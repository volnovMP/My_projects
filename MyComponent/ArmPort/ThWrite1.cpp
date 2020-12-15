#include <vcl.h>
#pragma hdrstop

#include "ThWrite1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TWriteThread1::TWriteThread1( TArmPort *ArmPort ) : TThread(false)
{
	FArmPort = ArmPort;
	FArmHandle = FArmPort->ComHandle;
	ZeroMemory( &WOL1, sizeof(WOL1) );
	WOL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TWriteThread1::~TWriteThread1(void)
{
	CloseHandle( WOL1.hEvent );
}

//----------------------------------------------------------------------------------------
//-------------------------------------------------- основна€ функци€ потока записи данных
void __fastcall TWriteThread1::Execute()
{
  DWORD OutUsed;
	try
	{
		while( !Terminated )
		{
			//---------------------------------------- посто€нно ждем событи€ "можно вести запись"
			if( WaitForSingleObject(FArmPort->wtEvent, INFINITE) != WAIT_OBJECT_0)continue;
			//---- дождались, но в буфере вывода ничего нет, поэтому взвести событие и снова ждать
			EnterCriticalSection( &FArmPort->WriteSection );
      OutUsed	= FArmPort->OBuffUsed;
	    LeaveCriticalSection( &FArmPort->WriteSection );
			if(OutUsed == 0 )
      {
      	ResetEvent(FArmPort->wtEvent);
        continue;
      }
			//если есть, что записать и управление аппаратное, но модем не готов к передаче данных
			COMSTAT lpStat; //----------------------------- объ€вить структуру состо€ни€ COM-порта
			DWORD lpErrors;

			//-- получить информацию о состо€нии порта и его ошибках, одновременно сбросить ошибки
			ClearCommError( FArmPort->ComHandle, &lpErrors, &lpStat );

			while(OutUsed) //-- пока в буфере остаетс€ что-то не отправленное в порт
			{
				EnterCriticalSection( &FArmPort->WriteSection );
				DWORD pos1 = FArmPort->OBuffPos;//получить указатель на начало непереданного массива
				DWORD used = FArmPort->OBuffUsed; //---------- получить размер непереданного массива
        OutUsed = used;
				LeaveCriticalSection( &FArmPort->WriteSection );

				DWORD pos2 = pos1 + used; //---- определить указатель на конец непереданного массива
				DWORD size;
				if( pos2 < FArmPort->OBuffSize ) //- если конец массива не выходит за пределы буфера
				{
					size = pos2 - pos1; //------------------------- размер массива дл€ передачи в порт
				}
				else //------- конец массива за пределами буфера, будет передана только перва€ часть
				{
					pos2 -= FArmPort->OBuffSize; //---------- указатель на начало второй части массива
					size = FArmPort->OBuffSize - pos1; //----------------- размер первой части массива
				}
				DWORD BytesWritten = 0; //------------- готовим число реально записанных байт в порт

				//------------------------ пишем в порт первую или единственную часть массива данных
				bool OK = WriteFile( FArmHandle,&(FArmPort->OBuffer[pos1]),size,&BytesWritten,&WOL1);
				if( !OK && GetLastError() == ERROR_IO_PENDING)//--- если порт еще не выполнил работу
				{
					//--------------------------------------------- ждать пока порт не закончит работу
					OK = GetOverlappedResult(FArmHandle,&WOL1,&BytesWritten,TRUE);
					if(OK)ResetEvent(WOL1.hEvent); //-------- если запись прошла удачно, сбросить Event
				}
				if(OK) //------------------------------ если удачно выполнена операци€ записи в порт
				{
					EnterCriticalSection( &FArmPort->WriteSection );
					FArmPort->OBuffUsed -= BytesWritten; //- число байт в буфере, не записанных в порт
					FArmPort->OBuffPos += BytesWritten; //----- вычислить новую позицию начала массива
					//---------------- если позици€ за пределами буфера, то переместить ее "по кольцу"
					if(FArmPort->OBuffPos >= FArmPort->OBuffSize)
					FArmPort->OBuffPos -= FArmPort->OBuffSize;
          OutUsed	= FArmPort->OBuffUsed;
					LeaveCriticalSection( &FArmPort->WriteSection );
				}
			}
		}
	}
		catch (...)
	{
		Application->MessageBox("ќЎ»Ѕ ј","COMPortThWrite",MB_OK);
	}
	return;
}
//----------------------------------------------------------------------------------------

