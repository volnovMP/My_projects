unit LoadSaveDBS;
{$INCLUDE d:\sapr2012\CfgProject}
//*****************************************************************************
//      Процедуры сохранения и загрузки файлов БД станции для САПР
//*****************************************************************************

interface

function LoadBV(FileName: string; start: Integer) : integer;
function LoadOU(FileName: string; start: Integer) : integer;
function LoadOV(FileName: string; start: Integer) : integer;
function GetConfigBV(FileName : string) : Boolean;
function GetConfigOU(FileName : string) : Boolean;
function GetConfigOV(FileName : string) : Boolean;


function SaveOZ(FileName: string; start, len: Integer) : integer; //сохранить структуру OZ
function SaveOV(FileName: string; start, len: Integer) : integer; //сохранить структуру OV
function SaveOU(FileName: string; start, len: Integer) : integer; //сохранить структуру OU
function SaveBV(FileName: string; start, len: Integer) : integer; //сохранить структуру BV
function FrameHeade(FileName: string; group, start, len, crc: Integer) : Boolean; // сформировать описание фрагмента в файле проекта
function SaveReport : Boolean;
{$IFNDEF TABLO}
function SaveLinkFR(FileName : string) : Boolean;
{$ENDIF}
implementation

uses
  TypeALL,
  Crccalc,
  windows,
  SysUtils,
  Classes;
//------------------------------------------------------------------------------
// загрузить буфер отображения
function LoadBV(FileName: string; start: Integer) : integer;
  var
    sl1  : TStringList; s,p,r : string; i,j : integer; z : integer;
begin
  result := -1;
  z := start;
  sl1 := TStringList.Create;
  try
    sl1.LoadFromFile(FileName);
    if sl1.Count > 1 then
    begin
      sl1.Delete(0);
      for i := 0 to sl1.Count-1 do
      begin
        s := sl1.Strings[i];
        if Length(s) > 0 then
        begin
          inc(z);
          j := 1;
          r := '';
          // Загрузить тип записи
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try
            OVBuffer[z].TypeRec := StrToint(p)
          except
            exit
          end;
          // Загрузить адрес перехода 1
          p := '';
          while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try OVBuffer[z].Jmp1 := StrToint(p) except exit end;
          // Загрузить адрес перехода 2
          p := '';
          while s[j] <> ';' do begin p := p + s[j];
          inc(j);
          if j > Length(s) then break; end;
          inc(j);
          try OVBuffer[z].Jmp2 := StrToint(p) except exit end;

          // Загрузить код объекта 1
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try
            OVBuffer[z].DZ1 := StrToint(p)
          except
            exit
          end;

          // Загрузить код объекта 2
          p := '';
          while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try OVBuffer[z].DZ2 := StrToint(p) except exit end;

          // Загрузить код объекта 3
          p := '';
          while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try OVBuffer[z].DZ3 := StrToint(p) except exit end;

          // Загрузить счетчик переходов
          p := '';
          while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try OVBuffer[z].Steps := StrToint(p) except exit end;

          // Загрузить контрольную сумму
          p := '';
          while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          OVBuffer[z].CRC := StrTointDef('$'+p,0);

          // Загрузить комментарий
          while j <= Length(s) do begin r := r + s[j]; inc(j); end;
        end;

        //------------------------------------------------------------- анализ комментария
        if r <> '' then
        begin
          j := 1;
          while j <= Length(r) do  begin if r[j] = '@' then break;  inc(j);  end;
          inc(j);
          if j < Length(r) then
          begin
            p := '';
            while r[j] <> ',' do
            begin p := p + r[j]; inc(j); if j > Length(r) then break; end;

            EditOVBuffer[z,1] := p;
            inc(j);
            if j < Length(r) then
            begin
              p := '';
              while r[j] <> ',' do begin p := p + r[j]; inc(j); if j > Length(r) then break; end;
              EditOVBuffer[z,2] := p;
              inc(j);
              if j < Length(r) then
              begin
                p := '';
                while r[j] <> ',' do begin p := p + r[j]; inc(j); if j > Length(r) then break; end;
                EditOVBuffer[z,3] := p;
              end else
              begin
                EditOVBuffer[z,3] := '';
              end;
            end
            else  begin EditOVBuffer[z,2] := ''; EditOVBuffer[z,3] := ''; end;
          end
          else begin EditOVBuffer[z,1] := ''; EditOVBuffer[z,2] := ''; EditOVBuffer[z,3] := ''; end;
        end;
      end;
      result := sl1.Count; // Вернуть количество загруженных объектов
    end;
  finally
    sl1.Free;
  end;
end;

//========================================================================================
//----------------------------------------------------------- загрузить объекты управления
function LoadOU(FileName: string; start: Integer) : integer;
  var
    sl2  : TStringList; s,p,r : string; i,j : integer; z : integer;
begin
  result := -1;
  z := start;
  sl2 := TStringList.Create;
  try
    sl2.LoadFromFile(FileName);
    if sl2.Count > 1 then
    begin
      sl2.Delete(0);
      for i := 0 to sl2.Count-1 do
      begin
        s := sl2.Strings[i];
        if Length(s) > 0 then
        begin
          inc(z);
          j := 1;
          r := '';
          // Загрузить RU
          p := '';
          while s[j] <> ',' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
           try ObjUprav[z].RU := StrToint(p) except exit end;

          // Загрузить IndexObj
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try  ObjUprav[z].IndexObj := StrToint(p) except exit end;

          // Загрузить Title
          p := '';
          while s[j] <> ';'
          do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          ObjUprav[z].Title := p;

          // Загрузить MenuID
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try ObjUprav[z].MenuID := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ':' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Box.Left := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ':' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Box.Top := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ':' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Box.Right := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Box.Bottom := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Neighbour[1] := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Neighbour[2] := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Neighbour[3] := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjUprav[z].Neighbour[4] := StrToint(p) except exit end;

          // Загрузить
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          ObjUprav[z].Hint := p;

          // Загрузить контрольную сумму
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          ObjUprav[z].CRC := StrTointDef('$'+p,0);

          // Загрузить комментарий
          while j <= Length(s) do begin r := r + s[j]; inc(j); end;
        end;
        // анализ комментария
        if r <> '' then
        begin
          j := 1;
          while j <= Length(r) do
          begin
           if r[j] = '@' then break;
           inc(j);
          end;
          inc(j);
          if j <= Length(r) then
          begin
            p := '';
            while r[j] <> ',' do
            begin
              p := p + r[j];
              inc(j);
              if j > Length(r) then break;
            end;
            EditObjUprav[z,1] := p;
          end else
          begin
            EditObjUprav[z,1] := '';
            EditObjUprav[z,2] := '';
          end;
        end;
      end;
      result := sl2.Count; // Вернуть количество загруженных объектов
    end;
  finally
    sl2.Free;
  end;
end;

//========================================================================================
//---------------------------------------------------------- загрузить объекты отображения
function LoadOV(FileName: string; start: Integer) : integer;
var
  sl3           : TStringList;
  s, p, r       : string;
  i,j,k,z,hvost : integer;
begin
  result := -1;
  z := start-1;
  sl3 := TStringList.Create;
  try
    sl3.LoadFromFile(FileName);
    if sl3.Count > 1 then
    begin
      sl3.Delete(0);
      for i := 0 to sl3.Count-1 do
      begin
        s := sl3.Strings[i];
        if Length(s) > 0 then
        begin
          inc(z);
          j := 1;
          r := '';
          //------------------------------------------------------------ Загрузить TypeObj
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].TypeObj := StrToint(p) except exit end;

          //----------------------------------------------------------------- Загрузить RU
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].RU := StrToint(p) except exit end;

          //-------------------------------------------------------------- Загрузить Layer
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].Layer := StrToint(p) except exit end;

          //-------------------------------------------------------------- Загрузить Title
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end;  inc(j);
          ObjView[z].Title := p;

          //------------------------------- попытка Загрузить Name (возможно это X точки 1
          //-------------------------------------------------- запоминаем позицию в строке
          k := j;
          p := '';
          while (s[j] <> ';') and (s[j] <> ':') do //собираем строку до любого разделителя
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end;

          if s[j] = ':' then //-------------------------------- если разделитель для точки
          begin
            ObjView[z].Points[1].X := StrToint(p);
            j := k;
          end else  //--------------------------------------- если разделитель для объекта
          begin
            inc(j);
            ObjView[z].Name := p;
          end;

          //---------------------------------------------------- Загрузить точку 1 (X & Y)
          p := '';
          while s[j] <> ':' do
          begin
            p := p + s[j];  inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try ObjView[z].Points[1].X := StrToint(p)   except exit end;
          p := '';

          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try
            ObjView[z].Points[1].Y := StrToint(p)
          except exit
          end;

          //---------------------------------------------------- Загрузить точку 2 (X & Y)
          p := ''; while s[j] <> ':' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end;
            inc(j);
          try ObjView[z].Points[2].X := StrToint(p) except exit end;
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end;
          inc(j);
          try ObjView[z].Points[2].Y := StrToint(p) except exit end;

          //---------------------------------------------------- Загрузить точку 3 (X & Y)
          p := '';
          while s[j] <> ':' do
          begin
            p := p + s[j];
            inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].Points[3].X := StrToint(p) except exit end;
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j];
            inc(j); if j > Length(s) then break;
          end;
          inc(j);
          try ObjView[z].Points[3].Y := StrToint(p) except exit end;

          //---------------------------------------------------- Загрузить точку 4 (X & Y)
          p := '';
          while s[j] <> ':' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end;
          inc(j);
          try
            ObjView[z].Points[4].X := StrToint(p) except exit
          end;
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].Points[4].Y := StrToint(p) except exit end;

          // Загрузить точку 5 (X & Y)
          p := '';
          while s[j] <> ':' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try
            ObjView[z].Points[5].X := StrToint(p) except exit
          end;
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].Points[5].Y := StrToint(p) except exit end;

          //---------------------------------------------------- Загрузить точку 6 (X & Y)
          p := '';
          while s[j] <> ':' do
          begin
            p := p + s[j]; inc(j);
            if j > Length(s) then break;
          end; inc(j);
          try
            ObjView[z].Points[6].X := StrToint(p) except exit
          end;
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].Points[6].Y := StrToint(p) except exit end;
          //-------------------------------------------------------- Загрузить константу 1
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].ObjConstI[1] := StrToint(p) except exit end;
          //-------------------------------------------------------- Загрузить константу 2
          p := '';
          while s[j] <> ';' do
          begin
            p := p + s[j]; inc(j); if j > Length(s) then break;
          end; inc(j);
          try ObjView[z].ObjConstI[2] := StrToint(p) except exit end;
          //-------------------------------------------------------- Загрузить константу 3
          p := '';
          while s[j] <> ';' do
          begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[3] := StrToint(p) except exit end;

          // Загрузить константу 4
          p := '';
          while s[j] <> ';'
          do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try ObjView[z].ObjConstI[4] := StrToint(p) except exit end;

          // Загрузить константу 5
          p := '';
          while s[j] <> ';'
          do begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          inc(j);
          try ObjView[z].ObjConstI[5] := StrToint(p) except exit end;

          // Загрузить константу 6
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[6] := StrToint(p) except exit end;

          // Загрузить константу 7
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[7] := StrToint(p) except exit end;

          // Загрузить константу 8
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[8] := StrToint(p) except exit end;

          // Загрузить константу 9
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[9] := StrToint(p) except exit end;

          // Загрузить константу 10
          p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
          try ObjView[z].ObjConstI[10] := StrToint(p) except exit end;

          hvost := length(s) - j;
          if hvost > 10 then
          begin
            // Загрузить константу 11
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[11] := StrToint(p) except exit end;

            // Загрузить константу 12
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[12] := StrToint(p) except exit end;

            // Загрузить константу 13
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[13] := StrToint(p) except exit end;

            // Загрузить константу 14
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[14] := StrToint(p) except exit end;

            // Загрузить константу 15
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[15] := StrToint(p) except exit end;

            // Загрузить константу 16
            p := ''; while s[j] <> ';' do begin p := p + s[j]; inc(j); if j > Length(s) then break; end; inc(j);
            try ObjView[z].ObjConstI[16] := StrToint(p) except exit end;
          end;
          // Загрузить контрольную сумму
          p := '';
          while s[j] <> ';' do
          begin p := p + s[j]; inc(j); if j > Length(s) then break; end;
          ObjView[z].CRC := StrTointDef('$'+p,0);
        end;
      end;
      result := z;
      //sl3.Count; // Вернуть количество загруженных объектов
    end;
  finally
    sl3.Free;
  end;
end;

///=======================================================================================
//---------------------------- Получить конфигурацию фрагмента описания буфера отображения
function GetConfigBV(FileName : string) : Boolean;
  var sl4 : TStringList; s,p : string; i,j : integer;
begin
  result := false;
  sl4 := TStringList.Create;
  try
    sl4.LoadFromFile(FileName);
    if sl4.Count > 1 then
    begin
      s := sl4.Strings[0];
      if Length(s) > 0 then
      begin // распаковать описание фрагмента
        p := '';
        i := 1;
        while ((s[i] <> ' ') and (i <= Length(s))) do
        begin
          p := p + s[i];
          inc(i);
        end;
        inc(i);
        if p <> '' then TabloCfg[TabloP.CurrentFrag].VBName := p;
        p := '';
        while ((s[i] <> ' ') and (i <= Length(s))) do
        begin
          p := p + s[i];
          inc(i);
        end;
        inc(i);
        j := StrToInt(p);
        TabloCfg[TabloP.CurrentFrag].VBStart := j;
        p := '';
        while ((s[i] <> ' ') and (i <= Length(s))) do
        begin
          p := p + s[i];
          inc(i);
        end;
        j := StrToInt(p);
        TabloCfg[TabloP.CurrentFrag].VBLen := j;
        result := true;
      end;
    end;
  finally
    sl4.Free;
  end;
end;

//------------------------------------------------------------------------------
// Получить конфигурацию фрагмента описания объектов управления
function GetConfigOU(FileName : string) : Boolean;
  var sl5 : TStringList; s,p : string; i,j : integer;
begin
  result := false;
  sl5 := TStringList.Create;
  try
    sl5.LoadFromFile(FileName);
    if sl5.Count > 1 then
    begin
      s := sl5.Strings[0];
      if Length(s) > 0 then
      begin // распаковать описание фрагмента
        p := ''; i := 1; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end; inc(i);
        if p <> '' then TabloCfg[TabloP.CurrentFrag].OUName := p;
        p := ''; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end; inc(i);
        j := StrToInt(p); TabloCfg[TabloP.CurrentFrag].OUStart := j;
        p := ''; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end;
        j := StrToInt(p); TabloCfg[TabloP.CurrentFrag].OULen := j;
        result := true;
      end;
    end;
  finally
    sl5.Free;
  end;
end;

//------------------------------------------------------------------------------
// Получить конфигурацию фрагмента описания объектов табло
function GetConfigOV(FileName : string) : Boolean;
  var sl6 : TStringList; s,p : string; i,j : integer;
begin
  result := false;
  sl6 := TStringList.Create;
  try
    sl6.LoadFromFile(FileName);
    if sl6.Count > 1 then
    begin
      s := sl6.Strings[0];
      if Length(s) > 0 then
      begin // распаковать описание фрагмента
        p := ''; i := 1; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end; inc(i);
        if p <> '' then TabloCfg[TabloP.CurrentFrag].OVName := p;
        p := ''; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end; inc(i);
        j := StrToInt(p); TabloCfg[TabloP.CurrentFrag].OVStart := j;
        p := ''; while ((s[i] <> ' ') and (i <= Length(s))) do begin p := p + s[i]; inc(i); end;
        j := StrToInt(p); TabloCfg[TabloP.CurrentFrag].OVLen := j;
        result := true;
      end;
    end;
  finally
    sl6.Free;
  end;
end;

//------------------------------------------------------------------------------
// сохранить буфер отображения
function SaveBV(FileName: string; start, len: Integer) : integer;
  var
    sl7 : TStringList; i : integer; s,n : string;
begin
  sl7:= TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to High(OVBuffer) do
      begin
        s := IntToStr(OVBuffer[i].TypeRec)+ ';'+
             IntToStr(OVBuffer[i].Jmp1)+ ';'+
             IntToStr(OVBuffer[i].Jmp2)+ ';'+
             IntToStr(OVBuffer[i].DZ1)+ ';'+
             IntToStr(OVBuffer[i].DZ2)+ ';'+
             IntToStr(OVBuffer[i].DZ3)+ ';'+
             IntToStr(OVBuffer[i].Steps)+ ';';
        OVBuffer[i].CRC := CalculateCRC16(pchar(s),Length(s));
        s := s + IntToHex(OVBuffer[i].CRC,4)+ ';';  // контрольная сумма строки
        s := s + ' -'+ IntToStr(i);
        if (EditOVBuffer[i,1] <> '') or (EditOVBuffer[i,2] <> '') or (EditOVBuffer[i,3] <> '') then
        begin
          s := s + '  @'+ EditOVBuffer[i,1]+ ','+ EditOVBuffer[i,2]+ ','+ EditOVBuffer[i,3];
        end;
        sl7.Add(s);
      end;
    end else
    begin
      for i := start to start+len-1 do
      begin
        s := IntToStr(OVBuffer[i].TypeRec)+ ';'+
             IntToStr(OVBuffer[i].Jmp1)+ ';'+
             IntToStr(OVBuffer[i].Jmp2)+ ';'+
             IntToStr(OVBuffer[i].DZ1)+ ';'+
             IntToStr(OVBuffer[i].DZ2)+ ';'+
             IntToStr(OVBuffer[i].DZ3)+ ';'+
             IntToStr(OVBuffer[i].Steps)+ ';';
        OVBuffer[i].CRC := CalculateCRC16(pchar(s),Length(s));
        s := s + IntToHex(OVBuffer[i].CRC,4)+ ';';  // контрольная сумма строки
        s := s + ' -'+ IntToStr(i);
        if (EditOVBuffer[i,1] <> '') or (EditOVBuffer[i,2] <> '') or (EditOVBuffer[i,3] <> '') then
        begin
          s := s + '  @'+ EditOVBuffer[i,1]+ ','+ EditOVBuffer[i,2]+ ','+ EditOVBuffer[i,3];
        end;
        sl7.Add(s);
      end;
    end;
    // Сформировать заголовок фрагмента БД OZ
    n := ''; i := Length(FileName);
    while i > 0 do
      if FileName[i] = '\' then break else dec(i);
    inc(i);
    while i <= Length(FileName) do
    begin
      n := n + FileName[i];
      inc(i);
    end;
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ sl7.Text;
    i := CalculateCRC32(pchar(s),Length(s));     // контрольная сумма фрагмента
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ ' '+ IntToHex(i,8);
    sl7.Insert(0,s);
    sl7.SaveToFile(FileName);
    s := sl7.Text;
    i := CalculateCRC32(pchar(s),Length(s)); // контрольная сумма файла
    FrameHeade(n,4,start,len,i);
  finally
    result := sl7.Count; // вернуть количество сохраненных объектов
    sl7.Free;
  end;
end;

//========================================================================================
//----------------------------------------------------------------- сохранить структуру OZ
function SaveOZ(FileName: string; start, len: Integer) : integer;
  var
    sl8 : TStringList;
    i,j : integer;
    s,n : string;
begin
  result := 0;
  if len = 0 then exit;
  sl8 := TStringList.Create;
  try
    //-------------------------------------------------------- Сформировать фрагмент БД OZ
    for i := start to start+len-1 do
    begin
      s := IntToStr(ObjZav[i].TypeObj)+ ';'+
      IntToStr(ObjZav[i].Group)+ ';' +
      IntToStr(ObjZav[i].RU) + ';' +
      ObjZav[i].Title + ';' +
      ObjZav[i].Liter+ ';';

      for j := Low(ObjZav[i].Neighbour) to High(ObjZav[i].Neighbour) do
      s := s + IntToStr(ObjZav[i].Neighbour[j].TypeJmp) + ':' +
      IntToStr(ObjZav[i].Neighbour[j].Obj) + ':' +
      IntToStr(ObjZav[i].Neighbour[j].Pin) + ';';

      s := s + IntToStr(ObjZav[i].BaseObject) + ';' +
      IntToStr(ObjZav[i].UpdateObject) + ';' +
      IntToStr(ObjZav[i].VBufferIndex)+ ';';

      for j := Low(ObjZav[i].ObjConstB) to High(ObjZav[i].ObjConstB) do
      begin
        if ObjZav[i].ObjConstB[j] then s := s + 't;' else s := s + ';';
      end;

      for j := Low(ObjZav[i].ObjConstI) to High(ObjZav[i].ObjConstI) do
      s := s + IntToStr(ObjZav[i].ObjConstI[j]) + ';';

      ObjZav[i].CRC1 := CalculateCRC16(pchar(s),Length(s));

      s := s + IntToHex(ObjZav[i].CRC1,4)+ ';';  //-------------- контрольная сумма строки

      s := s + ' -' + IntToStr(i);

      sl8.Add(s);
    end;
    //--------------------------------------------- Сформировать заголовок фрагмента БД OZ
    n := ''; i := Length(FileName);
    while i > 0 do
      if FileName[i] = '\' then break else dec(i);
    inc(i);
    while i <= Length(FileName) do
    begin
      n := n + FileName[i];
      inc(i);
    end;
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ sl8.Text;
    i := CalculateCRC32(pchar(s),Length(s));     //----------- контрольная сумма фрагмента
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ ' '+ IntToHex(i,8);
    sl8.Insert(0,s);
    sl8.SaveToFile(FileName);
    s := sl8.Text;
    i := CalculateCRC32(pchar(s),Length(s)); //------------------- контрольная сумма файла
    FrameHeade(n,1,start,len,i);
  finally
    result := sl8.Count; //----------------------- вернуть количество сохраненных объектов
    sl8.Free;
  end;
end;

//========================================================================================
//----------------------------------------------------------------- сохранить структуру OV
function SaveOV(FileName: string; start, len: Integer) : integer;
var
  sl9 : TStringList;
  i,j : integer;
  s,n : string;
  Tochka : TPoint;
begin
  result := 0;
  if len = 0 then exit;
  sl9 := TStringList.Create;
  try
    for i := start to start+len-1 do //----------------------- Сформировать фрагмент БД OV
    begin
      s := IntToStr(ObjView[i].TypeObj)+ ';'+ IntToStr(ObjView[i].RU)+ ';'+
      IntToStr(ObjView[i].Layer)+ ';'+ ObjView[i].Title+ ';'+ObjView[i].Name + ';';

      if ObjView[i].TypeObj = 12 then //------------------------------------ если это путь
      begin
        if TabloP.PlaceN = 0 then //-------------------------- если нечетные подходы слева
        if ObjView[i].Points[2].X > ObjView[i].Points[3].X then
        begin
          Tochka.X := ObjView[i].Points[2].X;
          ObjView[i].Points[2].X := ObjView[i].Points[3].X;
          ObjView[i].Points[3].X := Tochka.X;
        end;

        if TabloP.PlaceN = 1 then //------------------------- если нечетные подходы справа
        if ObjView[i].Points[2].X < ObjView[i].Points[3].X then
        begin
          Tochka.X := ObjView[i].Points[2].X;
          ObjView[i].Points[2].X := ObjView[i].Points[3].X;
          ObjView[i].Points[3].X := Tochka.X;
        end;
      end;

      for j := Low(ObjView[i].Points) to High(ObjView[i].Points) do
      s := s + IntToStr(ObjView[i].Points[j].X)+ ':'+
      IntToStr(ObjView[i].Points[j].Y)+ ';';

      for j := Low(ObjView[i].ObjConstI) to High(ObjView[i].ObjConstI) do
      s := s + IntToStr(ObjView[i].ObjConstI[j])+ ';';

      ObjView[i].CRC := CalculateCRC16(pchar(s),Length(s));
      s := s + IntToHex(ObjView[i].CRC,4)+ ';';  // контрольная сумма строки
      sl9.Add(s);
    end;
    // Сформировать заголовок фрагмента БД
    n := ''; i := Length(FileName);
    while i > 0 do if FileName[i] = '\' then break else dec(i);
    inc(i);
    while i <= Length(FileName) do begin n := n + FileName[i]; inc(i); end;
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ sl9.Text;
    i := CalculateCRC32(pchar(s),Length(s));     // контрольная сумма фрагмента
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ ' '+ IntToHex(i,8);
    sl9.Insert(0,s);
    sl9.SaveToFile(FileName);
    s := sl9.Text;
    i := CalculateCRC32(pchar(s),Length(s)); // контрольная сумма файла
    FrameHeade(n,2,start,len,i);
  finally
    result := sl9.Count; // вернуть количество сохраненных объектов
    sl9.Free;
  end;
end;

//------------------------------------------------------------------------------
// сохранить структуру OU
function SaveOU(FileName: string; start, len: Integer) : integer;
  var
    sl10 : TStringList; i : integer; s,n : string;
begin
  sl10 := TStringList.Create;
  try
    if len = 0 then
    begin
      for i := 1 to High(OVBuffer) do
      begin
        s := IntToStr(ObjUprav[i].RU)+ ','+
             IntToStr(ObjUprav[i].IndexObj)+ ';'+
             ObjUprav[i].Title+ ';'+
             IntToStr(ObjUprav[i].MenuID)+ ';'+
             IntToStr(ObjUprav[i].Box.Left)+ ':'+
             IntToStr(ObjUprav[i].Box.Top)+ ':'+
             IntToStr(ObjUprav[i].Box.Right)+ ':'+
             IntToStr(ObjUprav[i].Box.Bottom)+ ';'+
             IntToStr(ObjUprav[i].Neighbour[1])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[2])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[3])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[4])+ ';'+
             ObjUprav[i].Hint+ ';';
        ObjUprav[i].CRC := CalculateCRC16(pchar(s),Length(s));
        s := s + IntToHex(ObjUprav[i].CRC,4)+ ';';  // контрольная сумма строки
        s := s + ' -'+ IntToStr(i);
        if (EditObjUprav[i,1] <> '') or (EditObjUprav[i,2] <> '') then
        begin
          s := s + '  @'+ EditOVBuffer[i,1];
        end;
        sl10.Add(s);
      end;
    end else
    begin
      for i := start to start+len-1 do
      begin
        s := IntToStr(ObjUprav[i].RU)+ ','+
             IntToStr(ObjUprav[i].IndexObj)+ ';'+
             ObjUprav[i].Title+ ';'+
             IntToStr(ObjUprav[i].MenuID)+ ';'+
             IntToStr(ObjUprav[i].Box.Left)+ ':'+
             IntToStr(ObjUprav[i].Box.Top)+ ':'+
             IntToStr(ObjUprav[i].Box.Right)+ ':'+
             IntToStr(ObjUprav[i].Box.Bottom)+ ';'+
             IntToStr(ObjUprav[i].Neighbour[1])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[2])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[3])+ ';'+
             IntToStr(ObjUprav[i].Neighbour[4])+ ';'+
             ObjUprav[i].Hint+ ';';
        ObjUprav[i].CRC := CalculateCRC16(pchar(s),Length(s));
        s := s + IntToHex(ObjUprav[i].CRC,4)+ ';';  // контрольная сумма строки
        s := s + ' -'+ IntToStr(i);
        if (EditObjUprav[i,1] <> '') or (EditObjUprav[i,2] <> '') then
        begin
          s := s + '  @'+ EditObjUprav[i,1];
        end;
        sl10.Add(s);
      end;
    end;
    // Сформировать заголовок фрагмента БД
    n := ''; i := Length(FileName);
    while i > 0 do
      if FileName[i] = '\' then break else dec(i);
    inc(i);
    while i <= Length(FileName) do
    begin
      n := n + FileName[i];
      inc(i);
    end;
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ sl10.Text;
    i := CalculateCRC32(pchar(s),Length(s));     // контрольная сумма фрагмента
    s := n+ ' '+ IntToStr(start)+ ' '+ IntToStr(len)+ ' '+ IntToHex(i,8);
    sl10.Insert(0,s);
    sl10.SaveToFile(FileName);
    s := sl10.Text;
    i := CalculateCRC32(pchar(s),Length(s)); // контрольная сумма файла
    FrameHeade(n,3,start,len,i);
  finally
    result := sl10.Count; // вернуть количество сохраненных объектов
    sl10.Free;
  end;
end;

//========================================================================================
//---------------------------------------- сформировать описание фрагмента в файле проекта
function FrameHeade(FileName: string; group, start, len, crc: Integer) : Boolean;
var
  i : integer;
  s : string;
begin
  s := FileName+ ';'+ IntToStr(start)+ ';'+ IntToStr(len)+ ';'+ IntToHex(crc,8)+ ';';
  case group of
    1 :
    begin //--------------------------------------------------------------------------- OZ
      i := 1;
      while i <= High(hdrOZ) do
      begin
        if hdrOZ[i] = '' then
        begin
          hdrOZ[i] := s;
          break;
        end else inc(i);
      end;
    end;

    2 :
    begin //--------------------------------------------------------------------------- OV
      i := 1;
      while i <= High(hdrOV) do
      begin
        if hdrOV[i] = '' then
        begin
          hdrOV[i] := s;
          break;
        end else inc(i);
      end;
    end;

    3 :
    begin //--------------------------------------------------------------------------- OU
      i := 1;
      while i <= High(hdrOU) do
      begin
        if hdrOU[i] = '' then
        begin
          hdrOU[i] := s;
          break;
        end else inc(i);
      end;
    end;

    4 :
    begin //--------------------------------------------------------------------------- BV
      i := 1;
      while i <= High(hdrBV) do
      begin
        if hdrBV[i] = '' then
        begin
          hdrBV[i] := s;
          break;
        end else inc(i);
      end;
    end;
  end;
  result := true;
end;

//========================================================================================
function SaveReport : Boolean;
var
  i,j : integer;
  sl11 : TStringList;
  s : string;
begin
  sl11 := TStringList.Create;
  try
    if ProjectText <> '' then sl11.Add(';'+ProjectText);
    sl11.Add('[Project]');
    sl11.Add('name='+ ProjectName);
    DateTimeToString(s,'dd/mm/yy',Date);
    sl11.Add('date='+ s);
    sl11.Add('server='+ ServerIndex);
    sl11.Add('arm='+ ArmIndex);
    sl11.Add('state='+ StateIndex);
    sl11.Add('limitfr='+ LimitFRS);
    sl11.Add('ru=1');
    sl11.Add('verinfo=1');
    sl11.Add('');


    sl11.Add('[oz]'); j := 1;
    for i := 1 to High(hdrOZ) do
      if hdrOZ[i] <> '' then begin sl11.Add('f'+ IntToStr(j)+ '='+ hdrOZ[i]); inc(j); end;

    sl11.Add('[ov]'); j := 1;
    for i := 1 to High(hdrOV) do
      if hdrOV[i] <> '' then begin sl11.Add('f'+ IntToStr(j)+ '='+ hdrOV[i]); inc(j); end;

    sl11.Add('[bv]'); j := 1;
    for i := 1 to High(hdrBV) do
      if hdrBV[i] <> '' then begin sl11.Add('f'+ IntToStr(j)+ '='+ hdrBV[i]); inc(j); end;

    sl11.Add('[ou]'); j := 1;
    for i := 1 to High(hdrOU) do
      if hdrOU[i] <> '' then begin sl11.Add('f'+ IntToStr(j)+ '='+ hdrOU[i]); inc(j); end;


    sl11.Add('');
    sl11.Add('[ru]');
    sl11.Add('ru=1');
    sl11.Add('TabloHeight='+ IntToStr(TabloP.TabloHeight));
    sl11.Add('TabloWidth='+ IntToStr(TabloP.TabloWidth));
    sl11.Add('MonHeight='+ IntToStr(TabloP.ScreenHeight));
    sl11.Add('MonWidth='+ IntToStr(TabloP.ScreenWidth));
    sl11.Add('MsgLeft='+ IntToStr(TabloP.MsgLeft));
    sl11.Add('MsgTop='+ IntToStr(TabloP.MsgTop));
    sl11.Add('MsgRight='+ IntToStr(TabloP.MsgRight));
    sl11.Add('MsgBottom='+ IntToStr(TabloP.MsgBottom));
    sl11.Add('BoxLeft='+ IntToStr(TabloP.BoxLeft));
    sl11.Add('BoxTop='+ IntToStr(TabloP.BoxTop));
    sl11.Add('Тип системы='+IntToStr(TabloP.System_Tip));
    sl11.Add('Ориентация станции=' + IntToStr(TabloP.PlaceN));

    if Regim_DC then sl11.Add('Наличие ДЦ=1')
    else sl11.Add('Наличие ДЦ=0');

    if Regim_SU then sl11.Add('Наличие сезонного=1')
    else sl11.Add('Наличие сезонного=0');

    sl11.SaveToFile(StationDir + ProjectName+ '.inf');
  finally
    result := sl11.Count > 0;
    sl11.Free;
  end;
end;

{$IFNDEF TABLO}
//------------------------------------------------------------------------------
// сохранить файл связки датчиков канала
function SaveLinkFR(FileName : string) : Boolean;
  var
    sl12 : TStringList; i : integer; s,s1 : string;
begin
  sl12 := TStringList.Create;
  try
    result := false;
    for i := 1 to LinkFRPtr do
    begin
      if LinkFR[i].FR3 < 10 then s1 := '00' +IntToStr(LinkFR[i].FR3)
      else
        if LinkFR[i].FR3 < 100 then s1 := '0' +IntToStr(LinkFR[i].FR3)
        else s1 := IntToStr(LinkFR[i].FR3);
      s := s1 + ';'+ LinkFR[i].Name + ';' ;
      sl12.Add(s);
    end;
    sl12.Sort();
    sl12.SaveToFile(FileName);
  finally
    sl12.Free;
  end;
end;
{$ENDIF}
end.
