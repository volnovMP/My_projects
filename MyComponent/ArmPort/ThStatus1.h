#ifndef ThStatus1H
#define ThStatus1H

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "ArmPort.h"

//---------------------------------------------------------------------------
class TStatusThread1 : public TThread
{
private:
		TArmPort *FArmPort;
		HANDLE FArmHandle;

protected:
    void __fastcall Execute();

public:
  	AnsiString Name;
		OVERLAPPED SOL1;
		__fastcall TStatusThread1(TArmPort *ArmPort, TComEventType Events );
		virtual __fastcall ~TStatusThread1(void);
};

//---------------------------------------------------------------------------
#endif
