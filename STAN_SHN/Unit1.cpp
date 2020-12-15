//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TVVOD_DAY *VVOD_DAY;
//---------------------------------------------------------------------------
__fastcall TVVOD_DAY::TVVOD_DAY(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TVVOD_DAY::FormActivate(TObject *Sender)
{
  unsigned short hrw,mnw,scw,msecw;
	unsigned short god,mes,den;
  TDateTime Vremia;

  Vremia = Time();
  DecodeTime(Vremia, hrw, mnw, scw, msecw);
  UpDown4->Position = hrw;
  UpDown5->Position = mnw;
  UpDown6->Position = scw;

  Vremia = Date();
  DecodeDate(Vremia,god,mes,den);
  UpDown1->Position = den;
	UpDown2->Position = mes;
  UpDown3->Position = god;
}
//---------------------------------------------------------------------------
void __fastcall TVVOD_DAY::SETUPClick(TObject *Sender)
{
	TSystemTime uts;
  TDateTime ndt,nd,nt;
  bool err;
  long cdt,delta;
  unsigned short Hr,Mn,Sc,Yr,Mt,Dy;
  int i;

  ndt = EncodeTime(UpDown4->Position-1,UpDown5->Position,UpDown6->Position,0);
  nd = EncodeDate(UpDown3->Position,UpDown2->Position,UpDown1->Position);
  DateTimeToSystemTime(nd + ndt,uts);
  SetLocalTime(&uts);
}
//---------------------------------------------------------------------------
