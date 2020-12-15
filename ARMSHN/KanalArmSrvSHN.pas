unit KanalArmSrvSHN;
//****************************************************************************
//       ��������� ������ � ������� ������ - ��� ��
//****************************************************************************
{$INCLUDE d:\sapr2012\CfgProject}

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
  comport;


type TKanalErrors = (keOk,keErrCRC,keErrSrc,keErrDst);

const

PIPE_READING_SUCCESS = 1;
PIPE_WRITING_SUCCESS = 2;
PIPE_ERROR_STATE     = 3;
PIPE_EXIT            = 4;

LnSoobSrv  : integer = 70;    //------------------------------- ����� ��������� �� �������

function CreateKanalSrv : Boolean;                //--- ������� ���������� ������ TComPort
function DestroyKanalSrv : Boolean;               //----------- ���������� �������� ������
function GetKanalSrvStatus(kanal : Byte) : Byte;  //------------ �������� ��������� ������
function InitKanalSrv(kanal : Byte) : Byte;       //----------------- ������������� ������
function ConnectKanalSrv(kanal : Byte) : Byte;    //----------- ���������� ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte; //--------------- ������ ����� �� ������


function SyncReady : Boolean;
function GetFR5(param : Word) : Byte;

function ReadSoobCom(kanal: Byte; var rcv: string) : Integer; //-- ������ ������ COM-ports
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;     //-----  ����� ������ ������1 PIPEs
function ReadSoobPipe2(var RdBuf: Pointer) : DWORD;    //------ ����� ������ ������2 PIPEs
procedure WriteSoobCom(kanal: Byte);                   //------ �������� � ����� COM-ports
procedure WriteSoobPipe(kanal: Byte);                  //---------- �������� � ����� PIPEs
function SaveArch(const c: byte) : Boolean;       // ��������� � ������ �������� ���������
function AddCheck(kanal : Byte; crc : Word) : Boolean; //-------- �������� ����� ���������
function SendCheck(kanal : Byte; var crc : Word) : Boolean; //�������� ��������� ���������
procedure ExtractSoobSrv(kanal : Byte); //---------------- ���������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte); //--- ��������� ��������� �� �������
procedure SaveDUMP(buf,fname : string); //---------------- ���������� ��� - ������ �� ����
procedure SaveKanal;

implementation

uses
  TabloSHN,
  marshrut,

  commands,
  crccalc,
  commons,
  mainloop,
  TypeAll;

var
  OLS : TOverlapped;
  
  lpNBWri     : Cardinal;
  Buffer      : array[0..4097] of char;
  WrBuffer    : array[0..4097] of char; //--------------------------- ����� ������ � �����
  sz          : string;  
  stime       : string;
  tbuf        : string;
  stmp : string;
  errch : array[1..2] of integer;
  errfix : array[1..2] of Boolean;
//========================================================================================
//----------------------------------------------------- ������� ���������� ������ TComPort

function CreateKanalSrv : Boolean;
begin
  try
    if KanalSrv[1].Index > 0 then
    begin // ���������������� ����
      if KanalSrv[1].nPipe = '' then KanalSrv[1].port := TComPort.Create(nil);
    end else
    begin // �����
      if KanalSrv[1].nPipe <> '' then
      begin
        RcvOLS[1].hEvent := CreateEvent(nil,true,true,nil);
        TrmOLS[1].hEvent := CreateEvent(nil,true,true,nil);
      end;
    end;
    if KanalSrv[2].Index > 0 then
    begin
      if KanalSrv[2].nPipe = '' then KanalSrv[2].port := TComPort.Create(nil);
    end;
    result := true;
  except
    result := false;
  end;
end;
















//========================================================================================
//------------------------------------------------------------- ���������� �������� ������
function DestroyKanalSrv : Boolean;
begin
  try
    if Assigned(KanalSrv[1].port) then KanalSrv[1].port.Destroy else
    begin
      if CloseHandle(RcvOLS[1].hEvent) then RcvOLS[1].hEvent := INVALID_HANDLE_VALUE;
      if CloseHandle(TrmOLS[1].hEvent) then TrmOLS[1].hEvent := INVALID_HANDLE_VALUE;
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

//========================================================================================
//------------------------------------------------------------------- ������������� ������
function InitKanalSrv(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    RepF('������ 255 ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  if Assigned(KanalSrv[kanal].port) then
  begin // ���-����
    if KanalSrv[kanal].port.InitPort(IntToStr(KanalSrv[kanal].Index)+ ','+ KanalSrv[kanal].config) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('��������� ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('������ 254 ������������� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 254;
    end;
  end else
  if KanalSrv[kanal].nPipe = 'null' then result := 0 else
  begin // �����
    if kanalSrv[kanal].nPipe <> '' then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('��������� ������������� �����'+ IntToStr(kanal)+ ' '+ stime);
    end;
    result := 0;
  end;
end;


//----------------------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------
// ���������� ����� �� ������
function ConnectKanalSrv(kanal : Byte) : Byte;
  var Dummy : ULONG;
begin
  if (kanal < 1) or (kanal > 2) or
     ((KanalSrv[kanal].port = nil) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    RepF('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  KanalSrv[kanal].RcvPtr := 0;
  if KanalSrv[kanal].nPipe = '' then
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
      RepF('��������� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('�� ������� ������� ���������������� ���� ������'+ IntToStr(kanal)+ ' '+ stime);
    end;
  end else
  begin // �����
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
        RepF('�� ������� ������� ����� ������'+ IntToStr(kanal)+ ' (��� ������ '+IntToStr(GetLastError()) +') '+ stime);
      end else
      begin
        KanalSrv[1].State := 0; // ��������� ������ �� �����, ��������� ��������� � ���������
        CreateThread(nil,0,@ReadSoobPipe,nil,0,Dummy); // ������ ������������ ������ �����
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        RepF('��������� ����������� � ������� �� ������ '+ KanalSrv[kanal].nPipe + ' '+ stime);
        KanalSrv[kanal].active := true;
        result := 0;
      end;
    end else
      result := 0;
  end;
end;

//========================================================================================
//----------------------------------------------------------------- ������ ����� �� ������
function DisconnectKanalSrv(kanal : Byte) : Byte;
begin
  try
    if (kanal < 1) or (kanal > 2) or
    (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('������ ��� �������� ����������������� ����� ������'+ IntToStr(kanal)+ ' '+ stime);
      result := 255;
      exit;
    end;

    if Assigned(KanalSrv[kanal].port) then
    begin // COM-����
      if KanalSrv[kanal].port.PortIsOpen then
      begin
        if KanalSrv[kanal].port.ClosePort then
        begin
          KanalSrv[kanal].active := false;
          DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
          RepF('���������������� ���� ������'+ IntToStr(kanal)+ ' '+ stime+ ' ������');
          result := 0;
        end
        else result := 253;
      end
      else result := 0;
    end else
    if (KanalSrv[kanal].nPipe <> '') and (KanalSrv[kanal].nPipe <> 'null') then
    begin // �����
      if KanalSrv[kanal].hPipe = INVALID_HANDLE_VALUE then begin result := 0; exit; end
      else
      if CloseHandle(KanalSrv[kanal].hPipe) then
      begin result := 0; KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE; end
      else result := 253;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      RepF('�������� ����� ������ � �������� '+ KanalSrv[kanal].nPipe+ ' '+ stime);
      KanalSrv[kanal].State := PIPE_EXIT;
      KanalSrv[kanal].active := false;
    end
    else result := 0;
  except
    RepF('������ � DisconnectKanalSrv');
    Application.Terminate; result := 252;
  end;
end;

//----------------------------------------------------------------------------------------
var
  FixedDisconnect,FixedConnect : Boolean;
  FDT : double;

//========================================================================================
//------------------ ��������� ������ ���������� ������, �������� ������������� �� �������
function SyncReady : Boolean;
var
  i,j : integer;
begin
  result := false;
  if AppStart then exit; //--- �� ��������� ������������� �� ������������ ����� ���-������

  if KanalSrv[1].active then
  begin
    case KanalSrv[1].State of
      PIPE_READING_SUCCESS :
      begin //------------------------------------------- ��������� ������ �� ������ �����
        if not FixedConnect then
        begin //---------------------------- ������������� �������������� ����� � ��������
          AddFixMes(GetSMsg(1,434,'',0),5,0);
          InsNewMsg(0,434+$2000,0,'');
        end;
        FixedConnect := true;
        KanalSrv[1].iserror := false;
        KanalSrv[1].rcvcnt := KanalSrv[1].RcvPtr;
        if KanalSrv[1].rcvcnt > 0 then //----------------------- ��������� ������ �� �����
        begin
          if KanalSrv[1].rcvcnt > 70 then  inc(KanalSrv[1].cnterr)
          else KanalSrv[1].cnterr := 0;
          KanalSrv[1].isrcv := true;
          MySync[1] := true;

          if KanalSrv[1].RcvPtr > LnSoobSrv * 3 then
          begin
            inc(KanalSrv[1].cnterr); //------------------- ��������� ������� ������ ������
            RepF('���������� ����� ������ 1 ('+IntToStr(KanalSrv[1].RcvPtr)+' ���� )'
            + DateTimeToStr(LastTime));
            KanalSrv[1].RcvPtr := 0;
          end
          else ExtractSoobSrv(1); //------------------------- ���������� ������ �� �������
        end;
        KanalSrv[1].State := 0; //----------- ��������� ����������� ������ ������ �� �����
        MySync[1] := true;
        MyMarker[1] := false;
        KanalSrv[1].issync := true;
      end;

      PIPE_ERROR_STATE : KanalSrv[1].active := false; //--------- ������� ����� � ��������

      PIPE_EXIT :
      begin //--------------------------------------------------- ���������� ������ ������
        result := true;
        exit;
      end;
    end;
    WriteSoobPipe(1);
  end else
  begin
    if KanalSrv[1].State <> PIPE_EXIT then
    begin //-------- ���� �� ���� ���������� ������������ ������ - ����������� ����� �����
      //------------------------------- � �������� �������������� ���������� ����� 10 ���.
      KanalSrv[1].iserror := true;
      if FixedDisconnect then
      begin
        if FDT < LastTime then
        begin
          DisconnectKanalSrv(1);
          if (ConnectKanalSrv(1) > 0) and FixedConnect then
          begin
            AddFixMes(GetSMsg(1,433,'1',0),4,4);
            InsNewMsg(0,433+$1000,0,'');  //------------------- �������������� ����� � ��� $
          end;
          FixedDisconnect := false;
          FixedConnect := false;
        end;
      end else
      begin
        FixedDisconnect := true;
        FDT := LastTime + 10/86400;
      end;
    end;
  end;
end;



function GetFR5(param : Word) : Byte;
begin
  result := FR5[param];
  FR5[param] := 0; // �������� ��������
end;

//-----------------------------------------------------------------------------
// ��������� �������� � �����

// ��� ���-������
procedure WriteSoobCom(kanal : Byte);
  var next : boolean; crc : crc8_t; i,j,k : integer; a,b,bl,bh : byte;
  w,wyr,wmt,wdy,whr,wmn,wsc,wmsc : word; uts : TDateTime;
begin
  if KanalSrv[kanal].port <> nil then
  begin
    next := false;
    a := config.RMID; a := a shl 4; a := a + LastSrv[kanal]; // ���������� ���������
    // ������������ ���� ���������
    b := config.ru; // ����� ����������
    if WorkMode.KOK_TUMS then b := b + $20;
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
      WrBuffer[j] := char(_autoDT); inc(j);
      NewCmd[kanal] := NewCmd[kanal] + char(_autoDT);
      w := wSc and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wMn and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wHr and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wDy and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wMt and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wYr - 2000;  WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
      WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
    end else
    if (DoubleCnt > 0) and (ParamDouble.Cmd = _newDT) then
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


    if not WorkMode.LockCmd then
    begin // �������� ������� � ������ ���� ��� ������� ��

      if WorkMode.MarhRdy then
      begin // ���������� ������� �� ��� ������ � �������� �� ������
        WorkMode.MarhRdy := false;
        WrBuffer[j] := char(MarhTrac.MarhCmd[10]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[1]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[2]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[3]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[4]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[5]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[6]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[7]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[8]); inc(j);
        WrBuffer[j] := char(MarhTrac.MarhCmd[9]); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(MarhTrac.MarhCmd[10]) +
        char(MarhTrac.MarhCmd[1])   + char(MarhTrac.MarhCmd[2]) +
        char(MarhTrac.MarhCmd[3]) + char(MarhTrac.MarhCmd[4]) +
        char(MarhTrac.MarhCmd[5]) + char(MarhTrac.MarhCmd[6]) +
        char(MarhTrac.MarhCmd[7]) + char(MarhTrac.MarhCmd[8]) +
        char(MarhTrac.MarhCmd[9]);
      end;

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
        WrBuffer[j] := char(k + _kvitancija); inc(j);
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
end;
//========================================================================================
//------------------------------------------------------------------------------ ��� �����
procedure WriteSoobPipe;
var
  next : boolean;
  crc : crc8_t;
  i,j,k : integer;
  a,b,bl,bh : byte;
  w: word;
  cErr : cardinal;
begin
  try
    if (KanalSrv[1].nPipe <> '') and KanalSrv[1].active then
    begin
      KanalSrv[1].iserror := false;
      KanalSrv[1].cnterr := 0;
      MySync[1] := false;
      if not (SyncCmd or (DoubleCnt > 0)
      or WorkMode.MarhRdy or (Cmdcnt > 0)
      or (DoubleCnt > 0) or (LastCRC[1] > 0)) then  exit;
      MySync[1] := true;
      next := false;
      a := config.RMID; a := a shl 4; a := a + LastSrv[1]; //-------- ���������� ���������

      //------------------------------------------------------ ������������ ���� ���������
      b := config.ru; //------------------------------------------------- ����� ����������
      if WorkMode.KOK_TUMS then b := b + $20;
      if not WorkMode.OKError then b := b + $40;
      if WorkMode.PushRU then b := b + $80;

      j := 0;
      WrBuffer[j] := #$AA; inc(j);
      WrBuffer[j] := char(a); inc(j);
      WrBuffer[j] := char(b); inc(j);
      //----------------------------------------------------------------------------------
      if (DoubleCnt > 0) and (ParamDouble.Cmd = _newDT) then
      begin //----------------------------------------------------------- �������� �������
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[8]);
      end;

      //------------------------------------ �������� ������� � ������ ���� ��� ������� ��
      if (not WorkMode.LockCmd) or (CmdBuff.Cmd = _logoff) then
      begin
        if CmdCnt > 0 then
        begin //-------------------------------------------------- �������� ������� ������
          WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
          NewCmd[1] := NewCmd[1] + char(CmdBuff.Cmd);
          bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
          WrBuffer[j] := char(bl); inc(j); NewCmd[1] := NewCmd[1] + char(bl);
          WrBuffer[j] := char(bh); inc(j); NewCmd[1] := NewCmd[1] + char(bh);
          CmdCnt := 0;
//          if SendToSrvCloseRMDSP then SendToSrvCloseRMDSP := false;
        end;
      end else
      begin //------------------- �������� ��� ����������� ������� ���� ���� ���������� ��
        DoubleCnt := 0;
        Cmdcnt := 0;
        WorkMode.MarhRdy := false;
      end;

      if LastCRC[1] > 0 then
      begin //--------------------------------------------------------- �������� ���������
        if j < 25 then
        begin
          k := LastCRC[1];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; //---------------- ���������� ���-�� ���������� ���������
            next := true;        //--------------- ��������� ������� ����������� ���������
          end;
          WrBuffer[j] := char(k + _kvitancija); inc(j);
          while k > 0 do
          begin
            SendCheck(1,w);
            b := w div $100;
            WrBuffer[j] := char(w - (b * $100)); inc(j);
            WrBuffer[j] := char(b); inc(j);
            dec(k);
          end;
        end;
      end;

      while j < 26 do begin WrBuffer[j] := #0; inc(j); end; // ��������� �� �������� �����

      crc := CalculateCRC8(@WrBuffer[1],25);
      WrBuffer[j] := char(crc); inc(j);
      WrBuffer[j] := #$55; inc(j);

      i := 0;
      while next do
      begin //------------------------------ ������� ���������� ��������� ��������� ������
        i := i+28; j := 0;
        WrBuffer[i+j] := #$AA; inc(j);
        WrBuffer[i+j] := char(a); inc(j);
        WrBuffer[i+j] := char(b); inc(j);
        if LastCRC[1] > 0 then
        begin //------------------------------------------------------- �������� ���������
          if j < 25 then
          begin
            k := LastCRC[1];
            if (2 * k) > (25 - j) then
            begin
              k := (25 - j) div 2; //-------------- ���������� ���-�� ���������� ���������
              next := true;        //-------------------- ��������� ������� ����������� ��
            end
            else  next := false;
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
        while j < 26 do begin WrBuffer[i+j] := #0;inc(j);end;//��������� �� �������� �����
        crc := CalculateCRC8(@WrBuffer[i+1],25);
        WrBuffer[i+j] := char(crc); inc(j);
        WrBuffer[i+j] := #$55; inc(j);
      end;

      if j > 0 then
      begin //-------------------------------------------------- ���������� ������ � �����
        if not WriteFile(KanalSrv[1].hPipe, WrBuffer, j, lpNBWri, @TrmOLS) then
        begin
          cErr := GetLastError;
          case cErr of
            ERROR_PIPE_NOT_CONNECTED : KanalSrv[1].iserror := true;
            ERROR_IO_PENDING :  KanalSrv[1].iserror := false;
          end;
          MySync[1] := true;
          KanalSrv[1].issync := true;
        end
        else KanalSrv[2].iserror := false;
      end;
    end;
  except
    RepF('������ [KanalArmSrvSHN.WriteSoobPipe]');
    Application.Terminate;
  end;
end;

//========================================================================================
//-------------------------------------------- ��������� ����� ������ �� ������ ��� ������
function ReadSoobCom(kanal: Byte; var rcv: string) : Integer;
var
  razmer : Integer;
begin
  result := 0;
  razmer := sizeof(KanalSrv[kanal].port.Buffer);
  if KanalSrv[kanal].port <> nil then //------------------ ���� � ������ �������� Com-����
  begin
    result := KanalSrv[kanal].port.BufFromComm(KanalSrv[kanal].port.Buffer,razmer);

    if savearc then
    begin //------------------------- ��������� ������ �� ������ - ��������������� �������

      if kanal = 1 then chnl1 := chnl1 + rcv else
      if kanal = 2 then chnl2 := chnl2 + rcv;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------------------------- ��� ����� - ������ ������
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;
var
  i : integer;
  cbRd,cbTRd : cardinal;
  LastError : DWORD;
begin
  try
    LastError := 0;
    while true do
    begin
      if KanalSrv[1].hPipe = INVALID_HANDLE_VALUE then
      begin
        KanalSrv[1].iserror := true;
        break;
      end;
      case KanalSrv[1].State of
        PIPE_ERROR_STATE : break; //-------------- ����� ���� ������ ����������� � �������
        PIPE_EXIT :
        begin
          ExitThread(0);
          result := 0;
          exit; //------------------------------------ ��������� ������������ ������ �����
        end;
      else //------------------------------------------------------------- ������ �� �����
      if GetNamedPipeHandleState(KanalSrv[1].hPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile( KanalSrv[1].hPipe, Buffer, 70, cbRd, @RcvOLS) then
        begin //----------------------------------------------------- ���������� � �������
          LastError := GetLastError;
          if LastError = ERROR_IO_PENDING then
          begin
            //---------------------------------------------- ����� ����� �������� �� �����
            WaitForSingleObject(RcvOLS[1].hEvent, 31);
            CancelIO(KanalSrv[1].hPipe);
          end else
          begin //----------------------------------------------- ����� �� ��������� �����
            KanalSrv[1].iserror := true; 
            break;
          end;
        end;
        GetOverlappedResult(KanalSrv[1].hPipe,RcvOLS[1],cbTRd,false);
        if cbTRd > 0 then
        begin
          if (KanalSrv[1].RcvPtr + cbTRd) < RCV_LIMIT then
          begin //----------------------------------------------------- ���������� � �����
            for i := 0 to cbTRd-1 do
            begin
              KanalSrv[1].RcvBuf[KanalSrv[1].RcvPtr] := Buffer[i];
              inc(KanalSrv[1].RcvPtr);

              if savearc then //----- ��������� ������ �� ������ - ��������������� �������
                chnl1 := chnl1 + Buffer[i];
            end;
            KanalSrv[1].State := PIPE_READING_SUCCESS;
          end else
          begin //- ����������� ��������� ������ �� ������ ������� ��� ������������ ������
            KanalSrv[1].iserror := true;
            KanalSrv[1].RcvPtr := 0;
          end;
        end;
      end else
      begin //--------------------- ���������� ����� ���� ���������� ������ ������� ������
        KanalSrv[1].iserror := true;
        break;
      end;
    end;
  end;
  RepF('��� ������ ����� '+ IntToStr(LastError));
  KanalSrv[1].State := PIPE_ERROR_STATE;
  ExitThread(99); //------------------------ ��������� ������������ ������ ����� �� ������
  result := 0;
  except
    RepF('������ [KanalArmSrv.ReadSoobPipe]');
    Application.Terminate;
    ExitThread(99);
    result := 0;
  end;
end;
//========================================================================================
//------------------------------------------------------------ ��� ����� - ������ ������ 2
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
  RepF('��� ������ �����2 '+ IntToStr(LastError));
  KanalSrv[2].State := PIPE_ERROR_STATE;
  ExitThread(99); // ��������� ������������ ������ ����� �� ������
  result := 0;
except
  RepF('������ [KanalArmSrv.ReadSoobPipe2]'); Application.Terminate; ExitThread(99); result := 0;
end;
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
  if hfile = INVALID_HANDLE_VALUE then begin RepF('������ '+IntToStr(GetLastError)+' �������� ����� ������'); result := false; exit; end;
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
          if WorkMode.LimitFRI > 125 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // ������� ������ 126-250 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 250 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // ������� ������ 251-375 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 375 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // ������� ������ 376-500 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 500 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // ������� ������ 501-625 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 625 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // ������� ������ 626-750 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 750 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // ������� ������ 751-875 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 875 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // ������� ������ 876-1000 ��������
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 1000 then
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
        if WorkMode.LimitFRI > 125 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // ������� ������ 126-250 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 250 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // ������� ������ 251-375 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 375 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // ������� ������ 376-500 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 500 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // ������� ������ 501-625 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 625 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // ������� ������ 626-750 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 750 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // ������� ������ 751-875 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 875 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // ������� ������ 876-1000 ��������
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 1000 then
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
      RepF('������ '+IntToStr(GetLastError)+' ������ � ���� ������.'); result := false;
    end;
  end else
  begin
    RepF('������ '+ IntToStr(GetLastError)+ ' ��� ����������� ��������� � ����� ����� ������.'); result := false;
  end;
//  if not FlushFileBuffers(hfile) then begin ShowMessage('������ '+ IntToStr(GetLastError)+ ' �� ����� ������ ����� ������ �� ������� ����.'); result := false; end;
  finally
    if not CloseHandle(hfile) then begin RepF('������ '+ IntToStr(GetLastError)+' �������� ����� ������.'); result := false; end;
    case c of
      1 : begin
        NewFR[1] := ''; NewFR[2] := ''; NewCmd[1] := ''; NewCmd[2] := ''; // ����� ������� ������
        NewMenuC := ''; // ����� ������ ������ ����
        NewMsg := '';   // ����� ������ ��������������� ���������
      end;

    end;
  end;
end;

//========================================================================================
//------------------------------------------------------------ �������� ��������� � ������
function AddCheck(kanal : Byte; crc : Word) : Boolean;
var
  i : integer;
begin
  if LastCRC[kanal] < High(BackCRC) then    //-------------- ���� ��� ��������� ���� �����
  begin
    inc(LastCRC[kanal]);
    BackCRC[LastCRC[kanal],kanal]  := crc;
    result := true;
  end else    //----------------------------------------------- ���� ����� ��������� �����
  begin
    for i := 1 to High(BackCRC)-1 do
    begin
      BackCRC[i,kanal] := BackCRC[i+1,kanal]; //------- ������ ���� ����� ������ ���������
    end;
    BackCRC[LastCRC[kanal],kanal] := crc;
    result := false;
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

//========================================================================================
//-------------------------------------------------------- ���������� ��������� �� �������
procedure ExtractSoobSrv(kanal : Byte);
var
  pb : char;
  i,j,l : integer;
  dc : cardinal;
  i64 : int64;
  b,bl,bh,mm : byte;
  w,ww,dw : word;
  crc,pcrc : crc16_t;
  label  loop;
begin
  //  KanalSrv[kanal].RcvPtr := 80;

  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; //---------------- ���� ������ � ������
  i := 0;
  while i < KanalSrv[kanal].RcvPtr do
  begin
    if KanalSrv[kanal].RcvBuf[i] = #$AA then break;
    inc(i);
  end; //-------------------------------------------- ����� ���� � ��������� ������ ������

  if (i > 0) and (i < KanalSrv[kanal].RcvPtr) then
  begin //--------------------------------- �������� ������ ������ �� ������� ������ �����
    l := 0;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; //- �������� ������ � ������
      inc(i);
      inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l;
  end;

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; //--- ����� ������ ���� - ������ ������

  if KanalSrv[kanal].RcvBuf[LnSoobSrv-1] = #$55 then //-------- ���� ����� ������ �� �����
  begin  //--------------------------------------------------- ��������� ����������� �����
    w := byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-3])+ //----- ��������� �� ������ ����� � ��
    byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-2]) * 256;
    pcrc := crc16_t(w); //------------------------------------------------ �� �� ���������

    crc := CalculateCRC16(@KanalSrv[kanal].RcvBuf[1],LnSoobSrv-4); //--- ������ ������� ��

    if crc = pcrc then
    begin  // �������� ������������� ��������� - ����������� ������ (t - ���������� �����)
      KanalSrv[kanal].cnterr := 0; //------------------------------- ����� �������� ������
      KanalSrv[kanal].iserror := false;
      // rcvkvit := rcvkvit + ',' + IntToStr(crc)+ ':'+ IntToStr(kanal);

      //�������� ��������� � �����, ���� �� ����� ��������� ����� �������������� ���������
      if not AddCheck(kanal,crc) then inc(KanalSrv[kanal].cnterr);

      j := 1; //--------------------------------------------------------- ������ ���������
      b := byte(KanalSrv[kanal].RcvBuf[j]); //------------------------- ������ ������ ����
      mm := b and $0f; //------------------------------------------------- �������� ������

      if (config.RMID = mm) and //---------------------------------- ���� ��� ������ � ...
      (LastTime - LastRcv < AnsverTimeOut) then  //---- ������ �������� ���������� �������
        MyMarker[kanal] := true //------------------- ��������� �������� ��������� �������
      else
      MyMarker[kanal] := false; //---- ���� ������ ������ ������ ������� ������ ���-������

      LastRcv := LastTime; //----------- ����������� ����� ������ ���������� ������� �����

      //-------------------------------------------- �������� ����� �������������� �������
      SrvState := 0;
      b := b and $f0;
      SrvState := b;
      b := b shr 4;
      LastSrv[kanal] := b;

      inc(j); //--------------------------- ������� �� ���� ��������� ����������� � ������

      if config.RMID = mm then //---------------------------------------- ���� ���� ������
      StateRU := byte(KanalSrv[kanal].RcvBuf[j]); //---------- ��������� ��������� �������

      WorkMode.LockCmd := ((StateRU and $10) = 0);//�������� ������� ���������� �� �������

      SrvState := SrvState or (StateRU and 7);//���������� ����� � ��������� �����.�������

      if WorkMode.LockCmd then  //-------------------- ���� ���� ���������� �� ������� ...
      SrvState := SrvState or 8; //--------------- ��������� �������, ��� ��������� 2 ����

      if char(SrvState) <> FR3inp[WorkMode.ServerStateSoob] then //--- ���� ���� ���������
      begin //--------------------------- ��������� ����� �������� ����� ��������� �������
        bl := WorkMode.ServerStateSoob and $ff;
        bh := (WorkMode.ServerStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(SrvState);//---- �������
        FR3inp[WorkMode.ServerStateSoob] := char(SrvState); //-------- ������������� �����
      end;

      if config.configKRU <> 0 then
      begin //-------- ���� ������������� - ���� ��� ������������ ��� ���������� ���������
        if not WorkMode.PushRU then
        StateRU := StateRU and $7f;
      end;

      DirState[1] := (StateRU and $f0)+(config.ru and $0f); //-- ���� ��������� ����������
      FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);

      if WorkMode.Upravlenie <> ((StateRU and $80) = $80) then
      begin //--------------------------------------- ������������ ����� ������ ����������
        FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
        bl := WorkMode.DirectStateSoob and $ff;
        bh := (WorkMode.DirectStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
        StDirect := (StateRU and $80) = $80;
        ChDirect := true;
      end;

      if config.configKRU = 0 then
      begin //--------------------------- ������� � ������ ����� ���������� ��� �������� 0
        WorkMode.PushRU := (StateRU and $80) = $80;
      end;
      inc(j);
      SVAZ := byte(KanalSrv[kanal].RcvBuf[j]); //�������� ���� ����������� ��������� �����
      inc(j); //------------------------------------------------ ���������� ��������� ����
      //--------------------------------------------------------------------- ������ �����
      while j < LnSoobSrv-3 do //------------------------------- ���� �� ����������� �����
      begin
        bl := byte(KanalSrv[kanal].RcvBuf[j]);
        inc(j);
        if j > LnSoobSrv-4 then break;
        bh := byte(KanalSrv[kanal].RcvBuf[j]);
        w := bh * 256 + bl; //------------------------------------ ������ �������� (�����)
        inc(j);
        if j > LnSoobSrv-4 then break;
        pb := KanalSrv[kanal].RcvBuf[j];  //-------------------- �������� ��������� (����)
        inc(j);

        if w <> 0 then //------------------------------------------- ���� ����� �� �������
        begin
          b := byte(pb);
          if w = WorkMode.DirectStateSoob then //--------- ���� ��� ������� ��������� ����
          begin //------------------------------ ������������� ������� �� ��������� ������
            if config.RMID = mm then   //--------------------------------- ���� ��� ������
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
              if not WorkMode.Upravlenie then
              begin
                if (b and $0f) > 0 then
                begin //------------------------------------------- ����� ����� ����������
                  if config.ru <> (b and $0f) then
                  begin //----------------------------------------------- ����� ����������
                    ChRegion := true;
                    NewRegion := (b and $0f);
                  end;
                end;
              end;
            end;
          end else

          if (w > 0) and (w < 4096) then //------------------------- ��������� ������� FR3
          begin
            if pb <> FR3inp[w] then//--------------------------------------------- �������
            begin
              FR3inp[w] := pb;
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
            end;
            FR3s[w] := LastTime;
          end else

          if (w >= 4096) and (w < 5120) then //------- 2-� ������� ������ � ��������������
          begin
            if j > LnSoobSrv-4 then break;
            ww := w - 4096;
            dw := ww shl 8;
            dw := dw + b;
            if FR6[ww] <> dw then
            begin
              NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j];
              NewFr6 := dw;
            end;
            FR6[ww] := dw;
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if w = 5120  then   //------- 4-� ������� ������ ������� ���� �� ������ ������
          begin
            if j + 2 > LnSoobSrv-4 then break;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb +
            KanalSrv[kanal].RcvBuf[j] +
            KanalSrv[kanal].RcvBuf[j+1]+
            KanalSrv[kanal].RcvBuf[j+2];
            FR7 := b shl 24;
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 16;
            FR7 := FR7+dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 8;
            FR7 := FR7 + dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]);
            FR7 := FR7 + dc; inc(j);
          end else
          if w = 5121 then //-------- 4-� ������� ������ ������� ���� �� �������� ������
          begin
            if j+2 > LnSoobSrv-4 then break;
            NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j]+
            KanalSrv[kanal].RcvBuf[j+1]+ KanalSrv[kanal].RcvBuf[j+2];
            FR9 := b;
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 8;
            FR9 := FR9 + dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 16;
            FR9 := FR9 + dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 24;
            FR9 := FR9 + dc; inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w >= 6144) and (w < 7168) then //--------- 8-� ������� ������ ����� � ����
          begin
            if j + 6 > LnSoobSrv - 4 then break;
            ww := w - 6143;
            NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j]+
            KanalSrv[kanal].RcvBuf[j+1] + KanalSrv[kanal].RcvBuf[j+2] +
            KanalSrv[kanal].RcvBuf[j+3] + KanalSrv[kanal].RcvBuf[j+4] +
            KanalSrv[kanal].RcvBuf[j+5] + KanalSrv[kanal].RcvBuf[j+6];
            FR8 := b;
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 8;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 16;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 24;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 32;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 40;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 48;
            FR8 := FR8 + i64; inc(j);
            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 56;
            FR8 := FR8 + i64; inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w >= 7168) and (w < 8191) then //----------------------------- ������ ASCIIZ
          begin
            sz := pb;
            while ((KanalSrv[kanal].RcvBuf[j] > #0) and (j < LnSoobSrv-3)) do
            begin
              sz := sz + KanalSrv[kanal].RcvBuf[j];
              inc(j);
            end;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + sz; //- sz - ������ ASCII
            inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $8000 then //---------------------------------- ��������� FR4
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              if pb <> FR4inp[ww] then //----------------------------------------- �������
              begin
                FR4inp[ww] := pb;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
              FR4s[ww] := LastTime;
            end;
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $4000 then //----------- ��������� �� �������, ������� ������
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              if (mm = config.RMID) and WorkMode.CmdReady then
              begin //------------------------------------- ��������� ��������� �� �������
                KvitancijaFromSrv(ww,b);
              end;
            end;
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $2000 then //------ ���� ����������� ��������� �������� (FR5)
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              if not ((ww = LastDiagI) and (b = LastDiagN)) then
              begin
                FR5[ww] := FR5[ww] or b;
                LastDiagN := b;  LastDiagI := ww;  LastDiagD := LastTime + 2/80000;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
            end;
          end else
          begin
            //--- ����������� ������ - �������� ����� ������ � ���������� ������� ������
            LastTime := date+time;
            inc(KanalSrv[kanal].pktlost); //- ��������� ������� ���������� ������ � ������
            inc(errch[kanal]); errfix[kanal] := true; stmp := '';
            for l := 0 to LnSoobSrv-1 do stmp := stmp + KanalSrv[kanal].RcvBuf[l];

             SaveDUMP(stmp,config.arcpath+ '\kanal'+IntToStr(kanal)+'.dmp');
             KanalSrv[kanal].iserror := true;
             MsgStateRM := '��������� ������ � ������'+ IntToStr(kanal);
             MsgStateClr := 1;
             break;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if KanalSrv[kanal].RcvPtr > LnSoobSrv then //-- �������� �� ������ ������������ ����
      begin
        l := 0; i := LnSoobSrv;
        while i < KanalSrv[kanal].RcvPtr do
        begin
          KanalSrv[kanal].RcvBuf[l] :=
          KanalSrv[kanal].RcvBuf[i];inc(i);inc(l);//----------------------- ����� � ������
        end;
        KanalSrv[kanal].RcvPtr := l;
      end else
      begin
        KanalSrv[kanal].RcvPtr := 0;  exit; // ��������� ���� ������ ��������� ������ ����
      end;
      goto loop;
    end else
    begin //--------------- ����������� ����� ������� - ���������� ����� � �������� ������
      l := 0; i := 1;
      while i < KanalSrv[kanal].RcvPtr do
      begin
        KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l);
      end;
      KanalSrv[kanal].RcvPtr := l; goto loop;
    end;
  end else
  begin //------------- ������� ����� ����� �� ������ - ���������� ����� � �������� ������
    l := 0; i := 1;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i];
      inc(i); inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l; goto loop;
  end;
end;
//========================================================================================
//--------------------------------------------------------- ��������� ��������� �� �������
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte);
begin
  WorkMode.CmdReady := false; // �������������� ����� ������� �� ���������

  if Obj > High(ObjZv) then
  begin
    RepF('�������� ��������� �� �������������� ������ � �������� '+ IntToStr(Obj)); exit;
  end;

  case Kvit of
    1 : begin // ��������� � ���������� ���������� �������
      if Obj <> WorkMode.DirectStateSoob then
      begin
        MsgStateRM := GetSMsg(2,Kvit,LastMsgToDSP,0); MsgStateClr := 2;
      end;
    end;
    2 : begin // ��������� �� ������ �� ���������� ������� ����������� ����������
      MsgStateRM := GetSMsg(2,Kvit,ObjZv[Obj].Liter,0); MsgStateClr := 1;
    end;
    3 : begin // ����� �� ���������� ���������� �������
      MsgStateRM := GetSMsg(2,Kvit,ObjZv[Obj].Liter,0); MsgStateClr := 1;
    end;
    4 : begin // ��������� � ���������� ������� �������� �� �������
      MsgStateRM := GetSMsg(2,Kvit,ObjZv[Obj].Liter,0); MsgStateClr := 2;
    end;
    5 : begin // ����� �� ���������� ������� �������� �� �������
      MsgStateRM := GetSMsg(2,Kvit,ObjZv[Obj].Liter,0); MsgStateClr := 1;
      VytajkaOZM(Obj); // �������� ���������� �����, ������������ � ������
    end;
    6..61 : begin
      MsgStateRM := GetSMsg(2,Kvit,ObjZv[Obj].Liter,0); MsgStateClr := 1;
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
