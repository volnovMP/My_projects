unit comport;
//--------------------------------------------------
// Модуль последовательных коммуникационных портов
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

  //-------------------------------------- Идентификаторы ошибок при операция с СОМ-портом
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
//  CPM_TRMFAILED  = WM_USER + $7000;      // Ошибка при передаче
//  CPM_TRMSUCCESS = CPM_TRMFAILED + 1;    // Успешное завершение передачи
//  CPM_RCVFAILED  = CPM_TRMSUCCESS + 1;   // Ошибка при приеме
//  CPM_RCVSUCCESS = CPM_RCVFAILED + 1;    // Успешное завершение приема

  // Сообщения в модуль
//  CPM_FILLANDSEND = CPM_RCVSUCCESS + 1;  // Заполнить буфер и начать передачу
//  CPM_RCVSTART    = CPM_FILLANDSEND + 1; // Начать прием
//  CPM_CANCEL      = CPM_RCVSTART + 1;    // Прервать все операции с портом
//  CPM_CANCELRCV   = CPM_CANCEL + 1;      // Прервать прием
//  CPM_CANCELTRM   = CPM_CANCELRCV + 1;   // Прервать передачу
  CPM_TRMSIGNAL   = WM_USER + $7009;   // Сигнал события передатчика
  CPM_RCVSIGNAL   = CPM_TRMSIGNAL + 1;   // Сигнал события приемника
//  CPM_RTSTGL      = CPM_RCVSIGNAL + 1;   // Установка сигнала RST
 // CPM_PURGECOMM   = CPM_RTSTGL + 1;      // Явно прерывает операции

type

  // Тип номеров СОМ-портов
  TComNum = 1..4;

//------------------------------------------------------------------------
//       Класс последовательного коммуникационного порта TComPort
//------------------------------------------------------------------------
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
    RcvOLS      : TOverlapped;            // Структура асинхронного приема
    lvCdr       : Cardinal;
    RcvEvent    : TEvent;                 // Событие по окончании приема
    RcvBuf      : TPortBuffer;            // Буфер приема
    RcvdBytes   : Cardinal;               // Реально принятых байт
    RcvInProg   : Boolean;                // Флаг течения приема
//========================================================================================
    constructor Create( AOwner : TComponent); override;
    destructor  Destroy; override;
    function    RTSOnOff( aOn :Boolean) :Boolean;
    function    DTROnOff( aOn :Boolean) :Boolean;
    procedure   RecieveFinish;
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

//========================================================================================
constructor TComPort.Create( AOwner : TComponent);
  begin
    inherited Create( AOwner); //--------------------вызов конструктора предка, TComponent
    FWindowHandle := AllocateHWnd(WndProc);  //--------------- Установить обработчик порта
    if (Owner <> nil) and (Owner is TWinControl) then //Установить HWND на окно назначения
    MessageDest := (Owner as TWinControl).Handle
  else MessageDest := 0; //------------------ Если не является потомком класса TWinControl
  if CommNames = nil then  //-------------- Получить список доступных в системе COM-портов
  begin    // Если не инициализирован список доступных COM-портов - получить полный список
    CommNames := TStringList.Create;
    if not GetCommNames then //--------------------------------- если не найдены COM-порты
    begin
      ShowMessage('Нет зарегистрированных СОМ-портов!'+#13+'Программа завершает работу.');
      Application.Terminate;
      Exit;
    end;
  end;
  //---------------------------------------------- Установка параметров порта по умолчанию
  rcverrcnt  := 0;  //------------------------------------------ счетчик ошибок приема = 0
  trmerrcnt  := 0;  //---------------------------------------- счетчик ошибок передачи = 0
  PortIsOpen := false;   //--------------------------------------------------- Порт закрыт
  FBaudRate  := br_9600; //--------------------------------------------- скорость 9600 бод
  FFlowCtrl  := fc_No;   //---------------------------------- Выключено управление потоком
  FXOnLim    := 1;       //--------------------------- Мин. кол-во байт в буфере перед Xon
  FXOffLim   := 512;     //------------------------- Макс. кол-во байт в буфере перед Xoff
  FSymbSize  := 8;       //-------------------------------------------------- Символ 8 бит
  FParity    := pt_No;   //--------------------------------- Контроль паритета отсутствует
  FStopBits  := sb_One;  //------------------------------------------------- Один стоп-бит
  FXOnChar   := 3;       //----------------------------------------------- Код символа Xon
  FXOffChar  := 2;       //------------------------- Макс. кол-во байт в буфере перед Xoff
  FErrorChar := 23;      //-------------------------------------------- Код символа ошибки
  FEofChar   := 4;       //-------------------------------------- Код символа конца данных
  FEvtChar   := 25;      //------------------------------ Код символа сигнализации события
  FToTotal   := false;   //---------------------------------- Исп. общий таймаут сообщения
  FToIntv    := false;   //--------------------------------------Исп. интервальный таймаут
  FToValue   := 1000;    //--------------------------------- Величина общего таймаута в мс
  TrmEvent := TEvent.Create(nil,TRUE,TRUE,'CPM_TRANSMIT_COMPLETE' ); //-- событие передачи
  if TrmEvent.Handle = 0 then  begin Application.Terminate; Exit; end //------- не создано
  else TrmOLS.hEvent := TrmEvent.Handle; //------- установить событие в структуру передачи
  RcvEvent := TEvent.Create(nil,TRUE,TRUE,'CPM_RECIEVE_COMPLETE');//------- событие приема
  if RcvEvent.Handle = 0 then begin Application.Terminate;  Exit; end //------- не создано
  else  RcvOLS.hEvent := RcvEvent.Handle; //-------- установить событие в структуру приема
  TrmInProg := FALSE; //----------------------------------- Сбросить флаг течения передачи
  RcvInProg := FALSE; //--------------------------------------------------------- и приема
end; // TComPort.Create

//========================================================================================
destructor TComPort.Destroy;
begin
  //---------------------------------------------- Освободить обработчик порта для системы
  DeallocateHWnd(FWindowHandle);
  // Закрыть обработчик порта
  if PortIsOpen then CloseHandle(PortHandle);
  inherited;
end; // TComPort.Destroy

//========================================================================================
//------------------------------------------------------------------ Записать буфер в порт
function TComPort.BufToComm(Buf: pchar; Len : Integer) : cardinal;
var
  lpe : DWORD;
  lps : COMSTAT;
  lpNBWri : Cardinal;
begin
  Result := 0;
  //-------------------------------------------------- Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    if Len > 0 then
    begin
      //------------- Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
      if not WriteFile(PortHandle, Buf[0], Len, lpNBWri, @TrmOLS) then
      begin
        if GetLastError <> ERROR_IO_PENDING then
        begin  //--------------------------- Ошибка не была связана с отложенной передачей
          PurgeComm(PortHandle,PURGE_TXABORT or PURGE_TXCLEAR); //------------ сброс порта
          inc(trmerrcnt);//---------------------- Увеличить счетчик ошибок передачи порта.
          Exit;
        end;
      end;
      //---- если кол-во всспринятых для передачи символов(TrmOLS.InternalHigh) отличается
      //-- от длины передаваемого сообщения(i), то увеличить счетчик ошибок передачи порта
      if integer(TrmOLS.InternalHigh) <> Len then inc(trmerrcnt);
    end;
    result := TrmOLS.InternalHigh; //--------- Вернуть кол-во воспринятых портом символов.
  end;
end;

//========================================================================================
//-------------------------------------------------------- Записать строку символов в порт
function TComPort.StrToComm(trmstring: string) : longword;
var
  i : integer;
  lpe : DWORD;
  lps : COMSTAT;
  lpNBWri : Cardinal;
begin
  Result := 0;
  //-------------------------------------------------- Заполнить структуры состояния порта
  if ClearCommError(PortHandle, lpe, @lps) then
  begin
    i := Length(trmstring);
    //-------------------------------- Вычислить длину сообщения для записи в буфер порта.
    if i > (Length(Buffer) - integer(lps.cbOutQue)) then
    i := Length(Buffer) - integer(lps.cbOutQue);
    //-- Длина сообщения(i) = длина буфера(Length(soob)) - кол-во символов в буфере порта,
    //--------------------------------- оставшихся после последней передачи(lps.cbOutQue).
    if i > 0 then
    begin
      //-------------------------------------------------------- Копировать данные в буфер
      Move(trmstring[1], Buffer[0], i);
      //------------- Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
      if not WriteFile( PortHandle, Buffer, i, lpNBWri, @TrmOLS) then //----- для передачи
      begin
        if GetLastError <> ERROR_IO_PENDING then //если ошибка не флаг отложенной передачи
        begin
          PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR); //-------- очистить порт
          inc(trmerrcnt);//---------------------- Увеличить счетчик ошибок передачи порта.
          Exit;
        end;
      end;
      //------- Увеличить счетчик ошибок передачи порта, если кол-во принятых для передачи
      //----- символов(TrmOLS.InternalHigh) отличается от длины передаваемого сообщения(i)
      if integer(TrmOLS.InternalHigh) <> i then inc(trmerrcnt);
    end;
    result := i;    // Вернуть кол-во записанных в порт символов.
  end;
end;

//========================================================================================
//------------------------------------------------------------- Прочитать из порта в буфер
function TComPort.BufFromComm(Buf: pchar; MaxLen : Integer) : cardinal;
var
  j : integer;
  lpe : DWORD;
  lps : COMSTAT;
  lpNBRd : Cardinal;
begin
  lpNBRd := 0;
  Result := 0;
  //-------------------------------------------------- Заполнить структуры состояния порта
  if ClearCommError(PortHandle,lpe,@lps) then//если успешно сброшена ошибка или ее не было
  begin
    j := lps.cbInQue; //---------------------- Кол-во символов готовых для чтения из порта
    //--------------------------------- Сравнить кол-во символов в очереди с длиной буфера
    if j > MaxLen then j := MaxLen; // Ограничить кол-во читаемых символов по длине буфера
    if j > 0 then
    begin
      //------------------------- Прочитать буфер порта (j = количество символов в буфере)
      if not ReadFile( PortHandle, Buf[0], j, lpNBRd, @RcvOLS) then
      begin //------------------------------------------------------- Завершение с ошибкой
        if GetLastError <> ERROR_IO_PENDING then //---- если это не ошибка ожидания данных
        begin
          PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);//----------очистить порт
          inc(rcverrcnt);//---------------------- Увеличить счетчик ошибок порта по чтению
          Exit;
        end;
      end;
      // Проверить соответствие кол-ва полученных из порта символов
      if j <> integer(lpNBRd) then
      inc(rcverrcnt); // Увеличить счетчик ошибок порта по приему если счетчик прочитанных
                      // символов(lpNBRd) отличается от кол-ва символов, запрашиваемых из
                      // буфера порта(j).
    end;
  end;
  result := lpNBRd;
end;
//========================================================================================
//------------------------------------------------------ Чтение полученных данных из порта
function TComPort.StrFromComm(var rcvstring: string) : boolean;
var
  i,j : integer;
  lpe : DWORD;
  lps : COMSTAT;
  lpNBRd : Cardinal;
  label lp1;
begin
  Result := false;
  rcvstring := '';
lp1: 
  if ClearCommError(PortHandle, lpe, @lps) then //---- Заполнить структуры состояния порта
  begin //----------------------------------------------- если функция завершилась успешно
    j := lps.cbInQue;//----------------------- Кол-во символов готовых для чтения из порта
    if j > Length(Buffer) then //----------- если прочитанных символов больше длины буфера
    j := Length(Buffer);//------------ Ограничить кол-во читаемых символов по длине буфера
    if j > 0 then  //------------------------------------------ если есть символы в буфере
    begin //--- Прочитать буфер порта,j-столько хотим прочитать,lpNBRd - столько прочитали
      if not ReadFile(PortHandle,Buffer,j,lpNBRd,@RcvOLS) then
      begin //-------------------------------------------- если чтение завершено с ошибкой
        if GetLastError <> ERROR_IO_PENDING then
        begin  //---------------------- если ошибка не является флагом отложенной передачи
          PurgeComm(PortHandle,PURGE_RXABORT or PURGE_RXCLEAR); //--------- очистить буфер
          inc(rcverrcnt);  //-------------------- Увеличить счетчик ошибок порта по чтению
          Exit;
        end;
      end;
      for i := 0 to j-1 do      //----------------- Скопировать символы из буфера в строку
      rcvstring := rcvstring + Buffer[i]; //----------- добавить в строку данные из буфера
      if j <> integer(lpNBRd) then //-------------- если принято не столько сколько хотели
      inc(rcverrcnt);//-------------------------- Увеличить счетчик ошибок порта по приему
      goto lp1; //--------------------------------- проверить нет ли еще приема
    end;
  end;
  result := true;
end;
//========================================================================================
//---------------------------------------------------------------- Инициализация СОМ порта
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
  //--------------------------------------------------------------- Установить номер порта
  sp := '';
  while s[i] <> ',' do
  begin sp := sp + s[i]; inc(i); if i > Length(s) then exit; end;
  inc(i);
  if i > Length(s) then exit;
  sp := 'COM'+ sp;
  //----------- Завершить с ошибкой,если такой порт не зарегистрирован в списке COM-портов
  if (CommNames = nil) or (CommNames.IndexOf(sp) < 0) then exit;
  PortName := sp; //--------------------------------------------------- Наименование порта

  //---------------------------------------------------------------- Скорость работы порта
  sp := '';
  while s[i] <> ',' do begin sp := sp + s[i]; inc(i); if i > Length(s) then exit; end;
  if sp <> '' then
  begin
    try p := StrToInt(sp)
    except
      exit;//------------------- Завершить с ошибкой если параметр скорости задан не верно
    end;
    FBaudRate := TBaudRate(p); //----------------------------------------- скорость обмена
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;

  //------------------------------------------------------------------------- Тип паритета
  sp := '';
  while s[i] <> ',' do begin sp := sp + s[i]; inc(i); if i > Length(s) then exit; end;
  if sp <> '' then
  begin
    try p := StrToInt(sp)
    except
      exit;//------------------- Завершить с ошибкой если параметр паритета задан не верно
    end;
    FParity := TParity(p); //----------------------------------------------------- Паритет
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;

  //------------------------------------------------------------ Код количества стоп-битов
  sp := '';
  while s[i] <> ',' do  begin sp := sp + s[i]; inc(i); if i > Length(s) then exit; end;
  if sp <> '' then
  begin
    try p := StrToInt(sp)
    except
      exit;//------ Завершить с ошибкой если параметр количества стоп-битов задан не верно
    end;
    FStopBits := TStopBits(p); //--------------------------------------- кол-во стоп битов
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;

  //------------------------------------------------------------- Количество бит в символе
  sp := '';
  while s[i] <> ',' do  begin sp := sp + s[i]; inc(i); if i > Length(s) then break; end;
  if sp <> '' then
  begin
    try p := StrToInt(sp)
    except
      exit;//--- Завершить с ошибкой если параметр количества бит в символе задан не верно
    end;
    FSymbSize := TSymbSize(p); // кол-во бит в символе
  end;
  inc(i); if i > Length(s) then begin result := true; exit; end;

  //----------------------------------------------------- Код символа сигнализации события
  sp := '';
  while s[i] <> ',' do
  begin
    sp := sp + s[i]; inc(i); if i > Length(s) then break;
  end;
  if sp <> '' then FEvtChar := byte(sp[1]); //----------- Код символа сигнализации события
  result := true;
end; // TComPort.InitPort
//========================================================================================
//--------------------------------------------------------------- Закрыть обработчик порта
function TComPort.ClosePort : Boolean;
begin
  result := CloseHandle(PortHandle);
  if result then PortIsOpen := false;
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
//========================================================================================
// Определяет зарегистрированные в реестре Windows имена посл. портов и формирует список
// имен в переменной CommNames. Возвращает "T" при наличии хотя бы одного порта, иначе "F"
function TComPort.GetCommNames : Boolean;
var
  VReg : TRegistry;
  i  : integer;
  Val  : TStringList;
begin
  Result := false;
  VReg := TRegistry.Create;
  Val    := TStringList.Create;
  with VReg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    try
      if OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
      begin
        GetValueNames( Val );
        for i := 0 to Val.Count - 1 do
        begin
          if (Val.Strings[i] <> '') then  CommNames.Add(ReadString(Val.Strings[i]));
        end;
        Result := ( CommNames <> nil) and ( CommNames.Count > 0);
        CloseKey;
        Val.Free;
        exit;
      end;
    finally
      Free;
    end; //---------------------------------------------------------------- try .. finally
  end;
  Val.Free;
  VReg.Free;
  ShowMessage('В реестре не найдены записи Win98 или Win2k. Com-порты недоступны.');
  exit;
end;// TComPort.GetCommNames
//========================================================================================
// Заполняет поля коммуникационнной структуры DCB из Win32 SDK
procedure TComPort.FillDCB;
begin
  with PortDCB do
  begin
   
    DCBLength := SizeOf( DCB); //----------------------------------------- Длина структуры
    BaudRate := CBaudRateArray [ FBaudRate];//---------------------------- Скорость обмена

    Flags := 1; //----------------------- Флаги Для Win32 - fBinary установить обязательно
    if FParityEn  then Flags := Flags or $2;//--------------------- Использование паритета
    if FCTSFlow   then Flags := Flags or $4;//------------------ Управление выходом по CTS
    if FDSRFlow   then Flags := Flags or $8;//------------------ Управление выходом по DSR

    case FDTRControl of
      dtr_Enable : Flags := Flags or $10;//--------------------------- Есть управление DTR
      dtr_Handshake : Flags := Flags or $20;//----- Установка соединения с применением DTR
    end;

    if FDSRSense      then Flags := Flags or  $40;//------- Чувствительность к сигналу DSR
    if FTxCont        then Flags := Flags or  $80;//------ Продолжение передачи после Xoff
    if FOutX          then Flags := Flags or $100; //--- Использовать XoffXon при передаче
    if FInX           then Flags := Flags or $200;//------ Использовать XoffXon при приеме
    if FErrorReplace  then Flags := Flags or $400;//Заменять байты с ошибками на ErrorChar
    if FDiscardNull   then Flags := Flags or $800;//- Удаление нулевых байтов из сообщения

    case FRTSControl of
      rts_Enable :    Flags := Flags or $1000;//---------------------- Есть управление RTS
      rts_Handshake : Flags := Flags or $2000;// Установка соединения с использованием RTS
      rts_Toggle :    Flags := Flags or $3000;//------------------------- Переключение RTS
    end;

    if FAbortOnError then  Flags := Flags or $4000;//---------- Прерывать обмен при ошибке

    XOnLim :=   FXOnLim;//---------------------------- Мин. кол-во байт в буфере перед Xon
    XOffLim :=  FXOffLim; //------------------------ Макс. кол-во байт в буфере перед Xoff
    ByteSize := FSymbSize; //---------------------------------------- Кол-во бит в символе
    Parity :=   Ord( FParity);//--------------------------------------------- Тип паритета
    StopBits := Ord( FStopBits);//-------------------------------------- Кол-во стоп-битов
    XonChar :=  Chr( FXonChar);//--------------------------------------- Кол-во стоп-битов
    XoffChar := Chr( FXoffChar);//-------------------------------------- Кол-во стоп-битов
    ErrorChar:= Chr( FErrorChar);//------------------------------------ Код символа ошибки
    EofChar :=  Chr( FEofChar);//-------------------------------- Код символа конца данных
    EvtChar :=  Chr( FEvtChar);//------------------------ Код символа сигнализации события
  end;
end;

//========================================================================================
//------------------------------------------- Пытается открыть и сконфигурировать СОМ-порт
//------------------------------------------ Возвращает TRUE в случае удачи, иначе - FALSE
function TComPort.OpenPort : Boolean;
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
  //------------------------------------------------------ Заполнить поля блока управления
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
end;

//========================================================================================
//---------------------------------- Изменяет состояние сигнала RTS - только постоянно !!!
function TComPort.RTSOnOff(aOn: Boolean): Boolean;
begin
  if aOn then  FRTSControl := rts_Enable
  else   FRTSControl := rts_Disable;
  FillDCB;
  Result := SetCommState( PortHandle, PortDCB);
end; // TComPort.RTSOnOff
//========================================================================================
//---------------------------------- Изменяет состояние сигнала DTR - только постоянно !!!
function TComPort.DTROnOff(aOn: Boolean): Boolean;
begin
  if aOn then  FDTRControl := dtr_Enable
  else FDTRControl := dtr_Disable;
  FillDCB;
  Result := SetCommState( PortHandle, PortDCB);
end; // TComPort.RTSOnOff
//========================================================================================
//------------------------------------------------------------- обработчик сообщений порта
procedure TComPort.WndProc( var Msg :TMessage);
begin
  with Msg do
    case Msg of
      //------------- CPM_TRMSIGNAL   = WM_USER + $7009  ------ Сигнал события передатчика
      CPM_TRMSIGNAL :
      begin
        case TWaitResult( WParam) of
          wrError, wrAbandoned : //----------------------------------- ошибка при ожидании
          begin
            PurgeComm( PortHandle, PURGE_TXABORT or PURGE_TXCLEAR);
            TrmInProg := FALSE;
            TrmEvent.ResetEvent;
          end;

          wrSignaled : //----------------------------------------------------- Есть сигнал
          begin  TransmitFinish;  TrmEvent.ResetEvent; end;
        end; // case TWaitResult( WParam)
      end;

      //--------------- CPM_RCVSIGNAL   = WM_USER + $7010 ------- Сигнал события приемника
      CPM_RCVSIGNAL :
      begin
        case TWaitResult( WParam) of
          wrError, wrAbandoned : //----------------------------------- ошибка при ожидании
          begin
            PurgeComm( PortHandle, PURGE_RXABORT or PURGE_RXCLEAR);
            RcvInProg := FALSE;
            RcvEvent.ResetEvent;
          end;
          wrSignaled : //----------------------------------------------------- Есть сигнал
          begin
            RecieveFinish;
            RcvEvent.ResetEvent;
          end;
        end; // case TWaitResult( WParam)
      end;

      else
        Result := DefWindowProc( FWindowHandle, Msg, wParam, lParam);
      end; // case Msg
end; // TComPort.WndProc
//========================================================================================
//---------------------------------------------------------------------- Завершение приема
procedure TComPort.RecieveFinish;
//var
  //HErr : Cardinal;
begin
  if not RcvInProg then Exit; //---------------- Выход, если не уст. флаг течения передачи
  RcvInProg := FALSE;//-------------------------------------- Сбросить флаг течения приема

  if not GetOverlappedResult(PortHandle,RcvOLS,RcvdBytes,FALSE) then // если успешно завершено
  //----------------  CPM_RCVSUCCESS = CPM_RCVFAILED + 1 ------ Успешное завершение приема
//  PostMessage( MessageDest, CPM_RCVSUCCESS, RcvdBytes, 0)
//  else //------------------------------------------------------- если завершилось неудачей
  begin
    //HErr := GetLastError;//----------------------------------------- Получить номер ошибки
    CancelIO( PortHandle);   //------------- Принудительно завершить все операции с портом
    //-------------------------------------- Сообщение о незавершенности операции передачи
   // if HErr = ERROR_IO_INCOMPLETE then
    //----------------------- CPM_RCVFAILED  = CPM_TRMSUCCESS + 1; ----- Ошибка при приеме
    //  PostMessage( MessageDest, CPM_RCVFAILED, cpeRcvEndOverlap, HErr)
    //else PostMessage( MessageDest, CPM_RCVFAILED, cpeRcvEndFailed, HErr);
  end;
end; // TComPort.RecieveFinish
//========================================================================================
//-------------------------------------------------------------------- Завершение передачи
procedure TComPort.TransmitFinish;
//var
//  HErr : Cardinal;
begin
  if not TrmInProg then Exit;
  TrmInProg := FALSE;//------------------------------------ Сбросить флаг течения передачи
  if not GetOverlappedResult(PortHandle,TrmOLS,TrmdBytes,FALSE) then//неудачное завершение
  begin
//    HErr := GetLastError;//----------------------------------------- Получить номер ошибки
    CancelIO( PortHandle);//---------------- Принудительно завершить все операции с портом
    RcvInProg := FALSE; //----------------------------------- Сбросить флаг течения приема
  end;
end; //----------------------------------------------------------- TComPort.TransmitFinish
end.
