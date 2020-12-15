#ifndef ThReadABH
#define ThReadABH

//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "CommPortAB.h"
//---------------------------------------------------------------------------
class TReadThreadAB : public TThread
{
private:
		TCommPortAB *FComPortAB;
		HANDLE FComHandleAB;

protected:
		void __fastcall Execute();

public:
		AnsiString Name;
		OVERLAPPED ROL;
		__fastcall TReadThreadAB(TCommPortAB *ComPortAB );
		virtual __fastcall ~TReadThreadAB(void);
};

//---------------------------------------------------------------------------
#endif
