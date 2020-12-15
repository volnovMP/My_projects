#ifndef ThReadOptH
#define ThReadOptH

//---------------------------------------------------------------------------
#include <Classes.hpp>
#include "CommPortOpt.h"
//---------------------------------------------------------------------------
class TReadThreadOpt : public TThread
{
private:
		TCommPortOpt *FComPortOpt;
		HANDLE FComHandleOpt;

protected:
		void __fastcall Execute();

public:
		AnsiString Name;
		OVERLAPPED ROL;
		__fastcall TReadThreadOpt(TCommPortOpt *ComPortOpt );
		virtual __fastcall ~TReadThreadOpt(void);
};

//---------------------------------------------------------------------------
#endif
