//---------------------------------------------------------------------------
#include <vcl.h>
#include <conio.h>
#pragma hdrstop
#include "otladka.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TOtladka1 *Otladka1;
//---------------------------------------------------------------------------
__fastcall TOtladka1::TOtladka1(TComponent* Owner)
  : TForm(Owner)
{
  Otlad=0;
}
//---------------------------------------------------------------------------

void __fastcall TOtladka1::Button1Click(TObject *Sender)
{
    Label1->Visible=true;
    Edit1->Visible=true;

}
//---------------------------------------------------------------------------

void __fastcall TOtladka1::Edit1Exit(TObject *Sender)
{

  SetFocus();
  if(Edit1->Text!="490287")
  {
    Label1->Caption="Пароль неверен!!!";
    Edit1->Clear();
    Edit1->Visible=false;
    Button1->Visible=false;
    Update();
    Restor=63;
    Otlad=0;
    Sleep(1000);
    Hide();
  }
  else
  { Edit1->Clear();
    Hide();
    Otlad=5;
    Restor=15;
  }
}
//---------------------------------------------------------------------------


