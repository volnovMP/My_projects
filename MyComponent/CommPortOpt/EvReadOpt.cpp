#include <vcl.h>
#pragma hdrstop
#include "EvReadOpt.h"
#include "CRC.h"
#pragma package(smart_init)
//========================================================================================//---------------------------------------------------------------------------
__fastcall TReadEventThreadOpt::TReadEventThreadOpt(TCommPortOpt *ComPortOpt) : TThread(false)
{
	FComPortOpt = ComPortOpt;
}
//----------------------------------------------------------------------------------------
int __fastcall TReadEventThreadOpt::byla_com(unsigned char REG_[12])
{
	int i;
	if(FComPortOpt->REG_COM_TUMS[0]=='(')//-------------------- если в регистре есть команда
	{
		if((FComPortOpt->REG_COM_TUMS[1]==REG_[1])&&
		(FComPortOpt->REG_COM_TUMS[2]==REG_[2])&&
		(FComPortOpt->REG_COM_TUMS[3]==REG_[3]))
		{
			for(i=0;i<16;i++)FComPortOpt->REG_COM_TUMS[i]=0;
			return(0);
		}
		else return(-1);
	}
	return(0);
}
//========================================================================================
//------------------------- процедура непрерывного ожидания чтения последовательного порта
void __fastcall TReadEventThreadOpt::Execute()
{
	int i,k,podt_com,size;
	unsigned char test_sum;
	bool it_is_kvit,it_is_soob;
	unsigned char BufBuf[80]; //--------------------------------- промежуточный буфер данных
	unsigned char BufAll[80];
	DWORD NomerStan;
	int Hvost; //----------- ------- указатель на конец прочитанного сообщения или квитанции
	int Start; //------------------ указатель на начало прочитанного сообщения или квитанции
	int FCount; //------------------------------------------------------ счетчик байт данных
	//try
//	{
		while(!Terminated)
		{
			NomerStan = FComPortOpt->NumStan;
			//---- непрерывное ожидание события FComPortOpt->reEvent ("принято достаточно байт")
			if(WaitForSingleObject(FComPortOpt->reEventOpt, INFINITE) != WAIT_OBJECT_0 )continue;
			for (k=0; k < 18; k++)REG[k]=0; //-------------------- очистить регистр прием данных
			ZeroMemory(&BufAll,80); //------------------------------ очистить буфер ввода данных
			ZeroMemory(&BufBuf,80); //------------------------------ очистить буфер ввода данных
			EnterCriticalSection( &FComPortOpt->ReadOptSection ); // входим в критическую секцию
			size = FComPortOpt->InBuffUsed; //-------------- получаем количество нечитанных байт
			LeaveCriticalSection(&FComPortOpt->ReadOptSection);
			//---------------------------------------------- переписать прошлый остаток в BufAll
			if(FComPortOpt->N_OSTAT>0)
			CopyMemory(BufAll,FComPortOpt->OSTATOK,FComPortOpt->N_OSTAT);

			//------------------------------------------------ прочитать из буфера приема данные
			if(size<(80 - FComPortOpt->N_OSTAT))FCount = FComPortOpt->GetBlock(BufBuf, size);
			else
			{
				PurgeComm(FComPortOpt->ComHandle, PURGE_RXABORT | PURGE_RXCLEAR);
				EnterCriticalSection( &FComPortOpt->ReadOptSection );//входим в критическую секцию
				FComPortOpt->IBuffPos = 0 ;
				FComPortOpt->IBuffUsed = 0;
				LeaveCriticalSection(&FComPortOpt->ReadOptSection);
				continue;
			}

			//-------------------------------------- добавить принятые данные к прошлому остатку
			CopyMemory(&BufAll[FComPortOpt->N_OSTAT],BufBuf,FCount);
			FCount = FCount + FComPortOpt->N_OSTAT;
			Start=0;
			Hvost=0;
			while((FCount-Hvost)>17)
			{
				//----------------------------- проверить наличие сообщения или квитанции в данных
				for(i=Hvost; i < FCount; i++)
				{
					it_is_kvit = false;
					it_is_soob = false;
					if(i>=63)break;
					if(Terminated)break;
					if(BufAll[i] == '(')
					{
						if(BufAll[i+1] == (NomerStan&0xff000000)>>24)
						{
							if(BufAll[i+2] == (NomerStan&0x00ff0000)>>16)
							{
								if(BufAll[i+3] == (NomerStan&0x0000ff00)>>8)
								{
									if(BufAll[i+4] == (NomerStan&0x000000ff))
									{
										if(BufAll[i+10] == ')')
										{
											it_is_kvit = true;
											break;
										}
										if(BufAll[i+17] == ')')
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
					if(it_is_soob)Hvost = i+18;
					if(it_is_kvit)Hvost = i+11;
				}
				else Hvost = 63;


				if (it_is_soob)
				{
					test_sum = CalculateCRC8(&BufAll[i+7],9);
					if(test_sum != BufAll[i+16])it_is_soob = false;
				}

				if(it_is_soob)
				{
					k=0;
					for(i=Start;i<Hvost;i++)REG[k++]=BufAll[i];
					Soob_Kvit = True;
					Synchronize(DoOnReceived);
				}

				if (it_is_kvit)
				{
					test_sum = CalculateCRC8(&BufAll[i+7],2);
					if(test_sum != BufAll[i+9])it_is_kvit = false;
				}
				if(it_is_kvit)
				{
					k=0;
					for(i=Start;i<Hvost;i++)REG[k++]=BufAll[i];
					Soob_Kvit = False;
					Synchronize(DoOnReceived);
				}
			}
			k=0;
			for(i=Hvost;i<FCount;i++)FComPortOpt->OSTATOK[k++]=BufAll[i];
			FComPortOpt->N_OSTAT = k;
		}
/*	}
	catch (...)
	{
		Application->MessageBox("ОШИБКА","TReadEventThreadOpt",MB_OK);
		return;
	}
	 */
	return;
}

//----------------------------------------------------------------------------------------
void __fastcall TReadEventThreadOpt::DoOnReceived(void)
{
	if( FComPortOpt->OnDataReceivedOpt)
			FComPortOpt->OnDataReceivedOpt(FComPortOpt,REG,Soob_Kvit);
}

//---------------------------------------------------------------------------

