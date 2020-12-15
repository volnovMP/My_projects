#ifndef EvStatus1H
#define EvStatus1H

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "ArmPort.h"

//---------------------------------------------------------------------------
class TStatusEventThread1 : public TThread
{
private:
protected:
		TArmPort *FArmPort;
    void __fastcall DoOnSignal(void);

public:
  	AnsiString Name;
    __fastcall TStatusEventThread1(TArmPort *ArmPort);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
