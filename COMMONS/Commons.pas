unit Commons;
//------------------------------------------------------------------------------
//
//                общеупотребимые процедуры и константы
//
//  версия                    - 1
//  редакция                  - 5
//
//  дата последнего изменения - 14 июля 2006г.
//------------------------------------------------------------------------------

{$INCLUDE CfgProject}

interface

uses
  Windows, Forms, SysUtils, Graphics,
  TabloForm;

{$IFDEF RMARC}
procedure ArcMsg(Obj,Msg : SmallInt; Offset : Integer);
{$ENDIF}
function IsTestMode : Boolean;
function GetColor(param : SmallInt) : TColor;
function GetShortMsg(nlex, index : integer; arg : string) : string;
procedure ShowShortMsg(index, x, y : integer; arg : string);
procedure PutShortMsg(clr, x, y : integer; msg : string);
procedure ResetShortMsg;
procedure InsArcNewMsg(Obj,Msg : SmallInt);
procedure AddFixMessage(msg : string; color : SmallInt; alarm : SmallInt);
procedure ResetFixMessage;
procedure SetLockHint;
procedure UnLockHint;
procedure SetParamTablo; // Установить параметры табло для текущего района управления
function  GetNameObjZav(Index : SmallInt) : string;
procedure ReportF(Rep : string); // сохранить строку в файле протокола
{$IFNDEF RMARC}
procedure InsNewArmCmd(Obj,Cmd : Word); // добавить команду меню в архив
{$ENDIF}

// Определение цветов для РМ-ДСП
const
  armcolor1  =   0 * 65536 +   0 * 256 + 255;
  armcolor2  =   0 * 65536 + 255 * 256 +   0;
  armcolor3  = 255 * 65536 +   0 * 256 +   0;
  armcolor4  =   0 * 65536 +   0 * 256 + 191;
  armcolor5  =   0 * 65536 + 191 * 256 +   0;
  armcolor6  = 191 * 65536 +   0 * 256 +   0;
  armcolor7  =   0 * 65536 + 255 * 256 + 255;
  armcolor8  = 127 * 65536 + 127 * 256 + 127;
  armcolor9  = 255 * 65536 + 255 * 256 + 255;
  armcolor10 = 255 * 65536 +   0 * 256 + 127;
  armcolor11 = 255 * 65536 +   0 * 256 + 255;
  armcolor12 =  95 * 65536 +  95 * 256 +  95;
  armcolor13 =   1 * 65536 + 135 * 256 + 205;
  armcolor14 = 255 * 65536 + 255 * 256 +   0;
{$IFDEF RMARC}
  armcolor15 = 160 * 65536 + 196 * 256 + 196;
{$ELSE}
  armcolor15 = 191 * 65536 + 191 * 256 + 191;
{$ENDIF}
  armcolor16 = 239 * 65536 + 239 * 256 + 239;
  armcolor17 =  63 * 65536 +  63 * 256 +  63;
  armcolor18 = 205 * 65536 + 205 * 256 + 205;
  armcolor19 = 209 * 65536 + 209 * 256 + 209;

  bkgndcolor  = armcolor15; // фон табло
  focuscolor  = armcolor19; // фон выделенной строки в списке сообщений
  snsidecolor = armcolor16; // освещенная сторона
  dksidecolor = armcolor17; // теневая сторона
  bkkeycolor  = armcolor18; // фон кнопки

implementation

uses
{$IFDEF RMARC}
  PackArmSrv,
{$ELSE}
  KanalArmSrv,
{$ENDIF}
  MsgForm,
  VarStruct;

var
  s : string;
{$IFNDEF RMARC}
  t : string;
{$ENDIF}

//------------------------------------------------------------------------------
// Установить формат табло для текущего района управления
procedure SetParamTablo;
begin
{$IFDEF RMDSP}
  shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].TabloSize.Y;
  TabloMain.Width  := configRU[config.ru].TabloSize.X;
  isChengeRegion := false;
  Tablo1.Height  := configRU[config.ru].TabloSize.Y-15;
  Tablo1.Width   := configRU[config.ru].TabloSize.X;
  Tablo2.Height  := configRU[config.ru].TabloSize.Y-15;
  Tablo2.Width   := configRU[config.ru].TabloSize.X;
  if not StartRM then AddFixMessage(GetShortMsg(1,275,'ДСПЦ'+ IntToStr(config.ru)),0,2);
{$ELSE}
  TabloMain.PaintBox1.Height := configRU[config.ru].TabloSize.Y;
  TabloMain.PaintBox1.Width  := configRU[config.ru].TabloSize.X;
  Tablo1.Height  := configRU[config.ru].TabloSize.Y-15;
  Tablo1.Width   := configRU[config.ru].TabloSize.X;
  Tablo2.Height  := configRU[config.ru].TabloSize.Y-15;
  Tablo2.Width   := configRU[config.ru].TabloSize.X;
{$ENDIF}
{$IFDEF RMARC}
  shiftxscr := 0; shiftyscr := 0;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// блокировка вывода описания объекта табло
procedure SetLockHint;
begin
{$IFNDEF RMARC}
  LockHint := true;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// разблокирование вывода описания объектов табло
procedure UnLockHint;
begin
{$IFNDEF RMARC}
  LockHint := false; LastMove := Date+Time;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Проверка допустимости работы АРМа в тестовом режиме
function IsTestMode : Boolean;
begin
  IsTestMode := (asTestMode = $AA);
end;

//------------------------------------------------------------------------------
// получить цвет по его коду
function GetColor(param : SmallInt) : TColor;
begin
  case param of
    1  : result := armcolor1; // lt red     - светофор
    2  : result := armcolor2; // lt green   - светофор
    3  : result := armcolor3; // lt blue
    4  : result := armcolor4; // red
    5  : result := armcolor5; // green
    6  : result := armcolor6; // blue       - подсветка положения стрелок
    7  : result := armcolor7; // yellow
    8  : result := armcolor8; // gray
    9  : result := armcolor9; // white      - маневровый сигнал, предварительное замыкание
    10 : result := armcolor10; // magenta    - МСП
    11 : result := armcolor11; // dk magenta - неисправность
    12 : result := armcolor12; // dk cyan    - цвет нецентрализованных объектов
    13 : result := armcolor13; // brown      - местное управление
    14 : result := armcolor14; // cyan       - непарафазность
    15 : result := armcolor15; // background - фон
    16 : result := armcolor16; // солнечная сторона - контур кнопки
    17 : result := armcolor17; // теневая сторона - контур кнопки
    18 : result := armcolor18; // фон кнопки
    19 : result := armcolor19; // подсветка кнопки
  else
        result := 0; // black
  end;
end;

//------------------------------------------------------------------------------
// Добавить в архив новое сообщение
procedure InsArcNewMsg(Obj,Msg : SmallInt);
{$IFNDEF RMARC}  var bh,bl : Byte; k,m : Integer; {$ENDIF}
begin
// Дополнить буфер сообщений
{$IFNDEF RMARC}
  bh := Obj div $100; bl := Obj - (bh * $100); NewMsg := NewMsg + chr(bl) + chr(bh);
  bh := Msg div $100; bl := Msg - (bh * $100); NewMsg := NewMsg + chr(bl) + chr(bh);
  if Msg = $3001 then
  begin
    s := 'Зафиксирована неисправность входного интерфейса '+ IntToStr(Obj); DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); s := t + ' > '+ s;
  end else
  if Msg = $3002 then
  begin
    s := 'Зафиксировано восстановление входного интерфейса '+ IntToStr(Obj); DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); s := t + ' > '+ s;
  end else
  if (Msg >= $3003) and (Msg <= $3007) then // Сообщения диагностики УВК не дублировать (выводятся в процедуре обработки состояний)
  begin
    exit;
  end else
  // поместить сообщение в буфер неисправностей и предупреждений
  if Msg >= 0 then
  begin
    k := Msg and $0c00; m := Msg and $03ff;
    case k of
      $400 : begin // LEX2
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(2,m,ObjZav[Obj].Liter);
      end;
      $800 : begin // LEX3
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(3,m,ObjZav[Obj].Liter);
      end;
    else // LEX
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(1,m,ObjZav[Obj].Liter);
    end;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    s := t + ' > '+ s;
  end;
  if s <> '' then
  begin
    if (Msg < $3000) or (Msg >= $4000) then
    begin // предупреждения и сообщения о неисправностях устройств
      ListMessages := s + #13#10 + ListMessages; newListMessages := true;
      if Length(ListMessages) > 200000 then
      begin // отрезать хвост если строка длиннее допустимого
        k := 199000; SetLength(ListMessages,k);
        while (k > 0) and (ListMessages[k] <> #10) do dec(k); SetLength(ListMessages,k);
      end;
      if (Msg > $1000) and (Msg < $2000) then
      begin // поместить в список неисправностей устройств
        ListNeisprav := s + #13#10 + ListNeisprav; newListNeisprav := true;
        if Length(ListNeisprav) > 200000 then
        begin // отрезать хвост если строка длиннее допустимого
          k := 199000; SetLength(ListNeisprav,k);
          while (k > 0) and (ListNeisprav[k] <> #10) do dec(k); SetLength(ListNeisprav,k);
        end;
      end;
    end else
    begin // диагностические сообщения УВК
      ListDiagnoz := s + #13#10 + ListDiagnoz; newListDiagnoz := true;
      SingleBeep4 := true;
      if Length(ListDiagnoz) > 200000 then
      begin // отрезать хвост если строка длиннее допустимого
        k := 199000; SetLength(ListDiagnoz,k);
        while (k > 0) and (ListDiagnoz[k] <> #10) do dec(k); SetLength(ListDiagnoz,k);
      end;
    end;
    NewNeisprav := true; // Зафиксирована новая неисправность, предупреждение
{$ENDIF}
{$IFDEF ARMSN}
    rifreshMsg := false; // Требование обновить списки сообщений
{$ENDIF}
{$IFNDEF RMARC}
  end;
{$ENDIF}
end;

{$IFDEF RMARC}
procedure ArcMsg(Obj,Msg : SmallInt; Offset : Integer);
  var k,m : Integer; s,t : string;
begin
  if Msg = $3001 then
  begin
    s := 'Зафиксирована неисправность входного интерфейса '+ IntToStr(Obj);
  end else
  if Msg = $3002 then
  begin
    s := 'Зафиксировано восстановление входного интерфейса '+ IntToStr(Obj);
  end else
  if (Msg >= $3003) and (Msg <= $3006) then // Сообщения диагностики УВК не дублировать (выводятся в процедуре обработки состояний)
  begin
    exit;
  end else
  if (Msg > $3006) and (Msg < $4000) then
  begin // LEX
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      s := GetShortMsg(1,m,ObjZav[Obj].Liter);
    end else
      s := GetShortMsg(1,m,'');
  end;
  // поместить сообщение в буфер неисправностей и предупреждений
  if Length(ListNeisprav) > 200000 then
  begin // отрезать хвост если строка длиннее допустимого
    k := 199000; SetLength(ListNeisprav,k); while (k > 0) and (ListNeisprav[k] <> #10) do dec(k); SetLength(ListNeisprav,k);
  end;
  if (Msg >= 0) and (Msg < $3000) then
  begin
    k := Msg and $0c00;
    m := Msg and $03ff;
    case k of
      $400 : begin // LEX2
        if (Obj > 0) and (Obj < 4096) then
        begin
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(2,m,ObjZav[Obj].Liter);
        end else
          s := GetShortMsg(2,m,'');
      end;
      $800 : begin // LEX3
        if (Obj > 0) and (Obj < 4096) then
        begin
          if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(3,m,ObjZav[Obj].Liter);
        end else
          s := GetShortMsg(3,m,'');
      end;
    else // LEX
        if (Obj > 0) and (Obj < 4096) then
        begin
          if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(1,m,ObjZav[Obj].Liter);
        end else
          s := GetShortMsg(1,m,'');
    end;
  end else
  if Msg < $1000 then
  begin // LEX - сообщения о состоянии устройств
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(1,m,ObjZav[Obj].Liter);
    end else
      s := GetShortMsg(1,m,'');
  end else
  if (Msg >= $4000) and (Msg < $5000) then
  begin // LEX - диалог с оператором, меню, запросы, подтверждение команд
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(1,m,ObjZav[Obj].Liter);
    end else
      s := GetShortMsg(1,m,'');
  end;
  if (Msg >= $5000) and (Msg < $6000) then
  begin // LEX - диалог с оператором, предупреждения при формировании команд
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then s := MsgList[m] else s := GetShortMsg(1,m,ObjZav[Obj].Liter);
    end else
      s := GetShortMsg(1,m,'');
  end;
  if s <> '' then
  begin
    if LastFixed < Offset then
    begin
      DateTimeToString(t,'dd-mm-yy hh:nn:ss', DTFrameOffset);
      s := t + ' > '+ s;
      if (Msg < $3000) or (Msg >= $4000) then
      begin // предупреждения и сообщения о неисправностях устройств, меню, запросы
        ListNeisprav := s + #13#10 + ListNeisprav;
        if (Msg > $1000) and (Msg < $2000) then SndNewWar := true;
      end else
      begin // диагностические сообщения УВК
        ListDiagnoz := s + #13#10 + ListDiagnoz; SndNewUvk := true;
      end;
      NewNeisprav := true; // Зафиксирована новая неисправность, предупреждение, запрос
    end;
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// Вывести короткое сообщение
procedure ShowShortMsg(index, x, y : integer; arg : string);
{$IFDEF RMDSP}  var i,j : integer; c : TColor; {$ENDIF}
begin
{$IFDEF RMDSP}
  if (index < 1) or (index > Length(Lex)) then
  begin
    s := 'Ошибочный индекс короткого сообщения.'; c := armcolor1;
  end else
  begin
    s := Lex[index].msg; t := '';
    for i := 1 to Length(s) do begin if s[i] = '$' then t := t + arg else t := t + s[i]; end;
    c := Lex[index].Color;
  end;
  SetLockHint;
  j := x div configRU[config.ru].MonSize.X + 1; // Найти номер табло
  for i := 1 to 4 do begin if i = j then begin shortMsg[i] := t; shortMsgColor[i] := c; end else shortMsg[i] := ''; end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// получить строку сообщения из списков Lex, Lex2, Lex3
function GetShortMsg(nlex, index : integer; arg : string) : string;
  var i : integer;
begin
  case nlex of
    1 : begin
      if (index < 1) or (index > High(Lex)) then
      begin
        s := 'Ошибочный индекс короткого сообщения.';
      end else
      begin
        s := Lex[index].msg; result := '';
        for i := 1 to Length(s) do begin if s[i] = '$' then result := result + arg else result := result + s[i]; end;
      end;
    end;

    2 : begin
      if (index < 1) or (index > Length(Lex2)) then
      begin
        s := 'Ошибочный индекс короткого сообщения.';
      end else
      begin
        s := Lex2[index].msg; result := '';
        for i := 1 to Length(s) do begin if s[i] = '$' then result := result + arg else result := result + s[i]; end;
      end;
    end;

    3 : begin
      if (index < 1) or (index > Length(Lex3)) then
      begin
        s := 'Ошибочный индекс короткого сообщения.';
      end else
      begin
        s := Lex3[index].msg; result := '';
        for i := 1 to Length(s) do begin if s[i] = '$' then result := result + arg else result := result + s[i]; end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Вывести сообщение на экран
procedure PutShortMsg(clr, x, y : integer; Msg : string);
{$IFDEF RMDSP}  var i,j : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  j := x div configRU[config.ru].MonSize.X + 1; // Найти номер табло
  SetLockHint;
  for i := 1 to 4 do
  begin
    if i = j then
    begin
      shortMsg[i] := Msg; shortMsgColor[i] := GetColor(clr);
    end else shortMsg[i] := '';
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Сбросить короткие сообщения РМ-ДСП
procedure ResetShortMsg;
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  ShowWarning := false;
  for i := 1 to Length(ShortMsg) do ShortMsg[i] := '';
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Добавить строку к фиксируемым сообщениям
procedure AddFixMessage(msg : string; color : SmallInt; alarm : SmallInt);
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  if WorkMode.Upravlenie then
  begin // фиксируем сообщения если включено управление
    DateTimeToString(s,'hh:mm:ss',LastTime);
    if FixMessage.Count > 0 then
    begin
      for i := High(FixMessage.Msg) downto 2 do
      begin
        FixMessage.Msg[i] := FixMessage.Msg[i-1]; FixMessage.Color[i] := FixMessage.Color[i-1];
      end;
    end;
    FixMessage.Msg[1] := s + ' > ' + msg; FixMessage.Color[1] := GetColor(color);
    FixMessage.MarkerLine := 1; FixMessage.StartLine := 1;
    if FixMessage.Count < High(FixMessage.Msg) then inc(FixMessage.Count);
    case alarm of
      1 : SingleBeep  := true;
      2 : SingleBeep2 := true;
      3 : sound := true;
      4 : SingleBeep4 := true;
      5 : SingleBeep5 := true;
      6 : SingleBeep6 := true;
    end;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Сбросить строку фиксируемого сообщения
procedure ResetFixMessage;
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  if (FixMessage.Count > 0) and (FixMessage.MarkerLine > 0) then
  begin
    if FixMessage.MarkerLine < FixMessage.Count then
    begin
      for i := FixMessage.MarkerLine + 1 to FixMessage.Count do
      begin
        FixMessage.Msg[i-1] := FixMessage.Msg[i]; FixMessage.Color[i-1] := FixMessage.Color[i];
      end;
      dec(FixMessage.Count);
    end else
    begin
      dec(FixMessage.Count); dec(FixMessage.MarkerLine);
    end;
    if FixMessage.Count = 0 then
    begin
      FixMessage.MarkerLine := 1; FixMessage.StartLine := 1;
    end else
    begin
      if (FixMessage.MarkerLine > 4) and ((FixMessage.MarkerLine - FixMessage.StartLine) < 4) then FixMessage.StartLine := FixMessage.MarkerLine - 4;
      if FixMessage.MarkerLine < FixMessage.StartLine then FixMessage.StartLine := FixMessage.MarkerLine;
    end;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Получить наименование объекта зависимостей по его индексу в базе данных
function GetNameObjZav(Index : SmallInt) : string;
begin
  if Index = 0 then result := 'УВК' else
  case ObjZav[Index].TypeObj of
    1,2 : begin
      result := 'стр'+ ObjZav[Index].Liter;
    end;
  else
    result := ObjZav[Index].Liter;
  end;
end;

{$IFNDEF RMARC} var repl : string; {$ENDIF}
//------------------------------------------------------------------------------
// сохранить строку в файле протокола
procedure ReportF(Rep : string);
{$IFNDEF RMARC} var hfile,hnbw: cardinal; fp: longword; {$ENDIF}
begin
{$IFNDEF RMARC}
  repl := rep + #13#10;
  hfile := CreateFile(PChar(ReportFileName),
                      GENERIC_WRITE,
                      0,
                      nil,
                      OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      0);
  if hfile = INVALID_HANDLE_VALUE then exit;
  try
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then
      WriteFile(hfile, repl[1], Length(repl), hnbw, nil);
  finally
    CloseHandle(hfile);
  end;
{$ENDIF}
end;

{$IFNDEF RMARC}
//------------------------------------------------------------------------------
// добавить команду меню в архив
procedure InsNewArmCmd(Obj,Cmd : Word);
  var bh,bl : Byte;
begin
  bh := obj div $100; bl := obj - (bh * $100); NewMenuC := NewMenuC + chr(bl) + chr(bh);
  bh := Cmd div $100; bl := Cmd - (bh * $100); NewMenuC := NewMenuC + chr(bl) + chr(bh);
end;
{$ENDIF}

end.
