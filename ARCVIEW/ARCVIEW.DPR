program ARCVIEW;
uses
  ShareMem,
  Windows,
  Forms,
  TabloFormARC in 'TabloFormARC.pas' {TabloMain},
  Commons in 'D:\SAPR2012\COMMON\Commons.pas',
  MainLoop in 'D:\SAPR2012\COMMON\MainLoop.pas',
  TypeALL in 'D:\SAPR2012\COMMON\TypeALL.pas',
  Commands in 'D:\SAPR2012\COMMON\Commands.pas',
  Marshrut in 'D:\SAPR2012\COMMON\Marshrut.pas',
  Load in 'D:\SAPR2012\COMMON\Load.pas',
  CRCCALC in 'D:\SAPR2012\COMMON\CRCCALC.PAS',
  CMenu in 'D:\SAPR2012\COMMON\CMenu.pas',
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  OBJSOST in 'D:\SAPR2012\COMMON\OBJSOST.PAS',
  DirectForm in 'DirectForm.pas' {DirectFormDlg};

{$E exe}
{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.CreateForm(TDirectFormDlg, DirectFormDlg);
  Application.Run;
end.
