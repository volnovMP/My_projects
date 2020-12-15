//---------------------------------------------------------------------------
#ifndef ssk_srv_rboxH
#define ssk_srv_rboxH

#include "ArmPort.h"
#include "CommPortOpt.h"
#include "ServOut.h"
#include "Com_Port.h"
#include <Classes.hpp>
#include <Controls.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include <StdCtrls.hpp>
#include "CommPort.h"
#define RBOX
//#define  Debug 1

//----------------------------------------------------------------------------------------

#define BUF_PAKET 24
#define MAX_NEW 40

//----------------------------------------------------------------------------------------
_RTL_CRITICAL_SECTION NOM_PACKET_ZAP; //---------- критическа€ секци€ записи данных в порт

struct PAKET
{
  unsigned int KS_OSN;
  unsigned char ARM_OSN_KAN;
  unsigned int KS_REZ;
  unsigned char ARM_REZ_KAN;
}PAKETs[32];

struct OBJect
{
  unsigned int OBJ[21];
	unsigned int LAST;
}OBJ_ARMu[32],OBJ_ARMu1[32];

struct sp34
{
  unsigned char byt[34];
}*BD_OSN_BYT,*FR3;

struct sp26
{
  unsigned char byt[26];
}*AVTOD;

struct sp12
{
	unsigned char byt[12];
}*SPSTR,*SPSIG,*SPDOP,*SPKONT;

struct sp17
{
	unsigned char byt[17];
}*SPSPU,*SPPUT;

struct sp4
{
	unsigned char byt[4];
}*OUT_OB,*INP_OB;

#ifdef RBOX
typedef int (*TMyF1)(int);
typedef int (*TMyF2)(int,int);
typedef int (*TMyF3)(void);
typedef bool (*TMyF4)(void);

TMyF1 SetModName,SetWDTEnable,SetWDTValue;
TMyF3 GetWDTValue;
HMODULE dllcall;
#endif

#ifdef ARPEX
typedef bool (*TMyF1)(void);
typedef bool (*TMyF2)(int,int);
typedef bool (*TMyF3)(int, int*);
typedef bool (*TMyF4)(int);
typedef bool (*TMyF5)(char*,int);
typedef bool (*TMyF6)(int*,int*);
TMyF1 AppInit,AppDeInit,LcmClr,WDTStp;
TMyF2 SetDigOut;
TMyF3 GetDigOut,GetDigInp,GetAnalogInp;
TMyF4 WDTStrt;
TMyF5 LCMDspl;
TMyF6 WDTGetRng;
HINSTANCE dllcall;
#endif

class TStancia : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label4;
	TLabel *Lb4;
	TLabel *Lb7;
	TLabel *Lb8;
	TLabel *Label5;
	TEdit *Edit1;
	TEdit *Edit2;
	TLabel *Label9;
	TLabel *Label10;
	TImageList *ImageList1;
	TLabel *Label11;
	TEdit *Edit5;
	TEdit *Edit4;
	TEdit *Edit3;
	TLabel *Label12;
	TLabel *Label13;
	TEdit *Edit6;
	TEdit *Edit7;
	TLabel *Lb5;
	TButton *Button2;
	TPopupMenu *PopMenu1;
	TMenuItem *pt1;
	TMenuItem *pt2;
	TTimer *TimerTry;
	TTimer *TimerMain; //-------------------------------------------- св€зь с “”ћ—ом канал 1
	TServOut *Serv1;//----------------------------------------------- св€зь с “”ћ—ом канал 2
	TTimer *TimerDC;
	TTimer *TimerKOK;
	TTrayIcon *TrayIcon11;
	TArmPort *ArmPort1;
	TCommPortOpt *CommPortOpt1;
	TLabel *Label15;
	TLabel *Label3;
	TLabel *Label16;
	TEdit *Edit8;
	TEdit *Edit9;
	TEdit *Edit10;
	TTimer *Timer250;
	TTimer *TimerOtlad;
	TStringGrid *SG1;
	TButton *Button3;
	TButton *Button4;
	TButton *Button5;
	TCommPort *Port_DC;
	TLabel *Label1;
	TLabel *Lb1;
	TLabel *Label7;
	TLabel *Lb2;
	int __fastcall diagnoze(int st,int kan);
	int __fastcall test_plat(int st,int kan);
	int __fastcall TAKE_STROKA(unsigned char GRPP,int sb,int tms);
	void __fastcall ZAPOLNI_FR3(unsigned char GRP,int STRKA,int sob,unsigned char tum,char nov);
	int __fastcall ZAPOLNI_KVIT(int ar,int kn);
	void __fastcall RASPAK_ARM(const int bb,unsigned char STAT,int arm);
	void __fastcall add(int st,int sob,int knl);
	void __fastcall ARM_OUT(void);
	void __fastcall READ_BD(int jb);
	void __fastcall ANALIZ_KVIT_ARM(int arm,int stat);
	void __fastcall MAKE_KOMANDA(int ARM,int STAT,int ray);
	void __fastcall MAKE_MARSH(int ARM,int STAT);
	void __fastcall ANALIZ_ARM(void);
	void __fastcall perevod_strlk(unsigned char command,unsigned int objserv);
	void __fastcall signaly(unsigned char command,unsigned int objserv);
	void __fastcall ZAGRUZ_KOM_UVK(char tms, char grp, char pdgrp, char bt, char kd_cmd);
	int __fastcall ANALIZ_ST_IN_PUT(int nom_tras,int kom,int st,int marsh,int &ind);
	int __fastcall ANALIZ_MARSH(unsigned int KOM,unsigned int NACH,int END,int Nstrel,unsigned long POL);
	char __fastcall check_summ(const char *reg);
	void __fastcall sp_up_and_razd(unsigned char command,unsigned int objserv,int arm);
	void __fastcall puti(unsigned char command,unsigned int objserv);
	void __fastcall dopoln_obj(unsigned char command,int arm);
	void __fastcall prosto_komanda(unsigned char command);
	void __fastcall ob_tums(unsigned char command);
	int __fastcall TUMS_MARSH(int END);

	void __fastcall MAKE_AVTOD(int obj);

	void __fastcall otmena_rm(unsigned int objserv);
	int __fastcall tst_str_ohr(int nom_tras,int kom,int st,int marsh,int &ind);
	void __fastcall sbros_kom(void);
	void __fastcall Edit5DblClick(TObject *Sender);
	void __fastcall PovtorMarsh(int marshrut);
	void __fastcall DeleteMarsh(int marshrut);
	void __fastcall Soob_For_Arm(int nom_mar,int sos);
	void __fastcall Analiz_Glob_Marsh(void);
	void __fastcall Button1Click(TObject *Sender);
	void  __fastcall SosedOutOsn(void);
	void  __fastcall SosedOutRez(void);
	void  __fastcall SosedIn(void);
	void __fastcall Button2Click(TObject *Sender);
	void __fastcall pt1Click(TObject *Sender);
	void __fastcall pt2Click(TObject *Sender);
	void __fastcall TrayIcon112Click(TObject *Sender);
	void __fastcall TimerTryTimer(TObject *Sender);
	void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
	void __fastcall TimerDCTimer(TObject *Sender);
	void __fastcall TimerMainTimer(TObject *Sender);
	void __fastcall ANALIZ_MYTHX(unsigned char PODGR,int ST);
	void __fastcall MARSH_GLOB_LOCAL(void);
	void __fastcall FormActivate(TObject *Sender);
	void __fastcall Serv1ReadPacket(TObject *Sender,BYTE *Packet, int &Size);
	void __fastcall New_For_ARM(unsigned int ii);
	void __fastcall TimerKOKTimer(TObject *Sender);
	void __fastcall ArmPort1DataReceived(TObject *Sender, char *Packet, int Count, int NPAK);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall Edit7Enter(TObject *Sender);
	void __fastcall CommPortOpt1DataReceivedOpt(TObject *Sender, BYTE *Packet, bool Priznak);
	void __fastcall Timer250Timer(TObject *Sender);
	void __fastcall TimerOtladTimer(TObject *Sender);
	void __fastcall Button3Click(TObject *Sender);
	void __fastcall Button4Click(TObject *Sender);
	void __fastcall Button5Click(TObject *Sender);
	void __fastcall Port_DCDataReceived(TObject *Sender, char *Packet, int Count, int NPAK);

 private:	// User declarations
	int N_KOMAND;
	int N_PRIEM;
public:		// User declarations
	AnsiString Put,ArcPut;
	AnsiString TextHintTek,TextHintOld;
	TCom_Port *PORTA,*PORTB;
	unsigned int fixir;
	int STOP_OTVET,Otladka;
	unsigned char DIAGNOZ[3];
	unsigned char NEPAR_OBJ[3];
	unsigned char ERR_PLAT[6];

	struct osn_rez
{
	int ARM[2],SERV[2],UVK1[2],UVK2[2];
}OS_RZ;

	__fastcall TStancia(TComponent* Owner);
};
bool __fastcall SetPrivilege(char* aPrivilegeName, bool aEnabled);
//---------------------------------------------------------------------------
//extern PACKAGE TStancia *Stancia;
extern int __fastcall CalculateCRC16(void *pData, int dataLen);
extern	char __fastcall CalculateCRC8(void *pData, int dataLen);
//---------------------------------------------------------------------------
#endif
