#ifndef ThWriteOptH
#define ThWriteOptH

//---------------------------------------------------------------------------
#include <Classes.hpp>

//---------------------------------------------------------------------------
#include "CommPortOpt.h"

//---------------------------------------------------------------------------
class TWriteThreadOpt : public TThread
{
private:
protected:
		HANDLE FComHandleOpt;
		TCommPortOpt *FComPortOpt;

public:
		AnsiString Name;
		OVERLAPPED WolOpt;
		__fastcall TWriteThreadOpt(TCommPortOpt *ComPortOpt );
		virtual __fastcall ~TWriteThreadOpt(void);
		void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
