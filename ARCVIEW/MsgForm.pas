unit MsgForm;

interface

uses
  Windows,
  Forms,
  StdCtrls,
  Registry,
  ComCtrls, Classes, Controls;

type
  TMsgFormDlg = class(TForm)
    BtnCancel: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MemoUVK: TMemo;
    Memo: TMemo;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
 //   procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MsgFormDlg: TMsgFormDlg;
  UpdateMsgQuery : Boolean; // Запрос обновления списка сообщений

implementation

{$R *.dfm}

uses
  TabloForm;

var
  reg : TRegistry;

procedure TMsgFormDlg.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TMsgFormDlg.FormCreate(Sender: TObject);
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegMsgForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    if reg.ValueExists('height') then Height := reg.ReadInteger('height') else Left := 0;
    if reg.ValueExists('width')  then Width  := reg.ReadInteger('width')  else Width  := 0;
    reg.CloseKey;
  end;
end;
{
procedure TMsgFormDlg.FormDestroy(Sender: TObject);
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegMsgForm, false) then
  begin
    reg.WriteInteger('left', MsgFormDlg.Left);
    reg.WriteInteger('top', MsgFormDlg.Top);
    reg.WriteInteger('width', MsgFormDlg.Width);
    reg.WriteInteger('height', MsgFormDlg.Height);
    reg.CloseKey;
  end;
  reg.Free;
end;
}
end.

