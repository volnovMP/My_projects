//---------------------------------------------------------------------------

#ifndef PortArmH
#define PortArmH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Classes.hpp>
#include "CommPort.h"
class TReadEventThreadArm;
#include "EvReadArm.h"
//---------------------------------------------------------------------------
class PACKAGE TPortArm : public TCommPort
{
private:
protected:
public:
	__fastcall TPortArm(TComponent* Owner);
__published:
};
//---------------------------------------------------------------------------
#endif
