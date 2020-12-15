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

	struct MARS_ST //------------------------- структура локального маршрута для стойки ТУМС
	{
		char NEXT_KOM[14]; //----------------- маршрутная команда для ТУМС в требуемом формате
		char NUM;  //---------------- номер глобального маршрута, включающего данный локальный
		unsigned char SOST; //-------- переменная для отслеживания текущего состояния маршрута
		time_t T_VYD; //------------------------ время выдачи маршрутной команды в стойку ТУМС
		long T_MAX; //---------------- максимально возможное время ожидания исполнения команды
	}*MARSHRUT_ST[Nst][3]; //---------- для каждой стойки ТУМС одновременно до 3-х маршрутов

	struct Kvit
	{
    time_t Komanda_Time;
		int N_RAZ;
		unsigned char Nom_Paket[2];
		unsigned char KS;
		bool Komanda; //----------------------------------------- true = признак выдачи команд
		bool Kvit; //-------------------------------------- true = признак получения квитанций
    bool Arhiv; //--------------------- true = признак требования записи квитанции в архив
	}Kvitancia;

	time_t T_VYD_RAZ[Nst]; //-------------- время выдачи последней раздельной команды в ТУМС
  TDateTime Vrema;
	unsigned char MARSH_VYDAT[Nst]; //-- флаг-требование на выдачу маршрутной команды в ТУМС
  int DEL_TRASS_MARSH; //-------- признак удаления данных по маршрутам и замыканиям трассы
	int STOP_ALL;
	int ARM_SHN;
  int ARM_DSP;
  int SOSED_IN;//------------------------------------- счетчик тактов без приема от соседа
  int index;
	int PRT1; //------------------------------------------------------------- Основной канал
	int PRT2; //------------------------------------------------------------ Резервный канал
	int PRT3; //----------------------------------------------------------------- Канал ББКП
	int PRT4; //---------------------------------------------------------- Канал обмена ПЭВМ
	int PRT5; //--------------------------------------------------- порт А кнопочной станции
	int PRT6; //--------------------------------------------------- порт В кнопочной станции
	int KOL_STR[Nst];  //-------------------------------------------- число объектов стрелок
	int KOL_SIG[Nst];  //------------------------------------------- число объектов сигналов
	int KOL_DOP[Nst]; //-------------------------------------- число дополнительных объектов
	int KOL_SP[Nst];   //------------------------------------------------- число объектов СП
	int KOL_PUT[Nst];  //---------------------------------------------- число объектов путей
	int KOL_KONT[Nst]; //---------------------------------------- число объектов контроллера
	int RASFASOVKA;
	unsigned int POVTOR_FR4_SOSEDU;
	unsigned int	povtor_novizna;
	int out_dig[4], inp_dig[4], old_inp_dig[4];
	char StrOutInp[20],StrTmp[5],StrOutInpOld[20];
	AnsiString NomKnl;
	int cikl_marsh;
  int byla_trb; //---------------------------- переменная контроля целостности канала Pipe
	int zagruzka;
	int POVTOR_OTKR;
  int flag_err;
  unsigned int NextObj;
	unsigned char PODGR_OLD,BAITY_OLD[5];// подгруппа+байт фиксации ненорм плат без повторов

	time_t TIME_OLD,//-- время последней ненормы плат (если за 15 сек нет повтора, то сброс)
	T_TIME, // текущее время, обновляется основным таймером программы TimerMainTimer (400мс)
	FIXIR_TIME,// время последней фиксации данных (фиксация данных выполняется через 10 мин)
	TIME_DTR,//время последнего переключения линии DTR для модема (применен интервал 10 сек)
	TIME_COM,//-- время последнего открытия порта связи со стойкой (применен интервал 4 сек)
	TimerA, //---- время последнего приема информации портом А для анализа кнопочной станции
	TimerB; //---- время последнего приема информации портом В для анализа кнопочной станции

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
	unsigned char PROCESS, //---------------------------- признак управления от АРМ / пульта
	tiki_tum[Nst];
	unsigned char MYTHX[Nst];
	unsigned int NOVIZNA[KOL_NEW],NOVIZNA_FR4[10],nom_new;
	unsigned int TUMS_RABOT[Nst];
	unsigned int STATUS,statOSN,statREZ,  //------------- код статуса АРМа - серверной части
	OLD_STATUS, //-------------------- прежний статус АРМа для фиксации момента переключения
	NUM_ARM,  //----------------------------------------------------------------- номер АРМа
	SHN, //----------------------------------------------- признак работы с програмой АРМ-ШН
	CIKL;  //-------------------------------------------- признак четного - нечетного циклов
	AnsiString portA = "  ";
	AnsiString portB = "  ";//--------------------------------- символы принятые в порты АРМ
	unsigned char *OutPortA = "AAAAAAAA"; //------------------ символы для передачи в порт А
	unsigned char *OutPortB = "BBBBBBBB"; //------------------ символы для передачи в порт B
  unsigned int povtor_fr4; //----------- текущий указатель на ограничение посылаемое в DSP
	int file_arc,new_fr4,povtor_out,RESET_TIME;
	char Time1[11]; //---------------- символьная строка для записи времени в архивные файлы
	unsigned char SVAZ;//------------------------------ текущее состояние каналов связи АРМА
	unsigned char SVAZ_OLD;//-------------------------- прежнее состояние каналов связи АРМА
	unsigned char ZAPROS_ARM, N_PAKET, KOMANDA_TUMS[Nst][15];
	int SM_TUMS[Nst]; //----------- перечень номеров строк для исполняемых маршрутов в  ТУМС
	unsigned char KNOPKA_OK,//------------------ признак нажатия кнопки + восприятие нажатия
	KNOPKA_OK_N, //-------------------------------------- признак состояния 2-ух каналов КОК
	KNOPKA_OK0; //---------------------- признак нажатия кнопки для изменения формата скобок
	unsigned char KOK_OT_TUMS; //----------------- состояние кнопки КОК, вернувшееся от ТУМС
	unsigned char KVIT_ARMu[12],KVIT_ARMu1[12]; //--------- квитанции АРМу для 1 и 2 каналов

	char OK_KNOPKA, //----- состояние кнопки ответственных команд в команде, принятой от DSP
	ACTIV,  //--------------------------------------------------- признак активности сервера
	KOM_TIME[8]; //----------------------------- массив для записи команды установки времени

	unsigned char KOMANDA_RAZD[12],KOMANDA_MARS[12],MYTHX_TEC[Nst];
//========================================================================================
	int First_Soob_TUMS[Nst],// номер стартовой строки буфера ввода данных последнего приема
	Last_Soob_TUMS[Nst]; //номер заключительной строки буфера ввода данных последнего приема

	TDateTime Time_Last_Ot_TUMS[Nst], //------------- время последнего приема данных от ТУМС
	Time_tek, //------------------------------- текущее время, обновляемое таймером Timer250
	Delta0;//----- интервал между приемами данных от ТУМС, если более 2сек, то связь утеряна
	bool Norma_TS[Nst], //-------------------- признаки нормы приема информации по каналу ТС
	Norma_TU[Nst], //----------------------- признаки нормы передачи информации по каналу ТУ
	Norma_Sosed, //------------------------ признак нормы получения данных от соседнего АРМа
	Norma_Podkl, //------------------------------- признак нормы подключения каналов АРМ-УВК
  NAS,CHAS, //------------------------ признаки установки нечетного и четного автодействия
	Buf_Zaniat[Nst][10];//--- признак занятости буферов приема данных от УВК для отображения
  bool ReBoot; //---------------------------- признак необходимости перезапуска компьютера
	int Poteral[Nst],//-- счет потерянных подряд пакетов, если более 2-х, то снятие нормы ТС
	Prinal[Nst]; //--------------- счет принятых подряд пакетов, если более 3-х, то норма ТС
	unsigned int Tek_Packet[Nst]; //-------------- текущий номер последнего принятого пакета

	unsigned char Komanda_For_TUMS[Nst][18],Kvit_For_TUMS[Nst][11];

	unsigned char Stroki_TUMS[Nst][46][18], //полное текущее содержимое всех принятых данных
	Soob_TUMS[Nst][10][18], //---------------------------------- входной буфер приема данных
	Kvit_Ot_TUMS[Nst][11];
	AnsiString Stroka;
	char PAKET_TXT[33];
	AnsiString KK;
  Zapusk[Nst]; // признак выполненного запуска стойки (0 - нет запуска; 1- выполнен запуск  
//========================================================================================
	unsigned int KVIT_ARM[2][18];
#endif
