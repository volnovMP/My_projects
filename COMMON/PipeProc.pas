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

function InitpSD : Boolean;                   // создание пустого дескриптора безопасности
function InitEventPipes : Boolean;                   // создать события для обработки труб
procedure DspToDspServerProc(Param : Pointer); stdcall; //обработка трубы Dsp-Dsp (сервер)
procedure DspToDspClientProc(Param : Pointer); stdcall; //обработка трубы Dsp-Dsp (клиент)
procedure DspToARCProc(Param:Pointer);stdcall;//обработка трубы архива на удаленной машине
function SendDspToARC(Buf:pchar;Len:SmallInt):Boolean;//в буфер архива на удаленной машине

// новые переменные
var
  delta, maxdelta    : Double;
  LastRsv            : Double;
  pSD                : PSECURITY_DESCRIPTOR;
  sa                 : SECURITY_ATTRIBUTES;
  nDspToDspPipe      : WideString;
  hDspToDspPipe      : THandle;
  DspToDspBreak      : Boolean; // требование прекращения обслуживания канала ДСП-ДСП
  DspToDspEnabled    : Boolean; // требование инициализации канала ДСП-ДСП
  DspToDspConnected  : Boolean; // признак наличия соединения с трубой канала ДСП-ДСП
  DspToDspSucces     : Boolean; // готовность полученных данных по каналу ДСП-ДСП
  DspToDspPending    : Boolean; // блокировка записи данных на время передачи по трубе
  DspToDspOverLapWrt : TOVERLAPPED;
  DspToDspOverLapRd  : TOVERLAPPED;
  hDspToDspEventWrt  : THandle;
  hDspToDspEventRd   : THandle;
  DspToDspType       : Byte;    // тип окончания канала (0- сервер, 1- клиент)
	DspToDspThreadID   : ULONG;
  DspToDspParam      : Pointer;
  DspToDspBufRd      : array[0..8191] of Char;
  DspToDspBufWrt     : array[0..8191] of Char;
  DspToDspInputBuf   : string;                // входной буфер канала ДСП-ДСП
  DspToDspOutputBuf  : string;                // выходной буфер канала ДСП-ДСП
  DspToDspThread     : THandle;

  DspToArcThread     : THandle;
  DspToArcThreadID   : ULONG;
  DspToArcSucces     : Boolean; // готовность полученных данных по каналу ДСП-АРХИВ
  DspToArcPending    : Boolean; // блокировка записи данных на время передачи по трубе
  DspToArcConnected  : Boolean; // признак наличия соединения с трубой канала ДСП-АРХИВ
  DspToArcAdresatEn  : Boolean; // признак доступности другого конца трубы
	DspToArcEnabled    : Boolean; // требование инициализации канала ДСП-АРХИВ
  DspToArcParam      : Pointer;
  DspToArcBufRd      : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcBufWrt     : array[0..ARC_BUFFER_LENGTH-1] of Char;
  DspToArcInputBuf     : array[0..ARC_BUFFER_LENGTH-1] of Char; // входной буфер канала ДСП-АРХИВ
  DspToArcInputBufPtr  : Word;                   // указатель на конец данных в буфере приема
  DspToArcOutputBuf    : array[0..ARC_BUFFER_LENGTH-1] of Char; // выходной буфер канала ДСП-АРХИВ
  DspToArcOutputBufPtr : Word;                   // указатель на кон
  nDspToArcPipe      : WideString;
  hDspToArcPipe      : THandle;
  DspToArcOverLapRd  : TOVERLAPPED;
  hDspToArcEventWrt  : THandle;
  hDspToArcEventRd   : THandle;  //--------- событие подключения клиента к трубе ДСП-Архив
  DspToArcOverLapWrt : TOVERLAPPED;
  DspToArcBreak      : Boolean; //--- требование прекращения обслуживания канала ДСП-АРХИВ
  IsBreakKanalASU    : Boolean; //------------ признак завершения обслуживания каналов АСУ

  MsgError : string;

implementation

function InitpSD : Boolean; // создание пустого дескриптора безопасности
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

function InitEventPipes : Boolean; // создать события для обработки труб
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
// обработчик потока обмена между серверами (серверная сторона)
procedure DspToDspServerProc(Param : Pointer); stdcall;
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   s : string; i : integer;
begin
  DspToDspSucces := false;
  DspToDspPending := true;
  DspToDspConnected := false;
// создать экземпляр трубы
  hDspToDspPipe := CreateNamedPipeW(pWideChar(nDspToDspPipe),
    PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
    PIPE_READMODE_BYTE or PIPE_NOWAIT,
    PIPE_UNLIMITED_INSTANCES,
    8192,
    8192,
    50,
    @sa);
  if hDspToDspPipe = INVALID_HANDLE_VALUE then
  begin // не удалось создать трубу - выход
    MsgError := 'ErrorCode='+ IntToStr(GetLastError)+ ' Hand='+IntToStr(hDspToDspPipe);
    ExitThread(0);
    exit;
  end else
  begin // труба создана - подключиться со стороны сервера
    // запустить поток обслуживания канала
    exitLoop := false;
  end;

    repeat

    if DspToDspConnected then
    begin // прочитать трубу если есть подключение к трубе

    // прочитать трубу
      if not ReadFile(hDspToDspPipe,DspToDspBufRd,512,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            MsgError := 'Ожидание подключения клиента';
            WaitForSingleObject(hDspToDspEventRd,100); // ожидать данные
          end;
          ERROR_NO_DATA :
          begin 
            MsgError := 'Ожидание данных от клиента';
            DspToDspPending := false;
            WaitForSingleObject(hDspToDspEventRd,100); // ожидать данные
          end;
          ERROR_IO_PENDING :
          begin
            MsgError := 'Ожидание данных от клиента';
            DspToDspPending := false;
            WaitForSingleObject(hDspToDspEventRd,197); // ожидать данные
            CancelIO(hDspToDspEventRd);
          end;
        else
          MsgError := 'Read -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+IntToStr(hDspToDspPipe);
          exitLoop := true; // завершить обслуживание потока при поломке трубы
        end;
      end;

      if not exitLoop then
      begin
        GetOverlappedResult(hDspToDspPipe,DspToDspOverLapRd,cbTransRd,false);
        if cbTransRd <> 0 then
        begin //-------------------------------------------------- передать готовые данные

          if LastRsv > 0.00000000001 then
          begin
            delta := Time - LastRsv;
            if delta > maxdelta then maxdelta := delta;
          end;

          LastRsv := Time;

    // прочитать входные данные
          s := '';
          for i := 0 to cbTransRd-1 do s := s + DspToDspBufRd[i]; // Скопировать символы из буфера в строку
          if s <> '' then
          begin
            DspToDspInputBuf := DspToDspInputBuf + s;
          end;
          cbTransRd := 0;
          DspToDspSucces := true;
        end;

    // записать выходные данные
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
            MsgError := 'Write-> отправлено '+ IntToStr(i)+ ' байт';
            DspToDspOutputBuf := '';
            if not WriteFile( hDspToDspPipe, DspToDspBufWrt, i, bytesWrite, @DspToDspOverLapWrt) then // Записать в трубу
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
                exitLoop := true; // завершить обслуживание потока при поломке трубы
              end;
            end;
          end;
        end;

      end;

    end else
    begin // попытаться подключиться к трубе с серверной стороны

      if ConnectNamedPipe(hDspToDspPipe,@DspToDspOverLapRd) then
      begin // подсоединение с трубой состоялось
        MsgError := 'Connect -> Выполнено подключение '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
        DspToDspConnected := true;
        DspToDspPending := false;
        DspToDspOutputBuf := '';
      end else
      begin // обработать ошибку подключения к трубе
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            DspToDspConnected := true;
            MsgError := 'Connect -> ErrorCode=ERROR_IO_PENDING '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
          ERROR_PIPE_LISTENING :
          begin // ожидается подключение к трубе с клиентской стороны
            MsgError := 'Connect -> Ожидание подключения к трубе '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            DspToDspConnected := true;
          end;
          ERROR_PIPE_CONNECTED :
          begin // подключен клиент к трубе
            MsgError := 'Connect -> ErrorCode=ERROR_PIPE_CONNECTED '+ TimeToStr(Time)+ ' Hand='+IntToStr(hDspToDspPipe);
            DspToDspConnected := true;
          end;
          ERROR_NO_DATA :
          begin // клиент закрыл трубу - требуется разорвать соединение
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

  until DspToDspBreak; // прекратить обслуживание трубы по запросу программы

  ExitThread(0);
end;

procedure DspToDspClientProc(Param : Pointer); stdcall; // обработка трубы по чтению Dsp - Dsp (клиент)
  var cErr,bytesRead,cbTransRd,bytesWrite,cbTransWrt : Cardinal; exitLoop : boolean;
   s : string; i : integer; 
begin
  exitLoop := false;
  DspToDspPending := false;

  repeat

    if DspToDspConnected then
    begin // прочитать трубу если есть подключение к трубе

      if not ReadFile(hDspToDspPipe,DspToDspBufRd,512,bytesRead,@DspToDspOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_IO_PENDING :
          begin
            MsgError := 'Ожидание данных от сервера';
            WaitForSingleObject(hDspToDspEventRd,195); // ожидать данные
            CancelIO(hDspToDspEventRd);
          end;
          ERROR_BROKEN_PIPE :
          begin
            MsgError := 'Read -> ErrorCode='+ IntToStr(cErr)+ ' Hand='+ IntToStr(hDspToDspPipe);
            exitLoop := true; // завершить обслуживание потока при поломке трубы
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
        begin // передать сигнал готовности данных

          if LastRsv > 0.00000000001 then
          begin
            delta := Time - LastRsv;
            if delta > maxdelta then maxdelta := delta;
          end;
          LastRsv := Time;

    // прочитать входные данные
          s := '';
          for i := 0 to cbTransRd-1 do s := s + DspToDspBufRd[i]; // Скопировать символы из буфера в строку
          if s <> '' then
          begin
            DspToDspInputBuf := DspToDspInputBuf + s;
          end;
          cbTransRd := 0;
          DspToDspSucces := true;
        end;

    // записать выходные данные
        if DspToDspPending then
        begin
          DspToDspPending := not GetOverlappedResult(hDspToDspPipe,DspToDspOverLapWrt,cbTransWrt,false);
        end else
        // обработать буфер передачи
        if DspToDspOutputBuf <> '' then
        begin
          i := Length(DspToDspOutputBuf);
          if i > Length(DspToDspBufWrt) then i := Length(DspToDspBufWrt);
          if i > 0 then
          begin
            Move(DspToDspOutputBuf[1], DspToDspBufWrt, i);
            DspToDspOutputBuf := '';
            if not WriteFile( hDspToDspPipe, DspToDspBufWrt, i, bytesWrite, @DspToDspOverLapWrt) then // Записать в трубу
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
                exitLoop := true; // завершить обслуживание потока при поломке трубы
              end;
            end;
          end;
        end;

      end;

    end else
    begin // попытаться подключиться к трубе с клиентской стороны

      hDspToDspPipe := CreateFileW(PWideChar(nDspToDspPipe),
        GENERIC_WRITE or GENERIC_READ,
        FILE_SHARE_READ or FILE_SHARE_WRITE,
        nil,
        OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED,
        0);
      if hDspToDspPipe <> INVALID_HANDLE_VALUE then
      begin // соединеие с трубой состоялось
        DspToDspConnected := true;
        DspToDspOutputBuf := '';
        exitLoop := false;
      end else
      begin // обработать ошибку подключения к трубе
        cErr := GetLastError;
        case cErr of
          ERROR_FILE_NOT_FOUND :
          begin
            MsgError := 'Connect -> попытка подключения к несуществующей трубе '+ TimeToStr(Time)+ ' Hand='+ IntToStr(hDspToDspPipe);
            exitLoop := true;
          end;
          ERROR_SEEK_ON_DEVICE :
          begin
            MsgError := 'Connect -> попытка подключения к несуществующей трубе '+ TimeToStr(Time)+ ' Hand='+ IntToStr(hDspToDspPipe);
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
        WaitForSingleObject(hDspToDspEventRd,1000); // ожидать
    end;

  until DspToDspBreak;

  // завершить обслуживание трубы со стороны клиента
  ExitThread(0);
end;

//========================================================================================
//------ обработка трубы для сохранения архива на удаленной машине (серверный конец трубы)
//-------------------------------------------- функция потока для связи АРМа ДСП с архивом
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
  //-------------------------------------------------------------- создать экземпляр трубы
  hDspToArcPipe := CreateNamedPipeW(pWideChar(nDspToArcPipe),
  PIPE_TYPE_BYTE or PIPE_ACCESS_DUPLEX or FILE_FLAG_OVERLAPPED,
  PIPE_READMODE_BYTE or PIPE_NOWAIT,
  PIPE_UNLIMITED_INSTANCES,
  ARC_BUFFER_LENGTH,
  ARC_BUFFER_LENGTH,
  50,
  @sa);
  if hDspToArcPipe = INVALID_HANDLE_VALUE then //- если не удалось создать трубу, то выход
  begin ExitThread(0); exit; end

  //------ если труба создана,подключиться со стороны сервера,запустить поток обслуживания
  else exitLoop := false;
  repeat //----------------------------------------------------------- главный цикл потока
    if DspToArcConnected then //--------------------------- если есть подключение к архиву
    begin //---------- прочитать трубу если есть подключение к трубе, и если ошибка чтения
      if not ReadFile(hDspToArcPipe,DspToArcBufRd,ARC_BUFFER_LENGTH,bytesRead,@DspToArcOverLapRd) then
      begin
        cErr := GetLastError;
        case cErr of
          ERROR_PIPE_LISTENING : //---- ожидается подключение к трубе с клиентской стороны
          begin
            DspToArcAdresatEn := false;
            WaitForSingleObject(hDspToArcEventRd,100); //------ ожидать подключение 100 мс
          end;

          ERROR_NO_DATA :  //----------------------------------- нет данных, труба закрыта
          begin
            WaitForSingleObject(hDspToArcEventRd,100); //----------- ожидать данные 100 мс
            DspToArcAdresatEn := true;
          end;

          ERROR_IO_PENDING :  //---------------------------- включена асинхронная операция
          begin
            WaitForSingleObject(hDspToArcEventRd,INFINITE); //------------- ожидать данные
            CancelIO(hDspToArcPipe);
            DspToArcAdresatEn := true;
          end;

          else  exitLoop := true; //------ завершить обслуживание потока при поломке трубы
        end;
      end;

      if not exitLoop then //----------------------------------------- если труба в работе
      begin
        //---------------------------------------- проверить процесс чтения архивной трубы
        GetOverlappedResult(hDspToArcPipe,DspToArcOverLapRd,cbTransRd,false);
        if cbTransRd > 0 then //----------------------------- если есть прочитанные данные
        begin
          DspToArcAdresatEn := true;//выставить признак доступности данных из трубы архива
          i := 0;
          if DspToArcInputBufPtr + cbTransRd <= High(DspToArcInputBuf) then
          begin
            while i < cbTransRd do //------ побайтное чтение данных из буфера трубы архива
            begin
              DspToArcInputBuf[DspToArcInputBufPtr] := DspToArcBufRd[i];
              inc(i);
              inc(DspToArcInputBufPtr);
            end;
            cbTransRd := 0;
            DspToArcSucces := true;
          end;
        end;

        if DspToArcPending then //--- если установлена блокировка записи на время передачи
        begin
          DspToArcPending := //-- установить блокировку по инверсии события записи в трубу
          not GetOverlappedResult(hDspToArcPipe,DspToArcOverLapWrt,cbTransWrt,false);
        end else
        if DspToArcOutputBufPtr > 0 then //-------------------- если нет блокировки записи
        begin
          Move(DspToArcOutputBuf,DspToArcBufWrt,DspToArcOutputBufPtr);
          //------------------------------------------------------------- Записать в трубу
          if WriteFile(hDspToArcPipe,DspToArcBufWrt,DspToArcOutputBufPtr,bytesWrite,@DspToArcOverLapWrt)
          then DspToArcOutputBufPtr := 0 //------------------ если запись выполнена удачно
          else
          begin
            cErr := GetLastError; //---------------------- если неудачно, получить причину
            case cErr of
              //------------------------------------------------- если операция в ожидании
              ERROR_IO_PENDING : begin DspToArcOutputBufPtr:=0;DspToArcPending:=true;end;
              //--------------------------------------- если не ожидание, то поломка трубы
              else exitLoop := true; //--- завершить обслуживание потока при поломке трубы
            end;
          end;
        end;
      end;
    end else //-------------------------------------- если нет подключения сервера к трубе
    begin //-------------------------- попытаться подключиться к трубе с серверной стороны
      if ConnectNamedPipe(hDspToArcPipe,@DspToArcOverLapRd) then //---------- если успешно
      begin //------------------------------------------- подсоединение к трубе состоялось
        DspToArcConnected := true; DspToArcPending := false; DspToArcAdresatEn := true;
      end else
      begin //---------- если неудачное подключение, обработать ошибку подключения к трубе
        cErr := GetLastError;
        case cErr of

          ERROR_IO_PENDING : begin DspToArcConnected := true; exitLoop := true;  end;

          ERROR_PIPE_LISTENING : DspToArcConnected:=true;//------ ждем подключение клиента

          ERROR_PIPE_CONNECTED : // ------------------------------- клиент уже подключился
            begin
              DspToArcConnected:=true;
              DspToArcAdresatEn:=true;//------------------------- подключен клиент к трубе
            end;

          ERROR_NO_DATA :exitLoop := true;//-- клиент закрыл трубу -  разорвать соединение

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
   until DspToArcBreak; //------------- прекратить обслуживание трубы по запросу программы
  ExitThread(100);
end;
//========================================================================================
//------------------ Поместить данные в буфер канала сохранения архива на удаленной машине
function SendDspToARC(Buf : pchar; Len : SmallInt) : Boolean;
var
  lBuf : SmallInt;
begin
  result := false;
  if (Len = 0) or (DspToArcOutputBufPtr + Len > ARC_BUFFER_LENGTH)
  then exit; //------------------------- если данных нет или мало места в буфере, то выйти

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
