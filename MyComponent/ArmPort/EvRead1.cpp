#include <vcl.h>
#pragma hdrstop

#include "EvRead1.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TReadEventThread1::TReadEventThread1(TArmPort *ArmPort) : TThread(false)
{
	FArmPort = ArmPort;
}
//----------------------------------------------------------------------------------------
//------------------------- процедура непрерывного ожидания чтения последовательного порта
void __fastcall TReadEventThread1::Execute()
{
	int tst,j,i,k,podt_com,size;
	unsigned char test_sum,*BuferALL;
	bool it_is_kvit,Analiz;
	unsigned char BufArm[28]; //-------------------------------- буфер для входных данных
	unsigned char BufBuf[80]; //------------------------------- промежуточный буфер данных
	unsigned char BufAll[80];
	int Hvost; //-------------------- указатели конечных позиций при записи буфера
	int Start; //------------------- указатели начальных позиций при записи буфера
	int FCount; //-------------------------------------------- счетчик байт данных
	try
	{
		while(!Terminated)
		{
			if(WaitForSingleObject(FArmPort->reEvent, INFINITE) != WAIT_OBJECT_0 )continue;
			for (k=0; k < 28; k++)REG[k]=0;
			ZeroMemory(&BufAll,80);
			ZeroMemory(&BufBuf,80);
			EnterCriticalSection( &FArmPort->ReadSection );//входим в критическую секцию
			size = FArmPort->InBuffUsed;
			LeaveCriticalSection(&FArmPort->ReadSection);

			if(FArmPort->N_OSTAT>0)
			CopyMemory(BufAll,FArmPort->OSTATOK,FArmPort->N_OSTAT);

			if(size < ( 80 - FArmPort->N_OSTAT) ) FCount = FArmPort->GetBlock(BufBuf, size);
			else
			{
				PurgeComm(FArmPort->ComHandle, PURGE_RXABORT|PURGE_RXCLEAR);
				EnterCriticalSection(&FArmPort->ReadSection);
				FArmPort->IBuffPos = 0;
				FArmPort->IBuffUsed = 0;
				LeaveCriticalSection(&FArmPort->ReadSection);
				continue;
			}

			CopyMemory(&BufAll[FArmPort->N_OSTAT],BufBuf,FCount);
			FCount = FCount + FArmPort->N_OSTAT;
			Start = 0;
			Hvost = 0;
			while((FCount-Hvost)>27)
			{
				for(i=Hvost; i<FCount;i++)
				{
					Analiz = false;
					if( i>=53)break;
					if(Terminated)break;
					if((BufAll[i]==0xAA)&&(BufAll[i+27]==0x55))
					{
						Analiz = true;
						break;
					}
				}
				if(( i < FCount) & ( i < 53))
				{
					Start = i;
					if( Analiz) Hvost = i + 28;
				}
				else Hvost = 53;
				if(Analiz)
				{
					j=0;
					for( i = Start; i < Hvost; i++) REG[j++] = BufAll[i];
					Synchronize(DoOnReceived);
					for(i=0;i<28;i++)REG[i]=0;
				}
			}
			k=0;
			for(i=Hvost;i<FCount;i++)FArmPort->OSTATOK[k++]=BufAll[i];
			FArmPort->N_OSTAT = k;
		}
	}
	catch(...)
	{
		Application->MessageBox("ОШИБКА","ArmPortEvRead",MB_OK);
	}
	return;
}

//---------------------------------------------------------------------------
void __fastcall TReadEventThread1::DoOnReceived(void)
{
	if(FArmPort->OnDataReceived)
		 FArmPort->OnDataReceived(FArmPort,REG,Raznica+1, N_pak);
}

//---------------------------------------------------------------------------

