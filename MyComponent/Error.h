//---------------------------------------------------------------------------

#ifndef ErrorH
#define ErrorH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TErrorForm : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TButton *Button1;
	void __fastcall Button1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TErrorForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TErrorForm *ErrorForm;
//---------------------------------------------------------------------------
#endif
