//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit3.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TTums2 *Tums2;
//---------------------------------------------------------------------------
__fastcall TTums2::TTums2(TComponent* Owner)
  : TForm(Owner)
{
}

void __fastcall TTums2::Button1Click(TObject *Sender)
{
  DrG1->Hide();
  DrG1->Show();
}
//---------------------------------------------------------------------------

