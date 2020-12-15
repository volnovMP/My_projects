unit Clock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TClockForm = class(TForm)
    lbClock: TLabel;
    lbCalendar: TLabel;
    trClock: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure trClockTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClockForm: TClockForm;

implementation

{$R *.dfm}

uses
  TabloSHN;

procedure TClockForm.FormCreate(Sender: TObject);
begin
  Top := Screen.Height - Height - 40;
  Left := 0;
end;

var
  s : string;

procedure TClockForm.trClockTimer(Sender: TObject);
begin
  DateTimeToString(s,'hh:nn:ss', Time);
  lbClock.Caption := s;
  DateTimeToString(s,'dd mmmm yyyy', Date);
  lbCalendar.Caption := s;
end;

procedure TClockForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := IsCloseRMDSP;
end;

end.
