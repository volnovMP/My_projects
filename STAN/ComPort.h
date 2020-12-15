//---------------------------------------------------------------------------
#ifndef ComPortH
#define ComPortH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
//----------------------------------------------------------------------------------------
//---------------------------------------- Идентификаторы ошибок при операция с СОМ-портом
#define cpeOpenFailed 1
#define cpeConfigFailed 2
#define cpeClearFailed 3
#define cpeTrmInitFailed 4
#define cpeTrmEndFailed 5
#define cpeTrmMistake 6
#define cpeTrmEndOverlap 7
#define cpeRcvInitFailed 8
#define cpeRcvEndFailed 9
#define cpeRcvMistake 10
#define cpeRcvEndOverlap 11
#define cpeRcvNoBytes 12

#define	CPM_TRMSIGNAL WM_USER + 0x7009;  //-------------------- Сигнал события передатчика
#define	CPM_RCVSIGNAL CPM_TRMSIGNAL + 1; //---------------------- Сигнал события приемника

//----------------------------------------------------- Ошибки при операциях с СОМ-портами
unsigned char CPortErrName[12][70] =
{{"Не удалось открыть коммуникационный порт %s."},
{"Не удалось сконфигурировать порт %s!"},
{"Не удалось очистить последнюю операцию %s."},
{"Не удалось инициировать передачу сообщения по %s."},
{"Не удалось завершить передачу сообщения по %s."},
{"Ошибка при передаче сообщения по %s."},
{"Неверное завершение передачи сообщения по %s."},
{"Не удалось инициировать прием сообщения по %s."},
{"Не удалось завершить прием сообщения по %s."},
{"Ошибка при приеме сообщения по %s."},
{"Неверное завершение приема сообщения по %s."},
{"Нет принятых байтов по порту %s."}};
class TCom_Port;

//---------------------------------------- Модуль последовательных коммуникационных портов
typedef HANDLE TEvent;
typedef unsigned int TComNum;//--------------------------------------------- номера портов
typedef char TPortName[30];  //------------------------------------------ Имена СОМ-портов
enum	TOSystem {osWinNT, osWin3x, osWin9x, osWinMe, osWin2k, osWinXP}; //--------- Типы ОС
enum TDTRControl {dtr_Disable, dtr_Enable, dtr_Handshake}; // Тип управления портом по DTR
enum TRTSControl {rts_Disable,rts_Enable,rts_Handshake,rts_Toggle};//Тип управления по RTS
typedef unsigned int TSymbSize;//------------------------------- Тип числа битов в символе
enum TParity {pt_No, pt_Odd, pt_Even, pt_Mark, pt_Space};//------------------ Тип паритета
enum TStopBits {sb_One, sb_OneHalf, sb_Two};//----------------------------- Тип стоп-битов
enum TBaudRate {br_50, br_100, br_300, br_600, br_1200, br_2400, br_4800,
								br_9600, br_14400, br_19200, br_28800, br_38400, br_57600,
								br_115200};  //------------------------------------ Тип скоростей передачи
enum TFlowControl {fc_No, fc_XonXoff, fc_Hardware};//-------------- Тип управления потоком
//-------------------------------------------------------------------------- Буферы портов
struct TPortBuffer
{
		unsigned char Info[4095]; //---------------------------------------- Информация буфера
		int Head; //------------------------------------------------------------ Голова буфера
		int Tail; //------------------------------------------------------------- Хвост буфера
		unsigned int State;//------------------------------------------------ Состояние буфера
};

//------------------------------------------------------------------------
//       Класс последовательного коммуникационного порта TComPort
//------------------------------------------------------------------------
class TCom_Port : public TComponent
{
	private:
		TPortName    FPortName; //-------------------------------------------------- Имя порта
		TBaudRate    FBaudRate; //------------------------------------------ Скорость передачи
		bool         FParityEn; //------------------------------ Разрешение обработки паритета
		TFlowControl FFlowCtrl; //----------------------------------------- Управление потоком
		bool         FCTSFlow; //----------------------------- Управление выходом сигналом CTS
		bool         FDSRFlow; //----------------------------- Управление выходом сигналом DSR
	  TBaudRate    FDTRControl; //---------------------------- Тип управления по сигналу DTR
		bool         FDSRSense; //------------------------------ Влияние DSR на течение обмена
		bool         FTxCont; //------------------------------- Продолжать передачу после Xoff
		bool         FOutX;//---------------------------------- Флаг исп. XonXoff при передаче
		bool         FInX;//------------------------------------- Флаг исп. XonXoff при приеме
		bool         FErrorReplace;//----------------------- Заменять байты с ош. на ErrorChar
		bool         FDiscardNull;//-------------------------- Удалять нулевые байты из сообщ.
		TRTSControl  FRTSControl; //---------------------------- Тип управления по сигналу RTS
		bool         FAbortOnError;//------------------------------ Прерывать обмен при ошибке
		int          FXonLim; //-------------------------- Мин. кол-во байт в буфере перед Xon
		int          FXoffLim;//------------------------ Макс. кол-во байт в буфере перед Xoff
		TSymbSize    FSymbSize;//---------------------------------------- Кол-во бит в символе
		TParity      FParity;//-------------------------------------------------- Тип паритета
		TStopBits    FStopBits;//------------------------------------------- Кол-во стоп-битов
		unsigned char FXonChar;//--------------------------------------------- Код символа Xon
		unsigned char FXOffChar;//------------------------------------------- Код символа Xoff
		unsigned char FErrorChar;//---------------------------------------- Код символа ошибки
		unsigned char FEofChar;//------------------------------------ Код символа конца данных
		unsigned char FEvtChar;//---------------------------- Код символа сигнализации события
		bool         FToTotal;//--------------------------------- Исп. общий таймаут сообщения
		bool         FToIntv;//------------------------------------- Исп. интервальный таймаут
		unsigned long FToValue; //------------------------------ Величина общего таймаута в мс
		HWND         FWindowHandle; //--------------------------------------- Обработчик порта
		HWND         MessageDest;//--------------------------------- Окно назначения сообщения
		char*        s; //--------------------------- Строковые переменные для работы порта(1)
		char*        sp;//---------------------------------------------------------------  (2)

	protected:
		TCommTimeouts TimeOuts; //------------------------------------------ Таймауты ожидания
		bool __fastcall GetCommNames(void);
		void __fastcall CalcTimeouts(void);
		void __fastcall FillDCB(void);
		virtual void __fastcall WndProc(TMessage Msg);

	public:
		unsigned long rcverrcnt; //---------------------------- Счетчик ошибок порта по приему
		unsigned long trmerrcnt; //-------------------------- Счетчик ошибок порта по передаче
		char          Buffer[4096]; //-------------------------------------------- Буфер порта
		TOSystem      OSType; //------------------------------------- Код операционной системы
		bool          PortIsOpen; //---------------------------------------------- Порт открыт
		unsigned long PortHandle;//------------------------------------------ Обработчик порта
		DCB           PortDCB;//----------------------------------- Структура управления порта
		unsigned long PortError;//------------------------------- Номер последней ошибки порта
		TOverlapped   TrmOLS;//--------------------------------- Структура перекрытия передачи
		unsigned long lvCdt;
		TEvent        TrmEvent; //------------------------------ Событие по окончании передачи
		TPortBuffer   TrmBuf;//------------------------------------------------ Буфер передачи
		unsigned long TrmdBytes;//------------------------------------ Реально переданных байт
		bool          TrmInProg;//-------------------------------------- Флаг течения передачи
		TOverlapped	  RcvOLS;//--------------------------------- Структура асинхронного приема
		unsigned long lvCdr;
		TEvent        RcvEvent;//--------------------------------- Событие по окончании приема
		TPortBuffer   RcvBuf;//-------------------------------------------------- Буфер приема
		unsigned long RcvdBytes;//-------------------------------------- Реально принятых байт
		bool          RcvInProg;//---------------------------------------- Флаг течения приема
//========================================================================================
		__fastcall TCom_Port(TComponent *Owner);
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




#endif
