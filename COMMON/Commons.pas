unit Commons;

//========================================================================================
//-------------------------------------------------  ��������������� ��������� � ���������
{$INCLUDE d:\Sapr2012\CfgProject}
interface

uses
  Windows,    Forms,  SysUtils,  Graphics;

{$IFDEF RMARC} procedure ArcMsg(Obj : integer; Msg : SmallInt; Offset : Integer); {$ENDIF}

procedure RepF(Rep : string); //-------------------- ��������� ������ � ����� ���������
procedure ResetCommands; //------------------------------------ ����� ���� �������� ������
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

//------------------------------------- PutSMsg(clr-����; x, y-����������;  msg-�����)
procedure ShowSMsg(index, x, y : integer; arg : string);
procedure PutSMsg (clr,   x, y : integer; msg : string);
procedure RSTMsg;
procedure InsNewMsg(Obj : Integer; Msg,cvt : SmallInt;datch:string);
procedure AddFixMes(msg1 : string; color1 : SmallInt; alarm : SmallInt);
procedure ResetFixMessage;
procedure SetLockHint;
procedure SimpleBeep;
procedure UnLockHint;
procedure SetParamTablo; //----- ���������� ��������� ����� ��� �������� ������ ����������
function GetNameObj(Index : SmallInt) : string;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function GetFR4State(param : Word) : Boolean;
function GetFR5(param : Word) : Byte;


{$IFNDEF RMARC} procedure InsNewArmCmd(Obj, Cmd : Word); {������� ���� � �����} {$ENDIF}
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
//--------------------------------- ���������� ������ ����� ��� �������� ������ ����������
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
  then AddFixMes(GetSMsg(1,275,'����'+ IntToStr(config.ru),7),0,2);
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
  then AddFixMes(GetSMsg(1,275,'����'+ IntToStr(config.ru),0),0,2);
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
  then AddFixMes(GetSMsg(1,275,'����'+ IntToStr(config.ru),0),0,2);
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
  LockHint := false; LastMove := Date + Time;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// �������� ������������ ������ ���� � �������� ������
function IsTestMode : Boolean;
begin
  IsTestMode := (asTestMode = $AA);
end;
//========================================================================================
//------------------------------------------------- �������� � ���� - ���� ����� ���������
procedure InsNewMsg(Obj: integer; Msg,Cvt: SmallInt; datch : String);
{$IFNDEF RMARC}{$IFNDEF TABLO}
var
  ss : string;
  bh, bl : Byte;
  k,m : Integer;
{$ENDIF}{$ENDIF}
begin
  //------------------------------------------------------------ ��������� ����� ���������
  {$IFNDEF RMARC} {$IFNDEF TABLO}
  bh:=Obj div $100; bl:=Obj-(bh*$100); NewMsg:=NewMsg+chr(bl)+chr(bh);
  bh:=Msg div $100; bl:=Msg-(bh*$100); NewMsg:=NewMsg+chr(bl)+chr(bh);

  if Msg=$3001 then
  begin
    ss := '������������� �������� ���������� '+ IntToStr(Obj); //------------------ ������
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end else
  if Msg = $3010 then
  begin
    ss := '������������� �������� ���������� '+  LinkFR[Obj].Name;//------------------ ���
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end else
  if Msg = $3002 then
  begin
    ss := '�������������� �������� ���������� '+  IntToStr(Obj);
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime); ss := t + ' > '+ ss;
  end
  else
  //- ��������� ����������� ��� �� ����������� (��������� � ��������� ��������� ���������)
  if (Msg >= $3003) and (Msg <= $3007) then exit
  else  //-------------------- ��������� ��������� � ����� �������������� � ��������������
  if Msg >= 0 then
  begin
    k := Msg and $0c00;  m := Msg and $03ff;
    with ObjZv[Obj] do
    case k of
      $400 :
      begin //------------------------------------------------------ ����� ������� �� LEX2
        if (TypeObj=33) or (TypeObj=36) then ss:=MsgList[m]
        else ss := GetSMsg(2,m,Liter,Cvt);
      end;

      $800 :
      begin //--------------------------------------------------------------- ���� �� LEX3
        if (TypeObj=33) or (TypeObj=36) then ss:=MsgList[m]
        else ss:=GetSMsg(3,m,Liter,Cvt);
      end;

      else //---------------------------------------------------------------- ����� �� LEX
        //---- ���������� ������, ������ � ����������, ������ � ���������, ������ ��������
        if(TypeObj=33) or (TypeObj=35) or (TypeObj=36) or (TypeObj=51) then ss:=MsgList[m]
        else ss := GetSMsg(1,m,Liter,Cvt);
    end;
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);
    ss := t + ' > '+ ss + ' ' + datch;
  end;

  if ss <> '' then
  begin
    if (Msg < $3000) or (Msg >= $4000) then
    begin //------------------------ �������������� � ��������� � �������������� ���������
      ListMessages := ss + #13#10 + ListMessages;  newListMessages := true;

      if Length(ListMessages) > 200000 then
      begin //----------------------------- �������� ����� ���� ������ ������� �����������
        k := 199000; SetLength(ListMessages,k);
        while (k > 0) and (ListMessages[k] <> #10) do dec(k);
        SetLength(ListMessages,k);
      end;

      if (Msg > $1000) and (Msg < $2000) then
      begin //-------------------------------- ��������� � ������ �������������� ���������
        LstNN := ss + #13#10 + LstNN;  newListNeisprav := true;
        if Length(LstNN) > 200000 then
        begin //--------------------------- �������� ����� ���� ������ ������� �����������
          k := 199000; SetLength(LstNN,k);
          while (k > 0) and (LstNN[k] <> #10) do dec(k);
          SetLength(LstNN,k);
        end;
      end;
    end else
    begin //------------------------------------------------ ��������������� ��������� ���
      ListDiagnoz := ss + #13#10 + ListDiagnoz; newListDiagnoz := true; SBeep[4] := true;
      if Length(ListDiagnoz) > 200000 then
      begin //----------------------------- �������� ����� ���� ������ ������� �����������
        k := 199000;  SetLength(ListDiagnoz,k);
        while (k > 0) and (ListDiagnoz[k] <> #10) do dec(k);
        SetLength(ListDiagnoz,k);
      end;
    end;
    NewNeisprav := true; //------------- ������������� ����� �������������, ��������������
  {$IFDEF ARMSN} rifreshMsg := false; {$endif} //---- ���������� �������� ������ ���������
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
  if Msg = 273 then //-------------------------- "����� ��������� � ����������� ���������"
  begin
    WorkMode.Upravlenie:= true; StateRU:= StateRU or $80; DirState[1]:=DirState[1] or $80;
  end;

  if Msg = 274 then     //------------------------------------- "����� ��������� � ������"
  begin
    WorkMode.Upravlenie:=false; StateRU:=StateRU and $7F;DirState[1]:=DirState[1] and $7f;
  end;

  if Msg=$3001 then s:='������������� �������� ���������� '+IntToStr(Obj) else// � �������
  if Msg = $3010 then
  begin
    s := '������������� �������� ���������� '+ LinkFR[Obj].Name; //-------------- ��� ����
    DateTimeToString(t,'dd-mm-yy hh:nn:ss', LastTime);  s := t + ' > '+ s //- ���� � �����
  end else
  if Msg = $3002 then s := '�������������� �������� ���������� '+ IntToStr(Obj) else //- �
  if (Msg >= $3003) and (Msg <= $3006) then exit else //����������� ��� ��������� �� �����
  if (Msg > $3006) and (Msg < $4000) then //------------ ���������� �� ����� ����� LEX.sdb
  begin
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then s := GetSMsg(1,m,ObjZv[Obj].Liter,0) //�������� ���
    else s := GetSMsg(1,m,'',0); //------------------------------------- ��� ����� �������
  end;

  //-------------------------- ��������� ��������� � ����� �������������� � ��������������
  if Length(LstNN) > 200000 then
  begin //-------------------------------- �������� �����, ���� ������ ������� �����������
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
  begin //------------------------------------------ LEX - ��������� � ��������� ���������
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZv[Obj].TypeObj=33) or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj=51)
      then s := MsgList[m] else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
    end  else s := GetSMsg(1,m,'',0);
  end else
  if (Msg >= $4000) and (Msg < $5000) then
  begin //----------------- LEX - ������ � ����������, ����, �������, ������������� ������
    m := Msg and $03ff;
    if (Obj > 0) and (Obj < 4096) then
    begin
      if (ObjZv[Obj].TypeObj=33)  or (ObjZv[Obj].TypeObj=36) or (ObjZv[Obj].TypeObj = 51)
      then s := MsgList[m] else s := GetSMsg(1,m,ObjZv[Obj].Liter,0);
    end else s := GetSMsg(1,m,'',0);
  end;

  if (Msg >= $5000) and (Msg < $6000) then
  begin //-------------- LEX - ������ � ����������, �������������� ��� ������������ ������
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
      begin //------- �������������� � ��������� � �������������� ���������, ����, �������
        LstNN := s + #13#10 + LstNN;
        if (Msg > $1000) and (Msg < $2000) then SndNewWar := true;
      end else //------------------------------------------- ��������������� ��������� ���
      begin ListDiagnoz := s + #13#10 + ListDiagnoz;  SndNewUvk := true;  end;
      NewNeisprav := true; //--- ������������� ����� �������������, ��������������, ������
    end;
  end;
end;
{$ENDIF}

//========================================================================================
//-------------------------- ��������� �������� ��������� � ������� ���� ��� ������ ������
procedure ShowSMsg(index, x, y : integer; arg : string);
var
  i,j : integer;
  c : TColor;
begin
  if (index < 1) or (index > High(Lex))
  then begin s := '������ ������� ��������� ���������.';  c := ACVT1; end  else
  begin
    s := Lex[index].msg; t := '';
    for i:= 1 to Length(s) do begin if s[i]='$' then t:= t + arg else t:= t + s[i]; end;
    c := Lex[index].Color;
  end;
  SetLockHint;
  j := x div configRU[config.ru].MonSize.X + 1; //---------------------- ����� ����� �����
  for i := 1 to 4 do begin  if i = j  then sMsg[i] := t  else sMsg[i] := ''; end;
  if (c = ACVT1) or (c = ACVT4) then SBeep[1]:= true;
  sMsgCvet[1] := c;
end;

//========================================================================================
//--------------------------------- ���������� ������ ��������� �� ������� Lex, Lex2, Lex3
function GetSMsg(nlex, index : integer; arg : string; Cvt : Integer) : string;
//--------------------------------------------------------- nlex - ������ ����� ����������
//----------------------------------------------------------- index - ����� ������ � �����
//------------------ arg - ��������� �������, ����������� � ��������� (������ ��� �������)
//--------------- Cvt - ����������� ���� ��� ������� ����� �� �������  sMsgCvet[1..4]
var
  i,cvet : integer;
begin
  cvet := 0;
  result := '';
  case nlex of //---------------------------------------------------- ������ �� ������ LEX
    1 :
    if (index < 1) or (index > High(Lex)) then s := '��������� � ���������.'  else
    begin s:= Lex[index].msg; cvet:= Lex[index].Color; result:= '';  end;

    2 :  //--------------------------------------------------------- ������ �� ������ LEX2
    if (index < 1) or (index > Length(Lex2))then s:= '��������� � ���������.' else
    begin s:= Lex2[index].msg;  cvet:= Lex[index].Color;  result:= ''; end;

    3 :  //--------------------------------------------------------- ������ �� ������ LEX3
    if (index < 1) or (index > Length(Lex3)) then s := '��������� � ���������.'  else
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
//------------------------------------------------------- ����������� ��������� ��� ������
procedure PutSMsg(clr, x, y : integer; Msg : string);
{$IFDEF RMDSP}  var i,j : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
  j := x div configRU[config.ru].MonSize.X + 1; //--------------------- ����� ����� ������
  SetLockHint;
  for i := 1 to 4 do
  begin
    if i = j then  //------------------------------------- ���� ������ ����� ��� ���������
    begin
      sMsg[i]:= Msg;
      if not WorkMode.Upravlenie then sMsgCvet[i] := 0 else sMsgCvet[i] := GetColor1(clr);
    end else sMsg[i] := ''; //------------------------ ��� ������ ������� ��������� ������
  end;
{$ENDIF}
end;
//========================================================================================
//----------------------------------------------------- ��������� ������ � ����� ���������
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
//----------------------------------------------------- �������� �������� ��������� ��-���
procedure RSTMsg;
var i : integer;
begin
  ShowWarning := false; for i := 1 to High(SMsg) do sMsg[i] := '';
end;

//========================================================================================
//------- �������� ������ � ����������� ����������, ��������� � ������ ������� ���� ������
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
//------------------------------------------------- �������� ������ ������������ ���������
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
//---------------------------------------------------------------- ��������� ������ ������
procedure ResetCommands;
begin
{$IFDEF RMDSP}
  DspMenu.Ready := false; //--------------------------------------- ����� �������� �������
  DspMenu.WC := false;  //--------------------------- ����� �������� ������������� �������
  DspCom.Active := false; //--------------------------------- ����� ���������� �������
  DspMenu.obj := -1; //----------------------------------------- ����� ������� ��� �������
  ResetTrace; //---------------------------------------------- �������� ���������� �������
  WorkMode.GoMaketSt := false; //---------------------------------- ��������� �� ����� ���
  WorkMode.GoOtvKom := false; //--------------------------- ����� ������������� ������ ���
  Workmode.MarhOtm := false; //--------------------------------------- ������ �������� ���
  Workmode.VspStr := false; //---------------------- ���������������� �������� ������� ���
  Workmode.InpOgr := false; //-------------------------------------- ����� ����������� ���
  if OtvCommand.Active then //---- ���� �� ������ ����� ���� ������� ������������� �������
  begin
    InsNewArmCmd(0,0);
    OtvCommand.Active := false;
    InsNewMsg(0,156,1,'');  //----------------------- "���� ������������� ������� �������"
    ShowSMsg(156,LastX,LastY,'');
  end else
  if VspPerevod.Active then //--------- ���� ������������� ��������������� ������� �������
  begin
    InsNewArmCmd(0,0);
    VspPerevod.Cmd := 0;
    VspPerevod.Strelka := 0;
    VspPerevod.Reper := 0;
    VspPerevod.Active := false;
    InsNewMsg(0,149,1,''); //------------------------- "�������� �������� ������� ������ ���"
    ShowSMsg(149,LastX,LastY,'');
  end else RSTMsg; //------------------------------------- �������� ��� �������� ���������
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------------------- ������� Beep
procedure SimpleBeep;
begin
  Beep;
end;

//========================================================================================
//---------------- �������� ������������ ������� ������������ �� ��� ������� � ���� ������
function GetNameObj(Index : SmallInt) : string;
begin
  if Index = 0 then result := '���' else
  case ObjZv[Index].TypeObj of
    1,2 : result := '���'+ ObjZv[Index].Liter;
    else  result := ObjZv[Index].Liter;
  end;
end;

{$IFNDEF RMARC}
//========================================================================================
//-------------------------------------------------- �������� ������� ��� ��� ���� � �����
procedure InsNewArmCmd(Obj,Cmd : Word);
var
  bh,bl : Byte;
begin
  bh := obj div $100;  bl := obj - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);   //-------- ����� ������� = ��.���� + ��.����

  bh := Cmd div $100;  bl := Cmd - (bh * $100);
  NewMenuC := NewMenuC + chr(bl) + chr(bh);  //--------- ����� ������� = ��.���� + ��.����
end;
{$ENDIF}

//========================================================================================
//-------------------------------- �������� ��������� �������������� ���� ������ �� ������
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
var
  p,d : integer;
  NP : boolean;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7; //------------------------------------------ ����� �������������� ����
  p := param shr 3; //----------------------------------------- ����� �������������� �����
  if p > 4096 then exit;

  //-------------------------------------------- ��������� ���������� ������� ����� ������
{$IFNDEF  RMARC}
  if ready then ready := (LastTime - FR3s[p]) < MaxTimeOutRecave;
{$ENDIF}
  //--------------------------------------------- ��������� ������� ������������ ���������
  NP := (FR3[p] and $20) = $20;
  nep := nep or NP;
  //-------------------------------------------------------------------- �������� ��������
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
//------------------------------------------------- �������� �������� �������� �����������
function GetFR4State(param:Word):Boolean;
var
  p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7;
  p := param shr 3;
  if p > 4096 then exit;

  //-------------------------------------------- ��������� ���������� ������� ����� ������
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
//---------------------------------------------------------- �������� �������� �����������
function GetFR5(param : Word) : Byte;
begin
  result := FR5[param];  FR5[param] := 0; //---------------------------- �������� ��������
end;


//========================================================================================
//------------------------------------------------------------- �������� ���� �� ��� ����
function GetColor1(param : SmallInt) : TColor;
begin
  case param of
    0  : GetColor1 := clBlack;
    1  : GetColor1 := ACVT1; //------------------------------------- lt red     - ��������
    2  : GetColor1 := ACVT2; //------------------------------------- lt green   - ��������
    3  : GetColor1 := ACVT3; //--------------------------------------------------- lt blue
    4  : GetColor1 := ACVT4; //------------------------------------------------------- red
    5  : GetColor1 := ACVT5; //----------------------------------------------------- green
    6  : GetColor1 := ACVT6; //------------------------ blue - ��������� ��������� �������
    7  : GetColor1 := ACVT7; //---------------------------------------------------- yellow
    8  : GetColor1 := ACVT8; //------------------------------------------------------ gray
    9  : GetColor1 := ACVT9; //------ white - ���������� ������, ��������������� ���������
    10 : GetColor1 := ACVT10; //----------------------------------------- magenta    - ���
    11 : GetColor1 := ACVT11; //------------------------------- dk magenta - �������������
    12 : GetColor1 := ACVT12; //------------ dk cyan    - ���� ������������������ ��������
    13 : GetColor1 := ACVT13; //-------------------------- brown      - ������� ����������
    14 : GetColor1 := ACVT14; //------------------------------ cyan       - ��������������
    15 : GetColor1 := ACVT15; //----------------------------------------- background - ���
    16 : GetColor1 := ACVT16; //------------------------ ��������� ������� - ������ ������
    17 : GetColor1 := ACVT17; //-------------------------- ������� ������� - ������ ������
    18 : GetColor1 := ACVT18; //----------------------------------------------- ��� ������
    19 : GetColor1 := ACVT19; //----------------------------------------- ��������� ������
    20 : GetColor1 := ACVT20; //-------------------------------------- ������������ ������
    25 : GetColor1 := ACVT25; //-------------------------------- ����� ������� (���������)
    26 : GetColor1 := ACVT26; //-------------------------------- ����� ������� (���������)
    27 : GetColor1 := ACVT27; //------------------------------- ������ ������� (���������)
    28 : GetColor1 := ACVT28; //------------------------------ ������� ������� (���������)
    29 : GetColor1 := ACVT29; //------------------------------ ������� ������� (���������)
    30 : GetColor1 := ACVT30; //--------------------- ��������������� ������ �������� ����
    else  GetColor1 := 0; // black
  end;
end;
//========================================================================================
//-------------------------- ��������� �������� Bool � ������� ������ ���������� ���������
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
//----------------------- ��������� �������� Integer � ������� ������ ���������� ���������
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
//--------------------- ��������� ��������� �������� � ������� ������ ���������� ���������
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
//--------------------- ��������� ��������� �������� � ������� ������ ���������� ���������
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
//--------------------- ��������� ��������� �������� � ������� ������ ���������� ���������
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
//--------------------------------------------- ����� ������ � ������� ��� ������ � ������
function findchar(var index: integer; const s: string; const c: char): boolean;
begin
  while index <= Length(s) do
  if s[index] = c then begin findchar := true; exit; end else inc(index);
  findchar := false;
end;
//========================================================================================
//----------------------- ��������� �������� Integer � ������� ������ ���������� ���������
function getinteger(var index: integer; const s: string; var p: integer): boolean;
//- index - ������� ���������� ���������, �� ��������� ������ ������� - ������� ����������
//------------------------------- s - ��������� ������, � ������� ������� ������� ��������
//---------------------------------------- p - �������� ���������, ���� ���������� �������
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
//------------ ��������� �������� SmallInt � ������� ������� ���������� ��������� � ������
function getsmallint(var index: integer; const s: string; var p: smallInt): boolean;
//- index - ������� ���������� ���������, �� ��������� ������ ������� - ������� ����������
//------------------------------- s - ��������� ������, � ������� ������� ������� ��������
//---------------------------------------- p - �������� ���������, ���� ���������� �������
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
//---- ���������� ������������������ �������� � ������� ������ ���������� ������� � ������
function skipchar(var index: integer; const s: string; const c: char): boolean;
begin
  while index <= Length(s) do
    if s[index] = c then inc(index)
    else begin skipchar := true; exit; end;
  skipchar := false;
end;
//========================================================================================
//--------------------- ��������� ��������� �������� � ������� ������ ���������� ���������
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
//--------------------- ��������� ��������� �������� � ������� ������ ���������� ���������
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
