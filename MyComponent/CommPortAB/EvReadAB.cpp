#include <vcl.h>
#pragma hdrstop
#include "EvReadAB.h"
#include "CRC.h"
#pragma package(smart_init)
//========================================================================================//---------------------------------------------------------------------------
__fastcall TReadEventThreadAB::TReadEventThreadAB(TCommPortAB *ComPortAB) : TThread(false)
{
	FComPortAB = ComPortAB;
}
//========================================================================================
//------------------------- ��������� ������������ �������� ������ ����������������� �����
void __fastcall TReadEventThreadAB::Execute()
{
	int i,k,podt_com,size;
	unsigned char test_sum;
	bool it_is_kvit,it_is_soob;
	unsigned char BufBuf[80]; //--------------------------------- ������������� ����� ������
	unsigned char BufAll[80];
	DWORD NomerStan;
	int Hvost; //----------- ------- ��������� �� ����� ������������ ��������� ��� ���������
	int Start; //------------------ ��������� �� ������ ������������ ��������� ��� ���������
	int FCount; //------------------------------------------------------ ������� ���� ������
	//try
//	{
		while(!Terminated)
		{
			NomerStan = FComPortAB->NumStan;
			//---- ����������� �������� ������� FComPortAB->reEvent ("������� ���������� ����")
			if(WaitForSingleObject(FComPortAB->reEventAB, INFINITE) != WAIT_OBJECT_0 )continue;
			for (k=0; k < 18; k++)REG[k]=0; //-------------------- �������� ������� ����� ������
			ZeroMemory(&BufAll,80); //------------------------------ �������� ����� ����� ������
			ZeroMemory(&BufBuf,80); //------------------------------ �������� ����� ����� ������
			EnterCriticalSection( &FComPortAB->ReadABSection ); // ������ � ����������� ������
			size = FComPortAB->InBuffUsed; //-------------- �������� ���������� ���������� ����
			LeaveCriticalSection(&FComPortAB->ReadABSection);
			//---------------------------------------------- ���������� ������� ������� � BufAll
			if(FComPortAB->N_OSTAT>0)
			CopyMemory(BufAll,FComPortAB->OSTATOK,FComPortAB->N_OSTAT);

			//------------------------------------------------ ��������� �� ������ ������ ������
			if(size<(80 - FComPortAB->N_OSTAT))FCount = FComPortAB->GetBlock(BufBuf, size);
			else
			{
				PurgeComm(FComPortAB->ComHandle, PURGE_RXABORT | PURGE_RXCLEAR);
				EnterCriticalSection( &FComPortAB->ReadABSection );//������ � ����������� ������
				FComPortAB->IBuffPos = 0 ;
				FComPortAB->IBuffUsed = 0;
				LeaveCriticalSection(&FComPortAB->ReadABSection);
				continue;
			}

			//-------------------------------------- �������� �������� ������ � �������� �������
			CopyMemory(&BufAll[FComPortAB->N_OSTAT],BufBuf,FCount);
			FCount = FCount + FComPortAB->N_OSTAT;
			Start=0;
			Hvost=0;
			while((FCount-Hvost)>7)
			{
				//----------------------------- ��������� ������� ��������� ��� ��������� � ������
				for(i=Hvost; i < FCount; i++)
				{
					it_is_soob = false;
					if(i>=63)break;
					if(Terminated)break;
					if((BufAll[i] =='A') ||(BufAll[i] =='B'))
					{
						if(BufAll[i+1] ==BufAll[i])
						{
							if(BufAll[i+2] == BufAll[i])
							{
								if(BufAll[i+3] == BufAll[i])
								{
									if(BufAll[i+4] == BufAll[i])
									{
										if(BufAll[i+7] == BufAll[i])
										{
											it_is_soob = true;
											break;
										}

									}
								}
							}
						}
					}
				}

				if((i<FCount)&(i<63))
				{
					Start = i;
					if(it_is_soob)Hvost = i+8;
				}
				else Hvost = 63;

				if(it_is_soob)
				{
					k=0;
					for(i=Start;i<Hvost;i++)REG[k++]=BufAll[i];
					Synchronize(DoOnReceived);
				}
			}
			k=0;
			for(i=Hvost;i<FCount;i++)FComPortAB->OSTATOK[k++]=BufAll[i];
			FComPortAB->N_OSTAT = k;
		}
/*	}
	catch (...)
	{
		Application->MessageBox("������","TReadEventThreadAB",MB_OK);
		return;
	}
	 */
	return;
}

//----------------------------------------------------------------------------------------
void __fastcall TReadEventThreadAB::DoOnReceived(void)
{
	if( FComPortAB->OnDataReceivedAB)
			FComPortAB->OnDataReceivedAB(FComPortAB,REG);
}

//---------------------------------------------------------------------------

