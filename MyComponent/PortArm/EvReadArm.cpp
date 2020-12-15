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
	int j,i,k,podt_com,size;
  bool Analiz;
	unsigned char test_sum, KVIT[6], *BuferALL;
	unsigned char BufARM[18]; //-------------------------------- буфер для входных данных
	unsigned char BufBuf[80]; //------------------------------- промежуточный буфер данных
	unsigned char BufAll[80];
	int Konec; //------------------------ указатели конечных позиций при записи буфера
	int Nachalo; //--------------------- указатели начальных позиций при записи буфера
	int Konec_Buf; //------------- указатель конечной позиции записи в промежуточный буфер
	int FCount; //---------------------------------------------------- счетчик байт данных
	j = 0;
	Konec_Buf = 0; N_pak = 0;
	Konec=0xFF;Nachalo=0xFF;
	while( !Terminated )
	{
		Raznica = 0;
		if( WaitForSingleObject(FArmPort->reEvent, INFINITE) != WAIT_OBJECT_0 )continue;
		j = Konec_Buf;
		for (k=0; k < 28; k++)REG[k]=0;
		ZeroMemory(&BufAll,80);
		EnterCriticalSection(&FArmPort->ReadSection ); //------ входим в критическую секцию
		size = FArmPort->InBuffUsed;
		LeaveCriticalSection(&FArmPort->ReadSection);
		FCount = FArmPort->GetBlock(BufAll, size);
		for(i=0;i<FCount;i++)
		{
			BufBuf[j] = BufAll[i];
			if(BufBuf[j] == 0xAA)Nachalo = j; //--------------- фиксируем найденное начало
			if(BufBuf[j]==0x55)
	 		if(Nachalo != 0xFF)Konec = j; //найден конец
			j++;
			if(j>79)j=0;
   	}
    if((Nachalo!=0xFF)&&(Konec!=0xFF))
    {
  		ZeroMemory(&BufAll,80);
			Konec_Buf = j;
			if (Konec > Nachalo) Raznica = Konec - Nachalo;
			else Raznica = 80 - Nachalo + Konec;
     	Analiz = true;
     	if(Raznica != 27)
     	{
     		Analiz = false;
        i = Nachalo;
       	for(i=0;i<28;i++)BufBuf[i]=0;
				Konec=0xFF;Nachalo=0xFF;
     	}
 			if(Analiz)
			{
				j = Nachalo;
				for(i=0;i<28;i++)
        {
						REG[i] = BufBuf[j];	BufBuf[j++] = 0;
						if(j>79)j=0;
				}
        if((REG[0] == 0xAA) && (REG[27]== 0x55)) Synchronize(DoOnReceived);
        for(i=0;i<28;i++)REG[i]=0;
        Analiz = false;
        Nachalo = 0xFF;
        Konec = 0xFF;
      }
			else
		 	{
      	Analiz = false;
        Nachalo = 0xFF;
        Konec = 0xFF;

      }
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TReadEventThread1::DoOnReceived(void)
{
	if(FArmPort->OnDataReceived)
		 FArmPort->OnDataReceived(FArmPort,REG,Raznica+1, N_pak);
}

//---------------------------------------------------------------------------

