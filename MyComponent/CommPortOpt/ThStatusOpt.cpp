#include <vcl.h>
#pragma hdrstop

#include "ThStatusOpt.h"
#pragma package(smart_init)

//========================================================================================
//--------------------------------------------------------------------- ����������� ������
__fastcall TStatusThreadOpt::TStatusThreadOpt(TCommPortOpt *ComPortOpt,TComEventType Events)
: TThread(false)
{
	//----------------------- ������������ ������ �� ��������� ���� ������ ��� WaitCommEvent
	DWORD EvList[9] =
	{EV_RXCHAR,EV_RXFLAG,EV_TXEMPTY,EV_CTS,EV_DSR,EV_RLSD,EV_BREAK,EV_ERR,EV_RING };

	FComPortOpt = ComPortOpt;
	FComHandle = ComPortOpt->ComHandle;
	DWORD AttrWord = 0;

	for( int i=0; i < 9; i++ )
	{
		TEventState EvIndex = (TEventState)i;
		if( Events.Contains(EvIndex) )  AttrWord |= EvList[i];
	}
	SetCommMask( FComPortOpt->ComHandle, AttrWord );
	ZeroMemory( &SOL, sizeof(SOL) );
	SOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); //-------------------- ������ �����
}

//========================================================================================
__fastcall TStatusThreadOpt::~TStatusThreadOpt(void)
{
	CloseHandle( SOL.hEvent );
}
//========================================================================================
//------------------------------------------------ ����� �������� �� ����� ��������� �����
void __fastcall TStatusThreadOpt::Execute()
{
	DWORD lpModemStatus;
	if( FComPortOpt->IsEnabled() &&  //----------------- ���� ���� ����� ����������� ����� �
	GetCommModemStatus( FComHandle,&lpModemStatus)) //������� ������ �������� ������ �������
	{
		FComPortOpt->FCTS  = (lpModemStatus & MS_CTS_ON); //---- ��������� ��������� ����� CTS
		FComPortOpt->FDSR  = (lpModemStatus & MS_DSR_ON); //---- ��������� ��������� ����� DSR
		FComPortOpt->FDCD  = (lpModemStatus & MS_RLSD_ON);//--- ��������� ��������� ����� RLSD
		FComPortOpt->FRing = (lpModemStatus & MS_RING_ON); //-- ��������� ��������� ����� RING
		FComPortOpt->Status = 0;
	}
	while( !Terminated )
	{
		if( !FComPortOpt->IsEnabled())continue; //- ���� ��� ������������ ������, �� ���������
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
			FComPortOpt->Status = Status; //--------------- �������� ������� ����� ������� �����
			if( (Status & (EV_CTS | //--------------------------------- ���� ���� CTS-������ ���
			EV_DSR |   //--------------------------------------------------- ���� DSR-������ ���
			EV_RING | //--------------------------------------------------- ���� RING-������ ���
			EV_RLSD | //--------------------------------------------------- ���� RLSD-������ ���
			EV_ERR))!= 0 && //---------------------------- ���� ������ ������� ����� � ���  ����
			GetCommModemStatus(FComHandle, &lpModemStatus) ) //- ������� �������� ������� ������
			{
				//------------------------------- �� ���������� ���������� �������� �������� �����
				FComPortOpt->FCTS = (lpModemStatus & MS_CTS_ON); //------------------------ 0x0010
				FComPortOpt->FDSR = (lpModemStatus & MS_DSR_ON); //------------------------ 0x0020
				FComPortOpt->FDCD = (lpModemStatus & MS_RLSD_ON); //----------------------- 0x0080
				FComPortOpt->FRing = (lpModemStatus & MS_RING_ON); //---------------------- 0x0040
/*				if( FComPortOpt->Control == ccHard && //-------- ���� ���� ����������� ��������� �
				FComPortOpt->FCTS && // CTS == true (����� ������ ������) ����� ����� ���������� �
				FComPortOpt->OBuffUsed > 0) //--------- � ������ ������ ���������� ���� ������, ��
				SetEvent(FComPortOpt->wtEventOpt);//------- ���������� �������, "����, ��� ������"
*/
			}
			//------------------------------------------ ���� � ����� ������� ���� ����� �������
			if((Status & EV_RXCHAR)!=0)
			SetEvent(FComPortOpt->rtEventOpt);//----------------------- ���������� "���� ������"
			SetEvent(FComPortOpt->seEventOpt); //--------------- ���������� "���� ������� �����"
		}
	}
	return;
}
