#ifndef ThStatusOptH
#define ThStatusOptH

//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "CommPortOpt.h"
//---------------------------------------------------------------------------
class TStatusThreadOpt : public TThread
{
private:
		TCommPortOpt *FComPortOpt;
		HANDLE FComHandle;

protected:
		void __fastcall Execute();

public:
		AnsiString Name;
		OVERLAPPED SOL;
		__fastcall TStatusThreadOpt(TCommPortOpt *ComPortOpt, TComEventType Events);
		virtual __fastcall ~TStatusThreadOpt(void);
};

//---------------------------------------------------------------------------
#endif
