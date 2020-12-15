program DSP;

uses
  ShareMem,
  Windows,
  Forms,
  Registry,
  TypeALL in 'D:\SAPR2012\COMMON\TypeALL.pas',
  TabloForm in 'TabloForm.pas' {TabloMain},
  TimeInput in 'TimeInput.pas' {TimeInputDlg},
  Password in 'Password.pas' {PasswordDlg},
  KanalArmSrv in 'KanalArmSrv.pas',
  MsgForm in 'MsgForm.pas' {MsgFormDlg},
  Commands in 'D:\SAPR2012\COMMON\Commands.pas',
  PipeProc in 'D:\SAPR2012\COMMON\PipeProc.pas',
  Commons in 'D:\SAPR2012\COMMON\Commons.pas',
  COMPORT in 'D:\SAPR2012\COMMON\COMPORT.PAS',
  CMenu in 'D:\SAPR2012\COMMON\CMenu.pas',
  CRCCALC in 'D:\SAPR2012\COMMON\CRCCALC.PAS',
  Load in 'D:\SAPR2012\COMMON\Load.pas',
  MainLoop in 'D:\SAPR2012\COMMON\MainLoop.pas',
  LoadSaveDBS in 'D:\SAPR2012\COMMON\LoadSaveDBS.pas',
  Marshrut in 'D:\SAPR2012\COMMON\Marshrut.pas',
  OBJSOST in 'D:\SAPR2012\COMMON\OBJSOST.PAS',
  ViewFr in 'D:\SAPR2012\COMMON\ViewFr.pas' {FrForm},
  ViewOzOv in 'D:\SAPR2012\COMMON\ViewOzOv.pas' {ViewBaza};

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
      Application.CreateForm(TPasswordDlg, PasswordDlg);
      Application.CreateForm(TMsgFormDlg, MsgFormDlg);
      Application.CreateForm(TFrForm, FrForm);
      Application.CreateForm(TViewBaza, ViewBaza);
      Application.Run;
    end;
  end;
end.

