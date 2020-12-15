unit KanalArmDc;
{$INCLUDE d:\sapr_new\CfgProject}
//****************************************************************************
//       ��������� ������ � ������� �� - �� ���
//****************************************************************************


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
  SyncObjs,
  comport,
  KanalArmSrvSHN;

type TKanalDC = record
    State   : Byte;
    config  : string;
    Index   : Byte;
    port    : TComPort;
    active  : Boolean;
    hPipe   : THandle;
    rcvsoob : string;   // ������ ��������� ������
    RcvBuf  : array[0..4095] of char;
    RcvPtr  : word;     // ��������� �� ����� �������� ������
    isrcv   : boolean;
    issync  : boolean;
    iserror : boolean;
    cnterr  : integer;
    rcvcnt  : integer; // ������� ���������� �������� ��������
    trmcnt  : integer; // ������� ���������� ��������� ��������
    pktcnt  : integer; // ������� ���������� �������� �������
    tpkcnt  : integer; // ������� ���������� �������� �������
    lastcnt : integer; // ������� ���������� �������� ���� ��� ��������� ������ ������
    lostcnt : integer; // ������� ���������� �������� ������ ������ �� ������
  end;

const
  LnSoobDC     = 11;    // ����� ��������� ��� ��-��
  LnSoobKvitDC = 6;     // ����� ��������� �� ��-��
  LIMIT_DC  = 80;

var
  CurrDCSoob : integer; // ��������� ���������� ���������� ��������� � ����� ��
  LastDC     : array[1..2] of Byte; // ����� �������������� ��-��

//------------------------------------------------------------------------------
//                  ������ �������� �� ������ ��-�� - ���
//------------------------------------------------------------------------------
var
  FR3dc  : array[1..LIMIT_DC,1..5] of Byte; // ����� ��������� �������� ��� ��-��
  FR3dcn : array[1..LIMIT_DC] of boolean;   // ����� ������� ��������� �������� � ������ ��-��


var
  KanalDC  : array[1..2] of TKanalDC;

function CreateKanalDC : Boolean;                // ������� ���������� ������ TComPort
function DestroyKanalDC : Boolean;               // ���������� �������� ������
function GetKanalDCStatus(kanal : Byte) : Byte;  // �������� ��������� ������
function InitKanalDC(kanal : Byte) : Byte;       // ������������� ������
function ConnectKanalDC(kanal : Byte) : Byte;    // ���������� ����� �� ������
function DisconnectKanalDC(kanal : Byte) : Byte; // ������ ����� �� ������

function SyncDCReady : Boolean;
function GetFR3dc(const param : Word) : Boolean;
function ReadSoobDC(kanal: Byte; var rcv: string) : Integer; // ��������� ����� ������ ������ COM-ports
procedure WriteSoobDC(kanal: Byte);                   // ��������� �������� � ����� COM-ports
procedure ExtractSoobDC(kanal : Byte); // ���������� ��������� �� �������
procedure FixStatKanalDC(kanal : byte); // ��������� � ����� ��������� ���������� ������ ������

implementation

uses
  TabloSHN,
  crccalc,
  commands,
  commons,
  mainloop,
  marshrut,
  TypeALL;

var
WrBuffer    : array[0..10] of char; // ����� ������
sz          : string;
stime       : string;


//-----------------------------------------------------------------------------
// ������� ���������� ������ TComPort
function CreateKanalDC : Boolean;
begin
  try
    if KanalDC[1].Index > 0 then KanalDC[1].port := TComPort.Create(nil);
    if KanalDC[2].Index > 0 then KanalDC[2].port := TComPort.Create(nil);
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// ���������� �������� ������
function DestroyKanalDC : Boolean;
begin
  try
    if Assigned(KanalDC[1].port) then KanalDC[1].port.Destroy;
    if Assigned(KanalDC[2].port) then KanalDC[2].port.Destroy;
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// �������� ��������� ������
function GetKanalDCStatus(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then result := 255 else result := 0;
end;

//-----------------------------------------------------------------------------
// ������������� ������
function InitKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  if Assigned(KanalDC[kanal].port) then
  begin // ���-����
    if KanalDC[kanal].port.InitPort(IntToStr(KanalDC[kanal].Index)+ ','+ KanalDC[kanal].config) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� ������������� ������'+ IntToStr(kanal)+ ' �� '+ stime);
      result := 0;
    end else
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('������ 254 ������������� ������'+ IntToStr(kanal)+ ' �� '+ stime);
      result := 254;
    end;
  end else
    result := 253;
end;

//-----------------------------------------------------------------------------
// ���������� ����� �� ������
function ConnectKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  KanalDC[kanal].RcvPtr := 0;
  if Assigned(KanalDC[kanal].port) then
  begin // ���-����
    if KanalDC[kanal].port.PortIsOpen then
    begin
      KanalDC[kanal].active := true; result := 0;
    end else
    if KanalDC[kanal].port.OpenPort then
    begin
      PurgeComm(KanalDC[kanal].port.PortHandle,PURGE_TXABORT+PURGE_RXABORT+PURGE_TXCLEAR+PURGE_RXCLEAR);
      KanalDC[kanal].active := true;
      KanalDC[kanal].hPipe := KanalDC[kanal].port.PortHandle;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('��������� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' �� '+ stime);
      result := 0;
    end else
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('�� ������� ������� ���������������� ���� ������'+ IntToStr(kanal)+ ' �� '+ stime);
    end;
  end else
    result := 1;
end;

//-----------------------------------------------------------------------------
// ������ ����� �� ������
function DisconnectKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  if Assigned(KanalDC[kanal].port) then
  begin // COM-����
    if KanalDC[kanal].port.PortIsOpen then
    begin
      if KanalDC[kanal].port.ClosePort then
      begin
        KanalDC[kanal].active := false;
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('���������������� ���� ������'+ IntToStr(kanal)+ ' �� '+ stime+ ' ������');
        result := 0;
      end else
        result := 253;
    end else
      result := 0;
  end else
    result := 0;
end;


//-----------------------------------------------------------------------------
// ��������� ������ ���������� ������, �������� ������������� �� �������
//var
//  FixedDisconnect : array[1..2] of Boolean;
//  FixedConnect : array[1..2] of Boolean;
//  FDT : double;


function SyncDCReady : Boolean;
  var i,j : integer; b,c : boolean; d : byte;
begin
  result := false;
  if AppStart then exit; // �� ��������� ������������� �� ������������ ����� ���-������

  //
  // �������� ��������� �������� � ������ ������ ��
  //
  for i := 1 to WorkMode.LimitSoobDC do
  begin
    if LinkTCDC[i].Index[1] > 0  then
    begin
      b := GetFR3dc(LinkTCDC[i].Index[1]);
      c := ((FR3dc[i,1] and  $1) = $1);
      if b <> c then FR3dcn[i] := true;
      if b then d := (FR3dc[i,1] or $1)
      else d := (FR3dc[i,1] and ($ff-$1));
      FR3dc[i,1] := d;
    end;
    if LinkTCDC[i].Index[2] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[2]);  c := ((FR3dc[i,1] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $2)  else d := (FR3dc[i,1] and ($ff-$2));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[3] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[3]);  c := ((FR3dc[i,1] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $4)  else d := (FR3dc[i,1] and ($ff-$4));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[4] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[4]);  c := ((FR3dc[i,1] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $8)  else d := (FR3dc[i,1] and ($ff-$8));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[5] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[5]);  c := ((FR3dc[i,1] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $10) else d := (FR3dc[i,1] and ($ff-$10)); FR3dc[i,1] := d; end;

    if LinkTCDC[i].Index[6] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[6]);  c := ((FR3dc[i,2] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $1)  else d := (FR3dc[i,2] and ($ff-$1));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[7] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[7]);  c := ((FR3dc[i,2] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $2)  else d := (FR3dc[i,2] and ($ff-$2));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[8] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[8]);  c := ((FR3dc[i,2] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $4)  else d := (FR3dc[i,2] and ($ff-$4));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[9] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[9]);  c := ((FR3dc[i,2] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $8)  else d := (FR3dc[i,2] and ($ff-$8));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[10] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[10]); c := ((FR3dc[i,2] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $10) else d := (FR3dc[i,2] and ($ff-$10)); FR3dc[i,2] := d; end;

    if LinkTCDC[i].Index[11] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[11]); c := ((FR3dc[i,3] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $1)  else d := (FR3dc[i,3] and ($ff-$1));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[12] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[12]); c := ((FR3dc[i,3] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $2)  else d := (FR3dc[i,3] and ($ff-$2));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[13] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[13]); c := ((FR3dc[i,3] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $4)  else d := (FR3dc[i,3] and ($ff-$4));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[14] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[14]); c := ((FR3dc[i,3] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $8)  else d := (FR3dc[i,3] and ($ff-$8));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[15] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[15]); c := ((FR3dc[i,3] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $10) else d := (FR3dc[i,3] and ($ff-$10)); FR3dc[i,3] := d; end;

    if LinkTCDC[i].Index[16] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[16]); c := ((FR3dc[i,4] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $1)  else d := (FR3dc[i,4] and ($ff-$1));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[17] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[17]); c := ((FR3dc[i,4] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $2)  else d := (FR3dc[i,4] and ($ff-$2));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[18] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[18]); c := ((FR3dc[i,4] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $4)  else d := (FR3dc[i,4] and ($ff-$4));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[19] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[19]); c := ((FR3dc[i,4] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $8)  else d := (FR3dc[i,4] and ($ff-$8));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[20] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[20]); c := ((FR3dc[i,4] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $10) else d := (FR3dc[i,4] and ($ff-$10)); FR3dc[i,4] := d; end;

    if LinkTCDC[i].Index[21] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[21]); c := ((FR3dc[i,5] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $1)  else d := (FR3dc[i,5] and ($ff-$1));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[22] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[22]); c := ((FR3dc[i,5] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $2)  else d := (FR3dc[i,5] and ($ff-$2));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[23] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[23]); c := ((FR3dc[i,5] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $4)  else d := (FR3dc[i,5] and ($ff-$4));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[24] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[24]); c := ((FR3dc[i,5] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $8)  else d := (FR3dc[i,5] and ($ff-$8));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[25] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[25]); c := ((FR3dc[i,5] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $10) else d := (FR3dc[i,5] and ($ff-$10)); FR3dc[i,5] := d; end;
  end;

//
// ��� �������� ������������ �������� ������ � ������ �� ��
{  for i := 1 to WorkMode.LimitSoobDC do
    if FR3dcn[i] then
    begin
      sz := DateTimeToStr(Date+Time)+ ' > '+ LinkTCDC[i].Group+ ' '+ LinkTCDC[i].SGroup + '  '+ IntToHex(FR3dc[i,1],2)+ ' '+ IntToHex(FR3dc[i,2],2)+ ' '+ IntToHex(FR3dc[i,3],2)+ ' '+ IntToHex(FR3dc[i,4],2)+ ' '+ IntToHex(FR3dc[i,5],2);
      reportf(sz);
      FR3dcn[i] := false;
    end;}


  WrBuffer[0] := '(';
  WrBuffer[1] := 'A';
  WrBuffer[2] := LinkTCDC[CurrDCSoob].Group;
  WrBuffer[3] := LinkTCDC[CurrDCSoob].SGroup;
  WrBuffer[4] := char(FR3dc[CurrDCSoob,1] or $40);
  WrBuffer[5] := char(FR3dc[CurrDCSoob,2] or $40);
  WrBuffer[6] := char(FR3dc[CurrDCSoob,3] or $40);
  WrBuffer[7] := char(FR3dc[CurrDCSoob,4] or $40);
  WrBuffer[8] := char(FR3dc[CurrDCSoob,5] or $40);
  d := (byte(WrBuffer[1]) xor byte(WrBuffer[2]) xor byte(WrBuffer[3]) xor byte(WrBuffer[4]) xor byte(WrBuffer[5]) xor byte(WrBuffer[6]) xor byte(WrBuffer[7]) xor byte(WrBuffer[8])) or $40;
  WrBuffer[9] := char(d);
  WrBuffer[10] := ')';


  // ��������� ��������� �� ��������� ��������� ��� ����������� ��������
  if CurrDCSoob >= WorkMode.LimitSoobDC then CurrDCSoob := 1 else inc(CurrDCSoob);

  //
  // ��� ������ � ��-�� ������������ ��� ������ RS-422 � ���������� ������.
  // ������ �� ����� ����������, ������������ �� ���������� ������.
  //
  if KanalDC[1].active then
  begin
    WriteSoobDC(1); // ������ � 1-�� ����� ������
    i := ReadSoobDC(1,sz);
    KanalDC[1].lastcnt := i;
    KanalDC[1].rcvcnt := KanalDC[1].rcvcnt + i;
    if i > 0 then // ��������� ������ �� ������1
    begin
{      if not FixedConnect[1] then
      begin // ������������� �������������� ����� � ��������
        AddFixMessage(GetShortMsg(1,434,'1'),5,0); InsArcNewMsg(0,434+$2000);
      end;
      FixedConnect[1] := true;}
      if i >= 70 then begin inc(KanalDC[1].cnterr); KanalDC[1].lostcnt := 0; end;
      KanalDC[1].isrcv := true;  //???????????????????????????????????????????????????????
      if KanalDC[1].RcvPtr < 140 then KanalDC[1].iserror := false;
      if (i + KanalDC[1].RcvPtr) > sizeof(KanalDC[1].RcvBuf) then i := 0;
      for j := 0 to i-1 do begin KanalDC[1].RcvBuf[KanalDC[1].RcvPtr] := KanalDC[1].port.Buffer[j]; inc(KanalDC[1].RcvPtr); end;
      if KanalDC[1].RcvPtr > LnSoobSrv * 3 then
      begin
        inc(KanalDC[1].cnterr); // ��������� ������� ������ ������
        reportf('������������ �������� ������ ������ 1 �� ('+ IntToStr(KanalDC[1].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
        KanalDC[1].RcvPtr := 0;
      end else
        ExtractSoobDC(1); // ���������� ������ �� 1-�� ������
    end;
  end;

  if KanalDC[2].active then
  begin
    WriteSoobDC(2); // ������ �� 2-�� ����� ������
    i := ReadSoobDC(2,sz);
    KanalDC[2].lastcnt := i;
    KanalDC[2].rcvcnt := KanalDC[2].rcvcnt + i;
    if i > 0 then // ��������� ������ �� ������2
    begin
{      if not FixedConnect[2] then
      begin // ������������� �������������� ����� � ��������
        AddFixMessage(GetShortMsg(1,434,'2'),5,0); InsArcNewMsg(0,434+$2000);
      end;
      FixedConnect[2] := true;}
      if i >= 70 then begin inc(KanalDC[2].cnterr); KanalDC[2].lostcnt := 0; end;
      KanalDC[2].isrcv := true;
      if KanalDC[2].RcvPtr < 140 then KanalDC[2].iserror := false;
      if (i + KanalDC[2].RcvPtr) > sizeof(KanalDC[2].RcvBuf) then i := 0;
      for j := 0 to i-1 do begin KanalDC[2].RcvBuf[KanalDC[2].RcvPtr] := KanalDC[2].port.Buffer[j]; inc(KanalDC[2].RcvPtr); end;
      if KanalDC[2].RcvPtr > LnSoobSrv * 3 then
      begin
        inc(KanalDC[2].cnterr); // ��������� ������� ������ ������
        reportf('������������ �������� ������ ������ 2 �� ('+ IntToStr(KanalDC[2].RcvPtr)+' ����) '+ DateTimeToStr(LastTime));
        KanalDC[2].RcvPtr := 0;
      end else
        ExtractSoobDC(2); // ���������� ������ �� 2-�� ������
    end;
  end;
end;



function GetFR3dc(const param : Word) : Boolean;
  var p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7; // ����� �������������� ����
  p := param shr 3; // ����� �������������� �����
  if p > 4096 then exit;

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

//-----------------------------------------------------------------------------
// ��������� �������� � ����� ��
procedure WriteSoobDC(kanal : Byte);
begin
  if Assigned(KanalDC[kanal].port) then
  begin
    KanalDC[kanal].port.BufToComm(@WrBuffer[0],LnSoobDC);
    KanalDC[kanal].trmcnt := KanalDC[kanal].trmcnt + LnSoobDC; inc(KanalDC[kanal].tpkcnt);
  end;
end;

//-----------------------------------------------------------------------------
// ��������� ����� ������ �� ������
function ReadSoobDC(kanal: Byte; var rcv: string) : Integer;
begin
  result := 0;
  if Assigned(KanalDC[kanal].port) then result := KanalDC[kanal].port.BufFromComm(KanalDC[kanal].port.Buffer,sizeof(KanalDC[kanal].port.Buffer));
end;

//------------------------------------------------------------------------------
// ���������� ��������� �� �������
procedure ExtractSoobDC(kanal : Byte); // ���������� ��������� �� ��-��
  var i,l : integer;
  label loop;

begin
  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalDC[kanal].RcvPtr < LnSoobKvitDC then exit; // ���� ������ � ������
  i := 0;
  while i < KanalDC[kanal].RcvPtr do begin if KanalDC[kanal].RcvBuf[i] = '(' then break; inc(i); end; // ����� ���� � ��������� ������ ������

  if (i > 0) and (i < KanalDC[kanal].RcvPtr) then
  begin // �������� ������ ������ �� ������� ������ �����
    l := 0;
    while i < KanalDC[kanal].RcvPtr do begin KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l); end;
    KanalDC[kanal].RcvPtr := l;
  end;
  if KanalDC[kanal].RcvPtr < LnSoobKvitDC then exit; // ����� ������ ���� - ������ ������

  if KanalDC[kanal].RcvBuf[LnSoobKvitDC-1] = ')' then // ���� ������� ����� ������ �� ����� - ��������� ����������� �����
  begin
    KanalDC[kanal].cnterr := 0; // ����� �������� ������
    KanalDC[kanal].iserror := false;
    if KanalDC[kanal].RcvBuf[LnSoobKvitDC-2] = 'P' then // ���� ������� ���������
      inc(KanalDC[kanal].pktcnt); // ��������� ������� �������� �������

    // �������� �� ������ ������������ ����
    if KanalDC[kanal].RcvPtr > LnSoobKvitDC then
    begin
      l := 0; i := LnSoobKvitDC;
      while i < KanalDC[kanal].RcvPtr do
      begin
        KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l);
      end;
      KanalDC[kanal].RcvPtr := l;
    end else
    begin
      KanalDC[kanal].RcvPtr := 0; exit;
    end; // ��������� ���� ������ ��������� ������ ����
    goto loop;
  end else
  begin // ������� ����� ����� �� ������ - ���������� ����� � �������� ������
    l := 0; i := 1;
    while i < KanalDC[kanal].RcvPtr do
    begin
      KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l);
    end;
    KanalDC[kanal].RcvPtr := l; goto loop;
  end;
end;


//------------------------------------------------------------------------------
// ��������� � ����� ��������� ���������� ������ ������
procedure FixStatKanalDC(kanal : byte);
begin
  if Assigned(KanalDC[kanal].port) then
  begin
    reportf('����� '+IntToStr(kanal)+' �� : ���� ���������� '+IntToStr(KanalDC[kanal].trmcnt));
    reportf('����� '+IntToStr(kanal)+' �� : ������� ���������� '+IntToStr(KanalDC[kanal].tpkcnt));
    reportf('����� '+IntToStr(kanal)+' �� : ���� ������� '+IntToStr(KanalDC[kanal].rcvcnt));
    reportf('����� '+IntToStr(kanal)+' �� : ������� ������� '+IntToStr(KanalDC[kanal].pktcnt));
  end;
end;

end.
