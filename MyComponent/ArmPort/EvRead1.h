#ifndef EvRead1H
#define EvRead1H
#include <Classes.hpp>
#include "ArmPort.h"
//---------------------------------------------------------------------------
class TReadEventThread1 : public TThread
{
private:
protected:
		TArmPort *FArmPort;
		void __fastcall DoOnReceived(void);

public:
		unsigned char REG[28];
		AnsiString Name;
		int Raznica;
		int N_pak;
		__fastcall TReadEventThread1(TArmPort *ArmPort);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
