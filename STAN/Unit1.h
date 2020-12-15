//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TVVOD_DAY : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TEdit *DEN;
	TUpDown *UpDown1;
	TEdit *MES;
	TUpDown *UpDown2;
	TEdit *GOD;
	TUpDown *UpDown3;
	TLabel *Label1;
	TEdit *CHAS;
	TLabel *Label5;
	TEdit *MINUT;
	TEdit *SEKUND;
	TLabel *Label6;
	TUpDown *UpDown4;
	TUpDown *UpDown5;
	TUpDown *UpDown6;
	TButton *SETUP;
	void __fastcall FormActivate(TObject *Sender);
	void __fastcall SETUPClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TVVOD_DAY(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TVVOD_DAY *VVOD_DAY;
//---------------------------------------------------------------------------
#endif
