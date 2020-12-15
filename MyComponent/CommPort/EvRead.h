#ifndef EvReadH
#define EvReadH
#include <Classes.hpp>
#include "CommPort.h"
//---------------------------------------------------------------------------
class TReadEventThread : public TThread
{
private:
protected:
		TCommPort *FComPort;
    int __fastcall byla_com(unsigned char REG_[12]);
    void __fastcall DoOnReceived(void);

public:
  	AnsiString Name;
		unsigned char REG[12];
		int Raznica;
		int N_pak;
    __fastcall TReadEventThread(TCommPort *ComPort);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
