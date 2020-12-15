#include <vcl.h>
#pragma hdrstop

#include "EvStatus1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TStatusEventThread1::TStatusEventThread1(TArmPort *ArmPort) : TThread(false)
{
	FArmPort = ArmPort;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThread1::Execute()
{
	try
	{
		while(!Terminated )
		{
			if(WaitForSingleObject(FArmPort->seEvent,INFINITE)!= WAIT_OBJECT_0 )continue;
			Synchronize( DoOnSignal );
		}
	}
		catch (...)
	{
		Application->MessageBox("ÎØÈÁÊÀ","ARMPortEvStatus",MB_OK);
	}
	return;
}

//---------------------------------------------------------------------------
void __fastcall TStatusEventThread1::DoOnSignal(void)
{
	DWORD Status = FArmPort->Status;

	if( Status & EV_RXFLAG  )
		if( FArmPort->OnRxEventSignal )  FArmPort->OnRxEventSignal(FArmPort);

	if( Status & EV_TXEMPTY )
		if( FArmPort->OnTxDSignal     )  FArmPort->OnTxDSignal(FArmPort);

	if( Status & EV_BREAK   )
		if( FArmPort->OnBreakSignal   )  FArmPort->OnBreakSignal(FArmPort);

	if( Status & EV_ERR     )
		if( FArmPort->OnErrorSignal   )  FArmPort->OnErrorSignal(FArmPort, GetLastError() );
}

//---------------------------------------------------------------------------

