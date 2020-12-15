//---------------------------------------------------------------------------
#include <vcl.h>
#include <windows.h>

#pragma hdrstop
#include "TrubaServOut.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

__fastcall TTrubaServOut::TTrubaServOut(TServOut *ServOut) : TThread(false)
{
	FServOut = ServOut;
}
//========================================================================================
void __fastcall TTrubaServOut::DoReadPacket(void)
{
	int Razmer = 28;
	if(FServOut->Sost == 8888)return;
	if(FServOut->OnReadPacket)FServOut->OnReadPacket(FServOut,FInBuffer,Razmer);
}

//==============================================================================
//------------------------------- основная функция потока для обслуживания трубы
void __fastcall TTrubaServOut::Execute(void)
{
	int err, i, SostSrv;
	DWORD err1,dwWait;
	bool rc, fSuccess;
	bool tst,tst1;
	//	try	{
	while(!ServBreak)
	{
		if(ServConnected) //-------------------------------------------- если сервер подключен
		{
			if(!ReadFile(FServOut->Hndler,FInBuffer,28,&FCountIn,&FRd))
			{
				err = GetLastError();
				switch(err)
				{
					case ERROR_PIPE_LISTENING: WaitForSingleObject(FRd.hEvent ,300); break;
					case ERROR_NO_DATA: WaitForSingleObject(FRd.hEvent ,300); break;
					case ERROR_IO_PENDING:
						WaitForSingleObject(FRd.hEvent,INFINITE);
						CancelIo(FServOut->Hndler);
						break;
					default: ExitLoop = true;		
				}			
			}
			if(!ExitLoop)
			{
				GetOverlappedResult(FServOut->Hndler,&FRd,&FCountIn,true);	
				ResetEvent(FRd.hEvent);
				if(FCountIn == 28)Synchronize(DoReadPacket);
				else
				{
					err = GetLastError();
					if(err == ERROR_BROKEN_PIPE) ExitLoop = true;
				}
			}
		}
		else  //--------------------------------------------- не подключен, будем подключаться
		{
			if(ConnectNamedPipe(FServOut->Hndler,&FRd)) //------ если подключился к трубе удачно
			{
				ServConnected = true;				
				ServPending = false;
			}
			else
			{
				err = GetLastError();
				switch(err)
				{
					case ERROR_IO_PENDING: ServConnected = true; ExitLoop = false; break;
					case ERROR_PIPE_LISTENING: ServConnected = true; break;
					case ERROR_PIPE_CONNECTED: ServConnected = true; break;
					case ERROR_NO_DATA: ExitLoop = true; break;		
					default: ExitLoop = true;
				}	
			}

		}
		if(ExitLoop || ServBreak )
		{
			ServConnected = false;
			ServPending = false;
			ServSucces = false;
			ExitLoop = !DisconnectNamedPipe(FServOut->Hndler);
		}
	}
	ExitThread(100);
}	
/*
		switch(SostSrv) //---------------------- переключаемся по состоянию сервера
		{
			case CONNECTING_STATE:  //----------- клиент подключается, идет ожидание
				fSuccess=
				GetOverlappedResult(FServOut->Hndler,&FRd,&FCountIn,true);
				if(fSuccess)
				{
					EnterCriticalSection(&FServOut->WriteSection);
					FServOut->Sost = READING_STATE;
					LeaveCriticalSection(&FServOut->WriteSection);
				}
				ResetEvent(FRd.hEvent);
				break;
			case READING_STATE:
				fSuccess=ReadFile(FServOut->Hndler,FInBuffer,28,&FCountIn,&FRd);
				fSuccess=GetOverlappedResult(FServOut->Hndler,&FRd,&FCountIn,true);
				ResetEvent(FRd.hEvent);
				if(fSuccess && FCountIn!=0)
				{
					fPendingIO = false;
					if(FCountIn == 28)
					{
						Synchronize(DoReadPacket);
					}
				}
				else
				{
					err = GetLastError();
					if(err == ERROR_BROKEN_PIPE)break;
				}
				EnterCriticalSection(&FServOut->WriteSection);
				FServOut->Sost = WRITING_STATE;
				LeaveCriticalSection(&FServOut->WriteSection);
				break;
			case WRITING_STATE:
				fSuccess=GetOverlappedResult(FServOut->Hndler,&FWr,&FCountOut,true);
				ResetEvent(FWr.hEvent);
				if(fSuccess && FCountOut == FServOut->cbToWrite)
				{
					EnterCriticalSection(&FServOut->WriteSection);
					FServOut->Sost = READING_STATE;
					LeaveCriticalSection(&FServOut->WriteSection);
				}
        else
        {
					err = GetLastError();
          if(err == ERROR_BROKEN_PIPE)
          break;
          if(FServOut->Sost == 8888)
          break;
        }
				ResetEvent(FRd.hEvent);
				break;
			}
		}
    FServOut->Sost = 8888;
	//}
//catch(...)
//	{
//		Application->MessageBox("ОШИБКА","TrubaPotok",MB_OK);
//	}
	return;
}
//==============================================================================
*/
