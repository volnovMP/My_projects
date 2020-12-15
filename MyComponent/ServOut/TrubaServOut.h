//---------------------------------------------------------------------------
#ifndef TrubaServOutH
#define TrubaServOutH
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
//----------------------------------------------------------------------------------------
#include "ServOut.h"
//==================================================== класс потока для обслуживания трубы
class TTrubaServOut: public TThread
{
private:
  TServOut *FServOut;//--------------------------------------------- объект трубы в потоке
  BYTE FInBuffer[28];  //------------------------------------------ входной буфер
protected:
	bool fPendingIO;
	void __fastcall Execute(void);//------------------------------ основная процедура потока
	void __fastcall DoReadPacket(void);//----------------- формирование события-"есть пакет"
public:
	AnsiString Name;
	OVERLAPPED FWr;
	OVERLAPPED FRd;
  HANDLE WaitSinch;
	unsigned long FCountIn;
  unsigned long FCountOut;
	unsigned char FOutBuffer[70]; //----------------------------------------- выходной буфер
  __fastcall TTrubaServOut(TServOut *ServOut);

};
#endif
