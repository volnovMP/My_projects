#ifndef EvStatusH
#define EvStatusH

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "CommPort.h"

//---------------------------------------------------------------------------
class TStatusEventThread : public TThread
{
private:
protected:
    TCommPort *FComPort;
    void __fastcall DoOnSignal(void);

public:
  	AnsiString Name;
    __fastcall TStatusEventThread(TCommPort *ComPort);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
