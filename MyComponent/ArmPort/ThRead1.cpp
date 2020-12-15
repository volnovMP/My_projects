#include <vcl.h>
#pragma hdrstop

#include "ThRead1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TArmReadThread::TArmReadThread(TArmPort *ArmPort) : TThread(false)
{
	FArmPort = ArmPort;
	FArmHandle = ArmPort->ComHandle;
	ZeroMemory( &ROL1, sizeof(ROL1) );
  ROL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TArmReadThread::~TArmReadThread(void)
{
	CloseHandle( ROL1.hEvent );
}

//----------------------------------------------------------------------------------------
//--------------------------------------------------------- Основная функция потока чтения
void __fastcall TArmReadThread::Execute()
{
	try
	{
		while( !Terminated )
		{
			//---- бесконечно ждем события FComPort->rtEvent, при всех иных завершениях ожидания
			//--------- перезапускам ожидание вновь, объект rtEvent при создании имеет автосброс
			if( WaitForSingleObject(FArmPort->rtEvent, INFINITE) != WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- после события появления в порту каких-либо символов можно читать
			while( true ) //----------------------------------------------------- бесконечный цикл
			{
				ClearCommError( FArmHandle, &lpErrors, &lpStat );//- сброс ошибок и чтение состояния
				if(lpStat.cbInQue < FArmPort->PacketSize)
        {
          ResetEvent(FArmPort->rtEvent);
        	break;
        }

				EnterCriticalSection( &FArmPort->ReadSection ); //---- входим в критическую секцию
				DWORD pos1 = FArmPort->IBuffPos; //------ запоминаем позицию 1 ( изначально это 0)
				DWORD used = FArmPort->IBuffUsed;//запоминаем прочитанное число (изначально это 0)
				LeaveCriticalSection(&FArmPort->ReadSection);

				DWORD pos2 = pos1 + used; //-------- позиция 2 = позиция 1 + прочитанное
				DWORD size;

				//----------------------------- если не дошли до конца кольцевого буфера
				if(pos2 < FArmPort->IBuffSize) size = FArmPort->IBuffSize - pos2;
				else
				{
					pos2 -= FArmPort->IBuffSize;
					size = pos1 - pos2;
				}

				if( size > lpStat.cbInQue ) size = lpStat.cbInQue;//-- размер больше очереди порта
				if( size == 0 )  break; //------------------------- если буфер переполнен, бросить
				DWORD BytesReaded = 0;

				//---------------------- пытаемся прочесть в буфер ввода(от конца ранее принятого)
				bool OK = ReadFile(FArmHandle,&(FArmPort->IBuffer[pos2]),size,&BytesReaded,&ROL1);

				//------------------------- если чтение не удалось по причине медлительности порта
				if( !OK && GetLastError() == ERROR_IO_PENDING )
				{
					//------ запускаем ожидание события до тех пор, пока оно не произойдет
					OK = GetOverlappedResult(FArmHandle, &ROL1, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL1.hEvent); //------ по событию перезарядить "event" читалки
				}

				if( OK && BytesReaded > 0 ) //------------------------------- если прочитаны байты
				{
					EnterCriticalSection( &FArmPort->ReadSection ); //-- входим в критическую секцию
          FArmPort->IBuffUsed += BytesReaded; //------ увеличить число новых байт в буфере
					LeaveCriticalSection(&FArmPort->ReadSection);
					SetEvent(FArmPort->reEvent); //------------------- установить "event" компонента
				}
			}
		}
	}
	catch(...)
	{
		Application->MessageBox("ОШИБКА","ARMPortTHRead",MB_OK);
	}
	return;
}
//----------------------------------------------------------------------------------------

