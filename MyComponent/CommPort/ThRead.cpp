#include <vcl.h>
#pragma hdrstop
#include "ThRead.h"

#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TReadThread::TReadThread(TCommPort *ComPort) : TThread(false)
{
  FComPort = ComPort;
  FComHandle = ComPort->ComHandle;
  ZeroMemory( &ROL, sizeof(ROL) );
  ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TReadThread::~TReadThread(void)
{
  CloseHandle( ROL.hEvent );
}

//----------------------------------------------------------------------------------------
//--------------------------------------------------------- Основная функция потока чтения
void __fastcall TReadThread::Execute()
{

		while( !Terminated )
		{
			// бесконечно ждем события FComPort->rtEvent, при всех иных завершениях ожидания
			//перезапускам ожидание вновь, объект rtEvent при создании имеет автосброс
			if( WaitForSingleObject(FComPort->rtEvent, INFINITE) != WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//------- после события появления в порту каких-либо символов можно читать
			while( true ) //----------------------------------------- бесконечный цикл
			{
				ClearCommError( FComHandle, &lpErrors, &lpStat );//- сброс ошибок и чтение состояния
				if(lpStat.cbInQue < FComPort->PacketSize)
        {
        	ResetEvent(FComPort->rtEvent);
        	break;
        }

				EnterCriticalSection( &FComPort->ReadSection ); //---- входим в критическую секцию
				DWORD pos1 = FComPort->IBuffPos; //------ запоминаем позицию 1 ( изначально это 0)
				DWORD used = FComPort->IBuffUsed;//запоминаем прочитанное число (изначально это 0)
				LeaveCriticalSection(&FComPort->ReadSection);

				DWORD pos2 = pos1 + used; //-------- позиция 2 = позиция 1 + прочитанное
				DWORD size;

				//------------------------------ если не дошли до конца кольцевого буфера
				if(pos2 < FComPort->IBuffSize) size = FComPort->IBuffSize - pos2;
				else
				{
					pos2 -= FComPort->IBuffSize;
					size = pos1 - pos2;
				}

				if( size > lpStat.cbInQue ) size = lpStat.cbInQue;//если размер больше очереди порта
				if( size == 0 )  break; //--------------------------- если буфер переполнен, бросить
				DWORD BytesReaded = 0;

				//---------- пытаемся прочесть в буфер ввода(от конца ранее принятого)
				bool OK = ReadFile( FComHandle, &(FComPort->IBuffer[pos2]), size, &BytesReaded, &ROL);

				//--------------- если чтение не удалось по причине медлительности порта
				if( !OK && GetLastError() == ERROR_IO_PENDING )
				{
					//------ запускаем ожидание события до тех пор, пока оно не произойдет
					OK = GetOverlappedResult(FComHandle, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent); //по свершению события перезарядить "event" читалки
				}

				if( OK && BytesReaded > 0 ) //------------------------------- если прочитаны байты
				{
					EnterCriticalSection(&FComPort->ReadSection ); //--- входим в критическую секцию
					FComPort->IBuffUsed += BytesReaded; //------ увеличить число новых байт в буфере
   				LeaveCriticalSection(&FComPort->ReadSection);
					SetEvent(FComPort->reEvent); //------------------- установить "event" компонента
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

