unit ButtonOK;
{$INCLUDE d:\sapr_new\CfgProject}
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
//========================================================================================
//---------------------------------------------------------- Обработка КОК по схеме RS-232
function GetKOKStateKvit : byte;
begin
  result := 255;
end;

end.
