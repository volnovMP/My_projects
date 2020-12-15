#include <vcl.h>
#pragma hdrstop

#include "EvStatusAB.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TStatusEventThreadAB::TStatusEventThreadAB(TCommPortAB *ComPortAB) : TThread(false)
{
	FComPortAB = ComPortAB;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThreadAB::Execute()
{
	try
	{
		while(!Terminated )
		{
			if( WaitForSingleObject(FComPortAB->seEventAB,INFINITE) != WAIT_OBJECT_0)continue;
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
void __fastcall TStatusEventThreadAB::DoOnSignal(void)
{
	DWORD Status = FComPortAB->Status;
	if(Status & EV_CTS)
		if( FComPortAB->OnCTSSignal)FComPortAB->OnCTSSignal(FComPortAB);

	if( Status & EV_RLSD    )
		if( FComPortAB->OnDCDSignal     )  FComPortAB->OnDCDSignal(FComPortAB);

	if( Status & EV_DSR     )
		if( FComPortAB->OnDSRSignal     )  FComPortAB->OnDSRSignal(FComPortAB);

	if( Status & EV_RING    )
		if( FComPortAB->OnRingSignal    )  FComPortAB->OnRingSignal(FComPortAB);

	if( Status & EV_RXCHAR  )
		if( FComPortAB->OnRxDSignal     )  FComPortAB->OnRxDSignal(FComPortAB);

	if( Status & EV_RXFLAG  )
		if( FComPortAB->OnRxEventSignal )  FComPortAB->OnRxEventSignal(FComPortAB);

	if( Status & EV_TXEMPTY )
		if( FComPortAB->OnTxDSignal     )  FComPortAB->OnTxDSignal(FComPortAB);

	if( Status & EV_BREAK   )
		if( FComPortAB->OnBreakSignal   )  FComPortAB->OnBreakSignal(FComPortAB);

	if( Status & EV_ERR     )
		if( FComPortAB->OnErrorSignal  )  FComPortAB->OnErrorSignal(FComPortAB, GetLastError() );
}

//---------------------------------------------------------------------------

