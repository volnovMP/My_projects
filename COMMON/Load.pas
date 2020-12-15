unit Load;
//------------------------------------------------------------------------------
// ���� �������� ��������
//------------------------------------------------------------------------------
{$INCLUDE d:\sapr2012\CfgProject}

interface

uses
  Windows,
  Classes,
  Dialogs,
  SysUtils;
//-------------------------------------------------------------- ������� �� ���������� DLL
function findchar(var index: integer;const s: string;const c: char): boolean;external 'MyDLL1';
function getbool(var index: integer;const s: string;var p: boolean): boolean;external 'MyDLL1';
function getbyte(var index: integer;const s: string;var p: Byte): boolean;external 'MyDLL1';
function getcrc16(var index: integer;const s: string;var p: Word): boolean;external 'MyDLL1';
function getcrc32(var index: integer;const s: string;var p: integer): boolean;external 'MyDLL1';
function getcrc8(var index: integer;const s: string;var p: Byte): boolean;external 'MyDLL1';
function getinteger(var index: integer;const s: string;var p: integer): boolean;external 'MyDLL1';
function getsmallint(var index: integer;const s: string;var p: smallInt): boolean;external 'MyDLL1';
function getstring(var index: integer;const s: string;var p: string): boolean;external 'MyDLL1';
function getword(var index: integer;const s: string;var p: Word): boolean;external 'MyDLL1';
function skipchar(var index: integer; const s: string; const c: char): boolean; external 'MyDLL1';
//----------------------------------------------------------------------------------------
function CalcCRC_OU(Index : Integer) : boolean;
function CalcCRC_OV(Index : Integer) : boolean;
function CalcCRC_OZ(Index : Integer) : boolean;
function CalcCRC_VB(Index : Integer) : boolean;
function ChekFileParams(filepath: string; cfg : TStringList) : Boolean;
function GetMYTHX : Byte; //----------------------- �������� ������� ���-�������� �� �����
function LoadAKNR(filepath: string) : boolean;
function LoadBase(filepath: string) : boolean;
function LoadConfig(filepath: string) : boolean;
function LoadDiagnoze(filename: string):Integer; // ��������� ����������� ������ ���������
function LoadLex(filepath: string) : boolean;
function LoadLex2(filepath: string) : boolean;
function LoadLex3(filepath: string) : boolean;
function LoadLinkFR(filepath: string) : boolean;
function LoadMsg(filepath: string) : boolean;
function LoadOUStruct(filepath: string; const start, len : Integer) : boolean;
function LoadOVBuffer(filepath: string; const start, len : Integer) : boolean;
function LoadOVStruct(filepath: string; const start, len : Integer) : boolean;
function LoadOZStruct(filepath: string; const start, len : Integer) : boolean;
function SaveDiagnoze(filename : string) : Boolean; // ��������� ��������������� ���������� ������ ���������
{$IFDEF RMSHN}
function LoadLinkDC(filepath: string) : boolean;
{$ENDIF}

implementation
uses
  TypeALL,
  Commons,
  crccalc;
var
  ps,hdr,{s,}t,k,p,v,name : string;

//------------------------------------------------------------------------------
// ����� ������ ������� � ������ �������� ������������
function FindObjZav(Liter : string) : SmallInt;
  var i : integer;
begin
  if Liter <> '' then
  begin
    i := 1;
    while i <= High(ObjZav) do
    begin
      if AnsiUpperCase(ObjZav[i].Liter) = AnsiUpperCase(Liter) then
      begin
        result := i; exit;
      end;
      inc(i);
    end;
  end;
  result := 0;
end;
//========================================================================================
//---------------------------------------------------- �������� ���������� ����� ���������
function ChekFileParams(filepath: string; cfg : TStringList) : Boolean;
var
  crc,ccrc : crc32_t;
  i,j,l : integer;
  f : boolean;
  memo : TStringList;
begin
  memo := TStringList.Create;
  try
    hdr := cfg.Strings[0];
    memo.Assign(cfg);
    memo.Delete(0);
    s := '';
    i := 1;
    j := 0;
    l := 1;
    f := false;
    while i <= Length(hdr) do
    begin
      if f then s := s + hdr[i] else
      begin
        if hdr[i] = ' ' then
        begin
          inc(j);
          if j = 3 then
          begin
            l := i-1;
            f := true;
          end;
        end;
      end;
      inc(i);
    end;
    if s <> '' then
    begin
      ccrc := StrToIntDef('$'+s,0);
      SetLength(hdr,l);
      s := hdr+ memo.Text; //---- s - �������� ������ ��� �������� ����������� ����� �����
      crc := CalculateCRC32(pchar(s),Length(s));
      if crc <> ccrc then
      reportf('�������� ����������� ����� ������ � ����� '+ filepath);
    end;
  finally
    memo.Free;
    result := true;
  end;
end;
//========================================================================================
//-------------------------------------------------- �������� ���� ������ (������) �������
function LoadBase(filepath: string) : boolean;
  var i : integer;
begin
  result := true;
  if not LoadConfig(filepath) then
  begin
    result := false;
    reportf('������ ��� �������� ����� ������������ ���� ������ �������.');
    exit;
  end;
  reportf('��������� �������� ����� ������������ ���� ������ �������.');

  for i := 1 to High(config.ozname) do
  if config.ozname[i] <> '' then
  if LoadOZStruct(config.path+config.ozname[i],config.ozstart[i],config.ozlen[i]) then
  reportf('��������� �������� ����� '+ config.path+config.ozname[i])
  else
  begin
    result := false;
    reportf('������ ��� �������� ����� '+ config.path+config.ozname[i]);
  end;

  for i := 1 to High(config.ovname) do
  if config.ovname[i] <> '' then
  if LoadOVStruct(config.path+config.ovname[i],config.ovstart[i],config.ovlen[i]) then
  reportf('��������� �������� ����� '+ config.path+config.ovname[i])
  else
  begin
    result := false;
    reportf('������ ��� �������� ����� '+ config.path+config.ovname[i]);
  end;

  for i := 1 to High(config.bvname) do
  if config.bvname[i] <> '' then
  if LoadOVBuffer(config.path+config.bvname[i],config.bvstart[i],config.bvlen[i]) then
  reportf('��������� �������� ����� '+ config.path+config.bvname[i])
  else
  begin
    result := false;
    reportf('������ ��� �������� ����� '+ config.path+config.bvname[i]);
  end;

  for i := 1 to High(config.ouname) do
  if config.ouname[i] <> '' then
  if LoadOUStruct(config.path+config.ouname[i],config.oustart[i],config.oulen[i]) then
  reportf('��������� �������� ����� '+ config.path+config.ouname[i])
  else
  begin
    result := false;
    reportf('������ ��� �������� ����� '+ config.path+config.ouname[i]);
  end;

  if not LoadLinkFR(config.path+'FR3.SDB') then
  begin
    result := false;
    reportf('������ ��� �������� ����� FR3.SDB');
  end;


  for i := 1 to Length(configRU) do
  begin
    configRU[i].OVmin := 9999; configRU[i].OVmax := 0;
    configRU[i].OUmin := 9999; configRU[i].OUmax := 0;
    configRU[i].OZmin := 9999; configRU[i].OZmax := 0;
  end;

  //---------------------------------------------------- �������� �� ������� ������� �����
  for i := 1 to Length(ObjView) do
    if (ObjView[i].TypeObj > 0) and (ObjView[i].RU > 0) then
    begin
      if i > configRU[ObjView[i].RU].OVmax then configRU[ObjView[i].RU].OVmax := i;
      if i < configRU[ObjView[i].RU].OVmin then configRU[ObjView[i].RU].OVmin := i;
    end;

  //----------------------------------------------- �������� �� ������� ������� ����������
  for i := 1 to Length(ObjUprav) do
    if ObjUprav[i].RU > 0 then
    begin
      if i > configRU[ObjUprav[i].RU].OUmax then configRU[ObjUprav[i].RU].OUmax := i;
      if i < configRU[ObjUprav[i].RU].OUmin then configRU[ObjUprav[i].RU].OUmin := i;
    end;

  //--------------------------------------------- �������� �� ������� ������� ������������
  for i := 1 to Length(ObjZav) do
    if (ObjZav[i].TypeObj > 0) and (ObjZav[i].RU > 0) then
    begin
      if i > configRU[ObjZav[i].RU].OZmax then configRU[ObjZav[i].RU].OZmax := i;
      if i < configRU[ObjZav[i].RU].OZmin then configRU[ObjZav[i].RU].OZmin := i;
    end;

  //--------------------------------------------------------------- �������� ������ ������
  for i := 1 to Length(configRU) do
  begin
    if configRU[i].OVmin = 9999 then
    begin configRU[i].OVmin := 0; configRU[i].OVmax := 0; end;

    if configRU[i].OUmin = 9999 then
    begin configRU[i].OUmin := 0; configRU[i].OUmax := 0; end;

    if configRU[i].OZmin = 9999 then
    begin configRU[i].OZmin := 0; configRU[i].OZmax := 0; end;
  end;

  //------------------------------------------------------ ���������� ����������� ��������
  WorkMode.LimitObjZav := 0;
  for i := 1 to High(configRU) do
  if configRU[i].OZmax > WorkMode.LimitObjZav then
  WorkMode.LimitObjZav := configRU[i].OZmax;

  for i := 1 to High(configRU) do
  if configRU[i].OVmax > WorkMode.LimitObjView then
  WorkMode.LimitObjView := configRU[i].OVmax;

  for i := 1 to High(configRU) do
  if configRU[i].OUmax > WorkMode.LimitObjUprav
  then WorkMode.LimitObjUprav := configRU[i].OUmax;

  reportf('��������� ���������� ���� ������ �������');
end;

//========================================================================================
//------------------------------------------------------------------ �������� ������������
function LoadConfig(filepath: string) : boolean;
var
  i, j, l, m, rup, lru : integer;
  err , key, param, val : boolean;
  memo : TStringList;
begin
  rup := 0; lru := 0; err := false; result := false;
  memo := TStringList.Create;
  try
    //------------------------------------- ��������� ������ �� ����� ������������ �������
    try
      memo.LoadFromFile(filepath);
    except
      err := true;
      result := false;
      exit;
    end;

    if memo.Count < 25 then
    begin
      err := true;
      ShowMessage('������ � ����� ������������ ������ ������� '+ filepath);
      exit;
    end;

    i := 0; key := false; param := false; k := '';

    //------------------------------------ �������� ����� �������������, ������� � �������
    while i < memo.Count do
    begin
      s := memo.Strings[i];
      if (s <> '') and (s[1] <> ';') then //------------------------ ���� ������ �� ������
      begin
        j := 1; //----------------------------- �������� �������� � ������� ������� ������
        p := '';        v := '';        val := false;
        //-- �� ������ ����������� �������� ����� ��� ��� ��������� ��� �������� ���������
        while j <= Length(s) do //-------------------- �������� ���������� ������ �� �����
        begin
          if s[j] = '[' then //----------------------------------- ���������� ������ �����
          begin  key := true; param := false; k := '';  end else
          if s[j] = ']' then //------------------ ��������� ����� �����, �������� ��������
          begin key := false; param := true; end else

          if s[j] = '=' then param := false else //------- ��������� ����� ����� ���������

          if key then k := k + s[j] //----- ���� �������� �������� �����, �� ��������� ���
          else
          if param then p := p + s[j] //------------- ���� ��� ���������, �� ��������� ���
          else
            begin v := v + s[j]; val := true; end; //------------ ����� �������� ���������
          inc(j); //----------------------------------------------------- ��������� ������
        end; //-------------------------------------------------------- ������ �����������

        //--------------------------------------------------------------------------------
        if val then //-------------------- ���� � ������ ���� ��������� �������� ���������
        begin
          if k = 'Project' then //------------------ ���� ��� ����� ��������� ���� �������
          begin
            if p = 'name' then config.name := v; // ��� ��������� "name" ����� ��� ��������
            if p = 'server' then WorkMode.ServerStateSoob := StrToIntDef(v,0);//--- ������
            if p = 'arm'  then WorkMode.DirectStateSoob := StrToIntDef(v,0); //------- ���
            if p = 'state' then WorkMode.ArmStateSoob := StrToIntDef(v,0);//---- ���������
            if p = 'limitfr' then WorkMode.LimitFRI := StrToIntDef(v,0);//����� FR3 ��-���
            if p = 'verinfo' then err := (v <> '1'); //---------------------------- ������
            if p = 'ru' then lru := StrToIntDef(v,0); //----------------- ����� ����������
            if p = 'date'    then config.date := v; //----------------- ���� �������� ����
          end else //------------------------------------ ����� ���������� ����� "Project"
          if k = 'ru' then  //------------------------- ���� �������� ��������� ����� "ru"
          begin
            if p = 'ru' then rup:= StrToIntDef(v,0);//-------- ��� "ru" ����� ��� ��������
            if p = 'TabloHeight' then //---------- ���� �������� � ���������� ������ �����
            begin
              if (rup > 0)and (rup <= lru)
              then configRU[rup].Tablo_Size.Y := StrToInt(v)
            end;
            if p = 'TabloWidth'  then //-------------------- ���� �������� � ������� �����
            begin
              if (rup > 0) and (rup <= lru)
              then configRU[rup].Tablo_Size.X := StrToInt(v)
            end;
            if p = 'MonHeight'   then //------------------- ���� �������� � ������� ������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MonSize.Y   := StrToInt(v)
            end;
            if p = 'MonWidth'    then //------------------- ���� �������� � ������� ������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MonSize.X   := StrToInt(v)
            end;
            if p = 'MsgLeft'     then //--------- ���� �������� � ����� �������� ���������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MsgLeft     := StrToInt(v)
            end;
            if p = 'MsgTop' then //------------ ���� �������� � ������� �������� ���������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MsgTop  := StrToInt(v)
            end;
            if p= 'MsgRight' then //------------ ���� �������� � ������ �������� ���������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MsgRight := StrToInt(v)
            end;
            if p = 'MsgBottom'  then //------------------- ���� �������� � ������ ��������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].MsgBottom   := StrToInt(v)
            end;
            if p = 'BoxLeft' then //-------------- ���� �������� � ����� �������� ��������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].BoxLeft     := StrToInt(v);
            end;
            if p = 'BoxTop' then//-------------- ���� �������� � ������� �������� ��������
            begin
              if (rup > 0) and (rup <= lru) then
              configRU[rup].BoxTop      := StrToInt(v)
            end;

            if p = '���������� �������' then //-- �������� � ����������� ������� �� ������
            begin
              if (rup > 0) and (rup <= lru) then
              if v = '1' then OddRight := true  //-------------- �������� ��������� ������
              else OddRight := false; //-------------------------------------------- �����
            end;

            if p = '������� ��' then //---------------- ���� ������ � ��������� ������� ��
            begin
              if (rup > 0) and (rup <= lru) then
              WorkMode.DC      := StrToInt(v);
            end;

            if p = '������� ���������' then// ���� ������ � ��������� ��������� ����������
            begin
              if (rup > 0) and (rup <= lru) then
              WorkMode.SU  := StrToInt(v)
            end;
          end
          else
          if k = 'oz' then //---------------------------------- ���� ������ � ������� "oz"
          begin
            for l := 1 to Length(p)-1 do p[l] := p[l+1];
            SetLength(p,Length(p)-1);
            try
              l := StrToInt(p);
            except
              err := true; result := false; exit;
            end;
            //-------------------------------------- �������� � ������ 1, l - ������ �����
            m := 1;
            if getstring(m,v,config.ozname[l])   then
            begin err := true; result := false; exit; end;

            if getinteger(m,v,config.ozstart[l]) then
            begin err := true; result := false; exit; end;

            if getinteger(m,v,config.ozlen[l]) then
            begin err := true; result := false; exit; end;

            if getcrc32(m,v,config.ozcrc[l]) then
            begin err := true; result := false; exit; end;
          end else
          if k = 'ov' then   //--------------------------------------- ������ � ������� OV
          begin
            for l := 1 to Length(p)-1 do p[l] := p[l+1];
            SetLength(p,Length(p)-1);
            try
              l := StrToInt(p);
            except
              err := true; result := false; exit;
            end;
            //---------------------------------------�������� � ������ 1, l - ������ �����
              m := 1;
              if getstring(m,v,config.ovname[l])   then
              begin err := true; result := false; exit; end;

              if getinteger(m,v,config.ovstart[l]) then
              begin err := true; result := false; exit; end;

              if getinteger(m,v,config.ovlen[l])   then
              begin err := true; result := false; exit; end;

              if getcrc32(m,v,config.ovcrc[l]) then
              begin err := true; result := false; exit; end;
            end
            else
            if k = 'bv' then //--------------------------------------- ������ � ������� BV
            begin
              for l := 1 to Length(p)-1 do p[l] := p[l+1];
              SetLength(p,Length(p)-1);
              try
                l := StrToInt(p);
              except
                err := true; result := false; exit;
              end;
              //------------------------------------ �������� � ������ 1, l - ������ �����
              m := 1;
              if getstring(m,v,config.bvname[l])   then
              begin err := true; result := false; exit; end;

              if getinteger(m,v,config.bvstart[l]) then
              begin err := true; result := false; exit; end;

              if getinteger(m,v,config.bvlen[l])   then
              begin err := true; result := false; exit; end;

              if getcrc32(m,v,config.bvcrc[l])     then
              begin err := true; result := false; exit; end;
            end
            else
            if k = 'ou' then //--------------------------------------- ������ � ������� OU
            begin
              for l := 1 to Length(p)-1 do p[l] := p[l+1];
              SetLength(p,Length(p)-1);
              try
                l := StrToInt(p);
              except
                err := true; result := false; exit;
              end;
              //------------------------------------ �������� � ������ 1, l - ������ �����
              m := 1;
              if getstring(m,v,config.ouname[l])   then
              begin err := true; result := false; exit; end;

            if getinteger(m,v,config.oustart[l]) then
            begin err := true; result := false; exit; end;

            if getinteger(m,v,config.oulen[l])   then
            begin err := true; result := false; exit; end;

            if getcrc32(m,v,config.oucrc[l])     then
            begin err := true; result := false; exit; end;
          end;
          param := true;
        end;
      end;
      inc(i);
    end;

  finally
    memo.Free;
    err := err or (lru < 1);
    err := err or (WorkMode.ServerStateSoob < 1);
    err := err or (WorkMode.DirectStateSoob < 1);
    result := not err;
  end;
end;

//========================================================================================
//------------------------------------- ��������� �������� ��������� �������� ������������
function LoadOZStruct(filepath: string; const start, len : Integer) : boolean;
var
  i,j,k,cLoad : integer;
  fullrecord : boolean;
  ccrc : crc16_t;
  memo : TStringList;
begin
  //-------- �������� ������������ ���������� ������������ ��������� �������� ������������
  if not ((len > 0) and ((start + len) <= Length(ObjZav))) then
  begin
    ShowMessage('������ ��� �������� ��������� �������� �������� ������������ �������');
    result := false;
    exit;
  end;
  memo := TStringList.Create;
  try
    for i := start to start + len do  //------------- �������� ����� �������� ������������
    begin
      ObjZav[i].TypeObj := 0; ObjZav[i].Group := 0; ObjZav[i].RU := 0;
      ObjZav[i].Title := ''; ObjZav[i].Liter := '';

      for j := Low(ObjZav[1].Neighbour) to High(ObjZav[i].Neighbour) do
      begin
        ObjZav[i].Neighbour[j].TypeJmp := 0; ObjZav[i].Neighbour[j].Obj := 0;
        ObjZav[i].Neighbour[j].Pin := 0;
      end;

      ObjZav[i].BaseObject := 0; ObjZav[i].UpdateObject := 0;

      for j := Low(ObjZav[1].ObjConstB) to High(ObjZav[1].ObjConstB) do
      ObjZav[i].ObjConstB[j] := false;

      for j := Low(ObjZav[1].ObjConstI) to High(ObjZav[1].ObjConstI) do
      ObjZav[i].ObjConstI[j] := 0;

      ObjZav[i].CRC1 := 0; ObjZav[i].Refresh := false;
      for j := Low(ObjZav[1].bParam) to High(ObjZav[1].bParam) do
      ObjZav[i].bParam[j] := false;

      for j := Low(ObjZav[1].iParam) to High(ObjZav[1].iParam) do
      ObjZav[i].iParam[j] := 0;

      for j := Low(ObjZav[1].Timers) to High(ObjZav[i].Timers) do
      begin
        ObjZav[i].Timers[j].Active := false;
        ObjZav[i].Timers[j].First := 0;
        ObjZav[i].Timers[j].Second := 0;
      end;

      ObjZav[i].Index := 0;
      ObjZav[i].Counter := 0;
      ObjZav[i].RodMarsh := 0;
      ObjZav[i].CRC2 := 0;
    end;

    try
      memo.LoadFromFile(filepath);
    except
      ShowMessage('������ �� ����� ������ ����� '+ filepath);
      result := false;
    end;

    cLoad := memo.Count - 1;
    if cLoad <> len then
    begin
      ShowMessage('����� �������� ������������ ��������� ' + filepath+' �� �� �������!');
      result := false;
      exit;
    end;

    //---------------------------------------- ��������� ������������ ���������� ���������
    if not ChekFileParams(filepath, memo) then
    begin
        ShowMessage('��������� ����� ��������� '+ filepath+ ' �� �� �������!');
        result := false;
        exit;
    end;

    //------------------------------------------------------------------ ��������� �������
    fullrecord := false;  //--------------------- �������� ������� ������� ������ � ������
    j := 0; //--------------------------------------------- ����������� � ������ ���������
    while j < cLoad do
    begin
      fullrecord := false;  //------------------- �������� ������� ������� ������ � ������
      s := memo.Strings[j+1]; //--------------------------------------- ������ � ���������
      i := 1; //----------------------------------------------------- ������ ������ ������

      if getbyte(i, s, ObjZav[start+j].TypeObj) then break; //-------- ������ ���� �������
      if getbyte(i, s, ObjZav[start+j].Group) then break; //---------------- ������ ������
      if getbyte(i, s, ObjZav[start+j].RU) then break; //-------- ������ ������ ����������
      if getstring(i, s, ObjZav[start+j].Title) then break; //--- ������ ��������� �������
      if getstring(i, s, ObjZav[start+j].Liter) then break; //------ ������ ������ �������

      for k := Low(ObjZav[j].Neighbour) to High(ObjZav[j].Neighbour) do
      begin
        if getbyte(i,s, ObjZav[start+j].Neighbour[k].TypeJmp) then break;// ��� ����������
        if getsmallint(i, s, ObjZav[start+j].Neighbour[k].Obj) then break; //������ ������
        if getbyte(i, s, ObjZav[start+j].Neighbour[k].Pin) then break; //---- ����� ������
      end;

      if getsmallint(i, s,ObjZav[start+j].BaseObject) then break;//������ �������� �������

      if getsmallint(i, s, ObjZav[start+j].UpdateObject) then break; //- ������ ����������

      if getsmallint(i, s, ObjZav[start+j].VBufferIndex) then break; // ������ �����������

      for k := Low(ObjZav[j].ObjConstB) to High(ObjZav[j].ObjConstB) do
      if getbool(i, s, ObjZav[start+j].ObjConstB[k]) then break; //--- ��������� ���������

      for k := Low(ObjZav[j].ObjConstI) to High(ObjZav[j].ObjConstI) do
      if getsmallint(i, s, ObjZav[start+j].ObjConstI[k]) then break; //--- ����� ���������

      p := s; SetLength(p,i-1);
      ccrc := CalculateCRC16(pchar(p),Length(p)); //----- ������� ����������� ����� ������

      if getcrc16(i, s, ObjZav[start+j].CRC1) then break; //--- ����������� ����� �� �����

      if ObjZav[start+j].CRC1 <> ccrc then
      reportf('�������� ����������� ����� � ������ '+IntToStr(start+j)+' ����� '+filepath);
      inc(j); //------------------------------------------ ����������� �� ��������� ������
      fullrecord := true;
    end;

    if not fullrecord then
    begin
      ShowMessage('������ ��c������� ���������� ��������� ����� ������������ '+ filepath);
      result := false;
      exit;
    end;
    result := true;
  finally
    memo.Free;
  end;
end;

//-----------------------------------------------------------------------------
// ��������� ��������� ���������� ��������
function LoadOVStruct(filepath: string; const start, len : Integer) : boolean;
var
  i,j,k : integer; cLoad : integer; fullrecord : boolean; ccrc : crc16_t;
  memo : TStringList;
begin
  //--------- �������� ������������ ���������� ������������ ��������� �������� �����������
  if not ((len > 0) and ((start + len) <= Length(ObjView))) then
  begin
    ShowMessage('������ ��� �������� ��������� �������� �������� �����������');
    result := false;
  end;

  memo := TStringList.Create;
  try

    for i := start to start + len-1 do  //------------ �������� ����� �������� �����������
    begin
      ObjView[i].TypeObj := 0;
      ObjView[i].RU := 0;
      ObjView[i].Layer := 0;
      ObjView[i].Title := '';
      ObjView[i].Name := '';
      for j := Low(ObjView[1].Points) to High(ObjView[i].Points) do
      begin
        ObjView[i].Points[j].X := 0;
        ObjView[i].Points[j].Y := 0;
      end;
      for j := Low(ObjView[1].ObjConstI) to High(ObjView[1].ObjConstI)
      do ObjView[i].ObjConstI[j] := 0;

      ObjView[i].CRC := 0;
      ObjView[i].Refresh := false;
    end;

    try
      memo.LoadFromFile(filepath);
    except
      ShowMessage('������ �� ����� ������ ����� '+ filepath);
      result := false;
    end;

    cLoad := memo.Count - 1;
    if cLoad <> len then
    begin
      ShowMessage('����� ������������� ��������� '+filepath+' ���������� �� �������!');
      result := false;
    end;
    //---------------------------------------- ��������� ������������ ���������� ���������
    if not ChekFileParams(filepath, memo) then
    begin
      ShowMessage('��������� ����� ��������� '+ filepath+ ' �� ������������� �������!');
      result := false;
    end;

    //------------------------------------------------------------------ ��������� �������

    fullrecord := false;  //--------------------- �������� ������� ������� ������ � ������

    j := 0; //----------------------------------- ����������� ��������� � ������ ���������

    while j < cLoad do
    begin
      fullrecord := false;  //------------------- �������� ������� ������� ������ � ������
      s := memo.Strings[j+1]; //--------------------------------------- ������ � ���������
      i := 1; //----------------------------------------------------- ������ ������ ������

      if getbyte(i, s, ObjView[start+j].TypeObj) then break; //------- ������ ���� �������
      if getbyte(i, s, ObjView[start+j].RU) then break; //------- ������ ������ ����������
      if getbyte(i, s, ObjView[start+j].Layer) then break;//������ ���� ���������� �������
      if getstring(i, s, ObjView[start+j].Title) then break; //-- ������ ��������� �������
      if getstring(i,s,ObjView[start+j].Name)  then break;  //------- ������ ����� �������
      for k := Low(ObjView[j].Points) to High(ObjView[j].Points) do
      begin
        if getinteger(i, s, ObjView[start+j].Points[k].X) then break;//������ ���������� �
        if getinteger(i, s, ObjView[start+j].Points[k].Y) then break;//������ ���������� �
      end;

      //--------------------------------------------------- ������ ����� �������� ��������
      for k := Low(ObjView[j].ObjConstI) to High(ObjView[j].ObjConstI) do
      if getsmallint(i, s, ObjView[start+j].ObjConstI[k]) then break;

      p := s; SetLength(p,i-1); ccrc := CalculateCRC16(pchar(p),Length(p));
      if getcrc16(i, s, ObjView[start+j].CRC) then break; // KS ����������� ����� ��������

      if ObjView[start+j].CRC <> ccrc then
      begin
        reportf('�������� �����. ����� ������ '+ IntToStr(start+j)+ ' ����� '+ filepath);
      end;
      inc(j); //------------------------------------------ ����������� �� ��������� ������
      fullrecord := true;
    end;

    if not fullrecord then
    begin
      ShowMessage('������ ��c������� ������ ��������� �������� ������������ '+filepath);
      result := false;
    end;

    result := true;
  finally
    memo.Free;
  end;
end;

//----------------------------------------------------------------------------------------
//----------------------------------------- ��������� ��������� ������ ���������� ��������
function LoadOVBuffer(filepath: string; const start, len : Integer) : boolean;
var
  cLoad,i,j : integer;
  fullrecord : boolean;
  ccrc : crc16_t;
  memo : TStringList;
begin
  //--------- �������� ������������ ���������� ������������ ��������� �������� �����������
  if not ((len > 0) and ((start + len) <= Length(ObjView))) then
  begin
    ShowMessage('������ ��� �������� ��������� �������� ������ �������� �����������');
    result := false;
  end;
  memo := TStringList.Create;

  try
    for i := start to start + len do  //-------------- �������� ����� �������� �����������
    begin
      OVBuffer[i].TypeRec := 0;
      OVBuffer[i].Jmp1 := 0;
      OVBuffer[i].Jmp2 := 0;
      OVBuffer[i].DZ1 := 0;
      OVBuffer[i].DZ2 := 0;
      OVBuffer[i].DZ3 := 0;
      OVBuffer[i].Steps := 0;
      OVBuffer[i].CRC := 0;
    end;

    try
      memo.LoadFromFile(filepath);
    except
      ShowMessage('������ �� ����� ������ ����� '+ filepath);
      result := false;
      exit;
    end;

    cLoad := memo.Count - 1;
    if cLoad <> len then begin ShowMessage('���������� ������� �������� ����������� ��������� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;
    // ��������� ������������ ���������� ���������
    if not ChekFileParams(filepath, memo) then begin ShowMessage('��������� ����� ��������� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� �������

    fullrecord := false;  // �������� ������� ������� ������ � ������
    j := 0; // ����������� � ������ ���������
    while j < cLoad do
    begin
      fullrecord := false;  // �������� ������� ������� ������ � ������
      s := memo.Strings[j+1]; // ������ � ���������
      i := 1; // ������ ������ ������

      if getbyte(i, s, OVBuffer[start+j].TypeRec) then break;  //������ ���� ����
      if getsmallint(i, s, OVBuffer[start+j].Jmp1) then break; //������ ���������� ��������
      if getsmallint(i, s, OVBuffer[start+j].Jmp2) then break; //������ ���������� ��������
      if getsmallint(i, s, OVBuffer[start+j].DZ1) then break;  //������ ������1
      if getsmallint(i, s, OVBuffer[start+j].DZ2) then break;  //������ ������2
      if getsmallint(i, s, OVBuffer[start+j].DZ3) then break;  //������ ������3
      if getsmallint(i, s, OVBuffer[start+j].Steps) then break;  //������ ����������� �����
      p := s; SetLength(p,i-1); ccrc := CalculateCRC16(pchar(p),Length(p));
      if getcrc16(i, s, OVBuffer[start+j].CRC) then break;      //������ ����������� ����� ����������� ����� �������� ������
      if OVBuffer[start+j].CRC <> ccrc then begin reportf('�������� ����������� ����� � ������ '+ IntToStr(start+j)+ ' ����� '+ filepath); end;
      inc(j); // ����������� �� ��������� ������
      fullrecord := true;
    end;

    if not fullrecord then begin ShowMessage('������ ��� ��c������� ���������� ��������� '+ filepath); result := false; exit; end;
    result := true;
  finally
    memo.Free;
  end;
end;

//========================================================================================
//----------------------------------------------------------- ��������� ������� ����������
//----------------------------- filepath - ��� ����� ��������� ���������� � ��������� ����
//-------------- start - ������, � �������� ���������, ������ ������� ��������� ����������
//------------------------------------- len - ����� �������� ���������� � ������ ���������
//----------------- ���������� .T. - ���� �������� ��������� �������, ����� ���������� .F.
function LoadOUStruct(filepath: string; const start, len : Integer) : boolean;
var
  i,j,k,cLoad : integer;
  fullrecord : boolean;
  ccrc : crc16_t;
  memo : TStringList;
begin
  fullrecord := false;
  //----------- �������� ������������ �������� ������������ ��������� �������� �����������
  if not ((len > 0) and ((start + len) <= Length(ObjUprav))) then
  begin
    ShowMessage('������ ��� �������� ��������� �������� �������� ����������');
    result := false;
    exit;
  end;
  memo := TStringList.Create;

  try
    for i := start to start + len do  //--------------- �������� ����� �������� ����������
    begin
      ObjUprav[i].RU         := 0;
      ObjUprav[i].IndexObj   := 0;
      ObjUprav[i].Title      := '';
      ObjUprav[i].MenuID     := 0;
      ObjUprav[i].Box.Left   := 0;
      ObjUprav[i].Box.Right  := 0;
      ObjUprav[i].Box.Top    := 0;
      ObjUprav[i].Box.Bottom := 0;
      for j := Low(ObjUprav[1].Neighbour) to High(ObjUprav[i].Neighbour) do
      ObjUprav[i].Neighbour[j] := 0;

      ObjUprav[i].Hint := '';
      ObjUprav[i].CRC  := 0;
    end;

    try
      memo.LoadFromFile(filepath);
    except
      ShowMessage('������ �� ����� ������ ����� '+ filepath);
      result := false;
      exit;
    end;

    cLoad := memo.Count - 1;
    if cLoad <> len then
    begin
      ShowMessage('����� �������� ���������� ��������� '+ filepath+ ' �� �� �������!');
      result := false;
      exit;
    end;

    //---------------------------------------- ��������� ������������ ���������� ���������
    if not ChekFileParams(filepath, memo) then
    begin
      ShowMessage('��������� ����� ��������� '+ filepath+ ' �� ������������� �������!');
      result := false;
      exit;
    end;

    //------------------------------------------------------------------ ��������� �������
    j := 0; //--------------------------------------------- ����������� � ������ ���������
    while j < cLoad do
    begin
      fullrecord := false;  //------------------- �������� ������� ������� ������ � ������
      s := memo.Strings[j+1]; //----------------------- ����� ��������� ������ � ���������
      i := 1; //----------------------------------------------------- ������ ������ ������

      if getbyte(i,s,ObjUprav[start+j].RU) then break; //- ������ ������ ������ ����������
      if getsmallint(i,s,ObjUprav[start+j].IndexObj) then break;//- ������ ������� �������
      if getstring(i,s,ObjUprav[start+j].Title) then break;//---- ������ ��������� �������
      if getsmallint(i,s,ObjUprav[start+j].MenuID) then break;//- ������ ������������ ����
      if getinteger(i,s,ObjUprav[start+j].Box.Left) then break;//------ ������ ������� ...
      if getinteger(i,s,ObjUprav[start+j].Box.Top) then break; //.........................
      if getinteger(i,s,ObjUprav[start+j].Box.Right) then break; //.......................
      if getinteger(i,s,ObjUprav[start+j].Box.Bottom) then break;//...... ����������������

      for k := Low(ObjUprav[j].Neighbour) to High(ObjUprav[j].Neighbour) do
      if getsmallint(i,s,ObjUprav[start+j].Neighbour[k]) then break; //---- ������ �������

      if getstring(i,s,ObjUprav[start+j].Hint) then break;//- ������ ������������ ��������
      p := s; SetLength(p,i-1); //------- ���������� ������ "�" ��������� ��� ������������
      ccrc := CalculateCRC16(pchar(p),Length(p));//----------- ��������� ����������� �����

      if getcrc16(i,s,ObjUprav[start+j].CRC) then break; //--- ������ �� ����������� �����
      if ObjUprav[start+j].CRC <> ccrc then
      reportf('�������� �����.����� � ������ '+ IntToStr(start+j)+ ' ����� '+ filepath);
      inc(j); //------------------------------------------ ����������� �� ��������� ������
      fullrecord := true;
    end;

    if not fullrecord then
    begin
      ShowMessage('������ ��c������� ���������� ��������� �������� ���������� '+filepath);
      result := false;
      exit;
    end;
    result := true;
  finally
    memo.Free;
  end;
end;
//------------------------------------------------------------------------------
//
function CalcCRC_OZ(Index : Integer) : boolean;
  var i : integer; ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(ObjZav)) then
  begin
    s := IntToStr(ObjZav[Index].TypeObj)+ ';'+
         IntToStr(ObjZav[Index].Group)+ ';'+
         IntToStr(ObjZav[Index].RU)+ ';'+
         ObjZav[Index].Title+';'+
         ObjZav[Index].Liter+';'+
         IntToStr(ObjZav[Index].Neighbour[1].TypeJmp)+ ':'+ IntToStr(ObjZav[Index].Neighbour[1].Obj)+ ':'+ IntToStr(ObjZav[Index].Neighbour[1].Pin)+ ';'+
         IntToStr(ObjZav[Index].Neighbour[2].TypeJmp)+ ':'+ IntToStr(ObjZav[Index].Neighbour[2].Obj)+ ':'+ IntToStr(ObjZav[Index].Neighbour[2].Pin)+ ';'+
         IntToStr(ObjZav[Index].Neighbour[3].TypeJmp)+ ':'+ IntToStr(ObjZav[Index].Neighbour[3].Obj)+ ':'+ IntToStr(ObjZav[Index].Neighbour[3].Pin)+ ';'+
         IntToStr(ObjZav[Index].BaseObject)+ ';'+
         IntToStr(ObjZav[Index].UpdateObject)+ ';'+
         IntToStr(ObjZav[Index].VBufferIndex)+ ';';
    for i := 1 to High(ObjZav[Index].ObjConstB) do if ObjZav[Index].ObjConstB[i] then s := s + 't;' else s := s + ';';
    for i := 1 to High(ObjZav[Index].ObjConstI) do s := s + IntToStr(ObjZav[Index].ObjConstI[i])+ ';';
    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = ObjZav[Index].CRC1;
    exit;
  end;
  result := true;
end;

//------------------------------------------------------------------------------
//
function CalcCRC_OV(Index : Integer) : boolean;
  var ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(ObjView)) then
  begin
    s := IntToStr(ObjView[Index].TypeObj)+ ';'+
         IntToStr(ObjView[Index].RU)+ ';'+
         IntToStr(ObjView[Index].Layer)+ ';'+
         ObjView[Index].Title+';'+
         ObjView[Index].Name+';'+
         IntToStr(ObjView[Index].Points[1].X)+ ':'+ IntToStr(ObjView[Index].Points[1].Y)+ ';'+
         IntToStr(ObjView[Index].Points[2].X)+ ':'+ IntToStr(ObjView[Index].Points[2].Y)+ ';'+
         IntToStr(ObjView[Index].Points[3].X)+ ':'+ IntToStr(ObjView[Index].Points[3].Y)+ ';'+
         IntToStr(ObjView[Index].Points[4].X)+ ':'+ IntToStr(ObjView[Index].Points[4].Y)+ ';'+
         IntToStr(ObjView[Index].Points[5].X)+ ':'+ IntToStr(ObjView[Index].Points[5].Y)+ ';'+
         IntToStr(ObjView[Index].Points[6].X)+ ':'+ IntToStr(ObjView[Index].Points[6].Y)+ ';'+
         IntToStr(ObjView[Index].ObjConstI[1])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[2])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[3])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[4])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[5])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[6])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[7])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[8])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[9])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[10])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[11])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[12])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[13])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[14])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[15])+ ';'+
         IntToStr(ObjView[Index].ObjConstI[16])+ ';';

    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = ObjView[Index].CRC;
    exit;
  end;
  result := true;
end;

//========================================================================================
//
function CalcCRC_OU(Index : Integer) : boolean;
  var ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(ObjUprav)) then
  begin
    s := IntToStr(ObjUprav[Index].RU)+ ','+
         IntToStr(ObjUprav[Index].IndexObj)+ ';'+
         ObjUprav[Index].Title+';'+
         IntToStr(ObjUprav[Index].MenuID)+ ';'+
         IntToStr(ObjUprav[Index].Box.Left)+ ':'+ IntToStr(ObjUprav[Index].Box.Top)+ ':'+
         IntToStr(ObjUprav[Index].Box.Right)+ ':'+ IntToStr(ObjUprav[Index].Box.Bottom)+ ';'+
         IntToStr(ObjUprav[Index].Neighbour[1])+ ';'+
         IntToStr(ObjUprav[Index].Neighbour[2])+ ';'+
         IntToStr(ObjUprav[Index].Neighbour[3])+ ';'+
         IntToStr(ObjUprav[Index].Neighbour[4])+ ';'+
         ObjUprav[Index].Hint+';';
    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = ObjUprav[Index].CRC;
    exit;
  end;
  result := true;
end;

//------------------------------------------------------------------------------
//
function CalcCRC_VB(Index : Integer) : boolean;
  var ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(OVBuffer)) then
  begin
    s := IntToStr(OVBuffer[Index].TypeRec)+ ';'+
         IntToStr(OVBuffer[Index].Jmp1)+ ';'+
         IntToStr(OVBuffer[Index].Jmp2)+ ';'+
         IntToStr(OVBuffer[Index].DZ1)+ ';'+
         IntToStr(OVBuffer[Index].DZ2)+ ';'+
         IntToStr(OVBuffer[Index].DZ3)+ ';'+
         IntToStr(OVBuffer[Index].Steps)+ ';';
    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = OVBuffer[Index].CRC;
    exit;
  end;
  result := true;
end;

//------------------------------------------------------------------------------
// �������� �������� ��������� ��-���
function LoadLex(filepath: string) : boolean;
  var memo : TStringList; i,j : integer; c : string; cl : boolean;
begin
  memo := TStringList.Create;
  try
    try
      memo.LoadFromFile(filepath);
    except
      reportf('������ �� ����� ������ ����� '+ filepath);
      result := false;
      exit;
    end;

    if (memo.Count = 0) or (memo.Count > high(Lex)) then begin reportf('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex[i].msg := ''; Lex[i].Color := GetColor(0); c := ''; cl := false;
      j := 1;
      while j <= Length(s) do
      begin
        if s[j] = '#' then
        begin
        // ��������� ������� ��������� �����
          cl := true;
        end else
        if cl then
        begin
        // ������ ���� �����
          if (s[j] < '0') or (s[j] > '9') then
          begin
            j := StrToInt(c);
            case j of
              2 :  Lex[i].Color := GetColor(2);
              4 :  Lex[i].Color := GetColor(1);
              14 : Lex[i].Color := GetColor(7);
            else
              Lex[i].Color := GetColor(0);
            end;
            break; // ��������� ������ ��������� � Lex
          end else
            c := c + s[j];
        end else
        // ������������ ��������� ������
          Lex[i].msg := Lex[i].msg + s[j];
        inc(j);
      end;
    end;

    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

//------------------------------------------------------------------------------
// �������� ��������� ��-��� � ������������� � ��������������
function LoadLex2(filepath: string) : boolean;
  var memo : TStringList; i,j : integer; c : string; cl : boolean;
begin
  memo := TStringList.Create;
  try
    try memo.LoadFromFile(filepath); except reportf('������ �� ����� ������ ����� '+ filepath); result := false; exit; end;

    if (memo.Count = 0) or (memo.Count > High(Lex2)) then begin reportf('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex2[i].msg := ''; Lex2[i].Color := GetColor(0); c := ''; cl := false;
      j := 1;
      while j <= Length(s) do
      begin
        if s[j] = '#' then
        begin
        // ��������� ������� ��������� �����
          cl := true;
        end else
        if cl then
        begin
        // ������ ���� �����
          if (s[j] < '0') or (s[j] > '9') then
          begin
            j := StrToInt(c);
            case j of
              2 :  Lex2[i].Color := GetColor(2);
              4 :  Lex2[i].Color := GetColor(1);
              14 : Lex2[i].Color := GetColor(7);
            else
              Lex2[i].Color := GetColor(0);
            end;
            break; // ��������� ������ ��������� � Lex
          end else
            c := c + s[j];
        end else
        // ������������ ��������� ������
          Lex2[i].msg := Lex2[i].msg + s[j];
        inc(j);
      end;
    end;

    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

//------------------------------------------------------------------------------
// �������� ��������� ��-��� � ������������� � ��������������
function LoadLex3(filepath: string) : boolean;
  var memo : TStringList; i,j : integer; c : string; cl : boolean;
begin
  memo := TStringList.Create;
  try
    try memo.LoadFromFile(filepath); except reportf('������ �� ����� ������ ����� '+ filepath); result := false; exit; end;

    if (memo.Count = 0) or (memo.Count > High(Lex3)) then begin reportf('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex3[i].msg := ''; Lex3[i].Color := GetColor(0); c := ''; cl := false;
      j := 1;
      while j <= Length(s) do
      begin
        if s[j] = '#' then
        begin
        // ��������� ������� ��������� �����
          cl := true;
        end else
        if cl then
        begin
        // ������ ���� �����
          if (s[j] < '0') or (s[j] > '9') then
          begin
            j := StrToInt(c);
            case j of
              2 :  Lex3[i].Color := GetColor(2);
              4 :  Lex3[i].Color := GetColor(1);
              14 : Lex3[i].Color := GetColor(7);
            else
              Lex3[i].Color := GetColor(0);
            end;
            break; // ��������� ������ ��������� � Lex
          end else
            c := c + s[j];
        end else
        // ������������ ��������� ������
          Lex3[i].msg := Lex3[i].msg + s[j];
        inc(j);
      end;
    end;

    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

//------------------------------------------------------------------------------
// �������� ����
function LoadAKNR(filepath: string) : boolean;
  var memo : TStringList; i,j,k : integer; ccrc : crc16_t; fullrecord : boolean;
begin
  for i := 1 to High(AKNR) do
  begin
    AKNR[i].ObjStart := 0;
    AKNR[i].ObjEnd := 0;
    for j := 1  to High(AKNR[i].ObjAuto) do AKNR[i].ObjAuto[j] := 0;
    AKNR[i].Crc := 0;
  end;

  memo := TStringList.Create;
  try
    try memo.LoadFromFile(filepath); except reportf('������ �� ����� ������ ����� '+ filepath); result := false; exit; end;

    if memo.Count > High(AKNR) then begin reportf('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    if memo.Count > 0 then
    begin
      fullrecord := false;

      // ��������� ��������� ����
      for j := 1 to memo.Count do
      begin
        fullrecord := false;  // �������� ������� ������� ������ � ������
        s := memo.Strings[j-1]; // ������ � ���������
        i := 1; // ������ ������ ������
        if getstring(i, s, p) then break;        //������ ������
        AKNR[j].ObjStart := FindObjZav(p);
        if getstring(i, s, p) then break;          //������ �����
        AKNR[j].ObjEnd := FindObjZav(p);
        for k := Low(AKNR[j].ObjAuto) to High(AKNR[j].ObjAuto) do
        begin
          if getstring(i, s, p) then break;       //������ ������������� �����
          AKNR[j].ObjAuto[k] := FindObjZav(p);
        end;
        p := s; SetLength(p,i-1); ccrc := CalculateCRC16(pchar(p),Length(p));
        if getcrc16(i, s, AKNR[j].CRC) then break; //������ ����������� �����
        if AKNR[j].CRC <> ccrc then
        begin
          reportf('�������� ����������� ����� � ������ '+ IntToStr(j)+ ' ����� '+ filepath);
        end;
        fullrecord := true;
      end;

      if not fullrecord then begin reportf('������ ��� �������� �� ����� '+ filepath); result := false; exit; end;

      reportf('��������� �������� ����� '+ filepath);
      result := true;
    end else
      result := true;
  finally
    memo.Free;
  end;
end;

//------------------------------------------------------------------------------
// �������� ��������� �� ��������� ��������� �������� � �.�.
function LoadMsg(filepath: string) : boolean;
var
  i : integer;
  memo : TStringList;
begin
  memo := TStringList.Create;
  try
    try
      memo.LoadFromFile(filepath);
    except
      reportf('������ �� ����� ������ ����� '+ filepath); result := false; exit;
    end;

    if memo.Count > High(MsgList) then
    begin reportf('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do MsgList[i] := memo.Strings[i-1];

    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

//========================================================================================
//---------------------------------- ��������� ��������������� ���������� ������ ���������
function SaveDiagnoze(filename : string) : Boolean;
var
  sl : TStringList;
  i,j : integer;
begin
  sl := TStringList.Create;
  try
    DateTimeToString(s,'hh:mm:ss dd/nn/yy', LastTime);
    sl.Add(s);
    for i := 1 to High(ObjZav) do
    case ObjZav[i].TypeObj of
      1,3,4,5 :
      begin //----- ������� ���� �������� ������������, ��� ������� ����������� ����������
        p := IntToHex(ObjZav[i].TypeObj,2)+ ObjZav[i].Title+ '$';

        for j := 1 to 7 do
        begin
          if ObjZav[i].dtParam[j] > 0 then
          begin
            t := FloatToStrF(ObjZav[i].dtParam[j],ffGeneral,15,7);
            p := p + t + ';';
          end
          else  p := p + '0;';
        end;

        for j := 1 to 32 do
        if ObjZav[i].sbParam[j] then  p := p + 't'
        else  p := p + 'f';

        p := p + ';';

        for j := 1 to 10 do
        p := p + IntToStr(ObjZav[i].siParam[j])+ ';';

        sl.Add(p);
      end;
    end;
    sl.SaveToFile(filename);
  except
    reportf('������ SaveDiagnoze');
  end;
  sl.Free;
  result := true;
end;

//========================================================================================
//---------------------------------- ��������� ��������������� ���������� ������ ���������
function LoadDiagnoze(filename : string) : Integer;
var
  sl : TStringList;
  i,j,k,tobj,index : integer;
begin
  sl := TStringList.Create;
  try
    if FileExists(filename) then sl.LoadFromFile(filename) else
    begin
      sl.Free;
      reportf('���� ���������� ��������� �������� '+ filename+ ' �� ���������.');
      result := -1;
      exit;
    end;
    for i := 1 to sl.Count-1 do
    begin
      s := sl.Strings[i];
      if s <> '' then
      begin
        p := s[1]+s[2]; tobj := StrToIntDef('$'+p,0);
        j := 3; name := '';
        while ((j <= Length(s)) and (s[j] <> '$')) do
        begin name := name + s[j]; inc(j); end;
        inc(j);

        for index := 1 to High(ObjZav) do
        begin
          if (ObjZav[index].TypeObj = tobj) and (ObjZav[index].Title = name) then
          begin //------------------------------ ���������� ���������� ��� ������� �������
            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;

            if p <> '' then ObjZav[index].dtParam[1] := StrToFloat(p)
            else ObjZav[index].dtParam[1] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[2] := StrToFloat(p)
            else ObjZav[index].dtParam[2] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[3] := StrToFloat(p)
            else ObjZav[index].dtParam[3] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[4] := StrToFloat(p)
            else ObjZav[index].dtParam[4] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[5] := StrToFloat(p)
            else ObjZav[index].dtParam[5] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[6] := StrToFloat(p)
            else ObjZav[index].dtParam[4] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZav[index].dtParam[7] := StrToFloat(p)
            else ObjZav[index].dtParam[5] :=0;
            inc(j);

            k := 1;
            while ((j <= Length(s)) and (k <= High(ObjZav[1].sbParam))) do
            begin ObjZav[index].sbParam[k] := (s[j] = 't'); inc(j); inc(k); end;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[1] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[2] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[3] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[4] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[5] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[6] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[7] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[8] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[9] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZav[index].siParam[10] := StrToIntDef(p,0);
            break;
          end;
        end;
      end;
    end;
  finally
    result := sl.Count;
    sl.Free;
  end;
end;

//========================================================================================
//----------------------------------------------------- �������� ������ �������� � �������
function LoadLinkFR(filepath: string) : boolean;
var
  i,j,k,l : integer;
  p : string;
  memo : TStringList;
begin
  memo := TStringList.Create;
  try
    try
      memo.LoadFromFile(filepath);
    except
      reportf('������ �� ����� ������ ����� '+ filepath);
      result := false;
      memo.Free;
      exit;
    end;

    if memo.Count > High(LinkFR3) then
    begin
      reportf('��������� ����� '+ filepath+ ' �� ������������� �������!');
      result := false;
      memo.Free;
      exit;
    end;

    k := 0;
    //------------------------------------------------ ��������� ��������� ������ ��������
    i := 1;
    while(i < memo.Count) do
    begin
      s:= memo.Strings[i-1]; j := 1; p := ''; //--------- ����� ��������� ������ �� ������
      l := Length(s);
      while j < l  do
      begin
        if s[j] =';' then break;
        p := p + s[j];
        inc(j);
      end;
      try
        k := StrToIntDef(p,0);
        LinkFR[k].FR3 := k;
      except
        memo.Free;
        reportf('������ ��� �������� '+ filepath);
        result := false;
        exit;
      end;

      inc(j);
      p := '';
      while j < l do
      begin
        if s[j] = ';' then break;
        p := p + s[j];
        inc(j);
      end;
      LinkFR[k].Name := p;
      p  := '';
      inc(i);
    end;

    WorkMode.LimitNameFRI := memo.Count-1;
    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

{$IFDEF RMSHN}
//========================================================================================
//----------------------------------------------------- �������� ������ �������� � �������
function LoadLinkDC(filepath: string) : boolean;
var
  i,j,k : integer;
  memo : TStringList;
begin
  memo := TStringList.Create;

  try
    memo.LoadFromFile(filepath);
  except
    reportf('������ �� ����� ������ ����� '+ filepath);
    result := false;
    memo.Free;
    exit;
  end;

  try
    if memo.Count > High(LinkTCDC) then
    begin
      reportf('��������� ����� '+ filepath+ ' �� ������������� �������!');
      result := false;
      memo.Free;
      exit;
    end;

    //------------------------------------------------ ��������� ��������� ������ ��������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1]; j := 1;
      p := '';
      while ((j <= Length(s)) and (s[j] <> ';')) do begin p := p + s[j]; inc(j); end;
      LinkTCDC[i].Group := p[1];
      inc(j);

      p := '';
      while ((j <= Length(s)) and (s[j] <> ';')) do begin p := p + s[j]; inc(j); end;
      LinkTCDC[i].SGroup := char(StrToIntDef(p,0));
      inc(j);

      for k := 1 to 25 do
      begin
        p := '';
        while ((j <= Length(s)) and (s[j] <> ':')) do begin p := p + s[j]; inc(j); end;
        LinkTCDC[i].Name[k] := p; inc(j); p := '';
        while ((j <= Length(s)) and (s[j] <> ';')) do begin p := p + s[j]; inc(j); end;
        LinkTCDC[i].Index[k] := StrToIntDef(p,0); inc(j);
      end;
    end;

    WorkMode.LimitSoobDC := memo.Count;
    reportf('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;
{$ENDIF}
//========================================================================================
//----------------------------------------------- �������� ������� MYTHX-�������� �� �����
function GetMYTHX : Byte;
var
  i,j : integer;
begin
  j := 0;
  for i := 1 to High(ObjZav) do   //----------------- ������ �� ���� �������� ������������
    if ObjZav[i].TypeObj = 37 then //----------------------- ���� ����� �� ������ ���-����
    begin
      if ObjZav[i].ObjConstI[8] > 0 then //----------------------- ���� ������������ MYTHX
      begin
        inc(j);
        if j <= High(MYT)
        then MYT[j] := ObjZav[i].ObjConstI[8] div 8
        else break;
      end;
    end;
  GetMYTHX := j;
end;

end.
