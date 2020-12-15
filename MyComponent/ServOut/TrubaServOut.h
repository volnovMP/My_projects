//---------------------------------------------------------------------------
#ifndef TrubaServOutH
#define TrubaServOutH
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
//----------------------------------------------------------------------------------------
#include "ServOut.h"
//==================================================== ����� ������ ��� ������������ �����
class TTrubaServOut: public TThread
{
private:
  TServOut *FServOut;//--------------------------------------------- ������ ����� � ������
  BYTE FInBuffer[28];  //------------------------------------------ ������� �����
protected:
	bool fPendingIO;
	void __fastcall Execute(void);//------------------------------ �������� ��������� ������
	void __fastcall DoReadPacket(void);//----------------- ������������ �������-"���� �����"
public:
	AnsiString Name;
	OVERLAPPED FWr;
	OVERLAPPED FRd;
  HANDLE WaitSinch;
	unsigned long FCountIn;
  unsigned long FCountOut;
	unsigned char FOutBuffer[70]; //----------------------------------------- �������� �����
  __fastcall TTrubaServOut(TServOut *ServOut);

};
#endif
