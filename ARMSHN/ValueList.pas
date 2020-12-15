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

procedure UpdateKeyList(index : integer);   // �������� ������ �������� �������
procedure UpdateValueList(index : integer); // �������� ���������� � ��������� �������� �������

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

procedure UpdateKeyList(index : integer); // �������� ������ �������� �������
begin
  ValueListDlg.ValList.Strings.Clear;
  TabloMain.TimerView.Enabled := true;
  if not ValueListDlg.Visible then ValueListDlg.Show;
end;

procedure UpdateValueList(index : integer); // �������� ���������� � ��������� �������� �������
  var st,nep,rdy : boolean; i,j,o : smallint; s : string;
begin
  if not ValueListDlg.Visible then exit;
  ValueListDlg.ValList.Strings.Clear;
  case ObjZav[index].TypeObj of
    2 : begin // �������
      if ObjZav[ObjZav[index].BaseObject].ObjConstI[9] > 0 then
      begin // ��������� �������
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := '�������� : ������� '+ ObjZav[index].Liter+' ('+ ObjZav[o].Liter+ ')';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ��������'] := '����' else ValueListDlg.ValList.Values['�������� ��������'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� ��������'] := '����' else ValueListDlg.ValList.Values['��������� ��������'] := '���';
        if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) or (ObjZav[o].siParam[2] > 0) or (ObjZav[o].siParam[6] > 0) or (ObjZav[o].siParam[7] > 0) then
        begin
          if ObjZav[o].dtParam[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['������ ��������'] := s;
          end else ValueListDlg.ValList.Values['������ ��������'] := '�� �������������';
          if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['�� + ���������'] := IntToStr(ObjZav[o].siParam[1]);
          if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['�� - ���������'] := IntToStr(ObjZav[o].siParam[2]);
          if ObjZav[o].siParam[6] > 0 then ValueListDlg.ValList.Values['�� + �������'] := IntToStr(ObjZav[o].siParam[6]);
          if ObjZav[o].siParam[7] > 0 then ValueListDlg.ValList.Values['�� - �������'] := IntToStr(ObjZav[o].siParam[7]);
        end;
        if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[3] > 0) then
        begin
          if ObjZav[o].dtParam[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['������������'] := s;
          end else ValueListDlg.ValList.Values['������������'] := '�� �������������';
          if ObjZav[o].siParam[3] > 0 then
            ValueListDlg.ValList.Values['����������'] := IntToStr(ObjZav[o].siParam[3]);
        end;
        if ObjZav[o].siParam[4] > 0 then ValueListDlg.ValList.Values['��������� � +'] := IntToStr(ObjZav[o].siParam[4]);
        if ObjZav[o].siParam[5] > 0 then ValueListDlg.ValList.Values['��������� � -'] := IntToStr(ObjZav[o].siParam[5]);
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['����� �������� � +'] := s;
        end;
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['����� �������� � -'] := s;
        end;
        st := GetFR4State(ObjZav[o].ObjConstI[1]-5);
        if st then ValueListDlg.ValList.Values['����������'] := '���������' else ValueListDlg.ValList.Values['����������'] := '��������';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-4);
        if st then ValueListDlg.ValList.Values['�����'] := '����������' else ValueListDlg.ValList.Values['�����'] := '�� ����������';
        if ObjZav[index].ObjConstB[6] then
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]-2);
          if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
        end else
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]-3);
          if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
        end;
        if ObjZav[index].ObjConstB[6] then
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]);
          if st then ValueListDlg.ValList.Values['�������� ��'] := '�������' else ValueListDlg.ValList.Values['�������� ��'] := '���������';
        end else
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]-1);
          if st then ValueListDlg.ValList.Values['�������� ��'] := '�������' else ValueListDlg.ValList.Values['�������� ��'] := '���������';
        end;
      end else
      begin // ��������� �������
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := '�������� : ������� '+ ObjZav[o].Liter;
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ��������'] := '����' else ValueListDlg.ValList.Values['�������� ��������'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� ��������'] := '����' else ValueListDlg.ValList.Values['��������� ��������'] := '���';
        if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) or (ObjZav[o].siParam[2] > 0) or (ObjZav[o].siParam[6] > 0) or (ObjZav[o].siParam[7] > 0) then
        begin
          if ObjZav[o].dtParam[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['������ ��������'] := s;
          end else ValueListDlg.ValList.Values['������ ��������'] := '�� �������������';
          if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['�� + ���������'] := IntToStr(ObjZav[o].siParam[1]);
          if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['�� - ���������'] := IntToStr(ObjZav[o].siParam[2]);
          if ObjZav[o].siParam[6] > 0 then ValueListDlg.ValList.Values['�� + �������'] := IntToStr(ObjZav[o].siParam[6]);
          if ObjZav[o].siParam[7] > 0 then ValueListDlg.ValList.Values['�� - �������'] := IntToStr(ObjZav[o].siParam[7]);
        end;
        if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[3] > 0) then
        begin
          if ObjZav[o].dtParam[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['������������'] := s;
          end else ValueListDlg.ValList.Values['������������'] := '�� �������������';
          if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['����������'] := IntToStr(ObjZav[o].siParam[3]);
        end;
        if ObjZav[o].siParam[4] > 0 then ValueListDlg.ValList.Values['��������� � +'] := IntToStr(ObjZav[o].siParam[4]);
        if ObjZav[o].siParam[5] > 0 then ValueListDlg.ValList.Values['��������� � -'] := IntToStr(ObjZav[o].siParam[5]);
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['����� �������� � +'] := s;
        end;
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['����� �������� � -'] := s;
        end;
        st := GetFR4State(ObjZav[o].ObjConstI[1]-5);
        if st then ValueListDlg.ValList.Values['����������'] := '���������' else ValueListDlg.ValList.Values['����������'] := '��������';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-4);
        if st then ValueListDlg.ValList.Values['�����'] := '����������' else ValueListDlg.ValList.Values['�����'] := '�� ����������';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-3);
        if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-1);
        if st then ValueListDlg.ValList.Values['�������� ��'] := '�������' else ValueListDlg.ValList.Values['�������� ��'] := '���������';
      end;
    end;
    3 : begin // ��,��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Liter;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
      if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['����'] := s;
        end;
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['������� ������'] := s;
        end else ValueListDlg.ValList.Values['������� ������'] := '�� �������������';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['������������ ������'] := s;
        end else ValueListDlg.ValList.Values['������������ ������'] := '�� �������������';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['�������� ��.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ��.�.'] := '���������';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['�������� ����.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ����.�.'] := '���������';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['�������� ���.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ���.�.'] := '���������';
        end;
      end;
    end;
    4 : begin // �
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Liter;
      if (ObjZav[o].ObjConstI[2] <> ObjZav[o].ObjConstI[9]) and (ObjZav[o].ObjConstI[2] > 0) and (ObjZav[o].ObjConstI[9] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������(�)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������(�)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������(�)'] := '����' else ValueListDlg.ValList.Values['���������(�)'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������(�)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������(�)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������(�)'] := '����' else ValueListDlg.ValList.Values['���������(�)'] := '���';
      end else
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      end else
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��']:= '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      if (ObjZav[o].ObjConstI[5] <> ObjZav[o].ObjConstI[7]) and (ObjZav[o].ObjConstI[7] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end else
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if (ObjZav[o].ObjConstI[6] <> ObjZav[o].ObjConstI[8]) and (ObjZav[o].ObjConstI[6] > 0) and (ObjZav[o].ObjConstI[8] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��(�)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��(�)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��(�)'] := '����' else ValueListDlg.ValList.Values['��(�)'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��(�)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��(�)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��(�)'] := '����' else ValueListDlg.ValList.Values['��(�)'] := '���';
      end else
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end else
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['������� ����'] := s;
        end else ValueListDlg.ValList.Values['������� ����'] := '�� �������������';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['������������ ����'] := s;
        end else ValueListDlg.ValList.Values['������������ ����'] := '�� �������������';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      if (ObjZav[o].dtParam[3] > 0) or (ObjZav[o].siParam[3] > 0) then
      begin
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['���������� ����� ����'] := s;
        end else ValueListDlg.ValList.Values['���������� ����� ����'] := '�� �������������';
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8 + 2);
      if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8 + 3);
        if st then ValueListDlg.ValList.Values['�������� ��.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ��.�.'] := '���������';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8);
          if st then ValueListDlg.ValList.Values['�������� ����.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ����.�.'] := '���������';
          st := GetFR4State(ObjZav[o].ObjConstI[1] div 8 * 8 + 1);
          if st then ValueListDlg.ValList.Values['�������� ���.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ���.�.'] := '���������';
        end;
      end;
    end;
    5 : begin // ��������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Liter;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      end;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
      if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['�'] := '����������' else ValueListDlg.ValList.Values['�'] := '��������';
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['������������� �'] := s;
        end else ValueListDlg.ValList.Values['������������� �'] := '�� �������������';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['���������� �'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['����������'] := s;
        end else ValueListDlg.ValList.Values['����������'] := '�� �������������';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['���������� �.'] := IntToStr(ObjZav[o].siParam[2]);
      end;

      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        if ObjZav[o].ObjConstI[25] = 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
          if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
          if st then ValueListDlg.ValList.Values['��'] := '����������' else ValueListDlg.ValList.Values['��'] := '��������';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
          if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
          if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
        end;
      end;
      if ObjZav[o].ObjConstI[25] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[25],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[26] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[26],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[30] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[30],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[29] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[29],nep,rdy);
        if nep then ValueListDlg.ValList.Values['2��/���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['2��/���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['2��/���'] := '����' else ValueListDlg.ValList.Values['2��/���'] := '���';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '��������' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
      if (ObjZav[o].dtParam[3] > 0) or (ObjZav[o].siParam[3] > 0) then
      begin
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['������� �� ������'] := s;
        end else ValueListDlg.ValList.Values['������� �� ������'] := '�� �������������';
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['���������� ��'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��/���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��/���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��/���'] := '����' else ValueListDlg.ValList.Values['��/���'] := '���';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ �����'] := '����������' else ValueListDlg.ValList.Values['������ �����'] := '��������';
      end;
      if (ObjZav[o].dtParam[4] > 0) or (ObjZav[o].siParam[4] > 0) then
      begin
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['��������� �'] := s;
        end else ValueListDlg.ValList.Values['��������� �'] := '�� �������������';
        if ObjZav[o].siParam[4] > 0 then
        begin
          ValueListDlg.ValList.Values['���������� �'] := IntToStr(ObjZav[o].siParam[4]);
        end else ValueListDlg.ValList.Values['���������� �'] := '�� �������������';
      end;
      if (ObjZav[o].dtParam[5] > 0) or (ObjZav[o].siParam[5] > 0) then
      begin
        if ObjZav[o].dtParam[5] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[5]); ValueListDlg.ValList.Values['��������� ��'] := s;
        end else ValueListDlg.ValList.Values['��������� ��'] := '�� �������������';
        if ObjZav[o].siParam[5] > 0 then
        begin
          ValueListDlg.ValList.Values['���������� ��'] := IntToStr(ObjZav[o].siParam[5]);
        end else ValueListDlg.ValList.Values['���������� ��'] := '�� �������������';
      end;
      if ObjZav[o].dtParam[6] > 0 then
      begin
        DateTimeToString(s,'s,z',ObjZav[o].dtParam[6]); ValueListDlg.ValList.Values['���������� ��'] := s;
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        if ObjZav[o].bParam[18] then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        if ObjZav[o].ObjConstB[18] then
        begin
          if ObjZav[o].bParam[21] then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        end;
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['��������'] := '�������' else ValueListDlg.ValList.Values['��������'] := '���������';
    end;
    6 : begin // ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].bParam[5] then ValueListDlg.ValList.Values['�������������'] := '����';
    end;
    7 : begin // ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        if ObjZav[o].ObjConstI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
          if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
          if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
          if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
          if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
          if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
          if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        end;
      end;
    end;
    8 : begin // ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����������'] := '����' else ValueListDlg.ValList.Values['����������'] := '���';
      end;
    end;
    9 : begin // ��������� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����'] := '����' else ValueListDlg.ValList.Values['����'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    10 : begin // �������� ��������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����'] := '����' else ValueListDlg.ValList.Values['����'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������'] := '����' else ValueListDlg.ValList.Values['��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
    end;
    11 : begin // �������� �������� ������������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������'] := '����' else ValueListDlg.ValList.Values['������'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������������'] := '����' else ValueListDlg.ValList.Values['�������������'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.��������'] := '����' else ValueListDlg.ValList.Values['�����.��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.��������'] := '����' else ValueListDlg.ValList.Values['�����.��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.���������'] := '����' else ValueListDlg.ValList.Values['�����.���������'] := '���';
      end;
    end;
    12 : begin // �������� �������� ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.��������'] := '����' else ValueListDlg.ValList.Values['�����.��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.��������'] := '����' else ValueListDlg.ValList.Values['�����.��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����.���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����.���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����.���������'] := '����' else ValueListDlg.ValList.Values['�����.���������'] := '���';
      end;
    end;
    13 : begin // ���������� ��������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['"�����"'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['"�����"'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['"�����"'] := '����' else ValueListDlg.ValList.Values['"�����"'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� ��'] := '����' else ValueListDlg.ValList.Values['��������� ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ ��'] := '����' else ValueListDlg.ValList.Values['������ ��'] := '���';
      end;
    end;
    14 : begin // �����
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����������'] := '����' else ValueListDlg.ValList.Values['����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������1'] := '����������' else ValueListDlg.ValList.Values['������1'] := '��������';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������2'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������2'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������2'] := '����������' else ValueListDlg.ValList.Values['������2'] := '��������';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� �����'] := '����������' else ValueListDlg.ValList.Values['�������� �����'] := '��������';
      end;
    end;
    15 : begin // ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['1��/�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['1��/�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['1��/�'] := '�����' else ValueListDlg.ValList.Values['1��/�'] := '��������';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['2��/�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['2��/�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['2��/�'] := '�����' else ValueListDlg.ValList.Values['2��/�'] := '��������';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '�����������' else ValueListDlg.ValList.Values['��'] := '�����';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '�����' else ValueListDlg.ValList.Values['��'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����-����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����-����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����-����'] := '�����' else ValueListDlg.ValList.Values['����-����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ ��'] := '����' else ValueListDlg.ValList.Values['������ ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['3��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['3��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['3��'] := '�����' else ValueListDlg.ValList.Values['3��'] := '��������';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ��'] := '����' else ValueListDlg.ValList.Values['�������� ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�1'] := '����' else ValueListDlg.ValList.Values['�1'] := '���';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�2'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�2'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�2'] := '����' else ValueListDlg.ValList.Values['�2'] := '���';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['�������� ��������'] := '������' else ValueListDlg.ValList.Values['�������� ��������'] := '������';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['�������� ��.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ��.�.'] := '���������';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['�������� ����.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ����.�.'] := '���������';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['�������� ���.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ���.�.'] := '���������';
        end;
      end;
    end;
    16 : begin // ��������������� ����� ����������� ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
    end;
    17 : begin // ���������� �������� ���� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ���'] := '����' else ValueListDlg.ValList.Values['������� ���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
    end;
    18 : begin // ���������� ������ �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �� ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �� ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �� ������'] := '����' else ValueListDlg.ValList.Values['������� �� ������'] := '���';
      end;
    end;
    19 : begin // ��������������� ������� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    20 : begin // ����� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '���������' else ValueListDlg.ValList.Values['��'] := '�� ���������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
    end;
    21 : begin // �������� �������� ������� ������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������'] := '��������' else ValueListDlg.ValList.Values['���������'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['�������� ��'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����������'] := '��������' else ValueListDlg.ValList.Values['����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['�������� ��'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������'] := '��������' else ValueListDlg.ValList.Values['��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['�������� ��'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '��������' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '��������' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '��������' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    22 : begin // �������� �������������� ����������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���1'] := '��������' else ValueListDlg.ValList.Values['���1'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '��������' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '��������' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['�������� ��'] := IntToStr(ObjZav[o].siParam[1]);
      end;
    end;
    23 : begin // ������ � ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������� �����'] := '����' else ValueListDlg.ValList.Values['���������� �����'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������� �����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������� �����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������� �����������'] := '����' else ValueListDlg.ValList.Values['���������� �����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ��������'] := '����' else ValueListDlg.ValList.Values['������� ��������'] := '���';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['�������� ��������'] := '������' else ValueListDlg.ValList.Values['�������� ��������'] := '������';
    end;
    24 : begin // ������ � ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ ��'] := '����' else ValueListDlg.ValList.Values['������ ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����� ������ ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����� ������ ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����� ������ ��'] := '����' else ValueListDlg.ValList.Values['����� ������ ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ��������'] := '����' else ValueListDlg.ValList.Values['������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '�����' else ValueListDlg.ValList.Values['��'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ������ ��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ������ ��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ������ ��'] := '����' else ValueListDlg.ValList.Values['������� ������ ��'] := '���';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '�����' else ValueListDlg.ValList.Values['�'] := '��������';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �� ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �� ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �� ������'] := '�������' else ValueListDlg.ValList.Values['������� �� ������'] := '���';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �� ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �� ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �� ������'] := '����' else ValueListDlg.ValList.Values['������� �� ������'] := '���';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �� �����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �� �����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �� �����������'] := '�������' else ValueListDlg.ValList.Values['������� �� �����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �� �����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �� �����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �� �����������'] := '����' else ValueListDlg.ValList.Values['������� �� �����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['�������� ��������'] := '������' else ValueListDlg.ValList.Values['�������� ��������'] := '������';
    end;
    25 : begin // ���������� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������� ��������'] := '����' else ValueListDlg.ValList.Values['���������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ ��������'] := '����' else ValueListDlg.ValList.Values['������ ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�/��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�/��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�/��'] := '����' else ValueListDlg.ValList.Values['�/��'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ��������'] := '����' else ValueListDlg.ValList.Values['������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
    end;
    26 : begin // ������ � ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� �� �����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� �� �����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� �� �����������'] := '�����' else ValueListDlg.ValList.Values['��������� �� �����������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ������'] := '����' else ValueListDlg.ValList.Values['�������� ������'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���� ��������'] := '����' else ValueListDlg.ValList.Values['���� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� �� ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� �� ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� �� ������'] := '�����' else ValueListDlg.ValList.Values['��������� �� ������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ��������'] := '����' else ValueListDlg.ValList.Values['�������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����-����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����-����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����-����'] := '�����' else ValueListDlg.ValList.Values['����-����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������'] := '����������' else ValueListDlg.ValList.Values['�����������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '�����' else ValueListDlg.ValList.Values['��'] := '��������';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['�������� ��������'] := '������' else ValueListDlg.ValList.Values['�������� ��������'] := '������';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['�������� ��.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ��.�.'] := '���������';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['�������� ����.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ����.�.'] := '���������';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['�������� ���.�.'] := '�������' else ValueListDlg.ValList.Values['�������� ���.�.'] := '���������';
        end;
      end;
    end;
    30 : begin // �������� ��������� ����������� (��������� �������� ������)
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ��������'] := '����' else ValueListDlg.ValList.Values['������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� ��������'] := '����' else ValueListDlg.ValList.Values['��������� ��������'] := '���';
      end;
    end;
    31 : begin // ����������� ���������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� �����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� �����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� �����������'] := '����' else ValueListDlg.ValList.Values['��������� �����������'] := '���';
      end;
    end;
    32 : begin // ������ � ������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� �����'] := '�������' else ValueListDlg.ValList.Values['������� �����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������ �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������ �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������ �����'] := '�������' else ValueListDlg.ValList.Values['������ �����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����� �����'] := '�������' else ValueListDlg.ValList.Values['����� �����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� �����'] := '�������' else ValueListDlg.ValList.Values['��������� �����'] := '��������';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['����� �� ����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['����� �� ����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['����� �� ����������'] := '����' else ValueListDlg.ValList.Values['����� �� ����������'] := '���';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ��������'] := '����' else ValueListDlg.ValList.Values['������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� �������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� �������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� �������'] := '����' else ValueListDlg.ValList.Values['�������� �������'] := '���';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ��������'] := '����' else ValueListDlg.ValList.Values['�������� ��������'] := '���';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���������� �����'] := '����' else ValueListDlg.ValList.Values['���������� �����'] := '���';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� �����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� �����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� �����'] := '�����' else ValueListDlg.ValList.Values['��������� �����'] := '��������';
      end;
    end;
    33 : begin // ������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������'] := '����' else ValueListDlg.ValList.Values['������'] := '���';
      end;
    end;
    34 : begin // �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� 1 ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� 1 ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� 1 ������'] := '����������' else ValueListDlg.ValList.Values['�������� 1 ������'] := '����';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� 2 ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� 2 ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� 2 ������'] := '����������' else ValueListDlg.ValList.Values['�������� 2 ������'] := '����';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ���'] := '����' else ValueListDlg.ValList.Values['�������� ���'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� 1 ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� 1 ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� 1 ������'] := '���' else ValueListDlg.ValList.Values['��������� 1 ������'] := '����';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������� 2 ������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������� 2 ������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������� 2 ������'] := '���' else ValueListDlg.ValList.Values['��������� 2 ������'] := '����';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '��������� ��������' else ValueListDlg.ValList.Values['���'] := '�����';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������'] := '������' else ValueListDlg.ValList.Values['�����������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���1'] := '���������' else ValueListDlg.ValList.Values['���1'] := '��������';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���2'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���2'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���2'] := '���������' else ValueListDlg.ValList.Values['���2'] := '��������';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� �������1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� �������1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� �������1'] := '�������' else ValueListDlg.ValList.Values['�������� �������1'] := '�������';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� �������2'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� �������2'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� �������2'] := '�������' else ValueListDlg.ValList.Values['�������� �������2'] := '�������';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������� ����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������� ����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������� ����������'] := '��������' else ValueListDlg.ValList.Values['�������� ����������'] := '���������';
      end;
      if ObjZav[o].ObjConstI[15] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[15],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ����������'] := '����' else ValueListDlg.ValList.Values['������� ����������'] := '����';
      end;
      if ObjZav[o].ObjConstI[16] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[16],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������� ����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������� ����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������� ����������'] := '�������' else ValueListDlg.ValList.Values['������� ����������'] := '��������';
      end;
    end;
    36 : begin // ����
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['������'] := '��������' else ValueListDlg.ValList.Values['������'] := '���������';
      end;
    end;
    37 : begin // ����
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��������'] := '���������' else ValueListDlg.ValList.Values['��������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���.��������'] := '��� ������' else
        if not st then ValueListDlg.ValList.Values['���.��������'] := '��������' else ValueListDlg.ValList.Values['���.��������'] := '����������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���.��������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���.��������'] := '��� ������' else
        if not st then ValueListDlg.ValList.Values['���.��������'] := '��������' else ValueListDlg.ValList.Values['���.��������'] := '����������';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�������'] := '�����������' else ValueListDlg.ValList.Values['�������'] := '�����';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��1'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��1'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��1'] := '�����������' else ValueListDlg.ValList.Values['��1'] := '�����';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��2'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��2'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��2'] := '�����������' else ValueListDlg.ValList.Values['��2'] := '�����';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����'] := '�����������' else ValueListDlg.ValList.Values['�����'] := '�����';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        st := FR3[ObjZav[o].ObjConstI[8]] = 0;
        if st then ValueListDlg.ValList.Values['�������'] := '���������������' else ValueListDlg.ValList.Values['�������'] := '���';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    38 : begin // ������� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    39 : begin // �������� ��
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '�����' else ValueListDlg.ValList.Values['���'] := '�������';
      end;
    end;
    43 : begin // ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
      end;
    end;
    45 : begin // ���
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '��������' else ValueListDlg.ValList.Values['���'] := '���������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
    end;
    47 : begin // ������������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '��������' else ValueListDlg.ValList.Values['��'] := '���������';
      end;
    end;
    49 : begin // ������ � ����
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '������� ������' else ValueListDlg.ValList.Values['���'] := '������� ���������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '�������� ��������' else ValueListDlg.ValList.Values['��'] := '�������� ����������';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������'] := '����������' else ValueListDlg.ValList.Values['�����������'] := '��������';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����������' else ValueListDlg.ValList.Values['��'] := '��������';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['���'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['���'] := '����������' else ValueListDlg.ValList.Values['���'] := '��������';
      end;
    end;
    50 : begin // �������� ���������� �����
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(1)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(1)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(1)'] := '�����' else ValueListDlg.ValList.Values['�����(1)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(1)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(1)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(1)'] := '�����' else ValueListDlg.ValList.Values['�����������(1)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(2)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(2)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(2)'] := '�����' else ValueListDlg.ValList.Values['�����(2)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(2)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(2)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(2)'] := '�����' else ValueListDlg.ValList.Values['�����������(2)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(3)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(3)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(3)'] := '�����' else ValueListDlg.ValList.Values['�����(3)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(3)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(3)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(3)'] := '�����' else ValueListDlg.ValList.Values['�����������(3)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(4)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(4)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(4)'] := '�����' else ValueListDlg.ValList.Values['�����(4)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(4)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(4)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(4)'] := '�����' else ValueListDlg.ValList.Values['�����������(4)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(5)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(5)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(5)'] := '�����' else ValueListDlg.ValList.Values['�����(5)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(5)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(5)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(5)'] := '�����' else ValueListDlg.ValList.Values['�����������(5)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(6)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(6)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(6)'] := '�����' else ValueListDlg.ValList.Values['�����(6)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(6)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(6)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(6)'] := '�����' else ValueListDlg.ValList.Values['�����������(6)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(7)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(7)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(7)'] := '�����' else ValueListDlg.ValList.Values['�����(7)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(7)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(7)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(7)'] := '�����' else ValueListDlg.ValList.Values['�����������(7)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[15] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[15],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����(8)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����(8)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����(8)'] := '�����' else ValueListDlg.ValList.Values['�����(8)'] := '��������';
      end;
      if ObjZav[o].ObjConstI[16] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[16],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�����������(8)'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�����������(8)'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�����������(8)'] := '�����' else ValueListDlg.ValList.Values['�����������(8)'] := '��������';
      end;
    end;
    51 : begin // �������������� �������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Title;
      for i := 1 to 30 do
        if ObjZav[o].ObjConstI[i] > 0 then
        begin
          for j := 1 to High(LinkFR3) do
          if LinkFR3[j].ByteFR3 = ObjZav[o].ObjConstI[i] then
          begin s := LinkFR3[j].Name; break; end;
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[i],nep,rdy);
          if nep
          then ValueListDlg.ValList.Values[s] := '��������������'
          else
            if not rdy then ValueListDlg.ValList.Values[s] := '��� ������'
            else
              if st then ValueListDlg.ValList.Values[s] := '�������'
              else ValueListDlg.ValList.Values[s] := '��������';
        end;
    end;





  else
    ValueListDlg.Caption := '�������� : ?';
  end;
end;

//-----------------------------------------------------------------------------
// ����� ���������� �� �������
procedure TValueListDlg.pmResetStatClick(Sender: TObject);
  var o,i : integer;
begin
  case ObjZav[ID_ViewObj].TypeObj of
    2 : begin //�������
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

