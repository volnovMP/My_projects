unit ASUProc;
//   Процедуры обработки пакетов из сети АСУ
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

const
  ASU1_PACKET_IKONKI_LENGTH = 1000; // длина пакета для передачи 200 табличек

var
  IkonkiOut : array[0..1006] of char; // буфер массива табличек для передачи в канал АСУ
  IkonkiIn  : array[0..999] of char;  // буфер для массива табличек, полученых из канала АСУ
  Dat : array[1..1000] of byte;
  CountState : Integer;


function ExtractPacketASU(Buf : pchar; pLen : PInteger) : Boolean;   // распаковка пакетов АСУ
procedure IkonkiApply(cru,extype : byte); // применить массив табличек, полученный из канала АСУ
procedure IkonkiPack;                                   // упаковка массива информационных табличек


implementation

uses
  TypeAll,
  //VarStruct,
  crccalc,
  PipeProc;

//------------------------------------------------------------------------------
// распаковка пакетов АСУ
function ExtractPacketASU(Buf : pchar; pLen : PInteger) : Boolean;
  var i,j,k : integer; ptype,sru,etype, bh,bl : byte; ln : word; crc : crc16_t; 
begin
  result := false;
  if not Assigned(pLen) then exit;
  ln := word(pLen^);
  if ln = 0 then exit;

repeat

  i := 0;
  while i < ln do
  begin
    if Buf[i] = #$AA then
    begin
      if i > 0 then
      begin // урезать голову строки
        j := 0; k := i;
        while k < Ln do
        begin
          Buf[j] := Buf[k]; inc(k); inc(j);
        end;
        Ln := j;
      end;
      break;
    end else
      inc(i);
  end;
  if i > ln then
  begin // нет заголовка в полученом фрагменте
    pLen^ := 0; exit;
  end;
  if ln < 10 then begin pLen^ := ln; exit; end;
  i := 1; ptype := byte(Buf[i]); // тип пакета
  inc(i); etype := byte(Buf[i]); // вид обработки
  inc(i); sru := byte(Buf[i]); // код района
  case ptype of
    105 : begin // массив информационных табличек
      if ln < 1007 then exit; // неполный пакет
      if Buf[1006] = #$55 then
      begin
        crc := CalculateCRC16(@Buf[1],1003);
        bl := byte(Buf[1004]); bh := byte(Buf[1005]);
        if crc = (bl + bh *$100) then
        begin // получен пакет с массивом табличек
          for k := 0 to 999 do IkonkiIn[k] := Buf[k+4];
          IkonkiApply(sru,etype);
          // продолжить поиск в буфере
          j := 1; k := 1007; while k < Ln do begin Buf[j] := Buf[k];inc(k);inc(j); end; Ln := j-1;
        end else
        begin // контрольная сумма ошибочная - найти заголовок дальше по тексту
          j := 1; k := 2; while k < Ln do begin Buf[j] := Buf[k];inc(k);inc(j); end; Ln := j-1;
        end;
      end;
    end;
  else
  // неизвестный тип пакета - найти заголовок дальше по тексту
    j := 1; k := 2; while k <= Ln do begin Buf[j] := Buf[k];inc(k);inc(j); end; Ln := j-1;
  end;

until false;

end;

//------------------------------------------------------------------------------
// применить массив табличек, полученный из канала АСУ
procedure IkonkiApply(cru,extype : byte);
  var i,j : integer; bh,bl : byte;
begin
  if (extype < $10) and (extype < IkonPri) and (config.ru = cru) then
  begin // применить массив из канала ДСП-ДСП
    j := 0;
    for i := 1 to 200 do
    begin
      case cru of
        1 : begin
          Ikonki[i,1] := byte(IkonkiIn[j]); inc(j); bl := byte(IkonkiIn[j]); inc(j); bh := byte(IkonkiIn[j]); inc(j); Ikonki[i,2] := bl + bh * $100; bl := byte(IkonkiIn[j]); inc(j); bh := byte(IkonkiIn[j]); inc(j); Ikonki[i,3] := bl + bh * $100;
        end;
        2 : begin
          Ikonki2[i,1] := byte(IkonkiIn[j]); inc(j); bl := byte(IkonkiIn[j]); inc(j); bh := byte(IkonkiIn[j]); inc(j); Ikonki2[i,2] := bl + bh * $100; bl := byte(IkonkiIn[j]); inc(j); bh := byte(IkonkiIn[j]); inc(j); Ikonki2[i,3] := bl + bh * $100;
        end;
      else
        break;
      end;
    end;
  end;
end;


//------------------------------------------------------------------------------
// упаковка массива информационных табличек в формат канала АСУ
procedure IkonkiPack;
  var i,j : integer; bh,bl : Byte; w : Word; crc : crc16_t;
begin
  j := 0;
  IkonkiOut[j] := #$AA; inc(j);
  IkonkiOut[j] := #105; inc(j);
  IkonkiOut[j] := char(IkonPri); inc(j);
  IkonkiOut[j] := char(config.ru); inc(j);
  // сформировать массив табличек
  case config.ru of
    1 : begin
      for i := 1 to High(Ikonki) do
      begin
        IkonkiOut[j] := char(Ikonki[i,1]); inc(j);
        w := Ikonki[i,2]; bh := w shr 8; bl := w - bh * $100; IkonkiOut[j] := char(bl); inc(j); IkonkiOut[j] := char(bh); inc(j);
        w := Ikonki[i,3]; bh := w shr 8; bl := w - bh * $100; IkonkiOut[j] := char(bl); inc(j); IkonkiOut[j] := char(bh); inc(j);
      end;
    end;
    2 : begin
      for i := 1 to High(Ikonki2) do
      begin
        IkonkiOut[j] := char(Ikonki2[i,1]); inc(j);
        w := Ikonki2[i,2]; bh := w shr 8; bl := w - bh * $100; IkonkiOut[j] := char(bl); inc(j); IkonkiOut[j] := char(bh); inc(j);
        w := Ikonki2[i,3]; bh := w shr 8; bl := w - bh * $100; IkonkiOut[j] := char(bl); inc(j); IkonkiOut[j] := char(bh); inc(j);
      end;
    end;
  end;
  crc := CalculateCRC16(@IkonkiOut[1],1003); // подсчитать контрольную сумму
  bh := crc shr 8; bl := crc - bh * $100; IkonkiOut[j] := char(bl); inc(j); IkonkiOut[j] := char(bh); inc(j);
  IkonkiOut[j] := #$55;
end;

end.
