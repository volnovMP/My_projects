//---------------------------------------------------------------------------

#ifndef Unit3H
#define Unit3H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
//---------------------------------------------------------------------------
class TTums2 : public TForm
{
__published:	// IDE-managed Components
  TStringGrid *DrG1;
  TButton *Button1;
  void __fastcall Button1Click(TObject *Sender);
 private:	// User declarations
public:		// User declarations
  __fastcall TTums2(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TTums2 *Tums2;
//---------------------------------------------------------------------------
#endif
