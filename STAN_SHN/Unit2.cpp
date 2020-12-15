//---------------------------------------------------------------------------
#include <vcl.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
#pragma hdrstop

#include "Unit2.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TTums1 *Tums1;
//---------------------------------------------------------------------------
__fastcall TTums1::TTums1(TComponent* Owner)
  : TForm(Owner)
{

}


void __fastcall TTums1::Button1Click(TObject *Sender)
{
    DrG1->Hide();
    DrG1->Show();
}
//---------------------------------------------------------------------------


