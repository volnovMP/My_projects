program USEC1;
uses
  ShareMem,  ExceptionLog,  Windows,  Forms,  Registry,
  Tabloshn in 'Tabloshn.pas' {TabloMain},
  KanalArmSrvSHN in 'KanalArmSrvSHN.pas',
  ValueList in 'ValueList.pas' {ValueListDlg},
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  Password in 'Password.pas' {PasswordDlg},
  ViewFr in 'ViewFr.pas' {FrForm},
  Clock in 'Clock.pas' {ClockForm},
  ViewObj in 'ViewObj.pas' {ViewObjForm},
  CMenu in 'D:\SAPR2012\COMMON\CMenu.pas',
  Commands in 'D:\SAPR2012\COMMON\Commands.pas',
  Commons in 'D:\SAPR2012\COMMON\Commons.pas',
  CRCCALC in 'D:\SAPR2012\COMMON\CRCCALC.PAS',
  Load in 'D:\SAPR2012\COMMON\Load.pas',
  LoadSaveDBS in 'D:\SAPR2012\COMMON\LoadSaveDBS.pas',
  MainLoop in 'D:\SAPR2012\COMMON\MainLoop.pas',
  Marshrut in 'D:\SAPR2012\COMMON\Marshrut.pas',
  OBJSOST in 'D:\SAPR2012\COMMON\OBJSOST.PAS',
  StanEditTypes in 'D:\SAPR2012\COMMON\StanEditTypes.pas',
  TypeALL in 'D:\SAPR2012\COMMON\TypeALL.pas';

{$R *.res}

begin
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TValueListDlg, ValueListDlg);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TFrForm, FrForm);
  Application.CreateForm(TClockForm, ClockForm);
  Application.CreateForm(TViewObjForm, ViewObjForm);
  Application.Run;
  except
    reportf('������ USEC1');
    Application.Terminate;
  end;
end.
