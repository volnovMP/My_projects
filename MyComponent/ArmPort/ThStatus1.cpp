#include <vcl.h>
#pragma hdrstop

#include "ThStatus1.h"
#pragma package(smart_init)

//----------------------------------------------------------------------------------------
__fastcall TStatusThread1::TStatusThread1(TArmPort *ArmPort, TComEventType Events) : TThread(false)
{
	DWORD EvList[9] =
	{EV_RXCHAR, EV_RXFLAG, EV_TXEMPTY, EV_CTS, EV_DSR, EV_RLSD, EV_BREAK,	EV_ERR, EV_RING };

	FArmPort = ArmPort;
	FArmHandle = ArmPort->ComHandle;
  DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
  SetCommMask( FArmPort->ComHandle, AttrWord );
	ZeroMemory( &SOL1, sizeof(SOL1) );
  SOL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TStatusThread1::~TStatusThread1(void)
{
	CloseHandle( SOL1.hEvent );
}
//------------------------------------------------ поток слежения за всеми событиями порта
//----------------------------------------------------------------------------------------
void __fastcall TStatusThread1::Execute()
{
  DWORD lpModemStatus;
	if( FArmPort->IsEnabled() )//--------------------------- если порт имеет достоверный Хэндл
	FArmPort->Status = 0;
	try
	{
		while( !Terminated )
		{
			if( !FArmPort->IsEnabled())continue; //если у порта нет достоверного хэндла
			DWORD Status;
			//------------- включаем ожидание асинхронного события структуры SOL порта
			bool OK = WaitCommEvent(FArmHandle, &Status, &SOL1); // в статусе получим массу событий
			if( !OK ) //--------------------------------------- если сразу нет событий
			{
        Sleep(15);
				if( GetLastError() == ERROR_IO_PENDING ) //-------- если порт в ожидании
				{
					DWORD Temp;
					//------------------------- ждать, не выходя из функции, событий порта
					OK = GetOverlappedResult(FArmHandle, &SOL1, &Temp, TRUE );

				}
			}
			if(OK) //------------------------------------ если наступило событие порта
			{
				ResetEvent(SOL1.hEvent); //-- если дождались, сбросить событие
				FArmPort->Status = Status; //------ получаем текущую массу событий порта
				//----------------------------- если в массе событий есть прием символа
				if((Status & EV_RXCHAR)!=0 ) SetEvent(FArmPort->rtEvent);//установить "надо читать"
				SetEvent(FArmPort->seEvent); //--------- установить "есть событие порта"
				if(FArmPort->OBuffUsed > 0) //в буфере вывода компонента есть данные, то
				SetEvent(FArmPort->wtEvent);//--- установить событие, "есть, что писать"
			}
		}
	}
	catch(...)
	{
		Application->MessageBox("ОШИБКА","ARMPortThRead",MB_OK);
	}
	return;
}

