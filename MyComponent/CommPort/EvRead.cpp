#include <vcl.h>
#pragma hdrstop

#include "EvRead.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
__fastcall TReadEventThread::TReadEventThread(TCommPort *ComPort) : TThread(false)
{
	FComPort = ComPort;
}
//----------------------------------------------------------------------------------------
int __fastcall TReadEventThread::byla_com(unsigned char REG_[12])
{
	int i;
	if(FComPort->REG_COM_TUMS[0]=='(')//если в регистре есть команда
	{
		if((FComPort->REG_COM_TUMS[1]==REG_[1])&&
		(FComPort->REG_COM_TUMS[2]==REG_[2])&&
		(FComPort->REG_COM_TUMS[3]==REG_[3]))
		{
			for(i=0;i<16;i++)FComPort->REG_COM_TUMS[i]=0;
			return(0);
		}
		else return(-1);
	}
	return(0);
}
//========================================================================================
//------------------------- процедура непрерывного ожидания чтения последовательного порта
void __fastcall TReadEventThread::Execute()
{
	int j,i,k,podt_com,size;
	unsigned char test_sum, KVIT[6], *BuferALL;
	bool it_is_kvit,Analiz;
	unsigned char BufTums[18]; //---------------------------------- буфер для входных данных
	unsigned char BufBuf[80]; //--------------------------------- промежуточный буфер данных
	unsigned char BufAll[80];
	int Konec[8]; //--------------------------- указатели конечных позиций при записи буфера
	int Nachalo[8]; //------------------------ указатели начальных позиций при записи буфера
	int Konec_Buf; //--------------- указатель конечной позиции записи в промежуточный буфер
	int FCount; //------------------------------------------------------ счетчик байт данных
	j = 0;
	Konec_Buf = 0; N_pak = 0;
	for(i=0;i<8;i++){Konec[i]=0xFF;Nachalo[i]=0xFF;}
	while(!Terminated)
	{
		Raznica = 0;
		if(WaitForSingleObject(FComPort->reEvent, INFINITE) != WAIT_OBJECT_0 )continue;
		j = Konec_Buf;
		for (k=0; k < 12; k++)REG[k]=0;
		ZeroMemory(&BufAll,80);
		EnterCriticalSection( &FComPort->ReadSection ); //-------- входим в критическую секцию
		size = FComPort->InBuffUsed;
		LeaveCriticalSection(&FComPort->ReadSection);
		if(size<80)	FCount = FComPort->GetBlock(BufAll, size);
		else
		{
				PurgeComm(FComPort->ComHandle, PURGE_RXABORT | PURGE_RXCLEAR);
        continue;
			}
			for(i=0;i<FCount;i++)
			{
        if(Terminated)break;
      	if(i>79)j=0;
				BufBuf[j] = BufAll[i];
				if(BufBuf[j] == '(')Nachalo[N_pak] = j; //------------- фиксируем найденное начало
				if((BufBuf[j]==')')||(BufBuf[j]=='+'))
				{
					if(Nachalo[N_pak] != 0xFF)
					Konec[N_pak++] = j; //-------------------------------- фиксируем найденный конец
				}
				if(N_pak > 7) N_pak = 7;
				j++;
				if(j>79)j=0;
			}
			ZeroMemory(&BufAll,80);
			Konec_Buf = j;
			while(Konec[0]!=0xFF)
			{
        if(Terminated)break;
				it_is_kvit = false;  //----------------------------------------- исходные значения
				if (Konec[0] > Nachalo[0]) Raznica = Konec[0] - Nachalo[0];
				else Raznica = 80 - Nachalo[0] + Konec[0];
				Analiz = true;

				if(Raznica == 5) it_is_kvit = true;
				if((Raznica !=5) && (Raznica !=11 )&& (Raznica !=10 ))
				{
					Analiz = 0; i = Nachalo[0];
					while ( i != Konec[0])
					{
						BufBuf[i++] = 0;
						if ( i > 79 ) i = 0;
            if(Terminated)break;
					}
				}

				if(Analiz)
				{
					if((Nachalo[0]!=0xFF)&&(Konec[0]!=0xFF))
					{
						j = Nachalo[0];
    	      i = 0;
						while(1)
						{
							REG[i++] = BufBuf[j];
							BufBuf[j] = 0;
							if(j == Konec[0])	break;
							j++;
							if(j>79)j=0;
             if(Terminated)break;
					}
				}
				else
        {
          Analiz = 0;
         	Konec_Buf = 0; N_pak = 0;
					for(i=0;i<8;i++){Konec[i]=0xFF;Nachalo[i]=0xFF;}
          PurgeComm(FComPort->ComHandle, PURGE_RXABORT | PURGE_RXCLEAR );
          ZeroMemory(&BufAll,80);
         	continue;
        }

				if(it_is_kvit)
				{
					podt_com = byla_com(REG);
					if(podt_com == 0)FComPort->sboy_ts = 0;
				}
				Synchronize(DoOnReceived);
				for(i=0;i<12;i++)REG[i]=0;
				Analiz = false;
			}
			for(i=1;i<4;i++)
			{
				if(Nachalo[i] != 0xFF)
				{
					Nachalo[i-1] = Nachalo[i]; Nachalo[i] = 0xFF;
					Konec[i-1] = Konec[i]; Konec[i] = 0xFF;
					N_pak--;
				}
				else
				{
					Nachalo[i-1] = 0xFF;
					Konec[i-1] = 0xFF;
					N_pak--;
				}
				if(N_pak<0)	N_pak = 0;
			}
		}
	}
	return;
}

//---------------------------------------------------------------------------
void __fastcall TReadEventThread::DoOnReceived(void)
{
	if( FComPort->OnDataReceived )
			FComPort->OnDataReceived(FComPort,REG,Raznica+1, N_pak);
}

//---------------------------------------------------------------------------

