//========================================================================================
#pragma hdrstop
#include <vcl.h>
#include <Registry.hpp>
#include "Com_Port.h"
#pragma package(smart_init)
//========================================================================================
//-------------------------------------------------- ��������� �������� ��������� ��������
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
//---------------------------------------------------------------------------- �����������
 __fastcall TCom_Port::TCom_Port(TComponent* Owner)
: TComponent(Owner)
{
	CommNames = new TStringList();  //------------------------------ ������ ���� ���� ������
	if(GetCommNames() == false)//------------ �������� ������ ��������� � ������� COM-������
	{ //------- ���� �� ��������������� ������ ��������� COM-������ - �������� ������ ������
		{
			ShowMessage("��� ������������������ ���-������! ������ �����������.");
			Application->Terminate();
		}
	}
	//---------------------------------------------- ��������� ���������� ����� �� ���������
	rcverrcnt  = 0;  //------------------------------------------- ������� ������ ������ = 0
	trmerrcnt  = 0;  //----------------------------------------- ������� ������ �������� = 0
	PortIsOpen = false;   //---------------------------------------------------- ���� ������
	FBaudRate  = br_9600; //---------------------------------------------- �������� 9600 ���
	FFlowCtrl  = fc_No;   //----------------------------------- ��������� ���������� �������
	FXonLim = 1;       //---------------------------- ���. ���-�� ���� � ������ ����� Xon
	FXoffLim   = 512;     //-------------------------- ����. ���-�� ���� � ������ ����� Xoff
	FSymbSize  = 8;       //--------------------------------------------------- ������ 8 ���
	FParity    = pt_No;   //---------------------------------- �������� �������� �����������
	FStopBits  = sb_One;  //-------------------------------------------------- ���� ����-���
	FXonChar   = 3;       //------------------------------------------------ ��� ������� Xon
	FXoffChar  = 2;       //-------------------------- ����. ���-�� ���� � ������ ����� Xoff
	FErrorChar = 23;      //--------------------------------------------- ��� ������� ������
	FEofChar   = 4;       //--------------------------------------- ��� ������� ����� ������
	FEvtChar   = 25;      //------------------------------- ��� ������� ������������ �������
	FToTotal   = false;   //----------------------------------- ���. ����� ������� ���������
	FToIntv    = false;   //---------------------------------------���. ������������ �������
	FToValue   = 1000;    //---------------------------------- �������� ������ �������� � ��
	TrmEvent = CreateEvent(NULL,true,true,"CPM_TRANSMIT_COMPLETE"); //----- ������� ��������
	if(TrmEvent == NULL)Application->Terminate(); //----------------------------- �� �������
	else TrmOLS.hEvent = TrmEvent; //--------------- ���������� ������� � ��������� ��������
	RcvEvent = CreateEvent(NULL,true,true,"CPM_RECIEVE_COMPLETE");//--------- ������� ������
	if (RcvEvent == NULL) Application->Terminate(); //--------------------------- �� �������
	else  RcvOLS.hEvent = RcvEvent; //---------------- ���������� ������� � ��������� ������
	TrmInProg = false; //------------------------------------ �������� ���� ������� ��������
	RcvInProg = false; //---------------------------------------------------------- � ������
}

//========================================================================================
__fastcall TCom_Port::~TCom_Port(void)
{
	//---------------------------------------------- ���������� ���������� ����� ��� �������
	//------------------------------------------------------------- ������� ���������� �����
	if(PortIsOpen)CloseHandle(PortHandle);
  delete CommNames;
}

//========================================================================================
//------------------------------------------------------------------ �������� ����� � ����
unsigned long __fastcall TCom_Port::BufToComm(char* Buf, unsigned int Len)
{
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBWri,Result;

	Result = 0;
	//-------------------------------------------------- ��������� ��������� ��������� �����
	if(ClearCommError(PortHandle,&lpe,&lps))
	{
		if(Len > 0)
		{
			//------------- �������� � ����� ����� (lps.cbOutQue = ���������� �������� � ������)
			if(!WriteFile(PortHandle,Buf,Len,&lpNBWri,&TrmOLS))
			{
				if(GetLastError()!= ERROR_IO_PENDING)
				{ //-------------------------------- ������ �� ���� ������� � ���������� ���������
					PurgeComm(PortHandle,PURGE_TXABORT || PURGE_TXCLEAR); //------------ ����� �����
					trmerrcnt++;//------------------------- ��������� ������� ������ �������� �����.
					exit(1);
				}
			}
			//---- ���� ���-�� ����������� ��� �������� ��������(TrmOLS.InternalHigh) ����������
			//-- �� ����� ������������� ���������(i), �� ��������� ������� ������ �������� �����
			if(TrmOLS.InternalHigh != Len)trmerrcnt++;
		}
		Result = TrmOLS.InternalHigh; //---------- ������� ���-�� ����������� ������ ��������.
	}
	return(Result);
}
//========================================================================================
//-------------------------------------------------------- �������� ������ �������� � ����
unsigned long __fastcall TCom_Port::StrToComm(char* trmstring)
{
	unsigned int i;
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBWri,Result;
	Result = 0;
	//-------------------------------------------------- ��������� ��������� ��������� �����
	if(ClearCommError(PortHandle, &lpe, &lps))
	{
		i = sizeof(trmstring);
		//-------------------------------- ��������� ����� ��������� ��� ������ � ����� �����.
		if(i > (sizeof(Buffer) - lps.cbOutQue))
		i = sizeof(Buffer) - lps.cbOutQue;
		//-- ����� ���������(i) = ����� ������(Length(soob)) - ���-�� �������� � ������ �����,
		//--------------------------------- ���������� ����� ��������� ��������(lps.cbOutQue).
		if (i > 0)
		{
			//-------------------------------------------------------- ���������� ������ � �����
			Move(&trmstring[1], &Buffer[0], i);
			//------------- �������� � ����� ����� (lps.cbOutQue = ���������� �������� � ������)
			if(!WriteFile(PortHandle,Buffer,i, &lpNBWri,&TrmOLS)) //--------------- ��� ��������
			{
				if (GetLastError() != ERROR_IO_PENDING)//- ���� ������ �� ���� ���������� ��������
				{
					PurgeComm(PortHandle,PURGE_TXABORT|PURGE_TXCLEAR); //------------- �������� ����
					trmerrcnt++;//-___--------------------- ��������� ������� ������ �������� �����.
					exit(0);
				}
			}
			//------- ��������� ������� ������ �������� �����, ���� ���-�� �������� ��� ��������
			//----- ��������(TrmOLS.InternalHigh) ���������� �� ����� ������������� ���������(i)
			if(TrmOLS.InternalHigh != i)trmerrcnt++;
		}
		Result = i;    // ������� ���-�� ���������� � ���� ��������.
	}
	return(Result);
}
//========================================================================================
//------------------------------------------------------------- ��������� �� ����� � �����
unsigned long __fastcall TCom_Port::BufFromComm(char* Buf, unsigned int MaxLen)
{
	unsigned int j;
	DWORD lpe;
	COMSTAT lps;
	unsigned long lpNBRd;
	lpNBRd = 0;
	//-------------------------------------------------- ��������� ��������� ��������� �����
	if (ClearCommError(PortHandle,&lpe,&lps))//- ���� ������� �������� ������ ��� �� �� ����
	{
		j = lps.cbInQue; //----------------------- ���-�� �������� ������� ��� ������ �� �����
		//--------------------------------- �������� ���-�� �������� � ������� � ������ ������
		if (j > MaxLen)j = MaxLen; //----- ���������� ���-�� �������� �������� �� ����� ������
		if (j > 0)
		{
			//------------------------- ��������� ����� ����� (j = ���������� �������� � ������)
			if(!ReadFile(PortHandle,&Buf, j, &lpNBRd, &RcvOLS))
			{ //----------------------------------------------------------- ���������� � �������
				if(GetLastError()!= ERROR_IO_PENDING)//-------- ���� ��� �� ������ �������� ������
				{
					PurgeComm(PortHandle, PURGE_RXABORT|PURGE_RXCLEAR);//--------------�������� ����
					rcverrcnt++;//------------------------- ��������� ������� ������ ����� �� ������
					exit(0);
				}
			}
			//----------------------- ��������� ������������ ���-�� ���������� �� ����� ��������
			if (j != lpNBRd)rcverrcnt++;//��������� ������� ������ ����� �� ������, ���� �������
																	//����������� ��������(lpNBRd) ���������� �� ���-�� ���-
																	//�����, ������������� �� ������ �����(j).
		}
	}
	return(lpNBRd);
}
//========================================================================================
//------------------------------------------------------ ������ ���������� ������ �� �����
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
		if(ClearCommError(PortHandle, &lpe, &lps)) //----- ��������� ��������� ��������� �����
		{ //------------------------------------------------- ���� ������� ����������� �������
			j = lps.cbInQue; //--------------------- ���-�� �������� ������� ��� ������ �� �����
			if(j >sizeof(Buffer))j = sizeof(Buffer);//���������� ���-�� �������� �������� ������
			if(j > 0)  //-------------------------------------------- ���� ���� ������� � ������
			{ //----- ��������� ����� �����,j-������� ����� ���������,lpNBRd - ������� ���������
				if(!ReadFile(PortHandle,&Buffer,j,&lpNBRd,&RcvOLS))
				{ //---------------------------------------------- ���� ������ ��������� � �������
					if(GetLastError() != ERROR_IO_PENDING)
					{  //------------------------ ���� ������ �� �������� ������ ���������� ��������
						PurgeComm(PortHandle,PURGE_RXABORT|PURGE_RXCLEAR); //---------- �������� �����
						rcverrcnt++;  //-------------------- ��������� ������� ������ ����� �� ������
						return(Result);
					}
				}
				for(i=0;i<8;i++)      //------------------- ����������� ������� �� ������ � ������
				*rcvstring = *rcvstring + Buffer[i]; //-------- �������� � ������ ������ �� ������
				if (j != lpNBRd)rcverrcnt++; //------------ ���� ������� �� ������� ������� ������
																		 //---------- ��������� ������� ������ ����� �� ������
			}
			else break;
		}
	}
	return(true);
}
//========================================================================================
//---------------------------------------------------------------- ������������� ��� �����
//----------------------------- ��������� ���������� � ����� ������, ����������� ��������:
//---------------------------  - ����� �����
//---------------------------  - ��� �������� ������ ����� � ������������ � CBaudArray
//---------------------------  - ������� � ������������ � TParity
//---------------------------  - ��� ���������� ����-����� � ������������ � TStopBits
//---------------------------  - ���-�� ��� � ������� � ������������ � TSymbSize
//---------------------------  - ��� ������� ������������ ������� FEvtChar
//  ���� �������� ��������� ������ - �������� ������� ��������
//  ��� ���������� true ��� ���������� ������ � ����������, ����� false
bool __fastcall TCom_Port::InitPort(AnsiString CommPortParam)
{
	int i,p;
	s = CommPortParam;
	i = 1;
	//--------------------------------------------------------------- ���������� ����� �����
	sp = "";
	while (s.c_str()[i] != ',')	{sp = sp + s.c_str()[i++]; if(i > s.Length())exit(0);}
	i++;
	if(i > s.Length())exit(0);
	sp = "COM" + sp;
	//----------- ��������� � �������,���� ����� ���� �� ��������������� � ������ COM-������
	if((CommNames == NULL) || (CommNames->IndexOf(sp) < 0))exit(0);
	PortName = sp; //---------------------------------------------------- ������������ �����
	//---------------------------------------------------------------- �������� ������ �����
	sp = "";
	while (s.c_str()[i] != ',')	{	sp = sp + s.c_str()[i++];	if(i > s.Length())exit(0);}
	if(sp!="")
	{
		try	{p = StrToInt(sp);}
		catch(...){exit(0);}//------ ��������� � ������� ���� �������� �������� ����� �� �����
		FBaudRate = TBaudRate1(p); //----------------------------------------- �������� ������
	}
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------------------- ��� ��������
	sp = "";
	while(s.c_str()[i] !=','){sp = sp + s.c_str()[i++];if(i > s.Length())exit(0);}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);}//------ ��������� � ������� ���� �������� �������� ����� �� �����
		FParity = TParity1(p); //----------------------------------------------------- �������
	}
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------ ��� ���������� ����-�����
	sp = "";
	while(s.c_str()[i]!=','){sp = sp + s.c_str()[i++]; if(i>s.Length())exit(0);}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);} //��������� � �������,�������� ���������� ����-��� ����� �� �����
		FStopBits = TStopBits1(p); //----------------------------------------- ���-�� ���� ���
	};
	i++;
	if(i > s.Length())return(true);

	//------------------------------------------------------------- ���������� ��� � �������
	sp = "";
	while(s.c_str()[i]!=','){sp = sp + s.c_str()[i++];if(i > s.Length())break;}
	if(sp != "")
	{
		try {p = StrToInt(sp);}
		catch(...){exit(0);}//��������� � �������, �������� ����� ��� � ������� ����� �� �����
		FSymbSize = TSymbSize(p); // ���-�� ��� � �������
	}
	i++;
	if(i>s.Length())return(true);

	//----------------------------------------------------- ��� ������� ������������ �������
	sp = "";
	while(s.c_str()[i]!= ',')
	{
		sp = sp + s.c_str()[i++];
		if(i > s.Length())break;
	}
	if(sp != "")FEvtChar = (sp.c_str()[1]); //----------- ��� ������� ������������ �������
	return(true);
}// TComPort.InitPort
//========================================================================================
//--------------------------------------------------------------- ������� ���������� �����
bool __fastcall TCom_Port::ClosePort(void)
{
	bool result = CloseHandle(PortHandle);
	if(result)PortIsOpen = false;
	return(result);
} // TComPort.ClosePort
//========================================================================================
//---------------------------------------------------------- ��������� ��������� ���������
void __fastcall TCom_Port::CalcTimeouts(void)
{
	unsigned char HSL;
	//---------------------------------------------------------------- ����� ������� � �����
	HSL = FSymbSize + 2; //----------------------------------- ��������� � 1 (����) ��������
	if(FStopBits != sb_One)HSL++; //--------------------------- ���� ������ ������ ���������
	if((FParity != pt_No) && FParityEn)HSL++; //---------------------- �� ���� ���� ��������

	//---------------------------------------------------------------------- �������� ������
	if(FToIntv)
	//--------------------------------------- ������� �������� ���������� ������� ��� ������
	TimeOuts.ReadIntervalTimeout = 10*(( HSL * 1000 / CBaudArray[FBaudRate]) + 1);
	else TimeOuts.ReadIntervalTimeout = 0;
	if(FToTotal)
	{
		//---------------------------------------- ������� �������� ������ ������� � ���������
		TimeOuts.ReadTotalTimeoutMultiplier = (int)(HSL*1000/CBaudArray[ FBaudRate])+1;

		//-------------------------------- ���������� ������������ �������� �������� ���������
		TimeOuts.ReadTotalTimeoutConstant = FToValue;
	}
	else
	{
		//---------------------------------------- ������� �������� ������ ������� � ���������
		TimeOuts.ReadTotalTimeoutMultiplier = 0;

		//-------------------------------- ���������� ������������ �������� �������� ���������
		TimeOuts.ReadTotalTimeoutConstant = 0;
	}
	//---------------------------------------------------------------------- �������� ������
	TimeOuts.WriteTotalTimeoutMultiplier =  (int)(HSL*1000/ CBaudArray[ FBaudRate]) + 1;
	TimeOuts.WriteTotalTimeoutConstant = 50;
	SetCommTimeouts(PortHandle, &TimeOuts);
}
//========================================================================================
//-- ���������� ������������������ � ������� Windows ����� ����. ������ � ��������� ������
// ���� � ���������� CommNames. ���������� "T" ��� ������� ���� �� ������ �����, ����� "F"
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
	ShowMessage("� ������� �� ������� ������ Win98 ��� Win2k. Com-����� ����������.");
	return(Result);
}// TComPort.GetCommNames

//========================================================================================
// ��������� ���� ����������������� ��������� DCB �� Win32 SDK
void __fastcall TCom_Port::fill_DCB(void)
{
 //	with PortDCB do
	PortDCB.DCBlength = sizeof(DCB); //------------------------------------- ����� ���������
	PortDCB.BaudRate = CBaudArray [FBaudRate];//---------------------------- �������� ������

	//------------------------------------- ����� ��� Win32 - fBinary ���������� �����������
	if(FParityEn)PortDCB.fParity = 1;//------------------------------ ������������� ��������
	else PortDCB.fParity = 0;

	if(FCTSFlow)PortDCB.fOutxCtsFlow = 1;//----------------------- ���������� ������� �� CTS
	else PortDCB.fOutxCtsFlow = 0;

	if(FDSRFlow)PortDCB.fOutxDsrFlow	= 1;//---------------------- ���������� ������� �� DSR
	else PortDCB.fOutxDsrFlow	= 0;

	switch(FDTRControl)
	{
		case 	dtr_Enable: PortDCB.fDtrControl = 1;//---------------------- ���� ���������� DTR
		case dtr_Handshake: PortDCB.fDtrControl = 0;//- ��������� ���������� � ����������� DTR
	}

	if(FDSRSense)PortDCB.fDsrSensitivity = 1; //------------- ���������������� � ������� DSR
	else PortDCB.fDsrSensitivity =0;
	if(FTxCont)PortDCB.fTXContinueOnXoff = 1; //------------ ����������� �������� ����� Xoff
	else PortDCB.fTXContinueOnXoff = 0;
	if(FOutX)PortDCB.fOutX = 1; //------------------------ ������������ XoffXon ��� ��������
	else PortDCB.fOutX = 0;
	if(FInX)PortDCB.fInX = 1; //---------------------------- ������������ XoffXon ��� ������
	else PortDCB.fInX = 0;
	if(FErrorReplace)PortDCB.fErrorChar = 1; //------ �������� ����� � �������� �� ErrorChar
	else PortDCB.fErrorChar = 0;
	if(FDiscardNull)PortDCB.fNull = 1; //-------------- �������� ������� ������ �� ���������
	else PortDCB.fNull = 0;

	switch(FRTSControl)
	{
		case rts_Enable:  PortDCB.fRtsControl = 1;//---------------------- ���� ���������� RTS
		case rts_Handshake: PortDCB.fRtsControl= 0;//��������� ���������� � �������������� RTS
		case rts_Toggle: PortDCB.fRtsControl = 0;//-------------------------- ������������ RTS
	}

	if(FAbortOnError)PortDCB.fAbortOnError = 1; //--------------- ��������� ����� ��� ������
	else PortDCB.fAbortOnError = 0;

	PortDCB.XonLim    = FXonLim;//---------------------- ���. ���-�� ���� � ������ ����� Xon
	PortDCB.XoffLim   = FXoffLim; //------------------ ����. ���-�� ���� � ������ ����� Xoff
	PortDCB.ByteSize  = FSymbSize; //---------------------------------- ���-�� ��� � �������
	PortDCB.Parity    = FParity; //-------------------------------------------- ��� ��������
	PortDCB.StopBits  = FStopBits;//-------------------------------------- ���-�� ����-�����
	PortDCB.XonChar   = FXonChar;//--------------------------------------- ���-�� ����-�����
	PortDCB.XoffChar  = FXoffChar;//-------------------------------------- ���-�� ����-�����
	PortDCB.ErrorChar = FErrorChar;//------------------------------------ ��� ������� ������
	PortDCB.EofChar   = FEofChar;//-------------------------------- ��� ������� ����� ������
	PortDCB.EvtChar   = FEvtChar;//------------------------ ��� ������� ������������ �������
}

//========================================================================================
//------------------------------------------- �������� ������� � ���������������� ���-����
//------------------------------------------ ���������� TRUE � ������ �����, ����� - FALSE
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
	//------------------------------------------------------ ��������� ���� ����� ����������
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
//---------------------------------- �������� ��������� ������� RTS - ������ ��������� !!!
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
//---------------------------------- �������� ��������� ������� DTR - ������ ��������� !!!
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
//---------------------------------------------------------------------- ���������� ������
void __fastcall TCom_Port::RecieveFinish(void)
{
	if(!RcvInProg)exit(0); //--------------------- �����, ���� �� ���. ���� ������� ��������
	RcvInProg = false; //-------------------------------------- �������� ���� ������� ������
}

//========================================================================================
//-------------------------------------------------------------------- ���������� ��������
void __fastcall TCom_Port::TransmitFinish(void)
{
	if(!TrmInProg)exit(0);
	TrmInProg = false;//------------------------------------- �������� ���� ������� ��������
	if(!GetOverlappedResult(PortHandle,&TrmOLS,&TrmdBytes,false)) //--- ��������� ����������
	{
		CancelIo(PortHandle);//----------------- ������������� ��������� ��� �������� � ������
		RcvInProg = false; //------------------------------------ �������� ���� ������� ������
	}
}

