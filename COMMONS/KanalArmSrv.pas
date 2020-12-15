unit KanalArmSrv;
{$INCLUDE CfgProject}  // ��������� ����������
//****************************************************************************
//
//       ��������� ������ � ������� ������ - �� ���
//
//****************************************************************************


interface

uses
  Windows, Dialogs, SysUtils, Controls, Classes, Messages, Graphics, Forms, StdCtrls, Registry, SyncObjs, comport;


type TKanalErrors = (keOk,keErrCRC,keErrSrc,keErrDst);

const
  RCV_LIMIT = 4096;

type TKanal = record
    State   : Byte;
    config  : string;
    Index   : Byte;
    port    : TComPort;
    hPipe   : cardinal; // ������������� �����
    nPipe   : string;   // ��� �����
    active  : Boolean;
    rcvsoob : string;   // ������ ��������� ������
    RcvBuf  : array[0..RCV_LIMIT-1] of char;
    RcvPtr  : word;     // ��������� �� ����� �������� ������
    isrcv   : boolean;
    issync  : boolean;
    iserror : boolean;
    cnterr  : integer;
    rcvcnt  : integer; // ������� ���������� �������� ��������
    pktcnt  : integer; // ������� ���������� �������� �������
    chklost : integer; // ������� ���������� ���������
    pktlost : integer; // ������� ���������� �������
    lastcnt : integer; // ������� ���������� �������� ���� ��� ��������� ������ ������
    lostcnt : integer; // ������� ���������� �������� ������ ������ �� ������
  end;

const

PIPE_READING_SUCCESS = 1;
PIPE_WRITING_SUCCESS = 2;
PIPE_ERROR_STATE     = 3;
PIPE_EXIT            = 4;

  LnSoobSrv  : integer = 70;    // ����� ��������� �� �������

var
  AnsverTimeOut    : Double; // �������� ����������� ������������� ������� ������� ������ ���-������ ����� ������ �������
  MaxTimeOutRecave : Double; // �������� ����������� ������������� ������� �������� ������ � FR3 �� ������ �������� ����������� (������������� ������)
  NewFR            : array[1..2] of string;     // ����� ������� ��� ������
  NewCmd           : array[1..2] of string;     // ����� ��������� ��������� � ������ ��� ������
  NewMenuC         : string;                    // ����� ������ ����, �������������� ����������
  NewMsg           : string;                    // ����� ��������� �� ������ FR3
  BackCRC          : array[1..20,1..2] of WORD; // ����� ���������
  LastCRC          : array[1..2] of Byte;       // ��������� �� ��������� ���������
  LastSrv          : array[1..2] of Byte;       // ����� �������������� �������
  CmdCnt           : Byte;                      // ������� ������ ����������� ����������, ������� � ��������
  DoubleCnt        : Byte;                      // ������� ���������� Double ������� � �������� �� ������
  MySync           : array[1..2] of Boolean;    // ������� ��������� ������������� �� ������ ������
  MainLoopState    : Byte;                      // ������ ��������� ��������� ��������� ����

//  trmkvit : string; // ��������� �� �������� � ������
//  rcvkvit : string; // ��������� �� ������


const
  FR_LIMIT = 4096;

//------------------------------------------------------------------------------
//                  ������ �������� �� ������ ������ - ���
//------------------------------------------------------------------------------
var
  FR3    : array[1..FR_LIMIT] of Byte;      // ����� ������� ���������
  FR3inp : array[1..FR_LIMIT] of Char;      // ����� ������ FR3
  FR3s   : array[1..FR_LIMIT] of TDateTime; // ����������� ������ FR3

//------------------------------------------------------------------------------
//                 ������ �����������, ���������� �� �������
//------------------------------------------------------------------------------
var
  FR4    : array[1..FR_LIMIT] of Byte;      // ����� ������� ���������
  FR4inp : array[1..FR_LIMIT] of Char;      // ����� ������ FR4
  FR4s   : array[1..FR_LIMIT] of TDateTime; // ����������� ������ FR4

//------------------------------------------------------------------------------
//                         ������ ��������� �����������
//------------------------------------------------------------------------------
var
  FR5    : array[1..FR_LIMIT] of Byte;      // ����� �����������

//------------------------------------------------------------------------------
//                        ������ ����������� ����������
//------------------------------------------------------------------------------
var
  FR6 : array[1..1024] of Word;

//------------------------------------------------------------------------------
//                      ������ �������������� ����������
//------------------------------------------------------------------------------
var
  FR7 : array[1..1024] of Cardinal;

//------------------------------------------------------------------------------
//                      ������ ������������� ����������
//------------------------------------------------------------------------------
var
  FR8 : array[1..1024] of int64;

var
  ArchName  : string;   // ��� ����� ������ (��� ����)
  ArcIndex  : cardinal; // ������ ������ � ������
  KanalSrv  : array[1..2] of TKanal;
  KanalType : Byte; // 0 - RS-422, 1- Pipes

  savearc  : boolean; // ���������� ������ ����������� ������ � �����
  chnl1    : string;  // ����� ������ �� 1 ������
  chnl2    : string;  // ����� ������ �� 2 ������

  LastDiagN : Byte; // ��������� ���������� ��������� ���������������� ���������
  LastDiagI : Word;
  LastDiagD : Double;

function CreateKanalSrv : Boolean;                // ������� ���������� ������ TComPort
function DestroyKanalSrv : Boolean;               // ���������� �������� ������
function GetKanalSrvStatus(kanal : Byte) : Byte;  // �������� ��������� ������
function InitKanalSrv(kanal : Byte) : Byte;       // ������������� ������
function ConnectKanalSrv(kanal : Byte) : Byte;    // ���������� ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte; // ������ ����� �� ������

function SyncReadyThread(var RdBuf: Pointer) : DWORD; // ��������� ������ ��������� ������� �����
function SyncReady : Boolean;
function GetFR5(param : Word) : Byte;
function GetFR4State(param : Word) : Boolean;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function ReadSoobCom(kanal: Byte; var rcv: string) : Integer; // ��������� ����� ������ ������ COM-ports
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;     // ��������� ������ ������ ������1 PIPEs
function ReadSoobPipe2(var RdBuf: Pointer) : DWORD;    // ��������� ������ ������ ������2 PIPEs
procedure WriteSoobCom(kanal: Byte);                   // ��������� �������� � ����� COM-ports
procedure WriteSoobPipe(kanal: Byte);                  // ��������� �������� � ����� PIPEs
function SaveArch(const c: byte) : Boolean;            // ��������� � ������ �������� ���������
function AddCheck(kanal : Byte; crc : Word) : Boolean; // �������� ����� ���������
function SendCheck(kanal : Byte; var crc : Word) : Boolean; // �������� ��������� ���������
procedure ExtractSoobSrv(kanal : Byte); // ���������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte); // ��������� ��������� �� �������
procedure SaveDUMP(buf,fname : string); // ���������� ��� - ������ �� ����
procedure SaveKanal;
procedure FixStatKanal(kanal : byte); // ��������� � ����� ��������� ���������� ������ ������

implementation

uses
  TabloForm,
  crccalc,
  commands,
  commons,
  mainloop,
  marshrut,
  VarStruct;

var
  OLS : TOverlapped;

var
lpNBWri     : Cardinal;
Buffer      : array[0..4097] of char;
RcvOLS      : array[1..2] of TOverlapped; // ��������� ���������� ������ ��� �����
TrmOLS      : array[1..2] of TOverlapped; // ��������� ���������� �������� ��� �����
WrBuffer    : array[0..4097] of char; // ����� ������ � �����
RcvComplete : array[1..2] of boolean;
TrmComplete : array[1..2] of boolean;
sz          : string;
stime       : string;
tbuf        : string;


//-----------------------------------------------------------------------------
// ������� ���������� ������ TComPort
function CreateKanalSrv : Boolean;
begin
  try
    RcvOLS[1].hEvent := INVALID_HANDLE_VALUE; TrmOLS[1].hEvent := INVALID_HANDLE_VALUE; KanalSrv[1].hPipe := INVALID_HANDLE_VALUE;
    RcvOLS[2].hEvent := INVALID_HANDLE_VALUE; TrmOLS[2].hEvent := INVALID_HANDLE_VALUE; KanalSrv[2].hPipe := INVALID_HANDLE_VALUE;
    if KanalSrv[1].Index > 0 then
    begin // ���������������� ����
      KanalSrv[1].port := TComPort.Create(nil);
    end else
    begin // �����1
      if (KanalSrv[1].nPipe <> '') and (KanalSrv[1].nPipe <> 'null') then
      begin
        RcvOLS[1].hEvent := CreateEvent(nil,true,true,nil);
        TrmOLS[1].hEvent := CreateEvent(nil,true,true,nil);
      end;
    end;

    if KanalSrv[2].Index > 0 then
    begin
      KanalSrv[2].port := TComPort.Create(nil);
    end else
    begin // �����2
      if (KanalSrv[2].nPipe <> '') and (KanalSrv[2].nPipe <> 'null') then
      begin
        RcvOLS[2].hEvent := CreateEvent(nil,true,true,nil);
        TrmOLS[2].hEvent := CreateEvent(nil,true,true,nil);
      end;
    end;

    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// ���������� �������� ������
function DestroyKanalSrv : Boolean;
begin
  try
    if Assigned(KanalSrv[1].port) then KanalSrv[1].port.Destroy else
    begin
      if CloseHandle(RcvOLS[1].hEvent) then RcvOLS[1].hEvent := INVALID_HANDLE_VALUE;
      if CloseHandle(TrmOLS[1].hEvent) then TrmOLS[1].hEvent := INVALID_HANDLE_VALUE;
    end;
    if Assigned(KanalSrv[2].port) then KanalSrv[2].port.Destroy else
    begin
      if CloseHandle(RcvOLS[2].hEvent) then RcvOLS[2].hEvent := INVALID_HANDLE_VALUE;
      if CloseHandle(TrmOLS[2].hEvent) then TrmOLS[2].hEvent := INVALID_HANDLE_VALUE;
    end;
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// �������� ��������� ������
function GetKanalSrvStatus(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
    result := 255
  else
    result := 0;
end;

//-----------------------------------------------------------------------------
// ������������� ������
function InitKanalSrv(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ 255 ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  if Assigned(KanalSrv[kanal].port) then
  begin // ���-����
    if KanalSrv[kanal].port.InitPort(IntToStr(KanalSrv[kanal].Index)+ ','+ KanalSrv[kanal].config) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('������ 254 ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 254;
    end;
  end else
  if KanalSrv[kanal].nPipe = 'null' then result := 0 else
  begin // �����
    if KanalSrv[kanal].nPipe <> '' then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� ������������� ������������ ������'+ IntToStr(kanal)+ ' '+ stime);
    end;
    result := 0;
  end;
end;

//-----------------------------------------------------------------------------
// ���������� ����� �� ������
function ConnectKanalSrv(kanal : Byte) : Byte;
  var Dummy : ULONG; th : THandle;
begin
try
  if (kanal < 1) or (kanal > 2) or (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  KanalSrv[kanal].RcvPtr := 0;
  if Assigned(KanalSrv[kanal].port) then
  begin // ���-����
    if KanalSrv[kanal].port.PortIsOpen then
    begin
      KanalSrv[kanal].active := true; result := 0;
    end else
    if KanalSrv[kanal].port.OpenPort then
    begin
      PurgeComm(KanalSrv[kanal].port.PortHandle,PURGE_TXABORT+PURGE_RXABORT+PURGE_TXCLEAR+PURGE_RXCLEAR);
      KanalSrv[kanal].active := true;
      KanalSrv[kanal].hPipe := KanalSrv[kanal].port.PortHandle;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('�� ������� ������� ���������������� ���� ������'+ IntToStr(kanal)+ ' '+ stime);
    end;
  end else
  if (KanalSrv[kanal].nPipe <> '') and (KanalSrv[kanal].nPipe <> 'null') then
  begin // �����
    KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE;
    KanalSrv[kanal].State := 0; // ��������� ������ �� �����, ��������� ��������� � ���������
    KanalSrv[kanal].active := false;
    KanalSrv[kanal].hPipe := CreateFile(
      pchar(KanalSrv[kanal].nPipe),
      GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil,                    // �������� �������� �����������
      OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED,
      0);
    if KanalSrv[kanal].hPipe = INVALID_HANDLE_VALUE then
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('�� ������� ������� ����� ������'+ IntToStr(kanal)+ ' (��� ������ '+IntToStr(GetLastError()) +') '+ stime);
    end else
    begin
      KanalSrv[kanal].State := 0; // ��������� ������ �� �����, ��������� ��������� � ���������
      th := INVALID_HANDLE_VALUE;
      case kanal of
        1 : th := CreateThread(nil,0,@ReadSoobPipe,nil,0,Dummy); // ������ ������������ ������ �����1
        2 : th := CreateThread(nil,0,@ReadSoobPipe2,nil,0,Dummy); // ������ ������������ ������ �����2
      end;
      if th <> INVALID_HANDLE_VALUE then
      begin
        SetThreadPriority(th,THREAD_PRIORITY_TIME_CRITICAL);
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('��������� ����������� � ������� �� ������ '+ KanalSrv[kanal].nPipe + ' '+ stime);
        KanalSrv[kanal].active := true;
        result := 0;
      end else
        result := 254;
    end;
  end else
  begin
    KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE;
    result := 1;
  end;
except
  reportf('������ [KanalArmSrv.ConnectKanalSrv]'); Application.Terminate; result := 253;
end;
end;

//-----------------------------------------------------------------------------
// ������ ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte;
begin
try
  if (kanal < 1) or (kanal > 2) or (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  if Assigned(KanalSrv[kanal].port) then
  begin // COM-����
    if KanalSrv[kanal].port.PortIsOpen then
    begin
      if KanalSrv[kanal].port.ClosePort then
      begin
        KanalSrv[kanal].active := false;
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('���������������� ���� ������'+ IntToStr(kanal)+ ' '+ stime+ ' ������');
        result := 0;
      end else
        result := 253;
    end else
      result := 0;
  end else
  if (KanalSrv[kanal].nPipe <> '') and (KanalSrv[kanal].nPipe <> 'null') then
  begin // �����
    if KanalSrv[kanal].hPipe = INVALID_HANDLE_VALUE then begin result := 0; exit; end else
    if CloseHandle(KanalSrv[kanal].hPipe) then begin result := 0; KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE; end else result := 253;
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('�������� ����� ������ � �������� '+ KanalSrv[kanal].nPipe+ ' '+ stime);
    KanalSrv[kanal].State := PIPE_EXIT;
    KanalSrv[kanal].active := false;
  end else
    result := 0;
except
  reportf('������ [KanalArmSrv.DisconnectKanalSrv]'); Application.Terminate; result := 252;
end;
end;


//-----------------------------------------------------------------------------
// ��������� ������ ���������� ������, �������� ������������� �� �������

function SyncReadyThread(var RdBuf: Pointer) : DWORD; // ��������� ������ ��������� ������� �����
begin
try
  while LoopSync do begin SyncReady; WaitForSingleObject(hWaitKanal,20); end;
  ExitThread(0); result := 0;
except
  reportf('������ [KanalArmSrv.SyncReadyThread]'); Application.Terminate; ExitThread(99); result := 99;
end;
end;

var
  FixedDisconnect : array[1..2] of Boolean;
  FixedConnect : array[1..2] of Boolean;
  FDT : double;


function SyncReady : Boolean;
  var i,j : integer;
begin
try
  result := false;
  if AppStart then exit; // �� ��������� ������������� �� ������������ ����� ���-������

  case KanalType of
    //
    // ��� ������ � �������� ������������ ��� ������ RS-422 � ���������� ������.
    // ������ �� ����� ����������, ������������ �� ���������� ������.
    //
    0 : begin
      if KanalSrv[1].active then
      begin
        i := ReadSoobCom(1,sz);
        KanalSrv[1].lastcnt := i;
        KanalSrv[1].rcvcnt := KanalSrv[1].rcvcnt + i;
        if i > 0 then // ��������� ������ �� ������1
        begin
          if not FixedConnect[1] then
          begin // ������������� �������������� ����� � ��������
            AddFixMessage(GetShortMsg(1,434,'1'),5,0); InsArcNewMsg(0,434+$2000);
          end;
          FixedConnect[1] := true;
          if i >= 70 then begin inc(KanalSrv[1].cnterr); KanalSrv[1].lostcnt := 0; end;
          KanalSrv[1].isrcv := true;
          if KanalSrv[1].RcvPtr < 140 then KanalSrv[1].iserror := false;

          if (i + KanalSrv[1].RcvPtr) > sizeof(KanalSrv[1].RcvBuf) then i := 0;
          for j := 0 to i-1 do
          begin
            KanalSrv[1].RcvBuf[KanalSrv[1].RcvPtr] := KanalSrv[1].port.Buffer[j]; inc(KanalSrv[1].RcvPtr);
          end;
          if KanalSrv[1].RcvPtr > LnSoobSrv * 5 then
          begin
            inc(KanalSrv[1].cnterr); // ��������� ������� ������ ������
            reportf('������������ �������� ������ ������ 1 ('+ IntToStr(KanalSrv[1].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
            KanalSrv[1].RcvPtr := 0;
          end else
            ExtractSoobSrv(1); // ���������� ������ �� 1-�� ������
          if MyMarker[1] then
          begin // ��������� ������� ������������� �� 1-�� ������
            MySync[1] := true; MyMarker[1] := false; KanalSrv[1].issync := true; result := true;
            WriteSoobCom(1); // ������ � 1-�� ����� ������
          end;
        end;
      end;

      if KanalSrv[2].active then
      begin
        i := ReadSoobCom(2,sz);
        KanalSrv[2].lastcnt := i;
        KanalSrv[2].rcvcnt := KanalSrv[2].rcvcnt + i;
        if i > 0 then // ��������� ������ �� ������2
        begin
          if not FixedConnect[2] then
          begin // ������������� �������������� ����� � ��������
            AddFixMessage(GetShortMsg(1,434,'2'),5,0); InsArcNewMsg(0,434+$2000);
          end;
          FixedConnect[2] := true;
          if i >= 70 then begin inc(KanalSrv[2].cnterr); KanalSrv[2].lostcnt := 0; end;
          KanalSrv[2].isrcv := true;
          if KanalSrv[2].RcvPtr < 140 then KanalSrv[2].iserror := false;

          if (i + KanalSrv[2].RcvPtr) > sizeof(KanalSrv[2].RcvBuf) then i := 0;
          for j := 0 to i-1 do
          begin
            KanalSrv[2].RcvBuf[KanalSrv[2].RcvPtr] := KanalSrv[2].port.Buffer[j]; inc(KanalSrv[2].RcvPtr);
          end;
          if KanalSrv[2].RcvPtr > LnSoobSrv * 5 then
          begin
            inc(KanalSrv[2].cnterr); // ��������� ������� ������ ������
            reportf('������������ �������� ������ ������ 2 ('+ IntToStr(KanalSrv[2].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
            KanalSrv[2].RcvPtr := 0;
          end else
            ExtractSoobSrv(2); // ���������� ������ �� 2-�� ������
          if MyMarker[2] then
          begin // ��������� ������� ������������� �� 2-�� ������
            MySync[2] := true; MyMarker[2] := false; KanalSrv[2].issync := true; result := true;
            WriteSoobCom(2); // ������ �� 2-�� ����� ������
          end;
        end;
      end;
    end;

    //
    // ��� ������ � �������� ������������ ����� � ���������� ������.
    //
    1 : begin
      if KanalSrv[1].active then
      begin
        case KanalSrv[1].State of
          PIPE_READING_SUCCESS :
          begin // ��������� ������ �� ������ �����
            if not FixedConnect[1] then
            begin // ������������� �������������� ����� � ��������
              AddFixMessage(GetShortMsg(1,434,'1'),5,0); InsArcNewMsg(0,434+$2000);
            end;
            FixedConnect[1] := true; //KanalSrv[1].iserror := false;
            KanalSrv[1].rcvcnt := KanalSrv[1].RcvPtr;
            KanalSrv[1].lastcnt := KanalSrv[1].rcvcnt;
            if KanalSrv[1].rcvcnt > 0 then // ��������� ������ �� �����
            begin
              if KanalSrv[1].rcvcnt > 70 then begin inc(KanalSrv[1].cnterr); end else KanalSrv[1].cnterr := 0;
              KanalSrv[1].isrcv := true; MySync[1] := true;

              if KanalSrv[1].RcvPtr > LnSoobSrv * 3 then
              begin
                inc(KanalSrv[1].cnterr); // ��������� ������� ������ ������
                reportf('������������ �������� ������ ������ 1 ('+ IntToStr(KanalSrv[1].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
                KanalSrv[1].RcvPtr := 0;
              end else
                ExtractSoobSrv(1); // ���������� ������ �� �������
            end;
            KanalSrv[1].State := 0; // ��������� ����������� ������ ������ �� �����
            MySync[1] := true; MyMarker[1] := false; KanalSrv[1].issync := true;
          end;

          PIPE_ERROR_STATE :
          begin // ������� ����� � ��������
            KanalSrv[1].active := false;
          end;

          PIPE_EXIT :
          begin // ���������� ������ ������
            result := true; exit;
          end;
        end;
        WriteSoobPipe(1);
      end else
      begin
        if KanalSrv[1].State <> PIPE_EXIT then
        begin // ���� �� ���� ���������� ������������ ������ - ����������� ����� ����� � �������� �������������� ���������� ����� 10 ���.
          KanalSrv[1].iserror := true;
          if FixedDisconnect[1] then
          begin
            if FDT < LastTime then
            begin
              DisconnectKanalSrv(1);
              if (ConnectKanalSrv(1) > 0) and FixedConnect[1] then
              begin
                AddFixMessage(GetShortMsg(1,433,'1'),4,4); InsArcNewMsg(0,433+$1000);
              end;
              FixedDisconnect[1] := false; FixedConnect[1] := false;
            end;
          end else
          begin
            FixedDisconnect[1] := true; FDT := LastTime + 10/86400;
          end;
        end;
      end;

      if KanalSrv[2].active then
      begin
        case KanalSrv[2].State of
          PIPE_READING_SUCCESS :
          begin // ��������� ������ �� ������ �����
            if not FixedConnect[2] then
            begin // ������������� �������������� ����� � ��������
              AddFixMessage(GetShortMsg(1,434,'2'),5,0); InsArcNewMsg(0,434+$2000);
            end;
            FixedConnect[2] := true; //KanalSrv[2].iserror := false;
            KanalSrv[2].rcvcnt := KanalSrv[2].RcvPtr;
            KanalSrv[2].lastcnt := KanalSrv[2].rcvcnt;
            if KanalSrv[2].rcvcnt > 0 then // ��������� ������ �� �����
            begin
              if KanalSrv[2].rcvcnt > 70 then begin inc(KanalSrv[2].cnterr); end else KanalSrv[2].cnterr := 0;
              KanalSrv[2].isrcv := true; MySync[2] := true;

              if KanalSrv[2].RcvPtr > LnSoobSrv * 3 then
              begin
                inc(KanalSrv[2].cnterr); // ��������� ������� ������ ������
                reportf('������������ �������� ������ ������ 2 ('+ IntToStr(KanalSrv[2].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
                KanalSrv[2].RcvPtr := 0;
              end else
                ExtractSoobSrv(2); // ���������� ������ �� �������
            end;
            KanalSrv[2].State := 0; // ��������� ����������� ������ ������ �� �����
            MySync[2] := true; MyMarker[2] := false; KanalSrv[2].issync := true;
          end;

          PIPE_ERROR_STATE :
          begin // ������� ����� � ��������
            KanalSrv[2].active := false;
          end;

          PIPE_EXIT :
          begin // ���������� ������ ������
            result := true; exit;
          end;
        end;
        WriteSoobPipe(2);
      end else
      begin
        if KanalSrv[2].State <> PIPE_EXIT then
        begin // ���� �� ���� ���������� ������������ ������ - ����������� ����� ����� � �������� �������������� ���������� ����� 10 ���.
          KanalSrv[2].iserror := true;
          if FixedDisconnect[2] then
          begin
            if FDT < LastTime then
            begin
              DisconnectKanalSrv(2);
              if (ConnectKanalSrv(2) > 0) and FixedConnect[2] then
              begin
                AddFixMessage(GetShortMsg(1,433,'2'),4,4); InsArcNewMsg(0,433+$1000);
              end;
              FixedDisconnect[2] := false; FixedConnect[2] := false;
            end;
          end else
          begin
            FixedDisconnect[2] := true; FDT := LastTime + 10/86400;
          end;
        end;
      end;
    end;
  end;

// ��������������� ������� - ��������� ������, ���������� �� ������
  if savearc then SaveKanal;
except
  reportf('������ [KanalArmSrv.SyncReady]'); Application.Terminate; result := false;
end;
end;



function GetFR5(param : Word) : Byte;
begin
try
  result := FR5[param];
  FR5[param] := 0; // �������� ��������
except
  reportf('������ [KanalArmSrv.GetFR5]'); Application.Terminate; result := 0;
end;
end;

function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
  var p,d : integer;
begin
try
  result := false;
  if param < 8 then exit;
  d := param and 7; // ����� �������������� ����
  p := param shr 3; // ����� �������������� �����
  if p > 4096 then exit;

  // ��������� ���������� ������� ����� ������
  if ready then ready := (LastTime - FR3s[p]) < MaxTimeOutRecave;

  // ��������� ������� ������������ ���������
  if not nep then nep := (FR3[p] and $20) = $20;

  // �������� ��������
  case d of
    1 : result := (FR3[p] and 2) = 2;
    2 : result := (FR3[p] and 4) = 4;
    3 : result := (FR3[p] and 8) = 8;
    4 : result := (FR3[p] and $10) = $10;
    5 : result := (FR3[p] and $20) = $20;
    6 : result := (FR3[p] and $40) = $40;
    7 : result := (FR3[p] and $80) = $80;
  else
    result := (FR3[p] and 1) = 1;
  end;
except
  reportf('������ [KanalArmSrv.GetFR3]'); Application.Terminate; result := false;
end;
end;

function GetFR4State(param : Word) : Boolean;
  var p,d : integer;
begin
try
  result := false;
  if param < 8 then exit;
  d := param and 7;
  p := param shr 3;
  if p > 4096 then exit;

  // ��������� ���������� ������� ����� ������
  if (LastTime - FR4s[p]) < MaxTimeOutRecave then
  begin
    case d of
      1 : result := (FR4[p] and 2) = 2;
      2 : result := (FR4[p] and 4) = 4;
      3 : result := (FR4[p] and 8) = 8;
      4 : result := (FR4[p] and $10) = $10;
      5 : result := (FR4[p] and $20) = $20;
      6 : result := (FR4[p] and $40) = $40;
      7 : result := (FR4[p] and $80) = $80;
    else
      result := (FR4[p] and 1) = 1;
    end;
  end else
    result := false;
except
  reportf('������ [KanalArmSrv.GetFR4State]'); Application.Terminate; result := false;
end;
end;

//-----------------------------------------------------------------------------
// ��������� �������� � �����

// ��� ���-������
procedure WriteSoobCom(kanal : Byte);
  var next : boolean; crc : crc8_t; i,j,k : integer; a,b,bl,bh : byte;
  w {$IFDEF RMDSP},wyr,wmt,wdy,whr,wmn,wsc,wmsc{$ENDIF} : word; {$IFDEF RMDSP}uts : TDateTime;{$ENDIF}
begin
try
  if Assigned(KanalSrv[kanal].port) then
  begin
    next := false;
    a := config.RMID; a := a shl 4; a := a + LastSrv[kanal]; // ���������� ���������
    // ������������ ���� ���������
    b := config.ru; // ����� ����������
    if WorkMode.PushOK then b := b + $20;
    if not WorkMode.OKError then b := b + $40;
    if WorkMode.PushRU then b := b + $80;

    j := 0;
    WrBuffer[j] := #$AA; inc(j);
    WrBuffer[j] := char(a); inc(j);
    WrBuffer[j] := char(b); inc(j);

{$IFDEF RMDSP}
    if WorkMode.ServerSync then
    begin
      if SyncCmd then
      begin // ������ ������� ������������� ������� �� ��������
        DoubleCnt := 0; SyncCmd := false; SyncTime := false;
        uts := Date + Time; DecodeTime(uts,whr,wmn,wsc,wmsc); DecodeDate(uts,wyr,wmt,wdy);
        WrBuffer[j] := char(cmdfr3_autodatetime); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(cmdfr3_autodatetime);
        w := wSc and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wMn and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wHr and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wDy and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wMt and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wYr - 2000;  WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
        WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
      end else
      if (DoubleCnt > 0) and (ParamDouble.Cmd = cmdfr3_newdatetime) then
      begin // �������� �������
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[8]);
      end;
    end;

    if (CmdCnt > 0) and ((CmdBuff.Cmd = 96) or (CmdBuff.Cmd = 97) or (CmdBuff.Cmd = 125)) then
    begin // �������� ������� ����������� ������� ��� ���, �������������� ���������� ���
      WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
      NewCmd[kanal] := NewCmd[kanal] + char(CmdBuff.Cmd);
      bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
      WrBuffer[j] := char(bl); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bl);
      WrBuffer[j] := char(bh); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bh);
      CmdCnt := 0;
    end;
{$ENDIF}

    if not WorkMode.LockCmd then
    begin // �������� ������� � ������ ���� ��� ������� ��
{$IFDEF RMDSP}
      if WorkMode.MarhRdy then
      begin // ���������� ������� �� ��� ������ � �������� �� ������
        WorkMode.MarhRdy := false;
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[10]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[1]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[2]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[3]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[4]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[5]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[6]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[7]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[8]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[9]); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(MarhTracert[1].MarhCmd[10]) + char(MarhTracert[1].MarhCmd[1])
          + char(MarhTracert[1].MarhCmd[2]) + char(MarhTracert[1].MarhCmd[3]) + char(MarhTracert[1].MarhCmd[4]) + char(MarhTracert[1].MarhCmd[5])
          + char(MarhTracert[1].MarhCmd[6]) + char(MarhTracert[1].MarhCmd[7]) + char(MarhTracert[1].MarhCmd[8]) + char(MarhTracert[1].MarhCmd[9]);
      end;
{$ENDIF}
      if CmdCnt > 0 then
      begin // �������� ������� ������
        WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(CmdBuff.Cmd);
        bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
        WrBuffer[j] := char(bl); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bl);
        WrBuffer[j] := char(bh); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bh);
        CmdCnt := 0;
      end;

      if DoubleCnt > 0 then
      begin // �������� ���������� Double
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[8]);
      end;

    end else
    begin // �������� ��� ����������� ������� ���� ���� ���������� ��
      DoubleCnt := 0; Cmdcnt := 0; WorkMode.MarhRdy := false;
    end;

    if LastCRC[kanal] > 0 then
    begin // �������� ���������
      if j < 25 then
      begin
        k := LastCRC[kanal];
        if (2 * k) > (25 - j) then
        begin
          k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
          next := true;        // ��������� ������� ����������� ��
        end;
        WrBuffer[j] := char(k + cmdfr3_kvitancija); inc(j);
        while k > 0 do
        begin
          SendCheck(kanal,w);

//          trmkvit := trmkvit + ',' + IntToStr(w)+ ':'+ IntToStr(kanal);

          b := w div $100;
          WrBuffer[j] := char(w - (b * $100)); inc(j);
          WrBuffer[j] := char(b); inc(j);
          dec(k);
        end;
      end;
    end;

    while j < 26 do
    begin
      WrBuffer[j] := #0; inc(j);
    end; // ��������� ��������� �� �������� �����

    crc := CalculateCRC8(@WrBuffer[1],25);
    WrBuffer[j] := char(crc); inc(j);
    WrBuffer[j] := #$55; inc(j);

    i := 0;
    while next do
    begin // ������� ���������� ��������� ��������� ������
      i := i+28; j := 0;
      WrBuffer[i+j] := #$AA; inc(j);
      WrBuffer[i+j] := char(a); inc(j);
      WrBuffer[i+j] := char(b); inc(j);
      if LastCRC[kanal] > 0 then
      begin // �������� ���������
        if j < 25 then
        begin
          k := LastCRC[kanal];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
            next := true;        // ��������� ������� ����������� ��
          end else
            next := false;
          WrBuffer[i+j] := char(k + 224);
          while k > 0 do
          begin
            SendCheck(kanal,w);
            b := w div $100;
            WrBuffer[i+j] := char(w - (b * $100)); inc(j);
            WrBuffer[i+j] := char(b); inc(j);
            dec(k);
          end;
        end;
      end;
      while j < 26 do
      begin
        WrBuffer[i+j] := #0; inc(j);
      end; // ��������� ��������� �� �������� �����
      crc := CalculateCRC8(@WrBuffer[i+1],25);
      WrBuffer[i+j] := char(crc); inc(j);
      WrBuffer[i+j] := #$55; inc(j);
    end;

    KanalSrv[kanal].port.BufToComm(@WrBuffer[0],j);
  end;
except
  reportf('������ [KanalArmSrv.WriteSoobCom]'); Application.Terminate;
end;
end;

// ��� �����
procedure WriteSoobPipe(kanal: Byte);
  var next : boolean; crc : crc8_t; i,j,k : integer; a,b,bl,bh : byte;
  w{$IFDEF RMDSP},wyr,wmt,wdy,whr,wmn,wsc,wmsc{$ENDIF} : word; {$IFDEF RMDSP}uts : TDateTime;{$ENDIF} cErr : cardinal;
begin
try
  if (KanalSrv[kanal].nPipe <> 'null') and KanalSrv[kanal].active then
  begin
    KanalSrv[kanal].iserror := false;
    KanalSrv[kanal].cnterr := 0;
    MySync[kanal] := false;
    if not (SyncCmd or (DoubleCnt > 0) or WorkMode.MarhRdy or (Cmdcnt > 0) or (DoubleCnt > 0) or (LastCRC[kanal] > 0)) then
      exit;
    MySync[kanal] := true;
    next := false;
    a := config.RMID; a := a shl 4; a := a + LastSrv[kanal]; // ���������� ���������
    // ������������ ���� ���������
    b := config.ru; // ����� ����������
    if WorkMode.PushOK then b := b + $20;
    if not WorkMode.OKError then b := b + $40;
    if WorkMode.PushRU then b := b + $80;

    j := 0;
    WrBuffer[j] := #$AA; inc(j);
    WrBuffer[j] := char(a); inc(j);
    WrBuffer[j] := char(b); inc(j);

{$IFDEF RMDSP}
    if WorkMode.ServerSync then
    begin
      if SyncCmd then
      begin // ������ ������� ������������� ������� �� ��������
        DoubleCnt := 0; SyncCmd := false; SyncTime := false;
        uts := Date + Time; DecodeTime(uts,whr,wmn,wsc,wmsc); DecodeDate(uts,wyr,wmt,wdy);
        WrBuffer[j] := char(cmdfr3_autodatetime); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(cmdfr3_autodatetime);
        w := wSc and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wMn and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wHr and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wDy and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wMt and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        w := wYr - 2000;  WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
        WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
        WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
      end else
      if (DoubleCnt > 0) and (ParamDouble.Cmd = cmdfr3_newdatetime) then
      begin // �������� �������
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[8]);
      end;
    end;
{$ENDIF}

    if not WorkMode.LockCmd then
    begin // �������� ������� � ������ ���� ��� ������� ��

{$IFDEF RMDSP}
      if WorkMode.MarhRdy then
      begin // ���������� ������� �� ��� ������ � �������� �� ������
        WorkMode.MarhRdy := false;
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[10]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[1]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[2]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[3]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[4]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[5]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[6]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[7]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[8]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[9]); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(MarhTracert[1].MarhCmd[10]) + char(MarhTracert[1].MarhCmd[1])
          + char(MarhTracert[1].MarhCmd[2]) + char(MarhTracert[1].MarhCmd[3]) + char(MarhTracert[1].MarhCmd[4]) + char(MarhTracert[1].MarhCmd[5])
          + char(MarhTracert[1].MarhCmd[6]) + char(MarhTracert[1].MarhCmd[7]) + char(MarhTracert[1].MarhCmd[8]) + char(MarhTracert[1].MarhCmd[9]);
      end;
{$ENDIF}

      if CmdCnt > 0 then
      begin // �������� ������� ������
        WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(CmdBuff.Cmd);
        bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
        WrBuffer[j] := char(bl); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bl);
        WrBuffer[j] := char(bh); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bh);
        CmdCnt := 0;
      end;

      if DoubleCnt > 0 then
      begin // �������� ���������� Double
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[8]);
      end;
    end else
    begin // �������� ��� ����������� ������� ���� ���� ���������� ��
      DoubleCnt := 0; Cmdcnt := 0; WorkMode.MarhRdy := false;
    end;

    if LastCRC[kanal] > 0 then
    begin // �������� ���������
      if j < 25 then
      begin
        k := LastCRC[kanal];
        if (2 * k) > (25 - j) then
        begin
          k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
          next := true;        // ��������� ������� ����������� ��
        end;
        WrBuffer[j] := char(k + cmdfr3_kvitancija); inc(j);
        while k > 0 do
        begin
          SendCheck(kanal,w);

//          trmkvit := trmkvit + ',' + IntToStr(w)+ ':'+ IntToStr(kanal);

          b := w div $100;
          WrBuffer[j] := char(w - (b * $100)); inc(j);
          WrBuffer[j] := char(b); inc(j);
          dec(k);
        end;
      end;
    end;

    while j < 26 do
    begin
      WrBuffer[j] := #0; inc(j);
    end; // ��������� ��������� �� �������� �����

    crc := CalculateCRC8(@WrBuffer[1],25);
    WrBuffer[j] := char(crc); inc(j);
    WrBuffer[j] := #$55; inc(j);

    i := 0;
    while next do
    begin // ������� ���������� ��������� ��������� ������
      i := i+28; j := 0;
      WrBuffer[i+j] := #$AA; inc(j);
      WrBuffer[i+j] := char(a); inc(j);
      WrBuffer[i+j] := char(b); inc(j);
      if LastCRC[kanal] > 0 then
      begin // �������� ���������
        if j < 25 then
        begin
          k := LastCRC[kanal];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
            next := true;        // ��������� ������� ����������� ��
          end else
            next := false;
          WrBuffer[i+j] := char(k + 224);
          while k > 0 do
          begin
            SendCheck(kanal,w);
            b := w div $100;
            WrBuffer[i+j] := char(w - (b * $100)); inc(j);
            WrBuffer[i+j] := char(b); inc(j);
            dec(k);
          end;
        end;
      end;
      while j < 26 do
      begin
        WrBuffer[i+j] := #0; inc(j);
      end; // ��������� ��������� �� �������� �����
      crc := CalculateCRC8(@WrBuffer[i+1],25);
      WrBuffer[i+j] := char(crc); inc(j);
      WrBuffer[i+j] := #$55; inc(j);
    end;

    if j > 0 then
    begin // ���������� ������ � �����
      if not WriteFile( KanalSrv[kanal].hPipe, WrBuffer, j, lpNBWri, @TrmOLS[kanal]) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_NOT_CONNECTED : begin
            KanalSrv[kanal].iserror := true;
          end;
          ERROR_IO_PENDING : begin
            KanalSrv[kanal].iserror := false;
          end;
        end;
        MySync[kanal] := true; KanalSrv[kanal].issync := true;
      end else
        KanalSrv[kanal].iserror := false;
    end;
  end;
except
  reportf('������ [KanalArmSrv.WriteSoobPipe]'); Application.Terminate;
end;
end;

//-----------------------------------------------------------------------------
// ��������� ����� ������ �� ������

// ��� ��� ������
function ReadSoobCom(kanal: Byte; var rcv: string) : Integer;
  var i : integer;
begin
try
  result := 0;
  if Assigned(KanalSrv[kanal].port) then
  begin
    result := KanalSrv[kanal].port.BufFromComm(KanalSrv[kanal].port.Buffer,sizeof(KanalSrv[kanal].port.Buffer));
    if savearc then
    begin // ��������� ������ �� ������ - ��������������� �������
      rcv := ''; for i := 0 to result-1 do rcv := rcv + KanalSrv[kanal].port.Buffer[i];
      case kanal of
        1 : chnl1 := chnl1 + rcv;
        2 : chnl2 := chnl2 + rcv;
      end;
    end;
  end;
except
  reportf('������ [KanalArmSrv.ReadSoobCom]'); Application.Terminate; result := 0;
end;
end;

//
// ��� ����� - ������ ������ 1
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;
  var i : integer; cbRd,cbTRd : cardinal; LastError : DWORD;
begin
try
  LastError := 0;
  while true do
  begin
    if KanalSrv[1].hPipe = INVALID_HANDLE_VALUE then
    begin
      KanalSrv[1].iserror := true; break;
    end;
    case KanalSrv[1].State of
      PIPE_ERROR_STATE : break; // ����� ���� ������ ����������� � �������
      PIPE_EXIT : begin
        ExitThread(0); result := 0; exit; // ��������� ������������ ������ �����
      end;
    else // ������ �� �����
      if GetNamedPipeHandleState(KanalSrv[1].hPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile( KanalSrv[1].hPipe, Buffer, 70, cbRd, @RcvOLS[1]) then
        begin // ���������� � �������
          LastError := GetLastError;
          if LastError = ERROR_IO_PENDING then
          begin // ����� ����� �������� �� �����
            WaitForSingleObject(RcvOLS[1].hEvent, 31);
            CancelIO(KanalSrv[1].hPipe);
          end else
          begin // ����� �� ��������� �����
            KanalSrv[1].iserror := true; break;
          end;
        end;
        GetOverlappedResult(KanalSrv[1].hPipe,RcvOLS[1],cbTRd,false);
        if cbTRd > 0 then
        begin
          if (KanalSrv[1].RcvPtr + cbTRd) < RCV_LIMIT then
          begin // ���������� � �����
            for i := 0 to cbTRd-1 do
            begin
              KanalSrv[1].RcvBuf[KanalSrv[1].RcvPtr] := Buffer[i]; inc(KanalSrv[1].RcvPtr);

              if savearc then // ��������� ������ �� ������ - ��������������� �������
                chnl1 := chnl1 + Buffer[i];

            end;
            KanalSrv[1].State := PIPE_READING_SUCCESS;
          end else
          begin //����������� ��������� ������ �� ������ ������� ��� ������������ ������
            KanalSrv[1].iserror := true; KanalSrv[1].RcvPtr := 0;
          end;
        end;
      end else
      begin // ���������� ����� ���� ���������� ������ ������� ������
        KanalSrv[1].iserror := true; break;
      end;
    end;
  end;
  reportf('��� ������ ����� '+ IntToStr(LastError));
  KanalSrv[1].State := PIPE_ERROR_STATE;
  ExitThread(99); // ��������� ������������ ������ ����� �� ������
  result := 0;
except
  reportf('������ [KanalArmSrv.ReadSoobPipe]'); Application.Terminate; ExitThread(99); result := 0;
end;
end;

// ��� ����� - ������ ������ 2
function ReadSoobPipe2(var RdBuf: Pointer) : DWORD;
  var i : integer; cbRd,cbTRd : cardinal; LastError : DWORD;
begin
try
  LastError := 0;
  while true do
  begin
    if KanalSrv[2].hPipe = INVALID_HANDLE_VALUE then
    begin
      KanalSrv[2].iserror := true; break;
    end;
    case KanalSrv[2].State of
      PIPE_ERROR_STATE : break; // ����� ���� ������ ����������� � �������
      PIPE_EXIT : begin
        ExitThread(0); result := 0; exit; // ��������� ������������ ������ �����
      end;
    else // ������ �� �����
      if GetNamedPipeHandleState(KanalSrv[2].hPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile( KanalSrv[2].hPipe, Buffer, 70, cbRd, @RcvOLS[2]) then
        begin // ���������� � �������
          LastError := GetLastError;
          if LastError = ERROR_IO_PENDING then
          begin // ����� ����� �������� �� �����
            WaitForSingleObject(RcvOLS[2].hEvent, 31);
            CancelIO(KanalSrv[2].hPipe);
          end else
          begin // ����� �� ��������� �����
            KanalSrv[2].iserror := true; break;
          end;
        end;
        GetOverlappedResult(KanalSrv[2].hPipe,RcvOLS[2],cbTRd,false);
        if cbTRd > 0 then
        begin
          if (KanalSrv[2].RcvPtr + cbTRd) < RCV_LIMIT then
          begin // ���������� � �����
            for i := 0 to cbTRd-1 do
            begin
              KanalSrv[2].RcvBuf[KanalSrv[2].RcvPtr] := Buffer[i]; inc(KanalSrv[2].RcvPtr);

              if savearc then // ��������� ������ �� ������ - ��������������� �������
                chnl2 := chnl2 + Buffer[i];

            end;
            KanalSrv[2].State := PIPE_READING_SUCCESS;
          end else
          begin //����������� ��������� ������ �� ������ ������� ��� ������������ ������
            KanalSrv[2].iserror := true; KanalSrv[2].RcvPtr := 0;
          end;
        end;
      end else
      begin // ���������� ����� ���� ���������� ������ ������� ������
        KanalSrv[2].iserror := true; break;
      end;
    end;
  end;
  reportf('��� ������ �����2 '+ IntToStr(LastError));
  KanalSrv[2].State := PIPE_ERROR_STATE;
  ExitThread(99); // ��������� ������������ ������ ����� �� ������
  result := 0;
except
  reportf('������ [KanalArmSrv.ReadSoobPipe2]'); Application.Terminate; ExitThread(99); result := 0;
end;
end;

//------------------------------------------------------------------------------
// �������� � �����
function SaveArch(const c: byte) : Boolean;
  var i,hfile, hnbw, len: cardinal; bll,blh,bhl,bhh : byte; fp: longword; dt : Double; idt,cidt : int64;
begin
try
  DateTimeToString(stime, 'yymmdd', Date);
  if stime = ArchName then inc(ArcIndex) else begin ArcIndex := 0; ArchName := stime; end;
  sz := config.arcpath+ '\'+ ArchName+ '.ard';

  hfile := CreateFile(PChar(sz), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile = INVALID_HANDLE_VALUE then begin reportf('������ '+IntToStr(GetLastError)+' �������� ����� ������'); result := false; exit; end;
  try
  result := true;
  fp := SetFilePointer(hfile, 0, nil, FILE_END);
  if fp < $ffffffff then
  begin
    OLS.Offset := fp;
    LenArc := 0; // �������� ����� ������ ��� ������ � �����
    for i := 10 to Length(buffarc) do buffarc[i] := 0; // �������� �����
    dt := LastTime * 86400;
    idt := Trunc(dt);
    cidt := idt div $1000000; bhh := byte(cidt); idt := idt - cidt * $1000000;
    cidt := idt div $10000; bhl := byte(cidt); idt := idt - cidt * $10000;
    cidt := idt div $100; blh := byte(cidt); idt := idt - cidt * $100;
    bll := byte(idt);
    len := 1;
    case c of
      1 : begin // ������� ��������� �� ������ � ������� ��������� ������� � ����������
        if (ArcIndex = 0) and not StartRM then
        begin // ��������� ������ ����� � ������ ������ �����
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 11; inc(len); // ������� ������ 1-125 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to 125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          if WorkMode.LimitFR > 125 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // ������� ������ 126-250 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 250 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // ������� ������ 251-375 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 375 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // ������� ������ 376-500 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 500 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // ������� ������ 501-625 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 625 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // ������� ������ 626-750 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 750 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // ������� ������ 751-875 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 875 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // ������� ������ 876-1000 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFR > 1000 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 19; inc(len); // ������� ������ 1001-1125 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 1001 to 1125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          LastReper := LastTime;
        end;
        if NewMenuC <> '' then
        begin // ������� ����
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewMenuC) + 5; inc(len);
          buffarc[len] := 5; inc(len); // ������� ������ ����
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewMenuC) do begin buffarc[len] := byte(NewMenuC[i]); inc(len); end;
        end;
        if NewFR[1] <> '' then
        begin // ������� FR3 �� ��������� ������
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewFR[1]) + 5; inc(len);
          buffarc[len] := 1; inc(len); // ������� ������� �������� �� 1-�� ������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewFR[1]) do begin buffarc[len] := byte(NewFR[1,i]); inc(len); end;
        end;
        if NewFR[2] <> '' then
        begin // ������� FR3 �� ���������� ������
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewFR[2]) + 5; inc(len);
          buffarc[len] := 2; inc(len); // ������� ������� �������� �� 2-�� ������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewFR[2]) do begin buffarc[len] := byte(NewFR[2,i]); inc(len); end;
        end;
        if NewCmd[1] <> '' then
        begin // ������� ���������� �� ��������� ������
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewCmd[1]) + 5; inc(len);
          buffarc[len] := 3; inc(len); // ������� ������ ������� � 1-�� �����
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewCmd[1]) do begin buffarc[len] := byte(NewCmd[1,i]); inc(len); end;
        end;
        if NewCmd[2] <> '' then
        begin // ������� ���������� �� ���������� ������
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewCmd[2]) + 5; inc(len);
          buffarc[len] := 4; inc(len); // ������� ������ ������� � 2-�� �����
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewCmd[2]) do begin buffarc[len] := byte(NewCmd[2,i]); inc(len); end;
        end;
        if NewMsg <> '' then
        begin // �������� ��������� �� ������� �� FR3
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewMsg) + 5; inc(len);
          buffarc[len] := 6; inc(len);
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewMsg) do begin buffarc[len] := byte(NewMsg[i]); inc(len); end;
        end;
      end;

      2 : begin // ��������� 10-�� �������� ����� ���������
        buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 11; inc(len); // ������� ������ 1-125 ��������
        buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
        for i := 1 to 125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        if WorkMode.LimitFR > 125 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // ������� ������ 126-250 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 250 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // ������� ������ 251-375 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 375 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // ������� ������ 376-500 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 500 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // ������� ������ 501-625 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 625 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // ������� ������ 626-750 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 750 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // ������� ������ 751-875 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 875 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // ������� ������ 876-1000 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFR > 1000 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 19; inc(len); // ������� ������ 1001-1125 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1001 to 1125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        LastReper := LastTime;
      end;

      {������ ������}
    end;
    dec(len);
    LenArc := len; // ����� ������ ��� ������ � �����
    // ������ � ����
    if not WriteFile(hfile, buffarc[1], len, hnbw, nil) then
    begin
      reportf('������ '+IntToStr(GetLastError)+' ������ � ���� ������.'); result := false;
    end;
  end else
  begin
    reportf('������ '+ IntToStr(GetLastError)+ ' ��� ����������� ��������� � ����� ����� ������.'); result := false;
  end;
  finally
    if not CloseHandle(hfile) then begin reportf('������ '+ IntToStr(GetLastError)+' �������� ����� ������.'); result := false; end;
    case c of
      1 : begin
        NewFR[1] := ''; NewFR[2] := ''; NewCmd[1] := ''; NewCmd[2] := ''; // ����� ������� ������
        NewMenuC := ''; // ����� ������ ������ ����
        NewMsg := '';   // ����� ������ ��������������� ���������
      end;

    end;
  end;
except
  reportf('������ [KanalArmSrv.SaveArc]'); Application.Terminate; result := false;
end;
end;

//------------------------------------------------------------------------------
// �������� ��������� � ������
function AddCheck(kanal : Byte; crc : Word) : Boolean;
  var i : integer;
begin
try
  if LastCRC[kanal] < High(BackCRC) then
  begin
    inc(LastCRC[kanal]); BackCRC[LastCRC[kanal],kanal]  := crc; result := true;
  end else
  begin
    for i := 1 to High(BackCRC)-1 do begin BackCRC[i,kanal] := BackCRC[i+1,kanal]; end;
    BackCRC[LastCRC[kanal],kanal] := crc; result := false;
  end;
except
  reportf('������ [KanalArmSrv.AddCheck]'); Application.Terminate; result := false;
end;
end;

//-----------------------------------------------------------------------------
// �������� ��������� ���������
function SendCheck(kanal : Byte; var crc : Word) : Boolean;
  var i : integer;
begin
try
  result := false;
  if LastCRC[kanal] > 0 then
  begin
    crc := BackCRC[1,kanal];
    for i := 1 to LastCRC[kanal]-1 do BackCRC[i,kanal] := BackCRC[i+1,kanal];
    dec(LastCRC[kanal]);
    result := true;
  end;
except
  reportf('������ [KanalArmSrv.SSecdCheck]'); Application.Terminate; result := false;
end;
end;

var
  stmp : string;
  errch : array[1..2] of integer;
  errfix : array[1..2] of Boolean;

//------------------------------------------------------------------------------
// ���������� ��������� �� �������
procedure ExtractSoobSrv(kanal : Byte); // ���������� ��������� �� �������
  var
    pb : char; i,j,l : integer; dc : cardinal; i64 : int64;
    b,bl,bh,mm : byte; w,ww,dw : word; crc,pcrc : crc16_t;
  label  loop;

begin
try
  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; // ���� ������ � ������
  i := 0;
  while i < KanalSrv[kanal].RcvPtr do begin if KanalSrv[kanal].RcvBuf[i] = #$AA then break; inc(i); end; // ����� ���� � ��������� ������ ������

  if (i > 0) and (i < KanalSrv[kanal].RcvPtr) then
  begin // �������� ������ ������ �� ������� ������ �����
    l := 0;
    while i < KanalSrv[kanal].RcvPtr do begin KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l); end;
    KanalSrv[kanal].RcvPtr := l;
  end;
  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; // ����� ������ ���� - ������ ������

  if KanalSrv[kanal].RcvBuf[LnSoobSrv-1] = #$55 then // ���� ������� ����� ������ �� ����� - ��������� ����������� �����
  begin
    w := byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-3]) + byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-2]) * 256; pcrc := crc16_t(w); // �.�. �� ���������
    crc := CalculateCRC16(@KanalSrv[kanal].RcvBuf[1],LnSoobSrv-4); // �.�. �� ������
    if crc = pcrc then
    begin  // �������� ������������� ��������� - ����������� ������
      errfix[kanal] := false;
      KanalSrv[kanal].cnterr := 0; // ����� �������� ������
      KanalSrv[kanal].iserror := false;

      LastTime := Date+Time;
      inc(KanalSrv[kanal].pktcnt); // ��������� ������� �������� �������

//      rcvkvit := rcvkvit + ',' + IntToStr(crc)+ ':'+ IntToStr(kanal);

      if not AddCheck(kanal,crc) then
      begin
        inc(KanalSrv[kanal].cnterr); // ��������� ������� ������
        inc(KanalSrv[kanal].chklost); // ��������� ������� �������������� ���������
      end;
      j := 1; // ������ ���������
      b := byte(KanalSrv[kanal].RcvBuf[j]);
      mm := b and $0f; // �������� ������
      if (config.RMID = mm) and (LastTime - LastRcv < AnsverTimeOut) then
      begin
        MyMarker[kanal] := true; // ��������� �������� ��������� �������
      end else
        MyMarker[kanal] := false; // ������ ������� ������ ���-������
      LastRcv := Date+Time; // ��������� ����� ������ ���������� ������� �����
      // �������� ����� �������������� �������
      SrvState := 0;
      b := b and $f0; SrvState := b; b := b shr 4; LastSrv[kanal] := b; // �������� ����� ��������� ������� � ������
      inc(j);
      if config.RMID = mm then StateRU := byte(KanalSrv[kanal].RcvBuf[j]); // ��������� �� ������� ���� ���� ������
      WorkMode.LockCmd := ((StateRU and $10) = 0);
      SrvState := SrvState or (StateRU and 7); if WorkMode.LockCmd then SrvState := SrvState or 8;
      if char(SrvState) <> FR3inp[WorkMode.ServerStateSoob] then
      begin // ��������� ����� �������� ����� ��������� ��������
        bl := WorkMode.ServerStateSoob and $ff; bh := (WorkMode.ServerStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(SrvState);
        FR3inp[WorkMode.ServerStateSoob] := char(SrvState);
      end;

      DirState[1] := (StateRU and $f0)+(config.ru and $0f); // �������� ���� ��������� ����������
      FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
      if WorkMode.Upravlenie <> ((StateRU and $80) = $80) then
      begin // ������������ ����� ������ ����������
        bl := WorkMode.DirectStateSoob and $ff; bh := (WorkMode.DirectStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
        StDirect := (StateRU and $80) = $80; ChDirect := true;
      end;
      WorkMode.PushRU := (StateRU and $80) = $80;
      inc(j);

      inc(j); // ���������� ��������� ����
      // ������ �����
      while j < LnSoobSrv-3 do
      begin
        bl := byte(KanalSrv[kanal].RcvBuf[j]);
        inc(j);
        if j > LnSoobSrv-4 then break;
        bh := byte(KanalSrv[kanal].RcvBuf[j]);
        w := bh * 256 + bl; // ��������
        inc(j);
        if j > LnSoobSrv-4 then break;
        pb := KanalSrv[kanal].RcvBuf[j];    // �������� ��������� (����)
        inc(j);

        if w <> 0 then
        begin
          b := byte(pb);
          if w = WorkMode.DirectStateSoob then
          begin // ������������� ������� �� ��������� ������
            if config.RMID = mm then
            begin
              if not WorkMode.Upravlenie then
              begin
                if (b and $0f) > 0 then
                begin // ����� ����� ����������
                  if config.ru <> (b and $0f) then
                  begin // ����� ����������
                    ChRegion := true; NewRegion := (b and $0f);
                  end;
                end;
              end;
            end;
          end else

          if (w > 0) and (w < 4096) then
          begin                      // ��������� ������� FR3
            if (w <> WorkMode.ServerStateSoob) and (w <> WorkMode.ArmStateSoob) and (w <> WorkMode.DirectStateSoob) then
            begin // ���� �� ������������������ ������� - �������
              if pb <> FR3inp[w] then// �������
              begin
                FR3inp[w] := pb;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
              FR3s[w] := LastTime;
            end;
          end else

          if (w >= 4096) and (w < 5120) then
          begin                      // 2-� ������� ������
            if j > LnSoobSrv-4 then break;
            ww := w - 4095;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + KanalSrv[kanal].RcvBuf[j];
            dw := byte(KanalSrv[kanal].RcvBuf[j]); dw := dw shl 8;
            FR6[ww] := b+dw;
            inc(j);
          end else

          if (w >= 5120) and (w < 6144) then
          begin                      // 4-� ������� ������
            if j+2 > LnSoobSrv-4 then break;
            ww := w - 5119;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + KanalSrv[kanal].RcvBuf[j] +
                            KanalSrv[kanal].RcvBuf[j+1] + KanalSrv[kanal].RcvBuf[j+2];
            FR7[ww] := b;
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 8;  FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 16; FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 24; FR7[ww] := FR7[ww]+dc; inc(j);
          end else

          if (w >= 6144) and (w < 7168) then
          begin                      // 8-� ������� ������
            if j+6 > LnSoobSrv-4 then break;
            ww := w - 6143;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + KanalSrv[kanal].RcvBuf[j] +
                            KanalSrv[kanal].RcvBuf[j+1] + KanalSrv[kanal].RcvBuf[j+2] + KanalSrv[kanal].RcvBuf[j+3] +
                            KanalSrv[kanal].RcvBuf[j+4] + KanalSrv[kanal].RcvBuf[j+5] + KanalSrv[kanal].RcvBuf[j+6];
            FR8[ww] := b;
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 8;  FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 16; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 24; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 32; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 40; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 48; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 56; FR8[ww] := FR8[ww]+i64; inc(j);
          end else

          if (w >= 7168) and (w < 8191) then
          begin                      // ������ ASCIIZ
            sz := pb;
            while ((KanalSrv[kanal].RcvBuf[j] > #0) and (j < LnSoobSrv-3)) do
            begin
              sz := sz + KanalSrv[kanal].RcvBuf[j]; inc(j);
            end;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + sz;
            // sz - ������ ASCII
            inc(j);
          end else

          if (w and $e000) = $8000 then
          begin                      // ��������� FR4
            ww := w and $1fff;

            if (ww > 0) and (ww < 4096) then
            begin
              if pb <> FR4inp[ww] then// �������
              begin
                FR4inp[ww] := pb;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
              FR4s[ww] := LastTime;
            end;
          end else

          if (w and $e000) = $4000 then
          begin                      // ��������� �� �������, ������� ������
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              if mm = config.RMID then
              begin // ��������� ��������� �� ������� ��� ����� �� ������������ ��������
                KvitancijaFromSrv(ww,b);
              end;
            end;
          end else

          if (w and $e000) = $2000 then
          begin                      // ���� ����������� ��������� �������� (FR5)
            ww := w and $1fff;

            if (ww > 0) and (ww < 4096) then
            begin
              if not ((ww = LastDiagI) and (b = LastDiagN)) then
              begin
                FR5[ww] := FR5[ww] or b;
                LastDiagN := b; LastDiagI := ww; LastDiagD := LastTime + 2/80000;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
            end;
          end else
          begin
          // ���� ���������� ����������� ������ - �������� ����� ������ � ���������� ������� ������
            LastTime := date+time;
            inc(KanalSrv[kanal].pktlost); // ��������� ������� ���������� ������ � ������
            inc(errch[kanal]); errfix[kanal] := true; stmp := ''; for l := 0 to LnSoobSrv-1 do stmp := stmp + KanalSrv[kanal].RcvBuf[l];
            SaveDUMP(stmp,config.arcpath+ '\kanal'+IntToStr(kanal)+'.dmp');
            KanalSrv[kanal].iserror := true;
            MsgStateRM := '��������� ������ � ������'+ IntToStr(kanal); MsgStateClr := 1;
          // ��������� ������� ������ ������� ���������
            if (errch[kanal] > 30) and not LockTablo then
            begin
              SendCommandToSrv(WorkMode.DirectStateSoob,cmdfr3_logoff,0); // ���������� ���������� ������
              LockTablo := true; KanalSrv[kanal].active := false;
              reportf('������� ������ ������� ������ �������� 30, DUMP ������� � ���� '+ config.arcpath+ '\kanal'+IntToStr(kanal));
              FixStatKanal(1);
              FixStatKanal(2);
              Beep;
              ShowWindow(Application.Handle,SW_SHOW);
              ShowMessage('������� ������ ������� ������ �������� 30. �������� ������� � ���� "DSP.RPT". ������ ��������� ����� ���������.');
              Application.Terminate;
            end;
            break;
          end;

        end;
      end;
      // �������� �� ������ ������������ ����
      if KanalSrv[kanal].RcvPtr > LnSoobSrv then
      begin
        if not errfix[kanal] then errch[kanal] := 0; // �������� ������� ������ ������ ���� �� ������������ ����������� ������
        l := 0; i := LnSoobSrv;
        while i < KanalSrv[kanal].RcvPtr do
        begin
          KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l);
        end;
        KanalSrv[kanal].RcvPtr := l;
      end else
      begin
        KanalSrv[kanal].RcvPtr := 0; exit;
      end; // ��������� ���� ������ ��������� ������ ����
      goto loop;
    end else
    begin // ����������� ����� ������� - ���������� ����� � �������� ������
      l := 0; i := 1;
      while i < KanalSrv[kanal].RcvPtr do
      begin
        KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l);
      end;
      KanalSrv[kanal].RcvPtr := l; goto loop;
    end;
  end else
  begin // ������� ����� ����� �� ������ - ���������� ����� � �������� ������
    l := 0; i := 1;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l; goto loop;
  end;
except
  reportf('������ [KanalArmSrv.ExtractSoobSrv]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ��������� � ����� ��������� ���������� ������ ������
procedure FixStatKanal(kanal : byte);
begin
  if Assigned(KanalSrv[kanal].port) then
  begin
    reportf('����� '+IntToStr(kanal)+': ���� ������� '+IntToStr(KanalSrv[kanal].rcvcnt));
    reportf('����� '+IntToStr(kanal)+': ������� ������� '+IntToStr(KanalSrv[kanal].pktcnt));
    reportf('����� '+IntToStr(kanal)+': ������� �������� '+IntToStr(KanalSrv[kanal].pktlost));
    reportf('����� '+IntToStr(kanal)+': ��������� ��������� '+IntToStr(KanalSrv[kanal].chklost));
  end else
  if ((KanalSrv[kanal].nPipe <> 'null') and (KanalSrv[kanal].nPipe <> '')) then
  begin
    reportf('����� '+IntToStr(kanal)+': ������� ������� '+IntToStr(KanalSrv[kanal].pktcnt));
    reportf('����� '+IntToStr(kanal)+': ������� �������� '+IntToStr(KanalSrv[kanal].pktlost));
    reportf('����� '+IntToStr(kanal)+': ��������� ��������� '+IntToStr(KanalSrv[kanal].chklost));
  end;
end;


//------------------------------------------------------------------------------
// ��������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte);
  var i,im : integer;
begin
try
{$IFDEF RMSHN} WorkMode.CmdReady := false;{$ENDIF}

  if Obj > Word(WorkMode.LimitFR) then
  begin
    reportf('�������� ��������� �� �������������� ������ � �������� '+ IntToStr(Obj)); exit;
  end;

  case Kvit of
    0 : begin // �������� ���������� ���������� �������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      InsArcNewMsg(0,$400);
    end;
    1 : begin // ��������� � ���������� ���������� �������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      im := 0;// ����� ������� �������� �� ������ FR3
      for i := 1 to WorkMode.LimitObjZav do
        if ObjZav[i].TypeObj = 5 then
        begin
          if ObjZav[i].ObjConstI[3] > 0 then
            if Obj = (ObjZav[i].ObjConstI[3] div 8) then begin im := i; break; end;
          if ObjZav[i].ObjConstI[5] > 0 then
            if Obj = (ObjZav[i].ObjConstI[5] div 8) then begin im := i; break; end;
        end;
      if im > 0 then
        if ObjZav[im].RU = config.ru then
        begin MsgStateRM := GetShortMsg(2,1,ObjZav[im].Liter); MsgStateClr := 2; end;
      InsArcNewMsg(im,1+$400);
    end;
    2 : begin // ��������� �� ������ �� ���������� ������� ����������� ����������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
{$IFDEF RMDSP}
      if CmdBuff.LastObj = Obj then
      begin
        MsgStateRM := GetShortMsg(2,2,ObjZav[CmdBuff.LastObj].Liter); MsgStateClr := 1;
        InsArcNewMsg(0,2+$400);
      end;
{$ELSE}
        InsArcNewMsg(0,2+$400);
{$ENDIF}
    end;
    3 : begin // ����� �� ���������� ���������� �������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      im := 0;// ����� ������� �������� �� ������ FR3
      for i := 1 to WorkMode.LimitObjZav do
        if ObjZav[i].TypeObj = 5 then
        begin
          if ObjZav[i].ObjConstI[3] > 0 then
            if Obj = (ObjZav[i].ObjConstI[3] div 8) then begin im := i; break; end;
          if ObjZav[i].ObjConstI[5] > 0 then
            if Obj = (ObjZav[i].ObjConstI[5] div 8) then begin im := i; break; end;
        end;
      if im > 0 then
        if ObjZav[im].RU = config.ru then
        begin MsgStateRM := GetShortMsg(2,3,ObjZav[im].Liter); MsgStateClr := 1; end;
      InsArcNewMsg(im,3+$400);
    end;
    4 : begin // ��������� � ���������� ������� �������� �� �������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      im := 0;// ����� ������� �������� �� ������ FR3
      for i := 1 to WorkMode.LimitObjZav do
        if ObjZav[i].TypeObj = 25 then
        begin
          if ObjZav[i].ObjConstI[3] > 0 then
            if Obj = (ObjZav[i].ObjConstI[2] div 8) then begin im := i; break; end;
          if ObjZav[i].ObjConstI[5] > 0 then
            if Obj = (ObjZav[i].ObjConstI[8] div 8) then begin im := i; break; end;
        end;
      if im > 0 then
        if ObjZav[im].RU = config.ru then
        begin MsgStateRM := GetShortMsg(2,4,ObjZav[im].Liter); MsgStateClr := 2; end;
      InsArcNewMsg(im,4+$400);
    end;
    5 : begin // ����� �� ���������� ������� �������� �� �������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      im := 0;// ����� ������� �������� �� ������ FR3
      for i := 1 to WorkMode.LimitObjZav do
        if ObjZav[i].TypeObj = 25 then
        begin
          if ObjZav[i].ObjConstI[3] > 0 then
            if Obj = (ObjZav[i].ObjConstI[2] div 8) then begin im := i; break; end;
          if ObjZav[i].ObjConstI[5] > 0 then
            if Obj = (ObjZav[i].ObjConstI[8] div 8) then begin im := i; break; end;
        end;
      if im > 0 then
        if ObjZav[im].RU = config.ru then
        begin MsgStateRM := GetShortMsg(2,5,ObjZav[im].Liter); MsgStateClr := 1; end;
      InsArcNewMsg(im,5+$400);
    end;
    6 : begin // ����� ��������� ����������
      WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������
      MsgStateRM := GetShortMsg(2,Kvit,''); MsgStateClr := 1;
      InsArcNewMsg(0,6+$400);
    end;
    7 : begin // ����� ���������� ������� �� �������
      ResetMarhrutSrv(Obj); // ���������� ������� ������ �������� �� �������
    end;
    8..61 : begin
      MsgStateRM := GetShortMsg(2,Kvit,' FR['+IntToStr(Obj)+ ']'); MsgStateClr := 1;
    end;
  end;
except
  reportf('������ [KanalArmSrv.KvitancijaFromSrv]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ���������� ������ �� ���� � ��� - �������
procedure SaveDUMP(buf,fname : string);
  var i,hfile, hnbw, len: cardinal; fp: longword;
begin
  DateTimeToString(stime, 'hh:nn:ss.zzz', Date+Time);
  tbuf := '['+ stime+ '] ';
  for i := 1 to Length(buf) do tbuf := tbuf + IntToHex(byte(buf[i]),2) + ' ';
  tbuf := tbuf + #13#10;
  len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);
  hfile := CreateFile(PChar(fname), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then begin OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil); end;
    CloseHandle(hfile);
  end;
end;

//------------------------------------------------------------------------------
// ��������������� ������� - ���������� ������ �� ������� �� ����
procedure SaveKanal;
begin
  SaveDUMP(chnl1,'c:\kanal1.txt'); chnl1 := '';
  SaveDUMP(chnl2,'c:\kanal2.txt'); chnl2 := '';
end;

end.
