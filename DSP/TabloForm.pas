unit TabloForm;
{$INCLUDE d:\sapr2012\CfgProject} //--------------------------------- параметры компиляции
{$UNDEF SAVEKANAL}     //-------------------------------- сохранять данные каналов в файлы
//**************************************************************************************\\
//                       Главное окно программы РМ-ДСП                                  **
//**************************************************************************************//
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  ImgList,
  Registry,
  Menus,
  MMSystem;

type
  TTabloMain = class(TForm)
    ImageList: TImageList;
    MainTimer: TTimer;
    BeepTimer: TTimer;
    ImageListRU: TImageList;
    ImageList32: TImageList;
    ImageList16: TImageList;
    ImageListIcon: TImageList;
    ASU: TTimer;
    ilGlobus: TImageList;
    ilClock: TImageList;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure DrawTablo(tablo: TBitmap);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure FormActivate(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BeepTimerTimer(Sender: TObject);
    procedure DspPopupHandler(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure ASUTimer(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);


  private
    function RefreshTablo : Boolean; //--------------------------- Обновление образа табло
    procedure SetPlakat(X,Y : integer);
    procedure GetPlakat(X,Y : integer);
    procedure DrawPlakat(X,Y : integer);
  public
    PopupMenuCmd  : TPopupMenu;
    FindCursor    : Boolean; //------------------------------------ включить поиск курсора
    FindCursorCnt : Integer; //-------------------------------- счетчик для поиска курсора
  end;

var
  TabloMain: TTabloMain;

  RefreshTimeOut : Double;       //--- максимальное время ожидания синхронизации из канала
  StartTime      : Double;       //--------------------------------- время запуска системы
  TimeLockCmdDsp : Double;       //------------- время блокирования двойного щелчка мышкой
  IsCloseRMDSP   : Boolean;      //------------ выполнить закрытие главного окна программы
  AppStart       : Boolean;      //---------------- признак старта главного окна программы
  SendToSrvCloseRMDSP : Boolean; //-- послать уведомление серверу о завершении работы АРМа
  SendRestartServera  : Boolean; //---------------- выдать команду на перезагрузку сервера
  OpenMsgForm         : Boolean; //----------------------- Запрос открытия формы сообщений
  shiftscr    : integer; // сдвиг картинки
  GlobusIndex : integer; //

procedure ChangeDirectState(State : Boolean);
procedure ChangeRegion(RU : Byte);
procedure ResetCommands; // сброс всех активных команд
procedure PresetObjParams;
procedure IncrementKOK;

const
  CurTablo1    = 1;
  CurTablo1ok  = 2;
  CurTabloGlas = 3;
  MigInterval : double = 0.5;

  ReportFileName = 'Dsp.rpt';
  KeyName : string = '\Software\DSPRPCTUMS';

implementation

uses
  aclapi,
  accctrl,
  TypeALL,
  crccalc,
  Load,
  KanalArmSrv,
  Objsost,
  Commands,
  Marshrut,
  MainLoop,
  CMenu,
  Commons,
  Comport,
  Password,
  PipeProc,
  MsgForm,
  TimeInput,
  ViewOzOv,
  ViewFr;

{$R *.DFM}
{$R CURSOR.RES}

var
  sMsg,sPar : string; // строковые переменные для всех спроцедур формы
  dMigTablo : Double; // переменная для формирования интервала мигающей индикации табло

  CntSyncCh : integer;
  CntSyncTO : integer;

  fix : integer;

function SetPrivilege(aPrivilegeName : string; aEnabled : boolean ): boolean;
var
  TPPrev, TP : TTokenPrivileges;
  Token      : THandle;
  dwRetLen   : DWord;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token );
  TP.PrivilegeCount := 1;
  if(LookupPrivilegeValue(nil, PChar( aPrivilegeName ), TP.Privileges[ 0 ].LUID ) ) then
  begin
    if( aEnabled )then TP.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED else TP.Privileges[0].Attributes:= 0;
    dwRetLen := 0;
    Result := AdjustTokenPrivileges(Token,False,TP, SizeOf( TPPrev ), TPPrev,dwRetLen );
  end;
  CloseHandle( Token );
end; 
//========================================================================================
procedure TTabloMain.FormDestroy(Sender: TObject);
begin
  if LoopHandle > 0 then
  begin
    LoopSync := false;
    CloseHandle(LoopHandle);
  end; //закрыть поток канала АРМ-Сервер

  DateTimeToString(sMsg, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
  //FixStatKanal(1);
  //FixStatKanal(2);
  reportf('Синхронизаций по каналу   = '+ IntToStr(CntSyncCh));
  reportf('Синхронизаций по таймауту = '+ IntToStr(CntSyncTO));
  reportf('Завершение работы программы '+ sMsg);
  //if Assigned(MsgFormDlg) then
   //MsgFormDlg.Free;
  //if Assigned(TimeInputDlg) then
  //TimeInputDlg.Free;
  reg.Free;
  DestroyKanalSrv;
  if Assigned(Tablo1) then Tablo1.Free;
  if Assigned(Tablo2) then Tablo2.Free;
  if Assigned(ObjectWav) then ObjectWav.Free;
  if Assigned(IpWav) then IpWav.Free;
{$IFNDEF DEBUG}
  if ReBoot then
  begin
    if SetPrivilege('SeShutdownPrivilege', true) then
    begin
      if not ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0) then SimpleBeep;
      SetPrivilege('SeShutdownPrivilege', False);
    end;
    MessageBeep(MB_ICONHAND);
  end;
{$ENDIF}
end;
//========================================================================================
//------------------------------------- Процедура создания главного окна программы АРМ ДСП
procedure TTabloMain.FormCreate(Sender: TObject);
  var
    err: boolean;
    i,h,aiElements,aColors : integer;

begin
  Caption := 'Табло';

  GlobusIndex := 0; //---------------------------------- индекс стартовой картинки глобуса
  ilGlobus.BkColor := armcolor15; //-------------------------фоновый цвет картинки глобуса
  ilClock.BkColor := armcolor15; //--------------------- фоновый цвет картинки таймера МСП

  LockTablo := false; //----------------------------- блокировка табло на время прорисовки
  FormStyle := fsStayOnTop; //-------- если нет отладки - установить окно поверх остальных
  IsCloseRMDSP := false; //---------- признак "выполнить закрытие главного окна программы"
  SendToSrvCloseRMDSP := false; //--- признак "дать сообщеник серверу о конце работы АРМа"
  reg := TRegistry.Create; //-------------------------------- Объект для доступа к реестру
  reg.RootKey := HKEY_LOCAL_MACHINE; //----------------------------- корневой ключ реестра
  //---------------------------------------- Проверить длину файла протокола ошибок работы
  if FileExists(ReportFileName) then    //---------------------ReportFileName = 'Dsp.rpt';
  begin
    h := FileOpen(ReportFileName,fmOpenRead);
    if h > 0 then
    begin
      i := FileSeek(h,0,2); //------------------------------------------ найти конец файла
      if i > 199999 then FileSeek(h,0,0); //-- если файл достиг максимума, встать в начало
      FileClose(h);//-------------------------------------------------------- закрыть файл
    end;
  end;
  DateTimeToString(sMsg, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
  reportf('@');
  reportf('Начало работы программы '+ sMsg);

  PopupMenuCmd := TPopupMenu.Create(self);
  PopupMenuCmd.AutoPopup := false;
  shiftscr := 0;

  err := false;
  if Reg.OpenKey(KeyName, false) then   //--- для АРМ ДСП KeyName = '\Software\DSPRPCTUMS'
  begin
    if reg.ValueExists('databasepath') then
    database    := reg.ReadString('databasepath')
    else begin err := true; reportf('Нет ключа "databasepath"');end;

    if reg.ValueExists('path') then config.path := reg.ReadString('path')
    else begin err := true; reportf('Нет ключа "path"'); end;

    if reg.ValueExists('arcpath') then config.arcpath := reg.ReadString('arcpath')
    else begin err := true; reportf('Нет ключа "arcpath"'); end;

    if reg.ValueExists('ru') then config.ru := reg.ReadInteger('ru')
    else begin err := true; reportf('Нет ключа "ru"'); end;

    if reg.ValueExists('avtodst') then config.avtodst := reg.ReadInteger('avtodst')
    else begin err := true; reportf('Нет ключа "avtodst"'); end;

    {
      if (config.ru < 1) or (config.ru > 3) then config.ru := 1;
      DirState[1] := config.ru;
      config.def_ru := config.ru; //------------------------------- район по предустановке

      if reg.ValueExists('auto') then config.auto := reg.ReadBool('auto')
      else begin err := true; reportf('Нет ключа "auto"'); end;
    }
    if reg.ValueExists('RMID') then config.RMID := reg.ReadInteger('RMID')
    else begin err := true; reportf('Нет ключа "RMID"'); end;

    if reg.ValueExists('Master') then config.Master := true  //----------- мастер сети АСУ
    else if reg.ValueExists('Slave') then config.Slave := true;

    if reg.ValueExists('KOK') then KOKCounter  := reg.ReadInteger('KOK' ) //----- счет КОК
    else begin err := true; reportf('Нет ключа "KOK"'); end;

    if reg.ValueExists('configkanal') then sMsg := reg.ReadString('configkanal')
    else begin err := true; reportf('Нет ключа "configkanal"'); end;

    KanalSrv[1].config := sMsg; KanalSrv[2].config := sMsg;

    //------------------------------------------------------------- труба для связи с STAN
    if reg.ValueExists('namepipein') then KanalSrv[1].nPipe:= reg.ReadString('namepipein')
    else sMsg := '';

    if reg.ValueExists('namepipeout')then KanalSrv[2].nPipe:=reg.ReadString('namepipeout')
    else sMsg := '';

    if (KanalSrv[1].nPipe = '') and (KanalSrv[2].nPipe = '')  then KanalType := 0
    else
    if (KanalSrv[1].nPipe <> 'null') or (KanalSrv[2].nPipe <> 'null') then KanalType := 1
    else
      begin err := true; reportf('Неверно определен тип канала связи с сервером'); end;

    if reg.ValueExists('AnsverTimeOut') then
    AnsverTimeOut := reg.ReadDateTime('AnsverTimeOut')
    else
      begin err := true; reportf('Нет ключа "AnsverTimeOut"'); end;

    if reg.ValueExists('RefreshTimeOut') then
      RefreshTimeOut := reg.ReadDateTime('RefreshTimeOut')
    else
      begin err := true; reportf('Нет ключа "RefreshTimeOut"'); end;

    if reg.ValueExists('TimeOutRdy') then
      MaxTimeOutRecave := reg.ReadDateTime('TimeOutRdy')
    else
      begin err := true; reportf('Нет ключа "TimeOutRdy"'); end;

    if reg.ValueExists('IntervalAutoMarsh') then
      IntervalAutoMarsh := reg.ReadInteger('IntervalAutoMarsh')
    else IntervalAutoMarsh := 15;

    if reg.ValueExists('DiagnozUVK') then DiagnozON := reg.ReadBool('DiagnozUVK')
    else DiagnozON := false;

    if reg.ValueExists('configKRU') then config.configKRU := reg.ReadInteger('configKRU')
    else config.configKRU := 0;

    if reg.ValueExists('N_UVK') then config.N_UVK := reg.ReadInteger('N_UVK')
    else
      begin config.N_UVK :=0; err := true; reportf('Нет ключа "N_UVK"'); end;

    if reg.ValueExists('ServerSync') then WorkMode.ServerSync := true
    else WorkMode.ServerSync := false;

    if reg.ValueExists('SetIkonRez') then SetIkonRezNonOK := true;
    if reg.ValueExists('ASUpipe1')  then sMsg := reg.ReadString('ASUpipe1')
    else sMsg := '';
 {
    if sMsg = '' then //------------------------------ программный канал АСУ1 не определен
    begin  DspToDspEnabled := false; nDspToDspPipe := '';  end
    else //---------------------------------------------- программный канал АСУ1 определен
    begin
      if sMsg[1] = '0' then DspToDspType := 0 //---------------------ДСП(ведущий)-- сервер
      else
      if sMsg[1] = '1' then DspToDspType := 1 //--------------------ДСП(ведомый) -- клиент
      else
      begin err := true; reportf('неверный параметр конфигурации канала АСУ1'); SimpleBeep; end;

      if not err then DspToDspEnabled := true;
      nDspToDspPipe := '';
      for i := 3 to Length(sMsg) do nDspToDspPipe := nDspToDspPipe + sMsg[i];
    end;
}
    if reg.ValueExists('ARCpipe')  then sMsg := reg.ReadString('ARCpipe')
    else sMsg := '';
{
    if sMsg = '' then //------------------ программный канал хранилища архива не определен
    begin
      DspToArcEnabled := false;
      nDspToArcPipe := '';
    end else
    begin //------------------------------------------- программный канал хранилища архива
      DspToArcEnabled := true;
      //---------------------------------- формирование имени для канала "труба ДСП-АРХИВ"
      nDspToArcPipe := '';
      for i := 1 to Length(sMsg) do nDspToArcPipe := nDspToArcPipe + sMsg[i];
    end;
 }
    //------------------------------------------------------------ Технологическая функция
    if reg.ValueExists('SaveArc') then savearc := true;

    DesktopSize.X := Screen.DesktopWidth; //------- получить размер рабочего стола Windows
    DesktopSize.Y := Screen.DesktopHeight;

    if reg.ValueExists('kanal1') then
    begin i := reg.ReadInteger('kanal1'); KanalSrv[1].Index := i; end
    else
    begin KanalSrv[1].Index := 0; err := true; reportf('Нет ключа "kanal1"'); end;

    if reg.ValueExists('kanal2') then
    begin i := reg.ReadInteger('kanal2'); KanalSrv[2].Index := i; end
    else
    begin KanalSrv[2].Index := 0; err := true; reportf('Нет ключа "kanal2"'); end;

    if reg.ValueExists('cur_id') then //-------- Разрешить проверку ключа тестового режима
    config.cur_id := reg.ReadInteger('cur_id')
    else config.cur_id := 0;//------------------ Запретить проверку ключа тестового режима
    reg.CloseKey;

    if not FileExists(database) then
    begin
      err := true;
      reportf('Файл конфигурации базы данных станции не найден.');
    end;
  end else
  begin
    reportf('Нет ключа "DSPRPCTUMS"');
    ShowMessage('Завершение работы из-за обнаружения ошибки при инициализации программы. (Создан файл ошибок DSP.RPT)');
    Application.Terminate;
    exit;
  end;
  Left := 0;
  Top := 0;
  mem_page := false;


  if not InitpSD then //------------ если не удалось создать пустую структуру безопасности
  begin
    err := true;
    reportf('Ошибка инициализации структуры безопасности');
    SimpleBeep;
  end;

  if not InitEventPipes then //-- создать события R/W и внести в асинхр.структуры для труб
  begin err := true; reportf('Ошибка инициализации системных ресурсов'); SimpleBeep; end;

  CreateKanalSrv; //-- создать 1-й и 2-й каналы связи с сервером через СОМ-порты или трубы
  InitKanalSrv(1); //----------------------- инициировать канал 1 через СОМ-порт или трубу
//  InitKanalSrv(2);

  Tablo1 := TBitmap.Create;  //------------------------- создать битовый образ для табло 1
  Tablo2 := TBitmap.Create;  //------------------------- создать битовый образ для табло 2
  ImageList.BkColor   := bkgndcolor; //----------------- установить цвет фона для табличек
  ImageListRU.BkColor := bkgndcolor; //-------- установить цвет фона для режима управления

  screen.Cursors[curTablo1]   := LoadCursor(HInstance, IDC_ARROW);//-- стандартная стрелка
  screen.Cursors[curTablo1ok] := LoadCursor(HInstance, 'CURSOR1OK'); //- своя стрелка с ОК

  //--------------------------------------------------------- Сбросить все пункты ДСП-меню
  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspMenu.obj := -1;

  //---------------------------------------------- сбросить все сообщения с подтверждением
  FixMessage.Count := 0;
  FixMessage.MarkerLine := 1;
  FixMessage.StartLine  := 1;

  //------------------------------- Подготовка структуры вспомогательного перевода стрелок
  VspPerevod.Active := false;
  SyncTime := false;
  OperatorDirect := 0;
  StartObj := 1;
  cntObjZav := 1; cntObjView := 1; cntObjUprav := 1; cntOVBuffer := 1;
  ObjHintIndex := 0;
  LockHint := false;

  StartRM := true; //-------------------------------- выполняются процедуры старта системы

  ObjectWav := TStringList.Create; //----------- создать объект для списка звуковых файлов
  ObjectWav.Add(config.path+'media\sound1.wav');
  ObjectWav.Add(config.path+'media\sound2.wav');
  ObjectWav.Add(config.path+'media\sound3.wav');
  ObjectWav.Add(config.path+'media\sound4.wav');
  ObjectWav.Add(config.path+'media\sound5.wav');
  ObjectWav.Add(config.path+'media\sound6.wav');

  IpWav := TStringList.Create; //--- создать объект для списка звуков участков приближения
  IpWav.Add(config.path+'media\ip1.wav');
  IpWav.Add(config.path+'media\ip2.wav');

  //----------------------------------------------------------------- Загрузка базы данных
  if not LoadBase(database) then err := true;
{$IFNDEF DEBUG}
  if (DesktopSize.X < configru[config.ru].Tablo_Size.X) or
  (DesktopSize.Y < configru[config.ru].Tablo_Size.Y) then
  begin //------------- если мониторов не достаточно для АРМа РМ-ДСП - завершить по ошибке
    reportf('Размер табло ['+ IntToStr(configru[config.ru].Tablo_Size.X)+ 'x'+
    IntToStr(configru[config.ru].Tablo_Size.Y)+'] больше размера рабочего стола Windows!');
    err := true;
  end;
{$ENDIF}
  SetParamTablo; //---------------------------------------------- установить размеры табло

  //--------------------------------------------------- загрузка коротких сообщений РМ-ДСП
  if not LoadLex(config.path + 'LEX.SDB')   then err := true;
  if not LoadLex2(config.path + 'LEX2.SDB') then err := true;
  if not LoadLex3(config.path + 'LEX3.SDB') then err := true;
  if not LoadMsg(config.path + 'MSG.SDB')   then err := true;

  //------ Загрузка структуры АКНР - выполняется после инициализации объектов зависимостей
  if not LoadAKNR(config.path + 'AKNR.SDB') then err := true;

  GetMYTHX;//---------------------------------------------- заполнить индексы объектов MYT

  //--------------------------------------- Установить начальные данные режима работы АРМа
  ResetTrace;

  StateRU  := 0; //------------------------------------- сбросить состояник УВК в исходное
  ArmState := 0; //------------------------------------- сбросить состояник АРМ в исходное
  WorkMode.RazdUpr := false;//-------------------------- исходное управление не раздельное
  WorkMode.MarhUpr := true; //----------------------------- исходное управление маршрутное
  WorkMode.MarhOtm := false; //--------------------------------------- нет отмены маршрута
  WorkMode.VspStr  := false; //--------------------- нет вспомогательного перевода стрелок
  WorkMode.InpOgr  := false; //------------------------------------- нет ввода ограничений
  WorkMode.OtvKom  := false; //--------------------------- нет выдачи ответственных команд
  WorkMode.Podsvet := false; //--------------------------- нет подсветки положения стрелок
  WorkMode.GoTracert  := false; //--------------------------------- нет режима трассировки
  WorkMode.GoOtvKom   := false;//нет выполнения предварительной фазы ответственной команды
  WorkMode.GoMaketSt  := false;//-------------------------- нет установки стрелки на макет
  WorkMode.Upravlenie := false;//----------------------------- АРМ не является управляющим
  WorkMode.LockCmd    := true; //------------------------ нет блокировки управления от АРМ

  MsgFormDlg   := TMsgFormDlg.Create(nil); //-------- создать форму для системного журнала
  TimeInputDlg := TTimeInputDlg.Create(nil); //----------- создать форму для ввода времени
  PasswordDlg  := TPasswordDlg.Create(nil);  //------------ создать форму для ввода пароля
  //--------------------------------------------------- Установить позицию вывода запросов
  PasswordPos.X := configRU[config.ru].MsgLeft+1;//--------------- позиция окна для пароля
  PasswordPos.Y := configRU[config.ru].MsgTop+1;
  TimeInputPos.X := configRU[config.ru].MsgLeft+1; //------ позиция окна для ввода времени
  TimeInputPos.Y := configRU[config.ru].MsgTop+1;

  //hWaitKanal := CreateEvent(nil,false,false,nil);  //----- создать событие ожидания канала
  IsBreakKanalASU := false; //------- сбросить признак завершения обслуживания каналов АСУ

  if err then //-------если возникли ошибки при чтении реестра или инициализации программы
  begin
    ShowMessage('Конец работы из-за ошибки при инициализации.Создан файл ошибок DSP.RPT');
    Application.Terminate;
  end;

  aiElements := COLOR_MENU;
  aColors := armcolor7;
  SetSysColors(1,aiElements,aColors);
  AppStart := true;
end;
//========================================================================================
//---------------------------------------------------------------------- Активизация табло
procedure TTabloMain.FormActivate(Sender: TObject);
  var Dummy : Cardinal;
begin
  if not AppStart then exit; // если нет признака старта главного окна программы, то конец
  InsNewArmCmd($7ffb,0); //--------- иначе внести в архив код $7ffb (Начало работы РМ ДСП)
{$IFNDEF DEBUG}
  ShowWindow(Application.Handle,SW_HIDE);//----------------------------------- скрыть окно
{$ENDIF}
  AppStart := false; //-------------------------------- сбросить признак старта приложения
  //------------------------------------------------ первичная инициализация главного окна
  PresetObjParams; //----- Установить параметры объектов зависимостей в исходное состояние
  Screen.Cursor := curTablo1; //-------------- установить курсор обычного вида (стрелочка)
  FindCursor := false; //-------------------------------- отключить признак поиска курсора
  FindCursorCnt := 0; //---------------------------------- сбросить счетчик поиска курсора
  DrawTablo(Tablo1); //------------------------------------------------ нарисовать табло 1
  DrawTablo(Tablo2); //------------------------------------------------ нарисовать табло 2

  if config.cur_id = 1 then //------------------------------ если курсор имеет обычный вид
  begin
  //-------------------------------------------- Проверить разрешение на тестовую проверку
    if FileExists('c:/0000000-1a47jdv-kbmndws.ini') then //если существует такой файл на а:
    begin //------------------------------ Получено подтверждение режима тестовой проверки
      asTestMode := $aa;
    end
    else asTestMode := $55;
  end
  else
  asTestMode := $55;
  //--------------------------------------------------------------------------------------
  if DspToDspEnabled then
  begin //------------------------------ старт процесса обработки программного канала АСУ1
    case DspToDspType of //------------------------- переключатель определения типа РМ ДСП
      1 :                //---------------------------------------- если данный ДСП-клиент
        DspToDspThread := //----------------------------- создать поток для канала клиента
        CreateThread(nil,0,@DspToDspClientProc,DspToDspParam,0,DspToDspThreadID);//клиент1
      else              //----------------------------------------- если данный ДСП-сервер
        DspToDspThread := //----------------------------- создать поток для канала сервера
        CreateThread(nil,0,@DspToDspServerProc,DspToDspParam,0,DspToDspThreadID);//сервер1
    end;
    if DspToDspThread = 0 then reportf('Ошибка создания процесса обработки канала АСУ1.')
    else reportf('Начало обработки канала АСУ1.');
  end;


  if DspToArcEnabled then  //------------------------ если требуется связать ДСП с Архивом
  begin //------------------ старт процесса обработки программного канала хранилища архива
    DspToArcThread := //------------------------------------------------------ клиент АСУ1
    CreateThread(nil,0,@DspToARCProc,DspToArcParam,0,DspToArcThreadID);
    if DspToArcThread = 0 then
      reportf('Ошибка создания процесса обработки канала хранилища удаленного архива.')
    else
      reportf('Начало обработки канала хранилища удаленного архива.');
  end;

  //- Установить периодичность обработки событий канала АСУ в зависимости от приоритета РМ
  if config.Master then ASU.Interval := 799 else  //---------- если АРМ ведущий в паре АСУ
  if config.Slave then ASU.Interval := 1099; //-------------------------- если АРМ ведомый

  MainTimer.Enabled := true; //---------------------------------- запустить главный таймер
  LastRcv := Date+Time; //----------------------------- фиксируем момент последнего приема
  dMigTablo := Date+Time;  //------------------------- фиксируем момент последнего мигания
  if config.auto then
  SendCommandToSrv(WorkMode.DirectStateSoob,cmdfr3_directdef,0);//автозапрос на управление
  CmdSendT := Date + Time;   // начать отсчет времени жизни каманды автозахвата управления
  StartTime := CmdSendT;     //------------------------------------- момент запуска РМ-ДСП
  LastReper := Date + Time;  //------------ начать отсчет 10-ти минутных архивов состояний
  SendRestartServera := false; //------------------------- сброс признака рестарта сервера
  LockTablo := false;   //--------------------- сброс блокировки табло на время прорисовки
  LockCommandDsp := false;//сброс блок. дейст.оператора на время восприятия предупреждения
  // создать поток обслуживания канала АРМ - Сервер и начать синхронизацию
  LoopSync := true;  //--------- установить признак обслуживания каналов обмена с сервером

  LoopHandle := //------------------------------создать поток, начать обслуживание каналов
  CreateThread(nil,0,@SyncReadyThread,nil,0,Dummy);
  if LoopHandle > 0 then  //------------------ если поток удачно создан и запущен в работу
  begin
    reportf('Поток обработки канала АРМ-Сервер запущен. ThreadID='+IntToStr(Dummy));
    ConnectKanalSrv(1); //-------------------------------- создать подключение по каналу 1
    //ConnectKanalSrv(2);
  end else
  begin
    reportf('Ошибка инициализации потока обработки канала АРМ-Сервер. Аварийное завершение работы программы.');
    Application.Terminate;
  end;
  ReBoot := true;
end;
//========================================================================================
//-------- процедура постановки в очередь и предварительных действий перед закрытием формы
procedure TTabloMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ec : cardinal;
begin
  if WorkMode.Upravlenie and ((StateRU and $40) = $40) then
  begin
  //-- при включенном управлении с АРМа и включенном сервере не завершать работу программы
    if (LastRcv + MaxTimeOutRecave) > LastTime then
    begin CanClose := false;  exit; end;
  end;

  if IsCloseRMDSP then
  begin //----------------------------------- получено разрешение завершения работы РМ-ДСП
    DisconnectKanalSrv(1);
    //DisconnectKanalSrv(2);
    MainTimer.Enabled := false; //------------------------------ остановить главный таймер
    BeepTimer.Enabled := false; //-------------------- остановить таймер звуковых сигналов

    if DspToDspEnabled then
    begin
      if GetExitCodeThread(DspToDspThread,ec) then //---- проверить поток обмена с соседом
      begin
        if ec=STILL_ACTIVE then canClose:=false //не завершать,дока работает поток ДСП-ДСП
        else canClose := true;
      end
      else canClose := false;
    end
    else canClose := true;

    if canClose then
    begin
      if DspToArcEnabled then
      begin
        if GetExitCodeThread(DspToArcThread,ec) then //-- проверить поток обмена с архивом
        begin
          if ec=STILL_ACTIVE
          then canClose:=false;//-------------- не завершать пока работает поток ДСП-АРХИВ
        end
        else canClose := false;
      end;
    end;

  // MainLoopState := 1; //----------------------- завершить обработку главного цикла ?????
    ReBoot := not CanClose;
    exit;
  end
  else
  if not SendToSrvCloseRMDSP then //------------------ если серверу не передавался останов
  begin
    ShowWindow(Application.Handle,SW_SHOW); // активизировать и отобразить окно приложения
    if PasswordDlg.ShowModal = mrOk then
    begin
      InsArcNewMsg(0,89,7); //----------------------- "Ожидается завершение работы РМ ДСП"
      ShowShortMsg(89,LastX,LastY,'');
      SendCommandToSrv(WorkMode.DirectStateSoob,cmdfr3_logoff,0);  //--- остановить сервер
      SendToSrvCloseRMDSP := true; //------- фиксируем передачу останова в серверную часть
      StopAll := 15;
    end;
    ShowWindow(Application.Handle,SW_HIDE);
  end;
  CanClose := false;
end;

procedure TTabloMain.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if not mem_page
  then Canvas.Draw(-shiftscr,0,tablo2)
  else Canvas.Draw(-shiftscr,0,tablo1);
end;

//----------------------------------------------------------------------------------------
//---------------------------------------------- прорисовка на экране элементов управления
procedure TTabloMain.FormPaint(Sender: TObject);
var
  i,x,y : integer;
  p : TPoint;
  n : Boolean;
begin
  try
    n := false;

    for i := 1 to 20 do if stellaj[i] then begin n := true; break; end;

    if IkonkaMove or n then
    begin
      GetCursorPos(p);
      canvas.DrawFocusRect(rect(p.X+IkonkaDeltaX,p.Y+
      IkonkaDeltaY,p.X+12++IkonkaDeltaX,p.Y+12++IkonkaDeltaY));
    end;

    //------------------------------------------------------ Прорисовка фокуса на объектах
    if (cur_obj > 0) and (cur_obj < 20000) and (ObjUprav[cur_obj].MenuID > 0) then
    with canvas do
    begin
      Pen.Color := clRed; Pen.Mode := pmCopy; Pen.Width := 1;
      MoveTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Top);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftscr, ObjUprav[cur_obj].Box.Top);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftscr, ObjUprav[cur_obj].Box.Bottom);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Bottom);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Top);
    end;

    if not LockHint then
    begin
      //----------------------------------------------------------- вывод описания объекта
      if ((LastTime - LastMove) > (1/86400)) and
      (ObjUprav[cur_obj].Hint <> '') and
      (ObjHintIndex = 0) then
      begin
        ObjHintIndex := cur_obj;
        i := LastX div configru[config.ru].MonSize.X + 1;
        shortmsg[i] := ObjUprav[cur_obj].Hint;
        shortmsgcolor[i] := bkgndcolor;
      end else
      if (ObjHintIndex > 0) and ((LastTime - LastMove) > (30/86400)) then
      begin
        if tab_page then begin  ResetShortMsg; ObjHintIndex := cur_obj; end
        else
        begin
          i := LastX div configru[config.ru].MonSize.X + 1;
          shortmsg[i] := ObjUprav[cur_obj].Hint;
          shortmsgcolor[i] := bkgndcolor;
        end;
      end;
    end;

    x := configRU[config.ru].MonSize.X;
    if configRU[config.ru].Tablo_Size.X < x
    then x := configRU[config.ru].Tablo_Size.X;
    y := configRU[config.ru].Tablo_Size.Y;

    for i := 1 to High(shortmsg) do
    begin
      canvas.Brush.Style := bsSolid;
      canvas.Font.Style := [];
      if shortmsg[i] <> '' then
      begin
        //---------------------------------------------------- Вывести короткие сообщения
        canvas.Brush.Color := shortmsgcolor[i];
        if canvas.Brush.Color = 0 then
        canvas.Brush.Color := bkgndcolor;
        canvas.FillRect(rect((i-1)*X, Y-15, i*X-32, Y));
        if canvas.Brush.Color <> 255 then canvas.Font.Color  := clBlack
        else canvas.Font.Color  := clWhite;
        TekFontSize := canvas.Font.Size;
        canvas.Font.Size := 10;
        canvas.TextOut((i-1)*X+3, Y-15,shortmsg[i]);//-------------------- вывод сообщения
        canvas.Brush.Color := clWhite; canvas.FillRect(rect(i*X-32, Y-15, i*X-16, Y));
        canvas.Brush.Color := clRed; canvas.FillRect(rect(i*X-31, Y-14, i*X-27, Y-1));
        canvas.Brush.Color := clGreen; canvas.FillRect(rect(i*X-26, Y-14, i*X-22, Y-1));
        canvas.Brush.Color := clBlue; canvas.FillRect(rect(i*X-21, Y-14, i*X-17, Y-1));
        canvas.Font.Size := TekFontSize;
        if (ObjHintIndex > 0) and ((LastTime - LastMove) < (30/86400)) then
        begin ImageList16.Draw(canvas,i*X-16, Y-15,1); end
        else
        if ShowWarning then
        begin
          if tab_page then ImageList16.Draw(canvas,i*X-16, Y-15,5)
          else ImageList16.Draw(canvas,i*X-16, Y-15,0);
        end
        else begin ilGlobus.Draw(canvas, i*X-16, Y-15, GlobusIndex); end;
      end else
      begin
        canvas.Brush.Color := bkgndcolor; canvas.FillRect(rect((i-1)*X, Y-15, i*X-32, Y));
        canvas.Brush.Color := clWhite; canvas.FillRect(rect(i*X-32, Y-15, i*X-16, Y));
        canvas.Brush.Color := clRed; canvas.FillRect(rect(i*X-31, Y-14, i*X-27, Y-1));
        canvas.Brush.Color := clGreen; canvas.FillRect(rect(i*X-26, Y-14, i*X-22, Y-1));
        canvas.Brush.Color := clBlue; canvas.FillRect(rect(i*X-21, Y-14, i*X-17, Y-1));
        ilGlobus.Draw(canvas, i*X-16, Y-15, GlobusIndex);
      end;
    end;
  

    //------------------------------------------------------------- поиск курсора на табло
    if FindCursor then
    begin
      GetCursorPos(p); //----------------- получить позицию курсора в формате точки p(x,y)
      if FindCursorCnt >= 100 then
      begin //------------------------------------------------------ продолжить бег кругов
        canvas.Pen.Color := clWhite;
        canvas.Pen.Width := 3;
        canvas.Pen.Mode := pmNotMask;
        canvas.Pen.Style := psSolid;
        canvas.Brush.Style := bsClear;
        canvas.Ellipse(p.X-FindCursorCnt,p.Y-FindCursorCnt,p.X+FindCursorCnt,p.Y+FindCursorCnt);
        FindCursorCnt := FindCursorCnt - 100;

        if FindCursorCnt > 0 then
        begin
          canvas.Ellipse(p.X-FindCursorCnt,p.Y-FindCursorCnt,p.X+FindCursorCnt,p.Y+FindCursorCnt);
          FindCursorCnt := FindCursorCnt - 100;
          if FindCursorCnt > 0 then
          begin
            canvas.Ellipse(p.X-FindCursorCnt,p.Y-FindCursorCnt,p.X+FindCursorCnt,p.Y+FindCursorCnt);
            FindCursorCnt := FindCursorCnt - 100;
            if FindCursorCnt > 0 then
            begin
              canvas.Ellipse(p.X-FindCursorCnt,p.Y-FindCursorCnt,p.X+FindCursorCnt,p.Y+FindCursorCnt);
              if FindCursorCnt< 100 then begin FindCursor:=false; FindCursorCnt := 0; end;
            end;
          end
          else begin FindCursor := false; FindCursorCnt := 0; end;
        end else begin FindCursor := false; FindCursorCnt := 0; end;
      end  else
      begin FindCursor := false; FindCursorCnt := 0; end; //--------- завершить бег кругов
    end;
  except
    reportf('Ошибка [TabloForm.FormPaint]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------ теневая подготовка образа табло для вывода на экран
procedure TTabloMain.DrawTablo(tablo: TBitmap);
var
  i,x,y,c : integer;
  OldColor : TColor;
begin
  try
    if not Assigned(tablo) then
    begin
      reportf('Не инициализирован указатель перед вызовом процедуры [DrawTablo]');
      Application.Terminate;
      exit;
    end;
  fix := 1;
  Tablo.Canvas.Lock;
  with tablo.Canvas do
  begin
    Brush.Color := bkgndcolor;
    Brush.Style := bsSolid;
    FillRect(rect(0, 0, tablo.width, tablo.height));
  end;
  OldColor := shortmsgcolor[1];
  if FixMessage.Count > 0 then
  begin
  //--------------------------------------------------- Нарисовать фиксированные сообщения
    fix := 2;
    x := configRU[config.ru].MsgLeft; y := configRU[config.ru].MsgTop;
    c := FixMessage.Count - FixMessage.StartLine;
    Tablo.Canvas.Font.Size := 8;
    if c > 4 then c := 4;
    for i := FixMessage.StartLine to FixMessage.StartLine + c do
    begin
      Tablo.Canvas.Font.Color := FixMessage.Color[i];
      if i = FixMessage.MarkerLine then Tablo.Canvas.Brush.Color := focuscolor
      else Tablo.Canvas.Brush.Color := bkgndcolor;
      Tablo.Canvas.FillRect(rect(x,y,configRU[config.ru].MsgRight,y+16));
      Tablo.Canvas.TextOut(x+2,y,FixMessage.Msg[i]);
      y := y + 16;
    end;
    if FixMessage.Count > 5 then
    begin // отобразить полосу прокрутки фиксированных сообщений
      fix := 3;
      Tablo.Canvas.Brush.Color := bkgndcolor;
      Tablo.Canvas.Rectangle(configRU[config.ru].MsgRight-10,
      configRU[config.ru].MsgTop,
      configRU[config.ru].MsgRight,
      configRU[config.ru].MsgBottom);
      //Tablo.Canvas.Brush.Color := Tablo.Canvas.Pen.Color;
      if FixMessage.StartLine > 1 then
      begin
        Tablo.Canvas.Polygon(
        [Point(configRU[config.ru].MsgRight-9,configRU[config.ru].MsgTop+10),
        Point(configRU[config.ru].MsgRight-1, configRU[config.ru].MsgTop+10),
        Point(configRU[config.ru].MsgRight-5, configRU[config.ru].MsgTop+1)]);
      end;
      if (FixMessage.Count - FixMessage.StartLine) > 4 then
      begin
        Tablo.Canvas.Polygon(
        [Point(configRU[config.ru].MsgRight-9,configRU[config.ru].MsgBottom-10),
         Point(configRU[config.ru].MsgRight-1,configRU[config.ru].MsgBottom-10),
         Point(configRU[config.ru].MsgRight-5,configRU[config.ru].MsgBottom-1)]);
      end;
    end;
  end;
shortmsgcolor[1] := OldColor;

  //--------------------------------------------------------- прорисовка полки со значками
  fix := 4;
  Tablo.Canvas.Pen.Color := armcolor8;
  Tablo.Canvas.Brush.Color := armcolor18;
  Tablo.Canvas.Pen.Style := psSolid;
  Tablo.Canvas.Pen.Width := 2;

  Tablo.Canvas.Rectangle(configRU[config.ru].BoxLeft,configRU[config.ru].BoxTop,
  configRU[config.ru].BoxLeft+12*20+7,configRU[config.ru].BoxTop+16);
  for i := 0 to 19 do
  begin
    x := 1 + i * 12; if i > 10 then x := x + 3;
    case i of
        1 : y := 14;  2 : y := 15;  3 : y := 16;  4 : y := 17;  5 : y := 18;
        6 : y := 19;  7 : y := 20;  8 : y := 21;  9 : y := 22; 10 : y := 23;
       11 : y := 4;  12 : y := 5;  13 : y := 6;  14 : y := 7;  15 : y := 8;
       16 : y := 9;  17 : y := 10; 18 : y := 11; 19 : y := 12;
    else
      y := 13;
    end;
    ImageList.Draw(Tablo.Canvas,configRU[config.ru].BoxLeft+x,
    configRU[config.ru].BoxTop+1,y, Stellaj[i+1]);
  end;

  //------------------------------------------------------------- прорисовка иконок в поле
  fix := 5;
  case config.ru of
    1 :
    begin //-------------------------------------------------------------------------- RU1
      for i := 1 to High(Ikonki) do
      begin
        if (Ikonki[i,1] > 0) then
        ImageList.Draw(Tablo.Canvas,Ikonki[i,2],Ikonki[i,3],Ikonki[i,1],true);
      end;
    end;
    2 :
    begin //-------------------------------------------------------------------------- RU2
      for i := 1 to High(Ikonki2) do
      begin
        if (Ikonki2[i,1] > 0) then
        ImageList.Draw(Tablo.Canvas,Ikonki2[i,2],Ikonki2[i,3],Ikonki2[i,1],true);
      end;
    end;
  end;

  // Из за ошибки в драйвере видеоадаптера WinXP приходится проделывать следующие действия:
  fix := 6;
  Tablo.Canvas.Brush.Style := bsClear;
  Tablo.Canvas.Font.Color := clRed;
  Tablo.Canvas.Font.Color := clBlack;
  //-------------------------------------------- конец программы, устраняющей ошибку WinXP

  //------------------------------------------ прорисовка всех отображающих объектов табло
  fix := 7;
  c := 0;
  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 0)
    then DisplayItemTablo(@ObjView[i], Tablo.Canvas);
    inc(c);
    if c > 300 then
    begin
      SyncReady;
      WaitForSingleObject(hWaitKanal,INFINITE); //ChTO);
      c := 0;
    end;
  end;

  fix := 8;
  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 1) then
    DisplayItemTablo(@ObjView[i], Tablo.Canvas);
    inc(c);
    if c > 300 then
    begin
      SyncReady;
      WaitForSingleObject(hWaitKanal,ChTO);
      c := 0;
    end;
  end;

  fix := 9;
  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 2) then
    DisplayItemTablo(@ObjView[i], Tablo.Canvas);
    inc(c);
    if c > 300 then
    begin
      SyncReady;
      WaitForSingleObject(hWaitKanal,ChTO);
      c := 0;
    end;
  end;

  // Прорисовка границ экранов
  fix := 10;
  with Tablo.Canvas do
  begin
    Pen.Color := clDkGray;
    Pen.Width := 1;
    Brush.Style := bsClear;
    Pen.Style := psSolid;
    Rectangle(configRU[config.ru].MsgLeft,
    configRU[config.ru].MsgTop,
    configRU[config.ru].MsgRight,
    configRU[config.ru].MsgBottom);
    Pen.Color := armcolor12;
    Pen.Width := 2;
    for i := 1 to (configRU[config.ru].Tablo_Size.X div configRU[config.ru].MonSize.X)-1 do
    begin
      MoveTo(i*configRU[config.ru].MonSize.X,0);
      LineTo(i*configRU[config.ru].MonSize.X,configRU[config.ru].MonSize.Y);
    end;
    Pen.Color := clDkGray;
    Pen.Width := 1;
    MoveTo(0,Tablo.Height-1);
    LineTo(Tablo.Width,Tablo.Height-1);
  end;

  Tablo.Canvas.UnLock;
  except
    reportf('Ошибка [TabloForm.DrawTablo] fix='+ IntToStr(fix)); Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------------------- процедура обработки нажатия правой кнопки мыши
procedure TTabloMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetPlakat(X,Y); //----------------- получить параметры перемещаемого плаката (если есть)
  OperatorDirect := LastTime + 1/86400;
  if MarhTracert[1].TraceRazdel then ResetTrace;//----- сбросить трассу раздельного режима
end;
//=======================================================================================
//------------------------------------------ процедура обработки перемещения курсора мышки
procedure TTabloMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i,o: integer;
begin
  OperatorDirect := LastTime + 1/86400;

  if PopupMenuCmd.PopupComponent <> nil then exit;// прервать если на экране выведено меню

  if IkonkaDown > 0 then   //------------------------- если выбрана иконка для перемещения
  if not SetIkonRezNonOK and //------- если запрещена установка иконок на резервном АРМе и
  not WorkMode.OtvKom and //----------------------- АРМ не в режиме ответственных команд и
  not WorkMode.Upravlenie then //------------------ АРМ не в режиме основного управляющего
  begin //---------------------------------------------- все связанное с иконками сбросить
    for i := 1 to High(Stellaj) do stellaj[i] := false;
    IkonkaMove := false; IkonkaMoved := false; IkonkaDown := 0;
    IkonkaDeltaX := 0;
    IkonkaDeltaY := 0;
  end
  else  IkonkaMoved := true; //--------------------------- иначе разрешить движение иконки

  if ObjHintIndex > 0 then //------------------------ если ранее курсор указывал на объект
  begin ResetShortMsg; ObjHintIndex := 0; end;

  LastMove := Date+Time; //----------------------------------- фиксируем время перемещения
  LastX := x;   LastY := y;
  o := cur_obj;//---------------------------------------------- Номер объекта зависимостей
  cur_obj := -1; //-------------------------------------------- сброс объекта под курсором

  //-------------------------------------------------- проход по всем управляющим объектам
  for i := configRU[config.ru].OUmin to configRU[config.ru].OUmax do
  begin
    if (x+shiftscr >= ObjUprav[i].Box.Left) and //----- если курсор в зоне захвата объекта
    (y >= ObjUprav[i].Box.Top) and
    (x+shiftscr <= ObjUprav[i].Box.Right) and
    (y <= ObjUprav[i].Box.Bottom) then
    begin
      cur_obj := i;
      ID_obj := ObjUprav[i].IndexObj;
      ID_menu := ObjUprav[i].MenuID;
      break;
    end;
  end;

  if o <> cur_obj then
  begin
    canvas.Pen.Width := 1;
    if (o > 0) and (o < 20000) then
    with canvas do  //---------------- стереть прямоугольник с прежнего объекта управления
    begin
      Pen.Color := bkgndcolor;
      Pen.Mode := pmCopy;
      MoveTo(ObjUprav[o].Box.Left-shiftscr, ObjUprav[o].Box.Top);
      LineTo(ObjUprav[o].Box.Right-shiftscr, ObjUprav[o].Box.Top);
      LineTo(ObjUprav[o].Box.Right-shiftscr, ObjUprav[o].Box.Bottom);
      LineTo(ObjUprav[o].Box.Left-shiftscr, ObjUprav[o].Box.Bottom);
      LineTo(ObjUprav[o].Box.Left-shiftscr, ObjUprav[o].Box.Top);
    end;
    if (cur_obj > 0) and (ObjUprav[cur_obj].MenuID > 0) then
    with canvas do //---------------- нарисовать прямоугольник на новом объекте управления
    begin
      Pen.Color := clRed; Pen.Mode := pmCopy;
      MoveTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Top);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftscr, ObjUprav[cur_obj].Box.Top);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftscr, ObjUprav[cur_obj].Box.Bottom);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Bottom);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftscr, ObjUprav[cur_obj].Box.Top);
    end else
    begin
      ID_obj := -1;
      ID_menu := -1;
    end;
  end;
end;

//========================================================================================
//------------------------------------------------- Обработка события выбора пункта в меню
procedure TTabloMain.DspPopupHandler(Sender: TObject);
var
  i : integer;
begin
  try
    with Sender as TMenuItem do
    begin
      for i := 1 to Length(DspMenu.Items) do
      if DspMenu.Items[i].ID = Command then
      begin
        DspCommand.Command := DspMenu.Items[i].Command;
        DspCommand.Obj := DspMenu.Items[i].Obj;
        DspCommand.Active  := true;
        SelectCommand;
     
        if cur_obj > 0 then
        SetCursorPos(ObjUPrav[cur_obj].Box.Right-2, ObjUPrav[cur_obj].Box.Bottom-2);
        exit;
      end;
    end;
  except
    reportf('Ошибка [TabloForm.TTabloMain.DspPopupHandler]'); Application.Terminate;
  end;
end;
//========================================================================================
procedure TTabloMain.Edit1Change(Sender: TObject);
begin
{$IFDEF TEST_DANN}
  testObj :=  StrToInt(TabloMain.Edit1.Text);
{$endif}
end;
//========================================================================================
//---------------------------------------------------------------- процедура сброса команд
procedure ResetCommands;
begin
  DspMenu.Ready := false; //--------------------------------------- сброс ожидания команды
  DspMenu.WC := false;  //--------------------------- сброс ожидания подтверждения команды
  DspCommand.Active := false; //--------------------------------- сброс активности команды
  DspMenu.obj := -1; //----------------------------------------- сброс объекта для команды
  ResetTrace; //---------------------------------------------- Сбросить набираемый маршрут
  WorkMode.GoMaketSt := false; //---------------------------------- установки на макет нет
  WorkMode.GoOtvKom := false; //--------------------------- ввода ответственных команд нет
  Workmode.MarhOtm := false; //--------------------------------------- отмены маршрута нет
  Workmode.VspStr := false; //---------------------- вспомогательного перевода стрелки нет
  Workmode.InpOgr := false; //-------------------------------------- ввода ограничений нет
  if OtvCommand.Active then //---- если на момент сбоса была активна ответственная команда
  begin
    InsNewArmCmd(0,0);
    OtvCommand.Active := false;
    InsArcNewMsg(0,156,1);  //----------------------- "ввод ответственной команды прерван"
    showShortMsg(156,LastX,LastY,'');
  end else
  if VspPerevod.Active then //--------- если активизирован вспомогательный перевод стрелки
  begin
    InsNewArmCmd(0,0);
    VspPerevod.Cmd := 0;
    VspPerevod.Strelka := 0;
    VspPerevod.Reper := 0;
    VspPerevod.Active := false;
    InsArcNewMsg(0,149,1); //---------------------- "Отменено ожидание нажатия кнопки ВСП"
    showShortMsg(149,LastX,LastY,'');
  end
  else ResetShortMsg; //---------------------------------- Сбросить все короткие сообщения
end;

//========================================================================================
//------------------------------------------------------------- работа с ярлыками на табло
procedure TTabloMain.SetPlakat(X,Y : integer);
  var i,j,dx : integer; uu : boolean;
begin
  if not SetIkonRezNonOK and not WorkMode.OtvKom and not WorkMode.Upravlenie then
  begin
    for i := 1 to High(Stellaj) do stellaj[i] := false;
    IkonkaMove := false;
    IkonkaMoved := false;
    IkonkaDown := 0;
    IkonkaDeltaX := 0;
    IkonkaDeltaY := 0;
    exit;
  end;
  uu := false;

  for j := 0 to 19 do
  begin
    dx := j * 12 + 1; if j > 10 then dx := dx + 3;
    if (X >= configRU[config.ru].BoxLeft+dx) and
    (Y >= configRU[config.ru].BoxTop) and
    (X < configRU[config.ru].BoxLeft+dx+12) and
    (Y < configRU[config.ru].BoxTop+13) then
    begin
      for i := 1 to 20 do
      if i <> (j+1) then stellaj[i] := false
      else stellaj[i] := not stellaj[i];
      uu := true;
      IkonkaDeltaX := 0;
      IkonkaDeltaY := 0;
    end;
  end;
  if ((X+12+IkonkaDeltaX) >= configRU[config.ru].BoxLeft) and
  ((Y+12+IkonkaDeltaY) >= configRU[config.ru].BoxTop) and
  ((X+IkonkaDeltaX) < configRU[config.ru].BoxLeft+12*20+7) and
  ((Y+IkonkaDeltaY) < configRU[config.ru].BoxTop+16) then
  begin //------------------------------ проверить зону чувствительности полки с плакатами
    uu := true;
    for i := 1 to 20 do stellaj[i] := false;
  end;
  if not uu then
  begin
    //----------------------------------------------------------------- поиск вида плаката
    j := 0;

    for i := 1 to High(Stellaj) do //------------------------ пройтись по стелажу табличек
    if stellaj[i] then //---------------------------- если есть выделенная табличка-плакат
    begin
      j := i;  //-------------------------------------- получить номер выделенного плаката
      break;
    end;

    if j > 0 then //------------------------------------------- если есть выбранный плакат
    begin //------------------------------------------------------------ установить плакат
      case config.ru of
        1 :
        begin //---------------------------------------------------------------------- RU1
          for i := 1 to High(Ikonki) do  //----- ищем в массиве иконок ближайшую свободную
          begin
            if Ikonki[i,1] = 0 then
            begin //-------------------------------------------- поместить иконку на табло
              IkonNew := true;
              IkonSend := true;
              case j of         //--------------------- находим код изображения для иконки
                1  : Ikonki[i,1] := 13;
                2  : Ikonki[i,1] := 14;
                3  : Ikonki[i,1] := 15;
                4  : Ikonki[i,1] := 16;
                5  : Ikonki[i,1] := 17;
                6  : Ikonki[i,1] := 18;
                7  : Ikonki[i,1] := 19;
                8  : Ikonki[i,1] := 20;
                9  : Ikonki[i,1] := 21;
                10 : Ikonki[i,1] := 22;
                11 : Ikonki[i,1] := 23;
                12 : Ikonki[i,1] := 4;
                13 : Ikonki[i,1] := 5;
                14 : Ikonki[i,1] := 6;
                15 : Ikonki[i,1] := 7;
                16 : Ikonki[i,1] := 8;
                17 : Ikonki[i,1] := 9;
                18 : Ikonki[i,1] := 10;
                19 : Ikonki[i,1] := 11;
                20 : Ikonki[i,1] := 12;
              end;
              Ikonki[i,2] := X; Ikonki[i,3] := Y; //------------------ ставим координаты
              uu := true;
              break;
            end;
          end;
        end;

        2 :
        begin //-------------------------------------------------------------------- RU2
          for i := 1 to High(Ikonki) do
          begin
            if Ikonki2[i,1] = 0 then
            begin //-------------------------------------------- поместить иконку на табло
              IkonNew := true;
              IkonSend := true;
              case j of
                1  : Ikonki2[i,1] := 13;
                2  : Ikonki2[i,1] := 14;
                3  : Ikonki2[i,1] := 15;
                4  : Ikonki2[i,1] := 16;
                5  : Ikonki2[i,1] := 17;
                6  : Ikonki2[i,1] := 18;
                7  : Ikonki2[i,1] := 19;
                8  : Ikonki2[i,1] := 20;
                9  : Ikonki2[i,1] := 21;
                10 : Ikonki2[i,1] := 22;
                11 : Ikonki2[i,1] := 23;
                12 : Ikonki2[i,1] := 4;
                13 : Ikonki2[i,1] := 5;
                14 : Ikonki2[i,1] := 6;
                15 : Ikonki2[i,1] := 7;
                16 : Ikonki2[i,1] := 8;
                17 : Ikonki2[i,1] := 9;
                18 : Ikonki2[i,1] := 10;
                19 : Ikonki2[i,1] := 11;
                20 : Ikonki2[i,1] := 12;
              end;
              Ikonki2[i,2] := X; Ikonki2[i,3] := Y;
              uu := true;
              break;
            end;
          end;
        end;
      end;
      if not uu then SimpleBeep;
    end;

    for i := 1 to High(Stellaj)
    do stellaj[i] := false; //--------------------------------------------- сброс на полке
  end;
end;
//========================================================================================
procedure TTabloMain.Timer1Timer(Sender: TObject);
begin
  vremia_zapisi := true;
end;



//========================================================================================
procedure TTabloMain.GetPlakat(X,Y : integer);
var
  i,j,dx : integer;
  uu : boolean;
begin
  try
    if not SetIkonRezNonOK and not WorkMode.OtvKom and not WorkMode.Upravlenie then
    begin
      for i := 1 to High(Stellaj) do stellaj[i] := false;
      IkonkaMove := false; IkonkaMoved := false; IkonkaDown := 0;
      IkonkaDeltaX := 0; IkonkaDeltaY := 0;
      exit;
    end;
    uu := false;
    for j := 0 to 19 do
    begin //---------------------------- проверить зону чувствительности полки с плакатами
      dx := j * 12 + 1;
      if j > 10 then dx := dx + 3;
      if (X >= configRU[config.ru].BoxLeft+dx) and
      (Y >= configRU[config.ru].BoxTop) and
      (X < configRU[config.ru].BoxLeft+dx+12) and
      (Y < configRU[config.ru].BoxTop+13) then
      begin  //---------------------------------- если на экране попали на табличку-плакат
        for i := 1 to 20 do //------------------ сбросить все не выбранные сейчас таблички
        if i <> (j+1) then stellaj[i] := false
        else stellaj[i] := not stellaj[i];   //---------- выбранную табличку "перевернуть"
        uu := true;   //------------------------------- установить признак выбора таблички
      end;
    end;

    if not uu then  //-------------------------------------- если не было выбрано табличек
    begin
      case config.ru of
        1 :
        begin //---------------------------------------------------------------------- RU1
          for i := High(Ikonki) downto 1 do   //----------- пройтись по списку всех ихонок
          if Ikonki[i,1] > 0 then
          begin
            if (Ikonki[i,2] <= X) and
            (Ikonki[i,2]+12 >= X) and
            (Ikonki[i,3] <= Y) and
            (Ikonki[i,3]+12 >= Y) then   //если курсор нашел иконку на экране
            begin
              IkonkaDown := i;
              IkonkaMove := true;
              IkonkaMoved := false;
              IkonkaDeltaX := Ikonki[i,2] - X;
              IkonkaDeltaY := Ikonki[i,3] - Y;
              break;
            end;
          end;
        end;

        2 :
        begin //---------------------------------------------------------------------- RU2
          for i := High(Ikonki2) downto 1 do
          if Ikonki2[i,1] > 0 then
          begin
            if (Ikonki2[i,2] <= X) and
              (Ikonki2[i,2]+12 >= X) and
              (Ikonki2[i,3] <= Y) and
              (Ikonki2[i,3]+12 >= Y) then
            begin
              IkonkaDown := i;
              IkonkaMove := true;
              IkonkaMoved := false;

              IkonkaDeltaX := Ikonki2[i,2] - X;
              IkonkaDeltaY := Ikonki2[i,3] - Y;
              break;
            end;
          end;
        end;
      end;
    end;
  except
    reportf('Ошибка [TabloForm.TTabloMain.GetPlakat]');
    Application.Terminate;
  end;
end;
//========================================================================================
procedure TTabloMain.DrawPlakat(X,Y : integer);
  var i,j,dx : integer; uu : boolean;
begin
try
  if not SetIkonRezNonOK and not WorkMode.OtvKom and not WorkMode.Upravlenie then
  begin
    for i := 1 to High(Stellaj) do stellaj[i] := false;
    IkonkaMove := false;
    IkonkaMoved := false;
    IkonkaDown := 0;
    IkonkaDeltaX := 0;
    IkonkaDeltaY := 0;
    exit;
  end;
  uu := false;
  if ((X+12+IkonkaDeltaX) >= configRU[config.ru].BoxLeft) and
  ((Y+12+IkonkaDeltaY) >= configRU[config.ru].BoxTop) and
  ((X+IkonkaDeltaX) < configRU[config.ru].BoxLeft+12*20+7) and
  ((Y+IkonkaDeltaY) < configRU[config.ru].BoxTop+16) then
  begin // проверить зону чувствительности полки с плакатами
    for j := 0 to 19 do
    begin // проверить зону чувствительности иконок
      dx := j * 12 + 1; if j > 10 then dx := dx + 3;
      if (X >= configRU[config.ru].BoxLeft+dx) and (Y >= configRU[config.ru].BoxTop) and
         (X < configRU[config.ru].BoxLeft+dx+12) and (Y < configRU[config.ru].BoxTop+13) then
      begin
        for i := 1 to 20 do
        if i <> (j+1) then stellaj[i] := false
        else stellaj[i] := not stellaj[i];
      end;
    end;
    uu := true;
  end;
  IkonNew := true; IkonSend := true;
  if not uu then
  begin // переместить плакат на табло
    case config.ru of
      1 : begin
        Ikonki[IkonkaDown,2] := X + IkonkaDeltaX;
        Ikonki[IkonkaDown,3] := Y + IkonkaDeltaY;
      end;
      2 : begin
        Ikonki2[IkonkaDown,2] := X + IkonkaDeltaX;
        Ikonki2[IkonkaDown,3] := Y + IkonkaDeltaY;
      end;
    end;
  end else
  begin // убрать плакат с табло
    case config.ru of
      1 : begin
        Ikonki[IkonkaDown,1] := 0;
      end;
      2 : begin
        Ikonki2[IkonkaDown,1] := 0;
      end;
    end;
  end;
except
  reportf('Ошибка [TabloForm.TTabloMain.DrawPlakat]'); Application.Terminate;
end;
end;

procedure ResetAllPlakat;
var i : integer;
begin
  try
    for i := 1 to High(Ikonki) do
    begin
      Ikonki[i,1] := 0;
      Ikonki[i,2] := 0;
      Ikonki[i,3] := 0;
    end;
    for i := 1 to High(Ikonki2) do
    begin
      Ikonki2[i,1] := 0;
      Ikonki2[i,2] := 0;
      Ikonki2[i,3] := 0;
    end;
    IkonNew := true; IkonSend := true;
  except
    reportf('Ошибка [TabloForm.ResetAllPlakat]'); Application.Terminate;
  end;
end;
{
//========================================================================================
//------------------------------------------------ Реакция на нажатие правой клавиши мышки
procedure TTabloMain.FormMouseDown(Sender : TObject; Button : TMouseButton;
Shift : TShiftState; X,Y : Integer);
begin
  GetPlakat(X,Y); //----------------- получить параметры перемещаемого плаката (если есть)
  OperatorDirect := LastTime + 1/86400;
  if MarhTracert[1].TraceRazdel then ResetTrace;//----- сбросить трассу раздельного режима
end;
 }
var LastID_Obj : integer;

//========================================================================================
//------------------------------------------------------------ реакция на отпускание мышки
procedure TTabloMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
var
  n,i : integer;
begin
  if PopupMenuCmd.PopupComponent <> nil then exit; //если на экран выведено меню, то выйти

  if LockCommandDsp then
  begin  SingleBeep := true; exit; end;//----------------------- если заблокировано, выйти

  if Button = mbLeft then  //------------------------- если была нажата левая кнопка мышки
  begin
    if IkonkaMove and  IkonkaMoved and  //---------------- если работа с выбранной иконкой
    (IkonkaDown > 0) and (cur_obj < 0)
    then  DrawPlakat(X,Y); //---------------------------- переместить плакат в новое место

    IkonkaMove := false; IkonkaMoved := false; //---- освободиться от работы с плакатиками
    IkonkaDown := 0; IkonkaDeltaX := 0; IkonkaDeltaY := 0;

    if (X+shiftscr > configRU[config.ru].MsgLeft) and
    (X+shiftscr < configRU[config.ru].MsgRight) and
    (Y > configRU[config.ru].MsgTop) and
    (Y < configRU[config.ru].MsgBottom) then
    begin //---------------------------------------- работа в поле фиксированных сообщений
      if (X+shiftscr > configRU[config.ru].MsgRight-10) and
      (FixMessage.Count > 5) then
      begin //--------------------------------------------------------- прокрутить список?
        if (Y < (configRU[config.ru].MsgTop+10)) and
        (FixMessage.MarkerLine > 1) then
        begin //------------------------------------------- прокрутка вверх (новые данные)
          dec(FixMessage.MarkerLine);
          if FixMessage.MarkerLine < FixMessage.StartLine
          then FixMessage.StartLine := FixMessage.MarkerLine;
        end
        else
        if (Y > (configRU[config.ru].MsgBottom-10)) and
        (FixMessage.MarkerLine < FixMessage.Count) then
        begin //------------------------------------------- прокрутка вниз (старые данные)
          inc(FixMessage.MarkerLine);
          if (FixMessage.MarkerLine - FixMessage.StartLine) > 4
          then FixMessage.StartLine := FixMessage.MarkerLine - 4;
        end
        else
      end
      else
      begin //------------------------------------------------------------ пометить строку
        n := (Y - configRU[config.ru].MsgTop) div 16 + FixMessage.StartLine; //- №  строки
        if n <= FixMessage.Count then FixMessage.MarkerLine := n;
      end;

      for i := 1 to High(Stellaj) do stellaj[i] := false; //--- сбросить полку с плакатами
      exit;
    end
    else // -------------------------------- если курсор не в поле фиксированных сообщений
    if cur_obj < 0 then  //------------------- если курсор не связан с каким-либо объектом
    begin //-------------------------------------------------------------- проверить точку
      if WorkMode.GoTracert then //--------------------------------- если идет трассировка
      //________________________Т Р А С С И Р О В К А ____________________________________
      begin //-------------------- проверить не выбраны ли остряки стрелки при трассировке
        n := -1;
        for i := configRU[config.ru].OVmin to configRU[config.ru].OVmax do// по всем видео
        if ObjView[i].TypeObj = 11 then //------------- если попался видеообъект = стрелка
        begin
          if (ObjView[i].Points[2].X-8 < X) and
          (ObjView[i].Points[2].Y-8 < Y) and
          (ObjView[i].Points[2].X+8 > X) and
          (ObjView[i].Points[2].Y+8 > Y) then //-- если эта стрелка в зоне захвата курсора
          begin  n := ObjView[i].ObjConstI[4];break;end;//- взять номер буфера для стрелки
        end;

        if n > 0 then //------------------------------------------- если видеобуфер найден
        begin
          for i := 1 to WorkMode.LimitObjZav do //- теперь пройти по объектам зависимостей
          if (ObjZav[i].TypeObj >= 1) and (ObjZav[i].TypeObj <= 8) and //-- если стрелка и
          (ObjZav[i].VBufferIndex = n) then //--- на видеобуфер этой стрелки указал курсор
          begin //---------------------------------- то, следовательно, обнаружена стрелка
            if MarhTracert[1].Finish then //------------- если финиш трассы уже найден, то
            begin //------------------------------------------------- не продолжать трассу
              if LastID_Obj = i then //--- если эта стрелка и есть последний объект трассы
              begin //---------------------------- то завершить набор и подтвердить трассу
                LastID_Obj := -1;
                ID_Menu := KeyMenu_EndTrace; //------------- KeyMenu_EndTrace = 1008 <End>
                cur_obj := 20000;
                CreateDspMenu(ID_menu, X, Y);
                SelectCommand;
                break;
              end
              else begin ResetTrace;LastID_Obj:=-1; exit; end;//иначе сброс трассы и выход
            end
            else //------------------------------------------ если трасса ещё не закончена
            begin
              LastID_Obj := i; ID_Obj := i;
              ID_Menu := IDMenu_Tracert;//---------- продолжать трассу по острякам стрелок
              cur_obj := 20002;
              CreateDspMenu(ID_menu, X, Y); break;
            end;
          end;
        end else //---------------------------------------------- не найден видеобуфер, то
        begin SetPlakat(X,Y);ResetCommands;exit;end; //-- проверить нажатие ярлыка и выйти
      end else

      //------------------------------------------------ если идет не трассировка маршрута
      begin  SetPlakat(X,Y);ResetCommands; exit; end; //------ проверить не нажат ли ярлык

    end else //------------------------------------------- если курсор уже с чем-то связан
    for i := 1 to High(Stellaj) do stellaj[i] := false; //----- сбросить полку с плакатами

    //--- если есть объект под курсором и  ожидаем команды или её подтверждения оператором
    if (cur_obj > 0) and (DspMenu.WC or DspMenu.Ready) then
    begin
      if (DspMenu.Obj > 0) and //----------------------- если есть объект для управления и
      (cur_obj <> DspMenu.Obj) then //------------ объект курсора не тот, что выбран ранее
      begin
        //-------------------------- для режима ответственных команд сброс команды и выход
        if WorkMode.OtvKom then begin  ResetCommands; exit; end
        else //----------------------------------------------------------------- иначе ...
        if (MarhTracert[1].Finish or //--------- если запрос выдачи маршрутной команды или
        (MarhTracert[1].GonkaStrel and //------------ разрешена гонка стрелок в маршрута и
        (MarhTracert[1].GonkaList > 0))) and //----------------- есть стрелки для перевода
                                             //------(запрос перевода стрелок по трассе) и
        (ObjUprav[cur_obj].IndexObj = 20000) then //--------- нажата кнопка "Конец набора"
        begin
          MarhTracert[1].Finish := false;
          DspCommand.Active := true;
          SelectCommand;
        end else  ResetCommands;
        exit;//----------------------------------------------- иначе сброс команды и выход
      end;
    end;

    //-------------------------- если ждем подтверждения от оператора, то выбираем команду
    if DspMenu.WC then
    begin
      DspCommand.Active := true;
      SelectCommand;
    end
    else
    //-- иначе, если  ожидается выбор команды, то сначала перейти к ожиданию подтверждения
    if DspMenu.Ready then DspMenu.WC := true
    else
    begin //------------------------------------------------------------------ иначе ....
      if ID_menu > 0 then  //--------------------------- если есть ожидаемая команда, то..
      begin
        CreateDspMenu(ID_menu, X, Y); //-------------------- создаем меню для этой команды
        //--------------------------------- Выполнить команду сразу после вывода сообщения
        if not DspMenu.WC then SelectCommand; //--- если не ждем подтверждения, то команда
      end else SingleBeep := true; //------------------------------- иначе пикнуть и ждать
    end;
  end else
  begin //----------------------------------------------------- нажата правая кнопка мышки
    //------------------------------------- найти иконку, установленную на табло и удалить
    n := 1;
    case config.ru of  //----------------------------- переключатель по районам управления
      1 :
      begin //------------------------------------------------------------------------ RU1
        for i := High(Ikonki) downto 1 do
        if (Ikonki[i,1] > 0) and (Ikonki[i,2] <= X) and
        (Ikonki[i,2]+12 >= X) and (Ikonki[i,3] <= Y)and
        (Ikonki[i,3]+12 >= Y) then
        begin Ikonki[i,1] := 0; n := 0; break; end;
      end;

      2 :
      begin //------------------------------------------------------------------------ RU2
        for i := High(Ikonki2) downto 1 do
        if (Ikonki2[i,1] > 0) and (Ikonki2[i,2] <= X) and
        (Ikonki2[i,2]+12 >= X) and (Ikonki2[i,3] <= Y) and
        (Ikonki2[i,3]+12 >= Y) then
        begin Ikonki2[i,1] := 0; n := 0; break; end;
      end;
    end;
    IkonkaMove := false;
    IkonkaMoved := false;
    IkonkaDown := 0;
    IkonkaDeltaX := 0;
    IkonkaDeltaY := 0;
    InsNewArmCmd(0,0);
    UnLockHint;
    ResetCommands;
    //----------------------------------------------------- Сбросить фиксируемое сообщение
    if (n > 0) and (X+shiftscr > configRU[config.ru].MsgLeft) and
    (X+shiftscr < configRU[config.ru].MsgRight) and
    (Y > configRU[config.ru].MsgTop) and (Y < configRU[config.ru].MsgBottom) then
    begin
      n := (Y - configRU[config.ru].MsgTop) div 16 + FixMessage.StartLine;//- Номер строки
      if n <= FixMessage.Count then
      begin
        FixMessage.MarkerLine := n;
        ResetFixMessage;
      end
      else SingleBeep := true;
    end;
  end;
end;

//----------------------------------------------------------------------------------------
var
  LastKey : Word;        // Код последней нажатой клавиши
  LastKeyPress : Double; // Время нажатия последней клавиши

//========================================================================================
//-------------------------------------------------------- Обработка нажатия на клавиатуре
procedure TTabloMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  OperatorDirect := LastTime + 1/86400;

  // проверить длительность нажатия клавиши
  if LastKey = Key then
  begin
    if (LastKeyPress+10/80000) < Date+Time then //---- если клавиша нажата более 10 секунд
    begin
      LastKeyPress := Date+Time;
      case Key of //------------------------- сформировать имена для функциональных клавиш
        VK_RETURN : sMsg := 'ENTER';
        VK_ESCAPE : sMsg := 'ESC';
        VK_SPACE : sMsg := 'ПРОБЕЛ';
        VK_BACK : sMsg := 'ЗАБОЙ';
        VK_F1 : sMsg := 'F1'; //-------- Установить маршрутный/раздельный режим управления
        VK_F2 : sMsg := 'F2'; //--------------------------------------------- Ввод времени
        VK_F3 : sMsg := 'F3'; //--------------------------------------- ввод номера поезда
        VK_F4 : sMsg := 'F4'; //------------------------------ Сброс фиксируемых сообщений
        VK_F5 : sMsg := 'F5'; //-- Просмотр сообщений по ненормам устройств(для резервной)
        VK_F6 : sMsg := 'F6'; //--- отключить управление в случае экстренной необходимости
        VK_F7 : sMsg := 'F7'; //---------- сброс разрешения управления с РМ-ДСП(аварийный)
        VK_F8 : sMsg := 'F8'; //------------------- переключатель подсветки номера поездов
        VK_F9 : sMsg := 'F9'; //---------------- переключатель подсветки положения стрелок
        VK_F10 : sMsg := 'F10'; //------------- выдача команд в обход интерфейса оператора
        VK_F11 : sMsg := 'F11'; //--------------------------- подсветить положение курсора
        VK_F12 : sMsg := 'F12'; //------------------------------ Сброс фиксируемого звонка
        VK_INSERT : sMsg := 'INSERT'; //Просмотр списка значений FR3, FR4 (при Ctrl+Shift)
        VK_DELETE : sMsg := 'DELETE'; //--- сброс всех информационных тпбличек (при Shift)
        VK_HOME : sMsg := 'HOME';  //----- Перевести курсор на кнопки выбора режима работы
        VK_END : sMsg := 'END'; //-- Конец набора маршрута(или сброс маршрута, если Shift)
        VK_NEXT : sMsg := 'Page Down'; //----- сдвиг экранов табло вправо (в режиме DEBUG)
        VK_PRIOR : sMsg := 'Page Up';  //------ сдвиг экранов табло влево (в режиме DEBUG)
        VK_LEFT : sMsg := 'Стрелка влево';   //- переместить курсор на объект экрана влево
        VK_RIGHT : sMsg := 'Стрелка вправо';//- переместить курсор на объект экрана вправо
        VK_DOWN : sMsg := 'Стрелка вниз'; //----- переместить курсор на объект экрана вниз
        VK_UP : sMsg := 'Стрелка вверх';//------ переместить курсор на объект экрана вверх
        VK_SHIFT : sMsg := 'SHIFT';
        VK_MENU : sMsg := 'ALT';
        VK_CONTROL : sMsg := 'CTRL';
        else  sMsg := Char(Key); //------------------- для всех остальных клавиш взять имя
      end;
      InsNewArmCmd($7fe7,0);
      AddFixMessage(GetShortMsg(1,141,'<' + sMsg + '>',0),4,3);
      ShowShortMsg(141,LastX,LastY,'<'+ sMsg+ '>');//---------- "длительно нажата клавиша"
    end;
  end else
  begin //------------------------------------------ сохранить код клавиши и время нажатия
    LastKey := Key;
    LastKeyPress := Date+Time;
  end;
end;

//========================================================================================
//-------------------------------------------------------- Отпускание кнопки на клавиатуре
//------------------------------------------------- Key - код нажатой и отпущенной клавиши
//----------------------------------------------- Shift - код состояния управляющих клавиш
procedure TTabloMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i,o,p,x,y : integer;
  t : TPoint;
  {$IFDEF SAVEKANAL} sl : TStringList; {$ENDIF}
begin
  LastKey := 0; //---------------------------- сбросить код нажатой клавиши при отпускании

  if PopupMenuCmd.PopupComponent <> nil then exit;

  case Key of
    VK_INSERT : //--------------------------------------------------- нажата клавиша <Ins>
    begin
      if Shift = [ssShift,ssCtrl] //----------- если также одновременно нажаты управляющие
      then FrForm.Show;//------------------------------- Просмотр списка значений FR3, FR4

      if Shift = [ssShift,ssAlt] //----------- если также одновременно нажаты управляющие
      then ViewBaza.Show;//------------------------------- Просмотр списка значений FR3, FR4
    end;

    VK_DELETE : //---------------------------------------------- если нажата клавиша <Del>
    begin
      if Shift = [ssShift] then //------------ и одновременно с ней нажата клавиша <Shift>
      begin //--------------------------------------- сброс информационных тпбличек (всех)
        ResetAllPlakat;
        ShowShortMsg(142,LastX,LastY,''); //----------- "информационные таблички сброшены"
      end else
      if Shift = [] then
      begin //------------------------------------------------------ сброс трассы маршрута
        InsNewArmCmd(0,KeyMenu_ClearTrace);
        Cmd_ChangeMode(KeyMenu_ClearTrace); //?? ничего не делает
      end;
    end;

    VK_LEFT : //--------------------------------------------------- нажата стрелочка влево
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Neighbour[1] > 0
        then cur_obj := ObjUPrav[cur_obj].Neighbour[1];
      end
      else  cur_obj := StartObj;

      if cur_obj > 0
      then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);
    end;

    VK_RIGHT : //------------------------------------------------- нажата стрелочка вправо
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Neighbour[2] > 0
        then cur_obj := ObjUPrav[cur_obj].Neighbour[2];
      end
      else cur_obj := StartObj;

      if cur_obj > 0
      then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);
    end;

    VK_UP : //----------------------------------------------------- нажата стрелочка вверх
    begin
      if Shift = [ssCtrl] then //----------------------------- если при этом нажата <Ctrl>
      begin //------------------------ перемещение выделения строки вверх в поле сообщений
        if (FixMessage.Count > 0) and (FixMessage.MarkerLine > 1) then
        begin
          dec(FixMessage.MarkerLine);
          if FixMessage.MarkerLine < FixMessage.StartLine
          then FixMessage.StartLine := FixMessage.MarkerLine;
        end
        else  SimpleBeep;
      end
      else
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Neighbour[3] > 0
          then cur_obj := ObjUPrav[cur_obj].Neighbour[3];
        end
        else cur_obj := StartObj;
        if cur_obj > 0 then
        SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);
      end;
    end;

    VK_DOWN :  //--------------------------------------------------- нажата стрелочка вниз
    begin
      if Shift = [ssCtrl] then //----------------------------- если при этом нажата <Ctrl>
      begin  //----------------------- перемещение выделенной строки вниз в поле сообщений
        if (FixMessage.Count > 0) and (FixMessage.MarkerLine < FixMessage.Count) then
        begin
          inc(FixMessage.MarkerLine);
          if FixMessage.MarkerLine > FixMessage.StartLine + 4
          then FixMessage.StartLine := FixMessage.MarkerLine - 4;
        end
        else  SimpleBeep;
      end else
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Neighbour[4] > 0
          then cur_obj := ObjUPrav[cur_obj].Neighbour[4];
        end
        else cur_obj := StartObj;
        if cur_obj > 0  then
        SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);
      end;
    end;

    VK_RETURN : //------------------------------------------------- нажата клавиша <Enter>
    begin
      //------------------------------------- если команды заблокированы, то пикнуть и все
      if LockCommandDsp then
      begin  SingleBeep := true;  exit;  end;

      if DspMenu.WC then //------------------- если есть ожидание подтверждения оператором
      begin
        if cur_obj = DspMenu.obj then // если курсор на том объекте, для которого ожидание
        begin
          DspCommand.Active := true;
          SelectCommand; //----------------------------------------------- Выбрать команду
        end
        else
        begin //------------------ Сброс ранее подготовленной команды, если ушли с объекта
          ResetShortMsg; //------------------------------- Сбросить все короткие сообщения
          DspMenu.Ready := false; DspMenu.WC := false; //------ сбросить признаки ожидания
          DspMenu.obj := -1; //----------------------------- забыть выбранный ранее объект
        end;
      end
      else //-------------------------------------------------- если не ждем подтверждения
      //------------------------------------------------------- но ожидается выбор команды
      if DspMenu.Ready then SelectCommand
      else
      begin //------------------------------------------- если нет ожидания выбора команды
        if cur_obj < 0 then SimpleBeep //------- если курсор стоит не на объекте, только пикнуть
        else
        begin
          x := ObjUprav[cur_obj].Box.Left;
          y := ObjUprav[cur_obj].Box.Top;
          if ID_menu > 0 then //---------------------- если для объекта есть код типа меню
          begin
            CreateDspMenu(ID_menu, X, Y);  //---------------------------- подготовить меню
            if not DspMenu.WC then SelectCommand; //- если без подтверждения, то выполнить
          end else SimpleBeep;
        end;
      end;
    end;

    VK_ESCAPE : //---------------------------------------------- если нажата клавиша <Esc>
    begin
      UnLockHint;
      ResetCommands;
      InsNewArmCmd(0,0);
      if cur_obj > 0 then //----------------- если есть выбранный объект, то курсор на нем
      SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);
    end;

    VK_SPACE :                        
    begin

{$IFDEF DEBUG}
      if Shift = [ssCtrl] then //-------------- Технологическая функция KOK = Ctrl + SPACE
      begin
        WorkMode.PushOK := not WorkMode.PushOK;
      end else
      begin
{$ENDIF}

        UnLockHint;
        ResetCommands;
        InsNewArmCmd(0,0);
        if cur_obj > 0 then
        SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftscr-2,ObjUPrav[cur_obj].Box.Bottom-2);

{$IFDEF DEBUG}
      end;
{$ENDIF}

    end;

    VK_END :
    begin
      if WorkMode.MarhUpr then
      begin
        if Shift = [] then
        begin //---------------------------------------------------- Конец набора маршрута
          DspMenu.obj := 0;
          CreateDSPMenu(KeyMenu_EndTrace,LastX,LastY);
          SelectCommand;
        end else
        if Shift = [ssShift] then
        begin //------------------------------------------------------------- Сброс набора
          DspMenu.obj := 0;
          CreateDSPMenu(KeyMenu_ClearTrace,LastX,LastY);
          SelectCommand;
        end;
      end;
    end;

    VK_HOME :
    begin
      if Shift = [] then
      begin //---------------------------- Перевести курсор на кнопки выбора режима работы
        for i := 1 to High(ObjUprav) do
        begin
          if config.ru = ObjUprav[i].RU then
          begin
            if WorkMode.MarhUpr and (ObjUprav[i].MenuID = KeyMenu_MarshRejim) then
            begin
              SetCursorPos(ObjUPrav[i].Box.Right-shiftscr-60, ObjUPrav[i].Box.Bottom-8);
              break;
            end else
            if WorkMode.RazdUpr and (ObjUprav[i].MenuID = KeyMenu_RazdeRejim) then
            begin
              SetCursorPos(ObjUPrav[i].Box.Right-shiftscr-60, ObjUPrav[i].Box.Bottom-8);
              break;
            end;
          end;
        end;
        GetCursorPos(t);//------------ получить позицию мышиного курсора в формате точки t
        FindCursorCnt:=configRU[config.ru].Tablo_Size.X+configRU[config.ru].Tablo_Size.Y-t.X-t.Y;
        FindCursor := true;
      end;
    end;

    VK_PRIOR :
    begin
{$IFDEF DEBUG}
      //-------------------------------------------------------- сдвиг экранов табло влево
      if shiftscr >= 800 then shiftscr := shiftscr - 800
      else begin shiftscr := 0; SimpleBeep; end;
{$ENDIF}
    end;

    VK_NEXT :
    begin
{$IFDEF DEBUG}
      //------------------------------------------------------- сдвиг экранов табло вправо
      if shiftscr < (configru[config.ru].Tablo_Size.X - configru[config.ru].MonSize.X)
      then shiftscr := shiftscr + 800
      else SimpleBeep;
{$ENDIF}
    end;

    VK_F1 :
    begin
      if Shift = [] then
      begin
        if WorkMode.MarhUpr then
        begin //----------------------------------- Установить раздельный режим управления
          DspMenu.obj := 0;
          CreateDSPMenu(KeyMenu_RazdeRejim,LastX,LastY);
          SelectCommand;
        end else
        begin //----------------------------------- Установить маршрутный режим управления
          DspMenu.obj := 0;
          CreateDSPMenu(KeyMenu_MarshRejim,LastX,LastY);
          SelectCommand;
        end;
      end;
    end;

    VK_F2 :
    begin
      if Shift = [] then //-------------------------------------------------- Ввод времени
      begin
        DspMenu.obj := 0;
        CreateDSPMenu(KeyMenu_DateTime,LastX,LastY);
        SelectCommand;
      end;
    end;

    VK_F3 :
    begin
      if Shift = [] then //-------------------------------------------- ввод номера поезда
      begin
        DspMenu.obj := 20002;
        CreateDSPMenu(KeyMenu_VvodNomeraPoezda,LastX,LastY);
        SelectCommand;
      end;
    end;

    VK_F4 :
    begin //-------------------------------------------------- Сброс фиксируемых сообщений
      if Shift = [] then begin sound := false; ResetFixMessage; end;
    end;

    VK_F5 :
    begin //------------------------------- Просмотр сообщений по неисправностям устройств
      if Shift = [] then
      begin
        if WorkMode.Upravlenie then exit;
        OpenMsgForm := true;
      end;
    end;

    VK_F6 :
    begin
      if Shift = [ssShift,ssAlt,ssCtrl] then
      begin //--------------------- отключить управление в случае экстренной необходимости
        if Application.MessageBox('Подтвердите завершение работы РМ-ДСП','РМ-ДСП',MB_OKCANCEL) = IDOK then
        begin
          ReBoot := false;
          Application.Terminate;
        end;
{$IFDEF DEBUG}
      end else
      //------------------------------------- Включить управление для проверки без сервера
      if Shift = [] then
      begin
        WorkMode.Upravlenie := true;
        WorkMode.LockCmd := false;
        StartRM := false;
{$ENDIF}
      end;
    end;

    VK_F7 : //---- сброс разрешения управления с РМ-ДСП(при отсутствии другой возможности)
    begin
      if (Shift = [ssShift,ssAlt,ssCtrl]) and not WorkMode.Upravlenie then
      begin
        if config.ru <> 1 then
        begin
{$IFNDEF DEBUG}
          if (DesktopSize.X >= configru[1].Tablo_Size.X) and
          (DesktopSize.Y >= configru[1].Tablo_Size.Y) then
{$ENDIF}
          begin
            InsNewArmCmd($7fec,0); NewRegion := 1; ChRegion := true;
          end;
        end;
        if config.ru <> 2 then
        begin
{$IFNDEF DEBUG}
          if (DesktopSize.X >= configru[2].Tablo_Size.X) and
          (DesktopSize.Y >= configru[2].Tablo_Size.Y) then
{$ENDIF}
          begin
            InsNewArmCmd($7feb,0); NewRegion := 2; ChRegion := true;
          end;
        end;
      end;
    end;


    VK_F8 :
    begin //--------------------------------------- переключатель подсветки номера поездов
      if Shift = [] then
      begin
        DspMenu.obj := 20003;
        CreateDSPMenu(KeyMenu_PodsvetkaNomerov,LastX,LastY);
        SelectCommand;
{$IFDEF SAVEKANAL}
      end else
      if Shift = [ssCtrl] then
      begin
        sl := TStringList.Create;
        sl.Text := trmkvit;
        sl.SaveToFile('trm.txt');
        sl.Text := rcvkvit;
        sl.SaveToFile('rsv.txt');
        trmkvit := '';
        rcvkvit := '';
        sl.Free;
{$ENDIF}
      end;
    end;


    VK_F9 :
    begin //-------- переключатель подсветки положения стрелок, района местного управления
      if Shift = [] then
      begin
        DspMenu.obj := 20001;
        CreateDSPMenu(KeyMenu_PodsvetkaStrelok,LastX,LastY);
        SelectCommand;
      end;
    end;

    VK_F10 :
    begin //--------- технологическая функция - выдача команд в обход интерфейса оператора
      if (asTestMode = $55) then exit;
      TabloMain.Visible := false;
      if Shift = [ssShift] then
      begin //---------------------------------------------------- Ввод маршрутной команды

        sMsg := InputBox('Ввод маршрутной команды', 'Введите маршрут', '');
        if sMsg <> '' then
        begin
          if (sMsg[1] = 'м') or (sMsg[1] = 'М') or (sMsg[1] = 'm') or (sMsg[1] = 'M')
          then MarhTracert[1].MarhCmd[10] := cmdfr3_marshrutmanevr
          else
          if (sMsg[1] = 'п') or (sMsg[1] = 'П') or (sMsg[1] = 'p') or (sMsg[1] = 'P')
          then MarhTracert[1].MarhCmd[10] := cmdfr3_marshrutpoezd
          else MarhTracert[1].MarhCmd[10] := cmdfr3_marshrutlogic;

          i := 3; sPar := '';
          while i <= Length(sMsg) do
          begin
            if sMsg[i] = ' ' then break
            else sPar := sPar + sMsg[i];
            inc(i);
          end;
          inc(i);
          try x := StrToInt(sPar) except x := 0 end;

          MarhTracert[1].MarhCmd[1] := x - (x div 256) * 256;
          MarhTracert[1].MarhCmd[2] := x div 256;
          sPar := '';

          while i <= Length(sMsg) do
          begin
            if sMsg[i] = ' ' then break
            else sPar := sPar + sMsg[i];
            inc(i);
          end;
          inc(i);
          try  x := StrToInt(sPar) except x := 0 end;

          MarhTracert[1].MarhCmd[3] := x - (x div 256) * 256;
          MarhTracert[1].MarhCmd[4] := x div 256;
          sPar := '';

          while i <= Length(sMsg) do
          begin
            if sMsg[i] = ' ' then break
            else sPar := sPar + sMsg[i];
            inc(i);
          end;
          MarhTracert[1].MarhCmd[5] := Length(sPar);
          MarhTracert[1].MarhCmd[6] := 0;
          MarhTracert[1].MarhCmd[7] := 0;
          MarhTracert[1].MarhCmd[8] := 0;
          MarhTracert[1].MarhCmd[9] := 0;

          o := 1; p := 0;
          for i := 1 to Length(sPar) do
          begin
            if sPar[i] = '1'
            then p := p + o;
            o := o * 2;
          end;
          i := p and $ff;
          MarhTracert[1].MarhCmd[6] := i;
          i := p and $ff00;
          i := i shr 8; MarhTracert[1].MarhCmd[7] := i;
          i := p and $ff0000;
          i := i shr 16; MarhTracert[1].MarhCmd[8] := i;
          i := p and $ff000000;
          i := i shr 24; MarhTracert[1].MarhCmd[9] := i;
          CmdSendT := LastTime;
          WorkMode.MarhRdy := true;
        end;
      end else
      begin //---------------------------------------------------- Ввод раздельной команды
        sMsg := InputBox('Ввод раздельной команды', 'Введите команду', '');
        if sMsg <> '' then
        begin
          i := 1;
          sPar := '';
          while i <= Length(sMsg) do
          begin
            if sMsg[i] = ' ' then break
            else sPar := sPar + sMsg[i];
            inc(i);
          end;
          inc(i);
          try x := StrToInt(sPar) except x := 0 end;

          sPar := '';
          while i <= Length(sMsg) do
          begin
            if sMsg[i] = ' ' then break
            else sPar := sPar + sMsg[i];
            inc(i);
          end;
          try y := StrToInt(sPar) except y := 0 end;

          if (x > 0) and (x < 190) and (y > 0) and (y < 1100) then
          begin
            CmdBuff.Cmd := x;
            CmdBuff.Index := y;
            CmdCnt := 1;
            CmdSendT := LastTime;
          end
          else SimpleBeep;
        end;
      end;
    end;

    VK_F11 :
    begin //------------------------------------------------- подсветить положение курсора
      GetCursorPos(t);
      FindCursorCnt := configRU[config.ru].Tablo_Size.X +
      configRU[config.ru].Tablo_Size.Y - t.X - t.Y;
      if (t.X + t.Y) > FindCursorCnt
      then FindCursorCnt := t.X + t.Y;
      FindCursor := true;
    end;

    VK_F12 ://-------------------------------------------------- Сброс фиксируемого звонка
    begin InsNewArmCmd($7fe8,0); sound := false; end;

  else
    inherited;
  end;
end;

var
  lastCurOK : boolean;

//========================================================================================
//------------------------------------------------------ обработчик главного таймера табло
procedure TTabloMain.MainTimerTimer(Sender: TObject);
var
  gts : TSystemTime;
  st,i : integer;
  bh,bl,b : byte;
  ec: cardinal;
begin
  try
  {$IFNDEF DEBUG} shiftscr := 0; {$ENDIF}

 {$IFDEF DEBUG}
    WorkMode.LockCmd := false;
    //WorkMode.Upravlenie := true;
    for i := 1 to  1024 do
    begin
      ObjZav[i].bParam[31] := true;
    end;
 {$ENDIF}

    if LoopHandle > 0 then   //-------------------- если существует поток связи с сервером
    begin
      if GetExitCodeThread(LoopHandle,ec) then  //-------------------- если поток в работе
      begin
        if (ec <> STILL_ACTIVE) and //--------------------------- если поток не активен, а
        LoopSync then //------------------------ канал с сервером продолжает обслуживаться
        begin //-------------- повторить инициализацию потока обработки каналов АРМ-Сервер
          reportf('Перезапуск потока обслуживания каналов связи АРМ-Сервер');
          CloseHandle(LoopHandle); //--------------------------------------- закрыть поток
          //------------------------------------------- начать обслуживание каналов заново
          LoopHandle := CreateThread(nil,0,@SyncReadyThread,nil,0,ec);
          reportf('Поток обработки канала АРМ-Сервер перезапущен.ThreadID='+IntToStr(ec));
        end;
      end;
    end else //----------------------------------------------------------- если потока нет
    if LoopSync then //------------------------ если канал с сервером должен обслуживаться
    begin
      reportf('Запуск потока обслуживания каналов связи АРМ-Сервер');
      LoopHandle := CreateThread(nil,0,@SyncReadyThread,nil,0,ec);//начать обслуж. каналов
      reportf('Поток обработки канала АРМ-Сервер запущен. ThreadID='+IntToStr(ec));
    end;
    if LockTablo then exit;//-------------- если табло блокировано на прорисовку, то выйти

    if Assigned(Application.MainForm) then  //---------------- если объявлено главное окно
    begin
      if Application.MainForm.WindowState = wsMinimized//если окно пытаются минимизировать
      then Application.MainForm.WindowState := wsNormal;// установить обычные размеры окна
      if not Application.MainForm.Visible then   //--------------если окно пытаются скрыть
      begin
        Application.MainForm.Visible := true; //------------------- вернуть видимость окну
        SetForegroundWindow(Application.Handle);//-------- выдвинуть окно на передний план
      end;
    end;

    inc(GlobusIndex); if GlobusIndex > 31 then GlobusIndex := 0; //----- прокрутить глобус
    LastTime := Date + Time;             //-- Сохранить момент последнего чтения из канала

    if dMigTablo < LastTime then
    begin //---------------------------------------------- организовать мигающую индикацию
      tab_page := not tab_page;
      dMigTablo := LastTime + MigInterval / 86400;
    end;

    if CanFocus then DspMenu.Ready := false; //----- Управление курсором направить в табло

    if MySync[1] or MySync[2] //-------------- если есть синхронизация по каналу 1 или 2 ,
    then inc(CntSyncCh) //------------------------------ то добавить счетчик синхронизации
    else //---------------------------------------------------- иначе --------------------
    if (LastTime - LastSync > RefreshTimeOut) //----- если прошло достаточно много времени
    then inc(CntSyncTO); //-------------------------------- увеличить счетчик по тайм-ауту

    try
      if (LastTime - LastSync > RefreshTimeOut) or
      MySync[1] or MySync[2] then //--------------------------- интервал регенерации табло
      begin //----------------------------------------------------- Пора рисовать на табло
        MySync[1] := false;
        MySync[2] := false;

        //------------------------------- определить остановку обмена по каналу АРМ-Сервер
        if KanalSrv[1].lastcnt < 70   //-------- если принято менее 70 символов в канале 1
        then inc(KanalSrv[1].lostcnt) //---------------- увеличить счетчик потерь символов
        else KanalSrv[1].lostcnt := 0; //-------- если принять 70 и более, то сброс потерь

        if KanalSrv[1].lostcnt > 10 then //---------------------- если потерь более 10, то
        begin
          KanalSrv[1].iserror := true; //------------ установить признак ошибки в канале 1
          KanalSrv[1].lostcnt := 0;    //--------------------------------- сбросить потери
        end;

        //------------------------------------------------------- то же самое для канала 2
        if KanalSrv[2].lastcnt < 70 then inc(KanalSrv[2].lostcnt)
        else KanalSrv[2].lostcnt := 0;

        if KanalSrv[2].lostcnt > 10 then
        begin
          KanalSrv[2].iserror := true;
          KanalSrv[2].lostcnt := 0;
        end;

        //------------------------------------------------------------- Перерисовка экрана
        if not RefreshTablo then
        begin
          DateTimeToString(sMsg, 'dd/mm/yy h:nn:ss.zzz', LastTime);
          reportf('Сбой регенерации табло '+ sMsg);
        end;

        //----------------------------------- Подготовить байт состояния режима управления
        if WorkMode.RazdUpr   then b := 1 //------------------------ раздельное управление
        else b := 0;

        if WorkMode.MarhUpr   then b := b + 2;    //---------------- маршрутное управление
        if WorkMode.MarhOtm   then b := b + 4;    //------------------------------- отмена
        if WorkMode.InpOgr    then b := b + 8;    //--------------------- ввод ограничений
        if WorkMode.VspStr    then b := b + $10;  //-------------- вспомогательный перевод
        if WorkMode.OtvKom    then b := b + $20;  //--------------------------- нажата КОК
        if WorkMode.Podsvet   then b := b + $40;  //-------------------- подсветка стрелок
        if WorkMode.GoTracert then b := b + $80;  //----------------- ввод трассы маршрута

        if (ArmState <> b) and
        (WorkMode.ArmStateSoob > 0) then  //----- если есть изменения - сохранить в архиве
        begin
          ArmState := b;
          FR3inp[WorkMode.ArmStateSoob] := char(b);
          bl := WorkMode.ArmStateSoob and $ff;
          bh := WorkMode.ArmStateSoob shr 8;
          NewFR[1] := NewFR[1] + char(bl) + char(bh) + char(ArmState);
        end;

        //----------------------------- сохранить канальную новизну и команды меню в архив
        if (NewFR[1] <> '') or //-------- если 1-ый буфер новизны для архива не пустой или
        (NewFR[2] <> '') or    //-------- если 2-ой буфер новизны для архива не пустой или
        (NewCmd[1] <> '') or //1-й буфер сообщений отосланых в сервер для архива не пустой
        (NewCmd[2] <> '') or //2-й буфер сообщений отосланых в сервер для архива не пустой
        (NewMenuC <> '') or    //-- буфер команд меню, использованных оператором не пустой
        (NewMsg <> '') then    //----------------- буфер сообщений из потока FR3 не пустой
        begin
          if StartRM and (StartTime < LastTime - 9/86400) then SaveArch(2)
          else SaveArch(1);
          if DspToArcEnabled then //-------------------------------------------- ДСП-АРХИВ
          begin //------------------------------------- передать архив по каналу ДСП-АРХИВ
            if DspToArcConnected and //-------------- если есть связь по трубе с каналом и
            DspToArcAdresatEn and   //--------------------- доступен другой конец трубы и
            not DspToArcPending and //-- нет блокировки записи на время передачи в трубе и
            (LenArc > 0) and (BuffArc[1] > 0) then //- есть,что писать, и запись не пустая
            begin
              SendDspToArc(@BuffArc[1],LenArc);//- послать в буфер архива удаленной машины
              LenArc := 0;
            end;
          end;
        end;

        if Assigned(MsgFormDlg) then  //----------------- если существует системный журнал
        begin
          if OpenMsgForm then //------- если существует запрос на открытие формы сообщений
          begin
            OpenMsgForm := false;
            MsgFormDlg.Left := 0;
            MsgFormDlg.Top := 0;
            MsgFormDlg.Width := configru[config.ru].MonSize.X;
            MsgFormDlg.Height := configru[config.ru].MonSize.Y;
            MsgFormDlg.Show;  //------------------- показать окно формы системного журнала
            UpdateMsgQuery := true;
          end;
          if MsgFormDlg.Visible then  //---------------------- если системный журнал видим
          begin
            if NewNeisprav then //------------- если есть новая неисправность для фиксации
            begin
              NewNeisprav := false; //----------------- снять признак новизны для фиксации
              MsgFormDlg.BtnUpdate.Enabled := true; //---------- открыть кнопку "обновить"
            end;
            if UpdateMsgQuery then //----- если есть запрос на обновление списка сообщений
            begin
              MsgFormDlg.BtnUpdate.Enabled := false; //--------- закрыть кнопку "обновить"
              UpdateMsgQuery := false; //----- снять запрос на обновление списка сообщений
              st := 1;
              i := 0;
              while st <= Length(LstNN) do //-- пройти по списку неисправностей СЦБ
              begin
                if LstNN[st] = #10 then inc(i);//конец строки, счет нужно увеличить
                if i < 700 then inc(st) //------- если меньше 700 штук продолжаем движение
                else   //--------------------------------------------- если более 700 штук
                begin
                  SetLength(LstNN,st); //-------------- обрезаем список и прерываем
                  break;
                end;
              end;
              MsgFormDlg.Memo.Lines.Text := LstNN;//-список неисправностей на экран

              st := 1;
              i := 0;
              while st <= Length(ListDiagnoz) do //--- пройти по списку неисправностей УВК
              begin
                if ListDiagnoz[st] = #10 then inc(i);//- если конец строки, счет увеличить
                if i < 700 then inc(st)  //------ если меньше 700 штук продолжаем движение
                else    //-------------------------------------------- если более 700 штук
                begin
                  SetLength(ListDiagnoz,st);  //-------------- обрезаем список и прерываем
                  break;
                end;
              end;
              MsgFormDlg.MemoUVK.Lines.Text :=ListDiagnoz;//список неисправностей на экран
            end;
          end;
        end;

        if (LastReper + (600/86400)) < LastTime then //от последней записи в архив >10 мин
        begin //--------------------------------- сохранить 10-ти минутный архив состояний
          SaveArch(2);
          if DspToArcEnabled then //---------------- если иницаиализирован канал ДСП-АРХИВ
          begin //------------------------------------- передать архив по каналу ДСП-АРХИВ
            if DspToArcConnected and //----------------------- если этот канал подключен и
            DspToArcAdresatEn and //------------------- если доступен адресат для записи и
            not DspToArcPending and (LenArc > 0) then //-нет блокировки, есть что записать
            begin
              SendDspToArc(@BuffArc[1],LenArc);//- послать в буфер архива удаленной машины
              LenArc := 0;
            end;
          end;
        end;
//----------------------------------------------------------- обработать состояние системы
//-----проверка контрольной суммы записей массива ObjZav по 10 штук в каждом цикле таймера
        st := cntObjZav + 10;  //----------------------- отсчитываем очередные 10 объектов
        while cntObjZav < st do //-------------------------------- проходим по всем десяти
        begin
          if cntObjZav <= WorkMode.LimitObjZav then // если не дошли до конца об. зависим.
          begin
            if not CalcCRC_OZ(cntObjZav) then //----------- если КС для объекта не совпала
            begin
              InsNewArmCmd($7ffc,0); //------- записать в архив ДСП сообщение о ненорме БД
              ShowShortMsg(526,LastX,LastY,'объекта зависимостей в строке '+
              IntToStr(cntObjZav));
              SimpleBeep;
            end;
            inc(cntObjZav); //-------------------------------- перейти на следующий объект
          end
          else //------------------------------ когда прошли по всем объектам зависимостей
          begin
            cntObjZav := 1;
            break; //----------------------------------------------- переместить на начало
          end;
        end;
//--- проверка контрольной суммы записей массива ObjView по 20 штук в каждом цикле таймера
        st := cntObjView + 20; //----------------------- отсчитываем очередные 20 объектов
        while cntObjView < st do //--------------- проходим по всем из очередной двадцатки
        begin
          if cntObjView <= WorkMode.LimitObjView then //не дошли до последнего об.отображ.
          begin
            if ObjView[cntObjView].TypeObj <> 0 then //------------ если объект существует
            begin
              if not CalcCRC_OV(cntObjView) then  //---- если контрольная сумма не совпала
              begin
                InsNewArmCmd($7ffc,0);
                ShowShortMsg(526,LastX,LastY,'объекта табло в строке '+
                IntToStr(cntObjView));
                SimpleBeep;
              end;
            end;
            inc(cntObjView);
          end
          else //----------------------------------------------------- если дошли до конца
          begin
            cntObjView := 1;
            break; //----------------------------------------------- переместить на начало
          end;
        end;
//--------- проверка контрольной суммы записей массива ObjUprav по 20 штук в цикле таймера
        st := cntObjUprav + 20;
        while cntObjUprav < st do
        begin
          if cntObjUprav <= WorkMode.LimitObjUprav then
          begin
            if ObjUprav[cntObjUprav].RU <> 0 then
            begin
              if not CalcCRC_OU(cntObjUprav) then
              begin
                InsNewArmCmd($7ffc,0);  //-------------------------------------ошибка в БД
                ShowShortMsg(526,LastX,LastY,'объекта управления в строке '
                + IntToStr(cntObjUprav));
                SimpleBeep;
              end;
            end;
            inc(cntObjUprav);
          end else
          begin
            cntObjUprav := 1;
            break; //----------------------------------------------- переместить на начало
          end;
        end;
//--------- проверка контрольной суммы записей массива OVBuffer по 20 штук в цикле таймера
        st := cntOVBuffer + 20;
        while cntOVBuffer < st do
        begin
          if cntOVBuffer <= High(OVBuffer) then
          begin
            if (OVBuffer[cntOVBuffer].TypeRec <> 0) or
            (OVBuffer[cntOVBuffer].Jmp1 <> 0) or
            (OVBuffer[cntOVBuffer].Jmp2 <> 0) then
            begin
              if not CalcCRC_VB(cntOVBuffer) then
              begin
                InsNewArmCmd($7ffc,0);
                PutShortMsg(526,LastX,LastY,'буфера отображения в строке '+
                IntToStr(cntOVBuffer));
                SimpleBeep;
              end;
            end;
            inc(cntOVBuffer);
          end else
          begin
            cntOVBuffer := 1;
            break; //----------------------------------------------- переместить на начало
          end;
        end;
//----------------------------------------------------------------------------------------
        if WorkMode.ServerSync then //----- предусмотрена выдача команды установки времени
                                    //--------------------------- и синхронизации серверов
        begin //--------------------------------- Выполнить синхронизацию времени серверов
          st := (config.RMID - 3) * 12; //-------------- определить время для данного АРМа
          GetSystemTime(gts); //--------------------------------- получить системное время
          if SyncTime then   //------------------------- есть признак формирования команды
                             //---------------------------- синхронизации времени серверов
          begin
            if not ((gts.wMinute = st) and
            (gts.wSecond = 28)) then //------- если момент синхронизации только что прошел
            SyncCmd := true;//-------------------------- установить признак выдачи команды
                            //------------------ синхронизации времени серверов в канал ТУ
          end
          else
          begin //---------- Проверить необходимость выдачи синхронизации времени серверов
            if (gts.wMinute = st) and (gts.wSecond = 28) then //------- если подошло время
            SyncTime := true;//------------------- установить признак формирования команды
          end;
        end;

//{$IFDEF DEBUG}
//        WorkMode.OtvKom := WorkMode.PushOK;
//{$ELSE}
        if ((StateRU and $20) = $20) then
        begin
          WorkMode.PushOK := true;
          WorkMode.OtvKom := true;  //--------------------------------- Есть разрешение ОК
        end
        else
        begin
          WorkMode.OtvKom := false;//----------------------------------- Нет разрешения ОК
          WorkMode.PushOK := false;
        end;
//{$ENDIF}
        if WorkMode.OtvKom <> lastCurOK then  //----------------- изменилось состояние КОК
        begin
          lastCurOK := WorkMode.OtvKom;
          if WorkMode.OtvKom then InsNewArmCmd($7fe6,0) //------------- переход в режим ОК
          else InsNewArmCmd($7fe5,0); //------------- выход из режима ответственных команд
        end;

        if WorkMode.CmdReady or //---------------------- если разд.команда АРМа готова или
        WorkMode.MarhRdy then //--------------------------- маршрутная команда АРМа готова
        Screen.Cursor := crAppStart //-------------------- при занятости канала АРМ-Сервер
        else
        begin //---------------------------------------- при свободности канала АРМ-Сервер
          if WorkMode.OtvKom then Screen.Cursor := curTablo1ok //---при нажатой кнопке КОК
          else Screen.Cursor := crArrow; //-------------------- обычный курсор - стрелочка
        end;

        //------- при многоэкранном табло выявлен дефект ПО - исчезает курсор в режиме ОК.
        //---------------------------------------------------------- Данная штука помогает
        if WorkMode.OtvKom then
        begin ShowCursor(false); ShowCursor(true); end; //-------------------------???????

        if ChRegion then ChangeRegion(NewRegion); //---------- изменение района управления

        if ChDirect then
        ChangeDirectState(StDirect); //-------------------- изменение состояния управления

        if WorkMode.Upravlenie and
        WorkMode.OU[0] and
        Assigned(ObjectWav) and
        Assigned(IpWav) then //----------------------------------- для участка приближения
        begin //------------------------------- дать короткий звонок требуемой тональности
          if Ip1Beep then
          begin
            Ip1Beep := false;
            PlaySound(PAnsiChar(IpWav.Strings[0]),0,SND_ASYNC);
          end
          else //----------------------------------------------------------- 1 приближение
          if Ip2Beep then
          begin
            Ip2Beep := false;
            PlaySound(PAnsiChar(IpWav.Strings[1]),0,SND_ASYNC);
          end
          else  //---------------------------------------------------------- 2 приближение
          if SingleBeep  then
          begin
            SingleBeep := false;
            PlaySound(PAnsiChar(ObjectWav.Strings[0]),0,SND_ASYNC);
          end
          else
          if SingleBeep2 then
          begin
            SingleBeep2 := false;
            PlaySound(PAnsiChar(ObjectWav.Strings[1]),0,SND_ASYNC);
          end
          else
          if SingleBeep4 then
          begin
            SingleBeep4 := false;
            PlaySound(PAnsiChar(ObjectWav.Strings[3]),0,SND_ASYNC);
          end
          else
          if SingleBeep5 then
          begin
            SingleBeep5 := false;
            PlaySound(PAnsiChar(ObjectWav.Strings[4]),0,SND_ASYNC);
          end
          else
          if SingleBeep6
          then
          begin
            SingleBeep6 := false;
            PlaySound(PAnsiChar(ObjectWav.Strings[5]),0,SND_ASYNC);
          end;
        end;

        if MsgStateRM <> '' then
        begin //------------------------------------- вывод сообщения об изменении статуса
          PutShortMsg(MsgStateClr,LastX,LastY,MsgStateRM);
          MsgStateRM := '';
        end;

        //----------------------------------------------------- обработка канала ДСП - ДСП
        //----------------------------------- сформировать байт приоритета массива ярлыков
        IkonPri := $1f;
        if (StartTime+15/86400) < LastTime then //------ ожидать 15 секунд от запуска АРМа
        IkonPri := IkonPri and $ff-$10;//до установки прав передачи плаката на другие АРМы
        if IkonNew then IkonPri := IkonPri and $ff-$8;
        if WorkMode.Upravlenie then IkonPri := IkonPri and $ff-$4;
        if config.ru = config.def_ru then IkonPri := IkonPri and $ff-$2;
        if config.Master then IkonPri := IkonPri and $ff-$1;
{
        //--------------------------------------------------------------------- потоки АСУ
        if DspToDspEnabled then //------------------------------- если нужен канал ДСП-ДСП
        begin
          if DspToDspThread > 0 then
          begin
            if GetExitCodeThread(DspToDspThread,ec) then
            begin //--------------------- проверить исполнение потока обработки трубы АСУ1
              if (ec <> STILL_ACTIVE) and not IsBreakKanalASU then
              begin
                CloseHandle(DspToDspThread);
                AddFixMessage('Разрыв связи по каналу АСУ1',4,6);
                case DspToDspType of
                  1 :
                    DspToDspThread := //--------------------------- поток для клиента АСУ1
                    CreateThread(nil,0,@DspToDspClientProc,DspToDspParam,0,DspToDspThreadID);
                  else
                  DspToDspThread := //----------------------------- поток для сервера АСУ1
                  CreateThread(nil,0,@DspToDspServerProc,DspToDspParam,0,DspToDspThreadID);
                end;
                if DspToDspThread = 0 then //------------------------ если поток не создан
                reportf('Не создан процесс обработки канала АСУ1. '+
                DateTimeToStr(LastTime));
              end else
              begin //------------------------- обработать данные по приему из канала АСУ1
                //----------------------------- принять таблички из канала ДСП-ДСП2 (АСУ1)
                if DspToDspInputBufPtr > 0 then
                ExtractPacketASU(@DspToDspInputBuf[0],@DspToDspInputBufPtr);
                DspToDspSucces := false; //--------------------------- сбросить буфер приема
              end;
            end;
          end
          else

          if not IsBreakKanalASU then //------------------------- преван обмен плакатиками
          begin
            case DspToDspType of
              1 :
                DspToDspThread := //------------------------------- поток для клиента АСУ1
                CreateThread(nil,0,@DspToDspClientProc,DspToDspParam,0,DspToDspThreadID);
              else
                DspToDspThread := //------------------------------- поток для сервера АСУ1
                CreateThread(nil,0,@DspToDspServerProc,DspToDspParam,0,DspToDspThreadID);
            end;
            if DspToDspThread = 0
            then reportf('Не создан процесс обработки канала АСУ1. '+
            DateTimeToStr(LastTime));
          end;

          if IkonSend then
          begin //---------------------------- передать таблички по каналу ДСП-ДСП2 (АСУ1)
            if DspToDspConnected and DspToDspAdresatEn and not DspToDspPending then
            begin
              IkonNew := false;
              IkonSend := false;
              IkonkiPack; //--------------------------------- сформировать массив табличек
              SendDspToDsp(@IkonkiOut[0],1007); //----- передать таблички на другой РМ-ДСП
            end;
          end;
        end;
}
{
        if DspToArcEnabled then //---------------------------------------------- ДСП-АРХИВ
        begin
          if DspToArcThread > 0 then
          begin
            if GetExitCodeThread(DspToArcThread,ec) then
            begin //-------------------- проверить исполнение потока обработки трубы АРХИВ
              if (ec <> STILL_ACTIVE) and not IsBreakKanalASU then
              begin
                CloseHandle(DspToArcThread);
                AddFixMessage('Разрыв связи по каналу удаленного архива',4,6);
                DspToArcThread := //----------------------------------------- клиент АРХИВ
                CreateThread(nil,0,@DspToARCProc,DspToArcParam,0,DspToArcThreadID);
                if DspToArcThread = 0 then
                reportf('Не создан процесс обработки канала хранилища удаленного архива. '+
                DateTimeToStr(LastTime));
              end;
            end;
          end
          else
          if not IsBreakKanalASU then  //------------------------------------ клиент АРХИВ
          begin
            DspToArcThread :=
            CreateThread(nil,0,@DspToARCProc,DspToArcParam,0,DspToArcThreadID);
            if DspToArcThread = 0 then
            reportf('Не создан процесс обработки канала хранилища удаленного архива. '+
            DateTimeToStr(LastTime));
          end;
        end;
}
      end;

      //------------------- конец обработки процедур, выполняемых после получения признака
      //----------------------- синхронизации из канала или по превышению времени ожидания
      if SendToSrvCloseRMDSP then
      if CmdSendT + (3/86400) < LastTime then
      //------------------------------------------------------ Закрыть главное окно РМ-ДСП
      begin IsCloseRMDSP := true; Close; end;

      if (CmdCnt = 0) and
      WorkMode.CmdReady and SendRestartServera then
      begin //---------------- отменить ожидание квитанции на команду перезапуска серверов
        SendRestartServera := false;
        WorkMode.CmdReady := false;
      end;

      if ((CmdCnt > 0) or
      (WorkMode.MarhRdy) or
      (WorkMode.CmdReady)) then
      begin //------------------------------------------------------ буфер команд заполнен
        if WorkMode.LockCmd then
        begin //---------------- есть блокировка команд - отложить выдачу команд на сервер
          if StartRM then
          begin
            if CmdSendT + (10/86400) < LastTime then
            begin //-- превышено время ожидания команды автоматического захвата управления
              InsNewArmCmd($7ffd,0);
              CmdCnt := 0;
              WorkMode.MarhRdy := false;
              WorkMode.CmdReady := false;
              StartRM := false; //------------------------------------------- сброс команд
            end;
          end else
          if not SendToSrvCloseRMDSP then CmdSendT := LastTime;
        end else
        begin //------------------------ проверить время ожидания выдачи команды на сервер
          if CmdSendT + (5/86400) < LastTime then
          begin //--------------------------------------- превышено время ожидания команды
            InsArcNewMsg(0,296,0);  //--------------------------------- "сброшена команда"
            CmdCnt := 0;
            WorkMode.MarhRdy := false;
            WorkMode.CmdReady := false; //----------------------------------- сброс команд
            if not StartRM then //---------------------------------- если не старт системы
            AddFixMessage(GetShortMsg(1,296,GetNameObjZav(CmdBuff.LastObj),0),4,1);
         end;
        end;
      end;

      if StartRM and (StartTime < LastTime - 10/86400) then
      begin //--------------------------------------------------- процедуры старта системы
        if (KanalSrv[1].issync or KanalSrv[2].issync) and
        not WorkMode.LockCmd then
        StartRM := false;
      end;

      if LockCommandDsp then
      begin
        if TimeLockCmdDsp < (LastTime - 0.5/86400) then LockCommandDsp := false;
      end;
    finally
      MainTimer.Enabled := true;
    end;
  except
    reportf('Ошибка [TabloForm.MainTimerTimer]');
    Application.Terminate;
  end;
end;

//========================================================================================
var
  FixVspPerevod : boolean;

//========================================================================================
//---------------------------------------------------------------- Обновление образа табло
function TTabloMain.RefreshTablo : Boolean;
var
  Delta : Double;
  a,b : boolean;
  ptr : SmallInt;
begin
  try
    LastSync := LastTime;
    if SVAZ <> config.SVAZ_TUMS[1][1] then config.SVAZ_TUMS[1][1] := SVAZ
    else
    if SVAZ <> config.SVAZ_TUMS[1][2] then config.SVAZ_TUMS[1][2] := SVAZ
    else
    if SVAZ <> config.SVAZ_TUMS[1][3] then config.SVAZ_TUMS[1][3] := SVAZ;

    PrepareOZ; //----------------------------------- подготовка всех объектов зависимостей

    //--------------------------------- работа со структурой текущей ответственной команды
    if OtvCommand.Active then //---- если ждем выдачу исполнительной ответственной команды
    begin
      //--------------------------------------------------- проверить сообщения из сервера
      if OtvCommand.State <> GetFR3(OtvCommand.Check,a,b)//контролируемый датчик изменился
      then OtvCommand.Ready := false; //это подтверждение предв.ком,разреши исполнительную

      //-------------------------------------------------------- обработать состояние ОтвК
      Delta := OtvCommand.Reper - LastTime; //---------------------------- Остаток времени
      if Delta > 0 then
      begin
        if not WorkMode.OtvKom then //--------- если отпустили кнопку ответственных команд
        begin
          OtvCommand.Active := false;
          WorkMode.GoOtvKom := false;
          OtvCommand.Ready := false;
          ShowShortMsg(156, LastX, LastY, ''); //-----"ввод ответственной команды прерван"
          InsArcNewMsg(0,156,1);
//          SingleSimpleBeep := true;
        end
        else
        if OtvCommand.Second > 0 then
        begin
          if OtvCommand.Ready then
          begin //--------------------------------- преждевременная исполнительная команда
            OtvCommand.Active := false;
            WorkMode.GoOtvKom := false;
            ResetShortMsg;
            AddFixMessage(GetShortMsg(1,155,'',1),1,1);//------"нарушен порядок выдачи ОК"
            InsArcNewMsg(0,155,1);
          end
          else
          if (OtvCommand.Second = OtvCommand.Cmd) and //-если получена ожидаемая команды и
          (OtvCommand.Obj = OtvCommand.SObj) then //- получена команда на ожидаемый объект
          begin //-------------------------------------- Обнаружена исполнительная команда
            OtvCommand.Active := false;
            WorkMode.GoOtvKom := false;
            OtvCommand.Ready := false;
            DspCommand.Command := OtvCommand.Second;
            DspCommand.Obj := OtvCommand.SObj;
            DspCommand.Active  := true;
            SelectCommand;  //------------------------------- Выполнить команду управления
          end
          else
          begin //------------------------------ Вторая команда не соответствует ожидаемой
            OtvCommand.Active := false;
            WorkMode.GoOtvKom := false;
            OtvCommand.Ready := false;
            ResetShortMsg;
            AddFixMessage(GetShortMsg(1,153,'',1),1,1);//"исполн. противоречит предварит."
            InsArcNewMsg(0,153,1);
          end;
        end
        else
        begin //------------------------------- продолжить ожидание исполнительной команды
          if not (OtvCommand.Ready or //------ если ожидается ответ на предварительную или
          (OtvCommand.SObj > 0)) then //------------- на объект была выдача исполнительной
          begin // вывод отсчета таймера
            delta := delta * 84000;
            PutShortMsg(7,LastX,LastY,GetShortMsg(1,154,'',1)+FloatToStrF(delta,ffFixed,2,0));
          end;
        end;
      end
      else
      begin //--------------------------------------- Сброс ожидания по превышению времени
        OtvCommand.Active := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Ready := false;
        ShowShortMsg(152, LastX, LastY, '');//------------------"превышено время ожидания"
        InsArcNewMsg(0,152,1);
//        SingleSimpleBeep := true;
      end;
    end
    else
    if VspPerevod.Active and//Ожидание нажатия кнопки выключения контроля при всп.переводе
    (VspPerevod.Strelka > 0) and (VspPerevod.Strelka <= WorkMode.LimitObjZav) then
    begin
      ptr := ObjZav[VspPerevod.Strelka].BaseObject; //- указатель на индекс хвоста стрелки
      if (ptr > 0) and (ptr <= WorkMode.LimitObjZav) then
      begin
        Delta := VspPerevod.Reper - LastTime; //-------------------------- Остаток времени
        if Delta > 0 then
        begin
          if ObjZav[ObjZav[ObjZav[VspPerevod.Strelka].BaseObject].ObjConstI[13]].bParam[1]
          //---------------- если нажата кнопка вспомогательного перевода - выдать команду
          then
          begin
            VspPerevod.Active := false;
            WorkMode.VspStr := false;
            FixVspPerevod := false;
            DspCommand.Command := VspPerevod.Cmd;
            DspCommand.Obj := VspPerevod.Strelka;
            DspCommand.Active  := true;
            SelectCommand;  //------------------------------- Выполнить команду управления
          end
          else
          begin //----------------------------------- не нажата кнопка продолжить ожидание
            delta := delta * 84000;
            case VspPerevod.Cmd of
              CmdStr_ReadyVPerevodPlus : //----------- вспомогательный перевод стрелки в +
              begin
                sMsg:=GetShortMsg(1,99,ObjZav[ptr].Liter,7)+//ожидается нажатие - осталось
                FloatToStrF(delta,ffFixed,2,0);
                PutShortMsg(7, LastX, LastY, sMsg);
                if not FixVspPerevod then
                begin
                  InsArcNewMsg(ptr,99,7);
                  FixVspPerevod := true;
                end;
              end;

              CmdStr_ReadyVPerevodMinus : //---------- вспомогательный перевод стрелки в -
              begin
                sMsg:=GetShortMsg(1,100,ObjZav[ptr].Liter,7)+//ожидается нажатие- осталось
                FloatToStrF(delta,ffFixed,2,0);
                PutShortMsg(7, LastX, LastY, sMsg);
                if not FixVspPerevod then
                begin
                  InsArcNewMsg(ptr,100,7);
                  FixVspPerevod := true;
                end;
              end;
            end;
          end;
        end
        else
        begin //----------------------------------------------------- Сбросить команду ВСП
          VspPerevod.Active := false;
          WorkMode.VspStr := false;
          FixVspPerevod := false;
          ShowShortMsg(148, LastX, LastY, ObjZav[ptr].Liter); //"превышено время для ВСП"
          InsArcNewMsg(ptr,148,1);
        end;
      end
      else
      begin // Сбросить команду ВСП при обнаружении сбоя
        VspPerevod.Active := false;
        WorkMode.VspStr := false;
        FixVspPerevod := false;
      end;
    end;

    mem_page := not mem_page; //--- переключатель подготовки к отображению табло1 / табло2

    if mem_page then DrawTablo(Tablo2) //--------------- Подготовка табло2 для отображения
    else DrawTablo(Tablo1);            //--------------- Подготовка табло1 для отображения

    Invalidate;              //---------------------------------------- Перерисовка экрана
    result := true;
  except
    reportf('Ошибка [TabloForm.TTabloMain.RefreshTablo]');
    Application.Terminate; result := false;
  end;
end;

//========================================================================================
//----------------------------------------- обработчик таймера выработки звукового сигнала
procedure TTabloMain.BeepTimerTimer(Sender: TObject);
begin
  try
    if WorkMode.Upravlenie and WorkMode.OU[0] and Sound and Assigned(ObjectWav) then
    PlaySound(PAnsiChar(ObjectWav.Strings[2]),0,SND_ASYNC);
  except
    reportf('Ошибка [TabloForm.TTabloMain.SimpleBeepTimerTimer]');
    Application.Terminate;
  end;
end;

//========================================================================================
//------------------------------------------------ Инкремент счетчика ответственных команд
procedure IncrementKOK;
begin
  try
    inc(KOKCounter);
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName, false) then
    begin
      if reg.ValueExists('KOK') then reg.WriteInteger('KOK',KOKCounter);
      reg.CloseKey;
    end;
  except
    reportf('Ошибка [TabloForm.IncrementKOK]');
    Application.Terminate;
  end;
end;

//========================================================================================
//------------------------------------ установить начальные значения переменных в объектах
procedure PresetObjParams;
  var i : integer;
begin
try
  for i := 1 to High(ObjZav) do
    case ObjZav[i].TypeObj of
      2 :
      begin //-------------------------------------------------------------------- стрелка
        ObjZav[i].bParam[4] := false;
        ObjZav[i].bParam[5] := false;
      end;

      3 :
      begin //--------------------------------------------------------------------- Секция
        ObjZav[i].bParam[1] := true;  //----------------------------------------------- СП
        ObjZav[i].bParam[2] := true;  //------------------------------------------------ з
        ObjZav[i].bParam[4] := true;  //---------------------------------------------- МСП
        ObjZav[i].bParam[5] := true;  //----------------------------------------------- МИ
        ObjZav[i].bParam[8] := true;  //------------------------ Предварительное замыкание
        ObjZav[i].bParam[10] := true; //------------------------------ Аварийное замыкание
      end;

      4 :
      begin //----------------------------------------------------------------------- Путь
        ObjZav[i].bParam[1] := true; //---------------------------------------------- П(ч)
        ObjZav[i].bParam[2] := true; //------------------------------------------------ ЧИ
        ObjZav[i].bParam[3] := true; //------------------------------------------------ НИ
        ObjZav[i].bParam[5] := true; //--------------------------------------------- МИ(ч)
        ObjZav[i].bParam[6] := true; //--------------------------------------------- МИ(н)
        ObjZav[i].bParam[8] := true; //------------------------- Предварительное замыкание
        ObjZav[i].bParam[10] := true; //------------------------------ Аварийное замыкание
        ObjZav[i].bParam[16] := true; //--------------------------------------------- П(н)
      end;

      5 :
      begin //------------------------------------------------------------------- Светофор
        ObjZav[i].iParam[1] := 0;
        ObjZav[i].iParam[2] := 0;
        ObjZav[i].iParam[3] := 0;
      end;

      15 :
      begin //------------------------------------------------------------------------- АБ
        ObjZav[i].bParam[6] := false;
        ObjZav[i].bParam[9] := false; //------------------------- для МПЦ установить true;
      end;

      34 :
      begin //-------------------------------------------------------------------- Питание
        ObjZav[i].bParam[1] := true;
        ObjZav[i].bParam[2] := true;
      end;

      38 :
      begin //----------------------------------------------------------- контроль надвига
        ObjZav[i].bParam[1] := false;
      end;
    end;
{$IFDEF DEBUG}
// Установить признак активности объектов FR3s
  for i := 1 to FR_LIMIT do FR3s[i] := LastTime;
  for i := 1 to FR_LIMIT do FR4s[i] := LastTime;
{$ENDIF}
except
  reportf('Ошибка [TabloForm.PresetObjParams]');
  Application.Terminate;
end;
end;

//========================================================================================
//------------------------------ Выполнить переключение Управление -> резерв -> Управление
procedure ChangeDirectState(State : Boolean);
var
  i: Integer;
  f : Byte;
begin
  try
    ChDirect := false;
    for i := 1 to 16 do
    begin
      config.SVAZ_TUMS[i][1] := 0;
      config.SVAZ_TUMS[i][2] := 0;
      config.SVAZ_TUMS[i][3] := 0;
    end;

    for i := 1 to High(ObjZav) do
    begin //------------------------------------------------ Сбросить признаки трассировки
      case ObjZav[i].TypeObj of
        1 :
        begin //------------------------------------------------------------ хвост стрелки
          ObjZav[i].bParam[6]  := false;//------------------------------------ сбросить ПУ
          ObjZav[i].bParam[7]  := false; //----------------------------------- сбросить МУ
          ObjZav[i].bParam[14] := false; //---------------- сбросить программное замыкание
        end;

        2 :
        begin //------------------------------------------------------------------ стрелка
          ObjZav[i].bParam[6]  := false;//------------------------------------ сбросить ПУ
          ObjZav[i].bParam[7]  := false;//------------------------------------ сбросить МУ
          ObjZav[i].bParam[10] := false;//--- сбросить признак первого прохода трассировки
          ObjZav[i].bParam[11] := false;//--- сбросить признак второго прохода трассировки
          ObjZav[i].bParam[12] := false;//---- сбросить признак пошерстного "+" в маршруте
          ObjZav[i].bParam[13] := false;//---- сбросить признак пошерстного "-" в маршруте
          ObjZav[i].bParam[14] := false; //---------------- сбросить программное замыкание
          ObjZav[i].iParam[1] := 0; //--------------------------- сбросить индекс маршрута
        end;

        3 :
        begin //------------------------------------------------------------------ участок
          ObjZav[i].bParam[14] := false; //---------------- сбросить программное замыкание
          ObjZav[i].iParam[1] := 0; //---------------------- сбросить счетчик времени МСПД
          ObjZav[i].bParam[8] := true; //-- сбросить предварительное замыкание трассировки
          ObjZav[i].bParam[19] := false;//---------------- сбросить фиксацию неисправности
          ObjZav[i].bParam[22] := false; //------------- сбросить признак ложной занятости
          ObjZav[i].bParam[23] := false;//------------ сбросить признак ложной свободности
        end;

        4 :
        begin //--------------------------------------------------------------------- путь
          ObjZav[i].bParam[14] := false;
          ObjZav[i].iParam[1] := 0;
          ObjZav[i].bParam[8] := true;
          ObjZav[i].bParam[19] := false;
          ObjZav[i].bParam[21] := false;
          ObjZav[i].bParam[22] := false;
          ObjZav[i].bParam[23] := false;
        end;

        5 :
        begin //----------------------------------------------------------------- светофор
          ObjZav[i].bParam[14] := false;
          ObjZav[i].iParam[1] := 0;
          ObjZav[i].bParam[7] := false;
          ObjZav[i].bParam[9] := false;
          ObjZav[i].bParam[19] := false;
          ObjZav[i].bParam[20] := false;
          ObjZav[i].bParam[22] := false;
          ObjZav[i].bParam[23] := false;
        end;

        15 :
        begin //----------------------------------------------------------------------- АБ
          ObjZav[i].bParam[14] := false;
          ObjZav[i].bParam[15] := false;
        end;

        25 :
        begin //------------------------------------------------------- маневровая колонка
          ObjZav[i].bParam[14] := false;
          ObjZav[i].bParam[8] := false;
        end;
      end;
    end;

    //-------------------------------------------- сбросить список фиксированных сообщений
   // FixMessage.Count := 0;
   // FixMessage.MarkerLine := 0;
   // FixMessage.StartLine := 0;
   // maket_strelki_index := 0;
   // maket_strelki_name  := '';

    if State = State then
    begin //---------------------------------- Получено разрешение на включение управления
  {    if not WorkMode.Upravlenie then //--------------------------- если перешли в резерв
      begin //-------------------------------- Выполнить переключение Резерв -> Управление
  }
      for i := 1 to High(ObjZav) do
      begin //---------------------------------------------- Установить состояния объектов
        //------------------------------------------------------------------ применить FR4
        case ObjZav[i].TypeObj of
          1 :
          begin //---------------------------------------------------------- хвост стрелки
            f := fr4[ObjZav[i].ObjConstI[1] div 8]; //-------------------------- буфер FR4
            ObjZav[i].bParam[19] := (f and $2) = $2; //----------------------------- макет
            if ObjZav[i].bParam[19] and (ObjZav[i].RU = config.ru) then
            begin //--------------------------- повесить литер стрелки на макетный шильдик
              maket_strelki_index := i;
              maket_strelki_name  := ObjZav[i].Liter;
            end;
            if ObjZav[i].ObjConstI[8] > 0 then
            begin //------------------------------------ ограничения для ближней стрелки
              ObjZav[ObjZav[i].ObjConstI[8]].bParam[15] := ObjZav[i].bParam[19];//-- макет
              ObjZav[ObjZav[i].ObjConstI[8]].bParam[16] := (f and $4) = $4; //- закр.движ.
              ObjZav[ObjZav[i].ObjConstI[8]].bParam[18] := (f and $1) = $1; //-- откл.упр.
              ObjZav[ObjZav[i].ObjConstI[8]].bParam[17] := (f and $10) = $10;// закрыть ПШ
            end;
            if ObjZav[i].ObjConstI[9] > 0 then
            begin //-------------------------------------- ограничения для дальней стрелки
              ObjZav[ObjZav[i].ObjConstI[9]].bParam[15] := ObjZav[i].bParam[19];//-- макет
              ObjZav[ObjZav[i].ObjConstI[9]].bParam[16] := (f and $8) = $8;//-- закр.движ.
              ObjZav[ObjZav[i].ObjConstI[9]].bParam[18] := (f and $1) = $1; //-- откл.упр.
              ObjZav[ObjZav[i].ObjConstI[9]].bParam[17] := (f and $20) = $20;// закрыть ПШ
            end;
          end;

          3 :
          begin //-------------------------------------------------------------- участок
            f := fr4[ObjZav[i].ObjConstI[1]]; //------------------------------ буфер FR4
            ObjZav[i].bParam[25] := (f and $1) = $1; //---------------- закр.движ.пост.т
            ObjZav[i].bParam[26] := (f and $2) = $2; //----------------- закр.движ.пер.т
            ObjZav[i].bParam[13] := (f and $4) = $4; //---------------------- закр.движ.
            ObjZav[i].bParam[24] := (f and $8) = $8; //------------------- закр.движ.э.т
          end;

          4 :
          begin //----------------------------------------------------------------- путь
            f := fr4[ObjZav[i].ObjConstI[1]]; //------------------------------ буфер FR4
            ObjZav[i].bParam[25] := (f and $1) = $1; //---------------- закр.движ.пост.т
            ObjZav[i].bParam[26] := (f and $2) = $2; //----------------- закр.движ.пер.т
            ObjZav[i].bParam[13] := (f and $4) = $4; //---------------------- закр.движ.
            ObjZav[i].bParam[24] := (f and $8) = $8; //------------------- закр.движ.э.т
          end;

          5 :
          begin //------------------------------------------------------------- светофор
            f := fr4[ObjZav[i].ObjConstI[1]]; //------------------------------ буфер FR4
            ObjZav[i].bParam[13] := (f and $4) = $4; //-------------------- заблокирован
          end;

          15 :
          begin //------------------------------------------------------------------- АБ
            f := fr4[ObjZav[i].ObjConstI[3] div 8]; //------------------------ буфер FR4
            ObjZav[i].bParam[25] := (f and $1) = $1; //---------------- закр.движ.пост.т
            ObjZav[i].bParam[26] := (f and $2) = $2; //----------------- закр.движ.пер.т
            ObjZav[i].bParam[13] := (f and $4) = $4; //---------------------- закр.движ.
            ObjZav[i].bParam[24] := (f and $8) = $8; //------------------- закр.движ.э.т
          end;

          24 :
          begin //---------------------------------------------------------- Увязка с ЭЦ
            f := fr4[ObjZav[i].ObjConstI[8] div 8]; //------------------------ буфер FR4
            ObjZav[i].bParam[25] := (f and $1) = $1; //---------------- закр.движ.пост.т
            ObjZav[i].bParam[26] := (f and $2) = $2; //----------------- закр.движ.пер.т
            ObjZav[i].bParam[15] := (f and $4) = $4; //---------------------- закр.движ.
            ObjZav[i].bParam[24] := (f and $8) = $8; //------------------- закр.движ.э.т
          end;

          26 :
          begin //------------------------------------------------------------------ РПБ
            f := fr4[ObjZav[i].ObjConstI[13] div 8]; //----------------------- буфер FR4
            ObjZav[i].bParam[25] := (f and $1) = $1; //---------------- закр.движ.пост.т
            ObjZav[i].bParam[26] := (f and $2) = $2; //----------------- закр.движ.пер.т
            ObjZav[i].bParam[13] := (f and $4) = $4; //---------------------- закр.движ.
            ObjZav[i].bParam[24] := (f and $8) = $8; //------------------- закр.движ.э.т
          end;

          32 :
          begin //--------------------------------------------------------------- надвиг
            f := fr4[ObjZav[i].ObjConstI[1]]; // буфер FR4
            ObjZav[i].bParam[13] := (f and $4) = $4; // заблокирован
          end;
        end;
      end;
      SingleBeep := false;
      Sound := false;
      SingleBeep3 := false;
      SingleBeep2 := false;
      SingleBeep4 := false;
      SingleBeep5 := false;
      SingleBeep6 := false;
      Ip1Beep := false;
      Ip2Beep := false;

      if not WorkMode.RU[0] and WorkMode.OU[0] then
      begin
        if WorkMode.DU[0] then  //-------------------------- если диспетчерское управление
        begin
          InsArcNewMsg(0,571,0); //------------------- РМ-ДСП переведен в управление от ДЦ
          sMsg:=GetShortMsg(1,571,'',0);
          PutShortMsg(9,LastX, LastY, sMsg);
          AddFixMessage(sMsg,0,0);
          WorkMode.Upravlenie := false;
        end else
        if not WorkMode.Upravlenie then //---------------------- если переход в управление
        begin //------------------------------ Выполнить переключение Резерв -> Управление
          InsArcNewMsg(0,273,2); //-------------- РМ-ДСП переведен в управляющее состояние
          sMsg:=GetShortMsg(1,273,'',2);
          PutShortMsg(5,LastX, LastY, sMsg);
          AddFixMessage(sMsg,0,0);
          WorkMode.Upravlenie := true;
        end else
        if WorkMode.Upravlenie then //------------------------------ если переход в резерв
        begin
          WorkMode.Upravlenie := false;
          InsArcNewMsg(0,274,7);          //------------------- РМ-ДСП переведена в резерв
          sMsg:=GetShortMsg(1,274,'',7);
          PutShortMsg(7,LastX, LastY, sMsg);
          AddFixMessage(sMsg,0,0);
        end;
      end
      else
      begin
        WorkMode.Upravlenie := false;
        InsArcNewMsg(0,570,1);
        sMsg:= GetShortMsg(1,570,'',1);
        AddFixMessage(sMsg,0,0);  //------------------------ отключено управление от РМДСП
        PutShortMsg(1,LastX, LastY, sMsg);
      end;
    end;
  {  end;
    else
    begin //------------------------------------ Получена команда на отключение управления
      if WorkMode.Upravlenie then
      begin //-------------------------------- Выполнить переключение Управление -> Резерв
        ResetCommands;
        WorkMode.Upravlenie := false;
        for i := 1 to High(ObjZav) do
        begin //-------------------------------------------- Установить состояния объектов
        //------------------------------------------------------------------- сбросить FR4
          case ObjZav[i].TypeObj of
            1 :
            begin //-------------------------------------------------------- хвост стрелки
              ObjZav[i].bParam[19] := false; //------------------------------------- макет
              if ObjZav[i].ObjConstI[8] > 0 then
              begin //------------------------------------ ограничения для ближней стрелки
                ObjZav[ObjZav[i].ObjConstI[8]].bParam[15] := false; //-------------- макет
                ObjZav[ObjZav[i].ObjConstI[8]].bParam[16] := false; //--------- закр.движ.
                ObjZav[ObjZav[i].ObjConstI[8]].bParam[18] := false; //---------- откл.упр.
              end;
              if ObjZav[i].ObjConstI[9] > 0 then
              begin //------------------------------------ ограничения для дальней стрелки
                ObjZav[ObjZav[i].ObjConstI[9]].bParam[15] := false; //-------------- макет
                ObjZav[ObjZav[i].ObjConstI[9]].bParam[16] := false; //--------- закр.движ.
                ObjZav[ObjZav[i].ObjConstI[9]].bParam[18] := false; //---------- откл.упр.
              end;
            end;

            3 :
            begin //-------------------------------------------------------------- участок
              ObjZav[i].bParam[13] := false; //-------------------------------- закр.движ.
              ObjZav[i].bParam[24] := false; //----------------------------- закр.движ.э.т
              ObjZav[i].bParam[25] := false; //-------------------------- закр.движ.пост.т
              ObjZav[i].bParam[26] := false; //--------------------------- закр.движ.пер.т
            end;

            4 :
            begin //----------------------------------------------------------------- путь
              ObjZav[i].bParam[13] := false; //-------------------------------- закр.движ.
              ObjZav[i].bParam[24] := false; //----------------------------- закр.движ.э.т
              ObjZav[i].bParam[25] := false; //-------------------------- закр.движ.пост.т
              ObjZav[i].bParam[26] := false; //--------------------------- закр.движ.пер.т
            end;

            5 : ObjZav[i].bParam[13] := false; //------------------- светофор заблокирован

            15 :
            begin //------------------------------------------------------------------- АБ
              ObjZav[i].bParam[13] := false; //-------------------------------- закр.движ.
              ObjZav[i].bParam[24] := false; //----------------------------- закр.движ.э.т
              ObjZav[i].bParam[25] := false; //-------------------------- закр.движ.пост.т
              ObjZav[i].bParam[26] := false; //--------------------------- закр.движ.пер.т
            end;

            24 :
            begin //---------------------------------------------------------- Увязка с ЭЦ
              ObjZav[i].bParam[15] := false; //-------------------------------- закр.движ.
              ObjZav[i].bParam[24] := false; //----------------------------- закр.движ.э.т
              ObjZav[i].bParam[25] := false; //-------------------------- закр.движ.пост.т
              ObjZav[i].bParam[26] := false; //--------------------------- закр.движ.пер.т
            end;

            26 :
            begin //------------------------------------------------------------------ РПБ
              ObjZav[i].bParam[13] := false; //-------------------------------- закр.движ.
              ObjZav[i].bParam[24] := false; //----------------------------- закр.движ.э.т
              ObjZav[i].bParam[25] := false; //-------------------------- закр.движ.пост.т
              ObjZav[i].bParam[26] := false; //--------------------------- закр.движ.пер.т
            end;

            32 : ObjZav[i].bParam[13] := false;//--------------------- надвиг заблокирован

          end;
        end;
        InsArcNewMsg(0,274);
        AddFixMessage(GetShortMsg(1,274,''),0,2);
      end;
    end;
    }
  except
    reportf('Ошибка [TabloForm.ChangeDirectState]');
    Application.Terminate;
  end;
end;

//========================================================================================
//-------------------------------------------------------------- Изменить район управления
procedure ChangeRegion(RU : Byte);
var
  i: Integer;
  f : Byte;
begin
  try
    ChRegion := false;
    if ChDirect or WorkMode.Upravlenie or SendToSrvCloseRMDSP then exit;
    config.ru := RU;
    //------------------------------------------- Установить позицию вывода запроса пароля
    PasswordPos.X := configRU[config.ru].MsgLeft+1;
    PasswordPos.Y := configRU[config.ru].MsgTop+1;

    for i := 1 to High(ObjZav) do //---------------- проход по всем объектам  зависимостей
    begin //------------------------------------------------ Установить состояния объектов
      case ObjZav[i].TypeObj of
        1 :
        begin //------------------------------------------------------------ хвост стрелки
          f := fr4[ObjZav[i].ObjConstI[1] div 8]; //------- получить индекс для буфера FR4
          if ((f and $2)=$2) and (ObjZav[i].RU = config.ru) then // если стрелка на макете
          begin //----------------------------- повесить литер стрелки на макетный шильдик
            maket_strelki_index := i;
            maket_strelki_name  := ObjZav[i].Liter;
          end;
        end;
      end;
    end;
    ResetAllPlakat; //------------------------------------------------- убрать все плакаты
    SetParamTablo;
  except
    reportf('Ошибка [TabloForm.ChangeRegion]'); Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------ Блокировка запроса на изменение размеров окна
procedure TTabloMain.FormCanResize (Sender :TObject; var NewWidth, NewHeight : Integer;
var Resize : Boolean);
begin
  Resize := isChengeRegion;
end;

//========================================================================================
//------------------------------------------- Обработка каналов АСУ (сеть верхнего уровня)
procedure TTabloMain.ASUTimer(Sender: TObject);
begin
  IkonSend := true; //-- сформировать принудительный обмен по каналам АСУ в случае простоя
end;

end.

