#ifndef DAT_H
#define DAT_H
#include "opred.h"
	struct TRAS
	{
		unsigned int object;
		unsigned char tip;
		unsigned char stoyka;
		unsigned char podgrup;
		unsigned char kod_bit;
	}TRASSA[200],TRASSA1[200];

	extern struct MARS_ALL
	{
		char KMND;
		unsigned int NACH;
		int END;
		int NSTR;
		unsigned long POL_STR;
		int KOL_STR[Nst];
		unsigned int STREL[Nst][10];
		unsigned int SIG[Nst][10];
		unsigned int SP_UP[Nst][10];
		unsigned char SOST;
		int STOYKA[Nst];
		time_t T_VYD;
	}MARSHRUT_ALL[Nst*3];

	struct MARS_ST //------------------------- ��������� ���������� �������� ��� ������ ����
	{
		char NEXT_KOM[14]; //----------------- ���������� ������� ��� ���� � ��������� �������
		char NUM;  //---------------- ����� ����������� ��������, ����������� ������ ���������
		unsigned char SOST; //-------- ���������� ��� ������������ �������� ��������� ��������
		time_t T_VYD; //------------------------ ����� ������ ���������� ������� � ������ ����
		long T_MAX; //---------------- ����������� ��������� ����� �������� ���������� �������
	}*MARSHRUT_ST[Nst][3]; //---------- ��� ������ ������ ���� ������������ �� 3-� ���������

	struct Kvit
	{
    time_t Komanda_Time;
		int N_RAZ;
		unsigned char Nom_Paket[2];
		unsigned char KS;
		bool Komanda; //----------------------------------------- true = ������� ������ ������
		bool Kvit; //-------------------------------------- true = ������� ��������� ���������
    bool Arhiv; //--------------------- true = ������� ���������� ������ ��������� � �����
	}Kvitancia;

	time_t T_VYD_RAZ[Nst]; //-------------- ����� ������ ��������� ���������� ������� � ����
  TDateTime Vrema;
	unsigned char MARSH_VYDAT[Nst]; //-- ����-���������� �� ������ ���������� ������� � ����
  int DEL_TRASS_MARSH; //-------- ������� �������� ������ �� ��������� � ���������� ������
	int STOP_ALL;
	int ARM_SHN;
  int ARM_DSP;
  int SOSED_IN;//------------------------------------- ������� ������ ��� ������ �� ������
  int index;
	int PRT1; //------------------------------------------------------------- �������� �����
	int PRT2; //------------------------------------------------------------ ��������� �����
	int PRT3; //----------------------------------------------------------------- ����� ����
	int PRT4; //---------------------------------------------------------- ����� ������ ����
	int PRT5; //--------------------------------------------------- ���� � ��������� �������
	int PRT6; //--------------------------------------------------- ���� � ��������� �������
	int KOL_STR[Nst];  //-------------------------------------------- ����� �������� �������
	int KOL_SIG[Nst];  //------------------------------------------- ����� �������� ��������
	int KOL_DOP[Nst]; //-------------------------------------- ����� �������������� ��������
	int KOL_SP[Nst];   //------------------------------------------------- ����� �������� ��
	int KOL_PUT[Nst];  //---------------------------------------------- ����� �������� �����
	int KOL_KONT[Nst]; //---------------------------------------- ����� �������� �����������
	int RASFASOVKA;
	unsigned int POVTOR_FR4_SOSEDU;
	unsigned int	povtor_novizna;
	int out_dig[4], inp_dig[4], old_inp_dig[4];
	char StrOutInp[20],StrTmp[5],StrOutInpOld[20];
	AnsiString NomKnl;
	int cikl_marsh;
  int byla_trb; //---------------------------- ���������� �������� ����������� ������ Pipe
	int zagruzka;
	int POVTOR_OTKR;
  int flag_err;
  unsigned int NextObj;
	unsigned char PODGR_OLD,BAITY_OLD[5];// ���������+���� �������� ������ ���� ��� ��������

	time_t TIME_OLD,//-- ����� ��������� ������� ���� (���� �� 15 ��� ��� �������, �� �����)
	T_TIME, // ������� �����, ����������� �������� �������� ��������� TimerMainTimer (400��)
	FIXIR_TIME,// ����� ��������� �������� ������ (�������� ������ ����������� ����� 10 ���)
	TIME_DTR,//����� ���������� ������������ ����� DTR ��� ������ (�������� �������� 10 ���)
	TIME_COM,//-- ����� ���������� �������� ����� ����� �� ������� (�������� �������� 4 ���)
	TimerA, //---- ����� ���������� ������ ���������� ������ � ��� ������� ��������� �������
	TimerB; //---- ����� ���������� ������ ���������� ������ � ��� ������� ��������� �������

	unsigned char VVOD[Nst][70][7],KORZINA[Nst],SERVER;
	unsigned char VVOD_NEPAR[Nst][70][7];
	unsigned char BUF_OUT_ARM[70],OUT_TO_ARM[70];
	char BUF_OUT_DC[70];
	unsigned char BUF_IN_ARM[28];
	unsigned char BUF_OUT_SOSED[28];
	unsigned char BUF_IN_SOSED[28];
	unsigned char OSN1_KS[28],OSN2_KS[28];
	unsigned char KOM_BUFER[28],KONFIG_ARM;
	unsigned char REZ1_KS[28],REZ2_KS[28];
	unsigned long KOL_VO,KOL_ARM,KOL_SERV,KOL_OUT,LIN_PZU;
	unsigned int KOL_VYD_MARSH[Nst];
	unsigned short int BD_OSN[16];
  AnsiString NAME_FILE;
	unsigned char *PEREDACHA,*PRIEM,*FR4,*ZAFIX_FR4;
  AnsiString *PAKO;
  long *POOO;
	unsigned char KOMANDA_ST[Nst][15],SHET_KOM[Nst];
	unsigned char PROCESS, //---------------------------- ������� ���������� �� ��� / ������
	tiki_tum[Nst];
	unsigned char MYTHX[Nst];
	unsigned int NOVIZNA[KOL_NEW],NOVIZNA_FR4[10],nom_new;
	unsigned int TUMS_RABOT[Nst];
	unsigned int STATUS,statOSN,statREZ,  //------------- ��� ������� ���� - ��������� �����
	OLD_STATUS, //-------------------- ������� ������ ���� ��� �������� ������� ������������
	NUM_ARM,  //----------------------------------------------------------------- ����� ����
	SHN, //----------------------------------------------- ������� ������ � ��������� ���-��
	CIKL;  //-------------------------------------------- ������� ������� - ��������� ������
	AnsiString portA = "  ";
	AnsiString portB = "  ";//--------------------------------- ������� �������� � ����� ���
	unsigned char *OutPortA = "AAAAAAAA"; //------------------ ������� ��� �������� � ���� �
	unsigned char *OutPortB = "BBBBBBBB"; //------------------ ������� ��� �������� � ���� B
  unsigned int povtor_fr4; //----------- ������� ��������� �� ����������� ���������� � DSP
	int file_arc,new_fr4,povtor_out,RESET_TIME;
	char Time1[11]; //---------------- ���������� ������ ��� ������ ������� � �������� �����
	unsigned char SVAZ;//------------------------------ ������� ��������� ������� ����� ����
	unsigned char SVAZ_OLD;//-------------------------- ������� ��������� ������� ����� ����
	unsigned char ZAPROS_ARM, N_PAKET, KOMANDA_TUMS[Nst][15];
	int SM_TUMS[Nst]; //----------- �������� ������� ����� ��� ����������� ��������� �  ����
	unsigned char KNOPKA_OK,//------------------ ������� ������� ������ + ���������� �������
	KNOPKA_OK_N, //-------------------------------------- ������� ��������� 2-�� ������� ���
	KNOPKA_OK0; //---------------------- ������� ������� ������ ��� ��������� ������� ������
	unsigned char KOK_OT_TUMS; //----------------- ��������� ������ ���, ����������� �� ����
	unsigned char KVIT_ARMu[12],KVIT_ARMu1[12]; //--------- ��������� ���� ��� 1 � 2 �������

	char OK_KNOPKA, //----- ��������� ������ ������������� ������ � �������, �������� �� DSP
	ACTIV,  //--------------------------------------------------- ������� ���������� �������
	KOM_TIME[8]; //----------------------------- ������ ��� ������ ������� ��������� �������

	unsigned char KOMANDA_RAZD[12],KOMANDA_MARS[12],MYTHX_TEC[Nst];
//========================================================================================
	int First_Soob_TUMS[Nst],// ����� ��������� ������ ������ ����� ������ ���������� ������
	Last_Soob_TUMS[Nst]; //����� �������������� ������ ������ ����� ������ ���������� ������

	TDateTime Time_Last_Ot_TUMS[Nst], //------------- ����� ���������� ������ ������ �� ����
	Time_tek, //------------------------------- ������� �����, ����������� �������� Timer250
	Delta0;//----- �������� ����� �������� ������ �� ����, ���� ����� 2���, �� ����� �������
	bool Norma_TS[Nst], //-------------------- �������� ����� ������ ���������� �� ������ ��
	Norma_TU[Nst], //----------------------- �������� ����� �������� ���������� �� ������ ��
	Norma_Sosed, //------------------------ ������� ����� ��������� ������ �� ��������� ����
	Norma_Podkl, //------------------------------- ������� ����� ����������� ������� ���-���
  NAS,CHAS, //------------------------ �������� ��������� ��������� � ������� ������������
	Buf_Zaniat[Nst][10];//--- ������� ��������� ������� ������ ������ �� ��� ��� �����������
  bool ReBoot; //---------------------------- ������� ������������� ����������� ����������
	int Poteral[Nst],//-- ���� ���������� ������ �������, ���� ����� 2-�, �� ������ ����� ��
	Prinal[Nst]; //--------------- ���� �������� ������ �������, ���� ����� 3-�, �� ����� ��
	unsigned int Tek_Packet[Nst]; //-------------- ������� ����� ���������� ��������� ������

	unsigned char Komanda_For_TUMS[Nst][18],Kvit_For_TUMS[Nst][11];

	unsigned char Stroki_TUMS[Nst][46][18], //������ ������� ���������� ���� �������� ������
	Soob_TUMS[Nst][10][18], //---------------------------------- ������� ����� ������ ������
	Kvit_Ot_TUMS[Nst][11];
	AnsiString Stroka;
	char PAKET_TXT[33];
	AnsiString KK;
  Zapusk[Nst]; // ������� ������������ ������� ������ (0 - ��� �������; 1- �������� ������  
//========================================================================================
	unsigned int KVIT_ARM[2][18];
#endif
