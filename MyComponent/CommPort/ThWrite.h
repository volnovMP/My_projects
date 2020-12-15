#ifndef ThWriteH
#define ThWriteH

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "CommPort.h"

//---------------------------------------------------------------------------
class TWriteThread : public TThread
{
private:
protected:
    HANDLE FComHandle;
    TCommPort *FComPort;

public:
  	AnsiString Name;
    OVERLAPPED WOL;
    __fastcall TWriteThread(TCommPort *ComPort );
    virtual __fastcall ~TWriteThread(void);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
