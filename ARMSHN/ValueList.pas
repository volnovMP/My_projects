unit ValueList;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Registry, Buttons, Grids, ValEdit, Menus;

type
  TVlLstDlg = class(TForm)
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
  VlLstDlg : TVlLstDlg;

procedure UpdateKeyList(index : integer);   // обновить список датчиков объекта
procedure UpdateValueList(index : integer); // обновить информацию о состоянии датчиков объекта

implementation

{$R *.dfm}

uses
  TypeALL,
  Commons,
  TabloSHN,
  KanalArmSrvSHN,
  CMenu;
//========================================================================================
procedure TVlLstDlg.FormCreate(Sender: TObject);
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

//========================================================================================
procedure TVlLstDlg.FormActivate(Sender: TObject);
begin
//
end;

//========================================================================================
procedure UpdateKeyList(index : integer); // обновить список датчиков объекта
begin
  VlLstDlg.ValList.Strings.Clear;
  TabloMain.TimerView.Enabled := true;
  if not VlLstDlg.Visible then VlLstDlg.Show;
end;

//========================================================================================
procedure UpdateValueList(index : integer); //----обновить информацию о состоянии датчиков
var
  st,nep,rdy : boolean;
  i,j,k,o : smallint;
  s,MsgS : string;
begin
  if not VlLstDlg.Visible then exit;
  VlLstDlg.ValList.Strings.Clear;
  case ObjZv[index].TypeObj of
    2 :
    begin //---------------------------------------------------------------------- стрелка
      if ObjZv[ObjZv[index].BasOb].ObCI[9] > 0 then
      begin //---------------------------------------------------------- спаренная стрелка
        o := ObjZv[index].BasOb;
        with ObjZv[o] do
        begin
          VlLstDlg.Caption:= 'Свойства : стрелка '+ObjZv[index].Liter+' ('+Liter+')';
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep
          then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'непарафазность' else
          if not rdy
          then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'нет данных' else
          if st
          then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'есть' else
          VlLstDlg.ValList.Values['Плюсовой контроль'] := 'нет';
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);

          if nep then VlLstDlg.ValList.Values['Минусовой контроль']:= 'непарафазность'
          else
          if not rdy then VlLstDlg.ValList.Values['Минусовой контроль']:= 'нет данных'
          else
          if st then VlLstDlg.ValList.Values['Минусовой контроль'] := 'есть'
          else VlLstDlg.ValList.Values['Минусовой контроль'] := 'нет';

          if (dtP[1]>0) or (siP[1]>0) or (siP[2]>0)or (siP[6] > 0) or (siP[7] > 0) then
          begin
            if dtP[1] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
              VlLstDlg.ValList.Values['Потеря контроля'] := s;
            end else VlLstDlg.ValList.Values['Потеря контроля'] := 'не зафиксирована';

            if siP[1] > 0
            then VlLstDlg.ValList.Values['По + свободной'] := IntToStr(siP[1]);

            if siP[2] > 0
            then VlLstDlg.ValList.Values['По - свободной']:=IntToStr(siP[2]);

            if siP[6] > 0
            then VlLstDlg.ValList.Values['По + занятой'] := IntToStr(siP[6]);

            if siP[7] > 0
            then VlLstDlg.ValList.Values['По - занятой'] := IntToStr(siP[7]);
          end;

          if (dtP[2] > 0) or (siP[3] > 0) then
          begin
            if dtP[2] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
              VlLstDlg.ValList.Values['Непостановка'] := s;
            end else VlLstDlg.ValList.Values['Непостановка'] := 'не зафиксирована';

            if siP[3] > 0 then
            VlLstDlg.ValList.Values['Количество'] := IntToStr(siP[3]);
          end;

          if siP[4] > 0 then
          VlLstDlg.ValList.Values['Переводов в +'] := IntToStr(siP[4]);

          if siP[5] > 0 then
          VlLstDlg.ValList.Values['Переводов в -'] := IntToStr(siP[5]);

          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['Время перевода в +'] := s;
          end;

          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[4]);
            VlLstDlg.ValList.Values['Время перевода в -'] := s;
          end;

          st := GetFR4State(ObCI[1]-5);
          if st then VlLstDlg.ValList.Values['Управление'] := 'отключено'
          else VlLstDlg.ValList.Values['Управление'] := 'включено';

          st := GetFR4State(ObCI[1]-4);
          if st then VlLstDlg.ValList.Values['Макет'] := 'установлен'
          else VlLstDlg.ValList.Values['Макет'] := 'не установлен';


          if ObjZv[index].ObCB[6] then
          begin //-------------------------------------------------------- Дальняя стрелка
            st := GetFR4State(ObCI[1]-2);
            if st then VlLstDlg.ValList.Values['Движение'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение'] := 'разрешено';
          end else
          begin //-------------------------------------------------------- Ближняя стрелка
            st := GetFR4State(ObCI[1]-3);
            if st then VlLstDlg.ValList.Values['Движение'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение'] := 'разрешено';
          end;

          if ObjZv[index].ObCB[6] then
          begin //-------------------------------------------------------- Дальняя стрелка
            st := GetFR4State(ObCI[1]);
            if st then VlLstDlg.ValList.Values['Движение пш'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пш'] := 'разрешено';
          end else
          begin //-------------------------------------------------------- Ближняя стрелка
            st := GetFR4State(ObCI[1]-1);
            if st then VlLstDlg.ValList.Values['Движение пш'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пш'] := 'разрешено';
          end;
        end;
      end else
      begin //---------------------------------------------------------- одиночная стрелка
        o := ObjZv[index].BasOb;
        with ObjZv[o] do
        begin
          VlLstDlg.Caption := 'Свойства : стрелка '+ Liter;
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'непарафазность'
          else
          if not rdy then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'нет данных'
          else
          if st then VlLstDlg.ValList.Values['Плюсовой контроль'] := 'есть'
          else VlLstDlg.ValList.Values['Плюсовой контроль'] := 'нет';

          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Минусовой контроль']:= 'непарафазность'
          else
          if not rdy then VlLstDlg.ValList.Values['Минусовой контроль']:= 'нет данных'
          else
          if st then VlLstDlg.ValList.Values['Минусовой контроль'] := 'есть'
          else VlLstDlg.ValList.Values['Минусовой контроль'] := 'нет';

          if (dtP[1]>0) or (siP[1]>0) or (siP[2]>0) or (siP[6]>0) or (siP[7]>0) then
          begin
            if dtP[1] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
              VlLstDlg.ValList.Values['Потеря контроля'] := s;
            end else VlLstDlg.ValList.Values['Потеря контроля'] := 'не зафиксировано';

            if siP[1] > 0
            then VlLstDlg.ValList.Values['По + свободной']:=IntToStr(siP[1]);

            if siP[2] > 0
            then VlLstDlg.ValList.Values['По - свободной']:=IntToStr(siP[2]);

            if siP[6] > 0
            then VlLstDlg.ValList.Values['По + занятой'] := IntToStr(siP[6]);

            if siP[7] > 0
            then VlLstDlg.ValList.Values['По - занятой'] := IntToStr(siP[7]);
          end;

          if (dtP[2] > 0) or (siP[3] > 0) then
          begin
            if dtP[2] > 0 then
            begin
              DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
              VlLstDlg.ValList.Values['Непостановка'] := s;
            end
            else VlLstDlg.ValList.Values['Непостановка'] := 'не зафиксировано';

            if siP[3] > 0 then
            VlLstDlg.ValList.Values['Количество'] := IntToStr(siP[3]);
          end;

          if siP[4]>0 then VlLstDlg.ValList.Values['Переводов в +']:=IntToStr(siP[4]);
          if siP[5]>0 then VlLstDlg.ValList.Values['Переводов в -']:=IntToStr(siP[5]);
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['Время перевода в +'] := s;
          end;

          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[4]);
            VlLstDlg.ValList.Values['Время перевода в -'] := s;
          end;
          st := GetFR4State(ObCI[1]-5);
          if st then
          VlLstDlg.ValList.Values['Управление'] := 'отключено'
          else VlLstDlg.ValList.Values['Управление'] := 'включено';
          st := GetFR4State(ObCI[1]-4);

          if st then VlLstDlg.ValList.Values['Макет'] := 'установлен'
          else VlLstDlg.ValList.Values['Макет'] := 'не установлен';
          st := GetFR4State(ObCI[1]-3);

          if st then VlLstDlg.ValList.Values['Движение'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение'] := 'разрешено';
          st := GetFR4State(ObCI[1]-1);
          if st then VlLstDlg.ValList.Values['Движение пш'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение пш'] := 'разрешено';
        end;
      end;
    end;

    3 :
    begin //------------------------------------------------------------------------ СП,УП
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Liter;
        nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['Занятость'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['Занятость'] := 'нет данных' else
        if st then
        VlLstDlg.ValList.Values['Занятость'] := 'есть' else
        VlLstDlg.ValList.Values['Занятость'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);

        if nep then
        VlLstDlg.ValList.Values['Замыкание'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['Замыкание'] := 'нет данных' else
        if st then
        VlLstDlg.ValList.Values['Замыкание'] := 'есть' else
        VlLstDlg.ValList.Values['Замыкание'] := 'нет';

        nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['РИ'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['РИ'] := 'нет данных' else
        if st then
        VlLstDlg.ValList.Values['РИ'] := 'есть' else
        VlLstDlg.ValList.Values['РИ'] := 'нет';

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МСП'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МСП'] := 'нет данных' else
          if st then
          VlLstDlg.ValList.Values['МСП'] := 'есть' else
          VlLstDlg.ValList.Values['МСП'] := 'нет';

          if ObjZv[o].dtP[3] > 0 then
          begin
            DateTimeToString(s,'s,z',dtP[3]);
            VlLstDlg.ValList.Values['Тмсп'] := s;
          end;
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false;
          rdy := true;
          st := GetFR3(ObCI[6],nep,rdy);

          if nep then
          VlLstDlg.ValList.Values['МИ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МИ'] := 'нет данных' else
          if st then
          VlLstDlg.ValList.Values['МИ'] := 'есть' else
          VlLstDlg.ValList.Values['МИ'] := 'нет';
        end;

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['Занятие секции'] := s;
          end
          else VlLstDlg.ValList.Values['Занятие секции'] := 'не зафиксировано';

          if siP[1] > 0 then
          VlLstDlg.ValList.Values['Количество з.'] := IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['Освобождение секции'] := s;
          end
          else VlLstDlg.ValList.Values['Освобождение секции'] := 'не зафиксировано';

          if siP[2] > 0 then
          VlLstDlg.ValList.Values['Количество с.'] := IntToStr(siP[2]);
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then
        VlLstDlg.ValList.Values['Движение'] := 'закрыто'
        else VlLstDlg.ValList.Values['Движение'] := 'разрешено';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['Движение эл.т.'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение эл.т.'] := 'разрешено';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['Движение пост.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['Движение пер.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
          end;
        end;
      end;
    end;

    4 :
    begin //---------------------------------------------------------------------------- П
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : ' + Liter;
        if (ObCI[2] <> ObCI[9]) and (ObCI[2] > 0) and (ObCI[9] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость(ч)'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость(ч)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость(ч)'] := 'есть'
          else VlLstDlg.ValList.Values['Занятость(ч)'] := 'нет';

          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость(н)'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость(н)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость(н)'] := 'есть'
          else VlLstDlg.ValList.Values['Занятость(н)'] := 'нет';
        end else
        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость'] := 'есть'
          else VlLstDlg.ValList.Values['Занятость'] := 'нет';
        end else
        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость'] := 'есть'
          else VlLstDlg.ValList.Values['Занятость'] := 'нет';
        end;
        nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['ЧИ'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['ЧИ']:= 'нет данных' else
        if st then VlLstDlg.ValList.Values['ЧИ'] := 'есть'
        else VlLstDlg.ValList.Values['ЧИ'] := 'нет';

        nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['НИ'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['НИ'] := 'нет данных' else
        if st then VlLstDlg.ValList.Values['НИ'] := 'есть'
        else VlLstDlg.ValList.Values['НИ'] := 'нет';

        if (ObCI[5] <> ObCI[7]) and (ObCI[7] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ЧКМ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['ЧКМ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ЧКМ'] := 'есть'
          else VlLstDlg.ValList.Values['ЧКМ'] := 'нет';

          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['НКМ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['НКМ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['НКМ'] := 'есть'
          else VlLstDlg.ValList.Values['НКМ'] := 'нет';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['КМ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['КМ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КМ'] := 'есть'
          else VlLstDlg.ValList.Values['КМ'] := 'нет';
        end;
        if (ObCI[6] <> ObCI[8]) and (ObCI[6] > 0) and (ObCI[8] > 0) then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МИ(ч)'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МИ(ч)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МИ(ч)'] := 'есть'
          else VlLstDlg.ValList.Values['МИ(ч)'] := 'нет';

          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МИ(н)'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МИ(н)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МИ(н)'] := 'есть'
          else VlLstDlg.ValList.Values['МИ(н)'] := 'нет';
        end else
        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МИ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МИ'] := 'есть'
          else VlLstDlg.ValList.Values['МИ'] := 'нет';
        end else
        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МИ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МИ'] := 'есть'
          else VlLstDlg.ValList.Values['МИ'] := 'нет';
        end;

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['Занятие пути'] := s;
          end
          else VlLstDlg.ValList.Values['Занятие пути'] := 'не зафиксировано';

          if siP[1] > 0 then
          VlLstDlg.ValList.Values['Количество з.'] := IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['Освобождение пути'] := s;
          end
          else VlLstDlg.ValList.Values['Освобождение пути'] := 'не зафиксировано';
          if siP[2] > 0 then
          VlLstDlg.ValList.Values['Количество с.'] := IntToStr(siP[2]);
        end;

        if (dtP[3] > 0) or (siP[3] > 0) then
        begin
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[3]);
            VlLstDlg.ValList.Values['Отсутствие теста пути'] := s;
          end
          else VlLstDlg.ValList.Values['Отсутствие теста пути'] := 'не зафиксировано';
          if siP[3] > 0 then
          VlLstDlg.ValList.Values['Количество т.'] := IntToStr(siP[3]);
        end;

        st := GetFR4State(ObCI[2] div 8 * 8 + 2);
        if st then VlLstDlg.ValList.Values['Движение'] := 'закрыто'
        else VlLstDlg.ValList.Values['Движение'] := 'разрешено';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[2] div 8 * 8 + 3);
          if st then VlLstDlg.ValList.Values['Движение эл.т.'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение эл.т.'] := 'разрешено';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[2] div 8 * 8);
            if st then VlLstDlg.ValList.Values['Движение пост.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
            st := GetFR4State(ObCI[1] div 8 * 8 + 1);
            if st then VlLstDlg.ValList.Values['Движение пер.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
          end;
        end;
      end;
    end;

    5 :
    begin //--------------------------------------------------------------------- Светофор
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : ' + Liter;
        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Начало М'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Начало М'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Начало М'] := 'есть'
          else VlLstDlg.ValList.Values['Начало М'] := 'нет';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МВС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МВС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МВС'] := 'есть'
          else VlLstDlg.ValList.Values['МВС'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['МС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МС'] := 'есть'
          else VlLstDlg.ValList.Values['МС'] := 'нет';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Начало П'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Начало П'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Начало П'] := 'есть'
          else VlLstDlg.ValList.Values['Начало П'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ВС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['ВС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВС'] := 'есть'
          else VlLstDlg.ValList.Values['ВС'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['С'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['С'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['С'] := 'есть'
          else VlLstDlg.ValList.Values['С'] := 'нет';
        end;

        nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
        if nep then
        VlLstDlg.ValList.Values['о'] := 'непарафазность' else
        if not rdy then
        VlLstDlg.ValList.Values['о'] := 'нет данных' else
        if st then VlLstDlg.ValList.Values['о'] := 'неисправен'
        else VlLstDlg.ValList.Values['о'] := 'исправен';

        if (dtP[1] > 0) or (siP[1] > 0) then
        begin
          if dtP[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[1]);
            VlLstDlg.ValList.Values['Неисправность О'] := s;
          end else VlLstDlg.ValList.Values['Неисправность О'] := 'не зафиксировано';
          if siP[1]>0 then VlLstDlg.ValList.Values['Количество О']:=IntToStr(siP[1]);
        end;

        if (dtP[2] > 0) or (siP[2] > 0) then
        begin
          if dtP[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[2]);
            VlLstDlg.ValList.Values['Перекрытие'] := s;
          end else VlLstDlg.ValList.Values['Перекрытие'] := 'не зафиксировано';
          if siP[2]>0 then VlLstDlg.ValList.Values['Количество п.']:=IntToStr(siP[2]);
        end;

        if ObCI[9] > 0 then
        begin
          if ObCI[25] = 0 then
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['Со'] := 'непарафазность' else
            if not rdy then
            VlLstDlg.ValList.Values['Со'] := 'нет данных' else
            if st then VlLstDlg.ValList.Values['Со'] := 'неисправен'
            else VlLstDlg.ValList.Values['Со'] := 'исправен';
          end else
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['ЖСо'] := 'непарафазность' else
            if not rdy then
            VlLstDlg.ValList.Values['ЖСо'] := 'нет данных' else
            if st then VlLstDlg.ValList.Values['ЖСо'] := 'неисправен'
            else VlLstDlg.ValList.Values['ЖСо'] := 'исправен';
          end;
        end;

        if ObCI[25] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['зСо'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['зСо'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['зСо'] := 'неисправен'
          else VlLstDlg.ValList.Values['зСо'] := 'исправен';
        end;

        if ObCI[26] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[26],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ВНП'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['ВНП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВНП'] := 'неисправен'
          else VlLstDlg.ValList.Values['ВНП'] := 'исправен';
        end;

        if ObCI[30] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[30],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Кз'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Кз'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Кз'] := 'есть'
          else VlLstDlg.ValList.Values['Кз'] := 'нет';
        end;

        if ObCI[29] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[29],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['2зС/ЖБС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['2зС/ЖБС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['2зС/ЖБС'] := 'есть'
          else VlLstDlg.ValList.Values['2зС/ЖБС'] := 'нет';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Прикрытие'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Прикрытие'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Прикрытие'] := 'включено'
          else VlLstDlg.ValList.Values['Прикрытие'] := 'нет';
        end;

        if (dtP[3] > 0) or (siP[3] > 0) then
        begin
          if dtP[3] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZv[o].dtP[3]);
            VlLstDlg.ValList.Values['Переход на резерв'] := s;
          end
          else VlLstDlg.ValList.Values['Переход на резерв'] := 'не зафиксировано';

          if siP[3]>0 then VlLstDlg.ValList.Values['Количество Со']:=IntToStr(siP[3]);
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ЛС/ЖМС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['ЛС/ЖМС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ЛС/ЖМС'] := 'есть'
          else VlLstDlg.ValList.Values['ЛС/ЖМС'] := 'нет';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Авария шкафа'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Авария шкафа'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Авария шкафа'] := 'неисправен'
          else VlLstDlg.ValList.Values['Авария шкафа'] := 'исправен';
        end;

        if (dtP[4] > 0) or (siP[4] > 0) then
        begin
          if dtP[4] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[4]);
            VlLstDlg.ValList.Values['Последняя А'] := s;
          end else VlLstDlg.ValList.Values['Последняя А'] := 'не зафиксировано';

          if siP[4] > 0 then
          begin
            VlLstDlg.ValList.Values['Количество А'] := IntToStr(siP[4]);
          end else VlLstDlg.ValList.Values['Количество А'] := 'не зафиксировано';
        end;

        if (dtP[5] > 0) or (siP[5] > 0) then
        begin
          if dtP[5] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',dtP[5]);
            VlLstDlg.ValList.Values['Последняя Кз'] := s;
          end else VlLstDlg.ValList.Values['Последняя Кз'] := 'не зафиксировано';

          if siP[5] > 0 then
          begin
            VlLstDlg.ValList.Values['Количество Кз'] := IntToStr(siP[5]);
          end else VlLstDlg.ValList.Values['Количество Кз'] := 'не зафиксировано';
        end;

        if dtP[6] > 0 then
        begin
          DateTimeToString(s,'s,z',dtP[6]);
          VlLstDlg.ValList.Values['Замедление СР'] := s;
        end;

        if(ObCI[20]>0)or(ObCI[21]>0)or(ObCI[22]>0)or(ObCI[23]>0)or(ObCI[24]>0) then
        begin
          if bP[18] then VlLstDlg.ValList.Values['РМ'] := 'есть'
          else VlLstDlg.ValList.Values['РМ'] := 'нет';

          if ObCB[18] then
          begin
            if bP[21] then VlLstDlg.ValList.Values['МУС'] := 'есть'
            else VlLstDlg.ValList.Values['МУС'] := 'нет';
          end;
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['Движение'] := 'закрыто'
        else VlLstDlg.ValList.Values['Движение'] := 'разрешено';
      end;
    end;

    6 :
    begin //-------------------------------------------------------------------------- ПТО
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Оз'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Оз'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Оз'] := 'есть'
          else VlLstDlg.ValList.Values['Оз'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['оГ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['оГ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['оГ'] := 'есть'
          else VlLstDlg.ValList.Values['оГ'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['СоГ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['СоГ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['СоГ'] := 'есть'
          else VlLstDlg.ValList.Values['СоГ'] := 'нет';
        end;

        if bP[5] then VlLstDlg.ValList.Values['Неисправность'] := 'есть';
      end;
    end;

    7 :
    begin //--------------------------------------------------------------------------- ПС
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          if ObCI[3] > 0 then
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['ПС'] := 'непарафазность' else
            if not rdy then
            VlLstDlg.ValList.Values['ПС'] := 'нет данных' else
            if st then VlLstDlg.ValList.Values['ПС'] := 'есть'
            else VlLstDlg.ValList.Values['ПС'] := 'нет';

            nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['ПСо'] := 'непарафазность' else
            if not rdy
            then VlLstDlg.ValList.Values['ПСо'] := 'нет данных' else
            if st then VlLstDlg.ValList.Values['ПСо'] := 'есть'
            else VlLstDlg.ValList.Values['ПСо'] := 'нет';
          end else
          begin
            nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
            if nep then
            VlLstDlg.ValList.Values['КПС'] := 'непарафазность' else
            if not rdy then
            VlLstDlg.ValList.Values['КПС'] := 'нет данных' else
            if st then VlLstDlg.ValList.Values['КПС'] := 'есть'
            else VlLstDlg.ValList.Values['КПС'] := 'нет';
          end;
        end;
      end;
    end;

    8 :
    begin //-------------------------------------------------------------------------- УТС
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['УС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['УС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['УС'] := 'есть'
          else VlLstDlg.ValList.Values['УС'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['УУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['УУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['УУ'] := 'есть'
          else VlLstDlg.ValList.Values['УУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Блокировка'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Блокировка'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Блокировка'] := 'есть'
          else VlLstDlg.ValList.Values['Блокировка'] := 'нет';
        end;
      end;
    end;

    9 :
    begin //------------------------------------------------------------ Замыкание стрелок
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ДзС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДзС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДзС'] := 'есть'
          else VlLstDlg.ValList.Values['ДзС'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['оДзС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['оДзС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['оДзС'] := 'есть'
          else VlLstDlg.ValList.Values['оДзС'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Рз'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Рз'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Рз'] := 'есть'
          else VlLstDlg.ValList.Values['Рз'] := 'нет';
        end;
      end;
    end;

    10 :
    begin //------------------------------------------------------------ Закрытие переезда
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['УзП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['УзП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['УзП'] := 'есть' else
          VlLstDlg.ValList.Values['УзП'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['УзПД'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['УзПД'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['УзПД'] := 'есть'
          else VlLstDlg.ValList.Values['УзПД'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Закрытие'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Закрытие'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Закрытие'] := 'есть'
          else VlLstDlg.ValList.Values['Закрытие'] := 'нет';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Извещение'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Извещение'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Извещение'] := 'есть'
          else VlLstDlg.ValList.Values['Извещение'] := 'нет';
        end;
      end;
    end;

    11 :
    begin //----------------------------------------------- Контроль переезда станционного
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Авария'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Авария'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Авария'] := 'есть'
          else VlLstDlg.ValList.Values['Авария'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Неисправность'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Неисправность'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Неисправность'] := 'есть'
          else VlLstDlg.ValList.Values['Неисправность'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.закрытия'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.закрытия'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.закрытия'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.закрытия'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['зГ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['зГ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['зГ'] := 'есть'
          else VlLstDlg.ValList.Values['зГ'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.открытия'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.открытия'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.открытия'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.открытия'] := 'нет';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.извещения'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.извещения'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.извещения'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.извещения'] := 'нет';
        end;
      end;
    end;

    12 :
    begin //--------------------------------------------------------- Контроль переезда ДК
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['КНП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КНП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КНП'] := 'есть'
          else VlLstDlg.ValList.Values['КНП'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.закрытия'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.закрытия'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.закрытия'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.закрытия'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['зГ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['зГ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['зГ'] := 'есть'
          else VlLstDlg.ValList.Values['зГ'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.открытия'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.открытия'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.открытия'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.открытия'] := 'нет';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контр.извещения'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контр.извещения'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контр.извещения'] := 'есть'
          else VlLstDlg.ValList.Values['Контр.извещения'] := 'нет';
        end;
      end;
    end;

    13 :
    begin //---------------------------------------------------------- Оповещение монтеров
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['"Поезд"'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['"Поезд"'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['"Поезд"'] := 'есть'
          else VlLstDlg.ValList.Values['"Поезд"'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Включение'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Включение'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Включение'] := 'есть'
          else VlLstDlg.ValList.Values['Включение'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Окончание ВВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Окончание ВВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Окончание ВВ'] := 'есть'
          else VlLstDlg.ValList.Values['Окончание ВВ'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Начало ВВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Начало ВВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Начало ВВ'] := 'есть'
          else VlLstDlg.ValList.Values['Начало ВВ'] := 'нет';
        end;
      end;
    end;

    14 :
    begin //------------------------------------------------------------------------ УКСПС
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Блокировка'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Блокировка'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Блокировка'] := 'есть'
          else VlLstDlg.ValList.Values['Блокировка'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Датчик1'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик1'] := 'неисправен'
          else VlLstDlg.ValList.Values['Датчик1'] := 'исправен';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Датчик2'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик2'] := 'неисправен'
          else VlLstDlg.ValList.Values['Датчик2'] := 'исправен';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль линии1'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль линии1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль линии1'] := 'неисправна'
          else VlLstDlg.ValList.Values['Контроль линии1'] := 'исправна';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль линии2'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль линии2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль линии2'] := 'неисправна'
          else VlLstDlg.ValList.Values['Контроль линии2'] := 'исправна';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Команда на УКСПС'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Команда на УКСПС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Команда на УКСПС'] := 'активна'
          else VlLstDlg.ValList.Values['Команда на УКСПС'] := 'пассивна';
        end;

      end;
    end;

    15 :
    begin //--------------------------------------------------------------- Автоблокировка
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Liter;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Реде В'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Реде В'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Реде В'] := 'включено'
          else VlLstDlg.ValList.Values['Реде В'] := 'отключено';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Участок 1ИП/Ж'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Участок 1ИП/Ж'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Участок 1ИП/Ж'] := 'занят'
          else VlLstDlg.ValList.Values['Участок 1ИП/Ж'] := 'свободен';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Участок 2ИП/з'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Участок 2ИП/з'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Участок 2ИП/з'] := 'занят'
          else VlLstDlg.ValList.Values['Участок 2ИП/з'] := 'свободен';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Реде СН'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Реде СН'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Реде СН'] := 'отправление'
          else VlLstDlg.ValList.Values['Реде СН'] := 'прием';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Перегон'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Перегон'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Перегон'] := 'занят'
          else VlLstDlg.ValList.Values['Перегон'] := 'свободен';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Ключ-жезл'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Ключ-жезл'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Ключ-жезл'] := 'изъят'
          else VlLstDlg.ValList.Values['Ключ-жезл'] := 'вставлен';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Запрос СН'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Запрос СН'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Запрос СН'] := 'есть'
          else VlLstDlg.ValList.Values['Запрос СН'] := 'нет';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Л'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Л'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Л'] := 'включено'
          else VlLstDlg.ValList.Values['Л'] := 'отключено';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['3ИП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['3ИП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['3ИП'] := 'занят'
          else VlLstDlg.ValList.Values['3ИП'] := 'свободен';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Согласие СН'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Согласие СН'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Согласие СН'] := 'есть'
          else VlLstDlg.ValList.Values['Согласие СН'] := 'нет';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Д1'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Д1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Д1'] := 'включено'
          else VlLstDlg.ValList.Values['Д1'] := 'отключено';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Д2'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Д2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Д2'] := 'включено'
          else VlLstDlg.ValList.Values['Д2'] := 'отключено';
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['Закрытие перегона'] := 'закрыт'
        else VlLstDlg.ValList.Values['Закрытие перегона'] := 'открыт';

        if ObCB[8] or ObCB[9] then
        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['Движение эл.т.'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение эл.т.'] := 'разрешено';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['Движение пост.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пост.т.'] := 'разрешено';

            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['Движение пер.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
          end;
        end;
      end;
    end;

    16 :
    begin //----------------------------------------- Вспомогательная смена направления АБ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Исполнительная вспом.отправ.'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Исполнительная вспом.отправ.'] := 'нет данных'  else
          if st then VlLstDlg.ValList.Values['Исполнительная вспом.отправ.'] := 'включена'
          else VlLstDlg.ValList.Values['Исполнительная вспом.отправ.'] := 'отключена';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Исполнительная вспом. приема']:= 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Исполнительная вспом. приема'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Исполнительная вспом. приема']:= 'включена'
          else VlLstDlg.ValList.Values['Исполнительная вспом. приема'] := 'отключена';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Предварительная вспом. отправ.']:='непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Предварительная вспом. отправ.'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Предварительная вспом. отправ.']:='включена'
          else VlLstDlg.ValList.Values['Предварительная вспом. отправ.'] := 'отключена';
        end;


        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Предварительная вспом. приема']:= 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Предварительная вспом. приема'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Предварительная вспом. приема']:= 'включена'
          else VlLstDlg.ValList.Values['Предварительная вспом. приема'] := 'отключена';
        end;

      end;
    end;

    17 :
    begin //--------------------------------------------- Магистраль рабочего тока стрелок
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Включение'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Включение'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Включение'] := 'есть'
          else VlLstDlg.ValList.Values['Включение'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Рабочий ток'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Рабочий ток'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Рабочий ток'] := 'есть'
          else VlLstDlg.ValList.Values['Рабочий ток'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ЛАР'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ЛАР'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ЛАР'] := 'неисправен'
          else VlLstDlg.ValList.Values['ЛАР'] := 'исправен';
        end;
      end;
    end;

    18 :
    begin //---------------------------------------------------- Магистраль макета стрелок
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Перевод на макете'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Перевод на макете'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Перевод на макете'] := 'есть'
          else VlLstDlg.ValList.Values['Перевод на макете'] := 'нет';
        end
        else VlLstDlg.ValList.Values['Датчики объекта'] := 'отсутствуют'
      end;
    end;

    19 :
    begin //---------------------------------------------- Вспомогательный перевод стрелок
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ВК'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ВК'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВК'] := 'есть'
          else VlLstDlg.ValList.Values['ВК'] := 'нет';
        end;
      end;
    end;

    20 :
    begin //---------------------------------------------------------------- Макет стрелок
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['КМ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КМ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КМ'] := 'подключен'
          else VlLstDlg.ValList.Values['КМ'] := 'не подключен';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МПК'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['МПК'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МПК'] := 'есть'
          else VlLstDlg.ValList.Values['МПК'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ММК'] := 'непарафазность'
          else if not rdy then VlLstDlg.ValList.Values['ММК'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ММК'] := 'есть'
          else VlLstDlg.ValList.Values['ММК'] := 'нет';
        end;
      end;
    end;

    21 :
    begin //--------------------------------------------- Комплект выдержки времени отмены
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Liter;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Свободная'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Свободная'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Свободная'] := 'включена'
          else VlLstDlg.ValList.Values['Свободная'] := 'нет';
        end;

        if (ObCI[5] > 0) and (siP[1]>0)
        then VlLstDlg.ValList.Values['Выдержка ОС'] := IntToStr(siP[1]);

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маневровая'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Маневровая'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маневровая'] := 'включена'
          else VlLstDlg.ValList.Values['Маневровая'] := 'нет';
        end;

        if (ObCI[6] > 0) and (siP[2] > 0)
        then VlLstDlg.ValList.Values['Выдержка ОМ'] := IntToStr(siP[2]);


        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Поездная'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Поездная'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Поездная'] := 'включена'
          else VlLstDlg.ValList.Values['Поездная'] := 'нет';
        end;

        if (ObCI[7] > 0) and (siP[3] > 0)
        then VlLstDlg.ValList.Values['Выдержка ОП'] := IntToStr(siP[3]);

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['оВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['оВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['оВ'] := 'включена'
          else VlLstDlg.ValList.Values['оВ'] := 'нет';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['МВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['МВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МВ'] := 'включена'
          else VlLstDlg.ValList.Values['МВ'] := 'нет';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ПВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ПВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ПВ'] := 'включена'
          else VlLstDlg.ValList.Values['ПВ'] := 'нет';
        end;
      end;
    end;

    22 :
    begin //------------------------------------------- Комплект искусственного размыкания
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ГРИ1'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ГРИ1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ГРИ1'] := 'включена'
          else VlLstDlg.ValList.Values['ГРИ1'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ГРИ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ГРИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ГРИ'] := 'включена'
          else VlLstDlg.ValList.Values['ГРИ'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ИВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ИВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ИВ'] := 'включена'
          else VlLstDlg.ValList.Values['ИВ'] := 'нет';
        end;

        if (ObCI[5] > 0) and (siP[1] > 0)
        then VlLstDlg.ValList.Values['Выдержка ИР'] := IntToStr(siP[1]);
      end;
    end;

    23 :
    begin //----------------------------------------------------------------- Увязка с МЭЦ
      with ObjZv[o] do
      begin
        o := index;
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маневровый прием'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маневровый прием'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маневровый прием'] := 'есть'
          else VlLstDlg.ValList.Values['Маневровый прием'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маневровое отправление'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маневровое отправление'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маневровое отправление'] := 'есть'
          else VlLstDlg.ValList.Values['Маневровое отправление'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Гашение сигналов'] := 'есть'
          else VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет';
        end;
        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['Закрытие перегона'] := 'закрыт'
        else VlLstDlg.ValList.Values['Закрытие перегона'] := 'открыт';
      end;
    end;

    24 :
    begin //------------------------------------------------------------------ Увязка с ЭЦ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Запрос ПО'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Запрос ПО'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Запрос ПО'] := 'есть'
          else VlLstDlg.ValList.Values['Запрос ПО'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Выдан запрос ПО'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Выдан запрос ПО']:= 'нет данных' else
          if st then VlLstDlg.ValList.Values['Выдан запрос ПО'] := 'есть'
          else VlLstDlg.ValList.Values['Выдан запрос ПО'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Гашение сигналов']:='нет данных' else
          if st then VlLstDlg.ValList.Values['Гашение сигналов'] := 'есть'
          else VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ИП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ИП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ИП'] := 'занят'
          else VlLstDlg.ValList.Values['ИП'] := 'свободен';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Получен запрос ПО'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Получен запрос ПО'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Получен запрос ПО'] := 'есть'
          else VlLstDlg.ValList.Values['Получен запрос ПО'] := 'нет';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['П'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['П'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['П'] := 'занят'
          else VlLstDlg.ValList.Values['П'] := 'свободен';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маршрут по приему'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маршрут по приему'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маршрут по приему'] := 'замкнут'
          else VlLstDlg.ValList.Values['Маршрут по приему'] := 'нет';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маневры по приему'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маневры по приему'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маневры по приему'] := 'есть'
          else VlLstDlg.ValList.Values['Маневры по приему'] := 'нет';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маршрут по отправлению'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маршрут по отправлению'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маршрут по отправлению'] := 'замкнут'
          else VlLstDlg.ValList.Values['Маршрут по отправлению'] := 'нет';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Маневры по отправлению'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Маневры по отправлению'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Маневры по отправлению'] := 'есть'
          else VlLstDlg.ValList.Values['Маневры по отправлению'] := 'нет';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['МС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['МС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МС'] := 'есть'
          else VlLstDlg.ValList.Values['МС'] := 'нет';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ФС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ФС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ФС'] := 'есть'
          else VlLstDlg.ValList.Values['ФС'] := 'нет';
        end;
        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['Закрытие перегона'] := 'закрыт'
        else VlLstDlg.ValList.Values['Закрытие перегона'] := 'открыт';
      end;
    end;

    25 :
    begin //----------------------------------------------------------- Маневровая колонка
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Разрешение маневров'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Разрешение маневров'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Разрешение маневров'] := 'есть'
          else VlLstDlg.ValList.Values['Разрешение маневров'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Отмена маневров'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Отмена маневров'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Отмена маневров'] := 'есть'
          else VlLstDlg.ValList.Values['Отмена маневров'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['МИ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['МИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['МИ'] := 'есть'
          else VlLstDlg.ValList.Values['МИ'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Д/оИ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Д/оИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Д/оИ'] := 'есть'
          else VlLstDlg.ValList.Values['Д/оИ'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['РВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РВ'] := 'есть' else
          VlLstDlg.ValList.Values['РВ'] := 'нет';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Гашение сигналов'] := 'есть'
          else VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['РМК'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РМК'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РМК'] := 'есть'
          else VlLstDlg.ValList.Values['РМК'] := 'нет';
        end;
      end;
    end;

    26 :
    begin //----------------------------------------------------------------- Увязка с РПБ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : ' + Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость по отправлению'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость по отправлению'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость по отправлению'] := 'занят'
          else VlLstDlg.ValList.Values['Занятость по отправлению'] := 'свободен';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Прибытие поезда'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Прибытие поезда'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Прибытие поезда'] := 'есть'
          else VlLstDlg.ValList.Values['Прибытие поезда'] := 'нет';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Дача согласия'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Дача согласия'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Дача согласия'] := 'есть'
          else VlLstDlg.ValList.Values['Дача согласия'] := 'нет';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость по приему'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость по приему'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость по приему'] := 'занят'
          else VlLstDlg.ValList.Values['Занятость по приему'] := 'свободен';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Получено согласие'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Получено согласие'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Получено согласие'] := 'есть'
          else VlLstDlg.ValList.Values['Получено согласие'] := 'нет';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Ключ-жезл'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Ключ-жезл'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Ключ-жезл'] := 'изъят'
          else VlLstDlg.ValList.Values['Ключ-жезл'] := 'вставлен';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Повторитель'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Повторитель'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Повторитель'] := 'неисправен'
          else VlLstDlg.ValList.Values['Повторитель'] := 'исправен';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ИП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ИП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ИП'] := 'занят'
          else VlLstDlg.ValList.Values['ИП'] := 'свободен';
        end;

        st := GetFR4State(ObCI[1]*8+2);
        if st then VlLstDlg.ValList.Values['Закрытие перегона'] := 'закрыт'
        else VlLstDlg.ValList.Values['Закрытие перегона'] := 'открыт';
        if ObCB[8] or ObCB[9] then

        begin
          st := GetFR4State(ObCI[1]*8+3);
          if st then VlLstDlg.ValList.Values['Движение эл.т.'] := 'закрыто'
          else VlLstDlg.ValList.Values['Движение эл.т.'] := 'разрешено';

          if ObCB[8] and ObCB[9] then
          begin
            st := GetFR4State(ObCI[1]*8);
            if st then VlLstDlg.ValList.Values['Движение пост.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пост.т.'] := 'разрешено';

            st := GetFR4State(ObCI[1]*8+1);
            if st then VlLstDlg.ValList.Values['Движение пер.т.'] := 'закрыто'
            else VlLstDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
          end;
        end;
      end;
    end;

    30 :
    begin //------------------- Согласие поездного отправления (фиктивный поездной сигнал)
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ ObjZv[index].Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Гашение сигналов'] := 'есть'
          else VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Замыкание маршрута'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Замыкание маршрута'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Замыкание маршрута'] := 'есть'
          else VlLstDlg.ValList.Values['Замыкание маршрута'] := 'нет';
        end;
      end;
    end;

    31 : begin //--------------------------------------------------- повторитель светофора
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Включение повторителя'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Включение повторителя'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Включение повторителя'] := 'есть'
          else VlLstDlg.ValList.Values['Включение повторителя'] := 'нет';
        end;
      end;
    end;

    32 :
    begin //-------------------------------------------------------------- Увязка с горкой
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Зеленый огонь'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Зеленый огонь'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Зеленый огонь'] := 'включен'
          else VlLstDlg.ValList.Values['Зеленый огонь'] := 'отключен';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Желтый огонь'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Желтый огонь'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Желтый огонь'] := 'включен'
          else VlLstDlg.ValList.Values['Желтый огонь'] := 'отключен';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Белый огонь'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Белый огонь'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Белый огонь'] := 'включен'
          else VlLstDlg.ValList.Values['Белый огонь'] := 'отключен';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Указатель НАЗАД'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Указатель НАЗАД'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Указатель НАЗАД'] := 'включен'
          else VlLstDlg.ValList.Values['Указатель НАЗАД'] := 'отключен';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['СОО'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['СОО'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['СОО'] := 'есть'
          else VlLstDlg.ValList.Values['СОО'] := 'нет';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Отказ от осаживания'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Отказ от осаживания'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Отказ от осаживания'] := 'есть'
          else VlLstDlg.ValList.Values['Отказ от осаживания'] := 'нет';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Гашение сигналов'] := 'есть'
          else VlLstDlg.ValList.Values['Гашение сигналов'] := 'нет';
        end;
        
        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Согласие надвига'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Согласие надвига'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Согласие надвига'] := 'есть'
          else VlLstDlg.ValList.Values['Согласие надвига'] := 'нет';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Согласие маневров'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Согласие маневров'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Согласие маневров'] := 'есть'
          else VlLstDlg.ValList.Values['Согласие маневров'] := 'нет';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Восприятие горки'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Восприятие горки'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Восприятие горки'] := 'есть'
          else VlLstDlg.ValList.Values['Восприятие горки'] := 'нет';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Занятость горки'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Занятость горки'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Занятость горки'] := 'занят'
          else VlLstDlg.ValList.Values['Занятость горки'] := 'свободен';
        end;
      end;
    end;

    33 :
    begin //----------------------------------------------------------------------- Датчик
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Датчик ' + Liter] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик ' + Liter] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик ' + Liter] := 'включен'
          else VlLstDlg.ValList.Values['Датчик ' + Liter] := 'отключен';
        end;
      end;
    end;

    34 :
    begin //---------------------------------------------------------------------- Питание
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль 1 фидера'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль 1 фидера'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль 1 фидера'] := 'неисправен'
          else VlLstDlg.ValList.Values['Контроль 1 фидера'] := 'есть';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль 2 фидера'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль 2 фидера'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль 2 фидера'] := 'неисправен'
          else VlLstDlg.ValList.Values['Контроль 2 фидера'] := 'есть';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль ДГА'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Контроль ДГА'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль ДГА'] := 'есть'
          else VlLstDlg.ValList.Values['Контроль ДГА'] := 'нет';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Включение 1 фидера'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Включение 1 фидера'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Включение 1 фидера'] := 'нет'

          else VlLstDlg.ValList.Values['Включение 1 фидера'] := 'есть';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Включение 2 фидера'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Включение 2 фидера'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Включение 2 фидера'] := 'нет'
          else VlLstDlg.ValList.Values['Включение 2 фидера'] := 'есть';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Предохранитель'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Предохранитель']:='нет данных' else
          if st then VlLstDlg.ValList.Values['Предохранитель'] := 'неисправен'
          else VlLstDlg.ValList.Values['Предохранитель'] := 'исправен';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль предохранителя']:='непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль предохранителя'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль предохранителя'] := 'неисправен'
          else VlLstDlg.ValList.Values['Контроль предохранителя'] := 'исправен';
        end;

        if ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[8],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Сигнализатор заземления'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Сигнализатор заземления'] := 'нет данных' else
          if st then
          VlLstDlg.ValList.Values['Сигнализатор заземления'] := 'понижение изоляции'
          else  VlLstDlg.ValList.Values['Сигнализатор заземления'] := 'норма';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Кодирование'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Кодирование'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Кодирование'] := 'Авария'
          else VlLstDlg.ValList.Values['Кодирование'] := 'исправно';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ЩВП1'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ЩВП1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ЩВП1'] := 'отключено'
          else VlLstDlg.ValList.Values['ЩВП1'] := 'включено';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ЩВП2'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ЩВП2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ЩВП2'] := 'отключено'
          else VlLstDlg.ValList.Values['ЩВП2'] := 'включено';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Заряд батареи'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Заряд батареи'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Заряд батареи'] := 'ненорма'
          else VlLstDlg.ValList.Values['Заряд батареи'] := 'норма';
        end;

        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Напряжение батареи'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Напряжение батареи'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Напряжение батареи'] := 'ненорма'
          else VlLstDlg.ValList.Values['Напряжение батареи'] := 'норма';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Снижение напряжения'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Снижение напряжения'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Снижение напряжения'] := 'включено'
          else VlLstDlg.ValList.Values['Снижение напряжения'] := 'отключено';
        end;

        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Питание САУТ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Питание САУТ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Питание САУТ'] := 'ненорма'
          else VlLstDlg.ValList.Values['Питание САУТ'] := 'норма';
        end;

        if ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[16],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Автомат светофоров'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Автомат светофоров'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Автомат светофоров'] := 'включен'
          else VlLstDlg.ValList.Values['Автомат светофоров'] := 'отключен';
        end;

        if ObCI[17] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[17],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Контроль топлива'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Контроль топлива'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Контроль топлива'] := 'ненорма'
          else VlLstDlg.ValList.Values['Контроль топлива'] := 'норма';
        end;

        if ObCI[18] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[18],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['ВМГ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['ВМГ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВМГ'] := 'ненорма'
          else VlLstDlg.ValList.Values['ВМГ'] := 'норма';
        end;

        if ObCI[19] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[19],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Чередование фаз 1ф'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Чередование фаз 1ф'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Чередование фаз 1ф'] := 'ненорма'
          else VlLstDlg.ValList.Values['Чередование фаз 1ф'] := 'норма';
        end;

        if ObCI[20] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[20],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Чередование фаз 2ф'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Чередование фаз 2ф'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Чередование фаз 2ф'] := 'ненорма'
          else VlLstDlg.ValList.Values['Чередование фаз 2ф'] := 'норма';
        end;

        if ObCI[21] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[21],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Напряжение 1ф'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Напряжение 1ф'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Напряжение 1ф'] := 'ненорма'
          else VlLstDlg.ValList.Values['Напряжение 1ф'] := 'норма';
        end;

        if ObCI[22] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[22],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Напряжение 2ф'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Напряжение 2ф'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Напряжение 2ф'] := 'ненорма'
          else VlLstDlg.ValList.Values['Напряжение 2ф'] := 'норма';
        end;

        if ObCI[23] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[23],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Ловушка ВФ'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Ловушка ВФ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Ловушка ВФ'] := 'сработала'
          else VlLstDlg.ValList.Values['Ловушка ВФ'] := 'норма';
        end;

        if ObCI[24] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[24],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Фильтр кодирования'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Фильтр кодирования'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Фильтр кодирования'] := 'ненорма'
          else VlLstDlg.ValList.Values['Фильтр кодирования'] := 'норма';
        end;

        if ObCI[25] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Питание рельсовых цепей'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Питание рельсовых цепей'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Питание рельсовых цепей'] := 'ненорма'
          else VlLstDlg.ValList.Values['Питание рельсовых цепей'] := 'норма';
        end;

        if ObCI[26] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[26],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Авария табло'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Авария табло'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Авария табло'] := 'Авария'
          else VlLstDlg.ValList.Values['Авария табло'] := 'нет аварии';
        end;

        if ObCI[27] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[25],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Мигание табло'] := 'непарафазность' else
          if not rdy then
          VlLstDlg.ValList.Values['Мигание табло'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Мигание табло'] := 'ненорма'
          else VlLstDlg.ValList.Values['Мигание табло'] := 'норма';
        end;

      end;
    end;

    36 :
    begin //------------------------------------------------------------------------- Ключ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[11] > 0 then  //---------------------------------- Если есть первый датчик
        begin
          MsgS := MsgList[ObCI[4]];
          MsgS := StringReplace(MsgS,'?','',[rfReplaceAll]);
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values[MsgS] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := 'нет данных' else
          if (not st and ObCB[1]) or (not ObCB[1] and st) then
          VlLstDlg.ValList.Values[MsgS] := 'включено'
          else VlLstDlg.ValList.Values[MsgS] := 'отключено';
        end;
        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Датчик2'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик2'] := 'включено'
          else VlLstDlg.ValList.Values['Датчик2'] := 'отключено';
        end;
        if ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[13],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Датчик3'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик3'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик3'] := 'включено'
          else VlLstDlg.ValList.Values['Датчик3'] := 'отключено';
        end;
        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then
          VlLstDlg.ValList.Values['Датчик4'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Датчик4'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Датчик4'] := 'включено'
          else VlLstDlg.ValList.Values['Датчик4'] := 'отключено';
        end;
        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          MsgS := MsgList[ObCI[22]];
          if nep then
          VlLstDlg.ValList.Values[MsgS] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := 'нет данных' else
          if st then VlLstDlg.ValList.Values[MsgS] := 'включено'
          else VlLstDlg.ValList.Values[MsgS] := 'отключено';
        end;
      end;
    end;

    37 :
    begin //------------------------------------------------------------------------- ТУМС
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Комплект'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Комплект'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Комплект'] := 'резервный'
          else VlLstDlg.ValList.Values['Комплект'] := 'основной';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Осн.комплект'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Осн.комплект'] := 'нет данных' else
          if not st then VlLstDlg.ValList.Values['Осн.комплект'] := 'работает'
          else VlLstDlg.ValList.Values['Осн.комплект'] := 'остановлен';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Рез.комплект'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Рез.комплект'] := 'нет данных' else
          if not st then VlLstDlg.ValList.Values['Рез.комплект'] := 'работает'
          else VlLstDlg.ValList.Values['Рез.комплект'] := 'остановлен';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Питание'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Питание'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Питание'] := 'отсутствует'
          else VlLstDlg.ValList.Values['Питание'] := 'норма';
        end;

      if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['КП1'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КП1'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КП1'] := 'отсутствует'
          else VlLstDlg.ValList.Values['КП1'] := 'норма';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['КП2'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КП2'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КП2'] := 'отсутствует'
          else VlLstDlg.ValList.Values['КП2'] := 'норма';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Канал'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Канал'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Канал'] := 'отсутствует'
          else VlLstDlg.ValList.Values['Канал'] := 'норма';
        end;

        if ObCI[8] > 0 then
        begin
          st := FR3[ObCI[8]] = 0;
          if st then VlLstDlg.ValList.Values['Маршрут'] := 'устанавливается'
          else VlLstDlg.ValList.Values['Маршрут'] := 'нет';
        end;

        if ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['РУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РУ'] := 'есть'
          else VlLstDlg.ValList.Values['РУ'] := 'нет';
        end;

        if ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['оУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['оУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['оУ'] := 'есть'
          else VlLstDlg.ValList.Values['оУ'] := 'нет';
        end;

        if ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['оТУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['оТУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['оТУ'] := 'есть'
          else VlLstDlg.ValList.Values['оТУ'] := 'нет';
        end;

        if ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['РоТУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РоТУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РоТУ'] := 'есть'
          else VlLstDlg.ValList.Values['РоТУ'] := 'нет';
        end;

        if ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Перезапуск'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Перезапуск'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Перезапуск'] := 'есть'
          else VlLstDlg.ValList.Values['Перезапуск'] := 'нет';
        end;

        if ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['В/Н'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['В/Н'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['В/Н'] := 'левый'
          else VlLstDlg.ValList.Values['В/Н'] := 'правый';
        end;

      end;
    end;

    38 :
    begin //-------------------------------------------------------------- Маршрут надвига
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ГВ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ГВ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ГВ'] := 'есть'
          else VlLstDlg.ValList.Values['ГВ'] := 'нет';
        end;
      end;
    end;

    39 :
    begin //------------------------------------------------------------------ Контроль РУ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['РУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РУ'] := 'есть'
          else VlLstDlg.ValList.Values['РУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ОУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ОУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ОУ'] := 'есть'
          else VlLstDlg.ValList.Values['ОУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['СУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['СУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['СУ'] := 'есть'
          else VlLstDlg.ValList.Values['СУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ВСУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ВСУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВСУ'] := 'есть'
          else VlLstDlg.ValList.Values['ВСУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДУ'] := 'есть'
          else VlLstDlg.ValList.Values['ДУ'] := 'нет';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['КРУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КРУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КРУ'] := 'норма'
          else VlLstDlg.ValList.Values['КРУ'] := 'ненорма';
        end;
      end;
    end;

    43 :
    begin //-------------------------------------------------------------------------- ОПИ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ОПИ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ОПИ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ОПИ'] := 'есть'
          else VlLstDlg.ValList.Values['ОПИ'] := 'нет';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['РПО'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РПО'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РПО'] := 'есть'
          else VlLstDlg.ValList.Values['РПО'] := 'нет';
        end;
      end;
    end;

    45 :
    begin //-------------------------------------------------------------------------- КНМ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['КНМ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КНМ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КНМ'] := 'включено'
          else VlLstDlg.ValList.Values['КНМ'] := 'отключено';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ВС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ВС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ВС'] := 'есть'
          else VlLstDlg.ValList.Values['ВС'] := 'нет';
        end;
      end;
    end;

    47 :
    begin //----------------------------------------------------------------- Автодействие
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['АС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['АС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['АС'] := 'включено'
          else VlLstDlg.ValList.Values['АС'] := 'отключено';
        end;
      end;
    end;

    49 :
    begin //---------------------------------------------------------------- Увязка с АБТЦ
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ГПо'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ГПо'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ГПо'] := 'неисправно'
          else VlLstDlg.ValList.Values['ГПо'] := 'исправно';
        end;

        if ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['озП'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['озП'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['озП'] := 'перегон закнут'
          else VlLstDlg.ValList.Values['озП'] := 'перегон разомкнут';
        end;

        if ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['УУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['УУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['УУ'] := 'удаление замкнуто'
          else VlLstDlg.ValList.Values['УУ'] := 'удаление разомкнуто';
        end;

        if ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['Кодирование'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['Кодирование'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['Кодирование'] := 'неисправно'
          else VlLstDlg.ValList.Values['Кодирование'] := 'исправно';
        end;

        if ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['КЛ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['КЛ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['КЛ'] := 'неисправно'
          else VlLstDlg.ValList.Values['КЛ'] := 'исправно';
        end;

        if ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ПКЛ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ПКЛ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ПКЛ'] := 'неисправно'
          else VlLstDlg.ValList.Values['ПКЛ'] := 'исправно';
        end;

        if ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['РКЛ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['РКЛ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['РКЛ'] := 'неисправно'
          else VlLstDlg.ValList.Values['РКЛ'] := 'исправно';
        end;
      end;
    end;

    50 :
    begin //---------------------------------------------------- Контроль перегонных точек
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObjZv[o].ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(1)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(1)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(1)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(1)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(1)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(1)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(1)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(1)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(2)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(2)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(2)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(2)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(2)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(2)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(2)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(2)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(3)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(3)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(3)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(3)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(3)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(3)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(3)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(3)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(4)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(4)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(4)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(4)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[8],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(4)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(4)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(4)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(4)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(5)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(5)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(5)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(5)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(5)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(5)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(5)']:='занят'
          else VlLstDlg.ValList.Values['отправление(5)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(6)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(6)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(6)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(6)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(6)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(6)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(6)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(6)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(7)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(7)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(7)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(7)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(7)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(7)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(7)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(7)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['прием(8)'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['прием(8)'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['прием(8)'] := 'занят'
          else VlLstDlg.ValList.Values['прием(8)'] := 'свободен';
        end;

        if ObjZv[o].ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[16],nep,rdy);
          if nep then VlLstDlg.ValList.Values['отправление(8)']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['отправление(8)']:='нет данных' else
          if st then VlLstDlg.ValList.Values['отправление(8)'] := 'занят'
          else VlLstDlg.ValList.Values['отправление(8)'] := 'свободен';
        end;
      end;
    end;

    51 :
    begin //------------------------------------------------------------- сборка датчиков
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        for j := 1 to 10 do
        begin
          if ObCI[j] >0 then  MsgS := MsgList[ObCI[j+10]];
          nep := false; rdy := true; st := GetFR3(ObCI[j],nep,rdy);
          if nep then VlLstDlg.ValList.Values[MsgS] := 'непарафазность'  else
          if not rdy then VlLstDlg.ValList.Values[MsgS] := 'нет данных'  else
          if (not ObCb[j] and st) or ( not st and ObCb[j])
          then VlLstDlg.ValList.Values[MsgS] := 'включен'
          else VlLstDlg.ValList.Values[MsgS] := 'отключен';
        end;
      end;
    end;

    60 :
    begin //---------------------------------------------------------- Релейный дешифратор
      o := index;
      with ObjZv[o] do
      begin
        VlLstDlg.Caption := 'Свойства : '+ Title;
        if ObjZv[o].ObCI[1] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[1],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДПУ'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДПУ'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДПУ'] := 'включен'
          else VlLstDlg.ValList.Values['ДПУ'] := 'отключен';
        end;

        if ObjZv[o].ObCI[2] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[2],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДМУ']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДМУ']:='нет данных' else
          if st then VlLstDlg.ValList.Values['ДМУ'] := 'включен'
          else VlLstDlg.ValList.Values['ДМУ'] := 'отключен';
        end;

        if ObjZv[o].ObCI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[3],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДПС'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДПС'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДПС'] := 'включен'
          else VlLstDlg.ValList.Values['ДПС'] := 'отключен';
        end;

        if ObjZv[o].ObCI[4] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[4],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДМС']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДМС']:='нет данных' else
          if st then VlLstDlg.ValList.Values['ДМС'] := 'включен'
          else VlLstDlg.ValList.Values['ДМС'] := 'отключен';
        end;

        if ObjZv[o].ObCI[5] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[5],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДНСН'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДНСН'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДНСН'] := 'включен'
          else VlLstDlg.ValList.Values['ДНСН'] := 'отключен';
        end;

        if ObjZv[o].ObCI[6] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[6],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДЧСН']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДЧСН']:='нет данных' else
          if st then VlLstDlg.ValList.Values['ДЧСН'] := 'включен'
          else VlLstDlg.ValList.Values['ДЧСН'] := 'отключен';
        end;

        if ObjZv[o].ObCI[7] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[7],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДИР'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДИР'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['ДИР'] := 'включен'
          else VlLstDlg.ValList.Values['ДИР'] := 'отключен';
        end;

        if ObjZv[o].ObCI[8] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[8],nep,rdy);
          if nep then VlLstDlg.ValList.Values['ДОТ']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['ДОТ']:='нет данных' else
          if st then VlLstDlg.ValList.Values['ДОТ'] := 'включен'
          else VlLstDlg.ValList.Values['ДОТ'] := 'отключен';
        end;

        if ObjZv[o].ObCI[9] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[9],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О19'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О19'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['О19'] := 'включен'
          else VlLstDlg.ValList.Values['О19'] := 'отключен';
        end;

        if ObjZv[o].ObCI[10] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[10],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О210']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О210']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О210']:='включен'
          else VlLstDlg.ValList.Values['О210'] := 'отключен';
        end;

        if ObjZv[o].ObCI[11] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[11],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О311']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О311'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['О311'] := 'включен'
          else VlLstDlg.ValList.Values['О311'] := 'отключен';
        end;

        if ObjZv[o].ObCI[12] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[12],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О412']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О412']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О412'] := 'включен'
          else VlLstDlg.ValList.Values['О412'] := 'отключен';
        end;

        if ObjZv[o].ObCI[13] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[13],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О513'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О513'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['О513'] := 'включен'
          else VlLstDlg.ValList.Values['О513'] := 'отключен';
        end;

        if ObjZv[o].ObCI[14] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[14],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О614']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О614']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О614'] := 'включен'
          else VlLstDlg.ValList.Values['О614'] := 'отключен';
        end;

        if ObjZv[o].ObCI[15] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[15],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О715'] := 'непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О715'] := 'нет данных' else
          if st then VlLstDlg.ValList.Values['О715'] := 'включен'
          else VlLstDlg.ValList.Values['О715'] := 'отключен';
        end;

        if ObjZv[o].ObCI[16] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[16],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О816']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О816']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О816'] := 'включен'
          else VlLstDlg.ValList.Values['О816'] := 'отключен';
        end;

        if ObjZv[o].ObCI[17] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[17],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О1718']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О1718']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О1718'] := 'включен'
          else VlLstDlg.ValList.Values['О1718'] := 'отключен';
        end;

        if ObjZv[o].ObCI[18] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[18],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О1920']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О1920']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О1920'] := 'включен'
          else VlLstDlg.ValList.Values['О1920'] := 'отключен';
        end;

        if ObjZv[o].ObCI[19] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[19],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О2122']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О2122']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О2122'] := 'включен'
          else VlLstDlg.ValList.Values['О2122'] := 'отключен';
        end;

        if ObjZv[o].ObCI[20] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[20],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О2324']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О2324']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О2324'] := 'включен'
          else VlLstDlg.ValList.Values['О2324'] := 'отключен';
        end;

        if ObjZv[o].ObCI[21] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[21],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О2526']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О2526']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О2526'] := 'включен'
          else VlLstDlg.ValList.Values['О2526'] := 'отключен';
        end;

        if ObjZv[o].ObCI[22] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[22],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О2728']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О2728']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О2728'] := 'включен'
          else VlLstDlg.ValList.Values['О2728'] := 'отключен';
        end;

        if ObjZv[o].ObCI[23] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[23],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О2930']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О2930']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О2930'] := 'включен'
          else VlLstDlg.ValList.Values['О2930'] := 'отключен';
        end;

        if ObjZv[o].ObCI[24] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZv[o].ObCI[24],nep,rdy);
          if nep then VlLstDlg.ValList.Values['О3132']:='непарафазность' else
          if not rdy then VlLstDlg.ValList.Values['О3132']:='нет данных' else
          if st then VlLstDlg.ValList.Values['О3132'] := 'включен'
          else VlLstDlg.ValList.Values['О3132'] := 'отключен';
        end;
      end;
    end;
    else VlLstDlg.Caption := 'Свойства : ?';
  end;
  j := 0; k := 0;
  for i:= 0 to VlLstDlg.ValList.RowCount-1  do
  begin
    if Length(VlLstDlg.ValList.Keys[i]) > j
    then j := Length(VlLstDlg.ValList.Keys[i]);
    if Length(VlLstDlg.ValList.Cells[1,i]) > k
    then  k := Length(VlLstDlg.ValList.Cells[1,i])
  end;
  VlLstDlg.ValList.ColWidths[0] := (j+1)*8;
  VlLstDlg.ValList.ColWidths[1] := (k+1)*8;
  VlLstDlg.Width := (j+k+2)*8;
end;
//========================================================================================
//------------------------------------------------------------ Сброс статистики по объекту
procedure TVlLstDlg.pmResetStatClick(Sender: TObject);
  var o,i : integer;
begin
  case ObjZv[ID_ViewObj].TypeObj of
    2 :
    begin //---------------------------------------------------------------------- стрелка
      o := ObjZv[ID_ViewObj].BasOb;
      ObjZv[o].T[1].Activ := false; ObjZv[o].T[2].Activ := false;
      for i := 1 to High(ObjZv[1].dtP) do ObjZv[o].dtP[i] := 0;
      for i := 1 to High(ObjZv[1].siP) do ObjZv[o].siP[i] := 0;
    end;
    else
      for i := 1 to High(ObjZv[1].dtP) do ObjZv[ID_ViewObj].dtP[i] := 0;
      for i := 1 to High(ObjZv[1].siP) do ObjZv[ID_ViewObj].siP[i] := 0;
      for i := 1 to High(ObjZv[1].sbP) do ObjZv[ID_ViewObj].sbP[i] := false;
  end;
end;

end.

