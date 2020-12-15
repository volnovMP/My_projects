unit ValueList;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Registry, Buttons, Grids, ValEdit;

type
  TValueListDlg = class(TForm)
    ValList: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ValueListDlg : TValueListDlg;
  ID_ViewObj   : SmallInt;

const
  KeyRegValListForm : string = '\Software\SHNRPCTUMS\ValListForm';
  
procedure UpdateKeyList(index : integer);   // обновить список датчиков объекта
procedure UpdateValueList(index : integer); // обновить информацию о состоянии датчиков объекта

implementation

{$R *.dfm}

uses
  TypeALL,
  PackArmSrv,
  CMenu;

var
  reg : TRegistry;

procedure TValueListDlg.FormCreate(Sender: TObject);
begin
  reg := TRegistry.Create;
  if Reg.OpenKey(KeyRegValListForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    reg.CloseKey;
  end;
  reg.Free;
end;

procedure TValueListDlg.FormActivate(Sender: TObject);
begin
//
end;

procedure UpdateKeyList(index : integer); // обновить список датчиков объекта
begin
end;

procedure UpdateValueList(index : integer); // обновить информацию о состоянии датчиков объекта
  var st,nep,rdy : boolean; o : smallint;
begin
  case ObjZav[index].TypeObj of
    2 : begin // стрелка
      if ObjZav[ObjZav[index].BaseObject].ObjConstI[9] > 0 then
      begin // спаренная стрелка
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := 'Свойства : стрелка '+ ObjZav[index].Liter+' ('+ ObjZav[o].Liter+ ')';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ПК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ПК'] := 'есть' else ValueListDlg.ValList.Values['ПК'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МК'] := 'есть' else ValueListDlg.ValList.Values['МК'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if st then ValueListDlg.ValList.Values['Потеря контроля'] := 'есть' else ValueListDlg.ValList.Values['Потеря контроля'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if st then ValueListDlg.ValList.Values['Непостановка'] := 'есть' else ValueListDlg.ValList.Values['Непостановка'] := 'нет';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
        if st then ValueListDlg.ValList.Values['Выкл.управление'] := 'да' else ValueListDlg.ValList.Values['Выкл.управление'] := 'нет';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
        if st then ValueListDlg.ValList.Values['Макет'] := 'да' else ValueListDlg.ValList.Values['Макет'] := 'нет';
        if ObjZav[index].ObjConstB[6] then
        begin // Дальняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
          if st then ValueListDlg.ValList.Values['Закр.движение'] := 'да' else ValueListDlg.ValList.Values['Закр.движение'] := 'нет';
        end else
        begin // Ближняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
          if st then ValueListDlg.ValList.Values['Закр.движение'] := 'да' else ValueListDlg.ValList.Values['Закр.движение'] := 'нет';
        end;
      end else
      begin // одиночная стрелка
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := 'Свойства : стрелка '+ ObjZav[o].Liter;
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ПК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ПК'] := 'есть' else ValueListDlg.ValList.Values['ПК'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МК'] := 'есть' else ValueListDlg.ValList.Values['МК'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if st then ValueListDlg.ValList.Values['Потеря контроля'] := 'есть' else ValueListDlg.ValList.Values['Потеря контроля'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if st then ValueListDlg.ValList.Values['Непостановка'] := 'есть' else ValueListDlg.ValList.Values['Непостановка'] := 'нет';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
        if st then ValueListDlg.ValList.Values['Выкл.управление'] := 'да' else ValueListDlg.ValList.Values['Выкл.управление'] := 'нет';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
        if st then ValueListDlg.ValList.Values['Макет'] := 'да' else ValueListDlg.ValList.Values['Макет'] := 'нет';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
        if st then ValueListDlg.ValList.Values['Закр.движение'] := 'да' else ValueListDlg.ValList.Values['Закр.движение'] := 'нет';
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
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end;

//      KeyList.Add('Л.З.');
//      KeyList.Add('Л.С.');}

    end;
    4 : begin // П
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Liter;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
      if nep then ValueListDlg.ValList.Values['Занятость'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['Занятость'] := 'есть' else ValueListDlg.ValList.Values['Занятость'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['ЧИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЧИ']:= 'нет данных' else
      if st then ValueListDlg.ValList.Values['ЧИ'] := 'есть' else ValueListDlg.ValList.Values['ЧИ'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['НИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['НИ'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['НИ'] := 'есть' else ValueListDlg.ValList.Values['НИ'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
      if nep then ValueListDlg.ValList.Values['КМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КМ'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['КМ'] := 'есть' else ValueListDlg.ValList.Values['КМ'] := 'нет';
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end;

//      KeyList.Add('Л.З.');
//      KeyList.Add('Л.С.');}

    end;
    5 : begin // Светофор
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Liter;
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
      if st then ValueListDlg.ValList.Values['о'] := 'есть' else ValueListDlg.ValList.Values['о'] := 'нет';
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Со'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Со'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Со'] := 'есть' else ValueListDlg.ValList.Values['Со'] := 'нет';
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
        if st then ValueListDlg.ValList.Values['Авария шкафа'] := 'есть' else ValueListDlg.ValList.Values['Авария шкафа'] := 'нет';
      end;
      if ObjZav[o].ObjConstB[3] then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['НМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['НМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['НМ'] := 'есть' else ValueListDlg.ValList.Values['НМ'] := 'нет';
      end;
      if ObjZav[o].ObjConstB[2] then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Н'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Н'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Н'] := 'есть' else ValueListDlg.ValList.Values['Н'] := 'нет';
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        if ObjZav[o].bParam[18] then ValueListDlg.ValList.Values['РМ'] := 'есть' else ValueListDlg.ValList.Values['РМ'] := 'нет';
        if ObjZav[ID_Obj].ObjConstB[18] then
        begin
          if ObjZav[o].bParam[21] then ValueListDlg.ValList.Values['МУС'] := 'есть' else ValueListDlg.ValList.Values['МУС'] := 'нет';
        end;
      end;

//      KeyList.Add('Блокировка');
//      KeyList.Add('Перекрытие');

    end;



  else
    ValueListDlg.Caption := 'Свойства : ?';
  end;
end;

end.

