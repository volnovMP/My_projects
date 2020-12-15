#ifndef CommPortABH
#define CommPortABH

//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include "Common.H"
//---------------------------------------------------------------------------
class TCommPortAB;
class TReadThreadAB;
class TWriteThreadAB;
class TStatusThreadAB;
class TReadEventThreadAB;
class TStatusEventThreadAB;
#include "ThReadAB.h"
#include "ThStatusAB.h"
#include "EvReadAB.h"
#include "EvStatusAB.h"

//----------------------------------------------------------------------------------------
class PACKAGE TCommPortAB : public TComponent
{
	private:   //---------------------------------------------- частные (внутренние) объекты
		HANDLE FComHandle; //----------------------------------- Хэндл последовательного порта
		DCB FDCB;          //------------------------------------- Блок описания свойств порта
		int FComNumber;    //----------------------------------- номер коммуникационного порта
		TBaudRate FBaudRate; //-------------------------------------- скорость передачи данных
		TParity FParity; //----------------------------------- признак контроля паритете порта
		TComControl FComControl; //--------------------------------- способы управления портом
		TStopBits FStopBits; //---------------------------------------- число стоп-бит в байте
		TDataBits FDataBits; //-------------------------------------- число бит данных в байте
		TComEventType FMonitorEvents; //---------------------- события коммуникационного порта
		DWORD FNumStan;
		AnsiString DeviceName;
		void __fastcall BitsWarning(void); //------------- проверка правильности сочетания бит
		void __fastcall SetComNumber( int n ); //----- функция установки свойства номера порта
		void __fastcall SetComControl( TComControl Value );// установить тип управления портом
		void __fastcall SetBaudRate(TBaudRate Value); //------------ установить скорость порта
		void __fastcall SetParity( TParity Value ); //---------- установить тип паритета порта
		void __fastcall SetStopBits( TStopBits Value ); //-------- установить число стоп-битов
		void __fastcall SetDataBits( TDataBits Value ); //-------- установить число бит данных

		void __fastcall SetBaud(int B); //- перевести численное значение скорости в символьное
		int __fastcall GetBaud(void);   //--------- получить численное значение скорости порта

		int __fastcall GetOutQueCount(void);// получить размер очереди принятых данных в порту

		void __fastcall SetOBuffSize( DWORD _size );  //------- назначить размер буфера вывода
		DWORD __fastcall GetOutBuffUsed(void);// узнать число байт,отправленных в буфер вывода

		void __fastcall SetIBuffSize( DWORD _size );//---------- назначить размер буфера ввода
		DWORD __fastcall GetInBuffUsed(void); //-- узнать число байт поступивших в буфер ввода
		DWORD __fastcall GetInBuffFree(void); //-- узнать размер свободного места буфера ввода
		void __fastcall SetPackSize( DWORD _size );//----- назначить минимальный размер пакета

		void __fastcall SetDTR( bool State );//------------------------- установить сигнал DTR
		void __fastcall SetOpen( bool o );  //----------------------- открыть или закрыть порт

//------------------------------------------------------------ Com Config ================
//---------------------------------------------------------------------- Потоки компонента
		TReadThreadAB *ReadThreadAB; //---------------------- поток, ожидающий приема символов
		TWriteThreadAB *WriteThreadAB; //-------------------- поток, ожидающий записи символов
		TStatusThreadAB *StatusThreadAB; //---------- поток, следящий за всеми событиями порта
		TReadEventThreadAB *ReadEventThreadAB; //- поток, ожидающий завершения чтения из порта
		TStatusEventThreadAB *StatusEventThreadAB;//поток,сообщающий из компонента о статусе линий

//------------------------------------------------------------------ объекты событий порта
		TNotifyEvent FOnCTSSignal; //-------------------------- событие "изменился сигнал CTS"
		TNotifyEvent FOnDCDSignal; //-------------------------- событие "изменился сигнал DCD"
		TNotifyEvent FOnDSRSignal; //-------------------------- событие "изменился сигнал DSR"
		TNotifyEvent FOnRxDSignal; //-------------- событие "на входе обнаружен символ данных"
		TNotifyEvent FOnRxEventSignal; //--------- на входе в порту обнаружен "символ-событие"
		TNotifyEvent FOnTxDSignal; //---------- событие "отправлен последний символ из буфера"
		TNotifyEvent FOnRingSignal;//------------------------ событие "получен вызов из линии"
		TNotifyEvent FOnBreakSignal; //--------------------------------- обнаружен обрыв связи

		TErrorEvent  FOnErrorSignal;  //---------------------------- обнаружена ошибка в порту
		TReadEventAB FOnDataReceivedAB; //----------- событие "выполнен прием пакета данных"
		TOpenEvent   FOnOpen; //---------------------------------------- событие "порт открыт"
		TNotifyEvent FOnClose; //--------------------------------------- событие "порт закрыт"

//------------------------------защищенные функции компонента ----------------------------
protected:
		void __fastcall OpenPort(void); //------------------------------------- открытие порта
		void __fastcall ClosePort(void); //------------------------------------ закрытие порта
		bool __fastcall SetBreak( bool State );  //--- остановить или возобновить работу порта

//============================== доступные переменные компонента =========================
public:
		bool FDTR;  //--------------------------------------------------- значение сигнала DTR
		bool FRTS; //---------------------------------------------------- значение сигнала RTS
		bool FCTS; //---------------------------------------------------- значение сигнала CTS
		bool FDSR; //---------------------------------------------------- значение сигнала DSR
		bool FDCD; //---------------------------------------------------- значение сигнала DCD
		bool FRing; //-------------------------------------------------- значение сигнала Ring
		unsigned char Potoks;//--------------------------- байт слежения за состоянием потоков
		int sboy_ts;
		int otkaz_ts;
		char REG_COM_TUMS[16];

		DWORD Status; //----------------------------------------- значение всех сигналов порта

//------------------------------------------------------------------------- хэндлы событий
		HANDLE rtEventAB; //----------------------------------- хэндл события "принят символ"
		HANDLE wtEventAB; //--------------------------------- хэндл события "есть что писать"
		HANDLE reEventAB; //----------------------- хэндл события "прочитаны байты из буфера"
		HANDLE seEventAB; //----------------------- хендл события "произошло событие в порту"
		bool FOpen; //---------------------------------- признак состояния порта открыт/закрыт
		bool GotovWrite; //----------------------------------------------- готовность к записи

//--------------------------------------------------------------------------------- Буфера
		unsigned char *OBuffer; //---------------------------- указатель на буфер вывода порта
		DWORD OBuffSize; //---------------------------------------- размер буфера вывода порта
		DWORD OBuffPos;//------------ позиция начала непереданных данных в буфере вывода порта
		DWORD OBuffUsed; //------------------ число не переданных данных в буфере вывода порта


		unsigned char *IBuffer; //----------------------------- указатель на буфер ввода порта
		DWORD IBuffSize; //----------------------------------------- размер буфера ввода порта
		DWORD IBuffPos; //----------- позиция начала непрочитанных данных в буфере ввода порта
		DWORD IBuffUsed;//текущее число байт, вновь прочитанных в буфер ввода, не обработанных

		unsigned char OSTATOK[18]; //------- временно не обработанный остаток считанных данных
		int N_OSTAT; //---------------------------------- число не обработанных байт в остатке

		DWORD PacketSize;//-  минимальный объем принятых байт, когда компонент начинает анализ
//----------------------------------------------------------------------------------------
		_RTL_CRITICAL_SECTION ReadABSection; //----- критическая секция чтения данных из порта
		_RTL_CRITICAL_SECTION	WriteABSection;//------- критическая секция записи данных в порт
//----------------------------------------------------------------------------------------
		bool __fastcall IsEnabled(void); //------- функция проверки существования хэндла порта
		int __fastcall PutBlock( char *Buf, DWORD Count ); //---- отправить блок данных в порт
		int __fastcall GetBlock(unsigned char *Buf, DWORD Count );//взять блок данных из порта
		void __fastcall FlushInBuffer(void);  //--------- очистить входной буфер и его события
		void __fastcall FlushOutBuffer(void); //-------- очистить выходной буфер и его события

		bool __fastcall CharReady(void); //--------- проверка признака наличия данных в буфере
		char __fastcall GetChar(void); //---------------------- прочитать один символ из порта
		void __fastcall PutChar( char Ch ); //-------------------- записать один символ в порт
		void __fastcall PutString( char *s ); //-------------- записать строку символов в порт
		void __fastcall SendBreak( WORD Ticks ); //------------------ установить и снять Break

		void __fastcall PowerOn(void);   //------------------------------ установить RTS и DTR
		void __fastcall PowerOff(void);  //----------------------------------- снять RTS и DTR

		__property HANDLE ComHandle = {read=FComHandle}; //----------------------- хэндл порта

//----------------------------------------------------------------------------------------
		__fastcall TCommPortAB(TComponent* Owner);
		virtual __fastcall ~TCommPortAB(void);
//----------------------------------------------------------------------------------------
__published:
		__property int ComNumber = {read=FComNumber, write=SetComNumber};
		__property bool Open = {read=FOpen, write=SetOpen};
//----------------------------------- Com Status -----------------------------------------
		__property bool DTR = {read=FDTR, write=SetDTR};

//----------------------------------------------------------------------------------------
		__property DWORD InSize = {read=IBuffSize, write=SetIBuffSize};
		__property DWORD OutSize = {read=OBuffSize, write=SetOBuffSize};
		__property DWORD PackSize = {read = PacketSize, write=SetPackSize};
		__property DWORD InBuffFree = {read=GetInBuffFree};
		__property DWORD InBuffUsed = {read=GetInBuffUsed};
		__property DWORD OutBuffUsed = {read=GetOutBuffUsed};
		__property int OutQueCount = {read=GetOutQueCount};
		__property DWORD NumStan = {read=FNumStan, write=FNumStan};//--- идентификатор станции

//----------------------------------------------------------------------------- Com Config
		__property int Baud = {read=GetBaud, write=SetBaud};
		__property TBaudRate BaudRate = {read=FBaudRate, write=SetBaudRate};
		__property TComControl Control = {read=FComControl, write=SetComControl};
		__property TParity Parity = {read=FParity, write=FParity};
		__property TStopBits StopBits = {read=FStopBits, write=SetStopBits};
		__property TDataBits DataBits = {read=FDataBits, write=SetDataBits};
		__property TComEventType MonitorEvents = {read=FMonitorEvents, write=FMonitorEvents};

	//--------------------------------------------------------------------------------- Events
		__property TNotifyEvent OnCTSSignal     = {read=FOnCTSSignal, write=FOnCTSSignal};
		__property TNotifyEvent OnDCDSignal     = {read=FOnDCDSignal, write=FOnDCDSignal};
		__property TNotifyEvent OnDSRSignal     = {read=FOnDSRSignal, write=FOnDSRSignal};
		__property TNotifyEvent OnRxDSignal     = {read=FOnRxDSignal, write=FOnRxDSignal};
		__property TNotifyEvent OnTxDSignal     = {read=FOnTxDSignal, write=FOnTxDSignal};
		__property TNotifyEvent OnRingSignal    = {read=FOnRingSignal, write=FOnRingSignal};
		__property TNotifyEvent OnBreakSignal   = {read=FOnBreakSignal, write=FOnBreakSignal};
		__property TNotifyEvent OnRxEventSignal = {read=FOnRxEventSignal, write=FOnRxEventSignal};

		__property TErrorEvent  OnErrorSignal   = {read=FOnErrorSignal, write=FOnErrorSignal};
		__property TReadEventAB OnDataReceivedAB  = {read=FOnDataReceivedAB, write=FOnDataReceivedAB};
		__property TOpenEvent   OnOpen          = {read=FOnOpen, write=FOnOpen};
		__property TNotifyEvent OnClose         = {read=FOnClose, write=FOnClose};
};

//----------------------------------------------------------------------------------------
#endif
