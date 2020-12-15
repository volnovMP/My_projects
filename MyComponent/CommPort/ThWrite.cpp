#include <vcl.h>
#pragma hdrstop

#include "ThWrite.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TWriteThread::TWriteThread( TCommPort *ComPort ) : TThread(false)
{
  FComPort = ComPort;
  FComHandle = FComPort->ComHandle;
  ZeroMemory( &WOL, sizeof(WOL) );
  WOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TWriteThread::~TWriteThread(void)
{
  CloseHandle( WOL.hEvent );
}

//----------------------------------------------------------------------------------------
//-------------------------------------------------- основная функция потока записи данных
void __fastcall TWriteThread::Execute()
{
  DWORD OutUsed;
	while( !Terminated )
	{
			//---------------------------------------- постоянно ждем события "можно вести запись"
			if( WaitForSingleObject(FComPort->wtEvent, INFINITE) != WAIT_OBJECT_0)continue;
			//---- дождались, но в буфере вывода ничего нет, поэтому взвести событие и снова ждать
			EnterCriticalSection( &FComPort->WriteSection );
      OutUsed	= FComPort->OBuffUsed;
	    LeaveCriticalSection( &FComPort->WriteSection );
			if(OutUsed == 0 )
      {
      	ResetEvent(FComPort->wtEvent);
        continue;
      }
			//если есть, что записать и управление аппаратное, но модем не готов к передаче данных
			COMSTAT lpStat; //----------------------------- объявить структуру состояния COM-порта
			DWORD lpErrors;

			//-- получить информацию о состоянии порта и его ошибках, одновременно сбросить ошибки
			ClearCommError( FComPort->ComHandle, &lpErrors, &lpStat );

			while(OutUsed) //-- пока в буфере остается что-то не отправленное в порт
			{
				EnterCriticalSection( &FComPort->WriteSection );
				DWORD pos1 = FComPort->OBuffPos;//получить указатель на начало непереданного массива
				DWORD used = FComPort->OBuffUsed; //---------- получить размер непереданного массива
        OutUsed = used;
				LeaveCriticalSection( &FComPort->WriteSection );

				DWORD pos2 = pos1 + used; //---- определить указатель на конец непереданного массива
				DWORD size;
				if( pos2 < FComPort->OBuffSize ) //- если конец массива не выходит за пределы буфера
				{
					size = pos2 - pos1; //------------------------- размер массива для передачи в порт
				}
				else //------- конец массива за пределами буфера, будет передана только первая часть
				{
					pos2 -= FComPort->OBuffSize; //---------- указатель на начало второй части массива
					size = FComPort->OBuffSize - pos1; //----------------- размер первой части массива
				}
				DWORD BytesWritten = 0; //------------- готовим число реально записанных байт в порт

				//------------------------ пишем в порт первую или единственную часть массива данных
				bool OK = WriteFile( FComHandle,&(FComPort->OBuffer[pos1]),size,&BytesWritten,&WOL);
				if( !OK && GetLastError() == ERROR_IO_PENDING)//--- если порт еще не выполнил работу
				{
					//--------------------------------------------- ждать пока порт не закончит работу
					OK = GetOverlappedResult(FComHandle,&WOL,&BytesWritten,TRUE);
					if(OK)ResetEvent(WOL.hEvent); //-------- если запись прошла удачно, сбросить Event
				}
				if(OK) //------------------------------ если удачно выполнена операция записи в порт
				{
					EnterCriticalSection( &FComPort->WriteSection );
					FComPort->OBuffUsed -= BytesWritten; //- число байт в буфере, не записанных в порт
					FComPort->OBuffPos += BytesWritten; //----- вычислить новую позицию начала массива
					//---------------- если позиция за пределами буфера, то переместить ее "по кольцу"
					if(FComPort->OBuffPos >= FComPort->OBuffSize)
					FComPort->OBuffPos -= FComPort->OBuffSize;
          OutUsed	= FComPort->OBuffUsed;
					LeaveCriticalSection( &FComPort->WriteSection );
				}
			}
		}

	return;
}

//---------------------------------------------------------------------------

