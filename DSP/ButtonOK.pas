unit ButtonOK;
{$INCLUDE d:\sapr_new\CfgProject}
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
//========================================================================================
//---------------------------------------------------------- ��������� ��� �� ����� RS-232
function GetKOKStateKvit : byte;
begin
  result := 255;
end;

end.
