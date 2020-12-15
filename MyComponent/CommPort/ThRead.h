#ifndef ThReadH
#define ThReadH

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "CommPort.h"

//---------------------------------------------------------------------------
class TReadThread : public TThread
{
private:
    TCommPort *FComPort;
    HANDLE FComHandle;

protected:
    void __fastcall Execute();

public:
  	AnsiString Name;
    OVERLAPPED ROL;
    __fastcall TReadThread(TCommPort *ComPort );
    virtual __fastcall ~TReadThread(void);
};

//---------------------------------------------------------------------------
#endif
