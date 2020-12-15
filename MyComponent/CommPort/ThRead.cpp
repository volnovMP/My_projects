#include <vcl.h>
#pragma hdrstop
#include "ThRead.h"

#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TReadThread::TReadThread(TCommPort *ComPort) : TThread(false)
{
  FComPort = ComPort;
  FComHandle = ComPort->ComHandle;
  ZeroMemory( &ROL, sizeof(ROL) );
  ROL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TReadThread::~TReadThread(void)
{
  CloseHandle( ROL.hEvent );
}

//----------------------------------------------------------------------------------------
//--------------------------------------------------------- �������� ������� ������ ������
void __fastcall TReadThread::Execute()
{

		while( !Terminated )
		{
			// ���������� ���� ������� FComPort->rtEvent, ��� ���� ���� ����������� ��������
			//������������ �������� �����, ������ rtEvent ��� �������� ����� ���������
			if( WaitForSingleObject(FComPort->rtEvent, INFINITE) != WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//------- ����� ������� ��������� � ����� �����-���� �������� ����� ������
			while( true ) //----------------------------------------- ����������� ����
			{
				ClearCommError( FComHandle, &lpErrors, &lpStat );//- ����� ������ � ������ ���������
				if(lpStat.cbInQue < FComPort->PacketSize)
        {
        	ResetEvent(FComPort->rtEvent);
        	break;
        }

				EnterCriticalSection( &FComPort->ReadSection ); //---- ������ � ����������� ������
				DWORD pos1 = FComPort->IBuffPos; //------ ���������� ������� 1 ( ���������� ��� 0)
				DWORD used = FComPort->IBuffUsed;//���������� ����������� ����� (���������� ��� 0)
				LeaveCriticalSection(&FComPort->ReadSection);

				DWORD pos2 = pos1 + used; //-------- ������� 2 = ������� 1 + �����������
				DWORD size;

				//------------------------------ ���� �� ����� �� ����� ���������� ������
				if(pos2 < FComPort->IBuffSize) size = FComPort->IBuffSize - pos2;
				else
				{
					pos2 -= FComPort->IBuffSize;
					size = pos1 - pos2;
				}

				if( size > lpStat.cbInQue ) size = lpStat.cbInQue;//���� ������ ������ ������� �����
				if( size == 0 )  break; //--------------------------- ���� ����� ����������, �������
				DWORD BytesReaded = 0;

				//---------- �������� �������� � ����� �����(�� ����� ����� ���������)
				bool OK = ReadFile( FComHandle, &(FComPort->IBuffer[pos2]), size, &BytesReaded, &ROL);

				//--------------- ���� ������ �� ������� �� ������� �������������� �����
				if( !OK && GetLastError() == ERROR_IO_PENDING )
				{
					//------ ��������� �������� ������� �� ��� ���, ���� ��� �� ����������
					OK = GetOverlappedResult(FComHandle, &ROL, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL.hEvent); //�� ��������� ������� ������������ "event" �������
				}

				if( OK && BytesReaded > 0 ) //------------------------------- ���� ��������� �����
				{
					EnterCriticalSection(&FComPort->ReadSection ); //--- ������ � ����������� ������
					FComPort->IBuffUsed += BytesReaded; //------ ��������� ����� ����� ���� � ������
   				LeaveCriticalSection(&FComPort->ReadSection);
					SetEvent(FComPort->reEvent); //------------------- ���������� "event" ����������
				}
			}
		}
	return;
	}
//----------------------------------------------------------------------------------------

