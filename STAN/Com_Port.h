//---------------------------------------------------------------------------
#ifndef Com_PortH
#define Com_PortH
#include <Classes.hpp>
//---------------------------------------- Модуль последовательных коммуникационных портов
typedef AnsiString TPortName;  //---------------------------------------- Имена СОМ-портов
typedef unsigned int TSymbSize;//------------------------------- Тип числа битов в символе
typedef unsigned int TComNum;//--------------------------------------------- номера портов
typedef HANDLE TEvent;

enum TOSystem {osWinNT, osWin3x, osWin9x, osWinMe, osWin2k, osWinXP}; //--------- Типы ОС
enum TStopBits1 {sb_One, sb_OneHalf, sb_Two};//----------------------------- Тип стоп-битов
enum TParity1 {pt_No, pt_Odd, pt_Even, pt_Mark, pt_Space};//------------------ Тип паритета
enum TRTSControl1 {rts_Disable,rts_Enable,rts_Handshake,rts_Toggle};//Тип управления по RTS
enum TDTRControl1 {dtr_Disable, dtr_Enable, dtr_Handshake}; // Тип управления портом по DTR
enum TFlowControl {fc_No, fc_XonXoff, fc_Hardware};//-------------- Тип управления потоком
enum TBaudRate1 {br_110, br_300, br_600, br_1200, br_2400, br_4800,
								br_9600, br_14400, br_19200, br_38400, br_57600,
								br_115200,br_128000,br_256000};  //---------------- Тип скоростей передачи
//-------------------------------------------------------------------------- Буферы портов
struct TPortBuffer
{
		unsigned char Info[8]; //------------------------------------------- Информация буфера
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
		TBaudRate1   FBaudRate; //------------------------------------------ Скорость передачи
		bool         FParityEn; //------------------------------ Разрешение обработки паритета
		TFlowControl FFlowCtrl; //----------------------------------------- Управление потоком
		bool         FCTSFlow; //----------------------------- Управление выходом сигналом CTS
		bool         FDSRFlow; //----------------------------- Управление выходом сигналом DSR
		TDTRControl1 FDTRControl; //---------------------------- Тип управления по сигналу DTR
		bool         FDSRSense; //------------------------------ Влияние DSR на течение обмена
		bool         FTxCont; //------------------------------- Продолжать передачу после Xoff
		bool         FOutX;//---------------------------------- Флаг исп. XonXoff при передаче
		bool         FInX;//------------------------------------- Флаг исп. XonXoff при приеме
		bool         FErrorReplace;//----------------------- Заменять байты с ош. на ErrorChar
		bool         FDiscardNull;//-------------------------- Удалять нулевые байты из сообщ.
		TRTSControl1 FRTSControl; //---------------------------- Тип управления по сигналу RTS
		bool         FAbortOnError;//------------------------------ Прерывать обмен при ошибке
		long         FXonLim; //-------------------------- Мин. кол-во байт в буфере перед Xon
		long         FXoffLim;//------------------------ Макс. кол-во байт в буфере перед Xoff
		TSymbSize    FSymbSize;//---------------------------------------- Кол-во бит в символе
		TParity1     FParity;//-------------------------------------------------- Тип паритета
		TStopBits1   FStopBits;//------------------------------------------- Кол-во стоп-битов
		unsigned char FXonChar;//--------------------------------------------- Код символа Xon
		unsigned char FXoffChar;//------------------------------------------- Код символа Xoff
		unsigned char FErrorChar;//---------------------------------------- Код символа ошибки
		unsigned char FEofChar;//------------------------------------ Код символа конца данных
		unsigned char FEvtChar;//---------------------------- Код символа сигнализации события
		bool         FToTotal;//--------------------------------- Исп. общий таймаут сообщения
		bool         FToIntv;//------------------------------------- Исп. интервальный таймаут
		unsigned long FToValue; //------------------------------ Величина общего таймаута в мс
		AnsiString    s; //--------------------------- Строковые переменные для работы порта(1)
		AnsiString    sp;//---------------------------------------------------------------  (2)

	protected:
		TCommTimeouts TimeOuts; //------------------------------------------ Таймауты ожидания
		TStringList	*CommNames; //------------------------------------ список имеющихся портов
		bool __fastcall GetCommNames(void);
		void __fastcall CalcTimeouts(void);
		void __fastcall fill_DCB(void);

	public:
		__fastcall TCom_Port(TComponent* AOwner);
		__fastcall ~TCom_Port(void);
		unsigned long rcverrcnt; //---------------------------- Счетчик ошибок порта по приему
		unsigned long trmerrcnt; //-------------------------- Счетчик ошибок порта по передаче
		char          Buffer[8]; //----------------------------------------------- Буфер порта
		TOSystem      OSType; //------------------------------------- Код операционной системы
		bool          PortIsOpen; //---------------------------------------------- Порт открыт
		HANDLE				PortHandle;//------------------------------------------ Обработчик порта
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

		bool __fastcall RTSOnOff(bool aOn);
		bool __fastcall DTROnOff(bool aOn);
		void __fastcall RecieveFinish(void);
		void __fastcall TransmitFinish(void);
		bool __fastcall OpenPort(void);
		bool __fastcall ClosePort(void);
		bool __fastcall InitPort(AnsiString CommPortParam);
		unsigned long __fastcall StrToComm(char* trmstring);
		bool __fastcall StrFromComm(AnsiString* rcvstring);
		unsigned long __fastcall BufToComm(char* Buf,unsigned int Len);
		unsigned long __fastcall BufFromComm(char* Buf,unsigned int MaxLen);

	__published:
		__property TPortName PortName = {read = FPortName, write = FPortName};
		__property TBaudRate1 BaudRate = {read = FBaudRate, write = FBaudRate, default = br_600};
		__property bool ParityEn = {read = FParityEn, write = FParityEn, default = true};
		__property TFlowControl FlowCtrl = {read = FFlowCtrl, write = FFlowCtrl, default = fc_No};
		__property bool CTSFlow = {read = FCTSFlow, write = FCTSFlow, default = false};
		__property bool DSRFlow = {read = FDSRFlow, write = FDSRFlow, default = false};
		__property TDTRControl1 DTRControl = {read = FDTRControl, write = FDTRControl, default = dtr_Disable};
		__property bool DSRSense = {read = FDSRSense, write = FDSRSense, default = false};
		__property bool TxCont = {read = FTxCont, write = FTxCont, default = false};
		__property bool OutX   = {read = FOutX, write = FOutX, default = false};
		__property bool InX    = {read = FInX, write = FInX, default = false};
		__property bool ErrorReplace = {read = FErrorReplace, write = FErrorReplace, default = false};
		__property bool DiscardNull = {read = FDiscardNull, write = FDiscardNull, default = false};
		__property TRTSControl1 RTSControl = {read = FRTSControl, write = FRTSControl, default = rts_Disable};
		__property bool AbortOnError = {read = FAbortOnError, write = FAbortOnError, default = false};
		__property long XonLim = {read = FXonLim, write = FXonLim, default = 1};
		__property long XOffLim ={read = FXoffLim, write = FXoffLim, default = 512};
		__property TSymbSize SymbSize = {read = FSymbSize, write = FSymbSize, default = 7};
		__property TParity1 Parity = {read = FParity, write = FParity, default = pt_Odd};
		__property TStopBits1 StopBits = {read = FStopBits, write = FStopBits, default = sb_Two};
		__property unsigned char XOnChar = {read = FXonChar, write = FXonChar, default = 3};
		__property unsigned char XOffChar = {read = FXoffChar, write = FXoffChar, default = 2};
		__property unsigned char ErrorChar = {read = FErrorChar, write = FErrorChar, default = 23};
		__property unsigned char EofChar = {read = FEofChar, write = FEofChar, default = 4};
		__property unsigned char EvtChar = {read = FEvtChar, write = FEvtChar, default = 25};
		__property bool ToTotal = {read = FToTotal, write = FToTotal};
		__property bool ToIntv =  {read = FToIntv, write = FToIntv};
		__property unsigned long ToValue = {read = FToValue, write = FToValue, default = 1000};
	};


#endif
