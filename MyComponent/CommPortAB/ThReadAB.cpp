#include <vcl.h>
#pragma hdrstop

#include "ThReadAB.h"
#pragma package(smart_init)

//========================================================================================
__fastcall TReadThreadAB::TReadThreadAB(TCommPortAB *ComPortAB) : TThread(false)
{
	FComPortAB = ComPortAB;
	FComHandleAB = ComPortAB->ComHandle;
	ZeroMemory( &ROL, sizeof(ROL) );
	ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );//----------------- � ������ �������
}

//========================================================================================
__fastcall TReadThreadAB::~TReadThreadAB(void)
{
	CloseHandle( ROL.hEvent );
}

//========================================================================================
//--------------------------------------------------------- �������� ������� ������ ������
void __fastcall TReadThreadAB::Execute()
{
		bool OK;
		while( !Terminated )
		{
			//---- ���������� ���� ������� FComPort->rtEvent, ��� ���� ���� ����������� ��������
			//-------- ������������� �������� �����, ������ rtEvent ��� �������� ����� ���������
			if( WaitForSingleObject(FComPortAB->rtEventAB,INFINITE)!= WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- ����� ������� ��������� � ����� �����-���� �������� ����� ������
			while( true ) //--------------------------------------------------- ����������� ����
			{
				//----------------------------- �������� ������ � ������������ ��������� ���������
				ClearCommError(FComHandleAB, &lpErrors, &lpStat );

				if(lpStat.cbInQue < FComPortAB->PacketSize) //-- ���� � ����� ������� ���� ������
				{
					ResetEvent(FComPortAB->rtEventAB); //------ �������� ������� "��������� ��������"
					break;//-------------------------- �������� ���� � ��������� � �������� ��������
				}

				//-------------------------------------- ���� � ����� ���������� ���������� ������
				EnterCriticalSection( &FComPortAB->ReadABSection );//������ � ����������� ������
				DWORD pos1 = FComPortAB->IBuffPos; // ���������� ������ ���������� (��� ������=0)
				DWORD used = FComPortAB->IBuffUsed; //- ���������� ������� ���������� (������� 0)
				LeaveCriticalSection(&FComPortAB->ReadABSection);

				DWORD pos2 = pos1 + used; // ������� 2 = ����� ���������� = ������� 1 + ����������
				DWORD size;

				//--------------------------------------- ���� �� ����� �� ����� ���������� ������
				if(pos2 < FComPortAB->IBuffSize) size = FComPortAB->IBuffSize - pos2;
				else
				{
					pos2 -= FComPortAB->IBuffSize;  //- ����� ���������� ������ �� ������ ���������
					size = pos1 - pos2;  //---------------------- �������� ���������� ����� � ������
				}

				//���� � ������ ����� ������, ��� ������� �����, �� ����� ������ ���� ������ �����
				if( size > lpStat.cbInQue)size = lpStat.cbInQue;
				//----------------------------- ����� ����� ������ �������, ������� ����� � ������

				if(size == 0)break; //---------- ���� � ������ ��������� ��������, �� ���� �������

				if (size < 0) //--- ���� ���� ������ ������������, �� �������� ���� � ���� �������
				{
					PurgeComm(FComHandleAB,PURGE_RXCLEAR);
					EnterCriticalSection(&FComPortAB->ReadABSection);//������ � ����������� ������
					FComPortAB->IBuffUsed = 0;
					FComPortAB->IBuffPos = 0;
					LeaveCriticalSection(&FComPortAB->ReadABSection);
					break;
				}

				DWORD BytesReaded = 0;

				//----------------------- �������� ������� � ����� �����(�� ����� ����� ���������)
				OK = ReadFile(FComHandleAB,&(FComPortAB->IBuffer[pos2]),size,&BytesReaded,&ROL);

				//------------------------- ���� ������ �� ������� �� ������� �������������� �����
				if(!OK && GetLastError() == ERROR_IO_PENDING )
				{
					//---------------- ��������� �������� ������� �� ��� ���, ���� ��� �� ����������
					OK = GetOverlappedResult(FComHandleAB, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent);//������� ��������� - ������������ "event" �������
				}

				if( OK && BytesReaded > 0 ) //------------------------------- ���� ��������� �����
				{
					EnterCriticalSection(&FComPortAB->ReadABSection);//������ � ����������� ������
					FComPortAB->IBuffUsed += BytesReaded; //--- ��������� ����� ����� ���� � ������
					LeaveCriticalSection(&FComPortAB->ReadABSection);
          ResetEvent(ROL.hEvent);//------ ������� ��������� - ������������ "event" �������
					SetEvent(FComPortAB->reEventAB); //------------- ���������� "event" ����������
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

