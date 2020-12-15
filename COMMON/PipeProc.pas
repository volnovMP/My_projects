unit PipeProc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

const
  DAT_LIMIT = 1100;
  ASU1_BUFFER_LENGTH = 1024;
  ARC_BUFFER_LENGTH = 4096;
  ASU_TIMER_INTERVAL = 3757;

function InitpSD : Boolean;                   // �������� ������� ����������� ������������
function InitEventPipes : Boolean;                   // ������� ������� ��� ��������� ����
procedure DspToDspServerProc(Param : Pointer); stdcall; //��������� ����� Dsp-Dsp (������)
procedure DspToDspClientProc(Param : Pointer); stdcall; //��������� ����� Dsp-Dsp (������)
procedure DspToARCProc(Param:Pointer);stdcall;//��������� ����� ������ �� ��������� ������
function SendDspToARC(Buf:pchar;Len:SmallInt):Boolean;//� ����� ������ �� ��������� ������

// ����� ����������
var
  delta, maxdelta    : Double;
  LastRsv            : Double;
  pSD                : PSECURITY_DESCRIPTOR;
  sa                 : SECURITY_ATTRIBUTES;
  nDspToDspPipe      : WideString;
  hDspToDspPipe      : THandle;
  DspToDspBreak      : Boolean; // ���������� ����������� ������������ ������ ���-���
  DspToDspEnabled    : Boolean; // ���������� ������������� ������ ���-���
  DspToDspConnected  : Boolean; // ������� ������� ���������� � ������ ������ ���-���
  DspToDspSucces     : Boolean; // ���������� ���������� ������ �� ������ ���-���
  DspToDspPending    : Boolean; // ���������� ������ ������ �� ����� �������� �� �����
  DspToDspOverLapWrt : TOVERLAPPED;
  DspToDspOverLapRd  : TOVERLAPPED;
  hDspToDspEventWrt  : THandle;
  hDspToDspEventRd   : THandle;
  DspToDspType       : Byte;    // ��� ��������� ������ (0- ������, 1- ������)
	DspToDspThreadID   : ULONG;
  DspToDspParam      : Pointer;
  DspToDspBufRd      : array[0..8191] of Char;
  DspToDspBufWrt     : array[0..8191] of Char;
  DspToDspInputBuf   : string;                // ������� ����� ������ ���-���
  DspToDspOutputBuf  : string;                // �������� ����� ������ ���-���
  DspToDspThread     : THandle;

  DspToArcThread     : THandle;
  DspToArcThreadID   : ULONG;
  DspToArcSucces     : Boolean; // ���������� ���������� ������ �� ������ ���-�����
  DspToArcPending    : Boolean; // ���������� ������ ������ �� ����� �������� �� �����
  DspToArcConnected  : Boolean; // ������� ������� ���������� � ������ ������ ���-�����
  DspToArcAdresatEn  : Boolean; // ������� ����������� ������� ����� �����
	DspToArcEnabled    : Boolean; // ���������� ������������� ������ ���-�����
  DspToArcParam      : Pointer;
  DspToArcBufRd      : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcBufWrt     : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcInputBuf     : array[0..ARC_BUFFER_LENGTH-1] of Char; // ������� ����� ������ ���-�����
  DspToArcInputBufPtr  : Word;                   // ��������� �� ����� ������ � ������ ������
  DspToArcOutputBuf    : array[0..ARC_BUFFER_LENGTH-1] of Char; // �������� ����� ������ ���-�����
  DspToArcOutputBufPtr : Word;                   // ��������� �� ���
  nDspToArcPipe      : WideString;
  hDspToArcPipe      : THandle;
  DspToArcOverLapRd  : TOVERLAPPED;
  hDspToArcEventWrt  : THandle;
  hDspToArcEventRd   : THandle;  //--------- ������� ����������� ������� � ����� ���-�����
  DspToArcOverLapWrt : TOVERLAPPED;
  DspToArcBreak      : Boolean; //--- ���������� ����������� ������������ ������ ���-�����
  IsBreakKanalASU    : Boolean; //------------ ������� ���������� ������������ ������� ���

  MsgError : string;

implementation

function InitpSD : Boolean; // �������� ������� ����������� ������������
begin
  result := false;
  pSD := PSECURITY_DESCRIPTOR(LocalAlloc(LPTR,SECURITY_DESCRIPTOR_MIN_LENGTH));
  if not Assigned(pSD) then exit;
  if not InitializeSecurityDescriptor(pSD,SECURITY_DESCRIPTOR_REVISION) then
  begin
    LocalFree(HLOCAL(pSD));
    exit;
  end;
  if not SetSecurityDescriptorDacl(pSD,true,nil,false) then
  begin
    LocalFree(HLOCAL(pSD));
    exit;
  end;
  sa.nLength := sizeof(sa);
  sa.lpSecurityDescriptor := pSD;
  sa.bInheritHandle := true;
  result := true;
end;

function InitEventPipes : Boolean; // ������� ������� ��� ��������� ����
begin
  result := false;
  hDspToDspEventWrt := CreateEventW(nil,false,false,nil);
  if hDspToDspEventWrt = INVALID_HANDLE_VALUE then exit;
  FillChar(DspToDspOverLapWrt,sizeof(OVERLAPPED),0);
  DspToDspOverLapWrt.hEvent := hDspToDspEventWrt;
  hDspToDspEventRd := CreateEventW(nil,false,false,nil);
  if hDspToDspEventWrt = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(hDspToDspEventWrt); exit;
  end;
  FillChar(DspToDspOverLapRd,sizeof(OVERLAPPED),0);
  DspToDspOverLapRd.hEvent := hDspToDspEventRd;
  result := true;
end;

//------------------------------------------------------------------------------
// ���������� ������ ������ ����� ��������� (��������� �������)
procedure DspToDspServerProc(Param : Pointer); stdcall;
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   s : string; i : integer;
begin
  DspToDspSucces := false;
  DspToDspPending := true;
  DspToDspConnected := false;
// ������� ��������� �����
  hDspToDspPipe := CreateNamedPipeW(pWideChar(nDspToDspPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    8192,
    8192,
    50,
    @sa);
  if hDspToDspPipe = INVALID_HANDLE_VALUE then
  begin // �� ������� ������� ����� - �����
    MsgError := 'ErrorCode='+ IntToStr(GetLastError)+ ' Hand='+IntToStr(hDspToDspPipe);
    ExitThread(0);
    exit;
  end else
  begin // ����� ������� - ������������ �� ������� �������
    // ��������� ����� ������������ ������
    exitLoop := false;
  end;

    repeat

    if DspToDspConnected then
    begin // ��������� ����� ���� ���� ����������� � �����

    // ��������� �����
      if not ReadFile(hDspToDspPipe,DspToDspBufRd,512,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            MsgError := '�������� ����������� �������';
            WaitForSingleObject(hDspToDspEventRd,100); // ������� ������
          end;
          ERROR_NO_DATA :
          begin 
            MsgError := '�������� ������ �� �������';
            DspToDspPending := false;
            WaitForSingleObject(hDspToDspEventRd,100); // ������� ������
          end;
          ERROR_IO_PENDING :
          begin
            MsgError := '�������� ������ �� �������';
            DspToDspPending := false;
            WaitForSingleObject(hDspToDspEventRd,197); // ������� ������
            CancelIO(hDspToDspEventRd);
          end;
        else
          MsgError := 'Read -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+IntToStr(hDspToDspPipe);
          exitLoop := true; // ��������� ������������ ������ ��� ������� �����
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
        if cbTransRd <> 0 then
        begin //-------------------------------------------------- �������� ������� ������

          if LastRsv > 0.00000000001 then
          begin
            delta := Time - LastRsv;
            if delta > maxdelta then maxdelta := delta;
          end;

          LastRsv := Time;

    // ��������� ������� ������
          s := '';
          for i := 0 to cbTransRd-1 do s := s + DspToDspBufRd[i]; // ����������� ������� �� ������ � ������
          if s <> '' then
          begin
            DspToDspInputBuf := DspToDspInputBuf + s;
          end;
          cbTransRd := 0;
          DspToDspSucces := true;
        end;

    // �������� �������� ������
        if DspToDspPending then
        begin
          DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
        end else
        if DspToDspOutputBuf <> '' then
        begin
          i := Length(DspToDspOutputBuf);
          if i > Length(DspToDspBufWrt) then i := Length(DspToDspBufWrt);
          if i > 0 then
          begin
            Move(DspToDspOutputBuf[1], DspToDspBufWrt, i);
            MsgError := 'Write-> ���������� '+ IntToStr(i)+ ' ����';
            DspToDspOutputBuf := '';
            if not WriteFile( hDspToDspPipe, DspToDspBufWrt, i, bytesWrite, @DspToDspOverLapWrt) then // �������� � �����
            begin
              cErr := GetLastError;
              case cErr of
                ERROR_IO_PENDING :
                begin
                  MsgError := 'Write -> ERROR_IO_PENDING Hand='+IntToStr(hDspToDspPipe);
                  DspToDspPending := true;
                end;
              else
                MsgError := 'Write -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+IntToStr(hDspToDspPipe);
                exitLoop := true; // ��������� ������������ ������ ��� ������� �����
              end;
            end;
          end;
        end;

      end;

    end else
    begin // ���������� ������������ � ����� � ��������� �������

      if ConnectNamedPipe(hDspToDspPipe,@DspToDspOverLapRd) then
      begin // ������������� � ������ ����������
        MsgError := 'Connect -> ��������� ����������� '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
        DspToDspConnected := true;
        DspToDspPending := false;
        DspToDspOutputBuf := '';
      end else
      begin // ���������� ������ ����������� � �����
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToDspConnected := true;
            MsgError := 'Connect -> ErrorCode=ERROR_IO_PENDING '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ��������� ����������� � ����� � ���������� �������
            MsgError := 'Connect -> �������� ����������� � ����� '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            DspToDspConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // ��������� ������ � �����
            MsgError := 'Connect -> ErrorCode=ERROR_PIPE_CONNECTED '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            DspToDspConnected := true;
          end;
          ERROR_NO_DATA :
          begin // ������ ������ ����� - ��������� ��������� ����������
            MsgError := 'Connect -> ErrorCode=ERROR_NO_DATA '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
        else
          MsgError := 'Connect -> ErrorCode='+ IntToStr(cErr)+ ' '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
          exitLoop := true;
        end;
      end;

    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToDspConnected := false;
      DspToDspPending := true;
      exitLoop := not DisconnectNamedPipe(hDspToDspPipe);
    end;

  until DspToDspBreak; // ���������� ������������ ����� �� ������� ���������

  ExitThread(0);
end;

procedure DspToDspClientProc(Param : Pointer); stdcall; // ��������� ����� �� ������ Dsp - Dsp (������)
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   s : string; i : integer; 
begin
  exitLoop := false;
  DspToDspPending := false;

  repeat

    if DspToDspConnected then
    begin // ��������� ����� ���� ���� ����������� � �����

      if not ReadFile(hDspToDspPipe,DspToDspBufRd,512,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            MsgError := '�������� ������ �� �������';
            WaitForSingleObject(hDspToDspEventRd,195); // ������� ������
            CancelIO(hDspToDspEventRd);
          end;
          ERROR_BROKEN_PIPE :
          begin
            MsgError := 'Read -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+ IntToStr(hDspToDspPipe);
            exitLoop := true; // ��������� ������������ ������ ��� ������� �����
          end;
        else
          MsgError := 'Read -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+ IntToStr(hDspToDspPipe);
          exitLoop := true;
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
        if cbTransRd <> 0 then
        begin // �������� ������ ���������� ������

          if LastRsv > 0.00000000001 then
          begin
            delta := Time - LastRsv;
            if delta > maxdelta then maxdelta := delta;
          end;
          LastRsv := Time;

    // ��������� ������� ������
          s := '';
          for i := 0 to cbTransRd-1 do s := s + DspToDspBufRd[i]; // ����������� ������� �� ������ � ������
          if s <> '' then
          begin
            DspToDspInputBuf := DspToDspInputBuf + s;
          end;
          cbTransRd := 0;
          DspToDspSucces := true;
        end;

    // �������� �������� ������
        if DspToDspPending then
        begin
          DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
        end else
        // ���������� ����� ��������
        if DspToDspOutputBuf <> '' then
        begin
          i := Length(DspToDspOutputBuf);
          if i > Length(DspToDspBufWrt) then i := Length(DspToDspBufWrt);
          if i > 0 then
          begin
            Move(DspToDspOutputBuf[1], DspToDspBufWrt, i);
            DspToDspOutputBuf := '';
            if not WriteFile( hDspToDspPipe, DspToDspBufWrt, i, bytesWrite, @DspToDspOverLapWrt) then // �������� � �����
            begin
              cErr := GetLastError;
              case cErr of
                ERROR_IO_PENDING :
                begin
                  MsgError := 'Write -> ERROR_IO_PENDING Hand='+IntToStr(hDspToDspPipe);
                  DspToDspPending := true;
                end;
              else
                MsgError := 'Write -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+IntToStr(hDspToDspPipe);
                exitLoop := true; // ��������� ������������ ������ ��� ������� �����
              end;
            end;
          end;
        end;

      end;

    end else
    begin // ���������� ������������ � ����� � ���������� �������

      hDspToDspPipe := CreateFileW(PWideChar(nDspToDspPipe),
        GENERIC_WRITE or GENERIC_READ,
        FILE_SHARE_READ or FILE_SHARE_WRITE,
        nil,
        OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED,
        0);
      if hDspToDspPipe <> INVALID_HANDLE_VALUE then
      begin // ��������� � ������ ����������
        DspToDspConnected := true;
        DspToDspOutputBuf := '';
        exitLoop := false;
      end else
      begin // ���������� ������ ����������� � �����
        cErr := GetLastError;
        case cErr of
          ERROR_FILE_NOT_FOUND :
          begin
            MsgError := 'Connect -> ������� ����������� � �������������� ����� '+ TimeToStr(Time)+ ' Hand='+ IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
          ERROR_SEEK_ON_DEVICE :
          begin
            MsgError := 'Connect -> ������� ����������� � �������������� ����� '+ TimeToStr(Time)+ ' Hand='+ IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
        else
          MsgError := 'Connect -> ErrorCode='+ IntToStr(cErr)+ ' '+ TimeToStr(Time)+ ' Hand='+ IntToStr(hDspToDspPipe);
          exitLoop := true;
        end;
      end;

    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToDspConnected := false;
      DspToDspPending := false;
      CloseHandle(hDspToDspPipe);
      hDspToDspPipe := INVALID_HANDLE_VALUE;
      if not DspToDspBreak then
        WaitForSingleObject(hDspToDspEventRd,1000); // �������
    end;

  until DspToDspBreak;

  // ��������� ������������ ����� �� ������� �������
  ExitThread(0);
end;

//========================================================================================
//------ ��������� ����� ��� ���������� ������ �� ��������� ������ (��������� ����� �����)
//-------------------------------------------- ������� ������ ��� ����� ���� ��� � �������
procedure DspToARCProc(Param : Pointer); stdcall;
var
  cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt,i : Cardinal;
  exitLoop : boolean;
begin
  DspToArcSucces := false;
  DspToArcPending := true;
  DspToArcConnected := false;
  DspToArcAdresatEn := false;
  DspToArcInputBufPtr  := 0;
  DspToArcOutputBufPtr := 0;
  //-------------------------------------------------------------- ������� ��������� �����
  hDspToArcPipe := CreateNamedPipeW(pWideChar(nDspToArcPipe),
  PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
  PIPE_READMODE_BYTE or PIPE_NOWAIT,
  PIPE_UNLIMITED_INSTANCES,
  ARC_BUFFER_LENGTH,
  ARC_BUFFER_LENGTH,
  50,
  @sa);
  if hDspToArcPipe = INVALID_HANDLE_VALUE then //- ���� �� ������� ������� �����, �� �����
  begin ExitThread(0); exit; end

  //------ ���� ����� �������,������������ �� ������� �������,��������� ����� ������������
  else exitLoop := false;
  repeat //----------------------------------------------------------- ������� ���� ������
    if DspToArcConnected then //--------------------------- ���� ���� ����������� � ������
    begin //---------- ��������� ����� ���� ���� ����������� � �����, � ���� ������ ������
      if not ReadFile(hDspToArcPipe,DspToArcBufRd,ARC_BUFFER_LENGTH,bytesRead,@DspToArcOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING : //---- ��������� ����������� � ����� � ���������� �������
          begin
            DspToArcAdresatEn := false;
            WaitForSingleObject(hDspToArcEventRd,100); //------ ������� ����������� 100 ��
          end;

          ERROR_NO_DATA :  //----------------------------------- ��� ������, ����� �������
          begin
            WaitForSingleObject(hDspToArcEventRd,100); //----------- ������� ������ 100 ��
            DspToArcAdresatEn := true;
          end;

          ERROR_IO_PENDING :  //---------------------------- �������� ����������� ��������
          begin
            WaitForSingleObject(hDspToArcEventRd,INFINITE); //------------- ������� ������
            CancelIO(hDspToArcPipe);
            DspToArcAdresatEn := true;
          end;

          else  exitLoop := true; //------ ��������� ������������ ������ ��� ������� �����
        end;
      end;

      if not exitLoop then //----------------------------------------- ���� ����� � ������
      begin
        //---------------------------------------- ��������� ������� ������ �������� �����
        GetOverlappedResult(hDspToArcPipe,DspToArcOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then //----------------------------- ���� ���� ����������� ������
        begin
          DspToArcAdresatEn := true;//��������� ������� ����������� ������ �� ����� ������
          i := 0;
          if DspToArcInputBufPtr + cbTransRd <= High(DspToArcInputBuf) then
          begin
            while i < cbTransRd do //------ ��������� ������ ������ �� ������ ����� ������
            begin
              DspToArcInputBuf[DspToArcInputBufPtr] := DspToArcBufRd[i];
              inc(i);
              inc(DspToArcInputBufPtr);
            end;
            cbTransRd := 0;
            DspToArcSucces := true;
          end;
        end;

        if DspToArcPending then //--- ���� ����������� ���������� ������ �� ����� ��������
        begin
          DspToArcPending := //-- ���������� ���������� �� �������� ������� ������ � �����
          not GetOverlappedResult(hDspToArcPipe,DspToArcOverLapWrt,cbTransWrt,false);
        end else
        if DspToArcOutputBufPtr > 0 then //-------------------- ���� ��� ���������� ������
        begin
          Move(DspToArcOutputBuf,DspToArcBufWrt,DspToArcOutputBufPtr);
          //------------------------------------------------------------- �������� � �����
          if WriteFile(hDspToArcPipe,DspToArcBufWrt,DspToArcOutputBufPtr,bytesWrite,@DspToArcOverLapWrt)
          then DspToArcOutputBufPtr := 0 //------------------ ���� ������ ��������� ������
          else
          begin
            cErr := GetLastError; //---------------------- ���� ��������, �������� �������
            case cErr of
              //------------------------------------------------- ���� �������� � ��������
              ERROR_IO_PENDING : begin DspToArcOutputBufPtr:=0;DspToArcPending:=true;end;
              //--------------------------------------- ���� �� ��������, �� ������� �����
              else exitLoop := true; //--- ��������� ������������ ������ ��� ������� �����
            end;
          end;
        end;
      end;
    end else //-------------------------------------- ���� ��� ����������� ������� � �����
    begin //-------------------------- ���������� ������������ � ����� � ��������� �������
      if ConnectNamedPipe(hDspToArcPipe,@DspToArcOverLapRd) then //---------- ���� �������
      begin //------------------------------------------- ������������� � ����� ����������
        DspToArcConnected := true; DspToArcPending := false; DspToArcAdresatEn := true;
      end else
      begin //---------- ���� ��������� �����������, ���������� ������ ����������� � �����
        cErr := GetLastError;
        case cErr of

          ERROR_IO_PENDING : begin DspToArcConnected := true; exitLoop := true;  end;

          ERROR_PIPE_LISTENING : DspToArcConnected:=true;//------ ���� ����������� �������

          ERROR_PIPE_CONNECTED : // ------------------------------- ������ ��� �����������
            begin
              DspToArcConnected:=true;
              DspToArcAdresatEn:=true;//------------------------- ��������� ������ � �����
            end;

          ERROR_NO_DATA :exitLoop := true;//-- ������ ������ ����� -  ��������� ����������

          else exitLoop := true;
        end;
      end;
    end;

    if exitLoop or DspToDspBreak then
    begin
      DspToArcOutputBufPtr := 0; DspToArcConnected := false; DspToArcAdresatEn := false;
      DspToArcPending := false; DspToArcSucces := false;
      exitLoop := not DisconnectNamedPipe(hDspToArcPipe);
    end;
   until DspToArcBreak; //------------- ���������� ������������ ����� �� ������� ���������
  ExitThread(100);
end;
//========================================================================================
//------------------ ��������� ������ � ����� ������ ���������� ������ �� ��������� ������
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean;
var
  lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToArcOutputBufPtr + Len > ARC_BUFFER_LENGTH)
  then exit; //------------------------- ���� ������ ��� ��� ���� ����� � ������, �� �����

  lBuf := 0;
  while lBuf < Len do
  begin
    DspToArcOutputBuf[DspToArcOutputBufPtr] := Buf[lBuf];
    inc(lBuf);
    inc(DspToArcOutputBufPtr);
  end;
  result := true;
end;

end.
