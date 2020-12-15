//---------------------------------------------------------------------------
#ifndef otladkaH
#define otladkaH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TOtladka1 : public TForm
{
__published:	// IDE-managed Components
  TEdit *Edit1;
  TLabel *Label1;
  TButton *Button1;
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall Edit1Exit(TObject *Sender);
private:	// User declarations
public:		// User declarations
  int Otlad;
  int Restor;
  __fastcall TOtladka1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TOtladka1 *Otladka1;
//---------------------------------------------------------------------------
#endif
