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
  ps,hdr,t,k,p,v,name : string;

//========================================================================================
//-------------------- ����� ������ ������� � ������ �������� ������������ �� ��� ��������
function FindObjZav(Liter : string) : SmallInt;
var
  i : integer;
begin
  if Liter <> '' then
  begin
    i := 1;
    while i <= High(ObjZv) do
    begin
      if AnsiUpperCase(ObjZv[i].Liter) = AnsiUpperCase(Liter)
      then  begin result := i; exit; end;
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
      RepF('�������� ����������� ����� ������ � ����� '+ filepath);
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
    RepF('������ ��� �������� ����� ������������ ���� ������ �������.');
    exit;
  end;
  RepF('��������� �������� ����� ������������ ���� ������ �������.');

  for i := 1 to High(config.ozname) do
  if config.ozname[i] <> '' then
  if LoadOZStruct(config.path+config.ozname[i],config.ozstart[i],config.ozlen[i]) then
  RepF('��������� �������� ����� '+ config.path+config.ozname[i])
  else
  begin
    result := false;
    RepF('������ ��� �������� ����� '+ config.path+config.ozname[i]);
  end;

  for i := 1 to High(config.ovname) do
  if config.ovname[i] <> '' then
  if LoadOVStruct(config.path+config.ovname[i],config.ovstart[i],config.ovlen[i]) then
  RepF('��������� �������� ����� '+ config.path+config.ovname[i])
  else
  begin
    result := false;
    RepF('������ ��� �������� ����� '+ config.path+config.ovname[i]);
  end;

  for i := 1 to High(config.bvname) do
  if config.bvname[i] <> '' then
  if LoadOVBuffer(config.path+config.bvname[i],config.bvstart[i],config.bvlen[i]) then
  RepF('��������� �������� ����� '+ config.path+config.bvname[i])
  else
  begin
    result := false;
    RepF('������ ��� �������� ����� '+ config.path+config.bvname[i]);
  end;

  for i := 1 to High(config.ouname) do
  if config.ouname[i] <> '' then
  if LoadOUStruct(config.path+config.ouname[i],config.oustart[i],config.oulen[i]) then
  RepF('��������� �������� ����� '+ config.path+config.ouname[i])
  else
  begin
    result := false;
    RepF('������ ��� �������� ����� '+ config.path+config.ouname[i]);
  end;

  if not LoadLinkFR(config.path+'FR3.SDB') then
  begin
    result := false;
    RepF('������ ��� �������� ����� FR3.SDB');
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
  for i := 1 to Length(ObjZv) do
    if (ObjZv[i].TypeObj > 0) and (ObjZv[i].RU > 0) then
    begin
      if i > configRU[ObjZv[i].RU].OZmax then configRU[ObjZv[i].RU].OZmax := i;
      if i < configRU[ObjZv[i].RU].OZmin then configRU[ObjZv[i].RU].OZmin := i;
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

  RepF('��������� ���������� ���� ������ �������');
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
    memo.LoadFromFile(filepath);
    if memo.Count < 25 then
    begin  err := true; ShowMessage('������ � ����� ������������ '+ filepath); exit; end;

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
          begin v := v + s[j]; val := true; end; //-------------- ����� �������� ���������
          inc(j); //----------------------------------------------------- ��������� ������
        end; //-------------------------------------------------------- ������ �����������

        //--------------------------------------------------------------------------------
        if val then //-------------------- ���� � ������ ���� ��������� �������� ���������
        begin
          if k = 'Project' then //------------------ ���� ��� ����� ��������� ���� �������
          begin
            if p = 'name' then config.name := v;// ��� ��������� "name" ����� ��� ��������
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

            if (rup > 0) and (rup <= lru) then
            begin
              //----------------------------------------------  ������ � ����������� �����
              if (p = 'TabloHeight') then configRU[rup].T_S.Y := StrToInt(v);
              if p = 'TabloWidth' then configRU[rup].T_S.X := StrToInt(v);

              //------------------------------------------------------- �������� � �������
              if (p = 'MonHeight') then configRU[rup].MonSize.Y:=StrToInt(v);
              if (p = 'MonWidth') then configRU[rup].MonSize.X   := StrToInt(v);

              //------------------------------------------------  ������ � ����� ���������
              if (p = 'MsgLeft') then configRU[rup].MsgLeft := StrToInt(v);
              if p = 'MsgTop' then configRU[rup].MsgTop := StrToInt(v);
              if p = 'MsgRight' then  configRU[rup].MsgRight := StrToInt(v);
              if p = 'MsgBottom' then configRU[rup].MsgBottom := StrToInt(v);

              //----------------------------------------------- ������ � �������� ��������
              if p = 'BoxLeft' then  configRU[rup].BoxLeft := StrToInt(v);
              if p = 'BoxTop' then configRU[rup].BoxTop := StrToInt(v);

               //-------------------------------- �������� � ����������� ������� �� ������
              if p = '���������� �������' then
              if v = '1' then OddRight := true  //-------------- �������� ��������� ������
              else OddRight := false; //-------------------------------------------- �����

              //--------------------------------------- ���� ������ � ��������� ������� ��
              if p = '������� ��' then WorkMode.DC := StrToInt(v);

              //----------------------------- ���� ������ � ��������� ��������� ����������
              if p = '������� ���������' then WorkMode.SU  := StrToInt(v);
            end;
          end else
          if k = 'oz' then //---------------------------------- ���� ������ � ������� "oz"
          begin
            for l := 1 to Length(p)-1 do p[l] := p[l+1];
            SetLength(p,Length(p)-1); l := StrToInt(p);
            //-------------------------------------- �������� � ������ 1, l - ������ �����
            m := 1;
            if not getstring(m,v,config.ozname[l]) then begin err:=true;result:=false;exit;end;

            if getinteger(m,v,config.ozstart[l]) then begin err := true; result := false; exit; end;

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
              if not getstring(m,v,config.ovname[l])   then
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
              SetLength(p,Length(p)-1);  l := StrToInt(p);
              //------------------------------------ �������� � ������ 1, l - ������ �����
              m := 1;
              if not getstring(m,v,config.bvname[l])then begin err:=true;result:=false;exit;end;

              if getinteger(m,v,config.bvstart[l]) then
              begin err := true; result := false; exit; end;

              if getinteger(m,v,config.bvlen[l]) then begin err:=true;result:=false;exit; end;

              if getcrc32(m,v,config.bvcrc[l]) then begin err:=true;result:=false;exit;end;
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
              if not getstring(m,v,config.ouname[l])   then
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
  if not ((len > 0) and ((start + len) <= Length(ObjZv))) then
  begin  ShowMessage('������ �������� �������� ������������'); result := false; exit; end;

  memo := TStringList.Create;

  for i := start to start + len do  //--------------- �������� ����� �������� ������������
  with ObjZv[i] do
  begin
    TypeObj := 0; Group := 0; RU := 0; Title := ''; Liter := '';
    for j := 1 to High(Sosed) do
    begin Sosed[j].TypeJmp := 0; Sosed[j].Obj := 0; Sosed[j].Pin := 0; end;
    BasOb := 0; UpdOb := 0;
    for j := 1 to High(ObCB) do ObCB[j] := false;
    for j := 1 to High(ObCI) do ObCI[j] := 0;
    CRC1 := 0; Refresh := false;
    for j := 1 to High(bP) do bP[j] := false;
    for j := 1 to High(iP) do iP[j] := 0;
    for j := 1 to High(T) do begin T[j].Activ := false; T[j].F := 0; T[j].S:= 0; end;
    Index := 0; Counter := 0; RodMarsh := 0;
  end;

  try  memo.LoadFromFile(filepath);
  except
    ShowMessage('������ �� ����� ������ ����� '+ filepath); result := false;
  end;

  cLoad := memo.Count - 1;
  if cLoad <> len then
  begin
    ShowMessage('����� �������� ������������ � ' + filepath+' �� �� �������!');
    result := false;
    memo.Free;
    exit;
  end;

  //------------------------------------------ ��������� ������������ ���������� ���������
  if not ChekFileParams(filepath, memo) then
  begin
    ShowMessage('��������� ����� '+ filepath+ ' �� �� �������!');
    result := false;
    memo.Free;
    exit;
  end;

  //-------------------------------------------------------------------- ��������� �������
  fullrecord := false;  //----------------------- �������� ������� ������� ������ � ������

  j := 0; //----------------------------------------------- ����������� � ������ ���������
  while j < cLoad do
  begin
    fullrecord := false;  //--------------------- �������� ������� ������� ������ � ������
    s := memo.Strings[j+1]; //----------------------------------------- ������ � ���������
    i := 1; //------------------------------------------------------- ������ ������ ������

    if getbyte(i, s, ObjZv[start+j].TypeObj) then break; //----------- ������ ���� �������
    if getbyte(i, s, ObjZv[start+j].Group) then break; //------------------- ������ ������
    if getbyte(i, s, ObjZv[start+j].RU) then break; //----------- ������ ������ ����������
    if not getstring(i, s, ObjZv[start+j].Title) then break;//--- ������ ��������� �������
    if not getstring(i, s, ObjZv[start+j].Liter) then break;//------ ������ ������ �������

    for k := Low(ObjZv[j].Sosed) to High(ObjZv[j].Sosed) do
    begin
      if getbyte(i,s, ObjZv[start+j].Sosed[k].TypeJmp) then break;//------- ��� ����������
      if getsmallint(i, s, ObjZv[start+j].Sosed[k].Obj) then break; //------ ������ ������
      if getbyte(i, s, ObjZv[start+j].Sosed[k].Pin) then break; //----------- ����� ������
    end;

    if getsmallint(i, s,ObjZv[start+j].BasOb) then break;//------- ������ �������� �������
    if getsmallint(i, s, ObjZv[start+j].UpdOb) then break; //----------- ������ ����������
    if getsmallint(i, s, ObjZv[start+j].VBufInd) then break; //-------- ������ �����������
    for k := Low(ObjZv[j].ObCB) to High(ObjZv[j].ObCB) do
    if getbool(i, s, ObjZv[start+j].ObCB[k]) then break; //----------- ��������� ���������

    for k := Low(ObjZv[j].ObCI) to High(ObjZv[j].ObCI) do
    if getsmallint(i, s, ObjZv[start+j].ObCI[k]) then break; //----------- ����� ���������

    p := s; SetLength(p,i-1);
    ccrc := CalculateCRC16(pchar(p),Length(p)); //------- ������� ����������� ����� ������

    if getcrc16(i, s, ObjZv[start+j].CRC1) then break; //------ ����������� ����� �� �����

    if ObjZv[start+j].CRC1 <> ccrc then
    RepF('�������� �� ������ '+IntToStr(start+j)+' ����� '+filepath);
    inc(j); //------------------------------------------ ����������� �� ��������� ������
    fullrecord := true;
  end;

  if not fullrecord then
  begin
    ShowMessage('������ ��c������� ������������ � '+ filepath);
    result := false;
    memo.Free;
    exit;
  end;
  result := true;
  memo.Free;
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
      for j := Low(ObjView[1].P) to High(ObjView[i].P) do
      begin
        ObjView[i].P[j].X := 0;
        ObjView[i].P[j].Y := 0;
      end;
      for j := Low(ObjView[1].ObCI) to High(ObjView[1].ObCI)
      do ObjView[i].ObCI[j] := 0;

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
      if not getstring(i, s, ObjView[start+j].Title) then break; //-- ������ ��������� �������
      if not getstring(i,s,ObjView[start+j].Name)  then break;  //------- ������ ����� �������
      for k := Low(ObjView[j].P) to High(ObjView[j].P) do
      begin
        if getinteger(i, s, ObjView[start+j].P[k].X) then break;//������ ���������� �
        if getinteger(i, s, ObjView[start+j].P[k].Y) then break;//������ ���������� �
      end;

      //--------------------------------------------------- ������ ����� �������� ��������
      for k := Low(ObjView[j].ObCI) to High(ObjView[j].ObCI) do
      if getsmallint(i, s, ObjView[start+j].ObCI[k]) then break;

      p := s; SetLength(p,i-1); ccrc := CalculateCRC16(pchar(p),Length(p));
      if getcrc16(i, s, ObjView[start+j].CRC) then break; // KS ����������� ����� ��������

      if ObjView[start+j].CRC <> ccrc then
      begin
        RepF('�������� �����. ����� ������ '+ IntToStr(start+j)+ ' ����� '+ filepath);
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
      if OVBuffer[start+j].CRC <> ccrc then begin RepF('�������� ����������� ����� � ������ '+ IntToStr(start+j)+ ' ����� '+ filepath); end;
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
      for j := Low(ObjUprav[1].Sosed) to High(ObjUprav[i].Sosed) do
      ObjUprav[i].Sosed[j] := 0;

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
      if not getstring(i,s,ObjUprav[start+j].Title) then break;//---- ������ ��������� �������
      if getsmallint(i,s,ObjUprav[start+j].MenuID) then break;//- ������ ������������ ����
      if getinteger(i,s,ObjUprav[start+j].Box.Left) then break;//------ ������ ������� ...
      if getinteger(i,s,ObjUprav[start+j].Box.Top) then break; //.........................
      if getinteger(i,s,ObjUprav[start+j].Box.Right) then break; //.......................
      if getinteger(i,s,ObjUprav[start+j].Box.Bottom) then break;//...... ����������������

      for k := Low(ObjUprav[j].Sosed) to High(ObjUprav[j].Sosed) do
      if getsmallint(i,s,ObjUprav[start+j].Sosed[k]) then break; //---- ������ �������

      if not getstring(i,s,ObjUprav[start+j].Hint) then break;//- ������ ������������ ��������
      p := s; SetLength(p,i-1); //------- ���������� ������ "�" ��������� ��� ������������
      ccrc := CalculateCRC16(pchar(p),Length(p));//----------- ��������� ����������� �����

      if getcrc16(i,s,ObjUprav[start+j].CRC) then break; //--- ������ �� ����������� �����
      if ObjUprav[start+j].CRC <> ccrc then
      RepF('�������� �����.����� � ������ '+ IntToStr(start+j)+ ' ����� '+ filepath);
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
var
  i : integer;
  ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(ObjZv)) then
  begin
    s := IntToStr(ObjZv[Index].TypeObj)+ ';'+
         IntToStr(ObjZv[Index].Group)+ ';'+
         IntToStr(ObjZv[Index].RU)+ ';'+
         ObjZv[Index].Title+';'+
         ObjZv[Index].Liter+';'+
         IntToStr(ObjZv[Index].Sosed[1].TypeJmp)+ ':'+
         IntToStr(ObjZv[Index].Sosed[1].Obj)+ ':'+
         IntToStr(ObjZv[Index].Sosed[1].Pin)+ ';'+
         IntToStr(ObjZv[Index].Sosed[2].TypeJmp)+ ':'+
         IntToStr(ObjZv[Index].Sosed[2].Obj)+ ':'+
         IntToStr(ObjZv[Index].Sosed[2].Pin)+ ';'+
         IntToStr(ObjZv[Index].Sosed[3].TypeJmp)+ ':'+
         IntToStr(ObjZv[Index].Sosed[3].Obj)+ ':'+
         IntToStr(ObjZv[Index].Sosed[3].Pin)+ ';'+
         IntToStr(ObjZv[Index].BasOb)+ ';'+
         IntToStr(ObjZv[Index].UpdOb)+ ';'+
         IntToStr(ObjZv[Index].VBufInd)+ ';';
    for i := 1 to High(ObjZv[Index].ObCB) do
    if ObjZv[Index].ObCB[i] then s := s + 't;' else s := s + ';';

    for i := 1 to High(ObjZv[Index].ObCI) do
    s := s + IntToStr(ObjZv[Index].ObCI[i])+ ';';

    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = ObjZv[Index].CRC1;
    exit;
  end;
  result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function CalcCRC_OV(Index : Integer) : boolean;
var
  ccrc : crc16_t;
begin
  if (Index > 0) and (Index <= High(ObjView)) then
  begin
    with ObjView[Index] do
    begin
      s := IntToStr(TypeObj)+ ';'+ IntToStr(RU)+ ';'+ IntToStr(Layer)+ ';'+ Title+';'+
      Name+';'+ IntToStr(P[1].X)+ ':'+ IntToStr(P[1].Y)+ ';'+
      IntToStr(P[2].X)+ ':'+ IntToStr(P[2].Y)+ ';'+
      IntToStr(P[3].X)+ ':'+ IntToStr(P[3].Y)+ ';'+
      IntToStr(P[4].X)+ ':'+ IntToStr(P[4].Y)+ ';'+
      IntToStr(P[5].X)+ ':'+ IntToStr(P[5].Y)+ ';'+
      IntToStr(P[6].X)+ ':'+ IntToStr(P[6].Y)+ ';'+
      IntToStr(ObCI[1]) + ';'+ IntToStr(ObCI[2]) + ';'+ IntToStr(ObCI[3]) + ';'+
      IntToStr(ObCI[4]) + ';'+ IntToStr(ObCI[5]) + ';'+ IntToStr(ObCI[6]) + ';'+
      IntToStr(ObCI[7]) + ';'+ IntToStr(ObCI[8]) + ';'+ IntToStr(ObCI[9]) + ';'+
      IntToStr(ObCI[10])+ ';'+ IntToStr(ObCI[11])+ ';'+ IntToStr(ObCI[12])+ ';'+
      IntToStr(ObCI[13])+ ';'+ IntToStr(ObCI[14])+ ';'+ IntToStr(ObCI[15])+ ';'+
      IntToStr(ObCI[16])+ ';';
      ccrc := CalculateCRC16(pchar(s),Length(s));
      result := ccrc = CRC;
      exit;
    end;
  end;
  result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
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
         IntToStr(ObjUprav[Index].Sosed[1])+ ';'+
         IntToStr(ObjUprav[Index].Sosed[2])+ ';'+
         IntToStr(ObjUprav[Index].Sosed[3])+ ';'+
         IntToStr(ObjUprav[Index].Sosed[4])+ ';'+
         ObjUprav[Index].Hint+';';
    ccrc := CalculateCRC16(pchar(s),Length(s));
    result := ccrc = ObjUprav[Index].CRC;
    exit;
  end;
  result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function CalcCRC_VB(Index : Integer) : boolean;
var
  ccrc : crc16_t;
begin
  with OVBuffer[Index] do
  begin
    if (Index > 0) and (Index <= High(OVBuffer)) then
    begin
      s := IntToStr(TypeRec)+ ';'+ IntToStr(Jmp1)+ ';'+  IntToStr(Jmp2)+ ';'+
      IntToStr(DZ1)+ ';'+ IntToStr(DZ2)+ ';'+ IntToStr(DZ3)+ ';'+ IntToStr(Steps)+ ';';
      ccrc := CalculateCRC16(pchar(s),Length(s));
      result := ccrc = CRC;
      exit;
    end;
  end;
  result := true;
end;

//========================================================================================
//----------------------------------------------------- �������� �������� ��������� ��-���
function LoadLex(filepath: string) : boolean;
var
  memo : TStringList;
  i,j : integer;
  c : string;
  cl : boolean;
begin
  memo := TStringList.Create;
  try
    try
      memo.LoadFromFile(filepath);
    except
      RepF('������ ������ '+ filepath); result := false; exit;
    end;

    if (memo.Count = 0) or (memo.Count > high(Lex)) then
    begin RepF('��������� '+ filepath+ ' �� �� �������!'); result := false; exit; end;

    //--------------------------------------------- ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex[i].msg := ''; Lex[i].Color := GetColor1(0); c := ''; cl := false;
      j := 1;
      while j <= Length(s) do
      begin
        if s[j] = '#' then cl := true  //--------------- ��������� ������� ��������� �����
        else
        if cl then
        begin //-------------------------------------------------------- ������ ���� �����
          if (s[j] < '0') or (s[j] > '9') then
          begin
            j := StrToInt(c);
            case j of
              2 :  Lex[i].Color := GetColor1(2);
              4 :  Lex[i].Color := GetColor1(1);
              14 : Lex[i].Color := GetColor1(7);
              else Lex[i].Color := GetColor1(0);
            end;
            break; //------------------------------------ ��������� ������ ��������� � Lex
          end else c := c + s[j];
        end else Lex[i].msg := Lex[i].msg + s[j];//--------- ������������ ��������� ������
        inc(j);
      end;
    end;
    RepF('��������� �������� ����� '+ filepath);
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
    try memo.LoadFromFile(filepath); except RepF('������ �� ����� ������ ����� '+ filepath); result := false; exit; end;

    if (memo.Count = 0) or (memo.Count > High(Lex2)) then begin RepF('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex2[i].msg := ''; Lex2[i].Color := GetColor1(0); c := ''; cl := false;
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
              2 :  Lex2[i].Color := GetColor1(2);
              4 :  Lex2[i].Color := GetColor1(1);
              14 : Lex2[i].Color := GetColor1(7);
            else
              Lex2[i].Color := GetColor1(0);
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

    RepF('��������� �������� ����� '+ filepath);
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
    try memo.LoadFromFile(filepath); except RepF('������ �� ����� ������ ����� '+ filepath); result := false; exit; end;

    if (memo.Count = 0) or (memo.Count > High(Lex3)) then begin RepF('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do
    begin
      s := memo.Strings[i-1];
      Lex3[i].msg := ''; Lex3[i].Color := GetColor1(0); c := ''; cl := false;
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
              2 :  Lex3[i].Color := GetColor1(2);
              4 :  Lex3[i].Color := GetColor1(1);
              14 : Lex3[i].Color := GetColor1(7);
            else
              Lex3[i].Color := GetColor1(0);
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

    RepF('��������� �������� ����� '+ filepath);
    result := true;
  finally
    memo.Free;
  end;
end;

//========================================================================================
//-------------------------------------------------------------------------- �������� ����
function LoadAKNR(filepath: string) : boolean;
var
  memo : TStringList;
  i,j,k : integer;
  ccrc : crc16_t;
  fullrecord : boolean;
begin
  for i := 1 to High(AKNR) do
  begin
    AKNR[i].ObjStart := 0;
    AKNR[i].ObjEnd   := 0;
    for j := 1  to High(AKNR[i].ObjAuto) do AKNR[i].ObjAuto[j] := 0;
    AKNR[i].Crc := 0;
  end;

  memo := TStringList.Create;
  try
    try memo.LoadFromFile(filepath);
    except RepF('������ ������ ����� '+ filepath); result := false; exit; end;

    if memo.Count > High(AKNR) then
    begin RepF('��������� '+ filepath+ '�� �� �������!'); result := false; exit; end;

    if memo.Count > 0 then
    begin
      fullrecord := false;

      //--------------------------------------------------------- ��������� ��������� ����
      for j := 1 to memo.Count do
      begin
        fullrecord := false;  //----------------- �������� ������� ������� ������ � ������
        s := memo.Strings[j-1]; //--------------------------- ��������� ������ � ���������
        i := 1; //-------------------------------------- �������� � ������� ������� ������
        if not getstring(i, s, p) then break;   //--------------- p - ����� ������� ������
        AKNR[j].ObjStart := FindObjZav(p); //----------------------- ������ ������� ������
        if not getstring(i,s,p) then break; AKNR[j].ObjEnd:= FindObjZav(p);// ������ �����

        for k := Low(AKNR[j].ObjAuto) to High(AKNR[j].ObjAuto) do
        begin
          if not getstring(i,s,p) then break;AKNR[j].ObjAuto[k]:=FindObjZav(p);//��������.
        end;

        //--------------- �������� ��������� ������ �� �������� ������� � ���������� CRC16
        p := s; SetLength(p,i-1); ccrc := CalculateCRC16(pchar(p),Length(p));

        if getcrc16(i, s, AKNR[j].CRC) then break; //- ������ ���������� ����������� �����

        if AKNR[j].CRC <> ccrc
        then RepF('��������� CRC � ������ '+ IntToStr(j)+ ' '+ filepath);
        fullrecord := true;
      end;

      if not fullrecord then
      begin RepF('������ �������� ����� '+ filepath); result := false; exit; end;
      RepF('��������� �������� ����� '+ filepath);
      result := true;
    end else result := true;
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
      RepF('������ �� ����� ������ ����� '+ filepath); result := false; exit;
    end;

    if memo.Count > High(MsgList) then
    begin RepF('��������� ����� '+ filepath+ ' �� ������������� �������!'); result := false; exit; end;

    // ��������� ��������� �������� ���������
    for i := 1 to memo.Count do MsgList[i] := memo.Strings[i-1];

    RepF('��������� �������� ����� '+ filepath);
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
    for i := 1 to High(ObjZv) do
    case ObjZv[i].TypeObj of
      1,3,4,5 :
      begin //----- ������� ���� �������� ������������, ��� ������� ����������� ����������
        p := IntToHex(ObjZv[i].TypeObj,2)+ ObjZv[i].Title+ '$';

        for j := 1 to 7 do
        begin
          if ObjZv[i].dtP[j] > 0 then
          begin
            t := FloatToStrF(ObjZv[i].dtP[j],ffGeneral,15,7);
            p := p + t + ';';
          end
          else  p := p + '0;';
        end;

        for j := 1 to 32 do
        if ObjZv[i].sbP[j] then  p := p + 't'
        else  p := p + 'f';

        p := p + ';';

        for j := 1 to 10 do
        p := p + IntToStr(ObjZv[i].siP[j])+ ';';

        sl.Add(p);
      end;
    end;
    sl.SaveToFile(filename);
  except
    RepF('������ SaveDiagnoze');
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
      RepF('���� ���������� ��������� �������� '+ filename+ ' �� ���������.');
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

        for index := 1 to High(ObjZv) do
        begin
          if (ObjZv[index].TypeObj = tobj) and (ObjZv[index].Title = name) then
          begin //------------------------------ ���������� ���������� ��� ������� �������
            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;

            if p <> '' then ObjZv[index].dtP[1] := StrToFloat(p)
            else ObjZv[index].dtP[1] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[2] := StrToFloat(p)
            else ObjZv[index].dtP[2] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[3] := StrToFloat(p)
            else ObjZv[index].dtP[3] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[4] := StrToFloat(p)
            else ObjZv[index].dtP[4] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[5] := StrToFloat(p)
            else ObjZv[index].dtP[5] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[6] := StrToFloat(p)
            else ObjZv[index].dtP[4] :=0;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            if p <> '' then ObjZv[index].dtP[7] := StrToFloat(p)
            else ObjZv[index].dtP[5] :=0;
            inc(j);

            k := 1;
            while ((j <= Length(s)) and (k <= High(ObjZv[1].sbP))) do
            begin ObjZv[index].sbP[k] := (s[j] = 't'); inc(j); inc(k); end;
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[1] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[2] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[3] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[4] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[5] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[6] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[7] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[8] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[9] := StrToIntDef(p,0);
            inc(j);

            p := '';
            while ((j <= Length(s)) and (s[j] <> ';')) do
            begin p := p + s[j]; inc(j); end;
            ObjZv[index].siP[10] := StrToIntDef(p,0);
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
      RepF('������ �� ����� ������ ����� '+ filepath);
      result := false;
      memo.Free;
      exit;
    end;

    if memo.Count > High(LinkFR3) then
    begin
      RepF('��������� ����� '+ filepath+ ' �� ������������� �������!');
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
        if s[j] =';' then break;   p := p + s[j];   inc(j);
      end;
      try
        k := StrToIntDef(p,0); LinkFR[k].FR3 := k;
      except
        memo.Free;
        RepF('������ ��� �������� '+ filepath);
        result := false;
        exit;
      end;

      inc(j);
      p := '';
      while j < l do
      begin
        if s[j] = ';' then break;  p := p + s[j];  inc(j);
      end;
      LinkFR[k].Name := p;  p  := ''; inc(i);
    end;

    WorkMode.LimitNameFRI := memo.Count-1;
    RepF('��������� �������� ����� '+ filepath);
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
    RepF('������ �� ����� ������ ����� '+ filepath);
    result := false;
    memo.Free;
    exit;
  end;

  try
    if memo.Count > High(LinkTCDC) then
    begin
      RepF('��������� ����� '+ filepath+ ' �� ������������� �������!');
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
    RepF('��������� �������� ����� '+ filepath);
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
  for i := 1 to High(ObjZv) do   //------------------ ������ �� ���� �������� ������������
    if ObjZv[i].TypeObj = 37 then //------------------------ ���� ����� �� ������ ���-����
    begin
      if ObjZv[i].ObCI[8] > 0 then //----------------------------- ���� ������������ MYTHX
      begin
        inc(j);
        if j <= High(MYT)
        then MYT[j] := ObjZv[i].ObCI[8] div 8
        else break;
      end;
    end;
  GetMYTHX := j;
end;

end.
