unit ObjectsMng;
{$INCLUDE d:\sapr2012\CfgProject}
{***************************************************
//  ��������� � ��������� �������������� ����
***************************************************}

interface

uses
  Forms,
  Windows,
  Classes,
  Dialogs,
  Graphics,
  SysUtils,
  TypeALL;

// ��������� ����� �������
type
  TParamPlan = record
    SV        : integer; //-------------------------------- ��� ������������ �������� ����
    SH        : integer; //------------------------------ ��� �������������� �������� ����
    OZ        : TPoint;  //------------- ���������� ����� ����������� ������ ����� �������
    LineUp    : integer; //---------------------------- ���������� ����� ���� ������ �����
    LineDown  : integer; //---------------------------- ���������� ����� ���� ������ �����
    LineLeft  : integer; //--------------------------- ���������� ����� ����� ������ �����
    LineRight : integer; //-------------------------- ���������� ����� ������ ������ �����
    OddSide   : BYTE;    //������� ��������� �� ��������:0- ����� �� ���, 1- ������ �� ���
    DC        : BYTE;    //------------------ ������� ������� �� ������� �� (1-����/0-���)
    SU        : BYTE;    // ������� ������� �� ������� ��������� ���������� (1-����/0-���)
    VwObj     : boolean; //------------------- ���������� ������� ������������ � ���������
    VwCon     : boolean; //------------------- ���������� ���������� �������� ������������
    VwLinks   : boolean; //---------------- ���������� ������ ����� ��������� ������������
  end;

const
  BlockH = 30; //--------------------------------------------------- �������� ������ �����
  BlockW = 20; //--------------------------------------------------- �������� ������ �����

var
//========================================================================================
//               ��������� ��������� ���-��� � ������� ����
//========================================================================================
pplan      : TParamPlan;//---------------------------------------- ��������� ����� �������
selectIDO  : WORD;      //----------------------------- ��������� ��� �������� ��� �������
//selectObj  : WORD;    //------------------------------------- ���� ������������ � ������
isMoveObj  : BOOLEAN;   //------------------------------------ ������� ����������� �������
isExchObj  : Boolean;   //-------------- ������� ����������� ������� "������ ���� �������"
selectPin  : WORD;      //------------------------------------- ����� ����������� � ������
selectCon  : WORD;      //------------------------------------------- ����������� � ������
isfirstPin : BOOLEAN;   //------------------------ ���� ������ ����� ���������� ����������
ismoveCon  : BOOLEAN;   //-------------------------------- ������� ����������� �����������
CurPos     : TPoint;    //---------------------------------------- ������� ������� �������
DnPos      : TPoint;    //----------------------------- ������� ������� ����� ������ �����
UpPos      : TPoint;    //-------------------------- ������� ���������� ����� ������ �����
CurGrid    : TPoint;    //---------------------------- �������� ������ ����� ��� ��������.
                        //-----------------------------  ���� CurGrid.X=-9999 - ���� �����
CheckFill  : Boolean;   //---------------- ��������� ���������� ��������� �������� �������
VwMarh     : Integer;   //--------------------------- ����� ��������� ��������� �� �������
                        //---------------------------- (0- ���������, 1- ������ ���������)

function  AskNeedSavePrj : integer; //=========== ������ �� ������ ������������� ���������
function  SetNeedSavePrj : boolean; //========= ��������� �������� ������������� ���������
function  GetGridLine(y : integer) : integer; //========== ���������� ����� ������ � �����
function  GetGridCol(x : integer) : integer; //========== ���������� ����� ������� � �����
function  GetSelectPin(x,y,i : integer): integer;//���������� � �������� ����� �����������
function  SetSelectObj : boolean; //----- ���������� TRUE ���� ������� ������ ������������
procedure ClearAllObj; //----------------------------------- �������� ���� ������ ��������
function  AddNewObj(ind : integer) : integer; //------- �������� ����� ������ ������������
function  MoveObj(ind : integer) : integer; //---------------- ����������� ������ �� �����
function  DeleteObj(ind : integer) : integer; //------------------- ������� ������ �� ����
procedure SetObjInspector(i : integer); //----- ���������� ��������� � ���������� ��������
function  CheckParam(var p: TObjParams): boolean;//��������� ���������� ���������� �������
procedure ClearAllCon; //--------------------------------- �������� ���� ������ ����������
function  ConFirst : integer; //---------------------- ���������� ������ ����� �����������
function  ConSecond : integer; //--------------------- ���������� ������ ����� �����������
function  DeleteCon(ind : integer) : integer; //-------------- ������� ����������� �� ����
procedure ClearAllInpInt; //----------------- �������� ������ �������� ������� �����������
procedure ClearAllLogic; //--------------------------- �������� ������ ���������� ��������
procedure ClearAllOutInt; //---------------- �������� ������ �������� �������� �����������
function  ReplaceValues(Key, OldValue, NewValue : string) : integer; // ������������� ��� ��������� ��������� �� ���� ��������

var

  IsNeedSave : boolean; //---------------------------------- ������� ������������� �������

implementation

uses
  Main,
{$IFDEF TABLO}
  PaletteTablo,
  InspectorTablo;
{$ELSE}
  PalettePlan,
  InspectorPlan;
{$ENDIF}



//========================================================================================
function AskNeedSavePrj : integer;
var
  s : string;
begin
  if IsNeedSave then
  begin
    s := '�� ��������� ���������, ��������� � ������ ';
    if FileNamePrj <> '' then  s := s + '['+ FileNamePrj+ ']'
    else  s := s + '[��� �����]';
    s := s + #13 + '��������� ���������?';
    result := Application.MessageBox(pchar(s), '���� ���-���',
                MB_YESNOCANCEL+MB_DEFBUTTON1+MB_ICONQUESTION);
    if result = idNo then IsNeedSave := false;
  end
  else  result := idNo;
end;

//========================================================================================
//--------------------------------------------- ��������� �������� ������������� ���������
function SetNeedSavePrj : boolean;
begin
  result := not IsNeedSave;
  if result then
  begin
    MainForm.tbSaveProject.Enabled := true;
    IsNeedSave := true;
  end;
end;

//========================================================================================
//-------------------------------------------------------- ���������� ����� ������ � �����
function GetGridLine(y : integer) : integer;
  var
    i: integer;
begin
  result := -9999;
  for i := - pplan.LineUp to pplan.LineDown do
  begin
    if (y > (i * pplan.SV + pplan.OZ.Y - BlockH)) and
      (y < (i * pplan.SV + pplan.OZ.Y + BlockH)) then
    begin
      result := i;
      exit;
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------- ���������� ����� ������� � �����
function GetGridCol(x : integer) : integer;
  var
    j: integer;
begin
  result := -9999;
  for j := - pplan.LineLeft  to pplan.LineRight  do
  begin
    if (x > (j * pplan.SH + pplan.OZ.X - BlockW)) and
      (x < (j * pplan.SH + pplan.OZ.X + BlockW)) then
    begin
      result := j;
      exit;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------- ���������� ����� �������� ����� �����������
function GetSelectPin(x,y,i : integer) : integer;  //i --------- ������ ���������� �������
begin
  result := 0;
  if objects[i].index > 0 then
  begin //------------------------------------------------- �������� ��� ��������� �������
    if (X > (objects[i].col*pplan.SH+pplan.OZ.X-BlockW-2)) and
       (X < (objects[i].col*pplan.SH+pplan.OZ.X-BlockW+8)) and
       (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-8)) and
       (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+8)) then
    begin
      if palette[objects[i].IDO].npin > 0 then result := 1;
      exit;
    end else
    if (X > (objects[i].col*pplan.SH+pplan.OZ.X+BlockW-8)) and
       (X < (objects[i].col*pplan.SH+pplan.OZ.X+BlockW+2)) and
       (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-8)) and
       (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+8)) then
    begin
      if palette[objects[i].IDO].npin > 1 then result := 2;
      exit;
    end else
    if (objects[i].IDO = 1) or (objects[i].IDO = 2)
    or (objects[i].IDO = 5) or (objects[i].IDO = 6) then
    begin
      if (X > (objects[i].col*pplan.SH+pplan.OZ.X-8)) and
         (X < (objects[i].col*pplan.SH+pplan.OZ.X+8)) and
         (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-BlockH-3)) and
         (Y < (objects[i].line*pplan.SV+pplan.OZ.Y-BlockH+8)) then
      begin
        if palette[objects[i].IDO].npin > 2 then result := 3;
        exit;
      end
    end else
    if (objects[i].IDO = 3) or (objects[i].IDO = 4)
    or (objects[i].IDO = 7) or (objects[i].IDO = 8) then

    if (X > (objects[i].col*pplan.SH+pplan.OZ.X-8)) and
    (X < (objects[i].col*pplan.SH+pplan.OZ.X+8)) and
    (Y > (objects[i].line*pplan.SV+pplan.OZ.Y+BlockH-8)) and
    (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+BlockH+3)) then
    begin
      if palette[objects[i].IDO].npin > 2 then result := 3;
      exit;
    end
  end;
end;
//========================================================================================
//--------------------------------------- ���������� TRUE ���� ������� ������ ������������
function SetSelectObj : boolean;
  var
    i : integer;
begin
  selectPin := 0;
  selectObj := 0;
  if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
    for i := 1 to Length(objects) do
      if objects[i].index > 0 then
        if (objects[i].line = GetGridLine(CurPos.Y)) and
           (objects[i].col = GetGridCol(CurPos.X)) then
        begin
          selectObj := objects[i].index;
          SetObjInspector(i); // ���������� ��������� � ���������� ��������
          // ���������� ������� �� �������
          selectPin := GetSelectPin(CurPos.X,CurPos.Y,i);
          result := true;
{$IFDEF TABLO}
          if InspTabloForm.Visible then InspTabloForm.Refresh;
{$ELSE}
          if InspectorForm.Visible then InspectorForm.Refresh;
{$ENDIF}
          exit;
        end;
  SetObjInspector(0); // �������� ��������� � ���������� ��������
  for i := 1 to Length(objects) do
    objects[i].checkObj := false; // �������� �������� ������ ������
  result := false;
end;
//========================================================================================
//---------------------------------------------------------- �������� ���� ������ ��������
procedure ClearAllObj;
var
  i : integer;
begin
  for i := 1 to Length(objects) do
  begin
    with objects[i] do
    begin
      index  := 0;   name   := '';  line   := 0;  col    := 0;   IDO    := 0;
      jmp1   := 0;   jmp2   := 0;   jmp3   := 0;  params := ' ';
    end;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//----------------------------------------------------- �������� ����� ������ ������������
function AddNewObj(ind : integer)  : integer;
var
  i : integer;
begin
  //---------------------------------- �������� ������� ���������� ������ �� ���� ��������
  for i := 1 to Length(objects) do objects[i].checkObj := false;
  result := 0;
  if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
  begin
    for i := 1 to Length(objects) do
    begin
      if objects[i].index > 0 then
      if (objects[i].line = GetGridLine(CurPos.Y)) and
      (objects[i].col = GetGridCol(CurPos.X)) then
      begin
{$IFDEF TABLO}
        PaletteTabloForm.UnselectIDT; //----------- �������� ��� ���� ������������ �������
{$ELSE}
        UnselectIDO;   //-------------------------- �������� ��� ���� ������������ �������
{$ENDIF}
        result := i;        //---------------------- �������� ���������� (��������) ������
        SetObjInspector(i); //------------------------------- ��������� ������ � ���������
        exit;
      end;
    end;
    objects[ind].index:= ind;
    objects[ind].name := 'obj'+ IntToStr(ind);
    objects[ind].line := GetGridLine(CurPos.Y); objects[ind].col  := GetGridCol(CurPos.X);
    objects[ind].IDO  := selectIDO;
    //------------------------------------------------------------------ � ������ ��������
    result    := ind;
    SetObjInspector(ind);
  end;
  SetNeedSavePrj;
end;
//========================================================================================
//------------------------------------------------------------ ����������� ������ �� �����
function MoveObj(ind : integer) : integer;
var
  i,j,dx,dy : integer;
begin
  result := ind;  ismoveObj := false;
  if result = 0 then
  begin
    ShowMessage('����� �������������� ������� ����������� ���� ������� ������.');
    exit;
  end else
  begin
    if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
    begin
      dx := GetGridCol(CurPos.X) - objects[ind].col;
      dy := GetGridLine(CurPos.Y) - objects[ind].line;
      if (dx = 0) and (dy = 0) then exit;
      //------------- ��������� ����������� ����� ����������� ��� ���������� ���� ��������
      for j := 1 to Length(objects) do
      if objects[j].checkObj or (j = ind) then
      for i := 1 to Length(objects) do
      begin
        if objects[i].index > 0 then
        if (objects[i].line = dy + objects[j].Line) and
        (objects[i].col  = dx + objects[j].Col) and
        not (objects[i].checkObj or (i = j)) then
        begin
          ShowMessage('������ ����������� ������ �� ������� �����.');
          exit;
        end;
      end; //for
      //-------------------------------------- ���������� ����� ��������� �������� � �����
      for j := 1 to Length(objects) do
      if objects[j].checkObj or (j = ind) then
      begin
        objects[j].line := dy + objects[j].Line;
        objects[j].col  := dx + objects[j].Col;
      end;
      SetObjInspector(ind);
      SetNeedSavePrj;
      exit;
    end;
  end;
end;
//========================================================================================
//----------------------------------------------------------------- ������� ������ �� ����
function DeleteObj(ind : integer) : integer;
var
  i,j : integer;
begin
{$IFDEF TABLO}
  PaletteTabloForm.UnselectIDT;
{$ELSE}
  PalettePlan.UnselectIDO; // �������� ��� ���� ������������ �������
{$ENDIF}
  result := 0;
  if ind = 0 then
  begin
    ShowMessage('������� ������ ������.');
    exit;
  end else
  begin
    for i := 1 to Length(objects) do
    objects[i].checkObj := false; //------ �������� ������� ������ ������ �� ���� ��������
    for i := 1 to Length(objects) do
    if objects[i].index = ind then
    begin
      j := objects[i].jmp1;
      if j > 0 then DeleteCon(j);
      j := objects[i].jmp2;
      if j > 0 then DeleteCon(j);
      j := objects[i].jmp3;
      if j > 0 then DeleteCon(j);
      objects[i].index   := 0; //-------------------------------- ���������� ������ � ����
      objects[i].TmpName := '';  objects[i].name    := '';   objects[i].line    := 0;
      objects[i].col     := 0;   objects[i].IDO     := 0;    result := i;
      SetObjInspector(i);
      SetNeedSavePrj;
      break;
    end;
    //--------------------------------------------- ��������� ������� � ��������� ��������
    i := 1;
    while i < Length(objects) do
    begin  //-------------------------------------------- ����������� ���� ������ ��������
      if objects[i].index = 0 then
      begin
        j := i+1;
        while j <= Length(objects) do
        begin
          if objects[j].index > 0 then
          //----------------------------------------------------- ������� ����� � ��������
          //--------------------------------- i - ������ �����; j - ������� � ����� ������
          begin
            //-------------------------------- ����������� �������� �� ������ J � ������ I
            objects[i].index  := i;
            objects[i].TmpName:= objects[j].TmpName;
            objects[i].name   := objects[j].name; objects[i].line    := objects[j].line;
            objects[i].col    := objects[j].col;   objects[i].IDO     := objects[j].IDO;
            objects[i].Jmp1   := objects[j].Jmp1; objects[i].Jmp2    := objects[j].Jmp2;
            objects[i].Jmp3   := objects[j].Jmp3; objects[i].Params  := objects[j].Params;
            //------------------- �������������� ������� �������� � ��������� ������������
            if objects[j].Jmp1 > 0 then
            if connects[objects[j].Jmp1].BeginObj = j then
            connects[objects[j].Jmp1].BeginObj := i;

            if objects[j].Jmp2 > 0 then
            if connects[objects[j].Jmp2].BeginObj = j then
            connects[objects[j].Jmp2].BeginObj := i;

            if objects[j].Jmp3 > 0 then
            if connects[objects[j].Jmp3].BeginObj = j then
            connects[objects[j].Jmp3].BeginObj := i;

            if objects[j].Jmp1 > 0 then
            if connects[objects[j].Jmp1].EndObj = j then
            connects[objects[j].Jmp1].EndObj := i;

            if objects[j].Jmp2 > 0 then
            if connects[objects[j].Jmp2].EndObj = j then
            connects[objects[j].Jmp2].EndObj := i;

            if objects[j].Jmp3 > 0 then
            if connects[objects[j].Jmp3].EndObj = j then
            connects[objects[j].Jmp3].EndObj := i;

            //-------------------------------------------------------- ���������� ������ J
            objects[j].index   := 0;  objects[j].TmpName := '';  objects[j].name    := '';
            objects[j].line    := 0;  objects[j].col     := 0;   objects[j].IDO     := 0;
            objects[j].Jmp1    := 0;  objects[j].Jmp2    := 0;   objects[j].Jmp3    := 0;
            objects[j].Params  := '';
            break;
          end;
          inc(j);
        end;
      end;
      inc(i);
    end;
  end;
end;
//========================================================================================
//--------------------------------------------- ���������� ��������� � ���������� ��������
procedure SetObjInspector(i : integer);
begin
{$IFDEF TABLO}
  InspTabloForm.SetViewObject(i);
{$ELSE}
  InspectorForm.SetViewObject(i);
{$ENDIF}
end;
//========================================================================================
//-------------------------------------------------------- �������� ���� ������ ����������
procedure ClearAllCon;
  var
    i : integer;
begin
  for i := 1 to Length(connects) do
  begin
    with connects[i] do
    begin
      Index := 0; IDO := 0;  BeginObj := 0;  BeginPin := 0; EndObj   := 0; EndPin   := 0;
    end;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//---------------------------------------------------- ���������� ������ ����� �����������
function  ConFirst : integer;
var
  i : integer;
begin
  selectCon := 0;
  //---------------------------------- ��������� ����������� ���������� ������ �����������
  for i := 1 to Length(connects) do
  if connects[i].index = 0 then
  begin
    selectCon := i;
    break;
  end;
  if selectCon = 0 then
  ShowMessage('���� ������ ���������. ����� ������� �������� ����������.')
  else
  begin
    if SetSelectObj and (selectPin > 0) then
    begin
      //--------------------------------------------- ��������� ��������� ����� ����������
      connects[selectCon].Index := selectCon;
      case selectIDO of
        24,25,26,76 : i := selectIDO; //------------------------------------ ��� ���������

        31:
          case selectPin of
            1 : i := 31; //-------------------------------- ����� 1(��������������� �����)
            2 : i := 32; //------------------------------- ����� 2(��������������� ������)
          end

        else
          case selectPin of  //------------------------------------ �����, ������� �������
            1 : i := 33; //------------------------------------------ ����� 1(����� �����)
            2 : i := 34; //----------------------------------------- ����� 2(����� ������)
            else //------------------------------------------------- ����� 3 (��� �������)
              case objects[selectObj].IDO of
                1,2,5,6 : i := 42; //---------------------------------------- ����� ������
                3,4,7,8 : i := 43; //----------------------------------------- ����� �����
              end;
          end;
      end;
      connects[selectCon].IDO      := i;
      connects[selectCon].BeginObj := selectObj;
      connects[selectCon].BeginPin := selectPin;
      case selectPin of
        1: objects[selectObj].jmp1 := selectCon;
        2: objects[selectObj].jmp2 := selectCon;
        3: objects[selectObj].jmp3 := selectCon;
      end;
      case palette[i].npin of //------------------ ������� ������ ������ ����� �����������
        2..3: isfirstPin := true;
      else //--------------------------------------------- ����� ������� ������� ��� �����
        isfirstPin := false;
        SetNeedSavePrj;
      end;
      SetObjInspector(selectObj);
    end else
    begin

{$IFDEF TABLO}
      PaletteTabloForm.UnselectIDT; //------------- �������� ��� ���� ������������ �������
{$ELSE}
      UnselectIDO; //------------------------------ �������� ��� ���� ������������ �������
{$ENDIF}
      ShowMessage('��� ���������� ���������� ���� ���������� ��������� ����� �����������.');
      selectCon := 0;
    end;
  end;
  result := selectCon;
end;
//========================================================================================
//---------------------------------------------------- ���������� ������ ����� �����������
function  ConSecond : integer;
begin
  //-------------------------------------------------- ��������� �������� ����� ����������
  if SetSelectObj and (selectPin > 0) and (selectObj <> connects[selectCon].BeginObj) then
  begin
    connects[selectCon].EndObj := selectObj;
    connects[selectCon].EndPin := selectPin;
    case selectPin of
      1: objects[selectObj].jmp1 := selectCon;
      2: objects[selectObj].jmp2 := selectCon;
      3: objects[selectObj].jmp3 := selectCon;
    end;
    SetObjInspector(selectObj);
  end else
  begin
{$IFDEF TABLO}
    PaletteTabloForm.UnselectIDT; //--------------- �������� ��� ���� ������������ �������
{$ELSE}
    UnselectIDO; //-------------------------------- �������� ��� ���� ������������ �������
{$ENDIF}
    ShowMessage('��� ���������� ���������� ���� ���������� �������� ����� �����������.');
    case connects[selectCon].BeginPin of
      1: objects[connects[selectCon].BeginObj].jmp1 := 0;
      2: objects[connects[selectCon].BeginObj].jmp2 := 0;
      3: objects[connects[selectCon].BeginObj].jmp3 := 0;
    end;
    connects[selectCon].Index := 0;
    selectCon := 0;
  end;
  result := selectCon;
  isfirstPin := false;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------------------------------ ������� ����������� �� ����
function  DeleteCon(ind : integer) : integer;
var
  i,j : integer;
begin
  result := 0;
  if ind = 0 then
  ShowMessage('��� �������� ���������� ���� �������� ���� �� �������������� ���������.')
  else
  begin
    for i := 1 to Length(connects) do
    if connects[i].Index = ind then
    begin
      result := ind;
      break;
    end;
    if result = 0 then exit
    else
    begin
      case connects[ind].BeginPin of //------------- ������� ����� � �������� ������ �����
        1: objects[connects[ind].BeginObj].jmp1 := 0;
        2: objects[connects[ind].BeginObj].jmp2 := 0;
        3: objects[connects[ind].BeginObj].jmp3 := 0;
      end;
      case connects[ind].EndPin of //---------------- ������� ����� � �������� ����� �����
        1: objects[connects[ind].EndObj].jmp1 := 0;
        2: objects[connects[ind].EndObj].jmp2 := 0;
        3: objects[connects[ind].EndObj].jmp3 := 0;
      end;
      //-------------------------------------------------------------- ������� �����������
      connects[ind].Index := 0;    connects[ind].IDO   := 0;  connects[ind].BeginObj := 0;
      connects[ind].BeginPin := 0; connects[ind].EndObj := 0; connects[ind].EndPin := 0;
      SetObjInspector(selectObj);
      //---------------------------------------------------- ��������� ������ ������������
      i := 1;
      while i < Length(connects) do
      begin
        if connects[i].Index = 0 then
        begin
          j := i+1;
          while j <= Length(connects) do
          begin
            if connects[j].Index > 0 then
            begin
              //-------------------- I - ��������� ����� � ��������� �������� ������������
              //------------------------------------------------ J - ��������� �����������
              //------------------------------ ����������� �������� �� ������ J � ������ I
              connects[i].Index    := i;
              connects[i].IDO      := connects[j].IDO;
              connects[i].BeginObj := connects[j].BeginObj;
              connects[i].BeginPin := connects[j].BeginPin;
              connects[i].EndObj   := connects[j].EndObj;
              connects[i].EndPin   := connects[j].EndPin;
              //---------------------------- ����������������� ������ � ��������� ��������
              if connects[i].BeginObj > 0 then
              begin
                case connects[i].BeginPin of
                  1 : objects[connects[i].BeginObj].Jmp1 := i;
                  2 : objects[connects[i].BeginObj].Jmp2 := i;
                  3 : objects[connects[i].BeginObj].Jmp3 := i;
                end;
              end;
              if connects[i].EndObj > 0 then
              begin
                case connects[i].EndPin of
                  1 : objects[connects[i].EndObj].Jmp1 := i;
                  2 : objects[connects[i].EndObj].Jmp2 := i;
                  3 : objects[connects[i].EndObj].Jmp3 := i;
                end;
              end;
              //------------------------------------------------------ ���������� ������ J
              connects[j].Index := 0;   connects[j].IDO   := 0; connects[j].BeginObj := 0;
              connects[j].BeginPin := 0;connects[j].EndObj := 0;connects[j].EndPin := 0;
              break;
            end;
            inc(j);
          end;
        end;
        inc(i);
      end;
    end;
  end;
  SetNeedSavePrj;
end;
//========================================================================================
//------------------------- ��������� ������� � ������������ ���������� ���������� �������
function CheckParam(var p : TObjParams) : boolean;
var
  s,t,pa,d,h : string;
  i,j,k,l, All, Row1 : integer;
  ci : int64;
  fi : boolean;
  Marker : TRect;
begin
{$IFDEF TABLO}
  exit;
{$ELSE}

  result := false; //------------------------------- ���������� ������� �������� ���������
  s := p.params; //------------------------------------------- ��������� ��������� �������
  if s = '' then  exit; //------------------------------------- ���� ������ ������ - �����

  ci := $100000000;

  All := High(inint);

  for i := 0 to palette[p.IDO].proplist.Count-1 do  //--- ������ �� ���� ��������� �������
  begin
    j := 1; h := '';

    d := palette[p.IDO].proplist.Strings[i]; //����� ��������� �������� ������� �� �������

    while j <= Length(d) do
    begin
      if d[j] = ':'
      then break; //----------------------------- ����� �� ����������� �������� � ��������
      h := h + d[j]; //--------------------------- ���������� ��� �������� ������� �������
      inc(j);
    end;
    //-------------------------------- ����� �������� h - ������������ ��������� � �������

    if j > Length(d) then   exit; //------------- ���� ����� �� ���������� ����� � �������

    inc(j);
    t := '';
    while j <= Length(d) do //- ���������� ���� �� ������ � �������� ��� ��������� �������
    begin
      if d[j] = ':' then break;
      t := t + d[j];
      inc(j);
    end; //--------------------------------- t - ��� ���������, ��������� ������� ��������

    if j > Length(d) then exit;
    k := 1;

    //------------------------------------------ ����� �������� � �������� ������� �������
    while k <= Length(s) do
    begin
      pa := '';
      while k <= Length(s) do
      begin
        if s[k] = '='
        then break;
        pa := pa + s[k];
        inc(k);
      end;    //---------------------------- pa - ������������ ��������� � ������� �������
      if pa = h then  //���� ��� ��������� ������������� ����� ��������� ������� � �������
      begin //----------------------------- ��������� �������� ��������� � ������� �������
        inc(k);
        d := '';

        while k <= Length(s) do
        begin
          if s[k] = ';' then break;
          d := d + s[k];
          inc(k);
        end;
        //------------------------------------------------- �������� ��������� ������� � d

        //---------------------------------------------------- �������� �������� ���������
        fi := false; //------------------- ���������� ������� �������� ��������� ���������

        if t = 'iinput' then  //----------------- ���� ��� ��������� = "������� ���������"
        begin
          for l := 1 to All do  //------ �������� �� ����� ������ �������� �����
          if (inint[l].Index > 0) and
          (AnsiUpperCase(inint[l].Name) = AnsiUpperCase(d)) then //-- ������� ��� � ������
          begin
            fi := true;
            break;
          end; //-------------------------------------------------------- ������� ��������
          if d = '���' then d := '?';

          if l = SelectObj then
          InspectorForm.ValueListEditor.Values[h] := d;

          if (l < All) and (l > 1) and (d = '?')  then
          begin
            fi := true;
            //inint[l].Name := d;
            InspectorForm.ValueListEditor.Values[h] := d;
            break;
          end;//----------------------------------------- � ������� ������ �� ������������
        end else

        if t = 'ioutput' then //---------------- ���� ��� ��������� = "�������� ���������"
        begin
          for l := 1 to Length(outint) do   //--- �������� �� ����� ������ �������� ������
          if (outint[l].Index >0) and
          (AnsiUpperCase(outint[l].Name) = AnsiUpperCase(d)) then //���� ���� ��� � ������
          begin
            fi := true;
            break;
          end; //-------------------------------------------------------- ������� ��������

          if d = '���' then d := '?';

          if l = SelectObj then InspectorForm.ValueListEditor.Values[h] := d;
          if (l < All) and (l > 1) and (d = '?')  then
          begin
            fi := true;
            if l = SelectObj then  InspectorForm.ValueListEditor.Values[h] := d;
            break;
          end;//----------------------------------------- � ������� ������ �� ������������
        end else

        if t = 'iname' then  //-------- ���� ��� ��������� = "��� � �������� ������������"
        begin
          if ((d = '?') or (d = '���')) then  fi := true   // ������ ������� �� ������� ���
          else
          for l := 1 to Length(objects) do //-------- ������ �� ���� �������� ������������
          begin
            fi := false;
            if (objects[l].Index > 0) and
            (AnsiUpperCase(objects[l].Name) = AnsiUpperCase(d)) then //-���� ������ ������
            begin
              fi := true;
              break; //-------------------------------------------------- ������� ��������
            end;
          end;

          if d = '���' then d := '?'; //------------------------ � ������� �� ������������

          if(d <> '?') and (d <> '���' ) then InspectorForm.ValueListEditor.Values[h]:=d;

          if fi = false then InspectorForm.ValueListEditor.Values[h] := '#'
          else
          begin
            if (l < All) and (l > 1) and (d = '?')  then
            begin
              fi := true;
//              inint[l].Name := d;
              if l = SelectObj then
              InspectorForm.ValueListEditor.Values[h] := d;
              break;
            end;//--------------------------------------- � ������� ������ �� ������������
          end;
        end else
        if t = 'bool' then //------------------------ ���� ��� ��������� �������� ��������
        begin
          if (d = '��') or (d = '���') then   fi := true  //---------- ���� "��" ��� "���"
          else
          begin
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end;
        end else

        if t = 'byte' then //-------------------- ���� ��� ��������� = "�������� ��������"
        begin
          try
            ci := StrToInt(d);
            if (ci >= 0) and (ci < 256) then  fi := true;// ���� �������� � �������� �����
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end; //------------------------------------------------------- ��������� � �����
        end else

        if t = 'word' then //-------------------------------- ���� ��� ��������� = "�����"
        begin
          try
            ci := StrToInt(d)
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end; //------------------------------------------------------- ��������� � �����
          if (ci >= 0) and (ci < 65536) then fi := true;//--------- ���� � ��������� �����
        end else

        if t = 'lword' then //---------------------------- ���� �������� = "������� �����"
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end; //------------------------------------------------------- ��������� � �����
          if (ci >= 0) and (ci < $100000000) then  fi := true; //---------- ���� � �������
        end else

        if t = 'short' then //--------------------------- ���� �������� = "�������� �����"
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end; //--------------------- ��������� � �����
          if (ci >= -128) and (ci < 128) then  fi := true;//--------------- ���� � �������
        end else

        if t = 'small' then
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end;
          if (ci >= -$8000) and (ci < $8000) then fi := true;
        end else

        if t = 'int' then
        begin
          try
            ci := StrToInt(d);
            if (ci >= -$80000000) and (ci < $80000000) then  fi := true;
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end;
        end else

        if t = 'string' then //----------------------------------------------- ���� ������
        begin
          if d <> '' then   fi := true; //-------------------------- ���� ������ �� ������
        end else

        if t = 'ilist' then //----------------------------------- ������ ������ �� �������
        begin
          if d <> '' then  fi := true;
        end else

        begin //--------------------------------------------------- ������ ���� ����������
          fi := true;
        end;

        //--------------------- ��������� �������� ���� �������� �������������� ����������
        if d = '?'  then fi := true;

        if fi then break
        else
        begin
          s[k-1] := '#';
          p.params := s;
          if l = SelectObj then
          begin
            InspectorForm.ValueListEditor.Values[h] := '#';
            InspectorForm.ValueListEditor.FindRow(h,Row1);
            Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
            InspectorForm.ValueListEditor.Refresh;
          end;
          exit;
        end;
      end;

      while k <= Length(s) do
      begin
        if s[k] = ';' then break;
        inc(k);
      end;
      inc(k);
    end;
  end;
  result := true;
{$ENDIF}
end;

//========================================================================================
procedure ClearAllInpInt; //----------------- �������� ������ �������� ������� �����������
  var
    i : integer;
begin
  inint[1].Index := 1;
  inint[1].Name  := '���';
  inint[1].Limit := 0;
  inint[1].Used  := 0;
  for i := 2 to Length(inint) do
  begin
    inint[i].Index := 0;
    inint[i].Name  := '';
    inint[i].Limit := 0;
    inint[i].Used  := 0;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//---------------------------------------------------- �������� ������ ���������� ��������
procedure ClearAllLogic;
  var
    i : integer;
begin
  for i := 1 to Length(logint) do
  begin
    logint[i].Name  := '';
    logint[i].Logic := '';
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------------ �������� ������ �������� �������� �����������
procedure ClearAllOutInt;
  var
    i : integer;
begin
  outint[1].Index := 1; outint[1].Name  := '���';
  outint[1].Limit := 0; outint[1].Used  := 0;
  for i := 2 to Length(outint) do
  begin
    outint[i].Index := 0;  outint[i].Name  := '';
    outint[i].Limit := 0;  outint[i].Used  := 0;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------ �������� �������� ������ �� ���� ��������� ��������
function ReplaceValues(Key      : string; //----------------- ��� ��������� ������� (����)
                       OldValue : string; //-------------------- ������ �������� ���������
                       NewValue : string) //--------------------- ����� �������� ���������
                       : integer;         //-- ���������� ���������� ���������� ����������
var
  i,j,k,l,m,r : integer;
  s,n,o,t : string;
begin
  result := 0;
  for i := 1 to Length(objects) do
  begin
    if objects[i].index > 0 then
    begin
      for j := 0 to palette[objects[i].IDO].proplist.Count - 1 do
      begin //---------------- ����� ��������� �������, ����������� �� ��� ������� �������
        s := palette[objects[i].IDO].proplist.Strings[j];
        k := 1; n := '';
        while s[k] <> ':' do
        begin //------------------------------------------------------- �������� ��� �����
          n := n + s[k];
          inc(k);
          if k > Length(s) then break;
        end;
        inc(k);
        if k > Length(s) then break;
        t := '';
        while s[k] <> ':' do
        begin //--------------------------------------------------- �������� ��� ���������
          t := t + s[k];
          inc(k);
          if k > Length(s) then break;
        end;
        if t = Key then
        begin //---------------------------------- ����� ������ � �������� ������� �������
          s := objects[i].params;
          for l := 1 to Length(s) do
          begin
            m := 0; o := '';
            while s[l+m] <> '=' do
            begin
              o := o + s[l+m];
              inc(m);
              if (l+m) > Length(s) then break;
            end;
            if o = n then //---------------- ���� ���� ������ - �������� �������� � ������
            begin
              r := l+m; //------------------ ����� �������, � �������� ���������� ��������
              inc(m);
              o := '';
              while s[l+m] <> ';' do
              begin
                o := o + s[l+m];
                inc(m);
                if (l+m) > Length(s) then break;
              end;
              if o = OldValue then
              begin
                t := s;  SetLength(t,r);  t := t + NewValue;  k := r;
                while s[k] <> ';' do
                begin
                  inc(k);
                  if k > Length(s) then break;
                end;
                if k <= Length(s) then
                begin
                  while k <= Length(s) do
                  begin
                    t := t + s[k];  inc(k);
                  end;
                end;
                objects[i].params := t; inc(result);
              end;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  if result > 0 then SetNeedSavePrj;
end;

end.
