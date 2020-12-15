unit PipeProc;

////////////////////////////////////////////////////////////////////////////////
//
//         Процедуры работы с программными каналами обмена по сети АСУ
//
//
//   Дата       23 января 2006 года
//
//   Версия     1
//
//   редакция   2
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


function InitpSD : Boolean;                             // создание пустого дескриптора безопасности
function InitEventPipes : Boolean;                      // создать события для обработки труб
procedure DspToDspServerProc(Param : Pointer); stdcall; // обработка трубы Dsp - Dsp (сервер)
procedure DspToDspClientProc(Param : Pointer); stdcall; // обработка трубы Dsp - Dsp (клиент)
function SendDspToDsp(Buf : pchar; Len : SmallInt) : Boolean; // Поместить данные в буфер канала ДСП-ДСП для передачи

procedure DspToARCProc(Param : Pointer); stdcall; // обработка трубы для сохранения архива на удаленной машине
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean; // Поместить данные в буфер канала сохранения архива на удаленной машине


var
  pSD                : PSECURITY_DESCRIPTOR;
  sa                 : SECURITY_ATTRIBUTES;
  IsBreakKanalASU    : Boolean; // признак завершения обслуживания каналов АСУ

  // труба ДСП1-ДСП2
  nDspToDspPipe      : WideString;
  DspToDspType       : Byte;    // тип окончания канала (0- сервер, 1- клиент)
  hDspToDspPipe      : THandle;
  DspToDspBreak      : Boolean; // требование прекращения обслуживания канала ДСП-ДСП
  DspToDspEnabled    : Boolean; // требование инициализации канала ДСП-ДСП
  DspToDspConnected  : Boolean; // признак наличия соединения с трубой канала ДСП-ДСП
  DspToDspSucces     : Boolean; // готовность полученных данных по каналу ДСП-ДСП
  DspToDspPending    : Boolean; // блокировка записи данных на время передачи по трубе
  DspToDspAdresatEn  : Boolean; // признак доступности другого конца трубы
  DspToDspOverLapWrt : TOVERLAPPED;
  DspToDspOverLapRd  : TOVERLAPPED;
  hDspToDspEventWrt  : THandle;
  hDspToDspEventRd   : THandle;
  DspToDspThreadID   : ULONG;
  DspToDspParam      : Pointer;
  DspToDspBufRd      : array[0..ASU1_BUFFER_LENGTH-1] of Char;
  DspToDspBufWrt     : array[0..ASU1_BUFFER_LENGTH-1] of Char;
  DspToDspInputBuf     : array[0..ASU1_BUFFER_LENGTH-1] of Char; // входной буфер канала ДСП-ДСП
  DspToDspInputBufPtr  : Word;                   // указатель на конец данных в буфере приема
  DspToDspOutputBuf    : array[0..ASU1_BUFFER_LENGTH-1] of Char; // выходной буфер канала ДСП-ДСП
  DspToDspOutputBufPtr : Word;                   // указатель на конец данных в буфере передачи
  DspToDspThread       : THandle;

  // труба ДСП-АРХИВ
  nDspToArcPipe      : WideString;
  hDspToArcPipe      : THandle;
  DspToArcBreak      : Boolean; // требование прекращения обслуживания канала ДСП-АРХИВ
  DspToArcEnabled    : Boolean; // требование инициализации канала ДСП-АРХИВ
  DspToArcConnected  : Boolean; // признак наличия соединения с трубой канала ДСП-АРХИВ
  DspToArcSucces     : Boolean; // готовность полученных данных по каналу ДСП-АРХИВ
  DspToArcPending    : Boolean; // блокировка записи данных на время передачи по трубе
  DspToArcAdresatEn  : Boolean; // признак доступности другого конца трубы
  DspToArcOverLapWrt : TOVERLAPPED;
  DspToArcOverLapRd  : TOVERLAPPED;
  hDspToArcEventWrt  : THandle;
  hDspToArcEventRd   : THandle;
  DspToArcThreadID   : ULONG;
  DspToArcParam      : Pointer;
  DspToArcBufRd      : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcBufWrt     : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcInputBuf     : array[0..ARC_BUFFER_LENGTH-1] of Char; // входной буфер канала ДСП-АРХИВ
  DspToArcInputBufPtr  : Word;                   // указатель на конец данных в буфере приема
  DspToArcOutputBuf    : array[0..ARC_BUFFER_LENGTH-1] of Char; // выходной буфер канала ДСП-АРХИВ
  DspToArcOutputBufPtr : Word;                   // указатель на конец данных в буфере передачи
  DspToArcThread       : THandle;

implementation

function SendDspToDsp(Buf : pchar; Len : SmallInt) : Boolean; // Поместить данные в буфер канала ДСП-ДСП для передачи
  var lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToDspOutputBufPtr + Len > ASU1_BUFFER_LENGTH) then exit; // мало места в буфере
  lBuf := 0;
  while lBuf < Len do begin DspToDspOutputBuf[DspToDspOutputBufPtr] := Buf[lBuf]; inc(lBuf); inc(DspToDspOutputBufPtr); end;
  result := true;
end;

function InitpSD : Boolean; // создание пустого дескриптора безопасности
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

function InitEventPipes : Boolean; // создать события для обработки труб
begin
  result := false;
  // ДСП-ДСП
  hDspToDspEventWrt := CreateEventW(nil,false,false,nil);
  if hDspToDspEventWrt = INVALID_HANDLE_VALUE then exit;
  FillChar(DspToDspOverLapWrt,sizeof(OVERLAPPED),0);
  DspToDspOverLapWrt.hEvent := hDspToDspEventWrt;
  hDspToDspEventRd := CreateEventW(nil,false,false,nil);
  if hDspToDspEventRd = INVALID_HANDLE_VALUE then
  begin CloseHandle(hDspToDspEventWrt); exit; end;
  FillChar(DspToDspOverLapRd,sizeof(OVERLAPPED),0);
  DspToDspOverLapRd.hEvent := hDspToDspEventRd;
  // ДСП-АРХИВ
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
// обработчик потока обмена между серверами (серверная сторона)
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
// создать экземпляр трубы
  hDspToDspPipe := CreateNamedPipeW(pWideChar(nDspToDspPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    ASU1_BUFFER_LENGTH,
    ASU1_BUFFER_LENGTH,
    50,
    @sa);
  if hDspToDspPipe = INVALID_HANDLE_VALUE then
  begin // не удалось создать трубу - выход
    ExitThread(0); exit;
  end else
  begin // труба создана - подключиться со стороны сервера
    // запустить поток обслуживания канала
    exitLoop := false;
  end;

    repeat

    if DspToDspConnected then
    begin // прочитать трубу если есть подключение к трубе

    // прочитать трубу
      if not ReadFile(hDspToDspPipe,DspToDspBufRd,ASU1_BUFFER_LENGTH,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            DspToDspAdresatEn := false; WaitForSingleObject(hDspToDspEventRd,149); // ожидать подключение
          end;
          ERROR_NO_DATA :
          begin  //Ожидание данных от клиента
            WaitForSingleObject(hDspToDspEventRd,149); // ожидать данные
            DspToDspAdresatEn := true;
          end;
          ERROR_IO_PENDING :
          begin
            WaitForSingleObject(hDspToDspEventRd,INFINITE); // ожидать данные
            DspToDspAdresatEn := true;
            CancelIO(hDspToDspPipe);
          end;
        else
          exitLoop := true; // завершить обслуживание потока при поломке трубы
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then
        begin // передать готовые данные
          DspToDspAdresatEn := true;

    // прочитать входные данные
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

    // записать выходные данные
        if DspToDspPending then
        begin
          DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
        end else
        if DspToDspOutputBufPtr > 0 then
        begin
          Move(DspToDspOutputBuf, DspToDspBufWrt, DspToDspOutputBufPtr);
          if WriteFile( hDspToDspPipe, DspToDspBufWrt, DspToDspOutputBufPtr, bytesWrite, @DspToDspOverLapWrt) then // Записать в трубу
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
              exitLoop := true; // завершить обслуживание потока при поломке трубы
            end;
          end;
        end;
      end;

    end else
    begin // попытаться подключиться к трубе с серверной стороны

      if ConnectNamedPipe(hDspToDspPipe,@DspToDspOverLapRd) then
      begin // подсоединение с трубой состоялось
        DspToDspConnected := true; DspToDspPending := false; DspToDspAdresatEn := true;
      end else
      begin // обработать ошибку подключения к трубе
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToDspConnected := true; exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            DspToDspConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // подключен клиент к трубе
            DspToDspConnected := true; DspToDspAdresatEn := true;
          end;
          ERROR_NO_DATA :
          begin // клиент закрыл трубу - требуется разорвать соединение
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

  until DspToDspBreak; // прекратить обслуживание трубы по запросу программы

  ExitThread(100);
end;

procedure DspToDspClientProc(Param : Pointer); stdcall; // обработка трубы по чтению Dsp - Dsp (клиент)
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
    begin // прочитать трубу если есть подключение к трубе
      if GetNamedPipeHandleState(hDspToDspPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile(hDspToDspPipe,DspToDspBufRd,ASU1_BUFFER_LENGTH,bytesRead,@DspToDspOverLapRd) then
        begin
          cErr := GetLastError;
          case cErr of
            ERROR_IO_PENDING :
            begin
              WaitForSingleObject(hDspToDspEventRd,149); // ожидать данные
              CancelIO(hDspToDspPipe);
              if fixPend then
              begin // ожидание разрыва из-за длительного отсутствия приема
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
              exitLoop := true; // завершить обслуживание потока при поломке трубы
            end;
          else
            exitLoop := true;
          end;
        end;

        if not exitLoop then
        begin
          GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
          if cbTransRd > 0 then
          begin // передать сигнал готовности данных
            fixPend := false; DspToDspAdresatEn := true;
      // прочитать входные данные
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

      // записать выходные данные
          if DspToDspPending then
          begin
            DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
          end else
          if DspToDspOutputBufPtr > 0 then
          begin
            Move(DspToDspOutputBuf, DspToDspBufWrt, DspToDspOutputBufPtr);
            if WriteFile( hDspToDspPipe, DspToDspBufWrt, DspToDspOutputBufPtr, bytesWrite, @DspToDspOverLapWrt) then // Записать в трубу
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
                exitLoop := true; // завершить обслуживание потока при поломке трубы
              end;
            end;
          end;
        end;
      end else
      begin // Обнаружена ошибка в запросе состояния сервера
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
//            MsgError := 'Ожидание данных от сервера';
          end;
        else
          exitLoop := true;
        end;
      end;
    end else
    begin // попытаться подключиться к трубе с клиентской стороны
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
        begin // соединеие с трубой состоялось
          DspToDspConnected := true; DspToDspAdresatEn := true; exitLoop := false;
        end else
        begin // обработать ошибку подключения к трубе
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
        WaitForSingleObject(hDspToDspEventRd,5000); // ожидать 5 секунд

    end;

  until DspToDspBreak;

  // завершить обслуживание трубы со стороны клиента
  ExitThread(100);
end;



//------------------------------------------------------------------------------
// Поместить данные в буфер канала сохранения архива на удаленной машине
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean;
  var lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToArcOutputBufPtr + Len > ARC_BUFFER_LENGTH) then exit; // мало места в буфере
  lBuf := 0;
  while lBuf < Len do begin DspToArcOutputBuf[DspToArcOutputBufPtr] := Buf[lBuf]; inc(lBuf); inc(DspToArcOutputBufPtr); end;
  result := true;
end;

//------------------------------------------------------------------------------
// обработка трубы для сохранения архива на удаленной машине (серверный конец трубы)
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
// создать экземпляр трубы
  hDspToArcPipe := CreateNamedPipeW(pWideChar(nDspToArcPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    ARC_BUFFER_LENGTH,
    ARC_BUFFER_LENGTH,
    50,
    @sa);
  if hDspToArcPipe = INVALID_HANDLE_VALUE then
  begin // не удалось создать трубу - выход
    ExitThread(0); exit;
  end else
  begin // труба создана - подключиться со стороны сервера
    // запустить поток обслуживания канала
    exitLoop := false;
  end;

    repeat

    if DspToArcConnected then
    begin // прочитать трубу если есть подключение к трубе

    // прочитать трубу
      if not ReadFile(hDspToArcPipe,DspToArcBufRd,ARC_BUFFER_LENGTH,bytesRead,@DspToArcOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            DspToArcAdresatEn := false;
            WaitForSingleObject(hDspToArcEventRd,100); // ожидать подключение
          end;
          ERROR_NO_DATA :
          begin
            WaitForSingleObject(hDspToArcEventRd,100); // ожидать данные
            DspToArcAdresatEn := true;
          end;
          ERROR_IO_PENDING :
          begin
            WaitForSingleObject(hDspToArcEventRd,INFINITE); // ожидать данные
            CancelIO(hDspToArcPipe);
            DspToArcAdresatEn := true;
          end;
        else
          exitLoop := true; // завершить обслуживание потока при поломке трубы
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToArcPipe,DspToArcOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then
        begin // передать готовые данные
          DspToArcAdresatEn := true;

    // прочитать входные данные
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

    // записать выходные данные
        if DspToArcPending then
        begin
          DspToArcPending := not GetOverlappedResult(hDspToArcPipe,DspToArcOverLapWrt,cbTransWrt,false);
        end else
        if DspToArcOutputBufPtr > 0 then
        begin
          Move(DspToArcOutputBuf, DspToArcBufWrt, DspToArcOutputBufPtr);
          if WriteFile( hDspToArcPipe, DspToArcBufWrt, DspToArcOutputBufPtr, bytesWrite, @DspToArcOverLapWrt) then // Записать в трубу
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
              exitLoop := true; // завершить обслуживание потока при поломке трубы
            end;
          end;
        end;

      end;

    end else
    begin // попытаться подключиться к трубе с серверной стороны

      if ConnectNamedPipe(hDspToArcPipe,@DspToArcOverLapRd) then
      begin // подсоединение с трубой состоялось
        DspToArcConnected := true; DspToArcPending := false; DspToArcAdresatEn := true;
      end else
      begin // обработать ошибку подключения к трубе
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToArcConnected := true; exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            DspToArcConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // подключен клиент к трубе
            DspToArcConnected := true;
            DspToArcAdresatEn := true;
          end;
          ERROR_NO_DATA :
          begin // клиент закрыл трубу - требуется создать разорвать соединение
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

  until DspToArcBreak; // прекратить обслуживание трубы по запросу программы

  ExitThread(100);
end;

end.
