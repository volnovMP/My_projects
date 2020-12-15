#include <vcl.h>
#pragma hdrstop
#include "CommPortAB.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//

static inline void ValidCtrCheck(TCommPortAB *)
{
	new TCommPortAB(NULL);
}

//---------------------------------------------------------------------------
namespace Commportab
{
	void __fastcall PACKAGE Register()
	{
		TComponentClass classes[1] = {__classid(TCommPortAB)};
		RegisterComponents("RPCcomp", classes, 0);
	}
}
//============================================================================ конструктор
__fastcall TCommPortAB::TCommPortAB(TComponent* Owner) : TComponent(Owner)
{
	FComHandle = INVALID_HANDLE_VALUE;
	FComNumber = 2;
	FBaudRate = cbr1200;
	FParity = paNone;
	FStopBits = sb2_0;
	FDataBits = 8;
	FComControl = ccNone;
	FMonitorEvents << evBreak << evCTS << evDSR << evError << evRing
								 << evRlsd << evRxChar << evTxEmpty;

	IBuffSize = 2048;
	OBuffSize = 4096;
	IBuffUsed = 0;
	OBuffUsed = 0;

	FRTS = false;
	FDTR = false;

	InitializeCriticalSection(&ReadABSection);

	rtEventAB = CreateEvent(NULL, FALSE, FALSE, NULL);// событие сбрасываемое автоматически
	wtEventAB = CreateEvent(NULL, TRUE, FALSE, NULL);  //----- событие сбрасываемое вручную
	reEventAB = CreateEvent(NULL, FALSE, FALSE, NULL);//-событие сбрасываемое автоматически
	seEventAB = CreateEvent(NULL, FALSE, FALSE, NULL);// событие сбрасываемое автоматически
	Status = 0;
}

//---------------------------------------------------------------------------
__fastcall TCommPortAB::~TCommPortAB(void)
{
	ClosePort();
	CloseHandle(seEventAB);
	CloseHandle(reEventAB);
	CloseHandle(wtEventAB);
	CloseHandle(rtEventAB);
	DeleteCriticalSection(&ReadABSection);
}

//---------------------------------------------------------------------------
bool __fastcall TCommPortAB::IsEnabled(void)
{
	return( FComHandle != INVALID_HANDLE_VALUE );
}

//---------------------------------------------------------------------------
int __fastcall TCommPortAB::GetOutQueCount(void)
{
	DWORD lpErrors;
	COMSTAT lpStat;
	int Result = 0;
	if( IsEnabled())
	{
		ClearCommError( FComHandle, &lpErrors, &lpStat );
		Result = lpStat.cbOutQue;
	}
	return(Result);
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::OpenPort(void)
{
	if( FOpen )  return;

	IBuffUsed = 0;
	OBuffUsed = 0;
	N_OSTAT = 0;
  ZeroMemory(OSTATOK,sizeof(OSTATOK));
	OBuffer = new unsigned char[OBuffSize];
	IBuffer = new unsigned char[IBuffSize];
	SetLastError(0); //remove any pending errors

	DeviceName = AnsiString("\\\\.\\COM") + IntToStr(FComNumber);
	FComHandle = CreateFile( DeviceName.c_str(),
													 GENERIC_READ | GENERIC_WRITE,
													 0, NULL,
													 OPEN_EXISTING,
													 FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, 0);
	if( IsEnabled() )
	{
		COMMTIMEOUTS CommTimeOuts;
		SetupComm( FComHandle,IBuffSize,OBuffSize );// установить размеры буферов ввода/вывода

		ZeroMemory( &CommTimeOuts, sizeof(COMMTIMEOUTS) );
		CommTimeOuts.ReadIntervalTimeout = 5;
		CommTimeOuts.ReadTotalTimeoutMultiplier = 15;
		CommTimeOuts.ReadTotalTimeoutConstant = 5;
		CommTimeOuts.WriteTotalTimeoutMultiplier = 15;
		CommTimeOuts.WriteTotalTimeoutConstant = 5;
		SetCommTimeouts( FComHandle, &CommTimeOuts );

		Potoks = 0;
		SetComControl(FComControl);
		SetBaudRate(FBaudRate);
		SetParity(FParity);
		SetStopBits(FStopBits);
		SetDataBits(FDataBits);

		StatusThreadAB = new TStatusThreadAB( this, FMonitorEvents );
		StatusThreadAB->Name = "CommStatusThread";

		ResetEvent(rtEventAB);
		ReadThreadAB = new TReadThreadAB( this );
		ReadThreadAB->Name = "CommReadThread";

		ResetEvent(reEventAB);
		ReadEventThreadAB = new TReadEventThreadAB( this );
		ReadEventThreadAB->Name = "CommReadEventThreadAB";

		ResetEvent(seEventAB);
		StatusEventThreadAB = new TStatusEventThreadAB( this );
		StatusEventThreadAB->Name = "CommStatusEventThreadAB";

		FOpen = true;

		SetDTR(FDTR);
		GotovWrite = true;

		if( FOnOpen )  FOnOpen( this, GetLastError() );
	}else{
		Application->MessageBox("Не могу открыть COM-порт ", "COM-порт ошибка", MB_OK | MB_ICONSTOP );
	}
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::ClosePort(void)
{
	if( !FOpen )   return;

		SetCommMask(ComHandle,0);
		FCTS  = False;
		FDSR  = False;
		FDCD  = False;
		FRing = False;

		StatusThreadAB->Terminate();
		ResetEvent(StatusThreadAB->SOL.hEvent);
		SetCommMask(FComHandle, 0);
		StatusThreadAB->WaitFor();
		delete StatusThreadAB;
		StatusThreadAB = NULL;

		ReadThreadAB->Terminate();
		ResetEvent(ReadThreadAB->ROL.hEvent);
		SetEvent(rtEventAB);
		ReadThreadAB->WaitFor();
		delete ReadThreadAB;
		ReadThreadAB = NULL;

		ReadEventThreadAB->Terminate();
		SetEvent(reEventAB);
		ReadEventThreadAB->WaitFor();
		delete ReadEventThreadAB;
		ReadEventThreadAB = NULL;

		StatusEventThreadAB->Terminate();
		SetEvent(seEventAB);
		StatusEventThreadAB->WaitFor();
		delete StatusEventThreadAB;
		StatusEventThreadAB = NULL;

		CloseHandle(FComHandle);
		FComHandle = INVALID_HANDLE_VALUE;

		delete [] IBuffer;
		delete [] OBuffer;
		IBuffer = NULL;
		OBuffer = NULL;
		IBuffUsed = 0;
		OBuffUsed = 0;

		FOpen = false;

	if( FOnClose )  FOnClose( this );
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetComNumber(int n)
{
	Open = false;
	FComNumber = n;
}
//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetIBuffSize( DWORD _size )
{
	bool tmp = Open;
	Open = false;
	IBuffSize = _size;
	Open = tmp;
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetOBuffSize( DWORD _size )
{
	bool tmp = Open;
	Open = false;
	OBuffSize = _size;
	Open = tmp;
}
 //---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetPackSize( DWORD _size )
{
	bool tmp = Open;
	Open = false;
	PacketSize = _size;
	Open = tmp;
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPortAB::GetInBuffUsed(void)
{
	return( IBuffUsed );
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPortAB::GetInBuffFree(void)
{
	EnterCriticalSection( &ReadABSection );
	int Result = IBuffSize - IBuffUsed;
	LeaveCriticalSection( &ReadABSection );
	return( Result );
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPortAB::GetOutBuffUsed(void)
{
	return( OBuffUsed );
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetOpen( bool o )
{
	if(FOpen ==o) return;
	if (o) OpenPort();
	else ClosePort();
}

//========================================================================================
bool __fastcall TCommPortAB::CharReady(void)
{
	return( IBuffUsed > 0 );
}
//========================================================================================
char __fastcall TCommPortAB::GetChar(void)
{
	char Result = 0;
	if( IBuffUsed > 0 ) GetBlock( &Result,1);
	return( Result );
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::PutChar( char ch)
{
	PutBlock( &ch, 1 );
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::PutString( char *s )
{
  int l = strlen(s);
  if( l > 0 )  PutBlock( s, l );
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SendBreak( WORD Ticks )
{
	if(IsEnabled())SetBreak(true);
	Sleep( Ticks * 55 );
	if(IsEnabled())SetBreak(false);
}

//========================================================================================
int __fastcall TCommPortAB::PutBlock( char *Buf, DWORD Count )
{
	bool good;
	DWORD OK;
	try
	{
		if( !IsEnabled() )  return(0); //--------------------------------- если хэндла нет выйти
		if(Count == 0 )return(0);
		GotovWrite = false;
		CopyMemory(OBuffer, Buf,Count);
		COMSTAT lpStat; //----------------------------- объявить структуру состояния COM-порта
		DWORD lpErrors;
		DWORD BytesWritten = 0; //--------------- готовим число реально записанных байт в порт
		OVERLAPPED WolAB;
		ZeroMemory(&WolAB,sizeof(WolAB));
		WolAB.hEvent = CreateEvent( NULL, true, false, NULL );
		good = WriteFile(FComHandle,OBuffer,Count,&BytesWritten,&WolAB);
		if(good) OK = good;
		else OK = WaitForSingleObject(WolAB.hEvent,200);
		if(!good)
		if((OK == WAIT_OBJECT_0)&& GetOverlappedResult(FComHandle,&WolAB,&BytesWritten,true))
		{
			if(BytesWritten == Count)good = true;
		}
		else
		{
			int ErrorPort = GetLastError();
		}
		ResetEvent(WolAB.hEvent); //-----------------------------------------  сбросить Event
		CloseHandle(WolAB.hEvent);
		GotovWrite = true;
		if(good)return(Count);
		else return(0);
	}
	catch (...)
	{
		Application->MessageBox("ОШИБКА","COMPortAB",MB_OK);
		return(0);
	}
}
//========================================================================================
int __fastcall TCommPortAB::GetBlock( unsigned char *Buf, DWORD Count )
{
	if(!IsEnabled())return(0); //------------------------ если порт имеет правильный "Хэндл"
	if(IBuffUsed == 0) return(0); //-------------- если нет используемых байт в буфере ввода

	EnterCriticalSection(&ReadABSection); //---------------- войти в критическую секцию чтения
	DWORD used = IBuffUsed; //-------- получить число байт, вновь поступивших в буфере ввода
	DWORD pos1 = IBuffPos; //---- позиция в буфере откуда начинаются вновь поступившие байты
	LeaveCriticalSection(&ReadABSection); //---------------------- покинуть критическую секцию

	DWORD pos2 = pos1 + used; //------------------ получить указатель на конец принятых байт

	DWORD size1;
	DWORD size2 = 0;

	if( pos2 < IBuffSize ) //---------- если конец принятых байт находится в пределах буфера
	{
		size1 = pos2 - pos1; //---------------------------------- получить число принятых байт
		if(size1 > Count)size1 = Count; // принято больше, чем задано читать, размер по чтению
	}
	else //--------------------------- позиция конца принятых байт выходит за границу буфера
	{
		pos2 -= IBuffSize; //----------------------- переместить конец принятых байт по кольцу
		size1 = IBuffSize - pos1; //-- размер первого куска данных от начала приема до границы
		if( size1 > Count )size1 = Count; //-- если размер уже больше чем читать, то по чтению
		else
		{
			Count -= size1; //-------------------- иначе вычислить размер для оставшегося чтения
			size2 = pos2; //---------------------------- получить размер второго читаемого куска
			if( size2 > Count ) size2 = Count; //если этот кусок больше оставшегося куска чтения
		}
	}
	if( size1 > 0 )  CopyMemory( Buf, &IBuffer[pos1], size1 ); //--- копировать данные в Buf
	if( size2 > 0 )  CopyMemory( &Buf[size1], IBuffer, size2 );

	DWORD Result = size1 + size2;
	EnterCriticalSection(&ReadABSection);
	IBuffUsed -= Result; //---------------------- уменьшить число непрочитанных байт в порту
	IBuffPos += Result; //------------------------ переместить позицию конца нечитанных байт
	if( IBuffPos >= IBuffSize ) IBuffPos -= IBuffSize; //------------- переместить по кольцу
	LeaveCriticalSection(&ReadABSection);
	SetEvent(rtEventAB);//------ установить событие чтения из буфера порта в основной буфер
	return( Result );
}
//========================================================================================
void __fastcall TCommPortAB::SetComControl( TComControl Value )
{
  FComControl = Value;
	if(IsEnabled())
	{
		GetCommState(FComHandle,&FDCB);
		DWORD flags = DCB_BINARY;
		switch(FComControl)
		{
			case ccSoft: flags |= SOFT_FLOW;  break;
			case ccHard: flags |= HARD_FLOW;  break;
		}
		DWORD *tmp = (DWORD *)(&FDCB);
		tmp[2] = flags;
		SetCommState(FComHandle, &FDCB);
	}
}
//========================================================================================
//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetBaudRate( TBaudRate Value )
{
	int CBR[15] =
	{
		CBR_110,CBR_300,CBR_600,CBR_1200,CBR_2400,CBR_4800,CBR_9600,CBR_14400,
		CBR_19200,CBR_38400,CBR_56000,CBR_57600,CBR_115200,CBR_128000,CBR_256000
	};

  FBaudRate = Value;
	if(IsEnabled())
	{
		GetCommState( FComHandle, &FDCB );
		FDCB.BaudRate = CBR[FBaudRate];
		SetCommState(FComHandle, &FDCB);
	}
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetParity( TParity Value )
{
	char PAR[5] = {NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY};
	FParity = Value;
  if( IsEnabled() ){
    GetCommState( FComHandle, &FDCB );
		FDCB.Parity = PAR[FParity] ;
    SetCommState( FComHandle, &FDCB );
  }
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetStopBits( TStopBits Value )
{
  char STB[3] = {ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS};

  FStopBits = Value;
  if( IsEnabled() ){
    GetCommState(FComHandle, &FDCB);
    FDCB.StopBits = STB[FStopBits];
    SetCommState(FComHandle, &FDCB);
  }

  BitsWarning();
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetDataBits( TDataBits Value )
{
  if( Value < 5 || Value > 8 )  Value = 8;

  FDataBits = Value;
  if( IsEnabled() ){
    GetCommState(FComHandle, &FDCB);
    FDCB.ByteSize = Value;
    SetCommState(FComHandle, &FDCB);
  }

  BitsWarning();
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::BitsWarning(void)
{
  if( FDataBits != 5 ){
    if( FStopBits == sb1_5 )
      Application->MessageBox("Invalid combination (6,7 or 8 data bits with 1.5 stop bits)",
                              "COM port warning", MB_OK | MB_ICONWARNING );
  }else{
    if( FStopBits == sb2_0 )
      Application->MessageBox("Invalid combination (5 data bits with 2 stop bits)",
															"COM port warning", MB_OK | MB_ICONWARNING );
	}
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetBaud( int B )
{
	switch( B ){
		case 110     : BaudRate = cbr110;    break;
		case 300     : BaudRate = cbr300;    break;
		case 600     : BaudRate = cbr600;    break;
		case 1200    : BaudRate = cbr1200;   break;
		case 2400    : BaudRate = cbr2400;   break;
		case 4800    : BaudRate = cbr4800;   break;
		case 9600    : BaudRate = cbr9600;   break;
		case 14400   : BaudRate = cbr14400;  break;
		case 19200   : BaudRate = cbr19200;  break;
		case 38400   : BaudRate = cbr38400;  break;
		case 56000   : BaudRate = cbr56000;  break;
		case 57600   : BaudRate = cbr57600;  break;
		case 115200  : BaudRate = cbr115200; break;
		case 128000  : BaudRate = cbr128000; break;
		case 256000  : BaudRate = cbr256000; break;
	}
}

//---------------------------------------------------------------------------
int __fastcall TCommPortAB::GetBaud(void)
{
  int result = 0;
  switch( BaudRate ){
    case cbr110     : result = 110;    break;
    case cbr300     : result = 300;    break;
    case cbr600     : result = 600;    break;
    case cbr1200    : result = 1200;   break;
    case cbr2400    : result = 2400;   break;
    case cbr4800    : result = 4800;   break;
    case cbr9600    : result = 9600;   break;
    case cbr14400   : result = 14400;  break;
    case cbr19200   : result = 19200;  break;
    case cbr38400   : result = 38400;  break;
    case cbr56000   : result = 56000;  break;
    case cbr57600   : result = 57600;  break;
    case cbr115200  : result = 115200; break;
    case cbr128000  : result = 128000; break;
    case cbr256000  : result = 256000; break;
  }
  return( result );
}
//========================================================================================
void __fastcall TCommPortAB::FlushInBuffer(void)
{
	if( IsEnabled())
	{
		PurgeComm(FComHandle, PURGE_RXABORT | PURGE_RXCLEAR );
	}
	EnterCriticalSection(&ReadABSection);
	IBuffUsed = 0;
	LeaveCriticalSection(&ReadABSection);
}
//========================================================================================
void __fastcall TCommPortAB::FlushOutBuffer(void)
{
	if( IsEnabled())
	{
		PurgeComm( FComHandle, PURGE_TXABORT | PURGE_TXCLEAR );
	}
	OBuffUsed = 0;
}
//========================================================================================
void __fastcall TCommPortAB::PowerOn(void)
{
  EscapeCommFunction( FComHandle, SETDTR );
  EscapeCommFunction( FComHandle, SETRTS );
  FRTS = true;
  FDTR = true;
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::PowerOff(void)
{
  EscapeCommFunction( FComHandle, CLRDTR );
  EscapeCommFunction( FComHandle, CLRRTS );
  FRTS = false;
  FDTR = false;
}

//---------------------------------------------------------------------------
void __fastcall TCommPortAB::SetDTR( bool State )
{
	if( FOpen ){
    if( EscapeCommFunction( FComHandle, State ? SETDTR : CLRDTR ) ){
      FDTR = State;
    }
  }else{
    FDTR = State;
  }
}

//---------------------------------------------------------------------------
bool __fastcall TCommPortAB::SetBreak( bool State )
{
  bool Result = false;
	if( FOpen )
	Result = EscapeCommFunction( FComHandle, State ? SETBREAK : CLRBREAK );
	return( Result );
}

//---------------------------------------------------------------------------
