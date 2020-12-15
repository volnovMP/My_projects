unit MsgForm;

interface

uses
  Windows,
  Forms,
  StdCtrls,
  ComCtrls, Classes, Controls;

type
  TMsgFormDlg = class(TForm)
    BtnUpdate: TButton;
    BtnCancel: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MemoUVK: TMemo;
    Memo: TMemo;
    TabSheet3: TTabSheet;
    MemoNeispr: TMemo;
    BtnSave: TButton;
    procedure BtnUpdateClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure MemoNeisprEnter(Sender: TObject);
    procedure MemoUVKEnter(Sender: TObject);
    procedure MemoEnter(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MsgFormDlg: TMsgFormDlg;
  UpdateMsgQuery : Boolean; // Запрос обновления списка сообщений
  RefreshMsg : boolean;

implementation

{$R *.dfm}

uses
  TypeALL,
  TabloSHN;

var s : string;

procedure TMsgFormDlg.BtnUpdateClick(Sender: TObject);
begin
  UpdateMsgQuery := true; BtnUpdate.Enabled := false; refreshMsg := true;
  if PageControl.ActivePageIndex = 0 then
  begin
    Memo.SetFocus;
  end else
  if PageControl.ActivePageIndex = 1 then
  begin
    MemoUVK.SetFocus;
  end else
  if PageControl.ActivePageIndex = 2 then
  begin
    MemoNeispr.SetFocus;
  end;
end;

procedure TMsgFormDlg.BtnCancelClick(Sender: TObject);
begin
  Close;
end;
//========================================================================================
procedure TMsgFormDlg.FormCreate(Sender: TObject);
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegMsgForm, false) then
  begin
    if reg.ValueExists('left') then MsgFormDlg.Left := reg.ReadInteger('left')
    else MsgFormDlg.Left := 200;

    if reg.ValueExists('top') then MsgFormDlg.Top := reg.ReadInteger('top')
    else MsgFormDlg.Top := TabloMain.Height;

    if reg.ValueExists('height') then MsgFormDlg.Height := reg.ReadInteger('height')
    else MsgFormDlg.Height := Screen.Height- MsgFormDlg.Top;

    if reg.ValueExists('width') then MsgFormDlg.Width := reg.ReadInteger('width')
    else MsgFormDlg.Width := Screen.Width- MsgFormDlg.Left- 100;
    reg.CloseKey;
  end;
end;
//========================================================================================
procedure TMsgFormDlg.TabSheet1Show(Sender: TObject);
begin
  Memo.SetFocus;
end;
//========================================================================================
procedure TMsgFormDlg.TabSheet2Show(Sender: TObject);
begin
  MemoUVK.SetFocus;
end;
//========================================================================================
procedure TMsgFormDlg.TabSheet3Show(Sender: TObject);
begin
  MemoNeispr.SetFocus;
end;
//========================================================================================
procedure TMsgFormDlg.MemoNeisprEnter(Sender: TObject);
begin
  if refreshMsg then
  begin
    newListNeisprav := false; TabSheet3.Highlighted := false;
  end;
end;
//========================================================================================
procedure TMsgFormDlg.MemoUVKEnter(Sender: TObject);
begin
  if refreshMsg then
  begin
    newListDiagnoz := false; TabSheet2.Highlighted := false;
  end;
end;
//========================================================================================
procedure TMsgFormDlg.MemoEnter(Sender: TObject);
begin
  if refreshMsg then
  begin
    newListMessages := false; TabSheet1.Highlighted := false;
  end;
end;
//========================================================================================
procedure TMsgFormDlg.BtnSaveClick(Sender: TObject);
begin
  case PageControl.ActivePageIndex of
    0 : begin
      s := config.arcpath+ '\сообщения.txt';
      memo.Lines.SaveToFile(s);
    end;
    1 : begin
      s := config.arcpath+ '\УВК.txt';
      memoUVK.Lines.SaveToFile(s);
    end;
    2 : begin
      s := config.arcpath+ '\неисправности.txt';
      memoNeispr.Lines.SaveToFile(s);
    end;
  end;
  WinExec(PAnsiChar('NotePad.exe '+ s), SW_NORMAL);

end;

end.

