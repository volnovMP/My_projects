program ARCVIEW;
uses
  ShareMem,
  Windows,
  Forms,
  TabloFormARC in 'TabloFormARC.pas' {TabloMain},
  DirectForm in 'DirectForm.pas' {DirectFormDlg},
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  CMenu in 'E:\SAPR2012\COMMON\CMenu.pas',
  Commands in 'E:\SAPR2012\COMMON\Commands.pas',
  Commons in 'E:\SAPR2012\COMMON\Commons.pas',
  CRCCALC in 'E:\SAPR2012\COMMON\CRCCALC.PAS',
  Load in 'E:\SAPR2012\COMMON\Load.pas',
  MainLoop in 'E:\SAPR2012\COMMON\MainLoop.pas',
  Marshrut in 'E:\SAPR2012\COMMON\Marshrut.pas',
  OBJSOST in 'E:\SAPR2012\COMMON\OBJSOST.PAS',
  TypeALL in 'E:\SAPR2012\COMMON\TypeALL.pas';

{$E exe}
{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TDirectFormDlg, DirectFormDlg);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.Run;
end.
