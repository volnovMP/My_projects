#include <vcl.h>
#pragma hdrstop

#include "ThWrite.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TWriteThread::TWriteThread( TCommPort *ComPort ) : TThread(false)
{
  FComPort = ComPort;
  FComHandle = FComPort->ComHandle;
  ZeroMemory( &WOL, sizeof(WOL) );
  WOL.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TWriteThread::~TWriteThread(void)
{
  CloseHandle( WOL.hEvent );
}

//----------------------------------------------------------------------------------------
//-------------------------------------------------- �������� ������� ������ ������ ������
void __fastcall TWriteThread::Execute()
{
  DWORD OutUsed;
	while( !Terminated )
	{
			//---------------------------------------- ��������� ���� ������� "����� ����� ������"
			if( WaitForSingleObject(FComPort->wtEvent, INFINITE) != WAIT_OBJECT_0)continue;
			//---- ���������, �� � ������ ������ ������ ���, ������� ������� ������� � ����� �����
			EnterCriticalSection( &FComPort->WriteSection );
      OutUsed	= FComPort->OBuffUsed;
	    LeaveCriticalSection( &FComPort->WriteSection );
			if(OutUsed == 0 )
      {
      	ResetEvent(FComPort->wtEvent);
        continue;
      }
			//���� ����, ��� �������� � ���������� ����������, �� ����� �� ����� � �������� ������
			COMSTAT lpStat; //----------------------------- �������� ��������� ��������� COM-�����
			DWORD lpErrors;

			//-- �������� ���������� � ��������� ����� � ��� �������, ������������ �������� ������
			ClearCommError( FComPort->ComHandle, &lpErrors, &lpStat );

			while(OutUsed) //-- ���� � ������ �������� ���-�� �� ������������ � ����
			{
				EnterCriticalSection( &FComPort->WriteSection );
				DWORD pos1 = FComPort->OBuffPos;//�������� ��������� �� ������ ������������� �������
				DWORD used = FComPort->OBuffUsed; //---------- �������� ������ ������������� �������
        OutUsed = used;
				LeaveCriticalSection( &FComPort->WriteSection );

				DWORD pos2 = pos1 + used; //---- ���������� ��������� �� ����� ������������� �������
				DWORD size;
				if( pos2 < FComPort->OBuffSize ) //- ���� ����� ������� �� ������� �� ������� ������
				{
					size = pos2 - pos1; //------------------------- ������ ������� ��� �������� � ����
				}
				else //------- ����� ������� �� ��������� ������, ����� �������� ������ ������ �����
				{
					pos2 -= FComPort->OBuffSize; //---------- ��������� �� ������ ������ ����� �������
					size = FComPort->OBuffSize - pos1; //----------------- ������ ������ ����� �������
				}
				DWORD BytesWritten = 0; //------------- ������� ����� ������� ���������� ���� � ����

				//------------------------ ����� � ���� ������ ��� ������������ ����� ������� ������
				bool OK = WriteFile( FComHandle,&(FComPort->OBuffer[pos1]),size,&BytesWritten,&WOL);
				if( !OK && GetLastError() == ERROR_IO_PENDING)//--- ���� ���� ��� �� �������� ������
				{
					//--------------------------------------------- ����� ���� ���� �� �������� ������
					OK = GetOverlappedResult(FComHandle,&WOL,&BytesWritten,TRUE);
					if(OK)ResetEvent(WOL.hEvent); //-------- ���� ������ ������ ������, �������� Event
				}
				if(OK) //------------------------------ ���� ������ ��������� �������� ������ � ����
				{
					EnterCriticalSection( &FComPort->WriteSection );
					FComPort->OBuffUsed -= BytesWritten; //- ����� ���� � ������, �� ���������� � ����
					FComPort->OBuffPos += BytesWritten; //----- ��������� ����� ������� ������ �������
					//---------------- ���� ������� �� ��������� ������, �� ����������� �� "�� ������"
					if(FComPort->OBuffPos >= FComPort->OBuffSize)
					FComPort->OBuffPos -= FComPort->OBuffSize;
          OutUsed	= FComPort->OBuffUsed;
					LeaveCriticalSection( &FComPort->WriteSection );
				}
			}
		}

	return;
}

//---------------------------------------------------------------------------

