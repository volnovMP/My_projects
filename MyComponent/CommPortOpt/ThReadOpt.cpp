#include <vcl.h>
#pragma hdrstop

#include "ThReadOpt.h"
#pragma package(smart_init)

//========================================================================================
__fastcall TReadThreadOpt::TReadThreadOpt(TCommPortOpt *ComPortOpt) : TThread(false)
{
	FComPortOpt = ComPortOpt;
	FComHandleOpt = ComPortOpt->ComHandle;
	ZeroMemory( &ROL, sizeof(ROL) );
	ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );//----------------- � ������ �������
}

//========================================================================================
__fastcall TReadThreadOpt::~TReadThreadOpt(void)
{
	CloseHandle( ROL.hEvent );
}

//========================================================================================
//--------------------------------------------------------- �������� ������� ������ ������
void __fastcall TReadThreadOpt::Execute()
{
		bool OK;
		while( !Terminated )
		{
			//---- ���������� ���� ������� FComPort->rtEvent, ��� ���� ���� ����������� ��������
			//-------- ������������� �������� �����, ������ rtEvent ��� �������� ����� ���������
			if( WaitForSingleObject(FComPortOpt->rtEventOpt,INFINITE)!= WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- ����� ������� ��������� � ����� �����-���� �������� ����� ������
			while( true ) //--------------------------------------------------- ����������� ����
			{
				//----------------------------- �������� ������ � ������������ ��������� ���������
				ClearCommError(FComHandleOpt, &lpErrors, &lpStat );

				if(lpStat.cbInQue < FComPortOpt->PacketSize) //-- ���� � ����� ������� ���� ������
				{
					ResetEvent(FComPortOpt->rtEventOpt); //------ �������� ������� "��������� ��������"
					break;//-------------------------- �������� ���� � ��������� � �������� ��������
				}

				//-------------------------------------- ���� � ����� ���������� ���������� ������
				EnterCriticalSection( &FComPortOpt->ReadOptSection );//������ � ����������� ������
				DWORD pos1 = FComPortOpt->IBuffPos; // ���������� ������ ���������� (��� ������=0)
				DWORD used = FComPortOpt->IBuffUsed; //- ���������� ������� ���������� (������� 0)
				LeaveCriticalSection(&FComPortOpt->ReadOptSection);

				DWORD pos2 = pos1 + used; // ������� 2 = ����� ���������� = ������� 1 + ����������
				DWORD size;

				//--------------------------------------- ���� �� ����� �� ����� ���������� ������
				if(pos2 < FComPortOpt->IBuffSize) size = FComPortOpt->IBuffSize - pos2;
				else
				{
					pos2 -= FComPortOpt->IBuffSize;  //- ����� ���������� ������ �� ������ ���������
					size = pos1 - pos2;  //---------------------- �������� ���������� ����� � ������
				}

				//���� � ������ ����� ������, ��� ������� �����, �� ����� ������ ���� ������ �����
				if( size > lpStat.cbInQue)size = lpStat.cbInQue;
				//----------------------------- ����� ����� ������ �������, ������� ����� � ������

				if(size == 0)break; //---------- ���� � ������ ��������� ��������, �� ���� �������

				if (size < 0) //--- ���� ���� ������ ������������, �� �������� ���� � ���� �������
				{
					PurgeComm(FComHandleOpt,PURGE_RXCLEAR);
					EnterCriticalSection(&FComPortOpt->ReadOptSection);//������ � ����������� ������
					FComPortOpt->IBuffUsed = 0;
					FComPortOpt->IBuffPos = 0;
					LeaveCriticalSection(&FComPortOpt->ReadOptSection);
					break;
				}

				DWORD BytesReaded = 0;

				//----------------------- �������� ������� � ����� �����(�� ����� ����� ���������)
				OK = ReadFile(FComHandleOpt,&(FComPortOpt->IBuffer[pos2]),size,&BytesReaded,&ROL);

				//------------------------- ���� ������ �� ������� �� ������� �������������� �����
				if(!OK && GetLastError() == ERROR_IO_PENDING )
				{
					//---------------- ��������� �������� ������� �� ��� ���, ���� ��� �� ����������
					OK = GetOverlappedResult(FComHandleOpt, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent);//������� ��������� - ������������ "event" �������
				}

				if( OK && BytesReaded > 0 ) //------------------------------- ���� ��������� �����
				{
					EnterCriticalSection(&FComPortOpt->ReadOptSection);//������ � ����������� ������
					FComPortOpt->IBuffUsed += BytesReaded; //--- ��������� ����� ����� ���� � ������
					LeaveCriticalSection(&FComPortOpt->ReadOptSection);
          ResetEvent(ROL.hEvent);//------ ������� ��������� - ������������ "event" �������
					SetEvent(FComPortOpt->reEventOpt); //------------- ���������� "event" ����������
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

