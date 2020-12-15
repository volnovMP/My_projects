#ifndef EvStatusOptH
#define EvStatusOptH

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "CommPortOpt.h"

//---------------------------------------------------------------------------
class TStatusEventThreadOpt : public TThread
{
private:
protected:
		TCommPortOpt *FComPortOpt;
		void __fastcall DoOnSignal(void);

public:
	AnsiString Name;
	__fastcall TStatusEventThreadOpt(TCommPortOpt *ComPortOpt);
	void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
