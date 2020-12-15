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
//---------------------------------------------------------------------------- �����������
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
//----------------------------------------------------------------------------- ����������
__fastcall TServOut::~TServOut(void)
{
  DoCloseTruba();
	FTrubaServOut->Terminate();
}
//--------------�������� �����-------------------------------------
void __fastcall TServOut::Open(void)
{
	DoOpenTruba();
}
//--------------�������� �����--------------------------------------
void __fastcall TServOut::Close(void)
{
  DoCloseTruba();
}
//--------��������� ������ �����------------------------------------
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
//-------------��������� ����� ����� ------------------------------
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
//----------------------------------------------------------- �������� ������������ ������
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
	if(FSost==9999L)//���� �� ���� ������� ������� �����
	{
		//�������� ������������ ������
		FHandle=CreateNamedPipe(name.c_str(), //----------------------- ������� ����� � ������
									PIPE_ACCESS_DUPLEX|FILE_FLAG_OVERLAPPED,//- ���������������, �����������
									PIPE_WAIT|PIPE_TYPE_BYTE, //-------- ����������� �����, ���������� �����
									1,		//------------------------------------------ ������ ���� ���������
									80,		//--------------------------------------- 80 ���� ��������� ������
									80,		//---------------------------------------- 80 ���� �������� ������
									5000,	//-------------------------------------------------- ������� 5 ���
									&sa);	//-------------------------------------------- ������� �����������
		//-------------------------------------------- ���� ����� �� ������� - �������� ������
		if((FHandle==NULL)||(FHandle==INVALID_HANDLE_VALUE))
		Err=GetLastError(); //--------------------------------------- ��������� �������� �����
	}
	if(Err==0) //----------------------------------------------------------- ���� ������ ���
	{	FSost=0L; //------------------------------------------------------- �������� ���������
		if(FTrubaServOut==NULL)//---------------------------------- ���� ����� ����� �� ������
		{
			FTrubaServOut=new TTrubaServOut(this); //---------- ������� ����� ������������ �����
			FTrubaServOut->Priority=tpNormal; //-------------------- ���������� ��������� ������
			FTrubaServOut->Resume(); //---------------- ��������� ������� ������ ��������� �����
		}
	}
}
//========================================================================================
//------------------------------------------------------ ����� ������ ������ � ����� �����
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
			if(err1!=ERROR_NO_DATA)Err_Srv=13; //----------------------------------- ��� �������
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
//----------------------------------------- �������� ������� ������ ��� ������������ �����
void __fastcall TTrubaServOut::Execute(void)
{
	int err, i;
	DWORD err1;
	bool rc, fSuccess, ExitLoop = false;
  bool tst,tst1;
  FreeOnTerminate = true;
	try
	{
	 //--------------------------------------------------------- ������� ����������� �������
	 //------------------------------------------------------------ ������� ��������� ������
		FillMemory(&FRd,sizeof(FRd),0); //------------------ �������� ��������� ������� ������
		FRd.hEvent=CreateEvent(NULL,true,true,NULL); //------------ ������� ������� ��� ������
		FillMemory(&FWr,sizeof(FWr),0); //------------------ �������� ��������� ������� ������
		FWr.hEvent=CreateEvent(NULL,true,true,NULL); //------------ ������� ������� ��� ������

		if(FOwner->FSost==0L) //----------------------------------- ���� ����� ������� �������
		{
			//--------------- ���� ������� �������� ����������� ������, �� fPending = 0 (false),
			//--------------- �� ��� ���� ���� ����������� ��������� ����� ��� ��������� �������
			//---- �������� ������� ����������� �� ������������ ������, �� ���� �� ��������� FRd
			//---------------- ���� ������� �������� ����������� ��������, �� fPending = 1(true)

			//----------------------------- ������������ � ����������� �����, � ��������� ������
			fPending = !ConnectNamedPipe(FOwner->FHandle,&FRd);

			if(fPending) err = GetLastError();  //-------------------- ����������� � ��� �������

			//------------------------------- ���� ��� ���� �� ���������� ��������, �� ���������
			if(err != ERROR_IO_PENDING)ExitLoop = true;

			//-------------- ���� ������� ����� �����������, �� ��������� ����� =  READING_STATE
			//------------------------------------------------ ���� ��������� ����� �����������,
			//----------------- �� ��������� ����� = CONNECTING_STATE ��� ���� �������� ��������
			FOwner->FSost = fPending ? CONNECTING_STATE : READING_STATE ;
		}

		while(true)
		{
      if(Terminated)break;
			if(FOwner->Sost == 9999L)  //------------------------------- ���� ������������ �����
			{
				FOwner->Sost = 8888L; //----------------------------------- ����������� ����������
				tst = CloseHandle(FRd.hEvent);
				tst1 = CloseHandle(FWr.hEvent);
				Terminate();
			}

			if(fPending)//--- ���� �� ����������� ������ - �� ����, ��������� � ��������� ������
			{
				switch(FOwner->Sost) //------------------------ ������������� �� ��������� �������
				{
					case
					CONNECTING_STATE:  //------------------------ ������ ������������, ���� ��������
						//---------------------------------------- ��������� ��������� �������� ������
						fSuccess=GetOverlappedResult(FOwner->FHandle,&FRd,&FCountIn,false);

						//-------------- ���� ������ ���������� - ��������� ��������� ����� � "������"
						if(fSuccess)FOwner->FSost = READING_STATE;

						//------------------------------------------------ ������� ������ - ����������
						err1 =	WaitForSingleObject(FRd.hEvent,INFINITE);

						err = GetLastError();  //--------------------------- ����������� � ��� �������

						FOwner->Sost = READING_STATE;
						rc=ResetEvent(FRd.hEvent);
						fPending = false;
						break; //----------------------------------- ������ ���������� ����� �� switch
				 default:
         {
          FOwner->Sost == 9999L;
         	ExitLoop = true;
         }
			 }
			} //-------------------------------------------- ����� ������ ������ ��������� �����
			else //------------------------------------------ ���� ����� �� � ��������� ��������
			{
				switch(FOwner->Sost) //------------------------ ������������� �� ��������� �������
				{
					case READING_STATE: //------------------------------- ������ �����������, ������
						//----------------------------------------------------- ������ ������ �� �����
						fSuccess = ReadFile(FOwner->FHandle,FInBuffer,28,&FCountIn,&FRd);

						//------------- ��������� ��� ���� ������ IO_PENDING -���� ���������� ��������
						//------------------------- BROKEN_PIPE - ������ ����, ���������� ������������
						//------------------------------------- ��� ��������� ������� - ���� ���������
						if(!fSuccess)
						{
									err = GetLastError();
									switch(err)
									{
											case	ERROR_IO_PENDING:   //----------- ������ ���� ��� �� ���������
												WaitForSingleObject(FRd.hEvent,INFINITE); //���� ������ ����������
												break;

											case ERROR_BROKEN_PIPE: //---------------------------- ����� �������
                        FOwner->Sost = 9999L;
                        ExitLoop = true;
												break;

											default: //-------------------------- ���-�� ������� �������� ������
												MessageDlgPos("������ ���������� �����",mtError,TMsgDlgButtons() << mbAbort, 0, 800, 800);
												break;
									}
						} //------------------------------------------ ����� ������� ���������� ������

						if(!ExitLoop)//---------------------------- ���� ������ ��������� � ����� ����
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
				}//-------------------------------------- ����� ������������� �� ��������� �������
			}//---------------------------------------------- ����� ������ ������ �������� �����
		} //---------------------------------------------------------------------- ����� while
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
