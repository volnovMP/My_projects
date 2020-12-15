#include <vcl.h>
#pragma hdrstop

#include "ThWriteOpt.h"
#pragma package(smart_init)

//========================================================================================
//----------------------------------------------------------- функци€ записи данных в порт
__fastcall TWriteThreadOpt::TWriteThreadOpt( TCommPortOpt *ComPortOpt ) : TThread(false)
{
	FComPortOpt = ComPortOpt;
	FComHandleOpt = FComPortOpt->ComHandle;
	ZeroMemory( &WolOpt, sizeof(WolOpt) );
	WolOpt.hEvent = CreateEvent( NULL, true, true, NULL );
}

//========================================================================================
//------------------------------------------------------- функци€ деструктор потока записи
__fastcall TWriteThreadOpt::~TWriteThreadOpt(void)
{
	CloseHandle( WolOpt.hEvent );
}

//========================================================================================
//-------------------------------------------------- основна€ функци€ потока записи данных
void __fastcall TWriteThreadOpt::Execute()
{
	DWORD OutUsed;
	DWORD OK;
	bool good;
	int ErrWritten;
	while( !Terminated )
	{

		//---------------------------------------- посто€нно ждем событи€ "можно вести запись"
		if( WaitForSingleObject(FComPortOpt->wtEventOpt, INFINITE) != WAIT_OBJECT_0)continue;
		FComPortOpt->GotovWrite = false;
		ResetEvent(FComPortOpt->wtEventOpt);
		//-------------------------------- если дождались, то смотрим, сколько данных на вывод
		EnterCriticalSection(&FComPortOpt->WriteOptSection);
		OutUsed	= FComPortOpt->OBuffUsed;
		LeaveCriticalSection(&FComPortOpt->WriteOptSection);
		//------------------ в буфере вывода ничего нет, поэтому взвести событие и снова ждать
		if(OutUsed == 0 )
		{
			FComPortOpt->GotovWrite=true;
			continue;
		}
		//- если есть, что записать и управление аппаратное,а модем не готов к передаче данных
		COMSTAT lpStat; //----------------------------- объ€вить структуру состо€ни€ COM-порта
		DWORD lpErrors;
		DWORD BytesWritten = 0; //--------------- готовим число реально записанных байт в порт
		//----------------------------------------------------------------------- пишем в порт
		WriteFile(FComHandleOpt,&FComPortOpt->OBuffer,OutUsed,&BytesWritten,&WolOpt);
		OK = WaitForSingleObject(WolOpt.hEvent,INFINITE);
		if((OK == WAIT_OBJECT_0)&& GetOverlappedResult(FComHandleOpt,&WolOpt,&BytesWritten,true))
		{
			if(BytesWritten == OutUsed)good = true;
		}
		else
		//-- получить информацию о состо€нии порта и его ошибках, одновременно сбросить ошибки
		ClearCommError( FComPortOpt->ComHandle, &lpErrors, &lpStat );

		ResetEvent(WolOpt.hEvent); //-----------------------------------------  сбросить Event
		EnterCriticalSection(&FComPortOpt->WriteOptSection);
		FComPortOpt->OBuffUsed = 0;
		LeaveCriticalSection(&FComPortOpt->WriteOptSection);
		FComPortOpt->GotovWrite = true;
	}
	return;
}

//---------------------------------------------------------------------------

