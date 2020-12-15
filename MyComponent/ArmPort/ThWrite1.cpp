#include <vcl.h>
#pragma hdrstop

#include "ThWrite1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TWriteThread1::TWriteThread1( TArmPort *ArmPort ) : TThread(false)
{
	FArmPort = ArmPort;
	FArmHandle = FArmPort->ComHandle;
	ZeroMemory( &WOL1, sizeof(WOL1) );
	WOL1.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL );
}

//---------------------------------------------------------------------------
__fastcall TWriteThread1::~TWriteThread1(void)
{
	CloseHandle( WOL1.hEvent );
}

//----------------------------------------------------------------------------------------
//-------------------------------------------------- �������� ������� ������ ������ ������
void __fastcall TWriteThread1::Execute()
{
  DWORD OutUsed;
	try
	{
		while( !Terminated )
		{
			//---------------------------------------- ��������� ���� ������� "����� ����� ������"
			if( WaitForSingleObject(FArmPort->wtEvent, INFINITE) != WAIT_OBJECT_0)continue;
			//---- ���������, �� � ������ ������ ������ ���, ������� ������� ������� � ����� �����
			EnterCriticalSection( &FArmPort->WriteSection );
      OutUsed	= FArmPort->OBuffUsed;
	    LeaveCriticalSection( &FArmPort->WriteSection );
			if(OutUsed == 0 )
      {
      	ResetEvent(FArmPort->wtEvent);
        continue;
      }
			//���� ����, ��� �������� � ���������� ����������, �� ����� �� ����� � �������� ������
			COMSTAT lpStat; //----------------------------- �������� ��������� ��������� COM-�����
			DWORD lpErrors;

			//-- �������� ���������� � ��������� ����� � ��� �������, ������������ �������� ������
			ClearCommError( FArmPort->ComHandle, &lpErrors, &lpStat );

			while(OutUsed) //-- ���� � ������ �������� ���-�� �� ������������ � ����
			{
				EnterCriticalSection( &FArmPort->WriteSection );
				DWORD pos1 = FArmPort->OBuffPos;//�������� ��������� �� ������ ������������� �������
				DWORD used = FArmPort->OBuffUsed; //---------- �������� ������ ������������� �������
        OutUsed = used;
				LeaveCriticalSection( &FArmPort->WriteSection );

				DWORD pos2 = pos1 + used; //---- ���������� ��������� �� ����� ������������� �������
				DWORD size;
				if( pos2 < FArmPort->OBuffSize ) //- ���� ����� ������� �� ������� �� ������� ������
				{
					size = pos2 - pos1; //------------------------- ������ ������� ��� �������� � ����
				}
				else //------- ����� ������� �� ��������� ������, ����� �������� ������ ������ �����
				{
					pos2 -= FArmPort->OBuffSize; //---------- ��������� �� ������ ������ ����� �������
					size = FArmPort->OBuffSize - pos1; //----------------- ������ ������ ����� �������
				}
				DWORD BytesWritten = 0; //------------- ������� ����� ������� ���������� ���� � ����

				//------------------------ ����� � ���� ������ ��� ������������ ����� ������� ������
				bool OK = WriteFile( FArmHandle,&(FArmPort->OBuffer[pos1]),size,&BytesWritten,&WOL1);
				if( !OK && GetLastError() == ERROR_IO_PENDING)//--- ���� ���� ��� �� �������� ������
				{
					//--------------------------------------------- ����� ���� ���� �� �������� ������
					OK = GetOverlappedResult(FArmHandle,&WOL1,&BytesWritten,TRUE);
					if(OK)ResetEvent(WOL1.hEvent); //-------- ���� ������ ������ ������, �������� Event
				}
				if(OK) //------------------------------ ���� ������ ��������� �������� ������ � ����
				{
					EnterCriticalSection( &FArmPort->WriteSection );
					FArmPort->OBuffUsed -= BytesWritten; //- ����� ���� � ������, �� ���������� � ����
					FArmPort->OBuffPos += BytesWritten; //----- ��������� ����� ������� ������ �������
					//---------------- ���� ������� �� ��������� ������, �� ����������� �� "�� ������"
					if(FArmPort->OBuffPos >= FArmPort->OBuffSize)
					FArmPort->OBuffPos -= FArmPort->OBuffSize;
          OutUsed	= FArmPort->OBuffUsed;
					LeaveCriticalSection( &FArmPort->WriteSection );
				}
			}
		}
	}
		catch (...)
	{
		Application->MessageBox("������","COMPortThWrite",MB_OK);
	}
	return;
}
//----------------------------------------------------------------------------------------

