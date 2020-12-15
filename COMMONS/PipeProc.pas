unit PipeProc;

////////////////////////////////////////////////////////////////////////////////
//
//         ��������� ������ � ������������ �������� ������ �� ���� ���
//
//
//   ����       23 ������ 2006 ����
//
//   ������     1
//
//   ��������   2
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

const
  ASU1_BUFFER_LENGTH = 1024;
  ARC_BUFFER_LENGTH = 4096;
  ASU_TIMER_INTERVAL = 3757;


function InitpSD : Boolean;                             // �������� ������� ����������� ������������
function InitEventPipes : Boolean;                      // ������� ������� ��� ��������� ����
procedure DspToDspServerProc(Param : Pointer); stdcall; // ��������� ����� Dsp - Dsp (������)
procedure DspToDspClientProc(Param : Pointer); stdcall; // ��������� ����� Dsp - Dsp (������)
function SendDspToDsp(Buf : pchar; Len : SmallInt) : Boolean; // ��������� ������ � ����� ������ ���-��� ��� ��������

procedure DspToARCProc(Param : Pointer); stdcall; // ��������� ����� ��� ���������� ������ �� ��������� ������
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean; // ��������� ������ � ����� ������ ���������� ������ �� ��������� ������


var
  pSD                : PSECURITY_DESCRIPTOR;
  sa                 : SECURITY_ATTRIBUTES;
  IsBreakKanalASU    : Boolean; // ������� ���������� ������������ ������� ���

  // ����� ���1-���2
  nDspToDspPipe      : WideString;
  DspToDspType       : Byte;    // ��� ��������� ������ (0- ������, 1- ������)
  hDspToDspPipe      : THandle;
  DspToDspBreak      : Boolean; // ���������� ����������� ������������ ������ ���-���
  DspToDspEnabled    : Boolean; // ���������� ������������� ������ ���-���
  DspToDspConnected  : Boolean; // ������� ������� ���������� � ������ ������ ���-���
  DspToDspSucces     : Boolean; // ���������� ���������� ������ �� ������ ���-���
  DspToDspPending    : Boolean; // ���������� ������ ������ �� ����� �������� �� �����
  DspToDspAdresatEn  : Boolean; // ������� ����������� ������� ����� �����
  DspToDspOverLapWrt : TOVERLAPPED;
  DspToDspOverLapRd  : TOVERLAPPED;
  hDspToDspEventWrt  : THandle;
  hDspToDspEventRd   : THandle;
  DspToDspThreadID   : ULONG;
  DspToDspParam      : Pointer;
  DspToDspBufRd      : array[0..ASU1_BUFFER_LENGTH-1] of Char;
  DspToDspBufWrt     : array[0..ASU1_BUFFER_LENGTH-1] of Char;
  DspToDspInputBuf     : array[0..ASU1_BUFFER_LENGTH-1] of Char; // ������� ����� ������ ���-���
  DspToDspInputBufPtr  : Word;                   // ��������� �� ����� ������ � ������ ������
  DspToDspOutputBuf    : array[0..ASU1_BUFFER_LENGTH-1] of Char; // �������� ����� ������ ���-���
  DspToDspOutputBufPtr : Word;                   // ��������� �� ����� ������ � ������ ��������
  DspToDspThread       : THandle;

  // ����� ���-�����
  nDspToArcPipe      : WideString;
  hDspToArcPipe      : THandle;
  DspToArcBreak      : Boolean; // ���������� ����������� ������������ ������ ���-�����
  DspToArcEnabled    : Boolean; // ���������� ������������� ������ ���-�����
  DspToArcConnected  : Boolean; // ������� ������� ���������� � ������ ������ ���-�����
  DspToArcSucces     : Boolean; // ���������� ���������� ������ �� ������ ���-�����
  DspToArcPending    : Boolean; // ���������� ������ ������ �� ����� �������� �� �����
  DspToArcAdresatEn  : Boolean; // ������� ����������� ������� ����� �����
  DspToArcOverLapWrt : TOVERLAPPED;
  DspToArcOverLapRd  : TOVERLAPPED;
  hDspToArcEventWrt  : THandle;
  hDspToArcEventRd   : THandle;
  DspToArcThreadID   : ULONG;
  DspToArcParam      : Pointer;
  DspToArcBufRd      : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcBufWrt     : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcInputBuf     : array[0..ARC_BUFFER_LENGTH-1] of Char; // ������� ����� ������ ���-�����
  DspToArcInputBufPtr  : Word;                   // ��������� �� ����� ������ � ������ ������
  DspToArcOutputBuf    : array[0..ARC_BUFFER_LENGTH-1] of Char; // �������� ����� ������ ���-�����
  DspToArcOutputBufPtr : Word;                   // ��������� �� ����� ������ � ������ ��������
  DspToArcThread       : THandle;

implementation

function SendDspToDsp(Buf : pchar; Len : SmallInt) : Boolean; // ��������� ������ � ����� ������ ���-��� ��� ��������
  var lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToDspOutputBufPtr + Len > ASU1_BUFFER_LENGTH) then exit; // ���� ����� � ������
  lBuf := 0;
  while lBuf < Len do begin DspToDspOutputBuf[DspToDspOutputBufPtr] := Buf[lBuf]; inc(lBuf); inc(DspToDspOutputBufPtr); end;
  result := true;
end;

function InitpSD : Boolean; // �������� ������� ����������� ������������
begin
  result := false;
  pSD := PSECURITY_DESCRIPTOR(LocalAlloc(LPTR,SECURITY_DESCRIPTOR_MIN_LENGTH));
  if not Assigned(pSD) then exit;
  if not InitializeSecurityDescriptor(pSD,SECURITY_DESCRIPTOR_REVISION) then begin LocalFree(HLOCAL(pSD)); exit; end;
  if not SetSecurityDescriptorDacl(pSD,true,nil,false) then begin LocalFree(HLOCAL(pSD)); exit; end;
  sa.nLength := sizeof(sa);
  sa.lpSecurityDescriptor := pSD;
  sa.bInheritHandle := true;
  result := true;
end;

function InitEventPipes : Boolean; // ������� ������� ��� ��������� ����
begin
  result := false;
  // ���-���
  hDspToDspEventWrt := CreateEventW(nil,false,false,nil);
  if hDspToDspEventWrt = INVALID_HANDLE_VALUE then exit;
  FillChar(DspToDspOverLapWrt,sizeof(OVERLAPPED),0);
  DspToDspOverLapWrt.hEvent := hDspToDspEventWrt;
  hDspToDspEventRd := CreateEventW(nil,false,false,nil);
  if hDspToDspEventRd = INVALID_HANDLE_VALUE then
  begin CloseHandle(hDspToDspEventWrt); exit; end;
  FillChar(DspToDspOverLapRd,sizeof(OVERLAPPED),0);
  DspToDspOverLapRd.hEvent := hDspToDspEventRd;
  // ���-�����
  hDspToArcEventWrt := CreateEventW(nil,false,false,nil);
  if hDspToArcEventWrt = INVALID_HANDLE_VALUE then
  begin CloseHandle(hDspToDspEventWrt); CloseHandle(hDspToDspEventRd); exit; end;
  FillChar(DspToArcOverLapWrt,sizeof(OVERLAPPED),0);
  DspToArcOverLapWrt.hEvent := hDspToArcEventWrt;
  hDspToArcEventRd := CreateEventW(nil,false,false,nil);
  if hDspToArcEventRd = INVALID_HANDLE_VALUE then
  begin CloseHandle(hDspToDspEventWrt); CloseHandle(hDspToDspEventRd); CloseHandle(hDspToArcEventWrt); exit; end;
  FillChar(DspToArcOverLapRd,sizeof(OVERLAPPED),0);
  DspToArcOverLapRd.hEvent := hDspToArcEventRd;
  result := true;
end;

//------------------------------------------------------------------------------
// ���������� ������ ������ ����� ��������� (��������� �������)
procedure DspToDspServerProc(Param : Pointer); stdcall;
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   i : Cardinal;
begin
  DspToDspSucces := false;
  DspToDspPending := true;
  DspToDspConnected := false;
  DspToDspAdresatEn := false;
  DspToDspInputBufPtr  := 0;
  DspToDspOutputBufPtr := 0;
// ������� ��������� �����
  hDspToDspPipe := CreateNamedPipeW(pWideChar(nDspToDspPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    ASU1_BUFFER_LENGTH,
    ASU1_BUFFER_LENGTH,
    50,
    @sa);
  if hDspToDspPipe = INVALID_HANDLE_VALUE then
  begin // �� ������� ������� ����� - �����
    ExitThread(0); exit;
  end else
  begin // ����� ������� - ������������ �� ������� �������
    // ��������� ����� ������������ ������
    exitLoop := false;
  end;

    repeat

    if DspToDspConnected then
    begin // ��������� ����� ���� ���� ����������� � �����

    // ��������� �����
      if not ReadFile(hDspToDspPipe,DspToDspBufRd,ASU1_BUFFER_LENGTH,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            DspToDspAdresatEn := false; WaitForSingleObject(hDspToDspEventRd,149); // ������� �����������
          end;
          ERROR_NO_DATA :
          begin  //�������� ������ �� �������
            WaitForSingleObject(hDspToDspEventRd,149); // ������� ������
            DspToDspAdresatEn := true;
          end;
          ERROR_IO_PENDING :
          begin
            WaitForSingleObject(hDspToDspEventRd,INFINITE); // ������� ������
            DspToDspAdresatEn := true;
            CancelIO(hDspToDspPipe);
          end;
        else
          exitLoop := true; // ��������� ������������ ������ ��� ������� �����
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then
        begin // �������� ������� ������
          DspToDspAdresatEn := true;

    // ��������� ������� ������
          i := 0;
          if DspToDspInputBufPtr + cbTransRd <= High(DspToDspInputBuf) then
          begin
            while i < cbTransRd do
            begin
              DspToDspInputBuf[DspToDspInputBufPtr] := DspToDspBufRd[i];
              inc(i); inc(DspToDspInputBufPtr);
            end;
            cbTransRd := 0; DspToDspSucces := true;
          end;
        end;

    // �������� �������� ������
        if DspToDspPending then
        begin
          DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
        end else
        if DspToDspOutputBufPtr > 0 then
        begin
          Move(DspToDspOutputBuf, DspToDspBufWrt, DspToDspOutputBufPtr);
          if WriteFile( hDspToDspPipe, DspToDspBufWrt, DspToDspOutputBufPtr, bytesWrite, @DspToDspOverLapWrt) then // �������� � �����
          begin
            DspToDspOutputBufPtr := 0;
          end else
          begin
            cErr := GetLastError;
            case cErr of
              ERROR_IO_PENDING :
              begin
                DspToDspOutputBufPtr := 0; DspToDspPending := true;
              end;
            else
              exitLoop := true; // ��������� ������������ ������ ��� ������� �����
            end;
          end;
        end;
      end;

    end else
    begin // ���������� ������������ � ����� � ��������� �������

      if ConnectNamedPipe(hDspToDspPipe,@DspToDspOverLapRd) then
      begin // ������������� � ������ ����������
        DspToDspConnected := true; DspToDspPending := false; DspToDspAdresatEn := true;
      end else
      begin // ���������� ������ ����������� � �����
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToDspConnected := true; exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            DspToDspConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // ��������� ������ � �����
            DspToDspConnected := true; DspToDspAdresatEn := true;
          end;
          ERROR_NO_DATA :
          begin // ������ ������ ����� - ��������� ��������� ����������
            exitLoop := true;
          end;
        else
          exitLoop := true;
        end;
      end;

    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToDspOutputBufPtr := 0; DspToDspConnected := false;
      DspToDspAdresatEn := false; DspToDspPending := false; DspToDspSucces := false;
      exitLoop := not DisconnectNamedPipe(hDspToDspPipe);
    end;

  until DspToDspBreak; // ���������� ������������ ����� �� ������� ���������

  ExitThread(100);
end;

procedure DspToDspClientProc(Param : Pointer); stdcall; // ��������� ����� �� ������ Dsp - Dsp (������)
  var lastPend : Double; cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop,fixPend : boolean; i : Cardinal;
begin
  exitLoop := false;
  DspToDspPending := false;
  lastPend := 0; fixPend := false;
  DspToDspAdresatEn := false;
  DspToDspConnected := false;
  DspToDspOutputBufPtr := 0;

  repeat

    if DspToDspConnected then
    begin // ��������� ����� ���� ���� ����������� � �����
      if GetNamedPipeHandleState(hDspToDspPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile(hDspToDspPipe,DspToDspBufRd,ASU1_BUFFER_LENGTH,bytesRead,@DspToDspOverLapRd) then
        begin
          cErr := GetLastError;
          case cErr of
            ERROR_IO_PENDING :
            begin
              WaitForSingleObject(hDspToDspEventRd,149); // ������� ������
              CancelIO(hDspToDspPipe);
              if fixPend then
              begin // �������� ������� ��-�� ����������� ���������� ������
                if (lastPend + 5/80000) < (Date+Time) then
                begin
                  exitLoop := true;
                end;
              end else
              begin
                fixPend := true; lastPend := Date+Time;
              end;
            end;
            ERROR_BROKEN_PIPE :
            begin
              exitLoop := true; // ��������� ������������ ������ ��� ������� �����
            end;
          else
            exitLoop := true;
          end;
        end;

        if not exitLoop then
        begin
          GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
          if cbTransRd > 0 then
          begin // �������� ������ ���������� ������
            fixPend := false; DspToDspAdresatEn := true;
      // ��������� ������� ������
            i := 0;
            if DspToDspInputBufPtr + cbTransRd <= High(DspToDspInputBuf) then
            begin
              while i < cbTransRd do
              begin
                DspToDspInputBuf[DspToDspInputBufPtr] := DspToDspBufRd[i];
                inc(i); inc(DspToDspInputBufPtr);
              end;
              cbTransRd := 0; DspToDspSucces := true;
            end;
          end;

      // �������� �������� ������
          if DspToDspPending then
          begin
            DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
          end else
          if DspToDspOutputBufPtr > 0 then
          begin
            Move(DspToDspOutputBuf, DspToDspBufWrt, DspToDspOutputBufPtr);
            if WriteFile( hDspToDspPipe, DspToDspBufWrt, DspToDspOutputBufPtr, bytesWrite, @DspToDspOverLapWrt) then // �������� � �����
            begin
              DspToDspOutputBufPtr := 0;
            end else
            begin
              cErr := GetLastError;
              case cErr of
                ERROR_IO_PENDING :
                begin
                  DspToDspOutputBufPtr := 0; DspToDspPending := true;
                end;
              else
                exitLoop := true; // ��������� ������������ ������ ��� ������� �����
              end;
            end;
          end;
        end;
      end else
      begin // ���������� ������ � ������� ��������� �������
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
//            MsgError := '�������� ������ �� �������';
          end;
        else
          exitLoop := true;
        end;
      end;
    end else
    begin // ���������� ������������ � ����� � ���������� �������
//      if WaitNamedPipeW(PWideChar(nDspToDspPipe),20000) then
//      begin

        hDspToDspPipe := CreateFileW(PWideChar(nDspToDspPipe),
          GENERIC_WRITE or GENERIC_READ,
          FILE_SHARE_READ or FILE_SHARE_WRITE,
          nil,
          OPEN_EXISTING,
          FILE_FLAG_OVERLAPPED,
          0);
        if hDspToDspPipe <> INVALID_HANDLE_VALUE then
        begin // ��������� � ������ ����������
          DspToDspConnected := true; DspToDspAdresatEn := true; exitLoop := false;
        end else
        begin // ���������� ������ ����������� � �����
          cErr := GetLastError;
          case cErr of
            ERROR_FILE_NOT_FOUND :
            begin
              exitLoop := true;
            end;
            ERROR_SEEK_ON_DEVICE :
            begin
              exitLoop := true;
            end;
          else
            exitLoop := true;
          end;
        end;
//      end;
    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToDspOutputBufPtr := 0; DspToDspConnected := false; DspToDspAdresatEn := false;
      DspToDspSucces := false; DspToDspPending := false; fixPend := false;
      CloseHandle(hDspToDspPipe);
      hDspToDspPipe := INVALID_HANDLE_VALUE;

      if not DspToDspBreak then
        WaitForSingleObject(hDspToDspEventRd,5000); // ������� 5 ������

    end;

  until DspToDspBreak;

  // ��������� ������������ ����� �� ������� �������
  ExitThread(100);
end;



//------------------------------------------------------------------------------
// ��������� ������ � ����� ������ ���������� ������ �� ��������� ������
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean;
  var lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToArcOutputBufPtr + Len > ARC_BUFFER_LENGTH) then exit; // ���� ����� � ������
  lBuf := 0;
  while lBuf < Len do begin DspToArcOutputBuf[DspToArcOutputBufPtr] := Buf[lBuf]; inc(lBuf); inc(DspToArcOutputBufPtr); end;
  result := true;
end;

//------------------------------------------------------------------------------
// ��������� ����� ��� ���������� ������ �� ��������� ������ (��������� ����� �����)
procedure DspToARCProc(Param : Pointer); stdcall;
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   i : Cardinal;
begin
  DspToArcSucces := false;
  DspToArcPending := true;
  DspToArcConnected := false;
  DspToArcAdresatEn := false;
  DspToArcInputBufPtr  := 0;
  DspToArcOutputBufPtr := 0;
// ������� ��������� �����
  hDspToArcPipe := CreateNamedPipeW(pWideChar(nDspToArcPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    ARC_BUFFER_LENGTH,
    ARC_BUFFER_LENGTH,
    50,
    @sa);
  if hDspToArcPipe = INVALID_HANDLE_VALUE then
  begin // �� ������� ������� ����� - �����
    ExitThread(0); exit;
  end else
  begin // ����� ������� - ������������ �� ������� �������
    // ��������� ����� ������������ ������
    exitLoop := false;
  end;

    repeat

    if DspToArcConnected then
    begin // ��������� ����� ���� ���� ����������� � �����

    // ��������� �����
      if not ReadFile(hDspToArcPipe,DspToArcBufRd,ARC_BUFFER_LENGTH,bytesRead,@DspToArcOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            DspToArcAdresatEn := false;
            WaitForSingleObject(hDspToArcEventRd,100); // ������� �����������
          end;
          ERROR_NO_DATA :
          begin
            WaitForSingleObject(hDspToArcEventRd,100); // ������� ������
            DspToArcAdresatEn := true;
          end;
          ERROR_IO_PENDING :
          begin
            WaitForSingleObject(hDspToArcEventRd,INFINITE); // ������� ������
            CancelIO(hDspToArcPipe);
            DspToArcAdresatEn := true;
          end;
        else
          exitLoop := true; // ��������� ������������ ������ ��� ������� �����
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToArcPipe,DspToArcOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then
        begin // �������� ������� ������
          DspToArcAdresatEn := true;

    // ��������� ������� ������
          i := 0;
          if DspToArcInputBufPtr + cbTransRd <= High(DspToArcInputBuf) then
          begin
            while i < cbTransRd do
            begin
              DspToArcInputBuf[DspToArcInputBufPtr] := DspToArcBufRd[i];
              inc(i); inc(DspToArcInputBufPtr);
            end;
            cbTransRd := 0; DspToArcSucces := true;
          end;
        end;

    // �������� �������� ������
        if DspToArcPending then
        begin
          DspToArcPending := not GetOverlappedResult(hDspToArcPipe,DspToArcOverLapWrt,cbTransWrt,false);
        end else
        if DspToArcOutputBufPtr > 0 then
        begin
          Move(DspToArcOutputBuf, DspToArcBufWrt, DspToArcOutputBufPtr);
          if WriteFile( hDspToArcPipe, DspToArcBufWrt, DspToArcOutputBufPtr, bytesWrite, @DspToArcOverLapWrt) then // �������� � �����
          begin
            DspToArcOutputBufPtr := 0;
          end else
          begin
            cErr := GetLastError;
            case cErr of
              ERROR_IO_PENDING :
              begin
                DspToArcOutputBufPtr := 0; DspToArcPending := true;
              end;
            else
              exitLoop := true; // ��������� ������������ ������ ��� ������� �����
            end;
          end;
        end;

      end;

    end else
    begin // ���������� ������������ � ����� � ��������� �������

      if ConnectNamedPipe(hDspToArcPipe,@DspToArcOverLapRd) then
      begin // ������������� � ������ ����������
        DspToArcConnected := true; DspToArcPending := false; DspToArcAdresatEn := true;
      end else
      begin // ���������� ������ ����������� � �����
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToArcConnected := true; exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            DspToArcConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // ��������� ������ � �����
            DspToArcConnected := true;
            DspToArcAdresatEn := true;
          end;
          ERROR_NO_DATA :
          begin // ������ ������ ����� - ��������� ������� ��������� ����������
            exitLoop := true;
          end;
        else
          exitLoop := true;
        end;
      end;

    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToArcOutputBufPtr := 0; DspToArcConnected := false; DspToArcAdresatEn := false;
      DspToArcPending := false; DspToArcSucces := false; 
      exitLoop := not DisconnectNamedPipe(hDspToArcPipe);
    end;

  until DspToArcBreak; // ���������� ������������ ����� �� ������� ���������

  ExitThread(100);
end;

end.
