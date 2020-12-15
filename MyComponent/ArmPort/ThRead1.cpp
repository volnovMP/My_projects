#include <vcl.h>
#pragma hdrstop

#include "ThRead1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TArmReadThread::TArmReadThread(TArmPort *ArmPort) : TThread(false)
{
	FArmPort = ArmPort;
	FArmHandle = ArmPort->ComHandle;
	ZeroMemory( &ROL1, sizeof(ROL1) );
  ROL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TArmReadThread::~TArmReadThread(void)
{
	CloseHandle( ROL1.hEvent );
}

//----------------------------------------------------------------------------------------
//--------------------------------------------------------- �������� ������� ������ ������
void __fastcall TArmReadThread::Execute()
{
	try
	{
		while( !Terminated )
		{
			//---- ���������� ���� ������� FComPort->rtEvent, ��� ���� ���� ����������� ��������
			//--------- ������������ �������� �����, ������ rtEvent ��� �������� ����� ���������
			if( WaitForSingleObject(FArmPort->rtEvent, INFINITE) != WAIT_OBJECT_0 )continue;
			COMSTAT lpStat;
			DWORD lpErrors;
			//----------------- ����� ������� ��������� � ����� �����-���� �������� ����� ������
			while( true ) //----------------------------------------------------- ����������� ����
			{
				ClearCommError( FArmHandle, &lpErrors, &lpStat );//- ����� ������ � ������ ���������
				if(lpStat.cbInQue < FArmPort->PacketSize)
        {
          ResetEvent(FArmPort->rtEvent);
        	break;
        }

				EnterCriticalSection( &FArmPort->ReadSection ); //---- ������ � ����������� ������
				DWORD pos1 = FArmPort->IBuffPos; //------ ���������� ������� 1 ( ���������� ��� 0)
				DWORD used = FArmPort->IBuffUsed;//���������� ����������� ����� (���������� ��� 0)
				LeaveCriticalSection(&FArmPort->ReadSection);

				DWORD pos2 = pos1 + used; //-------- ������� 2 = ������� 1 + �����������
				DWORD size;

				//----------------------------- ���� �� ����� �� ����� ���������� ������
				if(pos2 < FArmPort->IBuffSize) size = FArmPort->IBuffSize - pos2;
				else
				{
					pos2 -= FArmPort->IBuffSize;
					size = pos1 - pos2;
				}

				if( size > lpStat.cbInQue ) size = lpStat.cbInQue;//-- ������ ������ ������� �����
				if( size == 0 )  break; //------------------------- ���� ����� ����������, �������
				DWORD BytesReaded = 0;

				//---------------------- �������� �������� � ����� �����(�� ����� ����� ���������)
				bool OK = ReadFile(FArmHandle,&(FArmPort->IBuffer[pos2]),size,&BytesReaded,&ROL1);

				//------------------------- ���� ������ �� ������� �� ������� �������������� �����
				if( !OK && GetLastError() == ERROR_IO_PENDING )
				{
					//------ ��������� �������� ������� �� ��� ���, ���� ��� �� ����������
					OK = GetOverlappedResult(FArmHandle, &ROL1, &BytesReaded, TRUE);
					if(OK) ResetEvent(ROL1.hEvent); //------ �� ������� ������������ "event" �������
				}

				if( OK && BytesReaded > 0 ) //------------------------------- ���� ��������� �����
				{
					EnterCriticalSection( &FArmPort->ReadSection ); //-- ������ � ����������� ������
          FArmPort->IBuffUsed += BytesReaded; //------ ��������� ����� ����� ���� � ������
					LeaveCriticalSection(&FArmPort->ReadSection);
					SetEvent(FArmPort->reEvent); //------------------- ���������� "event" ����������
				}
			}
		}
	}
	catch(...)
	{
		Application->MessageBox("������","ARMPortTHRead",MB_OK);
	}
	return;
}
//----------------------------------------------------------------------------------------

