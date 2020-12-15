//---------------------------------------------------------------------------
#pragma hdrstop
#include "CRC_CALC.h"

/***********************************************\
*  int CalculateCRC8(void *pData, int dataLen)  *
*        процедура расчета CRC-8                *
* pData - указатель на буфер данных контроля    *
* dataLen -длина буфера данных                  *
\***********************************************/
char __fastcall CalculateCRC8(void *pData, int dataLen)
{
	unsigned char *ptr = (unsigned char *)pData;
	unsigned char c = 0xff;
	int n;
	for (n = 0; n < dataLen; n++) c = crc08_table[ *ptr++ ^ c ];
	return c ^ 0xff;
}

//---------------------------------------------------------------------------
/***********************************************\
*  int CalculateCRC16(void *pData, int dataLen) *
*        процедура расчета CRC-16               *
* pData - указатель на буфер данных контроля    *
* dataLen -длина буфера данных                  *
\***********************************************/

int __fastcall CalculateCRC16(void *pData, int dataLen)
{
	unsigned char *ptr = (unsigned char *)pData;
	unsigned int c = 0xffff,a,b;
	int n;
	for (n = 0; n < dataLen; n++)
	{
		a=c>>8;
		b=(c<<8)&0xffff;
		c = crc16_table[ *ptr++ ^ a ] ^ b;
	}
	return c ^ 0xffff;
}

#pragma package(smart_init)
