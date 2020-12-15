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
  
procedure UpdateKeyList(index : integer);   // �������� ������ �������� �������
procedure UpdateValueList(index : integer); // �������� ���������� � ��������� �������� �������

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

procedure UpdateKeyList(index : integer); // �������� ������ �������� �������
begin
end;

procedure UpdateValueList(index : integer); // �������� ���������� � ��������� �������� �������
  var st,nep,rdy : boolean; o : smallint;
begin
  case ObjZav[index].TypeObj of
    2 : begin // �������
      if ObjZav[ObjZav[index].BaseObject].ObjConstI[9] > 0 then
      begin // ��������� �������
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := '�������� : ������� '+ ObjZav[index].Liter+' ('+ ObjZav[o].Liter+ ')';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if st then ValueListDlg.ValList.Values['������ ��������'] := '����' else ValueListDlg.ValList.Values['������ ��������'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if st then ValueListDlg.ValList.Values['������������'] := '����' else ValueListDlg.ValList.Values['������������'] := '���';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
        if st then ValueListDlg.ValList.Values['����.����������'] := '��' else ValueListDlg.ValList.Values['����.����������'] := '���';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
        if st then ValueListDlg.ValList.Values['�����'] := '��' else ValueListDlg.ValList.Values['�����'] := '���';
        if ObjZav[index].ObjConstB[6] then
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
          if st then ValueListDlg.ValList.Values['����.��������'] := '��' else ValueListDlg.ValList.Values['����.��������'] := '���';
        end else
        begin // ������� �������
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
          if st then ValueListDlg.ValList.Values['����.��������'] := '��' else ValueListDlg.ValList.Values['����.��������'] := '���';
        end;
      end else
      begin // ��������� �������
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := '�������� : ������� '+ ObjZav[o].Liter;
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if st then ValueListDlg.ValList.Values['������ ��������'] := '����' else ValueListDlg.ValList.Values['������ ��������'] := '���';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if st then ValueListDlg.ValList.Values['������������'] := '����' else ValueListDlg.ValList.Values['������������'] := '���';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
        if st then ValueListDlg.ValList.Values['����.����������'] := '��' else ValueListDlg.ValList.Values['����.����������'] := '���';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
        if st then ValueListDlg.ValList.Values['�����'] := '��' else ValueListDlg.ValList.Values['�����'] := '���';
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
        if st then ValueListDlg.ValList.Values['����.��������'] := '��' else ValueListDlg.ValList.Values['����.��������'] := '���';
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
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;

//      KeyList.Add('�.�.');
//      KeyList.Add('�.�.');}

    end;
    4 : begin // �
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Liter;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
      if nep then ValueListDlg.ValList.Values['���������'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['���������'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['���������'] := '����' else ValueListDlg.ValList.Values['���������'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��']:= '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
      if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
      if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;

//      KeyList.Add('�.�.');
//      KeyList.Add('�.�.');}

    end;
    5 : begin // ��������
      o := index;
      ValueListDlg.Caption := '�������� : '+ ObjZav[index].Liter;
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
      if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
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
        if st then ValueListDlg.ValList.Values['������ �����'] := '����' else ValueListDlg.ValList.Values['������ �����'] := '���';
      end;
      if ObjZav[o].ObjConstB[3] then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['��'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['��'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
      end;
      if ObjZav[o].ObjConstB[2] then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['�'] := '��������������' else if not rdy then ValueListDlg.ValList.Values['�'] := '��� ������' else
        if st then ValueListDlg.ValList.Values['�'] := '����' else ValueListDlg.ValList.Values['�'] := '���';
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        if ObjZav[o].bParam[18] then ValueListDlg.ValList.Values['��'] := '����' else ValueListDlg.ValList.Values['��'] := '���';
        if ObjZav[ID_Obj].ObjConstB[18] then
        begin
          if ObjZav[o].bParam[21] then ValueListDlg.ValList.Values['���'] := '����' else ValueListDlg.ValList.Values['���'] := '���';
        end;
      end;

//      KeyList.Add('����������');
//      KeyList.Add('����������');

    end;



  else
    ValueListDlg.Caption := '�������� : ?';
  end;
end;

end.

