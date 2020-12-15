#ifndef ThStatusABH
#define ThStatusABH

//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "CommPortAB.h"
//---------------------------------------------------------------------------
class TStatusThreadAB : public TThread
{
private:
		TCommPortAB *FComPortAB;
		HANDLE FComHandle;

protected:
		void __fastcall Execute();

public:
		AnsiString Name;
		OVERLAPPED SOL;
		__fastcall TStatusThreadAB(TCommPortAB *ComPortAB, TComEventType Events);
		virtual __fastcall ~TStatusThreadAB(void);
};

//---------------------------------------------------------------------------
#endif
