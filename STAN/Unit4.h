//---------------------------------------------------------------------------

#ifndef Unit4H
#define Unit4H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TFlagi : public TForm
{
__published:	// IDE-managed Components
  TStringGrid *SG;
  TStringGrid *SG1;
  TLabel *Label1;
  TLabel *Label2;

private:	// User declarations
public:		// User declarations
  __fastcall TFlagi(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TFlagi *Flagi;
//---------------------------------------------------------------------------
#endif
