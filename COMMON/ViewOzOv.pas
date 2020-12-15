unit ViewOzOv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TViewBaza = class(TForm)
    NomOZ: TEdit;
    Label1: TLabel;
    ParamOZ: TStringGrid;
    NameOZ: TLabel;
    ParamOV: TStringGrid;
    Label3: TLabel;
    procedure NomOZDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewBaza: TViewBaza;
  NomerOZ, NomerOV : integer;
implementation
  uses
    TypeALL;
{$R *.dfm}


procedure TViewBaza.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for i := 1 to 34 do
  begin
    ParamOZ.Cells[0,i-1] := IntToStr(i);
  end;
  for i := 1 to 32 do
  begin
    ParamOV.Cells[0,i-1] := IntToStr(i);
  end;

end;

procedure TViewBaza.NomOZDblClick(Sender: TObject);
var
  i,j,Buf : integer;
begin
  NomerOZ := StrToInt(NomOZ.Text);
  NameOZ.Caption := ObjZv[NomerOZ].Title;
  Buf := ObjZv[NomerOZ].VBufInd;
  Label3.Caption := 'Номер BV=' + IntToStr(Buf);
  for i := 1 to 34 do
  begin
    if ObjZv[NomerOZ].bP[i] then j := 1
    else j := 0;
    ParamOZ.Cells[1,i-1] := IntToStr(j);
  end;

  for i := 1 to 32 do
  begin
    if OVBuffer[Buf].Param[i] then j := 1
    else j := 0;
    ParamOV.Cells[1,i-1] := IntToStr(j);
  end;
end;

end.
