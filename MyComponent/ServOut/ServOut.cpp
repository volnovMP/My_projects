//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "ServOut.h"
#pragma package(smart_init)
//========================================================================================
//---------------- ValidCtrCheck is used to assure that the components created do not have
//------------------------------------------------------------ any pure virtual functions.
static inline void ValidCtrCheck(TServOut *)
{
	new TServOut(NULL);
}
//----------------------------------------------------------------------------------------
//---------------------------------------------------------------------------- �����������
__fastcall TServOut::TServOut(TComponent* Owner):TComponent(Owner)
{
  FSost = 9999L;
}
//========================================================================================
//----------------------------------------------------------------------------- ����������
__fastcall TServOut::~TServOut(void)
{
	if(ComponentState.Contains(csDesigning))return;
	//Close();
	//CloseHandle(FTrubaServOut->FWr.hEvent);
	//CloseHandle(FTrubaServOut->FRd.hEvent);
  DeleteCriticalSection(&WriteSection);
}
//--------------�������� �����-------------------------------------
void __fastcall TServOut::Open(void)
{
	DoOpenTruba();
}
//========================================================================================
//----------------------------------------------------------- �������� ������������ ������
void __fastcall TServOut::DoOpenTruba(void)
{
	LPSTR name;
	PSECURITY_DESCRIPTOR pSD;
	static SECURITY_ATTRIBUTES sa;
	HANDLE hEvent;
	DWORD Err=0;
	char NomTrb[2];
	if(ComponentState.Contains(csDesigning))return;
	InitializeCriticalSection(&WriteSection);
	FHandle = INVALID_HANDLE_VALUE;
	itoa(FTrubaNumber,NomTrb,10);
	FTrubaName = TEXT("\\\\.\\pipe\\Truba");
	strcat(FTrubaName,NomTrb);
	cikl_truba = false;
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
	name = TrubaName;
	if(ComponentState.Contains(csDesigning))return;
	if(FSost==9999L)//���� �� ���� ������� ������� �����
	{
		//�������� ������������ ������
		FHandle=CreateNamedPipe(name, //--------------------- ������� ����� � ������
									PIPE_ACCESS_DUPLEX|FILE_FLAG_OVERLAPPED,//- ���������������, �����������
									PIPE_WAIT|PIPE_TYPE_BYTE, // ����������� �����, ���������� �����
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
		FTrubaServOut=new TTrubaServOut(this); //------------ ������� ����� ������������ �����
		FTrubaServOut->Name = "ServOutTruba";
		hEvent = CreateEvent(NULL,FALSE,FALSE,NULL);
		FTrubaServOut->FRd.hEvent = hEvent;
		ResetEvent(FTrubaServOut->FRd.hEvent);
		hEvent = CreateEvent(NULL,FALSE,FALSE,NULL);
		FTrubaServOut->FWr.hEvent = hEvent;
		ResetEvent(FTrubaServOut->FWr.hEvent);
	}
}
//--------------�������� �����--------------------------------------
void __fastcall TServOut::Close(void)
{
  DoCloseTruba();
}
//========================================================================================
void __fastcall TServOut::DoCloseTruba(void)
{
	bool konec;
  int itog;
  if(ComponentState.Contains(csDesigning))return;
	FTrubaServOut->ServBreak = true;
	SetEvent(FTrubaServOut->FRd.hEvent);
	SetEvent(FTrubaServOut->FWr.hEvent);
	FTrubaServOut->WaitFor();
	delete FTrubaServOut;
  DisconnectNamedPipe(Hndler);
  CloseHandle(Hndler);
  Sost = 7777;
}
//--------��������� ������ �����------------------------------------
void __fastcall TServOut::SetTrubaNumber(int n)
{
		FTrubaNumber = n;
}
//----------------------------------------------------------------------------------------
void __fastcall TServOut::SetSost(unsigned int Value)
{
	EnterCriticalSection(&WriteSection);
	FSost = Value;
	LeaveCriticalSection(&WriteSection);
}
//----------------------------------------------------
unsigned int __fastcall TServOut::GetSost(void)
{
	unsigned int Result;
	EnterCriticalSection(&WriteSection);
	Result = FSost;
	LeaveCriticalSection(&WriteSection);
	return(Result);
}
//========================================================================================
//------------------------------------------------------ ����� ������ ������ � ����� �����
void __fastcall TServOut::Tell(const char *BUF, int size)
{
	int i;
	if(FHandle)
	{
		ResetEvent(FTrubaServOut->FWr.hEvent);
		WriteFile(FHandle,BUF,size,&FTrubaServOut->FCountOut,&FTrubaServOut->FWr);
	}
}
//========================================================================================
HANDLE __fastcall TServOut::ReadHandle(void)
{
	HANDLE Result;
	Result = FHandle;
  return(Result);
}

//========================================================================================
namespace Servout
{
	void __fastcall PACKAGE Register()
	{
		 TComponentClass classes[1] = {__classid(TServOut)};
		 RegisterComponents("RPCcomp", classes, 0);
  }
}
