library MyDLL1;
{Важное замечание относительно управления памятью в DLL:
 ShareMem должен быть первым модулем в разделе USES вашей библиотеки и вашего проекта
 (выбираете Project-View Source) USES раздел,если ваш DLL экспортирует некоторые процедуры
 или функции, в которых строки фигурируют как параметры или результаты функций.
 Это относится ко всем входным и выходным строкам вашего DLL-- даже когда они размещены в
 записях или классах.
 ShareMem - это интерфейсный модуль для менеджера общей памяти в BORLNDMM.DLL,
 который должен быть вложен в ваш DLL. Чтобы избежать использования BORLNDMM.DLL,
 передавайте строковую информацию применяя параметры PChar или ShortString. }

uses
  ShareMem,
  SysUtils,
  Graphics,
  Classes;

{$R *.res}

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

  armcolor25 =   0 * 65536 + 16 * 256 + 128;//-------- цвет для синего мигнания = 0x001080
  armcolor26 =   0 * 65536 + 32 * 256 + 128;//-------- цвет для белого мигнания = 0x002080
  armcolor27 =   0 * 65536 + 48 * 256 + 128;//------- цвет для желтого мигнания = 0x003080
  armcolor28 =   0 * 65536 + 64 * 256 + 128;//------ цвет для красного мигнания = 0x004080
  armcolor29 =   0 * 65536 + 80 * 256 + 128;//------ цвет для зеленого мигнания = 0x005080
  armcolor30 = 240 * 65536 + 96 * 256 + 128; //-- цвет восклицательного(логика) = 0x006080

  bkgndcolor  = armcolor15; // фон табло
  focuscolor  = armcolor19; // фон выделенной строки в списке сообщений
  snsidecolor = armcolor16; // освещенная сторона
  dksidecolor = armcolor17; // теневая сторона
  bkkeycolor  = armcolor18; // фон кнопки

//========================================================================================
//------------------------------------------------------------- получить цвет по его коду
function GetColor1(param : SmallInt) : TColor;
begin
  case param of
    1  : GetColor1 := armcolor1; //--------------------------------- lt red     - светофор
    2  : GetColor1 := armcolor2; //--------------------------------- lt green   - светофор
    3  : GetColor1 := armcolor3; //----------------------------------------------- lt blue
    4  : GetColor1 := armcolor4; //--------------------------------------------------- red
    5  : GetColor1 := armcolor5; //------------------------------------------------- green
    6  : GetColor1 := armcolor6; //-------------------- blue - подсветка положения стрелок
    7  : GetColor1 := armcolor7; //------------------------------------------------ yellow
    8  : GetColor1 := armcolor8; //-------------------------------------------------- gray
    9  : GetColor1 := armcolor9; //-- white - маневровый сигнал, предварительное замыкание
    10 : GetColor1 := armcolor10; //------------------------------------- magenta    - МСП
    11 : GetColor1 := armcolor11; //--------------------------- dk magenta - неисправность
    12 : GetColor1 := armcolor12; //-------- dk cyan    - цвет нецентрализованных объектов
    13 : GetColor1 := armcolor13; //---------------------- brown      - местное управление
    14 : GetColor1 := armcolor14; //-------------------------- cyan       - непарафазность
    15 : GetColor1 := armcolor15; //------------------------------------- background - фон
    16 : GetColor1 := armcolor16; //-------------------- солнечная сторона - контур кнопки
    17 : GetColor1 := armcolor17; //---------------------- теневая сторона - контур кнопки
    18 : GetColor1 := armcolor18; //------------------------------------------- фон кнопки
    19 : GetColor1 := armcolor19; //------------------------------------- подсветка кнопки
    25 : GetColor1 := armcolor25; //---------------------------- синее мигание (индикатор)
    26 : GetColor1 := armcolor26; //---------------------------- белое мигание (индикатор)
    27 : GetColor1 := armcolor27; //--------------------------- желтое мигание (индикатор)
    28 : GetColor1 := armcolor28; //-------------------------- красное мигание (индикатор)
    29 : GetColor1 := armcolor29; //-------------------------- зеленое мигание (индикатор)
    30 : GetColor1 := armcolor30; //----------------- восклицательный желтый мигающий знак
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
// прочитать параметр Integer и вернуть индекс следующего параметра
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
// прочитать строковый параметр и вернуть индекс следующего параметра
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
// прочитать строковый параметр и вернуть индекс следующего параметра
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
//---------------------- прочитать параметр SmallInt и вернуть индекс следующего параметра
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
