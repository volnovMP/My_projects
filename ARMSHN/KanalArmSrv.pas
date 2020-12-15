unit KanalArmSrv;
//****************************************************************************
//       ��������� ������ � ������� ������ - ��� ��
//****************************************************************************
{$INCLUDE e:\����_new\CfgProject}

interface

uses
  Windows,
  Dialogs,
  SysUtils,
  Controls,
  Classes,
  Messages,
  Graphics,
  Forms,
  StdCtrls,
  Registry,
  SyncObjs;


type TKanalErrors = (keOk,keErrCRC,keErrSrc,keErrDst);

const
  RCV_LIMIT = 2048;

type TKanal = record
    State   : Byte;
    config  : string;
    Index   : Byte;
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
    rcvcnt  : integer;
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
  NewFR    : array[1..2] of string;     // ����� ������� ��� ������
  NewCmd   : array[1..2] of string;     // ����� ��������� ��������� � ������ ��� ������
  NewMenuC : string;                    // ����� ������ ����, �������������� ����������
  NewMsg   : string;                    // ����� ��������� �� ������ FR3
  BackCRC  : array[1..20,1..2] of WORD; // ����� ���������
  LastCRC  : array[1..2] of Byte;       // ��������� �� ��������� ���������
  LastSrv  : array[1..2] of Byte;       // ����� �������������� �������
  buffarc  : array[1..32768] of byte;   // ����� ��� ������ � �����
  CmdCnt   : Byte;                      // ������� ������ ����������� ����������, ������� � ��������
  DoubleCnt: Byte;                      // ������� ���������� Double ������� � �������� �� ������
  MySync   : array[1..2] of Boolean;    // ������� ��������� ������������� �� ������ ������

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

function DestroyKanalSrv : Boolean;               // ���������� �������� ������
function GetKanalSrvStatus(kanal : Byte) : Byte;  // �������� ��������� ������
function InitKanalSrv(kanal : Byte) : Byte;       // ������������� ������
function ConnectKanalSrv(kanal : Byte) : Byte;    // ���������� ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte; // ������ ����� �� ������

function SyncReady : Boolean;
function GetFR5(param : Word) : Byte;
function GetFR4State(param : Word) : Boolean;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;     // ��������� ������ ������ ������ PIPEs
procedure WriteSoobPipe;                               // ��������� �������� � ����� PIPEs
function SaveArch(const c: byte) : Boolean;            // ��������� � ������ �������� ���������
function AddCheck(kanal : Byte; crc : Word) : Boolean; // �������� ����� ���������
function SendCheck(kanal : Byte; var crc : Word) : Boolean; // �������� ��������� ���������
procedure ExtractSoobSrv(kanal : Byte); // ���������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte); // ��������� ��������� �� �������
procedure SaveKanal;

implementation

uses
  TypeAll,
  TabloSHN1,
  crccalc,
  commands,
  commons,
  mainloop,
  marshrut;

 // VarStruct;

var
  OLS : TOverlapped;

var
lpNBWri     : Cardinal;
Buffer      : array[0..4097] of char;
RcvOLS      : TOverlapped;            // ��������� ���������� ������ ��� �����
TrmOLS      : TOverlapped;            // ��������� ���������� �������� ��� �����
WrBuffer    : array[0..4097] of char; // ����� ������ � �����
RcvComplete : boolean;
TrmComplete : boolean;
sz          : string;
stime       : string;
tbuf        : string;


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// ���������� �������� ������
function DestroyKanalSrv : Boolean;
begin
  try
    CloseHandle(RcvOLS.hEvent); RcvOLS.hEvent := INVALID_HANDLE_VALUE;
    CloseHandle(TrmOLS.hEvent); TrmOLS.hEvent := INVALID_HANDLE_VALUE;
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// �������� ��������� ������
function GetKanalSrvStatus(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or (KanalSrv[kanal].nPipe = '') then
  begin
    result := 255; exit;
  end;

  result := 0;
end;

//-----------------------------------------------------------------------------
// ������������� ������
function InitKanalSrv(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or  (KanalSrv[kanal].nPipe = '') then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ 255 ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;

  if kanal = 1 then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('��������� ������������� �����'+ IntToStr(kanal)+ ' '+ stime);
  end;
  result := 0;
end;

//-----------------------------------------------------------------------------
// ���������� ����� �� ������
function ConnectKanalSrv(kanal : Byte) : Byte;
  var Dummy : ULONG;
begin
  if (kanal < 1) or (kanal > 2) or (KanalSrv[kanal].nPipe = '') then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  KanalSrv[kanal].RcvPtr := 0;
  // �����
  if kanal = 1 then
  begin
    KanalSrv[1].hPipe := INVALID_HANDLE_VALUE;
    KanalSrv[1].State := 0; // ��������� ������ �� �����, ��������� ��������� � ���������
    KanalSrv[kanal].active := false;
    KanalSrv[1].hPipe := CreateFile(
    pchar(KanalSrv[1].nPipe),
    GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil,                    // �������� �������� �����������
    OPEN_EXISTING,
    FILE_FLAG_OVERLAPPED,
    0);
    if KanalSrv[1].hPipe = INVALID_HANDLE_VALUE then
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('�� ������� ������� ����� ������'+ IntToStr(kanal)+ ' (��� ������ '+IntToStr(GetLastError()) +') '+ stime);
    end else
    begin
      KanalSrv[1].State := 0; // ��������� ������ �� �����, ��������� ��������� � ���������
      CreateThread(nil,0,@ReadSoobPipe,nil,0,Dummy); // ������ ������������ ������ �����
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� ����������� � ������� �� ������ '+ KanalSrv[kanal].nPipe + ' '+ stime);
      KanalSrv[kanal].active := true;
      result := 0;
    end;
  end else
    result := 0;
end;

//-----------------------------------------------------------------------------
// ������ ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or(KanalSrv[kanal].nPipe = '') then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  // �����
  if kanal = 1 then
  begin
    if KanalSrv[kanal].hPipe = INVALID_HANDLE_VALUE then result := 0 else
    if CloseHandle(KanalSrv[kanal].hPipe) then result := 0 else result := 253;
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('�������� ����� ������ � �������� '+ KanalSrv[kanal].nPipe+ ' '+ stime);
    KanalSrv[kanal].active := false;
    KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE;
  end else result := 0;
end;


//-----------------------------------------------------------------------------
// ��������� ������ ���������� ������, �������� ������������� �� �������
var
  FixedDisconnect : Boolean;
  FixedConnect : Boolean;
  FDT : double;

function SyncReady : Boolean;
  var i,j : integer;
begin
  result := false;
  if AppStart then exit; // �� ��������� ������������� �� ������������ ����� ���-������
  if KanalSrv[1].active then
  begin
    case KanalSrv[1].State of
      PIPE_READING_SUCCESS :
      begin // ��������� ������ �� ������ �����
        if not FixedConnect then
        begin // ������������� �������������� ����� � ��������
          AddFixMessage(GetShortMsg(1,434,''),5,0); InsArcNewMsg(0,434+$2000);
        end;
        FixedConnect := true; KanalSrv[1].iserror := false;
        KanalSrv[1].rcvcnt := KanalSrv[1].RcvPtr;
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
    end;
  end else
  begin
    KanalSrv[1].iserror := true; KanalSrv[2].iserror := true;
    if FixedDisconnect then
    begin
      if FDT < LastTime then
      begin
        AddFixMessage(GetShortMsg(1,433,''),4,4);
        InsArcNewMsg(0,433+$1000);
        DisconnectKanalSrv(1);
        ConnectKanalSrv(1);
        FixedDisconnect := false;
        FixedConnect := false;
      end;
    end else
    begin
      FixedDisconnect := true;
      FDT := LastTime + 10/86400;
    end;
  end;
  WriteSoobPipe;
end;



function GetFR5(param : Word) : Byte;
begin
  result := FR5[param];
  FR5[param] := 0; // �������� ��������
end;

function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
  var p,d : integer;
begin
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
end;

function GetFR4State(param : Word) : Boolean;
  var p,d : integer;
begin
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
end;

//-----------------------------------------------------------------------------
// ��������� �������� � �����

// ��� �����
procedure WriteSoobPipe;
  var next : boolean; crc : crc8_t; i,j,k : integer; a,b,bl,bh : byte;
  w,wyr,wmt,wdy,whr,wmn,wsc,wmsc : word; uts : TDateTime; cErr : cardinal;
begin
  if (KanalSrv[1].nPipe <> '') and KanalSrv[1].active then
  begin
    KanalSrv[2].iserror := false;
    KanalSrv[2].cnterr := 0;
    MySync[2] := false;
    if not (SyncCmd or (DoubleCnt > 0) or WorkMode.MarhRdy or (Cmdcnt > 0) or (DoubleCnt > 0) or (LastCRC[1] > 0)) then
      exit;
    MySync[2] := true;
    next := false;
    a := config.RMID; a := a shl 4; a := a + LastSrv[1]; // ���������� ���������
    // ������������ ���� ���������
    b := config.ru; // ����� ����������
    if WorkMode.PushOK then b := b + $20;
    if not WorkMode.OKError then b := b + $40;
    if WorkMode.PushRU then b := b + $80;

    j := 0;
    WrBuffer[j] := #$AA; inc(j);
    WrBuffer[j] := char(a); inc(j);
    WrBuffer[j] := char(b); inc(j);

    if SyncCmd then
    begin // ������ ������� ������������� ������� �� ��������
      DoubleCnt := 0; SyncCmd := false; SyncTime := false;
      uts := Date + Time; DecodeTime(uts,whr,wmn,wsc,wmsc); DecodeDate(uts,wyr,wmt,wdy);
      WrBuffer[j] := char(cmdfr3_autodatetime); inc(j); NewCmd[1] := NewCmd[1] + char(cmdfr3_autodatetime);
      w := wSc and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      w := wMn and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      w := wHr and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      w := wDy and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      w := wMt and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      w := wYr - 2000;  WrBuffer[j] := char(w); inc(j); NewCmd[1] := NewCmd[1] + char(w);
      WrBuffer[j] := char(0); inc(j); NewCmd[1] := NewCmd[1] + char(0);
      WrBuffer[j] := char(0); inc(j); NewCmd[1] := NewCmd[1] + char(0);
    end else
    if (DoubleCnt > 0) and (ParamDouble.Cmd = cmdfr3_newdatetime) then
    begin // �������� �������
      DoubleCnt := 0;
      WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
      WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[1]);
      WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[2]);
      WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[3]);
      WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[4]);
      WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[5]);
      WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[6]);
      WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[7]);
      WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[8]);
    end;

    if not WorkMode.LockCmd then
    begin // �������� ������� � ������ ���� ��� ������� ��

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
        NewCmd[1] := NewCmd[1] + char(MarhTracert[1].MarhCmd[10]) + char(MarhTracert[1].MarhCmd[1])
          + char(MarhTracert[1].MarhCmd[2]) + char(MarhTracert[1].MarhCmd[3]) + char(MarhTracert[1].MarhCmd[4]) + char(MarhTracert[1].MarhCmd[5])
          + char(MarhTracert[1].MarhCmd[6]) + char(MarhTracert[1].MarhCmd[7]) + char(MarhTracert[1].MarhCmd[8]) + char(MarhTracert[1].MarhCmd[9]);
      end;

      if CmdCnt > 0 then
      begin // �������� ������� ������
        WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
        NewCmd[1] := NewCmd[1] + char(CmdBuff.Cmd);
        bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
        WrBuffer[j] := char(bl); inc(j); NewCmd[1] := NewCmd[1] + char(bl);
        WrBuffer[j] := char(bh); inc(j); NewCmd[1] := NewCmd[1] + char(bh);
        CmdCnt := 0;
      end;

      if DoubleCnt > 0 then
      begin // �������� ���������� Double
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[8]);
      end;
    end else
    begin // �������� ��� ����������� ������� ���� ���� ���������� ��
      DoubleCnt := 0; Cmdcnt := 0; WorkMode.MarhRdy := false;
    end;

    if LastCRC[1] > 0 then
    begin // �������� ���������
      if j < 25 then
      begin
        k := LastCRC[1];
        if (2 * k) > (25 - j) then
        begin
          k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
          next := true;        // ��������� ������� ����������� ��
        end;
        WrBuffer[j] := char(k + cmdfr3_kvitancija); inc(j);
        while k > 0 do
        begin
          SendCheck(1,w);

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
      if LastCRC[1] > 0 then
      begin // �������� ���������
        if j < 25 then
        begin
          k := LastCRC[1];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; // ���������� ���-�� ���������� ���������
            next := true;        // ��������� ������� ����������� ��
          end else
            next := false;
          WrBuffer[i+j] := char(k + 224);
          while k > 0 do
          begin
            SendCheck(1,w);
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
      if not WriteFile( KanalSrv[1].hPipe, WrBuffer, j, lpNBWri, @TrmOLS) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_NOT_CONNECTED : begin
            KanalSrv[2].iserror := true;
          end;
          ERROR_IO_PENDING : begin
            KanalSrv[2].iserror := false;
          end;
        end;
        MySync[1] := true; KanalSrv[1].issync := true;
      end else
        KanalSrv[2].iserror := false;
    end;
  end;
end;

//-----------------------------------------------------------------------------
// ��������� ����� ������ �� ������
// ��� ����� - ������ ������
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;
  var i : integer; cbRd,cbTRd : cardinal; LastError : DWORD;
begin
  LastError := 0;
  while true do
  begin
    case KanalSrv[1].State of
      PIPE_READING_SUCCESS : WaitForSingleObject(RcvOLS.hEvent, 239); // �������� ��������� ������ � ���������� ��������
      PIPE_ERROR_STATE : break; // ����� ���� ������ ����������� � �������
      PIPE_EXIT : begin
        ExitThread(0); // ��������� ������������ ������ �����
        result := 0;
        exit;
      end;
    else // ������ �� �����
      if not ReadFile( KanalSrv[1].hPipe, Buffer, 70, cbRd, @RcvOLS) then
      begin // ���������� � �������
        LastError := GetLastError;
        if LastError = ERROR_IO_PENDING then
        begin // ����� ����� �������� �� �����
          WaitForSingleObject(RcvOLS.hEvent, 197);
          CancelIO(KanalSrv[1].hPipe);
        end else
        begin // ����� �� ��������� �����
          KanalSrv[1].iserror := true; break;
        end;
      end;
      GetOverlappedResult(KanalSrv[1].hPipe,RcvOLS,cbTRd,true);
      if cbTRd > 0 then
      begin
        if (KanalSrv[1].RcvPtr + cbTRd) < RCV_LIMIT then
        begin // ���������� � �����
          for i := 0 to cbTRd-1 do
          begin
            KanalSrv[1].RcvBuf[KanalSrv[1].RcvPtr] := Buffer[i]; inc(KanalSrv[1].RcvPtr);
          end;
        end else KanalSrv[1].iserror := true;
        KanalSrv[1].State := PIPE_READING_SUCCESS;
      end;
    end;
  end;
  reportf('��� ������ ����� '+ IntToStr(LastError));
  KanalSrv[1].State := PIPE_ERROR_STATE;
  ExitThread(99); // ��������� ������������ ������ ����� �� ������
  result := 0;
end;

//------------------------------------------------------------------------------
// �������� � �����
function SaveArch(const c: byte) : Boolean;
  var i,hfile, hnbw, len: cardinal; bll,blh,bhl,bhh : byte; fp: longword; dt : Double; idt,cidt : int64;
begin
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
    // ������ � ����
    if not WriteFile(hfile, buffarc[1], len, hnbw, nil) then
    begin
      reportf('������ '+IntToStr(GetLastError)+' ������ � ���� ������.'); result := false;
    end;
  end else
  begin
    reportf('������ '+ IntToStr(GetLastError)+ ' ��� ����������� ��������� � ����� ����� ������.'); result := false;
  end;
//  if not FlushFileBuffers(hfile) then begin ShowMessage('������ '+ IntToStr(GetLastError)+ ' �� ����� ������ ����� ������ �� ������� ����.'); result := false; end;
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
end;

//------------------------------------------------------------------------------
// �������� ��������� � ������
function AddCheck(kanal : Byte; crc : Word) : Boolean;
  var i : integer;
begin
  if LastCRC[kanal] < High(BackCRC) then
  begin
    inc(LastCRC[kanal]); BackCRC[LastCRC[kanal],kanal]  := crc; result := true;
  end else
  begin
    for i := 1 to High(BackCRC)-1 do begin BackCRC[i,kanal] := BackCRC[i+1,kanal]; end;
    BackCRC[LastCRC[kanal],kanal] := crc; result := false;
  end;
end;

//-----------------------------------------------------------------------------
// �������� ��������� ���������
function SendCheck(kanal : Byte; var crc : Word) : Boolean;
  var i : integer;
begin
  result := false;
  if LastCRC[kanal] > 0 then
  begin
    crc := BackCRC[1,kanal];
    for i := 1 to LastCRC[kanal]-1 do BackCRC[i,kanal] := BackCRC[i+1,kanal];
    dec(LastCRC[kanal]);
    result := true;
  end;
end;

//------------------------------------------------------------------------------
// ���������� ��������� �� �������
procedure ExtractSoobSrv(kanal : Byte); // ���������� ��������� �� �������
  var
    pb : char; i,j,l : integer; dc : cardinal; i64 : int64;
    b,bl,bh,mm : byte; w,ww,dw : word; crc,pcrc : crc16_t;
  label  loop;

begin
  KanalSrv[kanal].RcvPtr := 80;

  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; // ���� ������ � ������
  i := 0;
  while i < KanalSrv[kanal].RcvPtr do
  begin
    if KanalSrv[kanal].RcvBuf[i] = #$AA then break;
    inc(i);
  end; // ����� ���� � ��������� ������ ������

  if (i > 0) and (i < KanalSrv[kanal].RcvPtr) then
  begin // �������� ������ ������ �� ������� ������ �����
    l := 0;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i];
      inc(i); inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l;
  end;
  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; // ����� ������ ���� - ������ ������

  if KanalSrv[kanal].RcvBuf[LnSoobSrv-1] = #$55 then // ���� ������� ����� ������ �� ����� - ��������� ����������� �����
  begin
    w := byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-3]) + byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-2]) * 256; pcrc := crc16_t(w); // �.�. �� ���������
    crc := CalculateCRC16(@KanalSrv[kanal].RcvBuf[1],LnSoobSrv-4); // �.�. �� ������

    if crc = pcrc then
    begin  // �������� ������������� ��������� - ����������� ������ (t - ���������� �����)
      KanalSrv[kanal].cnterr := 0; // ����� �������� ������
      KanalSrv[kanal].iserror := false;

//      rcvkvit := rcvkvit + ',' + IntToStr(crc)+ ':'+ IntToStr(kanal);

      if not AddCheck(kanal,crc) then
      begin
        inc(KanalSrv[kanal].cnterr); // ��������� ������� �� ���������� ���-�� �������������� ���������
      end;
      j := 1; // ������ ���������
      b := byte(KanalSrv[kanal].RcvBuf[j]);
      mm := b and $0f; // �������� ������
      if (config.RMID = mm) and (LastTime - LastRcv < AnsverTimeOut) then
        MyMarker[kanal] := true // ��������� �������� ��������� �������
      else
        MyMarker[kanal] := false; // ������ ������� ������ ���-������
      LastRcv := LastTime; // ��������� ����� ������ ���������� ������� �����
      // �������� ����� �������������� �������
      SrvState := 0;
      b := b and $f0; SrvState := b; b := b shr 4; LastSrv[kanal] := b;
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

      if config.configKRU <> 0 then
      begin // ���� ������������� - ���� ��� ������������ ��� ���������� ���������
        if not WorkMode.PushRU then StateRU := StateRU and $7f;
      end;
      DirState[1] := (StateRU and $f0)+(config.ru and $0f); // �������� ���� ��������� ����������
      FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
      if WorkMode.Upravlenie <> ((StateRU and $80) = $80) then
      begin // ������������ ����� ������ ����������
        FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
        bl := WorkMode.DirectStateSoob and $ff; bh := (WorkMode.DirectStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
        StDirect := (StateRU and $80) = $80; ChDirect := true;
      end;
      if config.configKRU = 0 then
      begin // ������� � ������ ����� ���������� ��� �������� 0
        WorkMode.PushRU := (StateRU and $80) = $80;
      end;
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
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
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
            if pb <> FR3inp[w] then// �������
            begin
              FR3inp[w] := pb;
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
            end;
            FR3s[w] := LastTime;
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
              if (mm = config.RMID) and WorkMode.CmdReady then
              begin // ��������� ��������� �� �������
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
          end;

        end;
      end;
      // �������� �� ������ ������������ ����
      if KanalSrv[kanal].RcvPtr > LnSoobSrv then
      begin
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
end;








{ ������ ������ ���������� ��������� �������
procedure ExtractSoobSrv(kanal : Byte); // ���������� ��������� �� �������

  var
    pb : char;
    i,j,l : integer; dc : cardinal; i64 : int64;
    b,bl,bh,mm : byte; w,ww,dw : word;
    crc,pcrc : crc16_t; //xxx : boolean;

  label  loop;

begin
  if (kanal < 1) or (kanal > 2) then exit;
loop:
  s := KanalSrv[kanal].rcvsoob;
  l := Length(s);
  if l < LnSoobSrv then exit;
  i := 1;
  while i <= l do begin if s[i] = #$AA then break; inc(i); end; // ����� ���� � ��������� ������ ������
  if (l - i + 1) < LnSoobSrv then
  begin
    t := ''; // �������� �� ������� ������ �����
    while i <= l do begin t := t + s[i]; inc(i); end;
    KanalSrv[kanal].rcvsoob := t;
    exit; // ����� ������ ���� - ������ ������
  end;

  if s[i+LnSoobSrv-1] = #$55 then // ���� ������� ����� ������ �� ����� - ��������� ����������� �����
  begin
    t := ''; inc(i); j := i; while j < i+LnSoobSrv-4 do begin t := t + s[j]; inc(j); end;
    j := i + LnSoobSrv-4;
    b := byte(s[j]); inc(j); w := b + byte(s[j]) * 256; pcrc := crc16_t(w); // �.�. �� ���������
    crc := CalculateCRC16(@t[1],Length(t));

    if crc = pcrc then
    begin  // �������� ������������� ��������� - ����������� ������ (t - ���������� �����)
      KanalSrv[kanal].cnterr := 0; // ����� �������� ������
      KanalSrv[kanal].iserror := false;

//      rcvkvit := rcvkvit + ',' + IntToStr(crc)+ ':'+ IntToStr(kanal);

      if not AddCheck(kanal,crc) then
      begin
        inc(KanalSrv[kanal].cnterr); // ��������� ������� �� ���������� ���-�� �������������� ���������
      end;
      j := 1;
      b := byte(t[j]);
      mm := b and $0f; // �������� ������
      if (config.RMID = mm) and (LastTime - LastRcv < AnsverTimeOut) then
        MyMarker[kanal] := true // ��������� �������� ��������� �������
      else
        MyMarker[kanal] := false; // ������ ������� ������ ���-������
      LastRcv := LastTime; // ��������� ����� ������ ���������� ������� �����
      // �������� ����� �������������� �������
      SrvState := 0;
      b := b and $f0; SrvState := b; b := b shr 4; LastSrv[kanal] := b;
      inc(j);
      if config.RMID = mm then StateRU := byte(t[j]); // ��������� �� ������� ���� ���� ������
      WorkMode.LockCmd := ((StateRU and $10) = 0);
      SrvState := SrvState or (StateRU and 7); if WorkMode.LockCmd then SrvState := SrvState or 8;
      if char(SrvState) <> FR3inp[WorkMode.ServerStateSoob] then
      begin // ��������� ����� �������� ����� ��������� ��������
        bl := WorkMode.ServerStateSoob and $ff; bh := (WorkMode.ServerStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(SrvState);
        FR3inp[WorkMode.ServerStateSoob] := char(SrvState);
      end;

      if config.configKRU <> 0 then
      begin // ���� ������������� - ���� ��� ������������ ��� ���������� ���������
        if not WorkMode.PushRU then StateRU := StateRU and $7f;
      end;
      DirState[1] := (StateRU and $f0)+(config.ru and $0f); // �������� ���� ��������� ����������
      FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
      if WorkMode.Upravlenie <> ((StateRU and $80) = $80) then
      begin // ������������ ����� ������ ����������
        FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
        bl := WorkMode.DirectStateSoob and $ff; bh := (WorkMode.DirectStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
        StDirect := (StateRU and $80) = $80; ChDirect := true;
      end;
      if config.configKRU = 0 then
      begin // ������� � ������ ����� ���������� ��� �������� 0
        WorkMode.PushRU := (StateRU and $80) = $80;
      end;
      inc(j);

      inc(j); // ���������� ��������� ����
      // ������ �����
      while j <= Length(t) do
      begin
        bl := byte(t[j]);
        inc(j);
        if j > Length(t) then break;
        bh := byte(t[j]);
        w := bh * 256 + bl; // ��������
        inc(j);
        if j > Length(t) then break;
        pb := t[j];    // �������� ��������� (����)
        inc(j);

        if w <> 0 then
        begin
          b := byte(pb);
          if w = WorkMode.DirectStateSoob then
          begin // ������������� ������� �� ��������� ������
            if config.RMID = mm then
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
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
            if pb <> FR3inp[w] then// �������
            begin
              FR3inp[w] := pb;
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
            end;
            FR3s[w] := LastTime;
          end else

          if (w >= 4096) and (w < 5120) then
          begin                      // 2-� ������� ������
            if j > Length(t) then break;
            ww := w - 4095;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + t[j];
            dw := byte(t[j]); dw := dw shl 8;
            FR6[ww] := b+dw;
            inc(j);
          end else

          if (w >= 5120) and (w < 6144) then
          begin                      // 4-� ������� ������
            if j+2 > Length(t) then break;
            ww := w - 5119;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + t[j] + t[j+1] + t[j+2];
            FR7[ww] := b;
            dc := byte(t[j]); dc := dc shl 8;  FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(t[j]); dc := dc shl 16; FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(t[j]); dc := dc shl 24; FR7[ww] := FR7[ww]+dc; inc(j);
          end else

          if (w >= 6144) and (w < 7168) then
          begin                      // 8-� ������� ������
            if j+6 > Length(t) then break;
            ww := w - 6143;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb + t[j] + t[j+1] + t[j+2] + t[j+3] + t[j+4] + t[j+5] + t[j+6];
            FR8[ww] := b;
            i64 := byte(t[j]); i64 := i64 shl 8;  FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 16; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 24; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 32; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 40; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 48; FR8[ww] := FR8[ww]+i64; inc(j);
            i64 := byte(t[j]); i64 := i64 shl 56; FR8[ww] := FR8[ww]+i64; inc(j);
          end else

          if (w >= 7168) and (w < 8191) then
          begin                      // ������ ASCIIZ
            sz := pb;
            while ((t[j] > #0) and (j <= Length(t))) do
            begin
              sz := sz + t[j]; inc(j);
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
              if (mm = config.RMID) and WorkMode.CmdReady then
              begin // ��������� ��������� �� �������
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
          end;

        end;
      end;
      // �������� �� ������ ������������ ����
      i := i + LnSoobSrv-1; t := ''; while i <= l do begin t := t + s[i]; inc(i); end; KanalSrv[kanal].rcvsoob := t;
      if t = '' then exit; // ��������� ���� ������� ��������� ������ ����
      goto loop;
    end else
    begin // ����������� ����� ������� - ���������� ����� � �������� ������
      t := ''; while i <= l do begin t := t + s[i]; inc(i); end; KanalSrv[kanal].rcvsoob := t; goto loop;
    end;
  end else
  begin // ������� ����� ����� �� ������ - ���������� ����� � �������� ������
    inc(i); t := ''; while i <= l do begin t := t + s[i]; inc(i); end; KanalSrv[kanal].rcvsoob := t; goto loop;
  end;
end;
}


//------------------------------------------------------------------------------
// ��������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte);
begin
  WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������

  if Obj > High(ObjZav) then
  begin
    reportf('�������� ��������� �� �������������� ������ � �������� '+ IntToStr(Obj)); exit;
  end;

  case Kvit of
    1 : begin // ��������� � ���������� ���������� �������
      if Obj <> WorkMode.DirectStateSoob then
      begin
        MsgStateRM := GetShortMsg(2,Kvit,LastMsgToDSP); MsgStateClr := 2;
      end;
    end;
    2 : begin // ��������� �� ������ �� ���������� ������� ����������� ����������
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
    3 : begin // ����� �� ���������� ���������� �������
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
    4 : begin // ��������� � ���������� ������� �������� �� �������
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 2;
    end;
    5 : begin // ����� �� ���������� ������� �������� �� �������
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
      VytajkaOZM(Obj); // �������� ���������� �����, ������������ � ������
    end;
    6..61 : begin
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
  end;
end;


//------------------------------------------------------------------------------
// ��������������� ������� - ���������� ������ �� ������� �� ����
procedure SaveKanal;
  var i,hfile, hnbw, len: cardinal; fp: longword;
begin
  DateTimeToString(stime, 'hh:nn:ss.zzz', LastTime);
  stime := #13#10+ '['+ stime+ ']'+ #13#10;

  tbuf := '';
  for i := 1 to Length(chnl1) do
  begin
    tbuf := tbuf + IntToHex(byte(chnl1[i]),2) + ' ';
  end;
  tbuf := stime + tbuf; len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);

  hfile := CreateFile(PChar('c:\kanal1.txt'), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then
    begin
      OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil);
    end;
    CloseHandle(hfile);
  end;
  chnl1 := '';

  tbuf := '';
  for i := 1 to Length(chnl2) do
  begin
    tbuf := tbuf + IntToHex(byte(chnl2[i]),2) + ' ';
  end;
  tbuf := stime + tbuf; len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);

  hfile := CreateFile(PChar('c:\kanal2.txt'), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then
    begin
      OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil);
    end;
    CloseHandle(hfile);
  end;
  chnl2 := '';
end;

end.
