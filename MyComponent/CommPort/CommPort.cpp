#include <vcl.h>
#pragma hdrstop
#include "CommPort.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//

static inline void ValidCtrCheck(TCommPort *)
{
	new TCommPort(NULL);
}

//---------------------------------------------------------------------------
namespace Commport
{
	void __fastcall PACKAGE Register()
	{
		TComponentClass classes[1] = {__classid(TCommPort)};
		RegisterComponents("RPCcomp", classes, 0);
	}
}
//---------------------------------------------------------------------------
__fastcall TCommPort::TCommPort(TComponent* Owner) : TComponent(Owner)
{
  FComHandle = INVALID_HANDLE_VALUE;
	FComNumber = 2;
	FBaudRate = cbr1200;
	FParity = paNone;
	FStopBits = sb2_0;
	FDataBits = 7;
	FComControl = ccNone;
  FMonitorEvents << evBreak << evCTS << evDSR << evError << evRing
                 << evRlsd << evRxChar << evTxEmpty;

  IBuffSize = 2048;
  OBuffSize = 4096;
  IBuffUsed = 0;
  OBuffUsed = 0;

  FRTS = false;
  FDTR = false;

  InitializeCriticalSection(&WriteSection);
  InitializeCriticalSection(&ReadSection);
  rtEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
  wtEvent = CreateEvent(NULL, TRUE, FALSE, NULL);
  reEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
  seEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

  Status = 0;
}

//---------------------------------------------------------------------------
__fastcall TCommPort::~TCommPort(void)
{
  ClosePort();
  CloseHandle(seEvent);
  CloseHandle(reEvent);
  CloseHandle(wtEvent);
  CloseHandle(rtEvent);
  DeleteCriticalSection(&ReadSection);
  DeleteCriticalSection(&WriteSection);
}

//---------------------------------------------------------------------------
bool __fastcall TCommPort::IsEnabled(void)
{
  return( FComHandle != INVALID_HANDLE_VALUE );
}

//---------------------------------------------------------------------------
int __fastcall TCommPort::GetOutQueCount(void)
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
void __fastcall TCommPort::OpenPort(void)
{
	if( FOpen )  return;

	IBuffUsed = 0;
	OBuffUsed = 0;

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

		StatusThread = new TStatusThread( this, FMonitorEvents );
		StatusThread->Name = "CommStatusThread";

		ResetEvent(rtEvent);
		ReadThread = new TReadThread( this );
		ReadThread->Name = "CommReadThread";

		ResetEvent(wtEvent);
		WriteThread = new TWriteThread( this );
		WriteThread->Name = "CommWriteThread";

		ResetEvent(reEvent);
		ReadEventThread = new TReadEventThread( this );
		ReadEventThread->Name = "CommReadEventThread";

		ResetEvent(seEvent);
		StatusEventThread = new TStatusEventThread( this );
    StatusEventThread->Name = "CommStatusEventThread";

		FOpen = true;

    SetDTR(FDTR);

    if( FOnOpen )  FOnOpen( this, GetLastError() );
  }else{
    Application->MessageBox("Не могу открыть COM-порт ", "COM-порт ошибка", MB_OK | MB_ICONSTOP );
  }
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::ClosePort(void)
{
	if( !FOpen )   return;

    SetCommMask(ComHandle,0);
    FCTS  = False;
    FDSR  = False;
    FDCD  = False;
    FRing = False;

    StatusThread->Terminate();
    ResetEvent(StatusThread->SOL.hEvent);
    SetCommMask(FComHandle, 0);
    StatusThread->WaitFor();
    delete StatusThread;
    StatusThread = NULL;

    ReadThread->Terminate();
    ResetEvent(ReadThread->ROL.hEvent);
    SetEvent(rtEvent);
    ReadThread->WaitFor();
    delete ReadThread;
    ReadThread = NULL;

    WriteThread->Terminate();
    ResetEvent(WriteThread->WOL.hEvent);
    SetEvent(wtEvent);
    WriteThread->WaitFor();
    delete WriteThread;
    WriteThread = NULL;

    
    ReadEventThread->Terminate();
    SetEvent(reEvent);
    ReadEventThread->WaitFor();
    delete ReadEventThread;
    ReadEventThread = NULL;

    StatusEventThread->Terminate();
    SetEvent(seEvent);
    StatusEventThread->WaitFor();
    delete StatusEventThread;
    StatusEventThread = NULL;

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
void __fastcall TCommPort::SetComNumber( int n )
{
  Open = false;
  FComNumber = n;
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::SetIBuffSize( DWORD _size )
{
  bool tmp = Open;
  Open = false;
  IBuffSize = _size;
  Open = tmp;
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::SetOBuffSize( DWORD _size )
{
  bool tmp = Open;
	Open = false;
	OBuffSize = _size;
	Open = tmp;
}
 //---------------------------------------------------------------------------
void __fastcall TCommPort::SetPackSize( DWORD _size )
{
	bool tmp = Open;
	Open = false;
	PacketSize = _size;
	Open = tmp;
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPort::GetInBuffUsed(void)
{
  return( IBuffUsed );
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPort::GetInBuffFree(void)
{
  EnterCriticalSection( &ReadSection );
  int Result = IBuffSize - IBuffUsed;
  LeaveCriticalSection( &ReadSection );
  return( Result );
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPort::GetOutBuffUsed(void)
{
	return( OBuffUsed );
}

//---------------------------------------------------------------------------
DWORD __fastcall TCommPort::GetOutBuffFree(void)
{
  EnterCriticalSection( &WriteSection );
  int Result = OBuffSize - OBuffUsed;
  LeaveCriticalSection( &WriteSection );
  return( Result );
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::SetOpen( bool o )
{
	if(FOpen ==o) return;
	if (o) OpenPort();
	else ClosePort();
}

//========================================================================================
bool __fastcall TCommPort::CharReady(void)
{
	return( IBuffUsed > 0 );
}
//========================================================================================
char __fastcall TCommPort::GetChar(void)
{
	char Result = 0;
	if( IBuffUsed > 0 ) GetBlock( &Result,1);
	return( Result );
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::PutChar( char ch)
{
  PutBlock( &ch, 1 );
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::PutString( char *s )
{
  int l = strlen(s);
  if( l > 0 )  PutBlock( s, l );
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::SendBreak( WORD Ticks )
{
	if(IsEnabled())SetBreak(true);
	Sleep( Ticks * 55 );
	if(IsEnabled())SetBreak(false);
}

//========================================================================================
int __fastcall TCommPort::PutBlock( char *Buf, DWORD Count )
{
	try
  {
		if( !IsEnabled() )  return(0); //--------------------------------- если хэндла нет выйти
		EnterCriticalSection(&WriteSection); //--------------- войти в критическую секцию записи
		DWORD used = OBuffUsed; //----------------------------- число непереданных байт в буфере
		DWORD pos1 = OBuffPos; //---------------------------------- позиция начала непереданного
		LeaveCriticalSection(&WriteSection); //-------------- покинуть критическую секцию записи

		DWORD pos2 = pos1 + used; //--------------------- новая позиция начала непереданных байт

		DWORD size1;
  	DWORD size2 = 0;

		if(pos2 < OBuffSize) // новая позиция начала не переданных байт в пределах границ буфера
		{
			size1 = OBuffSize - pos2; //------------------ размер первой части данных для передачи
			if( size1 > Count ) //----------- если размер первой части больше назначенной передачи
			{
				size1 = Count; //------------------------- размер ограничить затребованным значением
			}
			else
			{
				Count -= size1; //если размер первой части меньше затребованного значения, то вторая
				size2 = pos1;   //часть добавляется по кольцу
				if( size2 > Count )  size2 = Count; //--- если вторая часть велика, то ограничить ее
			}
		}
		else
		{
			pos2 -= OBuffSize;
			size1 = pos1 - pos2;
			if( size1 > Count )  size1 = Count;
		}
		if( size1 > 0 ) CopyMemory( &OBuffer[pos2], Buf, size1 );
		if( size2 > 0 ) CopyMemory( OBuffer, &Buf[size1], size2 );
		DWORD Result = size1 + size2;
		OBuffUsed += Result;
		if( Result )  SetEvent(wtEvent);
		return( Result );
	}
  catch(...)
	{
		return(0);
	}
}
//========================================================================================
int __fastcall TCommPort::GetBlock( unsigned char *Buf, DWORD Count )
{
	if(!IsEnabled())return(0); //------------------------ если порт имеет правильный "Хэндл"
	if(IBuffUsed == 0) return(0); //-------------- если нет используемых байт в буфере ввода

	EnterCriticalSection(&ReadSection); //---------------- войти в критическую секцию чтения
	DWORD used = IBuffUsed; //-------- получить число байт, вновь поступивших в буфере ввода
	DWORD pos1 = IBuffPos; //---- позиция в буфере откуда начинаются вновь поступившие байты
	LeaveCriticalSection(&ReadSection); //---------------------- покинуть критическую секцию

	DWORD pos2 = pos1 + used; //--------------------- получить указатель конца принятых байт

	DWORD size1;
	DWORD size2 = 0;

	if( pos2 < IBuffSize ) //---------- если число принятых байт находится в пределах буфера
	{
		size1 = pos2 - pos1; //---------------------------------- получить число принятых байт
		if( size1 > Count )  size1 = Count; //- принято больше, чем читается, размер по чтению
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
	if( size1 > 0 )  CopyMemory( Buf, &IBuffer[pos1], size1 ); //-- переместить данные в Buf
	if( size2 > 0 )  CopyMemory( &Buf[size1], IBuffer, size2 );

	DWORD Result = size1 + size2;
  EnterCriticalSection(&ReadSection);
	IBuffUsed -= Result;
	IBuffPos += Result;
	if( IBuffPos >= IBuffSize )  IBuffPos -= IBuffSize;
	LeaveCriticalSection(&ReadSection);
	SetEvent(rtEvent);//--------- установить событие чтения из буфера порта в основной буфер
  if (Result>79) Result = 79;
	return( Result );
}
//========================================================================================
void __fastcall TCommPort::SetComControl( TComControl Value )
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
void __fastcall TCommPort::SetBaudRate( TBaudRate Value )
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
void __fastcall TCommPort::SetParity( TParity Value )
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
void __fastcall TCommPort::SetStopBits( TStopBits Value )
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
void __fastcall TCommPort::SetDataBits( TDataBits Value )
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
void __fastcall TCommPort::BitsWarning(void)
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
void __fastcall TCommPort::SetBaud( int B )
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
int __fastcall TCommPort::GetBaud(void)
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
void __fastcall TCommPort::FlushInBuffer(void)
{
	if( IsEnabled())
	{
		PurgeComm(FComHandle, PURGE_RXABORT | PURGE_RXCLEAR );
	}
	EnterCriticalSection(&ReadSection);
	IBuffUsed = 0;
	LeaveCriticalSection(&ReadSection);
}
//========================================================================================
void __fastcall TCommPort::FlushOutBuffer(void)
{
	if( IsEnabled())
	{
		PurgeComm( FComHandle, PURGE_TXABORT | PURGE_TXCLEAR );
	}
	EnterCriticalSection(&WriteSection);
	ResetEvent(wtEvent);
	OBuffUsed = 0;
	LeaveCriticalSection(&WriteSection);
}
//========================================================================================
void __fastcall TCommPort::PowerOn(void)
{
  EscapeCommFunction( FComHandle, SETDTR );
  EscapeCommFunction( FComHandle, SETRTS );
  FRTS = true;
  FDTR = true;
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::PowerOff(void)
{
  EscapeCommFunction( FComHandle, CLRDTR );
  EscapeCommFunction( FComHandle, CLRRTS );
  FRTS = false;
  FDTR = false;
}

//---------------------------------------------------------------------------
void __fastcall TCommPort::SetDTR( bool State )
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
bool __fastcall TCommPort::SetBreak( bool State )
{
  bool Result = false;
	if( FOpen )
	Result = EscapeCommFunction( FComHandle, State ? SETBREAK : CLRBREAK );
	return( Result );
}

//---------------------------------------------------------------------------
