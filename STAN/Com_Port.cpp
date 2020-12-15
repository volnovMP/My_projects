//========================================================================================
#pragma hdrstop
#include <vcl.h>
#include <Registry.hpp>
#include "Com_Port.h"
#pragma package(smart_init)
//========================================================================================
//-------------------------------------------------- Численные значения скоростей передачи
unsigned long CBaudArray[14] =
{
	CBR_110,   CBR_300,   CBR_600,   CBR_1200, CBR_2400,
	CBR_4800,  CBR_9600,  CBR_14400, CBR_19200,	CBR_38400,
	CBR_57600, CBR_115200,CBR_128000,CBR_256000
};
//========================================================================================
static inline TCom_Port *ValidCtrCheck()
{
	return new TCom_Port(NULL);
}
//---------------------------------------------------------------------------- конструктор
 __fastcall TCom_Port::TCom_Port(TComponent* Owner)
: TComponent(Owner)
{
	CommNames = new TStringList();  //------------------------------ Список имен всех портов
	if(GetCommNames() == false)//------------ Получить список доступных в системе COM-портов
	{ //------- Если не инициализирован список доступных COM-портов - получить полный список
		{
			ShowMessage("Нет зарегистрированных СОМ-портов! Работа завершается.");
			Application->Terminate();
		}
	}
	//---------------------------------------------- Установка параметров порта по умолчанию
	rcverrcnt  = 0;  //------------------------------------------- счетчик ошибок приема = 0
	trmerrcnt  = 0;  //----------------------------------------- счетчик ошибок передачи = 0
	PortIsOpen = false;   //---------------------------------------------------- Порт закрыт
	FBaudRate  = br_9600; //---------------------------------------------- скорость 9600 бод
	FFlowCtrl  = fc_No;   //----------------------------------- Выключено управление потоком
	FXonLim = 1;       //---------------------------- Мин. кол-во байт в буфере перед Xon
	FXoffLim   = 512;     //-------------------------- Макс. кол-во байт в буфере перед Xoff
	FSymbSize  = 8;       //--------------------------------------------------- Символ 8 бит
	FParity    = pt_No;   //---------------------------------- Контроль паритета отсутствует
	FStopBits  = sb_One;  //-------------------------------------------------- Один стоп-бит
	FXonChar   = 3;       //------------------------------------------------ Код символа Xon
	FXoffChar  = 2;       //-------------------------- Макс. кол-во байт в буфере перед Xoff
	FErrorChar = 23;      //--------------------------------------------- Код символа ошибки
	FEofChar   = 4;       //--------------------------------------- Код символа конца данных
	FEvtChar   = 25;      //------------------------------- Код символа сигнализации события
	FToTotal   = false;   //----------------------------------- Исп. общий таймаут сообщения
	FToIntv    = false;   //---------------------------------------Исп. интервальный таймаут
	FToValue   = 1000;    //---------------------------------- Величина общего таймаута в мс
	TrmEvent = CreateEvent(NULL,true,true,"CPM_TRANSMIT_COMPLETE"); //----- событие передачи
	if(TrmEvent == NULL)Application->Terminate(); //----------------------------- не создано
	else TrmOLS.hEvent = TrmEvent; //--------------- установить событие в структуру передачи
	RcvEvent = CreateEvent(NULL,true,true,"CPM_RECIEVE_COMPLETE");//--------- событие приема
	if (RcvEvent == NULL) Application->Terminate(); //--------------------------- не создано
	else  RcvOLS.hEvent = RcvEvent; //---------------- установить событие в структуру приема
	TrmInProg = false; //------------------------------------ Сбросить флаг течения передачи
	RcvInProg = false; //---------------------------------------------------------- и приема
}

//========================================================================================
__fastcall TCom_Port::~TCom_Port(void)
{
	//---------------------------------------------- Освободить обработчик порта для системы
	//------------------------------------------------------------- Закрыть обработчик порта
	if(PortIsOpen)CloseHandle(PortHandle);
  delete CommNames;
}

//========================================================================================
//------------------------------------------------------------------ Записать буфер в порт
unsigned long __fastcall TCom_Port::BufToComm(char* Buf, unsigned int Len)
{
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBWri,Result;

	Result = 0;
	//-------------------------------------------------- Заполнить структуры состояния порта
	if(ClearCommError(PortHandle,&lpe,&lps))
	{
		if(Len > 0)
		{
			//------------- Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
			if(!WriteFile(PortHandle,Buf,Len,&lpNBWri,&TrmOLS))
			{
				if(GetLastError()!= ERROR_IO_PENDING)
				{ //-------------------------------- Ошибка не была связана с отложенной передачей
					PurgeComm(PortHandle,PURGE_TXABORT || PURGE_TXCLEAR); //------------ сброс порта
					trmerrcnt++;//------------------------- Увеличить счетчик ошибок передачи порта.
					exit(1);
				}
			}
			//---- если кол-во всспринятых для передачи символов(TrmOLS.InternalHigh) отличается
			//-- от длины передаваемого сообщения(i), то увеличить счетчик ошибок передачи порта
			if(TrmOLS.InternalHigh != Len)trmerrcnt++;
		}
		Result = TrmOLS.InternalHigh; //---------- Вернуть кол-во воспринятых портом символов.
	}
	return(Result);
}
//========================================================================================
//-------------------------------------------------------- Записать строку символов в порт
unsigned long __fastcall TCom_Port::StrToComm(char* trmstring)
{
	unsigned int i;
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBWri,Result;
	Result = 0;
	//-------------------------------------------------- Заполнить структуры состояния порта
	if(ClearCommError(PortHandle, &lpe, &lps))
	{
		i = sizeof(trmstring);
		//-------------------------------- Вычислить длину сообщения для записи в буфер порта.
		if(i > (sizeof(Buffer) - lps.cbOutQue))
		i = sizeof(Buffer) - lps.cbOutQue;
		//-- Длина сообщения(i) = длина буфера(Length(soob)) - кол-во символов в буфере порта,
		//--------------------------------- оставшихся после последней передачи(lps.cbOutQue).
		if (i > 0)
		{
			//-------------------------------------------------------- Копировать данные в буфер
			Move(&trmstring[1], &Buffer[0], i);
			//------------- Записать в буфер порта (lps.cbOutQue = количество символов в буфере)
			if(!WriteFile(PortHandle,Buffer,i, &lpNBWri,&TrmOLS)) //--------------- для передачи
			{
				if (GetLastError() != ERROR_IO_PENDING)//- если ошибка не флаг отложенной передачи
				{
					PurgeComm(PortHandle,PURGE_TXABORT|PURGE_TXCLEAR); //------------- очистить порт
					trmerrcnt++;//-___--------------------- Увеличить счетчик ошибок передачи порта.
					exit(0);
				}
			}
			//------- Увеличить счетчик ошибок передачи порта, если кол-во принятых для передачи
			//----- символов(TrmOLS.InternalHigh) отличается от длины передаваемого сообщения(i)
			if(TrmOLS.InternalHigh != i)trmerrcnt++;
		}
		Result = i;    // Вернуть кол-во записанных в порт символов.
	}
	return(Result);
}
//========================================================================================
//------------------------------------------------------------- Прочитать из порта в буфер
unsigned long __fastcall TCom_Port::BufFromComm(char* Buf, unsigned int MaxLen)
{
	unsigned int j;
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBRd;
	lpNBRd = 0;
	//-------------------------------------------------- Заполнить структуры состояния порта
	if (ClearCommError(PortHandle,&lpe,&lps))//- если успешно сброшена ошибка или ее не было
	{
		j = lps.cbInQue; //----------------------- Кол-во символов готовых для чтения из порта
		//--------------------------------- Сравнить кол-во символов в очереди с длиной буфера
		if (j > MaxLen)j = MaxLen; //----- Ограничить кол-во читаемых символов по длине буфера
		if (j > 0)
		{
			//------------------------- Прочитать буфер порта (j = количество символов в буфере)
			if(!ReadFile(PortHandle,&Buf, j, &lpNBRd, &RcvOLS))
			{ //----------------------------------------------------------- Завершение с ошибкой
				if(GetLastError()!= ERROR_IO_PENDING)//-------- если это не ошибка ожидания данных
				{
					PurgeComm(PortHandle, PURGE_RXABORT|PURGE_RXCLEAR);//--------------очистить порт
					rcverrcnt++;//------------------------- Увеличить счетчик ошибок порта по чтению
					exit(0);
				}
			}
			//----------------------- Проверить соответствие кол-ва полученных из порта символов
			if (j != lpNBRd)rcverrcnt++;//Увеличить счетчик ошибок порта по приему, если счетчик
																	//прочитанных символов(lpNBRd) отличается от кол-ва сим-
																	//волов, запрашиваемых из буфера порта(j).
		}
	}
	return(lpNBRd);
}
//========================================================================================
//------------------------------------------------------ Чтение полученных данных из порта
bool __fastcall TCom_Port::StrFromComm(AnsiString* rcvstring)
{
	unsigned int i,j;
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBRd;
	bool Result = false;
	*rcvstring = "";
	while(1)
	{
		if(ClearCommError(PortHandle, &lpe, &lps)) //----- Заполнить структуры состояния порта
		{ //------------------------------------------------- если функция завершилась успешно
			j = lps.cbInQue; //--------------------- Кол-во символов готовых для чтения из порта
			if(j >sizeof(Buffer))j = sizeof(Buffer);//Ограничить кол-во читаемых символов буфера
			if(j > 0)  //-------------------------------------------- если есть символы в буфере
			{ //----- Прочитать буфер порта,j-столько хотим прочитать,lpNBRd - столько прочитали
				if(!ReadFile(PortHandle,&Buffer,j,&lpNBRd,&RcvOLS))
				{ //---------------------------------------------- если чтение завершено с ошибкой
					if(GetLastError() != ERROR_IO_PENDING)
					{  //------------------------ если ошибка не является флагом отложенной передачи
						PurgeComm(PortHandle,PURGE_RXABORT|PURGE_RXCLEAR); //---------- очистить буфер
						rcverrcnt++;  //-------------------- Увеличить счетчик ошибок порта по чтению
						return(Result);
					}
				}
				for(i=0;i<8;i++)      //------------------- Скопировать символы из буфера в строку
				*rcvstring = *rcvstring + Buffer[i]; //-------- добавить в строку данные из буфера
				if (j != lpNBRd)rcverrcnt++; //------------ если принято не столько сколько хотели
																		 //---------- Увеличить счетчик ошибок порта по приему
			}
			else break;
		}
	}
	return(true);
}
//========================================================================================
//---------------------------------------------------------------- Инициализация СОМ порта
//----------------------------- Параметры передаются в одной строке, разделенные запятыми:
//---------------------------  - Номер порта
//---------------------------  - Код скорости работы порта в соответствии с CBaudArray
//---------------------------  - Паритет в соответствии с TParity
//---------------------------  - Код количества стоп-битов в соответствии с TStopBits
//---------------------------  - Кол-во бит в символе в соответствии с TSymbSize
//---------------------------  - Код символа сигнализации события FEvtChar
//  Если значение параметра пустое - оставить прежнее значение
//  Код завершения true при отсутствии ошибок в параметрах, иначе false
bool __fastcall TCom_Port::InitPort(AnsiString CommPortParam)
{
	int i,p;
	s = CommPortParam;
	i = 1;
	//--------------------------------------------------------------- Установить номер порта
	sp = "";
	while (s.c_str()[i] != ',')	{sp = sp + s.c_str()[i++]; if(i > s.Length())exit(0);}
	i++;
	if(i > s.Length())exit(0);
	sp = "COM" + sp;
	//----------- Завершить с ошибкой,если такой порт не зарегистрирован в списке COM-портов
	if((CommNames == NULL) || (CommNames->IndexOf(sp) < 0))exit(0);
	PortName = sp; //---------------------------------------------------- Наименование порта
	//---------------------------------------------------------------- Скорость работы порта
	sp = "";
	while (s.c_str()[i] != ',')	{	sp = sp + s.c_str()[i++];	if(i > s.Length())exit(0);}
	if(sp!="")
	{
		try	{p = StrToInt(sp);}
		catch(...){exit(0);}//------ Завершить с ошибкой если параметр скорости задан не верно
		FBaudRate = TBaudRate1(p); //----------------------------------------- скорость обмена
	}
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------------------- Тип паритета
	sp = "";
	while(s.c_str()[i] !=','){sp = sp + s.c_str()[i++];if(i > s.Length())exit(0);}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);}//------ Завершить с ошибкой если параметр паритета задан не верно
		FParity = TParity1(p); //----------------------------------------------------- Паритет
	}
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------ Код количества стоп-битов
	sp = "";
	while(s.c_str()[i]!=','){sp = sp + s.c_str()[i++]; if(i>s.Length())exit(0);}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);} //Завершить с ошибкой,параметр количества стоп-бит задан не верно
		FStopBits = TStopBits1(p); //----------------------------------------- кол-во стоп бит
	};
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------- Количество бит в символе
	sp = "";
	while(s.c_str()[i]!=','){sp = sp + s.c_str()[i++];if(i > s.Length())break;}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);}//Завершить с ошибкой, параметр числа бит в символе задан не верно
		FSymbSize = TSymbSize(p); // кол-во бит в символе
	}
	i++;
	if(i>s.Length())return(true);

	//----------------------------------------------------- Код символа сигнализации события
	sp = "";
	while(s.c_str()[i]!= ',')
	{
		sp = sp + s.c_str()[i++];
		if(i > s.Length())break;
	}
	if(sp != "")FEvtChar = (sp.c_str()[1]); //----------- Код символа сигнализации события
	return(true);
}// TComPort.InitPort
//========================================================================================
//--------------------------------------------------------------- Закрыть обработчик порта
bool __fastcall TCom_Port::ClosePort(void)
{
	bool result = CloseHandle(PortHandle);
	if(result)PortIsOpen = false;
	return(result);
} // TComPort.ClosePort
//========================================================================================
//---------------------------------------------------------- Вычислить параметры таймаутов
void __fastcall TCom_Port::CalcTimeouts(void)
{
	unsigned char HSL;
	//---------------------------------------------------------------- Длина символа в битах
	HSL = FSymbSize + 2; //----------------------------------- Стартовый и 1 (один) стоповый
	if(FStopBits != sb_One)HSL++; //--------------------------- Если больше одного стопового
	if((FParity != pt_No) && FParityEn)HSL++; //---------------------- За счет бита паритета

	//---------------------------------------------------------------------- Таймауты чтения
	if(FToIntv)
	//--------------------------------------- Таймаут ожидания следующего символа при приеме
	TimeOuts.ReadIntervalTimeout = 10*(( HSL * 1000 / CBaudArray[FBaudRate]) + 1);
	else TimeOuts.ReadIntervalTimeout = 0;
	if(FToTotal)
	{
		//---------------------------------------- Таймаут ожидания одного символа в сообщении
		TimeOuts.ReadTotalTimeoutMultiplier = (int)(HSL*1000/CBaudArray[ FBaudRate])+1;

		//-------------------------------- Постоянная составляющая таймаута ожидания сообщения
		TimeOuts.ReadTotalTimeoutConstant = FToValue;
	}
	else
	{
		//---------------------------------------- Таймаут ожидания одного символа в сообщении
		TimeOuts.ReadTotalTimeoutMultiplier = 0;

		//-------------------------------- Постоянная составляющая таймаута ожидания сообщения
		TimeOuts.ReadTotalTimeoutConstant = 0;
	}
	//---------------------------------------------------------------------- Таймауты записи
	TimeOuts.WriteTotalTimeoutMultiplier =  (int)(HSL*1000/ CBaudArray[ FBaudRate]) + 1;
	TimeOuts.WriteTotalTimeoutConstant = 50;
	SetCommTimeouts(PortHandle, &TimeOuts);
}
//========================================================================================
//-- Определяет зарегистрированные в реестре Windows имена посл. портов и формирует список
// имен в переменной CommNames. Возвращает "T" при наличии хотя бы одного порта, иначе "F"
bool __fastcall TCom_Port::GetCommNames(void)
{
	int i;
	bool Result = false;
	TRegistry *VReg = new TRegistry;
	TStringList *Val  = new TStringList;
	//with VReg do
	VReg->RootKey = HKEY_LOCAL_MACHINE;
	try
	{
		if(VReg->OpenKeyReadOnly("HARDWARE\\DEVICEMAP\\SERIALCOMM"))
		{
			VReg->GetValueNames(Val );
			for(i=0;i<Val->Count;i++)
			if(Val->Strings[i] != "")CommNames->Add(VReg->ReadString(Val->Strings[i]));
			Result = (CommNames != NULL) && (CommNames->Count > 0);
			VReg->CloseKey();
			Val->Free();
      VReg->Free();
			return(Result);
		}
	}
	catch(...){VReg->Free();}
	//---------------------------------------------------------------- try .. finally
  VReg->Free();
	Val->Free();
	ShowMessage("В реестре не найдены записи Win98 или Win2k. Com-порты недоступны.");
	return(Result);
}// TComPort.GetCommNames

//========================================================================================
// Заполняет поля коммуникационнной структуры DCB из Win32 SDK
void __fastcall TCom_Port::fill_DCB(void)
{
 //	with PortDCB do
	PortDCB.DCBlength = sizeof(DCB); //------------------------------------- Длина структуры
	PortDCB.BaudRate = CBaudArray [FBaudRate];//---------------------------- Скорость обмена

	//------------------------------------- Флаги Для Win32 - fBinary установить обязательно
	if(FParityEn)PortDCB.fParity = 1;//------------------------------ Использование паритета
	else PortDCB.fParity = 0;

	if(FCTSFlow)PortDCB.fOutxCtsFlow = 1;//----------------------- Управление выходом по CTS
	else PortDCB.fOutxCtsFlow = 0;

	if(FDSRFlow)PortDCB.fOutxDsrFlow	= 1;//---------------------- Управление выходом по DSR
	else PortDCB.fOutxDsrFlow	= 0;

	switch(FDTRControl)
	{
		case 	dtr_Enable: PortDCB.fDtrControl = 1;//---------------------- Есть управление DTR
		case dtr_Handshake: PortDCB.fDtrControl = 0;//- Установка соединения с применением DTR
	}

	if(FDSRSense)PortDCB.fDsrSensitivity = 1; //------------- Чувствительность к сигналу DSR
	else PortDCB.fDsrSensitivity =0;
	if(FTxCont)PortDCB.fTXContinueOnXoff = 1; //------------ Продолжение передачи после Xoff
	else PortDCB.fTXContinueOnXoff = 0;
	if(FOutX)PortDCB.fOutX = 1; //------------------------ Использовать XoffXon при передаче
	else PortDCB.fOutX = 0;
	if(FInX)PortDCB.fInX = 1; //---------------------------- Использовать XoffXon при приеме
	else PortDCB.fInX = 0;
	if(FErrorReplace)PortDCB.fErrorChar = 1; //------ Заменять байты с ошибками на ErrorChar
	else PortDCB.fErrorChar = 0;
	if(FDiscardNull)PortDCB.fNull = 1; //-------------- Удаление нулевых байтов из сообщения
	else PortDCB.fNull = 0;

	switch(FRTSControl)
	{
		case rts_Enable:  PortDCB.fRtsControl = 1;//---------------------- Есть управление RTS
		case rts_Handshake: PortDCB.fRtsControl= 0;//Установка соединения с использованием RTS
		case rts_Toggle: PortDCB.fRtsControl = 0;//-------------------------- Переключение RTS
	}

	if(FAbortOnError)PortDCB.fAbortOnError = 1; //--------------- Прерывать обмен при ошибке
	else PortDCB.fAbortOnError = 0;

	PortDCB.XonLim    = FXonLim;//---------------------- Мин. кол-во байт в буфере перед Xon
	PortDCB.XoffLim   = FXoffLim; //------------------ Макс. кол-во байт в буфере перед Xoff
	PortDCB.ByteSize  = FSymbSize; //---------------------------------- Кол-во бит в символе
	PortDCB.Parity    = FParity; //-------------------------------------------- Тип паритета
	PortDCB.StopBits  = FStopBits;//-------------------------------------- Кол-во стоп-битов
	PortDCB.XonChar   = FXonChar;//--------------------------------------- Кол-во стоп-битов
	PortDCB.XoffChar  = FXoffChar;//-------------------------------------- Кол-во стоп-битов
	PortDCB.ErrorChar = FErrorChar;//------------------------------------ Код символа ошибки
	PortDCB.EofChar   = FEofChar;//-------------------------------- Код символа конца данных
	PortDCB.EvtChar   = FEvtChar;//------------------------ Код символа сигнализации события
}

//========================================================================================
//------------------------------------------- Пытается открыть и сконфигурировать СОМ-порт
//------------------------------------------ Возвращает TRUE в случае удачи, иначе - FALSE
bool __fastcall TCom_Port::OpenPort(void)
{
	AnsiString Name_Port;
	Name_Port = "//./" + FPortName;
	PortIsOpen = false;
	PortHandle = CreateFile(Name_Port.c_str(), GENERIC_READ|GENERIC_WRITE, 0,NULL,
	OPEN_EXISTING,FILE_FLAG_OVERLAPPED, 0);

	if (PortHandle == INVALID_HANDLE_VALUE)
	{
		PortError = GetLastError();
		exit(0);
	}
	//------------------------------------------------------ Заполнить поля блока управления
	fill_DCB();
	if(!SetCommState(PortHandle,&PortDCB))
	{
		PortError = GetLastError();
		exit(0);
	}
	CalcTimeouts();
	lvCdr = EV_RXFLAG;
	SetCommMask(PortHandle, lvCdr);
	CancelIo(PortHandle);
	PortIsOpen = true;
	return(true);
}
//========================================================================================
//---------------------------------- Изменяет состояние сигнала RTS - только постоянно !!!
bool __fastcall TCom_Port::RTSOnOff(bool aOn)
{
	bool Result;
	if(aOn)FRTSControl = rts_Enable;
	else   FRTSControl = rts_Disable;
	fill_DCB();
	Result = SetCommState(PortHandle, &PortDCB);
	return(Result);
}
//========================================================================================
//---------------------------------- Изменяет состояние сигнала DTR - только постоянно !!!
bool __fastcall TCom_Port::DTROnOff(bool aOn)
{
	bool Result;
	if(aOn) FDTRControl = dtr_Enable;
	else FDTRControl = dtr_Disable;
	fill_DCB();
	Result = SetCommState(PortHandle, &PortDCB);
	return(Result);
}
//========================================================================================
//---------------------------------------------------------------------- Завершение приема
void __fastcall TCom_Port::RecieveFinish(void)
{
	if(!RcvInProg)exit(0); //--------------------- Выход, если не уст. флаг течения передачи
	RcvInProg = false; //-------------------------------------- Сбросить флаг течения приема
}

//========================================================================================
//-------------------------------------------------------------------- Завершение передачи
void __fastcall TCom_Port::TransmitFinish(void)
{
	if(!TrmInProg)exit(0);
	TrmInProg = false;//------------------------------------- Сбросить флаг течения передачи
	if(!GetOverlappedResult(PortHandle,&TrmOLS,&TrmdBytes,false)) //--- неудачное завершение
	{
		CancelIo(PortHandle);//----------------- Принудительно завершить все операции с портом
		RcvInProg = false; //------------------------------------ Сбросить флаг течения приема
	}
}

