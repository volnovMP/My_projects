//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "TservOut.h"
#pragma package(smart_init)
#define CONNECTING_STATE 0
#define READING_STATE 1
#define WRITING_STATE 2
//========================================================================================
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//
static inline void ValidCtrCheck(TServOut *)
{
	new TServOut(NULL);
}
//========================================================================================
//---------------------------------------------------------------------------- конструктор
__fastcall TServOut::TServOut(TComponent* Owner)
	: TComponent(Owner)
{
	cikl_truba = false;
	FSost=9999L;
	FTrubaNumber=1;
	FHandle=NULL;
	FTrubaServOut=NULL;
}
//========================================================================================
//----------------------------------------------------------------------------- деструктор
__fastcall TServOut::~TServOut(void)
{
  DoCloseTruba();
	FTrubaServOut->Terminate();
}
//--------------открытие трубы-------------------------------------
void __fastcall TServOut::Open(void)
{
	DoOpenTruba();
}
//--------------закрытие трубы--------------------------------------
void __fastcall TServOut::Close(void)
{
  DoCloseTruba();
}
//--------установка номера трубы------------------------------------
void __fastcall TServOut::SetTrubaNumber(const int Value)
{
	if (ComponentState.Contains(csDesigning))
	{
		if(FTrubaNumber==Value)return;
		FTrubaNumber=Value;
	}
}
//----------------------------------------------------------------------------------------
void __fastcall TServOut::SetSost(unsigned int Value)
{
	FSost = Value;
}
//-------------получение имени трубы ------------------------------
AnsiString __fastcall TServOut::GetTrubaName(void)
{
  AnsiString Result,NOM_TRUB;
	Result="\\\\.\\pipe\\Truba";
	NOM_TRUB=IntToStr(FTrubaNumber);
	Result=Result+NOM_TRUB;
  return(Result);
}
//-----------------------------------------------------------------
DWORD __fastcall TServOut::ReadHandle(void)
{
	DWORD res;
	res=(DWORD)FHandle;
  return(res);
}
//========================================================================================
//----------------------------------------------------------- открытие именованного канала
void __fastcall TServOut::DoOpenTruba(void)
{
	AnsiString name;
	PSECURITY_DESCRIPTOR pSD;
	static SECURITY_ATTRIBUTES sa;
	DWORD Err=0;
	pSD=(PSECURITY_DESCRIPTOR)LocalAlloc(LPTR,SECURITY_DESCRIPTOR_MIN_LENGTH);
	if(pSD==NULL)return;
	if(InitializeSecurityDescriptor(pSD,SECURITY_DESCRIPTOR_REVISION)==false)
	{
		LocalFree((HLOCAL)pSD);
		return;
	}
	if(SetSecurityDescriptorDacl(pSD,true,NULL,false)==false)
	{
		LocalFree((HLOCAL)pSD);
		return;
	}
	sa.nLength=sizeof(sa);
	sa.lpSecurityDescriptor=pSD;
	sa.bInheritHandle=true;
	name=GetTrubaName();
	if(ComponentState.Contains(csDesigning))return;
	if(FSost==9999L)//если не было попытки создать трубу
	{
		//создание именованного канала
		FHandle=CreateNamedPipe(name.c_str(), //----------------------- создать трубу с именем
									PIPE_ACCESS_DUPLEX|FILE_FLAG_OVERLAPPED,//- двунаправленную, асинхронную
									PIPE_WAIT|PIPE_TYPE_BYTE, //-------- блокирующий режим, побайтовый поток
									1,		//------------------------------------------ только один экземпляр
									80,		//--------------------------------------- 80 байт выходного буфера
									80,		//---------------------------------------- 80 байт входного буфера
									5000,	//-------------------------------------------------- таймаут 5 сек
									&sa);	//-------------------------------------------- атрибут секретности
		//-------------------------------------------- если труба не создана - получить ошибку
		if((FHandle==NULL)||(FHandle==INVALID_HANDLE_VALUE))
		Err=GetLastError(); //--------------------------------------- результат создания трубы
	}
	if(Err==0) //----------------------------------------------------------- если ошибки нет
	{	FSost=0L; //------------------------------------------------------- обнулить состояние
		if(FTrubaServOut==NULL)//---------------------------------- если поток трубы не создан
		{
			FTrubaServOut=new TTrubaServOut(this); //---------- создать поток обслуживания трубы
			FTrubaServOut->Priority=tpNormal; //-------------------- установить приоритет потока
			FTrubaServOut->Resume(); //---------------- запустить процесс потока серверной трубы
		}
	}
}
//========================================================================================
//------------------------------------------------------ вывод данных буфера в канал трубы
void __fastcall TServOut::Tell(const char *BUF)
{
	bool res;
	DWORD err1=0;
  if(Sost == 8888) return;
	res=WriteFile(FHandle,BUF,70,&FTrubaServOut->FCountOut,&FTrubaServOut->FWr);
	if(!res)
	{
		err1=GetLastError();
		if(err1==ERROR_IO_PENDING)
		{
			WaitForSingleObject(FTrubaServOut->FWr.hEvent,INFINITE);
			ResetEvent(FTrubaServOut->FWr.hEvent);
		}
		else
			if(err1!=ERROR_NO_DATA)Err_Srv=13; //----------------------------------- нет клиента
	}
}
//========================================================================================
void __fastcall TServOut::DoCloseTruba(void)
{
	bool konec;
  int itog;
/*
  if(FTrubaServOut->FRd.hEvent ==INVALID_HANDLE_VALUE)
  {
    CloseHandle(FHandle);
	 	FHandle=INVALID_HANDLE_VALUE;
	}
  */
}
//========================================================================================
void __fastcall TTrubaServOut::DoReadPacket(void)
{
	int Razmer=28;
	int Err1;
	Err1=(int)FOwner->Err_Srv;
	if(FOwner->OnReadPacket)FOwner->OnReadPacket(FInBuffer,Razmer,Err1);
}
//========================================================================================
__fastcall TTrubaServOut::TTrubaServOut(TServOut *AOwner)
:TThread(true)
{
	FOwner=AOwner;
}
//========================================================================================
__fastcall TTrubaServOut::~TTrubaServOut(void)
{
	CloseHandle(FOwner->FHandle);
 }
//========================================================================================
//----------------------------------------- основная функция потока для обслуживания трубы
void __fastcall TTrubaServOut::Execute(void)
{
	int err, i;
	DWORD err1;
	bool rc, fSuccess, ExitLoop = false;
  bool tst,tst1;
  FreeOnTerminate = true;
	try
	{
	 //--------------------------------------------------------- ожидаем подключения клиента
	 //------------------------------------------------------------ готовим структуру чтения
		FillMemory(&FRd,sizeof(FRd),0); //------------------ очистить структуру события чтения
		FRd.hEvent=CreateEvent(NULL,true,true,NULL); //------------ создать событие для чтения
		FillMemory(&FWr,sizeof(FWr),0); //------------------ очистить структуру события записи
		FWr.hEvent=CreateEvent(NULL,true,true,NULL); //------------ создать событие для записи

		if(FOwner->FSost==0L) //----------------------------------- если труба успешно создана
		{
			//--------------- если функция ожидания подключения удачна, то fPending = 0 (false),
			//--------------- но при этом само подключение состоится позже при включении клиента
			//---- ожидание клиента выполняется по асинхронному чтению, то есть по структуре FRd
			//---------------- если функция ожидания подключения неудачна, то fPending = 1(true)

			//----------------------------- подключиться к именованной трубе, с ожиданием чтения
			fPending = !ConnectNamedPipe(FOwner->FHandle,&FRd);

			if(fPending) err = GetLastError();  //-------------------- разобраться в чем неудача

			//------------------------------- если при этом не включилось ожидание, то завершить
			if(err != ERROR_IO_PENDING)ExitLoop = true;

			//-------------- если удачный вызов подключения, то состояние трубы =  READING_STATE
			//------------------------------------------------ если неудачный вызов подключения,
			//----------------- то состояние трубы = CONNECTING_STATE при этом включено ожидание
			FOwner->FSost = fPending ? CONNECTING_STATE : READING_STATE ;
		}

		while(true)
		{
      if(Terminated)break;
			if(FOwner->Sost == 9999L)  //------------------------------- если уничтожается поток
			{
				FOwner->Sost = 8888L; //----------------------------------- уничтожение воспринято
				tst = CloseHandle(FRd.hEvent);
				tst1 = CloseHandle(FWr.hEvent);
				Terminate();
			}

			if(fPending)//--- если не подключился клиент - мы ждем, находимся в состоянии чтения
			{
				switch(FOwner->Sost) //------------------------ переключаемся по состоянию сервера
				{
					case
					CONNECTING_STATE:  //------------------------ клиент подключается, идет ожидание
						//---------------------------------------- проверяем результат ожидания чтения
						fSuccess=GetOverlappedResult(FOwner->FHandle,&FRd,&FCountIn,false);

						//-------------- если чтение состоялось - переводим состояние трубы в "читаем"
						if(fSuccess)FOwner->FSost = READING_STATE;

						//------------------------------------------------ ожидаем чтения - бесконечно
						err1 =	WaitForSingleObject(FRd.hEvent,INFINITE);

						err = GetLastError();  //--------------------------- разобраться в чем неудача

						FOwner->Sost = READING_STATE;
						rc=ResetEvent(FRd.hEvent);
						fPending = false;
						break; //----------------------------------- чтение состоялось выход из switch
				 default:
         {
          FOwner->Sost == 9999L;
         	ExitLoop = true;
         }
			 }
			} //-------------------------------------------- конец работы внутри ожидающей трубы
			else //------------------------------------------ если труба не в состоянии ожидания
			{
				switch(FOwner->Sost) //------------------------ переключаемся по состоянию сервера
				{
					case READING_STATE: //------------------------------- клиент подключился, читаем
						//----------------------------------------------------- читаем данные из трубы
						fSuccess = ReadFile(FOwner->FHandle,FInBuffer,28,&FCountIn,&FRd);

						//------------- проверяем три вида ошибки IO_PENDING -ждем завершения операции
						//------------------------- BROKEN_PIPE - клиент умер, завершение обслуживания
						//------------------------------------- при остальных ошибках - тоже завершать
						if(!fSuccess)
						{
									err = GetLastError();
									switch(err)
									{
											case	ERROR_IO_PENDING:   //----------- чтение пока еще не закончено
												WaitForSingleObject(FRd.hEvent,INFINITE); //ждем чтения бесконечно
												break;

											case ERROR_BROKEN_PIPE: //---------------------------- труба пропала
                        FOwner->Sost = 9999L;
                        ExitLoop = true;
												break;

											default: //-------------------------- что-то неясное прервало чтение
												MessageDlgPos("Ошибка серверного конца",mtError,TMsgDlgButtons() << mbAbort, 0, 800, 800);
												break;
									}
						} //------------------------------------------ конец анализа неудачного чтения

						if(!ExitLoop)//---------------------------- если чтение завершено и труба жива
						{
							fSuccess = GetOverlappedResult(FOwner->FHandle,&FRd,&FCountIn,false);
							if(fSuccess && FCountIn!=0)
							{
								fPending=false;
								if(FCountIn==28)
								{
									Synchronize(DoReadPacket);
									rc=ResetEvent(FRd.hEvent);
								}
								FOwner->cikl_truba = !FOwner->cikl_truba;
							}
							break;
					}
					default:
          {
            FOwner->Sost == 9999L;
          	ExitLoop=true;
          }
				}//-------------------------------------- конец переключателя по состоянию сервера
			}//---------------------------------------------- конец работы внутри читающей трубы
		} //---------------------------------------------------------------------- конец while
	}
  catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch(...)
	{
		FOwner->Sost=8888l;
	}
  FOwner->Sost = 8888l;
  tst1 = DisconnectNamedPipe(FOwner->FHandle);
  tst1 = ResetEvent(FRd.hEvent);
	tst1 = CloseHandle(FRd.hEvent);
  tst1 = ResetEvent(FWr.hEvent);
	tst1 = CloseHandle(FWr.hEvent);
  tst1 = CloseHandle(FOwner->FHandle);
  if(tst1)
  	FOwner->FHandle = INVALID_HANDLE_VALUE;
	return;
}
//========================================================================================
namespace Tservout
{
	void __fastcall PACKAGE Register()
	{
     TComponentClass classes[1] = {__classid(TServOut)};
		 RegisterComponents("RPCcomp", classes, 0);
  }
}
//----------------------------------------------------------------------------------------
