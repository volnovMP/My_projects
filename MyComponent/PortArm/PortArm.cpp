//---------------------------------------------------------------------------

#include <vcl.h>

#pragma hdrstop

#include "PortArm.h"
#pragma link "CommPort"
#pragma package(smart_init)
//---------------------------------------------------------------------------
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//

static inline void ValidCtrCheck(TPortArm *)
{
	new TPortArm(NULL);
}
//---------------------------------------------------------------------------
__fastcall TPortArm::TPortArm(TComponent* Owner)
	: TCommPort(Owner)
{
}
//---------------------------------------------------------------------------
namespace Portarm
{
	void __fastcall PACKAGE Register()
	{
		TComponentClass classes[1] = {__classid(TPortArm)};
		RegisterComponents("RPCcomp", classes, 0);
	}
}
//---------------------------------------------------------------------------
