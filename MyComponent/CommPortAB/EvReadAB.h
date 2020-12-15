#ifndef EvReadABH
#define EvReadABH
#include <Classes.hpp>
#include "CommPortAB.h"
//---------------------------------------------------------------------------
class TReadEventThreadAB : public TThread
{
private:
protected:
		TCommPortAB *FComPortAB;
		void __fastcall DoOnReceived(void);

public:
		AnsiString Name;
		Byte REG[8]; //---------- регистр данных для приема информации порта кнопочной станции
		__fastcall TReadEventThreadAB(TCommPortAB *ComPortAB);
    void __fastcall Execute();
};

//---------------------------------------------------------------------------
#endif
