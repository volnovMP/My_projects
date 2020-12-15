#include <vcl.h>
#pragma hdrstop

#include "ThStatusOpt.h"
#pragma package(smart_init)

//========================================================================================
//--------------------------------------------------------------------- конструктор класса
__fastcall TStatusThreadOpt::TStatusThreadOpt(TCommPortOpt *ComPortOpt,TComEventType Events)
: TThread(false)
{
	//----------------------- составляется список из системных имен флагов для WaitCommEvent
	DWORD EvList[9] =
	{EV_RXCHAR,EV_RXFLAG,EV_TXEMPTY,EV_CTS,EV_DSR,EV_RLSD,EV_BREAK,EV_ERR,EV_RING };

	FComPortOpt = ComPortOpt;
	FComHandle = ComPortOpt->ComHandle;
	DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
	SetCommMask( FComPortOpt->ComHandle, AttrWord );
	ZeroMemory( &SOL, sizeof(SOL) );
	SOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); //-------------------- ручной сброс
}

//========================================================================================
__fastcall TStatusThreadOpt::~TStatusThreadOpt(void)
{
	CloseHandle( SOL.hEvent );
}
//========================================================================================
//------------------------------------------------ поток слежения за всеми событиями порта
void __fastcall TStatusThreadOpt::Execute()
{
	DWORD lpModemStatus;
	if( FComPortOpt->IsEnabled() &&  //----------------- если порт имеет достоверный Хэндл и
	GetCommModemStatus( FComHandle,&lpModemStatus)) //функция чтения регистра модема успешна
	{
		FComPortOpt->FCTS  = (lpModemStatus & MS_CTS_ON); //---- считываем состояние линии CTS
		FComPortOpt->FDSR  = (lpModemStatus & MS_DSR_ON); //---- считываем состояние линии DSR
		FComPortOpt->FDCD  = (lpModemStatus & MS_RLSD_ON);//--- считываем состояние линии RLSD
		FComPortOpt->FRing = (lpModemStatus & MS_RING_ON); //-- считываем состояние линии RING
		FComPortOpt->Status = 0;
	}
	while( !Terminated )
	{
		if( !FComPortOpt->IsEnabled())continue; //- если нет достоверного хэндла, то зациклить
		DWORD Status;
		//-------------- заряжаем систему на ожидание асинхронного события структуры SOL порта
		bool OK = WaitCommEvent(FComHandle, &Status, &SOL); // в статусе получим массу событий

		if( !OK ) //--------------------------------------------- если неудачный вызов функции
		{
			Sleep(50); //---------------------------------------------------------- ждем 50 мсек
			if( GetLastError() == ERROR_IO_PENDING ) //-------------------- если порт в ожидании
			{
				DWORD Temp;
				//------------------------------------- ждать, не выходя из функции, событий порта
				OK = GetOverlappedResult(FComHandle, &SOL, &Temp, TRUE );//-- TRUE = ждать "вечно"
			}
		}

		if(OK) //------------------------------------------------ если наступило событие порта
		{
			ResetEvent(SOL.hEvent); //----------------- дождались, теперь нужно сбросить событие
			FComPortOpt->Status = Status; //--------------- получаем текущую массу событий порта
			if( (Status & (EV_CTS | //--------------------------------- если есть CTS-сигнал или
			EV_DSR |   //--------------------------------------------------- есть DSR-сигнал или
			EV_RING | //--------------------------------------------------- есть RING-сигнал или
			EV_RLSD | //--------------------------------------------------- есть RLSD-сигнал или
			EV_ERR))!= 0 && //---------------------------- есть ошибка статуса линии и при  этом
			GetCommModemStatus(FComHandle, &lpModemStatus) ) //- успешно прочитан регистр модема
			{
				//------------------------------- то установить актуальные значения сигналов линий
				FComPortOpt->FCTS = (lpModemStatus & MS_CTS_ON); //------------------------ 0x0010
				FComPortOpt->FDSR = (lpModemStatus & MS_DSR_ON); //------------------------ 0x0020
				FComPortOpt->FDCD = (lpModemStatus & MS_RLSD_ON); //----------------------- 0x0080
				FComPortOpt->FRing = (lpModemStatus & MS_RING_ON); //---------------------- 0x0040
/*				if( FComPortOpt->Control == ccHard && //-------- если порт управляется аппаратно и
				FComPortOpt->FCTS && // CTS == true (буфер модема пустой) модем готов передавать и
				FComPortOpt->OBuffUsed > 0) //--------- в буфере вывода компонента есть данные, то
				SetEvent(FComPortOpt->wtEventOpt);//------- установить событие, "есть, что писать"
*/
			}
			//------------------------------------------ если в массе событий есть прием символа
			if((Status & EV_RXCHAR)!=0)
			SetEvent(FComPortOpt->rtEventOpt);//----------------------- установить "надо читать"
			SetEvent(FComPortOpt->seEventOpt); //--------------- установить "есть событие порта"
		}
	}
	return;
}
