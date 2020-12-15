library MyDLL1;
{������ ��������� ������������ ���������� ������� � DLL:
 ShareMem ������ ���� ������ ������� � ������� USES ����� ���������� � ������ �������
 (��������� Project-View Source) USES ������,���� ��� DLL ������������ ��������� ���������
 ��� �������, � ������� ������ ���������� ��� ��������� ��� ���������� �������.
 ��� ��������� �� ���� ������� � �������� ������� ������ DLL-- ���� ����� ��� ��������� �
 ������� ��� �������.
 ShareMem - ��� ������������ ������ ��� ��������� ����� ������ � BORLNDMM.DLL,
 ������� ������ ���� ������ � ��� DLL. ����� �������� ������������� BORLNDMM.DLL,
 ����������� ��������� ���������� �������� ��������� PChar ��� ShortString. }

uses
  ShareMem,
  SysUtils,
  Graphics,
  Classes;

{$R *.res}

// ����������� ������ ��� ��-���
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

  armcolor25 =   0 * 65536 + 16 * 256 + 128;//-------- ���� ��� ������ �������� = 0x001080
  armcolor26 =   0 * 65536 + 32 * 256 + 128;//-------- ���� ��� ������ �������� = 0x002080
  armcolor27 =   0 * 65536 + 48 * 256 + 128;//------- ���� ��� ������� �������� = 0x003080
  armcolor28 =   0 * 65536 + 64 * 256 + 128;//------ ���� ��� �������� �������� = 0x004080
  armcolor29 =   0 * 65536 + 80 * 256 + 128;//------ ���� ��� �������� �������� = 0x005080
  armcolor30 = 240 * 65536 + 96 * 256 + 128; //-- ���� ����������������(������) = 0x006080

  bkgndcolor  = armcolor15; // ��� �����
  focuscolor  = armcolor19; // ��� ���������� ������ � ������ ���������
  snsidecolor = armcolor16; // ���������� �������
  dksidecolor = armcolor17; // ������� �������
  bkkeycolor  = armcolor18; // ��� ������

//========================================================================================
//------------------------------------------------------------- �������� ���� �� ��� ����
function GetColor1(param : SmallInt) : TColor;
begin
  case param of
    1  : GetColor1 := armcolor1; //--------------------------------- lt red     - ��������
    2  : GetColor1 := armcolor2; //--------------------------------- lt green   - ��������
    3  : GetColor1 := armcolor3; //----------------------------------------------- lt blue
    4  : GetColor1 := armcolor4; //--------------------------------------------------- red
    5  : GetColor1 := armcolor5; //------------------------------------------------- green
    6  : GetColor1 := armcolor6; //-------------------- blue - ��������� ��������� �������
    7  : GetColor1 := armcolor7; //------------------------------------------------ yellow
    8  : GetColor1 := armcolor8; //-------------------------------------------------- gray
    9  : GetColor1 := armcolor9; //-- white - ���������� ������, ��������������� ���������
    10 : GetColor1 := armcolor10; //------------------------------------- magenta    - ���
    11 : GetColor1 := armcolor11; //--------------------------- dk magenta - �������������
    12 : GetColor1 := armcolor12; //-------- dk cyan    - ���� ������������������ ��������
    13 : GetColor1 := armcolor13; //---------------------- brown      - ������� ����������
    14 : GetColor1 := armcolor14; //-------------------------- cyan       - ��������������
    15 : GetColor1 := armcolor15; //------------------------------------- background - ���
    16 : GetColor1 := armcolor16; //-------------------- ��������� ������� - ������ ������
    17 : GetColor1 := armcolor17; //---------------------- ������� ������� - ������ ������
    18 : GetColor1 := armcolor18; //------------------------------------------- ��� ������
    19 : GetColor1 := armcolor19; //------------------------------------- ��������� ������
    25 : GetColor1 := armcolor25; //---------------------------- ����� ������� (���������)
    26 : GetColor1 := armcolor26; //---------------------------- ����� ������� (���������)
    27 : GetColor1 := armcolor27; //--------------------------- ������ ������� (���������)
    28 : GetColor1 := armcolor28; //-------------------------- ������� ������� (���������)
    29 : GetColor1 := armcolor29; //-------------------------- ������� ������� (���������)
    30 : GetColor1 := armcolor30; //----------------- ��������������� ������ �������� ����
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
// ��������� �������� Integer � ������� ������ ���������� ���������
function getcrc32(var index: integer; const s: string; var p: integer): boolean;
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      p := StrToIntDef('$'+ps,0);
      result := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
  end;
  result := true;
end;
//========================================================================================
// ��������� ��������� �������� � ������� ������ ���������� ���������
function getstring(var index: integer; const s: string; var p: string): boolean;
begin
  p := '';
  while index <= Length(s) do
  begin
    if s[index] = ';' then
    begin
      getstring := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      p := p + s[index];
      inc(index);
    end;
  end;
  getstring := true;
end;
//========================================================================================
// ��������� ��������� �������� � ������� ������ ���������� ���������
function getword(var index: integer; const s: string; var p: Word): boolean;
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getword := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
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
      getbyte := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
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
var ps : string;
begin
  p := 0; ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getinteger := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
  end;
  getinteger := true;
end;
//========================================================================================
//---------------------- ��������� �������� SmallInt � ������� ������ ���������� ���������
function getsmallint(var index: integer; const s: string; var p: smallInt): boolean;
var ps : string;
begin
  p := 0;
  ps := '';
  while index <= Length(s) do
  begin
    if (s[index] = ';') or (s[index] = ':') or (s[index] = ',') then
    begin
      try p := StrToInt(ps) except p := 0 end;
      getsmallint := (index > Length(s));
      inc(index);
      exit;
    end else
    begin
      ps := ps + s[index];
      inc(index);
    end;
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


  exports
   getcrc8,
   getcrc16,
   skipchar,
   getsmallint,
   getinteger,
   findchar,
   getbyte,
   getword,
   getstring,
   getcrc32,
   getbool,
   GetColor1;
begin
end.
