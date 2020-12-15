program ARCVIEW;

uses
  ExceptionLog,
  Windows,
  Forms,
  PackArmSrv in 'PackArmSrv.pas',
  TabloForm in 'TabloForm.pas' {TabloMain},
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  ValueList in 'ValueList.pas' {ValueListDlg},
  DirectForm in 'DirectForm.pas' {DirectFormDlg},
  Commands in 'E:\Сапр_new\Commons\Commands.pas',
  COMPORT in 'E:\Сапр_new\Commons\COMPORT.PAS',
  CRCCALC in 'E:\Сапр_new\Commons\CRCCALC.PAS',
  Commons in 'E:\Сапр_new\Commons\Commons.pas',
  Marshrut in 'E:\Сапр_new\Commons\Marshrut.pas',
  TypeALL in 'E:\Сапр_new\Commons\TypeALL.pas',
  CMenu in 'E:\Сапр_new\Commons\CMenu.pas',
  Load in 'E:\Сапр_new\Commons\Load.pas',
  OBJSOST in 'E:\Сапр_new\Commons\OBJSOST.PAS',
  MainLoop in 'E:\Сапр_new\Commons\MainLoop.pas';

{$R *.RES}

var h : cardinal;

begin
  h := FindWindowEx(0,0,PChar('TDSPMain'+#0),PChar('Архив системного журнала'+#0));
  if h > 0 then
  begin
    ShowWindow(h,SW_SHOW);
  end else
  begin
    Application.Initialize;
    Application.Title := 'Архив';
    Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TValueListDlg, ValueListDlg);
  Application.CreateForm(TDirectFormDlg, DirectFormDlg);
  Application.Run;
  end;
end.
