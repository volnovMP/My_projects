unit comport;
//--------------------------------------------------
//
// Модуль последовательных коммуникационных портов
//
// Версия              - 1
// количество редакций - 5
// Последняя редакция  - 18 августа 2004 года
//
//--------------------------------------------------

{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  SyncObjs,
  Registry;

const

  // Идентификаторы ошибок при операция с СОМ-портом
  cpeOpenFailed    = $01;
  cpeConfigFailed  = $02;
  cpeClearFailed   = $03;
  cpeTrmInitFailed = $04;
  cpeTrmEndFailed  = $05;
  cpeTrmMistake    = $06;
  cpeTrmEndOverlap = $07;
  cpeRcvInitFailed = $08;
  cpeRcvEndFailed  = $09;
  cpeRcvMistake    = $0A;
  cpeRcvEndOverlap = $0B;
  cpeRcvNoBytes    = $0C;

  // Ошибки при операциях с СОМ-портами
  CPortErrName : array[$01..$0C] of String[70] =
    (
      'Не удалось открыть коммуникационный порт %s.',
      'Не удалось сконфигурировать порт %s!',
      'Не удалось очистить последнюю операцию %s.',
      'Не удалось инициировать передачу сообщения по %s.',
      'Не удалось завершить передачу сообщения по %s.',
      'Ошибка при передаче сообщения по %s.',
      'Неверное завершение передачи сообщения по %s.',
      'Не удалось инициировать прием сообщения по %s.',
      'Не удалось завершить прием сообщения по %s.',
      'Ошибка при приеме сообщения по %s.',
      'Неверное завершение приема сообщения по %s.',
      'Нет принятых байтов по порту %s.'
    );

  // Сообщения из модуля
  CPM_TRMFAILED  = WM_USER + $7000;      // Ошибка при передаче
  CPM_TRMSUCCESS = CPM_TRMFAILED + 1;    // Успешное завершение передачи
  CPM_RCVFAILED  = CPM_TRMSUCCESS + 1;   // Ошибка при приеме
  CPM_RCVSUCCESS = CPM_RCVFAILED + 1;    // Успешное завершение приема

  // Сообщения в модуль
  CPM_FILLANDSEND = CPM_RCVSUCCESS + 1;  // Заполнить буфер и начать передачу
  CPM_RCVSTART    = CPM_FILLANDSEND + 1; // Начать прием
  CPM_CANCEL      = CPM_RCVSTART + 1;    // Прервать все операции с портом
  CPM_CANCELRCV   = CPM_CANCEL + 1;      // Прервать прием
  CPM_CANCELTRM   = CPM_CANCELRCV + 1;   // Прервать передачу
  CPM_TRMSIGNAL   = CPM_CANCELTRM + 1;   // Сигнал события передатчика
  CPM_RCVSIGNAL   = CPM_TRMSIGNAL + 1;   // Сигнал события приемника
  CPM_RTSTGL      = CPM_RCVSIGNAL + 1;   // Установка сигнала RST
  CPM_PURGECOMM   = CPM_RTSTGL + 1;      // Явно прерывает операции

type

  // Тип номеров СОМ-портов
  TComNum = 1..4;

  // Имена СОМ-портов
  TPortName = type string;

  // Типы ОС
  TOSystem = ( osWinNT, osWin3x, osWin9x, osWinMe, osWin2k, osWinXP);

  // Тип управления портом по сигналу DTR
  TDTRControl = ( dtr_Disable, dtr_Enable, dtr_Handshake);

  // Тип управления портом по сигналу RTS
  TRTSControl = ( rts_Disable, rts_Enable, rts_Handshake, rts_Toggle);

  // Тип числа битов в символе
  TSymbSize = 4..8;

  // Тип паритета
  TParity = ( pt_No, pt_Odd, pt_Even, pt_Mark, pt_Space);

  // Тип стоп-битов
  TStopBits = ( sb_One, sb_OneHalf, sb_Two);

  // Тип скоростей передачи
  TBaudRate = ( br_50, br_100, br_300, br_600, br_1200, br_2400, br_4800,
                br_9600, br_14400, br_19200, br_28800, br_38400, br_57600,
                br_115200);

  // Тип управления потоком
  TFlowControl = ( fc_No, fc_XonXoff, fc_Hardware);

  // Буферы портов
  TPortBuffer = record
    Info      : array [ 0..4095] of Byte;// Информация буфера
    Head      : Word;                    // Голова буфера
    Tail      : Word;                    // Хвост буфера
    State     : Cardinal;                // Состояние буфера
  end; // TPortBuffer

//------------------------------------------------------------------------
//       Класс последовательного коммуникационного порта TComPort
//------------------------------------------------------------------------
  TComPort = class( TComponent)
  private
    FPortName     : TPortName;          // Имя порта
    FBaudRate     : TBaudRate;          // Скорость передачи
    FParityEn     : Boolean;            // Разрешение обработки паритета
    FFlowCtrl     : TFlowControl;       // Управление потоком
    FCTSFlow      : Boolean;            // Управление выходом сигналом CTS
    FDSRFlow      : Boolean;            // Управление выходом сигналом DSR
    FDTRControl   : TDTRControl;        // Тип управления по сигналу DTR
    FDSRSense     : Boolean;            // Влияние DSR на течение обмена
    FTxCont       : Boolean;            // Продолжать передачу после Xoff
    FOutX         : Boolean;            // Флаг исп. XonXoff при передаче
    FInX          : Boolean;            // Флаг исп. XonXoff при приеме
    FErrorReplace : Boolean;            // Заменять байты с ош. на ErrorChar
    FDiscardNull  : Boolean;            // Удалять нулевые байты из сообщ.
    FRTSControl   : TRTSControl;        // Тип управления по сигналу RTS
    FAbortOnError : Boolean;            // Прерывать обмен при ошибке
    FXonLim       : LongInt;            // Мин. кол-во байт в буфере перед Xon
    FXoffLim      : LongInt;            // Макс. кол-во байт в буфере перед Xoff
    FSymbSize     : TSymbSize;          // Кол-во бит в символе
    FParity       : TParity;            // Тип паритета
    FStopBits     : TStopBits;          // Кол-во стоп-битов
    FXonChar      : Byte;               // Код символа Xon
    FXOffChar     : Byte;               // Код символа Xoff
    FErrorChar    : Byte;               // Код символа ошибки
    FEofChar      : Byte;               // Код символа конца данных
    FEvtChar      : Byte;               // Код символа сигнализации события
    FToTotal      : Boolean;            // Исп. общий таймаут сообщения
    FToIntv       : Boolean;            // Исп. интервальный таймаут
    FToValue      : Cardinal;           // Величина общего таймаута в мс
    FWindowHandle : HWND;               // Обработчик порта
    MessageDest   : HWND;               // Окно назначения сообщения
    s             : string;             // Строковые переменные для работы порта(1)
    sp            : string;             //                                      (2)
  protected
    TimeOuts    : TCommTimeouts;        // Таймауты ожидания
    function    GetCommNames : Boolean;
    procedure   CalcTimeouts;
    procedure   FillDCB;
    procedure   Loaded; override;
    procedure   WndProc(var Msg : TMessage); virtual;
  public
    rcverrcnt   : cardinal;               // Счетчик ошибок порта по приему
    trmerrcnt   : cardinal;               // Счетчик ошибок порта по передаче
    Buffer      : array[0..4095] of char; // Буфер порта
    OSType      : TOSystem;               // Код операционной системы
    PortIsOpen  : boolean;                // Порт открыт
    PortHandle  : Cardinal;               // Обработчик порта
    PortDCB     : DCB;                    // Структура управления порта
    PortError   : Cardinal;               // Номер последней ошибки порта
    TrmOLS      : TOverlapped;            // Структура перекрытия передачи
    lvCdt       : Cardinal;
    TrmEvent    : TEvent;                 // Событие по окончании передачи
    TrmBuf      : TPortBuffer;            // Буфер передачи
    TrmdBytes   : Cardinal;               // Реально переданных байт
    TrmInProg   : Boolean;                // Флаг течения передачи
//    PortRSA     : TSecurityAttributes;    // Индивидуальные атрибуты передачи
    RcvOLS      : TOverlapped;            // Структура перекрытия приема
    lvCdr       : Cardinal;
    RcvEvent    : TEvent;                 // Событие по окончании приема
    RcvBuf      : TPortBuffer;            // Буфер приема
    RcvdBytes   : Cardinal;               // Реально принятых байт
    RcvInProg   : Boolean;                // Флаг течения приема
//    PortTSA     : TSecurityAttributes;    // Индивидуальные атрибуты передачи
    constructor Create( AOwner : TComponent); override;
    destructor  Destroy; override;
    function    RTSOnOff( aOn :Boolean) :Boolean;
    function    DTROnOff( aOn :Boolean) :Boolean;
    procedure   AsyncSignal( Sender :TObject; var Done :Boolean);
    function    CalcSequenceTime( aNum : Cardinal) :Cardinal;
    procedure   GetSignalState( var Msg :TMsg; var Handled :Boolean);
    function    GetWindowHandle :HWND;
    function    RecieveLine( ASymbNum :Word; AIndex :Word) :Boolean;
    procedure   RecieveFinish;
    procedure   SetMessageDest( aMessageDest :HWND);
    function    SyncRecieve(var Buffer; aSymbNum: Cardinal): Boolean;
    function    SyncTransmit(const Buffer; aSymbNum: Cardinal): Boolean;
    function    TransmitLine( ASymbNum :Word; AIndex :Word) :Boolean;
    procedure   TransmitFinish;
    function    OpenPort  : Boolean;
    function    ClosePort : Boolean;
    function    InitPort(CommPortParam: string) : Boolean;
    function    StrToComm(trmstring: string) : longword;
    function    StrFromComm(var rcvstring: string) : boolean;
    function    BufToComm(Buf: pchar; Len : Integer) : cardinal;
    function    BufFromComm(Buf: pchar; MaxLen : Integer) : cardinal;
  published
    property PortName     : TPortName read FPortName write FPortName;
    property BaudRate     : TBaudRate read FBaudRate write FBaudRate default br_600;
    property ParityEn     : Boolean read FParityEn write FParityEn default TRUE;
    property FlowCtrl     : TFlowControl read FFlowCtrl write FFlowCtrl default fc_No;
    property CTSFlow      : Boolean read FCTSFlow write FCTSFlow default FALSE;
    property DSRFlow      : Boolean read FDSRFlow write FDSRFlow default FALSE;
    property DTRControl   : TDTRControl read FDTRControl write FDTRControl default dtr_Disable;
    property DSRSense     : Boolean read FDSRSense write FDSRSense default FALSE;
    property TxCont       : Boolean read FTxCont write FTxCont default FALSE;
    property OutX         : Boolean read FOutX write FOutX default FALSE;
    property InX          : Boolean read FInX write FInX default FALSE;
    property ErrorReplace : Boolean read FErrorReplace write FErrorReplace default FALSE;
    property DiscardNull  : Boolean read FDiscardNull write FDiscardNull default FALSE;
    property RTSControl   : TRTSControl read FRTSControl write FRTSControl default rts_Disable;
    property AbortOnError : Boolean read FAbortOnError write FAbortOnError default FALSE;
    property XonLim       : LongInt read FXonLim write FXonLim default 1;
    property XOffLim      : LongInt read FXoffLim write FXoffLim default 512;
    property SymbSize     : TSymbSize read FSymbSize write FSymbSize default 7;
    property Parity       : TParity read FParity write FParity default pt_Odd;
    property StopBits     : TStopBits read FStopBits write FStopBits default sb_Two;
    property XOnChar      : Byte read FXonChar write FXonChar default 3;
    property XOffChar     : Byte read FXoffChar write FXoffChar default 2;
    property ErrorChar    : Byte read FErrorChar write FErrorChar default 23;
    property EofChar      : Byte read FEofChar write FEofChar default 4;
    property EvtChar      : Byte read FEvtChar write FEvtChar default 25;
    property ToTotal      : Boolean read FToTotal write FToTotal;
    property ToIntv       : Boolean read FToIntv write FToIntv;
    property ToValue      : Cardinal read FToValue write FToValue default 1000;
  end;

const
  // Численные значения скоростей передачи
  CBaudRateArray : array[ TBaudRate] of Cardinal =
  (50, 100, 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200);

var
  CommNames : TStringList;  // Список имен всех портов

implementation

//-----------------------------------------------------------------------
constructor TComPort.Create( AOwner : TComponent);
  begin
  inherited Create( AOwner);
  // Установить обработчик порта
  FWindowHandle := AllocateHWnd(WndProc);
  // Установить HWND на окно назначения сообщений
  if (Owner <> nil) and (Owner is TWinControl) then
    MessageDest := (Owner as TWinControl).Handle
  else
    MessageDest := 0; // Если не является потомком класса TWinControl
  // Получить список доступных в системе последовательных коммуникационных портов
  if CommNames = nil then
  begin
    // Если не инициализирован список доступный последовательных портов - получить полный список
    CommNames := TStringList.Create;
    if not GetCommNames then
    begin
      ShowMessage('Не обнаружено зарегистрированных СОМ-портов!'+ #13+ 'Программа завершает работу.');
      Application.Terminate;
      Exit;
    end;
  end;
  // Установка параметров порта по умолчанию
  rcverrcnt  := 0;
  trmerrcnt  := 0;
  PortIsOpen := false;   // Порт закрыт
  FBaudRate  := br_9600; // скорость 9600 бод
  FFlowCtrl  := fc_No;   // Выключено управление потоком
  FXOnLim    := 1;
  FXOffLim   := 512;
  FSymbSize  := 8;       // Символ 8 бит
  FParity    := pt_No;   // Контроль паритета отсутствует
  FStopBits  := sb_One;  // Один стоп-бит
  FXOnChar   := 3;
  FXOffChar  := 2;
  FErrorChar := 23;
  FEofChar   := 4;
  FEvtChar   := 25;
  FToTotal   := false;
  FToIntv    := false;
  FToValue   := 1000;
  TrmEvent := TEvent.Create(nil,TRUE,TRUE,'CPM_TRANSMIT_COMPLETE');
  if TrmEvent.Handle = 0 then
  begin
    Application.Terminate;
    Exit;
  end else
    TrmOLS.hEvent := TrmEvent.Handle;
  RcvEvent := TEvent.Create(nil,TRUE,TRUE,'CPM_RECIEVE_COMPLETE');
  if RcvEvent.Handle = 0 then
  begin
    Application.Terminate;
    Exit;
  end else
    RcvOLS.hEvent := RcvEvent.Handle;
  // Сбросить флаг течения передачи
  TrmInProg := FALSE;
  // и приема
  RcvInProg := FALSE;
end; // TComPort.Create

//-------------------------------------------------------------------------
destructor TComPort.Destroy;
begin
  // Освободить обработчик порта для системы
  DeallocateHWnd(FWindowHandle);
  // Закрыть обработчик порта
  if PortIsOpen then CloseHandle(PortHandle);
  inherited;
end; // TComPort.Destroy

//-----------------------------------------------------------------------------
// Записать буфер в порт
function TComPort.BufToComm(Buf: pchar; Len : Integer) : cardinal;
  var lpe : DWORD; lps : COMSTAT; lpNBWri : Cardinal;
begin
  Result := 0;
  // Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    if Len > 0 then
    begin
      // Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
      if not WriteFile( PortHandle, Buf[0], Len, lpNBWri, @TrmOLS) then
      begin
        if GetLastError <> ERROR_IO_PENDING then
        begin  // Ошибка не является флагом отложенной передачи
          PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
          // Увеличить счетчик ошибок передачи порта.
          inc(trmerrcnt); Exit;
        end;
      end;
      if integer(TrmOLS.InternalHigh) <> Len then
        inc(trmerrcnt); // Увеличить счетчик ошибок передачи порта, если кол-во принятых для передачи символов(TrmOLS.InternalHigh) отличается от длины передаваемого сообщения(i)
    end;
    result := TrmOLS.InternalHigh; // Вернуть кол-во записанных в порт символов.
  end;
end;

//-----------------------------------------------------------------------------
// Записать строку символов в порт
function TComPort.StrToComm(trmstring: string) : longword;
  var i : integer; lpe : DWORD; lps : COMSTAT; lpNBWri : Cardinal;
begin
  Result := 0;
  // Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    i := Length(trmstring);
    // Вычислить длину сообщения для записи в буфер порта.
    if i > (Length(Buffer) - integer(lps.cbOutQue)) then
      i := Length(Buffer) - integer(lps.cbOutQue);
    // Длина сообщения(i) = длина буфера(Length(soob)) - кол-во символов в буфере порта, оставшихся после последней передачи(lps.cbOutQue).
    if i > 0 then
    begin
      // Копировать данные в буфер
      Move(trmstring[1], Buffer[0], i);
      // Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
      if not WriteFile( PortHandle, Buffer, i, lpNBWri, @TrmOLS) then
      begin
        if GetLastError <> ERROR_IO_PENDING then
        begin  // Ошибка не является флагом отложенной передачи
          PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
          // Увеличить счетчик ошибок передачи порта.
          inc(trmerrcnt);
          Exit;
        end;
      end;
      if integer(TrmOLS.InternalHigh) <> i then
        // Увеличить счетчик ошибок передачи порта, если кол-во принятых для передачи символов(TrmOLS.InternalHigh) отличается от длины передаваемого сообщения(i)
        inc(trmerrcnt);
    end;
    // Вернуть кол-во записанных в порт символов.
    result := i;
  end;
end; // TComport.StrToComm


//-----------------------------------------------------------------------------
// Прочитать из порта в буфер
function TComPort.BufFromComm(Buf: pchar; MaxLen : Integer) : cardinal;
  var j : integer; lpe : DWORD; lps : COMSTAT; lpNBRd : Cardinal;
begin
  lpNBRd := 0;
  Result := 0;
  // Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    j := lps.cbInQue; // Кол-во символов готовых для чтения из порта
    // Сравнить кол-во прочитанных символов с длиной буфера
    if j > MaxLen then j := MaxLen; // Ограничить кол-во читаемых символов по длине буфера
    if j > 0 then
    begin
      // Прочитать буфер порта (j = количество символов в буфере)
      if not ReadFile( PortHandle, Buf[0], j, lpNBRd, @RcvOLS) then
      begin // Завершение с ошибкой
        if GetLastError <> ERROR_IO_PENDING then
        begin  // Ошибка не является флагом отложенной передачи
          PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
          // Увеличить счетчик ошибок порта по чтению
          inc(rcverrcnt); Exit;
        end;
      end;
      // Проверить соответствие кол-ва полученных из порта символов
      if j <> integer(lpNBRd) then inc(rcverrcnt); // Увеличить счетчик ошибок порта по приему если счетчик прочитанных символов(lpNBRd) отличается от кол-ва символов, запрашиваемых из буфера порта(j).
    end;
  end;
  result := lpNBRd;
end;

//-----------------------------------------------------------------------------
// Чтение полученных данных из порта
function TComPort.StrFromComm(var rcvstring: string) : boolean;
  var i,j : integer; lpe : DWORD; lps : COMSTAT; lpNBRd : Cardinal;
  label lp1;
begin
  Result := false;
  rcvstring := '';
lp1:
  // Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    // Кол-во символов готовых для чтения из порта
    j := lps.cbInQue;
    // Сравнить кол-во прочитанных символов с длиной буфера
    if j > Length(Buffer) then
      // Ограничить кол-во читаемых символов по длине буфера
      j := Length(Buffer);
    if j > 0 then
    begin
      // Прочитать буфер порта (j = количество символов в буфере)
      if not ReadFile( PortHandle, Buffer, j, lpNBRd, @RcvOLS) then
      begin // Завершение с ошибкой
        if GetLastError <> ERROR_IO_PENDING then
        begin  // Ошибка не является флагом отложенной передачи
          PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
          // Увеличить счетчик ошибок порта по чтению
          inc(rcverrcnt);
          Exit;
        end;
      end;
      // Скопировать символы из буфера в строку
      for i := 0 to j-1 do
        rcvstring := rcvstring + Buffer[i];
      // Проверить соответствие кол-ва полученных из порта символов
      if j <> integer(lpNBRd) then
        // Увеличить счетчик ошибок порта по приему если счетчик прочитанных символов(lpNBRd) отличается от кол-ва символов, запрашиваемых из буфера порта(j).
        inc(rcverrcnt);
      goto lp1;
    end;
  end;
  result := true;
end; // TComport.StrFromComm

//------------------------------------------------------------------------------
// Инициализация СОМ порта
//
// Параметры передаются в одной строке, разделенные запятыми:
//  - Номер порта
//  - Код скорости работы порта в соответствии с CBaudRateArray
//  - Паритет в соответствии с TParity
//  - Код количества стоп-битов в соответствии с TStopBits
//  - Кол-во бит в символе в соответствии с TSymbSize
//  - Код символа сигнализации события FEvtChar
//
//  Если значение параметра пустое - оставить прежнее значение
//
//  Код завершения true при отсутствии ошибок в параметрах, иначе false
//
function TComPort.InitPort(CommPortParam: string) : Boolean;
  var
    i,p  : integer;
begin
  s := CommPortParam;
  i := 1;
  result := false;
  sp := '';
  // Установить номер порта
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then exit;
  end;
  inc(i);
  if i > Length(s) then exit;
  sp := 'COM'+ sp;
  if (CommNames = nil) or (CommNames.IndexOf(sp) < 0) then
    exit;// Завершить с ошибкой если такой порт не зарегистрирован в списке последовательных портов
  PortName := sp; // Наименование порта
  sp := '';
  // Скорость работы порта
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then exit;
  end;
  if sp <> '' then
  begin
    try p := StrToInt(sp) except
      exit;// Завершить с ошибкой если параметр скорости задан не верно
    end;
    FBaudRate := TBaudRate(p); // скорость обмена
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;
  sp := '';
  // Тип паритета
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then exit;
  end;
  if sp <> '' then
  begin
    try p := StrToInt(sp) except
      exit;// Завершить с ошибкой если параметр паритета задан не верно
    end;
    FParity := TParity(p); // Паритет
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;
  sp := '';
  // Код количества стоп-битов
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then exit;
  end;
  if sp <> '' then
  begin
    try p := StrToInt(sp) except
      exit;// Завершить с ошибкой если параметр количества стоп-битов задан не верно
    end;
    FStopBits := TStopBits(p); // кол-во стоп битов
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;
  sp := '';
  // Количество бит в символе
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then break;
  end;
  if sp <> '' then
  begin
    try p := StrToInt(sp) except
      exit;// Завершить с ошибкой если параметр количества бит в символе задан не верно
    end;
    FSymbSize := TSymbSize(p); // кол-во бит в символе
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;
  sp := '';
  // Код символа сигнализации события
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then break;
  end;
  if sp <> '' then FEvtChar := byte(sp[1]); // Код символа сигнализации события
  result := true;
end; // TComPort.InitPort

//-------------------------------------------------------------------------
function TComPort.ClosePort : Boolean;
// Закрыть обработчик порта
begin
  result := CloseHandle(PortHandle);
  if result then
    PortIsOpen := false;
end; // TComPort.ClosePort

//-------------------------------------------------------------------------
// Вычислить параметры таймаутов
procedure TComPort.CalcTimeouts;
  var
    HSL : Byte;
begin
  // Длина символа в битах
  HSL := FSymbSize + 2; // Стартовый и 1 (один) стоповый
  if FStopBits <> sb_One then   // Если больше одного стопового
    Inc( HSL);
  if ( FParity <> pt_No) and FParityEn then  // За счет бита паритета
    Inc( HSL);
  with Timeouts do
    begin
    // Таймауты чтения
    if FToIntv then
      begin
      // Таймаут ожидания следующего символа при приеме
      ReadIntervalTimeout :=
        10 * ( Trunc( HSL * 1000 / CBaudRateArray[ FBaudRate]) + 1);
      end
    else
      ReadIntervalTimeout := 0;
    if FToTotal then
      begin
      // Таймаут ожидания одного символа в сообщении
      ReadTotalTimeoutMultiplier :=
        Trunc( HSL * 1000 / CBaudRateArray[ FBaudRate]) + 1;
      // Постоянная составляющая таймаута ожидания сообщения
      ReadTotalTimeoutConstant := FToValue;
      end
    else
      begin
      // Таймаут ожидания одного символа в сообщении
      ReadTotalTimeoutMultiplier := 0;
      // Постоянная составляющая таймаута ожидания сообщения
      ReadTotalTimeoutConstant := 0;
      end;
    // Таймауты записи
    WriteTotalTimeoutMultiplier :=
      Trunc( HSL * 1000 / CBaudRAteArray[ FBaudRate]) + 1;
    WriteTotalTimeoutConstant := 50;
    end;
  SetCommTimeouts( PortHandle, Timeouts);
end; // TComPort.CalcTimeouts

//-------------------------------------------------------------------------
// Определяет зарегистрированные в реестре Windows имена посл. портов
//    и формирует список имен в переменной CommNames.
//  Возвращает TRUE при наличии хотя бы одного порта,
//    иначе    FALSE
function TComPort.GetCommNames : Boolean;
  var
    VReg : TRegistry;
    i,j  : integer;
    val  : TStringList;
begin
  Result := FALSE;
  VReg   := TRegistry.Create;
  Val    := TStringList.Create;
  with VReg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion') then
    begin
      GetValueNames( Val );
      for i := 0 to Val.Count - 1 do
      begin
        if (Val.Strings[i] = 'Version') and (ReadString(Val.Strings[I]) = 'Windows 98') then
        begin
          // Windows 98
          CloseKey;
          OSType := osWin9x;
          try
            if not OpenKeyReadOnly( 'Hardware\DeviceMap\SerialComm') then
            begin
              Free;
              Val.Free;
              Exit;
            end;
            GetValueNames( CommNames);
            CloseKey;
          finally
            Free;
            Val.Free;
          end; // try .. finally
          Result := ( CommNames <> nil) and ( CommNames.Count > 0);
          exit;
        end;
      end;
    end;
    CloseKey;
    Val.Clear;
    if OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion') then
    begin
      GetValueNames( Val );
      for i := 0 to Val.Count - 1 do
      begin
        if (Val.Strings[i] = 'Version') and (ReadString(Val.Strings[I]) = 'Windows Millennium Edition') then
        begin
          // Windows Me
          CloseKey;
          OSType := osWinMe;
          try
            if not OpenKeyReadOnly( 'Hardware\DeviceMap\SerialComm') then
            begin
              Free;
              Val.Free;
              Exit;
            end;
            GetValueNames( CommNames);
            CloseKey;
          finally
            Free;
            Val.Free;
          end; // try .. finally
          Result := ( CommNames <> nil) and ( CommNames.Count > 0);
          exit;
        end;
      end;
    end;
    CloseKey;
    Val.Clear;
    if OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      GetValueNames( Val );
      for i := 0 to Val.Count - 1 do
      begin
        if (Val.Strings[i] = 'ProductName') and (ReadString(Val.Strings[i]) = 'Microsoft Windows 2000') then
        begin
          // Windows 2k
          CloseKey;
          OSType := osWin2k;
          try
            if not OpenKeyReadOnly( 'Hardware\DeviceMap\SerialComm') then
            begin
              Free;
              Val.Free;
              Exit;
            end;
            GetValueNames( Val);
            for j := 0 to Val.Count-1 do
              CommNames.Add(ReadString(Val.Strings[j]));
            CloseKey;
          finally
            Free;
            Val.Free;
          end; // try .. finally
          Result := ( CommNames <> nil) and ( CommNames.Count > 0);
          exit;
        end;
      end;
    end;

    CloseKey;
    Val.Clear;
    if OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      GetValueNames( Val );
      for i := 0 to Val.Count - 1 do
      begin
        if (Val.Strings[i] = 'ProductName') and (ReadString(Val.Strings[i]) = 'Microsoft Windows XP') then
        begin
          // Windows XP
          CloseKey;
          OSType := osWinXP;
          try
            if not OpenKeyReadOnly( 'Hardware\DeviceMap\SerialComm') then
            begin
              Free;
              Val.Free;
              Exit;
            end;
            GetValueNames( Val);
            for j := 0 to Val.Count-1 do
              CommNames.Add(ReadString(Val.Strings[j]));
            CloseKey;
          finally
            Free;
            Val.Free;
          end; // try .. finally
          Result := ( CommNames <> nil) and ( CommNames.Count > 0);
          exit;
        end;
      end;
    end;
    CloseKey;
    Free;
    Val.Free;
    ShowMessage('В реестре не найдены записи Win98 или Win2k. Последовательные порты недоступны.');
    exit;
  end;
end; // TComPort.GetCommNames

//-------------------------------------------------------------------------
// Заполняет поля коммуникационнной структуры DCB из Win32 SDK
procedure TComPort.FillDCB;
begin
  with PortDCB do
  begin
    // Длина структуры
    DCBLength := SizeOf( DCB);
    // Скорость обмена
    BaudRate := CBaudRateArray [ FBaudRate];
    // Флаги
    Flags := 1; // Для Win32 - fBinary установить обязательно
    if FParityEn then // Использование паритета
      Flags := Flags or $2;
    if FCTSFlow then  // Управление выходом по CTS
      Flags := Flags or $4;
    if FDSRFlow then  // Управление выходом по DSR
      Flags := Flags or $8;
    case FDTRControl of
      dtr_Enable : // Есть управление DTR
        Flags := Flags or $10;
      dtr_Handshake : // Установка соединения с применением DTR
        Flags := Flags or $20;
    end; // case FDTRControl
    if FDSRSense then // Чувствительность к сигналу DSR
      Flags := Flags or $40;
    if FTxCont then  // Продолжение передачи после Xoff
      Flags := Flags or $80;
    if FOutX then  // Использовать XoffXon при передаче
      Flags := Flags or $100;
    if FInX then   // Использовать XoffXon при приеме
      Flags := Flags or $200;
    if FErrorReplace then  // Заменять байты с ошибками на ErrorChar
      Flags := Flags or $400;
    if FDiscardNull then  // Удаление нулевых байтов из сообщения
      Flags := Flags or $800;
    case FRTSControl of
      rts_Enable : // Есть управление RTS
        Flags := Flags or $1000;
      rts_Handshake : // Установка соединения с использованием RTS
        Flags := Flags or $2000;
      rts_Toggle : // Переключение RTS
        Flags := Flags or $3000;
    end; // case FRTSControl
    if FAbortOnError then   // Прерывать обмен при ошибке
      Flags := Flags or $4000;
    // Мин. кол-во байт в буфере перед Xon
    XOnLim := FXOnLim;
    // Макс. кол-во байт в буфере перед Xoff
    XOffLim := FXOffLim;
    // Кол-во бит в символе
    ByteSize := FSymbSize;
    // Тип паритета
    Parity := Ord( FParity);
    // Кол-во стоп-битов
    StopBits := Ord( FStopBits);
    // Код символа Xon
    XonChar := Chr( FXonChar);
    // Код символа Xoff
    XoffChar := Chr( FXoffChar);
    // Код символа ошибки
    ErrorChar := Chr( FErrorChar);
    // Код символа конца данных
    EofChar := Chr( FEofChar);
    // Код символа сигнализации события
    EvtChar := Chr( FEvtChar);
  end;
end; // TComPort.FillDCB

//-------------------------------------------------------------------------
// Установка параметров при создании нового экземпляра класса TComPort
procedure TComPort.Loaded;
begin
  inherited;
  if not FParityEn then // Привести в соответствие указание паритета
    FParity := pt_No;
  case FFlowCtrl of
    fc_No :             // Нет управления потоком
    begin
      // Выключить флаги аапаратного управления
      FCTSFlow    := FALSE;
      FDSRFlow    := FALSE;
      FDTRControl := dtr_Disable;
      FRTSControl := rts_Disable;
      FDSRSense   := FALSE;
      // Выключить флаги программного управления
      FTxCont     := FALSE;
      FOutX       := FALSE;
      FInX        := FALSE;
    end;
    fc_XonXoff :        // Программное управление потоком
    begin
      // Выключить флаги аппаратного управления
      FCTSFlow    := FALSE;
      FDSRFlow    := FALSE;
      FDTRControl := dtr_Disable;
      FRTSControl := rts_Disable;
      FDSRSense   := FALSE;
    end;
    fc_Hardware :       // Аппаратное управление потоком
    begin
      // Выключить флаги программного управления
      FTxCont := FALSE;
      FOutX   := FALSE;
      FInX    := FALSE;
    end;
  end; // case FFlowCtrl
end;   // TComPort.Loaded

//-------------------------------------------------------------------------
// Пытается открыть и сконфигурировать СОМ-порт
// Возвращает TRUE в случае удачи, иначе - FALSE
function TComPort.OpenPort : Boolean;
//  var ct : cardinal;
begin
  OpenPort   := FALSE;
  PortIsOpen := FALSE;
  PortHandle := CreateFile(PChar('\\.\'+FPortName),
                           GENERIC_READ or GENERIC_WRITE, 0,
                           nil, OPEN_EXISTING,
                           FILE_FLAG_OVERLAPPED, 0);
  if PortHandle = INVALID_HANDLE_VALUE then
  begin
    PortError := GetLastError;
    Exit;
  end;
  // Заполнить поля блока управления
  FillDCB;
  if not SetCommState( PortHandle, PortDCB) then
  begin
    PortError := GetLastError;
    Exit;
  end;
  CalcTimeouts;
  lvCdr := EV_RXFLAG;
  SetCommMask( PortHandle, lvCdr);
  CancelIO(PortHandle);
  OpenPort   := TRUE;
  PortIsOpen := TRUE;
end; // TComPort.OpenPort

//-------------------------------------------------------------------------
// Изменяет состояние сигнала RTS - только постоянно !!!
function TComPort.RTSOnOff(aOn: Boolean): Boolean;
begin
  if aOn then
    FRTSControl := rts_Enable
  else
    FRTSControl := rts_Disable;
  FillDCB;
  Result := SetCommState( PortHandle, PortDCB);
end; // TComPort.RTSOnOff

//-------------------------------------------------------------------------
// Изменяет состояние сигнала DTR - только постоянно !!!
function TComPort.DTROnOff(aOn: Boolean): Boolean;
begin
  if aOn then
    FDTRControl := dtr_Enable
  else
    FDTRControl := dtr_Disable;
  FillDCB;
  Result := SetCommState( PortHandle, PortDCB);
end; // TComPort.RTSOnOff

//-----------------------------------------------------------------
// обработчик сообщений порта
procedure TComPort.WndProc( var Msg :TMessage);
begin
  with Msg do
    case Msg of
      CPM_FILLANDSEND : // Заполнить буфер и начать передачу
      begin
        if TrmInProg or ( WParam > SizeOf( TrmBuf.Info)) then
        begin // Если перeдача еще продолжается или длина сообщения слишком велика
          Result := -1;
          Exit;
        end;
        // Скопировать в буфер передачи
        Move( Pointer( LParam)^, TrmBuf.Info[ 0], WParam);
        // Попробовать инициировать передачу
        if TransmitLine( WParam, 0) then
          Result := 0
        else
          Result := -1;
      end;
      CPM_RCVSTART : // Начать прием
      begin
        if RecieveLine( WParam, 0) then
          Result := 0
        else
          Result := -1;
      end;
      CPM_TRMSIGNAL : // Получен сигнал события передачи
      begin
        case TWaitResult( WParam) of
          wrError, wrAbandoned : // ошибка при ожидании
          begin
            PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
            TrmInProg := FALSE;
            TrmEvent.ResetEvent;
          end;
          wrSignaled : // Есть сигнал
          begin
            TransmitFinish;
            TrmEvent.ResetEvent;
          end;
        end; // case TWaitResult( WParam)
      end;
      CPM_RCVSIGNAL : // Получен сигнал события приема
      begin
        case TWaitResult( WParam) of
          wrError, wrAbandoned : // ошибка при ожидании
          begin
            PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
            RcvInProg := FALSE;
            RcvEvent.ResetEvent;
          end;
          wrSignaled : // Есть сигнал
          begin
            RecieveFinish;
            RcvEvent.ResetEvent;
          end;
        end; // case TWaitResult( WParam)
      end;
      CPM_CANCEL : // Прервать операции с портом
      begin
        CancelIO( PortHandle);
        TrmInProg := FALSE;
        RcvInProg := FALSE;
        Result := 0;
      end;
      CPM_CANCELRCV : // Прервать прием
      begin
        PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
        RcvInProg := FALSE;
        Result := 0;
      end;
      CPM_CANCELTRM : // Прервать передачу
      begin
        PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
        TrmInProg := FALSE;
        Result := 0;
      end;
      CPM_RTSTGL : // Изменить управление по RST
      begin
        FRTSControl := TRTSControl( WParam);
        FillDCB;
        Result := Integer( SetCommState( PortHandle, PortDCB));
      end;
      CPM_PURGECOMM : // Явно прерывает операции с COM-портом
      begin
        Result := Integer( PurgeComm( PortHandle, Cardinal( WParam)));
      end;
      else
        Result := DefWindowProc( FWindowHandle, Msg, wParam, lParam);
      end; // case Msg
end; // TComPort.WndProc

//-------------------------------------------------------------------------
function TComPort.GetWindowHandle: HWND;
begin
  Result := FWindowHandle;
end; // TComPort.GetWindowHandle

//-------------------------------------------------------------------------
// Устанавливает обработчик окна назначения сообщений - БЕЗ ПРОВЕРОК !!!
procedure TComPort.SetMessageDest( aMessageDest: HWND);
begin
  MessageDest := aMessageDest;
end; // TComPort.SetMessageDest

//-------------------------------------------------------------------------
// Вычисляет верхнюю границу времени передачи последовательности байт длиной aNum
function TComPort.CalcSequenceTime( aNum: Cardinal): Cardinal;
  var
    hBits : Cardinal;
begin
  // Вычислить чило битов на символ
  hBits := FSymbSize + 2; // Стартовый и 1 (один) стоповый
  if FStopBits <> sb_One then   // Если больше одного стопового
    Inc( hBits);
  if ( FParity <> pt_No) and FParityEn then  // За счет бита паритета
    Inc( hBits);
  // Результат
  Result := ( Trunc( hBits * 1000 / CBaudRateArray[ FBaudRate]) + 1) * aNum ;
end; // TComPort.CalcSequenceTime

//-------------------------------------------------------------------------
// Процедура для использования в качестве обработчика Application.OnMessage
procedure TComPort.GetSignalState( var Msg: TMsg; var Handled: Boolean);
  var
    hWR : TWaitResult;
begin
  Handled := FALSE;
  if not ( TrmInProg or RcvInProg) then
    Exit;
  if TrmInProg then
  begin
    hWR := TrmEvent.WaitFor( 0);
    if hWR <> wrTimeout then
    begin
//      if hWR <> wrAbandoned then
//        TrmEvent.ResetEvent;
      PostMessage( FWindowHandle, CPM_TRMSIGNAL, Cardinal( hWR), 0);
    end
  end;
  if RcvInProg then
  begin
    hWR := RcvEvent.WaitFor( 0);
    if hWR <> wrTimeout then
    begin
//      if hWR <> wrAbandoned then
//        RcvEvent.ResetEvent;
      PostMessage( FWindowHandle, CPM_RCVSIGNAL, Cardinal( hWR), 0);
    end
  end;
end; // TComPort.GetSignalState

//-------------------------------------------------------------------------
// Завершение приема
procedure TComPort.RecieveFinish;
  var
    HErr : Cardinal;
begin
  if not RcvInProg then
  // Выход, если не уст. флаг течения передачи
    Exit;
  // Сбросить флаг течения приема
  RcvInProg := FALSE;
  if GetOverlappedResult( PortHandle, RcvOLS, RcvdBytes, FALSE) then
    // При успешном завершении процедуры
    PostMessage( MessageDest, CPM_RCVSUCCESS, RcvdBytes, 0)
  else
  begin
    // Получить номер ошибки
    HErr := GetLastError;
    // Принудительно завершить все операции с портом
    CancelIO( PortHandle);
    // Сообщение о незавершенности операции передачи
    if HErr = ERROR_IO_INCOMPLETE then
      PostMessage( MessageDest, CPM_RCVFAILED, cpeRcvEndOverlap, HErr)
    else
      PostMessage( MessageDest, CPM_RCVFAILED, cpeRcvEndFailed, HErr);
  end;
end; // TComPort.RecieveFinish

//-------------------------------------------------------------------------
// Прием строки заданной длинны
function TComPort.RecieveLine( ASymbNum :Word; AIndex :Word) :Boolean;
// Попытка инициализировать прием строки длиной ASymbNum
//    в буфер приема с началом по индексу AIndex.
//  Возвращает TRUE при удачной попытке инициализации приема,
//    иначе    FALSE
  var
    HABR : Cardinal;
    HErr : Cardinal;
begin
  Result := FALSE;
  if not ReadFile( PortHandle, RcvBuf.Info[ AIndex], ASymbNum,
                    HABR, @RcvOLS) then
  begin // Завершение с ошибкой
    HErr := GetLastError;
    if HErr <> ERROR_IO_PENDING then
    begin // Ошибка не является флагом отложенной передачи
      CancelIO( PortHandle);
      RcvInProg := FALSE;
      Exit;
    end else // Отложенный прием
      RcvInProg := TRUE;
  end else // Завершение без ошибки
    RecieveFinish;
  Result := TRUE;
end; // TComPort.RecieveLine

//-------------------------------------------------------------------------
// Завершение передачи
procedure TComPort.TransmitFinish;
  var
    HErr : Cardinal;
begin
  if not TrmInProg then // Выход, если не уст. флаг течения передачи
    Exit;
  // Сбросить флаг течения передачи
  TrmInProg := FALSE;
  if GetOverlappedResult( PortHandle, TrmOLS, TrmdBytes, FALSE) then
  begin // При успешном завершении процедуры
    if ( TrmdBytes = 0) then
      PostMessage( MessageDest, CPM_TRMFAILED, cpeTrmEndFailed, 0)
    else
      PostMessage( MessageDest, CPM_TRMSUCCESS, TrmdBytes, 0);
  end else // При ошибочном завершении процедуры
  begin
    // Получить номер ошибки
    HErr := GetLastError;
    // Принудительно завершить все операции с портом
    CancelIO( PortHandle);
    // Сбросить флаг течения приема
    RcvInProg := FALSE;
    // Сообщение о незавершенности передачи
    if HErr = ERROR_IO_INCOMPLETE then
      PostMessage( MessageDest, CPM_TRMFAILED, cpeTrmEndOverlap, HErr)
    else
      PostMessage( MessageDest, CPM_TRMFAILED, cpeTrmEndFailed, HErr);
  end;
end; // TComPort.TransmitFinish

//-------------------------------------------------------------------------
// Передача строки заданной длины
function TComPort.TransmitLine( ASymbNum :Word; AIndex :Word) :Boolean;
// Попытка передать строку длиной ASymbNum из буфера передачи
//    с началом по индексу AIndex.
//  Возвращает TRUE при удачной попытке инициализации обмена,
//    иначе    FALSE
  var
    HABT : Cardinal;
    HErr : Cardinal;
begin
  Result := FALSE;
  if not WriteFile( PortHandle, TrmBuf.Info[ AIndex], ASymbNum,
                    HABT, @TrmOLS) then
  begin // Завершение с ошибкой
    HErr := GetLastError;
    if HErr <> ERROR_IO_PENDING then
    begin // Ошибка не является флагом отложенной передачи
      TrmInProg := FALSE;
      Exit;
    end else // Отложенная передача
      TrmInProg := TRUE;
  end else // Завершение без ошибки
    TransmitFinish;
  Result := TRUE;
end; // TComPort.TransmitLine

//-------------------------------------------------------------------------
// Дает асинхронный сигнал о завершении обмена
procedure TComPort.AsyncSignal( Sender :TObject; var Done :Boolean);
begin
  Done := not( TrmInProg or RcvInProg);
  if TrmInProg then
    case TrmEvent.WaitFor( 0) of
      wrError : // ошибка при ожидании
      begin
        PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
        TrmEvent.ResetEvent;
        TrmInProg := FALSE;
      end;
      wrSignaled : // Есть сигнал
      begin
        TransmitFinish;
        TrmEvent.ResetEvent;
      end;
      wrAbandoned : // Событие было разрушено
      begin
        PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
        TrmInProg := FALSE;
      end;
    end; // case WaitForSingleObject
  if RcvInProg then
    case RcvEvent.WaitFor( 0) of
      wrError : // ошибка при ожидании
      begin
        PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
        RcvEvent.ResetEvent;
        RcvInProg := FALSE;
      end;
      wrSignaled : // Есть сигнал
      begin
        RecieveFinish;
        RcvEvent.ResetEvent;
      end;
      wrAbandoned : // Событие было разрушено
      begin
        PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
        RcvInProg := FALSE;
      end;
    end; // case WaitForSingleObject
end; // TComPort.AsyncSignal

//-------------------------------------------------------------------------
// Синхронизированный (программный) прием. Возвращает TRUE при удачном приеме, иначе - FALSE
function TComPort.SyncRecieve(var Buffer; aSymbNum: Cardinal): Boolean;
  var
    lvCard    : Cardinal;
    lvErr     : Cardinal;
    lvWaitRes : TWaitResult;
begin
  Result := FALSE;
  if not ReadFile( PortHandle, Buffer, aSymbNum, lvCard, @RcvOLS) then
  begin // Завершение с ошибкой
    lvErr := GetLastError;
    if lvErr <> ERROR_IO_PENDING then
    begin  // Ошибка не является флагом отложенной передачи
      PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
      Exit
    end else // Отложенная передача
    begin
      lvCard := 3 * CalcSequenceTime( aSymbNum);
      lvWaitRes := RcvEvent.WaitFor( lvCard);
      GetOverlappedResult( PortHandle, RcvOLS, lvCard, FALSE);
      Result := lvWaitRes = wrSignaled;
      if Result then
        RcvEvent.ResetEvent;
    end
  end else // Завершение без ошибки
  Result := TRUE;
end; // TComPort.SyncRecieve

//-------------------------------------------------------------------------
// Синхронизированная (программная) передача. Возвращает TRUE при удачной передаче, иначе - FALSE
function TComPort.SyncTransmit(const Buffer; aSymbNum: Cardinal): Boolean;
  var
    lvCard    : Cardinal;
    lvErr     : Cardinal;
    lvWaitRes : TWaitResult;
begin
  Result := FALSE;
  if not WriteFile( PortHandle, Buffer, aSymbNum, lvCard, @TrmOLS) then
  begin // Завершение с ошибкой
    lvErr := GetLastError;
    if lvErr <> ERROR_IO_PENDING then
    begin  // Ошибка не является флагом отложенной передачи
      PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
      Exit
    end else // Отложенная передача
    begin
      lvCard := CalcSequenceTime( aSymbNum);
      lvWaitRes := TrmEvent.WaitFor( lvCard);
      Result := lvWaitRes = wrSignaled;
      if Result then
        TrmEvent.ResetEvent;
    end
  end else // Завершение без ошибки
  Result := TRUE;
end; // TComPort.SyncTransmit

end.
