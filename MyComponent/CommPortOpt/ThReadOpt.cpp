#include <vcl.h>
#pragma hdrstop

#include "ThReadOpt.h"
#pragma package(smart_init)

//========================================================================================
__fastcall TReadThreadOpt::TReadThreadOpt(TCommPortOpt *ComPortOpt) : TThread(false)
{
	FComPortOpt = ComPortOpt;
	FComHandleOpt = ComPortOpt->ComHandle;
	ZeroMemory( &ROL, sizeof(ROL) );
	ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );//----------------- с ручным сбросом
}

//========================================================================================
__fastcall TReadThreadOpt::~TReadThreadOpt(void)
{
	CloseHandle( ROL.hEvent );
}

//========================================================================================
//--------------------------------------------------------- ќсновна€ функци€ потока чтени€
void __fastcall TReadThreadOpt::Execute()
{
		bool OK;
		while( !Terminated )
		{
			//---- бесконечно ждем событи€ FComPort->rtEvent, при всех иных завершени€х ожидани€
			//-------- перезапускаем ожидание вновь, объект rtEvent при создании имеет автосброс
			if( WaitForSingleObject(FComPortOpt->rtEventOpt,INFINITE)!= WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- после событи€ по€влени€ в порту каких-либо символов можно читать
			while( true ) //--------------------------------------------------- бесконечный цикл
			{
				//----------------------------- сбросить ошибки и одновременно прочитать состо€ние
				ClearCommError(FComHandleOpt, &lpErrors, &lpStat );

				if(lpStat.cbInQue < FComPortOpt->PacketSize) //-- если в порту слишком мало данных
				{
					ResetEvent(FComPortOpt->rtEventOpt); //------ сбросить событие "по€вление символов"
					break;//-------------------------- прервать цикл и вернутьс€ в ожидание символов
				}

				//-------------------------------------- если в порту накопилось достаточно данных
				EnterCriticalSection( &FComPortOpt->ReadOptSection );//входим в критическую секцию
				DWORD pos1 = FComPortOpt->IBuffPos; // вспоминаем начало нечитанных (при старте=0)
				DWORD used = FComPortOpt->IBuffUsed; //- вспоминаем сколько нечитанных (сначала 0)
				LeaveCriticalSection(&FComPortOpt->ReadOptSection);

				DWORD pos2 = pos1 + used; // позици€ 2 = конец нечитанных = позици€ 1 + нечитанное
				DWORD size;

				//--------------------------------------- если не дошли до конца кольцевого буфера
				if(pos2 < FComPortOpt->IBuffSize) size = FComPortOpt->IBuffSize - pos2;
				else
				{
					pos2 -= FComPortOpt->IBuffSize;  //- конец нечитанных теперь по кольцу сместилс€
					size = pos1 - pos2;  //---------------------- осталось свободного места в буфере
				}

				//если в буфере места больше, чем очередь порта, то будем читать весь размер порта
				if( size > lpStat.cbInQue)size = lpStat.cbInQue;
				//----------------------------- иначе будем читать столько, сколько места в буфере

				if(size == 0)break; //---------- если в буфере полностью заполнен, то пока бросить

				if (size < 0) //--- если есть угроза переполнени€, то обнулить порт и пока бросить
				{
					PurgeComm(FComHandleOpt,PURGE_RXCLEAR);
					EnterCriticalSection(&FComPortOpt->ReadOptSection);//входим в критическую секцию
					FComPortOpt->IBuffUsed = 0;
					FComPortOpt->IBuffPos = 0;
					LeaveCriticalSection(&FComPortOpt->ReadOptSection);
					break;
				}

				DWORD BytesReaded = 0;

				//----------------------- пытаемс€ прин€ть в буфер ввода(от конца ранее прин€того)
				OK = ReadFile(FComHandleOpt,&(FComPortOpt->IBuffer[pos2]),size,&BytesReaded,&ROL);

				//------------------------- если чтение не удалось по причине медлительности порта
				if(!OK && GetLastError() == ERROR_IO_PENDING )
				{
					//---------------- запускаем ожидание событи€ до тех пор, пока оно не произойдет
					OK = GetOverlappedResult(FComHandleOpt, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent);//событие произошло - перезар€дить "event" читалки
				}

				if( OK && BytesReaded > 0 ) //------------------------------- если прочитаны байты
				{
					EnterCriticalSection(&FComPortOpt->ReadOptSection);//входим в критическую секцию
					FComPortOpt->IBuffUsed += BytesReaded; //--- увеличить число новых байт в буфере
					LeaveCriticalSection(&FComPortOpt->ReadOptSection);
          ResetEvent(ROL.hEvent);//------ событие произошло - перезар€дить "event" читалки
					SetEvent(FComPortOpt->reEventOpt); //------------- установить "event" компонента
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

