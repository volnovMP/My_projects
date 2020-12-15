unit ViewFr;
{$INCLUDE d:\sapr2012\CfgProject}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Grids, StdCtrls;

type
  TFrForm = class(TForm)
    Refresh: TButton;
    sgFr: TStringGrid;
    procedure RefreshClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure RefreshFr;
  public
    { Public declarations }
  end;

var
  FrForm: TFrForm;

implementation

{$R *.dfm}

uses
  TypeALL,
{$IFDEF RMDSP}
  KanalArmSrv;
{$ENDIF}
{$IFDEF RMSHN}
    KanalArmSrvSHN;
{$ENDIF}
//------------------------------------------------------------
// Обновить данные FR3, FR4
procedure TFrForm.RefreshClick(Sender: TObject);
begin
  RefreshFr;
end;

//-----------------------------------------------------------
//
procedure TFrForm.FormCreate(Sender: TObject);
  var i,lim : integer;
begin
  lim := WorkMode.LimitFRI;
  if (lim < 1) or (lim > FR_LIMIT) then lim := FR_LIMIT;
  sgFr.RowCount := lim + 1;
  for i := 1 to lim do sgFr.Cells[0,i] := IntToStr(i);
  sgFr.Cells[0,0] := '№№';
  sgFr.Cells[1,0] := '     FR3';
  sgFr.Cells[2,0] := '     FR4';
  sgFr.Cells[3,0] := '   Имя  ';
  sgFr.ColWidths[0] := 34;
  sgFr.ColWidths[1] := 58;
  sgFr.ColWidths[2] := 58;
  sgFr.ColWidths[3] := 100;
end;

procedure TFrForm.FormActivate(Sender: TObject);
begin
  RefreshFr;
end;

var
  sValue : string;

//--------------------------------------------------------------------------
// обновить таблицу значений FR
procedure TFrForm.RefreshFr;
  var i,lim : integer; b : byte;
begin
  lim := WorkMode.LimitFRI;
  if (lim < 1) or (lim > FR_LIMIT) then lim := FR_LIMIT;
  for i := 1 to lim do
  begin
    b := FR3[i]; sValue := '00000000';
    if (b and 1) = 1 then sValue[8] := '1';
    if (b and 2) = 2 then sValue[7] := '1';
    if (b and 4) = 4 then sValue[6] := '1';
    if (b and 8) = 8 then sValue[5] := '1';
    if (b and $10) = $10 then sValue[4] := '1';
    if (b and $20) = $20 then sValue[3] := '1';
    if (b and $40) = $40 then sValue[2] := '1';
    if (b and $80) = $80 then sValue[1] := '1';
    sgFr.Cells[1,i] := sValue;
    b := FR4[i]; sValue := '00000000';
    if (b and 1) = 1 then sValue[8] := '1';
    if (b and 2) = 2 then sValue[7] := '1';
    if (b and 4) = 4 then sValue[6] := '1';
    if (b and 8) = 8 then sValue[5] := '1';
    if (b and $10) = $10 then sValue[4] := '1';
    if (b and $20) = $20 then sValue[3] := '1';
    if (b and $40) = $40 then sValue[2] := '1';
    if (b and $80) = $80 then sValue[1] := '1';
    sgFr.Cells[2,i] := sValue;
    sgFr.Cells[3,i] := LinkFR[i*8].Name;
  end;
end;

end.
