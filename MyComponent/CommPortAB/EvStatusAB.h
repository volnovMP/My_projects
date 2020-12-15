#ifndef EvStatusABH
#define EvStatusABH

//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "CommPortAB.h"
//---------------------------------------------------------------------------
class TStatusEventThreadAB : public TThread
{
private:
protected:
		TCommPortAB *FComPortAB;
		void __fastcall DoOnSignal(void);

public:
	AnsiString Name;
	__fastcall TStatusEventThreadAB(TCommPortAB *ComPortAB);
	void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
