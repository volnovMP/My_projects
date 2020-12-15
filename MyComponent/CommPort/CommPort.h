#ifndef CommPortH
#define CommPortH

//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include "Common.H"
//---------------------------------------------------------------------------
class TCommPort;
class TReadThread;
class TWriteThread;
class TStatusThread;
class TReadEventThread;
class TStatusEventThread;
#include "ThRead.h"
#include "ThWrite.h"
#include "ThStatus.h"
#include "EvRead.h"
#include "EvStatus.h"

//----------------------------------------------------------------------------------------
class PACKAGE TCommPort : public TComponent
{
	private:   //---------------------------------------------- ������� (����������) �������
		HANDLE FComHandle; //----------------------------------- ����� ����������������� �����
		DCB FDCB;          //------------------------------------- ���� �������� ������� �����
		int FComNumber;    //----------------------------------- ����� ����������������� �����
		TBaudRate FBaudRate; //-------------------------------------- �������� �������� ������
		TParity FParity; //----------------------------------- ������� �������� �������� �����
		TComControl FComControl; //--------------------------------- ������� ���������� ������
		TStopBits FStopBits; //---------------------------------------- ����� ����-��� � �����
		TDataBits FDataBits; //-------------------------------------- ����� ��� ������ � �����
		TComEventType FMonitorEvents; //---------------------- ������� ����������������� �����
		AnsiString DeviceName;

		void __fastcall BitsWarning(void); //------------- �������� ������������ ��������� ���
		void __fastcall SetComNumber( int n ); //----- ������� ��������� �������� ������ �����
		void __fastcall SetComControl( TComControl Value );// ���������� ��� ���������� ������
		void __fastcall SetBaudRate(TBaudRate Value); //------------ ���������� �������� �����
		void __fastcall SetParity( TParity Value ); //---------- ���������� ��� �������� �����
		void __fastcall SetStopBits( TStopBits Value ); //-------- ���������� ����� ����-�����
		void __fastcall SetDataBits( TDataBits Value ); //-------- ���������� ����� ��� ������

		void __fastcall SetBaud(int B); //- ��������� ��������� �������� �������� � ����������
		int __fastcall GetBaud(void);   //--------- �������� ��������� �������� �������� �����

		int __fastcall GetOutQueCount(void);// �������� ������ ������� �������� ������ � �����

		void __fastcall SetOBuffSize( DWORD _size );  //------- ��������� ������ ������ ������
		DWORD __fastcall GetOutBuffUsed(void);// ������ ����� ����,������������ � ����� ������
		DWORD __fastcall GetOutBuffFree(void);//������ ������ ���������� ����� � ������ ������

		void __fastcall SetIBuffSize( DWORD _size );//---------- ��������� ������ ������ �����
		DWORD __fastcall GetInBuffUsed(void); //-- ������ ����� ���� ����������� � ����� �����
		DWORD __fastcall GetInBuffFree(void); //-- ������ ������ ���������� ����� ������ �����
		void __fastcall SetPackSize( DWORD _size );//----- ��������� ����������� ������ ������

		void __fastcall SetDTR( bool State );//------------------------- ���������� ������ DTR
		void __fastcall SetOpen( bool o );  //----------------------- ������� ��� ������� ����

//------------------------------------------------------------ Com Config ================
//---------------------------------------------------------------------- ������ ����������
		TReadThread *ReadThread; //-------------------------- �����, ��������� ������ ��������
		TWriteThread *WriteThread; //------------------------ �����, ��������� ������ ��������
		TStatusThread *StatusThread; //-------------- �����, �������� �� ����� ��������� �����
		TReadEventThread *ReadEventThread; //----- �����, ��������� ���������� ������ �� �����
		TStatusEventThread *StatusEventThread;//�����,���������� �� ���������� � ������� �����

//------------------------------------------------------------------ ������� ������� �����
		TNotifyEvent FOnCTSSignal; //-------------------------- ������� "��������� ������ CTS"
		TNotifyEvent FOnDCDSignal; //-------------------------- ������� "��������� ������ DCD"
		TNotifyEvent FOnDSRSignal; //-------------------------- ������� "��������� ������ DSR"
		TNotifyEvent FOnRxDSignal; //-------------- ������� "�� ����� ��������� ������ ������"
		TNotifyEvent FOnRxEventSignal; //--------- �� ����� � ����� ��������� "������-�������"
		TNotifyEvent FOnTxDSignal; //---------- ������� "��������� ��������� ������ �� ������"
		TNotifyEvent FOnRingSignal;//------------------------ ������� "������� ����� �� �����"
		TNotifyEvent FOnBreakSignal; //--------------------------------- ��������� ����� �����

		TErrorEvent  FOnErrorSignal;  //---------------------------- ���������� ������ � �����
		TReadEvent   FOnDataReceived; //--------------- ������� "�������� ����� ������ ������"
		TOpenEvent   FOnOpen; //---------------------------------------- ������� "���� ������"
		TNotifyEvent FOnClose; //--------------------------------------- ������� "���� ������"

//------------------------------���������� ������� ���������� ----------------------------
protected:
		void __fastcall OpenPort(void); //------------------------------------- �������� �����
		void __fastcall ClosePort(void); //------------------------------------ �������� �����
		bool __fastcall SetBreak( bool State );  //--- ���������� ��� ����������� ������ �����

//============================== ��������� ���������� ���������� =========================
public:
		bool FDTR;  //--------------------------------------------------- �������� ������� DTR
		bool FRTS; //---------------------------------------------------- �������� ������� RTS
		bool FCTS; //---------------------------------------------------- �������� ������� CTS
		bool FDSR; //---------------------------------------------------- �������� ������� DSR
		bool FDCD; //---------------------------------------------------- �������� ������� DCD
		bool FRing; //-------------------------------------------------- �������� ������� Ring
		unsigned char Potoks;//--------------------------- ���� �������� �� ���������� �������
		int sboy_ts;
		int otkaz_ts;
		char REG_COM_TUMS[16];

		DWORD Status; //----------------------------------------- �������� ���� �������� �����

//------------------------------------------------------------------------- ������ �������
		HANDLE rtEvent; //-------------------------------------- ����� ������� "������ ������"
		HANDLE wtEvent; //------------------------------------ ����� ������� "���� ��� ������"
		HANDLE reEvent; //-------------------------- ����� ������� "��������� ����� �� ������"
		HANDLE seEvent; //-------------------------- ����� ������� "��������� ������� � �����"
		bool FOpen; //---------------------------------- ������� ��������� ����� ������/������

//--------------------------------------------------------------------------------- ������
		unsigned char *OBuffer; //---------------------------- ��������� �� ����� ������ �����
		DWORD OBuffSize; //---------------------------------------- ������ ������ ������ �����
		DWORD OBuffPos;//------------ ������� ������ ������������ ������ � ������ ������ �����
		DWORD OBuffUsed; //------------------ ����� �� ���������� ������ � ������ ������ �����

		unsigned char *IBuffer; //----------------------------- ��������� �� ����� ����� �����
		DWORD IBuffSize; //----------------------------------------- ������ ������ ����� �����
		DWORD IBuffPos; //----------- ������� ������ ������������� ������ � ������ ����� �����
		DWORD IBuffUsed;  //-------------------- ����� ����, ����� ����������� �� ������ �����

		DWORD PacketSize;//����������� ����� �������� ����, � �������� ��������� ������ ������
//----------------------------------------------------------------------------------------
		_RTL_CRITICAL_SECTION WriteSection; //-------- ����������� ������ ������ ������ � ����
		_RTL_CRITICAL_SECTION ReadSection; //------- ����������� ������ ������ ������ �� �����
//----------------------------------------------------------------------------------------
		bool __fastcall IsEnabled(void); //------- ������� �������� ������������� ������ �����
		int __fastcall PutBlock( char *Buf, DWORD Count ); //---- ��������� ���� ������ � ����
		int __fastcall GetBlock( unsigned char *Buf, DWORD Count ); //--- �������� ���� ������ �� �����
		void __fastcall FlushInBuffer(void);  //--------- �������� ������� ����� � ��� �������
		void __fastcall FlushOutBuffer(void); //-------- �������� �������� ����� � ��� �������

		bool __fastcall CharReady(void); //--------- �������� �������� ������� ������ � ������
		char __fastcall GetChar(void); //---------------------- ��������� ���� ������ �� �����
		void __fastcall PutChar( char Ch ); //-------------------- �������� ���� ������ � ����
		void __fastcall PutString( char *s ); //-------------- �������� ������ �������� � ����
		void __fastcall SendBreak( WORD Ticks ); //------------------ ���������� � ����� Break

		void __fastcall PowerOn(void);   //------------------------------ ���������� RTS � DTR
		void __fastcall PowerOff(void);  //----------------------------------- ����� RTS � DTR

		__property HANDLE ComHandle = {read=FComHandle}; //----------------------- ����� �����

//----------------------------------------------------------------------------------------
		__fastcall TCommPort(TComponent* Owner);
		virtual __fastcall ~TCommPort(void);
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
		__property DWORD OutBuffFree = {read=GetOutBuffFree};
		__property DWORD OutBuffUsed = {read=GetOutBuffUsed};
		__property int OutQueCount = {read=GetOutQueCount};

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
		__property TReadEvent   OnDataReceived  = {read=FOnDataReceived, write=FOnDataReceived};
		__property TOpenEvent   OnOpen          = {read=FOnOpen, write=FOnOpen};
		__property TNotifyEvent OnClose         = {read=FOnClose, write=FOnClose};
};

//----------------------------------------------------------------------------------------
#endif
