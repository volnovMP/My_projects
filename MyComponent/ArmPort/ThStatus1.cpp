#include <vcl.h>
#pragma hdrstop

#include "ThStatus1.h"
#pragma package(smart_init)

//----------------------------------------------------------------------------------------
__fastcall TStatusThread1::TStatusThread1(TArmPort *ArmPort, TComEventType Events) : TThread(false)
{
	DWORD EvList[9] =
	{EV_RXCHAR, EV_RXFLAG, EV_TXEMPTY, EV_CTS, EV_DSR, EV_RLSD, EV_BREAK,	EV_ERR, EV_RING };

	FArmPort = ArmPort;
	FArmHandle = ArmPort->ComHandle;
  DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
  SetCommMask( FArmPort->ComHandle, AttrWord );
	ZeroMemory( &SOL1, sizeof(SOL1) );
  SOL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TStatusThread1::~TStatusThread1(void)
{
	CloseHandle( SOL1.hEvent );
}
//------------------------------------------------ ����� �������� �� ����� ��������� �����
//----------------------------------------------------------------------------------------
void __fastcall TStatusThread1::Execute()
{
  DWORD lpModemStatus;
	if( FArmPort->IsEnabled() )//--------------------------- ���� ���� ����� ����������� �����
	FArmPort->Status = 0;
	try
	{
		while( !Terminated )
		{
			if( !FArmPort->IsEnabled())continue; //���� � ����� ��� ������������ ������
			DWORD Status;
			//------------- �������� �������� ������������ ������� ��������� SOL �����
			bool OK = WaitCommEvent(FArmHandle, &Status, &SOL1); // � ������� ������� ����� �������
			if( !OK ) //--------------------------------------- ���� ����� ��� �������
			{
        Sleep(15);
				if( GetLastError() == ERROR_IO_PENDING ) //-------- ���� ���� � ��������
				{
					DWORD Temp;
					//------------------------- �����, �� ������ �� �������, ������� �����
					OK = GetOverlappedResult(FArmHandle, &SOL1, &Temp, TRUE );

				}
			}
			if(OK) //------------------------------------ ���� ��������� ������� �����
			{
				ResetEvent(SOL1.hEvent); //-- ���� ���������, �������� �������
				FArmPort->Status = Status; //------ �������� ������� ����� ������� �����
				//----------------------------- ���� � ����� ������� ���� ����� �������
				if((Status & EV_RXCHAR)!=0 ) SetEvent(FArmPort->rtEvent);//���������� "���� ������"
				SetEvent(FArmPort->seEvent); //--------- ���������� "���� ������� �����"
				if(FArmPort->OBuffUsed > 0) //� ������ ������ ���������� ���� ������, ��
				SetEvent(FArmPort->wtEvent);//--- ���������� �������, "����, ��� ������"
			}
		}
	}
	catch(...)
	{
		Application->MessageBox("������","ARMPortThRead",MB_OK);
	}
	return;
}

