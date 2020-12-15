#ifndef ThRead1H
#define ThRead1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
//---------------------------------------------------------------------------
#include "ArmPort.h"
//---------------------------------------------------------------------------
class TArmReadThread : public TThread
{
private:
		TArmPort *FArmPort;
		HANDLE FArmHandle;

protected:
		void __fastcall Execute();

public:
		OVERLAPPED ROL1;
		AnsiString *Name;
		__fastcall TArmReadThread(TArmPort *ArmPort );
		virtual __fastcall ~TArmReadThread(void);
};

//---------------------------------------------------------------------------
#endif
