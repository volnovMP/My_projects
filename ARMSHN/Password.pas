unit Password;
{$INCLUDE d:\sapr2012\CfgProject}
interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Registry,
  Buttons;

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

  implementation
var
 keyvalue : string;
 reg1 : TRegistry;
{$R *.dfm}

procedure TPasswordDlg.FormCreate(Sender: TObject);
  var i : integer;
begin
  reg1 := TRegistry.Create;
  reg1.RootKey := HKEY_LOCAL_MACHINE;
  if Reg1.OpenKey('\Software\SHNRPCTUMS', false) then
  begin
    if reg1.ValueExists('key') then
    begin
      keyvalue := reg1.ReadString('key');
      for i := 1 to Length(keyvalue) do
      begin
        keyvalue[i] := char(byte(keyvalue[i])-i)
      end;
    end else keyvalue := '262793';
    Reg1.CloseKey;
  end;
  reg1.Destroy;
end;

procedure TPasswordDlg.OKBtnClick(Sender: TObject);
begin
  if keyvalue <> password.Text then
  begin
    modalResult := mrCancel;
    exit;
  end;
end;

procedure TPasswordDlg.FormActivate(Sender: TObject);
begin
  Password.Text := '';
end;
end.

