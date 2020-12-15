//---------------------------------------------------------------------------
// Copyright (C) 1999 by Dmitriy Vassiliev
// slydiman@mailru.com
//---------------------------------------------------------------------------
#ifndef ThStatusH
#define ThStatusH
//---------------------------------------------------------------------------
#include <Classes.hpp>
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
class TStatusThread : public TThread
{
private:
    TCommPort *FComPort;
    HANDLE FComHandle;

protected:
    void __fastcall Execute();

public:
  	AnsiString Name;
    OVERLAPPED SOL;
    __fastcall TStatusThread(TCommPort *ComPort, TComEventType Events );
    virtual __fastcall ~TStatusThread(void);
};

//---------------------------------------------------------------------------
#endif
