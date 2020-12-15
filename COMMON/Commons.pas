unit Commons;
//========================================================================================
//-------------------------------------------------  ��������������� ��������� � ���������
{$INCLUDE d:\Sapr2012\CfgProject}
interface

uses
  Windows,
  Forms,
  SysUtils,
  Graphics;

{$IFDEF RMARC}
procedure ArcMsg(Obj : integer; Msg : SmallInt; Offset : Integer);
{$ENDIF}

procedure ReportF(Rep : string); //-------------------- ��������� ������ � ����� ���������
function GetColor(param : SmallInt) : TColor; external 'MyDLL1';
function IsTestMode : Boolean;
function GetShortMsg(nlex, index : integer; arg : string; cvt : integer) : string;
procedure ShowShortMsg(index, x, y : integer; arg : string);
//------------------------------------- PutShortMsg(clr-����; x, y-����������;  msg-�����)
procedure PutShortMsg(clr, x, y : integer; msg : string);
procedure ResetShortMsg;
procedure InsArcNewMsg(Obj : Integer; Msg,cvt : SmallInt);
procedure AddFixMessage(msg : string; color : SmallInt; alarm : SmallInt);
procedure ResetFixMessage;
procedure SetLockHint;
procedure SimpleBeep;
procedure UnLockHint;
procedure SetParamTablo; //----- ���������� ��������� ����� ��� �������� ������ ����������
function  GetNameObjZav(Index : SmallInt) : string;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function GetFR4State(param : Word) : Boolean;
function GetFR5(param : Word) : Byte;


{$IFNDEF RMARC}
procedure InsNewArmCmd(Obj,Cmd : Word); //------------------ �������� ������� ���� � �����
{$ENDIF}
//---------------------------------------------------------- ����������� ������ ��� ��-���
const
  //             blue         green      red
  armcolor1  =   0 * 65536 +   0 * 256 + 255;  //---------------------------- lt red = 255
  armcolor2  =   0 * 65536 + 255 * 256 +   0;  //------------------------ lt green = 65280
  armcolor3  = 255 * 65536 +   0 * 256 +   0;  //---------------------- lt blue = 16711680
  armcolor4  =   0 * 65536 +   0 * 256 + 191;  //------------------------------- red = 191
  armcolor5  =   0 * 65536 + 191 * 256 +   0;   //-------------------------- greey = 48896
  armcolor6  = 191 * 65536 +   0 * 256 +   0;   //------------------------ blue = 12517376
  armcolor7  =   0 * 65536 + 255 * 256 + 255; //--------------------------- ������ = 65535
  armcolor8  = 127 * 65536 + 127 * 256 + 127; //--------------------------- gray = 8355711
  armcolor9  = 255 * 65536 + 255 * 256 + 255; //------------------------------------ �����
  armcolor10 = 255 * 65536 +   0 * 256 + 127; //---------------------------------- magenta
  armcolor11 = 255 * 65536 +   0 * 256 + 255; //------------------------------- lt magenta
  armcolor12 =  95 * 65536 +  95 * 256 +  95; //---------------------- ������ (��� ������)
  armcolor13 =   1 * 65536 + 135 * 256 + 205; //------------------------------------ brown
  armcolor14 = 255 * 65536 + 255 * 256 +   0;  //--------------------- ���� (������������)
{$IFDEF RMARC}
  armcolor15 = 160 * 65536 + 196 * 256 + 196;//-------------------------------- ��� ������
{$ELSE}
 armcolor15 = 191 * 65536 + 191 * 256 + 191;  //-------------------------------------- ���
{$ENDIF}
  armcolor16 = 239 * 65536 + 239 * 256 + 239;
  armcolor17 =  63 * 65536 +  63 * 256 +  63;
  armcolor18 = 205 * 65536 + 205 * 256 + 205;
  armcolor19 = 209 * 65536 + 209 * 256 + 209;

  bkgndcolor  = armcolor15; //-------------------------------------------------- ��� �����
  focuscolor  = armcolor19; //------------------- ��� ���������� ������ � ������ ���������
  snsidecolor = armcolor16; //----------------------------------------- ���������� �������
  dksidecolor = armcolor17; //-------------------------------------------- ������� �������
  bkkeycolor  = armcolor18; //------------------------------------------------- ��� ������
var

t : string;
implementation
uses
{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMDSP}
  TabloForm,
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
  KanalArmSrv,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
{$ENDIF}

{$ENDIF}

 TypeALL;
//========================================================================================
//--------------------------------- ���������� ������ ����� ��� �������� ������ ����������
procedure SetParamTablo;
begin
{$IFDEF RMDSP}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].Tablo_Size.Y;
  TabloMain.Width  := configRU[config.ru].Tablo_Size.X;
  isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo1.Width   := configRU[config.ru].Tablo_Size.X;

  Tablo2.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo2.Width   := configRU[config.ru].Tablo_Size.X;
  if not StartRM
  then AddFixMessage(GetShortMsg(1,275,'����'+ IntToStr(config.ru),7),0,2);
{$ENDIF}

{$IFDEF RMARC}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].Tablo_Size.Y;
  TabloMain.Width  := configRU[config.ru].Tablo_Size.X;
  isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo1.Width   := configRU[config.ru].Tablo_Size.X;

  Tablo2.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo2.Width   := configRU[config.ru].Tablo_Size.X;
  if not StartRM
  then AddFixMessage(GetShortMsg(1,275,'����'+ IntToStr(config.ru),0),0,2);
{$ENDIF}

{$IFDEF RMSHN}
  //shiftscr := 0;
  isChengeRegion := true;
  TabloMain.Height := configRU[config.ru].Tablo_Size.Y;
  TabloMain.Width  := configRU[config.ru].Tablo_Size.X;
  //isChengeRegion := false;

  Tablo1.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo1.Width   := configRU[config.ru].Tablo_Size.X;

  Tablo2.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo2.Width   := configRU[config.ru].Tablo_Size.X;
  if not StartRM
  then AddFixMessage(GetShortMsg(1,275,'����'+ IntToStr(config.ru),0),0,2);
{$ENDIF}

{$IFDEF TABLO}
  TabloMain.Tablo.Height := configRU[config.ru].Tablo_Size.Y;
  TabloMain.Tablo.Width  := configRU[config.ru].Tablo_Size.X;
  Tablo1.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo1.Width   := configRU[config.ru].Tablo_Size.X;

  Tablo2.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo2.Width   := configRU[config.ru].Tablo_Size.X;
{$ENDIF}

{$IFDEF RMARC}
//  shiftxscr := 0; shiftyscr := 0;
  Tablo1.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo1.Width   := configRU[config.ru].Tablo_Size.X;

  Tablo2.Height  := configRU[config.ru].Tablo_Size.Y-15;
  Tablo2.Width   := configRU[config.ru].Tablo_Size.X;
{$ENDIF}
end;
//========================================================================================
// ���������� ������ �������� ������� �����
procedure SetLockHint;
begin
{$IFNDEF RMARC}   LockHint := true;   {$ENDIF} // ��� ������������ ������ ��� ������������
end;

//------------------------------------------------------------------------------
// ��������������� ������ �������� �������� �����
procedure UnLockHint;
begin
{$IFNDEF RMARC}
  LockHint := false; LastMove := Date+Time;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// �������� ������������ ������ ���� � �������� ������
function IsTestMode : Boolean;
begin
  IsTestMode := (asTestMode = $AA);
end;
//========================================================================================
//------------------------------------------------------- �������� � ����� ����� ���������
procedure InsArcNewMsg(Obj : integer ;Msg,Cvt : SmallInt);
{$IFNDEF RMARC}
{$IFNDEF TABLO}
var
  ss : string;
  bh, bl : Byte;
  k,m : Integer;
{$ENDIF}
{$ENDIF}
begin
  //------------------------------------------------------------ ��������� ����� ���������
  {$IFNDEF RMARC}
  {$IFNDEF TABLO}
  bh := Obj div $100;
  bl := Obj - (bh * $100);

  NewMsg := NewMsg + chr(bl) + chr(bh);

  bh := Msg div $100;
  bl := Msg - (bh * $100);
  NewMsg := NewMsg + chr(bl) + chr(bh);

  if Msg = $3001 then
  begin
    ss := '������������� ������������� �������� ���������� '+ IntToStr(Obj);
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss;
  end else
  if Msg = $3010 then
  begin
      ss := '������������� ������������� �������� ���������� '+  LinkFR[Obj].Name;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss;
  end else
  if Msg = $3002 then
  begin
    ss := '������������� �������������� �������� ���������� '+  IntToStr(Obj);
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss;
  end

  else
  //- ��������� ����������� ��� �� ����������� (��������� � ��������� ��������� ���������)
  if (Msg >= $3003) and (Msg <= $3007) then exit

  else  //-------------------- ��������� ��������� � ����� �������������� � ��������������
  if Msg >= 0 then
  begin
    k := Msg and $0c00;
    m := Msg and $03ff;
    case k of
      $400 :
      begin //------------------------------------------------------ ����� ������� �� LEX2
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36)
        then ss := MsgList[m]
        else ss := GetShortMsg(2,m,ObjZav[Obj].Liter,Cvt);
      end;

      $800 : begin //-------------------------------------------------------- ���� �� LEX3
        if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36) then ss := MsgList[m]
        else ss := GetShortMsg(3,m,ObjZav[Obj].Liter,Cvt);
      end;

    else //------------------------------------------------------------------------ �� LEX
        if (ObjZav[Obj].TypeObj = 33) or
        (ObjZav[Obj].TypeObj = 36) or
        (ObjZav[Obj].TypeObj = 51)
        then ss := MsgList[m]
        else ss := GetShortMsg(1,m,ObjZav[Obj].Liter,Cvt);
    end;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss;
  end;

  if ss <> '' then
  begin
    if (Msg < $3000) or (Msg >= $4000) then
    begin //------------------------ �������������� � ��������� � �������������� ���������
      ListMessages := ss + #13#10 + ListMessages;
      newListMessages := true;
      if Length(ListMessages) > 200000 then
      begin //----------------------------- �������� ����� ���� ������ ������� �����������
        k := 199000;
        SetLength(ListMessages,k);
        while (k > 0) and (ListMessages[k] <> #10) do dec(k);
        SetLength(ListMessages,k);
      end;
      if (Msg > $1000) and (Msg < $2000) then
      begin //-------------------------------- ��������� � ������ �������������� ���������
        LstNN := ss + #13#10 + LstNN;
        newListNeisprav := true;
        if Length(LstNN) > 200000 then
        begin //--------------------------- �������� ����� ���� ������ ������� �����������
          k := 199000;
          SetLength(LstNN,k);
          while (k > 0) and (LstNN[k] <> #10) do dec(k);
          SetLength(LstNN,k);
        end;
      end;
    end else
    begin //------------------------------------------------ ��������������� ��������� ���
      ListDiagnoz := ss + #13#10 + ListDiagnoz;
      newListDiagnoz := true;
      SingleBeep4 := true;
      if Length(ListDiagnoz) > 200000 then
      begin //----------------------------- �������� ����� ���� ������ ������� �����������
        k := 199000;
        SetLength(ListDiagnoz,k);
        while (k > 0) and (ListDiagnoz[k] <> #10) do dec(k);
        SetLength(ListDiagnoz,k);
      end;
    end;
    NewNeisprav := true; //------------- ������������� ����� �������������, ��������������
  {$IFDEF ARMSN}
    rifreshMsg := false; //-------------------------- ���������� �������� ������ ���������
  {$endif}
  end;
{$ENDIF}
{$ENDIF}
end;
//========================================================================================
{$IFDEF RMARC}
procedure ArcMsg(Obj : integer; Msg : SmallInt; Offset : Integer);
var
  k,m : Integer;
  s,t : string;
begin
  if Msg = 273 then
  begin
    WorkMode.Upravlenie := true;
    StateRU := StateRU or $80;
    DirState[1] := DirState[1] or $80;
  end;

  if Msg = 274 then
  begin
    WorkMode.Upravlenie := false;
    StateRU := StateRU and $7F;
    DirState[1] := DirState[1] and $7f;
  end;

  if Msg = $3001 then
  begin
    s := '������������� ������������� �������� ���������� '+ IntToStr(Obj);
  end else
   if Msg = $3010 then
  begin
    s := '������������� ������������� �������� ���������� '+ LinkFR[Obj].Name;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    s := t + ' > '+ s
  end else
  if Msg = $3002 then
  begin
    s := '������������� �������������� �������� ���������� '+ IntToStr(Obj);
  end else
  if (Msg >= $3003) and (Msg <= $3006) then
  // ��������� ����������� ��� �� ����������� (��������� � ��������� ��������� ���������)
  begin
    exit;
  end else
  if (Msg > $3006) and (Msg < $4000) then
  begin // LEX
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      s := GetShortMsg(1,m,ObjZav[Obj].Liter,0);
    end else
      s := GetShortMsg(1,m,'',0);
  end;

  //-------------------------- ��������� ��������� � ����� �������������� � ��������������
  if Length(LstNN) > 200000 then
  begin //--------------------------------- �������� ����� ���� ������ ������� �����������
    k := 199000;
    SetLength(LstNN,k);
    while (k > 0) and (LstNN[k] <> #10) do dec(k);
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
          if (ObjZav[Obj].TypeObj = 33) or
          (ObjZav[Obj].TypeObj = 36)  or
          (ObjZav[Obj].TypeObj = 51)
          then s := MsgList[m]
          else s := GetShortMsg(2,m,ObjZav[Obj].Liter,0);
        end
        else s := GetShortMsg(2,m,'',0);
      end;

      $800 :
      begin //----------------------------------------------------------------------- LEX3
        if (Obj > 0) and (Obj < 4096) then
        begin
          if (ObjZav[Obj].TypeObj = 33) or (ObjZav[Obj].TypeObj = 36)
          then s := MsgList[m]
          else s := GetShortMsg(3,m,ObjZav[Obj].Liter,0);
        end
        else s := GetShortMsg(3,m,'',0);
      end;

      else //------------------------------------------------------------------------- LEX
      if (Obj > 0) and (Obj < 4096) then
      begin
        if (ObjZav[Obj].TypeObj = 33) or
        (ObjZav[Obj].TypeObj = 36) or
        (ObjZav[Obj].TypeObj = 51)
        then s := MsgList[m]
        else s := GetShortMsg(1,m,ObjZav[Obj].Liter,0);
      end else
      s := GetShortMsg(1,m,'',0);
    end;
  end else
  if Msg < $1000 then
  begin //------------------------------------------ LEX - ��������� � ��������� ���������
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33) or
      (ObjZav[Obj].TypeObj = 36) or
      (ObjZav[Obj].TypeObj = 51)
      then s := MsgList[m]
      else s := GetShortMsg(1,m,ObjZav[Obj].Liter,0);
    end
    else s := GetShortMsg(1,m,'',0);
  end else
  if (Msg >= $4000) and (Msg < $5000) then
  begin //----------------- LEX - ������ � ����������, ����, �������, ������������� ������
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33)
      or (ObjZav[Obj].TypeObj = 36)
      or (ObjZav[Obj].TypeObj = 51)
      then s := MsgList[m]
      else s := GetShortMsg(1,m,ObjZav[Obj].Liter,0);
    end
    else s := GetShortMsg(1,m,'',0);
  end;

  if (Msg >= $5000) and (Msg < $6000) then
  begin //-------------- LEX - ������ � ����������, �������������� ��� ������������ ������
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZav[Obj].TypeObj = 33)
      or (ObjZav[Obj].TypeObj = 36)
      or (ObjZav[Obj].TypeObj = 51)
      then s := MsgList[m]
      else s := GetShortMsg(1,m,ObjZav[Obj].Liter,0);
    end
    else s := GetShortMsg(1,m,'',0);
  end;

  if s <> '' then
  begin
    if LastFixed < Offset then
    begin
      DateTimeToString(t,'dd-mm-yy hh:nn:ss', DTFrameOffset);
      s := t + ' > '+ s;
      if (Msg < $3000) or (Msg >= $4000) then
      begin //------- �������������� � ��������� � �������������� ���������, ����, �������
        LstNN := s + #13#10 + LstNN;
        if (Msg > $1000) and (Msg < $2000) then SndNewWar := true;
      end else
      begin //---------------------------------------------- ��������������� ��������� ���
        ListDiagnoz := s + #13#10 + ListDiagnoz;
        SndNewUvk := true;
      end;
      NewNeisprav := true; //--- ������������� ����� �������������, ��������������, ������
    end;
  end;
end;
{$ENDIF}

//{$IFDEF RMDSP}
//========================================================================================
//------------------------------------------------------------- ������� �������� ���������
procedure ShowShortMsg(index, x, y : integer; arg : string);
var
  i,j : integer;
  c : TColor;
{$IFNDEF RMDSP}  t : string;{$ENDIF}
begin
  if (index < 1) or (index > Length(Lex))
  then begin s := '��������� ������ ��������� ���������.';  c := armcolor1; end
  else
  begin
    s := Lex[index].msg; t := '';
    for i := 1 to Length(s) do
    begin
      if s[i] = '$' then t := t + arg
      else t := t + s[i];
    end;
    c := Lex[index].Color;
  end;
  SetLockHint;
  j := x div configRU[config.ru].MonSize.X + 1; //---------------------- ����� ����� �����
  for i := 1 to 4 do
  begin
    if i = j
    then shortMsg[i] := t
    else shortMsg[i] := '';
  end;
  if (c = armcolor1) or (c = armcolor4) then SingleBeep := true;
  //shortmsgcolor[1] := c;
end;
//{$ENDIF}
//========================================================================================
//----------------------------------- �������� ������ ��������� �� ������� Lex, Lex2, Lex3
function GetShortMsg(nlex, index : integer; arg : string; Cvt : Integer) : string;
var
  i,cvet : integer;
begin
  cvet := 0;
  case nlex of //---------------------------------------------------- ������ �� ������ LEX
    1 :
    begin
      if (index < 1) or (index > High(Lex))
      then s := '��������� � ���������.'
      else
      begin
        s := Lex[index].msg;
        cvet := Lex[index].Color;
        result := '';
        for i := 1 to Length(s) do
        if s[i] = '$'
        then result := result + arg
        else result := result + s[i];
      end;
    end;

    2 :  //--------------------------------------------------------- ������ �� ������ LEX2
    begin
      if (index < 1) or (index > Length(Lex2))then s := '��������� � ���������.'
      else
      begin
        s := Lex2[index].msg;
        cvet := Lex[index].Color;
        result := '';
        for i := 1 to Length(s) do
        begin
          if s[i] = '$'
          then result := result + arg
          else result := result + s[i];
        end;
      end;
    end;

    3 :  //--------------------------------------------------------- ������ �� ������ LEX3
    begin
      if (index < 1) or (index > Length(Lex3)) then s := '��������� � ���������.'
      else
      begin
        s := Lex3[index].msg;
        cvet := Lex[index].Color;
        result := '';
        for i := 1 to Length(s) do
        begin
          if s[i] = '$'
          then result := result + arg
          else result := result + s[i];
        end;
      end;
    end;
  end;
  if not WorkMode.Upravlenie and (index <> 76)then cvt := 0
  else
  begin
    if (cvet = armcolor1) or (cvet = armcolor4) then  SingleBeep := true;
    if cvt = 1 then cvt := ArmColor1;
    if cvt = 2 then cvt := ArmColor2;
    if cvt = 7 then cvt := ArmColor7;
    if cvt<> 0 then shortmsgcolor[1] := cvt;
  end;
end;

//------------------------------------------------------------------------------
// ������� ��������� �� �����
procedure PutShortMsg(clr, x, y : integer; Msg : string);
{$IFDEF RMDSP}  var i,j : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  j := x div configRU[config.ru].MonSize.X + 1; //---------------------- ����� ����� �����
  SetLockHint;
  for i := 1 to 4 do
  begin
    if i = j then
    begin
      shortMsg[i] := Msg;
      if not WorkMode.Upravlenie then shortMsgColor[i]  := 0
      else shortMsgColor[i] := GetColor(clr);
    end
    else shortMsg[i] := '';
  end;

{$ENDIF}
end;
//========================================================================================
//----------------------------------------------------- ��������� ������ � ����� ���������
procedure ReportF(Rep : string);
var
  hfile,hnbw: cardinal;
  fp: longword;
begin
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
end;

//{$IFDEF RMDSP}
//========================================================================================
//----------------------------------------------------- �������� �������� ��������� ��-���
procedure ResetShortMsg;
var i : integer;
begin
  ShowWarning := false;
  for i := 1 to Length(ShortMsg) do ShortMsg[i] := '';
end;
//{$ENDIF}
//========================================================================================
//----------------------------------------------- �������� ������ � ����������� ����������
procedure AddFixMessage(msg : string; color : SmallInt; alarm : SmallInt);
{$IFDEF RMDSP}  var i : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  //if WorkMode.Upravlenie then
  //begin //--------------------------------- ��������� ��������� ���� �������� ����������
    DateTimeToString(s,'hh:mm:ss',LastTime);
    if FixMessage.Count > 0 then
    begin
      for i := High(FixMessage.Msg) downto 2 do
      begin
        FixMessage.Msg[i] := FixMessage.Msg[i-1];
        FixMessage.Color[i] := FixMessage.Color[i-1];
      end;
    end;
    FixMessage.Msg[1] := s + ' > ' + msg;
    FixMessage.Color[1] := GetColor(color);
    FixMessage.MarkerLine := 1;
    FixMessage.StartLine := 1;
    if FixMessage.Count < High(FixMessage.Msg) then inc(FixMessage.Count);
    case alarm of
      1 : SingleBeep  := true;
      2 : SingleBeep2 := true;
      3 : sound := true;
      4 : SingleBeep4 := true;
      5 : SingleBeep5 := true;
      6 : SingleBeep6 := true;
    end;

  //end else
  //begin

  //end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// �������� ������ ������������ ���������
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
        FixMessage.Msg[i-1] := FixMessage.Msg[i]; 
        FixMessage.Color[i-1] := FixMessage.Color[i];
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
      if (FixMessage.MarkerLine > 4) and ((FixMessage.MarkerLine - FixMessage.StartLine) < 4) 
      then FixMessage.StartLine := FixMessage.MarkerLine - 4;
      
      if FixMessage.MarkerLine < FixMessage.StartLine 
      then FixMessage.StartLine := FixMessage.MarkerLine;
    end;
  end;
{$ENDIF}
end;
//========================================================================================
//--------------------------------------------------------------------------- ������� Beep
procedure SimpleBeep;
begin
  Beep;
end;
//------------------------------------------------------------------------------
// �������� ������������ ������� ������������ �� ��� ������� � ���� ������
function GetNameObjZav(Index : SmallInt) : string;
begin
  if Index = 0 then result := '���' else
  case ObjZav[Index].TypeObj of
    1,2 : begin
      result := '���'+ ObjZav[Index].Liter;
    end;
  else
    result := ObjZav[Index].Liter;
  end;
end;

{$IFNDEF RMARC}
//========================================================================================
//---------------------------------------------------------- �������� ������� ���� � �����
procedure InsNewArmCmd(Obj,Cmd : Word);
  var bh,bl : Byte;
begin
  bh := obj div $100;
  bl := obj - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);   //---------------------------- ����� �������
  bh := Cmd div $100;
  bl := Cmd - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);  //----------------------------- ����� �������
end;
{$ENDIF}

//========================================================================================
//-------------------------------- �������� ��������� �������������� ���� ������ �� ������
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
var
  p,d : integer;
  NP : boolean;
begin
  try
    result := false;
    if param < 8 then exit;
    d := param and 7; //---------------------------------------- ����� �������������� ����
    p := param shr 3; //--------------------------------------- ����� �������������� �����
    if p > 4096 then exit;

    //------------------------------------------ ��������� ���������� ������� ����� ������
{$IFNDEF  RMARC}
    if ready then ready := (LastTime - FR3s[p]) < MaxTimeOutRecave;
{$ENDIF}
    //------------------------------------------- ��������� ������� ������������ ���������
    NP := (FR3[p] and $20) = $20;
    nep := nep or NP;
    //------------------------------------------------------------------ �������� ��������
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
//========================================================================================
//------------------------------------------------- �������� �������� �������� �����������
function GetFR4State(param:Word):Boolean;
var
  p,d : integer;
begin
  try
    result := false;
    if param < 8 then exit;
    d := param and 7;
    p := param shr 3;
    if p > 4096 then exit;

    //------------------------------------------ ��������� ���������� ������� ����� ������
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
  except
    reportf('������ [KanalArmSrv.GetFR4State]'); Application.Terminate; result := false;
  end;
end;
//========================================================================================
//---------------------------------------------------------- �������� �������� �����������
function GetFR5(param : Word) : Byte;
begin
  try
    result := FR5[param];
    FR5[param] := 0; //------------------------------------------------- �������� ��������
  except
    reportf('������ [KanalArmSrv.GetFR5]');
    Application.Terminate;
    result := 0;
  end;
end;
end.
