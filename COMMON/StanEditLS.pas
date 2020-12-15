unit StanEditLS;
//*****************************************************************************
// ��������� ���������� � �������� �������� �������� ������������ �������
//*****************************************************************************

interface

uses
  SysUtils,
  Classes,
  StanEditTypes,
  interpritator,
  TypeALL;

const
  // �������� ���� ������ � ��������� ������������ �������
  filenameObjDat   = 'Objects.dat';
  filenameConDat   = 'Connects.dat';
  filenameIIObjDat = 'IIObj.dat';
  filenameOIObjDat = 'OIObj.dat';

function SaveObjParams(FileName: string; start, len: Integer) : integer; // ��������� ��������� ��������
function LoadObjParams(FileName: string; start: Integer) : integer;      // ��������� ��������� ��������
function SaveConParams(FileName: string; start, len: Integer) : integer; // ��������� �������� ����������
function LoadConParams(FileName: string; start: Integer) : integer;      // ��������� �������� ����������
function SaveIIObjList(FileName: string; start, len: Integer) : integer; // ��������� ������ ������� ����������� ��������
function LoadIIObjList(FileName: string; start: Integer) : integer;      // ��������� ������ ������� ����������� ��������
function SaveOIObjList(FileName: string; start, len: Integer) : integer; // ��������� ������ �������� ����������� ��������
function LoadOIObjList(FileName: string; start: Integer) : integer;      // ��������� ������ �������� ����������� ��������

implementation

function SaveObjParams(FileName: string; start, len: Integer) : integer; // ��������� ��������� ��������
  var
    sl0 : TStringList;
    i  : integer;
begin
  sl0 := TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to Length(objects) do
        if objects[i].index <> 0 then
          sl0.Add(IntToStr(objects[i].Index)+ ';'+ objects[i].name+ ';'+ IntToStr(objects[i].Line)+ ';'+ IntToStr(objects[i].Col)+ ';'+ IntToStr(objects[i].IDO)+ ';'+ IntToStr(objects[i].Jmp1)+ ';'+ IntToStr(objects[i].Jmp2)+ ';'+ IntToStr(objects[i].Jmp3)+ ';'+ objects[i].TmpName+ ';'+ objects[i].params);
    end else
    begin
      for i := start to start+len do
        if objects[i].index <> 0 then
          sl0.Add(IntToStr(objects[i].Index)+ ';'+ objects[i].name+ ';'+ IntToStr(objects[i].Line)+ ';'+ IntToStr(objects[i].Col)+ ';'+ IntToStr(objects[i].IDO)+ ';'+ IntToStr(objects[i].Jmp1)+ ';'+ IntToStr(objects[i].Jmp2)+ ';'+ IntToStr(objects[i].Jmp3)+ ';'+ objects[i].TmpName+ ';'+ objects[i].params);
    end;
    sl0.SaveToFile(FileName);
  finally
    result := sl0.Count; // ������� ���������� ����������� ��������
    sl0.Free;
  end;
end;
//========================================================================================
//----------------------------------------------------------- ��������� ��������� ��������
function LoadObjParams(FileName: string; start: Integer) : integer;
var
  sla  : TStringList;
  s,p : string;
  i,j,z : integer;
begin
  result := -1;
  sla := TStringList.Create;
  try
    sla.LoadFromFile(FileName);
    if sla.Count > 0 then
    begin
      for i := 0 to sla.Count-1 do
      begin
        s := sla.Strings[i];
        if Length(s) > 0 then
        begin
          p := ''; j := 1;
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);

          try  z := StrToInt(p) except z := -1  end;//--------------------- ������ �������

          if z > 0 then
          begin
            objects[z + start].index := z + start;

            //------------------------------------------------------ ��������� ��� �������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            objects[z+start].name := p;

            //------------------------------------------------ ��������� ����� ����� �����
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);

            try objects[z+start].line := StrToint(p) except exit end;

            //---------------------------------------------- ��������� ����� ������� �����
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            try objects[z+start].col := StrToint(p) except exit end;

            //--------------------------------------- ��������� ������������� ���� �������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            try objects[z+start].IDO := StrToint(p) except exit end;

            //-------------------- ��������� ������ �� �������, ������������ � 1-�� ������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            try objects[z+start].jmp1 := StrToint(p) except exit end;

            //------------------- ��������� ������ �� �������, ������������ �� 2-�� ������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            try objects[z+start].jmp2 := StrToint(p) except exit end;

            //-------------------- ��������� ������ �� �������, ������������ � 3-�� ������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            try objects[z+start].jmp3 := StrToint(p) except exit end;

            //--------------------- ��������� ������ ��� ���� �������\�������� �����������
            p := '';
            while s[j] <> ';' do
            begin
              p := p + s[j];
              inc(j);
              if j > Length(s) then break;
            end;
            inc(j);
            objects[z+start].TmpName := p;

            //----------------------------------------- ��������� �������� ������� �������
            p := '';
            while j <= Length(s) do
            begin
              p := p + s[j];
              inc(j);
            end;
            objects[z+start].params := p;
          end;
        end;
      end;
      result := sla.Count; //--------------------- ������� ���������� ����������� ��������
    end;
  finally
    sla.Free;
  end;
end;

//========================================================================================
//---------------------------------------------------------- ��������� �������� ����������
function SaveConParams(FileName: string; start, len: Integer) : integer;
var
  slb : TStringList;
  i : integer;
begin
  slb := TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to Length(connects) do
      if connects[i].index <> 0 then
      slb.Add(IntToStr(connects[i].Index) + ';' +
      IntToStr(connects[i].IDO) + ';' +
      IntToStr(connects[i].BeginObj) + ';' +
      IntToStr(connects[i].BeginPin) + ';' +
      IntToStr(connects[i].EndObj) + ';' +
      IntToStr(connects[i].EndPin)+ ';');
    end else
    begin
      for i := start to start+len do
      slb.Add(IntToStr(connects[i].Index) + ';' +
      IntToStr(connects[i].IDO) + ';'+
      IntToStr(connects[i].BeginObj) + ';' +
      IntToStr(connects[i].BeginPin) + ';' +
      IntToStr(connects[i].EndObj) + ';' +
      IntToStr(connects[i].EndPin) + ';');
    end;
    slb.SaveToFile(FileName);
  finally
    result := slb.Count; //--------------------- ������� ���������� ����������� ����������
    slb.Free;
  end;
end;

function LoadConParams(FileName: string; start: Integer) : integer; // ��������� �������� ����������
  var
    slc : TStringList; s,p : string; i,j : integer; z : integer;
begin
  result := -1;
  slc := TStringList.Create;
  try
    slc.LoadFromFile(FileName);
    if slc.Count > 0 then
    begin
      for i := 0 to slc.Count-1 do
      begin
        s := slc.Strings[i];
        if Length(s) > 0 then
        begin
          p := ''; j := 1; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try z := StrToInt(p) except z := -1 end; // ������ ����������
          if z > 0 then
          begin
            connects[z + start].index := z + start;
            // ��������� ������������� ���� ����������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); try connects[z+start].IDO := StrToint(p) except exit end;
            // ��������� ����� ������� ������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); try connects[z+start].BeginObj := StrToint(p) except exit end;
            // ��������� ����� �������� ������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); try connects[z+start].BeginPin := StrToint(p) except exit end;
            // ��������� ����� ������� �����
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); try connects[z+start].EndObj := StrToint(p) except exit end;
            // ��������� ����� �������� �����
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; try connects[z+start].EndPin := StrToint(p) except exit end;
          end;
        end;
      end;
      result := slc.Count; // ������� ���������� ����������� ����������
    end;
  finally
    slc.Free;
  end;
end;

function SaveIIObjList(FileName: string; start, len: Integer) : integer; // ��������� ������ ������� ����������� ��������
  var sld : TStringList; i  : integer;
begin
  sld := TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to Length(IIObjects) do
        if IIObjects[i].index <> 0 then
          sld.Add(IntToStr(IIObjects[i].Index)+ ';'+ IIObjects[i].NameObj+ ';'+ IIObjects[i].NameKey+ ';'+ IIObjects[i].NameInterface+ ';'+ IIObjects[i].Hint+ ';');
    end else
    begin
      for i := start to start+len do
        if IIObjects[i].index <> 0 then
          sld.Add(IntToStr(IIObjects[i].Index)+ ';'+ IIObjects[i].NameObj+ ';'+ IIObjects[i].NameKey+ ';'+ IIObjects[i].NameInterface+ ';'+ IIObjects[i].Hint+ ';');
    end;
    sld.SaveToFile(FileName);
  finally
    result := sld.Count; // ������� ���������� ����������� ��������
    sld.Free;
  end;
end;

function LoadIIObjList(FileName: string; start: Integer) : integer;      // ��������� ������ ������� ����������� ��������
  var sle  : TStringList; s,p : string; i,j : integer; z : integer;
begin
  result := -1;
  sle := TStringList.Create;
  try
    sle.LoadFromFile(FileName);
    if sle.Count > 0 then
    begin
      for i := 0 to sle.Count-1 do
      begin
        s := sle.Strings[i];
        if Length(s) > 0 then
        begin
          p := ''; j := 1; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try z := StrToInt(p) except z := -1 end; // ������ �������
          if z > 0 then
          begin
            IIObjects[z + start].index := z + start;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); IIObjects[z+start].NameObj := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); IIObjects[z+start].NameKey := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); IIObjects[z+start].NameInterface := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; IIObjects[z+start].Hint := p;
          end;
        end;
      end;
      result := sle.Count; // ������� ���������� ����������� ��������
    end;
  finally
    sle.Free;
  end;
end;

function SaveOIObjList(FileName: string; start, len: Integer) : integer; // ��������� ������ �������� ����������� ��������
  var slf : TStringList; i  : integer;
begin
  slf := TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to Length(objects) do
        if OIObjects[i].index <> 0 then
          slf.Add(IntToStr(OIObjects[i].Index)+ ';'+ OIObjects[i].NameObj+ ';'+ OIObjects[i].NameKey+ ';'+ OIObjects[i].NameInterface+ ';'+ OIObjects[i].Hint+ ';');
    end else
    begin
      for i := start to start+len do
        if OIObjects[i].index <> 0 then
          slf.Add(IntToStr(OIObjects[i].Index)+ ';'+ OIObjects[i].NameObj+ ';'+ OIObjects[i].NameKey+ ';'+ OIObjects[i].NameInterface+ ';'+ OIObjects[i].Hint+ ';');
    end;
    slf.SaveToFile(FileName);
  finally
    result := slf.Count; // ������� ���������� ����������� ��������
    slf.Free;
  end;
end;

function LoadOIObjList(FileName: string; start: Integer) : integer;      // ��������� ������ �������� ����������� ��������
  var slg  : TStringList; s,p : string; i,j : integer; z : integer;
begin
  result := -1;
  slg := TStringList.Create;
  try
    slg.LoadFromFile(FileName);
    if slg.Count > 0 then
    begin
      for i := 0 to slg.Count-1 do
      begin
        s := slg.Strings[i];
        if Length(s) > 0 then
        begin
          p := ''; j := 1; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try z := StrToInt(p) except z := -1 end; // ������ �������
          if z > 0 then
          begin
            OIObjects[z + start].index := z + start;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); OIObjects[z+start].NameObj := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); OIObjects[z+start].NameKey := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j); OIObjects[z+start].NameInterface := p;
            // ��������� ��� �������
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; OIObjects[z+start].Hint := p;
          end;
        end;
      end;
      result := slg.Count; // ������� ���������� ����������� ��������
    end;
  finally
    slg.Free;
  end;
end;

end.
