//---------------------------------------------------------------------------

#ifndef Unit2H
#define Unit2H
#include <Classes.hpp>
#include <Controls.hpp>
#include <Grids.hpp>
#include <StdCtrls.hpp>
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
class TTums1 : public TForm
{
__published:	// IDE-managed Components
  TStringGrid *DrG1;
  TButton *Button1;
  void __fastcall Button1Click(TObject *Sender);

private:	// User declarations
public:		// User declarations
  __fastcall TTums1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TTums1 *Tums1;
//---------------------------------------------------------------------------
#endif
