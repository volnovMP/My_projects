#include <vcl.h>
#pragma hdrstop

#include "EvStatus.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TStatusEventThread::TStatusEventThread(TCommPort *ComPort) : TThread(false)
{
  FComPort = ComPort;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThread::Execute()
{
	try
	{
		while(!Terminated )
		{
			if( WaitForSingleObject(FComPort->seEvent, INFINITE) != WAIT_OBJECT_0 )  continue;
			Synchronize( DoOnSignal );
		}
		return;
	}
	catch (...)
	{
		Application->MessageBox("ÎØÈÁÊÀ","COMPortEvStatus",MB_OK);
	}
	return;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThread::DoOnSignal(void)
{
  DWORD Status = FComPort->Status;
	if( Status & EV_CTS     )
		if( FComPort->OnCTSSignal     )  FComPort->OnCTSSignal(FComPort);

	if( Status & EV_RLSD    )
		if( FComPort->OnDCDSignal     )  FComPort->OnDCDSignal(FComPort);

	if( Status & EV_DSR     )
		if( FComPort->OnDSRSignal     )  FComPort->OnDSRSignal(FComPort);

	if( Status & EV_RING    )
		if( FComPort->OnRingSignal    )  FComPort->OnRingSignal(FComPort);

	if( Status & EV_RXCHAR  )
		if( FComPort->OnRxDSignal     )  FComPort->OnRxDSignal(FComPort);

	if( Status & EV_RXFLAG  )
		if( FComPort->OnRxEventSignal )  FComPort->OnRxEventSignal(FComPort);

	if( Status & EV_TXEMPTY )
		if( FComPort->OnTxDSignal     )  FComPort->OnTxDSignal(FComPort);

	if( Status & EV_BREAK   )
		if( FComPort->OnBreakSignal   )  FComPort->OnBreakSignal(FComPort);

	if( Status & EV_ERR     )
		if( FComPort->OnErrorSignal  )  FComPort->OnErrorSignal(FComPort, GetLastError() );
}

//---------------------------------------------------------------------------

