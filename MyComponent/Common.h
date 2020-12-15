//---------------------------------------------------------------------------
#ifndef CommonH
#define CommonH
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
#define  DCB_BINARY           0x0001
#define  DCB_PARITY           0x0002
#define  DCB_OUT_CTS_FLOW     0x0004
#define  DCB_OUT_DSR_FLOW     0x0008

#define  DCB_DTR_DISABLE      0x0000
#define  DCB_DTR_ENABLE       0x0010
#define  DCB_DTR_HANDSHAKE    0x0020

#define  DCB_DSR_SENSITIVITY  0x0040
#define  DCB_TX_CONT_ON_XOFF  0x0080
#define  DCB_OUT_X_CTRL       0x0100
#define  DCB_IN_X_CTRL        0x0200
#define  DCB_ERROR_CHAR       0x0400
#define  DCB_NULL             0x0800

#define  DCB_RTS_DISABLE      0x0000
#define  DCB_RTS_ENABLE       0x1000
#define  DCB_RTS_HANDSHAKE    0x2000
#define  DCB_RTS_TOGGLE       0x3000

#define  DCB_ABORT_ON_ERROR   0x4000

//----------------------------------
#define  NONE_FLOW   (DCB_DTR_ENABLE    | DCB_RTS_ENABLE)
#define  SOFT_FLOW   (DCB_DTR_ENABLE    | DCB_RTS_ENABLE    | DCB_OUT_X_CTRL   | DCB_IN_X_CTRL)
#define  HARD_FLOW   (DCB_DTR_HANDSHAKE | DCB_RTS_HANDSHAKE | DCB_OUT_CTS_FLOW | DCB_OUT_DSR_FLOW)

//---------------------------------------------------------------------------
typedef void __fastcall (__closure *TOpenEvent  )(System::TObject* Sender, int Error );
typedef void __fastcall (__closure *TErrorEvent )(System::TObject* Sender, int Error );
typedef void __fastcall (__closure *TReadEvent  )(System::TObject* Sender, char *Packet, int Count, int NPAK );
typedef void __fastcall (__closure *TReadEventOpt )(System::TObject* Sender,Byte *Packet, bool Priznak);
typedef void __fastcall(__closure *TTrubaPacketEvent)(System::TObject* Sender,BYTE *Packet,int &Size);
typedef CHAR *LPSTR;
//----------------------------------------------------------------------------------------
//----------------------------- последовательность идентификаторов для обозначения событий
enum TEventState
{
	evRxChar,evRxEventChar,evTxEmpty,evCTS,evDSR,evRlsd,evBreak,evError,evRing
};

typedef Set <TEventState, evRxChar, evRing>  TComEventType;

enum TBaudRate
{
	cbr110,cbr300,cbr600,cbr1200,cbr2400,cbr4800,cbr9600,cbr14400,cbr19200,cbr38400,
	cbr56000,cbr57600,cbr115200,cbr128000,cbr256000
};

enum TParity  { paNone, paOdd, paEven, paMark, paSpace };

enum TStopBits  { sb1_0, sb1_5, sb2_0 };

enum TComControl { ccNone, ccSoft, ccHard };

typedef WORD TDataBits;
#endif
