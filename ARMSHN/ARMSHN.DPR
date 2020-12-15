program armshn;

uses
  ShareMem,
  Windows,
  Forms,
  Registry,
  Tabloshn in 'Tabloshn.pas' {TabloMain},
  KanalArmSrvSHN in 'KanalArmSrvSHN.pas',
  Clock in 'Clock.pas' {ClockForm},
  ViewObj in 'ViewObj.pas' {ViewObjForm},
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  Password in 'Password.pas' {PasswordDlg},
  ValueList in 'ValueList.pas' {VlLstDlg},
  CMenu in 'E:\SAPR2012\COMMON\CMenu.pas',
  Commands in 'E:\SAPR2012\COMMON\Commands.pas',
  Commons in 'E:\SAPR2012\COMMON\Commons.pas',
  COMPORT in 'E:\SAPR2012\COMMON\COMPORT.PAS',
  CRCCALC in 'E:\SAPR2012\COMMON\CRCCALC.PAS',
  Load in 'E:\SAPR2012\COMMON\Load.pas',
  MainLoop in 'E:\SAPR2012\COMMON\MainLoop.pas',
  Marshrut in 'E:\SAPR2012\COMMON\Marshrut.pas',
  OBJSOST in 'E:\SAPR2012\COMMON\OBJSOST.PAS',
  TypeALL in 'E:\SAPR2012\COMMON\TypeALL.pas',
  ViewFr in 'E:\SAPR2012\COMMON\ViewFr.pas' {FrForm},
  ViewOzOv in 'E:\SAPR2012\COMMON\ViewOzOv.pas' {ViewBaza};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TClockForm, ClockForm);
  Application.CreateForm(TViewObjForm, ViewObjForm);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TVlLstDlg, VlLstDlg);
  Application.CreateForm(TFrForm, FrForm);
  Application.CreateForm(TViewBaza, ViewBaza);
  Application.Run;
end.
