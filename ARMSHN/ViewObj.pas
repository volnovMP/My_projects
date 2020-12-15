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
  ListObjCount : integer;                  // ������� �������� ������������ � ������
  StatusObjCod : array[1..2048] of Byte;   // ������ ��������� �������� ������������
  StatusObjMsg : array[1..2048] of string; // ������ ��������� ��� �������� ������������

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
      2 : begin // �������
        sparam[1] := '�������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      3 : begin // �������
        sparam[1] := '�������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      4 : begin // ����
        sparam[1] := '����'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      5 : begin // ��������
        sparam[1] := '��������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      6 : begin // ���
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      7 : begin // ��������������� ������
        sparam[1] := '��'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      8 : begin // ��������� ����
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      9 : begin // ��������� �������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      10 : begin // ���������� ���������
        sparam[1] := '�������(���)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      11 : begin // �������� �������� ������������
        sparam[1] := '�������(�1)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      12 : begin // �������� �������� ��������������
        sparam[1] := '�������(��)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      13 : begin // ���������� ��������
        sparam[1] := '��'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      14 : begin // �����
        sparam[1] := '�����'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      15 : begin // ��
        sparam[1] := '��'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      16 : begin // ��������������� ����� �����������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      17 : begin // ������� ���������� �������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      18 : begin // ���������� ������ �������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      19 : begin // ��������������� ������� �������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      20 : begin // ����� �������
        sparam[1] := '����� ���.'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      21 : begin // �������� ������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      22 : begin // ���
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      23 : begin // ���
        sparam[1] := '������ ���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      24 : begin // ������ ����� �������
        sparam[1] := '������ ��'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      25 : begin // ������ � ���������� ��������
        sparam[1] := '��'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      26 : begin // ���
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      31 : begin // ����������� ���������
        sparam[1] := '����������� ��.'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      32 : begin // ������ � ���
        sparam[1] := '������ ���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      33 : begin // ������
        sparam[1] := '������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      34 : begin // �������� ��������������
        sparam[1] := '�������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      36 : begin // ������� ��� ������������
        sparam[1] := '����'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      37 : begin // ����������
        sparam[1] := '����������'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      38 : begin // �������� �������� �������
        sparam[1] := '��'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      39 : begin // ����� ����������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      43 : begin // ���
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      45 : begin // ����� ���� ����������
        sparam[1] := '���'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      47 : begin // ��������� ������������
        sparam[1] := '��'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      49 : begin // ������ � ����
        sparam[1] := '����'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      50 : begin // �������� ���������� �����
        sparam[1] := '����'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      51 : begin // �������� �������������� ��������
        sparam[1] := '������'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
    end;
    if ins then
    begin // �������� � ������ ��������
      inc(ListObjCount);
      ListItem := ListObj.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.Add(sparam[1]);
      ListItem.SubItems.Add(sparam[2]);
      StatusObjMsg[i] := '���� ������';
      StatusObjCod[i] := 0;
      ListItem.SubItems.Add(StatusObjMsg[i]);
    end;
  end;
end;

//------------------------------------------------------------------------------
// ����� ������� �� ������
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
// ���������� ���������� � ��������� �������� ������������
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
        2 : begin // �������
          o := ObjZav[j].BaseObject;
          if not ObjZav[o].bParam[31] then
          begin // ��� ������
            StatusObjMsg[i] := '��� ������'; state := 1;
          end else
          if ObjZav[o].bParam[32] then
          begin // ��������������
            StatusObjMsg[i] := '������������� �����'; state := 2;
          end else
          if ObjZav[o].bParam[26] and not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin // ������ �������� �������
            StatusObjMsg[i] := '��� ��������'; state := 3;
          end else
          if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin
            StatusObjMsg[i] := '� �����'; state := 4;
          end else
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin
            StatusObjMsg[i] := '� ������'; state := 5;
          end else
          begin
            StatusObjMsg[i] := '������� �������'; state := 6;
          end;
        end;

        3 : begin // ������
          if not ObjZav[j].bParam[31] then
          begin // ��� ������
            StatusObjMsg[i] := '��� ������'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // ��������������
            StatusObjMsg[i] := '������������� �����'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] then begin state := 3; StatusObjMsg[i] := '��������'; end else begin state := 3+$8; StatusObjMsg[i] := '�����'; end;
            if ObjZav[j].bParam[2] then begin StatusObjMsg[i] := StatusObjMsg[i]+', ���������'; end else begin state := 3+$10; StatusObjMsg[i] := StatusObjMsg[i]+', �������'; end;
            if ObjZav[j].bParam[3] then begin state := 3+$20; StatusObjMsg[i] := StatusObjMsg[i]+', ������������� ����������'; end;
          end;
        end;

        4 : begin // ����
          if not ObjZav[j].bParam[31] then
          begin // ��� ������
            StatusObjMsg[i] := '��� ������'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // ��������������
            StatusObjMsg[i] := '������������� �����'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] and ObjZav[j].bParam[16] then begin state := 3; StatusObjMsg[i] := '��������'; end else begin state := 3+$8; StatusObjMsg[i] := '�����'; end;
            if ObjZav[j].bParam[2] and ObjZav[j].bParam[3] then begin StatusObjMsg[i] := StatusObjMsg[i]+', ���������'; end else begin state := 3+$10; StatusObjMsg[i] := StatusObjMsg[i]+', �������'; end;
          end;
        end;

        5 : begin // ��������
          if not ObjZav[j].bParam[31] then
          begin // ��� ������
            StatusObjMsg[i] := '��� ������'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // ��������������
            StatusObjMsg[i] := '������������� �����'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] or ObjZav[j].bParam[2] or ObjZav[j].bParam[3] or ObjZav[j].bParam[4] then
            begin
              state := 4; StatusObjMsg[i] := '������';
              if ObjZav[j].bParam[1] or ObjZav[j].bParam[2] then begin state := state+$8; StatusObjMsg[i] := StatusObjMsg[i]+' ����������'; end;
              if ObjZav[j].bParam[3] or ObjZav[j].bParam[4] then begin state := state+$10; StatusObjMsg[i] := StatusObjMsg[i]+' ��������'; end;
            end else
            begin
              state := 3; StatusObjMsg[i] := '������';
              if ObjZav[j].bParam[5] then begin state := state+$20; StatusObjMsg[i] := StatusObjMsg[i]+', ����������'; end;
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
