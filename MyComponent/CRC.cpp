//---------------------------------------------------------------------------
#pragma hdrstop
#include "CRC.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
                /***********************************************\
*  int CalculateCRC8(void *pData, int dataLen)  *
*        ��������� ������� CRC-8                *
* pData - ��������� �� ����� ������ ��������    *
* dataLen -����� ������ ������                  *
\***********************************************/
char __fastcall CalculateCRC8(void *pData, int dataLen)
{ 
  unsigned char *ptr = (unsigned char *)pData;
	unsigned char c = 0xff;
  int n;
  for (n = 0; n < dataLen; n++) c = crc8_table[ *ptr++ ^ c ];
  return c ^ 0xff;
}

