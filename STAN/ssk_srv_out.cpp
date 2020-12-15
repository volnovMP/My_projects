//---------------------------------------------------------------------------
#include <vcl.h>
#include <time.h>
#include <Registry.hpp>
#include <conio.h>
#include <stdlib.h>
#include <SysUtils.hpp>
#include <stdio.h>
#include <io.h>
#include <string.h>
#include <fcntl.h>
#include <mmsystem.h>
#include <shlwapi.h>
#pragma hdrstop
#include "ssk_srv_out.h"
#include "otladka.h"
#include "Unit4.h"
#include "Unit2.h"
#include "Unit3.h"
#include "Unit6.h"
#include "stan_TLB.h"
//------------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ServOut"
#pragma link "ArmPort"
#pragma link "CommPortOpt"
#pragma resource "*.dfm"
TStancia *Stancia;
_RTL_CRITICAL_SECTION ReadPacket;
char BUF[2][N_KANAL][BUF_PAKET];     //-------------------------- ������ �������
char REG[2][N_KANAL][BUF_PAKET+2];   //---------------- ��������� ������ �������
char REG_OT[2][N_KANAL][BUF_PAKET+2];
char FIXATOR_KOM[2][13];
int Port_Schet_Com[2],Port_Schet_Takt[2];
struct MARS_ALL MARSHRUT_ALL[Nst*3];
bool stan_cikl,truba_jiva;
unsigned char Timer_Arm_Arm;
AnsiString TODAY,OLDDAY;

//------------------------------------------------------------------------------
__fastcall TStancia::TStancia(TComponent* Owner)
	: TForm(Owner)
{
	int i,j,k,fu,opn_fil,jj;

	const AnsiString KeyName="Software\\DSPRPCTUMS";
	const AnsiString KeyName1="Software\\SHNRPCTUMS";
	Flagi= new TFlagi(Application);
	Tums1= new TTums1(Application);
	Limit = new TLimit(Application);
	Otladka1= new TOtladka1(Application);
	TRegistry *Reg = new TRegistry;
  FILE *fai;
	/*
  TOKEN_PRIVILEGES  TPPrev,TP;
  HANDLE Token;
  DWORD dwRetLen;*/

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
  SOSED=0;
	char NameTmp[50];
#ifdef ARPEX
	dllcall = LoadLibrary("AppLibs.dll");
	if(dllcall != 0)
  {
		AppInit = (TMyF1) GetProcAddress(dllcall,"AppLibsInit");
    AppDeInit = (TMyF1) GetProcAddress(dllcall,"AppLibsDeInit");
    LcmClr = (TMyF1) GetProcAddress(dllcall,"LcmClear");
		WDTStp = (TMyF1) GetProcAddress(dllcall,"WDTStop");
		SetDigOut = (TMyF2) GetProcAddress(dllcall,"SetDigitalOutput");
		GetDigOut = (TMyF3) GetProcAddress(dllcall,"GetDigitalOutput");
    GetDigInp = (TMyF3) GetProcAddress(dllcall,"GetDigitalInput");
    GetAnalogInp = (TMyF3) GetProcAddress(dllcall,"GetAnalogInput");
		WDTStrt = (TMyF4) GetProcAddress(dllcall,"WDTStart");
		LCMDspl = (TMyF5) GetProcAddress(dllcall,"LcmDisplay");
		WDTGetRng = (TMyF6) GetProcAddress(dllcall,"WDTGetRange");
	}

//----------------------------------------------------------------------------------------
	if (!AppInit()) //---------------------------------------------- ������������ ����������
	{
		STOP_ALL=15; //--------------------------------- ���� ������������� �� ������� - �����
		exit(-1);
	}
	else
	#endif
	TimerKOK->Enabled = true; //------------------------- ��������� ����� �������� ������/�������

	//=========================================================== ��������� �������� �������
#ifdef ARPEX
	for(i=0;i<4;i++)
	{
		if(!SetDigOut(i,0)) STOP_ALL=15;
		if(GetDigOut(i,&out_dig[i]))STOP_ALL=15;
	}
	Button4->Visible = false;
	Button5->Visible = false;
#else
	Button4->Visible = true;
	Button5->Visible = true;
#endif
	for(j=0;j<Nst*3;j++)ISPOLNIT[j]=0;

	for(j=0;j<Nst;j++)
	{
		MARSH_VYDAN[j]=0;
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
	if(file_arc<0)
	{
		char arxiv[40];
		strcpy(arxiv,ArcPut.c_str());
		strcat(arxiv,"\\RESULT");
		file_arc=mkdir(arxiv);
		file_arc=open(NameTmp,O_CREAT|O_TRUNC|O_APPEND|O_RDWR,S_IWRITE|O_BINARY);
		if(file_arc<0)
		{
			clrscr();
			exit(1);
		}
	}

	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\tranc.svs");
  fai=fopen(NameTmp,"r");
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


	fu=0;
	while(fu!='\n')fu=fgetc(fai);
	fscanf(fai,"%x",&NUM_ARM);     //--------------------------- ����� ���� (�������� �����)

  fclose(fai);

  strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\pako.bin");
  //���������� ������� �������� ��������
	opn_fil=open(NameTmp,O_BINARY);

	KOL_VO=filelength(opn_fil)/22+1;
	POOO= new long[KOL_VO];
  ZeroMemory(POOO,KOL_VO<<2);
	PAKO= new AnsiString[KOL_VO];
  i=1;
	char tmp[22];
  do
  {
    if(i>=(int)KOL_VO)break;
		read(opn_fil,&tmp,22);
		tmp[20]=0;
		tmp[21]=0;
		for(j=0;j<22;j++)if(tmp[j]==0x20)tmp[j]=0;
		PAKO[i++]=tmp;
	} while (!eof(opn_fil));
  close(opn_fil);

	//---------------------------------------------- ���������� ������� �������� ���� ������
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\bd_osn.bin");

	//------------------------------------------------- ���������� ������� �������� ��������
	opn_fil=open(NameTmp,O_BINARY);
	BD_OSN_BYT=new sp34[KOL_VO];
	i=1;
	do
	{
		read(opn_fil, &BD_OSN_BYT[i++],34);
		if(i>=(int)KOL_VO)break;
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
	if((SPSTR[k].byt[i]==0xFF)||(SPSTR[k].byt[i]==0x20)){SPSTR[k].byt[i]=0; SPSTR[k].byt[i+1]=0;}

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
	if((SPSIG[k].byt[i]==0xFF)||(SPSIG[k].byt[i]==0x20)){SPSIG[k].byt[i]=0; SPSIG[k].byt[i+1]=0;}

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
	if((SPDOP[k].byt[i]==0xFF)||(SPDOP[k].byt[i]==0x20)){SPDOP[k].byt[i]=0; SPDOP[k].byt[i+1]=0;}

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
	if((SPKONT[k].byt[i]==0xFF)||(SPKONT[k].byt[i]==0x20)){SPKONT[k].byt[i]=0; SPKONT[k].byt[i+1]=0;}

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
	if((SPSPU[k].byt[i]==0xFF)||(SPSPU[k].byt[i]==0x20)){SPSPU[k].byt[i]=0; SPSPU[k].byt[i+1]=0;}

	//---------------------------------------------------- ���������� ������� �������� �����
	j=0;jj=0;
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
	if((SPPUT[k].byt[i]==0xFF)||(SPPUT[k].byt[i]==0x20)){SPPUT[k].byt[i]=0; SPPUT[k].byt[i+1]=0;}

	//---------------------------------------------------- ���������� ������� �������� �����
	//  j=0;jj=0;
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\inp.bin");
	opn_fil=open(NameTmp,O_BINARY);
	INP_OB= new sp4[KOL_VO];
	i=1;
	do
	{
		read(opn_fil, &INP_OB[i++],4);
		if(i>=(int)KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

	//--------------------------------------------------- ���������� ������� �������� ������
	OUT_OB= new sp4[KOL_VO];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\out.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=1;
	do
	{
		read(opn_fil, &OUT_OB[i++],4);
		if(i>=(int)KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

	//--------------------------------------------------------------- ���������� ������� FR3
	FR3= new sp34[KOL_VO];
	strcpy(NameTmp,Put.c_str());
	strcat(NameTmp,"dat\\fr3.bin");
	opn_fil=open(NameTmp,O_BINARY);
	i=1;
	do
	{
		read(opn_fil, &FR3[i++],34);
		if(i>=(int)KOL_VO)break;
	} while (!eof(opn_fil));
	close(opn_fil);

#ifdef KOL_AVTOD
 // ���������� ������� ��������� ������������
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
	for(i=1;i<(int)KOL_VO;i++)
	{
		for(j=0;j<34;j++)if(FR3[i].byt[j]==32)FR3[i].byt[j]=0;
	}
	PEREDACHA= new unsigned char[KOL_VO<<1];

	PRIEM=new unsigned char[KOL_VO];
  ZeroMemory(PRIEM,KOL_VO);
	FR4=new unsigned char[KOL_VO];
  ZeroMemory(FR4,KOL_VO);
  ZAFIX_FR4= new unsigned char[KOL_VO];
	ZeroMemory(ZAFIX_FR4,KOL_VO);
  FillMemory(&TRASSA,sizeof(TRASSA),0);
	SVAZ=0;
	SVAZ_OLD=0;
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

	//  ������������� ���������� ��� ������ � ������ ���/���.
	STATUS=0;  SHN=0;  CIKL=0;


 // DC_PORT->ComNumber=PRT3;
 // DC_PORT->Open();
	CommPortOpt1->ComNumber = PRT1;
  ArmPort1->ComNumber=PRT4;
	byla_trb=0;
  TimerMain->Enabled = true;
}
//========================================================================================
//--------------------------------------------- ������ � �������, ��������� �� ������ ����
//-------------------------------------- st - ����� ������, �� ������� ���� ������� ������
//------------------------------------------ kan - ����� ������, �� �������� ������ ������
void __fastcall TStancia::PriemVvod(unsigned char st,int kan)
{
	unsigned char GRUPPA,STROKA,novizna,j,bait;
	char PODGR;
	int s_m,ik,ob_str,nom,i;
	unsigned char grup_test;
	unsigned int num[15];
	TRect VV;
	int soob,jj,nov_bit;
	novizna=0;
	PODGR = REG[st][kan][9]; //--------------------- �������� �������� ��������� ���������
	ANALIZ_MYTHX(PODGR,st);
	GRUPPA=REG[st][kan][2];  //--------------------------------------- �������� ��� ������
	soob=REG[st][kan][3]-48; //---------------------------------- �������� ����� ���������

	if(soob<0)return;

		if((GRUPPA=='R')&&((REG[st][kan][3]=='y')||(REG[st][kan][3]=='Y'))) // ����������� ���
		{
			soob=45;
			if(diagnoze(st,kan)==-1){ for(jj=0;jj<3;jj++)DIAGNOZ[jj]=0;	return;	}
		}
		else
		if(REG[st][kan][3]>=112) //------------------ ��������� � �������, ��������� ���������
		{
			if(GRUPPA=='J')
			{
				if(test_plat(st,kan)==-1){for(jj=0;jj<6;jj++)ERR_PLAT[jj]=0;return;}
				soob=44;
			}
			else return;

			nov_bit=0;
			novizna=0;
			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				//---------------------------------------------------------------- ������� �������
				if(VVOD[st][soob][j]!=REG[st][kan][j+4])novizna=novizna|(1<<j);
				VVOD[st][soob][j] = REG[st][kan][j+4];//----------- �������� ������ � ������ �����
			}
		}
		else
		//---------------------------------------------------- ���� ��������� � ��������������
		if((GRUPPA=='Z')||(GRUPPA=='z'))
		{
			if(soob>48)return;

			for(j=0;j<5;j++)//---------------------------------- ������ �� ���� ������ ���������
			{
				if(VVOD_NEPAR[st][soob][j]!=REG[st][kan][j+4])//--- ��������� ����� ��������������
				{
					novizna=novizna|(1<<j);
					grup_test = (unsigned char)KOL_STR[st];  //- ������� ���������� ������� � ������
					if(soob<grup_test)grup_test = 'C'; //----------- ���� ��������� �������� �������
					else
					{
						grup_test = grup_test + KOL_SIG[st]; //----------- ��������� � ������ ��������
						if(soob<grup_test)grup_test = 'E';
						else
						{
							grup_test = grup_test + KOL_DOP[st]; //----- ��������� � ������ ���.��������
							if(soob<grup_test)grup_test = 'Q';
							else
							{
								grup_test = grup_test + KOL_SP[st]; //---------------- ��������� � �� � ��
								if(soob<grup_test)grup_test = 'F';
								else
								{
									grup_test = grup_test + KOL_PUT[st];
									if(soob<grup_test)grup_test = 'I';
									else
									{
										grup_test = grup_test + KOL_KONT[st]; //------ ��������� � �����������
										if(soob<grup_test)grup_test = 'L';
									}
								}
							}
						}
					}
					STROKA=TAKE_STROKA(grup_test,soob,st);//--- �������� ����� ������ � ����� ������

					for(i=0;i<15;i++)num[i] = 0; //------------------------- �������� ������ �������

					switch(grup_test) //-- ����� ��������� ������� ������� �������� ������ ���������
					{
						case 'C':
							for(i=0;i<5;i++)num[i]=SPSTR[STROKA].byt[i*2]*256+SPSTR[STROKA].byt[i*2+1];
							break;
						case 'E':
							for(i=0;i<5;i++)num[i]=SPSIG[STROKA].byt[i*2]*256+SPSIG[STROKA].byt[i*2+1];
							break;
						case 'Q':
							for(i=0;i<5;i++)num[i]=SPDOP[STROKA].byt[i*2]*256+SPDOP[STROKA].byt[i*2+1];
							break;
						case 'F':
							for(i=0;i<5;i++)num[i]=SPSPU[STROKA].byt[i*2]*256+SPSPU[STROKA].byt[i*2+1];
							break;
						case 'I':
							for(i=0;i<5;i++)num[i]=SPPUT[STROKA].byt[i*2]*256+SPPUT[STROKA].byt[i*2+1];
							break;
						case 'L':
							for(i=0;i<5;i++)num[i]=SPKONT[STROKA].byt[i*2]*256+SPKONT[STROKA].byt[i*2+1];
							break;
						default: 	return;
					}

					for(i=0;i<=4;i++)	if((1<<i) & REG[st][kan][j+4])break; // ����� ���� ��� � �����


					if(i<5)//-------------------------------- ���� ���� �������� �� ������������ ���
					{
						if(grup_test != 'L') //---------------------------------- ���� ��� �� ��� ����
						{
							NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
							NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;//---- ������� ���� ����� + 4096
							NEPAR_OBJ[2] = REG[st][kan][j+4] & 0x1f;
						}
						else//----------------------------- ���� �������������� � �������� �����������
						{
							if(STROKA == (st+1)*5 - 1) //--- ���� ��������� ������ �������������� ������
							{
								NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
								NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;
								NEPAR_OBJ[2] = REG[st][kan][j+4] & 0x1f;
							}
							else
							{
								NEPAR_OBJ[0] = STROKA*5+j+1;
								NEPAR_OBJ[1] = 0x14;
								NEPAR_OBJ[2] = st<<4;
								NEPAR_OBJ[2] = NEPAR_OBJ[2] | (REG[st][kan][j+4] & 0xf);
							}
						}
					}
				}
				VVOD_NEPAR[st][soob][j]=REG[st][kan][j+4]; //------ �������� ������ � ������ �����
			}
		}
		else //------------------------------------------------------- ��� ��������� ���������
		{
			novizna=0; nov_bit=0;
			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				if(VVOD[st][soob][j]!=REG[st][kan][j+4])novizna=novizna|(1<<j); // ������� �������
				VVOD[st][soob][j]=REG[st][kan][j+4]; //------------ �������� ������ � ������ �����
				VVOD_NEPAR[st][soob][j]=REG[st][kan][j+4]; //------ �������� ������ � ������ �����
			}
		}
		//		if(REG[st][kan][9]!=124)novizna=0x1f;
		if((GRUPPA=='z')||(GRUPPA=='Z'))VVOD_NEPAR[st][soob][6]=0; //----- ������������ ������
		else VVOD[st][soob][6]=0; //-------------------------------------- ������������ ������

		/*------------------------------------------------------------------------------------
		if(novizna)
		{
			if(Otladka1->Otlad==5)
			{
				if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Font->Color=clRed;
				Stancia->SetFocus();
			}
		}
		------------------------------------------------------------------------------------*/

		if((soob!=45)&&(soob!=44)) //--------------- ���� ��������� ������� ��� ��������������
		{
			/*----------------------------------------------------------------------------------
			if(Otladka1->Otlad==5)
			{
				switch(GRUPPA)
				{
					case 'C':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clLime;
						break;
					case 'E':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clYellow;
						break;
					case 'Q':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clFuchsia;
						break;
					case 'F':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clSilver;
						break;
					case 'I':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clWhite;
						break;
					case 'L':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clOlive;
						break;
					case 'Z':
					case 'z':
						if((st==0)&&(Tums1->Visible))
						{
							Tums1->DrG1->Canvas->Brush->Color=clWhite;
							VV=Tums1->DrG1->CellRect(2,soob);
							Tums1->DrG1->Canvas->FillRect(VV);
							Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
							Tums1->DrG1->Canvas->Font->Color=clBlack;
							Stancia->SetFocus();
						}
				}
				if((GRUPPA!='z')&&(GRUPPA!='Z'))
				{
					if((st==0)&&(Tums1->Visible))
					{
						VV=Tums1->DrG1->CellRect(0,soob);
						Tums1->DrG1->Canvas->FillRect(VV);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob+1));
						VV=Tums1->DrG1->CellRect(1,soob);
						Tums1->DrG1->Canvas->FillRect(VV);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
						Tums1->DrG1->Canvas->Font->Color=clBlack;
						VV = Tums1->DrG1->CellRect(2,soob);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,"");
						Stancia->SetFocus();
					}
				}
			}
			*/
			STROKA=TAKE_STROKA(GRUPPA,soob,st); //------------------------ �������� ����� ������
			ZAPOLNI_FR3(GRUPPA,STROKA,soob,st,novizna); //---------------- ��������� FR3 �������
		}
		else
		{
			if((st==0)&&(Tums1->Visible))
			{
				Tums1->DrG1->Canvas->Font->Name = "Courier New";
				Tums1->DrG1->Canvas->Brush->Color=clRed;
				VV=Tums1->DrG1->CellRect(0,soob-1);
				Tums1->DrG1->Canvas->FillRect(VV);
				Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob));
				VV=Tums1->DrG1->CellRect(1,soob-1);
				Tums1->DrG1->Canvas->FillRect(VV);
				Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
				Tums1->DrG1->Canvas->Font->Color=clBlack;
				Stancia->SetFocus();
			}
		}
		if((novizna!=0)||(fixir!=0)||(Otladka1->Otlad==5))
		add(st,soob,0);
}
//========================================================================================
//----  ������ ��������� ��������� ������ ����� � ���������� �� ������, �������� �� ������
//--------------------------------------------------------- PODGR - ���� � ������� � MYTHX
//------------------------------------------ ST - ����� ������, �� ������� �������� ������
void __fastcall TStancia::ANALIZ_MYTHX(unsigned char PODGR,int ST)
{
	int svoi,s_m,nom,ik,ob_str,ijk;
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
		MARSH_VYDAN[tum] = 0;  //------------ ������� ���������, ������� ����� ������� �������

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
						MARSHRUT_ST[tum][s_m]->SOST = (MARSHRUT_ST[tum][s_m]->SOST&0xC0)|0x1f;
						for(ijk=0;ijk<15;ijk++)KOMANDA_TUMS[tum][ijk]=0;
						TUMS_RABOT[tum] = 0xf; //---------------------- ��������� ���� "���� � ������"
						break;

						//------------------------------------- ��������� ��������� ��������� ��������
					 case 0x50:
						MARSHRUT_ST[tum][s_m]->SOST = 0x1; //---------------------- ���������� �������
						for(ijk=0;ijk<15;ijk++)KOMANDA_TUMS[tum][ijk]=0; //---------- �������� �������
						TUMS_RABOT[tum] = 0xf; //------------------------- ������ ���� "���� � ������"
						break;

						//--------------------------------------- ������� ��������� ��������� ��������
						case 0x60:
						MARSHRUT_ST[tum][s_m]->SOST = (MARSHRUT_ST[tum][s_m]->SOST&0xC0)|0x1f;
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

		if(KOMANDA_TUMS[i_s][10]!=0)continue;//���� ����� ���������������� �������, ����������

		for(s_m=0;s_m<MARS_STOY;s_m++)//--------- ������ �� ������� ��������� ��������� ������
		{
			//���� i_s ����� �������  � ������ s_m ���������� ���������,��� ��� �� ������ � ����
			if((MARSHRUT_ST[i_s][s_m]->NEXT_KOM[0]!=0) && (MARSHRUT_ST[i_s][s_m]->T_VYD == 0))
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
					KOMANDA_TUMS[i_s][14] = s_m; //------------------------- ������ ������ ���������
					MARSHRUT_ST[i_s][s_m]->NEXT_KOM[12] = MYTHX_TEC[i_s]; //-------- ��������� MYTHX

					kk = MARSHRUT_ST[i_s][s_m]->NUM - 100;
					kk = MARSHRUT_ALL[kk].KOL_STR[i_s]*20+10;

					MARSHRUT_ST[i_s][s_m]->T_MAX = kk;
					TUMS_RABOT[i_s] = 0xf;
					MARSH_VYDAN[i_s]=0xf;
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
			gru=REG[st][kan][4];
			podgru=REG[st][kan][5];
			bt=REG[st][kan][6]&0xf;
			kod=REG[st][kan][7];
		}
		else
		if(kan==1)
		{
			gru=REG[st][kan][4];
			podgru=REG[st][kan][5];
			bt=REG[st][kan][6]&0xf;
			kod=REG[st][kan][7];
		}
		strk=TAKE_STROKA(gru,podgru-48,st);
		if(strk==-1)error_diag=-1;
		//--------------------------------------------------------- ���������� ������� �������
		switch(gru)
		{
		case 'E': for(i=0;i<10;i++)nm[i]=SPSIG[strk].byt[i]; break;
		case 'F': for(i=0;i<15;i++)nm[i]=SPSPU[strk].byt[i]; break;
		case 'I': for(i=0;i<15;i++)nm[i]=SPPUT[strk].byt[i]; break;
		default: error_diag=-1;break;
		}
		nom_serv=nm[bt*2]*256+nm[bt*2+1];
		if(nom_serv>(int)KOL_VO)error_diag=-1;

		//----------------------------------------------------------- ���������� ������� �����
		for(i=0;i<2;i++)NOM_ARM[i]=OUT_OB[nom_serv].byt[i];
		DIAGNOZ[0]=NOM_ARM[1];
		DIAGNOZ[1]=NOM_ARM[0]|0x20;
		switch(kod)
		{
			case 'P': DIAGNOZ[2]=1;break;
			case 'Z': DIAGNOZ[2]=1;break;
			case 'S': DIAGNOZ[2]=2;break;
			case 'T': DIAGNOZ[2]=4;break;
			default: error_diag=-1;break;
		}
		break;
	}
	return(error_diag);
}
//========================================================================================
int __fastcall TStancia::test_plat(int st,int kan)
{
	int i,error_plat=0;
	unsigned char podgr,kod,plata,baity[5];
	unsigned int bits=0;
	while(error_plat!=-1)
	{
		if((st<0)||(st>Nst))error_plat=-1;
		if(kan==0)
		{
			podgr=REG[st][kan][3];
			for(i=0;i<5;i++)baity[i]=REG[st][kan][4+i];
		}
		else
			if(kan==1)
			{
				podgr=REG[st][kan][3];
				for(i=0;i<5;i++)baity[i]=REG[st][kan][4+i];
			}
		if(podgr==PODGR_OLD)
		{
			for(i=0;i<5;i++)if(baity[i]!=BAITY_OLD[i])break;
			if(i<5)
			{
				for(i=0;i<5;i++)BAITY_OLD[i]=baity[i];
				TIME_OLD=time(NULL);
				return(-1);
			}
		}
		else
		{
			PODGR_OLD=podgr;
			for(i=0;i<5;i++)BAITY_OLD[i]=baity[i];
			TIME_OLD=time(NULL);
			return(-1);
		}
		switch(podgr)
		{
			case 'p': kod=1; plata=1;   //------------------------------------ ����������� �����
								for(i=0;i<3;i++)bits=bits|((baity[i]&0x1f)<<(i*5));
								break;
			case 'q': kod=2; plata=1;  //------------------------------------------- ����� �����
								for(i=0;i<3;i++)bits=bits|((baity[i]&0x1f)<<(i*5));
								break;
			case 'r': kod=3; plata=9;    //------------------------------- ���������� 0 � �201-1
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 's': kod=3; plata=10;   //------------------------------- ���������� 0 � �201-2
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 't': kod=3; plata=11;   //------------------------------- ���������� 0 � �201-3
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 'u': kod=3; plata=12;   //------------------------------- ���������� 0 � �201-4
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 'v': kod=4; plata=9;  //--------------------------------- ���������� 1 � M201-1
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 'w': kod=4; plata=10; //--------------------------------- ���������� 1 � M201-2
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			case 'x': kod=4; plata=11;  //-------------------------------- ���������� 1 � M201-3
								for(i=0;i<4;i++)bits=bits|((baity[i]&0x1f)<<(i*4));
								break;
			default: error_plat=-1;
		}

		break;
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

	return(error_plat);
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
//---------------------------------- STRKA - ������ � ������ ������� ������� ������ ������
//---------------------------------- sob - ����� ��������� ��������� ---------------------
//---------------------------------- tum - ����� ������ ----------------------------------
//---------------------------------- nov - ������� ������� ������ ��������� --------------
void __fastcall TStancia::ZAPOLNI_FR3(unsigned char GRP,int STRKA,int sob,unsigned char tum,char nov)
{
	unsigned int i,jj,j,k,num[15],ii,sgnl=0,i_m,i_s,i_sig;
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
		{ if((num[i]>=KOL_VO)||(num[i]<=0))continue; //���� ������ ��� ������-������ �� ������
			j=0;
			k=1<<i;
//if((nov&k))//���� ���� ���������, �� ����� �� ������ ������� num[i] � ����� ��������� ����� �������
			if(true)
			{	jj=num[i];
				if(GRP == 'F')
				{
					koryto = 0;  READ_BD(jj);
					if((BD_OSN[0] == 3)&&(BD_OSN[3]!=0)) //------------------------ ���� �� � ������
					{
						str_lev = (BD_OSN[3]&0xff00)>>8;		str_prav = BD_OSN[3]&0xff;

						READ_BD(str_lev); sp_lev = (BD_OSN[6]&0xFF00)>>8;

						READ_BD(str_prav); sp_prav =(BD_OSN[6]&0xFF00)>>8;

						if (jj == sp_prav) break;  //---------------------- ������ �� ������ ���������

						//-----------------------------------------�������� ������ �� ��������� ������


						if((FR3[sp_lev].byt[24])||(FR3[sp_lev].byt[25])) //���� �� � �����-�� ��������
						FR3[sp_lev].byt[24]=FR3[sp_lev].byt[24]|0x80; //���������� �������� �� �����

						if((FR3[sp_prav].byt[24])||(FR3[sp_prav].byt[25])) //���� �� ������ � ��������
						FR3[sp_prav].byt[24]=FR3[sp_prav].byt[24]|0x80; //-------- ���������� ��������

						koryto = 0;
 						if (FR3[str_lev].byt[1]) koryto = koryto|1; //----- ���� ����� ������� � �����
						if(FR3[str_lev].byt[3]) koryto = koryto|2; //------------- ���� ����� � ������
            if(FR3[str_prav].byt[1]) koryto = koryto|4; //------------ ���� ������ � �����
						if(FR3[str_prav].byt[3]) koryto = koryto|8; //----------- ���� ������ � ������
				 }
				}

				for(j=0;j<6;j++) //--------------------- ������ ������� �� ������ �������� �� ����
				{
					l=1<<j;//------------------------------------------------- ������������ ���� ���
					FR3[jj].byt[j*2]=0;
				 //--------------------------- �������� ��������� � ������������ � ������� �� ���Ѡ
					if((VVOD[tum][sob][i]&l))//-------------------------------- ���� ��� ������� � 1
					{
						if(GRP=='E') //--------------------------------------------------- ���� ������
						{
							if(j<4)  //------------------------------------------ ���� ���������� ��� ��
							{
								for(i_m=0;i_m<Nst*3;i_m++) //--------- ������ �� ���� ���������� ���������
								{
									if(MARSHRUT_ALL[i_m].KMND==0)continue;
									i_sig=0; //------------- ���������� �������, ��� � �������� ��� ��������
									for(i_s=0;i_s<Nst;i_s++)//-------- ������ �� ���� ������� ����� ��������
									{
										if(MARSHRUT_ALL[i_m].SIG[i_s][0]==0)continue;
										if(MARSHRUT_ALL[i_m].SIG[i_s][0]==jj)continue;
										else i_sig++;
									}
									//--------- ���� ������� ��������� ��� � ������� ���������� ��� ��������
									//------------ � ������� ���������, �� ������� ������� �� �������� �����
									//------------------------------------------------- ��� �� �� ����������
									if((i_sig==0)&&((MARSHRUT_ALL[i_m].SOST&0x1F)==0x1F))
									{
										add(i_m,8888,11);
										DeleteMarsh(i_m);
									}
								}
							}
						}

						if(GRP=='I')//------------------------------------------------------ ���� ����
						{
							if((j==1)||(j==2)||(j==4))//----------------------------- ���� ��, �� ��� ��
							{
								FR3[jj].byt[13]=0; //------------------------------------- ����� ���������
								//------------------------------------ �������� ������ �� ��������� ������
								if((FR3[jj].byt[24])||(FR3[jj].byt[25]))FR3[jj].byt[24]=FR3[jj].byt[24]|0x80;
								READ_BD(jj);
								if(BD_OSN[1]!=0)
								{
									ii=BD_OSN[1];
									FR3[ii].byt[13]=0; //����� ���������
									//�������� ������ �� ��������� ������
									if((FR3[ii].byt[24])||(FR3[ii].byt[25]))FR3[ii].byt[24]=FR3[ii].byt[24]|0x80;
									FR3[ii].byt[27]=0;FR3[ii].byt[26]=FR3[ii].byt[26]|0xE0;//���������� ������� �������
									New_For_ARM(ii);
								}
							}
						}
						//------------------------------------------------------------- ���� �� ��� ��
						if((GRP == 'F') && (STATUS == 0))FR3[jj].byt[13]=0;
						if((GRP=='F')&&((j==1)||(j==4))) //--------------------- ���� ��������� ��� ��
						{
							switch(koryto)
							{ //----------------- ����� ��������������� ���������, ��� ��� ���� ��������
								case 6:		FR3[sp_lev].byt[13]=0; break; //- ����� � ������, ����� ����� ��
								case 9:		FR3[sp_prav].byt[13]=0;break; //-������ � ������, ����� ������ ��
								default:	FR3[sp_lev].byt[13]=0; FR3[sp_prav].byt[13]=0; //����� ���������
							}
							New_For_ARM(sp_lev); New_For_ARM(sp_prav);

							FR3[jj].byt[13]=0; //--------------------------------------- ����� ���������

							//-------------------------------------- �������� ������ �� ��������� ������
							if((FR3[jj].byt[24])||(FR3[jj].byt[25]))FR3[jj].byt[24]=FR3[jj].byt[24]|0x80;

							if((tum+1)==(nom[10+i]&0xf)) FR3[jj].byt[17]=FR3[jj].byt[17]|l; //����������

							//-------------------------------------------- ���� ������� �� ������ ������
							if((tum+1) == ((num[10+i]&0xf0)>>4))FR3[jj].byt[16] = FR3[jj].byt[16]|1;

							//--------------- �������� ������ ������� ������ �������� � ������ ���������
							sgnl=FR3[jj].byt[24]*256+FR3[jj].byt[25];

							READ_BD(jj);
							if((BD_OSN[0]==4)&&(BD_OSN[1]!=0)) //-------------- ���� �� � � ���� �������
							{
								ii = BD_OSN[1];
								FR3[ii].byt[13] = 0;
								//���������� ��� ������� ������� ���������� ���������
								if(FR3[ii].byt[24]||FR3[ii].byt[25])FR3[ii].byt[24] = FR3[ii].byt[24]|0x80;

								FR3[ii].byt[27] = 0;
								FR3[ii].byt[26] = FR3[ii].byt[26]|0xE0; //���������� ������� �������
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
								FR3[jj].byt[j*2+1]=1;//��� ������ ���������� �����
								New_For_ARM(jj);
								break;
							default:
								FR3[sp_lev].byt[j*2+1]=1;//����������
								FR3[sp_prav].byt[j*2+1]=1;//����������
								New_For_ARM(sp_lev);
								New_For_ARM(sp_prav);
						}

						if(GRP=='C') //���� ������ - �������
						{
							READ_BD(jj);
							if(BD_OSN[12]!=9999)//���� ���������
							{
								if(BD_OSN[12]==1)//���� ��������
								{
									ii=BD_OSN[8]&0xFFF; //�������� ����� ������
									FR3[ii].byt[j*2+1]=1;
									if(j==3)
									{
										i_m = 0;
										for(i_m=0;i_m<Nst*3;i_m++)
										{
											i_s = 0;
											for(i_s=0;i_s<10;i_s++)
											{
												if((MARSHRUT_ALL[i_m].STREL[tum][i_s]&0xfff) == jj)
												{
													add(i_m,8888,12);
													DeleteMarsh(i_m);
													break;
												}
											}
										}
									}
								}
							}
						}
					}
					else //���� ��� ������� � 0
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

							case 0: FR3[jj].byt[j*2+1]=0;//��� ������ �������� �����
								New_For_ARM(jj);
								break;
							default:  if(sp_lev!=0)
												{
													FR3[sp_lev].byt[j*2+1]=0;  //��������
													FR3[sp_prav].byt[j*2+1]=0; //��������
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

						if((GRP == 'F') && (j == 1)) //���� �� ������������
						{
								if((FR3[jj].byt[24]&0x80)!=0) //���� ����� ������������� �������� ���������
								{
									sgnl = (FR3[jj].byt[24]&0x7f)*256 + FR3[jj].byt[25];
									FR3[jj].byt[24] = 0; FR3[jj].byt[25] = 0;  //�������� ����� ������� � ��
								}
								if(sp_prav!=0)
								if((FR3[sp_prav].byt[24]&0x80)!=0) //���� ����� ������������� �������� ���������
								{
									sgnl = (FR3[sp_prav].byt[24]&0x7f)*256 + FR3[sp_prav].byt[25];
									FR3[sp_prav].byt[24] = 0; FR3[sp_prav].byt[25] = 0;  //�������� ����� ������� � ��
								}

						}
						else
						if(GRP=='C') //���� ������ - �������
						{
							READ_BD(jj);
							if(BD_OSN[12]!=9999)//���� ���������
							{
								if(BD_OSN[12]==1)//���� ��������
								{
									ii=BD_OSN[8]&0xFFF; //�������� ����� ������
									FR3[ii].byt[j*2+1]=0;
								}
							}
						}
					}
				}
				FR3[jj].byt[27]=0;
				FR3[jj].byt[26]=FR3[jj].byt[26]|0XE0; //���������� ������� �������

				if(GRP=='L') //���� ��� ������ �����������
				{
					READ_BD(num[i]);
					if((BD_OSN[0]&0xff00)==0x400)//���� ���� ������ ����� ��
					{
						maska=BD_OSN[0]&0xff;//��������� ��������� ��������� ������ ��
						tester=0;
						for(j=0;j<5;j++)tester=tester+(FR3[num[i]].byt[j*2+1]<<j); //�������� �������
						if(tester==maska)PROCESS=0x40; //���� �������, �� ���������� �� ���
						else PROCESS=0; //����� ���������� �� ������
					}
					if(BD_OSN[0]==0x38F) //---------------- ���� ���� ������ �������� PAMX
					{
						if(FR3[num[i]].byt[5]!=FR3[num[i]].byt[7]) SVAZ = SVAZ | 0x80;
						else SVAZ = SVAZ & 0x7F;
						KOK_OT_TUMS = FR3[num[i]].byt[5];//����� ��� ��� = ��������� ������ ��
						KOK_OT_TUMS = KOK_OT_TUMS | FR3[num[i]].byt[7];
					}
				}
FIN:
				if(sgnl)//----------------------------------------------- ���� ��� �������� ������
				{
					if(sgnl<0x8000) //���� ������ �� ���������� ����������� ������
					{
						jj=sgnl;
						FR3[jj].byt[13]=0;FR3[jj].byt[15]=0;
						FR3[jj].byt[24]=0;

						FR3[jj].byt[27]=0;
						FR3[jj].byt[26]=FR3[jj].byt[26]|0xE0; //���������� ������� �������
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
			}

			if(tiki_tum[tum]>30)//���� ���������� ������ �����
			{
				if(GRP=='L') //���� ��� ������ �����������
				{
					READ_BD(num[i]);
					if(BD_OSN[0]==25)KORZINA[tum]=VVOD[tum][sob][i]&1;
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
	char ZAPIS[40],tms[2],nom[3],nom_fr4[4],OGR[2],VREMA[9];
	unsigned int ito,i,kk;
	if (Serv1->Sost == 8888  )return;
	for(ito=0;ito<40;ito++)ZAPIS[ito]=0;
	//--------------------------------------------------------- �������� ����� � ����� �����
	strcpy(ZAPIS,Time1);
	strncat(ZAPIS," ",1);
	if((sob!=200)&&(sob!=300)&&(sob!=7777)&&(sob!=6666)&&(sob!=3333)&&(sob!=5555))
	{
		tms[0]=st+49; 	tms[1]=32;	strncat(ZAPIS,tms,2);	strncat(ZAPIS," ",1);
	}
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
		strncat(ZAPIS,"{㤠�}",6);
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
	if(sob!=9999)	//-------------------------------------------------------- ���� �� �������
	{
		nom[0]=0;nom[1]=0;nom[2]=0;
		if(sob<10) { nom[0]=48;	nom[1]=sob+48; }
		else
		{
			nom[0]=(sob/10)+48;	nom[1]=(sob%10)+48;
		}
		strcat(ZAPIS,nom); 	//--------------------------------------- �������� ����� ���������
		if(knl==0)strncat(ZAPIS,"-1",2); //----------------------------- �������� ����� ������
		else strncat(ZAPIS,"-2",2);
		kk=strlen(ZAPIS);
			//�������� ���������� �������� ��������
		if(knl==0) for(i=0;i<12;i++)ZAPIS[kk+i]=REG[st][knl][i];
		else for(i=0;i<12;i++)ZAPIS[kk+i]=REG[st][knl][i];
	}
	else   //------------------------------------------------------ ���� ����������� �������
	{
		strncat(ZAPIS,"<Kom>",5);
		if(KOMANDA_ST[st][11]!=0)  //---------------------------- ���� ���� ���������� �������
		{
			kk=strlen(ZAPIS);
			for(i=0;i<12;i++)ZAPIS[kk+i]=KOMANDA_ST[st][i]; //--------- ���������� ����� �������
		}
		else
		if(KOMANDA_TUMS[st][11]!=0) //--------------------------- ���� ���� ���������� �������
		{
			kk=strlen(ZAPIS);
			for(i=0;i<12;i++)ZAPIS[kk+i]=KOMANDA_TUMS[st][i]; //------------ ����������� �������
		}
	}
	if(ACTIV==1)strncat(ZAPIS,"_A",2);
	ZAPIS[strlen(ZAPIS)]=0xd;
	ZAPIS[strlen(ZAPIS)]=0;
	ito=write(file_arc,ZAPIS,strlen(ZAPIS));
	return;
}
//========================================================================================
//--------------------------------------------------- ���������� ������ ��� �������� � ���
void __fastcall TStancia::ARM_OUT(void)
{
	int i,j,k,n_out,n_out1,ARM,stoyka,bait,tst;
	int jf;
	unsigned int CRC; //------------------------------------------- ����������� ����� CRC-16
	unsigned char
	OUT_BYTE,   //------------------------------------------ ���� ��������� ������� ���� ���
	ZAGOL,      //----------------------------------- ���� ��������� ��� ��������� � ��� ���
	SOST;       //------------------------------------------- ���� ��������� ������� ��� ���

	for(i=0;i<70;i++)	{BUF_OUT_ARM[i]=0;BUF_OUT_ARM1[i]=0;} //------- �������� ������ ������
	ZAPROS_ARM=4;	//-------------------------------------------------------- ������ ��������
	ARM=ZAPROS_ARM-4;	//--------------------- ��������� �������� ��������� � ���������� ����
	BUF_OUT_ARM[3] = SVAZ; //------------ ����������� ���� ��������� ������� �����
	//-------------------------------------------- ���������� ��������� �� �������
	n_out = ZAPOLNI_KVIT(ARM,0);//������������ �������� ��������� �� ��������� ���� ������
	n_out1 = ZAPOLNI_KVIT1(ARM,0,n_out);
	n_out = n_out1;
	//����� �� ����� ����������� �������� �����
	OBJ_ARMu[N_PAKET].LAST=0;
	if((DIAGNOZ[1])||(DIAGNOZ[2]))
	{ //�������� � ����� �����������
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
	for(i=0;i<KOL_NEW;i++)//---------------------------- ������ �� ������� ��������� �������
	{
		if(NOVIZNA[i]==0)continue;//--------------------- ���� ��� ������� ������� � ���������

		//------------------------------------------------------ ���� ������ �� ��������� ����
		if(NOVIZNA[i]>=KOL_VO){NOVIZNA[i]=0;continue;}

		//----------------------------- ���� ���� ������� - ����� �� ������� ��������� �������
		jf=NOVIZNA[i];
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

		if((NOVIZNA_FR4[i]&0xfff)>=KOL_VO)
		{
			NOVIZNA_FR4[i]=0;
			continue; //------------------------------------------------------- ���� ��� �������
		}

		jf = NOVIZNA_FR4[i]&0xFFF; //-------------------------------- ����� �� ����� ��� �����

		if((OUT_OB[jf].byt[1]==32)&&(OUT_OB[jf].byt[0]==32))
		{
			NOVIZNA_FR4[i]=0;
			continue; //----------------------------------------------- ���� ������  �� ��� ����
		}

		if((OUT_OB[jf].byt[1]==0)&&(OUT_OB[jf].byt[0]==0))
		{
			NOVIZNA_FR4[i]=0;
			continue; //-------------------------- ���� ������ ������ ������� � ��������� ������
		}

		OUT_BYTE = FR4[NOVIZNA_FR4[i]&0xfff];
		BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[1];//------- �������� � ����� ������ ����� ��� ...
		BUF_OUT_ARM[n_out++]=OUT_OB[jf].byt[0]|0x80;//------------------------ ������� �������
		BUF_OUT_ARM[n_out++]=OUT_BYTE;  //----------------- �������� � ����� ��������� �������

		NOVIZNA_FR4[i]=NOVIZNA_FR4[i]+0x1000; //-------- ��������� ������� ������� �����������
		if((NOVIZNA_FR4[i]&0x3000)==0x3000)NOVIZNA_FR4[i]=0;//- 3 ��������,  ������ �� �������
		if(n_out>64)break;//------------------------------------ �������� ����� �������� � ���
	}

	if(i==10)new_fr4=0; //--------------------------- �������� ������� �������, ������ �����

	if(n_out<65)//------------------------------------ ���� � ������ �������� �������� �����

	for(i=1;i<(int)KOL_VO;i++)
	{
		if(PEREDACHA[i])continue; //----------------------- ���� ��� �������, ������ �� ������

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
		OBJ_ARMu[N_PAKET].OBJ[j]=i;//������������ ������
    PEREDACHA[i]=PEREDANO;
    if(n_out>64)break;
	}
a1:
	if(n_out<65)
	{
		for(i=povtor_out;i<(int)KOL_VO;i++)
		{

		 //����� ��������� �������
			stoyka=(FR3[i].byt[28]&0xF0)>>4;//�������� ������
			if(stoyka==0)stoyka=1;
			bait=FR3[i].byt[28]&0xf;        //�������� ����
			if(Norma_TS[stoyka-1]==false)
			{
				SVAZ = SVAZ | (1<<(stoyka-1));
				if(FR3[i].byt[29]>=48)
				{
				 FR3[i].byt[11]=1; //�������� ��������������
				 VVOD[stoyka-1][FR3[i].byt[29]-48][bait-1]=
				 VVOD[stoyka-1][FR3[i].byt[29]-48][bait-1]|0x20;
				}
			}
			else SVAZ = SVAZ & (!(1<<(stoyka-1)));
			//����� ����� ������� ��� ���
			//���� ������ �� ��� ��� , �� ������ �� ������
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
        BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[1];//�������� � ����� ������ ��� ����� ���
        BUF_OUT_ARM[n_out++]=OUT_OB[i].byt[0]|0x80;//������� �������
        BUF_OUT_ARM[n_out++]=OUT_BYTE;  //�������� � ����� ��������� �������
      }

      FR3[i].byt[27]=FR3[i].byt[27]|0x1f;//���������� ����� �������� � ���
      FR3[i].byt[26]=FR3[i].byt[26]|(N_PAKET&0x1F);//��������� ����� ������ ��������
      j=OBJ_ARMu[N_PAKET].LAST++;
      OBJ_ARMu[N_PAKET].OBJ[j]=i;//������������ ������
      if(n_out>64)break;
    }
    povtor_out=i;
    if(povtor_out>=(int)KOL_VO)povtor_out=1;
    goto a1;
  }
  //������������ ���������
	ZAGOL=0;
	ZAGOL=ZAGOL|(ZAPROS_ARM&0xf);
  SERVER=NUM_ARM;
	ZAGOL=ZAGOL|((SERVER<<4)&0xf0);
	SOST=0x10;
	SOST=SOST|(1<<(SERVER-1));//���������� ������� ����������� �������
  j=0;
	if(STATUS==1)SOST=SOST|0x80;  //���� ��������
	else SOST=SOST&0x7f; //���� ���������
	/*
	if(KONFIG_ARM==0xFF)SOST=SOST|0x80;  //���� ��������
	else SOST=SOST&0x7f; //���� ���������
  */
	if(PROCESS==0)SOST=SOST&0xef;

	if( KNOPKA_OK0 != KOK_OT_TUMS) SVAZ = SVAZ | 0x80;
	else SVAZ = SVAZ & 0x7F;

	#ifdef ARPEX
	if((KNOPKA_OK0==1) && (KOK_OT_TUMS == 1))
	{
		KNOPKA_OK=1;
		SOST=SOST|0x20; //�������� ������� ������
	}
	else
	{
		KNOPKA_OK=0;
		SOST = SOST & 0xDF;
	}
	#else
	if(KNOPKA_OK0==1)
	{
		KNOPKA_OK=1;
		SOST=SOST|0x20; //�������� ������� ������
	}
	else
	{
		KNOPKA_OK=0;
		SOST = SOST & 0xDF;
	}
	#endif
	SOST=SOST|PROCESS; //�������� ��������� ������ ���������� ��� ��� �����
//  SOST=SOST&0xeF;
	BUF_OUT_ARM[2]=SOST;
	BUF_OUT_ARM[1]=ZAGOL;
	BUF_OUT_ARM[3]=SVAZ;
  CRC=CalculateCRC16(&BUF_OUT_ARM[1],66); //���������� CRC

  PAKETs[N_PAKET].KS_OSN=CRC;//��������� ����������� ����� ������
  PAKETs[N_PAKET].ARM_OSN_KAN=0x1f;//��������� ���� �������� � ����

  BUF_OUT_ARM[68]=(CRC&0xFF00)>>8;
  BUF_OUT_ARM[67]=CRC&0xFF;
  BUF_OUT_ARM[0]=0xAA;
  BUF_OUT_ARM[69]=0x55;
  N_PAKET++;
	if(N_PAKET==32) N_PAKET=0;
// if(BUF_OUT_DC[0]==0)
// for(i=0;i<70;i++)BUF_OUT_DC[i]=BUF_OUT_ARM[i];
 for(i=0;i<28;i++)BUF_IN_ARM[i] = 0;
  return;
}

/******************************************************\
*     ��������� ���������� ��������� ������ ��� ����   *
*         ZAPOLNI_KVIT(int arm,int knl)                *
*         arm - ������ ����                            *
*         knl - ������ ������                          *
\******************************************************/
int __fastcall TStancia::ZAPOLNI_KVIT(int arm,int knl)
{
  int i, n_ou=4;
  //���� ���� ��������� ��� ����� ������
	if((KVIT_ARMu[0])||(KVIT_ARMu[1]))
	{
		if(knl==0)
		{ //������ ���������
			for(i=0;i<3;i++)BUF_OUT_ARM[n_ou++]=KVIT_ARMu[i];
			//���� ��� ������ 999 - ������ ����������, �� �������� �������� FR3
			if((KVIT_ARMu[0]==0xE7)&&((KVIT_ARMu[1]&0xf)==3))
			{
				BUF_OUT_ARM[n_ou++]=KVIT_ARMu[0];
				BUF_OUT_ARM[n_ou++]=KVIT_ARMu[1]&0xf;
				BUF_OUT_ARM[n_ou++]=1;

			}
			for(i=0;i<3;i++)KVIT_ARMu[i]=0;
		}
    else
    //���� ���� ��������� ��� ���������� ������
    if(knl==1)
		{
			for(i=0;i<3;i++)BUF_OUT_ARM1[n_ou++]=KVIT_ARMu[i];
			//���� ������ 999
			if((KVIT_ARMu[0]==0xE7) &&((KVIT_ARMu[1]&0xf)==3))
			{
				BUF_OUT_ARM1[n_ou++]=KVIT_ARMu[0];
				BUF_OUT_ARM1[n_ou++]=KVIT_ARMu[1]&0xf;
				if(KONFIG_ARM==0xFF)BUF_OUT_ARM1[n_ou++]=0x81;
				else BUF_OUT_ARM1[n_ou++]=1;
			}
			for(i=0;i<3;i++)KVIT_ARMu[i]=0;
		}
	}
	return(n_ou);
}
/*********************************************************\
*     ��������� ���������� ��������� -��������� ��� ����   *
*         ZAPOLNI_KVIT1(int arm,int knl)                    *
*         arm - ������ ����                                *
*         knl - ������ ������                              *
\**********************************************************/
int __fastcall TStancia::ZAPOLNI_KVIT1(int arm,int knl,int n_ou)
{
	int i;
	//���� ���� ��������� ��� ����� ������
	if((KVIT_ARMu1[0])||(KVIT_ARMu1[1]))
	{ if(knl==0) //������ ���������
			for(i=0;i<3;i++)BUF_OUT_ARM[n_ou++]=KVIT_ARMu1[i];
		else
		//���� ���� ��������� ��� ���������� ������
		if(knl==1) for(i=0;i<3;i++)BUF_OUT_ARM1[n_ou++]=KVIT_ARMu1[i];
		for(i=0;i<3;i++)KVIT_ARMu1[i]=0;
	}
	return(n_ou);
}
/***********************************************\
*  int CalculateCRC8(void *pData, int dataLen)  *
*        ��������� ������� CRC-8                *
* pData - ��������� �� ����� ������ ��������    *
* dataLen -����� ������ ������                  *
\***********************************************/
char __fastcall TStancia::CalculateCRC8(void *pData, int dataLen)
{
  unsigned char *ptr = (unsigned char *)pData;
	unsigned char c = 0xff;
  int n;
  for (n = 0; n < dataLen; n++) c = crc8_table[ *ptr++ ^ c ];
  return c ^ 0xff;
}

/***********************************************\
*  int CalculateCRC16(void *pData, int dataLen) *
*        ��������� ������� CRC-16               *
* pData - ��������� �� ����� ������ ��������    *
* dataLen -����� ������ ������                  *
\***********************************************/

int __fastcall TStancia::CalculateCRC16(void *pData, int dataLen)
{
  unsigned char *ptr = (unsigned char *)pData;
	unsigned int c = 0xffff,a,b;
  int n;
  for (n = 0; n < dataLen; n++)
  {
    a=c>>8;
    b=(c<<8)&0xffff;
    c = crc16_table[ *ptr++ ^ a ] ^ b;
  }
  return c ^ 0xffff;
}
//-------------------------
void __fastcall TStancia::READ_BD(int jb)
{
  int l;
  for(l=0;l<16;l++)
	BD_OSN[l]=BD_OSN_BYT[jb].byt[l*2]*256+BD_OSN_BYT[jb].byt[2*l+1];
}
//-------------------------------------------------------------------------------------------
/*****************************************\
*    ��������� ������� ������,            *
*         �������� �� ����                *
*             ANALIZ_ARM()                *
\*****************************************/
//---------------------------------------------------------------------------
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
//------------------------------------
/**************************************\
*     ��������� ���������� ������,     *
*          �������� �� ����            *
* RASPAK_ARM(int bb,unsigned char STAT)*
* bb - ��� ������ ������ ������        *
* STAT -��� ������ (0-���.; 1-���.)    *
\**************************************/
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
		if(((KOM_BUFER[3]>0)&&(KOM_BUFER[3]<128))|| //--------- ���� ������-���������� �������
		((KOM_BUFER[3]>192)&&(KOM_BUFER[3]<203)))   //---------- �� ���������� �� � ���.������
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
			KVIT_ARMu[1]=KOMANDA_RAZD[2]|0x40;//�������� ������� ���������
			KVIT_ARMu[2]=0;
			MAKE_KOMANDA(ARM,STAT,RAY);
			if(STOP_ALL==15)return;
		}
		if(KOMANDA_MARS[0])
		{
			KVIT_ARMu[0]=KOMANDA_MARS[1];
			KVIT_ARMu[1]=KOMANDA_MARS[2]|0x40;//�������� ������� ���������
			KVIT_ARMu[2]=1;
			MAKE_MARSH(ARM,STAT);
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
/*************************************************************\
*     MAKE_KOMANDA(int ARM,int STAT,unsigned char ray)        *
*     ��������� ������������� ���������� ������ �� ����       *
*              � ���� ������ ����� ����                       *
*       ARM - ������ ����, ��������� �������                  *
*       STAT - ��� ������,�� �������� �������� �������        *
*       ray  - ��� ������ ����������                          *
\*************************************************************/
void __fastcall TStancia::MAKE_KOMANDA(int ARM,int STAT,int ray)
{
  unsigned short int obj,obj_serv,ii,tip_ob,job;
  unsigned char komanda;
  AnsiString Arm_kom;
	if(KOMANDA_RAZD[0])//���� ���� ������ ����������
	{ //��������� ������ ������� ����
		obj=KOMANDA_RAZD[1]+KOMANDA_RAZD[2]*256;

		if((obj==0)||(obj>=(unsigned short)KOL_VO))
		{
			for(ii=0;ii<3;ii++)KOMANDA_RAZD[ii]=0;
			return;
		}
		komanda=KOMANDA_RAZD[0]; //��������� ���� �������
		if(Otladka1->Otlad==5)
		{
			Arm_kom=IntToStr(komanda)+" - "+IntToStr(obj);
			Edit3->Text=Arm_kom;
		}
		//-----------------------------------------------------------------
		//-----------��������� ������ �� ������������ ������ � ��̠
		//-----------------------------------------------------------------
		if(obj==1)
		{
			if((komanda==79)&&(PROCESS==0x40))//���� ���������� ����������
			{
					KONFIG_ARM=0xFF;
			}
			else
			if((komanda==80)&&(PROCESS==0x40))//���� ������ ���������
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
		//------------------------------------------------
		//  ��������� ������� ��� ����������� ��������
		//------------------------------------------------
		if(obj==998)
		{
			if(komanda!=96)return;
			else
			{
				if(ACTIV==1)RESET_TIME=10; //��������� ������������ 0,5 ���
			}
			return;
		}
		//-------------------------------------------------
		//  ��������� ��������� ������
		//-------------------------------------------------
		//������� ��������������� ������ �������

		obj_serv=INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];
		if(obj_serv>(unsigned short)KOL_VO)return;
		READ_BD(obj_serv); 											//������ ������ �������
		if(BD_OSN[0]<100)tip_ob=BD_OSN[0]&0xF; //�������� ��� �������
		else tip_ob=BD_OSN[0];
		if(((tip_ob>=1)&&(tip_ob<=5))||(tip_ob==8)||(tip_ob==9))
		{
			switch(tip_ob) //� ����������� �� ������� �������� �������
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
		// ���� ��� ���������� �������
		if(BD_OSN[0]==226)
		{
			if(komanda==71) //���� �������������������� �������
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
				if((BD_OSN[4]==1)||(BD_OSN[4]==0))komanda=64;
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

	if(KOMANDA_MARS[0])//----------------------------------- ���� ���� ����������
	{
		obj = KOMANDA_MARS[1] + KOMANDA_MARS[2]*256;
		obj0 = obj; //---------------------------------------- ������ �������� � ��������� DSP
		if((obj<=0)||(obj>=KOL_VO))//----------------------------- ���� ������ ������ ��� ����
		{
			for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
			return;
		}
		komanda = KOMANDA_MARS[0]; //------------------------- �������� ��� �������
		if((komanda == 189) ||(komanda == 188))POVTOR_OTKR = 0xFF;

		nach_marsh=INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];//- �������� ������ �������� STAN

		obj = KOMANDA_MARS[3]+KOMANDA_MARS[4]*256; //---- ����� �� � DSP

		if((obj==0)||(obj>=KOL_VO)) //----------------------------- ���� ������ ����� ��� ����
		{
			for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
			return;
		}
		end_marsh = INP_OB[obj].byt[0]*256+INP_OB[obj].byt[1];//----- ����� �������� �� � STAN

		nstrel=KOMANDA_MARS[5]; //---------------------- ����� ������������ �������

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
 	for(ii=0;ii<12;ii++)KOMANDA_MARS[ii]=0;
	return;
}
 /**********************************************************************\
* perevod_strlk - ������ ������������ ���������� ������� �� �������    *
* command - ���� ����������� ������� �� �������                        *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� ������� � �� *
\**********************************************************************/
void __fastcall TStancia::perevod_strlk(unsigned char command,unsigned int objserv)
{
  unsigned char tums,//����� ������
  gruppa,//��� ������ ��� ������� �������
  podgruppa, //��� ��������� ��� �������
  kod_cmd, //��� ������� ��� �������
  bit;    //����� ����� ��� ������� �������
	//--------------------------------------------------------------
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='C';
  podgruppa=BD_OSN[15]&0xff;
  switch(command)
	{
    //��������� ������� �� ����������
    case 31:  FR4[objserv]=FR4[objserv]|1;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //�������� ������� � ����������
    case 32:  FR4[objserv]=FR4[objserv]&0xFE;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;

    //������� �������� �� �������
    case 33:  FR4[objserv]=FR4[objserv]|4;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� �������� �� �������
    case 34:  FR4[objserv]=FR4[objserv]&0xFB;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������, ������ � 0
              return;
    //������� �������� �� ������� �������
    case 35:  FR4[objserv]=FR4[objserv]|8;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� �������� �� ������� �������
    case 36:  FR4[objserv]=FR4[objserv]&0xF7;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
							if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //���������� ����� �� �������
    case 37:  FR4[objserv]=FR4[objserv]|2;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //����� ������� � ������
    case 38:  FR4[objserv]=FR4[objserv]&0xFD;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
      //������� ��������������� �������� �� �������
    case 114:  FR4[objserv]=FR4[objserv]|0x10;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� ��������������� �������� �� �������
    case 115: FR4[objserv]=FR4[objserv]&0xEF;
							NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������, ������ � 0
              return;
    //������� ��������������� �������� �� ������� �������
    case 116: FR4[objserv]=FR4[objserv]|0x20;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    //������� ��������������� �������� �� ������� �������
    case 117: FR4[objserv]=FR4[objserv]&0xDF;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    case 41:  kod_cmd='A';break;  //������� ������� ������� � ����
    case 42:  kod_cmd='B';break;  //������� ������� ������� � �����
    case 43:  kod_cmd='Q';break;  //��������������� ������� ������� � ����
		case 44:  kod_cmd='R';break;  //��������������� ������� ������� � �����
    case 81:  kod_cmd='E';break;  //������� ������� �� ������ � ����
    case 82:  kod_cmd='F';break;  //������� ������� �� ������ � �����
    case 83:  kod_cmd='U';break;  //��������������� ������� ������� �� ������ � ����
    case 84:  kod_cmd='V';break;  //��������������� ������� ������� �� ������ � �����

    case 107: kod_cmd='I';break; //������� � ���� � ��������
    case 127: kod_cmd='J';break;  //������� � ����� � ��������
    default:  return;
  }
  int Err=0;
  if((command>=41)&&(command<=84))
  {
		for(int i_m=0;i_m<Nst*3;i_m++)
    for(int i_s=0;i_s<Nst;i_s++)
    for(int i_str=0;i_str<10;i_str++)
		if(MARSHRUT_ALL[i_m].STREL[i_s][i_str]==objserv)
		{
      DeleteMarsh(i_m);
			add(i_m,8888,13);
      Err++;
    }
  }
  bit=(BD_OSN[15]&0xe000)>>13; //�������� ����� ����� � ��������� = ����� ���� ��� �������
	ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
	return;
}

/*************************************************************************\
* signaly - ������ ������������ ���������� ������ �� ������                *
* command - ���� ����������� ������� �� �������                           *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� ������� � ��    *
* unsigned objserv - ������ � ������� ��� ������������ �������            *
\****************************************************************�********/
void __fastcall TStancia::signaly(unsigned char command,unsigned int objserv)
{
  unsigned char tums,//����� ������
  gruppa,//��� ������ ��� ������� �������
  podgruppa, //��� ��������� ��� �������
  kod_cmd, //��� ������� ��� �������
  sp_in_put, //�� ������� � ����
  spar_sp,   //�� ��������� �������
  job, //����� ���� ������
  i_m,  //������ ����������� ��������
  i_s,  //������ ������
  i_sig, //������ �������
  bit,    //����� ����� ��� ������� �������
  ii;     //��������������� ����������
  unsigned int ob_next;
  int shag,kk,jf;
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='E';
  podgruppa=BD_OSN[15]&0xff;
  bit=(BD_OSN[15]&0xe000)>>13;
  switch(command)
  {
                 //�������� ��������
    case 33:  FR4[objserv]=FR4[objserv]|4;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    case 34:  FR4[objserv]=FR4[objserv]&0xFB;
              NOVIZNA_FR4[new_fr4++]=objserv;//��������� ����� ������������ �������
              if(new_fr4>=10)new_fr4=0; //���� �� �������� ����� 10 ������,������ � 0
              return;
    case 95:            
		case 45:  kod_cmd='A';break;
    case 46:  kod_cmd='B';break;

		case 47:  kod_cmd='E';//������ ����������� ��������
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
              READ_BD(objserv);//��������� ���� �������
              if(BD_OSN[1]==0)shag=-1;//��� ������� ������� ���� �����
              else shag=1; //��� ��������� ���� ������
              //������ �� ���������� ������� � ���� �� �� ��� ��
              for(kk=objserv+shag;(kk>0)&&(kk<(int)KOL_VO);)
							{
                READ_BD(kk);
                if((BD_OSN[0]==3)||(BD_OSN[0]==4))break;
                if(BD_OSN[0]==6)kk=BD_OSN[1];
                else kk=kk+shag;
              }
              jf=kk; //����� FR3
              if((FR3[jf].byt[2]==0)&&(FR3[jf].byt[3]==0)) // ���� ����������
              {
                jf=objserv;
								if((FR3[jf].byt[24]&0x80)==0)//���� ������ �� ����������
								{
									FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
									New_For_ARM(objserv);
								}
							}
              while(objserv)
              {
                jf=objserv;
                READ_BD(jf);
                if(((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;
                //����� �������� ���������
                if((FR3[jf].byt[1]==0)&&(FR3[jf].byt[3]==0)&&
                (FR3[jf].byt[5]==0)&&(FR3[jf].byt[7]==0)&&(ii))
                {
                  if((FR3[jf].byt[24]&0x80)==0)
                  {
										FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
										New_For_ARM(objserv);
										if(BD_OSN[0]==5)//���� ����
                    {
                      if(BD_OSN[1]!=0)
                      {
                        job=BD_OSN[1];
                        //����� �������� ���������
                        FR3[job].byt[12]=0;FR3[job].byt[13]=0;
                        FR3[job].byt[14]=0;FR3[job].byt[15]=0;
												FR3[job].byt[20]=0;FR3[job].byt[21]=0;
												New_For_ARM(job);
											}
                    }
                  }
                }
                ob_next=(FR3[jf].byt[20]&0xF)*256+FR3[jf].byt[21];
                if(ii){FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;}
                ii++;
                //��������� ���������� ������� �� ����������� �����
                objserv=ob_next;
              }
              break;

		case 48:  kod_cmd='F';//������ ��������� ��������
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
              for(kk=objserv+shag;(kk>0)&&(kk<(int)KOL_VO);)
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
                //������������ ���� ������
                READ_BD(jf);
                //���� ������ ������ ���� �� ������, �� �� ������ ������
                if((BD_OSN[0]==2)&&((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;
                if((BD_OSN[0]==7)&&(BD_OSN[1]==15))//���� �� ��� ������� � ����
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
                if(BD_OSN[0]==5) //���� ����
                {
                  if(BD_OSN[1]!=0)
                  {
                    job=BD_OSN[1];
                    //����� �������� ���������
                    FR3[job].byt[12]=0;FR3[job].byt[13]=0;FR3[job].byt[14]=0;FR3[job].byt[15]=0;
										//FR3[job].byt[20]=0;FR3[job].byt[21]=0;
										New_For_ARM(job);
									}
                }
                //����� �������� ���������
								if((FR3[jf].byt[1]==0)&&(FR3[jf].byt[3]==0)&&
                (FR3[jf].byt[5]==0)&&(FR3[jf].byt[7]==0)&&(ii))
                {
                  //����� �������� ���������
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
		case 49:
		case 111:	kod_cmd='A';break;
		case 50:
		case 112:	kod_cmd='B';break;
		case 62:  kod_cmd='B';break;
    case 85:  jf=objserv;
              //����� �������� ���������
              FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
							FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;
							New_For_ARM(objserv);
							return;
		//������������ �������
#ifdef KOL_AVTOD
		case 108: MAKE_AVTOD(objserv);
							return;
#endif							
    default: return;
  }
	ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}
/**************************************************************\
* ZAGRUZ_KOM_TUMS - ������ �������� ���������� ������� � ����  *
* tms - ����� ����                                             *
* grp - ��� ������                                             *
* pdgrp - ��� ���������                                        *
* kd_cmd - ��� �������                                         *
* bt ����� ����� � ���������                                   *
* int BD_OSN[16] - ������ �������� ������� ���������� � ��     *
\*****************************************************�********/
void __fastcall TStancia::ZAGRUZ_KOM_TUMS( char tms,
                                        char grp,
                                        char pdgrp,
                                        char bt,
                                        char kd_cmd)
{
  int i,j;
  char adr_kom;
  for(i=0;i<15;i++)KOMANDA_ST[tms-1][i]=0;
#ifdef ORSK
  switch(tms)
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
  adr_kom=0x40;
  if(tms==1)adr_kom=adr_kom|1;
  if(tms==2)adr_kom=adr_kom|2;
	if(STATUS==1)
  {
		if(NUM_ARM==1)adr_kom=adr_kom|4;
    if(NUM_ARM==2)adr_kom=adr_kom|8;
  }
#endif
	KOMANDA_ST[tms-1][0]='(';
	KOMANDA_ST[tms-1][1]=adr_kom; //������������ �����
	KOMANDA_ST[tms-1][2]=grp;
	KOMANDA_ST[tms-1][3]=pdgrp;
	for(j=4;j<10;j++)KOMANDA_ST[tms-1][j]='|';
	KOMANDA_ST[tms-1][3+bt]=kd_cmd;
	KOMANDA_ST[tms-1][10]=check_summ(KOMANDA_ST[tms-1]);
	KOMANDA_ST[tms-1][11]=')';
  KOMANDA_ST[tms-1][12]=0;
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
/*************************************************************************\
* sp_up_and_razd ������ ������������ ���������� ������ �� ��,�� � ��������*
* command - ���� ����������� ������� �� �������                           *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� ��,�� � ��      *
\*************************************************************************/
void __fastcall TStancia::sp_up_and_razd(unsigned char command,unsigned int objserv,int arm)
{

	unsigned char tums,//����� ������
	gruppa,//��� ������ ��� ������� �������
	podgruppa, //��� ���������
	kod_cmd, //��� �������
	bit;    //����� ����� ��� ������� �������
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

		case 198:
		case 201:
		case 202:
		case 193:
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
	ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
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
    case 8:
		case 200: if(KNOPKA_OK == 1){kod_cmd='X';break;}
							else return;

		case 55: if(KNOPKA_OK == 1){kod_cmd='N';break;}
						 else return;

		case 199:
		case 195:
		case 202:
		case 3:
		case 7:
		case 194:
		case 2:  if(KNOPKA_OK == 1){kod_cmd='T';break;}
						 else return;

		case 60: if(KNOPKA_OK == 1){kod_cmd='M';break;}
						 else return;

		case 53:
		case 75:
		case 105:
		case 67:
		case 61: kod_cmd='A';break;

		case 197: if(KNOPKA_OK == 1){kod_cmd='A';break;}
						 else return;
		case 106:
		case 68: kod_cmd='M';break;

		case 63:
		case 76:
		case 78:
		case 59:
		case 57: kod_cmd='B';break;

		case 113:
		case 86:
		case 77:
		case 58: kod_cmd='N';break;

		case 56: kod_cmd = 'F';break;
		default: return;
	}
	bit=(BD_OSN[15]&0xe000)>>13;
	ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
	return;
}
/*************************************************************************\
* prosto_komanda ������ ������������ ���������� ������ ��� ���.��������   *
* command - ���� ����������� ������� �� �������                           *
* int BD_OSN[16] - ������ �������� ������� ���������� � ��                *
\****************************************************************�********/
void __fastcall TStancia::prosto_komanda(unsigned char command)
{
	unsigned char tums,//����� ������
	gruppa,//��� ������ ��� ������� �������
	podgruppa, //��� ��������� ��� �������
	kod_cmd, //��� ������� ��� �������
	bit;    //����� ����� ��� ������� �������
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
	ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
	return;
}
/***************************************************\
*  ��������� ������ ������� �� ������ �����������   *
*  ob_tums(unsigned char command,int obj_serv)      *
\***************************************************/
void __fastcall TStancia::ob_tums(unsigned char command)
{
	unsigned char tums,//����� ������
	gruppa,//��� ������ ��� ������� �������
  podgruppa, //��� ��������� ��� �������
	kod_cmd, //��� ������� ��� �������
  bit;    //����� ����� ��� ������� �������
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
  ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}
/*************************************************************************\
* otmena_rm - ������ ������������ ������� ������ ���������.��������       *
* int BD_OSN[16] - ������ �������� ������� ���������� ��� �� � ��         *
* unsigned int objserv - ������ � ������� ��� ����������� �������         *
\****************************************************************�********/
void __fastcall TStancia::otmena_rm(unsigned int objserv)
{
  unsigned char tums,//����� ������
  gruppa,//��� ������ ��� ������� �������
  podgruppa, //��� ���������
  kod_cmd, //��� �������
  bit,    //����� ����� ��� ������� �������
  ii;     //��������������� ����������
  int jf;
  unsigned int ob_next;
  tums=(BD_OSN[13]&0xff00)>>8;
  gruppa='Q';
  podgruppa=BD_OSN[15]&0xff;
	kod_cmd='N';//������
  ii=0;
  objserv=BD_OSN[1];
  while(objserv)
  {
    jf=objserv;
    if(((FR3[jf].byt[20]&0x80)==0x80)&&(ii))break;
    ii++;
    //����� �������� ���������
    if((FR3[jf].byt[12])||(FR3[jf].byt[13])||(FR3[jf].byt[14])||(FR3[jf].byt[15]))
    {
      //����� �������� ���������
      FR3[jf].byt[12]=0;FR3[jf].byt[13]=0;
			FR3[jf].byt[14]=0;FR3[jf].byt[15]=0;
			New_For_ARM(objserv);
		}
    ob_next=(FR3[jf].byt[20]&0xF)*256+FR3[jf].byt[21];
    FR3[jf].byt[20]=0;FR3[jf].byt[21]=0;
    //��������� �� ����������� ����� ���������� �������
    objserv=ob_next;
  }
  bit=(BD_OSN[15]&0xe000)>>13;
  ZAGRUZ_KOM_TUMS(tums,gruppa,podgruppa,bit,kod_cmd);
  return;
}

//========================================================================================
//------------------------------------------ ������ ������������ � ������� ������ ��������
//---------------------------------------- KOM - ��� ���������� ������� ���������� �� ����
//---------------------------------------------- NACH - ������ ������� ��� ������ ��������
//----------------------------------------------- END  - ������ ������� ��� ����� ��������
//---------------------------------- Nst - ����� ��������������� ������� � ������ ��������
//-------------------------- POL - ������� ������ ���������� ��������� ������� ��� �������
int __fastcall TStancia::ANALIZ_MARSH(unsigned int KOM,
unsigned int NACH,int END,int Nstrel,unsigned long POL)
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
	i_n; //------------------------------------------------------ ��������������� ����������
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
		i_n=0;
		//-------------------------------- �������� ������� ����� �� ��������, ��������� �����
		while((MARSHRUT_ALL[i_n].NACH != NACH)&& //-------------------- ���� �� ����� ������ �
		(MARSHRUT_ALL[i_n].END != END))//-------------------------------------- �� ����� �����
		{
			i_n++; //-------------------------------- ������������ �� ������ ��������� � �������
			if(i_n >= Nst*3)break;
		}

		if(i_n >= Nst*3)//----------------------------------- ���� ������������� ������� �����
		{
			i_n=0;
			while(MARSHRUT_ALL[i_n].NACH !=0 )//------ ���� � ���������� ������� ��������� �����
			{
				i_n++;
				if(i_n >= (Nst*3))break;
			}

			if(i_n>=(Nst*3))ERROR_MARSH=1004; //------------------ � ������� ��������� ��� �����

		}
		else
		{
				if(POVTOR_OTKR != 0)DeleteMarsh(i_n);
				else return(25000);
		}

		if(ERROR_MARSH==0)//--- ���� ���� ��� ��������� - �������� �������� �������� � �������
		{
			MARSHRUT_ALL[i_n].KMND=kod_marsh;
			MARSHRUT_ALL[i_n].NACH=NACH;
			MARSHRUT_ALL[i_n].END=END;
			MARSHRUT_ALL[i_n].NSTR=Nstrel;
			MARSHRUT_ALL[i_n].POL_STR=POL;
			add(NACH,7777,END);
			for(ii=0;ii<Nst;ii++)MARSHRUT_ALL[i_n].KOL_STR[ii] = 0;
		}

		ii = NACH;

		if(ERROR_MARSH<1000)ERROR_MARSH = i_n;

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
													MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++]=ii;
													TRASSA[jj].object=ii|0x4000;
													if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//������� �� � �����
													{
														//------------------------ ��������� ����� ����������� �������
														MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++;

														//-------------------------------- �������� ��������� ��������
														MARSHRUT_ALL[i_n].SOST = MARSHRUT_ALL[i_n].SOST&0xC0;

														//----------------------- ���������� ��������� ������ ��������
														MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;
													}
													ii=ii+shag;
												}
												else  //���� ����� �� �����, � ������ ������� ������ ���� � ������
												{
													MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++] = ii | 0x1000;
													TRASSA[jj].object=ii|0xC000;
													if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))//- ���� �� � ������
													{
														MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++; // �������++
														MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST&0xC0;//���������
														MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;//������ �����
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
												MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++] = ii;
												TRASSA[jj].object=ii|0x4000;
												if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//- ������� �� � �����
												{
													MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++;   // �������++
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST&0xC0;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;
												}
												ii=ii+shag;
											}
											else
											{
												//------------------------------------------------------------------------------------------$$4
												MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++] = ii|0x1000;
												TRASSA[jj].object=ii|0xC000; //�������� ������� � ������ � "-"
												if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))// ������� �� � ������
												{
													MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST&0xC0;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;
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
												//-------------------------------------------------------------------------------------------$$5
												MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++] = ii|0x1000;
												TRASSA[jj].object=ii|0x8000;                  //�������� � ��������� "-"
												if((FR3[ii].byt[1]!=0)||(FR3[ii].byt[3]!=1))//���� ������� �� � ������
												{
													MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST&0xC0;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;
												}
											}
											else
											{
												//-------------------------------------------------------------------------------------------$$6
												MARSHRUT_ALL[i_n].STREL[tums][ind_str[tums]++] = ii;
												TRASSA[jj].object=ii;//�������� ������� � ������ � "+"
												if((FR3[ii].byt[1]!=1)||(FR3[ii].byt[3]!=0))//���� ������� �� � �����
												{
													MARSHRUT_ALL[i_n].KOL_STR[TRASSA[jj].stoyka-1]++;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST&0xC0;
													MARSHRUT_ALL[i_n].SOST=MARSHRUT_ALL[i_n].SOST|3;
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
									ERROR_MARSH=ERROR_MARSH + ANALIZ_ST_IN_PUT(jj,kod_marsh,tums,i_n,ind_str[tums]);
								}
								if(BD_OSN[1]==14)	ERROR_MARSH=ERROR_MARSH + tst_str_ohr();
								ii=ii+shag;
								break;

			 default: TRASSA[jj].object = ii;
								if((BD_OSN[0]==3)||(BD_OSN[0]==4))
								{
									MARSHRUT_ALL[i_n].SP_UP[tums][ind_sp[tums]++] = ii;
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
										MARSHRUT_ALL[i_n].SIG[tums][ind_sig[tums]++]=ii;
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
			if(tek_strel>Nstrel){ERROR_MARSH=1006;break;}

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
						MARSHRUT_ALL[i_n].SIG[tums][n_sig]=TRASSA[jj].object&0xfff;
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
//----------------------------------------------   NACH - ��������� ������ ������ ��������
//------------------------------------------------	 END - ��������� ������ ����� ��������
void __fastcall TStancia::TUMS_MARSH(int i_m)
{
	int ii=0,last_end,first_beg,jj,sosed,i_s=0,s_m,test=0;
	int str_in_put,pol_str,sp_in_put,spar_sp;
	unsigned char tums_tek,tums_pred,adr_kom,perevod_str;
	unsigned char n_strel,sum,kmnd;
	unsigned int objk,objk_next,fiktiv=0,nachalo=0,END;
	unsigned long pol_strel=0l;
	if(TRASSA[0].object) //----------------------------------- ���� � ������ ������� �������
	{
		//-------------------------- ���� � ������ �� ��� �������, ������� ����� �� ����������
		if(MARSHRUT_ALL[i_m].NACH!=(TRASSA[0].object&0xfff))
		{
			ZeroMemory(&TRASSA,sizeof(TRASSA));	return;
		}
		else
		{
			kmnd=MARSHRUT_ALL[i_m].KMND; //--------------------------------------- ����� �������
			END=MARSHRUT_ALL[i_m].END;
			MARSHRUT_ALL[i_m].T_VYD = T_TIME;
		}
		ii=0;
		last_end=-1,first_beg=-1; //--------------------------------- ���������� ������ ������
		tums_pred=TRASSA[0].stoyka;
		tums_tek=tums_pred; //----------------------------------------------------- ����� ����
		//---------------------------------------------- ��������� ����� �� ���������� �������
		for(i_s=0;i_s<Nst;i_s++)test=test+MARSHRUT_ALL[i_m].KOL_STR[i_s];
		if(test==0)perevod_str=0;
		else perevod_str=0xf;
		 while(ii<200) //----------------------------------------------- ������ �� ���� ������
		{ if((TRASSA[ii].tip==2)||(TRASSA[ii].tip==0))  //------- ���� ������ ��� ����� ������
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
						//������������ �����
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
								if((TRASSA[jj].object&0x4000)==0x4000)//���� ���������������
								{
									if((TRASSA[jj].object&0x2000)!=0x2000) //���� ��� ��������
									{
										if((TRASSA[jj].object&0x8000)==0x8000)//���� � ������
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
						sum=0;
						//for(jj=1;jj<10;jj++)sum=sum^MARSHRUT_ST[i_s][s_m].NEXT_KOM[jj];
						//sum=sum|0x40;
						//MARSHRUT_ST[i_s][s_m].NEXT_KOM[10]=sum;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[10]=0;
						MARSHRUT_ST[i_s][s_m]->NEXT_KOM[11]=')';
						KOL_VYD_MARSH[i_s] = 0;
						add(i_s,6666,s_m);

						//������������� ��������� ���������� ��������
						if(perevod_str!=0)MARSHRUT_ST[i_s][s_m]->SOST=0x47;
						else	MARSHRUT_ST[i_s][s_m]->SOST=0x87;

						MARSHRUT_ST[i_s][s_m]->NUM=i_m + 100; //----- ���������� ����� ������ ��������

						if(MARSHRUT_ST[i_s][s_m]->NEXT_KOM[3]==0)fiktiv=0xf;
						else fiktiv=0;


 NEXT:      for(jj=first_beg;jj<=(last_end+1);jj++) //--- ������ �� �������� ��� ���������
						{ if(fiktiv==0)objk=TRASSA[jj].object&0xfff;
							else fiktiv=0;
							if(objk==0)break;
							objk_next=TRASSA[jj+1].object&0xfff;

							if(TRASSA[jj].tip==7)
							{
								READ_BD(objk_next);

								if((BD_OSN[0]==7)&&(BD_OSN[1]==15)&&((kmnd=='b')||(kmnd=='j')))//���� ������� � ����
								{
									sp_in_put=BD_OSN[3]; //�������� ������ ��� �� ������� � ����
									spar_sp=BD_OSN[5]; //�������� �� ��� ��������� �������
									FR3[sp_in_put].byt[12]=0;
									FR3[sp_in_put].byt[13]=1;  //�������� ��������������� ��������� ��
									New_For_ARM(sp_in_put);

									if(spar_sp!=0) //���� ���� �� ��� ��������� �������
									{
										FR3[spar_sp].byt[12]=0;
										FR3[spar_sp].byt[13]=1; //�������� ��������������� ��������� ��� ��������� �������
										New_For_ARM(spar_sp);
									}
								}
								FR3[objk].byt[20] = FR3[objk].byt[20]|(objk_next/256);
								FR3[objk].byt[21] = objk_next%256;
							}
							else //���� �� ��
							if((TRASSA[jj].tip>=3)&&(TRASSA[jj].tip<=5))//���� ��,��,����
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
								//���������� �������� ���������
								FR3[objk].byt[12]=0;
								FR3[objk].byt[13]=1;
                FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
								FR3[objk].byt[21]=objk_next%256;
								New_For_ARM(objk);
								if(TRASSA[jj].tip==5)  //���� ����
                {
                  READ_BD(objk);
                  if(BD_OSN[1]!=0)//���� ���� �����
                  {
                    sosed=BD_OSN[1];
                    FR3[sosed].byt[12]=0;
										FR3[sosed].byt[13]=1;
										New_For_ARM(sosed);
									}
								}
								if(nom_new>=KOL_NEW)nom_new=0; //���� �� �������� ����� 20 ������,������ � 0
              }
              else
							if((TRASSA[jj].tip==2)&&(objk!=END)) //���� ������
							{
								if((TRASSA[jj].object&0x8000)==0x8000)//���� ��� ������
								{
									nachalo=objk;
									if(kmnd=='a') //���� ���������� �������
									{
										FR3[objk].byt[12]=0;FR3[objk].byt[13]=1;
									}
									if(kmnd=='b')  //���� �������� �������
									{
										if((TRASSA[jj].object&0x2000)==0x2000) //���� ��������
										{
											FR3[objk].byt[14]=0;FR3[objk].byt[15]=1;
										}
									}
									FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
									//���� ���� ��������� ������ � ������ � ���������� �������
									if((s_m<3)&&(objk_next)&&(MARSHRUT_ST[i_s][s_m]->NEXT_KOM[3]))
									if((FR3[objk].byt[13])||(FR3[objk].byt[15]))
									FR3[objk].byt[20]=FR3[objk].byt[20]|0x80;
									FR3[objk].byt[21]=objk_next%256;
									New_For_ARM(objk);
								}
								else //���� �� ������� ������ ���
								{
									FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
									FR3[objk].byt[21]=objk_next%256;
								}
							}
							else
							{
								FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
								FR3[objk].byt[21]=objk_next%256;
							}
						} //����� ������� ��� ���������
						add(tums_pred-1,9999,0);
						first_beg=-1;
						last_end=-1;
					}
					else//���� ��� ������ ��� �����
					{
						if(last_end==first_beg)first_beg=-1;
						if(last_end==-1)first_beg=-1;
					}
				}
				tums_pred=tums_tek; //���������� ������

				if((TRASSA[ii].object&0x8000)==0x8000)//���� ������ ����� ���� �������
				{
					if(first_beg)//���� ��������������� ������� �� ������� �������
					{
						if(first_beg==-1)first_beg=ii;
					}

					else //���� ��������������� ������� �� �������� �������
					{
						if(kmnd=='b') //��������
						{
							if((TRASSA[ii].object&0x2000)==0x2000) //���� ��������
							{
								if(first_beg==-1)first_beg=ii; //���� �� ���� ������ - �����
							}
							else//���� ��� ��������� ���������
								if(first_beg==-1)first_beg=0x8000|ii;//������������
						}
						else if(first_beg==-1)first_beg=ii;//��� ����������� ������ ������
					}
				}// ����� ������� ������� ��� ������

				if((TRASSA[ii].object&0x4000)==0x4000)//���� ������ ����� ���� ������
				{
					if(first_beg!=-1)last_end=ii; //���� ���� ������, �� ����� �����
				}

				if((TRASSA[ii].object&0xC000)==0)//���� ������ �������
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
				FR3[objk].byt[20]=FR3[objk].byt[20]|(objk_next/256);
				FR3[objk].byt[21]=objk_next%256;
			}
		}
out:		
    ZeroMemory(&TRASSA,sizeof(TRASSA));
    return;
  }
}
//------------------------------------------------------
int __fastcall TStancia::tst_str_ohr(void)
{
  int a=0;
  return(a);
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
	int ii,jj,i,j,l_reg,n_ou,i_s,s_m,i_cik,i_m,ss;
	int mar1=0,mar2=0,povtor_novizna;
	char MIF[12];
	char contr_sum;
	TDateTime Vrema;
	char BUF_POKAZ[15],POKAZ[12];
	unsigned char bukva;
	AnsiString NAM1;
	char sled_kom[14];


		T_TIME = time(NULL);
		Vrema = Time();
		strcpy(Time1,TimeToStr(Vrema).c_str());
   	n_ou=0;
		if (STOP_ALL == 15)return; //----- ��� ���������� ������ ���� ������ �� ���������� ...

		if(zagruzka==0) // ------------------------------------- ���� ��� ����������� ��������
		{
///*
			NAM1=Stancia->Put;
			if(ARM_DSP!=0)NAM1 = NAM1 +"dsp.exe";
			else
				if(ARM_SHN!=0)NAM1 = NAM1 + "armshn.exe";
				else return;

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
	 //		*/
			zagruzka=0xf;
			Otladka1->Otlad = 63;
			Otladka1->Restor = 63;
			Tums1->Visible = false;		  // �������� ����� ��������� ����
			Flagi->Visible =false; 		  Limit->Visible = false; //--------------- �������� �����
			Tums1->Hide(); 	Flagi->Hide();  Limit->Hide();
			TimerMain->Enabled=true;
			TimerKOK->Enabled = true;
			TimerTry->Enabled = true;
			TimerDC->Enabled = true;
			ShowWindow(Application->Handle, SW_HIDE);
			return;
		}

//--------------------------------------------------------- ����������� ����� ��� ��������
		TextHintTek="";

		if((SVAZ&0x1)!=0)TextHintTek="��� ����� � ���-1.\n";
		else TextHintTek="����� � ���-1.\n";

	#if (Nst == 2)
		if((SVAZ&0x2)!=0)TextHintTek=TextHintTek + "��� ����� � ���-2.\n";
		else	TextHintTek=TextHintTek + "����� � ���-2.\n";
	#endif

		if(ARM_DSP!=0)
		{
			if((SVAZ&0x10)!=0)TextHintTek=TextHintTek + "��� ����� � ���-�������";
			else TextHintTek=TextHintTek + "����� � ���-�������";
		}

		if(Otladka1->Restor==15)
		{
			ShowWindow(Application->Handle ,SW_SHOW);
			WindowState = wsNormal;
			Visible = true;
			SetFocus();
//		TrayIcon11->Refresh();
			BringToFront();
			Otladka1->Restor=40;
		}
		if(Otladka1->Otlad==5)
		{
			for(i=0;i<15;i++)BUF_POKAZ[i]=BUF_OUT_ARM[i]|0x40;
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
		if((Norma_TS[0]==false)&&((T_TIME-TIME_DTR)>10))
		{
			CommPortOpt1->DTR = false;
			Sleep(1000);
			Beep();
			CommPortOpt1->DTR = true;
			TIME_DTR = time(NULL);
		}
		if((Norma_TS[0]==false)&&((T_TIME-TIME_COM)>4))
		{
			CommPortOpt1->Open = false;
			CommPortOpt1->Open = true;
			TIME_COM = time(NULL);
		}
		SOSED++;
		if(SOSED>=10)
		{
			SOSED=10;
			SVAZ=SVAZ|0x10;
		}
		else SVAZ=SVAZ&0xEF;

		if(povtor_novizna >= KOL_VO)povtor_novizna = 0;
		New_For_ARM(povtor_novizna++);

		if((RASFASOVKA==0)&&(cikl_marsh == 1))	Analiz_Glob_Marsh();
	//======================================================================================================================
	//����������� ���������� ������

		if((Otladka1->Otlad==5)&&(FIXATOR_KOM[0][0]!=0))
		{
			Edit4->Text=FIXATOR_KOM[0];
		 //	add(i_s,9999,1);
		}


		for(i_s=0;i_s<Nst;i_s++)
		{	if(cikl_marsh == 2)
			{	if((KOMANDA_TUMS[i_s][10]!=0))
				{	s_m=KOMANDA_TUMS[i_s][14];
					if((T_TIME-MARSHRUT_ST[i_s][s_m]->T_VYD)>2L)
					{ if(MARSHRUT_ST[i_s][s_m]->T_VYD ==0)
						MARSHRUT_ST[i_s][s_m]->T_MAX = MARSHRUT_ST[i_s][s_m]->T_MAX+T_TIME;
						MARSHRUT_ST[i_s][s_m]->T_VYD=T_TIME;
						//���������� ��������� ������
						MARSHRUT_ST[i_s][s_m]->SOST=(MARSHRUT_ST[i_s][s_m]->SOST&0xC0)|0xF;
						KOMANDA_TUMS[i_s][11]=')';
						TUMS_RABOT[i_s]=0xF;
						return;
						mar1 = 15;
					}
				}
				else
				{ //������ � ����������� ��������� � ������
					if(KOMANDA_ST[i_s][10]!=0)
					{
						if(OK_KNOPKA!=0)ZeroMemory(KOMANDA_ST[i_s],12); //���� ������ ������ ��, �� �������� � ��������� �������
						else
						{	SHET_KOM[i_s]++; //��������� ������� �������� ������
							if(SHET_KOM[i_s]>4) ZeroMemory(KOMANDA_ST[i_s],12);//���� ���������� 3 ����
						}
					}
				} 
			}
		}
		if(mar1!=0)add(0,9999,0);
		if(mar2!=0)add(1,9999,0);
		if((Otladka1->Otlad==5)&&(Flagi->Visible))
		{ //1
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
			Flagi->SG1->Cells[1][1] = MARSHRUT_ST[0][0]->NEXT_KOM;
			Flagi->SG1->Cells[1][2] = MARSHRUT_ST[0][1]->NEXT_KOM;
			Flagi->SG1->Cells[1][3] = MARSHRUT_ST[0][2]->NEXT_KOM;

			Flagi->SG1->Cells[2][1] = IntToStr(MARSHRUT_ST[0][0]->SOST);
			Flagi->SG1->Cells[2][2] = IntToStr(MARSHRUT_ST[0][1]->SOST);
			Flagi->SG1->Cells[2][3] = IntToStr(MARSHRUT_ST[0][2]->SOST);
			switch (MYTHX[0]&0xF)
			{	case 0x9: strcpy(MIF,"���1"); break;
				case 0xa: strcpy(MIF,"���2"); break;
				case 0xc: strcpy(MIF,"���3"); break;
				default:  strcpy(MIF,"�����"); break;
			}
			switch (MYTHX[0]&0xF0)
			{	case 0x70: strcat(MIF,"_���"); break;
				case 0x60: strcat(MIF,"_����"); break;
				case 0x50: strcat(MIF,"_����"); break;
				default:  strcat(MIF,"_�����"); break;
			}
			Flagi->SG1->Cells[1][4] = MIF;
			Flagi->SG1->Cells[2][4]=IntToStr(REG[0][0][9]);
			Stancia->SetFocus();
		}
		i_s = 0; s_m = 0;
		if(CommPortOpt1->REG_COM_TUMS[0]!=0)//���� ���� ������������ ������� ��� ����-1
		{	if(Otladka1->Otlad==5)	Stancia->SetFocus();
			Port_Schet_Takt[0]=Port_Schet_Takt[0]+1;
/*			if((Port_Schet_Takt[0]>10)&&(n_ou==0))
			{	for(ii=0;ii<12;ii++)
				{	KOMANDA_ST[0][ii]=CommPortOpt1->REG_COM_TUMS[ii];
					FIXATOR_KOM[0][ii]=KOMANDA_ST[0][ii];
				}
				FIXATOR_KOM[0][12]=0;
				if((Otladka1->Otlad==5)&&(FIXATOR_KOM[0][0]!=0))
				{	if(FIXATOR_KOM[0][0]!='F') ss=0;
					Edit4->Text=FIXATOR_KOM[0];
					Edit4->Update();
				}
				add(0,9999,7);
				n_ou++;
				for(ii=0;ii<12;ii++)KOMANDA_ST[0][ii]=0;
			}
*/
			if(Port_Schet_Com[0]>2)
			{	for(ii=0;ii<16;ii++)CommPortOpt1->REG_COM_TUMS[ii]=0;
				Port_Schet_Com[0]=0;
				Port_Schet_Takt[0]=0;
			}
			else
			{	Port_Schet_Com[0]=0;
				Port_Schet_Takt[0]=0;
			}
		}
		TimerMain->Interval = 300;
  	//-------------------- �������� ������� ������� ���������� �������� ����
	  /*
  	for(i=0;i<4;i++)
	  {
  		if(GetDigOut(i,&out_dig[i])) //--------------------------------------- ��������� �����
			{
				STOP_ALL=15;
				NomKnl = IntToStr(i);
  	    NomKnl =  "�� ���������� ����� D" + NomKnl;
				MessageBox(NULL,NomKnl.c_str(),"������", MB_OK);
			}
  	  else
    	{
      	if(out_dig[i] == 1) //------------------ ���� ����� �� ���������� � 0, �� ����������
	      {
					if(!SetDigOut(i,0))
					{
						STOP_ALL=15;
      			NomKnl = IntToStr(i);
      			NomKnl =  "��������� D" + NomKnl + "������ ��������!";
						MessageBox(NULL,NomKnl.c_str(),"������", MB_OK);
					}
    	  }
				else
				{
					if(!GetDigInp(i,&inp_dig[i]))
					{
						STOP_ALL=15;
						NomKnl = IntToStr(i);
						NomKnl =  "�� �������� ���� D" + NomKnl;
						MessageBox(NULL,NomKnl.c_str(),"������", MB_OK);
					}
				}
			}
		}
		for(i=0;i<4;i++)itoa(out_dig[i],&StrTmp[i],10);
		StrTmp[4] = 0;
		strcpy(StrOutInp,"OUT=");
		strcat(StrOutInp,StrTmp);
		for(i=0;i<4;i++)itoa(inp_dig[i],&StrTmp[i],10);
		StrTmp[4] = 0;
		strcat(StrOutInp,"INP=");
		strcat(StrOutInp,StrTmp);
		if(strcmp(StrOutInp,StrOutInpOld)!=0)LCMDspl(StrOutInp,strlen(StrOutInp));
		strcpy(StrOutInpOld,StrOutInp);
		if((inp_dig[0]==1)&(inp_dig[1]==0))STATUS=1;
		else STATUS = 0;
	 */

	if(STOP_ALL == 15)
	{
		Close();
		return;
	}
	if(byla_trb >250)
	{
		Serv1->Sost = 8888;
	}
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
	return;
}
#ifdef KOL_AVTOD
//========================================================================================
//-------- ��������� ��������� ������ ������������,�������� �� ����     MAKE_AVTOD(int ob)
void __fastcall TStancia::MAKE_AVTOD(int ob)
{
	unsigned int nach_marsh,end_marsh,nstrel,ii;
	int jj;
		char POKAZ[13];
	unsigned long pol_strel;
	unsigned char komanda,str_obj_serv[2];
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
          pol_strel=pol_strel|(0x1<<(nstrel-1));
        }
      }
      break;
    }
  }
  if(ii>=KOL_AVTOD)return;
  RASFASOVKA=0xF;
  ii=ANALIZ_MARSH(192,nach_marsh,end_marsh,nstrel,pol_strel);
  if(ii<(Nst*3))TUMS_MARSH(ii);
  RASFASOVKA=0;
	for(ii=0;ii<200;ii++)
  {
	TRASSA[ii].object=0;
    TRASSA[ii].tip=0;
    TRASSA[ii].stoyka=0;
    TRASSA[ii].podgrup=0;
	}
  return;
}
#endif
//------------------------------------------------------------------------
void __fastcall TStancia::Edit5DblClick(TObject *Sender)
{
	int nom_arm,nom_serv,i;
	AnsiString Bit[8];
	char Nomer[4];
	Edit5->GetTextBuf(Nomer,4);
	nom_arm = atoi(Nomer);
	if((nom_arm<0)||(nom_arm>=(int)KOL_VO))return;
	nom_serv=INP_OB[nom_arm].byt[0]*256+INP_OB[nom_arm].byt[1];
	if((nom_serv<0)||(nom_serv>=(int)KOL_VO))return;
	Edit6->Font->Color = clBlack;
	Edit6->Text=PAKO[nom_serv];
	for(i=0;i<8;i++)Bit[i]=IntToStr(FR3[nom_serv].byt[2*i+1]);
	Edit7->Text=Bit[7]+Bit[6]+Bit[5]+Bit[4]+Bit[3]+Bit[2]+Bit[1]+Bit[0];
}
//-----------------------------------------------------
/****************************************************\
* ��������� ������� ������� � ������ ������� � ����  *
* �� ������ ������ ANALIZ_ST_IN_PUT()                *
\****************************************************/
int __fastcall TStancia::ANALIZ_ST_IN_PUT(int nom_tras,int kom,int st,int marsh,int ind)
{
  int ii,Error;
  long DT;
  unsigned int str_in_put;
	int sp_in_put,spar_str,spar_sp,pol_str,tms_str;
  ii=nom_tras;
  Error=0;
  if((TRASSA[ii].tip==7)&&(kom==98))
  {
  	READ_BD(TRASSA[ii].object);
    if((BD_OSN[1]!=15)||(kom!=98))return 0;
    str_in_put=BD_OSN[2];
    sp_in_put=BD_OSN[3];
		spar_str=BD_OSN[4];
    spar_sp=BD_OSN[5];
    pol_str=BD_OSN[6];
    READ_BD(str_in_put);
    tms_str=((BD_OSN[13]&0x0f00)>>8)-1;
    if(pol_str==0)//���� ������� ������ ���� � �����
    { //���� ������� �� � �����
    	if((FR3[str_in_put].byt[1]!=1)||(FR3[str_in_put].byt[3]!=0))
      {
        MARSHRUT_ALL[marsh].KOL_STR[tms_str]++;
        MARSHRUT_ALL[marsh].STREL[tms_str][ind++]=str_in_put;
        MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST&0xc0;
        MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST|0x3;
      	if((FR3[sp_in_put].byt[1]==0)&& //���� ���� ��-�����
        (FR3[sp_in_put].byt[3]==0)&&
        (FR3[sp_in_put].byt[5]==0)&&
        (FR3[sp_in_put].byt[11]==0))
        {
        	if(spar_str!=0) //���� ���� ������ �������
          {
          	if((FR3[sp_in_put].byt[1]==0)&& //���� �� ���� �����
            (FR3[spar_sp].byt[3]==0)&&
            (FR3[spar_sp].byt[5]==0)&&
            (FR3[spar_sp].byt[11]==0))
            {
              if(POOO[str_in_put]==0l)
              {
             	  perevod_strlk(107,str_in_put);
                POOO[str_in_put]=time(NULL);
              }
              else
              {
                DT=time(NULL)-POOO[str_in_put];
                if(DT>40l)
                {
									DeleteMarsh(marsh);
									add(1,8888,16);
									POOO[str_in_put]=0l;
                  Error=1015;
                }
              }
            }
            else  Error=1015;//���� �� ���� � �������
          }//���� ��� ������ �������
          else
          {
						if(POOO[str_in_put]==0l)
            {
          	  perevod_strlk(107,str_in_put);
              POOO[str_in_put]=time(NULL);
            }
            else
            {
              DT=time(NULL)-POOO[str_in_put];
              if(DT>40l)
              {
                DeleteMarsh(marsh);
								add(1,8888,17);
								POOO[str_in_put]=0l;
                Error=1015;
              }
            }
          }
        }
        else  Error=1015;//���� ���� �� � �������
      }
    }//����� ��������� ��������� �������
    if(pol_str==1)//���� ������� ������ ���� � ������
    {
      if((FR3[str_in_put].byt[3]!=1)||(FR3[str_in_put].byt[1]!=0))//���� ������� �� � ������
			{
        MARSHRUT_ALL[marsh].KOL_STR[tms_str]++;
        MARSHRUT_ALL[marsh].STREL[tms_str][ind++]=str_in_put;
        MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST&0xc0;
        MARSHRUT_ALL[marsh].SOST=MARSHRUT_ALL[marsh].SOST|0x3;
        if((FR3[sp_in_put].byt[1]==0)&& //���� ���� ��-�����
        (FR3[sp_in_put].byt[3]==0)&&
        (FR3[sp_in_put].byt[5]==0)&&
        (FR3[sp_in_put].byt[11]==0))
        {
          if(spar_str!=0) //���� ���� ������ �������
          {
            if((FR3[sp_in_put].byt[1]==0)&& //���� �� ���� �����
            (FR3[spar_sp].byt[3]==0)&&
            (FR3[spar_sp].byt[5]==0)&&
            (FR3[spar_sp].byt[11]==0))
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
            else    Error=1015;// ���� ��� ����� �� ����
					}
          else  //���� ��� ������ �������
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
        else Error=1015;//���� ���� �� � �������
      }
    }//����� ���������� ���������
  }//����� ������� �������
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
		if(MARSH_VYDAN[ii] != 0)return; //���� ������ ���������� �������, �� ���� ��� ������� - ��������;
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
//================================================
void _fastcall TStancia::DeleteMarsh(int i_m)
{
	int i_s,s_m,ii,strelka;

	for(i_s=0;i_s<Nst;i_s++)//������ �� ���� �������
	{
		MARSHRUT_ALL[i_m].KOL_STR[i_s]=0; //������� �������� ������� ��� ���� �����
		MARSHRUT_ALL[i_m].STOYKA[i_s]=0; //������� �������� ��������� ����� � �������
		for(s_m=0;s_m<10;s_m++) //������ �� �������� �������, �������� � ��(��)
		{
			strelka=MARSHRUT_ALL[i_m].STREL[i_s][s_m]&0xfff;//�������� ����� �������
			if(strelka!=0) //���� ������ ����� �������
			{
				POOO[strelka]=0l; //�������� ������� ������� ��� �������
				MARSHRUT_ALL[i_m].STREL[i_s][s_m]=0;//������� ������� �� �������
			}
			MARSHRUT_ALL[i_m].SIG[i_s][s_m]=0;//������� ������ �� �������
			MARSHRUT_ALL[i_m].SP_UP[i_s][s_m]=0; //������� �� ��� �� �� �������
		}
	}
	MARSHRUT_ALL[i_m].KMND=0;    //�������� ������ �������
	MARSHRUT_ALL[i_m].NACH=0;    //�������� ������ ������
	MARSHRUT_ALL[i_m].END=0;	//�������� ������ �����
	MARSHRUT_ALL[i_m].NSTR=0;	//�������� ����� �������
	MARSHRUT_ALL[i_m].POL_STR=0;	//�������� ��������� �������
	MARSHRUT_ALL[i_m].SOST=0;    //�������� ������� ��������� ����������� ��������

	for(i_s=0;i_s<Nst;i_s++)	//������ �� �������
	for(s_m=0;s_m<MARS_STOY;s_m++) //������ �� ��������� � ������
	{
		if((MARSHRUT_ST[i_s][s_m]->NUM-100)==i_m) //���� ��������� ��� ����������
		{
			for(ii=0;ii<13;ii++)MARSHRUT_ST[i_s][s_m]->NEXT_KOM[ii]=0; //������� �������
			TUMS_RABOT[i_s]=0; //�������������� ������ (�������� ��� �� ����������)
			MARSHRUT_ST[i_s][s_m]->NUM=0; //������� ����� �����������
			MARSHRUT_ST[i_s][s_m]->SOST=0; //�������� ��������� ����������
			MARSHRUT_ST[i_s][s_m]->T_VYD=0l; //�������� ����� ������ ����������
			MARSHRUT_ST[i_s][s_m]->T_MAX=0l; //�������� ����� ������������� �������� ���������� �����������
			MARSH_VYDAN[i_s]=0; //������� ������� ������
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
//----------------------------------------------------------
void  __fastcall TStancia::Analiz_Glob_Marsh(void)
{   //------------------------------------------------------------------------------------------------$$1
	int i_m, i_s, s_m, ii,mars_st,ij,ik,ijk,ob_str,polojen;
	unsigned int KOM;
	time_t t_tek;
	double Delta;
	unsigned char kateg, Sost;
	mars_st = 0;
	// ������ �� ���� ���������� ������� ���������
	for(i_m=0; i_m<Nst*3; i_m++)
	{ //------------------------------------------------------------------------------------------------$$2
		if(MARSHRUT_ALL[i_m].SOST==0)continue;
		if((T_TIME - MARSHRUT_ALL[i_m].T_VYD) > 40 )DeleteMarsh(i_m);
		kateg=0xC0&MARSHRUT_ALL[i_m].SOST; //����� ��������� �������� ����������� ��������
		Sost=0x3f; //���������� ������������ �� �������� ����������
		for(i_s=0;i_s<Nst;i_s++) //������ �� ���� �������
		{ //----------------------------------------------------------------------------------------------$$3  
			if(MARSHRUT_ALL[i_m].STOYKA[i_s]!=0)//���� ������ ��������� � ���� ��������
			{ 	
				for(s_m=0;s_m<MARS_STOY;s_m++) //������ �� ���� ��������� ��������� ������
				{ 
					if(MARSHRUT_ST[i_s][s_m]->NUM==0)continue;  //���� ��� ����� ���������� - ������� � ����������
					if((MARSHRUT_ST[i_s][s_m]->NUM-100)==i_m)//���� ������ ��������� ��� ����� �����������
					{
						mars_st++;
						if(MARSHRUT_ST[i_s][s_m]->T_VYD == 0) //���� �� �����, ������� � ����������
						MARSHRUT_ST[i_s][s_m]->SOST = (MARSHRUT_ST[i_s][s_m]->SOST & 0xC) | 0x7;
						if((MARSHRUT_ST[i_s][s_m]->SOST & 0x1f) != 0x1f)  //���� ������� �� ���������
						{
							if((T_TIME-MARSHRUT_ST[i_s][s_m]->T_VYD)>2)  //���� ������ ����� 2 ��� �� ������
							{
								if(MARSHRUT_ST[i_s][s_m]->T_VYD!=0)	//���� ������������� ������
								{
									if(KOL_VYD_MARSH[i_s] == 0)	//���� ���� ���� ������
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
						else	//���� ������� ���������
						{	//������ �� ���� �������� ������������ ��������
							for(ik=0;ik<10;ik++)
							{	//�������� ��������� �������
								ob_str = MARSHRUT_ALL[i_m].STREL[i_s][ik] & 0xfff;
								polojen = MARSHRUT_ALL[i_m].STREL[i_s][ik] & 0x1000;
								if(ob_str == 0)continue;	//���� �� ���, ���� �����
								if(FR3[ob_str].byt[1] == FR3[ob_str].byt[3])break; //���� ������� ��� �������� - �������� ��������
								if(polojen == 0) //���� ����� � �����
								{
									if((FR3[ob_str].byt[1]!=1)||(FR3[ob_str].byt[3]!=0)) break; //������� �� � ����� - ������� �������
								}
								else //���� ����� � ������
								{
									if((FR3[ob_str].byt[1] != 0) || (FR3[ob_str].byt[3]!=1))break; //�� � ������ - ������� �������
								}
							}
							if(ik>=10)//���� ��� ������� ����������� (������� ��������)
							{
								//���������� ��� ���������� - ����� ����������
								MARSHRUT_ST[i_s][s_m]->SOST = MARSHRUT_ST[i_s][s_m]->SOST|0x3f;
							}
							else //���� ������� �� ������
							{
                //----------------------------------------------------- ������� ����������
								MARSHRUT_ST[i_s][s_m]->SOST = (MARSHRUT_ST[i_s][s_m]->SOST & 0xC0)|0x1f;

              	//--------------------------------------------------- ���� ��������� �����
								if((T_TIME - MARSHRUT_ST[i_s][s_m]->T_VYD) > MARSHRUT_ST[i_s][s_m]->T_MAX)
								{
									add(i_m,8888,41);
									DeleteMarsh(i_m);
									return;
								}
							}
						}
            //---------------------------------- ������������ ����� ��������� � ����������
						Sost=(Sost&MARSHRUT_ST[i_s][s_m]->SOST);
						break;
					}
				}
			}

      //---------------------------------------- ���� � ������� ������ ���� �� ���� ������
			if(mars_st!=0)
			{
      	//-------------------------------------------- ��������� ����� ������ � ����.����.
				MARSHRUT_ALL[i_m].SOST = kateg|Sost;
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
  int i,j,n_bait;
  char Pkz[11];
  BUF_OUT_SOSED[0]=0xAA;
  n_bait=1;
  for(i=0;i<10;i++)
  {
    if(NOVIZNA_FR4[i]!=0)
    {
      j=NOVIZNA_FR4[i]&0xfff;
      BUF_OUT_SOSED[n_bait++]=j&0x00ff;
			BUF_OUT_SOSED[n_bait++]=(j&0xff00)>>8;
      BUF_OUT_SOSED[n_bait++]=FR4[j];
      if(n_bait>=25)break;
    }
  }
  if(n_bait<=22)
  {
    if(POVTOR_FR4>=(int)KOL_VO)
    {
      POVTOR_FR4=0;
      for(i=0;i<10;i++)Limit->StrGrFr4->Cells[0][i]="";
    }
    for(i=POVTOR_FR4;i<(int)KOL_VO;i++)
    {
      //---------------------------------------------------------- ����� ��������� �������
      BUF_OUT_SOSED[n_bait++]=i&0x00ff; //---------------------------------------- �������
      BUF_OUT_SOSED[n_bait++]=(i&0xff00)>>8; //----------------------------------- �������
      BUF_OUT_SOSED[n_bait++]=FR4[i];
			if(Otladka1->Otlad==5)
      {
				if(FR4[i]!=0)
        Limit->StrGrFr4->Cells[0][i%10]=PAKO[i];
        Stancia->SetFocus();
      }
      if(n_bait>=25)break;
    }
    POVTOR_FR4=i;
  }
  BUF_OUT_SOSED[25]=0;
  BUF_OUT_SOSED[26]=CalculateCRC8(&BUF_OUT_SOSED[1],24);
  BUF_OUT_SOSED[27]=0x55;
	if(Otladka1->Otlad==5)
  {
    for(i=0;i<10;i++)Pkz[i]=BUF_OUT_SOSED[i]|0x40;
    Pkz[10]=0;
		Lb5->Caption=Pkz;
  }
	i = ArmPort1->PutBlock(BUF_OUT_SOSED,28);
  for(j=0;j<28;j++)BUF_OUT_SOSED[j] = 0;
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
	SetFocus();
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
			if((SVAZ==0x10)&&(ARM_DSP!=0))//-------------------- ���� ��� ����� � �������� �����
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
		if(TIME_OLD!=0)
		{
			time_t tt=time(NULL);
			if(tt-TIME_OLD>15)
			{
				TIME_OLD=0;
				for(i=0;i<5;i++)BAITY_OLD[i]=0;
				PODGR_OLD=0;
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
		Application->Terminate();
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
	close(file_arc);
  Application->Terminate();
}
//========================================================================================
//----------------------------------------------------------------------------------------
void __fastcall TStancia::TimerDCTimer(TObject *Sender)
{
	int i;
	//DC_PORT->WriteBuffer(BUF_OUT_DC,70);
	//for(i=0;i<70;i++)BUF_OUT_DC[i]=0;

	if(BUF_IN_SOSED[0] == 0xAA)
	SosedIn();
	if(zagruzka!=0)
	{
		if(OLD_STATUS == STATUS)
    {
			if(STATUS==1)SosedOutOsn();
    }
    else
    {
			CommPortOpt1->Open = false;
			ArmPort1->Open = false;
			CommPortOpt1->Open = true;
      ArmPort1->Open = true;
    }
		OLD_STATUS = STATUS;
  }
}
//===============================================================================================
void __fastcall TStancia::FormActivate(TObject *Sender)
{
	TrayIcon11->Visible = true;
	TIME_DTR = time(NULL);
  TIME_COM = time(NULL);
	Timer_Arm_Arm = 0;
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
//������ ��������� � �������� 1 ������� ��� ������������ ������ ������������� � ������ ��
void __fastcall TStancia::TimerKOKTimer(TObject *Sender)
{
	int i,DELTA;
	DELTA = 0;  //-------------------------- ������� ������� ��������� � ���������� ��������
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
		if (DELTA!=0)
		{
			for(i=0;i<4;i++)
			{
				if(out_dig[i] == 1)SetDigOut(i,0); //-- ���� ����� �� ���������� � 0, �� ����������
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
	}
	catch(...)
	{
		; //--------------------------------------------------------------????????????????????
	}
	return;
}
//========================================================================================
//------------------------------ ��������� ������,�������� �� ������� ������ ������ ������//========================================================================================
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
//  ����� ������ �� ��������� ����
void __fastcall TStancia::SosedIn(void)
{
	int i,j;
	unsigned char CRC_S,ByteFr4;
	char Pkz[28];
	CRC_S=CalculateCRC8(&BUF_IN_SOSED[1],24);
	if(CRC_S!=BUF_IN_SOSED[26])
	{
		//--------------------------------------------------- ���� ��� ����� ����������� �����
		for(i=0;i<26;i++)BUF_IN_SOSED[i]=0;
    return;
	}
	else
	{
	//----------------------------------------------------------------- ������ � ������� FR4
		for(i=0;i<8;i++)
		{
			j=BUF_IN_SOSED[3*i+1];        //-------------------------------------------- �������
			j=j|(BUF_IN_SOSED[3*i+2]<<8); //-------------------------------------------- �������
			if(j>=KOL_VO)continue;
			ByteFr4=BUF_IN_SOSED[3*i+3];
			if(Otladka1->Otlad==5)
			{
				if(ByteFr4!=0)Limit->StrGrFr4->Cells[0][j%10]=PAKO[j];
			}
			if(FR4[j]!=ByteFr4)
			{
				NOVIZNA_FR4[new_fr4++]=j;	FR4[j]=ByteFr4;	if(new_fr4>=10)new_fr4=0;
			}
		}
		if(Otladka1->Otlad==5)
		{
			for(i=0;i<28;i++)
			{
				Pkz[i]=BUF_IN_SOSED[i]|0x40;	BUF_IN_SOSED[i]=0;
			}
			Pkz[10]=0;
			Lb4->Caption=Pkz;
		}
	}
}
//========================================================================================
void __fastcall TStancia::Serv1ReadPacket(TObject *Sender, BYTE *Packet, int &Size)
{
	try
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
		BUF_IN_ARM[i]=Packet[i];
	}
	Serv1->cikl_truba  = !Serv1->cikl_truba;
	if(Otladka1->Otlad==5)Edit1->Text=POKAZ;
	byla_trb = 0;
	ANALIZ_ARM();
	}
	catch(...)
	{
		;//--------------------????????????????
	}
	return;
}
//========================================================================================
void __fastcall TStancia::FormCreate(TObject *Sender)
{
	Serv1->Open();
	CommPortOpt1->Open = true;
	ArmPort1->Open = true;
	add(0,100,0);
}
//---------------------------------------------------------------------------


void __fastcall TStancia::Edit7Enter(TObject *Sender)
{
	int nom_serv,nom_arm,ij;
	char fr3_new[8],fr3_inv[8];
	nom_arm = atoi(Edit5->Text.c_str() );
	if((nom_arm<0)||(nom_arm>=(int)KOL_VO))return;
	nom_serv=INP_OB[nom_arm].byt[0]*256+INP_OB[nom_arm].byt[1];
	if((nom_serv<0)||(nom_serv>=(int)KOL_VO))return;
	StrCopy(fr3_new,Edit7->Text.c_str());

	for(ij=0;ij<8;ij++)
	{
		fr3_inv[ij] = fr3_new[7-ij];
		FR3[nom_serv].byt[2*ij+1] = fr3_inv[ij]-48;
	}
}
//---------------------------------------------------------------------------
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

	Nom_Packet = (Priem[5]<<8) | Priem[6];
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
		Tek_Packet[Stoika] = Nom_Packet;
	}
	else
	{
		Prinal[Stoika]++;
		if(Prinal[Stoika] > 3)
		{
			Poteral[Stoika] = 0;
			Prinal[Stoika] = 3;
			Norma_TS[Stoika] = true;
			if((Priem[5]&0x80) == 0x80)	Norma_TU[Stoika] = true;
			else	Norma_TU[Stoika] = false;
			if(Priznak)
			{
				for(i=0;i<18;i++)Soob_TUMS[Stoika][Last_Soob_TUMS[Stoika]][i] = Priem[i];
				Buf_Zaniat[Stoika][Last_Soob_TUMS[Stoika]]=true;
				Last_Soob_TUMS[Stoika]++;
				if(Last_Soob_TUMS[Stoika]>9)Last_Soob_TUMS[Stoika]=0;
			}
		}
		Tek_Packet[Stoika] = Nom_Packet;
	}
}
//---------------------------------------------------------------------------

void __fastcall TStancia::Timer250Timer(TObject *Sender)
{
	int i,j,jj,ij,kk,ijk,JJ[11];
	Word Hrs,Min,Sec,Ms;
	AnsiString KK;
	char BB[3];
	unsigned char Zagol,novizna,MYTHX,GRUPPA,STROKA,PODGR;
	char Soob[] = "         ";
	cikl_marsh++;
	if(cikl_marsh>3)cikl_marsh=0;
	if(cikl_marsh == 2)	MARSH_GLOB_LOCAL();
	if(cikl_marsh == 3)	Analiz_Glob_Marsh();
	byla_trb=byla_trb++;
	ARM_OUT();
	Serv1->cbToWrite = 70;
 	Serv1->Tell(BUF_OUT_ARM,70);
	Time_tek = Time();
	for(i=0;i<Nst;i++)
	{
		Delta = Time_tek - Time_Last_Ot_TUMS[i];
		DecodeTime(Delta,Hrs,Min,Sec,Ms);
		if(Sec>2)
		{
			Norma_TS[i] = false;
			Norma_TU[i] = false;
		}
			if(Norma_TU[i]== false)SVAZ = SVAZ | (0x4<<i);
			else SVAZ = SVAZ & (!(0x4<<i));
	}

	Zagol = 0;
	if (STATUS == 1)
	{
		if(NUM_ARM == 1) Zagol = Zagol | 0x04;
		if(NUM_ARM == 2) Zagol = Zagol | 0x08;
	}
	for(i=0;i<Nst;i++)
	{
		while(Last_Soob_TUMS[i] != First_Soob_TUMS[i])
		{

			for(ij=0;ij<9;ij++)
			{
				Soob[ij]= Soob_TUMS[i][First_Soob_TUMS[i]][ij+7];
				REG[0][0][ij] = Soob[ij];
			}
			if((Soob[7] & Zagol)!=Zagol)SVAZ = SVAZ | 0x20;
			else SVAZ = SVAZ & 0xDF;

			if(Soob[2]>=48)kk = Soob[2]-48;
			if((Soob[1]=='R')&&((Soob[2]=='y')||(Soob[2] =='Y'))) // ����������� ���
			{
				kk=45;
				if(diagnoze(i,0)==-1){ for(jj=0;jj<3;jj++)DIAGNOZ[jj]=0;	return;	}
			}
			for(ij=0;ij<18;ij++)Stroki_TUMS[i][kk][ij]=Soob_TUMS[i][First_Soob_TUMS[i]][ij];
			for(ij=0;ij<8;ij++)Kvit_For_TUMS[i][ij] = Stroki_TUMS[i][kk][ij];
			Kvit_For_TUMS[i][7] = Kvit_For_TUMS[i][7]&0xF3;
			Kvit_For_TUMS[i][7] = Kvit_For_TUMS[i][7]|Zagol;
			Kvit_For_TUMS[i][8] = Stroki_TUMS[i][kk][16];
			Kvit_For_TUMS[i][9] = CalculateCRC8(&Kvit_For_TUMS[i][7],2);
			if (KNOPKA_OK0 == 0)Kvit_For_TUMS[i][10]=')';
			else
			{
				Kvit_For_TUMS[i][0]='{';
				Kvit_For_TUMS[i][10]='}';
			}
			while(1)
			{
				if(CommPortOpt1->GotovWrite)break;
				else 	continue;
			}
			novizna=0;
			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				//---------------------------------------------------------------- ������� �������
				if(VVOD[i][kk][j]!=Stroki_TUMS[i][kk][j+10])
						novizna=novizna|(1<<j);
				VVOD[i][kk][j] = Stroki_TUMS[i][kk][j+10];//------- �������� ������ � ������ �����
			}
			if(novizna!= 0)	add(i,kk,0);
			MYTHX = Stroki_TUMS[i][kk][15]; //-------------------------- �������� �������� MYTHX
			ANALIZ_MYTHX(MYTHX,i);
			GRUPPA = Stroki_TUMS[i][kk][8];

			STROKA = TAKE_STROKA(GRUPPA,kk,i);
			ZAPOLNI_FR3(GRUPPA,STROKA,kk,i,novizna);

			if((cikl_marsh==2)&&(KOMANDA_TUMS[0][0]!=0)) //-------- ���������� �������
			{
				for(ij=0;ij<8;ij++)Komanda_For_TUMS[i][ij] = Kvit_For_TUMS[i][ij];
				for(ijk=2;ijk<10;ijk++)
				{
					Komanda_For_TUMS[i][ijk+6]=KOMANDA_TUMS[0][ijk];
					FIXATOR_KOM[i][ijk-2]=KOMANDA_TUMS[i][ijk];
				}
				Komanda_For_TUMS[i][7] = Kvit_For_TUMS[i][7]&0xF3;
				Komanda_For_TUMS[i][7] = Kvit_For_TUMS[i][7]|Zagol;
				Komanda_For_TUMS[i][16] = CalculateCRC8(&Komanda_For_TUMS[i][7],9);
				Komanda_For_TUMS[i][0] = 0X28;
				Komanda_For_TUMS[i][17] = 0x29;
				CommPortOpt1->PutBlock(Komanda_For_TUMS[i],18);
				Beep();
				for(ij=0;ij<8;ij++)KOMANDA_TUMS[0][ij]=0;
			}
			else
			{
				if(KOMANDA_ST[0][0]!=0)//--------------------------- ����������� �������
				{
					for(ij=0;ij<8;ij++)Komanda_For_TUMS[i][ij] = Kvit_For_TUMS[i][ij];

					for(ijk=2;ijk<10;ijk++)
					{
						Komanda_For_TUMS[i][ijk+6]=KOMANDA_ST[0][ijk];
						FIXATOR_KOM[i][ijk-2]=KOMANDA_ST[i][ijk];
					}
					FIXATOR_KOM[i][ijk-2]=0;
					Komanda_For_TUMS[i][7] = Kvit_For_TUMS[i][7]&0xF3;
					Komanda_For_TUMS[i][7] = Kvit_For_TUMS[i][7]|Zagol;
					Komanda_For_TUMS[i][16] = CalculateCRC8(&Komanda_For_TUMS[i][7],9);
					Komanda_For_TUMS[i][0] = 0X28;
					Komanda_For_TUMS[i][17] = 0x29;
					CommPortOpt1->PutBlock(Komanda_For_TUMS[i],18);
					add(i,9999,0);
					Beep();
					for(ij=0;ij<8;ij++)KOMANDA_ST[0][ij]=0;
				}

			}
			while(1)
			{
				if(CommPortOpt1->GotovWrite)break;
				else 	continue;
			}
			CommPortOpt1->PutBlock(Kvit_For_TUMS[i],11);
			Buf_Zaniat[i][First_Soob_TUMS[i]] = false;
			First_Soob_TUMS[i]++;
			if(First_Soob_TUMS[i]==10)First_Soob_TUMS[i]=0;
		}
		if(Kvit_Ot_TUMS[i][0]!=0)
		{
			for(ij=0;ij<11;ij++)
			{
				JJ[ij] = Kvit_Ot_TUMS[i][ij];
				itoa(JJ[ij],BB,16);
				KK = KK + " " + BB ;
				Kvit_Ot_TUMS[i][ij]=0;
			}
		}
	}
}


 /*
		if((GRUPPA=='R')&&((REG[st][kan][3]=='y')||(REG[st][kan][3]=='Y'))) // ����������� ���
		{
			soob=45;
			if(diagnoze(st,kan)==-1){ for(jj=0;jj<3;jj++)DIAGNOZ[jj]=0;	return;	}
		}
		else
		if(REG[st][kan][3]>=112) //------------------ ��������� � �������, ��������� ���������
		{
			if(GRUPPA=='J')
			{
				if(test_plat(st,kan)==-1){for(jj=0;jj<6;jj++)ERR_PLAT[jj]=0;return;}
				soob=44;
			}
			else return;

			nov_bit=0;
			novizna=0;
			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				//---------------------------------------------------------------- ������� �������
				if(VVOD[st][soob][j]!=REG[st][kan][j+4])novizna=novizna|(1<<j);
				VVOD[st][soob][j] = REG[st][kan][j+4];//----------- �������� ������ � ������ �����
			}
		}
		else
		//---------------------------------------------------- ���� ��������� � ��������������
		if((GRUPPA=='Z')||(GRUPPA=='z'))
		{
			if(soob>48)return;

			for(j=0;j<5;j++)//---------------------------------- ������ �� ���� ������ ���������
			{
				if(VVOD_NEPAR[st][soob][j]!=REG[st][kan][j+4])//--- ��������� ����� ��������������
				{
					novizna=novizna|(1<<j);
					grup_test = (unsigned char)KOL_STR[st];  //- ������� ���������� ������� � ������
					if(soob<grup_test)grup_test = 'C'; //----------- ���� ��������� �������� �������
					else
					{
						grup_test = grup_test + KOL_SIG[st]; //----------- ��������� � ������ ��������
						if(soob<grup_test)grup_test = 'E';
						else
						{
							grup_test = grup_test + KOL_DOP[st]; //----- ��������� � ������ ���.��������
							if(soob<grup_test)grup_test = 'Q';
							else
							{
								grup_test = grup_test + KOL_SP[st]; //---------------- ��������� � �� � ��
								if(soob<grup_test)grup_test = 'F';
								else
								{
									grup_test = grup_test + KOL_PUT[st];
									if(soob<grup_test)grup_test = 'I';
									else
									{
										grup_test = grup_test + KOL_KONT[st]; //------ ��������� � �����������
										if(soob<grup_test)grup_test = 'L';
									}
								}
							}
						}
					}
					STROKA=TAKE_STROKA(grup_test,soob,st);//--- �������� ����� ������ � ����� ������

					for(i=0;i<15;i++)num[i] = 0; //------------------------- �������� ������ �������

					switch(grup_test) //-- ����� ��������� ������� ������� �������� ������ ���������
					{
						case 'C':
							for(i=0;i<5;i++)num[i]=SPSTR[STROKA].byt[i*2]*256+SPSTR[STROKA].byt[i*2+1];
							break;
						case 'E':
							for(i=0;i<5;i++)num[i]=SPSIG[STROKA].byt[i*2]*256+SPSIG[STROKA].byt[i*2+1];
							break;
						case 'Q':
							for(i=0;i<5;i++)num[i]=SPDOP[STROKA].byt[i*2]*256+SPDOP[STROKA].byt[i*2+1];
							break;
						case 'F':
							for(i=0;i<5;i++)num[i]=SPSPU[STROKA].byt[i*2]*256+SPSPU[STROKA].byt[i*2+1];
							break;
						case 'I':
							for(i=0;i<5;i++)num[i]=SPPUT[STROKA].byt[i*2]*256+SPPUT[STROKA].byt[i*2+1];
							break;
						case 'L':
							for(i=0;i<5;i++)num[i]=SPKONT[STROKA].byt[i*2]*256+SPKONT[STROKA].byt[i*2+1];
							break;
						default: 	return;
					}

					for(i=0;i<=4;i++)	if((1<<i) & REG[st][kan][j+4])break; // ����� ���� ��� � �����


					if(i<5)//-------------------------------- ���� ���� �������� �� ������������ ���
					{
						if(grup_test != 'L') //---------------------------------- ���� ��� �� ��� ����
						{
							NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
							NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;//---- ������� ���� ����� + 4096
							NEPAR_OBJ[2] = REG[st][kan][j+4] & 0x1f;
						}
						else//----------------------------- ���� �������������� � �������� �����������
						{
							if(STROKA == (st+1)*5 - 1) //--- ���� ��������� ������ �������������� ������
							{
								NEPAR_OBJ[0] = OUT_OB[num[j]].byt[1];
								NEPAR_OBJ[1] = OUT_OB[num[j]].byt[0] | 0x10;
								NEPAR_OBJ[2] = REG[st][kan][j+4] & 0x1f;
							}
							else
							{
								NEPAR_OBJ[0] = STROKA*5+j+1;
								NEPAR_OBJ[1] = 0x14;
								NEPAR_OBJ[2] = st<<4;
								NEPAR_OBJ[2] = NEPAR_OBJ[2] | (REG[st][kan][j+4] & 0xf);
							}
						}
					}
				}
				VVOD_NEPAR[st][soob][j]=REG[st][kan][j+4]; //------ �������� ������ � ������ �����
			}
		}
		else //------------------------------------------------------- ��� ��������� ���������
		{
			novizna=0; nov_bit=0;
			for(j=0;j<5;j++) //--------------------------------- ������ �� ���� ������ ���������
			{
				if(VVOD[st][soob][j]!=REG[st][kan][j+4])novizna=novizna|(1<<j); // ������� �������
				VVOD[st][soob][j]=REG[st][kan][j+4]; //------------ �������� ������ � ������ �����
				VVOD_NEPAR[st][soob][j]=REG[st][kan][j+4]; //------ �������� ������ � ������ �����
			}
		}
		//		if(REG[st][kan][9]!=124)novizna=0x1f;
		if((GRUPPA=='z')||(GRUPPA=='Z'))VVOD_NEPAR[st][soob][6]=0; //----- ������������ ������
		else VVOD[st][soob][6]=0; //-------------------------------------- ������������ ������

 //		/*----------------------------------------------------------------------------------
		if(novizna)
		{
			if(Otladka1->Otlad==5)
			{
				if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Font->Color=clRed;
				Stancia->SetFocus();
			}
		}
// /----------------------------------------------------------------------------------

		if((soob!=45)&&(soob!=44)) //--------------- ���� ��������� ������� ��� ��������������
		{
			/*----------------------------------------------------------------------------------
			if(Otladka1->Otlad==5)
			{
				switch(GRUPPA)
				{
					case 'C':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clLime;
						break;
					case 'E':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clYellow;
						break;
					case 'Q':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clFuchsia;
						break;
					case 'F':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clSilver;
						break;
					case 'I':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clWhite;
						break;
					case 'L':
						if((st==0)&&(Tums1->Visible))Tums1->DrG1->Canvas->Brush->Color=clOlive;
						break;
					case 'Z':
					case 'z':
						if((st==0)&&(Tums1->Visible))
						{
							Tums1->DrG1->Canvas->Brush->Color=clWhite;
							VV=Tums1->DrG1->CellRect(2,soob);
							Tums1->DrG1->Canvas->FillRect(VV);
							Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
							Tums1->DrG1->Canvas->Font->Color=clBlack;
							Stancia->SetFocus();
						}
				}
				if((GRUPPA!='z')&&(GRUPPA!='Z'))
				{
					if((st==0)&&(Tums1->Visible))
					{
						VV=Tums1->DrG1->CellRect(0,soob);
						Tums1->DrG1->Canvas->FillRect(VV);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob+1));
						VV=Tums1->DrG1->CellRect(1,soob);
						Tums1->DrG1->Canvas->FillRect(VV);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
						Tums1->DrG1->Canvas->Font->Color=clBlack;
						VV = Tums1->DrG1->CellRect(2,soob);
						Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,"");
						Stancia->SetFocus();
					}
				}
			}

			STROKA=TAKE_STROKA(GRUPPA,soob,st); //------------------------ �������� ����� ������
			ZAPOLNI_FR3(GRUPPA,STROKA,soob,st,novizna); //---------------- ��������� FR3 �������
		}
		else
		{
			if((st==0)&&(Tums1->Visible))
			{
				Tums1->DrG1->Canvas->Font->Name = "Courier New";
				Tums1->DrG1->Canvas->Brush->Color=clRed;
				VV=Tums1->DrG1->CellRect(0,soob-1);
				Tums1->DrG1->Canvas->FillRect(VV);
				Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob));
				VV=Tums1->DrG1->CellRect(1,soob-1);
				Tums1->DrG1->Canvas->FillRect(VV);
				Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,REG[st][kan]);
				Tums1->DrG1->Canvas->Font->Color=clBlack;
				Stancia->SetFocus();
			}
		}
		if((novizna!=0)||(fixir!=0)||(Otladka1->Otlad==5))
		add(st,soob,0);
*/
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
	}
	for(soob=0;soob<28;soob++)
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
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,IntToStr(soob+1));
					VV=Tums1->DrG1->CellRect(1,soob);
					Tums1->DrG1->Canvas->FillRect(VV);
					strncpy(strka,&Stroki_TUMS[0][soob][7],9);
					strka[9]=0;
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,strka);
					Tums1->DrG1->Canvas->Font->Color=clBlack;
					VV = Tums1->DrG1->CellRect(2,soob);
					Tums1->DrG1->Canvas->TextRect(VV,VV.Left+2,VV.Top+1,"");
					Stancia->SetFocus();
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
		Tums1->Visible=false;
		Tums1->Hide();
	}
	else
	{
		Tums1->Visible=true;
		Tums1->Show();
	}
}
//---------------------------------------------------------------------------

void __fastcall TStancia::Button4Click(TObject *Sender)
{
#ifdef ARPEX
	return;
#else
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
	if(KNOPKA_OK0 == 1)
	{
		KNOPKA_OK0 = 0;
		Button5->Caption = "�� ������";
	}
	else
	{
		KNOPKA_OK0 = 1;
		Button5->Caption = "�� ������";
	}
}
//---------------------------------------------------------------------------

