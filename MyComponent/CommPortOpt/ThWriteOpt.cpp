#include <vcl.h>
#pragma hdrstop

#include "ThWriteOpt.h"
#pragma package(smart_init)

//========================================================================================
//----------------------------------------------------------- ������� ������ ������ � ����
__fastcall TWriteThreadOpt::TWriteThreadOpt( TCommPortOpt *ComPortOpt ) : TThread(false)
{
	FComPortOpt = ComPortOpt;
	FComHandleOpt = FComPortOpt->ComHandle;
	ZeroMemory( &WolOpt, sizeof(WolOpt) );
	WolOpt.hEvent = CreateEvent( NULL, true, true, NULL );
}

//========================================================================================
//------------------------------------------------------- ������� ���������� ������ ������
__fastcall TWriteThreadOpt::~TWriteThreadOpt(void)
{
	CloseHandle( WolOpt.hEvent );
}

//========================================================================================
//-------------------------------------------------- �������� ������� ������ ������ ������
void __fastcall TWriteThreadOpt::Execute()
{
	DWORD OutUsed;
	DWORD OK;
	bool good;
	int ErrWritten;
	while( !Terminated )
	{

		//---------------------------------------- ��������� ���� ������� "����� ����� ������"
		if( WaitForSingleObject(FComPortOpt->wtEventOpt, INFINITE) != WAIT_OBJECT_0)continue;
		FComPortOpt->GotovWrite = false;
		ResetEvent(FComPortOpt->wtEventOpt);
		//-------------------------------- ���� ���������, �� �������, ������� ������ �� �����
		EnterCriticalSection(&FComPortOpt->WriteOptSection);
		OutUsed	= FComPortOpt->OBuffUsed;
		LeaveCriticalSection(&FComPortOpt->WriteOptSection);
		//------------------ � ������ ������ ������ ���, ������� ������� ������� � ����� �����
		if(OutUsed == 0 )
		{
			FComPortOpt->GotovWrite=true;
			continue;
		}
		//- ���� ����, ��� �������� � ���������� ����������,� ����� �� ����� � �������� ������
		COMSTAT lpStat; //----------------------------- �������� ��������� ��������� COM-�����
		DWORD lpErrors;
		DWORD BytesWritten = 0; //--------------- ������� ����� ������� ���������� ���� � ����
		//----------------------------------------------------------------------- ����� � ����
		WriteFile(FComHandleOpt,&FComPortOpt->OBuffer,OutUsed,&BytesWritten,&WolOpt);
		OK = WaitForSingleObject(WolOpt.hEvent,INFINITE);
		if((OK == WAIT_OBJECT_0)&& GetOverlappedResult(FComHandleOpt,&WolOpt,&BytesWritten,true))
		{
			if(BytesWritten == OutUsed)good = true;
		}
		else
		//-- �������� ���������� � ��������� ����� � ��� �������, ������������ �������� ������
		ClearCommError( FComPortOpt->ComHandle, &lpErrors, &lpStat );

		ResetEvent(WolOpt.hEvent); //-----------------------------------------  �������� Event
		EnterCriticalSection(&FComPortOpt->WriteOptSection);
		FComPortOpt->OBuffUsed = 0;
		LeaveCriticalSection(&FComPortOpt->WriteOptSection);
		FComPortOpt->GotovWrite = true;
	}
	return;
}

//---------------------------------------------------------------------------

