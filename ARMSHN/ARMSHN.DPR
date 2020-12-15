program ARMSHN;

uses
  ExceptionLog,
  Windows,
  Forms,
  LoadSaveDBS in 'E:\Сапр_new\Commons\LoadSaveDBS.pas',
  CMenu in 'E:\Сапр_new\Commons\CMenu.pas',
  Commands in 'E:\Сапр_new\Commons\Commands.pas',
  Commons in 'E:\Сапр_new\Commons\Commons.pas',
  COMPORT in 'E:\Сапр_new\Commons\COMPORT.PAS',
  CRCCALC in 'E:\Сапр_new\Commons\CRCCALC.PAS',
  KanalArmSrv in 'E:\Сапр_new\Commons\KanalArmSrv.pas',
  MainLoop in 'E:\Сапр_new\Commons\MainLoop.pas',
  Marshrut in 'E:\Сапр_new\Commons\Marshrut.pas',
  TypeALL in 'E:\Сапр_new\Commons\TypeALL.pas',
  Clock in 'Clock.pas' {ClockForm},
  Load in 'E:\Сапр_new\Commons\Load.pas',
  OBJSOST in 'E:\Сапр_new\Commons\OBJSOST.PAS',
  Notify in 'Notify.pas' {NotifyForm},
  ViewFr in 'ViewFr.pas' {FrForm},
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  Password in 'Password.pas' {PasswordDlg},
  ValueList in 'ValueList.pas' {ValueListDlg},
  ViewObj in 'ViewObj.pas' {ViewObjForm},
  TabloSHN in 'TabloSHN.pas' {TabloMain};

{$R *.RES}

var h,o : THandle;

begin
  h := FindWindowEx(0,0,PChar('TTabloMain'+#0),PChar('АРМ ШН - Контроль станции в реальном времени'+#0));
  if h > 0 then
  begin
    o := GetWindow(h,GW_OWNER);
    if o > 0 then
    begin
      SetForegroundWindow(o);
      ShowWindow(o,SW_SHOWNORMAL);
    end;
  end else
  begin
    Application.Initialize;
    Application.Title := 'АРМ ШН';
    Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TClockForm, ClockForm);
  Application.CreateForm(TNotifyForm, NotifyForm);
  Application.CreateForm(TFrForm, FrForm);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TValueListDlg, ValueListDlg);
  Application.CreateForm(TViewObjForm, ViewObjForm);
  Application.Run;
  end;
end.
