#include <vcl.h>
#pragma hdrstop

#include "ThStatus.h"
#pragma package(smart_init)

//----------------------------------------------------------------------------------------
__fastcall TStatusThread::TStatusThread(TCommPort *ComPort, TComEventType Events) : TThread(false)
{
	DWORD EvList[9] =
	{EV_RXCHAR, EV_RXFLAG, EV_TXEMPTY, EV_CTS, EV_DSR, EV_RLSD, EV_BREAK,	EV_ERR, EV_RING };

	FComPort = ComPort;
  FComHandle = ComPort->ComHandle;
  DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
  SetCommMask( FComPort->ComHandle, AttrWord );
	ZeroMemory( &SOL, sizeof(SOL) );
  SOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TStatusThread::~TStatusThread(void)
{
  CloseHandle( SOL.hEvent );
}
//------------------------------------------------ поток слежения за всеми событиями порта
//----------------------------------------------------------------------------------------
void __fastcall TStatusThread::Execute()
{
  DWORD lpModemStatus;
	if( FComPort->IsEnabled() &&  //-------------------- если порт имеет достоверный Хэндл и 
	GetCommModemStatus( FComHandle,&lpModemStatus)) //функция чтения регистра модема успешна
	{
		FComPort->FCTS  = (lpModemStatus & MS_CTS_ON); //------- считываем состояние линии CTS
    FComPort->FDSR  = (lpModemStatus & MS_DSR_ON); //------- считываем состояние линии DSR
    FComPort->FDCD  = (lpModemStatus & MS_RLSD_ON);//------ считываем состояние линии RLSD
    FComPort->FRing = (lpModemStatus & MS_RING_ON); //----- считываем состояние линии RING
    FComPort->Status = 0;
  }
	while( !Terminated )
	{
		if( !FComPort->IsEnabled())continue; //---------- если у порта нет достоверного хэндла
		DWORD Status;
		//------------- включаем ожидание асинхронного события структуры SOL порта
		bool OK = WaitCommEvent(FComHandle, &Status, &SOL); // в статусе получим массу событий
		if( !OK ) //--------------------------------------------------- если сразу нет событий
		{
			Sleep(50); //----------------------------------------------------------- ждем 50 мсек
			if( GetLastError() == ERROR_IO_PENDING ) //-------------------- если порт в ожидании
			{
				DWORD Temp;
				//------------------------------------- ждать, не выходя из функции, событий порта
				OK = GetOverlappedResult(FComHandle, &SOL, &Temp, TRUE );
			}
		}
		if(OK) //------------------------------------ если наступило событие порта
		{
       ResetEvent(SOL.hEvent); //--------------- если дождались, сбросить событие
			FComPort->Status = Status; //------------------ получаем текущую массу событий порта
			if( (Status & (EV_CTS | //--------------------------------- если есть CTS-сигнал или
			EV_DSR |   //--------------------------------------------------- есть DSR-сигнал или
			EV_RING | //--------------------------------------------------- есть RING-сигнал или
			EV_RLSD | //--------------------------------------------------- есть RLSD-сигнал или
			EV_ERR))!= 0 && //---------------------------- есть ошибка статуса линии и при  этом
			GetCommModemStatus(FComHandle, &lpModemStatus) ) //- успешно прочитан регистр модема
			{
				//------------------------------- то установить актуальные значения сигналов линий
				FComPort->FCTS = (lpModemStatus & MS_CTS_ON); //--------------------------- 0x0010
				FComPort->FDSR = (lpModemStatus & MS_DSR_ON); //--------------------------- 0x0020
				FComPort->FDCD = (lpModemStatus & MS_RLSD_ON); //-------------------------- 0x0080
				FComPort->FRing = (lpModemStatus & MS_RING_ON); //------------------------- 0x0040

				if( FComPort->Control == ccHard && //----------- если порт управляется аппаратно и
				FComPort->FCTS && //есть сигнал CTS (буфер модема пустой) модем готов передавать и
				FComPort->OBuffUsed > 0) //------------ в буфере вывода компонента есть данные, то
				SetEvent(FComPort->wtEvent);//------------ установить событие, "есть, что писать"
			}
			//--------------------------- если в массе событий есть прием символа
			if((Status & EV_RXCHAR)!=0 ) SetEvent(FComPort->rtEvent);//установить "надо читать"
			SetEvent(FComPort->seEvent); //--------------------- установить "есть событие порта"
		}
	}
	return;
}
