unit Password;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Registry, Buttons;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordDlg: TPasswordDlg;
  PasswordPos : TPoint;

implementation

{$R *.dfm}

var
  reg : TRegistry;
  keyvalue : string;

procedure TPasswordDlg.FormCreate(Sender: TObject);
  var i : integer;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('\Software\DSPRPCTUMS', false) then
  begin
    if reg.ValueExists('key') then
    begin
      keyvalue := reg.ReadString('key');
      for i := 1 to Length(keyvalue) do begin keyvalue[i] := char(byte(keyvalue[i])-i) end;
    end else keyvalue := '262793';
    Reg.CloseKey;
  end;
  reg.Free;
end;

procedure TPasswordDlg.OKBtnClick(Sender: TObject);
begin
  if keyvalue <> password.Text then begin modalResult := mrCancel; exit; end;
end;

procedure TPasswordDlg.FormActivate(Sender: TObject);
begin
  Password.Text := ''; Left := PasswordPos.X; Top := PasswordPos.Y;
end;

end.

