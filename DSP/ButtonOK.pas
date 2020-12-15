unit ButtonOK;
//========================================================================================
//---------------------------------------- Процедуры обработки кнопки ответственных команд
interface
uses
  Windows, comport, SysUtils;
var
  ChOKTime      : Double;   //------------------------ время изменения состояния кнопки ОК

function GetKOKStateKvit : byte;

implementation

uses
  Commons, TypeALL;

var
  LastTr1       : string;
  LastTr2       : string;
  s1,s2         : string;
  CntPacketKOK  : word;
  UndefineState : Boolean;
  BadSxemaKOK   : Boolean;
  err           : boolean;
  lpModemStat   : Cardinal;
//========================================================================================
//---------------------------------------------------------- Обработка КОК по схеме RS-232
function GetKOKStateKvit : byte;
begin
  result := 255;
end;

end.
