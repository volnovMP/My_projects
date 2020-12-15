unit Commons;

//========================================================================================
//-------------------------------------------------  общеупотребимые процедуры и константы
{$INCLUDE d:\Sapr2012\CfgProject}
interface

uses
  Windows,    Forms,  SysUtils,  Graphics;

{$IFDEF RMARC} procedure ArcMsg(Obj : integer; Msg : SmallInt; Offset : Integer); {$ENDIF}

procedure RepF(Rep : string); //-------------------- сохранить строку в файле протокола
procedure ResetCommands; //------------------------------------ сброс всех активных команд
function GetColor1(param : SmallInt) : TColor;
function IsTestMode : Boolean;
function GetSMsg(nlex, index : integer; arg : string; cvt : integer) : string;
function findchar(var index: integer;const s: string;const c: char): boolean;
function getbool(var index: integer;const s: string;var p: boolean): boolean;
function getbyte(var index: integer;const s: string;var p: Byte): boolean;
function getcrc16(var index: integer;const s: string;var p: Word): boolean;
function getcrc32(var index: integer;const s: string;var p: integer): boolean;
function getcrc8(var index: integer;const s: string;var p: Byte): boolean;
function getinteger(var index: integer;const s: string;var p: integer): boolean;
function getsmallint(var index: integer;const s: string;var p: smallInt): boolean;
function getstring(var index: integer;const s: string;var p: string): boolean;
function getword(var index: integer;const s: string;var p: Word): boolean;
function skipchar(var index: integer; const s: string; const c: char): boolean;

//------------------------------------- PutSMsg(clr-цвет; x, y-координаты;  msg-текст)
procedure ShowSMsg(index, x, y : integer; arg : string);
procedure PutSMsg (clr,   x, y : integer; msg : string);
procedure RSTMsg;
procedure InsNewMsg(Obj : Integer; Msg,cvt : SmallInt;datch:string);
procedure AddFixMes(msg1 : string; color1 : SmallInt; alarm : SmallInt);
procedure ResetFixMessage;
procedure SetLockHint;
procedure SimpleBeep;
procedure UnLockHint;
procedure SetParamTablo; //----- Установить параметры табло для текущего района управления
function GetNameObj(Index : SmallInt) : string;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function GetFR4State(param : Word) : Boolean;
function GetFR5(param : Word) : Byte;


{$IFNDEF RMARC} procedure InsNewArmCmd(Obj, Cmd : Word); {команду меню в архив} {$ENDIF}
var
  t : string;
implementation
uses
{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMDSP}
  TabloDSP,
{$ENDIF}

{$IFNDEF TABLO}
   Marshrut,
{$ENDIF}

{$IFDEF RMSHN}
  TabloSHN,
  MsgForm,
{$ENDIF}

{$IFNDEF TABLO}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

{$IFDEF RMDSP}
  KanalArmSrvDSP,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
{$ENDIF}

{$ENDIF}

 TypeALL;
//========================================================================================
//--------------------------------- Установить формат табло для текущего района управления
procedure SetParamTablo;
begin
{$IFDEF RMDSP}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].T_S.Y;
  TabloMain.Width  := configRU[config.ru].T_S.X;
  isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].T_S.Y-15;
  Tablo1.Width   := configRU[config.ru].T_S.X;

  Tablo2.Height  := configRU[config.ru].T_S.Y-15;
  Tablo2.Width   := configRU[config.ru].T_S.X;
  if not StartRM
  then AddFixMes(GetSMsg(1,275,'ДСПЦ'+ IntToStr(config.ru),7),0,2);
{$ENDIF}

{$IFDEF RMARC}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].T_S.Y;
  TabloMain.Width  := configRU[config.ru].T_S.X;
  isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].T_S.Y-15;
  Tablo1.Width   := configRU[config.ru].T_S.X;

  Tablo2.Height  := configRU[config.ru].T_S.Y-15;
  Tablo2.Width   := configRU[config.ru].T_S.X;
  if not StartRM
  then AddFixMes(GetSMsg(1,275,'ДСПЦ'+ IntToStr(config.ru),0),0,2);
{$ENDIF}

{$IFDEF RMSHN}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].T_S.Y;
  TabloMain.Width  := configRU[config.ru].T_S.X;
  //isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].T_S.Y-15;
  Tablo1.Width   := configRU[config.ru].T_S.X;

  Tablo2.Height  := configRU[config.ru].T_S.Y-15;
  Tablo2.Width   := configRU[config.ru].T_S.X;
  if not StartRM
  then AddFixMes(GetSMsg(1,275,'ДСПЦ'+ IntToStr(config.ru),0),0,2);
{$ENDIF}

{$IFDEF TABLO}
  TabloMain.Tablo.Height := configRU[config.ru].T_S.Y;
  TabloMain.Tablo.Width  := configRU[config.ru].T_S.X;
  Tablo1.Height  := configRU[config.ru].T_S.Y-15;
  Tablo1.Width   := configRU[config.ru].T_S.X;

  Tablo2.Height  := configRU[config.ru].T_S.Y-15;
  Tablo2.Width   := configRU[config.ru].T_S.X;
{$ENDIF}

{$IFDEF RMARC}
//  shiftxscr := 0; shiftyscr := 0;
  Tablo1.Height  := configRU[config.ru].T_S.Y-15;
  Tablo1.Width   := configRU[config.ru].T_S.X;

  Tablo2.Height  := configRU[config.ru].T_S.Y-15;
  Tablo2.Width   := configRU[config.ru].T_S.X;
{$ENDIF}
end;
//========================================================================================
// блокировка вывода описания объекта табло
procedure SetLockHint;
begin
{$IFNDEF RMARC}   LockHint := true;   {$ENDIF} // для просмотрщика архива это пропускается
end;

//------------------------------------------------------------------------------
// разблокирование вывода описания объектов табло
procedure UnLockHint;
begin
{$IFNDEF RMARC}
  LockHint := false; LastMove := Date + Time;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// Проверка допустимости работы АРМа в тестовом режиме
function IsTestMode : Boolean;
begin
  IsTestMode := (asTestMode = $AA);
end;
//========================================================================================
//------------------------------------------------- Добавить в Мемо - окна новое сообщение
procedure InsNewMsg(Obj: integer; Msg,Cvt: SmallInt; datch : String);
{$IFNDEF RMARC}{$IFNDEF TABLO}
var
  ss : string;
  bh, bl : Byte;
  k,m : Integer;
{$ENDIF}{$ENDIF}
begin
  //------------------------------------------------------------ Дополнить буфер сообщений
  {$IFNDEF RMARC} {$IFNDEF TABLO}
  bh:=Obj div $100; bl:=Obj-(bh*$100); NewMsg:=NewMsg+chr(bl)+chr(bh);
  bh:=Msg div $100; bl:=Msg-(bh*$100); NewMsg:=NewMsg+chr(bl)+chr(bh);

  if Msg=$3001 then
  begin
    ss := 'Неисправность входного интерфейса '+ IntToStr(Obj); //------------------ объект
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end else
  if Msg = $3010 then
  begin
    ss := 'Неисправность входного интерфейса '+  LinkFR[Obj].Name;//------------------ бит
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end else
  if Msg = $3002 then
  begin
    ss := 'Восстановление входного интерфейса '+  IntToStr(Obj);
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end
  else
  //- Сообщения диагностики УВК не дублировать (выводятся в процедуре обработки состояний)
  if (Msg >= $3003) and (Msg <= $3007) then exit
  else  //-------------------- поместить сообщение в буфер неисправностей и предупреждений
  if Msg >= 0 then
  begin
    k := Msg and $0c00;  m := Msg and $03ff;
    with ObjZv[Obj] do
    case k of
      $400 :
      begin //------------------------------------------------------ текст берется из LEX2
        if (TypeObj=33) or (TypeObj=36) then ss:=MsgList[m]
        else ss := GetSMsg(2,m,Liter,Cvt);
      end;

      $800 :
      begin //--------------------------------------------------------------- тект из LEX3
        if (TypeObj=33) or (TypeObj=36) then ss:=MsgList[m]
        else ss:=GetSMsg(3,m,Liter,Cvt);
      end;

      else //---------------------------------------------------------------- текст из LEX
        //---- дискретный датчик, доступ к параметрам, кнопка с датчиками, сборка датчиков
        if(TypeObj=33) or (TypeObj=35) or (TypeObj=36) or (TypeObj=51) then ss:=MsgList[m]
        else ss := GetSMsg(1,m,Liter,Cvt);
    end;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss + ' ' + datch;
  end;

  if ss <> '' then
  begin
    if (Msg < $3000) or (Msg >= $4000) then
    begin //------------------------ предупреждения и сообщения о неисправностях устройств
      ListMessages := ss + #13#10 + ListMessages;  newListMessages := true;

      if Length(ListMessages) > 200000 then
      begin //----------------------------- отрезать хвост если строка длиннее допустимого
        k := 199000; SetLength(ListMessages,k);
        while (k > 0) and (ListMessages[k] <> #10) do dec(k);
        SetLength(ListMessages,k);
      end;

      if (Msg > $1000) and (Msg < $2000) then
      begin //-------------------------------- поместить в список неисправностей устройств
        LstNN := ss + #13#10 + LstNN;  newListNeisprav := true;
        if Length(LstNN) > 200000 then
        begin //--------------------------- отрезать хвост если строка длиннее допустимого
          k := 199000; SetLength(LstNN,k);
          while (k > 0) and (LstNN[k] <> #10) do dec(k);
          SetLength(LstNN,k);
        end;
      end;
    end else
    begin //------------------------------------------------ диагностические сообщения УВК
      ListDiagnoz := ss + #13#10 + ListDiagnoz; newListDiagnoz := true; SBeep[4] := true;
      if Length(ListDiagnoz) > 200000 then
      begin //----------------------------- отрезать хвост если строка длиннее допустимого
        k := 199000;  SetLength(ListDiagnoz,k);
        while (k > 0) and (ListDiagnoz[k] <> #10) do dec(k);
        SetLength(ListDiagnoz,k);
      end;
    end;
    NewNeisprav := true; //------------- Зафиксирована новая неисправность, предупреждение
  {$IFDEF ARMSN} rifreshMsg := false; {$endif} //---- Требование обновить списки сообщений
  end;
{$ENDIF}{$ENDIF}
end;
//========================================================================================
{$IFDEF RMARC}
procedure ArcMsg(Obj : integer; Msg : SmallInt; Offset : Integer);
var
  k,m : Integer;
  s,t : string;
begin
  if Msg = 273 then //-------------------------- "РМДСП переведен в управляющее состояние"
  begin
    WorkMode.Upravlenie:= true; StateRU:= StateRU or $80; DirState[1]:=DirState[1] or $80;
  end;

  if Msg = 274 then     //------------------------------------- "РМДСП переведен в резерв"
  begin
    WorkMode.Upravlenie:=false; StateRU:=StateRU and $7F;DirState[1]:=DirState[1] and $7f;
  end;

  if Msg=$3001 then s:='Неисправность входного интерфейса '+IntToStr(Obj) else// № объекта
  if Msg = $3010 then
  begin
    s := 'Неисправность входного интерфейса '+ LinkFR[Obj].Name; //-------------- имя бита
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);  s := t + ' > '+ s //- дата и время
  end else
  if Msg = $3002 then s := 'Восстановление входного интерфейса '+ IntToStr(Obj) else //- №
  if (Msg >= $3003) and (Msg <= $3006) then exit else //Диагностика УВК выводится не здесь
  if (Msg > $3006) and (Msg < $4000) then //------------ сообщещние из строк файла LEX.sdb
  begin
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then s := GetSMsg(1,m,ObjZv[Obj].Liter,0) //добавить имя
    else s := GetSMsg(1,m,'',0); //------------------------------------- без имени объекта
  end;

  //-------------------------- поместить сообщение в буфер неисправностей и предупреждений
  if Length(LstNN) > 200000 then
  begin //-------------------------------- отрезать хвост, если строка длиннее допустимого
    k := 199000; SetLength(LstNN,k); while (k > 0) and (LstNN[k] <> #10) do dec(k);
    SetLength(LstNN,k);
  end;

  if (Msg >= 0) and (Msg < $3000) then
  begin
    k := Msg and $0c00;
    m := Msg and $03ff;
    case k of
      $400 :
      begin //----------------------------------------------------------------------- LEX2
        if (Obj > 0) and (Obj < 4096) then
        begin
          if(ObjZv[Obj].TypeObj=33) or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj=51)
          then s := MsgList[m] else s := GetSMsg(2,m,ObjZv[Obj].Liter,0);
        end else s := GetSMsg(2,m,'',0);
      end;

      $800 :
      begin //----------------------------------------------------------------------- LEX3
        if (Obj > 0) and (Obj < 4096) then
        begin
          if (ObjZv[Obj].TypeObj = 33) or (ObjZv[Obj].TypeObj = 36)
          then s := MsgList[m] else s := GetSMsg(3,m,ObjZv[Obj].Liter,0);
        end else s := GetSMsg(3,m,'',0);
      end;

      else //------------------------------------------------------------------------- LEX
      if (Obj > 0) and (Obj < 4096) then
      begin
        if (ObjZv[Obj].TypeObj=33) or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj=51)
        then s := MsgList[m]
        else
        if m = 581 then s := GetSMsg(1,m,LinkFr[Obj].Name,0)
        else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
      end else  s := GetSMsg(1,m,'',0);
    end;
  end else
  if Msg < $1000 then
  begin //------------------------------------------ LEX - сообщения о состоянии устройств
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZv[Obj].TypeObj=33) or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj=51)
      then s := MsgList[m] else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
    end  else s := GetSMsg(1,m,'',0);
  end else
  if (Msg >= $4000) and (Msg < $5000) then
  begin //----------------- LEX - диалог с оператором, меню, запросы, подтверждение команд
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZv[Obj].TypeObj=33)  or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj = 51)
      then s := MsgList[m] else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
    end else s := GetSMsg(1,m,'',0);
  end;

  if (Msg >= $5000) and (Msg < $6000) then
  begin //-------------- LEX - диалог с оператором, предупреждения при формировании команд
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if(ObjZv[Obj].TypeObj=33) or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj=51)
      then s := MsgList[m] else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
    end else s := GetSMsg(1,m,'',0);
  end;

  if s <> '' then
  begin
    if LastFixed < Offset then
    begin
      DateTimeToString(t,'dd-mm-yy hh:nn:ss', DTFrameOffset);  s := t + ' > '+ s;
      if (Msg < $3000) or (Msg >= $4000) then
      begin //------- предупреждения и сообщения о неисправностях устройств, меню, запросы
        LstNN := s + #13#10 + LstNN;
        if (Msg > $1000) and (Msg < $2000) then SndNewWar := true;
      end else //------------------------------------------- диагностические сообщения УВК
      begin ListDiagnoz := s + #13#10 + ListDiagnoz;  SndNewUvk := true;  end;
      NewNeisprav := true; //--- Зафиксирована новая неисправность, предупреждение, запрос
    end;
  end;
end;
{$ENDIF}

//========================================================================================
//-------------------------- Формирует короткое сообщение и готовит цвет для нижней строки
procedure ShowSMsg(index, x, y : integer; arg : string);
var
  i,j : integer;
  c : TColor;
begin
  if (index < 1) or (index > High(Lex))
  then begin s := 'Ошибка индекса короткого сообщения.';  c := ACVT1; end  else
  begin
    s := Lex[index].msg; t := '';
    for i:= 1 to Length(s) do begin if s[i]='$' then t:= t + arg else t:= t + s[i]; end;
    c := Lex[index].Color;
  end;
  SetLockHint;
  j := x div configRU[config.ru].MonSize.X + 1; //---------------------- Найти номер табло
  for i := 1 to 4 do begin  if i = j  then sMsg[i] := t  else sMsg[i] := ''; end;
  if (c = ACVT1) or (c = ACVT4) then SBeep[1]:= true;
  sMsgCvet[1] := c;
end;

//========================================================================================
//--------------------------------- возвращает строку сообщения из списков Lex, Lex2, Lex3
function GetSMsg(nlex, index : integer; arg : string; Cvt : Integer) : string;
//--------------------------------------------------------- nlex - индекс файла сообощений
//----------------------------------------------------------- index - номер строки в файле
//------------------ arg - текстовый литерал, добавляемый к сообщению (обычно имя объекта)
//--------------- Cvt - назначаемый цвет для первого цвета из массива  sMsgCvet[1..4]
var
  i,cvet : integer;
begin
  cvet := 0;
  result := '';
  case nlex of //---------------------------------------------------- чтение из списка LEX
    1 :
    if (index < 1) or (index > High(Lex)) then s := 'Ошибочный № сообщения.'  else
    begin s:= Lex[index].msg; cvet:= Lex[index].Color; result:= '';  end;

    2 :  //--------------------------------------------------------- чтение из списка LEX2
    if (index < 1) or (index > Length(Lex2))then s:= 'Ошибочный № сообщения.' else
    begin s:= Lex2[index].msg;  cvet:= Lex[index].Color;  result:= ''; end;

    3 :  //--------------------------------------------------------- чтение из списка LEX3
    if (index < 1) or (index > Length(Lex3)) then s := 'Ошибочный № сообщения.'  else
    begin  s := Lex3[index].msg;  cvet := Lex[index].Color;   result := ''; end;
  end;

  for i:= 1 to Length(s) do if s[i]='$' then result:=result+arg else result:=result+s[i];


  if not WorkMode.Upravlenie and (index <> 76)then cvt := 0 else
  begin
    if (cvet = ACVT1) or (cvet = ACVT4) then SBeep[1]:= true;
    if cvt = 1 then cvt := ACVT1 else
    if cvt = 2 then cvt := ACVT2 else
    if cvt = 7 then cvt := ACVT7;
    if cvt<> 0 then sMsgCvet[1] := cvt;
  end;
end;

//----------------------------------------------------------------------------------------
//------------------------------------------------------- подготовить сообщение для экрана
procedure PutSMsg(clr, x, y : integer; Msg : string);
{$IFDEF RMDSP}  var i,j : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  j := x div configRU[config.ru].MonSize.X + 1; //--------------------- Найти номер экрана
  SetLockHint;
  for i := 1 to 4 do
  begin
    if i = j then  //------------------------------------- если найден экран для сообщения
    begin
      sMsg[i]:= Msg;
      if not WorkMode.Upravlenie then sMsgCvet[i] := 0 else sMsgCvet[i] := GetColor1(clr);
    end else sMsg[i] := ''; //------------------------ для прочих экранов сообщения убрать
  end;
{$ENDIF}
end;
//========================================================================================
//----------------------------------------------------- сохранить строку в файле протокола
procedure RepF(Rep : string);
var
  hfile,hnbw: cardinal;
  fp: longword;
begin
  repl := rep + #13#10;
  hfile := CreateFile(PChar(RepFileName),
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
end;
//========================================================================================
//----------------------------------------------------- Сбросить короткие сообщения РМ-ДСП
procedure RSTMsg;
var i : integer;
begin
  ShowWarning := false; for i := 1 to High(SMsg) do sMsg[i] := '';
end;

//========================================================================================
//------- Добавить строку к фиксируемым сообщениям, выводимым в правом верхнем углу экрана
procedure AddFixMes(msg1: string; color1: SmallInt; alarm: SmallInt);
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
  {$IFDEF RMDSP}
  DateTimeToString(s,'hh:mm:ss',LastTime);
  with FixMessage do
  begin
    if Count > 0 then
    for i:= High(Msg) downto 2 do begin Msg[i]:= Msg[i-1]; Color[i]:= Color[i-1]; end;
    Msg[1] := s + ' > ' + msg1;  Color[1] := GetColor1(color1);
    ActLine := 1;  StartLine := 1;
    if Count < High(Msg) then inc(Count);
    if alarm = 3 then Zvuk := true else  SBeep[alarm]  := true;
  end
  {$ENDIF}
end;

//========================================================================================
//------------------------------------------------- Сбросить строку фиксируемого сообщения
procedure ResetFixMessage;
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  if (FixMessage.Count > 0) and (FixMessage.ActLine > 0) then
  begin
    if FixMessage.ActLine < FixMessage.Count then
    begin
      for i := FixMessage.ActLine + 1 to FixMessage.Count do
      begin
        FixMessage.Msg[i-1] := FixMessage.Msg[i];
        FixMessage.Color[i-1] := FixMessage.Color[i];
      end;
      dec(FixMessage.Count);
    end else
    begin
      dec(FixMessage.Count); dec(FixMessage.ActLine);
    end;
    if FixMessage.Count = 0 then
    begin
      FixMessage.ActLine := 1; FixMessage.StartLine := 1;
    end else
    begin
      if (FixMessage.ActLine > 4) and ((FixMessage.ActLine - FixMessage.StartLine) < 4)
      then FixMessage.StartLine := FixMessage.ActLine - 4;
      
      if FixMessage.ActLine < FixMessage.StartLine 
      then FixMessage.StartLine := FixMessage.ActLine;
    end;
  end;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- процедура сброса команд
procedure ResetCommands;
begin
{$IFDEF RMDSP}
  DspMenu.Ready := false; //--------------------------------------- сброс ожидания команды
  DspMenu.WC := false;  //--------------------------- сброс ожидания подтверждения команды
  DspCom.Active := false; //--------------------------------- сброс активности команды
  DspMenu.obj := -1; //----------------------------------------- сброс объекта для команды
  ResetTrace; //---------------------------------------------- Сбросить набираемый маршрут
  WorkMode.GoMaketSt := false; //---------------------------------- установки на макет нет
  WorkMode.GoOtvKom := false; //--------------------------- ввода ответственных команд нет
  Workmode.MarhOtm := false; //--------------------------------------- отмены маршрута нет
  Workmode.VspStr := false; //---------------------- вспомогательного перевода стрелки нет
  Workmode.InpOgr := false; //-------------------------------------- ввода ограничений нет
  if OtvCommand.Active then //---- если на момент сбоса была активна ответственная команда
  begin
    InsNewArmCmd(0,0);
    OtvCommand.Active := false;
    InsNewMsg(0,156,1,'');  //----------------------- "ввод ответственной команды прерван"
    ShowSMsg(156,LastX,LastY,'');
  end else
  if VspPerevod.Active then //--------- если активизирован вспомогательный перевод стрелки
  begin
    InsNewArmCmd(0,0);
    VspPerevod.Cmd := 0;
    VspPerevod.Strelka := 0;
    VspPerevod.Reper := 0;
    VspPerevod.Active := false;
    InsNewMsg(0,149,1,''); //------------------------- "Отменено ожидание нажатия кнопки ВСП"
    ShowSMsg(149,LastX,LastY,'');
  end else RSTMsg; //------------------------------------- Сбросить все короткие сообщения
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------------------- простой Beep
procedure SimpleBeep;
begin
  Beep;
end;

//========================================================================================
//---------------- Получить наименование объекта зависимостей по его индексу в базе данных
function GetNameObj(Index : SmallInt) : string;
begin
  if Index = 0 then result := 'УВК' else
  case ObjZv[Index].TypeObj of
    1,2 : result := 'стр'+ ObjZv[Index].Liter;
    else  result := ObjZv[Index].Liter;
  end;
end;

{$IFNDEF RMARC}
//========================================================================================
//-------------------------------------------------- добавить команду или тип меню в архив
procedure InsNewArmCmd(Obj,Cmd : Word);
var
  bh,bl : Byte;
begin
  bh := obj div $100;  bl := obj - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);   //-------- номер объекта = ст.байт + мл.байт

  bh := Cmd div $100;  bl := Cmd - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);  //--------- номер команды = ст.байт + мл.байт
end;
{$ENDIF}

//========================================================================================
//-------------------------------- получить состояние запрашиваемого бита данных из обмена
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
var
  p,d : integer;
  NP : boolean;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7; //------------------------------------------ номер запрашиваемого бита
  p := param shr 3; //----------------------------------------- номер запрашиваемого байта
  if p > 4096 then exit;

  //-------------------------------------------- Проверить превышение времени жизни данных
{$IFNDEF  RMARC}
  if ready then ready := (LastTime - FR3s[p]) < MaxTimeOutRecave;
{$ENDIF}
  //--------------------------------------------- Проверить признак парафазности сообщения
  NP := (FR3[p] and $20) = $20;
  nep := nep or NP;
  //-------------------------------------------------------------------- Получить значение
  case d of
    1   :   result := (FR3[p] and   2) = 2;
    2   :   result := (FR3[p] and   4) = 4;
    3   :   result := (FR3[p] and   8) = 8;
    4   :   result := (FR3[p] and $10) = $10;
    5   :   result := (FR3[p] and $20) = $20;
    6   :   result := (FR3[p] and $40) = $40;
    7   :   result := (FR3[p] and $80) = $80;
    else    result := (FR3[p] and   1) = 1;
  end;
end;
//========================================================================================
//------------------------------------------------- Получить значение принятых ограничений
function GetFR4State(param:Word):Boolean;
var
  p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7;
  p := param shr 3;
  if p > 4096 then exit;

  //-------------------------------------------- Проверить превышение времени жизни данных
  if (FR4s[p] > 0 ) then
  begin
    case d of
      1 : result := (FR4[p] and 2) = 2;
      2 : result := (FR4[p] and 4) = 4;
      3 : result := (FR4[p] and 8) = 8;
      4 : result := (FR4[p] and $10) = $10;
      5 : result := (FR4[p] and $20) = $20;
      6 : result := (FR4[p] and $40) = $40;
      7 : result := (FR4[p] and $80) = $80;
      else result := (FR4[p] and 1) = 1;
    end;
  end else result := false;
end;
//========================================================================================
//---------------------------------------------------------- получить значение диагностики
function GetFR5(param : Word) : Byte;
begin
  result := FR5[param];  FR5[param] := 0; //---------------------------- очистить признаки
end;


//========================================================================================
//------------------------------------------------------------- получить цвет по его коду
function GetColor1(param : SmallInt) : TColor;
begin
  case param of
    0  : GetColor1 := clBlack;
    1  : GetColor1 := ACVT1; //------------------------------------- lt red     - светофор
    2  : GetColor1 := ACVT2; //------------------------------------- lt green   - светофор
    3  : GetColor1 := ACVT3; //--------------------------------------------------- lt blue
    4  : GetColor1 := ACVT4; //------------------------------------------------------- red
    5  : GetColor1 := ACVT5; //----------------------------------------------------- green
    6  : GetColor1 := ACVT6; //------------------------ blue - подсветка положения стрелок
    7  : GetColor1 := ACVT7; //---------------------------------------------------- yellow
    8  : GetColor1 := ACVT8; //------------------------------------------------------ gray
    9  : GetColor1 := ACVT9; //------ white - маневровый сигнал, предварительное замыкание
    10 : GetColor1 := ACVT10; //----------------------------------------- magenta    - МСП
    11 : GetColor1 := ACVT11; //------------------------------- dk magenta - неисправность
    12 : GetColor1 := ACVT12; //------------ dk cyan    - цвет нецентрализованных объектов
    13 : GetColor1 := ACVT13; //-------------------------- brown      - местное управление
    14 : GetColor1 := ACVT14; //------------------------------ cyan       - непарафазность
    15 : GetColor1 := ACVT15; //----------------------------------------- background - фон
    16 : GetColor1 := ACVT16; //------------------------ солнечная сторона - контур кнопки
    17 : GetColor1 := ACVT17; //-------------------------- теневая сторона - контур кнопки
    18 : GetColor1 := ACVT18; //----------------------------------------------- фон кнопки
    19 : GetColor1 := ACVT19; //----------------------------------------- подсветка кнопки
    20 : GetColor1 := ACVT20; //-------------------------------------- приглушенный объект
    25 : GetColor1 := ACVT25; //-------------------------------- синее мигание (индикатор)
    26 : GetColor1 := ACVT26; //-------------------------------- белое мигание (индикатор)
    27 : GetColor1 := ACVT27; //------------------------------- желтое мигание (индикатор)
    28 : GetColor1 := ACVT28; //------------------------------ красное мигание (индикатор)
    29 : GetColor1 := ACVT29; //------------------------------ зеленое мигание (индикатор)
    30 : GetColor1 := ACVT30; //--------------------- восклицательный желтый мигающий знак
    else  GetColor1 := 0; // black
  end;
end;
//========================================================================================
//-------------------------- прочитать параметр Bool и вернуть индекс следующего параметра
function getbool(var index: integer; const s: string; var p: boolean): boolean;
var ps : string;
begin
  ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      p := (ps = 't');
      getbool := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
  end;
  p := false;
  getbool := true;
end;
//========================================================================================
//----------------------- прочитать параметр Integer и вернуть индекс следующего параметра
function getcrc32(var index: integer; const s: string; var p: integer): boolean;
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin p:= StrToIntDef('$'+ps,0); result:= (index > Length(s)); inc(index); exit; end
    else  begin ps := ps + s[index]; inc(index); end;
  end;
  result := true;
end;
//========================================================================================
//--------------------- прочитать строковый параметр и вернуть индекс следующего параметра
function getstring(var index: integer; const s: string; var p: string): boolean;
begin
  p := '';
  while index <= Length(s) do
  begin
    if s[index] = ';' then begin getstring := not (index>Length(s)); inc(index); exit; end
    else begin p := p + s[index]; inc(index); end;
  end;
  getstring := false;
end;
//========================================================================================
//--------------------- прочитать строковый параметр и вернуть индекс следующего параметра
function getword(var index: integer; const s: string; var p: Word): boolean;
var
  ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getword := (index > Length(s));   inc(index);  exit;
    end
    else begin ps := ps + s[index]; inc(index); end;
  end;
  getword := true;
end;
//========================================================================================
//--------------------- прочитать строковый параметр и вернуть индекс следующего параметра
function getbyte(var index: integer; const s: string; var p: Byte): boolean;
var ps : string;
begin
  p := 0;
  ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getbyte := (index > Length(s)); inc(index);  exit;
    end
    else begin ps := ps + s[index];  inc(index);  end;
  end;
  getbyte := true;
end;
//========================================================================================
//--------------------------------------------- найти символ и вернуть его индекс в строке
function findchar(var index: integer; const s: string; const c: char): boolean;
begin
  while index <= Length(s) do
  if s[index] = c then begin findchar := true; exit; end else inc(index);
  findchar := false;
end;
//========================================================================================
//----------------------- прочитать параметр Integer и вернуть индекс следующего параметра
function getinteger(var index: integer; const s: string; var p: integer): boolean;
//- index - позиция считывания параметра, по окончании работы функции - позиция следующего
//------------------------------- s - текстовая строка, в которой записан искомый параметр
//---------------------------------------- p - значение параметра, цель выполнения функции
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getinteger := (index > Length(s));  inc(index);   exit;
    end
    else  begin  ps := ps + s[index];  inc(index); end;
  end;
  getinteger := true;
end;
//========================================================================================
//------------ прочитать параметр SmallInt и вернуть позицию следующего параметра в строке
function getsmallint(var index: integer; const s: string; var p: smallInt): boolean;
//- index - позиция считывания параметра, по окончании работы функции - позиция следующего
//------------------------------- s - текстовая строка, в которой записан искомый параметр
//---------------------------------------- p - значение параметра, цель выполнения функции
var
  ps : string;
begin
  p := 0;
  ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getsmallint := (index > Length(s));  inc(index);  exit;
    end
    else  begin  ps := ps + s[index];  inc(index); end;
  end;
  getsmallint := true;
end;
//========================================================================================
//---- пропустить последовательность символов и вернуть индекс следующего символа в строке
function skipchar(var index: integer; const s: string; const c: char): boolean;
begin
  while index <= Length(s) do
    if s[index] = c then inc(index)
    else begin skipchar := true; exit; end;
  skipchar := false;
end;
//========================================================================================
//--------------------- прочитать строковый параметр и вернуть индекс следующего параметра
function getcrc16(var index: integer; const s: string; var p: Word): boolean;
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      p := StrToIntDef('$'+ps,0);
      getcrc16 := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
  end;
  getcrc16 := true;
end;
//========================================================================================
//--------------------- прочитать строковый параметр и вернуть индекс следующего параметра
function getcrc8(var index: integer; const s: string; var p: Byte): boolean;
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      p := StrToIntDef('$'+ps,0);
      getcrc8 := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
  end;
  getcrc8 := true;
end;

end.
