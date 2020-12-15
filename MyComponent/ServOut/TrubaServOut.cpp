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
//------------------------------- �������� ������� ������ ��� ������������ �����
void __fastcall TTrubaServOut::Execute(void)
{
	int err, i, SostSrv;
	DWORD err1,dwWait;
	bool rc, fSuccess;
	bool tst,tst1;
	try
	{
	 //----------------------------------------------- ������� ����������� �������
	 //-------------------------------------------------- ������� ��������� ������
	 if(FServOut->Sost == 0L) //---------------------- ���� ����� ������� �������
	 {
	 //-------- ���� ������� �������� ����������� ������, �� fPending = 0 (false),
	 //-------- �� ��� ���� ���� ����������� ��������� ����� ��� ��������� �������
	 //-------------- �������� ������� ����������� �� ������������ ������, �� ����
	 //-------------- �� ��������� FRd ���� ������� �������� ����������� ��������,
	 //----------------------------------------------------- �� fPending = 1(true)
	 //---------------------- ������������ � ����������� �����, � ��������� ������
		fPendingIO = !ConnectNamedPipe(FServOut->Hndler,&FRd);
		FServOut->Sost = fPendingIO ?  CONNECTING_STATE : READING_STATE ;
	 }
	 while(!Terminated)
	 {
		SostSrv = FServOut->Sost;
		if(SostSrv == 8888)
    {
     tst = true;
     break;
    }
		switch(SostSrv) //---------------------- ������������� �� ��������� �������
		{
			case CONNECTING_STATE:  //----------- ������ ������������, ���� ��������
				fSuccess=GetOverlappedResult(FServOut->Hndler,&FRd,&FCountIn,true);
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
            ResetEvent(WaitSinch);
          	Synchronize(DoReadPacket);
            SetEvent(WaitSinch);
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
	}
	catch(...)
	{
		Application->MessageBox("������","TrubaPotok",MB_OK);
	}
	return;
}
//==============================================================================

