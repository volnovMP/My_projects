#include <vcl.h>
#pragma hdrstop

#include "EvStatusOpt.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TStatusEventThreadOpt::TStatusEventThreadOpt(TCommPortOpt *ComPortOpt) : TThread(false)
{
	FComPortOpt = ComPortOpt;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThreadOpt::Execute()
{
	try
	{
		while(!Terminated )
		{
			if( WaitForSingleObject(FComPortOpt->seEventOpt,INFINITE) != WAIT_OBJECT_0)continue;
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
void __fastcall TStatusEventThreadOpt::DoOnSignal(void)
{
	DWORD Status = FComPortOpt->Status;
	if(Status & EV_CTS)
		if( FComPortOpt->OnCTSSignal)FComPortOpt->OnCTSSignal(FComPortOpt);

	if( Status & EV_RLSD    )
		if( FComPortOpt->OnDCDSignal     )  FComPortOpt->OnDCDSignal(FComPortOpt);

	if( Status & EV_DSR     )
		if( FComPortOpt->OnDSRSignal     )  FComPortOpt->OnDSRSignal(FComPortOpt);

	if( Status & EV_RING    )
		if( FComPortOpt->OnRingSignal    )  FComPortOpt->OnRingSignal(FComPortOpt);

	if( Status & EV_RXCHAR  )
		if( FComPortOpt->OnRxDSignal     )  FComPortOpt->OnRxDSignal(FComPortOpt);

	if( Status & EV_RXFLAG  )
		if( FComPortOpt->OnRxEventSignal )  FComPortOpt->OnRxEventSignal(FComPortOpt);

	if( Status & EV_TXEMPTY )
		if( FComPortOpt->OnTxDSignal     )  FComPortOpt->OnTxDSignal(FComPortOpt);

	if( Status & EV_BREAK   )
		if( FComPortOpt->OnBreakSignal   )  FComPortOpt->OnBreakSignal(FComPortOpt);

	if( Status & EV_ERR     )
		if( FComPortOpt->OnErrorSignal  )  FComPortOpt->OnErrorSignal(FComPortOpt, GetLastError() );
}

//---------------------------------------------------------------------------

