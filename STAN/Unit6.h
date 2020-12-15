//---------------------------------------------------------------------------

#ifndef Unit6H
#define Unit6H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
//---------------------------------------------------------------------------
class TLimit : public TForm
{
__published:	// IDE-managed Components
  TStringGrid *StrGrFr4;
private:	// User declarations
public:		// User declarations
  __fastcall TLimit(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TLimit *Limit;
//---------------------------------------------------------------------------
#endif
