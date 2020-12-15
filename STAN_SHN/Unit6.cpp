//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Grids.hpp>
#include <vcl.h>
#pragma hdrstop

#include "Unit6.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TLimit *Limit;
//---------------------------------------------------------------------------
__fastcall TLimit::TLimit(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
