#include <vcl.h>
#pragma hdrstop

#include "ThReadAB.h"
#pragma package(smart_init)

//========================================================================================
__fastcall TReadThreadAB::TReadThreadAB(TCommPortAB *ComPortAB) : TThread(false)
{
	FComPortAB = ComPortAB;
	FComHandleAB = ComPortAB->ComHandle;
	ZeroMemory( &ROL, sizeof(ROL) );
	ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );//----------------- с ручным сбросом
}

//========================================================================================
__fastcall TReadThreadAB::~TReadThreadAB(void)
{
	CloseHandle( ROL.hEvent );
}

//========================================================================================
//--------------------------------------------------------- ќсновна€ функци€ потока чтени€
void __fastcall TReadThreadAB::Execute()
{
		bool OK;
		while( !Terminated )
		{
			//---- бесконечно ждем событи€ FComPort->rtEvent, при всех иных завершени€х ожидани€
			//-------- перезапускаем ожидание вновь, объект rtEvent при создании имеет автосброс
			if( WaitForSingleObject(FComPortAB->rtEventAB,INFINITE)!= WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- после событи€ по€влени€ в порту каких-либо символов можно читать
			while( true ) //--------------------------------------------------- бесконечный цикл
			{
				//----------------------------- сбросить ошибки и одновременно прочитать состо€ние
				ClearCommError(FComHandleAB, &lpErrors, &lpStat );

				if(lpStat.cbInQue < FComPortAB->PacketSize) //-- если в порту слишком мало данных
				{
					ResetEvent(FComPortAB->rtEventAB); //------ сбросить событие "по€вление символов"
					break;//-------------------------- прервать цикл и вернутьс€ в ожидание символов
				}

				//-------------------------------------- если в порту накопилось достаточно данных
				EnterCriticalSection( &FComPortAB->ReadABSection );//входим в критическую секцию
				DWORD pos1 = FComPortAB->IBuffPos; // вспоминаем начало нечитанных (при старте=0)
				DWORD used = FComPortAB->IBuffUsed; //- вспоминаем сколько нечитанных (сначала 0)
				LeaveCriticalSection(&FComPortAB->ReadABSection);

				DWORD pos2 = pos1 + used; // позици€ 2 = конец нечитанных = позици€ 1 + нечитанное
				DWORD size;

				//--------------------------------------- если не дошли до конца кольцевого буфера
				if(pos2 < FComPortAB->IBuffSize) size = FComPortAB->IBuffSize - pos2;
				else
				{
					pos2 -= FComPortAB->IBuffSize;  //- конец нечитанных теперь по кольцу сместилс€
					size = pos1 - pos2;  //---------------------- осталось свободного места в буфере
				}

				//если в буфере места больше, чем очередь порта, то будем читать весь размер порта
				if( size > lpStat.cbInQue)size = lpStat.cbInQue;
				//----------------------------- иначе будем читать столько, сколько места в буфере

				if(size == 0)break; //---------- если в буфере полностью заполнен, то пока бросить

				if (size < 0) //--- если есть угроза переполнени€, то обнулить порт и пока бросить
				{
					PurgeComm(FComHandleAB,PURGE_RXCLEAR);
					EnterCriticalSection(&FComPortAB->ReadABSection);//входим в критическую секцию
					FComPortAB->IBuffUsed = 0;
					FComPortAB->IBuffPos = 0;
					LeaveCriticalSection(&FComPortAB->ReadABSection);
					break;
				}

				DWORD BytesReaded = 0;

				//----------------------- пытаемс€ прин€ть в буфер ввода(от конца ранее прин€того)
				OK = ReadFile(FComHandleAB,&(FComPortAB->IBuffer[pos2]),size,&BytesReaded,&ROL);

				//------------------------- если чтение не удалось по причине медлительности порта
				if(!OK && GetLastError() == ERROR_IO_PENDING )
				{
					//---------------- запускаем ожидание событи€ до тех пор, пока оно не произойдет
					OK = GetOverlappedResult(FComHandleAB, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent);//событие произошло - перезар€дить "event" читалки
				}

				if( OK && BytesReaded > 0 ) //------------------------------- если прочитаны байты
				{
					EnterCriticalSection(&FComPortAB->ReadABSection);//входим в критическую секцию
					FComPortAB->IBuffUsed += BytesReaded; //--- увеличить число новых байт в буфере
					LeaveCriticalSection(&FComPortAB->ReadABSection);
          ResetEvent(ROL.hEvent);//------ событие произошло - перезар€дить "event" читалки
					SetEvent(FComPortAB->reEventAB); //------------- установить "event" компонента
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

