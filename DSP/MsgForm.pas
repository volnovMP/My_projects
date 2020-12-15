unit MsgForm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Registry, Buttons, ComCtrls, DateUtils;

type
  TMsgFormDlg = class(TForm)
    BtnUpdate: TButton;
    BtnCancel: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MemoUVK: TMemo;
    Memo: TMemo;
    procedure BtnUpdateClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
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

procedure TMsgFormDlg.BtnUpdateClick(Sender: TObject);
begin
  UpdateMsgQuery := true;
  BtnUpdate.Enabled := false;
  if PageControl.ActivePageIndex = 0 then
  begin
    Memo.SetFocus;
  end else
  if PageControl.ActivePageIndex = 1 then
  begin
    MemoUVK.SetFocus;
  end;

end;

procedure TMsgFormDlg.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

end.

