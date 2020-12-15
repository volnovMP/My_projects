program DSP;

uses
  ShareMem,
  Windows,
  Forms,
  Registry,
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  TimeInput in 'TimeInput.pas' {TimeInputDlg},
  CMenu in 'E:\Сапр_new\Commons\CMenu.pas',
  Commands in 'E:\Сапр_new\Commons\Commands.pas',
  Commons in 'E:\Сапр_new\Commons\Commons.pas',
  COMPORT in 'E:\Сапр_new\Commons\COMPORT.PAS',
  CRCCALC in 'E:\Сапр_new\Commons\CRCCALC.PAS',
  Load in 'E:\Сапр_new\Commons\Load.pas',
  LoadSaveDBS in 'E:\Сапр_new\Commons\LoadSaveDBS.pas',
  MainLoop in 'E:\Сапр_new\Commons\MainLoop.pas',
  Marshrut in 'E:\Сапр_new\Commons\Marshrut.pas',
  OBJSOST in 'E:\Сапр_new\Commons\OBJSOST.PAS',
  TypeALL in 'E:\Сапр_new\Commons\TypeALL.pas',
  KanalArmSrv in 'E:\Сапр_new\Commons\KanalArmSrv.pas',
  TabloForm in 'TabloForm.pas' {TabloMain},
  Password in 'Password.pas' {PasswordDlg},
  ViewFr in 'E:\Сапр_new\Commons\ViewFr.pas' {FrForm},
  ASUProc in 'ASUProc.pas',
  PipeProc in 'E:\Сапр_new\Commons\PipeProc.pas';

{$E exe}

{$R *.RES}

var h,o : THandle; reg : TRegistry;

begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  findSrv := false;
  if Reg.OpenKey('\Software\DSPRPCTUMS', false) then
  begin
    if reg.ValueExists('FindServerForRun')
    then findSrv := reg.ReadBool('FindServerForRun');
    reg.CloseKey;
  end;
  //-------------------- поиск окна программы сервера (объекта класса TStan с именем Stan)
  h := FindWindowEx(0,0,PChar('TStan'+#0),PChar('Stan'+#0));
  if not findSrv or (h > 0) then
  begin //-------------- если запущена программа сервера или не требуется проверка сервера
    h := FindWindowEx(0,0,PChar('TTabloMain'+#0),PChar('Табло'+#0));
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
      Application.Title := 'РМ ДСП';
      Application.CreateForm(TTabloMain, TabloMain);
  Application.CreateForm(TTimeInputDlg, TimeInputDlg);
  Application.CreateForm(TMsgFormDlg, MsgFormDlg);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TFrForm, FrForm);
  Application.Run;
    end;
  end;
end.
