unit ButtonOK;
//========================================================================================
//---------------------------------------- ��������� ��������� ������ ������������� ������
interface
uses
  Windows, comport, SysUtils;
var
  ChOKTime      : Double;   //------------------------ ����� ��������� ��������� ������ ��

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
//---------------------------------------------------------- ��������� ��� �� ����� RS-232
function GetKOKStateKvit : byte;
begin
  result := 255;
end;

end.
