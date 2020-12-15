//---------------------------------------------------------------------------
#include <vcl.h>
#include <time.h>
#include <Registry.hpp>
#include <conio.h>
//#include <stdlib.h>
#include <SysUtils.hpp>
#include <stdio.h>
#include <io.h>
#include <string.h>
#include <fcntl.h>
#include <mmsystem.h>
#include <shlwapi.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <dir.h>
#include <io.h>
#include <Buttons.hpp>
#include <Graphics.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include <Grids.hpp>
#include <sys\stat.h>
#include <ComCtrls.hpp>
#include <ToolWin.hpp>
#include "ssk_srv_rbox.h"
#include "otladka.h"
#include "dat.h"
#pragma hdrstop
#include "ArmPort.h"
#include "CommPortOpt.h"
#include "ServOut.h"
#include "Trayicon.h"
#include "Unit1.h"
#include "Unit2.h"
#include "Unit4.h"
#include "Unit6.h"

//----------------------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ArmPort"
#pragma link "CommPortOpt"
#pragma link "ServOut"
#pragma link "COM_PORT"
#pragma link "CommPort"
#pragma resource "*.dfm"
TStancia *Stancia;

char BUF[2][N_KANAL][BUF_PAKET];     //------------------------------------ ������ �������
char REG[2][N_KANAL][BUF_PAKET+2];   //-------------------------- ��������� ������ �������
char REG_OT[2][N_KANAL][BUF_PAKET+2];
char FIXATOR_KOM[2][15];
int Port_Schet_Com[2],Port_Schet_Takt[2];
struct MARS_ALL MARSHRUT_ALL[Nst*3];
bool stan_cikl,truba_jiva;
unsigned char Timer_Arm_Arm;
AnsiString TODAY,OLDDAY;


//------------------------------------------------------------------------------
__fastcall TStancia::TStancia(TComponent* Owner)
	: TForm(Owner)
{
	unsigned int i,j,k,l,fu,opn_fil,jj;
 	unsigned char konvert_kom[28];
	cikl_marsh = 0;
	POVTOR_OTKR = 0;
	DEL_TRASS_MARSH = 0;
	SERVER = 1;
	KONFIG_ARM =0;
	nom_new = 0;
	povtor_out = 0;
	povtor_fr4 = 0;
	ReBoot = false;


	KOL_STR[0] = 3; //----------------------------------------------- ����� �������� �������
	KOL_SIG[0] = 5; //---------------------------------------------- ����� �������� ��������
	KOL_DOP[0] = 12;//---------------------------------------- ����� �������������� ��������
	KOL_SP[0] = 9; //----------------------------------------------------- ����� �������� ��
	KOL_PUT[0] = 1;//-------------------------------------------------- ����� �������� �����
	KOL_KONT[0]=5; //-------------------------------------------- ����� �������� �����������

	portA = ""; //-------------- ��������� ���������� �������� �� ������ � ��������� �������
	portB = ""; //-------------- ��������� ���������� �������� �� ������ � ��������� �������

	statOSN = 0;
	statREZ = 0;

	const AnsiString KeyName="Software\\DSPRPCTUMS";
	const AnsiString KeyName1="Software\\SHNRPCTUMS";

	Flagi= new TFlagi(Application);
	Tums1= new TTums1(Application);
	Limit = new TLimit(Application);
	Otladka1= new TOtladka1(Application);
	TRegistry *Reg = new TRegistry;
	InitializeCriticalSection(&NOM_PACKET_ZAP);
	FILE *fai;

#if RBOX == 1
	Button4->Visible = false;
	Button5->Visible = false;
#endif

	N_KOMAND=0;
	flag_err=0;
	N_PRIEM=0;
	STOP_ALL=0;
	zagruzka=0;
	RASFASOVKA=0;
	PRIEM=0;
	PODGR_OLD=0;
	for(i=0;i<5;i++)BAITY_OLD[i]=0;
	TIME_OLD=0;

#if (Nst == 2)
#endif

	SOSED_IN = 0;
	char NameTmp[50];
	//=========================================================== ��������� �������� �������

	for(j=0;j<Nst;j++)
	{
		MARSH_VYDAT[j]=0;
		for(i=0;i<N_KANAL;i++)
		{
			for(k=0;k<BUF_PAKET+2;k++)REG[j][i][k]=0;
		}
	}

	try
	{

		Reg->RootKey=HKEY_LOCAL_MACHINE;
		if(Reg->OpenKey(KeyName,false))   //------------------- KeyName="Software\\DSPRPCTUMS"
		{
			if(Reg->ValueExists("path"))Put=Reg->ReadString("path");
			if(Reg->ValueExists("arcpath"))ArcPut=Reg->ReadString("arcpath");
			Reg->RootKey=HKEY_LOCAL_MACHINE;
			ARM_DSP=15;
			ARM_SHN=0;
			Reg->CloseKey();
		}
		else
		{
			if(Reg->OpenKey(KeyName1,false)) //----------------- KeyName1="Software\\SHNRPCTUMS"
			{
				if(Reg->ValueExists("path"))Put=Reg->ReadString("path");
				if(Reg->ValueExists("arcpath"))ArcPut=Reg->ReadString("arcpath");
				Reg->RootKey=HKEY_LOCAL_MACHINE;
				ARM_SHN=15;
				ARM_DSP=0;
				Reg->CloseKey();
			}
		}
	}
	__finally
	{
		delete Reg;
	}
	Otladka1->Show();	Otladka1->Hide();
	Otladka1->Otlad=0;
	TODAY=DateToStr(Date());
	OLDDAY=TODAY;
	DateSeparator = '_';
	NAME_FILE=ArcPut+"\\RESULT\\";
	NAME_FILE = NAME_FILE + FormatDateTime("dd/mm", Now());
	NAME_FILE=NAME_FILE+".ogo";
	strcpy(NameTmp,NAME_FILE.c_str());
	file_arc=open(NameTmp,O_APPEND|O_RDWR,O_BINARY);

	if(file_arc < 0)
	{
		char arxiv[40];
		strcpy(arxiv,ArcPut.c_str());
		strcat(arxiv,"\\RESULT");
		file_arc = mkdir(arxiv);
		file_arc=open(NameTmp,O_CREAT|O_TRUNC|O_APPEND|O_RDWR,S_IWRITE|O_BINARY);
		if(file_arc<0)
		{
			clrscr();
			exit(1);
		}
	}

	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\tranc.svs");
	fai = fopen(NameTmp,"r");
	if(fai==NULL)
	{
		MessageBox(NULL,"�� ���� ������� ���� ","������ � ������ STAN",MB_OK);
		Close();
		exit(0);
	}

	fscanf(fai,"%x",&PRT1);          //-------------------------- ���� ��������� ������ ����
	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&PRT2);      //----------------------------- ���� ���������� ������ ����

	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&PRT3);     //------------------------------------------- ���� ������ ��

	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&PRT4);     //-------------------------------- ���� ������ ������ � ����

#if RBOX == 1
	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&PRT5);     //------------------------- ���� A ������� ��������� �������

	fu=0;
	while(fu!='\n')fu=fgetc(fai);
		fscanf(fai,"%x",&PRT6);     //----------------------- ���� B ������� ��������� �������
#endif

	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&NUM_ARM);     //--------------------------- ����� ���� (�������� �����)

	fclose(fai);

	LIN_PZU = 1;

	for(i=0;i<Nst;i++)
	LIN_PZU=LIN_PZU +KOL_STR[i] +KOL_SIG[i] +KOL_DOP[i] +KOL_SP[i] +KOL_PUT[i] +KOL_KONT[i];

  KOL_VO = LIN_PZU * 5 + 25;

#ifdef KOL_AVTOD
 //--------------------------------------------- ���������� ������� ��������� ������������
	AVTOD= new sp26[KOL_AVTOD];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\avtdst.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &AVTOD[i++],26);
    if(i>=(int)KOL_AVTOD)break;
	} while (!eof(opn_fil));
	close(opn_fil);
#endif

	//---------------------------------------------- ���������� ������� �������� ���� ������
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\bd_osn.bin");
	opn_fil = open(NameTmp,O_BINARY);

  KOL_ARM = KOL_VO;
  KOL_SERV = KOL_VO;

	BD_OSN_BYT = new sp34[210];

	ZeroMemory(BD_OSN_BYT,KOL_VO);
	i=1;
	do
	{ if(i >= KOL_VO)KOL_VO = i;
		read(opn_fil, &BD_OSN_BYT[i++],34);
	} while (!eof(opn_fil));
	close(opn_fil);

	POOO = new long[KOL_VO];
	ZeroMemory(POOO,KOL_VO);

	//------------------------------------------------- ���������� ������� �������� ��������
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\pako.bin");
	opn_fil=open(NameTmp,O_BINARY);
	PAKO= new AnsiString[KOL_VO];
	ZeroMemory(PAKO,KOL_VO);

	i=1;
	char tmp[22];
	do
	{
    if(i > KOL_VO)KOL_VO = i;;
		read(opn_fil,&tmp,22);
		tmp[20]=0;
		tmp[21]=0;
		for(j=0;j<22;j++)if(tmp[j]==0x20)tmp[j]=0;
		PAKO[i++] = tmp;
	} while (!eof(opn_fil));

	close(opn_fil);

	//----------------------------------------------- ���������� ������� ���������� ��������
	j=0;jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_STR[j];
	SPSTR= new sp12[jj];

	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spstr.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPSTR[i++],12);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPSTR[k].byt[i]==0xFF)||(SPSTR[k].byt[i]==0x20))
  {
  	SPSTR[k].byt[i]=0;	SPSTR[k].byt[i+1]=0;
  }

	//----------------------------------------------- ���������� ������� ���������� ��������
	j=0;jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_SIG[j];
	SPSIG= new sp12[jj];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spsig.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPSIG[i++],12);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPSIG[k].byt[i]==0xFF)||(SPSIG[k].byt[i]==0x20))
  {
  	SPSIG[k].byt[i]=0;	SPSIG[k].byt[i+1]=0;
  }

	//------------------------------------------- ���������� ������� �������������� ��������
	j=0;jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_DOP[j];
	SPDOP= new sp12[jj];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spdop.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPDOP[i++],12);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPDOP[k].byt[i]==0xFF)||(SPDOP[k].byt[i]==0x20))
  {
  	SPDOP[k].byt[i]=0; SPDOP[k].byt[i+1]=0;
  }

	//---------------------------------------------- ���������� ������� �������� �����������
	j=0;jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_KONT[j];
	SPKONT= new sp12[jj];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spkon.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPKONT[i++],12);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPKONT[k].byt[i]==0xFF)||(SPKONT[k].byt[i]==0x20))
  {
  	SPKONT[k].byt[i]=0; SPKONT[k].byt[i+1]=0;
  }

	//--------------------------------------------- ���������� ������� �������� ��, �� � ��.
	j=0;jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_SP[j];

	SPSPU= new sp17[jj];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spspu.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPSPU[i++],17);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPSPU[k].byt[i]==0xFF)||(SPSPU[k].byt[i]==0x20))
  {
  	SPSPU[k].byt[i]=0; SPSPU[k].byt[i+1]=0;
  }

	//---------------------------------------------------- ���������� ������� �������� �����
	j=0;	jj=0;
	for(j=0;j<Nst;j++)jj=jj+KOL_PUT[j];
	SPPUT= new sp17[jj];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\spput.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=0;
	do
	{
		read(opn_fil, &SPPUT[i++],17);
		if(i>=jj)break;
	} while (!eof(opn_fil));
	close(opn_fil);
	for(k=0;k<jj;k++)
	for(i=0;i<=8;i=i+2)
	if((SPPUT[k].byt[i]==0xFF)||(SPPUT[k].byt[i]==0x20))
  {
  	SPPUT[k].byt[i]=0; SPPUT[k].byt[i+1]=0;
  }

	unsigned char test[4];
	//---------------------------------------------------- ���������� ������� �������� �����
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\inp.bin");
	opn_fil=open(NameTmp,O_BINARY);

	try
	{
		INP_OB = new sp4[KOL_VO];
		if(!INP_OB)
		{
			ShowMessage("��� ������ ���  INP.bin");
			exit(-1);
		}
		else ZeroMemory(INP_OB,KOL_VO);
	}
	catch(...)
	{
		ShowMessage("��� ������ ���  INP.bin");
		exit(-1);
	}

	i=1;
	do
	{
		l = read(opn_fil, &INP_OB[i++],4);
		if(i>=KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

	//--------------------------------------------------- ���������� ������� �������� ������
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\out.bin");
	opn_fil=open(NameTmp,O_BINARY);

	OUT_OB = new sp4[KOL_VO];

	if(!OUT_OB)
	{
		ShowMessage("��� ������ ���  OUT.bin");
		exit(-1);
	}
	else ZeroMemory(OUT_OB,KOL_VO);

	i=1;
	do
	{
		l = read(opn_fil, &OUT_OB[i++],4);
    if(l < 4)break;
    if(i >= KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

  KOL_OUT = i-1; //-------------------------------------- ����� �������� ��� ������� � ���

 	//--------------------------------------------------------------- ���������� ������� FR3

	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\fr3.bin");
	opn_fil=open(NameTmp,O_BINARY);

	FR3 = new sp34[KOL_VO];
	ZeroMemory(FR3,KOL_VO);

	i=1;
	do
	{
		read(opn_fil, &FR3[i++],34);
    if(i>=KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

	for(i=1;i<KOL_VO;i++)
	{
		for(j=0;j<34;j++)if(FR3[i].byt[j]==32)FR3[i].byt[j]=0;
	}
	PEREDACHA = new unsigned char[KOL_VO << 1];

	PRIEM = new unsigned char[KOL_VO];
	ZeroMemory(PRIEM,KOL_VO);

	FR4 = new unsigned char[KOL_VO + 1];
	ZeroMemory(FR4,KOL_VO + 1);

	ZAFIX_FR4= new unsigned char[KOL_VO + 1];
	ZeroMemory(ZAFIX_FR4,KOL_VO +1);

  for(i=0;i<10;i++) NOVIZNA_FR4[i] = 0;

	FillMemory(&TRASSA,sizeof(TRASSA),0);
	ZeroMemory(NOVIZNA,KOL_NEW);

	povtor_novizna = 0;
	SVAZ=0;
	for(i=0;i<Nst;i++)
	{
		for(j=0;j<3;j++)
		{
			MARSHRUT_ST[i][j] = new struct MARS_ST;
			FillMemory(MARSHRUT_ST[i][j],sizeof(MARS_ST),0);
			FillMemory(&MARSHRUT_ALL[(i+1)*j],sizeof(MARSHRUT_ALL[(i+1)*j]),0);

		}
  }
  Application->RestoreTopMosts();
	FillMemory(&TRASSA,sizeof(TRASSA),0);

	//-------------------------------  ������������� ���������� ��� ������ � ������ ���/���.
	STATUS=0;  SHN=0;  CIKL=0;
  StatusAndKOK[0] = 0xFF;
  StatusAndKOK[1] = 0xF;
  StatusAndKOK[2] = 0;

	// DC_PORT->ComNumber=PRT3;
	// DC_PORT->Open();
#ifdef  DC_COM
  if(PRT3!=0) //-------------------------------------------- ���� ���������� �� �� �������
  {
  	Port_DC->ComNumber = PRT3;
    for(k = 0; k<Nst; k++)
    {
    	for(i = 0; i <30; i++)
    	{
      	noviznaDC[k*30+i] = 0;
      	peredalDC[k*30+i] = 0;
      	priniatoDC[k*30+i] = 0;
    		for(j = 0; j < 11; j++)VVOD_DC[k*30+i][j] = 0x40;
    	}
    	ukaz_DC[k] = 0;

    }
    strcpy(NameTmp,Put.c_str());
		strcat(NameTmp,"dat\\OUTDC.str"); //------------------- ���� � ��������� ������ ������
		opn_fil = open(NameTmp,O_BINARY);
   	i=0;

    //----------------------------------------- �������� ������� �������� ��������� ��� ��
		do
		{
			read(opn_fil, &konvert_kom,13);
      for(j=0;j<11;j++)VVOD_DC[i][j] = konvert_kom[j];
      i++;
    } while (!eof(opn_fil));
   	close(opn_fil);


		strcpy(NameTmp,Put.c_str());
		strcat(NameTmp,"dat\\COMDC.str"); //------------------------------ ���� � ��������� ��
		opn_fil = open(NameTmp,O_BINARY);
		i=0;

    //--------------- �������� ������� ����������� ������ �� � ���������� ����������� ����
		do
		{
			read(opn_fil, &konvert_kom,28);
      for(j=0;j<11;j++)KOMANDA_DC[i].Com_DC[j] = konvert_kom[j];
      for(j=11;j<23;j++)KOMANDA_DC[i].Com_ARM[j-11] = konvert_kom[j];
      KOMANDA_DC[i].Otv = konvert_kom[24];
      KOMANDA_DC[i].KS_DC = CalculateCRC8(&konvert_kom[0],11);
			KOMANDA_DC[i].KS_ARM = CalculateCRC8(&konvert_kom[11],12);
      i++;
 			if(i >= DC_COM)break;
		} while (!eof(opn_fil));
   	close(opn_fil);

    strcpy(NameTmp,Put.c_str());
		strcat(NameTmp,"dat\\CONVTS.str"); //------------------ ���� ����������� ������ ������
    fai = fopen(NameTmp,"r");
    i = 0;
    int a1,a2,a3,a4,a5;
    //--------------------------------------------- �������� ������� ����������� ���������
		for(k = 0; k<30; k++)
    for(i = 0; i <5; i++)
    for(j = 0; j <5; j++)
		fscanf(fai, "%d" , &OUT_DC[k].paramDC[i][j]);
   	fclose(fai);
  }
  #endif

	FIXIR_TIME = 0;
	CommPortOpt1->ComNumber = PRT1;
	if(PRT4!=0) ArmPort1->ComNumber = PRT4;
	byla_trb = 0; //--------------------------- ���������� ��������� ������� ��������� �����
}
//========================================================================================
//--------------------------------------------- ������ � �������, ��������� �� ������ ����
//========================================================================================
//----  ������ ��������� ��������� ������ ����� � ���������� �� ������, �������� �� ������
//--------------------------------------------------------- PODGR - ���� � ������� � MYTHX
//------------------------------------------ ST - ����� ������, �� ������� �������� ������
void __fastcall TStancia::ANALIZ_MYTHX(unsigned char PODGR,int ST)
{
	int svoi, s_m, nom, ik, ob_str, ijk;
	unsigned int tum;
	char sym_myt;
	unsigned char prov;

	if(((PODGR<0x59)||(PODGR>0x7C))&&(PODGR!=0x6E))return;//���� �� MYTHX, � ���������,�����

	svoi = 0;

	tum = ST;

	switch(MYTHX_TEC[tum])	//----------- ������������� �� ��������, ������������ ��� ������
	{
		case 0x50: //------ ���� ��������� ������ �������, � ������ �������� � ������, �� ����
			if((PODGR&0xf) == 0x9){svoi = 0xf; break;}

		case 0x60: //------- ���� ��������� ������ ������� � ������ �������� � ������, �� ����
			if((PODGR&0xf) == 0xA){svoi = 0xf; break;}

		case 0x70:	//------------- ���� ��������� ������ � ������ �������� � �������, �� ����
				if((PODGR&0xf) == 0xC){svoi = 0xf;break;}

		 case 0x6e:
		 case 0:	svoi = 0xf;break; // ������ ������ ������, ���	����� ������ ���,����� = ����
#ifdef DETSK
		 case 0x40: svoi = 0xf; break;
#endif
		 default: break;	//---------------------- ���� ���-�� ������, �� �� �������� ��������
	}

	if(svoi != 0) //-------------------------------------------------------------- ���� ����
	{
		if(MYTHX[tum] != PODGR)	//--------------------------------------- ���� ��������� MYTHX
		MARSH_VYDAT[tum] = 0;  //------------ ������� ���������, ������� ����� ������� �������

		for(s_m=0; s_m<MARS_STOY; s_m++)  //------------------ ������ �� ���� ��������� ������
		{	//-------------------------- �������� MYTHX �� ��������� � �������� �� MYTHX �������
			//------------------------------------ � 12 ����� ����� MYTHX, � ������� ��� �������
			//----------------- � ��������� � ������� ��������� ����� MYTHX, ����������� � �����
			//------------------------------------------------- 0x59 - 1-�� ����� � 1-� � ������
			//------------------------------------------------ 0x6A - 2-�� ����� � 2-�� � ������
			//------------------------------------------------ 0x7c - 3-�� ����� � 3-�� � ������
			prov = MARSHRUT_ST[tum][s_m]->NEXT_KOM[12] | (PODGR&0xf);

			//------------------------ ���� MYTHX ������ ������������� ��������� ����� � �������
			if((prov == 0x59) || (prov == 0x6A) || (prov == 0x7C))
			{
				switch(PODGR&0xF0)
				{
						//--------- ������� � ������, ���������� ��������� ���������� � ������ �������
					case 0x70:
						MARSHRUT_ST[tum][s_m]->SOST = (MARSHRUT_ST[tum][s_m]->SOST & 0xC0) | 0x1f;
						for(ijk=0;ijk<15;ijk++)KOMANDA_TUMS[tum][ijk]=0;
						TUMS_RABOT[tum] = 0xf; //---------------------- ��������� ���� "���� � ������"
						break;

						//------------------------------------- ��������� ��������� ��������� ��������
					case 0x50:
						MARSHRUT_ST[tum][s_m]->SOST = 0x1; //---------------------- ���������� �������
						for(ijk=0;ijk<15;ijk++)KOMANDA_TUMS[tum][ijk]=0; //---------- �������� �������
						TUMS_RABOT[tum] = 0;  //-------------------------- ������ ���� "���� � ������"
						break;

						//--------------------------------------- ������� ��������� ��������� ��������
					case 0x60:
						MARSHRUT_ST[tum][s_m]->SOST = (MARSHRUT_ST[tum][s_m]->SOST&0xC0) | 0x1f;
						for(ijk=0;ijk<15;ijk++)KOMANDA_TUMS[tum][ijk]=0;
						TUMS_RABOT[tum] = 0; //������ ���� "���� � ������"
						break;
					default: break;
				}
				break; //------------------------------- �������� ���� ������� �� ��������� ������
		}
		else //--------------------------------- ���� MYTHX �� ������������� �������� ��������
		{
				switch(PODGR&0xF0)
				{
					case 0x70: TUMS_RABOT[tum] = 0xf; break; //----------------------- ������ ������
					case 0x50: TUMS_RABOT[tum] = 0; break;
					case 0x60: TUMS_RABOT[tum] = 0; break;
					default: break;
				}
				if(PODGR == 0x6e)TUMS_RABOT[tum] = 0; //------------------- ������ ���������������
			}
		}
	}
	if(svoi != 0)MYTHX[tum] = PODGR;	//-------------- ���� ��� ���� MYTHX, �� ��������� ���
	if(MYTHX[tum] == 0)MYTHX[tum] = PODGR; //---------- ���� ������ �����, �� ���� ���������
	return;
}

//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::MARSH_GLOB_LOCAL(void)
{
	int i_s,s_m,ii,kk;
	unsigned char sum;
	for(i_s=0; i_s<Nst; i_s++)	//--------------------------- ������ �� ���� ������� �������
	{
		if(TUMS_RABOT[i_s]!=0) continue; //------------ ���� ������ � ������, �� ���������� �

		if((KOMANDA_TUMS[i_s][10]!=0)&&(POVTOR_OTKR==0))continue;//���� ����� ���������������� �������, ����������

		for(s_m=0;s_m<MARS_STOY;s_m++)//--------- ������ �� ������� ��������� ��������� ������
		{
			//���� i_s ����� �������  � ������ s_m ���������� ���������,��� ��� �� ������ � ����
			if((MARSHRUT_ST[i_s][s_m]->NEXT_KOM[0]!=0) && (  MARSHRUT_ST[i_s][s_m]->T_VYD == 0))
			{
				//---------------------------------- ���� ��������� �������� "������ �� ���������"
				if((MARSHRUT_ST[i_s][s_m]->SOST&0xF) == 0x7)
				{  //-------------- ��������� ������� ��� ����, ���������� ������� ������ ��������
					for(kk=0;kk<12;kk++)KOMANDA_TUMS[i_s][kk] = MARSHRUT_ST[i_s][s_m]->NEXT_KOM[kk];

					switch(MYTHX_TEC[i_s])//������� � ������� ������� Mythx � ������������ � �������
					{
						case 0x50:	MYTHX_TEC[i_s] = 0x60; break; //------------------- ������� 1 -> 2
						case 0x60:	MYTHX_TEC[i_s] = 0x70; break; //------------------- ������� 2 -> 3
						case 0:
						case 0x6e:
						case 0x70:	MYTHX_TEC[i_s] = 0x50; break; //-------------- ������� 0,n,3  -> 1
						default:	break; //------------------------------------- ����� �������� ������
					}

					KOMANDA_TUMS[i_s][7] = KOMANDA_TUMS[i_s][7]|MYTHX_TEC[i_s];
					sum = 0; for(kk=1;kk<10;kk++)sum = sum^KOMANDA_TUMS[i_s][kk];  sum = sum | 0x40;
					KOMANDA_TUMS[i_s][10] = sum;
					add(i_s,9999,0); //------------------------------------ �������� ������� � �����
					SM_TUMS[i_s] = s_m; //---------------------------------- ������ ������ ���������
					MARSHRUT_ST[i_s][s_m]->NEXT_KOM[12] = MYTHX_TEC[i_s]; //-------- ��������� MYTHX

					kk = MARSHRUT_ST[i_s][s_m]->NUM - 100;
					kk = MARSHRUT_ALL[kk].KOL_STR[i_s] * 20 + 20;
					MARSHRUT_ST[i_s][s_m]->T_MAX = kk;
					TUMS_RABOT[i_s] = 0xf;
					MARSH_VYDAT[i_s]=0xf;
				}
			}
		}
	}
}
//========================================================================================
//-------------------------------------------------- ��������� ������� ������� �����������
//--------------------------------------------------------- st -  ������ ������(0,1,2....)
//--------------------------------------------------------- kan - ����� ������ (0,1)
int __fastcall TStancia::diagnoze(int st,int kan)
{
	int nom_serv,strk,error_diag=0,i;
	unsigned char gru,podgru,nm[15],NOM_ARM[2],bt,kod;
	while(error_diag!=-1)
	{
		if((st<0)||(st>7))error_diag=-1;
		if(kan==0)
		{
			gru = REG[st][0][4];
			podgru = REG[st][0][5];
			bt = REG[st][0][6]&0xf;
			kod = REG[st][0][7];
		}
		else
		if(kan==1)
		{
			gru = REG[st][0][4];
			podgru = REG[st][0][5];
			bt = REG[st][0][6]&0xf;
			kod = REG[st][0][7];
		}
		strk = TAKE_STROKA(gru,podgru-48,st);
		if(strk < 0) error_diag = -1;
    else
    {
			//--------------------------------------------------------- ���������� ������� �������
			switch(gru)
			{
			case 'E': for(i = 0; i < 10; i++) nm[i] = SPSIG[strk].byt[i]; break;
			case 'F': for(i = 0; i < 15; i++) nm[i] = SPSPU[strk].byt[i]; break;
			case 'I': for(i = 0; i < 15; i++) nm[i] = SPPUT[strk].byt[i]; break;
			default: error_diag = -1; break;
			}
			nom_serv = nm[bt*2] * 256 + nm[bt*2+1];
			if(nom_serv > (int)KOL_VO)error_diag = -1;
  	  else
    	{
				//--------------------------------------------------------- ���������� ������� �����
				for(i = 0; i < 2; i++)NOM_ARM[i] = OUT_OB[nom_serv].byt[i];
				DIAGNOZ[0] = NOM_ARM[1];
				DIAGNOZ[1] = NOM_ARM[0]|0x20;
				switch(kod)
				{
					case 'P': DIAGNOZ[2] = 1; break;
					case 'Z': DIAGNOZ[2] = 1; break;
					case 'S': DIAGNOZ[2] = 2; break;
					case 'T': DIAGNOZ[2] = 4; break;
					default: error_diag = -1; break;
				}
				break;
    	}
		}
  }
	return(error_diag);
}
//========================================================================================
//---------------------------------------------- �������� ��������� ���� �����/������ ����
int __fastcall TStancia::test_plat(int st,int kan)
{
	int i;
	unsigned char podgr, kod, plata, baity[5];
	unsigned int bits = 0;

	if((st < 0) || (st > Nst)) return(0);//������������ � ������, ������ ���� �� �����������

	if((kan < 0 )||( kan > 1 ))return(0);//������������ � ������, ������ ���� �� �����������
  else
	{
		podgr = REG[st][kan][3];
		for(i = 0; i < 5; i++)baity[i] = REG[st][kan][4+i];
  }

	if(podgr == PODGR_OLD) //----------------------- ���� �� �� ����� ���������, ��� � �����
  {
		for(i=0;i<5;i++) if(baity[i] != BAITY_OLD[i])break; //------ ���� ������� ������ �����

		if(i < 5) //---------------------------------------- ���� ���� �������� ������ �������
		{
			for(i = 0; i < 5; i++)BAITY_OLD[i] = baity[i]; //------- ������������ ������� ������
			TIME_OLD = time(NULL); //-----------------------------  �������� ��� ������� �������
			return(0);
		}
	}
	else //---------------------------------- ���� ��������� �������� �� ����� �������������
	{
		PODGR_OLD = podgr; //--------------------------------------------- ��������� ���������
		for(i = 0; i<5; i++) BAITY_OLD[i] = baity[i]; //---------- ��������� ���������� ������
		TIME_OLD = time(NULL); //--------------------------------------------- ��������� �����
		return(0);
	}

  switch(podgr)
  {
		case 'p': kod=1; plata=1;   //-------------------------------------- ����������� �����
    					for(i=0;i<3;i++)bits=bits|((baity[i]&0x1f)<<(i*5));
              break;
		case 'q': kod=2; plata=1;  //--------------------------------------------- ����� �����
							for(i=0;i<3;i++)bits=bits|((baity[i]&0x1f)<<(i*5));
							break;
		case 'r': kod=3; plata=9;    //--------------------------------- ���������� 0 � �201-1
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 's': kod=3; plata=10;   //--------------------------------- ���������� 0 � �201-2
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 't': kod=3; plata=11;   //--------------------------------- ���������� 0 � �201-3
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 'u': kod=3; plata=12;   //--------------------------------- ���������� 0 � �201-4
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 'v': kod=4; plata=9;  //----------------------------------- ���������� 1 � M201-1
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 'w': kod=4; plata=10; //----------------------------------- ���������� 1 � M201-2
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		case 'x': kod=4; plata=11;  //---------------------------------- ���������� 1 � M201-3
							for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
							break;
		default: return(0);
	}

	ERR_PLAT[0]=0;
	ERR_PLAT[1]=0x14;

	ERR_PLAT[5]=((st+1)&0xf)<<4;
	ERR_PLAT[5]=ERR_PLAT[5]|(((KORZINA[st]+1)&3)<<2);
	ERR_PLAT[5]=ERR_PLAT[5] | ( (plata&0xc)>>2 );

	ERR_PLAT[4]=(plata&0x3)<<6;
	ERR_PLAT[4]=ERR_PLAT[4] | (kod&0x3f);

	ERR_PLAT[2]=bits&0xFF;
	ERR_PLAT[3]=(bits&0xFF00)>>8;

	return(1);
}

//========================================================================================
//-- ��������� ����������� ������ ������, ���������� ������ �������� ��� ��������� �� ����
//------------------------------------------------------------ GRPP - ��� ������ ���������
//------------------------------------------------------------------- sb - ����� ���������
//--------------------------------------------------------------------- tms - ����� ������
int __fastcall TStancia::TAKE_STROKA(unsigned char GRPP,int sb,int tms)
{
	int j,STRK=0;
	switch(GRPP) //-------------------------------------- ������������� �� ������� ���������
	{ //-------------------------------------------------------------- ��������� �� ��������
		case 'C': for(j=0;j<tms;j++)STRK=STRK+KOL_STR[j];
							STRK=STRK+sb;
							break;
		case 'E': for(j=0;j<tms;j++)STRK=STRK+KOL_SIG[j];
							STRK=STRK+sb-KOL_STR[tms];
							break;
		case 'Q': for(j=0;j<tms;j++)STRK=STRK+KOL_DOP[j];
							STRK=STRK+sb-KOL_STR[tms]-KOL_SIG[tms];
							break;
		case 'F': for(j=0;j<tms;j++)STRK=STRK+KOL_SP[j];
							STRK=STRK+sb-KOL_STR[tms]-KOL_SIG[tms]-KOL_DOP[tms];
							break;
		case 'I': for(j=0;j<tms;j++)STRK=STRK+KOL_PUT[j];
							STRK=STRK+sb-KOL_STR[tms]-KOL_SIG[tms]-KOL_DOP[tms]-KOL_SP[tms];
							break;
		case 'L': for(j=0;j<tms;j++)STRK=STRK+KOL_KONT[j];
							STRK=STRK+sb-KOL_STR[tms]-KOL_SIG[tms]-KOL_DOP[tms]-KOL_SP[tms]-KOL_PUT[tms];
							break;
		default: return(-1);
	}
	return(STRK);
}
//========================================================================================
//--------------------------- ��������� ���������� ��������� ������� FR3 ��������� �������
//---------------------------------- GRP - ��� ������ �������� ������ --------------------
//--------------------------------- STRKA - ������ � ������ ������� �������� ������ ������
//---------------------------------- sob - ����� ��������� ��������� ---------------------
//---------------------------------- tum - ����� ������ ----------------------------------
//---------------------------------- nov - ������� ������� ������ ��������� --------------
void __fastcall TStancia::ZAPOLNI_FR3(unsigned char GRP,int STRKA,int sob,unsigned char tum,char nov)
{
	unsigned int kk,nn,i,jj,j,num[15],ii,ij,sgnl=0,i_m,i_s,i_sig;
	unsigned int str_lev=0,str_prav=0,sp_lev=0,sp_prav=0,koryto=0;
	unsigned char nom[15],l,maska,tester;
	try
	{
		for(i=0;i<15;i++){num[i]=nom[i]=0;}
//		if(nov==0)return;
		//��� ������ GRP � ������ STRKA ����� ������ �������� �������
		switch(GRP)
		{
			case 'C':
				for(i=0;i<5;i++)num[i]=SPSTR[STRKA].byt[i*2]*256+SPSTR[STRKA].byt[i*2+1];
				break;
			case 'E':
				for(i=0;i<5;i++)num[i]=SPSIG[STRKA].byt[i*2]*256+SPSIG[STRKA].byt[i*2+1];
				break;
			case 'Q':
				for(i=0;i<5;i++)num[i]=SPDOP[STRKA].byt[i*2]*256+SPDOP[STRKA].byt[i*2+1];
				break;
			case 'F': sgnl=0;
				for(i=0;i<5;i++)num[i]=SPSPU[STRKA].byt[i*2]*256+SPSPU[STRKA].byt[i*2+1];
				break;
			case 'I':
				for(i=0;i<5;i++)num[i]=SPPUT[STRKA].byt[i*2]*256+SPPUT[STRKA].byt[i*2+1];
				break;
			case 'L':
				for(i=0;i<5;i++)num[i]=SPKONT[STRKA].byt[i*2]*256+SPKONT[STRKA].byt[i*2+1];
				break;
			case 'J': break;
			default: 	return;
		}

//------------------------------- ������������ ������ ������� �������� ��� �������� ������
//---------------------------------------- for(i=0;i<5;i++)num[i]=nom[i*2]*256+nom[i*2+1];
//--------------------------------------------- ������ �� ���� �������� �� ������� �������
		for(i=0;i<5;i++) //������ �� ���� �������� ���������
		{ if((num[i] >= KOL_VO) || (num[i] <= 0))continue;//������ ���������, ������ �� ������
			j=0;

			jj=num[i];
			if(GRP == 'F')
			{
				koryto = 0;
				READ_BD(jj);
				if((BD_OSN[0] == 3)&&(BD_OSN[3]!=0)) //-------------------------- ���� �� � ������
				{
					str_lev = (BD_OSN[3]&0xff00)>>8;		str_prav = BD_OSN[3]&0xff;

					READ_BD(str_lev); sp_lev = (BD_OSN[6]&0xFF00)>>8;

					READ_BD(str_prav); sp_prav =(BD_OSN[6]&0xFF00)>>8;

					if (jj == sp_prav) break;  //------------------------ ������ �� ������ ���������

					//-------------------------------------------�������� ������ �� ��������� ������
					if((FR3[sp_lev].byt[24])||(FR3[sp_lev].byt[25])) //- ���� �� � �����-�� ��������
					FR3[sp_lev].byt[24]=FR3[sp_lev].byt[24]|0x80; //--- ���������� �������� �� �����

					if((FR3[sp_prav].byt[24])||(FR3[sp_prav].byt[25])) //- ���� �� ������ � ��������
					FR3[sp_prav].byt[24]=FR3[sp_prav].byt[24]|0x80; //---------- ���������� ��������

					koryto = 0;
					if (FR3[str_lev].byt[1]) koryto = koryto|1; //------- ���� ����� ������� � �����
					if(FR3[str_lev].byt[3]) koryto = koryto|2; //--------------- ���� ����� � ������
					if(FR3[str_prav].byt[1]) koryto = koryto|4; //-------------- ���� ������ � �����
					if(FR3[str_prav].byt[3]) koryto = koryto|8; //------------- ���� ������ � ������
			 }
			}
			for(j=0;j<6;j++) //----------------------- ������ ������� �� ������ �������� �� ����
			{
				l=1<<j;//--------------------------------------------------- ������������ ���� ���
				FR3[jj].byt[j*2]=0;
			 //----------------------------- �������� ��������� � ������������ � ������� �� ���Ѡ
				if((VVOD[tum][sob][i]&l))//---------------------------------- ���� ��� ������� � 1
				{
					if(GRP=='E') //----------------------------------------------------- ���� ������
					{
            READ_BD(jj);
            if((BD_OSN[2] < 2) && (j<4)) //------ ���� ��� ������ � ���������� ���� ��� ��
						{
              kk = jj;
             /*
              while(1)
              {
              	nn = ((FR3[kk].byt[20]&0x7f)*256 + FR3[kk].byt[21]);
                FR3[kk].byt[13] = 0;
                FR3[kk].byt[15] = 0;
                FR3[kk].byt[20] = 0;
                FR3[kk].byt[21] = 0;
                if(nn == 0)break;
                kk = nn;
              }*/
							for(i_m=0;i_m<Nst*3;i_m++) //----------- ������ �� ���� ���������� ���������
							{
								if(MARSHRUT_ALL[i_m].KMND==0)continue;
								i_sig=0; //--------------- ���������� �������, ��� � �������� ��� ��������
								for(i_s=0;i_s<Nst;i_s++)//---------- ������ �� ���� ������� ����� ��������
								{
									if(MARSHRUT_ALL[i_m].SIG[i_s][0]==0)continue;
									if(MARSHRUT_ALL[i_m].SIG[i_s][0]==jj)continue;
									else i_sig++;
								}
								//----------- ���� ������� ��������� ��� � ������� ���������� ��� ��������
								//-------------- � ������� ���������, �� ������� ������� �� �������� �����
								//--------------------------------------------------- ��� �� �� ����������
								if((i_sig==0)&&((MARSHRUT_ALL[i_m].SOST&0x1F)==0x1F))
								{
									add(i_m,8888,11);
									DeleteMarsh(i_m);
								}
							}
						}
					}
					if(GRP=='I')//-------------------------------------------------------- ���� ����
					{
						if((j==1)||(j==2)||(j==4))//------------------------------- ���� ��, �� ��� ��
						{
							FR3[jj].byt[13]=0; //--------------------------------------- ����� ���������
							//-------------------------------------- �������� ������ �� ��������� ������
							if((FR3[jj].byt[24])||(FR3[jj].byt[25]))FR3[jj].byt[24]=FR3[jj].byt[24]|0x80;
							READ_BD(jj);
							if(BD_OSN[1]!=0)
							{
								ii=BD_OSN[1];
								FR3[ii].byt[13]=0; //------------------------------------- ����� ���������
								//------------------------------------ �������� ������ �� ��������� ������
								if((FR3[ii].byt[24])||(FR3[ii].byt[25]))FR3[ii].byt[24]=FR3[ii].byt[24]|0x80;
								FR3[ii].byt[27]=0;FR3[ii].byt[26]=FR3[ii].byt[26]|0xE0;//- ������� �������
								New_For_ARM(ii);
							}
						}
					}
					//--------------------------------------------------------------- ���� �� ��� ��
					if((GRP == 'F') && (STATUS == 0))FR3[jj].byt[13]=0;
					if((GRP=='F')&&((j==1)||(j==4))) //----------------------- ���� ��������� ��� ��
					{
						switch(koryto)
						{ //------------------- ����� ��������������� ���������, ��� ��� ���� ��������
							case 6:		FR3[sp_lev].byt[13]=0; break; //--- ����� � ������, ����� ����� ��
							case 9:		FR3[sp_prav].byt[13]=0;break; //--������ � ������, ����� ������ ��
							default:	FR3[sp_lev].byt[13]=0; FR3[sp_prav].byt[13]=0; //- ����� ���������
						}
						New_For_ARM(sp_lev); New_For_ARM(sp_prav);
						FR3[jj].byt[13]=0; //----------------------------------------- ����� ���������

						//---------------------------------------- �������� ������ �� ��������� ������
						if((FR3[jj].byt[24])||(FR3[jj].byt[25]))FR3[jj].byt[24]=FR3[jj].byt[24]|0x80;
						if((tum+1)==(nom[10+i]&0xf)) FR3[jj].byt[17]=FR3[jj].byt[17]|l; //- ����������

						//---------------------------------------------- ���� ������� �� ������ ������
						if((unsigned int)(tum+1) == ((num[10+i]&0xf0)>>4))
						FR3[jj].byt[16] = FR3[jj].byt[16]|1;

						//----------------- �������� ������ ������� ������ �������� � ������ ���������
						sgnl=FR3[jj].byt[24]*256+FR3[jj].byt[25];
						READ_BD(jj);
						if((BD_OSN[0]==4)&&(BD_OSN[1]!=0)) //---------------- ���� �� � � ���� �������
						{
							ii = BD_OSN[1];
							FR3[ii].byt[13] = 0;
							//---------------------- ���������� ��� ������� ������� ���������� ���������
							if(FR3[ii].byt[24]||FR3[ii].byt[25])FR3[ii].byt[24] = FR3[ii].byt[24]|0x80;
							FR3[ii].byt[27] = 0;
							FR3[ii].byt[26] = FR3[ii].byt[26]|0xE0; //------- ���������� ������� �������
							New_For_ARM(ii);
						}
					}
					switch(koryto)
					{
						case 6:
							FR3[sp_lev].byt[j*2+1]=1;
							New_For_ARM(sp_lev);
							New_For_ARM(sp_prav);
							break;
						case 9:
							FR3[sp_prav].byt[j*2+1]=1;
							New_For_ARM(sp_lev);
							New_For_ARM(sp_prav);
							break;
						case 0:
							FR3[jj].byt[j*2+1]=1;//------------------------- ��� ������ ���������� �����
							New_For_ARM(jj);
							break;
						default:
							FR3[sp_lev].byt[j*2+1]=1;//-------------------------------------- ����������
							FR3[sp_prav].byt[j*2+1]=1;//------------------------------------- ����������
							New_For_ARM(sp_lev);
							New_For_ARM(sp_prav);
					}
					if(GRP=='C') //------------------------------------------- ���� ������ - �������
					{
						READ_BD(jj);
						if(BD_OSN[12]!=9999)//----------------------------------------- ���� ���������
						{
							if(BD_OSN[12]==1)//------------------------------------------- ���� ��������
							{
								ii=BD_OSN[8]&0xFFF; //------------------------------ �������� ����� ������
								FR3[ii].byt[j*2+1] = 1;
							}
						}
            if(j==3) //--------------------------------------------- ������� �� ����������
						{
							i_m = 0;
							for(i_m=0;i_m<Nst*3;i_m++)
							{
								i_s = 0;
								for(i_s=0;i_s<10;i_s++)
								{
									if(((MARSHRUT_ALL[i_m].STREL[tum][i_s]&0xfff) == jj)
                  || ((MARSHRUT_ALL[i_m].STREL[tum][i_s]&0xfff) == ii))
									{
                  	for(ij=0;ii<3;ij++)KVIT_ARMu[ij]=0;
										ij = MARSHRUT_ALL[i_m].NACH; //---- ������ ������� ������ ��������
										KVIT_ARMu[0]=OUT_OB[ij].byt[1]; //- �������� � ����� ����� ��� DSP
										KVIT_ARMu[1]=OUT_OB[ij].byt[0]|0x40;
										KVIT_ARMu[2] = 3;
										add(i_m,8888,12);
										DeleteMarsh(i_m);
                  }
                }
							}
            }
					}
				}
				else //------------------------------------------------------ ���� ��� ������� � 0
				{
					switch(koryto)
					{
						case 6:
							FR3[sp_lev].byt[j*2+1]=0;
							FR3[sp_prav].byt[j*2+1]=0;
							New_For_ARM(sp_lev);
							New_For_ARM(sp_prav);
							break;
						case 9:
							FR3[sp_prav].byt[j*2+1]=0;
							FR3[sp_lev].byt[j*2+1]=0;
							New_For_ARM(sp_lev);
							New_For_ARM(sp_prav);
						break;

						case 0: FR3[jj].byt[j*2+1]=0;//--------------------- ��� ������ �������� �����
							New_For_ARM(jj);
							break;
						default:  if(sp_lev!=0)
											{
												FR3[sp_lev].byt[j*2+1]=0; //----------------------------- ��������
												FR3[sp_prav].byt[j*2+1]=0; //---------------------------- ��������
												New_For_ARM(sp_lev);
												New_For_ARM(sp_prav);
											}
											else
											{
												New_For_ARM(jj);
											}
					}
					if((FR3[69].byt[0]==0) && (FR3[69].byt[1]==0))
					tester = 0;

					if((GRP == 'F') && (j == 1)) //---------------------------- ���� �� ������������
					{
						if((FR3[jj].byt[24]&0x80)!=0) //-- ���� ����� ������������� �������� ���������
						{
							sgnl = (FR3[jj].byt[24]&0x7f)*256 + FR3[jj].byt[25];
							FR3[jj].byt[24] = 0; FR3[jj].byt[25] = 0; //---- �������� ����� ������� � ��
              FR3[sgnl].byt[13] = 0;
              FR3[sgnl].byt[15] = 0;
						}
						if(sp_prav!=0)
						if((FR3[sp_prav].byt[24]&0x80)!=0) //���� ��� ������������� �������� ���������
						{
							sgnl = (FR3[sp_prav].byt[24]&0x7f)*256 + FR3[sp_prav].byt[25];
							FR3[sp_prav].byt[24] = 0; FR3[sp_prav].byt[25] = 0;//�������� � ������� � ��
						}
					}
					else
					if(GRP=='C') //------------------------------------------- ���� ������ - �������
					{
						READ_BD(jj);
						if(BD_OSN[12]!=9999)//----------------------------------------- ���� ���������
						{
							if(BD_OSN[12]==1)//------------------------------------------- ���� ��������
							{
								ii=BD_OSN[8]&0xFFF; //------------------------------ �������� ����� ������
								FR3[ii].byt[j*2+1]=0;
							}
						}
					}
				}
			}
			FR3[jj].byt[27]=0;
			FR3[jj].byt[26]=FR3[jj].byt[26]|0XE0; //----------------- ���������� ������� �������
			if(GRP == 'L') //--------------------------------------- ���� ��� ������ �����������
			{
				READ_BD(num[i]);
				if((BD_OSN[0]&0xff00)==0x400)//------------------------- ���� ���� ������ ����� ��
				{
					tester=0;
					for(j=0;j<5;j++)tester =tester + (FR3[num[i]].byt[j*2+1]<<j);//��������� �������
					if((tester>7)&&(tester<11))PROCESS=0x40; //-- ���� � �����, �� ���������� �� ���
					else PROCESS=0; //----------------------------------- ����� ���������� �� ������
          if(tester == 0xA)Upr_DC = true;
          else Upr_DC = false;
				}
				if(BD_OSN[0]==0x38F) //---------------------------- ���� ���� ������ �������� PAMX
				{
					if(FR3[num[i]].byt[5] != FR3[num[i]].byt[7]) SVAZ = SVAZ | 0x80;
					else SVAZ = SVAZ & 0x7F;
					KOK_OT_TUMS = FR3[num[i]].byt[5];// ������ ��� = ��������� ������ �� �� ������ 1
					KOK_OT_TUMS = KOK_OT_TUMS | FR3[num[i]].byt[7];//4�� ���, ��������� ��� ������ 2
					KNOPKA_OK_N = FR3[num[i]].byt[5] + FR3[num[i]].byt[7]*2;
				}
			}
FIN:
			if(sgnl)//------------------------------------------------- ���� ��� �������� ������
			{
				if(sgnl<0x8000) //------------------- ���� ������ �� ���������� ����������� ������
				{
					jj=sgnl;
					FR3[jj].byt[13]=0;FR3[jj].byt[15]=0;
					FR3[jj].byt[24]=0;
					FR3[jj].byt[27]=0;
					FR3[jj].byt[26]=FR3[jj].byt[26]|0xE0; //------------- ���������� ������� �������
					New_For_ARM(sgnl);
					sgnl=0;
				}
				if(sgnl>=0x8000)
				{
					ii = sgnl&0x7fff;
					FR3[ii].byt[24]=FR3[ii].byt[24]|0x80;
					New_For_ARM(ii);
					sgnl=0;
				}
			}
			New_For_ARM(num[i]);
			//===============&&&&&&&&&&&&&&&

			if(tiki_tum[tum]>30)//--------------------------------- ���� ���������� ������ �����
			{
				if(GRP=='L') //--------------------------------------- ���� ��� ������ �����������
				{
					READ_BD(num[i]);
					if(BD_OSN[0] == 25)KORZINA[tum] = VVOD[tum][sob][i]&1;//��� ������� KS (��,��,�)
				}
			}
		}
	}
	catch(...)
	{
		; //-------------------------?????????????????????
	}
	return;
}
//========================================================================================
//------------------------------------------------------ �������� � ����� ������ ���������
void __fastcall TStancia::add(int st,int sob,int knl)
{
	char ZAPIS[80],ZAPIS_TIME[80],tms[2],nom[3],nom_fr4[4],OGR[2],VREMA[9];
	unsigned int ito,i,kk;
	if (Serv1->Sost == 8888  )return;
	for(ito=0;ito<40;ito++)ZAPIS[ito]=0;
	//--------------------------------------------------------- �������� ����� � ����� �����
/*
	if((sob!=200)&&(sob!=300)&&(sob!=7777)&&(sob!=6666)&&(sob!=3333)&&(sob!=5555))
	{
		tms[0]=st+49; 	tms[1]=32;	strncat(ZAPIS,tms,2);	strncat(ZAPIS," ",1);
	}
	*/
	if(sob==300)//--------------------------------------------------- ���� ��������� �������
	{
		strncat(ZAPIS,"<TIME> ",7);

		if(KOM_TIME[2]<10)VREMA[0]=0x30;
		else VREMA[0]=(KOM_TIME[2]/10)|0x30;

		VREMA[1]=(KOM_TIME[2]%10)|0x30; 	VREMA[2]=':';
		if(KOM_TIME[1]<10)VREMA[3]=0x30;
		else VREMA[3]=(KOM_TIME[1]/10)|0x30;
		VREMA[4]=(KOM_TIME[1]%10)|0x30;	VREMA[5]=':';

		if(KOM_TIME[0]<10)VREMA[6]=0x30;
		else VREMA[6]=(KOM_TIME[0]/10)|0x30;
		VREMA[7]=(KOM_TIME[0]%10)|0x30;	VREMA[8]=0;
		strcat(ZAPIS,VREMA);
	}
	else
	if(sob==200)
	{
		strncat(ZAPIS,"<FR4> ",6);
		itoa(knl,nom_fr4,10);	strcat(ZAPIS,nom_fr4);	strncat(ZAPIS,"-",1);
		OGR[0]=st|0x40;	OGR[1]=0;	strncat(ZAPIS,OGR,1);
	}
	else
	if(sob==100) strncat(ZAPIS,"BEGIN",5);
	else
	if(sob==3333)//----------------------------------------- ���� �������� ����������� �����
	{
		strncat(ZAPIS,"$$$ ",4);
		strncat(ZAPIS,REG[st][knl],12);	strncat(ZAPIS,"->",2);
		if(knl==0)strncat(ZAPIS,"���",3);
		else strncat(ZAPIS,"���",3);
	}
	else
	if(sob==8888) //------------------------------------------------- ���� �������� ��������
	{
		strncat(ZAPIS,"{����}",6);
		strncat(ZAPIS,PAKO[MARSHRUT_ALL[st].NACH].c_str(),strlen(PAKO[MARSHRUT_ALL[st].NACH].c_str()));
		itoa(knl,nom_fr4,10);
		strncat(ZAPIS,"->",2);
		strncat(ZAPIS,nom_fr4,2);//------------------------------------- �������� ��� ��������
	}
	else
	if(sob==7777)  //------------------------------------------------ ���� ������ ����������
	{
		strncat(ZAPIS,PAKO[st].c_str(),strlen(PAKO[st].c_str()));
		strncat(ZAPIS,"->",2);
		strncat(ZAPIS,PAKO[knl].c_str(),strlen(PAKO[knl].c_str()));
	}
	else
	if(sob==6666)  //------------------------------------------------- ���� ������ ���������
	{
		strncat(ZAPIS,MARSHRUT_ST[st][knl]->NEXT_KOM,13);
	}
	else
	if(sob==5555)  //----------------------------------------- ���� ����������������� ������
	{
		if(knl==1)strncat(ZAPIS,"��������",8);
		if(knl==4)strncat(ZAPIS,"�������",7);
		if(knl==2)strncat(ZAPIS,"��������",8);
	}
	else
        if(sob == 4444)
        {
  	  		if(Kvitancia.Arhiv)
          {
    	    	strcat(ZAPIS,"���� = ");
    	    	strcat(ZAPIS,KK.c_str()); 	//--------------------------------- �������� ���������
            Kvitancia.Arhiv =  false;
          }
          else return;
        }
        else
	if(sob != 9999)	//-------------------------------------------------------- ���� �� �������
	{
		nom[0]=0;nom[1]=0;nom[2]=0;
		if(sob<10) { nom[0]=48;	nom[1]=sob+48; }
		else
		{
			nom[0]=(sob/10)+48;	
                        nom[1]=(sob%10)+48;
		}
		strcat(ZAPIS,nom); 	//--------------------------------------- �������� ����� ���������
		if(knl==0)strncat(ZAPIS,"-1",2); //----------------------------- �������� ����� ������
		else strncat(ZAPIS,"-2",2);
		
		strncat(ZAPIS,REG[st][knl],10); //-------------- �������� ���������� �������� ��������

	}
	else   //------------------------------------------------------ ���� ����������� �������
	{
		if(KOMANDA_ST[st][0]!=0)  //----------------------------- ���� ���� ���������� �������
		{ strncat(ZAPIS,"<Kom>",5);
			kk=strlen(ZAPIS);
			for(i=0;i<12;i++)ZAPIS[kk+i]=KOMANDA_ST[st][i]; //--------- ���������� ����� �������
		}
		else
		if(KOMANDA_TUMS[st][0]!=0) //---------------------------- ���� ���� ���������� �������
		{
			strncat(ZAPIS,"<Kom>",5);
			kk=strlen(ZAPIS);
			for(i=0;i<12;i++)ZAPIS[kk+i]=KOMANDA_TUMS[st][i]; //------------ ����������� �������
		}
	}
	if(ZAPIS[3]!=0)
	{
		strcpy(ZAPIS_TIME,Time1);
		strncat(ZAPIS_TIME," ",1);
		strncat(ZAPIS_TIME,ZAPIS,strlen(ZAPIS));
		if(ACTIV==1)strncat(ZAPIS_TIME,"_A",2);
		strncat(ZAPIS_TIME," ",1);
		EnterCriticalSection(&NOM_PACKET_ZAP);
		strncat(ZAPIS_TIME,PAKET_TXT,strlen(PAKET_TXT));
		LeaveCriticalSection(&NOM_PACKET_ZAP);
		int aa=strlen(ZAPIS_TIME);
		ZAPIS_TIME[aa]=0xd;
		ZAPIS_TIME[aa+1]=0;
		ito = write(file_arc,ZAPIS_TIME,aa+1);
		for(i=0;i<strlen(ZAPIS_TIME);i++)ZAPIS_TIME[i]=0;
	}
	return;
}
//========================================================================================
//--------------------------------------------------- ���������� ������ ��� �������� � ���
void __fastcall TStancia::ARM_OUT(void)
{
	int j,k,n_out,ARM,stoyka,bait,tst;
	int jf;
	unsigned int i,CRC; //----------------------------------------- ����������� ����� CRC-16
	unsigned char
	OUT_BYTE,   //------------------------------------------ ���� ��������� ������� ���� ���
	ZAGOL,      //----------------------------------- ���� ��������� ��� ��������� � ��� ���
	SOST;       //------------------------------------------- ���� ��������� ������� ��� ���
	for(i=0;i<70;i++)BUF_OUT_ARM[i]=0; //---------------------------- �������� ������ ������
	ZAPROS_ARM = 4;	//------------------------------------------------------ ������ ��������
	ARM=ZAPROS_ARM - 4;	//------------------- ��������� �������� ��������� � ���������� ����

	//------------------------------------------------------ ���������� ��������� �� �������
	//--------------------------- ������������ �������� = ��������� �� ��������� ���� ������

	n_out = ZAPOLNI_KVIT(ARM,0);
	//-------------------------------------------- ����� �� ����� ����������� �������� �����
	OBJ_ARMu[N_PAKET].LAST=0;
	if((DIAGNOZ[1])||(DIAGNOZ[2]))
	{ //------------------------------------------------------- �������� � ����� �����������
		BUF_OUT_ARM[n_out++]=DIAGNOZ[0]; DIAGNOZ[0]=0;
		BUF_OUT_ARM[n_out++]=DIAGNOZ[1]; DIAGNOZ[1]=0;
		BUF_OUT_ARM[n_out++]=DIAGNOZ[2]; DIAGNOZ[2]=0;
	}
	if(ERR_PLAT[1])
	{
		BUF_OUT_ARM[n_out++]=ERR_PLAT[0];ERR_PLAT[0]=0;
		BUF_OUT_ARM[n_out++]=ERR_PLAT[1];ERR_PLAT[1]=0;
		BUF_OUT_ARM[n_out++]=ERR_PLAT[2];ERR_PLAT[2]=0;
		BUF_OUT_ARM[n_out++]=ERR_PLAT[3];ERR_PLAT[3]=0;
		BUF_OUT_ARM[n_out++]=ERR_PLAT[4];ERR_PLAT[4]=0;
		BUF_OUT_ARM[n_out++]=ERR_PLAT[5];ERR_PLAT[5]=0;
	}
	if(NEPAR_OBJ[0]!=0)
	{
		BUF_OUT_ARM[n_out++]=NEPAR_OBJ[0];NEPAR_OBJ[0]=0;
		BUF_OUT_ARM[n_out++]=NEPAR_OBJ[1];NEPAR_OBJ[1]=0;
		BUF_OUT_ARM[n_out++]=NEPAR_OBJ[2];NEPAR_OBJ[2]=0;
	}
	for(i = 0; i < KOL_NEW; i++)//---------------------- ������ �� ������� ��������� �������
	{
		if(NOVIZNA[i] == 0)continue;//------------------- ���� ��� ������� ������� � ���������

		//------------------------------------------------------ ���� ������ �� ��������� ����
		if(NOVIZNA[i] >= KOL_OUT){NOVIZNA[i] = 0;continue;}

		//----------------------------- ���� ���� ������� - ����� �� ������� ��������� �������
		jf = NOVIZNA[i];
		//-------------------------------------------------- ���������� ����� ������� ��� ����
		//----------------------- ���� ������ �� ��� ���� - ������ �� ������, �� ������� �����
		if((OUT_OB[jf].byt[1]==32)&&(OUT_OB[jf].byt[0]==32)){NOVIZNA[i]=0;continue;}
		if((OUT_OB[jf].byt[1]==0)&&(OUT_OB[jf].byt[0]==0)){NOVIZNA[i]=0;continue;}

		OUT_BYTE=0; //------------------------------------------------- ���� ��������� �������

		for(j=0;j<8;j++) //--------------- ��������� ���� ��������� ������� ������� ����������
		{k = 1<<j; if(FR3[jf].byt[2*j+1]==1)OUT_BYTE = OUT_BYTE|k;}

		//------------------------------ �������� � ����� ������ ��� ����� ��� ������� �������
		BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[1];
		BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[0];
/*  	if((BUF_OUT_ARM[n_out-2] == 0xb1) && (BUF_OUT_ARM[n_out-1] == 0xbc))
		{
			i = 0;
			break;
		}
*/
		BUF_OUT_ARM[n_out++]=OUT_BYTE;  //----------------------------- ���� ��������� �������

		FR3[jf].byt[27]=FR3[jf].byt[27]|0x1f; //-------------- ���������� ����� �������� � ���
		FR3[jf].byt[26]=FR3[jf].byt[26]|(N_PAKET&0x1F);//----- ��������� ����� ������ ��������

		j=OBJ_ARMu[N_PAKET].LAST++;

		//------------------------------------ �������� ������������ ������ � ��������� ������
		OBJ_ARMu[N_PAKET].OBJ[j]=NOVIZNA[i];

		NOVIZNA[i]=0; //-------------------------------------------- ������� ������ �� �������
		if(n_out>64)break;
	}

	if(n_out<65)//------------------------------------ ���� � ������ �������� �������� �����

	//----------------------------------- ������ �� ������� ��������� ������� � ������������
	for(i=0;i<10;i++)
	{
		if(NOVIZNA_FR4[i]==0)continue;//-------------------------- ���� ��� ������� ���� �����

    if((NOVIZNA_FR4[i]&0xfff)== KOL_VO)
    {
    	OUT_BYTE = FR4[NOVIZNA_FR4[i]&0xfff];
			BUF_OUT_ARM[n_out++] = 9;//--------------- �������� � ����� ������ ����� ��� ���/���
			BUF_OUT_ARM[n_out++] = 0;
			BUF_OUT_ARM[n_out++] = OUT_BYTE;  //------------- �������� � ����� ��������� �������
    }
    else
    {
			if((NOVIZNA_FR4[i]&0xfff) >= KOL_OUT)
			{
				NOVIZNA_FR4[i]=0;
				continue; //----------------------------------------------------- ���� ��� �������
			}

			jf = NOVIZNA_FR4[i]&0xFFF; //------------------------------ ����� �� ����� ��� �����

			if((OUT_OB[jf].byt[1]==32)&&(OUT_OB[jf].byt[0]==32))
			{
				NOVIZNA_FR4[i]=0;
				continue; //--------------------------------------------- ���� ������  �� ��� ����
			}

			if((OUT_OB[jf].byt[1]==0)&&(OUT_OB[jf].byt[0]==0))
			{
				NOVIZNA_FR4[i]=0;
				continue; //------------------------ ���� ������ ������ ������� � ��������� ������
			}

			OUT_BYTE = FR4[jf];
			BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[1];//----- �������� � ����� ������ ����� ��� ...
			BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[0]|0x80;//---------------------- ������� �������
			BUF_OUT_ARM[n_out++]=OUT_BYTE;  //--------------- �������� � ����� ��������� �������
    }
		NOVIZNA_FR4[i] = NOVIZNA_FR4[i]+0x1000; //------ ��������� ������� ������� �����������
		if((NOVIZNA_FR4[i]&0x3000)==0x3000)NOVIZNA_FR4[i]=0;//- 3 ��������,  ������ �� �������
		if(n_out>64)break;//------------------------------------ �������� ����� �������� � ���
	}
 	if(i==10)new_fr4=0; //-------------------------- �������� �������� �������, ������ �����


  if(n_out<65)//------------------------------------ ���� � ������ �������� �������� �����
  {
 	  BUF_OUT_ARM[n_out++] = StatusAndKOK[0];
		BUF_OUT_ARM[n_out++] = StatusAndKOK[1];
		BUF_OUT_ARM[n_out++] = StatusAndKOK[2];
    OldStatusAndKOK = StatusAndKOK[2];
  }
	if(n_out<65)//------------------------------------ ���� � ������ �������� �������� �����
  {
  	if(((OUT_OB[povtor_fr4].byt[1]!=32)||(OUT_OB[povtor_fr4].byt[0]!=32)) &&
   	((OUT_OB[povtor_fr4].byt[1]!=0)||(OUT_OB[povtor_fr4].byt[0]!=0)))
    {
  		OUT_BYTE = FR4[povtor_fr4];
			BUF_OUT_ARM[n_out++]=OUT_OB[povtor_fr4].byt[1];//�������� � ����� ������ ����� ���..
			BUF_OUT_ARM[n_out++]=OUT_OB[povtor_fr4].byt[0]|0x80;//-------------- ������� �������
			BUF_OUT_ARM[n_out++]=OUT_BYTE;  //--------------- �������� � ����� ��������� �������
    }
    povtor_fr4++;
    if(povtor_fr4 >= KOL_OUT)povtor_fr4 = 0;
  }

	if(n_out<65)//------------------------------------ ���� � ������ �������� �������� �����

	for(i = 1; i < KOL_OUT; i++)
	{
		if(PEREDACHA[i]== PEREDANO)
    {
    	PEREDACHA[i] = 0;
    	continue; //------------------------------------- ���� ��� �������, ������ �� ������
    }

		if((OUT_OB[i].byt[1]==32)&&(OUT_OB[i].byt[0]==32))//������ �� ��� ���,������ �� ������
		{
			PEREDACHA[i]=0x1f;continue;
		}
		if((OUT_OB[i].byt[1]==0)&&(OUT_OB[i].byt[0]==0))//---- ������ ������, ������ �� ������
		{
			PEREDACHA[i]=0x1f;continue;
		}

		OUT_BYTE=0;
		for(j=0;j<8;j++) {k=1<<j;if(FR3[i].byt[2*j+1]==1)OUT_BYTE = OUT_BYTE|k;}

		BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[1];
		BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[0];
		BUF_OUT_ARM[n_out++]=OUT_BYTE;

		FR3[i].byt[27]=FR3[i].byt[27]|0x1f; //--------------- ���������� ����� �������� � ����

		FR3[i].byt[26]=FR3[i].byt[26]|(N_PAKET&0x1F);//------- ��������� ����� ������ ��������

		j=OBJ_ARMu[N_PAKET].LAST++;
		OBJ_ARMu[N_PAKET].OBJ[j]=i;//------------------------------------- ������������ ������
		PEREDACHA[i] = PEREDANO;
		if(n_out>64)break;
	}

	while(n_out < 65)
	{
		for(i = povtor_out; i < KOL_OUT; i++)
		{
			if(FR3[i].byt[34] != 10){FR3[i].byt[34] = 10; i=1;} 
			//---------------------------------------------------------- ����� ��������� �������
			stoyka = (FR3[i].byt[28]&0xF0)>>4;//-------------------------------- �������� ������
			if(stoyka==0)stoyka=1;
			bait=FR3[i].byt[28]&0xf;        //------------------------------------ �������� ����
			if(Norma_TS[stoyka-1]== false)
			{
				SVAZ = SVAZ | (1<<(stoyka-1));
				if(FR3[i].byt[29]>=48)
				{
				 FR3[i].byt[11]=1; //------------------------------------- �������� ��������������
				 VVOD[stoyka-1][FR3[i].byt[29]-48][bait-1]=
				 VVOD[stoyka-1][FR3[i].byt[29]-48][bait-1]|0x20;
				}
			}
			//------------------------------------------------------ ����� ����� ������� ��� ���
			//------------------------------------- ���� ������ �� ��� ��� , �� ������ �� ������
			if((OUT_OB[i].byt[1]==32)&&(OUT_OB[i].byt[0]==32))continue;
			if((OUT_OB[i].byt[1]==0)&&(OUT_OB[i].byt[0]==0))continue;
			OUT_BYTE=0;
			for(j=0;j<8;j++){k=1<<j;if(FR3[i].byt[2*j+1]==1)OUT_BYTE=OUT_BYTE|k;}
			BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[1];
			BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[0];
			BUF_OUT_ARM[n_out++]=OUT_BYTE;
			if(FR4[i])
			{
				OUT_BYTE=FR4[i];
				BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[1];//---- �������� � ����� ������ ��� ����� ���
				BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[0]|0x80;//--------------------- ������� �������
				BUF_OUT_ARM[n_out++]=OUT_BYTE;  //------------- �������� � ����� ��������� �������
			}

			FR3[i].byt[27]=FR3[i].byt[27]|0x1f;//--------------- ���������� ����� �������� � ���
			FR3[i].byt[26]=FR3[i].byt[26]|(N_PAKET&0x1F);//----- ��������� ����� ������ ��������
			j=OBJ_ARMu[N_PAKET].LAST++;
			OBJ_ARMu[N_PAKET].OBJ[j]=i;//----------------------------------- ������������ ������
			if(n_out>64)break;
		}
		povtor_out = i;
		if(povtor_out>=(int)KOL_OUT)povtor_out=1;
	}
	//--------------------------------------------------------------- ������������ ���������
	ZAGOL=0;
	ZAGOL=ZAGOL|(ZAPROS_ARM&0xf);
	SERVER=NUM_ARM;
	ZAGOL=ZAGOL|((SERVER<<4)&0xf0);

	if(Kvitancia.Kvit) ZAGOL = ZAGOL | 0x80;
	else ZAGOL = ZAGOL & 0x7F;

	SOST = 0x10;  //------------------------------------ ���������� ������� � ������ �������

	SOST = SOST | 1;//--------------------- ���������� ������� ����������� ������� ������(1)
	j=0;

	if(STATUS == 1)SOST = SOST|0x80;  //---------------------------------------���� ��������
	else SOST = SOST & 0x7f; //-----------------------------------------------���� ���������
	/*
	if(KONFIG_ARM==0xFF)SOST=SOST|0x80;  //���� ��������
	else SOST=SOST&0x7f; //���� ���������
	*/
	if(PROCESS==0)SOST = SOST&0xef;

	if( KNOPKA_OK0 != KOK_OT_TUMS) SOST = SOST & 0xEF; //�� ������������ ��� ���, ����������
	else SOST = SOST|0x10;//��� � ���� � � ����� �������������, ������ ���������� ����������

	if((KNOPKA_OK0==1) && (KOK_OT_TUMS == 1))
	{
		KNOPKA_OK=1;
		SOST = SOST|0x20; //----------------------------------------- �������� ������� ������ ��
	}
	else
	{
		KNOPKA_OK = 0;
		SOST = SOST & 0xDF; //--------------------------------------- ������ ������� ������ ��
	}
	SOST = SOST|PROCESS; //-------------- �������� ��������� ������ ���������� ��� ��� �����
//  SOST=SOST&0xeF;
	BUF_OUT_ARM[2] = SOST;
	BUF_OUT_ARM[1] = ZAGOL;
	BUF_OUT_ARM[3] = SVAZ;
	CRC=CalculateCRC16(&BUF_OUT_ARM[1],66); //------------------------------- ���������� CRC

	PAKETs[N_PAKET].KS_OSN = CRC; //--------------------- ��������� ����������� ����� ������
	PAKETs[N_PAKET].ARM_OSN_KAN = 0x1f; //------------------- ��������� ���� �������� � ����

	BUF_OUT_ARM[68] = (CRC&0xFF00)>>8;
	BUF_OUT_ARM[67] = CRC&0xFF;
	BUF_OUT_ARM[0] = 0xAA;
	BUF_OUT_ARM[69] = 0x55;

	N_PAKET++;
	if(N_PAKET==32) N_PAKET=0;
	for(i=0;i<28;i++)BUF_IN_ARM[i] = 0;
	return;
}

//========================================================================================
//----- ��������� �������� � ������ ������� ������-��� ��������� ������ ��� �������� � DSP
//------------------------------------------------ arm - ������ ����;  knl - ������ ������
//------ ������� ���������� ����� ����� � ������ �������� � ���,  ���������� �� ����������
int __fastcall TStancia::ZAPOLNI_KVIT(int arm,int knl)
{
	int i, n_ou=4;
	if((KVIT_ARMu[0])||(KVIT_ARMu[1])) //-------------- ���� ���� ��������� ��� ����� ������
	{
		if(knl==0)
		{
			for(i=0;i<3;i++)BUF_OUT_ARM[n_ou++] = KVIT_ARMu[i]; //------------- ������ ���������
			//---------------- ���� ��� ������ 999 - ������ ����������, �� �������� �������� FR3
			if((KVIT_ARMu[0]==0xE7)&&((KVIT_ARMu[1]&0xf)==3))
			{
				BUF_OUT_ARM[n_ou++]=KVIT_ARMu[0];
				BUF_OUT_ARM[n_ou++]=KVIT_ARMu[1]&0xf;
				BUF_OUT_ARM[n_ou++]=1;

			}

			for(i=0;i<3;i++)KVIT_ARMu[i]=0;
		}
	}
	return(n_ou);
}
//========================================================================================
void __fastcall TStancia::READ_BD(int jb)
{
	int l;
	for(l=0;l<16;l++)
	BD_OSN[l]=BD_OSN_BYT[jb].byt[l*2]*256+BD_OSN_BYT[jb].byt[2*l+1];
}
//========================================================================================
//--------------------------------------------- ��������� ������� ������, �������� �� ����
void __fastcall TStancia::ANALIZ_ARM(void)
{
  int ik,ii;
	char CRC_s;
	if((BUF_IN_ARM[0]==0xAA)&&(BUF_IN_ARM[27]==0x55))//���� ���� ������� ������
	{ //���� �������� ������ ����� ����� ������ - ��������� ���
		if(OSN1_KS[0]==0) for(ii=0;ii<28;ii++)OSN1_KS[ii]=BUF_IN_ARM[ii];
		//���� ��� �������� � �����-���� ������, �� �������� ����� �������
 //   if(KONFIG_ARM==0xFF)
		// add_ARM_IN(ZAPROS_ARM,0); //�������� �������� � �����
	}
	if(OSN1_KS[0]==0xAA) //���� ������ ������ �������������
	{
		CRC_s = CalculateCRC8(&OSN1_KS[1],25);
		if(CRC_s != (char)OSN1_KS[26])
		for(ii=0;ii<28;ii++)OSN1_KS[ii]=0;
	}
	if(OSN2_KS[0]==0xAA)//���������� � �������� �������
	{
		CRC_s=CalculateCRC8(&OSN2_KS[1],25);
		if(CRC_s!=OSN2_KS[26])
		for(ii=0;ii<28;ii++)OSN2_KS[ii]=0;
	}

	if(OSN1_KS[0]==0xAA)RASPAK_ARM(1,0,0xff);
  if(STOP_ALL == 15)return;
	if(OSN2_KS[0]==0xAA)RASPAK_ARM(2,0,0xff);
  if(STOP_ALL == 15)return;
	if(N_PRIEM<N_KOMAND)
	ik=0;
	if(OSN1_KS[0]==0xAA)for(ik=0;ik<28;ik++)OSN1_KS[ik]=0;
	if(OSN2_KS[0]==0xAA)for(ik=0;ik<28;ik++)OSN2_KS[ik]=0;
	return;
}
//========================================================================================
// ----------------------------------------- ��������� ���������� ������, �������� �� ����
// --------------------------------------------------------- bb - ��� ������ ������ ������
// ------------------------------------------------------STAT -��� ������ (0-���.; 1-���.)
void __fastcall TStancia::RASPAK_ARM(const int bb,unsigned char STAT,int arm)
{
	unsigned char ARM,RAY;
  int ii,jj,kvit;
  if(bb!=0xff)
  {
    for(ii=0;ii<28;ii++)KOM_BUFER[ii]=0;
    switch(bb) //���������� ������
    {
      case 1: for(ii=0;ii<28;ii++)KOM_BUFER[ii]=OSN1_KS[ii];break;
      case 2: for(ii=0;ii<28;ii++)KOM_BUFER[ii]=OSN2_KS[ii];break;
      case 3: for(ii=0;ii<28;ii++)KOM_BUFER[ii]=REZ1_KS[ii];break;
      case 4: for(ii=0;ii<28;ii++)KOM_BUFER[ii]=REZ2_KS[ii];break;
      default: return;
		}
  }
	else if(arm!=255)ARM=arm;

	if(KOM_BUFER[1])
	{
		ARM=((KOM_BUFER[1]&0xf0)>>4)-4;  //------------------------------ ��������� ������ ���
		if((KOM_BUFER[2]&0x20)==0x20)
		{
			//KNOPKA_OK[ARM]=1;
			OK_KNOPKA=OK_KNOPKA|(1<<ARM); //------------------------------ ��������� �������� ��
		}
		else
		{
			//KNOPKA_OK[ARM]=0;
			OK_KNOPKA=OK_KNOPKA&(~(1<<ARM));
		}
		RAY=KOM_BUFER[2]&0x3; //--------------------------------------------- ��������� ������
/*
		if((KOM_BUFER[2]&0x80)==0x80)  //-------------------------- ���� ��� �������� � ������
		{
				KONFIG_ARM=0xFF;
		}
		else KONFIG_ARM=0;
*/
	}

	//--------------------------------------------- ���� ��������� ������� ��������� �������
	if((KOM_BUFER[3]==102)||(KOM_BUFER[3]==101))
	{
		for(ii=0;ii<7;ii++)KOM_TIME[ii]=KOM_BUFER[4+ii];//------------ ��������� ����� �������
		if(KOM_BUFER[11]>224)            //---------------------------- ���� ������� ���������
		{
			kvit=KOM_BUFER[11]-224;        //----------- ���������� ����� ��������� � ����������
			for(ii=0,jj=12;(ii<kvit)&&(jj<26);ii++,jj=jj+2)
			KVIT_ARM[STAT][ii]=KOM_BUFER[jj]+(KOM_BUFER[jj+1]<<8);
		}
		for(ii=0;ii<7;ii++)KOM_TIME[ii]=0;
		for(ii=0;ii<28;ii++)KOM_BUFER[ii]=0;
		return;
	}
	else
	{
		if(((KOM_BUFER[3]>0)&&(KOM_BUFER[3]< 133))|| //-------- ���� ������-���������� �������
		((KOM_BUFER[3]>192)&&(KOM_BUFER[3]<205)))   //---------- �� ���������� �� � ���.������
		{
			for(ii=0,jj=3;ii<3,jj<6;ii++,jj++)
				KOMANDA_RAZD[ii]=KOM_BUFER[jj];

			if(KOM_BUFER[6]>224)               //-------------------------- ���� ����� ���������
			{ kvit=KOM_BUFER[6]-224;           //-------------------- ���������� ����� ���������
				for(ii=0,jj=7;(ii<kvit)&&(jj<26);ii++,jj=jj+2)//------------- ���������� ���������
				KVIT_ARM[STAT][ii]=KOM_BUFER[jj]+(KOM_BUFER[jj+1]<<8);
			}
//      if((KONFIG_ARM[ZAPROS_ARM][0]xFF)&&
//			(KONFIG_ARM[ZAPROS_ARM][1]xFF))

//      add_ARM_IN(ARM,3); //�������� �������� � �����

		}
		else                              //-------------------------- ���� ������ ��� �������
		{
			if(KOM_BUFER[3]>224)            //--------------------------- ���� ������� ���������
			{
				kvit=KOM_BUFER[3]-224;        //--------- ���������� ����� ���������� � ����������
				for(ii=0,jj=4;(ii<kvit)&&(jj<26);ii++,jj=jj+2)
				KVIT_ARM[STAT][ii]=KOM_BUFER[jj]+(KOM_BUFER[jj+1]<<8);
			}
			else                            //----------------------- ���� � ������ ��� ��������
			{
				if((KOM_BUFER[3]>=187)&&(KOM_BUFER[3]<=192))  //----------- ������� �����. �������
				{
					ii = 0; jj = 3;
					for(ii=0,jj=3;ii<10,jj<13;ii++,jj++)        //------------------ ������� � �����
					KOMANDA_MARS[ii]=KOM_BUFER[jj];

					if(KOM_BUFER[13]>224)                       //------------- ���� ����� ���������
					{
						kvit=KOM_BUFER[13]-224;                   //------------------ ����� ���������
						for(ii=0,jj=14;(ii<kvit)&&(jj<26);ii++,jj=jj+2)
						KVIT_ARM[STAT][ii]=KOM_BUFER[jj]+(KOM_BUFER[jj+1]<<8);
					}
				}
			}
		}
		for(ii=0;ii<28;ii++)KOM_BUFER[ii]=0; //-------------------------------- �������� �����
		ANALIZ_KVIT_ARM(ARM,STAT); //------------------------- ���������������� ��������� ����
		//-------------------------------------------------------------- ���� ���� �����������
		if(KOMANDA_RAZD[0]!=0)
		{
			N_PRIEM++;
			KVIT_ARMu[0]=KOMANDA_RAZD[1];
			KVIT_ARMu[1]=KOMANDA_RAZD[2]|0x40;//--------------------- �������� ������� ���������
			KVIT_ARMu[2]=0;
			MAKE_KOMANDA(ARM,STAT,RAY);
			if(STOP_ALL==15)return;
			for(ii=0;ii<12;ii++)KOMANDA_RAZD[ii]=0;
		}
		if(KOMANDA_MARS[0])
		{
			KVIT_ARMu[0]=KOMANDA_MARS[1];
			KVIT_ARMu[1]=KOMANDA_MARS[2]|0x40;//--------------------- �������� ������� ���������
			KVIT_ARMu[2]=1;
			MAKE_MARSH(ARM,STAT);
			for(ii=0;ii<10;ii++)KOMANDA_MARS[ii]=0;
		}
		return;
	}
}
/******************************************\
*  ��������� ��������� ���������� �������  *
*            MAKE_TIME()                   *
/**********************************************\
*      ANALIZ_KVIT_ARM(int arm,int stat)       *
* ��������� ������� ���������,�������� �� ���� *
* arm - ������ ����, ������������ ����� ������ *
* stat- ��� ������ �����,�������������� �����  *
\**********************************************/
void __fastcall TStancia::ANALIZ_KVIT_ARM(int arm,int stat)
{
  int ii,jj,oo,ob;
  if(KVIT_ARM[stat][0]==0)return;
  switch(stat)
  {
    case 0: for(ii=0;ii<18;ii++)//������ �� ���� ��������� ����������
						{
              if(KVIT_ARM[0][ii]==0)continue;
              for(jj=0;jj<32;jj++)//������ �� ���� �������
              { if(KVIT_ARM[0][ii]==PAKETs[jj].KS_OSN)//������ � ��������
                {
                  for(oo=0;oo<21;oo++)//������� ����� �� ��� ������� ������
                  {
                    ob=OBJ_ARMu[jj].OBJ[oo];
		    PRIEM[ob]=PRIEM[ob]|(1<<arm);
                  }
                  PAKETs[jj].ARM_OSN_KAN=PAKETs[jj].ARM_OSN_KAN&(~(1<<arm));//������� �ਥ�
                  KVIT_ARM[0][ii]=0;//�������� ���������
                  break;
                }
              }
            }
            break;
    case 1: for(ii=0;ii<18;ii++)
						{ if(KVIT_ARM[1][ii]==0)continue;
              for(jj=0;jj<32;jj++)
              { if(KVIT_ARM[1][ii]==PAKETs[jj].KS_REZ)
                {
                  for(oo=0;oo<21;oo++)
                  {
                    ob=OBJ_ARMu1[jj].OBJ[oo];
                    PRIEM[ob]=PRIEM[ob]|(1<<arm);
                  }
                  PAKETs[jj].ARM_REZ_KAN=PAKETs[jj].ARM_REZ_KAN&(~(1<<arm));
                  KVIT_ARM[1][ii]=0;
									break;
                }
              }
            }
            break;
    default:break;
  }
  KVIT_ARM[stat][0]=0;
  return;
}
//========================================================================================
//--------------------------------------- MAKE_KOMANDA(int ARM,int STAT,unsigned char ray)
//  ��������� ������������� ���������� ������ �� ���� � ���� ������ ����� ����                       *
//--------------------------------------------------  ARM - ������ ����, ��������� �������
//----------------------------------------- STAT - ��� ������,�� �������� �������� �������
//----------------------------------------------------------- ray  - ��� ������ ����������
void __fastcall TStancia::MAKE_KOMANDA(int ARM,int STAT,int ray)
{
	unsigned short int obj,obj_serv,ii,tip_ob,job;
	unsigned char komanda;
	AnsiString Arm_kom;
	if(KOMANDA_RAZD[0])//--------------------------------------- ���� ���� ������ ����������
	{ //------------------------------------------------------ ��������� ������ ������� ����
		obj=KOMANDA_RAZD[1]+KOMANDA_RAZD[2]*256;
		if((obj==0)||(obj>(unsigned short)KOL_ARM))
		{
			for(ii=0;ii<3;ii++)KOMANDA_RAZD[ii]=0;
			return;
		}
		komanda = KOMANDA_RAZD[0]; //---------------------------------- ��������� ���� �������
		if(Otladka1->Otlad==5)
		{
			Arm_kom=IntToStr(komanda)+" - "+IntToStr(obj);
			Edit3->Text=Arm_kom;
		}
		//-------------------------------------- ��������� ������ �� ������������ ������ � ��̠
		if(obj==1)
		{
			if((komanda==79)&&(PROCESS==0x40)) //-------------------- ���� ���������� ����������
			{
					KONFIG_ARM=0xFF;
			}
			else
			if((komanda==80)&&(PROCESS==0x40))//-------------------------- ���� ������ ���������
			{
				 KONFIG_ARM=0xFF;
				 KVIT_ARMu[0]=KOMANDA_RAZD[1];
				 KVIT_ARMu[1]=KOMANDA_RAZD[2];
				 KVIT_ARMu[2]=ray;
			}
			return;
		}

		if(obj==2)
		{
			if(komanda==54)
			{
				STOP_ALL=15;
#ifdef ARPEX
				WDTStp();
#endif
				for(ii=0;ii<12;ii++)KOMANDA_RAZD[ii]=0;
				for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
				return;
			}
		}

		//----------------------------------------  ��������� ������� ��� ����������� ��������
		if(obj==998)
		{
			if(komanda!=96)return;
			else
			{
				if(ACTIV==1)RESET_TIME=10; //-----------------------��������� ������������ 0,5 ���
			}
			return;
		}
#ifdef KOL_AVTOD
    //--------------------------------------------------------- ��������� ��������� ������
    if (obj == OB_AVTOD) //-------- ���� ��� ������ ��� �������� ������������ ������������
    {
      switch(komanda)
      {
    		case 129:
        {
        	NAS = true;
          FR4[KOL_VO] = FR4[KOL_VO] | 'A';
          NOVIZNA_FR4[new_fr4++] = KOL_VO;
          if(new_fr4 >=10)new_fr4 = 0;
          break;
        }
      	case 130:
        {
        	NAS = false;
          FR4[KOL_VO] = FR4[KOL_VO] & 0xFE;
          NOVIZNA_FR4[new_fr4++] = KOL_VO;
          if(new_fr4 >=10)new_fr4 = 0;
          break;
        }
        case 131:
        {
        	CHAS = true;
          FR4[KOL_VO] = FR4[KOL_VO] | 'B';
          NOVIZNA_FR4[new_fr4++] = KOL_VO;
          if(new_fr4 >=10)new_fr4 = 0;
          break;
        }
        case 132:
        {
        	CHAS = false;
          FR4[KOL_VO] = FR4[KOL_VO] & 0xFD;
          NOVIZNA_FR4[new_fr4++] = KOL_VO;
          if(new_fr4 >=10)new_fr4 = 0;
          break;
        }
      }
      return;
    }
#endif

		//--------------------------------------------- ������� ��������������� ������ �������
		obj_serv = INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];
		if(obj_serv > (unsigned short)KOL_SERV)return;
		READ_BD(obj_serv); 											//---------------------- ������ ������ �������

		if(BD_OSN[0] < 100)tip_ob = BD_OSN[0]&0xF; //-------------------- �������� ��� �������
		else tip_ob=BD_OSN[0];

		if(((tip_ob>=1)&&(tip_ob<=5))||(tip_ob==8)||(tip_ob==9))
		{
			switch(tip_ob) //------------------------- � ����������� �� ������� �������� �������
			{
				case 1: perevod_strlk(komanda,obj_serv);break;

				case 2: signaly(komanda,obj_serv);break;
				case 3:
				case 4: sp_up_and_razd(komanda,obj_serv,ARM);break;
				case 5: puti(komanda,obj_serv);break;
				case 8: if((komanda==64)||(komanda==65)||(komanda==87)||(komanda==88))
								prosto_komanda(komanda);
								else  dopoln_obj(komanda,ARM);
								break;
				case 9: ob_tums(komanda);break;
				default: break;
			}
			for(ii=0;ii<16;ii++)BD_OSN[ii]=0;
			for(ii=0;ii<12;ii++)KOMANDA_RAZD[ii]=0;
			return;
		}
		else
		//-------------------------------------------------------- ���� ��� ���������� �������
		if(BD_OSN[0]==226)
		{
			if(komanda==71) //-------------------------------- ���� �������������������� �������
			{
				KOMANDA_MARS[0]=71;
				job=BD_OSN[1];
				KOMANDA_MARS[1]=OUT_OB[job].byt[1];
				KOMANDA_MARS[2]=OUT_OB[job].byt[0];
				job=BD_OSN[2];
				KOMANDA_MARS[3]=OUT_OB[job].byt[1];
				KOMANDA_MARS[4]=OUT_OB[job].byt[0];
				KOMANDA_MARS[5]=(BD_OSN[3]&0xf000)>>12;
				KOMANDA_MARS[6]=BD_OSN[3]&0xfff;
				KOMANDA_MARS[7]=0;
				KOMANDA_MARS[8]=0;
				KOMANDA_MARS[9]=0;
				for(ii=0;ii<12;ii++)
				{
					KOMANDA_RAZD[ii]=0;
				}
				MAKE_MARSH(ARM,STAT);
				for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
			}

			if(komanda==72)otmena_rm(obj_serv);

			if((komanda==64)||(komanda==65)||(komanda==87)||(komanda==88))
			{
				prosto_komanda(komanda);
			}
			for(ii=0;ii<16;ii++)BD_OSN[ii]=0;
			for(ii=0;ii<12;ii++)KOMANDA_RAZD[ii]=0;
			return;
		}
		else
		if(BD_OSN[0]==238)
		{
			if(komanda==73) //���� �������� ����
			{
				obj_serv=BD_OSN[1];
				if(BD_OSN[3]==1)komanda=64;
				if(BD_OSN[3]==2)komanda=87;
				if((BD_OSN[3]==1)&&(BD_OSN[4]==0))komanda=65;
				if((BD_OSN[3]==2)&&(BD_OSN[4]==0))komanda=88;
				READ_BD(obj_serv);
				prosto_komanda(komanda);
			}
			if(komanda==74) //���� �������� ����
			{
				obj_serv=BD_OSN[2];
				if(BD_OSN[4]==1)komanda = 65;
        if(BD_OSN[4]==0)komanda = 64;
				if(BD_OSN[4]==2)komanda=87;
				READ_BD(obj_serv);
				prosto_komanda(komanda);
			}
			for(ii=0;ii<16;ii++)BD_OSN[ii]=0;
		}
	}
	for(ii=0;ii<12;ii++)KOMANDA_RAZD[ii]=0;
	return;
}

//========================================================================================
//--------------------------------  ��������� ��������� ���������� ������,�������� �� ����
//------------------------------------   ARM - �����(���) ����, ��������� ������� ��������
//--------------------------------   STAT - �����(���) ������, �� �������� ������� �������
void __fastcall TStancia::MAKE_MARSH(int ARM,int STAT)
{
	unsigned int obj,obj0,nach_marsh,end_marsh,nstrel,ii;
	unsigned long pol_strel;
	unsigned char komanda;
	AnsiString Arm_kom;

	if(KOMANDA_MARS[0])//---------------------------------------------- ���� ���� ����������
	{
		obj = KOMANDA_MARS[1] + KOMANDA_MARS[2]*256;
		obj0 = obj; //---------------------------------------- ������ �������� � ��������� DSP
		if((obj<=0)||(obj>= KOL_ARM))//--------------------------- ���� ������ ������ ��� ����
		{
			for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
			return;
		}
		komanda = KOMANDA_MARS[0]; //------------------------------------ �������� ��� �������
		if((komanda == 189) ||(komanda == 188))POVTOR_OTKR = 0xFF;

		nach_marsh=INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];//- �������� ������ �������� STAN

		obj = KOMANDA_MARS[3]+KOMANDA_MARS[4]*256; //-------------------------- ����� �� � DSP

		if((obj==0)||(obj>=KOL_ARM)) //---------------------------- ���� ������ ����� ��� ����
		{
			for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
			return;
		}
		end_marsh = INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];//----- ����� �������� �� � STAN

		nstrel=KOMANDA_MARS[5]; //--------------------------------- ����� ������������ �������

		//---------------------------------------- ��������� ������������ ������� (�� 32 ����)
		pol_strel=KOMANDA_MARS[6]+(KOMANDA_MARS[7]<<8)+
		(KOMANDA_MARS[8]<<16)+(KOMANDA_MARS[9]<<24);

		if(Otladka1->Otlad==5)
		{
			Arm_kom=IntToStr(komanda)+"-"+IntToStr(obj0)+"-"+
			IntToStr(KOMANDA_MARS[3]+KOMANDA_MARS[4]*256)+
			"-"+IntToStr(nstrel)+"-"+IntToStr(pol_strel);
			Edit3->Text=Arm_kom;
		}
		RASFASOVKA=0xF;
		//-------------------------------------- ������ ��������� ��������
		ii = ANALIZ_MARSH(komanda,nach_marsh,end_marsh,nstrel,pol_strel);

		if(ii<(Nst*3))TUMS_MARSH(ii);
		else
		{
			Soob_For_Arm(ii,nach_marsh); ii=0;
		}
		RASFASOVKA=0;
	}
	return;
}
 //=======================================================================================
//---------------------- perevod_strlk - ������ ������������ ���������� ������� �� �������
//------------------------------------------ command - ���� ����������� ������� �� �������
//------------------- int BD_OSN[16] - ������ �������� ������� ���������� ��� ������� � ��
void __fastcall TStancia::perevod_strlk(unsigned char command,unsigned int objserv)
{
	unsigned char tums, //----------------------------------------------------- ����� ������
	gruppa, //----------------------------------------------- ��� ������ ��� ������� �������
	podgruppa, //------------------------------------------------- ��� ��������� ��� �������
	kod_cmd, //----------------------------------------------------- ��� ������� ��� �������
	bit;    //---------------------------------------------- ����� ����� ��� ������� �������
	//--------------------------------------------------------------------------------------
	tums = (BD_OSN[13]&0xff00)>>8;
  gruppa='C';
  podgruppa=BD_OSN[15]&0xff;
  switch(command)
	{
		//---------------------------------------------------- ��������� ������� �� ����������
		case 31:  FR4[objserv]=FR4[objserv]|1;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		
		case 32:  FR4[objserv]=FR4[objserv]&0xFE;//------------- �������� ������� � ����������
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;

		//-------------------------------------------------------- ������� �������� �� �������
		case 33:  FR4[objserv]=FR4[objserv]|4;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//-------------------------------------------------------- ������� �������� �� �������
		case 34:  FR4[objserv]=FR4[objserv]&0xFB;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //--- ���� �� �������� ����� 10 ������, ������ � 0
							return;
		//------------------------------------------------ ������� �������� �� ������� �������
		case 35:  FR4[objserv]=FR4[objserv]|8;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//------------------------------------------------ ������� �������� �� ������� �������
		case 36:  FR4[objserv]=FR4[objserv]&0xF7;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//-------------------------------------------------------- ���������� ����� �� �������
		case 37:  FR4[objserv]=FR4[objserv]|2;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//------------------------------------------------------------- ����� ������� � ������
		case 38:  FR4[objserv]=FR4[objserv]&0xFD;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//---------------------------------------- ������� ��������������� �������� �� �������
		case 114: FR4[objserv]=FR4[objserv]|0x10;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//---------------------------------------- ������� ��������������� �������� �� �������
		case 115: FR4[objserv]=FR4[objserv]&0xEF;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //--- ���� �� �������� ����� 10 ������, ������ � 0
							return;
		//-------------------------------- ������� ��������������� �������� �� ������� �������
		case 116: FR4[objserv]=FR4[objserv]|0x20;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		//-------------------------------- ������� ��������������� �������� �� ������� �������
		case 117: FR4[objserv]=FR4[objserv]&0xDF;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;

		case 41:  kod_cmd='A';break;  //----------------------- ������� ������� ������� � ����
		case 42:  kod_cmd='B';break;  //---------------------- ������� ������� ������� � �����
		case 43:  kod_cmd='Q';break;  //--------------- ��������������� ������� ������� � ����
		case 44:  kod_cmd='R';break;  //-------------- ��������������� ������� ������� � �����
		case 81:  kod_cmd='E';break;  //--------------------- ������� ������� �� ������ � ����
		case 82:  kod_cmd='F';break;  //-------------------- ������� ������� �� ������ � �����
		case 83:  kod_cmd='U';break;  //----- ��������������� ������� ������� �� ������ � ����
		case 84:  kod_cmd='V';break;  //---- ��������������� ������� ������� �� ������ � �����

		case 107: kod_cmd='I';break; //----------------------------- ������� � ���� � ��������
		case 127: kod_cmd='J';break; //---------------------------- ������� � ����� � ��������

		default:  return;
	}

	int Err=0;
	if((command>=41)&&(command<=84))
	{
		for(int i_m=0;i_m<Nst*3;i_m++)
		for(int i_s=0;i_s<Nst;i_s++)
		for(int i_str=0;i_str<10;i_str++)
		if(MARSHRUT_ALL[i_m].STREL[i_s][i_str] == objserv)
		{
      DeleteMarsh(i_m);
			add(i_m,8888,13);
      Err++;
    }
  }
  bit=(BD_OSN[15]&0xe000)>>13; //�������� ����� ����� � ��������� = ����� ���� ��� �������
	ZAGRUZ_KOM_UVK(tums, gruppa, podgruppa, bit, kod_cmd);
	return;
}

//========================================================================================
//------------------------------ signaly - ������ ������������ ���������� ������ �� ������
//------------------------------------------ command - ���� ����������� ������� �� �������
//------------------- int BD_OSN[16] - ������ �������� ������� ���������� ��� ������� � ��
//--------------------------- unsigned objserv - ������ � ������� ��� ������������ �������
void __fastcall TStancia::signaly(unsigned char command,unsigned int objserv)
{
	unsigned char tums,//------------------------------------------------------ ����� ������
	gruppa, //----------------------------------------------- ��� ������ ��� ������� �������
	podgruppa, //------------------------------------------------- ��� ��������� ��� �������
	kod_cmd, //----------------------------------------------------- ��� ������� ��� �������
	sp_in_put, //--------------------------------------------------------- �� ������� � ����
	spar_sp,   //------------------------------------------------------ �� ��������� �������
	job, //--------------------------------------------------------------- ����� ���� ������
	i_m, //----------------------------------------------------- ������ ����������� ��������
	i_s, //------------------------------------------------------------------- ������ ������
	i_sig,//----------------------------------------------------------------- ������ �������
	bit,  //------------------------------------------------ ����� ����� ��� ������� �������
	ii;   //----------------------------------------------------- ��������������� ����������
	unsigned int ob_next;
	int shag,kk,jf;
	tums=(BD_OSN[13]&0xff00)>>8;
	gruppa='E';
	podgruppa=BD_OSN[15]&0xff;
	bit=(BD_OSN[15]&0xe000)>>13;
  switch(command)
	{
		//------------------------------------------------------------------ �������� ��������
		case 33:  FR4[objserv]=FR4[objserv]|4;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;

		case 34:  FR4[objserv]=FR4[objserv]&0xFB;
							NOVIZNA_FR4[new_fr4++]=objserv;//------ ��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //---- ���� �� �������� ����� 10 ������,������ � 0
							return;
		case 95:
		case 45:  kod_cmd='A';break;
		case 46:  kod_cmd='B';break;

		case 47:  kod_cmd='E';//---------------------------------- ������ ����������� ��������
							ii=0;
							for(i_m=0;i_m<Nst*3;i_m++)
              {
                for(i_s=0;i_s<Nst;i_s++)
                {
                  for(i_sig=0;i_sig<10;i_sig++)
                  {
                    if(MARSHRUT_ALL[i_m].SIG[i_s][i_sig]==objserv)
                    {
                      DeleteMarsh(i_m);
											add(i_m,8888,14);
                    }
                  }
                }
              }
							READ_BD(objserv);//---------------------------------- ��������� ���� �������
							if(BD_OSN[1]==0)shag=-1;//------------------- ��� ������� ������� ���� �����
							else shag=1; //----------------------------------- ��� ��������� ���� ������
							//------------------------- ������ �� ���������� ������� � ���� �� �� ��� ��
							for(kk = objserv+shag; (kk>0)&&(kk<(int)KOL_SERV);)
							{
								READ_BD(kk);
								if((BD_OSN[0]==3)||(BD_OSN[0]==4))break;
								if(BD_OSN[0]==6)kk=BD_OSN[1];
								else kk=kk+shag;
							}
							jf = kk; //------------------------------------------------------- ����� FR3
							if((FR3[jf].byt[2]==0)&&(FR3[jf].byt[3]==0)) //------------- ���� ����������
							{
                jf=objserv;
								if((FR3[jf].byt[24]&0x80)==0)//----------------- ���� ������ �� ����������
								{
									FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
									New_For_ARM(objserv);
								}
							}
							while(objserv>0)
							{
								jf = objserv;
								READ_BD(jf);
								if(((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;

								//----------------------------------------------- ����� �������� ���������
								if((FR3[jf].byt[1]==0)&&(FR3[jf].byt[3]==0)&&
								(FR3[jf].byt[5]==0)&&(FR3[jf].byt[7]==0)&&(ii))
								{
									if((FR3[jf].byt[24]&0x80)==0)
									{
										FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
										New_For_ARM(objserv);

										if(BD_OSN[0]==5)//------------------------------------------ ���� ����
										{
											if(BD_OSN[1]!=0) //------ ���� ���� ����������� ���� � ������ ������
											{
												job = BD_OSN[1]; //----------------- ������ ���� � �������� ������

												//--------------------------------------- ����� �������� ���������
												FR3[job].byt[12]=0;FR3[job].byt[13]=0;
												FR3[job].byt[14]=0;FR3[job].byt[15]=0;
												FR3[job].byt[20]=0;FR3[job].byt[21]=0;
												New_For_ARM(job);
											}
										}
									}
								}
								ob_next=(FR3[jf].byt[20]&0xF)*256+FR3[jf].byt[21];
								//if(ii){
                FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;
                //}
								ii++;
								//---------------------- ��������� ���������� ������� �� ����������� �����
								objserv=ob_next;
							}
							break;

		case 48:  kod_cmd='F';//------------------------------------ ������ ��������� ��������
							ii=0;
              for(i_m=0;i_m<Nst*3;i_m++)
              {
                for(i_s=0;i_s<Nst;i_s++)
                {
                  for(i_sig=0;i_sig<10;i_sig++)
                  {
                    if(MARSHRUT_ALL[i_m].SIG[i_s][i_sig]==objserv)
                    {
                      DeleteMarsh(i_m);
											add(i_m,8888,15);
                    }
                  }
                }
              }
              READ_BD(objserv);
              if(BD_OSN[1]==0)shag=-1;
              else shag=1;
              for(kk=objserv + shag;(kk>0)&&(kk<(int)KOL_SERV);)
              {
                READ_BD(kk);
                if((BD_OSN[0]==3)||(BD_OSN[0]==4))break;
                if(BD_OSN[0]==6)kk=BD_OSN[1];
                else kk=kk+shag;
              }
              jf=kk;
              if((FR3[jf].byt[2]==0)&&(FR3[jf].byt[3]==0))
              {
                jf=objserv;
                if((FR3[jf].byt[24]&0x80)==0)
                {
                  FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
                  FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
									New_For_ARM(objserv);
								}
              }

							while(objserv)
							{
								jf=objserv;
								//---------------------------------------------- ������������, ���� ������
								READ_BD(jf);

								//----------------- ���� ������ ������ ���� �� ������, �� �� ������ ������
                if(BD_OSN[0]==2)
                {
                	if(((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;
                	else FR3[jf].byt[20] = 0;
                }

								if((BD_OSN[0]==7)&&(BD_OSN[1]==15))//---------- ���� �� ��� ������� � ����
								{
                  sp_in_put=BD_OSN[3];
                  FR3[sp_in_put].byt[12]=0;FR3[sp_in_put].byt[13]=0;
									FR3[sp_in_put].byt[14]=0;FR3[sp_in_put].byt[15]=0;
									New_For_ARM(sp_in_put);
									spar_sp=BD_OSN[5];
									if(spar_sp!=0)
									{
										FR3[spar_sp].byt[12]=0;FR3[spar_sp].byt[13]=0;
										FR3[spar_sp].byt[14]=0;FR3[spar_sp].byt[15]=0;
										New_For_ARM(spar_sp);
									}
                }

								if(BD_OSN[0]==5) //--------------------------------------------- ���� ����
								{
									if(BD_OSN[1]!=0)
									{
										job=BD_OSN[1];
										//------------------------------------------- ����� �������� ���������
										FR3[job].byt[12]=0;FR3[job].byt[13]=0;
										FR3[job].byt[14]=0;FR3[job].byt[15]=0;
										//FR3[job].byt[20]=0;FR3[job].byt[21]=0;
										New_For_ARM(job);
									}
								}

								//----------------------------------------------- ����� �������� ���������
								if((FR3[jf].byt[1]==0)&&(FR3[jf].byt[3]==0)&&
                (FR3[jf].byt[5]==0)&&(FR3[jf].byt[7]==0)&&(ii))
                {
									//--------------------------------------------- ����� �������� ���������
                  FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
									FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
									New_For_ARM(objserv);
								}
								ob_next=(FR3[jf].byt[20]&0xF)*256+FR3[jf].byt[21];
								if(ii){FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;}
								ii++;
								objserv=ob_next;
							}
							break;
    case 111:
		case 49:  kod_cmd='A';break;

    case 112:
		case 50:  kod_cmd='B';break;

		case 62:  kod_cmd='B';break;

		case 85:  jf=objserv;
							//------------------------------------------------- ����� �������� ���������
              FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
							FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;
							New_For_ARM(objserv);
							return;


		//--------------------------------------------------------------- ������������ �������
		case 108: MAKE_AVTOD(objserv);
							return;

    default: return;
  }
  ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}

//========================================================================================
//----------------------------- ZAGRUZ_KOM_UVK - ������ �������� ���������� ������� � ����
void __fastcall TStancia::ZAGRUZ_KOM_UVK(char tms,char grp,char pdgrp,char bt,char kd_cmd)
//----------------------------------------------------------------------- tms - ����� ����
//----------------------------------------------------------------------- grp - ��� ������
//------------------------------------------------------------------ pdgrp - ��� ���������
//------------------------------------------------------------------- kd_cmd - ��� �������
//------------------------------------------------------------- bt ����� ����� � ���������
//------------------------------- int BD_OSN[16] - ������ �������� ������� ���������� � ��
{
	int i,j;
	char adr_kom;
	for(i=0;i<15;i++)KOMANDA_ST[tms-1][i]=0;
#ifdef ORSK
	switch(tms)
	{
		case 1 : adr_kom = 'G'; break;
		case 2 : adr_kom = 'K'; break;
		case 3 : adr_kom = 'M'; break;
		case 4 : adr_kom = 'N'; break;
		case 5 : adr_kom = 'S'; break;
		case 6 : adr_kom = 'U'; break;
		case 7 : adr_kom = 'V'; break;
		case 8 : adr_kom = 'Y'; break;
		default : return;
	}
#else
  adr_kom = 0x40;
  if(tms == 1)adr_kom = adr_kom | 1;
  if(tms == 2)adr_kom = adr_kom | 2;
	if(STATUS == 1)
  {
		if(NUM_ARM == 1) adr_kom = adr_kom | 4;
    if(NUM_ARM == 2) adr_kom = adr_kom | 8;
  }
#endif
	KOMANDA_ST[tms-1][0] = '(';
	KOMANDA_ST[tms-1][1] = adr_kom; //----------------------------------- ������������ �����
	KOMANDA_ST[tms-1][2] = grp;
	KOMANDA_ST[tms-1][3] = pdgrp;
	for(j=4;j<10;j++)KOMANDA_ST[tms-1][j] = '|';
	KOMANDA_ST[tms-1][3+bt] = kd_cmd;
	KOMANDA_ST[tms-1][10] = check_summ(KOMANDA_ST[tms-1]);
	KOMANDA_ST[tms-1][11] = ')';
	KOMANDA_ST[tms-1][12] = 0;
	return;
}
/****************************************************\
*         int check_summ(unsigned char reg[12])      *
* ��������� �������� ����������� ����� ��� ����      *
\****************************************************/
char __fastcall TStancia::check_summ(const char *reg)
{
  char sum=0;
  int ic;
  for(ic=1;ic<10;ic++)sum=sum^reg[ic];
  sum=sum|0x40;
  return(sum);
}

//========================================================================================
//--------------- sp_up_and_razd ������ ������������ ���������� ������ �� ��,�� � ��������
//------------------------------------------ command - ���� ����������� ������� �� �������
//--------------------- int BD_OSN[16] - ������ �������� ������� ���������� ��� ��,�� � ��
void __fastcall TStancia::sp_up_and_razd(	unsigned char command,
																					unsigned int objserv,
																					int arm)
{

	unsigned char tums,//------------------------------------------------------ ����� ������
	gruppa, //----------------------------------------------- ��� ������ ��� ������� �������
	podgruppa, //------------------------------------------------------------- ��� ���������
	kod_cmd, //----------------------------------------------------------------- ��� �������
	bit;    //---------------------------------------------- ����� ����� ��� ������� �������
	int job;
	unsigned int str_prav=0,sp_prav=0;
	tums=(BD_OSN[13]&0xff00)>>8;
	gruppa='F';
	podgruppa=BD_OSN[15]&0xff;
	switch(command)
	{
		case 85:  job=objserv;
							//����� �������� ���������
							FR3[job].byt[12]=0;FR3[job].byt[13]=0;
              FR3[job].byt[14]=0;FR3[job].byt[15]=0;
							FR3[job].byt[20]=0;FR3[job].byt[21]=0;
							New_For_ARM(objserv);
							return;
						 //�������� ��������
		case 33:  FR4[objserv]=FR4[objserv]|4;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
							READ_BD(objserv);
							if((BD_OSN[0] == 3)&&(BD_OSN[3]!=0)) //���� �� � � ������
							{
								str_prav = BD_OSN[3]&0xff;
								READ_BD(str_prav); sp_prav =(BD_OSN[6]&0xFF00)>>8;
								FR4[sp_prav]=FR4[sp_prav]|4;
								NOVIZNA_FR4[new_fr4++]=sp_prav;//��������� ����� ������������ �������
								if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
							}
							return;
		case 34:  FR4[objserv]=FR4[objserv]&0xFB;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
							READ_BD(objserv);
							if((BD_OSN[0] == 3)&&(BD_OSN[3]!=0)) //���� �� � � ������
							{
								str_prav = BD_OSN[3]&0xff;
								READ_BD(str_prav); sp_prav =(BD_OSN[6]&0xFF00)>>8;
								FR4[sp_prav]=FR4[sp_prav]&0xFB;
								NOVIZNA_FR4[new_fr4++]=sp_prav;//��������� ����� ������������ �������
								if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
							}

							return;
        //�������� �������� �� �����������
		case 118: FR4[objserv]=FR4[objserv]|8;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� �������� �� �����������
		case 119: FR4[objserv]=FR4[objserv]&0xF7;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
   //�������� �������� �� ����������� ����������� ����
    case 120:  FR4[objserv]=FR4[objserv]|2;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� �������� �� ����������� ����������� ����
    case 121: FR4[objserv]=FR4[objserv]&0xFD;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
   //�������� �������� �� ����������� ����������� ����
    case 122:  FR4[objserv]=FR4[objserv]|1;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
							return;
    //������� �������� �� ����������� ����������� ����
    case 123: FR4[objserv]=FR4[objserv]&0xFE;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    case 66:  kod_cmd='L';break; //�������� �������� ������� ���

    case 6:
    case 9:
		case 10:
		case 2:
		case 1:   if(KNOPKA_OK == 1){kod_cmd='T';break;}
							else return;
		case 55:  if(KNOPKA_OK == 1){kod_cmd='O';break;}
							else return;
		case 98:	if(KNOPKA_OK != 1){kod_cmd = 'O'; break;}
							else return;

		case 193:

		case 198:
		case 201:
		case 202:
		case 194:
#ifndef TEST
							if(KNOPKA_OK == 1)
#endif
							{kod_cmd='S';break;}
#ifndef TEST
							else return;
#endif
		default: return;
	}
	bit=(BD_OSN[15]&0xe000)>>13;
	ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
	return;

}
/*************************************************************************\
* puti - ������ ������������ ���������� ������ ��� ����                   *
* command - ���� ����������� ������� �� �������                           *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� ���� � ��       *
\****************************************************************�********/
void __fastcall TStancia::puti(unsigned char command,unsigned int objserv)
{
  int job;
  job=objserv;
  switch(command)
  { //������������ ����
    case 85:  //����� �������� ���������
              FR3[job].byt[12]=0;FR3[job].byt[13]=0;FR3[job].byt[14]=0;FR3[job].byt[15]=0;
							FR3[job].byt[20]=0;FR3[job].byt[21]=0;
							New_For_ARM(objserv);
							READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                //����� �������� ���������
                FR3[job].byt[12]=0;FR3[job].byt[13]=0;FR3[job].byt[14]=0;FR3[job].byt[15]=0;
                FR3[job].byt[20]=0;FR3[job].byt[21]=0;
								New_For_ARM(job);
							}
              return;
    //�������� �������� �� ����
		case 33:  FR4[objserv]=FR4[objserv]|4;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
								job=BD_OSN[1];
                FR4[job]=FR4[job]|4;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
    //������� �������� �� ����
    case 34:  FR4[objserv]=FR4[objserv]&0xFB;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]&0xFB;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
    //�������� �������� �� ����������� �� ����
    case 118: FR4[objserv]=FR4[objserv]|8;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]|8;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
			  }
              return;
    //������� �������� �� ����������� �� ����
    case 119: FR4[objserv]=FR4[objserv]&0xF7;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]&0xF7;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
   //�������� �������� �� ����������� ����������� ���� �� ����
    case 120:  FR4[objserv]=FR4[objserv]|2;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]|2;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
    //������� �������� �� ����������� ����������� ���� �� ����
    case 121: FR4[objserv]=FR4[objserv]&0xFD;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
               READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]&0xFD;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
							return;
   //�������� �������� �� ����������� ����������� ���� �� ����
    case 122:  FR4[objserv]=FR4[objserv]|1;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]|1;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
    //������� �������� �� ����������� ����������� ���� �� ����
    case 123: FR4[objserv]=FR4[objserv]&0xFE;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              READ_BD(job);
              if(BD_OSN[1]!=0)
              {
                job=BD_OSN[1];
                FR4[job]=FR4[job]&0xFE;
                NOVIZNA_FR4[new_fr4++]=job;//��������� ����� ������������ �������
                if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              }
              return;
    default: return;
  }
}
/*************************************************************************\
* dopoln_obj - ������ ������������ ���������� ������ ��� ���.��������     *
* command - ���� ����������� ������� �� �������                           *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� ������� � ��    *
\****************************************************************�********/
void __fastcall TStancia::dopoln_obj(unsigned char command,int arm)
{
  unsigned char tums,//����� ������
  gruppa,//��� ������ ��� �������
  podgruppa, //��� ��������� ��� �������
  kod_cmd, //��� ������� ��� �������
  bit;    //����� ����� ��� ������� �������
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='Q';
  podgruppa=BD_OSN[15]&0xff;
  switch(command)
  {
    case 13:if(KNOPKA_OK == 1){kod_cmd='T';break;}
    else return;

    case 204: if(KNOPKA_OK == 1){kod_cmd='S';break;}
    else return;

    case 8:
    case 200: if(KNOPKA_OK == 1){kod_cmd='X';break;}
    else return;

    case 55: kod_cmd='N';break;


    case 98: kod_cmd='O';break;

    case 199:   //
    case 195:
    case 202:
    case 3:
    case 4:
    case 6:
    case 7:
    case 12:
    case 194:
    case 196:
    case 2:  if(KNOPKA_OK == 1){kod_cmd='T';break;}
    else return;

    case 56: kod_cmd='N';break;

    case 53:
    case 75:
    case 105:
    case 67:
    case 61: kod_cmd='A';break;

    case 5: if(KNOPKA_OK == 1){kod_cmd='T';break;}
            else return;

    case 197: if(KNOPKA_OK == 1){kod_cmd='T';break;}
              else return;

    case 198: if(KNOPKA_OK == 1) {kod_cmd='S';break;}
              else return;

    case 113:
    case 106:
    case 68: kod_cmd='M';break;

    case 63: kod_cmd='A';break;

    case 30:
    case 76:
    case 78:
    case 59: kod_cmd='B';break;




    case 128:
    case 86:
    case 77: kod_cmd='N';break;

    case 58:
    case 57: kod_cmd='A';break;


    case 60:
    case 89: kod_cmd = 'O'; break;

    //case 56: kod_cmd = 'F';break;
    default: return;
  }
  bit=(BD_OSN[15]&0xe000)>>13;
  ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}
//========================================================================================
//------------------ prosto_komanda ������ ������������ ���������� ������ ��� ���.��������
void __fastcall TStancia::prosto_komanda(unsigned char command)
//------------------------------------------ command - ���� ����������� ������� �� �������
//------------------------------- int BD_OSN[16] - ������ �������� ������� ���������� � ��
{
	unsigned char tums,//------------------------------------------------------ ����� ������
	gruppa,//------------------------------------------------ ��� ������ ��� ������� �������
	podgruppa, //------------------------------------------------- ��� ��������� ��� �������
	kod_cmd, //----------------------------------------------------- ��� ������� ��� �������
	bit;    //---------------------------------------------- ����� ����� ��� ������� �������
	int ii;
	if((BD_OSN[0]<8)||(BD_OSN[0]>250))
	{
		for(ii=0;ii<16;ii++)BD_OSN[ii]=0;
		return;
	}
	tums=(BD_OSN[13]&0xff00)>>8;
	gruppa='Q';
	podgruppa=BD_OSN[15]&0xff;
	switch(command)
	{

		case 64: kod_cmd='A';break;
		case 65: kod_cmd='M';break;

		case 87: kod_cmd='B';break;
		case 88: kod_cmd='N';break;

		default: return;
	}
	bit=(BD_OSN[15]&0xe000)>>13;
	ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
	return;
}//========================================================================================
//========================================================================================
//----------------------------------------- ��������� ������ ������� �� ������ �����������
void __fastcall TStancia::ob_tums(unsigned char command)
{
	unsigned char tums,//------------------------------------------------------ ����� ������
	gruppa, //----------------------------------------------- ��� ������ ��� ������� �������
  podgruppa, //------------------------------------------------- ��� ��������� ��� �������
	kod_cmd, //----------------------------------------------------- ��� ������� ��� �������
  bit;    //---------------------------------------------- ����� ����� ��� ������� �������
  int ii;
  if((BD_OSN[0]&0xf)!=9){for(ii=0;ii<16;ii++)BD_OSN[ii]=0;return;}
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='L';
  podgruppa=BD_OSN[15]&0xff;
  switch(command)
  {

    case 97: kod_cmd='D';break;
    default: return;
  }
  bit=(BD_OSN[15]&0xe000)>>13;
  ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}
//========================================================================================
void __fastcall TStancia::otmena_rm(unsigned int objserv)
//---------------------- otmena_rm - ������ ������������ ������� ������ ���������.��������
//------------------------ int BD_OSN[16] - ������ �������� ������� ���������� ��� �� � ��
//------------------------ unsigned int objserv - ������ � ������� ��� ����������� �������
{
  unsigned char tums,//------------------------------------------------------ ����� ������
  gruppa, //----------------------------------------------- ��� ������ ��� ������� �������
  podgruppa, //------------------------------------------------------------- ��� ���������
  kod_cmd, //----------------------------------------------------------------- ��� �������
  bit,    //---------------------------------------------- ����� ����� ��� ������� �������
  ii;     //--------------------------------------------------- ��������������� ����������
  int jf;
  unsigned int ob_next;
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='Q';
  podgruppa=BD_OSN[15]&0xff;
	kod_cmd='N';//------------------------------------------------------------------- ������
  ii=0;
  objserv=BD_OSN[1];
  while(objserv)
  {
    jf=objserv;
    if(((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;
    ii++;
    //----------------------------------------------------------- ����� �������� ���������
    if((FR3[jf].byt[12])||(FR3[jf].byt[13])||(FR3[jf].byt[14])||(FR3[jf].byt[15]))
    {
      //--------------------------------------------------------- ����� �������� ���������
      FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
			FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
			New_For_ARM(objserv);
		}
    ob_next=(FR3[jf].byt[20]&0xF)*256+FR3[jf].byt[21];
    FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;
    //---------------------------------- ��������� �� ����������� ����� ���������� �������
    objserv=ob_next;
  }
  bit=(BD_OSN[15]&0xe000)>>13;
  ZAGRUZ_KOM_UVK(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}
//========================================================================================
//------------------------------------------ ������ ������������ � ������� ������ ��������
int __fastcall TStancia:: ANALIZ_MARSH(unsigned int KOM,
unsigned int NACH,int END,int Nstrel,unsigned long POL)
//---------------------------------------- KOM - ��� ���������� ������� ���������� �� ����
//---------------------------------------------- NACH - ������ ������� ��� ������ ��������
//----------------------------------------------- END  - ������ ������� ��� ����� ��������
//------------------------------- Nstrel - ����� ��������������� ������� � ������ ��������
//-------------------------- POL - ������� ������ ���������� ��������� ������� ��� �������
{
	unsigned int ERROR_MARSH=0, //----------------------------------- ��� ������ �����������
	PROHOD=0; //-------------------------------------------------- ���� ������������ �������
	char kod_marsh=0; //----------------------------------------- ��� ������������� ��������
	int shag=0, //------------------------------------------------- ��� �������� �� ��������
	ind_str[Nst],//-------------------------------- ������ ������� ������� �������� � ������
	ind_sp[Nst], //----------------------------- ������ ������� ���������� �������� � ������
	ind_sig[Nst],//-------------------- ������ ������� ������� ����������� �������� � ������
	ii=0,  //-------------------------------------------------------- ������ �������� � ����
	jj=0,//-------------------------------------------------------- ������ �������� � ������
	tek_strel=0, //----------------------------------- ������� ����� ��������������� �������
	stroka_tek, //---------------------------------------- ������ ��������� �������� �������
	stroka_pred, //------------------------------------ ������ ��������� ����������� �������
  i_s, //------------------------------------------------------------------- ������ ������
	i_m; //------------------------------------------------------ ��������������� ����������
	int n_sig=0,tums;
	unsigned int  kod_beg=0, //------------ ��� ���������� ������ ��� ������������� ��������
								kod_end=0; //------------- ��� ���������� ����� ��� ������������� ��������
	ZeroMemory(&TRASSA,sizeof(TRASSA));//----------------------------------- �������� ������
	ZeroMemory(&ind_sig,sizeof(ind_sig)); //--------------------- �������� �������� ��������
	ZeroMemory(&ind_str,sizeof(ind_str)); //---------------------- �������� �������� �������
	ZeroMemory(&ind_sp,sizeof(ind_sp)); //------------------------- �������� �������� ������
	KOM=KOM&0xFF;
	switch(KOM)
	{
		case 188:
		case 191: kod_marsh='a';break;    //--------------------------------------- ����������

		case 189:
  	case 192: kod_marsh='b';break;     //---------------------------------------- ��������

		case 71:  kod_marsh='d';break;    //------------------------------------------ �������

		default: kod_marsh=0;ERROR_MARSH=1005;break; //--------------------------- �����������
	}
	READ_BD(NACH); //-------------------------------- ��������� ���� ��� ���������� ��������

	if(BD_OSN[1]==0)shag=-1;//------------------------------------------- ���� ������ ������
	else
		if(BD_OSN[1]==1)shag=1;//---------------------------------------- ���� ������ ��������
		else return(1001); //------------- ���� ������ ����� ������������ �������� �����������

	if(BD_OSN[0]!=2)ERROR_MARSH=1001; //--------------- ���� ������� ���������� �� � �������
	else
	//------------------------------------------- ���� ������� ����������, � ������ ��������
	if(((KOM==191)||(KOM==188)||(KOM==71))&&(BD_OSN[6]==1))ERROR_MARSH=1002;
	else
	//------------------------------------------- ���� ������� ��������, � ������ ����������
	if(((KOM==192)||(KOM==189))&&(BD_OSN[6]==0))ERROR_MARSH=1003;
	else
	{ ii = NACH; //---------------------------------------- ��������� ������ ������ ��������
		TRASSA[jj].stoyka=(BD_OSN[13]&0x0f00)>>8;//---------------- ������� ������ ��� �������
		stroka_tek = (BD_OSN[14]&0xFF00)>>8; //------------------- ������ ��������� ��� ������
		stroka_pred = stroka_tek;            //----------------------- ��������� ���� ����� ��
		i_m=0;
		//-------------------------------- �������� ������� ����� �� ��������, ��������� �����
		while((MARSHRUT_ALL[i_m].NACH != NACH)&& //-------------------- ���� �� ����� ������ �
		(MARSHRUT_ALL[i_m].END != END))//-------------------------------------- �� ����� �����
		{
			i_m++; //-------------------------------- ������������ �� ������ ��������� � �������
			if(i_m >= Nst*3)break;
		}

		if(i_m >= Nst*3)//----------------------------------- ���� ������������� ������� �����
		{
			i_m=0;
			while(MARSHRUT_ALL[i_m].NACH !=0 )//------ ���� � ���������� ������� ��������� �����
			{
				i_m++;
				if(i_m >= (Nst*3))break;
			}

			if(i_m>=(Nst*3))ERROR_MARSH=1004; //------------------ � ������� ��������� ��� �����

		}
		else
		{
				if(POVTOR_OTKR != 0)DeleteMarsh(i_m);
				else return(25000);
		}

		if(ERROR_MARSH==0)//--- ���� ���� ��� ��������� - �������� �������� �������� � �������
		{
			MARSHRUT_ALL[i_m].KMND=kod_marsh;
			MARSHRUT_ALL[i_m].NACH=NACH;
			MARSHRUT_ALL[i_m].END=END;
			MARSHRUT_ALL[i_m].NSTR=Nstrel;
			MARSHRUT_ALL[i_m].POL_STR=POL;
			add(NACH,7777,END);
			for(ii=0;ii<Nst;ii++)MARSHRUT_ALL[i_m].KOL_STR[ii] = 0;
		}

		ii = NACH;

		if(ERROR_MARSH<1000)ERROR_MARSH = i_m;

		if(ERROR_MARSH<1000)
		while(jj<200) //----------------------- ������ �� ���� ��������� ������������ ��������
		{
			READ_BD(ii);                          //----------- ��������� ��������� ������� ����
			stroka_tek=(BD_OSN[14] & 0xFF00)>>8;  //------------ �������� ������� ������� ������
			TRASSA[jj].stoyka = (BD_OSN[13] & 0x0f00)>>8; //------------------- ��������� ������
			if((BD_OSN[0]<7)&&(BD_OSN[0]>0))tums = TRASSA[jj].stoyka-1;
			TRASSA[jj].tip=BD_OSN[0]&0xff;
			switch(BD_OSN[0])//------------------------ ����� ��������� � ����������� �� �������
			{
				//------------------------------------------------------------------- ���� �������
				case 1: if(FR3[ii].byt[9] != 0)return(2000+ii); //------ ������� �������� ��������
								if(FR3[ii].byt[11] != 0)return(3000+ii); //----------- ������� �����������
								//------------------------------ ������� ������� � ������ ������� ��������
								if(((BD_OSN[7]==0) && (shag == -1))|| //----- ���� ������� ���������������
								((BD_OSN[7]==1) && (shag == 1)))
								{
										if((BD_OSN[8]&0x4000) == 0x4000) //- ���� ������� �� ���������� �� ���
										{
												if((BD_OSN[8]&0x8000) == 0)//---------------- ���� ����� �� ������
												{
													MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii;
													TRASSA[jj].object=ii|0x4000;
													if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//������� �� � �����
													{
														//------------------------ ��������� ����� ����������� �������
														MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++;

														//-------------------------------- �������� ��������� ��������
														MARSHRUT_ALL[i_m].SOST = MARSHRUT_ALL[i_m].SOST&0xC0;

														//----------------------- ���������� ��������� ������ ��������
														MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;
													}
													ii=ii+shag;
												}
												else  //���� ����� �� �����, � ������ ������� ������ ���� � ������
												{
													MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii | 0x1000;
													TRASSA[jj].object=ii|0xC000;
													if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))//- ���� �� � ������
													{
														MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++; // �������++
														MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST&0xC0;//���������
														MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;//������ �����
													}
													ii=BD_OSN[2];
												}
												if((BD_OSN[8]&0x2000)==0x2000)//----------- ���� ��� �������� ����
												{
													TRASSA[jj].object=ii|0x2000;
												}
												break;
											}
											//----------------------------------------- ���� ������ �� ���������
											if(tek_strel>Nstrel)
											{ERROR_MARSH=1006;break;}//----------- ������� ������, ��� � �������

											if((POL&(1<<tek_strel))==0)//----- ���� ������ ������� ����� � �����
											{
												//-------------------------------------------------------------$$3
												//---------------------- �������� ������� � ������ � ��������� "+"
												MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii;
												TRASSA[jj].object=ii|0x4000;
												if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//- ������� �� � �����
												{
													MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++;   // �������++
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST&0xC0;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;
												}
												ii=ii+shag;
											}
											else
											{
												//-------------------------------------------------------------$$4
												MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii|0x1000;
												TRASSA[jj].object=ii|0xC000; //�������� ������� � ������ � "-"
												if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))// ������� �� � ������
												{
													MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST&0xC0;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;
												}
												ii=BD_OSN[2];//����������� ������� �� ������ �������
											}
											tek_strel++;
										}
										else
										if(((BD_OSN[7]==1)&&(shag==-1))|| //���� ������� ����������
										((BD_OSN[7]==0)&&(shag==1)))
										{
											if(stroka_tek!=stroka_pred)//���� ���������� ������ � ������ ������
											{
												//-------------------------------------------------------------$$5
												MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii|0x1000;
												TRASSA[jj].object=ii|0x8000;  //--------- �������� � ��������� "-"
												if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))//-- ����  �� � ������
												{
													MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST&0xC0;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;
												}
											}
											else
											{
												//-------------------------------------------------------------$$6
												MARSHRUT_ALL[i_m].STREL[tums][ind_str[tums]++] = ii;
												TRASSA[jj].object=ii;//----------- �������� ������� � ������ � "+"
												if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//---- ���� �� � �����
												{
													MARSHRUT_ALL[i_m].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST&0xC0;
													MARSHRUT_ALL[i_m].SOST=MARSHRUT_ALL[i_m].SOST|3;
												}
											}
											ii=ii+shag;
										}
										break;

				case 6: TRASSA[jj].object=ii;
								//���� ���������� �������� �������� � ����������� �������� ����
								if((shag == 1)&&(BD_OSN[3] == 1))   //���� ��� �������� � ������� ��������
								{
									ii=BD_OSN[1];
									if(BD_OSN[2])
									{
											shag = -shag; //���� ��������� �������
											ii = ii + shag;
									}
								}
								else
								{
									if((shag==-1)&&(BD_OSN[3]==0))
									{
										ii=BD_OSN[1];
										if(BD_OSN[2])
										{
											shag = -shag;
											ii = ii + shag;
										}
									}
									else ii=ii+shag;
								}
								break;

				case 7: TRASSA[jj].object = ii;
								if(BD_OSN[1]==15)
								{
									ERROR_MARSH=ERROR_MARSH +
									ANALIZ_ST_IN_PUT(jj,kod_marsh, tums, i_m, ind_str[tums]);
								}

								if(BD_OSN[1]==14)	ERROR_MARSH =
								ERROR_MARSH + tst_str_ohr(jj,kod_marsh, tums, i_m, ind_str[tums]);

								ii=ii+shag;
								break;

			 default: TRASSA[jj].object = ii;
								if((BD_OSN[0]==3)||(BD_OSN[0]==4))
								{
									MARSHRUT_ALL[i_m].SP_UP[tums][ind_sp[tums]++] = ii;
								}
								if(BD_OSN[0]==2)//���� ������ �����렫
								{
									switch(shag)
									{ //�������� �����������
										case 1: switch(kod_marsh)
														{ //����������
															case 'a':
															case 'd':
																				kod_beg=256;
																				kod_end=1;
																				break;
															//��������
															case 'b': kod_beg=4096;
																				kod_end=16;
																				break;
															default:  ERROR_MARSH=1010; break;
														}
														break;
										//������ �����������
										case -1:  switch(kod_marsh)
															{ //����������
																case 'a':
																case 'd': kod_beg=1024; kod_end=4; break;
																//��������
																case 'b': kod_beg=16384; kod_end=64; break;
																default:  ERROR_MARSH=1010; break;
															}
															break;
										 default: ERROR_MARSH=1010;break;
									}
									if(ERROR_MARSH>1000)break;
									if((BD_OSN[11]&kod_beg)==kod_beg)//���� ���� ����� ������
									{
										TRASSA[jj].object=TRASSA[jj].object|0x8000;
										MARSHRUT_ALL[i_m].SIG[tums][ind_sig[tums]++]=ii;
									}

									if((BD_OSN[11]&kod_end)==kod_end)//����� ���� ����� �����
									TRASSA[jj].object=TRASSA[jj].object|0x4000;

									//���� � ������� ���� �������� ���������
									if(BD_OSN[6]) TRASSA[jj].object=TRASSA[jj].object|0x2000;

									//����� ��� ���������
									TRASSA[jj].podgrup=BD_OSN[15]&0x00ff;

									//����� ��� ������ ����� ��� ������� �������
									TRASSA[jj].kod_bit=(((BD_OSN[15]&0xe000)>>13)-1)|0x40;

									if((PROHOD==1)&&((BD_OSN[11]&kod_end)==kod_end))
									{
										if((BD_OSN[1]==0)&&(shag==-1))return(ERROR_MARSH);
										if((BD_OSN[1]==1)&&(shag==1))return(ERROR_MARSH);
									}
								}
								ii=ii+shag;
								break;
			}//����� ������������ �� ���� ������� ����
			if(ERROR_MARSH>1000)break;
			stroka_pred=stroka_tek;
			//���� ������ �� ���������
			if(tek_strel > Nstrel){ERROR_MARSH=1006;break;}

			if(ii==END)PROHOD=1; //���� ��������� ����� �������� - ���������� �������

			if((PROHOD==1)&&((TRASSA[jj].tip==5)||(TRASSA[jj].tip==4))) //���� ������ ����� �������� � ����� �� ���� ��� ��
			{
				jj++;  //�������� ����� �� ���� ��� ��
				READ_BD(ii);
				TRASSA[jj].object=ii;
				stroka_tek=(BD_OSN[14]&0xFF00)>>8;//�������� ������� ������� ������
				TRASSA[jj].stoyka=(BD_OSN[13]&0x0f00)>>8;//��������� ������
				TRASSA[jj].tip=BD_OSN[0]&0xff;
				if(ERROR_MARSH>1000)break;
				if(BD_OSN[0]==2)//���� ����� �� ������
				{
					switch(shag)
					{ //-------------------------------------- �������� �����������
						case 1:
							switch(kod_marsh)
							{ //����������
								case 'a':
								case 'd':	kod_beg=256; kod_end=1;  break;

								//��������
								case 'b': kod_beg=4096;	kod_end=16; break;
								default:  ERROR_MARSH=1010;break;
							}
							break;
						//---------------------------------------- ������ �����������
						case -1:
							switch(kod_marsh)
							{ //����������
								case 'a':
								case 'd': kod_beg=1024; kod_end=4; break;

								//��������
								case 'b': kod_beg=16384;	kod_end=64;  break;
								default:  ERROR_MARSH=1010;break;
							}
							break;

							default:  ERROR_MARSH=1010;break;
					}
					if(ERROR_MARSH>1000)break;

					if((BD_OSN[11]&kod_beg)==kod_beg)//���� ��� ������� ���� ����� ������
					{
						TRASSA[jj].object=TRASSA[jj].object|0x8000;  //�������� � ��������� ������ ������� ������� ������
						n_sig = ind_sig[tums]++;	//�������� ������ � ������ ��������
						MARSHRUT_ALL[i_m].SIG[tums][n_sig]=TRASSA[jj].object&0xfff;
					}
					if((BD_OSN[11]&kod_end)==kod_end)//���� ���� ����� �����
					TRASSA[jj].object=TRASSA[jj].object|0x4000;	//�������� � ��������� ������ ������� ������� �����

					//����� ��� ���������
					TRASSA[jj].podgrup=BD_OSN[15]&0x00ff;

					//����� ��� ������ ����� ��� �������� �������
					TRASSA[jj].kod_bit=(((BD_OSN[15]&0xe000)>>13)-1)|0x40;

					//���� ���������� ����� � ����� ���� �����
					if((PROHOD==1)&&((BD_OSN[11]&kod_end)==kod_end))
					{
						if((BD_OSN[1]==0)&&(shag==-1))return(ERROR_MARSH);
						if((BD_OSN[1]==1)&&(shag==1))return(ERROR_MARSH);
					}
				} //����� ������� �������
				break;
			}//����� ������� ������� �� �������� ��������
			jj++;
			if(ERROR_MARSH>1000)break;
			if(jj>=200)break;
		}
 		if(ERROR_MARSH>1000)ZeroMemory(&TRASSA,sizeof(TRASSA));//���� ������ � ������, �� �� ���������� � ������ �� ������
	}
	return(ERROR_MARSH);
}
//========================================================================================
//---------------------------- TUMS_MARSH() - ������ �������� ���������� ������ ����� ����
int __fastcall TStancia::TUMS_MARSH(int i_m)
//----------------------------------------------   NACH - ��������� ������ ������ ��������
//------------------------------------------------	 END - ��������� ������ ����� ��������
{
	int ii=0,last_end,first_beg,jj,sosed,i_s=0,s_m,test=0;
	int str_in_put,pol_str,sp_in_put,spar_sp,result;
	unsigned char tums_tek,tums_pred,adr_kom,perevod_str;
	unsigned char n_strel,kmnd;
	unsigned int objk, objk_next, fiktiv=0, nachalo=0,END;
	unsigned long pol_strel=0l;
  result = -1;
	if(TRASSA[0].object) //----------------------------------- ���� � ������ ������� �������
	{
		//-------------------------- ���� � ������ �� ��� �������, ������� ����� �� ����������
		if(MARSHRUT_ALL[i_m].NACH!=(TRASSA[0].object&0xfff))
		{
			ZeroMemory(&TRASSA,sizeof(TRASSA));
      return(-1);
		}
		else
		{
			kmnd=MARSHRUT_ALL[i_m].KMND; //--------------------------------------- ����� �������
			END=MARSHRUT_ALL[i_m].END;
		}
		ii=0;
		last_end = -1, first_beg = -1; //---------------------------- ���������� ������ ������
		tums_pred=TRASSA[0].stoyka;
		tums_tek=tums_pred; //----------------------------------------------------- ����� ����
		//---------------------------------------------- ��������� ����� �� ���������� �������
		for(i_s=0;i_s<Nst;i_s++)test=test+MARSHRUT_ALL[i_m].KOL_STR[i_s];
		if(test==0)perevod_str=0;
		else perevod_str=0xf;
		while(ii<200) //----------------------------------------------- ������ �� ���� ������
		{ if((TRASSA[ii].tip==2)||(TRASSA[ii].tip == 0))  //----- ���� ������ ��� ����� ������
			{ tums_tek=TRASSA[ii].stoyka; //------------------------ �������� ������ ��� �������
				if(tums_tek!=tums_pred) //--------------------------- ���� ������� � ������ ������
				{ if((first_beg&0x8000)==0x8000) //--------------------- ���� ��������� ������ ���
					{ last_end=-1;first_beg=-1;tums_tek=tums_pred; } //----- �������� ������ � �����
				}
				if(tums_tek!=tums_pred) //--------------------------- ���� ������� � ������ ������
				{
					if((last_end!=-1)&&(first_beg!=last_end)) //----------- ���� ���� ����� � ������
					{
						i_s=tums_pred-1;
						MARSHRUT_ALL[i_m].STOYKA[i_s]=1; //-- �������� ��������� ������ � ���� �������

						if(perevod_str!=0) //------------------- ���� ������� ������� �������� �������
						{
							MARSHRUT_ALL[i_m].SOST=0x43; //------------------------- ��������������� ���
							if(MARSHRUT_ALL[i_m].KOL_STR[i_s]!=0) //--- ���� � ���� ������ ����� �������
							{
								MARSHRUT_ALL[i_m].STOYKA[i_s]=2;//-------- ��������� ��������� � ���������
							}
							else	goto NEXT;
						}
						else //---------------------------------------- ���� ������� ����� �� ��������
						{
							MARSHRUT_ALL[i_m].SOST=0x83; //--------------------- ������� ���������������
						}
						s_m = 0;
						for(s_m=0;s_m<3;s_m++)
						if((MARSHRUT_ST[i_s][s_m]->NUM-100)==i_m)break;

						if(s_m>=3) //--------------------------------- ���� ������ ������� �� � ������
						{
							s_m = 0;
							for(s_m=0;s_m<3;s_m++)
							if(MARSHRUT_ST[i_s][s_m]->NUM==0)break;
						}

						if(s_m>=3) goto out; //---------- ���� ��� ��������� ����� � ��������� �������
						//--------------------------------------------------------- ������������ �����
#ifdef ORSK
						switch(tums_pred)
						{
							case 1: adr_kom='G';break;
							case 2: adr_kom='K';break;
							case 3: adr_kom='M';break;
							case 4: adr_kom='N';break;
							case 5: adr_kom='S';break;
							case 6: adr_kom='U';break;
							case 7: adr_kom='V';break;
							case 8: adr_kom='Y';break;
							default:return;
						}
#else
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[0]='(';
						adr_kom=0x40;
						if(tums_pred==1)adr_kom=adr_kom|1;
            if(tums_pred==2)adr_kom=adr_kom|2;

						if((STATUS==1)&&(NUM_ARM==1))adr_kom=adr_kom|0x4;
						if((STATUS==1)&&(NUM_ARM==2))adr_kom=adr_kom|0x8;
#endif


						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[1]=adr_kom;

						if(perevod_str==0)MARSHRUT_ST[i_s][s_m]->NEXT_KOM[2]=kmnd;
						else MARSHRUT_ST[i_s][s_m]->NEXT_KOM[2]=kmnd|8;

						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[3]=TRASSA[first_beg].podgrup;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[4]=TRASSA[first_beg].kod_bit;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[5]=TRASSA[last_end].podgrup;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[6]=TRASSA[last_end].kod_bit;
						n_strel=0;
						pol_strel=0;

						for(jj=first_beg;jj<=last_end;jj++)
						{
							if(TRASSA[jj].tip==1)//���� �������
							{
								if((TRASSA[jj].object&0x4000)==0x4000)//------------- ���� ���������������
								{
									if((TRASSA[jj].object&0x2000)!=0x2000) //------------- ���� ��� ��������
									{
										if((TRASSA[jj].object&0x8000)==0x8000)//---------------- ���� � ������
										{
											pol_strel=pol_strel|(1<<n_strel);
										}
										n_strel++;
									}
								}
							}
						}
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[7]=0x40|n_strel;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[8]=0x40|(pol_strel&0x3f);
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[9]=0x40|((pol_strel&0xFC0)>>6);
						//for(jj=1;jj<10;jj++)sum=sum^MARSHRUT_ST[i_s][s_m].NEXT_KOM[jj];
						//sum=sum|0x40;
						//MARSHRUT_ST[i_s][s_m].NEXT_KOM[10]=sum;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[10]=0;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[11]=')';
						KOL_VYD_MARSH[i_s] = 0;
            result = 0;
						add(i_s,6666,s_m);

						//-------------------------------- ������������� ��������� ���������� ��������
						if(perevod_str!=0)MARSHRUT_ST[i_s][s_m]->SOST=0x47;
						else	MARSHRUT_ST[i_s][s_m]->SOST=0x87;

						MARSHRUT_ST[i_s][s_m]->NUM=i_m + 100; //----- ���������� ����� ������ ��������

						if(MARSHRUT_ST[i_s][s_m]->NEXT_KOM[3]==0)fiktiv=0xf;
						else fiktiv=0;


 NEXT:      for(jj=first_beg; jj<=(last_end+1); jj++)//-- ������ �� �������� ��� ���������
						{ if(fiktiv == 0)objk = TRASSA[jj].object&0xfff;
							else fiktiv = 0;

							if(objk == 0)break;

							objk_next = TRASSA[jj+1].object & 0xfff;
              /*
              if(TRASSA[jj].tip == 7)
							{
								READ_BD(objk);

								if((BD_OSN[0]==7)&&(BD_OSN[1]==15)&&
                ((kmnd=='b')||(kmnd=='j')))//---- ���� ������ � ��������� � ������� � ����
								{
									sp_in_put=BD_OSN[3]; //----------- �������� ������ ��� �� ������� � ����
									spar_sp=BD_OSN[5]; //�������� �� ��� ��������� �������
									FR3[sp_in_put].byt[12]=0;
									FR3[sp_in_put].byt[13]=1;  //�������� ��������������� ��������� ��
									New_For_ARM(sp_in_put);

									if(spar_sp!=0) //���� ���� �� ��� ��������� �������
									{
										FR3[spar_sp].byt[12]=0;
										FR3[spar_sp].byt[13]=1; //-- �������� ��������������� ��������� ��� ��
										New_For_ARM(spar_sp);
									}
								}
								FR3[objk].byt[20] = FR3[objk].byt[20]|(objk_next/256);
								FR3[objk].byt[21] = objk_next%256;
							}
							else //---------------------------------------------------------- ���� �� ��
              */
							if((TRASSA[jj].tip>=3)&&(TRASSA[jj].tip<=5))//-------------- ���� ��,��,����
							{
								if(nachalo)
								{
									if((TRASSA[jj].tip==3)||(TRASSA[jj].tip==4))
									{
										FR3[objk].byt[24]=nachalo/256;
										FR3[objk].byt[25]=nachalo%256;
										nachalo=0;
									}
								}
								//------------------------------------------ ���������� �������� ���������
								FR3[objk].byt[12]=0;
								FR3[objk].byt[13]=1;
                FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
								FR3[objk].byt[21]=objk_next%256;
								New_For_ARM(objk);
								if(TRASSA[jj].tip==5)  //--------------------------------------- ���� ����
                {
                  READ_BD(objk);
                  if(BD_OSN[1]!=0)//-------------------------------------- ���� ���� �����
                  {
                    sosed=BD_OSN[1];
                    FR3[sosed].byt[12]=0;
										FR3[sosed].byt[13]=1;
										New_For_ARM(sosed);
									}
								}
								if(nom_new>=KOL_NEW)nom_new=0; //- ���� �� �������� > 20 ������,������ � 0
              }
              else //--------------------------------------------------------- ���� ������
							if((TRASSA[jj].tip == 2) && (objk != END)) //---- ������ � �� ����� ��������
							{
								if((TRASSA[jj].object&0x8000) == 0x8000)//------- ���� ���� ������� ������
								{
									nachalo = objk;
									if(kmnd=='a') //-------------------------------- ���� ���������� �������
									{
										FR3[objk].byt[12]=0; FR3[objk].byt[13]=1;
									}
									if(kmnd=='b')  //--------------------------------- ���� �������� �������
									{
										if((TRASSA[jj].object&0x2000)==0x2000) //--------------- ���� ��������
										{
											FR3[objk].byt[14] = 0; FR3[objk].byt[15] = 1;
										}
									}
									FR3[objk].byt[20] = FR3[objk].byt[20]|(objk_next/256);

									//------------- ���� ���� ��������� ������ � ������ � ���������� �������
									if((s_m<3) && (objk_next>0) && (MARSHRUT_ST[i_s][s_m]->NEXT_KOM[3]!=0))
                  if((FR3[objk].byt[13]) || (FR3[objk].byt[15]))//���� ��� ������ ��������
									FR3[objk].byt[20] = FR3[objk].byt[20]|0x80;

									FR3[objk].byt[21] = objk_next%256;
									New_For_ARM(objk);
								}
								else //---------------------------------------- ���� �� ������� ������ ���
								{
									FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
									FR3[objk].byt[21]=objk_next%256;
								}
							}
							else //----------------------------------- ���� �� ������ ��� ����� ��������
							{
                if (objk_next != 0)
                {
									FR3[objk].byt[20] = FR3[objk].byt[20]|(objk_next/256);
									FR3[objk].byt[21] = objk_next%256;
                }
							}
						} //---------------------------------------------- ����� ������� ��� ���������
						first_beg = -1;
						last_end = -1;

            if(nachalo == (TRASSA[jj-1].object & 0xFFF)) //-- ���� �� ����. ������� ������
            {
              objk = TRASSA[jj-1].object & 0xFFF;
              FR3[objk].byt[13] = 0;
              FR3[objk].byt[15] = 0;
            }
					}
					else //----------------------------------------------- ���� ��� ������ ��� �����
					{
						if(last_end == first_beg)first_beg = -1;
						if(last_end == -1)first_beg = -1;
					}
				}

				tums_pred=tums_tek; //------------------------------------------ ���������� ������

				if((TRASSA[ii].object&0x8000) == 0x8000) //--- ���� ���� ������ ����� ���� �������
				{
					if(first_beg < 0) //------------ ���� ��������������� ������� �� ������� �������
					{
						if(first_beg == -1)first_beg = ii;
					}

					else //------------------------ ���� ��������������� ������� �� �������� �������
					{
						if(kmnd == 'b') //--------------------------------------------------- ��������
						{
							if((TRASSA[ii].object&0x2000)==0x2000) //--------------------- ���� ��������
							{
								if(first_beg == -1)first_beg = ii; //--------- ���� �� ���� ������ - �����
							}
							else //---------------------------------------- ���� ��� ��������� ���������
              if(first_beg==-1)first_beg=0x8000|ii; //----------------------- ������������
						}
						else
            if(first_beg == -1)first_beg = ii; //----------- ��� ����������� ������ ������
					}
				} //--------------------------------------------- ����� ������� ������� ��� ������

				if((TRASSA[ii].object&0x4000)==0x4000) //----------- ���� ������ ����� ���� ������
				{
					if(first_beg != -1)last_end = ii; //----------- ���� ���� ������, �� ����� �����
				}

				if((TRASSA[ii].object&0xC000) == 0) //------------------------ ���� ������ �������
				{
					objk=TRASSA[ii].object&0xfff;
					objk_next=TRASSA[ii+1].object&0xfff;
					FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
					FR3[objk].byt[21]=objk_next%256;
				}
			}
			if((TRASSA[ii].tip==0)&&(TRASSA[ii].object==0))break;
			ii++;//���� ������
			//����� ������� ��� ������� ���� 2���
			if(TRASSA[ii].tip==4)//���� ��
			{
				objk=TRASSA[ii].object&0xfff;
				objk_next=TRASSA[ii+1].object&0xfff;
				//���������� �������� ���������
				FR3[objk].byt[12]=0; FR3[objk].byt[13]=1;
				FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
				FR3[objk].byt[21]=objk_next%256;
				New_For_ARM(objk);
			}
			if(TRASSA[ii].tip>=6)//���� ������� ��� ��
			{
				objk=TRASSA[ii].object&0xfff;
				objk_next=TRASSA[ii+1].object&0xfff;
				//FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
				//FR3[objk].byt[21]=objk_next%256;
			}
		}
out:
    ZeroMemory(&TRASSA,sizeof(TRASSA));
    if(result < 0)
    {
	    for(i_s = 0; i_s < Nst; i_s++)
  	  for(s_m = 0; s_m < 3; s_m++)
    	{
    		if(MARSHRUT_ST[i_s][s_m]-> NUM == (i_m+100))
	      {
  	      for(jj=0;jj<14;jj++)MARSHRUT_ST[i_s][s_m]->NEXT_KOM[jj] = 0;
    	    MARSHRUT_ST[i_s][s_m]->NUM = 0;
      	  MARSHRUT_ST[i_s][s_m]->SOST = 0;
        	MARSHRUT_ST[i_s][s_m]->T_VYD = 0;
	        MARSHRUT_ST[i_s][s_m]->T_MAX = 0;
  	    }
    	}

	   	MARSHRUT_ALL[i_m].KMND = 0;
  	  MARSHRUT_ALL[i_m].NACH = 0;
    	MARSHRUT_ALL[i_m].END = 0;
	    MARSHRUT_ALL[i_m].NSTR = 0;
  	  MARSHRUT_ALL[i_m].POL_STR = 0;

    	for(i_s = 0; i_s < Nst; i_s++)MARSHRUT_ALL[i_m].KOL_STR[i_s] = 0;

	    for(i_s = 0; i_s < Nst; i_s++)
  	  for(jj = 0; jj < 10; jj++)
    	{
    		MARSHRUT_ALL[i_m].STREL[i_s][jj] = 0;
		    MARSHRUT_ALL[i_m].SIG[i_s][jj] = 0;
		    MARSHRUT_ALL[i_m].SP_UP[i_s][jj] = 0;
    	}

    	MARSHRUT_ALL[i_m].SOST = 0;

    	for(i_s = 0; i_s < Nst; i_s++)MARSHRUT_ALL[i_m].STOYKA[i_s] = 0;

	    MARSHRUT_ALL[i_m].T_VYD = 0;
    }
    return(result);
  }
}
//------------------------------------------------------
int __fastcall TStancia::tst_str_ohr(int nom_tras, int kom, int st,int marsh,int &ind)
{
	int ii,Error;
  long DT;
	unsigned int str_ohr;
	int sp_ohr, spar_str, spar_sp, pol_str, tms_str;
	ii = nom_tras;
	Error=0;

	READ_BD(TRASSA[ii].object);//------------------------------------- ��������� �������� ��
	str_ohr = BD_OSN[2]; //------------------------------- ��������� ������ �������� �������
	sp_ohr = BD_OSN[3]; //----------------------------- ��������� ������ �� �������� �������
	spar_str = BD_OSN[4]; //----------- ��������� ������ ������ ������� ��� �������� �������
	spar_sp = BD_OSN[5]; //--------- ��������� ������ �� ������ ������� ��� �������� �������
	pol_str = BD_OSN[6]; //--------------- ��������� ��������� �������� ��� �������� �������

	READ_BD(str_ohr); //-------------------------------- ��������� �������� �������� �������

	tms_str=((BD_OSN[13]&0x0f00)>>8)-1; //-------- �������� ������ ���� ��� �������� �������

	if(pol_str == 0) //------------------------------------ ���� ������� ������ ���� � �����
	{
		MARSHRUT_ALL[marsh].STREL[tms_str][ind++] = str_ohr;//------ ������ �� ������ � ������
		if((FR3[str_ohr].byt[1]!=1)||(FR3[str_ohr].byt[3]!=0)) //--------- ���� ��� �� � �����
		{
			MARSHRUT_ALL[marsh].KOL_STR[tms_str]++; //----- �������� ������� � ����� �����������
			MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST & 0xc0;
			MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST|0x3;//-- ������ ��������� ��������

			if((FR3[sp_ohr].byt[1]==0)&& //------------ ���� �� �������� ������� �� ������ � ...
			(FR3[sp_ohr].byt[3]==0)&& //-------------------------------------- �� �������� � ...
			(FR3[sp_ohr].byt[5]==0)&& //------------------------------------ �� � �������� � ...
			(FR3[sp_ohr].byt[11]==0)) //---------------------------------------------- ���������
			{
				if(spar_str != 0) //------------------------------------- ���� ���� ������ �������
				{
					if((FR3[spar_sp].byt[1]==0)&& //------ ���� �� ������ ������� � ��� �� ���������
					(FR3[spar_sp].byt[3]==0)&&
					(FR3[spar_sp].byt[5]==0)&&
					(FR3[spar_sp].byt[11]==0))
					{
						if(st != tms_str) //-- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
						{
							if(POOO[str_ohr] == 0l) //----- ���� ������ ��� �������� ������� �� � ������
							{
								perevod_strlk(107,str_ohr);//---- ������� ��� 107 = ������� � + � ��������
								POOO[str_ohr] = time(NULL); //----------------------��������� ����� ������
							}
							else  //------------------------------- ���� ������ ��� ������� ��� � ������
							{
								DT = time(NULL)-POOO[str_ohr]; //---------- ������� ������� ������ �������

								if(DT>40l) //--------------------------------- ���� ������ ����� 40 ������
								{
									DeleteMarsh(marsh); //---------------------------------- ������� �������
									add(1,8888,16);
									POOO[str_ohr]=0l;
									Error=1015;
								}
							}
						}
					}
					else  Error = 1015; //----------------------------------- ���� �� ���� � �������
				}
				else //------------------------------------------------ ���� ��� ��������� �������
				{
					if(st != tms_str) //------ ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
					{
						if(POOO[str_ohr] == 0l) //----------- ���� ������ �������� ������� �� � ������
						{
							perevod_strlk(107, str_ohr);
							POOO[str_ohr] = time(NULL);
						}
						else
						{
							DT = time(NULL)-POOO[str_ohr];
							if(DT>40l)
							{
								DeleteMarsh(marsh);
								add(1,8888,17);
								POOO[str_ohr]=0l;
								Error = 1015;
							}
						}
					}
				}
			}
			else  Error = 1015; //------------------------------- ���� ���� �� ��������� �������
		}
	}//--------------------------------------------------- ����� ��������� ��������� �������

	if(pol_str == 1)//------------------------------------ ���� ������� ������ ���� � ������
	{
 		MARSHRUT_ALL[marsh].STREL[tms_str][ind++] = str_ohr|0x1000;//������ �� ������ � ������
		if((FR3[str_ohr].byt[3]!=1)||(FR3[str_ohr].byt[1]!=0))//--------- ���� ��� �� � ������
		{
			MARSHRUT_ALL[marsh].KOL_STR[tms_str]++; //------ ��������� ����� ����������� �������
			MARSHRUT_ALL[marsh].SOST = MARSHRUT_ALL[marsh].SOST & 0xc0;//---------- ��� ��������
			MARSHRUT_ALL[marsh].SOST = MARSHRUT_ALL[marsh].SOST | 0x3; //---- �������� ���������

			if((FR3[sp_ohr].byt[1]==0)&& //-------------- ���� ���� �� ��������� ������� �������
			(FR3[sp_ohr].byt[3]==0)&&
			(FR3[sp_ohr].byt[5]==0)&&
			(FR3[sp_ohr].byt[11]==0))
			{
				if(spar_str!=0) //------------------------------------- ���� ���� ������ �������
				{
					if((FR3[spar_sp].byt[1]==0)&& //--- ���� �� ������ ������� ��������� �������
					(FR3[spar_sp].byt[3]==0)&&
					(FR3[spar_sp].byt[5]==0)&&
					(FR3[spar_sp].byt[11]==0))
					{
						if(st != tms_str) //-- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
						{
							if(POOO[str_ohr]==0l)
							{
								perevod_strlk(127,str_ohr);
									POOO[str_ohr]=time(NULL);
							}
							else
							{
								DT=time(NULL)-POOO[str_ohr];
								if(DT>40l)
								{
									DeleteMarsh(marsh);
									add(1,8888,18);
									POOO[str_ohr]=0l;
									Error=1015;
								}
							}
						}
					}
					else  Error=1015;//----------------- ���� �� ������ ������� �� ��������� �������
				}
				else  //-------------------------------------------------- ���� ��� ������ �������
				{
					if(st != tms_str) //---- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
					{
						if(POOO[str_ohr]==0l)
						{
							perevod_strlk(127,str_ohr);
							POOO[str_ohr]=time(NULL);
						}
						else
						{
							DT=time(NULL)-POOO[str_ohr];
							if(DT>40l)
							{
								DeleteMarsh(marsh);
								add(1,8888,19);
								POOO[str_ohr]=0l;
								Error=1015;
							}
						}
					}
				}
			}
			else Error=1015;//----------------------------------------- ���� ���� �� � �������
		}
	} //------------------------------------------------------- ����� ���������� ���������
	return Error;
}
//-------------------------------------------------------
void __fastcall TStancia::sbros_kom(void)
{
  int i,j;
	for(j=0;j<12;j++)
	{
		KOMANDA_MARS[j]=0;
		KOMANDA_RAZD[j]=0;
	}
	for(i=0;i<Nst;i++)
	for(j=0;j<15;j++)
	{
			KOMANDA_ST[i][j]=0;
	}
	for(i=0;i<3;i++)DIAGNOZ[i]=0;
	for(i=0;i<6;i++)ERR_PLAT[i]=0;
	return;
}
//========================================================================================
//-------------------------------------------------------------- �������� ������ ���������
void __fastcall TStancia::TimerMainTimer(TObject *Sender)
{
	int ii,jj,i,j,k,l_reg,n_ou,i_s,i_cik,i_m,ss;
  DWORD Err;
	char MIF[12];
	char contr_sum;
	time_t FIX_DELTA;
	char BUF_POKAZ[15],POKAZ[12];
	unsigned char bukva;
	AnsiString NAM1;
	char sled_kom[14];

	TrayIcon11->BalloonHint = "";
	T_TIME = time(NULL);
	if(FIXIR_TIME == 0)	FIXIR_TIME = T_TIME;
	else
	FIX_DELTA = (T_TIME - FIXIR_TIME);

	if(FIX_DELTA > 599)fixir = 1;
	if(FIX_DELTA > 610)
	{
		fixir = 0;
		FIXIR_TIME = T_TIME;
	}
	Vrema = Time();
	strcpy(Time1,TimeToStr(Vrema).c_str());
	n_ou=0;
	if (STOP_ALL == 15)return; //----- ��� ���������� ������ ���� ������ �� ���������� ...
  if(ReBoot)
  {
    if(SetPrivilege("SeShutdownPrivilege", true))
    {
      if(!ExitWindowsEx(EWX_FORCE | EWX_REBOOT, 0))Beep();
      SetPrivilege("SeShutdownPrivilege", False);
    }
  }
	if(zagruzka==0) // ------------------------------------- ���� ��� ����������� ��������
	{
		add(0,100,0); //--------------------------------- ����������� � ������ ������ ������
#ifndef Debug
		NAM1=Stancia->Put;
		if(ARM_DSP!=0)NAM1 = NAM1 +"dsp.exe";
		SHELLEXECUTEINFO execinfo;
		memset(&execinfo,0,sizeof(execinfo));
		execinfo.cbSize = sizeof(execinfo);
		execinfo.lpVerb ="open";
		execinfo.lpFile = NAM1.c_str();
		execinfo.lpParameters = NULL;
		execinfo.fMask = SEE_MASK_NOCLOSEPROCESS | SEE_MASK_NO_CONSOLE;
		execinfo.nShow = SW_SHOWDEFAULT;

		if(!ShellExecuteEx(&execinfo)) //------------------- ������ ��������� ��� ��� ��� ��
		{
			char data[100];
			sprintf(data,"�� ���� ��������� ��������� '%s'",NAM1);
			MessageBox(NULL,data,"������ ��������!", MB_OK);
			exit;
		}
#endif
		zagruzka=0xf;
		Otladka1->Otlad = 63;
		Otladka1->Restor = 63;
		Tums1->Visible = false;	 //----------------------------- �������� ����� ��������� ����
		Flagi->Visible =false; 		  Limit->Visible = false; //----------------- �������� �����
		Tums1->Hide(); 	Flagi->Hide();  Limit->Hide();
		TimerMain->Enabled=true;
		TimerKOK->Enabled = true;
		TimerTry->Enabled = true;
		TimerDC->Enabled = true;
		ShowWindow(Application->Handle, SW_HIDE);
		return;
	}

//--------------------------------------------------------- ����������� ����� ��� ��������
	if(SVAZ != SVAZ_OLD) //-------------------------------- ���������� ��������� ����� �����
	{
		TextHintTek="";
		if((SVAZ&0x1)!=0)
		{
			TextHintTek="��� ����� � ���-1.\n";
			TrayIcon11->BalloonHint = "��� ����� � ���1 ";
			TrayIcon11->ShowBalloonHint();
		}
		else TextHintTek="����� � ���-1.\n";

	#if (Nst == 2)
		if((SVAZ&0x2)!=0)
		{
			TextHintTek=TextHintTek + "��� ����� � ���-2.\n";
			TrayIcon11->BalloonHint = "��� ����� � ���2";
			TrayIcon11->ShowBalloonHint();
		}
		else	TextHintTek=TextHintTek + "����� � ���-2.\n";
	#endif

		if(ARM_DSP!=0)
		{
			if((SVAZ&0x10)!=0)
			{
				TextHintTek=TextHintTek + "��� ����� � ���-�������";
				TrayIcon11->BalloonHint = "��� ����� � ���-������� ";
				TrayIcon11->ShowBalloonHint();
			}
			else TextHintTek=TextHintTek + "����� � ���-�������";
		}

		if((SVAZ&0x20) == 0x20)TrayIcon11->BalloonHint = TrayIcon11->BalloonHint + "���������� ������ ����� � ��� ";
		TrayIcon11->ShowBalloonHint();
		SVAZ_OLD = SVAZ;
	}

	if(Otladka1->Restor==15)
	{
		ShowWindow(Application->Handle ,SW_SHOW);
		WindowState = wsNormal;
		Stancia->Visible = true;
		Stancia->SetFocus();
		BringToFront();
		Otladka1->Restor=40;
	}

	if(Otladka1->Otlad==5)
	{
		for(i=0;i<15;i++)BUF_POKAZ[i] = BUF_OUT_ARM[i]|0x40;
		Edit2->Text=BUF_POKAZ;
	}
	else
	{
		if(Otladka1->Restor==63)
		{
			if(Visible)SetFocus();
			WindowState = wsMinimized;
			Hide();
			ShowWindow(Application->Handle,SW_HIDE);
			Otladka1->Restor=0;
			Otladka1->Otlad=0;
		}
	}

	for(ii=0;ii<Nst;ii++)
	{
		if((Norma_TS[ii] == false)&&((T_TIME - TIME_DTR) > 10))
		{
			CommPortOpt1->DTR = false;
			Sleep(1500);
			Beep();
			CommPortOpt1->DTR = true;
			TIME_DTR = time(NULL);
		}

		if(ii==0)
		{
			if(Norma_TS[ii]== false)SVAZ = SVAZ | 1;
			else SVAZ = SVAZ &0xFE;


		}

		if(ii==1)
		{
			if(Norma_TS[1]== false)SVAZ = SVAZ | 2;
			else SVAZ = SVAZ &0xFD;
		}


	}

	if(Norma_Podkl==false)SVAZ = SVAZ|0x20;
	else SVAZ = SVAZ&0xDF;


	if (KNOPKA_OK_N == 1)
	TrayIcon11->BalloonHint = TrayIcon11->BalloonHint + "������ �� ������ � ������ 1 ";

	if (KNOPKA_OK_N == 2)
	TrayIcon11->BalloonHint = TrayIcon11->BalloonHint + "������ �� ������ � ������ 2 ";

	if(Kvitancia.Komanda)SVAZ = SVAZ|0x40;  //------------------------- ���� ������ �������
	else SVAZ = SVAZ&0xBF;

	SOSED_IN++;
	if(SOSED_IN>=10)
	{
		SOSED_IN=10;
		SVAZ=SVAZ|0x10;
	}
	else SVAZ=SVAZ&0xEF;

	if(povtor_novizna >= KOL_ARM)povtor_novizna = 0;
	else New_For_ARM(povtor_novizna++);

	if((RASFASOVKA==0)&&(cikl_marsh == 1))	Analiz_Glob_Marsh();
	//======================================================================================
	//����������� ������
	for(i_s=0;i_s<Nst;i_s++)
	{
		if(Stancia->Visible)Stancia->SetFocus();
		if((Otladka1->Otlad==5)&&(FIXATOR_KOM[i_s][0]!=0))Edit4->Text=FIXATOR_KOM[i_s];
		n_ou++;
	}
	if((Otladka1->Otlad==5)&&(Flagi->Visible))
	{ //1
		Flagi->SG->Cells[1][0] = "������� ";
		Flagi->SG->Cells[2][0] = "���������";
		Flagi->SG->Cells[1][1]=IntToStr(MARSHRUT_ALL[0].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[0].NACH)+"-"+IntToStr(MARSHRUT_ALL[0].END);
		Flagi->SG->Cells[2][1]=IntToStr(MARSHRUT_ALL[0].SOST);
		//2
		Flagi->SG->Cells[1][2]=IntToStr(MARSHRUT_ALL[1].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[1].NACH)+"-"+IntToStr(MARSHRUT_ALL[1].END);
		Flagi->SG->Cells[2][2]=IntToStr(MARSHRUT_ALL[1].SOST);
		//3
		Flagi->SG->Cells[1][3]=IntToStr(MARSHRUT_ALL[2].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[2].NACH)+"-"+IntToStr(MARSHRUT_ALL[2].END);
		Flagi->SG->Cells[2][3]=IntToStr(MARSHRUT_ALL[2].SOST);
#if Nst >1
		//4
		Flagi->SG->Cells[1][4]=IntToStr(MARSHRUT_ALL[3].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[3].NACH)+"-"+IntToStr(MARSHRUT_ALL[3].END);
		Flagi->SG->Cells[2][4]=IntToStr(MARSHRUT_ALL[3].SOST);
		//5
		Flagi->SG->Cells[1][5]=IntToStr(MARSHRUT_ALL[4].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[4].NACH)+"-"+IntToStr(MARSHRUT_ALL[4].END);
		Flagi->SG->Cells[2][5]=IntToStr(MARSHRUT_ALL[4].SOST);
		//6
		Flagi->SG->Cells[1][6]=IntToStr(MARSHRUT_ALL[5].KMND)+"-"
		+IntToStr(MARSHRUT_ALL[5].NACH)+"-"+IntToStr(MARSHRUT_ALL[5].END);
		Flagi->SG->Cells[2][6]=IntToStr(MARSHRUT_ALL[5].SOST);
#endif
		Flagi->SG1->Cells[1][0] = "������� ";
		Flagi->SG1->Cells[2][0] = "���������";

		Flagi->SG1->Cells[1][1] = MARSHRUT_ST[0][0]->NEXT_KOM;
		Flagi->SG1->Cells[1][2] = MARSHRUT_ST[0][1]->NEXT_KOM;
		Flagi->SG1->Cells[1][3] = MARSHRUT_ST[0][2]->NEXT_KOM;

		Flagi->SG1->Cells[2][1] = IntToStr(MARSHRUT_ST[0][0]->SOST);
		Flagi->SG1->Cells[2][2] = IntToStr(MARSHRUT_ST[0][1]->SOST);
		Flagi->SG1->Cells[2][3] = IntToStr(MARSHRUT_ST[0][2]->SOST);

		switch (MYTHX[0]&0xF)
		{
			case 0x9: strcpy(MIF,"���1"); break;
			case 0xa: strcpy(MIF,"���2"); break;
			case 0xc: strcpy(MIF,"���3"); break;
			default:  strcpy(MIF,"�����"); break;
		}

		switch (MYTHX[0]&0xF0)
		{
			case 0x70: strcat(MIF,"_���"); break;
			case 0x60: strcat(MIF,"_����"); break;
			case 0x50: strcat(MIF,"_����"); break;
			default:  strcat(MIF,"_�����"); break;
		}
		Flagi->SG1->Cells[1][4] = MIF;
		Flagi->SG1->Cells[2][4]=IntToStr(REG[0][0][9]);

#if Nst>1
		Flagi->SG2->Cells[1][1] = MARSHRUT_ST[1][0]->NEXT_KOM;
		Flagi->SG2->Cells[1][2] = MARSHRUT_ST[1][1]->NEXT_KOM;
		Flagi->SG2->Cells[1][3] = MARSHRUT_ST[1][2]->NEXT_KOM;
		Flagi->SG2->Cells[2][1] = IntToStr(MARSHRUT_ST[1][0]->SOST);
		Flagi->SG2->Cells[2][2] = IntToStr(MARSHRUT_ST[1][1]->SOST);
		Flagi->SG2->Cells[2][3] = IntToStr(MARSHRUT_ST[1][2]->SOST);
		Flagi->SG2->Cells[1][4] = IntToStr(MYTHX[1]);
		Flagi->SG2->Cells[2][4] = IntToStr(REG[1][0][9]);
#endif
	}
	i_s = 0;
	if(CommPortOpt1->REG_COM_TUMS[0]!=0)//���� ���� ������������ ������� ��� ����-1
	if(Stancia->Visible)Stancia->SetFocus();
	Port_Schet_Takt[0]=Port_Schet_Takt[0]+1;
	if(Port_Schet_Com[0]>2)
	{
		for(ii=0;ii<16;ii++)CommPortOpt1->REG_COM_TUMS[ii]=0;
		Port_Schet_Com[0]=0;
		Port_Schet_Takt[0]=0;
	}
	else
	{
		Port_Schet_Com[0]=0;
		Port_Schet_Takt[0]=0;
	}
	this-> TimerMain-> Interval = 300;

	if(STOP_ALL == 15)
	{
		Close();
		return;
	}

  #ifndef Debug
	if(byla_trb > 10) //----------------- ���� ����� Pipe �������, �� ��������� ������������
	{
		ReBoot = true;
	}
 #endif 
	if(Serv1->Sost == 8888)
	{
		TimerMain->Enabled = false;
		TimerKOK->Enabled = false;
		TimerTry->Enabled = false;
		TimerDC->Enabled = false;
		Tums1->Close();
		Flagi->Close();
		Close();
	}

  if( DEL_TRASS_MARSH == -1)
  {
    TimerKOK->Enabled = false;
		Timer250->Enabled = false;
		TimerMain->Enabled = false;
		for(i=0;i<200;i++)
    {
    	TRASSA[i].object = 0;
      TRASSA[i].tip = 0;
      TRASSA[i].stoyka = 0;
      TRASSA[i].podgrup = 0;
      TRASSA[i].kod_bit = 0;
    }

    for(i=0;i<Nst;i++)
    for(j=0;j<3;j++)
    {
    	for(k=0;k<14;k++) MARSHRUT_ST[i][j]->NEXT_KOM[k] = 0;
      MARSHRUT_ST[i][j]->NUM = 0;
      MARSHRUT_ST[i][j]->SOST = 0;
      MARSHRUT_ST[i][j]->T_VYD = 0;
      MARSHRUT_ST[i][j]->T_MAX = 0;
    }

    for(i=0;i<(Nst*3);i++)
    {
    	MARSHRUT_ALL[i].KMND = 0;
      MARSHRUT_ALL[i].NACH = 0;
      MARSHRUT_ALL[i].END = 0;
      MARSHRUT_ALL[i].NSTR = 0;
      MARSHRUT_ALL[i].POL_STR = 0;

      for(k=0;k<Nst;k++)MARSHRUT_ALL[i].KOL_STR[k] = 0;

      for(j=0; j<Nst; j++)
      for(k=0; k<10; k++)
      {
      	MARSHRUT_ALL[i].STREL[j][k] = 0;
		    MARSHRUT_ALL[i].SIG[j][k] = 0;
		    MARSHRUT_ALL[i].SP_UP[j][k] = 0;
      }

      MARSHRUT_ALL[i].SOST = 0;

      for(j=0;j<Nst;j++)MARSHRUT_ALL[i].STOYKA[j] = 0;

      MARSHRUT_ALL[i].T_VYD = 0;
    }

    for(i=0;i<KOL_VO;i++)
    {
    	FR3[i].byt[12] = 0;
			FR3[i].byt[13] = 0;  //-------------------- ������� ��������������� ��������� ��
      FR3[i].byt[20] = 0;
      FR3[i].byt[21] = 0;
      FR3[i].byt[24] = 0;
      FR3[i].byt[25] = 0;
    }
 	 	DEL_TRASS_MARSH = 0;
    TimerKOK->Enabled = true;
		Timer250->Enabled = true;
		TimerMain->Enabled = true;
  }
	NOVIZNA_FR4[new_fr4++] = NextObj++;
  if (new_fr4>9) new_fr4 = 0;
  if (NextObj > KOL_VO) NextObj = 1;
  return;
}


//========================================================================================
//-------- ��������� ��������� ������ ������������,�������� �� ����     MAKE_AVTOD(int ob)
void __fastcall TStancia::MAKE_AVTOD(int ob)
{
	unsigned int nach_marsh,end_marsh,nstrel,ii;
	int jj;
  char POKAZ[13];
	unsigned long pol_strel;
	unsigned char komanda,str_obj_serv[2];

#ifdef KOL_AVTOD
	for(ii=0;ii<KOL_AVTOD;ii++)
	{
		nach_marsh=AVTOD[ii].byt[0]*256+AVTOD[ii].byt[1];
		if(nach_marsh==(unsigned)ob)
		{
			end_marsh=AVTOD[ii].byt[2]*256+AVTOD[ii].byt[3];
			nstrel=0;
			pol_strel=0;
      for(jj=0;jj<10;jj++)
      {
        if((AVTOD[ii].byt[4+jj]==0)&&(AVTOD[ii].byt[5+jj]==0))break;
        else
        {
          nstrel++;
          if((AVTOD[ii].byt[4+jj]&0x80)!=0)
          pol_strel = pol_strel|(0x1<<(nstrel-1));
        }
      }
      break;
    }
  }
  if(ii>=KOL_AVTOD)return;

  RASFASOVKA=0xF;
  ii = ANALIZ_MARSH(192,nach_marsh,end_marsh,nstrel,pol_strel);
  if(ii<(Nst*3))TUMS_MARSH(ii);
  RASFASOVKA=0;

	for(ii=0;ii<200;ii++)
  {
	 	TRASSA[ii].object=0;
    TRASSA[ii].tip=0;
    TRASSA[ii].stoyka=0;
    TRASSA[ii].podgrup=0;
	}
#endif
  return;
}

//------------------------------------------------------------------------
void __fastcall TStancia::Edit5DblClick(TObject *Sender)
{
	int nom_arm,nom_serv,i;
	AnsiString Bit[8];
	char Nomer[4];
	Edit5->GetTextBuf(Nomer,4);
	nom_arm = atoi(Nomer);
	if((nom_arm<0)||(nom_arm>=(int)KOL_ARM))return;
	nom_serv=INP_OB[nom_arm].byt[0]*256+INP_OB[nom_arm].byt[1];
	if((nom_serv<0)||(nom_serv>=(int)KOL_SERV))return;
	Edit6->Font->Color = clBlack;
	Edit6->Text=PAKO[nom_serv];
	for(i=0;i<8;i++)Bit[i]=IntToStr(FR3[nom_serv].byt[2*i+1]);
	Edit7->Text=Bit[7]+Bit[6]+Bit[5]+Bit[4]+Bit[3]+Bit[2]+Bit[1]+Bit[0];
}
//========================================================================================
//---------- ��������� ��������� � ������ �� "������� � ����" (��������  �� ������ ������)
//------------------------- nom_tras - ������ �������� �� � ������ �������������� ��������
//----------------------- kom - ��� ���������� ������� ��������������� ��� �������� � ����
//-------- st - ����� ������, � ������� ��������� ������ ������ �� (����� ���� �� 0 �� 15)
int __fastcall TStancia::ANALIZ_ST_IN_PUT(int nom_tras, int kom, int st,int marsh,int &ind)
{
	int ii,Error;
  long DT;
  unsigned int str_in_put;
	int sp_in_put, spar_str, spar_sp, pol_str, tms_str;
	ii = nom_tras;
  Error=0;
	if((TRASSA[ii].tip==7)&&(kom==98))// ���� �� � ������� 'b'- �������� ������� � ���������
	{
		READ_BD(TRASSA[ii].object);//----------------------------------- ��������� �������� ��
		if((BD_OSN[1] != 15) || (kom != 98))return 0;// ���� �� ������� � ���� ��� �� ��������
		str_in_put = BD_OSN[2]; //---------------------------- ��������� ������ ������� � ����
		sp_in_put = BD_OSN[3]; //-------------------------- ��������� ������ �� ������� � ����
		spar_str = BD_OSN[4]; //----------- ��������� ������ ������ ������� ��� ������� � ����
		spar_sp = BD_OSN[5]; //--------- ��������� ������ �� ������ ������� ��� ������� � ����
		pol_str=BD_OSN[6]; //----------------- ��������� ��������� �������� ��� ������� � ����

		READ_BD(str_in_put); //----------------------------- ��������� �������� ������� � ����

		tms_str=((BD_OSN[13]&0x0f00)>>8)-1; //-------- �������� ������ ���� ��� ������� � ����
		//ind = MARSHRUT_ALL[marsh].KOL_STR[tms_str]; // ����� ����� ������� �������� � ������

		if(pol_str == 0) //---------------------------------- ���� ������� ������ ���� � �����
		{
			MARSHRUT_ALL[marsh].STREL[tms_str][ind++] = str_in_put;//- ������ �� ������ � ������
      MARSHRUT_ALL[marsh].STREL[tms_str][ind++]=spar_str;//  ������ ������ � ������
			if((FR3[str_in_put].byt[1]!=1)||(FR3[str_in_put].byt[3]!=0)) //- ���� ��� �� � �����
			{
				MARSHRUT_ALL[marsh].KOL_STR[tms_str]++; //--- �������� ������� � ����� �����������
				MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST & 0xc0;
				MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST|0x3;// ������ ��������� ��������

				if((FR3[sp_in_put].byt[1]==0)&& //--------- ���� �� ������� � ���� �� ������ � ...
				(FR3[sp_in_put].byt[3]==0)&& //--------------------------------- �� �������� � ...
				(FR3[sp_in_put].byt[5]==0)&& //------------------------------- �� � �������� � ...
				(FR3[sp_in_put].byt[11]==0)) //----------------------------------------- ���������
				{
					if(spar_str != 0) //----------------------------------- ���� ���� ������ �������
					{
						if((FR3[sp_in_put].byt[1]==0)&& //-- ���� �� ������ ������� � ��� �� ���������
						(FR3[spar_sp].byt[3]==0)&&
						(FR3[spar_sp].byt[5]==0)&&
						(FR3[spar_sp].byt[11]==0))
						{
							if(st != tms_str) //-- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
							{
								if(POOO[str_in_put] == 0l) //-- ���� ������ ��� ������� � ���� �� � ������
								{
									perevod_strlk(107,str_in_put);//������� ��� 107 = ������� � + � ��������
									POOO[str_in_put]=time(NULL); //-------------------��������� ����� ������
								}
								else  //----------------------------- ���� ������ ��� ������� ��� � ������
								{
									DT = time(NULL)-POOO[str_in_put]; //----- ������� ������� ������ �������

									if(DT>40l) //------------------------------- ���� ������ ����� 40 ������
									{
										DeleteMarsh(marsh); //-------------------------------- ������� �������
										add(1,8888,16);
										POOO[str_in_put]=0l;
										Error=1015;
									}
								}
							}
						}
						else  Error = 1015; //--------------------------------- ���� �� ���� � �������
					}
					else //---------------------------------------------- ���� ��� ��������� �������
					{
						if(st != tms_str) //---- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
						{
							if(POOO[str_in_put] == 0l) //-------- ���� ������ ������� � ���� �� � ������
							{
								perevod_strlk(107, str_in_put);
								POOO[str_in_put] = time(NULL);
							}
							else
							{
								DT = time(NULL)-POOO[str_in_put];
								if(DT>40l)
								{
									DeleteMarsh(marsh);
									add(1,8888,17);
									POOO[str_in_put]=0l;
									Error = 1015;
								}
							}
						}
					}
				}
				else  Error = 1015; //----------------------------- ���� ���� �� ��������� �������
			}
		}//------------------------------------------------- ����� ��������� ��������� �������

		if(pol_str == 1)//---------------------------------- ���� ������� ������ ���� � ������
		{
      MARSHRUT_ALL[marsh].STREL[tms_str][ind++]=str_in_put|0x1000;//������ ������ � ������
   		MARSHRUT_ALL[marsh].STREL[tms_str][ind++]=spar_str|0x1000;//  ������ ������ � ������
			if((FR3[str_in_put].byt[3]!=1)||(FR3[str_in_put].byt[1]!=0))//- ���� ��� �� � ������
			{
				MARSHRUT_ALL[marsh].KOL_STR[tms_str]++; //---- ��������� ����� ����������� �������
				MARSHRUT_ALL[marsh].SOST = MARSHRUT_ALL[marsh].SOST & 0xc0;//-------- ��� ��������
				MARSHRUT_ALL[marsh].SOST = MARSHRUT_ALL[marsh].SOST | 0x3; //-- �������� ���������

				if((FR3[sp_in_put].byt[1]==0)&& //--------- ���� ���� �� ��������� ������� �������
				(FR3[sp_in_put].byt[3]==0)&&
				(FR3[sp_in_put].byt[5]==0)&&
				(FR3[sp_in_put].byt[11]==0))
				{
					if(spar_str!=0) //------------------------------------- ���� ���� ������ �������
					{
						if((FR3[sp_in_put].byt[1]==0)&& //--- ���� �� ������ ������� ��������� �������
						(FR3[spar_sp].byt[3]==0)&&
						(FR3[spar_sp].byt[5]==0)&&
						(FR3[spar_sp].byt[11]==0))
						{
							if(st != tms_str) //-- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
							{
								if(POOO[str_in_put]==0l)
								{
									perevod_strlk(127,str_in_put);
									POOO[str_in_put]=time(NULL);
								}
								else
								{
									DT=time(NULL)-POOO[str_in_put];
									if(DT>40l)
									{
										DeleteMarsh(marsh);
										add(1,8888,18);
										POOO[str_in_put]=0l;
										Error=1015;
									}
								}
							}
						}
						else  Error=1015;//--------------- ���� �� ������ ������� �� ��������� �������
					}
					else  //------------------------------------------------ ���� ��� ������ �������
					{
						if(st != tms_str) //---- ���� ������� �� � ��� ������ ����, ��� ���� ������ ��
						{
							if(POOO[str_in_put]==0l)
							{
								perevod_strlk(127,str_in_put);
								POOO[str_in_put]=time(NULL);
							}
							else
							{
								DT=time(NULL)-POOO[str_in_put];
								if(DT>40l)
								{
									DeleteMarsh(marsh);
									add(1,8888,19);
									POOO[str_in_put]=0l;
									Error=1015;
								}
							}
						}
					}
				}
				else Error=1015;//----------------------------------------- ���� ���� �� � �������
			}
		} //------------------------------------------------------- ����� ���������� ���������
	}//--------------------------------------------------------------- ����� ������� �������
	return Error;
}
//-----------------------------------------------
void __fastcall TStancia::PovtorMarsh(int i_m)
{
	int ii;
  char KMND;
	unsigned int NACH=MARSHRUT_ALL[i_m].NACH;
 	int END=MARSHRUT_ALL[i_m].END;
 	int NSTR=MARSHRUT_ALL[i_m].NSTR;
	unsigned long POL=MARSHRUT_ALL[i_m].POL_STR;
	for(ii=0;ii<Nst;ii++)
	{
		if(MARSH_VYDAT[ii] != 0)return; //������ ���������� �������, ���� ��� ������� - �����;
	}
	switch(MARSHRUT_ALL[i_m].KMND)
	{
		case 'a': KMND=191; break;
		case 'b': KMND=192; break;
		case 'd': KMND=71; break;
		default:  DeleteMarsh(i_m);return;
	}
	add(1,8888,20);
	DeleteMarsh(i_m);
	RASFASOVKA=0xF;
	ii=ANALIZ_MARSH(KMND,NACH,END,NSTR,POL);
	if(ii<Nst*3)TUMS_MARSH(ii);
	else
	{
		Soob_For_Arm(ii,0);
	}
	RASFASOVKA=0;
	return;
}
//========================================================================================
//-------------------------------------- ��������� �������� ����������� �������� ����� i_m
void _fastcall TStancia::DeleteMarsh(int i_m)
{
	int i_s,s_m,ii,strelka;

	for(i_s=0;i_s<Nst;i_s++)//--------------------------------------- ������ �� ���� �������
	{
		MARSHRUT_ALL[i_m].KOL_STR[i_s]=0; //---------- ������� �������� ������� ��� ���� �����
		MARSHRUT_ALL[i_m].STOYKA[i_s]=0; //-------- ������� �������� ��������� ����� � �������
		for(s_m=0;s_m<10;s_m++) //-------------- ������ �� �������� �������, �������� � ��(��)
		{
			strelka=MARSHRUT_ALL[i_m].STREL[i_s][s_m]&0xfff;//----------- �������� ����� �������
			if(strelka!=0) //----------------------------------------- ���� ������ ����� �������
			{
				POOO[strelka]=0l; //------------------------- �������� ������� ������� ��� �������
				MARSHRUT_ALL[i_m].STREL[i_s][s_m]=0;//----------------- ������� ������� �� �������
			}
			MARSHRUT_ALL[i_m].SIG[i_s][s_m]=0;//---------------------- ������� ������ �� �������
			MARSHRUT_ALL[i_m].SP_UP[i_s][s_m]=0; //---------------- ������� �� ��� �� �� �������
		}
	}
	MARSHRUT_ALL[i_m].KMND = 0;    //------------------------------- �������� ������ �������
	MARSHRUT_ALL[i_m].NACH = 0;    //-------------------------------- �������� ������ ������
	MARSHRUT_ALL[i_m].END = 0;	//------------------------------------ �������� ������ �����
	MARSHRUT_ALL[i_m].NSTR = 0;	//----------------------------------- �������� ����� �������
	MARSHRUT_ALL[i_m].POL_STR = 0; //---------------------------- �������� ��������� �������
	MARSHRUT_ALL[i_m].SOST=0;   //---------- �������� ������� ��������� ����������� ��������

	for(i_s=0;i_s<Nst;i_s++)	//------------------------------------------ ������ �� �������
	for(s_m=0;s_m<MARS_STOY;s_m++) //-------------------------- ������ �� ��������� � ������
	{
		if((MARSHRUT_ST[i_s][s_m]->NUM-100)==i_m) //------------ ���� ��������� ��� ����������
		{
			for(ii=0;ii<13;ii++)MARSHRUT_ST[i_s][s_m]->NEXT_KOM[ii]=0; //------- ������� �������
			TUMS_RABOT[i_s]=0; //------------ �������������� ������ (�������� ��� �� ����������)
			MARSHRUT_ST[i_s][s_m]->NUM=0; //-------------------------- ������� ����� �����������
			MARSHRUT_ST[i_s][s_m]->SOST=0; //--------------------- �������� ��������� ����������
			MARSHRUT_ST[i_s][s_m]->T_VYD=0l; //---------------- �������� ����� ������ ����������
			MARSHRUT_ST[i_s][s_m]->T_MAX=0l; //����� ������� ����.�������� ���������� ����������
			MARSH_VYDAT[i_s]=0; //----------------------------------------- �������� ���� ������
		}
	}
	return;
}
//========================================================================================
//------------------------------------ ������������ ��������� ��� DSP � ��������� ��������
void __fastcall TStancia::Soob_For_Arm(int N_mar,int sos)
{
	int objserv;

	if(N_mar<Nst*3) //---------------------------------------- ���� ����� �������� � �������
	{
		objserv = MARSHRUT_ALL[N_mar].NACH; //------- ��������� ������ ������� ������ ��������

		KVIT_ARMu1[0]=OUT_OB[objserv].byt[1]; //-- �������� � ����� ������ ����� ��� DSP
		KVIT_ARMu1[1]=OUT_OB[objserv].byt[0]|0x40;

		if(sos==0) KVIT_ARMu1[2] = 7; //
		else KVIT_ARMu1[2] = 1;
	}
	else
	{
		objserv=sos;
		KVIT_ARMu1[0]=OUT_OB[objserv].byt[1];//�������� � ����� ������ ����� ���
		KVIT_ARMu1[1]=OUT_OB[objserv].byt[0]|0x40;
		if(sos==0) KVIT_ARMu1[2]=3;
		else KVIT_ARMu1[2]=1;
	}
  return;
}
//========================================================================================
//---------------------------- ��������� �������� ��������� ��������� ���������� ���������
void  __fastcall TStancia::Analiz_Glob_Marsh(void)
{   //---------------------------------------------------------------------------------$$1
	int i_m, i_s, s_m, ii,mars_st,ij,ik,ijk,ob_str,polojen;
	unsigned int KOM;
	time_t t_tek;
	double Delta;
	unsigned char kateg, Sost;
	//------------------------------------------ ������ �� ���� ���������� ������� ���������
	for(i_m=0; i_m<Nst*3; i_m++)
	{ //---------------------------------------------------------------------------------$$2
		if(MARSHRUT_ALL[i_m].SOST==0)continue;
		kateg=0xC0&MARSHRUT_ALL[i_m].SOST; //--- ����� ��������� �������� ����������� ��������
		mars_st = 0; //------------------------------------------ ������� ������� �� ���������

		Sost=0x3f; //-------------------------- ���������� ������������ �� �������� ����������

		for(i_s = 0; i_s < Nst; i_s++) //------------------------------ ������ �� ���� �������
		{ //-------------------------------------------------------------------------------$$3
			if(MARSHRUT_ALL[i_m].STOYKA[i_s]!=0)//-------- ���� ������ ��������� � ���� ��������
			{
				for(s_m=0;s_m<MARS_STOY;s_m++) //------- ������ �� ���� ��������� ��������� ������
				{
					if(MARSHRUT_ST[i_s][s_m]->NUM == 0)continue;// ��� ����� ����������,� ����������
					if((MARSHRUT_ST[i_s][s_m]->NUM-100) == i_m )//- ������ ��������� ��� �����������
					{
						mars_st++;
						//--------- ���� �� �����, ���������� ������� ��������� � ������� � ����������
						if(MARSHRUT_ST[i_s][s_m]->T_VYD == 0)
						MARSHRUT_ST[i_s][s_m]->SOST = (MARSHRUT_ST[i_s][s_m]->SOST & 0xC) | 0x7;

						if((MARSHRUT_ST[i_s][s_m]->SOST & 0x1f) != 0x1f)//-- ���� ������� �� ���������
						{
							if((T_TIME-MARSHRUT_ST[i_s][s_m]->T_VYD)>2) //--- ���� ����� 2 ��� �� ������
							{
								if(MARSHRUT_ST[i_s][s_m]->T_VYD!=0)	//---------- ���� ������������� ������
								{
									if(KOL_VYD_MARSH[i_s] == 0)	//-------------------- ���� ���� ���� ������
									{
										MARSHRUT_ST[i_s][s_m]->T_VYD = 0;
										MARSHRUT_ST[i_s][s_m]->SOST = MARSHRUT_ST[i_s][s_m]->SOST & 0x7;
										KOL_VYD_MARSH[i_s]++;
										TUMS_RABOT[i_s] = 0;
										KOMANDA_TUMS[i_s][10] = 0;
									}
									else
									{
										add(i_m,8888,40);
										DeleteMarsh(i_m);
										return;
									}
								}
							}
						}
						else	//----------------------------------------------- ���� ������� ���������
						{	//---------------------------- ������ �� ���� �������� ������������ ��������
							for(ik=0;ik<10;ik++)
							{	//--------------------------------------------- �������� ��������� �������
								ob_str = MARSHRUT_ALL[i_m].STREL[i_s][ik] & 0xfff;
								polojen = MARSHRUT_ALL[i_m].STREL[i_s][ik] & 0x1000;

								if(ob_str == 0)continue;	//---------------------- ���� �� ���, ���� �����

								//-------------------------- ���� ������� ��� �������� - �������� ��������
								if(FR3[ob_str].byt[1] == FR3[ob_str].byt[3])break;

								if(polojen == 0) //------------------------------------ ���� ����� � �����
								{
									//----------------------- ������� �� � ����� - ������� �������� ��������
									if((FR3[ob_str].byt[1]!=1)||(FR3[ob_str].byt[3]!=0)) break;
								}
								else //----------------------------------------------- ���� ����� � ������
								{
									//----------------------- ������� �� � ������ - ������� �������� �������
									if((FR3[ob_str].byt[1] != 0) || (FR3[ob_str].byt[3]!=1))break;
								}
							}

							if(ik>=10)//---------------- ���� ��� ������� ����������� (������� ��������)
							{
								//--------------------------- ���������� ��� ���������� - ����� ����������
								MARSHRUT_ST[i_s][s_m]->SOST = MARSHRUT_ST[i_s][s_m]->SOST|0x3f;
							}
							else //---------------------------------------------- ���� ������� �� ������
							{
								//----------------------------------------------------- ������� ����������
								MARSHRUT_ST[i_s][s_m]->SOST = (MARSHRUT_ST[i_s][s_m]->SOST & 0xC0)|0x1f;

								//--------------------------------------------------- ���� ��������� �����
								if((T_TIME - MARSHRUT_ST[i_s][s_m]->T_VYD) > MARSHRUT_ST[i_s][s_m]->T_MAX)
								{
									for(ii=0;ii<3;ii++)KVIT_ARMu[ii]=0;
									ii = MARSHRUT_ALL[i_m].NACH; // ��������� ������ ������� ������ ��������
									KVIT_ARMu[0]=OUT_OB[ii].byt[1]; // �������� � ����� ������ ����� ��� DSP
									KVIT_ARMu[1]=OUT_OB[ii].byt[0]|0x40;
									KVIT_ARMu[2] = 3;
									add(i_m,8888,41);
									DeleteMarsh(i_m);
									return;
								}
							}
						}
						//---------------------------------- ������������ ����� ��������� � ����������
						Sost = (Sost & MARSHRUT_ST[i_s][s_m]->SOST);
						break;
					}
				}
			}

			//---------------------------------------- ���� � ������� ������ ���� �� ���� ������
			if(mars_st!=0)
			{
				//-------------------------------------------- ��������� ����� ������ � ����.����.
				MARSHRUT_ALL[i_m].SOST = kateg | Sost;
				//----------------------------------- ���� ��������� �������� = ������� ����������
				if((Sost&0x3F)==0x3f)
				{
					//-------------------------------------- ���� ���������� ��������������� �������
					if(kateg == 0x40)
					{
						PovtorMarsh(i_m);
						continue;
					}
        	//---------------------------------------------- ���� ��� �������������� �������
					else
					{
						add(i_m,8888,26);
						DeleteMarsh(i_m);
						continue;
					}
				}
				//----------------------------------------------------------------- ���� ���������
				else
        //------------------------------------------------------- ���� ��������� ���������
				if((Sost&0x3f)==0x1)
				{
					Soob_For_Arm(i_m,0);
					DeleteMarsh(i_m);
					add(1,8888,21);
					return;
				}
			}
		}
	}
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::Button1Click(TObject *Sender)
{
	if(Flagi->Visible)Flagi->Visible=false;
	else
	{
		Flagi->SG->Cells[0][1]="����1";
		Flagi->SG->Cells[0][2]="����2";
		Flagi->SG->Cells[0][3]="����3";
		Flagi->SG->Cells[0][4]="����4";
		Flagi->SG->Cells[0][5]="����5";
		Flagi->SG->Cells[0][6]="����6";
		Flagi->SG1->Cells[0][1]="���1_1";
		Flagi->SG1->Cells[0][2]="���1_2";
		Flagi->SG1->Cells[0][3]="���1_3";
		Flagi->SG1->Cells[0][4]="���1";
		Flagi->Visible=true;
	}
}
//========================================================================================
//----------------------------------------------- �������� ����������� ��� ���������� ����
void  __fastcall TStancia::SosedOutOsn(void)
{
	unsigned int i,j,n_bait;
	char Pkz[11];
	BUF_OUT_SOSED[0]=0xAA;
	n_bait=1;
	for(i=0;i<10;i++)
	{
		if(NOVIZNA_FR4[i]!=0)
		{
			j = NOVIZNA_FR4[i]&0xfff;
			BUF_OUT_SOSED[n_bait++]=j&0x00ff;
			BUF_OUT_SOSED[n_bait++]=(j&0xff00)>>8;
			BUF_OUT_SOSED[n_bait++]=FR4[j];
			if(n_bait>=25)break;
		}
	}

	if(n_bait<=22)
	{
		if(POVTOR_FR4_SOSEDU >= KOL_VO)
		{
			i = KOL_VO;
			BUF_OUT_SOSED[n_bait++]=i&0x00ff; //---------------------------------------- �������
			BUF_OUT_SOSED[n_bait++]=(i&0xff00)>>8; //----------------------------------- �������

			if(NAS) FR4[i] = FR4[i] | 'A';
			else FR4[i] = FR4[i] & 0xFE;

			if(CHAS) FR4[i] = FR4[i] | 'B';
			else FR4[i] = FR4[i] & 0xFD;

			BUF_OUT_SOSED[n_bait++]=FR4[i];

			POVTOR_FR4_SOSEDU = 0;
			for(i=0;i<10;i++)Limit->StrGrFr4->Cells[0][i]="";
		}

		for(i = POVTOR_FR4_SOSEDU; i <= KOL_VO; i++)
		{
			//---------------------------------------------------------- ����� ��������� �������
			BUF_OUT_SOSED[n_bait++]=i&0x00ff; //---------------------------------------- �������
			BUF_OUT_SOSED[n_bait++]=(i&0xff00)>>8; //----------------------------------- �������
			BUF_OUT_SOSED[n_bait++]=FR4[i];
			if(Stancia->Visible)
			{
				if(FR4[i]!=0)
				{
					if (i==KOL_VO) Limit->StrGrFr4->Cells[0][i%10]= "������";
					else Limit->StrGrFr4->Cells[0][i%10]=PAKO[i];
				}
				Stancia->SetFocus();
			}
			if(n_bait>=25)break;
		}
		POVTOR_FR4_SOSEDU = i;
	}
	BUF_OUT_SOSED[25]=0;
	BUF_OUT_SOSED[26]=CalculateCRC8(&BUF_OUT_SOSED[1],24);
	BUF_OUT_SOSED[27]=0x55;
	if(Otladka1->Otlad==5)
	{
		for(i=0;i<10;i++)Pkz[i] = BUF_OUT_SOSED[i]|0x40;
		Pkz[10]=0;
		Lb5->Caption=Pkz;
	}
	i = ArmPort1->PutBlock(BUF_OUT_SOSED,28);
	for(j=0;j<28;j++)BUF_OUT_SOSED[j] = 0;
}
//========================================================================================
//-------------------------------------------- �������� �������� ���������� � �������� ���
void  __fastcall TStancia::SosedOutRez(void)
{
	int j,n_bait;
	unsigned int i;
	char Pkz[11];
	if (STATUS == 0)
	{
		BUF_OUT_SOSED[0]=0xAA;
		n_bait=25;
		if(Norma_Sosed)for(i=1;i<26;i++)BUF_OUT_SOSED[i]=i;//- ������������������ ����� ������
		else for(i=1;i<26;i++)BUF_OUT_SOSED[i]=n_bait--;//-- ������������������ ������� ������
		BUF_OUT_SOSED[26]=CalculateCRC8(&BUF_OUT_SOSED[1],24);
		BUF_OUT_SOSED[27]=0x55;
		if(Otladka1->Otlad==5)
		{
			for(i=0;i<10;i++)Pkz[i] = BUF_OUT_SOSED[i]|0x40;
			Pkz[10]=0;
			Lb5->Caption=Pkz;
		}
		i = ArmPort1->PutBlock(BUF_OUT_SOSED,28);
		for(j=0;j<28;j++)BUF_OUT_SOSED[j] = 0;

		for(i=0;i<10;i++)	Limit->StrGrFr4->Cells[0][i%10]="";

		for(i = POVTOR_FR4_SOSEDU ;i < KOL_ARM;i++)
		{
			if(Stancia->Visible)
			{
				if(FR4[i]!=0)
				Limit->StrGrFr4->Cells[0][i%10]=PAKO[i];
				Stancia->SetFocus();
			}
		}
	}
}

//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::Button2Click(TObject *Sender)
{
	if(Limit->Visible)Limit->Visible=false;
	else
	{
		Limit->Visible=true;
	}
	if(Limit->Visible)Limit->SetFocus();
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::pt1Click(TObject *Sender)
{
 int ii;
 Edit1->Text = "";
 Edit2->Text = "";
 Edit3->Text = "";
 Edit4->Text = "";
 for(ii=0;ii<13;ii++)FIXATOR_KOM[0][ii]=0;
 for(ii=0;ii<13;ii++)FIXATOR_KOM[1][ii]=0;
 if(Otladka1->Otlad==5)return;
 TimerOtlad->Enabled = true;
 Otladka1->Show();
 Otladka1->BringToFront();
 Otladka1->Edit1->Visible=true;
 Otladka1->Button1->Visible=true;
 Otladka1->Label1->Caption="������� ������";
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::pt2Click(TObject *Sender)
{
  int ii;
	Edit1->Text = "";
	Edit2->Text = "";
	Edit3->Text = "";
	Edit4->Text = "";
	for(ii=0;ii<13;ii++)FIXATOR_KOM[0][ii]=0;
	for(ii=0;ii<13;ii++)FIXATOR_KOM[1][ii]=0;
	if(Otladka1->Otlad!=5)return;
	Otladka1->Otlad = 63;
	Otladka1->Restor = 63;
	TimerOtlad->Enabled = false;
	Tums1->Visible = false;
	Flagi->Visible =false;
	Limit->Visible = false;
	Tums1->Hide();
	Flagi->Hide();
	Limit->Hide();
	ShowWindow(Application->Handle, SW_HIDE);
}
//========================================================================================
void __fastcall TStancia::TrayIcon112Click(TObject *Sender)
{
	Flagi->Visible = false;
	Flagi->Hide();
	Limit->Visible = false;
	Limit->Hide();
	Tums1->Visible = false;
	Tums1->Hide();
	Stancia->BringToFront();
	TrayIcon11->PopupMenu->OwnerDraw=true;
}
//========================================================================================
//------------------------------------------------------ ������ ��� ������ � �������� Tray
void __fastcall TStancia::TimerTryTimer(TObject *Sender)
{
  int i;
	char NameTmp[50];
	if(STOP_ALL==0)
	{

		if(SVAZ==0) //------------------------------------------------------- ���� ��� � �����
		{
			if(TrayIcon11->IconIndex>=4)TrayIcon11->IconIndex=0;
		}
		else
		{
			if(((SVAZ&0x10)==0x10)&&(ARM_DSP!=0))//------------- ���� ��� ����� � �������� �����
			{
				if(TrayIcon11->IconIndex<=9)TrayIcon11->IconIndex=10;  //------------------ ������
				if(TrayIcon11->IconIndex==14)TrayIcon11->IconIndex=10; //------------------ ������
			}
			else
			{
				if(ARM_DSP!=0)
				{
					if((TrayIcon11->IconIndex<5)||(TrayIcon11->IconIndex>9))
					TrayIcon11->IconIndex=5;//�������
					if(TrayIcon11->IconIndex==9)TrayIcon11->IconIndex=5; //----------------- �������
				}
			}
		}
		if(TextHintTek!=TextHintOld)TrayIcon11->Hint=TextHintTek;
		TextHintOld=TextHintTek;

		if(TIME_OLD != 0) //---------------------------------- ���� ���� �������� ������� ����
		{
			time_t tt = time(NULL);
			if(tt - TIME_OLD > 15)//���� ����� 15 ��� �� ���� ������ ����, �� ���� ���� ��������
			{
				TIME_OLD = 0;
				for(i = 0; i < 5; i++) BAITY_OLD[i] = 0;
				PODGR_OLD = 0;
			}
		}
		TODAY=DateToStr(Date());
		if(TODAY!=OLDDAY) //----------------------------------------------- ������� ����� ����
		{
			NAME_FILE=ArcPut+"\\RESULT\\";
			NAME_FILE = NAME_FILE + FormatDateTime("dd/mm", Now());
			NAME_FILE=NAME_FILE+".ogo";
			strcpy(NameTmp,NAME_FILE.c_str());
			close(file_arc);
			file_arc=open(NameTmp,O_CREAT|O_TRUNC|O_APPEND|O_RDWR,S_IWRITE|O_BINARY);
			if(file_arc<0)
			{
				clrscr();
				STOP_ALL=15;
			}
		}
		OLDDAY=TODAY;
		return;
	}
	else
	{
		Close();
	 //	Application->Terminate();
	}
	return;
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::FormClose(TObject *Sender, TCloseAction &Action)
{
	int i,j;
#ifdef ARPEX
	bool rslt = WDTStp();
	rslt = AppDeInit();
	FreeLibrary(dllcall);
#endif
  TimerTry->Enabled = false;
  TimerMain->Enabled = false;
  TimerKOK->Enabled = false;
  TimerDC->Enabled = false;
  Sleep(1000);
	ArmPort1->Open = false;
	CommPortOpt1->Open = false;

#ifdef DC_COM
  Port_DC->Open = false;
#endif

#if RBOX == 1
	PORTA->ClosePort();
	PORTB->ClosePort();
	delete PORTA;
	delete PORTB;
#endif
	Serv1->Close();
	delete Flagi;
	TrayIcon11->Visible = false;
	TrayIcon11->Destroying();
	delete TimerMain;
	delete TimerKOK;
	delete[] PAKO;
	delete[] BD_OSN_BYT;
	delete[] SPSTR;
	delete[] SPSIG;
	delete[] SPDOP;
	delete[] SPKONT;
	delete[] SPSPU;
	delete[] SPPUT;
	delete[] INP_OB;
	delete[] OUT_OB;
	delete[] FR3;
	delete[] PEREDACHA;
	delete[] PRIEM;
	delete[] FR4;
	delete[] ZAFIX_FR4;
	delete[] AVTOD;
	delete[] POOO;
	for(i=0;i<Nst;i++)
	{
		for(j=0;j<3;j++)
		{
			delete MARSHRUT_ST[i][j];
		}
	}
	DeleteCriticalSection(&NOM_PACKET_ZAP);
	close(file_arc);
  //exit(0);
//  Application->Terminate();
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::TimerDCTimer(TObject *Sender)
{
	int i,j,k;
  char Packet_DC[11];
	//DC_PORT->WriteBuffer(BUF_OUT_DC,70);
	//for(i=0;i<70;i++)BUF_OUT_DC[i]=0;

#if RBOX != 1
  if((!Upr_DC)&&(KNOPKA_OK_ARM == 0))KNOPKA_OK0 = 0;
#endif

	if(zagruzka!=0)//-------------------------------- ���� �������� ������ �� ���� ���������
	{
		if(BUF_IN_SOSED[0] == 0xAA)
		SosedIn();
		if(OLD_STATUS == STATUS) //------------------------------- ���� ������ ���� �� �������
		{
			if(STATUS==1)SosedOutOsn();
			else SosedOutRez();
		}
		else  //------------------------------------------------------------- ������ ���������
		{
			if(STATUS==0)//--------------------------------------------- ���� ��� ���� ���������
			{
				DEL_TRASS_MARSH = -1;
			}
			if (CommPortOpt1->FOpen == false)
			{
					CommPortOpt1->Open = true;
			}

			if(ArmPort1->ComNumber != 0)
			{
				if (ArmPort1->FOpen == false)
				{
					ArmPort1->Open = true;
				}
			}
			if((!CommPortOpt1->FOpen)&(!ArmPort1->FOpen))exit;
		}
		OLD_STATUS = STATUS;
	}

  for(i = 0; i < 30; i++)
  {
  	if((noviznaDC[i] > 0) && (peredalDC[i] == 0))
    {
    	for(j=0;j<11;j++)Packet_DC[j] = VVOD_DC[i][j];

     	Packet_DC[9] = check_summ(VVOD_DC[i]);
      Lb2->Caption = Packet_DC;
      Port_DC->PutBlock(Packet_DC,11);
      peredalDC[i]++;
      return;
    }
  }

  for(i= 0; i < 30; i++)
  {
  	if((priniatoDC[i] == 0) && (peredalDC[i] == 0))
    {
    	for(j=0;j<11;j++)Packet_DC[j] = VVOD_DC[i][j];

     	Packet_DC[9] = check_summ(VVOD_DC[i]);
      
      Lb2->Caption = Packet_DC;
      Port_DC->PutBlock(Packet_DC,11);
      peredalDC[i]++;
      return;
    }
  }

  i = ukaz_DC[0];
  for(j = 0; j < 11; j++) Packet_DC[j] = VVOD_DC[i][j];
  Packet_DC[9] = check_summ(VVOD_DC[i]);
  if(Norma_DC > 0)Packet_DC[10] = '+';
  Lb2->Caption = Packet_DC;
  Port_DC->PutBlock(Packet_DC,11);
  peredalDC[i]++;
  if(peredalDC[i] > 3)peredalDC[i] = 3;
  Norma_DC--;
  if(Norma_DC<0)Norma_DC = 0;
  ukaz_DC[0]++;
  if(ukaz_DC[0]>=30)ukaz_DC[0] = 0;
}
//========================================================================================
void __fastcall TStancia::FormActivate(TObject *Sender)
{
	int k;
	unsigned short god,mes,den;
	TDateTime  Vrem;

	Vrem = Date();
	DecodeDate(Vrem, god, mes,den);
	while(god < 2012)
	{
// 		Application->CreateForm(__classid(TVVOD_DAY), &VVOD_DAY);
		VVOD_DAY = new TVVOD_DAY(this);
    VVOD_DAY->Top = Screen->Height / 2 - VVOD_DAY->Height/2;
    VVOD_DAY->Left = Screen->Width / 2 - VVOD_DAY->Width/2;
		VVOD_DAY->ShowModal();
		delete VVOD_DAY;
		Vrem = Date();
		DecodeDate(Vrem, god, mes,den);
  }

	TrayIcon11->Visible = true;
	TIME_DTR = time(NULL);
	TIME_COM = time(NULL);
	Timer_Arm_Arm = 0;

	Kvitancia.Nom_Paket[0] = 0;
	Kvitancia.Nom_Paket[1] = 0;
	Kvitancia.Komanda_Time = 0;
	Kvitancia.KS = 0;
	Kvitancia.Komanda = false;
        Kvitancia.Arhiv = false;
	Kvitancia.Kvit = false;

	for(k=0;k<Nst;k++)Norma_TS[k] = true;
	for(k=0;k<Nst;k++)Norma_TU[k] = true;

	Norma_Sosed = false;
	Norma_Podkl = false;

	InitializeCriticalSection(&NOM_PACKET_ZAP);

  TimerKOK->Enabled = true; //---------------------------------------- ��������� ����� ���
	Timer250->Enabled = true;
	TimerMain->Enabled = true;
}
//========================================================================================
//------------------------------------- ��������� �������� ������ ������� � ������ �������
void __fastcall TStancia::New_For_ARM(unsigned int ii)
{
	if(((nom_new>0)&&(NOVIZNA[nom_new-1]!=ii))||(nom_new==0))
	{
		NOVIZNA[nom_new++]=ii; //��������� ����� ������������ �������
		PEREDACHA[ii] = PEREDANO;
		if(nom_new >= MAX_NEW) nom_new = 0;
	}
}
//========================================================================================
// ������ ��������� � �������� 1 ������� ��� ������������ ������ ������������� � ������ ��
void __fastcall TStancia::TimerKOKTimer(TObject *Sender)
{
	int i,DELTA_A,DELTA_B,DELTA_D;
	DELTA_A = 0; //------------------------- ������� ������� ��������� � ���������� ��������
  DELTA_B = 0;

	try
	{
#ifdef ARPEX
		for(i=0;i<4;i++)
		{
			if(GetDigInp(i,&inp_dig[i])) //--------------------------- �������� ���������� �����
			{
				if(inp_dig[i] != old_inp_dig[i])DELTA++;
				old_inp_dig[i] = inp_dig[i];
			}
		}

		if (DELTA_D!=0)
		{
			for(i=0;i<4;i++)
			{
				if(out_dig[i] == 1)SetDigOut(i,0); //- ���� ����� �� ���������� � 0, �� ����������
				GetDigOut(i,&out_dig[i]);
			}
		}

		if((inp_dig[0]==1) && (inp_dig[1]==0))STATUS=1; //---------------- ����������� �������
		else STATUS = 0;

		if((inp_dig[2]==1) && (inp_dig[3]==0)) //--------------- ����������� ������� ������ ��
		{
			KNOPKA_OK0 = 1;
		}
		else
		{
			KNOPKA_OK0 = 0;
		}
#endif

#if RBOX == 1

		DELTA_B = T_TIME - TimerB;
		DELTA_A = T_TIME - TimerA;

 		if((DELTA_B > 2) && (DELTA_A > 2))
    {
    	portB = "";
      portA = "";
      statOSN = 0;
      statREZ = 3;
    }

		if(portA.c_str()[0] == 'B')statOSN++;
    else
    	if(portA.c_str()[0] == 'A')statREZ++;
      else StatCIAN++;

    if (statREZ > 3) {statREZ = 3; statOSN=0; STATUS = 0; StatCIAN = 0;}

    if (statOSN > 3) { statOSN = 3; statREZ = 0; STATUS = 1; StatCIAN = 0;}

    if (statOSN > statREZ) STATUS = 1;  else STATUS = 0;

		if(portB.c_str()[0] == 'B')
    {
    	KNOPKA_OK0 = 1; //------------------------------------ ����������� ������� ������ ��
      OK_CIAN = 0;
    }
    else
   		if(portB.c_str()[0] == 'A')
      {
      	KNOPKA_OK0 = 0;
        OK_CIAN = 0;
      }
      else OK_CIAN++;

    if (StatCIAN >= 3)
    {
    	StatCIAN = 3;
      StatusAndKOK[2] = StatusAndKOK[2] | 0x1;
    }
    else StatusAndKOK[2] = StatusAndKOK[2] & 0xFE;


    if(OK_CIAN >= 3)
    {
    	OK_CIAN = 3;
      StatusAndKOK[2] = StatusAndKOK[2] |0x2;
    }
    else StatusAndKOK[2] = StatusAndKOK[2] & 0xFD;

#endif
	}
	catch(...)
	{
		; //--------------------------------------------------------------????????????????????
	}
	return;
}
//========================================================================================
//------------------------------ ��������� ������,�������� �� ������� ������ ������ ������
void __fastcall TStancia::ArmPort1DataReceived(TObject *Sender, char *Packet, int Count,
			int NPAK)
{
	int i;
	if(STOP_ALL!=0)return;
	for(i=0;i<28;i++)
	{
		BUF_IN_SOSED[i]=Packet[i];
	}
  return;
}
//========================================================================================
//--------------------------------------------------------  ����� ������ �� ��������� ����
void __fastcall TStancia::SosedIn(void)
{
	int i,j;
	unsigned char CRC_S,ByteFr4;
	char Pkz[28];
	Norma_Sosed = true;
	CRC_S=CalculateCRC8(&BUF_IN_SOSED[1],24);
	if(CRC_S!=BUF_IN_SOSED[26])
	{
		//--------------------------------------------------- ���� ��� ����� ����������� �����
		for(i=0;i<26;i++)BUF_IN_SOSED[i]=0;
		Norma_Sosed = false;
		return;
	}
	else
	{
		if(STATUS==0)
		{
			//------------------------------------------------------------- ������ � ������� FR4
			for(i=0;i<8;i++)
			{
				j = BUF_IN_SOSED[3*i+1];        //---------------------------------------- �������
				j = j|(BUF_IN_SOSED[3*i+2]<<8); //---------------------------------------- �������

        if (j == KOL_VO)
        {
        	ByteFr4 = BUF_IN_SOSED[3*i+3];

          if ((ByteFr4 & 'A') == 'A')NAS = true;
          else NAS = false;

          if ((ByteFr4 & 'B') == 'B')CHAS = true;
          else CHAS = false;
        }
        else
        {
					if(j >= (int)KOL_ARM) continue;
					ByteFr4 = BUF_IN_SOSED[3*i+3];
        }

				if(Otladka1->Otlad==5)
				{
					if(ByteFr4!=0)Limit->StrGrFr4->Cells[0][j%10]=PAKO[j];
				}
				if(FR4[j] != ByteFr4)
				{
					NOVIZNA_FR4[new_fr4++]=j;
					FR4[j]=ByteFr4;
					if(new_fr4 >=10) new_fr4=0;
				}
			}
		}
		else
		{
			for(i=0;i<8;i++)
			{
				if((BUF_IN_SOSED[i+2]-BUF_IN_SOSED[i+1]) != 1)break;
			}
			if(i<8)Norma_Sosed = false;
		}
		SOSED_IN = 0;
		for(i=0;i<28;i++)
		{
			Pkz[i]=BUF_IN_SOSED[i]|0x40;
			BUF_IN_SOSED[i]=0;
		}
		Pkz[10]=0;
		if(Otladka1->Otlad==5)Lb4->Caption=Pkz;

	}
}
//========================================================================================
void __fastcall TStancia::Serv1ReadPacket(TObject *Sender, BYTE *Packet, int &Size)
{
	char POKAZ[15];
	int i;
	if(Serv1->Sost == 8888)return;
#ifdef ARPEX
	WDTStrt(10);
#endif
	for(i=0;i<Size;i++)
	{
		if(Otladka1->Otlad==5)
		if(i<15)POKAZ[i]=Packet[i]|0x40;
		BUF_IN_ARM[i] = Packet[i];
	}
	Serv1->cikl_truba  = !Serv1->cikl_truba;
	if(Otladka1->Otlad==5)Edit1->Text=POKAZ;
	byla_trb = 0; //-------------- ���� ����� �� ������ pipe, ����������� ����������� ������
	ANALIZ_ARM();
	return;
}
//========================================================================================
void __fastcall TStancia::FormCreate(TObject *Sender)
{
	int A;
  A = 0;
	KNOPKA_OK_N = 0;
	TextHintTek="";
	Serv1->Open();
	if(CommPortOpt1->ComNumber != 0)
	{
		CommPortOpt1->Open = true;
		if(!CommPortOpt1->FOpen)exit;
	}
	if(ArmPort1->ComNumber != 0)
	{
		ArmPort1->Open = true;
		if(!ArmPort1->FOpen)exit;
	}

  if(PRT3 != 0)
  {
    Port_DC->ComNumber = PRT3;
    Port_DC->Open = true;
    if(!Port_DC->FOpen)exit;
  }

  A = RBOX;

	if(RBOX == 1)
  {
		//	TCom_Port *PORTA = new TCom_Port(this);
		//	TCom_Port *PORTB = new TCom_Port(this);
		if((PRT5!=0) & (PRT6!=0))
		{
			PORTA = new TCom_Port(this);
			PORTB = new TCom_Port(this);
			PORTA->PortName = "COM" + IntToStr(PRT5);
			PORTB->PortName = "COM" + IntToStr(PRT6);

			PORTA->OpenPort();
			if(!PORTA->PortIsOpen)portA = "0000";

			PORTB->OpenPort();
			if(!PORTB->PortIsOpen)portB = "0000";
		}
	}
}
//---------------------------------------------------------------------------


void __fastcall TStancia::Edit7Enter(TObject *Sender)
{
	int nom_serv,nom_arm,ij;
	char fr3_new[8],fr3_inv[8];
	nom_arm = atoi(Edit5->Text.c_str() );
	if((nom_arm<0)||(nom_arm>=(int)KOL_ARM))return;
	nom_serv=INP_OB[nom_arm].byt[0]*256+INP_OB[nom_arm].byt[1];
	if((nom_serv<0)||(nom_serv>=(int)KOL_SERV))return;
	StrCopy(fr3_new,Edit7->Text.c_str());

	for(ij=0;ij<8;ij++)
	{
		fr3_inv[ij] = fr3_new[7-ij];
		FR3[nom_serv].byt[2*ij+1] = fr3_inv[ij]-48;
	}
}

//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::CommPortOpt1DataReceivedOpt(TObject *Sender, BYTE *Packet,
      bool Priznak)
{
	Byte Priem[18];
	unsigned int Nom_Packet,i;
	int Stoika = 0;
	AnsiString StrNomPacket;

	if(STOP_ALL == 15)return;

	Norma_TS[Stoika] = true;

	Time_Last_Ot_TUMS[Stoika] = Time();

	if(Priznak)
		for(i=0;i<18;i++)Priem[i]=Packet[i]; //----------------------------- ������� ���������
	else
		for(i=0;i<11;i++)Kvit_Ot_TUMS[Stoika][i] = Packet[i]; //------------ ������� ���������

	Nom_Packet = (Packet[5]<<8) | Packet[6];

	if(Otladka1->Otlad == 5)
	{
		StrNomPacket = IntToStr(Nom_Packet);
		if((Nom_Packet%2)==1)Edit8->Text = StrNomPacket;
		else Edit9->Text = StrNomPacket;
	}

	if((Nom_Packet <= Tek_Packet[Stoika]) || ((Nom_Packet - Tek_Packet[Stoika])>9))
	{
		Poteral[Stoika]++;
		if(Poteral[Stoika]>2)
		{
			Poteral[Stoika] = 3;
			Prinal[Stoika] = 0;
			Norma_TS[Stoika] = false;
			Norma_TU[Stoika] = false;
		}
		EnterCriticalSection(&NOM_PACKET_ZAP);
		Tek_Packet[Stoika] = Nom_Packet;
		itoa(Tek_Packet[Stoika],PAKET_TXT,10);
		LeaveCriticalSection(&NOM_PACKET_ZAP);
	}
	else
	{
		Prinal[Stoika]++;

		if(Prinal[Stoika] > 3)
		{
			Poteral[Stoika] = 0;
			Prinal[Stoika] = 3;
			Norma_TS[Stoika] = true;

			if((Priem[5] & 0x80) == 0x80)	Norma_TU[Stoika] = true; //-���� ���� ��������� ��� ��
			else	Norma_TU[Stoika] = false;

			if(Priznak) //-------------------------------------------- ���� ������� ������ �� ��
			{
				for(i=0;i<18;i++)Soob_TUMS[Stoika][Last_Soob_TUMS[Stoika]][i] = Priem[i];

				Buf_Zaniat[Stoika][Last_Soob_TUMS[Stoika]]=true;

				Last_Soob_TUMS[Stoika]++;

				if(Last_Soob_TUMS[Stoika]>9)Last_Soob_TUMS[Stoika]=0;
			}
		}
		EnterCriticalSection(&NOM_PACKET_ZAP);
		Tek_Packet[Stoika] = Nom_Packet;
		itoa(Tek_Packet[Stoika],PAKET_TXT,10);
		EnterCriticalSection(&NOM_PACKET_ZAP);
	}
}
//========================================================================================
//----- ������ ������ ����� ��� ������� �������� ������ �� ��� � ������ ������ � ���������

void __fastcall TStancia::Timer250Timer(TObject *Sender)
{
	int i,i_st,ik,j,jj,ii,kk = -1,ijk,JJ[11],grup_test;
  int soob,bait,bit;
  unsigned char maska,maska1;
	unsigned int ij,num[15];
	Word Hrs,Min,Sec,Ms;
	char BB[3];
	unsigned char Zagol,//-------------------------------------- ��������� ����������� �����
	Zagol_UVK, //------------------------------------------------- ��������� �������� �� ���
	novizna,MYTHX,GRUPPA,STROKA,PODGR;
	char Soob[] = "         ";

#if RBOX == 1
		//----------------------------- ������ ��������� ������ "��" � ������������� "���/���"
		PORTA->StrFromComm(&portA); //----------------------------- ������� ������� �� ����� �
		PORTB->StrFromComm(&portB); //----------------------------- ������� ������� �� ����� B

		PORTA->StrToComm(OutPortA);//------------------------ ������ � ���� � ����� "��������"
		PORTB->StrToComm(OutPortB);//------------------------ ������ � ���� B ����� "BBBBBBBB"

		//----------------------------- ���������� �������� ������ ������ �� ��������� �������
		if((portA.c_str()[0] == 'A')||(portA.c_str()[0] == 'B')) TimerA = T_TIME;

		if((portB.c_str()[0] == 'A')||(portB.c_str()[0] == 'B')) TimerB = T_TIME;
#endif

	cikl_marsh++;

	if(cikl_marsh>3)cikl_marsh=0;

	if(cikl_marsh == 2)	MARSH_GLOB_LOCAL();

	byla_trb = byla_trb++;  //--------- ������ 250 ���� ���������� ���������� �������� �����

	//Timer250->Enabled = false;

	if((Otladka1->Otlad==5) &&(Otladka1->Restor==15))TimerOtlad->Enabled = true;

	ARM_OUT();
  for(ij=0;ij<70;ij++) OUT_TO_ARM[ij] = BUF_OUT_ARM[ij];
	Serv1->cbToWrite = 70;
	Serv1->Tell(OUT_TO_ARM,70);

 /*
	if(Serv1->FTrubaServOut->FCountOut == 70)//--- ���� ��� ������������ � ������ ������ ���
	{
		Timer250->Interval = 250;
		Timer250->Enabled = true;
	}
	else
	{
		Timer250->Interval = 500;
		Timer250->Enabled = true;
	}
	*/
  double DEL_KOK = (Timer_KOK_DC - Time_tek);

  if((DEL_KOK < 0.3/86400) && (DEL_KOK>0.1/86400))
  {
  	 if(Upr_DC)KNOPKA_OK0 = 0;
     Timer_KOK_DC = 0;
  }
	Time_tek = Time();
	for(i_st = 0; i_st < Nst; i_st++)
	{
    if(!Norma_TS[i_st])
  	{
  		for(ij = 0; ij < KOL_OUT; ij++)
      {
      	if((FR3[ij].byt[29]>=48) && (((FR3[ij].byt[28]&0xF0)>>4) == (i_st+1))) 
				{
          ii = FR3[ij].byt[29]-48;
        	FR3[ij].byt[11]=1; //----------------------------------- �������� ��������������
         	for(ijk = 1; ijk < 6;  ijk++)
         	{
				 		VVOD[i_st][ii][ijk-1]=VVOD[i_st][ii][ijk-1]|0x20;
						Stroki_TUMS[i_st][ii][ijk+9] = VVOD[i_st][ii][ijk-1];//- ������ � ������ �����
        	}
				}
      }
  	}
		Delta0 = Time_tek - Time_Last_Ot_TUMS[i_st];
		DecodeTime(Delta0,Hrs,Min,Sec,Ms);
		if(Sec > 2)
		{
			Norma_TS[i_st] = false;
			Norma_TU[i_st] = false;
		}
	}

	Zagol = 0;

	if (STATUS == 1) //------------------------------ ���������� ��������� ��� ��������� ���
	{
		if(NUM_ARM == 1) Zagol = Zagol | 0x04;
		if(NUM_ARM == 2) Zagol = Zagol | 0x08;
	}

	for(i_st = 0; i_st < Nst; i_st++) //----------------- ��������� ����� �������� ���������
	{
		while(Last_Soob_TUMS[i_st] != First_Soob_TUMS[i_st])
		{

			for(ij=0;ij<9;ij++)Soob[ij]= Soob_TUMS[i_st][First_Soob_TUMS[i_st]][ij+7];

			if(Norma_TU[i_st]) REG[i_st][0][0] = 0x20;
			else REG[i_st][0][0] = 0xdb;

			Zagol_UVK = Soob[0]; //--------------------------- ������������� ��������� ���������
			Norma_Podkl = false;
			if (STATUS == 1) //-------------------------- ���������� ��������� ��� ��������� ���
			{
				if(NUM_ARM == 1)
				{
					if((Zagol_UVK&0x04)!=0x4)Norma_Podkl = false;
					else Norma_Podkl = true;
				}
				if(NUM_ARM == 2)
				{	if((Zagol_UVK&0x08)!=0x8)Norma_Podkl = false;
					else Norma_Podkl = true;
				}
			}
			else
			if (STATUS == 0) //--------------------------- �������� ��������� ��� ���������� ���
			{
				if(NUM_ARM == 1)
				{
					if((Zagol_UVK&0x04)==0x4)Norma_Podkl = false;
					else Norma_Podkl = true;
				}
				if(NUM_ARM == 2)
				{
					if((Zagol_UVK&0x08)==0x8)Norma_Podkl = false;
					else Norma_Podkl = true;
				}
			}

			for(ij=0;ij<9;ij++)REG[i_st][0][ij+1] = Soob[ij];

			if((Soob[1]=='R')&&((Soob[2]=='y')||(Soob[2]=='Y')))kk = 45; //--------- ������� ���
			else
			if((Soob[1]=='J')&&((Soob[2]>111)&&(Soob[2]<121)))kk = 44;//----------- ������� ����
			else if(Soob[2]>=48)kk = Soob[2]-48;

			if(kk<0)return;
      if(kk==45)kk=44;


			for(ij=0;ij<18;ij++)
			Stroki_TUMS[i_st][kk][ij] = Soob_TUMS[i_st][First_Soob_TUMS[i_st]][ij];

			for(ij=0;ij<8;ij++)Kvit_For_TUMS[i_st][ij] = Stroki_TUMS[i_st][kk][ij];

			Kvit_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]&0xF3;
			Kvit_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]|Zagol;
			Kvit_For_TUMS[i_st][8] = Stroki_TUMS[i_st][kk][16];
			Kvit_For_TUMS[i_st][9] = CalculateCRC8(&Kvit_For_TUMS[i_st][7],2);

			if (KNOPKA_OK0 == 0)Kvit_For_TUMS[i_st][10]=')';
			else
			{
				Kvit_For_TUMS[i_st][0]='{';
				Kvit_For_TUMS[i_st][10]='}';
			}
			novizna=0;

			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				//---------------------------------------------------------------- ������� �������
				if(VVOD[i_st][kk][j]!=Stroki_TUMS[i_st][kk][j+10])novizna=novizna|(1<<j);
				VVOD[i_st][kk][j] = Stroki_TUMS[i_st][kk][j+10];//- �������� ������ � ������ �����
			}
#ifdef DC_COM
      if(kk<30) //--------------------------------- ���� ������ � ������� ��������� ��� ��
      {
      	for(i = 0; i<5; i++) //----------------- ������ �� �������������� ������ ���������
        {
        	for(j= 0;j<5;j++) //----------------- ������ �� ����� ���������� ����� ���������
          {
            if(OUT_DC[kk].paramDC[i][j] == 0)break; //- ���� �������� ���� �� ������������

        		if((OUT_DC[kk].paramDC[i][j] <= 127) && (OUT_DC[kk].paramDC[i][j] > 0))
            {
              maska = OUT_DC[kk].paramDC[i][j] & 0xFF;   //- ����, ������� ���� ����������
              maska1 = ~maska;   //------------------ ����, ������� �� ���� �������
              VVOD_DC[kk][i+4] = VVOD_DC[kk][i+4] & maska1; //-------------- ������ ������
              maska =  VVOD[i_st][kk][i] & maska; //----- ������������ ���� ������ ��� ��
              VVOD_DC[kk][i+4] = VVOD_DC[kk][i+4] | maska;
              VVOD_DC[kk][i+4] = VVOD_DC[kk][i+4] & 0x7F;
              if(novizna != 0)
              noviznaDC[kk] = novizna;
              break;
            }

            if(OUT_DC[kk].paramDC[i][j] > 273) // ���� ���� ����������� ��� � ����� ������
            { //--------------------- ��� ������ ������� � ��������� kk, ����� i, ���� 4-j
            	soob = ((OUT_DC[kk].paramDC[i][j] & 0xFF00)>>8) - 1;//���������� � ���������
              bait = ((OUT_DC[kk].paramDC[i][j] & 0xF0)>>4) - 1; //---- ���������� � �����
              bit =  (OUT_DC[kk].paramDC[i][j] & 0xF) - 1; //------- ���������� ����� ����

              maska = 0x10 >> j; //------------ ����������� ��� � ��������� ������ �������
              maska = maska & VVOD[i_st][kk][i]; //-------- ������ � ����� ����������� ���

							if(maska == 0)
              {
              	maska = ~(0x1 << bit);	//---------------- ���� ��� ������ ������� �������
								VVOD_DC[soob][bait+4] = VVOD_DC[soob][bait+4] & maska;
              }
            	else //---------------------------------- ���� ��� ������ ������� ����������
              {
              	maska = 0x1 << bit;
								VVOD_DC[soob][bait+4] = VVOD_DC[soob][bait+4] | maska;
              }
              VVOD_DC[soob][bait+4] = VVOD_DC[soob][bait+4] | 0x40;
							VVOD_DC[soob][bait+4] = VVOD_DC[soob][bait+4] & 0x5F;
              if(novizna != 0)noviznaDC[soob] = novizna;
            }

            if(OUT_DC[kk].paramDC[i][j] < 0 )continue;
            if(novizna != 0)peredalDC[i_st*30 + kk] = 0; //----- �������� ������� ��������

          }
        }
      /*
       	for(j=4;j<9;j++)
        {
        	VVOD_DC[kk][j] = VVOD[i_st][kk][j-4]; //------------------- ������ ������ ��� ��
        }
        */
      }
#endif
			MYTHX = Stroki_TUMS[i_st][kk][15]; //----------------------- �������� �������� MYTHX
			GRUPPA = Stroki_TUMS[i_st][kk][8];
			STROKA = TAKE_STROKA(GRUPPA,kk,i_st);

			//--------------------------------------------------- ����������� ��� --------------
			if(kk==44)
			{
				for(ij=0;ij<9;ij++)REG[i_st][0][ij+1] = Soob[ij];
				if(diagnoze(i_st,0)== -1) { for(jj=0;jj<3;jj++)DIAGNOZ[jj]=0;}
			}

			if(kk == 44) //------------------------------------------------- ��������� � �������
			{
				for(ij=0;ij<9;ij++)REG[i_st][0][ij+1] = Soob[ij];
				if(test_plat(i_st,0) != 0) {for(jj=0;jj<6;jj++)ERR_PLAT[jj]=0;}
			}

			//-------------------------------------------------- ���� ��������� � ��������������
			if((GRUPPA=='Z')||(GRUPPA=='z'))
			{
				if(kk>48)continue;
				for(j=0;j<5;j++)//-------------------------------- ������ �� ���� ������ ���������
				{
					if(VVOD_NEPAR[i_st][kk][j]!=Soob[j+3])//--------- ��������� ����� ��������������
					{
						novizna=novizna|(1<<j);
						grup_test = (unsigned char)KOL_STR[i_st];//������� ���������� ������� � ������
						if(kk < grup_test)grup_test = 'C'; //--------- ���� ��������� �������� �������
						else
						{
							grup_test = grup_test + KOL_SIG[i_st]; //------- ��������� � ������ ��������
							if(kk < grup_test)grup_test = 'E';
							else
							{
								grup_test = grup_test + KOL_DOP[i_st]; //- ��������� � ������ ���.��������
								if(kk < grup_test)grup_test = 'Q';
								else
								{
									grup_test = grup_test + KOL_SP[i_st]; //------------ ��������� � �� � ��
									if(kk < grup_test)grup_test = 'F';
									else
									{
										grup_test = grup_test + KOL_PUT[i_st];
										if(kk < grup_test)grup_test = 'I';
										else
										{
											grup_test = grup_test + KOL_KONT[i_st]; //-- ��������� � �����������
											if(kk < grup_test)grup_test = 'L';
										}
									}
								}
							}
						}
						STROKA=TAKE_STROKA(grup_test,kk,i_st);//- �������� ����� ������ � ����� ������

						for(ik=0;ik<15;ik++)num[ik] = 0; //------------------- �������� ������ �������

						switch(grup_test) // ����� ��������� ������� ������� �������� ������ ���������
						{
							case 'C':
								for(ik=0;ik<5;ik++)
								num[ik]=SPSTR[STROKA].byt[ik*2]*256+SPSTR[STROKA].byt[ik*2+1];
								break;
							case 'E':
								for(ik=0;ik<5;ik++)
								num[ik]=SPSIG[STROKA].byt[ik*2]*256+SPSIG[STROKA].byt[ik*2+1];
								break;
							case 'Q':
								for(ik=0;ik<5;ik++)
								num[ik]=SPDOP[STROKA].byt[ik*2]*256+SPDOP[STROKA].byt[ik*2+1];
								break;
							case 'F':
								for(ik=0;ik<5;ik++)
								num[ik]=SPSPU[STROKA].byt[ik*2]*256+SPSPU[STROKA].byt[ik*2+1];
								break;
							case 'I':
								for(ik=0;ik<5;ik++)
								num[ik]=SPPUT[STROKA].byt[ik*2]*256+SPPUT[STROKA].byt[ik*2+1];
								break;
							case 'L':
								for(ik=0;ik<5;ik++)
								num[ik]=SPKONT[STROKA].byt[ik*2]*256+SPKONT[STROKA].byt[ik*2+1];
								break;
							default: 	return;
						}

						for(ik=0;ik<=4;ik++)	if((1<<ik) & Soob[j+3])break; //------- ���� ��� � �����


						if(ik<5)//----------------------------- ���� ���� �������� �� ������������ ���
						{
							if(grup_test != 'L') //-------------------------------- ���� ��� �� ��� ����
							{
								NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
								NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;//-- ������� ���� ����� + 4096
								NEPAR_OBJ[2] = Soob[j+3] & 0x1f;
							}
							else//--------------------------- ���� �������������� � �������� �����������
							{
								if(STROKA == (i_st+1)*5 - 1) //���� ��������� ������ �������������� ������
								{
									NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
									NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;
									NEPAR_OBJ[2] = Soob[j+3] & 0x1f;
								}
								else
								{
									NEPAR_OBJ[0] = STROKA*5+j+1;
									NEPAR_OBJ[1] = 0x14;
									NEPAR_OBJ[2] = i_st<<4;
									NEPAR_OBJ[2] = NEPAR_OBJ[2] | (Soob[j+3] & 0x1f);
								}
							}
						}
					}
					VVOD_NEPAR[i_st][kk][j]=Soob[j+3]; //------------ �������� ������ � ������ �����
				}
			}
			else
			{
				ZAPOLNI_FR3(GRUPPA,STROKA,kk,i_st,novizna);
				if(kk>48)continue;
				for(j=0;j<5;j++)VVOD_NEPAR[i_st][kk][j]=0;
			}

			while(1)
			{
				if(CommPortOpt1->GotovWrite)break;
				else 	continue;
			}
			if(CommPortOpt1->GotovWrite)
			{
				CommPortOpt1->PutBlock(Kvit_For_TUMS[i_st],11);
			}
			Buf_Zaniat[i_st][First_Soob_TUMS[i_st]] = false;
			First_Soob_TUMS[i_st]++;
			if(First_Soob_TUMS[i_st]>9)First_Soob_TUMS[i_st]=0;

			if((novizna!=0)||(fixir!=0)||(Otladka1->Otlad == 5))
			{
				if(kk >= 0) add(i_st,kk,0);
			}
		}

		if(KOMANDA_TUMS[i_st][0]!=0) //------------------------------------ ���������� �������
		{
			for(ij=0;ij<8;ij++)Komanda_For_TUMS[i_st][ij] = Kvit_For_TUMS[i_st][ij];
			for(ijk=2;ijk<10;ijk++)
      {
				Komanda_For_TUMS[i_st][ijk+6]=KOMANDA_TUMS[i_st][ijk];
				FIXATOR_KOM[i_st][ijk-2]=KOMANDA_TUMS[i_st][ijk];
			}
			FIXATOR_KOM[i_st][ijk-2]=0;
			Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]&0xF3;
			Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]|Zagol;
			Komanda_For_TUMS[i_st][16] = CalculateCRC8(&Komanda_For_TUMS[i_st][7],9);
			Komanda_For_TUMS[i_st][0] = 0X28;
			Komanda_For_TUMS[i_st][17] = 0x29;

			if(CommPortOpt1->GotovWrite)
      {
      	CommPortOpt1->PutBlock(Komanda_For_TUMS[i_st],18);
        Kvitancia.Arhiv = true;
      }

			Kvitancia.Komanda_Time = T_TIME;
			Kvitancia.Nom_Paket[0] = Komanda_For_TUMS[i_st][5];
			Kvitancia.Nom_Paket[1] = Komanda_For_TUMS[i_st][6];
			Kvitancia.KS = Komanda_For_TUMS[i_st][16];
			Kvitancia.Komanda = true;
			Kvitancia.N_RAZ = 1;
			POVTOR_OTKR = 0;
			MARSHRUT_ST[i_st][SM_TUMS[i_st]]->T_VYD = T_TIME;
			for(ij=0;ij<8;ij++)KOMANDA_TUMS[0][ij]=0;
		}
		else
		{
			if(KOMANDA_ST[i_st][0]!=0)//------------------------------------- ���������� �������
				{
					for(ij=0;ij<8;ij++)Komanda_For_TUMS[i_st][ij] = Kvit_For_TUMS[i_st][ij];

					for(ijk=2;ijk<10;ijk++)
					{
							Komanda_For_TUMS[i_st][ijk+6]=KOMANDA_ST[0][ijk];
							FIXATOR_KOM[i_st][ijk-2]=KOMANDA_ST[i_st][ijk];
					}
					FIXATOR_KOM[i_st][ijk-2]=0;
					add(i_st,9999,0);
					Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]&0xF3;
					Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]|Zagol;
					Komanda_For_TUMS[i_st][16] = CalculateCRC8(&Komanda_For_TUMS[i_st][7],9);
					Komanda_For_TUMS[i_st][0] = 0X28;
					Komanda_For_TUMS[i_st][17] = 0x29;
					if(CommPortOpt1->GotovWrite)
          {
          	CommPortOpt1->PutBlock(Komanda_For_TUMS[i_st],18);
            Kvitancia.Arhiv = true;
            if((Upr_DC)&&(KNOPKA_OK0 == 1)&&(Kon_otv))
        		{
            	Nach_otv = false;
          		Kon_otv = false;
              Timer_KOK_DC = Time_tek + 2.0/86400;
          	}
          }
					Kvitancia.Komanda_Time = T_TIME;
					Kvitancia.Nom_Paket[0] = Komanda_For_TUMS[i_st][5];
					Kvitancia.Nom_Paket[1] = Komanda_For_TUMS[i_st][6];
					Kvitancia.KS = Komanda_For_TUMS[i_st][16];
					Kvitancia.Komanda = true;
					Kvitancia.N_RAZ = 1;

					for(ij=0;ij<8;ij++)KOMANDA_ST[i_st][ij]=0;
				}
		}

		if(Kvit_Ot_TUMS[i_st][0]!=0)
		{
			KK = "";
			for(ij=0;ij<11;ij++)
			{
				JJ[ij] = Kvit_Ot_TUMS[i_st][ij];
				itoa(JJ[ij],BB,16);
				KK = KK + BB ;
			}

      add(0,4444,0);
			if(Komanda_For_TUMS[i_st][0]!=0) //----- ���� ���� ���������������� ������� ��� ����
			{
				if((Komanda_For_TUMS[i_st][7] == Kvit_Ot_TUMS[i_st][7])&&
				(Komanda_For_TUMS[i_st][16] == Kvit_Ot_TUMS[i_st][8]))
				{
					for(ij=0;ij<18;ij++)Komanda_For_TUMS[i_st][ij]=0;
					Kvitancia.Komanda = false;  //------------------ ����� �������� �������� �������
					Kvitancia.Kvit = true; //--------------- ��������� �������� ���������� ���������
					Kvitancia.Nom_Paket[0] = 0;
					Kvitancia.Nom_Paket[1] = 0;
					Kvitancia.KS = 0;
          for(ij=0;ij<15;ij++)KOMANDA_TUMS[i_st][ij] = 0;
				}
			}
		}

		if(cikl_marsh == 3)	Analiz_Glob_Marsh();

		ANALIZ_MYTHX(MYTHX,i_st);//-- ������ MYTHX, �������� TUMS_RABOT, �������� KOMANDA_TUMS

		if(Komanda_For_TUMS[i_st][0]!=0) //------- ���� ���� ���������������� ������� ��� ����
		{
			if((T_TIME - Kvitancia.Komanda_Time) > 1)Kvitancia.Komanda = false;

			if((T_TIME - Kvitancia.Komanda_Time) > 3) //------------- ���� ������ ����� 3 ������
			{
				if(KOK_OT_TUMS == 0)
				{
					for(ijk=2;ijk<10;ijk++)
					{
						KOMANDA_ST[i_st][ijk] = Komanda_For_TUMS[i_st][ijk+6];
						FIXATOR_KOM[i_st][ijk-2]=KOMANDA_ST[i_st][ijk];
					}
					KOMANDA_ST[i_st][0] = '+';
					KOMANDA_ST[i_st][1] = '+';
					//----------------------------------- �������� ������ ������ ��� ������� �������
					for(ij=0;ij<8;ij++)Komanda_For_TUMS[i_st][ij] = Kvit_For_TUMS[i_st][ij];

					for(ijk=2;ijk<10;ijk++)
					{
						Komanda_For_TUMS[i_st][ijk+6]=KOMANDA_ST[0][ijk];
						FIXATOR_KOM[i_st][ijk-2]=KOMANDA_ST[i_st][ijk];
						FIXATOR_KOM[i_st][14] = 0; //------------------------- ������� ������� �������
					}
					add(i_st,9999,0);
					FIXATOR_KOM[i_st][ijk-2]=Kvitancia.N_RAZ|0x30 ;
					FIXATOR_KOM[i_st][ijk-1]=0;
					Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]&0xF3;
					Komanda_For_TUMS[i_st][7] = Kvit_For_TUMS[i_st][7]|Zagol;
					Komanda_For_TUMS[i_st][16] = CalculateCRC8(&Komanda_For_TUMS[i_st][7],9);
					Komanda_For_TUMS[i_st][0] = 0X28;
					Komanda_For_TUMS[i_st][17] = 0x29;

					if(CommPortOpt1->GotovWrite)
          {
          	CommPortOpt1->PutBlock(Komanda_For_TUMS[i_st],18);
            Kvitancia.Arhiv = true;
          }

					Kvitancia.Komanda_Time = T_TIME;
					Kvitancia.Nom_Paket[0] = Komanda_For_TUMS[i_st][5];
					Kvitancia.Nom_Paket[1] = Komanda_For_TUMS[i_st][6];
					Kvitancia.KS = Komanda_For_TUMS[i_st][16];
					Kvitancia.Komanda = true;
					Kvitancia.N_RAZ++;

					for(ij=0;ij<8;ij++)KOMANDA_ST[i_st][ij]=0;
				}
				else
				{
					Kvitancia.Komanda_Time = T_TIME;
					Kvitancia.N_RAZ = Kvitancia.N_RAZ+2;
					Kvitancia.Komanda = true;
				}
			}
			if(Kvitancia.N_RAZ >= 3)
			{
				for(ij=0;ij<18;ij++)Komanda_For_TUMS[i_st][ij]=0;
				Kvitancia.Komanda = false;//---------------------- ����� �������� �������� �������
				Kvitancia.Kvit = false; //-------------------- ����� �������� ���������� ���������
                                Kvitancia.Arhiv = false; //------------- ����� ���������� ������ ��������� � �����
				Kvitancia.Nom_Paket[0] = 0;
				Kvitancia.Nom_Paket[1] = 0;
				Kvitancia.N_RAZ = 0;
				Kvitancia.KS = 0;
			}
		}
	}
}
//---------------------------------------------------------------------------

void __fastcall TStancia::TimerOtladTimer(TObject *Sender)
{
	int soob,kk,i;
	char GRUPPA;
	char strka[] = "          ";
	TRect VV;
	if(Otladka1->Otlad==5)
	{
		for (i = 0; i < 10; i++)
		{
			VV = SG1->CellRect(i,0);
			if (Buf_Zaniat[0][i])SG1->Canvas->Brush->Color = clRed;
			else SG1->Canvas->Brush->Color = clLime;
			SG1->Canvas->FillRect(VV);
		}
		if(FIXATOR_KOM[0][0]!=0)
		{
			Edit4->Text = FIXATOR_KOM[0];
			if(FIXATOR_KOM[0][14] <= 15) //--------------------------- ���� ��� �������� � �����
			FIXATOR_KOM[0][14] = 55;  //-------------------------------- ����� �������� ��������
		}
		if(KK!=0)
		{
			Edit10->Text = KK;
      KK = "";
		}
//		Kvit_Ot_TUMS[i_st][ij]=0;
	}


	for(soob=0;soob<45;soob++)
	if((soob!=45)&&(soob!=44)) //--------------- ���� ��������� ������� ��� ��������������
	{
		GRUPPA =  Stroki_TUMS[0][soob][8];
		if(Otladka1->Otlad==5)
		{
			switch(GRUPPA)
			{
				case 'C':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clLime;
					break;
				case 'E':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clYellow;
					break;
				case 'Q':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clFuchsia;
					break;
				case 'F':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clSilver;
					break;
				case 'I':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clWhite;
					break;
				case 'L':
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clOlive;
					break;
			}
			if((GRUPPA!='z')&&(GRUPPA!='Z'))
			{
				if(Tums1->Visible)
				{
					VV=Tums1->DrG1->CellRect(0,soob);
					Tums1->DrG1->Canvas->FillRect(VV);
					Tums1->DrG1->Canvas->Font->Color=clBlack;
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob+1));
					VV=Tums1->DrG1->CellRect(1,soob);
					Tums1->DrG1->Canvas->FillRect(VV);
					strncpy(strka,&Stroki_TUMS[0][soob][7],9);
					strka[9]=0;
					Tums1->DrG1->Canvas->Font->Color=clBlack;
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,strka);
					VV = Tums1->DrG1->CellRect(2,soob);
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,"");
					Tums1->SetFocus();
				}
			}
			else
			{
				if(Tums1->Visible)
				{
					if(Tums1->Visible)Tums1->DrG1->Canvas->Brush->Color=clWhite;
					VV=Tums1->DrG1->CellRect(2,soob);
					strncpy(strka,&Stroki_TUMS[0][soob][7],9);
					strka[9]=0;
					Tums1->DrG1->Canvas->Font->Color=clBlack;
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,strka);
					Tums1->SetFocus();
				}
			}
		}
	}
}
//---------------------------------------------------------------------------

void __fastcall TStancia::Button3Click(TObject *Sender)
{
	if(Tums1->Visible)
	{
		Tums1->Visible = false;
		Tums1->Hide();
	}
	else
	{
		Tums1->Visible = true;
		Tums1->Show();
	}
}
//---------------------------------------------------------------------------

void __fastcall TStancia::Button4Click(TObject *Sender)
{
#ifdef ARPEX
	return;
#endif

#if RBOX == 0
	Button4->Enabled = true;
	if(STATUS == 1)
	{
		STATUS = 0;
		Button4->Caption = "���������";
	}
	else
	{
		STATUS = 1;
		Button4->Caption = "��������";
	}
#endif
}

//---------------------------------------------------------------------------

void __fastcall TStancia::Button5Click(TObject *Sender)
{
#ifdef ARPEX
	return;
#endif

#if RBOX == 0
	if((KNOPKA_OK0 == 1)&&(!Upr_DC))
	{
		KNOPKA_OK0 = 0;
    KNOPKA_OK_ARM = 0;
		Button5->Caption = "�� ������";
	}
	else
	{
		if(!Upr_DC)
    {
    	KNOPKA_OK0 = 1;
      KNOPKA_OK_ARM = 1;
			Button5->Caption = "�� ������";
    }
	}
#endif
}
//---------------------------------------------------------------------------
//========================================================================================
//------------------------------------- ������� ��������� ���������� ��� �������� ��������
//------------------------------------------- aPrivilegeName : string = ��� ��� ����������
//------------------------- aEnabled : boolean = ������� ��������� / ���������� ����������
bool __fastcall SetPrivilege(char* aPrivilegeName, bool aEnabled)
{
  TOKEN_PRIVILEGES TPPrev, TPNew ; //---------------------- ��������� ��������� ����������
  HANDLE Token; //--------------------------------------------------------- ������ �������
  DWORD dwRetLen;
  bool Result;
  Result = false;

  // ������� ������ ������� ��� �������� �������� � ������ ���������/���������� ����������
  Result=OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES|TOKEN_QUERY,&Token);

  TPNew.PrivilegeCount = 1;

  //------------- ���������� ���������� ��������� ������������� ��� ����������� ����������
  if(LookupPrivilegeValue(0, aPrivilegeName, &TPNew.Privileges[0].Luid))
  {
    if(aEnabled) //----------------------------------------- ���� ���� �������� ����������
    TPNew.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;  //--------- ���������� ��������
    else TPNew.Privileges[0].Attributes = 0;                 // ����� ��������� ����������

    dwRetLen = 0;

    //--------------- �������������� ���������� ������� ������� Token � ������������ � TP
    Result = AdjustTokenPrivileges(Token, false, &TPNew, sizeof(TPPrev),&TPPrev,&dwRetLen);
  }
  CloseHandle(Token);
  return Result;
}
//============================================================= ������� ������ �� ����� ��


void __fastcall TStancia::Port_DCDataReceived(TObject *Sender, char *Packet, int Count,
      int NPAK)
{
  unsigned char kod1,kod2,komanda_TUM[12],KS1_crc,KS2_crc;
  int beg,end,i,j,k;
#ifdef DC_COM
	if (Otladka1->Otlad == 5)
  {
  	Lb1->Caption = Packet;
  }

  if((Count==11) && (STATUS == 1) && Upr_DC)
  {
	  kod1 = Packet[2]&0xF;
  	kod2 = Packet[3]&0xF;
	  kod2 = (kod1<<4)|kod2;
  	switch(kod2)	//---------------------------- ������������� �� ���� �������� ������� ��
		{
	  	case 0x13: beg =  94; end =  99; break;
  	 	case 0x14: beg = 100; end = 107; break;
  		case 0x15: beg = 108; end = 116; break;
	  	case 0x16: beg = 117; end = 128; break;
  		case 0x17: beg = 129; end = 133; break;
  		case 0x23: beg = 134; end = 134; break;
	  	case 0x24: beg = 135; end = 146; break;
  		case 0x25: beg = 147; end = 158; break;
  		case 0x26: beg = 159; end = 159; break;
			case 0x30: beg =   1; end =   9; break;
  		case 0x31: beg =  10; end =  19; break;
  		case 0x32: beg =  20; end =  26; break;
	  	case 0x53: beg =  27; end =  31; break;
  		case 0x54: beg =  32; end =  39; break;
  		case 0x55: beg =  40; end =  47; break;
	  	case 0x56: beg =  48; end =  53; break;
  		case 0x57: beg =  54; end =  58; break;
  		case 0x58: beg =  59; end =  64; break;
	  	case 0x59: beg =  65; end =  66; break;
  		case 0x5A: beg =  67; end =  69; break;
  		case 0x5B: beg =  70; end =  72; break;
	  	case 0x5C: beg =  73; end =  73; break;
  		case 0x69: beg =  74; end =  83; break;
  		case 0x6A: beg =  84; end =  93; break;
      case 0xC3: beg = 160; end = 160; break;
	  }

  	for(i = beg - 1; i < end; i++)
	  {
  		for(j=0;j<11;j++)
    	{
    		if(KOMANDA_DC[i].Com_DC[j] != Packet[j])break;
	    }
  	  if(j==11)break;
  	}

  	if(j==11)
  	{
    	if(KOMANDA_DC[i].Otv == '1')
    	{
    		Nach_otv = true;
      	if(Upr_DC)KNOPKA_OK0 = 1;
      	Sleep(190);
      	Kon_otv = false;
    	}
    	else
    	if((KOMANDA_DC[i].Otv == '2') && (Nach_otv))
    	{
    		Nach_otv = false;
      	Kon_otv = true;
    	}
    	else
    	{
    		Kon_otv = false;
      	KNOPKA_OK0 = 0;
    	}

   		KS1_crc = CalculateCRC8(Packet,11);
    	if(KS1_crc == KOMANDA_DC[i].KS_DC)
    	{
    		for(k=0;k<12;k++)komanda_TUM[k] = KOMANDA_DC[i].Com_ARM[k];
      	KS2_crc = CalculateCRC8(&komanda_TUM,12);
      	if(KS2_crc == KOMANDA_DC[i].KS_ARM)
      	{
        	komanda_TUM[10] = KS2_crc;
        	for(k=0;k<12;k++)
        	{
        		KOMANDA_ST[0][k] = komanda_TUM[k];
          	komanda_TUM[k] = 0;
        	}
      		Timer_KOK_DC = Time_tek + 20.0/86400;
        	k = 0;
      	}
    	}
  	}
	}
  if(Count==6)
  {
  	i = Packet[3] - 48;
    if(i<45)priniatoDC[i] = 1;
		Norma_DC = 3;
  }
#endif  
}

