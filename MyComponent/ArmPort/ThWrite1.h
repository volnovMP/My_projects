#ifndef ThWrite1H
#define ThWrite1H

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "ArmPort.h"

//---------------------------------------------------------------------------
class TWriteThread1 : public TThread
{
private:
protected:
		HANDLE FArmHandle;
		TArmPort *FArmPort;

public:
  	AnsiString Name;
		OVERLAPPED WOL1;
		__fastcall TWriteThread1(TArmPort *ArmPort);
		virtual __fastcall ~TWriteThread1(void);
		void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
