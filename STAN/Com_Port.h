//---------------------------------------------------------------------------
#ifndef Com_PortH
#define Com_PortH
#include <Classes.hpp>
//---------------------------------------- ������ ���������������� ���������������� ������
typedef AnsiString TPortName;  //---------------------------------------- ����� ���-������
typedef unsigned int TSymbSize;//------------------------------- ��� ����� ����� � �������
typedef unsigned int TComNum;//--------------------------------------------- ������ ������
typedef HANDLE TEvent;

enum TOSystem {osWinNT, osWin3x, osWin9x, osWinMe, osWin2k, osWinXP}; //--------- ���� ��
enum TStopBits1 {sb_One, sb_OneHalf, sb_Two};//----------------------------- ��� ����-�����
enum TParity1 {pt_No, pt_Odd, pt_Even, pt_Mark, pt_Space};//------------------ ��� ��������
enum TRTSControl1 {rts_Disable,rts_Enable,rts_Handshake,rts_Toggle};//��� ���������� �� RTS
enum TDTRControl1 {dtr_Disable, dtr_Enable, dtr_Handshake}; // ��� ���������� ������ �� DTR
enum TFlowControl {fc_No, fc_XonXoff, fc_Hardware};//-------------- ��� ���������� �������
enum TBaudRate1 {br_110, br_300, br_600, br_1200, br_2400, br_4800,
								br_9600, br_14400, br_19200, br_38400, br_57600,
								br_115200,br_128000,br_256000};  //---------------- ��� ��������� ��������
//-------------------------------------------------------------------------- ������ ������
struct TPortBuffer
{
		unsigned char Info[8]; //------------------------------------------- ���������� ������
		int Head; //------------------------------------------------------------ ������ ������
		int Tail; //------------------------------------------------------------- ����� ������
		unsigned int State;//------------------------------------------------ ��������� ������
};
//------------------------------------------------------------------------
//       ����� ����������������� ����������������� ����� TComPort
//------------------------------------------------------------------------
class TCom_Port : public TComponent
{
	private:
		TPortName    FPortName; //-------------------------------------------------- ��� �����
		TBaudRate1   FBaudRate; //------------------------------------------ �������� ��������
		bool         FParityEn; //------------------------------ ���������� ��������� ��������
		TFlowControl FFlowCtrl; //----------------------------------------- ���������� �������
		bool         FCTSFlow; //----------------------------- ���������� ������� �������� CTS
		bool         FDSRFlow; //----------------------------- ���������� ������� �������� DSR
		TDTRControl1 FDTRControl; //---------------------------- ��� ���������� �� ������� DTR
		bool         FDSRSense; //------------------------------ ������� DSR �� ������� ������
		bool         FTxCont; //------------------------------- ���������� �������� ����� Xoff
		bool         FOutX;//---------------------------------- ���� ���. XonXoff ��� ��������
		bool         FInX;//------------------------------------- ���� ���. XonXoff ��� ������
		bool         FErrorReplace;//----------------------- �������� ����� � ��. �� ErrorChar
		bool         FDiscardNull;//-------------------------- ������� ������� ����� �� �����.
		TRTSControl1 FRTSControl; //---------------------------- ��� ���������� �� ������� RTS
		bool         FAbortOnError;//------------------------------ ��������� ����� ��� ������
		long         FXonLim; //-------------------------- ���. ���-�� ���� � ������ ����� Xon
		long         FXoffLim;//------------------------ ����. ���-�� ���� � ������ ����� Xoff
		TSymbSize    FSymbSize;//---------------------------------------- ���-�� ��� � �������
		TParity1     FParity;//-------------------------------------------------- ��� ��������
		TStopBits1   FStopBits;//------------------------------------------- ���-�� ����-�����
		unsigned char FXonChar;//--------------------------------------------- ��� ������� Xon
		unsigned char FXoffChar;//------------------------------------------- ��� ������� Xoff
		unsigned char FErrorChar;//---------------------------------------- ��� ������� ������
		unsigned char FEofChar;//------------------------------------ ��� ������� ����� ������
		unsigned char FEvtChar;//---------------------------- ��� ������� ������������ �������
		bool         FToTotal;//--------------------------------- ���. ����� ������� ���������
		bool         FToIntv;//------------------------------------- ���. ������������ �������
		unsigned long FToValue; //------------------------------ �������� ������ �������� � ��
		AnsiString    s; //--------------------------- ��������� ���������� ��� ������ �����(1)
		AnsiString    sp;//---------------------------------------------------------------  (2)

	protected:
		TCommTimeouts TimeOuts; //------------------------------------------ �������� ��������
		TStringList	*CommNames; //------------------------------------ ������ ��������� ������
		bool __fastcall GetCommNames(void);
		void __fastcall CalcTimeouts(void);
		void __fastcall fill_DCB(void);

	public:
		__fastcall TCom_Port(TComponent* AOwner);
		__fastcall ~TCom_Port(void);
		unsigned long rcverrcnt; //---------------------------- ������� ������ ����� �� ������
		unsigned long trmerrcnt; //-------------------------- ������� ������ ����� �� ��������
		char          Buffer[8]; //----------------------------------------------- ����� �����
		TOSystem      OSType; //------------------------------------- ��� ������������ �������
		bool          PortIsOpen; //---------------------------------------------- ���� ������
		HANDLE				PortHandle;//------------------------------------------ ���������� �����
		DCB           PortDCB;//----------------------------------- ��������� ���������� �����
		unsigned long PortError;//------------------------------- ����� ��������� ������ �����
		TOverlapped   TrmOLS;//--------------------------------- ��������� ���������� ��������
		unsigned long lvCdt;
		TEvent        TrmEvent; //------------------------------ ������� �� ��������� ��������
		TPortBuffer   TrmBuf;//------------------------------------------------ ����� ��������
		unsigned long TrmdBytes;//------------------------------------ ������� ���������� ����
		bool          TrmInProg;//-------------------------------------- ���� ������� ��������
		TOverlapped	  RcvOLS;//--------------------------------- ��������� ������������ ������
		unsigned long lvCdr;
		TEvent        RcvEvent;//--------------------------------- ������� �� ��������� ������
		TPortBuffer   RcvBuf;//-------------------------------------------------- ����� ������
		unsigned long RcvdBytes;//-------------------------------------- ������� �������� ����
		bool          RcvInProg;//---------------------------------------- ���� ������� ������
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
