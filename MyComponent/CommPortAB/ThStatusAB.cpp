#include <vcl.h>
#pragma hdrstop

#include "ThStatusAB.h"
#pragma package(smart_init)

//========================================================================================
//--------------------------------------------------------------------- ����������� ������
__fastcall TStatusThreadAB::TStatusThreadAB(TCommPortAB *ComPortAB,TComEventType Events)
: TThread(false)
{
	//----------------------- ������������ ������ �� ��������� ���� ������ ��� WaitCommEvent
	DWORD EvList[9] =
	{EV_RXCHAR,EV_RXFLAG,EV_TXEMPTY,EV_CTS,EV_DSR,EV_RLSD,EV_BREAK,EV_ERR,EV_RING };

	FComPortAB = ComPortAB;
	FComHandle = ComPortAB->ComHandle;
	DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
	SetCommMask( FComPortAB->ComHandle, AttrWord );
	ZeroMemory( &SOL, sizeof(SOL) );
	SOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); //-------------------- ������ �����
}

//========================================================================================
__fastcall TStatusThreadAB::~TStatusThreadAB(void)
{
	CloseHandle( SOL.hEvent );
}
//========================================================================================
//------------------------------------------------ ����� �������� �� ����� ��������� �����
void __fastcall TStatusThreadAB::Execute()
{
	DWORD lpModemStatus;
	if( FComPortAB->IsEnabled() &&  //----------------- ���� ���� ����� ����������� ����� �
	GetCommModemStatus( FComHandle,&lpModemStatus)) //������� ������ �������� ������ �������
	{
		FComPortAB->FCTS  = (lpModemStatus & MS_CTS_ON); //---- ��������� ��������� ����� CTS
		FComPortAB->FDSR  = (lpModemStatus & MS_DSR_ON); //---- ��������� ��������� ����� DSR
		FComPortAB->FDCD  = (lpModemStatus & MS_RLSD_ON);//--- ��������� ��������� ����� RLSD
		FComPortAB->FRing = (lpModemStatus & MS_RING_ON); //-- ��������� ��������� ����� RING
		FComPortAB->Status = 0;
	}
	while( !Terminated )
	{
		if( !FComPortAB->IsEnabled())continue; //- ���� ��� ������������ ������, �� ���������
		DWORD Status;
		//-------------- �������� ������� �� �������� ������������ ������� ��������� SOL �����
		bool OK = WaitCommEvent(FComHandle, &Status, &SOL); // � ������� ������� ����� �������

		if( !OK ) //--------------------------------------------- ���� ��������� ����� �������
		{
			Sleep(50); //---------------------------------------------------------- ���� 50 ����
			if( GetLastError() == ERROR_IO_PENDING ) //-------------------- ���� ���� � ��������
			{
				DWORD Temp;
				//------------------------------------- �����, �� ������ �� �������, ������� �����
				OK = GetOverlappedResult(FComHandle, &SOL, &Temp, TRUE );//-- TRUE = ����� "�����"
			}
		}

		if(OK) //------------------------------------------------ ���� ��������� ������� �����
		{
			ResetEvent(SOL.hEvent); //----------------- ���������, ������ ����� �������� �������
			FComPortAB->Status = Status; //--------------- �������� ������� ����� ������� �����
			if( (Status & (EV_CTS | //--------------------------------- ���� ���� CTS-������ ���
			EV_DSR |   //--------------------------------------------------- ���� DSR-������ ���
			EV_RING | //--------------------------------------------------- ���� RING-������ ���
			EV_RLSD | //--------------------------------------------------- ���� RLSD-������ ���
			EV_ERR))!= 0 && //---------------------------- ���� ������ ������� ����� � ���  ����
			GetCommModemStatus(FComHandle, &lpModemStatus) ) //- ������� �������� ������� ������
			{
				//------------------------------- �� ���������� ���������� �������� �������� �����
				FComPortAB->FCTS = (lpModemStatus & MS_CTS_ON); //------------------------ 0x0010
				FComPortAB->FDSR = (lpModemStatus & MS_DSR_ON); //------------------------ 0x0020
				FComPortAB->FDCD = (lpModemStatus & MS_RLSD_ON); //----------------------- 0x0080
				FComPortAB->FRing = (lpModemStatus & MS_RING_ON); //---------------------- 0x0040
/*				if( FComPortAB->Control == ccHard && //-------- ���� ���� ����������� ��������� �
				FComPortAB->FCTS && // CTS == true (����� ������ ������) ����� ����� ���������� �
				FComPortAB->OBuffUsed > 0) //--------- � ������ ������ ���������� ���� ������, ��
				SetEvent(FComPortAB->wtEventAB);//------- ���������� �������, "����, ��� ������"
*/
			}
			//------------------------------------------ ���� � ����� ������� ���� ����� �������
			if((Status & EV_RXCHAR)!=0)
			SetEvent(FComPortAB->rtEventAB);//----------------------- ���������� "���� ������"
			SetEvent(FComPortAB->seEventAB); //--------------- ���������� "���� ������� �����"
		}
	}
	return;
}
