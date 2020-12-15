//---------------------------------------------------------------------------
#ifndef ComPortH
#define ComPortH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
//----------------------------------------------------------------------------------------
//---------------------------------------- �������������� ������ ��� �������� � ���-������
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

#define	CPM_TRMSIGNAL WM_USER + 0x7009;  //-------------------- ������ ������� �����������
#define	CPM_RCVSIGNAL CPM_TRMSIGNAL + 1; //---------------------- ������ ������� ���������

//----------------------------------------------------- ������ ��� ��������� � ���-�������
unsigned char CPortErrName[12][70] =
{{"�� ������� ������� ���������������� ���� %s."},
{"�� ������� ���������������� ���� %s!"},
{"�� ������� �������� ��������� �������� %s."},
{"�� ������� ������������ �������� ��������� �� %s."},
{"�� ������� ��������� �������� ��������� �� %s."},
{"������ ��� �������� ��������� �� %s."},
{"�������� ���������� �������� ��������� �� %s."},
{"�� ������� ������������ ����� ��������� �� %s."},
{"�� ������� ��������� ����� ��������� �� %s."},
{"������ ��� ������ ��������� �� %s."},
{"�������� ���������� ������ ��������� �� %s."},
{"��� �������� ������ �� ����� %s."}};
class TCom_Port;

//---------------------------------------- ������ ���������������� ���������������� ������
typedef HANDLE TEvent;
typedef unsigned int TComNum;//--------------------------------------------- ������ ������
typedef char TPortName[30];  //------------------------------------------ ����� ���-������
enum	TOSystem {osWinNT, osWin3x, osWin9x, osWinMe, osWin2k, osWinXP}; //--------- ���� ��
enum TDTRControl {dtr_Disable, dtr_Enable, dtr_Handshake}; // ��� ���������� ������ �� DTR
enum TRTSControl {rts_Disable,rts_Enable,rts_Handshake,rts_Toggle};//��� ���������� �� RTS
typedef unsigned int TSymbSize;//------------------------------- ��� ����� ����� � �������
enum TParity {pt_No, pt_Odd, pt_Even, pt_Mark, pt_Space};//------------------ ��� ��������
enum TStopBits {sb_One, sb_OneHalf, sb_Two};//----------------------------- ��� ����-�����
enum TBaudRate {br_50, br_100, br_300, br_600, br_1200, br_2400, br_4800,
								br_9600, br_14400, br_19200, br_28800, br_38400, br_57600,
								br_115200};  //------------------------------------ ��� ��������� ��������
enum TFlowControl {fc_No, fc_XonXoff, fc_Hardware};//-------------- ��� ���������� �������
//-------------------------------------------------------------------------- ������ ������
struct TPortBuffer
{
		unsigned char Info[4095]; //---------------------------------------- ���������� ������
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
		TBaudRate    FBaudRate; //------------------------------------------ �������� ��������
		bool         FParityEn; //------------------------------ ���������� ��������� ��������
		TFlowControl FFlowCtrl; //----------------------------------------- ���������� �������
		bool         FCTSFlow; //----------------------------- ���������� ������� �������� CTS
		bool         FDSRFlow; //----------------------------- ���������� ������� �������� DSR
	  TBaudRate    FDTRControl; //---------------------------- ��� ���������� �� ������� DTR
		bool         FDSRSense; //------------------------------ ������� DSR �� ������� ������
		bool         FTxCont; //------------------------------- ���������� �������� ����� Xoff
		bool         FOutX;//---------------------------------- ���� ���. XonXoff ��� ��������
		bool         FInX;//------------------------------------- ���� ���. XonXoff ��� ������
		bool         FErrorReplace;//----------------------- �������� ����� � ��. �� ErrorChar
		bool         FDiscardNull;//-------------------------- ������� ������� ����� �� �����.
		TRTSControl  FRTSControl; //---------------------------- ��� ���������� �� ������� RTS
		bool         FAbortOnError;//------------------------------ ��������� ����� ��� ������
		int          FXonLim; //-------------------------- ���. ���-�� ���� � ������ ����� Xon
		int          FXoffLim;//------------------------ ����. ���-�� ���� � ������ ����� Xoff
		TSymbSize    FSymbSize;//---------------------------------------- ���-�� ��� � �������
		TParity      FParity;//-------------------------------------------------- ��� ��������
		TStopBits    FStopBits;//------------------------------------------- ���-�� ����-�����
		unsigned char FXonChar;//--------------------------------------------- ��� ������� Xon
		unsigned char FXOffChar;//------------------------------------------- ��� ������� Xoff
		unsigned char FErrorChar;//---------------------------------------- ��� ������� ������
		unsigned char FEofChar;//------------------------------------ ��� ������� ����� ������
		unsigned char FEvtChar;//---------------------------- ��� ������� ������������ �������
		bool         FToTotal;//--------------------------------- ���. ����� ������� ���������
		bool         FToIntv;//------------------------------------- ���. ������������ �������
		unsigned long FToValue; //------------------------------ �������� ������ �������� � ��
		HWND         FWindowHandle; //--------------------------------------- ���������� �����
		HWND         MessageDest;//--------------------------------- ���� ���������� ���������
		char*        s; //--------------------------- ��������� ���������� ��� ������ �����(1)
		char*        sp;//---------------------------------------------------------------  (2)

	protected:
		TCommTimeouts TimeOuts; //------------------------------------------ �������� ��������
		bool __fastcall GetCommNames(void);
		void __fastcall CalcTimeouts(void);
		void __fastcall FillDCB(void);
		virtual void __fastcall WndProc(TMessage Msg);

	public:
		unsigned long rcverrcnt; //---------------------------- ������� ������ ����� �� ������
		unsigned long trmerrcnt; //-------------------------- ������� ������ ����� �� ��������
		char          Buffer[4096]; //-------------------------------------------- ����� �����
		TOSystem      OSType; //------------------------------------- ��� ������������ �������
		bool          PortIsOpen; //---------------------------------------------- ���� ������
		unsigned long PortHandle;//------------------------------------------ ���������� �����
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
