unit MainLoop;
//------------------------------------------------------------------------------
//          Цикл обсчета зависимостей РМ-ДСП, АРМ-ШН, просмотр архива
//------------------------------------------------------------------------------
{$INCLUDE d:\Sapr2012\CfgProject}

interface

uses
  SysUtils,
  Windows,
  Dialogs,
  Forms,
  DateUtils;

procedure SetDateTimeARM(index : SmallInt);
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
procedure PrepareOZ;
procedure PrepareOZ1(Ptr : Integer);
procedure GoOVBuffer(Ptr,Steps : Integer);

procedure DiagnozUVK(Index : SmallInt);
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;

procedure PrepXStrelki(Ptr : Integer);
procedure PrepDZStrelki(Ptr : Integer);
procedure PrepStrelka(Ptr : Integer);
procedure PrepOxranStrelka(Ptr : Integer);
procedure PrepSekciya(Ptr : Integer);
procedure PrepPuti(Ptr : Integer);
procedure PrepSvetofor(Ptr : Integer);
procedure PrepRZS(Ptr : Integer);
procedure PrepMagStr(Ptr : Integer);
procedure PrepMagMakS(Ptr : Integer);
procedure PrepAPStr(Ptr : Integer);
procedure PrepPTO(Ptr : Integer);
procedure PrepUTS(Ptr : Integer);
procedure PrepUPer(Ptr : Integer);
procedure PrepKPer(Ptr : Integer);
procedure PrepK2Per(Ptr : Integer);
procedure PrepOM(Ptr : Integer);
procedure PrepUKSPS(Ptr : Integer); //--------------- контроль схода подвижного состава 14 
procedure PrepMaket(Ptr : Integer);
procedure PrepOtmen(Ptr : Integer);
procedure PrepGRI(Ptr : Integer);
procedure PrepAB(Ptr : Integer);
procedure PrepVSNAB(Ptr : Integer);
procedure PrepPAB(Ptr : Integer);
procedure PrepDSPP(Ptr : Integer);
procedure PrepPSvetofor(Ptr : Integer);
procedure PrepPriglasit(Ptr : Integer);
procedure PrepNadvig(Ptr : Integer);
procedure PrepMarhNadvig(Ptr : Integer);
procedure PrepMEC(Ptr : Integer);
procedure PrepZapros(Ptr : Integer);
procedure PrepManevry(Ptr : Integer);
procedure PrepSingle(Ptr : Integer);
procedure PrepInside(Ptr : Integer);
procedure PrepPitanie(Ptr : Integer);
procedure PrepSwitch(Ptr : Integer);
procedure PrepIKTUMS(Ptr : Integer);
procedure PrepKRU(Ptr : Integer);
procedure PrepIzvPoezd(Ptr : Integer);
procedure PrepVP(Ptr : Integer);
procedure PrepVPStrelki(VPSTR : Integer);
procedure PrepOPI(Ptr : Integer);
procedure PrepSOPI(Ptr : Integer);
procedure PrepSMI(Ptr : Integer);
procedure PrepKNM(Ptr : Integer);
procedure PrepRPO(Ptr : Integer);
procedure PrepAutoSvetofor(Ptr : Integer);
procedure PrepAutoMarshrut(Ptr : Integer);
procedure PrepABTC(Ptr : Integer);
procedure PrepDCSU(Ptr : Integer);
procedure PrepDopDat(Ptr : Integer);
procedure PrepSVMUS(Ptr : Integer);
procedure PrepST(Ptr : Integer);
procedure PrepDN(Ptr : Integer);
procedure PrepDopSvet(Ptr : Integer);
procedure PrepUKG(Ptr : Integer); //---------------------------------------------- УКГ(56)

const
  DiagUVK : SmallInt      = 1; //5120 адрес сообщения о неисправности УВК
  DateTimeSync : Word = 1; //6144 адрес сообщения для синхронизации времени системы
{$IFDEF RMSHN}
  StatStP                 = 5; // количество переводов для вычисления средней длительности перевода стрелки
{$ENDIF}


implementation

uses
  Marshrut,
  Commands,
{$IFDEF RMDSP}
  //PipeProc,
  KanalArmSrv,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
  ValueList,
  TabloSHN,
{$ENDIF}

{$IFDEF RMDSP}
  TabloForm,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

  Commons,
  TypeALL;
var
  s  : string;
  dt : string;
  LiveCounter : integer;

procedure SetDateTimeARM(index : SmallInt);
{$IFNDEF RMARC}
  var
    uts,lt : TSystemTime;
    nd,nt : TDateTime;
    ndt,cdt,delta : Double;
    time64 : int64;
    Hr,Mn,Sc,Yr,Mt,Dy : Word;
    err : boolean;
    i : integer;
{$ENDIF}
begin
{$IFNDEF RMARC}
try
  if FR8[index] > 0 then
  begin
    time64 := FR8[index];
    err := false;
    Sc := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Mn := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Hr := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Dy := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Mt := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Yr := (time64 and $00000000000000ff) + 2000;

    if not TryEncodeTime(Hr,Mn,Sc,0,nt) then
    begin
      err := true; InsArcNewMsg(0,507,1);
      AddFixMessage(GetShortMsg(1,507,'',1) + 'Попытка установки времени '+ IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;
    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsArcNewMsg(0,507,1);
      AddFixMessage(GetShortMsg(1,507,'',1) + 'Попытка установки даты '+ IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
    end;
    if not err then
    begin
      ndt := nd+nt; delta := ndt - LastTime;
      DateTimeToSystemTime(ndt,uts);
      SystemTimeToTzSpecificLocalTime(nil,uts,lt);
      cdt := SystemTimeToDateTime(lt) - ndt;
      ndt := ndt - cdt;
      DateTimeToSystemTime(ndt,uts);
      SetSystemTime(uts);

      for i := 1 to high(FR3s) do // коррекция отметок времени в FR3
        if FR3s[i] > 0.00000001 then FR3s[i] := FR3s[i] - delta;
      for i := 1 to high(FR4s) do // коррекция отметок времени в FR4
        if FR4s[i] > 0.00000001 then FR4s[i] := FR4s[i] - delta;

      for i := 1 to high(ObjZav) do
      begin // коррекция отметок времени в объектах зависимостей
        if ObjZav[i].Timers[1].Active then
        ObjZav[i].Timers[1].First := ObjZav[i].Timers[1].First - delta;

        if ObjZav[i].Timers[2].Active then
        ObjZav[i].Timers[2].First := ObjZav[i].Timers[2].First - delta;

        if ObjZav[i].Timers[3].Active then
        ObjZav[i].Timers[3].First := ObjZav[i].Timers[3].First - delta;

        if ObjZav[i].Timers[4].Active then
        ObjZav[i].Timers[4].First := ObjZav[i].Timers[4].First - delta;

        if ObjZav[i].Timers[5].Active then
        ObjZav[i].Timers[5].First := ObjZav[i].Timers[5].First - delta;
      end;
      LastSync := ndt;
      LastTime := ndt;
    end;
    // сбросить параметр
    FR8[index] := 0;
  end;
except
  FR8[index] := 0; reportf('Ошибка [MainLoop.SetDateTimeARM]'); Application.Terminate;
end;
{$ENDIF}
end;
//========================================================================================
//----------------------------------------------------------- проход по буферу отображения
procedure GoOVBuffer(Ptr,Steps : Integer);
var
  LastStep, cPtr : integer;
begin
  try
    LastStep := Steps;
    cPtr := Ptr;
    while LastStep > 0 do  StepOVBuffer(cPtr,LastStep);
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.GoOVBuffer]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------ Сделать шаг по буферу отображения
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
var
  oPtr : integer;
begin
  try
    oPtr := Ptr;
    case OVBuffer[Ptr].TypeRec of
      0 : Ptr := OVBuffer[Ptr].Jmp1;//----------------------- вернуться к предыдущему узлу

      1 :
      begin //----------------------------------------------- копировать буфер отображения
        OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
        Ptr := OVBuffer[Ptr].Jmp1;
      end;

      2 :
      begin //---------------------------------------------- дублировать буфер отображения
        if OVBuffer[Ptr].StepOver then
        begin
          OVBuffer[OVBuffer[Ptr].Jmp2].Param := OVBuffer[Ptr].Param;
          Ptr := OVBuffer[Ptr].Jmp2
        end else
        begin
          OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
          Ptr := OVBuffer[Ptr].Jmp1;
        end;
      end;

      3 :
      begin //-------------------------------------------------------------------- Стрелка
        if OVBuffer[Ptr].StepOver then //--------------- второй проход через эту строку BV
        begin
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //++++++++++++ второй проход, выполняется прорисовка для минусовой ветви стрелки
          Ptr := OVBuffer[Ptr].Jmp2;
          OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];  //------------- парафазность
          OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11]; //
          OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16]; //-------------- активность

          //+++++++++++ что будет с веткой минус, если стрелка в плюсе +++++++++++++++++++
          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then   //------------- не МК стрелки
          begin
            if ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then  //-------------- есть ПК стрелки
            begin
              if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] //если Мест.упр.
              then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] //взять разрешение МУ
              else OVBuffer[Ptr].Param[2] := false; //--------- иначе убрать разрешение МУ
              OVBuffer[Ptr].Param[4] := true; //------------------- убрать занятость ветви
              OVBuffer[Ptr].Param[8] := true; //----------------------- убрать МСП с ветви
            end else
            begin  //---------------------------------- нет ПК и МК (стрелка без контроля)
              OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //------ взять признак МУ
              OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------- взять занятость
              OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //------------- взять МСП
            end;

            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24]//--- стрелка на МУ
            then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]//копировать значение МИ
            else OVBuffer[Ptr].Param[3] := true; //--------------------- иначе сбросить МИ

            OVBuffer[Ptr].Param[5] := true; //------------- снять маршрутное замыкание "З"
            OVBuffer[Ptr].Param[7] := false; //-------------------------------- снять "РИ"
            OVBuffer[Ptr].Param[10] := false; //------------------------- убрать подсветку
          end else
          begin //------------------------- что будет с веткой минус, если есть МК стрелки
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //---------- копирование РМ
            OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]; //---------- копирование МИ
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //--- копирование занятости

//            if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then  //------------------ если Вз
//            begin
            OVBuffer[Ptr].Param[5] :=OVBuffer[oPtr].Param[5];//копировать маршрутное "З"
            OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7]; //------- копировать "РИ"
//            end else
//            begin
//             OVBuffer[Ptr].Param[5] := true;   //----------------------------- убрать "З"
//              OVBuffer[Ptr].Param[7] := false; //----------------------------- убрать "РИ"
//            end;

            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //---------- копировать МСП
            OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //-- копировать подсветку
          end;

//          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //------------------ если не Вз
//          OVBuffer[Ptr].Param[10] := false; //--------------------------- убрать подсветку

          if ObjZav[OVBuffer[oPtr].DZ1].bParam[7] or //-если активно управление МУ или ...
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and //----- первый проход по трассе и ...
          ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or //---- второй проход по трассе или ...
          ObjZav[OVBuffer[oPtr].DZ1].bParam[13] then //--------------- пошерстная в минусе
          begin
            OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6]; //--скопировать трассировку
          end else
          begin
            OVBuffer[Ptr].Param[6] := true; //------------------- иначе убрать трассировку
            OVBuffer[Ptr].Param[14] := false; //------------- убрать программное замыкание
          end;
        end else //------------------ первый проход, выполняется прорисовка плюсовой ветви
        begin
          Ptr := OVBuffer[Ptr].Jmp1;
          OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];   //---- копия непарафазности
          OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11]; //---- ????????????????????
          OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16]; //-------- копия активности

          //+++++++++++ что будет с веткой плюса, если стрелка в минусе ++++++++++++++++++
          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then //----------------- если нет ПК
          begin
            if ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then //------------------ если есть МК
            begin
              if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] // стрелка на МУ
              then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] //----- копировать РМ
              else OVBuffer[Ptr].Param[2] := false; //-------------------- иначе РМ убрать

              OVBuffer[Ptr].Param[4] := true; //------------------------- убрать занятость
              OVBuffer[Ptr].Param[8] := true; //------------------------------- убрать МСП
            end else
            begin //------------------------------------- ПК,МК нет (стрелка без контроля)
              OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //-------------- копия РМ
              OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------- копия занятости
              OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //------------- копия МСП
            end;
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24]//--------- если МУ
            then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] //------- копировать МИ
            else OVBuffer[Ptr].Param[3] := true; //------------------------- установить МИ

            OVBuffer[Ptr].Param[5] := true; //--------------------------------- убрать "З"
            OVBuffer[Ptr].Param[7] := false; //------------------------------- убрать "РИ"
            OVBuffer[Ptr].Param[10] := false; //------------------------- убрать подсветку
          end else
          begin //--------------------------------------------- ветка плюса при наличии ПК
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //------------- копируем РМ
            OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]; //------------- копируем МИ
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------ копируем занятость
//            if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //------------------- если Вз
//            begin
              OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];  //------------ копия "З"
              OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];  //----------- копия "РИ"
//            end else
//            begin
//              OVBuffer[Ptr].Param[5] := true; //----------------------- иначе сбросить "З"
//              OVBuffer[Ptr].Param[7] := false; //--------------------------- сбросить "РИ"
//            end;
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];   //------------- копия МСП
            OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //------- копия подсветки
          end;

          //--------------------------------------------- не зависимо от положения стрелки
//          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //---------------- если не "Вз"
//          OVBuffer[Ptr].Param[10] := false;

          if ObjZav[OVBuffer[oPtr].DZ1].bParam[6] or // если активно управление ПУ или ...
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and //--- первый проход трассировки и ...
          not ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or //не второй проход трассировки или
          ObjZav[OVBuffer[oPtr].DZ1].bParam[12] then //---- пошерстная в плюсе по маршруту
          begin
            OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6]; //----------- копировать ПУ
          end else
          begin
            OVBuffer[Ptr].Param[6] := true;
            OVBuffer[Ptr].Param[14] := false; //----------- сбросить программное замыкание
          end;
        end;
      end;
    end;

    if Ptr = 0 then Step := 0 else dec(Step);
    OVBuffer[oPtr].StepOver := true;
    result := true;
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.StepOVBuffer]');
    {$ENDIF}
    result := false;
    Application.Terminate;
  end;
end;
//========================================================================================
//-------- перенести в хвост стрелки признаки программного замыкания (нужно для спаренной)
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
begin
try
  if ObjZav[ptr].bParam[14] then
  begin // если устанавливается замыкание - безусловно записать в хвост
    ObjZav[ObjZav[ptr].BaseObject].bParam[14] := true;
  end else
  begin // если снимается замыкание - проверить условия для спаренной
    if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9] = 0 then
    begin // одиночная
      ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
    end else
    begin // спаренная
      if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8] = ptr then
      begin // ближняя стрелка изменила замыкание
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end else
      begin // дальняя стрелка изменила замыкание
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end;
    end;
  end;
except
  {$IFNDEF RMARC}
  reportf('Ошибка [MainLoop.SetPrgZamykFromXStrelka]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//---------------------------------- Обработка диагностики о неисправностях аппаратуры УВК
procedure DiagnozUVK(Index : SmallInt);
var
  u,m,p,o,z,c : cardinal;
  t : boolean;
  msg,ii : Integer;
begin
  try
    c := FR7[Index];

    if NenormUVK[Index] <> c then
    begin
      if c > 0 then
      begin
        u := c and $f0000000; u := u shr 28;  //-------------------- получить номер стойки
        m := c and $0c000000; m := m shr 26;  //--------------- получить номер контроллера
        p := c and $03c00000; p := p shr 22;  //----------------------- получить код платы
        t := (c and $02000000) = $02000000;   //--------- тип платы (М201-true/М203-false)
        o := c and $003f0000; o := o shr 16;  //----------------- получить характер отказа
        z := c and $0000ffff;                 //------------------------ получить параметр

        if (u > 0) and (p > 0) and (o > 0) then
        begin
          s := 'УВК'+ IntToStr(u)+ ' МПСУ'+ IntToStr(m);
          if t then s := s + ' М201'
          else s := s + ' М203';
          s := s + '.' + IntToStr(p and $7);
          case o of
            1 : begin s := s + ' объединение групп '; msg := 3003; end;
            2 : begin s := s + ' обрыв групп '; msg := 3004; end;
            3 : begin s := s + ' отсутствие "0" '; msg := 3005; end;
            4 : begin s := s + ' отсутствие "1" '; msg := 3006; end;
            else   s := s + ' код отказа: '; msg := 3007;
          end;
          s := s + '['+ IntToHEX(z,4)+']';
          AddFixMessage('Сообщение диагностики '+ s,4,4);

          DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
          s := dt + ' > '+ s;
          ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
          NewNeisprav := true; SingleBeep4 := true;
          InsArcNewMsg(z,msg,1);
        end else
        begin //------------------------------------------------- Неопределенное сообщение
          InsArcNewMsg(0,508,1);
          AddFixMessage(GetShortMsg(1,508,'',1),4,4);
        end;
        FR7[Index] := 0; // Сбросить обработанное сообщение
      end;
    end else
    begin
      for ii := 2 to 21 do
      begin
        if NenormUVK[ii] = FR7[ii] then continue
        else NenormUVK[ii] := FR7[ii];
        c := FR7[ii];

        if c > 0 then
        begin
          s := 'Неисправен датчик ';
          if ii < 10 then
          begin
            s := s + NameGrup[ii];
            if c = 1 then s := s +'1'
            else s := s + '2';
          end else
          begin
            if ii >= 21 then continue;
            if c = 1 then s := s + NameO1[ii-9]
            else s := s + NameO2[ii-9];
          end;
          AddFixMessage('Сообщение диагностики '+ s,4,4);
          DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
          s := dt + ' > '+ s;
          ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
          NewNeisprav := true; SingleBeep4 := true;
          z := ii shl 8;
          z := z or c;
          InsArcNewMsg(z,3008,1);
        end;
        
      end;
    end;
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.DiagnozUVK]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------ Получить РМ из маневровой колонки
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;
begin
try
  // Возвращает состояние РМ&ОИ
  // признак разрешения маневров (без учета нажатия кнопки восприятия маневров на колонке)
  result := ObjZav[Ptr].bParam[1] and //-------------------- результат равен РМ и не ОИ(Д)
  not ObjZav[Ptr].bParam[4];
except
  {$IFNDEF RMARC}
  reportf('Ошибка [MainLoop.GetState_Manevry_D]');
  {$ENDIF}
  result := false;
  Application.Terminate;
end;
end;
//========================================================================================
//---------------------------------------- подготовка объектов зависимостей для прорисовки
procedure PrepareOZ;
var
  c,Ptr,ii,k,l,jj : integer;
  s : string;
  st : byte;
  i,j,cfp  : integer;
  fix,fp,fn : Boolean;

begin
  try
    c := 0; k := 1;
    SetDateTimeARM(DateTimeSync);  //------------ Отработать команду синхронизации времени

    if DiagnozON then DiagnozUVK(DiagUVK);//-- Обработать диагностику о неисправностях УВК
    if NewFr6 <> OldFr6 then
    begin
      if NewFr6 > 0 then
      begin
        s :=  'Неисправен датчик ';
        ii :=  NewFr6 and $FF;

        for l := 0 to 7 do
        begin
          k := 1 shl l;
          c :=  ii and k;
          case c of
            0 : k := 8;
            1 : k := 0;
            2 : k := 1;
            4 : k := 2;
            8 : k := 3;
            16 : k := 4;
            32 : k := 5;
            64 : k := 6;
            128 : k := 7;
          end;
          if k > 7 then continue;

          if NewFr6 > 0 then
          begin
            jj := (NewFr6 shr 8)*8 + k;
            s := s + LinkFr[jj].Name + ';';
            InsArcNewMsg(jj,$3010,1);
          end;
        end;

        OldFr6 := NewFr6;
        AddFixMessage('Сообщение диагностики '+ s,4,4);
        DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
        s := dt + ' > '+ s;
        ListDiagnoz := s + #13#10 + ListDiagnoz;
        NewNeisprav := true;
        SingleBeep4 := true;
        OldFr6 := NewFr6;
      end;
    end;

    // WaitForSingleObject(hWaitKanal,ChTO);

{$IFNDEF RMARC}
    //---------------------------------------------------------- копировать буфера FR3,FR4
    if DiagnozON and WorkMode.FixedMsg then
    begin //------------------------ выполнить проверку непарафазности входных интерфейсов
      for Ptr := 1 to FR_LIMIT do
      begin
        if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
        begin
          st := byte(FR3inp[Ptr]);
          if (st and $20) <> (FR3[Ptr] and $20) then // Проверить изменение непарафазности
          begin
            if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4])
            and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr<> MYT[8])
            and (Ptr <> MYT[9]) then
            begin //--------------- если объекты канала не относятся к мифам - фиксировать
              if ((st and $20) <> $20)
              then
              begin
                InsArcNewMsg(Ptr,$3002,7); //"зафиксир.восстановление входного интерфейса"
                FR6[Ptr]:=0;
                NewFR6 :=0;
                OldFr6 := 0;
              end
              else InsArcNewMsg(Ptr,$3001,1);//"зафикс.неисправность входного интерфейса"
            end;
          end;
          FR3[Ptr] := st;
        end;
        if FR4inp[Ptr] > char(0) then
        FR4s[Ptr] := LastTime;
        //if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4s[Ptr] := byte(FR4inp[Ptr])
        //else FR4s[Ptr] := 0;
      end;
    end else
    begin //---------- если диагностика не фиксируется, то просто переписать входной буфер
{$ENDIF}
      for Ptr := 1 to FR_LIMIT do
      begin
{$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}
        //if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4s[Ptr] := byte(FR4inp[Ptr])
        //else FR4s[Ptr] := 0;
      end;
{$IFNDEF RMARC}
    end;
    //WaitForSingleObject(hWaitKanal,ChTO);//+++++++++++++++++++++++++++++++++++++++++++++
    //------------------------------------------------------------ сбросить блокировку FR5
    if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

    //----------------------------------------- подготовка исходных состояний перед циклом
    for Ptr := 1 to WorkMode.LimitObjZav do
    begin
      for ii := 1 to 32 do OVBuffer[ObjZav[ptr].VBufferIndex].Param[ii] := false;

      case ObjZav[Ptr].TypeObj of
        1 :  //--------------------------------------------------- в хвосте каждой стрелки
        begin
          ObjZav[Ptr].bParam[5] := false; //---------- снять  требование перевода охранной
          ObjZav[Ptr].bParam[8] := false; //----- снять признак ожидания перевода охранной
          ObjZav[Ptr].bParam[10] := false;//снять ПСМИ(исключить перевод в + при маневрах)
          ObjZav[Ptr].bParam[11] := false;//снять МСМИ(исключить перевод в - при маневрах)
        end;

        27 : //----------------------------- обработка объекта дополнительных зависимостей
        begin
          ObjZav[Ptr].bParam[5] := false; //----------- снять требование перевода охранной
          ObjZav[Ptr].bParam[8] := false; //----- снять признак ожидания перевода охранной
        end;

        41 : //------------------------------------------ объект охранности стрелок в пути
        begin
          ObjZav[Ptr].bParam[1] := false; //---------- снять признак перевода 1-ой стрелки
          ObjZav[Ptr].bParam[2] := false; //---------- снять признак перевода 2-ой стрелки
          ObjZav[Ptr].bParam[3] := false; //---------- снять признак перевода 3-ей стрелки
          ObjZav[Ptr].bParam[4] := false; //---------- снять признак перевода 4-ой стрелки
          ObjZav[Ptr].bParam[8] := false; //--------- снять признак ожидания перевода 1-ой
          ObjZav[Ptr].bParam[9] := false; //--------- снять признак ожидания перевода 2-ой
          ObjZav[Ptr].bParam[10] := false;//--------- снять признак ожидания перевода 3-ей
          ObjZav[Ptr].bParam[11] := false;//--------- снять признак ожидания перевода 4-ой
        end;

        44 : //------------------------------------------- исключение стрелки при маневрах
        begin
          ObjZav[Ptr].bParam[1] := false; //------------  снять исключение перевода в плюс
          ObjZav[Ptr].bParam[2] := false; //------------ снять исключение перевода в минус
          ObjZav[Ptr].bParam[5] := false; //----------- снять требование перевода охранной
          ObjZav[Ptr].bParam[8] := true; //--------- установить ожидание перевода охранной
        end;

        48 : ObjZav[Ptr].bParam[1] := false; //РПО ---- снять разрешение маневров в районе
      end;
    end;
    //WaitForSingleObject(hWaitKanal,ChTO);

    //---------------------------------------------------- подготовка отображения на табло
    for Ptr := 1 to WorkMode.LimitObjZav do
    begin
      case ObjZav[Ptr].TypeObj of
  //    1 : ------------------------------------------- хвост стрелки обрабатывается далее
  //    2 : ------------------------------------------------- стрелка обрабатывается далее
        3  : PrepSekciya(Ptr);//--------------------------------------------------- секция
        4  : PrepPuti(Ptr); //------------------------------------------------------- путь
        6  : PrepPTO(Ptr);       //--------------------------------------- ограждение пути
        7  : PrepPriglasit(Ptr); //-------------------------------- пригласительный сигнал
        8  : PrepUTS(Ptr);  //
        9  : PrepRZS(Ptr);  //----------------------------------- ручное замыкание стрелок
        10 : PrepUPer(Ptr); //--------------------------------------- управление переездом
        11 : PrepKPer(Ptr); //----------------------------------- контроль переезда (тип1)
        12 : PrepK2Per(Ptr);//----------------------------------- контроль переезда (тип2)
        13 : PrepOM(Ptr);
        14 : PrepUKSPS(Ptr); //------------------------- контроль схода подвижного состава
        15 : PrepAB(Ptr);
        16 : PrepVSNAB(Ptr);
        17 : PrepMagStr(Ptr);//------------------------------------- стрелочная магистраль
        18 : PrepMagMakS(Ptr);
        19 : PrepAPStr(Ptr);
        20 : PrepMaket(Ptr);
        21 : PrepOtmen(Ptr);
        22 : PrepGRI(Ptr);
        23 : PrepMEC(Ptr);
        24 : PrepZapros(Ptr);
        25 : PrepManevry(Ptr);
        26 : PrepPAB(Ptr);
//      27 : ---------------------------------------- ДЗ для стрелки обрабатывается дальше
//      28 : PrepPI(Ptr) ---------------------------- не требует предварительной обработки
//      29 : ------------------------------ ДЗ для СП не требует предварительной обработки
        30 : PrepDSPP(Ptr); //------------------------------ объекта дачи поездного приема
        31 : PrepPSvetofor(Ptr); //--------------------------------- повторитель светофора
        32 : PrepNadvig(Ptr);
        33 : PrepSingle(Ptr);     //---------------------------- объект - одиночный датчик
        34 : PrepPitanie(Ptr);
        35 : PrepInside(Ptr);
        36 : PrepSwitch(Ptr);      //------------------------ объект - кнопка + 5 датчиков
        37 : PrepIKTUMS(Ptr);       //------------ объект - исполнительный контроллер ТУМС
        38 : PrepMarhNadvig(Ptr);
        39 : PrepKRU(Ptr);
        40 : PrepIzvPoezd(Ptr);
//      41 : ----------------------------------------- стрелка в пути обрабатывается далее
        42 : PrepVP(Ptr);
        43 : PrepOPI(Ptr);
        45 : PrepKNM(Ptr); //------------------- Подготовка объекта выбора зоны оповещения
        46 : PrepAutoSvetofor(Ptr);
        48 : PrepRPO(Ptr);
        49 : PrepABTC(Ptr);
        50 : PrepDCSU(Ptr);
        51 : PrepDopDat(Ptr);
        52 : PrepSVMUS(Ptr);
//      53 : ---------------------- Сборка трассы МУС не требует предварительной обработки
        54 : PrepST(Ptr);
        55 : PrepDopSvet(Ptr);
        56 : PrepUKG(Ptr); //---------------------- объект "Устройство контроля габаритов"
        92 :PrepDN(Ptr); //-------------------------------------------- объект "День-Ночь"
      end;

      inc(c);

      if c > 500 then c := 0;

      if LiveCounter > MaxLiveCtr then LiveCounter := 0;

  end;

  //-------------------------------------------------------- обработка вторичных состояний
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then  LiveCounter := 0;
  end;


  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    if ObjZav[Ptr].TypeObj = 2 then PrepOxranStrelka(Ptr);
    if ObjZav[Ptr].TypeObj = 27 then PrepDZStrelki(Ptr);
  end;

  //--------------------------------------------- Вывод на табло охранностей стрелки и др.
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      2  : PrepStrelka(Ptr);
      41 : PrepVPStrelki(Ptr);
      43 : PrepSOPI(Ptr);
      47 : PrepAutoMarshrut(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then LiveCounter := 0;
  end;

  //--------------------------------------------------------- Обработка буфера отображения
  c := 0;
  for Ptr := 1 to 2000 do OVBuffer[Ptr].StepOver := false;
  for Ptr := 1 to 2000 do
  begin
    if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
    inc(c);
    if c > 999 then c := 0;
  end;

{$IFDEF RMARC}
    SrvState := FR3[WorkMode.ServerStateSoob];
{$ENDIF}

//---------------------- количество рабочих серверов, исправность кнопки выбора управления
    if Config.configKRU = 1 then
    begin //-------------------------------------------------------------------- с кнопкой
      if (SrvState and $7) = 0 then
      begin //------------------------------------- неисправность кнопки выбора управления
        SrvCount := 1;
        WorkMode.RUError := WorkMode.RUError or $4;
      end else
      begin //--------------------------------------- исправность кнопки выбора управления
        SrvCount := 2;
        WorkMode.RUError :=  WorkMode.RUError and $FB;
      end;
      //------------------------------------------------------------- номер рабочего места
      if SrvState and $30 = $10 then SrvActive := 1 else
      if SrvState and $30 = $20 then SrvActive := 2 else
      if SrvState and $30 = $30 then SrvActive := 3 else
      SrvActive := 0;
    end else
    begin //------------------------------------------------------------------- на сервере
      //-------------------------------------------------------------- количество серверов
      if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or
      ((SrvState and $7) = 0) then SrvCount := 1
      else
      if (SrvState and $7) = 7 then SrvCount := 3
      else SrvCount := 2;

      //---------------------------------------------------------- номер активного сервера
      if ((LastRcv + MaxTimeOutRecave) > LastTime) then
      begin
      if (SrvState and $30) = $10 then SrvActive := 1
      else
      if (SrvState and $30) = $20 then SrvActive := 2
      else
      if (SrvState and $30) = $30 then SrvActive := 3 else SrvActive := 0;
    end
    else SrvActive := 0;
  end;

{$IFNDEF RMARC}
  //-------------------------------------------------  Состояние каналов связи с серверами
  if (KanalSrv[1].Index > 0) or (KanalSrv[1].nPipe <> 'null') then
  begin
    if KanalSrv[1].iserror then ArmSrvCh[1] := 1 //---- если в канале 1 фиксирована ошибка
    else
    if KanalSrv[1].cnterr > 2 then ArmSrvCh[1] := 2 //в канале 1 число ошибок символов > 2
    else
    if MySync[1] then ArmSrvCh[1] := 4 //----- если по каналу получен маркер синхронизации
    else ArmSrvCh[1] := 8; //---------------------------------- обычное исходное состояние
  end;

  if (KanalSrv[2].Index > 0) or (KanalSrv[2].nPipe <> 'null') then
  begin
    if KanalSrv[2].iserror then ArmSrvCh[2] := 1
    else
    if KanalSrv[2].cnterr > 2 then ArmSrvCh[2] := 2
    else
    if MySync[2] then ArmSrvCh[2] := 4
    else ArmSrvCh[2] := 8;
  end;
{$ENDIF}

{$IFDEF RMSHN}
  //------------------------------------------------------------------- обработать события
  for i := 1 to 10 do
  begin
    cfp := 0;
    if FixNotify[i].Enable and (
    (FixNotify[i].Datchik[1] > 0) or
    (FixNotify[i].Datchik[2] > 0) or
    (FixNotify[i].Datchik[3] > 0) or
    (FixNotify[i].Datchik[4] > 0) or
    (FixNotify[i].Datchik[5] > 0) or
    (FixNotify[i].Datchik[6] > 0)
    ) then

    for j := 1 to 6 do
    if FixNotify[i].Datchik[j] > 0 then
    begin
      fp := GetFR3(LinkFR[FixNotify[i].Datchik[j]].FR3,fn,fn);//-------- состояние датчика
      fix := (FixNotify[i].State[j] = fp) and not fn;
      if fix then inc(cfp);
    end;

    if cfp > 0 then
    begin //---------------------------------------------------- выдать реакцию на событие

      for k := 1 to 6 do
      if FixNotify[i].Datchik[k] > 0 then dec(cfp);

      if cfp = 0 then
      begin
        if not FixNotify[i].fix then
        begin
          FixNotify[i].beep := true;
          if FixNotify[i].Obj > 0 then
          begin
            ID_ViewObj := FixNotify[i].Obj;
            ValueListDlg.Show;
          end;
        end;
        FixNotify[i].fix := true;
      end
      else FixNotify[i].fix := false;
    end
    else  FixNotify[i].fix := false;
  end;
{$ENDIF}


{$IFDEF RMDSP}
{
  if DspT                                                                                                                                                                                                                                                                                                                                                                                                                      oDspEnabled then
  begin //--------------------------------------------------------- канал ДСП-ДСП2 включен
    if DspToDspConnected then
    begin
      if DspToDspAdresatEn then ArmAsuCh[1] := 2 //--------------------- полное соединение
      else ArmAsuCh[1] := 1; //----------------------------- ожидание подключения дальнего
    end
    else ArmAsuCh[1] := 0; //---------------------------------------------- нет соединения
  end
  else ArmAsuCh[1] := 255; //------------------------------------- канал ДСП-ДСП2 отключен
}

{$ENDIF}
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepareOZ]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
procedure PrepareOZ1(Ptr : Integer);
var
  jj : integer;
begin
    case ObjZav[Ptr].TypeObj of
    2  :
    begin
      for jj := 1 to 2000
      do if OVBuffer[jj].Steps > 0 then
      GoOVBuffer(jj,OVBuffer[jj].Steps);
     // PrepXStrelki(Ptr+1);
     // PrepStrelka(Ptr);
    end;
  end;
{
  case ObjZav[Ptr].TypeObj of
    1 :  //--------------------------------------------------- в хвосте каждой стрелки
    begin
      ObjZav[Ptr].bParam[5] := false; //---------- снять  требование перевода охранной
      ObjZav[Ptr].bParam[8] := false; //----- снять признак ожидания перевода охранной
      ObjZav[Ptr].bParam[10] := false;//снять ПСМИ(исключить перевод в + при маневрах)
      ObjZav[Ptr].bParam[11] := false;//снять МСМИ(исключить перевод в - при маневрах)
    end;

    27 : //----------------------------- обработка объекта дополнительных зависимостей
    begin
      ObjZav[Ptr].bParam[5] := false; //----------- снять требование перевода охранной
      ObjZav[Ptr].bParam[8] := false; //----- снять признак ожидания перевода охранной
    end;

    41 : //------------------------------------------ объект охранности стрелок в пути
    begin
      ObjZav[Ptr].bParam[1] := false; //---------- снять признак перевода 1-ой стрелки
      ObjZav[Ptr].bParam[2] := false; //---------- снять признак перевода 2-ой стрелки
      ObjZav[Ptr].bParam[3] := false; //---------- снять признак перевода 3-ей стрелки
      ObjZav[Ptr].bParam[4] := false; //---------- снять признак перевода 4-ой стрелки
      ObjZav[Ptr].bParam[8] := false; //--------- снять признак ожидания перевода 1-ой
      ObjZav[Ptr].bParam[9] := false; //--------- снять признак ожидания перевода 2-ой
      ObjZav[Ptr].bParam[10] := false;//--------- снять признак ожидания перевода 3-ей
      ObjZav[Ptr].bParam[11] := false;//--------- снять признак ожидания перевода 4-ой
    end;

    44 : //------------------------------------------- исключение стрелки при маневрах
    begin
      ObjZav[Ptr].bParam[1] := false; //------------  снять исключение перевода в плюс
      ObjZav[Ptr].bParam[2] := false; //------------ снять исключение перевода в минус
      ObjZav[Ptr].bParam[5] := false; //----------- снять требование перевода охранной
      ObjZav[Ptr].bParam[8] := true; //--------- установить ожидание перевода охранной
    end;

    48 : ObjZav[Ptr].bParam[1] := false; //РПО ---- снять разрешение маневров в районе
  end;
   //---------------------------------------------------- подготовка отображения на табло

  case ObjZav[Ptr].TypeObj of
    2  :
    begin
      for jj := 1 to 2000
      do if OVBuffer[jj].Steps > 0 then
      GoOVBuffer(jj,OVBuffer[jj].Steps);
      PrepXStrelki(Ptr+1);
      PrepStrelka(Ptr);
    end;
    3  : PrepSekciya(Ptr);//--------------------------------------------------- секция
    4  : PrepPuti(Ptr); //------------------------------------------------------- путь
    5  : PrepSvetofor(Ptr);
    6  : PrepPTO(Ptr);       //--------------------------------------- ограждение пути
    7  : PrepPriglasit(Ptr); //-------------------------------- пригласительный сигнал
    8  : PrepUTS(Ptr);  //
    9  : PrepRZS(Ptr);  //----------------------------------- ручное замыкание стрелок
    10 : PrepUPer(Ptr); //--------------------------------------- управление переездом
    11 : PrepKPer(Ptr); //----------------------------------- контроль переезда (тип1)
    12 : PrepK2Per(Ptr);//----------------------------------- контроль переезда (тип2)
    13 : PrepOM(Ptr);
    14 : PrepUKSPS(Ptr); //------------------------- контроль схода подвижного состава
    15 : PrepAB(Ptr);
    16 : PrepVSNAB(Ptr);
    17 : PrepMagStr(Ptr);//------------------------------------- стрелочная магистраль
    18 : PrepMagMakS(Ptr);
    19 : PrepAPStr(Ptr);
    20 : PrepMaket(Ptr);
    21 : PrepOtmen(Ptr);
    22 : PrepGRI(Ptr);
    23 : PrepMEC(Ptr);
    24 : PrepZapros(Ptr);
    25 : PrepManevry(Ptr);
    26 : PrepPAB(Ptr);
    31 : PrepPSvetofor(Ptr); //--------------------------------- повторитель светофора
    32 : PrepNadvig(Ptr);
    33 : PrepSingle(Ptr);     //---------------------------- объект - одиночный датчик
    34 : PrepPitanie(Ptr);
    35 : PrepInside(Ptr);
    36 : PrepSwitch(Ptr);      //------------------------ объект - кнопка + 5 датчиков
    37 : PrepIKTUMS(Ptr);       //------------ объект - исполнительный контроллер ТУМС
    38 : PrepMarhNadvig(Ptr);
    39 : PrepKRU(Ptr);
    40 : PrepIzvPoezd(Ptr);
    42 : PrepVP(Ptr);
    43 : PrepOPI(Ptr);
    45 : PrepKNM(Ptr); //------------------- Подготовка объекта выбора зоны оповещения
    46 : PrepAutoSvetofor(Ptr);
    48 : PrepRPO(Ptr);
    49 : PrepABTC(Ptr);
    50 : PrepDCSU(Ptr);
    51 : PrepDopDat(Ptr);
    52 : PrepSVMUS(Ptr);
    54 : PrepST(Ptr);
    55 : PrepDopSvet(Ptr);
    56 : PrepUKG(Ptr); //---------------------- объект "Устройство контроля габаритов"
    92 :PrepDN(Ptr); //-------------------------------------------- объект "День-Ночь"
  end;



  if ObjZav[Ptr].TypeObj = 2 then PrepOxranStrelka(Ptr);
  if ObjZav[Ptr].TypeObj = 27 then PrepDZStrelki(Ptr);

  case ObjZav[Ptr].TypeObj of

    41 : PrepVPStrelki(Ptr);
    43 : PrepSOPI(Ptr);
    47 : PrepAutoMarshrut(Ptr);
  end;

}
// if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
 
end;
//========================================================================================
//--------------------------------------------------- Подготовка объекта хвоста стрелки #1
procedure PrepXStrelki(Ptr : Integer);
var
  i, o, p, str_1, str_2, sp_1, sp_2 : integer;
  pk,mk,pks,nps,d,bl : boolean;
  {$IFDEF RMSHN} dvps : Double; {$ENDIF}
begin
  try
    inc(LiveCounter);
    str_1 := ObjZav[Ptr].ObjConstI[8]; //----------------- первая стрелка хвоста (ближняя)
    str_2 := ObjZav[Ptr].ObjConstI[9]; //----------------- вторая стрелка хвоста (дальняя)
    sp_1 := ObjZav[str_1].UpdateObject;
    sp_2 := ObjZav[str_2].UpdateObject;
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false;//------------------------------------- Непарафазность

    pk :=
      GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ПК
    mk :=
      GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //МК
  //----------------------------------------------------------------- непостановка стрелки
    nps:=
      GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);
  //-------------------------------------------------------------- потеря контроля стрелки
    pks :=
      GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  //------------------------------------------ если парафазность или активность информации
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
{$IFDEF RMSHN}  //------------------------------------------------------------ для АРМа ШН
      //------------------------ если нет ни ПК, ни МК, ни ПКС, и не активны таймеры 1 и 2
      if not(pk or mk or pks or ObjZav[Ptr].Timers[1].Active
      or ObjZav[Ptr].Timers[2].Active)
      then
      begin
        if ObjZav[Ptr].sbParam[2] then  //-------------- если предыдущее положение "минус"
        begin //-------------- фиксируем время начала потери контроля минусового положения
          ObjZav[Ptr].Timers[2].Active := true; //---------------- активизировать таймер 2
          ObjZav[Ptr].Timers[2].First := LastTime; //------------- запомнить текущее время
        end;

        if ObjZav[Ptr].sbParam[1] then //---------------- если предыдущее положение "плюс"
        begin //--------------- фиксируем время начала потери контроля плюсового положения
          ObjZav[Ptr].Timers[1].Active := true; //---------------- активизировать таймер 1
          ObjZav[Ptr].Timers[1].First := LastTime; //------------- запомнить текущее время
        end;
      end;
{$ENDIF}

      if pk and mk then //------------------------------------ если и ПК и МК одновременно
      begin
        pk := false; //---------------- принудительно сбросить ПК и МК если оба возбуждены
        mk := false;
      end;

      if ObjZav[Ptr].bParam[25] <> nps then //------ если изменился бит неперевода стрелки
      begin
        if nps then //------------------------------------- если получен неперевод стрелки
        begin
          if WorkMode.FixedMsg then //---------------- если установлена фиксация сообщений
          begin
{$IFDEF RMSHN}
            InsArcNewMsg(Ptr,270+$1000,1); //----------------- "стрелка <Ptr> не переведа"
            ObjZav[Ptr].dtParam[2] := LastTime;//запомни время события "неперевод стрелки"
            inc(ObjZav[Ptr].siParam[3]); //----------------- увеличить счетчик непереводов
{$ELSE}
            if config.ru = ObjZav[ptr].RU then //----если стрелка в районе управления АРМа
            begin
              InsArcNewMsg(Ptr,270+$1000,1); //--------------- "стрелка <Ptr> не переведа"
              AddFixMessage(GetShortMsg(1,270,ObjZav[ptr].Liter,1),4,1);
            end;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[25] := nps;  //-------------- фиксируем состояние бита неперевода

      d := false;
      o := ObjZav[Ptr].ObjConstI[6]; //------------------ берем индекс для возможного МУ-1

      if o > 0 then //---------------------- если стрелка действительно имеет связь с МУ-1
      begin //---------------------- проверить передачу на управление в маневровый район 1
        case ObjZav[o].TypeObj of //---------------------- переключиться по типу района МУ
          25 : d := GetState_Manevry_D(o); //--- если маневровая колонка, то получить РМ&Д
          44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); //исключ. из маневров - РМ&Д
        end;
      end;

      if not d then //-------------------------------------------------------- если нет РМ
      begin
        o := ObjZav[Ptr].ObjConstI[7]; //------------- получить индекс для возможного МУ-2
        if o > 0 then
        begin //-------------------- проверить передачу на управление в маневровый район 2
          case ObjZav[o].TypeObj of
            25 : d := GetState_Manevry_D(o); //-------------------------------------- РМ&Д
            44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); //------------------- РМ&Д
          end;
        end;
      end;

      if d then ObjZav[Ptr].bParam[24] := true //если РМ, то ставим признак "местн.управл"
      else ObjZav[Ptr].bParam[24] := false; //------  если нет РМ, то снимаем признак "МУ"

      if ObjZav[Ptr].bParam[26] <> pks then //- если изменился бит потери контроля стрелки
      begin
        if pks then //----------------------------------- получена потеря контроля стрелки
        begin
{$IFDEF RMSHN}
          ObjZav[Ptr].Timers[1].Active := false; //---------- сбросить таймер потери плюса
          ObjZav[Ptr].Timers[2].Active := false; //--------- сбросить таймер потери минуса
          if WorkMode.FixedMsg and WorkMode.OU[0] //-- если фиксация и управление от УВК и
          and WorkMode.OU[ObjZav[Ptr].Group] and not d then //--------------- КРУ и нет РМ
          begin
            InsArcNewMsg(Ptr,271+$1000,0); // ---------- "стрелка <Ptr> потеряла контроль"
            SingleBeep3 := true;
            ObjZav[Ptr].dtParam[1] := LastTime;//фиксируем время события "потеря контроля"
            if ObjZav[Ptr].sbParam[1] then //------------------- если стрелка была в плюсе
            begin
              if ObjZav[Ptr].bParam[22] then //------------- если секция стрелки не занята
              inc(ObjZav[Ptr].siParam[1]) //---- увеличить счетчик потерь контроля в плюсе
            else
            inc(ObjZav[Ptr].siParam[6]);//счет потерь контроля "+"  при занятости секции
          end;

          if ObjZav[Ptr].sbParam[2] then //-------------------- если стрелка была в минусе
          begin
            if ObjZav[Ptr].bParam[22] then //--------------- если секция стрелки не занята
            inc(ObjZav[Ptr].siParam[2]) //--------------- счетчик потерь контроля в минусе
            else
              inc(ObjZav[Ptr].siParam[7]); //счет потерь контроля "-" при занятости секции
          end;
        end;
{$ELSE}
        if WorkMode.FixedMsg and not d then //-- если фиксируем и не на местном управлении
        begin
          if config.ru = ObjZav[ptr].RU then //----- если стрелка в районе управления АРМа
          begin
            InsArcNewMsg(Ptr,271+$1000,0);//------------ "стрелка <Ptr> потеряла контроль"
            AddFixMessage(GetShortMsg(1,271,ObjZav[ptr].Liter,0),4,3);
          end;
        end;
{$ENDIF}
      end else //--------------------------------------------- если контроль восстановился
      begin
        if WorkMode.FixedMsg and not d then //---------- если фиксация включена и не на МУ
        begin
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,345+$1000,0); //---"восстановлен контроль положения стрелки <Ptr>
          SingleBeep2 := true;
{$ELSE}
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,345+$1000,0);
            AddFixMessage(GetShortMsg(1,345,ObjZav[ptr].Liter,0),5,2);
          end;
{$ENDIF}
        end;
      end;
    end;

    ObjZav[Ptr].bParam[26] := pks; //--------------- фиксируем значение бита ПКС в объекте

    ObjZav[Ptr].bParam[1] := pk; //---------------------------------------------------- ПК
    ObjZav[Ptr].bParam[2] := mk; //---------------------------------------------------- МК
{$IFDEF RMSHN}
    if pk then //-----------------------------------------------------если стрелка в плюсе
    begin
      ObjZav[Ptr].Timers[1].Active := false;//-----------------------------сброс таймера 1

      if ObjZav[Ptr].Timers[2].Active //----------------------------- если таймер2 активен
      then
      begin //------------------------------------- фиксируем длительность перевода в плюс
        ObjZav[Ptr].Timers[2].Active := false;//------------------------- останов таймера2
        dvps := LastTime - ObjZav[Ptr].Timers[2].First;//считаем длительность перевода в +
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[4] > StatStP then //--если переводов больше миним.выборки
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * StatStP + dvps)/(StatStP+1); //------среднее
          end else //----------------------------- если выборка мала для общего осреднения
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * ObjZav[Ptr].siParam[4] +
            dvps)/(ObjZav[Ptr].siParam[4]+1);
          end;
          ObjZav[Ptr].dtParam[3] := dvps;
        end;
      end;

      if not ObjZav[Ptr].sbParam[1] then //----------- если раньше стрелка была не в плюсе
      begin //----------------------------- история ПК -----------------------------------
        ObjZav[Ptr].sbParam[1] := pk;//---------------------------запомним значение для ПК
        ObjZav[Ptr].sbParam[2] := mk;//---------------------------запомним значение для МК
        if not StartRM then //------------------------------если не этап запуска программы
        inc(ObjZav[Ptr].siParam[4]);//-------------------- увеличить счетчик переводов в +
      end;
    end;

    if mk then//-----------------------------------------------------если стрелка в минусе
    begin
      ObjZav[Ptr].Timers[2].Active := false; //-------------------------остановить таймер2
      if ObjZav[Ptr].Timers[1].Active then //------------------------если работает таймер1
      begin //------------------------------------ фиксируем длительность перевода в минус
        ObjZav[Ptr].Timers[1].Active := false;//------------------------остановить таймер1
        dvps := LastTime - ObjZav[Ptr].Timers[1].First;//-------считаем время перевода в -
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[5] > StatStP then//переводов в минус больше миним.выборки
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * StatStP + dvps)/(StatStP+1); //------среднее
          end else
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * ObjZav[Ptr].siParam[5] +
            dvps)/(ObjZav[Ptr].siParam[5]+1);
          end;
          ObjZav[Ptr].dtParam[4] := dvps;//-----------------запомнить время перевода в "-"
        end;
      end;

      if not ObjZav[Ptr].sbParam[2] then   //-------- если раньше стрелка была не в минусе
      begin //---------------------------- история МК ------------------------------------
        ObjZav[Ptr].sbParam[1] := pk;//---------------------------запомним значение для ПК
        ObjZav[Ptr].sbParam[2] := mk;//---------------------------запомним значение для МК
        if not StartRM then //------------------------------если не этап запуска программы
        inc(ObjZav[Ptr].siParam[5]);//-------------------- увеличить счетчик переводов в -
      end;
    end;
{$ENDIF}

    if ObjZav[Ptr].ObjConstB[3] then  //-------------- если для стрелки надо проверять МСП
    begin //--------------------------------------------------------------- сбор МСП из СП
      if ObjZav[str_1].ObjConstB[9] then //---------если первая стрелка имеет в хвосте МСП
      ObjZav[Ptr].bParam[20] :=  ObjZav[sp_1].bParam[4];//-- по значению МСП из объекта СП

      if (str_2 > 0) and ObjZav[str_2].ObjConstB[9] then//есть вторая стрелка и  имеет МСП
      if ObjZav[Ptr].bParam[20] then //-если МСП ранее не установлено, то взять из объекта
      ObjZav[Ptr].bParam[20] := ObjZav[SP_2].bParam[4];//СП 2-ой стрелки
    end
    else ObjZav[Ptr].bParam[20] := true; //--если МСП проверять не надо, то сбрасываем МСП

    //----------------------------------------- сбор замыканий из СП ---------------------
    d := ObjZav[sp_1].bParam[2];//----------------------- значение замыкания из СП ближней
    if str_2 > 0 then//----------------------------------------- если есть дальняя стрелка
    if d then d := ObjZav[SP_2].bParam[2]; //------ если ближняя не замкнута из СП дальней

    if d <> ObjZav[Ptr].bParam[21] then //------------ если состояние замыкания изменилось
    begin
      ObjZav[Ptr].bParam[6] := false;//--------------------------------- сброс признака ПУ
      ObjZav[Ptr].bParam[7] := false; //-------------------------------- сброс признака МУ

      //------------------------------------- перенести в признак активизации автовозврата
      bl :=  ObjZav[sp_1].bParam[20];// -------- блокировка из ближней по неисправности СП
      if (str_2 > 0) and (not bl) then //--- если есть дальняя и нет блокировки из ближней
      bl :=  ObjZav[sp_2].bParam[20]; //---------------------------------- блокировка 2-ой

      ObjZav[Ptr].bParam[3] := d and//признак размыкания для автовозврата = замыканию СП и
      not bl and //----------------------------------------------- отсутствию блокировки и
      ObjZav[Ptr].ObjConstB[2] and //--------------------- наличию признака автовозврата и
      (not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2]);//----------- стрелка в минусе
    end;

    ObjZav[Ptr].bParam[21] := d; //------------------------- запомнить состояние замыкания

    //--------------------------------------------------------------- сбор занятости из СП
    ObjZav[Ptr].bParam[22] := ObjZav[sp_1].bParam[1]; //---- взять занятость из ближней СП

    if str_2 > 0 then //---------------------------------------- если есть дальняя стрелка
    if ObjZav[Ptr].bParam[22] then //---------------- если не было занятости от ближней,то
    ObjZav[Ptr].bParam[22] := ObjZav[sp_2].bParam[1]; //---------------- занятость дальней

    //-------------------------------------------------------- Сброс признаков трассировки
    ObjZav[Ptr].bParam[23] := false;
    inc(LiveCounter);//---------------------------- увеличить счет ожидания длинных циклов

    //-------------------------------------------- проверка передачи на местное управление
    ObjZav[Ptr].bParam[9] := false; //-------------------------------- сбросить признак РМ
    for i := 20 to 24 do //--------------------------- пройти по 5-ти возможным районам МУ
    if ObjZav[Ptr].ObjConstI[i] > 0 then //---- если такой район на станции существует, то
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of //---- переключатель по типу района
        25 :  //------------------------------------------------------- маневровая колонка
          if not ObjZav[Ptr].bParam[9] then //---- если нет признака ------------------ РМ
          ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]); //-- РМ&Д
        44 : //-------------------------------------------- исключение стрелки из маневров
          if not ObjZav[Ptr].bParam[9] then //----------------------- если нет признака РМ
          ObjZav[Ptr].bParam[9] :=
          GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
      end;
    end;

    //--------------------------------------------------------- Проверка ручного замыкания
    ObjZav[Ptr].bParam[4] := false; //-------------------- сброс дополнительного замыкания
    ObjZav[Ptr].bParam[4] := ObjZav[Ptr].bParam[4] or
    ObjZav[Ptr-1].bParam[33] or ObjZav[Ptr-1].bParam[25]; //------------- если НАС или ЧАС

    if ObjZav[Ptr].ObjConstI[12] > 0 then //----------- если есть ручное замыкание стрелки
    begin
      if ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[1] then //-- если активен признак РЗ или
      ObjZav[Ptr].bParam[4] := true;  //------------------------- установить доп.замыкание
    end;


    if ObjZav[Ptr].bParam[21] then //------------------- если нет признака замыкания от СП
    begin
      if not ObjZav[Ptr].bParam[4] then //--------------------- если нет дополн. замыкания
      //----------------------------------------------------- проверки двойного управления
      for i := 6 to 7 do //------------------------- пройти по 2-ум возможным районам МУ
      begin
        o := ObjZav[Ptr].ObjConstI[i];//---------------------------- взять индекс района
        if o > 0 then //------------------------------------ если для стрелки есть район
        begin

          case ObjZav[o].TypeObj of //--------------------- переключатель по типу района
            25 : // ------------------------------------------------- маневровая колонка
            begin
              if not ObjZav[o].bParam[3] then //--------------------------- если есть МИ
              begin
                ObjZav[Ptr].bParam[4] := true; //--------- установить дополнит.замыкание
                break;
              end;
            end;
            44 ://--------------------------------------- исключение стрелки из маневров
            begin
              if not ObjZav[ObjZav[o].BaseObject].bParam[3] then //-------- если есть МИ
              begin
                ObjZav[Ptr].bParam[4] := true; //--------- установить дополнит.замыкание
                break;
              end;
            end;
          end;
        end;
      end;

      //---------------------------------------------------------------- проверки маневров
      for i := 20 to 24 do //---------------- пройти по 5-ти возможным объектам районов МУ
      begin
        o := ObjZav[Ptr].ObjConstI[i]; //----------------------- получить очередной объект
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            25 :
            begin
              if not ObjZav[o].bParam[3] then //---------------------------------- если МИ
              begin
                ObjZav[Ptr].bParam[4] := true; //----------- установить дополнит.замыкание
                break;
              end;
            end;
            44 :
            begin
              if not ObjZav[ObjZav[o].BaseObject].bParam[3] then //--------------- если МИ
              begin
                ObjZav[Ptr].bParam[4] := true; //----------- установить дополнит.замыкание
                break;
              end;
            end;
          end;
        end;
      end;

      if not ObjZav[Ptr].bParam[4] then//-------------- если нет дополнительного замыкания
      //---------------------------------------------------------- проверки хвоста стрелки
      for i := 14 to 19 do //----------------- пройти по 6-ти возможным объектам замыкания
      begin
        o := ObjZav[Ptr].ObjConstI[i];//--------------------------------- очередной объект
        if o > 0 then //-------------------------------------------- если этот объект есть
        begin
          case ObjZav[O].TypeObj of //---------------------- переключатель по типу объекта
            3 : //----------------------------------------------------------------- секция
            begin
              if not ObjZav[o].bParam[2] then //--------------------- если секция замкнута
              begin
                ObjZav[Ptr].bParam[4] := true; //---------------- установить доп.замыкание
                break;
              end;
            end;

            25 :  //--------------------------------------------------- маневровая колонка
            begin
              if not ObjZav[o].bParam[3] then  //--------------------------------- если МИ
              begin
                ObjZav[Ptr].bParam[4] := true; //-------------- установить доп.замыкание
                break;
              end;
            end;

            27 : //------------------------------------------------------ охранная стрелка
            begin
              if not ObjZav[ObjZav[o].ObjConstI[2]].bParam[2] then //---- если СП замкнута
              begin
                if ObjZav[o].ObjConstB[1] then //------------------ если контроль по плюсу
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[2] then //----- если нет МК
                  begin
                    ObjZav[Ptr].bParam[4] := true; //------------ установить доп.замыкание
                    break;
                  end;
                end else//------------------------------------- если нет контроля по плюсу
                if ObjZav[o].ObjConstB[2] then //----------------- если контроль по минусу
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[1] then //-- стрелка не в +
                  begin
                    ObjZav[Ptr].bParam[4] := true; //------------ установить доп.замыкание
                    break;
                  end;
                end;
              end
              else
            end;

            41 :  //------------------ охранность стрелки в пути для маршрутов отправления
            begin
              if ObjZav[o].bParam[20] and//----- если есть признак поездного отправления и
              not ObjZav[ObjZav[o].UpdateObject].bParam[2] then//- контрольная СП замкнута
              begin
                ObjZav[Ptr].bParam[4] := true; //---------------- установить доп.замыкание
                break;
              end;
            end;

            46 : //------------------------------------------------- автодействие сигналов
            begin
              if ObjZav[o].bParam[1] then  //-------------------если включено автодействие
              begin
                ObjZav[Ptr].bParam[4] := true;//----------------- установить доп.замыкание
                break;
              end;
            end;
          end;
        end;
      end;

      if not ObjZav[Ptr].bParam[4] and //------------ если нет дополнительного замыкания и
      (ObjZav[Ptr].ObjConstI[8] > 0) then //------------------------- есть ближняя стрелка
      if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[7]) then //----если замыкать по плюсу
      begin
        inc(LiveCounter);
        o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Obj;//---- сосед ближней по "+"
        p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Pin;//--- № точки соседа по "+"
        i := 100;//-------------- установить допустимое число шагов(более чем достаточное)
        while i > 0 do //------------------------ цикл до максимума, если не выйдем раньше
        begin
          case ObjZav[o].TypeObj of //--------- переключатель по типу примыкающего объекта
            2 : //---------------------------------------------------------------- стрелка
            begin
              case p of//----------------------- переключатель по номеру точки подключения
                2 :
                begin //--------------------------- Вход на соседнюю стрелку через её плюс
                  if ObjZav[o].bParam[2] //---------- если соседняя стрелка стоит в минусе
                  then break; //------------------------------- стрелка в отводе по минусу
                end;

                3 :
                begin //-------------------------- Вход на соседнюю стрелку через её минус
                  if ObjZav[o].bParam[1] //----------------- если соседняя стрелка в плюсе
                  then break; //-------------------------------- стрелка в отводе по плюсу
                end;

                else//------------------------------если вышли на точку 1 соседней стрелки
                  ObjZav[Ptr].bParam[4] := true;//------------------------------- замкнуть
                  break; //------------------------------------------ ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin;//----- № точки следующего соседа по точке 1
              o := ObjZav[o].Neighbour[1].Obj;//---------- сосед соседа по точке 1 стрелки
            end;

            //----------------------------------------------------------------------------
            3,4 : //--------------------------------------------------------- участок,путь
            begin
              ObjZav[Ptr].bParam[4] :=//-------------- установить дополнительное замыкание
              not ObjZav[o].bParam[2]; //--------------------по состоянию замыкающего реле
              break;
            end;

            else //--------------------------------------------------- для прочих объектов
              if p = 1 then //------------------------ если подключились к точке 1 объекта
              begin
                p := ObjZav[o].Neighbour[2].Pin; //--- получить № точки подключения соседа
                o := ObjZav[o].Neighbour[2].Obj; //---- получить объект сосед за точкой №2
              end
              else //---------------------- если подключились к другой точке (это точка 2)
              begin
                p := ObjZav[o].Neighbour[1].Pin; //--- получить № точки подключения соседа
                o := ObjZav[o].Neighbour[1].Obj; //---- получить объект сосед за точкой №1
              end;
            end;
            if (o = 0) or (p < 1) then break;  //------если 0-объект или 0-точка, то выйти
            dec(i);
          end;
        end;

        if not ObjZav[Ptr].bParam[4] and //---------- если нет дополнительного замыкания и
        (ObjZav[Ptr].ObjConstI[8] > 0) then //------------------ если есть ближняя стрелка
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[8]) then//если надо замыкать по "-"
        begin //------------------------------------------------- по минусовому примыканию
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Obj;//-- сосед со стороны "-"
          p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Pin; //----№ точки соседа "-"
          i := 100;
          while i > 0 do
          begin
          case ObjZav[o].TypeObj of
            2 :   //-------------------------------------------------------------- стрелка
            begin
              case p of
                2 :   //-------------------------------------------- Вход со стороны плюса
                begin
                  if ObjZav[o].bParam[2] //--------------- если стрелка в отводе по минусу
                  then break;
                end;

                3 :   //------------------------------------------- Вход со стороны минуса
                begin
                  if ObjZav[o].bParam[1] //---------------- если стрелка в отводе по плюсу
                  then break;
                end;
                else  ObjZav[Ptr].bParam[4] := true; break; //------- ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin; //----- получить № точки подключения соседа
              o := ObjZav[o].Neighbour[1].Obj; //------ получить объект сосед за точкой №1
            end;

            3,4 : //--------------------------------------------------------- участок,путь
            begin
              ObjZav[Ptr].bParam[4] := //------------------------ дополнительное замыкание
              not ObjZav[o].bParam[2];//---------------------по состоянию замыкающего реле
              break;
            end;

            else //-------------------------------------------------------- другие объекты
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end
            else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break; //---------если 0-объект или 0-точка, то выйти
          dec(i);
        end;
      end;

      if not ObjZav[Ptr].bParam[4] and //------------ если нет дополнительного замыкания и
      (ObjZav[Ptr].ObjConstI[9] > 0) then //------------------------- есть дальняя стрелка
      if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[7]) //--замык.по плюсовому примыканию
      then //----------------------------------------проверка отводящего положения стрелок
      begin
        inc(LiveCounter);
        o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Obj; //-- объект со стороны "+"
        p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Pin; //---- № точки объекта "+"
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 : //-------------------------------------------------------- сосед = стрелка
            begin
              case p of
                2 :   //-------------------------------------------- Вход со стороны плюса
                begin
                  if ObjZav[o].bParam[2] //------------------- если стрелка-сосед в минусе
                  then break;
                end;

                3 :   //------------------------------------------- Вход со стороны минуса
                begin
                  if ObjZav[o].bParam[1] //-------------------- если стрелка-сосед в плюсе
                  then break;
                end;

                else
                  ObjZav[Ptr].bParam[4] := true;
                  break; //------------------------------------------ ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin;//------ получить № точки подключения соседа
              o := ObjZav[o].Neighbour[1].Obj; //- получить соседа,подключенного к точке 1
            end;

            3,4 : //--------------------------------------------------------- участок,путь
            begin
              ObjZav[Ptr].bParam[4] := //-------- дополнительное замыкание по состоянию ..
              not ObjZav[o].bParam[2]; //------------------ замыкающего реле участка, пути
              break;
            end;
            else //---------------------------------------------- для всех прочих объектов
              if p = 1 then //------------- для точки 1 взять то, что подключено к точке 2
              begin
                p := ObjZav[o].Neighbour[2].Pin;
                o := ObjZav[o].Neighbour[2].Obj;
              end
              else//----------------------- для точки 2 взять то, что подключено к точке 1
              begin
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;
            end;
            if (o = 0) or (p < 1) then break; //-------для 0-объекта или 0-точки завершить
            dec(i);
          end;
        end;

        if not ObjZav[Ptr].bParam[4] and //---------- если нет дополнительного замыкания и
        (ObjZav[Ptr].ObjConstI[9] > 0) then //----------------------- есть дальняя стрелка
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[8]) then//если надо замыкать по "-"
        begin
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Obj; //------сосед за минусом
          p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Pin;//точка соседа за минусом
          i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : //-------------------------------------------------------------- стрелка
              begin
                case p of
                  2 :   //-------------------------------------------------- Вход по плюсу
                  begin
                    if ObjZav[o].bParam[2] then break; //--если стрелка в отводе по минусу
                  end;
                  3 :   //------------------------------------------------- Вход по минусу
                  begin
                    if ObjZav[o].bParam[1] then break; //---если стрелка в отводе по плюсу
                  end;
                  else
                    ObjZav[Ptr].bParam[4] := true;
                    break; //------ ошибка в базе данных
                end;
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;

              3,4 : //------------------------------------------------------- участок,путь
              begin
                ObjZav[Ptr].bParam[4] :=
                not ObjZav[o].bParam[2]; // состояние замыкающего реле
                break;
              end;

              else
                if p = 1 then
                begin
                  p := ObjZav[o].Neighbour[2].Pin;
                  o := ObjZav[o].Neighbour[2].Obj;
                end
                else
                begin
                  p := ObjZav[o].Neighbour[1].Pin;
                  o := ObjZav[o].Neighbour[1].Obj;
                end;
            end;
            if (o = 0) or (p < 1) then break;
            dec(i);
          end;
        end;
      end;
{$IFDEF RMDSP}
      //---------------------------------------------------- ПРОВЕРКА УСЛОВИЙ АВТОВОЗВРАТА
      if ObjZav[Ptr].ObjConstB[2] then //------------------------ если имеется автовозврат
      begin
        inc(LiveCounter);
        if ObjZav[Ptr].bParam[3] then //----------------------------- если есть размыкание
        begin
          ObjZav[Ptr].bParam[3] := false;
          if StartRM then
          begin // блокировать автовозврат при запуске АРМа
            ObjZav[Ptr].Timers[1].Active := false;
          end else
          // проверить наличие контроля минусового положения стрелки
          if not ObjZav[Ptr].bParam[1] and //----------------------------------- нет плюса
          ObjZav[Ptr].bParam[2] and //----------------------------------------- есть минус
          WorkMode.Upravlenie and //-------------------------------------- есть управление
          WorkMode.OU[0] and //--------------------------------------------------- есть ОУ
          WorkMode.OU[ObjZav[Ptr].Group] then //--------------------------------- есть КРУ
          begin //-------------------- возбудить признак активизации проверки автовозврата
            ObjZav[Ptr].bParam[12] := true;//---------- акстивировать признак автовозврата
            ObjZav[Ptr].Timers[1].Active := true; //--------- активировать таймер1 стрелки
            ObjZav[Ptr].Timers[1].First := LastTime + 3/80000; //------зафиксировать время
          end;
        end
        else //------------------------------------------------------ если нет размыкаыния
        // проверить допустимость выдачи команды автовозврата
        if ObjZav[Ptr].bParam[12] and //------------- если есть активизация автовозврата и
        not ObjZav[Ptr].bParam[1] and //----------------------------------------- нет ПК и
        ObjZav[Ptr].bParam[2] and //-------- стрелка имеет контроль минусового положения и
        not ObjZav[Ptr].bParam[4] and //------------------ нет дополнительного замыкания и
        not ObjZav[Ptr].bParam[8] and //--------------- нет ожидания перевода в охранное и
        not ObjZav[Ptr].bParam[14] and //----------------------- стрелка не трассируется и
        not ObjZav[Ptr].bParam[18] and //------------ стрелка не отключена от управления и
        not ObjZav[Ptr].bParam[19] and //---------------- стрелка не выключена или макет и
        ObjZav[Ptr].bParam[20] and //------------------------------------------- нет МСП и
        ObjZav[Ptr].bParam[21] and //---------------------------------- нет замыкания СП и
        ObjZav[Ptr].bParam[22] and //---------------------------------- нет занятости СП и
        not ObjZav[Ptr].bParam[23] and //------------------------------- нет трассировки и
        not ObjZav[Ptr].bParam[9] and //----------------------------------------- нет РМ и
        not ObjZav[Ptr].bParam[10] and //------------------- нет исключения при маневрах и
        not ObjZav[Ptr].bParam[24] then //------------------------ нет местного управления
        begin
          if ObjZav[ObjZav[Ptr].ObjConstI[10]].bParam[3] then//если ЛАР магистрали стрелок
          begin //--- есть авария питания рельсовых цепей - сброс активизации автовозврата
            ObjZav[Ptr].bParam[12] := false; //-------------------------- сброс активности
            ObjZav[Ptr].Timers[1].Active := false; //----------------------- сброс таймера
          end else
          begin //--------------------------------------- исправно питание рельсовых цепей
            d := not ObjZav[Ptr].bParam[19]; //------------------------------------- макет

            if d then //----------------------------------------- если макет не установлен
            d := not ObjZav[Ptr].bParam[15]; //--------------------------- взять макет FR4

            if d then //----------------------------------------- если макет не установлен
            d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[18]; // выключение из ближней

            if d then //------------------------------------ если нет запретов для стрелки
            d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[10] and //не 1-ый ход трасс и
            not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[12] and // пошерстная не в плюсе и
            not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[13]; //---- пошерстная не в минусе

          if ObjZav[Ptr].ObjConstI[9] > 0 then //--------------- если есть дальняя стрелка
          begin
            if d then //------------------------------------ если нет запретов для стрелки
            d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[18]; // нет выключение упр-ия
            if d then //------------------------------------------------ если нет запретов
            d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[10] and //не 1-й ход трассы и
            not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[12] and // пошерстная не в плюсе и
            not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[13]; //-----пошерстная не в минусе
          end;
          if d and //------------------------------------- если нет запретов для стрелки и
          ObjZav[Ptr].Timers[1].Active and //------------------------ активен таймер №ё1 и
          (ObjZav[Ptr].Timers[1].First < LastTime) then   //------- прошло некоторое время
          begin
            if (CmdCnt = 0) and //-------------- если нет раздельных команд для передачи и
            not WorkMode.OtvKom and //------------------------------ не нажата кнопка ОК и
            not WorkMode.VspStr and //------------ нет вспомогательного перевода стрелок и
            not WorkMode.GoMaketSt and //------------ не идет установка стрелки на макет и
            WorkMode.Upravlenie and   //------------------------- управление от АРМа ДСП и
            not WorkMode.LockCmd and //--------------------------- нет блокировки команд и
            not WorkMode.CmdReady and  //----------- нет ожидания подтверждения маршрута и
            WorkMode.OU[0] and        //-------------------------------- есть признак ОУ и
            WorkMode.OU[ObjZav[Ptr].Group] then //----------------------- есть признак КРУ
            begin // есть признак активизации автовозврата и нет ожидающих команд в буфере
              ObjZav[Ptr].bParam[12] := false; //------------сброс активности автовозврата
              ObjZav[Ptr].Timers[1].Active := false; //-------------- остановить таймер №1
              //---------------------------- послать команду автовозврата стрелки в сервер
              if  SendCommandToSrv(ObjZav[Ptr].ObjConstI[2] div 8, cmdfr3_strautorun,Ptr)
              then
                //------------------"выдана команда перевода стрелки в охранное положение"
              AddFixMessage(GetShortMsg(1,418, ObjZav[Ptr].Liter,7),5,5);
            end;
          end;
        end;
      end;
    end else //------------------------------ если для стрелки не предусмотрен автовозврат
    begin //--------------------------------- не фиксируется размыкание стрелочной секции,
          //--------------------------------------- если нет признака автовозврата стрелки
      ObjZav[Ptr].bParam[3] := false;
      ObjZav[Ptr].bParam[12] := false;
      ObjZav[Ptr].Timers[1].Active := false;
    end;
{$ENDIF}
  end else
  begin //------------------------------------ потерять контроль при отсутствии информации
    ObjZav[Ptr].bParam[1] := false;
    ObjZav[Ptr].bParam[2] := false;
    ObjZav[Ptr].bParam[3] := false;
{$IFDEF RMSHN}
    ObjZav[Ptr].bParam[19] := false;
{$ENDIF}
  end;

  {FR4}

  ObjZav[Ptr].bParam[18] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-5);//выключено управление

  ObjZav[Ptr].bParam[15] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-4);//-------------- макет

  ObjZav[Ptr].bParam[16] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-3);//закрыто движ.ближняя

  ObjZav[Ptr].bParam[17] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-2);//закрыто движ.дальняя

  ObjZav[Ptr].bParam[33] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-1); // закрыта ПШ ближняя

  ObjZav[Ptr].bParam[34] := GetFR4State(ObjZav[Ptr].ObjConstI[1]); //-- закрыта ПШ дальняя
except
  {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepXStrelki]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//------------------- Подготовка объекта стрелки в качестве охранной для вывода на табло 2
procedure PrepOxranStrelka(Ptr : Integer);
var
  o,p,VideoBufStr,Xstr,Strelka : Integer;
begin
  try
    Strelka := Ptr;
    inc(LiveCounter);
    VideoBufStr := ObjZav[Strelka].VBufferIndex;
    Xstr := ObjZav[Strelka].BaseObject;
    //---------------------------------- Проверка принадлежности стрелки к трассе маршрута
    if ObjZav[Strelka].bParam[10] or //---------------- если первый проход трассировки или
    ObjZav[Strelka].bParam[11] or //------------------------ второй проход трассировки или
    ObjZav[Strelka].bParam[12] or //------------------------------- пошерстная в плюсе или
    ObjZav[Strelka].bParam[13] then //-------------------------------- пошерстная в минусе
    begin
      OVBuffer[VideoBufStr].Param[6] := false; //-------------- охранность на зкране снять
      OVBuffer[VideoBufStr].Param[5] := false; //------------------ признак перевода снять
      exit;
    end else
    begin
      if ObjZav[Xstr].bParam[5] = false then //----- если нет требования перевода охранной
      begin
        o := ObjZav[Xstr].ObjConstI[8]; //----- получить объект "С" 1-ой стрелки (ближней)
        p := ObjZav[Xstr].ObjConstI[9]; //----- получить объект "С" 2-ой стрелки (дальней)
        if (p > 0) and (p <> Strelka) then  //----- если есть дальняя стрелка и она другая
        begin
          if (ObjZav[p].bParam[10] or //--------------- если первый проход трассировки или
          ObjZav[p].bParam[11] or //------------------------ второй проход трассировки или
          ObjZav[p].bParam[12] or //------------------------------- пошерстная в плюсе или
          ObjZav[p].bParam[13]) then //------------------------------- пошерстная в минусе
          OVBuffer[VideoBufStr].Param[6] := true //------- охранность на зкране установить
        else
          OVBuffer[VideoBufStr].Param[6] := false; //---- иначе охранность на экране снять
        end else
        if (o > 0) and (o <> Strelka) then  //----- если есть ближняя стрелка и она другая
        begin
          if (ObjZav[o].bParam[10] or
          ObjZav[o].bParam[11] or
          ObjZav[o].bParam[12] or
          ObjZav[o].bParam[13]) then
          OVBuffer[VideoBufStr].Param[6] := true
          else OVBuffer[VideoBufStr].Param[6] := false;
        end
        else  OVBuffer[VideoBufStr].Param[6] := false; // иначе охранность на экране снять
      end
      else  OVBuffer[VideoBufStr].Param[6] := true;
    end;
    //----------------- Подсветка ожидания перевода стрелок, не входящих в трассу маршрута
    if ObjZav[Xstr].bParam[14] then  //---------------- если программное замыкание стрелки
    OVBuffer[VideoBufStr].Param[5] := false //-------- снять на экране требование перевода
    else OVBuffer[VideoBufStr].Param[5]:=ObjZav[Xstr].bParam[8];//треб.перевода из хвоста
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepOxranStrelka]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------- Подготовка объекта "маршрут через стрелку" для вывода на табло #2
procedure PrepStrelka(Ptr : Integer);
var
  i,o,p,DZ,SPohr,SPstr,Strelka,VideoBufStr,Xstr,rzs,Maket_str,Mag_str : integer;
  text : string;
begin
  try
    Strelka := Ptr;
    VideoBufStr := ObjZav[Strelka].VBufferIndex;
    Xstr := ObjZav[Strelka].BaseObject;
    SPstr := ObjZav[Strelka].UpdateObject;
    Mag_str := ObjZav[Xstr].ObjConstI[11]; //--------------------------- магистраль макета
    Maket_str := ObjZav[Mag_str].BaseObject; //----------------------------- макет стрелки


    inc(LiveCounter);
    if VideoBufStr > 0 then
    begin
      OVBuffer[VideoBufStr].Param[16] := ObjZav[Xstr].bParam[31]; //----------- активность

      OVBuffer[VideoBufStr].Param[1] := ObjZav[Xstr].bParam[32];//----------- парафазность

      ObjZav[Strelka].bParam[1] := ObjZav[Xstr].bParam[1]; //-------------------------- ПК
      ObjZav[Strelka].bParam[2] := ObjZav[Xstr].bParam[2]; //-------------------------- МК

      rzs := ObjZav[Xstr].ObjConstI[12];//--------------- объект ручного замыкания стрелок

      ObjZav[Strelka].bParam[4] := false;

      if ObjZav[Xstr].bParam[4] then
      ObjZav[Strelka].bParam[4] := ObjZav[Xstr].bParam[4];//------------- Замыкание хвоста

      ObjZav[Strelka].bParam[4] := ObjZav[Strelka].bParam[4] or
      ObjZav[Strelka].bParam[33] or ObjZav[Strelka].bParam[25]; //------------ ЧАС или НАС

      if ObjZav[rzs].bParam[1] or
      ObjZav[Strelka].bParam[33] or ObjZav[Strelka].bParam[25] then
      OVBuffer[VideoBufStr].Param[7] := true   //----------------- если есть РЗС или АВТОД
      else
        if ObjZav[SPstr].bParam[2] then//---------------- если oбъект СП стрелки разомкнут
        OVBuffer[VideoBufStr].Param[7] := ObjZav[Strelka].bParam[4]//отобразить пред.замык.
        else OVBuffer[VideoBufStr].Param[7] := false; // иначе не отображать замык.стрелки

      if not ObjZav[Xstr].bParam[31] or //------------------ При отсутствии информации или
      ObjZav[Xstr].bParam[32] then //------------------------------  непарафазности хвоста
      begin  //-------------------------------------- сбросить  видеоинформацию по стрелке
        OVBuffer[VideoBufStr].Param[2] := false; //-------------------------------- нет ПК
        OVBuffer[VideoBufStr].Param[3] := false; //-------------------------------- нет МК
        OVBuffer[VideoBufStr].Param[8] := false; //-------- нет охранности с автовозвратом
        OVBuffer[VideoBufStr].Param[9] := false; //-------- нет охранности с автовозвратом
        OVBuffer[VideoBufStr].Param[10] := false;//-------- нет охранности с автовозвратом
        OVBuffer[VideoBufStr].Param[12] := false;//------------------- нет выдержки МСП(Д)
      end else
      begin
        //---------------------- скопировать признак разрешения маневров из хвоста стрелки
        ObjZav[Strelka].bParam[9] := ObjZav[XStr].bParam[9];

        if not WorkMode.Upravlenie then
        begin
          ObjZav[XStr].Timers[3].Active := false;
          ObjZav[XStr].Timers[3].First := 0;
        end;
//---------------------- Р А Б О Т А  С  М А К Е Т О М -----------------------------------
        if ({$IFDEF RMDSP}(XStr = maket_strelki_index) or {$ENDIF}  //----- если на макете
        ObjZav[XStr].bParam[24]) and not WorkMode.Podsvet then
        begin //включен макет стрелки или местное управление - не рисовать остряки стрелки
          if not WorkMode.Upravlenie or //---------------- если не управляющий АРМ или ...
          (ObjZav[XStr].Timers[3].First <> 0) then //--- если была выдача команд на макете
          begin
            if not WorkMode.Upravlenie or //-------------- если не управляющий АРМ или ...
            (LastTime > ObjZav[XStr].Timers[3].First) then //------- макету пора исполнить
            begin
              if not WorkMode.Upravlenie or   //---------- если не управляющий АРМ или ...
              (ObjZav[XStr].iParam[5] = cmdfr3_strmakplus) then //----- переводили в плюс
              begin
                if not ObjZav[Maket_str].bParam[4] and //--------------- если нет ММК и...
                ObjZav[Maket_str].bParam[3] and  //------------------------ есть МПК и ...
                (not ObjZav[XStr].bParam[2] and ObjZav[XStr].bParam[1]) then //-------- ПК
                begin
                  ObjZav[XStr].Timers[3].Active := false;
                  ObjZav[XStr].Timers[3].First := 0;
                  ObjZav[XStr].iParam[4] := ObjZav[XStr].iParam[5];
                end else
                begin
                  if ObjZav[XStr].Timers[3].Active then
                  begin
                    InsArcNewMsg(XStr,577+$2000,0);//--- Ошибка перевода стрелки на макете
                    AddFixMessage(GetShortMsg(1,577,ObjZav[XStr].Liter,0),4,4);
                    ObjZav[XStr].Timers[3].Active := false;
                  end;
                end;
              end;

              if not WorkMode.Upravlenie or
              (ObjZav[XStr].iParam[5] = cmdfr3_strmakminus) then //--- переводили в минус
              begin
                if ObjZav[Maket_str].bParam[4] and //------------------ если есть ММК и...
                not ObjZav[Maket_str].bParam[3] and  //--------------------- нет МПК и ...
                (ObjZav[XStr].bParam[2] and not ObjZav[XStr].bParam[1]) then //-------- МК
                begin
                  ObjZav[XStr].Timers[3].Active := false;
                  ObjZav[XStr].Timers[3].First := 0;
                  ObjZav[XStr].iParam[4] := ObjZav[XStr].iParam[5];
                end else
                begin
                  if ObjZav[XStr].Timers[3].Active then
                  begin
                    InsArcNewMsg(XStr,577+$2000,0);//Ошибка при переводе стрелки на макете
                    AddFixMessage(GetShortMsg(1,577,ObjZav[XStr].Liter,0),4,4);
                    ObjZav[XStr].Timers[3].Active := false;
                  end;
                end;
              end;
            end;
          end;

          //------------- дальше - если управляющий или  не было выдачи команды для макета
          if ObjZav[Maket_str].bParam[2] then //----------------- если шнур макета включен
          begin
            if WorkMode.Upravlenie and //------------------------- если АРМ основной и ...
            (ObjZav[XStr].iParam[4] <> ObjZav[XStr].iParam[5]) then //команда не исполнена
            begin
              OVBuffer[VideoBufStr].Param[2] := false; //-------------------------- нет ПК
              OVBuffer[VideoBufStr].Param[3] := false; //-------------------------- нет МК
            end else  //------------------------ если команда исполнена  или резервный АРМ
            if ObjZav[Maket_str].bParam[2] then
            begin
              OVBuffer[VideoBufStr].Param[2] :=
              ObjZav[XStr].bParam[1] and ObjZav[Maket_str].bParam[3]; //--------------  ПК

              OVBuffer[VideoBufStr].Param[3] :=
              ObjZav[XStr].bParam[2] and ObjZav[Maket_str].bParam[4]; //--------------  МК

              if ObjZav[XStr].bParam[1] and ObjZav[Maket_str].bParam[3] then
              begin
                ObjZav[XStr].iParam[4] := cmdfr3_strmakplus;
                ObjZav[XStr].iParam[5] := cmdfr3_strmakplus;
              end;

              if ObjZav[XStr].bParam[2] and ObjZav[Maket_str].bParam[4] then
              begin
                ObjZav[XStr].iParam[4] := cmdfr3_strmakminus;
                ObjZav[XStr].iParam[5] := cmdfr3_strmakminus;
              end;
            end;

            if WorkMode.Upravlenie then
            begin
              if (ObjZav[XStr].iParam[4] = cmdfr3_strmakminus) or//-- если команда "минус"
              (ObjZav[XStr].iParam[4] = 0) then //--------------------- или не было ничего
              begin
                if not ObjZav[Maket_str].bParam[4] or //------------- если нет ММК или ...
                ObjZav[Maket_str].bParam[3] or   //---------------------- есть МПК или ...
                not ObjZav[XStr].bParam[2]  or    //----------------------- нет МК или ...
                ObjZav[XStr].bParam[1] then //------------------------------------ есть ПК
                begin
                  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[2] := false; //--- снять ПК
                  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[3] := false;//---- снять МК
                  if not ObjZav[XStr].bParam[27] then
                  begin
                    InsArcNewMsg(XStr,271+$1000,0);//--------- "стрелка потеряла контроль"
                    AddFixMessage(GetShortMsg(1,271,ObjZav[XStr].Liter,0),4,3);
                    ObjZav[XStr].bParam[27] := true;
                  end;
                end;
              end else

              if (ObjZav[XStr].iParam[4] =  cmdfr3_strmakplus) or // если была команда "+"
              (ObjZav[XStr].iParam[4] = 0) then //--------------------- или не было ничего
              begin
                if ObjZav[Maket_str].bParam[4] or //-------------------- если  ММК или ...
                not ObjZav[Maket_str].bParam[3] or //--------------------- нет МПК или ...
                ObjZav[XStr].bParam[2]  or    //------------------------------- МК или ...
                not ObjZav[XStr].bParam[1]  then //-------------------------------- нет ПК
                begin
                  OVBuffer[VideoBufStr].Param[2] := false; //-------------------- снять ПК
                  OVBuffer[VideoBufStr].Param[3] := false;//--------------------- снять МК
                  if not ObjZav[XStr].bParam[27] then
                  begin
                    InsArcNewMsg(XStr,271+$1000,0);//--- "стрелка <Ptr> потеряла контроль"
                    AddFixMessage(GetShortMsg(1,271,ObjZav[XStr].Liter,0),4,3);
                    ObjZav[XStr].bParam[27] := true;
                  end;
                end;
              end;
            end;
          end;

         if OVBuffer[VideoBufStr].Param[2] <> OVBuffer[VideoBufStr].Param[3] then
          ObjZav[XStr].bParam[27] := false;//---- контроль восстановлен, сбросить фиксацию
        end else //---------------------------------------------------------- не на макете
        begin
          if ObjZav[Strelka].bParam[1] then // ------------------------------ если есть ПК
          begin
            if ObjZav[Strelka].bParam[2] then //--------------------- одновременно есть МК
            begin
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[2] := false; //------- снять ПК
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[3] := false;//-------- снять МК
            end else
            begin //------------------------------------------------------------ есть плюс
              //--------------------------- установить признак последнего контроля в плюсе
              ObjZav[Strelka].bParam[20] := true;
              ObjZav[Strelka].bParam[21] := false;
              ObjZav[Strelka].bParam[22] := false;
              ObjZav[Strelka].bParam[23] := false;
              OVBuffer[VideoBufStr].Param[2] := true;  //-- для экрана ПК
              OVBuffer[VideoBufStr].Param[3] := false;//для экрана нет МК
            end;
          end else
          if ObjZav[Strelka].bParam[2] then //--------------------------------- есть минус
          begin
            //---------------------------- установить признак последнего контроля в минусе
            ObjZav[Strelka].bParam[20] := false;
            ObjZav[Strelka].bParam[21] := true;
            ObjZav[Strelka].bParam[22] := false;
            ObjZav[Strelka].bParam[23] := false;
            OVBuffer[VideoBufStr].Param[2] := false; //----------------- для экрана нет ПК
            OVBuffer[VideoBufStr].Param[3] := true; //----------------- для экрана есть МК
          end else
          begin
            OVBuffer[VideoBufStr].Param[2] := false;
            OVBuffer[VideoBufStr].Param[3] := false;
          end;
        end;

        //---------------------------------------------- проверить выдержку времени МСП(Д)
        OVBuffer[VideoBufStr].Param[12] := ObjZav[Strelka].ObjConstB[9] and
        not ObjZav[ObjZav[Strelka].UpdateObject].bParam[4] and
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[1] and
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[2];

        //------------------------------------------------------------- собрать Вз стрелки
        ObjZav[Strelka].bParam[3] :=
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[5];//МИ из секции

        inc(LiveCounter);
        o := 0;

        //----------------------------------------------- проверить охранности для стрелки
        for i := 1 to 10 do
        if ObjZav[Strelka].ObjConstI[i] > 0 then
        begin
          o := 0;
          case ObjZav[ObjZav[Strelka].ObjConstI[i]].TypeObj of
            27 :
            begin //------------------------------------------- охранное положение стрелки
              DZ := ObjZav[Strelka].ObjConstI[i]; //-- объект описания охранного замыкания
              SPohr := ObjZav[DZ].ObjConstI[2];//------ объект СП для охранного замыкания
              if ObjZav[DZ].ObjConstB[1] then //---- если зависимость для ходовой  в плюсе
              begin
                if ObjZav[Strelka].bParam[1] then //--------- если ходовая стрелка в плюсе
                begin
                  o := ObjZav[DZ].ObjConstI[3]; //----------------------- охранная стрелка
                  if o > 0 then
                  begin
                    if ObjZav[DZ].ObjConstB[3] then //---- если охранная должна быть в "+"
                    begin
                      if ObjZav[o].bParam[1] = false then //----- если охранная не в плюсе
                      begin
                        ObjZav[o].bParam[3] := false; //---------------замкнуть в маршруте
                        break;
                      end else
                      begin
                        ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6];
                      end;
                    end else
                    if ObjZav[DZ].ObjConstB[4] then //--------------------- если охр. по -
                    begin
                      if ObjZav[o].bParam[2] = false then //------------- если не в минусе
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- копировать замк
                      end;
                    end;
                  end;
                end;
              end else
              if ObjZav[DZ].ObjConstB[2] then //------- если ходовая должна быть по минусу
              begin
                if ObjZav[Strelka].bParam[2] then //---------------- если стрелка в минусе
                begin
                  o := ObjZav[ObjZav[Strelka].ObjConstI[i]].ObjConstI[3];//охранная стрелка
                  if o > 0 then
                  begin
                    if ObjZav[DZ].ObjConstB[3] then//--- если охранная должна быть в плюсе
                    begin
                      if ObjZav[o].bParam[1] = false then //----------- стрелка не в плюсе
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- копировать замк
                      end;
                    end else //---------------------- если охранная должна быть не в плюсе
                    if ObjZav[DZ].ObjConstB[4] then //- если охранная должна быть в минусе
                    begin
                      if ObjZav[o].bParam[2] = false then //- охранная стрелка не в минусе
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- копировать замк
                      end;
                    end;
                  end;
                end;
              end;

              if o > 0 then
              begin
                ObjZav[o].bParam[4] := //--------------- замыкание охранной состоит из ...
                ObjZav[o].bParam[4] or //--------- собственное замыкание охраннной или ...
                (not ObjZav[SPohr].bParam[2]) or //------------------ разомкнутость СП или
                ObjZav[o].bParam[33] or //------------------- четного автодействия или ...
                ObjZav[o].bParam[25]; //--------------------------- нечетного автодействия

                OVBuffer[ObjZav[o].VBufferIndex].Param[7] := ObjZav[o].bParam[4];
                OVBuffer[ObjZav[o].VBufferIndex].Param[6] := ObjZav[o].bParam[14];
              end;
            end; //-------------------------------------------------------------- конец 27

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            6 : //-------------------------------------------------------- Ограждение пути
            begin
              for p := 14 to 17 do
              begin
                if ObjZav[ObjZav[Strelka].ObjConstI[i]].ObjConstI[p] = Strelka then
                begin
                  o := ObjZav[Strelka].ObjConstI[i];
                  if ObjZav[o].bParam[2] then
                  begin
                    if ObjZav[Strelka].bParam[1] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-27] then
                      begin
                        ObjZav[Strelka].bParam[3] := false; break;
                      end;
                    end else
                    if ObjZav[Strelka].bParam[2] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-26] then
                      begin
                        ObjZav[Strelka].bParam[3] := false; break;
                      end;
                    end;
                  end;
                end;
              end;
            end; //6
          end; //case
        end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
        o := 0;
        //-------------------------------------------------------- Проверка негабаритности
        if ObjZav[Strelka].bParam[3] then
        begin
          inc(LiveCounter);
          //-------------- Искать негабаритность через стык и отведенное положение стрелок
          if ObjZav[Strelka].bParam[1] then
          begin
            if (ObjZav[Strelka].Neighbour[3].TypeJmp = LnkNeg) or //---- негабаритный стык
            (ObjZav[Strelka].ObjConstB[8]) then//или проверка отводящего положения стрелок
            begin //--------------------------------------------- по минусовому примыканию
              o := ObjZav[Strelka].Neighbour[3].Obj;
              p := ObjZav[Strelka].Neighbour[3].Pin;
              i := 100;
              while i > 0 do
              begin
                case ObjZav[o].TypeObj of
                  2 :
                  begin //-------------------------------------------------------- стрелка
                    case p of
                      2 :
                      begin //---------------------------------------------- Вход по плюсу
                        if ObjZav[o].bParam[2] then break; //-- стрелка в отводе по минусу
                      end;

                      3 :
                      begin // Вход по минусу
                        if ObjZav[o].bParam[1] then break; //--- стрелка в отводе по плюсу
                      end;

                      else
                        ObjZav[Strelka].bParam[3] := false;
                        break; //------------------------------------ ошибка в базе данных
                    end;
                    p := ObjZav[o].Neighbour[1].Pin;
                    o := ObjZav[o].Neighbour[1].Obj;
                  end;

                  3,4 :
                  begin //--------------------------------------------------- участок,путь
                    if ObjZav[Strelka].Neighbour[3].TypeJmp = LnkNeg then
                    ObjZav[Strelka].bParam[3]:=ObjZav[o].bParam[1]//состояние путевого датчика
                    else  ObjZav[Strelka].bParam[3] := false;
                    break;
                  end;
                  else
                    if p = 1 then
                    begin
                      p := ObjZav[o].Neighbour[2].Pin;
                      o := ObjZav[o].Neighbour[2].Obj;
                    end else
                    begin
                      p := ObjZav[o].Neighbour[1].Pin;
                      o := ObjZav[o].Neighbour[1].Obj;
                    end;
                end;

                if (o = 0) or (p < 1) then break;
                dec(i);
              end;
            end;
          end else
          if ObjZav[Strelka].bParam[2] then //----------------------------------- если есть МК
          begin
            if (ObjZav[Strelka].Neighbour[2].TypeJmp = LnkNeg) or //-------- негабаритный стык
            (ObjZav[Strelka].ObjConstB[7]) then  //- или проверка отводящего положения стрелок
            begin //---------------------------------------------- по плюсовому примыканию
              o := ObjZav[Strelka].Neighbour[2].Obj;
              p := ObjZav[Strelka].Neighbour[2].Pin;
              i := 100;
              while i > 0 do
              begin
                case ObjZav[o].TypeObj of
                  2 :
                  begin //-------------------------------------------------------- стрелка
                    case p of
                      2 :
                      begin //---------------------------------------------- Вход по плюсу
                        if ObjZav[o].bParam[2] then break; //-- стрелка в отводе по минусу
                      end;

                      3 :
                      begin //--------------------------------------------- Вход по минусу
                        if ObjZav[o].bParam[1] then break; //--- стрелка в отводе по плюсу
                      end;

                      else
                        ObjZav[Strelka].bParam[3] := false;
                        break; //------------------------------------ ошибка в базе данных
                    end;
                    p := ObjZav[o].Neighbour[1].Pin;
                    o := ObjZav[o].Neighbour[1].Obj;
                  end;

                  3,4 :
                  begin //--------------------------------------------------- участок,путь
                    if ObjZav[Strelka].Neighbour[2].TypeJmp = LnkNeg then
                    ObjZav[Strelka].bParam[3]:=ObjZav[o].bParam[1]//состояние путевого датчика
                    else  ObjZav[Strelka].bParam[3] := false;
                    break;
                  end;

                  else
                    if p = 1 then
                    begin
                      p := ObjZav[o].Neighbour[2].Pin;
                      o := ObjZav[o].Neighbour[2].Obj;
                    end else
                    begin
                      p := ObjZav[o].Neighbour[1].Pin;
                      o := ObjZav[o].Neighbour[1].Obj;
                    end;
                end;

                if (o = 0) or (p < 1) then break;
                dec(i);
              end;
            end;
          end;
        end;

        //-------------------------------------- проверка охранного положения сбрасывающей
        if ObjZav[XStr].ObjConstB[1] then //----------------------------- есть признак КОП
        begin
          inc(LiveCounter);
          if ObjZav[Strelka].bParam[1] and not ObjZav[Strelka].bParam[2] then//стрелка в +
          begin //-------------------------------------- есть контроль охранного положения
            ObjZav[Strelka].bParam[19] := false;
            ObjZav[Strelka].Timers[1].Active := false;//сброс фикс.времени стрелки не в ОП
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := true;
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
          end else
          begin
            if not ObjZav[XStr].bParam[21] then //СП замкнута в маршруте
            begin
              ObjZav[Strelka].bParam[19] := false;
              ObjZav[Strelka].Timers[1].Active := false;//сброс фикс.врем. стрелки не в ОП
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false; //-- нет охранного
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false; //нельзя перевести
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
            end else
            if not ObjZav[XStr].bParam[20] or
            not ObjZav[XStr].bParam[22] then
            begin //--------------------------- выдержка времени МСП или занятость стрелки
              ObjZav[Strelka].bParam[19] := false;
              ObjZav[Strelka].Timers[1].Active := false;//сброс фиксации врем.вывода из ОП
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false;
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := true;
            end else
            begin //-------------------------------------- выведена из охранного положения
              if not ObjZav[Strelka].bParam[1] and ObjZav[Strelka].bParam[2] then
              begin
                if ObjZav[Strelka].Timers[1].Active then
                begin //-- вывести признак отсутствия охранного положения длительное время
                  if LastTime >= ObjZav[Strelka].Timers[1].First then
                  begin
                    if (ObjZav[XStr].ObjConstI[8] = Strelka) and
                    not ObjZav[Strelka].bParam[19] and
                    not ObjZav[Strelka].bParam[18] and
                    not ObjZav[XStr].bParam[18] and //--------------------------- Колпачек
                    not ObjZav[XStr].bParam[15] then //----------------------------- макет
                    begin
{$IFDEF RMDSP}
                      if WorkMode.OU[0] and
                      WorkMode.OU[ObjZav[Strelka].Group] and
                      (ObjZav[Strelka].RU = config.ru) then//сообщение, при АРМ-управлении
                      begin
                        InsArcNewMsg(XStr,477,1);
                        text := GetShortMsg(1,477,ObjZav[XStr].Liter,7);
                        AddFixMessage(text,4,3); //------- стрелка не в охранном положении
                        ShowShortMsg(477,LastX,LastY,ObjZav[XStr].Liter);
                      end;
{$ELSE}
                      InsArcNewMsg(XStr,477,2);
{$ENDIF}
                    end;
                    ObjZav[Strelka].Timers[1].Active := false;
                    ObjZav[Strelka].bParam[19] := true;
                  end;
                end else
                begin //-------- зафиксировать время вывода стрелки из охранного положения
                  ObjZav[Strelka].Timers[1].Active := true;
                  ObjZav[Strelka].Timers[1].First := LastTime + 0.000694;//------ 1 минута
                end;
              end else //------------------------------------ нет контроля - сброс мигалки
              begin
                ObjZav[Strelka].bParam[19] := false;
                ObjZav[Strelka].Timers[1].Active := false;
              end;

              if ObjZav[Strelka].bParam[19] and
              not ObjZav[Strelka].bParam[18] and
              not ObjZav[XStr].bParam[18] and //----------- Колпачек
              not ObjZav[XStr].bParam[15] and //-------------- макет
              WorkMode.Upravlenie then
              begin //------------------------------------------------------------- мигать
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := tab_page;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
              end else
              begin //---------------------------------------------------------- не мигать
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := true;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
              end;
            end;
          end;
        end;

        //------------------------------------------------------ Аварийный перевод стрелки
        if ObjZav[XStr].ObjConstI[13] > 0 then
        begin
          if ObjZav[ObjZav[XStr].ObjConstI[13]].bParam[1] then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[11] := true
          else  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[11] := false;
        end;

        // Снять предварительное замыкание по замыканию стрелочной секции или по PM или МИ
        if not ObjZav[ObjZav[Strelka].UpdateObject].bParam[2] or
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[9] or
        not ObjZav[ObjZav[Strelka].UpdateObject].bParam[5] then
        begin
          ObjZav[Strelka].bParam[14] := false;
          ObjZav[Strelka].bParam[6] := false;
          ObjZav[Strelka].bParam[7] := false;
          ObjZav[Strelka].bParam[10] := false;
          ObjZav[Strelka].bParam[11] := false;
          ObjZav[Strelka].bParam[12] := false;
          ObjZav[Strelka].bParam[13] := false;
          SetPrgZamykFromXStrelka(Strelka);
        end;

        OVBuffer[VideoBufStr].Param[7] :=
        OVBuffer[VideoBufStr].Param[7] or ObjZav[Strelka].bParam[33];

        if o <> 0 then OVBuffer[VideoBufStr].Param[7] :=
        OVBuffer[VideoBufStr].Param[7] or ObjZav[o].bParam[25];


        if not WorkMode.Podsvet and //----------------------- если нет подсветки стрелок и
        (ObjZav[XStr].iParam[4] <> ObjZav[XStr].iParam[5]) and //----- перевод макета и ..
       (ObjZav[XStr].bParam[15] or  //------------------------------ есть Макет из Fr4 или
{$IFDEF RMSHN} ObjZav[XStr].bParam[19] or {$ENDIF}//--------------------- Макет из объекта
        ObjZav[Xstr].bParam[24]) then //--------------------- стр.дв-го упр.в маневр.район
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[4] := true //-- выключить цвет литера
        else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[4] := false;
      end;

      //--------------------------------------- FR4 --------------------------------------
      if ObjZav[Strelka].ObjConstB[6] then //----------- если спаренная и при этом дальняя
      begin
            //-------------------------- закрытие  для движения --------------------------
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Strelka].bParam[16]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[17];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[17];
        //------------------------------------------- закрыт для противошерстного движения
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Strelka].bParam[17]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] :=  ObjZav[Xstr].bParam[34];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] :=  ObjZav[Xstr].bParam[34];
      end else
      begin //------------------------------------------------------ одиночная или ближняя
        //----------------------------------------------------------- закрыта для движения
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Strelka].bParam[16]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[16];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[16];
        //------------------------------------------- закрыт для противошерстного движения
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Strelka].bParam[17]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Xstr].bParam[33];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Xstr].bParam[33];
      end;
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //---------------------------------------------------------------------- макет
        if tab_page then OVBuffer[VideoBufStr].Param[31] :=  ObjZav[Xstr].bParam[19]
        else
        OVBuffer[VideoBufStr].Param[31] := ObjZav[Xstr].bParam[15];
      end else
{$ENDIF}
      OVBuffer[VideoBufStr].Param[31] := ObjZav[Xstr].bParam[15];
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- выключено управление
        if tab_page then  OVBuffer[VideoBufStr].Param[32] := ObjZav[Strelka].bParam[18]
        else OVBuffer[VideoBufStr].Param[32] := ObjZav[Xstr].bParam[18];
      end else
{$ENDIF}
      OVBuffer[VideoBufStr].Param[32] := ObjZav[Xstr].bParam[18];
      {
      OVBuffer[ObjZav[Strelka].VBufferIndex].Param[7] :=
      ObjZav[Xstr].bParam[4] or ObjZav[Strelka].bParam[4]
      }
    end;
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepStrelka]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- Подготовка объекта секции для вывода на табло #3
procedure PrepSekciya(Ptr : Integer);
var
  p,msp,z,mi,ri : boolean;
  i : integer;
  sost : byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    p := //------------------------------------------------------------------ Путевое реле
    not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    z := //--------------------------------------------------------------------- замыкание
    not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ri := //--------------------------------------------------------------------------- РИ
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    msp := //------------------------------------------------------------------------- МСП
    not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    mi := //--------------------------------------------------------------------------- МИ
    not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[6] := //-------------------------------------------------- предв РИ
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[7] := //----------------------------------------------- предв замык
    not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //активность
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];//парафазность

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if (ObjZav[Ptr].ObjConstI[8] > 0) and(ObjZav[Ptr].ObjConstI[9] > 0) then
        begin //------------------------------- вести счет времени если есть таймер МСП(Д)
          if p <> ObjZav[Ptr].bParam[1] then
          begin //---------------------------------- Зафиксировать изменение путевого реле
            if p then
            begin //------------------------------------------------- освобождение участка
              if msp then
              begin //--------------------------------------------------- возбужден МСП(Д)
                ObjZav[Ptr].Timers[1].Active := false; //----------- сброс счетчика МСП(Д)
              end else
              begin //--------------------------------------------------- обесточен МСП(Д)
                if not ObjZav[Ptr].Timers[1].Active then
                begin //-------------------------------------------- начать отсчет времени
                  ObjZav[Ptr].Timers[1].First := LastTime;
                  ObjZav[Ptr].Timers[1].Active := true;
                end;
              end;
            end else
            begin //------------------------------------------------------ занятие участка
              ObjZav[Ptr].Timers[1].Active := false; //------------- сброс счетчика МСП(Д)
            end;
          end;

          if msp <> ObjZav[Ptr].bParam[4] then
          begin //-------------------------------------------- Зафиксировать изменение МСП
            if msp then
            begin //----------------------------------------------------- возбужден МСП(Д)
{$IFDEF RMSHN}
              if ObjZav[Ptr].Timers[1].Active
              then ObjZav[Ptr].dtParam[3] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
              ObjZav[Ptr].Timers[1].Active := false; //------------- сброс счетчика МСП(Д)
            end;
          end;
        end;

        ObjZav[Ptr].bParam[1] := p;
        ObjZav[Ptr].bParam[4] := msp;

        if ObjZav[Ptr].ObjConstI[9] > 0 then
        begin
          if ObjZav[Ptr].Timers[1].Active then
          begin //----------------------------------- выдать значение временного интервала
            Timer[ObjZav[Ptr].ObjConstI[9]] :=
            1 + Round((LastTime - ObjZav[Ptr].Timers[1].First) * 86400);
          end else
          begin //---------------------------------------------------------- скрыть таймер
            Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
          end;
        end;

      if ObjZav[Ptr].bParam[21] then //если есть фиксация недостоверности информации по СП
      begin
        ObjZav[Ptr].bParam[20] := true; //------------------ установить признак восприятия
        ObjZav[Ptr].bParam[21] := false; //----------------------- сброс признака фиксации
      end else
      begin //---------------- если нет фиксации признака недостоверности информации по СП
        ObjZav[Ptr].bParam[20] := false; //------------------- сбросить признак восприятия
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] :=
      (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; //активность района управления

      if ObjZav[Ptr].bParam[2] <> z then //-------------------------- изменилось замыкание
      begin
        ObjZav[Ptr].bParam[8] := true;  //----------------------------- снять трассировку
        ObjZav[Ptr].bParam[14] := false; //--------------- снять предварительное замыкание

        if z then //------------------------------------------------ при размыкании секции
        begin
          ObjZav[Ptr].iParam[2] := 0; //----- сброс индекса светофора, ограждения маршрута
          ObjZav[Ptr].iParam[3] := 0; //------------------------------- Сброс индекса горы
          ObjZav[Ptr].bParam[15] := false; //----------------------------------- снять 1КМ
          ObjZav[Ptr].bParam[16] := false; //----------------------------------- снять 2КМ
        end;
      end;
      ObjZav[Ptr].bParam[2] := z;  //----------------- установить текущее значение для "З"

      if ObjZav[Ptr].bParam[5] <> mi then //-------------------------------- изменилось МИ
      begin
        ObjZav[Ptr].bParam[8] := true;  //------------------------------ снять трассировку
        ObjZav[Ptr].bParam[14] := false; //--------------- снять предварительное замыкание
        if mi then
        begin //---------------------------------------------------- при размыкании секции
          ObjZav[Ptr].bParam[15] := false; //----------------------------------- снять 1КМ
          ObjZav[Ptr].bParam[16] := false; //----------------------------------- снять 2КМ
        end;
      end;
      ObjZav[Ptr].bParam[5] := mi;  //------------------------------------------------- МИ

      //------------------------------------------ проверка передачи на местное управление
      ObjZav[Ptr].bParam[9] := false; //----------------------------------------------- РМ
      for i := 20 to 24 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then //---------------------- если есть этот район
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            25 :
            if not ObjZav[Ptr].bParam[9] then
            ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);

            44 :
            if not ObjZav[Ptr].bParam[9] then
            ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
          end;
        end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[2];
{$IFDEF RMDSP}
      inc(LiveCounter);

      if WorkMode.Upravlenie then
      begin
        if not ObjZav[Ptr].bParam[14] then
        begin //---------------------------------------------------------- при трассировке
          if not ObjZav[Ptr].bParam[7] then
          begin //----------------------------------------------------------------- из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin //--------------------------------- светить немигающую тонкую белую полосу
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8];//из объекта
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] then
          begin //----------------------------------------------------------------- из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then //---------------- проверка выдачи команды установки маршрута
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] :=
              ObjZav[Ptr].bParam[8]; //----------------------------------- из объекта АРМа
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- из FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[7];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not ObjZav[Ptr].bParam[7];
{$IFDEF RMDSP}
      end;
{$ENDIF}

      if ObjZav[Ptr].bParam[3] <> ri then
      begin
        if ri and not StartRM then
        begin //-------------------------------------------- фиксируем выбор секции для ИР
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,84+$2000,7);
            AddFixMessage(GetShortMsg(1,84,ObjZav[Ptr].Liter,7),0,2);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,84+$2000,7);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[3] := ri;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[3]; //--------- РИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[6];

      sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
      if ObjZav[Ptr].bParam[5] and (ObjZav[Ptr].iParam[3] = 0) then
      begin //--------------------------- проверить диагностику если нет маневров, надвига
        if ((sost and 1) = 1) then
        begin //---------------------------------------- фиксируем лoжную занятость секции
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000,0);
          ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime;
          inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then
          begin
            InsArcNewMsg(Ptr,394+$1000,0); //----------------------- Зафиксировано занятие
            AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter,0),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; //----- Фиксировать неисправность
{$ENDIF}
        end;
        if ((sost and 2) = 2) and not ObjZav[Ptr].bParam[9] then
        begin //-------------------------------------- фиксируем лoжную свободность секции
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000,0);  //------------------- Зафиксировано освобождение
          ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime;
          inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then
          begin //--------------------- Фиксировать неисправность если включено управление
            InsArcNewMsg(Ptr,395+$1000,0);
            AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter,0),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie;
{$ENDIF}
        end;
      end;

      if WorkMode.Podsvet and ObjZav[Ptr].ObjConstB[6] then
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;

    end else
    begin //------------------------------------- переход в недостоверное состояние данных
      if ObjZav[Ptr].ObjConstI[9] > 0 then Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
      ObjZav[Ptr].bParam[21] := true; //-------- установить ловушку недостоверности данных
    end;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[19];

    //-------------------------------------------------------------------------------- FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
    begin
      if tab_page
      then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13]
      else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin //------------------------------------------------------------- есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin //---------------------------------------------------- есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26]
          else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  {$IFNDEF RMARC}
  reportf('Ошибка [MainLoop.PrepSekciya]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------- Подготовка объекта пути для вывода на табло #4
procedure PrepPuti(Ptr : Integer);
var
  z1,z2,mic,min,Nepar,Activ : boolean;
  i,PutCH,PutN,Ni,CHi,CHkm,Nkm,MI_CH,MI_N,PrZC,PrZN,VidB : integer;
  sost,sost1,sost2 : Byte;
begin
  try
    inc(LiveCounter);

    Nepar := false;
    Activ := true;

    PutCH := ObjZav[Ptr].ObjConstI[2];
    Ni    := ObjZav[Ptr].ObjConstI[4];
    CHi   := ObjZav[Ptr].ObjConstI[3];
    CHkm  := ObjZav[Ptr].ObjConstI[5];
    MI_CH := ObjZav[Ptr].ObjConstI[6];
    Nkm   := ObjZav[Ptr].ObjConstI[7];
    MI_N  := ObjZav[Ptr].ObjConstI[8];
    PutN  := ObjZav[Ptr].ObjConstI[9];
    PrZC  := ObjZav[Ptr].ObjConstI[11];
    PrZN  := ObjZav[Ptr].ObjConstI[12];
    VidB :=  ObjZav[Ptr].VBufferIndex;


    //--------------------------------------- Занятости пути в четной и в нечетной стойках
    ObjZav[Ptr].bParam[1] := not GetFR3(PutCH,Nepar,Activ);//------------------------ П(ч)
    ObjZav[Ptr].bParam[16] := not GetFR3(PutN,Nepar,Activ);//------------------------ П(н)

    z1 :=  not GetFR3(Ni,Nepar,Activ);//----------------------------------------------- НИ

    z2 :=  not GetFR3(CHi,Nepar,Activ);//---------------------------------------------- ЧИ

    ObjZav[Ptr].bParam[4] := GetFR3(CHkm,Nepar,Activ); //---------------------------- ЧКМ

    if MI_CH > 0 then  mic := not GetFR3(MI_CH,Nepar,Activ)//если есть объект МИ,проверить
    else mic := true; //------------------------------------------------------ иначе МИ(ч)

    ObjZav[Ptr].bParam[15] := GetFR3(Nkm,Nepar,Activ); //----------------------------- НКМ

    if MI_N > 0 then min := not GetFR3(MI_N,Nepar,Activ) //------------------------- МИ(н)
    else min := true;



    ObjZav[Ptr].bParam[7] := not GetFR3(PrZC,Nepar,Activ);//-------------- - замк чет STAN

    ObjZav[Ptr].bParam[11] := not GetFR3(PrZN,Nepar,Activ); //---- предв замык неч из STAN

    ObjZav[Ptr].bParam[31] := Activ; //--------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := Nepar; //------------------------------------ Непарафазность


    if  VidB > 0 then
    begin
      OVBuffer[VidB].Param[16] := Activ;
      OVBuffer[VidB].Param[1] := Nepar;
      if Activ and not Nepar then
      begin
        OVBuffer[VidB].Param[18] := (config.ru = ObjZav[ptr].RU) and  WorkMode.Upravlenie;
        if ObjZav[Ptr].bParam[3] <> z1 then //-------------------------- если НИ обновился
        begin
          if ObjZav[Ptr].bParam[3] then
          begin
            ObjZav[Ptr].iParam[2] := 0;
            ObjZav[Ptr].bParam[8] := true; //--------------------------- снять трассировку
            ObjZav[Ptr].bParam[14] := false; //----------- снять предварительное замыкание
          end;
        end;
        ObjZav[Ptr].bParam[3] := z1;  //----------------------------------------------- нИ

        if ObjZav[Ptr].bParam[2] <> z2 then //-------------------------- если ЧИ обновился
        begin
          if ObjZav[Ptr].bParam[2] then
          begin
            ObjZav[Ptr].iParam[3] := 0;
            ObjZav[Ptr].bParam[8] := true; //--------------------------- снять трассировку
            ObjZav[Ptr].bParam[14] := false; //----------- снять предварительное замыкание
          end;
        end;
        ObjZav[Ptr].bParam[2] := z2;  //----------------------------------------------- чИ

        if ObjZav[Ptr].bParam[5] <> mic then
        begin
          if ObjZav[Ptr].bParam[5] then
          begin
            ObjZav[Ptr].bParam[8] := true; //--------------------------- снять трассировку
            ObjZav[Ptr].bParam[14] := false; //----------- снять предварительное замыкание
          end;
        end;
        ObjZav[Ptr].bParam[5] := mic;  //------------------------------------------- МИ(ч)

        if ObjZav[Ptr].bParam[6] <> min then
        begin
          if ObjZav[Ptr].bParam[6] then
          begin
            ObjZav[Ptr].bParam[8] := true; //--------------------------- снять трассировку
            ObjZav[Ptr].bParam[14] := false; //----------- снять предварительное замыкание
          end;
        end;
        ObjZav[Ptr].bParam[6] := min;  //------------------------------------------- МИ(н)

        //---------------------------------------- проверка передачи на местное управление
        ObjZav[Ptr].bParam[9] := false;

        for i := 20 to 24 do //------------------------- пройтись по номерам возможных РМУ
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of //----------------- по типу РМУ
            25 : //---------------------------------------------------- маневровая колонка
            if not ObjZav[Ptr].bParam[9] //----------------------------------- если нет РМ
            then ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);

            43 : //------------------------------------- оПИ - исключение пути из маневров
            if not ObjZav[Ptr].bParam[9] //----------------------------------- если нет РМ
            then ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
          end;
        end;

        OVBuffer[VidB].Param[2] := ObjZav[Ptr].bParam[3]; //--------------------------- ни
        OVBuffer[VidB].Param[3] := ObjZav[Ptr].bParam[2]; //--------------------------- чи
{$IFDEF RMDSP}
        //------------------------------------------- собираем занятости из соседних стоек
        OVBuffer[VidB].Param[4] := ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[16];
{$ELSE}
        if tab_page  then OVBuffer[VidB].Param[4]:=ObjZav[Ptr].bParam[1] //--- занятость Ч
        else OVBuffer[VidB].Param[4] := ObjZav[Ptr].bParam[16]; //------------ занятость Н
{$ENDIF}
        OVBuffer[VidB].Param[5] := ObjZav[Ptr].bParam[4];   //------------------------ чкм
        OVBuffer[VidB].Param[7] := ObjZav[Ptr].bParam[15];  //------------------------ нкм
        OVBuffer[VidB].Param[9] := ObjZav[Ptr].bParam[9];   //------------------------- рм
        OVBuffer[VidB].Param[10] := ObjZav[Ptr].bParam[5]  and ObjZav[Ptr].bParam[6];// ми
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if not ObjZav[Ptr].bParam[14] then //--- если нет программное замыкание в РМ ДСП
          begin
            if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then //Чз, Нз в FR3
            begin
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin //--------------------------------- светить немигающую тонкую белую полосу
              OVBuffer[VidB].Param[14] := false;
              OVBuffer[VidB].Param[6] := ObjZav[Ptr].bParam[8];
            end;
          end else
          begin
            if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
            begin //--------------------------------------------------------------- из FR3
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin
              OVBuffer[VidB].Param[14] := false;
              if tab_page then  OVBuffer[VidB].Param[6] := true//
              else OVBuffer[VidB].Param[6] :=  ObjZav[Ptr].bParam[8]; //------- из объекта
            end;
          end;
        end else
        begin //------------------------------------------------------------------- из FR3
{$ENDIF}
          OVBuffer[VidB].Param[6] := ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11];
          OVBuffer[VidB].Param[14]:= not OVBuffer[VidB].Param[6];
{$IFDEF RMDSP}
        end;
{$ENDIF}

        sost1 := GetFR5(PutCH  div 8);

        if (PutN > 0) and (PutCH <> PutN) then sost2 := GetFR5(PutN div 8)//составной путь
        else sost2 := 0;

        sost := sost1 or sost2;

        //роверить наличие блокировки дубляжа диагностики от разных контроллеров за 1 сек.
        ObjZav[Ptr].Timers[1].Active := ObjZav[Ptr].Timers[1].First < LastTime;

        if (sost > 0) and
        ((sost <> byte(ObjZav[Ptr].iParam[4])) or ObjZav[Ptr].Timers[1].Active) then
        begin
          ObjZav[Ptr].iParam[4] := SmallInt(sost);
{$IFDEF RMSHN}
          //-------------------------------- зафиксировать время блокировки диагностики ШН
          ObjZav[Ptr].Timers[1].First := LastTime + 1 / 86400;
{$ELSE}
          //------------------------------- зафиксировать время блокировки диагностики ДСП
          ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400;
{$ENDIF}
          if (sost and 4) = 4 then
          begin //---------------------------------------- фиксируем отсутствие теста пути
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,397+$1000,0);
//            SingleBeep := true;
              ObjZav[Ptr].bParam[19] := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,397+$1000,0);
                AddFixMessage(GetShortMsg(1,397,ObjZav[Ptr].Liter,0),4,1);
              end;
              //----------------------- Фиксировать неисправность если включено управление
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie;
{$ENDIF}
            end;

            if (sost and 1) = 1 then
            begin //--------------------------------------- фиксируем лoжную занятость пути
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,394+$1000,0);
              ObjZav[Ptr].bParam[19] := true;
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,394+$1000,0);
                AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter,0),4,1);
              end;
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать при управлении
{$ENDIF}
            end;
            if (sost and 2) = 2 then
            begin //------------------------------------ фиксируем ложную свободность пути
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,395+$1000,0);
              ObjZav[Ptr].dtParam[2] := LastTime;
              inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,395+$1000,0);
                AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter,0),4,1);
              end;
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; //- Фиксировать неисправность
{$ENDIF}
            end;
          end;
        end;

        OVBuffer[VidB].Param[13] := ObjZav[Ptr].bParam[19];

        //---------------------------------------------------------------------------- FR4
        ObjZav[Ptr].bParam[12] := GetFR4State(PutCH div 8 * 8 + 2);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[13]
          else OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[12];
        end else
{$ENDIF}
        OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[12];

        if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
        begin //--------------------------------------------------------- есть электротяга
          ObjZav[Ptr].bParam[27] := GetFR4State(PutCH div 8 * 8 + 3);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page then OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[24]
            else OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[27];
          end else
{$ENDIF}
          OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[27];

          if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
          begin //------------------------------------------------ есть 2 вида электротяги
            ObjZav[Ptr].bParam[28] := GetFR4State(PutCH div 8 * 8);
{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
            begin
              if tab_page
              then OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[25]
              else OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[28];
            end else
{$ENDIF}
            OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[28];
            ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1] div 8 * 8 + 1);

{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
            begin
              if tab_page then OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[26]
              else OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[29];
            end else
{$ENDIF}
              OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[29];
          end;
        end;
      end;
    except
{$IFNDEF RMARC}
      reportf('Ошибка [MainLoop.PrepPuti]');
{$ENDIF}
      Application.Terminate;
    end;
end;
 //========================================================================================
//------------------------------------ Подготовка объекта светофора для вывода на табло #5
procedure PrepSvetofor(Ptr : Integer);
var
  i,j,VidBuf : integer;
  n,o,zso,so,jso,vnp,kz,Nepar,Aktiv : boolean;
  sost : Byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    ObjZav[Ptr].bParam[1] :=  //-------------------------------------- МС1 (ВС маневровый)
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[2] := //------------------------------------------------------- МС2
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[3] := //------------------------------------------ С1 (ВС поездной)
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[4] := //-------------------------------------------------------- С2
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    o :=   //-------------------------------------------------------------------- огневое
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[6] := //---------------------------- признак "маневровое начало НМ"
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[8] := //------------------------------- признак "поездное начало Н"
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[10] := // Ко -------------------------- включение сигнала прикрытия
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    if ObjZav[Ptr].bParam[4] and //---------------------- если включен С2 - поездной и ...
    (ObjZav[Ptr].BaseObject = 0) then  //-------------------------- нет перекрывной секции
    begin
      ObjZav[Ptr].bParam[9] := false;
      ObjZav[Ptr].bParam[14] := false;
    end;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      VidBuf := ObjZav[Ptr].VBufferIndex;

      OVBuffer[VidBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VidBuf].Param[1] := ObjZav[Ptr].bParam[32];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then // активен и парафазен
      begin
        OVBuffer[VidBuf].Param[18] := (config.ru = ObjZav[ptr].RU);//район упр-ния активен

        inc(LiveCounter);

//---------------------------------------------------------------- обработка огневого реле
        if o <> ObjZav[Ptr].bParam[5] then //------------- огневое реле изменило состояние
        begin
          if o then //---------------------------------- неисправность огневушки появилась
          begin
            if ObjZav[Ptr].Timers[3].Active = false then  //------- если таймер не активен
            begin
              ObjZav[Ptr].Timers[3].Active := true;
              ObjZav[Ptr].Timers[3].First := LastTime;
            end else //------------------------------- если таймер был ранее активизирован
            begin
              if (LastTime - ObjZav[Ptr].Timers[3].First) > 5/80000 then//прошло 2 секунды
              begin
                if not ObjZav[Ptr].bParam[2] and //---------------------- закрыт МС2 и ...
                not ObjZav[Ptr].bParam[4] then//-------------------------------- закрыт С2
                begin
                  if WorkMode.FixedMsg then //------------- если работа с фиксацией ошибок
                  begin
{$IFDEF RMDSP}
                    if config.ru = ObjZav[ptr].RU then //------- если наш район управления
                    begin
                      if ObjZav[Ptr].bParam[10] then //----- если включен сигнал прикрытия
                      begin
                        //-------------"Неисправность красного огня светофора прикрытия $"
                        InsArcNewMsg(Ptr,481+$1000,1);
                        AddFixMessage(GetShortMsg(1,481, ObjZav[ptr].Liter,1),4,4);
                      end else
                      begin
                        InsArcNewMsg(Ptr,272+$1000,0);//---------- "Неисправен светофор $"
                        AddFixMessage(GetShortMsg(1,272, ObjZav[ptr].Liter,0),4,4);
                      end;
                    end;
{$ELSE}
                    if ObjZav[Ptr].bParam[10] then
                    InsArcNewMsg(Ptr,481+$1000,0) //---------- "Неисправен сигнал прикрытия"
                    else   InsArcNewMsg(Ptr,272+$1000,0); //--- Неисправен запрещающий огонь
                    SingleBeep4 := true;
                    ObjZav[Ptr].dtParam[1] := LastTime;
                    inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
                    ObjZav[Ptr].bParam[5] := o;  //----- обновить значение огневого реле О
                  end;   //----------------------------------------------- конец фиксации
                end;//-------------------------------------------- конец закрытого сигнала

                ObjZav[Ptr].bParam[20] := false; //-------- сброс восприятия неисправности
                ObjZav[Ptr].Timers[3].Active := false;
                ObjZav[Ptr].Timers[3].First := 0;

              end;//-------------------------------------------------- конец времени 2 сек
            end; //----------------------------------------------- конец таймера активного
          end else //---------------------------------------------- конец огневушка = true
          begin
            ObjZav[Ptr].Timers[3].Active := false;
            ObjZav[Ptr].Timers[3].First :=0;
            ObjZav[Ptr].bParam[5] := o;  //------------- обновить значение огневого реле О
          end;
        end;
//------------------------------------------------------------ конец работы с огневым реле

        if ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[3] or //-------- МС1 или С1 или ...
        ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4] then //----------------- МС2 или С2
        begin //---------------------------------------------- открыт или выдержка времени
          for i := 1 to 10 do //---------------------------- просмотр всех возможных трасс
          begin
            if MarhTracert[i].SvetBrdr = Ptr then //------ данный сигнал открылся в трассе
            begin
              for j := 1 to 10 do MarhTracert[i].MarhCmd[j] := 0;
              ObjZav[Ptr].bParam[14] := false; //-- сбросить программное замыкание сигнала
              ObjZav[Ptr].bParam[7] := false;//--- сбросить маневровую трассировку сигнала
              ObjZav[Ptr].bParam[9] := false;//----- сбросить поездную трассировку сигнала
              j := MarhTracert[i].HTail; //------------------------- выделить хвост трассы
              ObjZav[j].bParam[14] := false; //-------- снять программное замыкание хвоста
              ObjZav[j].bParam[7] := false;//------ сбросить маневровую трассировку хвоста
              ObjZav[j].bParam[9] := false;//-------- сбросить поездную трассировку хвоста
              j := MarhTracert[i].PutPriem;
              ObjZav[j].bParam[14] := false; //---------- снять программное замыкание пути
              ObjZav[j].bParam[7] := false;//-------- сбросить маневровую трассировку пути
              ObjZav[j].bParam[9] := false;//---------- сбросить поездную трассировку пути
            end;
          end;

          ObjZav[Ptr].iParam[1] := 0; //------------------------- сбросить индекс маршрута
          ObjZav[Ptr].bParam[34] := false; //---------- отменить признак сброса на сервере



          if(((ObjZav[Ptr].iParam[10] and $4) = 0) and //если нет фиксации неисправности и
          (((ObjZav[Ptr].bParam[1] and //--------------------------------------- МС1 и ...
          ObjZav[Ptr].bParam[3]) and // ----------------------------------------- С1 и ...
          not ObjZav[Ptr].ObjConstB[22]) //--------------------------------- нет общего ВС
          or //------------------------------------------------------------------- или ...
          (ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[4]))) then //------------ МС2 и С2
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,300+$1000,1);//"Неисправен разрешающий огонь светофора $"
                AddFixMessage(GetShortMsg(1,300, ObjZav[ptr].Liter,1),4,4)
              end;
{$ELSE}
              InsArcNewMsg(Ptr,300+$1000,1);
{$ENDIF}
            end;
            ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $4;//--- фиксация ненормы
          end;
        end
        else ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFFB;//- сброс фиксации

//----------------------------------------------------------------------------------------
        if ObjZav[Ptr].BaseObject > 0 then //---------------- если есть перекрывная секция
        begin
          if ObjZav[Ptr].bParam[11] <> ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
          begin //------------------------------------------ замыкание в секции изменилось
            if ObjZav[Ptr].bParam[11] then  //-------------- если раньше замыкания не было
            begin
              ObjZav[Ptr].iParam[1] := 0;  //-------------------- сбросить индекс маршрута
              ObjZav[Ptr].bParam[34] := false; //------ сбросить признак сброса на сервере
            end else
            begin //------------------------ если раньше было замыкание перекрывной секции
              ObjZav[Ptr].bParam[14] := false; //------------- снять программное замыкание
              ObjZav[Ptr].bParam[7] := false;  //------------ Сброс маневровой трассировки
              ObjZav[Ptr].bParam[9] := false;  //-------------- Сброс поездной трассировки
              ObjZav[Ptr].iParam[2] := 0;      //-------------------------------- Сброс ГВ
              ObjZav[Ptr].iParam[3] := 0;      //-------------------------------- Сброс УН
            end;
            ObjZav[Ptr].bParam[11] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2];//- копия З
          end;
        end;

//========================================================================================
//------------------------------------------------ проверка передачи на местное управление
        ObjZav[Ptr].bParam[18] := false;  //---------------- сбросить признаки "РМ или МИ"
        ObjZav[Ptr].bParam[21] := false; //---------------------------------- сбросить МУС

        for i := 20 to 24 do //---------------------------- пройти по возможным районам МУ
        begin
          j := ObjZav[Ptr].ObjConstI[i];

          if j > 0 then //------------------------------ если есть принадлежность к району
          begin
            case ObjZav[j].TypeObj of //--------------------- переключатель по типу района
              25 :
              begin //-------------------------------------------- МК (маневровая колонка)
                if not ObjZav[Ptr].bParam[18] then //------------------ если нет "РМ | МИ"
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(j); //---- получить "РМ | МИ"

                if ObjZav[Ptr].ObjConstB[18] and //------------- если отображать МУС и ...
                not ObjZav[Ptr].bParam[21] then //------------------------ и МУС не собран
                begin //------------------------------------------------------ Собрать МУС
                  ObjZav[Ptr].bParam[21] := ObjZav[j].bParam[1] and     //------- РМ и ...
                                          not ObjZav[j].bParam[4] and //--------------- оИ
                                          ObjZav[j].bParam[5];        //--- В (восприятие)
                end;

                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[j].bParam[3]; //---------------------------------- РМ&ОИ или МИ
              end;

              43 :
              begin //---------------------------------------------------------------- оПИ
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);

                if ObjZav[Ptr].ObjConstB[18] and //------------- если отображать МУС и ...
                not ObjZav[Ptr].bParam[21] then //---------------------------- МУС = false
                begin //------------------------------------------------------ Собрать МУС
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ РМ
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- оИ
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and     //--------------------- В
                  not ObjZav[j].bParam[2]; //----------------------------------------- РПо
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- РМ&ОИ или МИ
              end;

              48 :
              begin //---------------------------------------------------------------- РПо
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
                if ObjZav[Ptr].ObjConstB[18] and //------------- если отображать МУС и ...
                not ObjZav[Ptr].bParam[21] then //---------------------------- МУС = false
                begin //------------------------------------------------------ Собрать МУС
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ РМ
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- оИ
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and     //--------------------- В
                  ObjZav[j].bParam[1]; //----------------------------- есть проход на пути
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- РМ&ОИ или МИ
              end;

              52 :
              begin //-------------------------------------------------------------- СВМУС
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
                if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
                begin //------------------------------------------------------ Собрать МУС
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ РМ
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- оИ
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and //------------------------- В
                  ObjZav[j].bParam[1]; //-------------- есть проход по пошерстным стрелкам
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- РМ&ОИ или МИ
              end;
            end; //--------------------------------- конец переключателя по типу района МУ
          end; //---------------------------------------- конец принадлежности к району МУ
        end; //------------------------------------- конец прохода по возможным районам МУ

        if (ObjZav[Ptr].iParam[2] = 0) and //---------------------------------- признак ГВ
        (ObjZav[Ptr].iParam[3] = 0) and //------------------------------------ признак УН
        not ObjZav[Ptr].bParam[18] then //------------------------------------ признак РМ
        begin //------------------------------- контролировать замедление сигнального реле
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then // если перекрывная СП свободна
          begin //----------------------- сброс таймера при свободности перекрывной секции
            ObjZav[Ptr].Timers[1].Active := false;
          end else  //------------------------------------------ перекрывная секция занята
          if ObjZav[Ptr].bParam[4] then //-------------------------- если открыт сигнал С2
          begin //---------------------------------------------------------- сигнал открыт
            if not ObjZav[Ptr].Timers[1].Active then //----------------- таймер не активен
            begin //--------------------------------------------- фиксируем начало отсчета
              ObjZav[Ptr].Timers[1].Active := true;
              ObjZav[Ptr].Timers[1].First := LastTime;
            end;
          end else
          begin //------------------------------------------------------ сигнал перекрылся
            if ObjZav[Ptr].Timers[1].Active then
            begin
              ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
              ObjZav[Ptr].dtParam[6] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
            end;
          end;
        end;

        if (ObjZav[Ptr].iParam[2] = 0) and //---------------------------------- признак ГВ
        (ObjZav[Ptr].iParam[3] = 0) and //------------------------------------- признак УН
        not ObjZav[Ptr].bParam[18]      //------------------------------------- признак РМ
{$IFDEF RMDSP}
        and (ObjZav[Ptr].RU = config.ru) //------ в РМ-ДСП - проверить соответствие района
        and WorkMode.Upravlenie          //-------------------------- и наличие управления
{$ENDIF}
        then
        begin //-------------------------------------------------- контроль работы сигнала
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
          begin //--------------------------------------- нет замыкания перекрывной секции
            if not ObjZav[Ptr].Timers[1].Active and
            not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[9] then
            begin //---------------- нет ожидания обестачивания поездного сигнального реле
              if ObjZav[Ptr].bParam[4] then
              begin //------------------------------------------------------------- есть С
                if((ObjZav[Ptr].iParam[10] and $2) = 0) then
                begin //----------------------------- нет фиксации неисправности светофора
                  if WorkMode.FixedMsg then
                  begin
                    InsArcNewMsg(Ptr,510+$1000,0);
                    //---------- "Зафиксировано открытие сигнала $ без установки маршрута"
                    AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter,0),4,1);
                  end;
                end;
                ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $2;
              end
              else ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFD;
            end;

            if ObjZav[Ptr].bParam[2] then //------------------------------ если открыт МС2
            begin
              if not ObjZav[Ptr].bParam[6] and //---- нет начала маршрута из сервера и ...
              not ObjZav[Ptr].bParam[7] then //---------------- нет маневровой трассировки
              begin //---------------------------------------- есть МС без начала маршрута
                if ObjZav[Ptr].Timers[2].Active then //--------------- если запущен таймер
                begin //-------------- ожидание обестачивания маневрового сигнального реле
                  if LastTime > ObjZav[Ptr].Timers[2].First then //-- время ожидания вышло
                  begin
                    if ((ObjZav[Ptr].iParam[10] and $1) = 0) then //--------- нет фиксации
                    begin
                      if WorkMode.FixedMsg then
                      begin
                        //-------- Зафиксировано открытие сигнала $ без установки маршрута
                        InsArcNewMsg(Ptr,510+$1000,0);
                        AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter,0),4,1);
                        ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $1;
                      end;
                    end;
                  end;
                end else
                begin //---------- нет ожидания обестачивания маневрового сигнального реле
                  ObjZav[Ptr].Timers[2].First := LastTime + 5 / 86400;
                  ObjZav[Ptr].Timers[2].Active := true;
                end;
              end;
            end  else
            begin
              ObjZav[Ptr].Timers[2].Active := false;//---- сброс таймера,маневровый закрыт
              ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFFE;
            end;
          end else //------------------------------------------ есть замыкание перекрывной
          if ObjZav[Ptr].bParam[6] or//-------------------- есть признак НМ из сервера или
          ObjZav[Ptr].bParam[8] then //------------------------- есть признак Н из сервера
          begin
            if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then //- занята перекрывная СП
            begin
              if not ObjZav[Ptr].bParam[27] then //--- не фиксировано занятие СП в сигнале
              begin
                if not (ObjZav[Ptr].bParam[2] //-------------------- нет включения МС2 ...
                or ObjZav[Ptr].bParam[4]) then //-------------------- или нет включения С2
                begin //---------------------------------------------------- сигнал закрыт
                  if WorkMode.FixedMsg then
                  begin
                    InsArcNewMsg(Ptr,509+$1000,0);//------ Занятие СП  до открытия сигнала
                    AddFixMessage(GetShortMsg(1,509,ObjZav[Ptr].Liter,0),4,1);
                    ObjZav[Ptr].bParam[19] := true; //--------- выставить признак фиксации
                  end;
                end;
                ObjZav[Ptr].bParam[27] := true; //--- фиксируем занятие перекрывной секции
              end;
            end;
          end;
        end;

        if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then //--- свободна перекрывная секция
        ObjZav[Ptr].bParam[27] := false;//- сброс признака фиксации занятия перекрывной СП

        if ObjZav[Ptr].ObjConstI[28] > 0 then
        begin //-------------------------------- отобразить состояние автодействия сигнала
          OVBuffer[VidBuf].Param[31] := ObjZav[ObjZav[Ptr].ObjConstI[28]].bParam[1];
        end else OVBuffer[VidBuf].Param[31] := false;

        OVBuffer[VidBuf].Param[3] :=  //-------------------------  маневровый сигнал табло
        ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[21]; //- маневровый или МУС объекта OZ

        OVBuffer[VidBuf].Param[5] := ObjZav[Ptr].bParam[4];//-------------------- Поездной
        OVBuffer[VidBuf].Param[6] := ObjZav[Ptr].bParam[5];//------------------- огневушка

        if not ObjZav[Ptr].bParam[2] and  //-------------------- закрыт маневровый и ...
        not ObjZav[Ptr].bParam[4] and //-------------------------- закрыт поездной и ...
        not ObjZav[Ptr].bParam[21] then //-------------------------------------- нет МУС
        begin
          OVBuffer[VidBuf].Param[2] := ObjZav[Ptr].bParam[1]; //- перенос в видеобуфер МВС

          OVBuffer[VidBuf].Param[4] := ObjZav[Ptr].bParam[3]; //- в видеобуфер поездной ВС

          if not ObjZav[Ptr].bParam[1] and
          not ObjZav[Ptr].bParam[3] then //-------------------------- если нет никакого ВС
          begin
            if WorkMode.Upravlenie then //----------------------------- если АРМ управляет
            begin
              if not ObjZav[Ptr].bParam[14] and //----------- нет программного замыкания и
              ObjZav[Ptr].bParam[7] then    //------------------------- есть трассировка
              begin //--------------------------------- при трассировке светить немигающую
                OVBuffer[VidBuf].Param[11] := ObjZav[Ptr].bParam[7]; //-------- из объекта
              end else

              //-------- здесь организуется мигание начала маневров при различии со "STAN"
              if tab_page then //-------------- проверка выдачи команды установки маршрута
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //перекрывная занята и
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then //- перекрывная замкнута
                OVBuffer[VidBuf].Param[11]:=false //--- снять маневр. начало в видеобуфере
                else
                OVBuffer[VidBuf].Param[11]:=//--- иначе маневровое начало табло состоит из
                ObjZav[Ptr].bParam[6] and   //--------------------- НМ из FR3 (stan) и ...
                not ObjZav[Ptr].bParam[34] //------------------  нет сброса трассы сервера
              end else
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //перекрывная занята и
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then //- перекрывная замкнута
                OVBuffer[VidBuf].Param[11] := false //---- снять маневровое начало в табло
                else OVBuffer[VidBuf].Param[11] := //-- маневровое начало табло состоит из
                ObjZav[Ptr].bParam[7]; //---------------------------------- МПР из объекта
              end;
            end
            else //------------------------------------------ если нет управления от АРМа
            OVBuffer[VidBuf].Param[11] := ObjZav[Ptr].bParam[6];//маневровое начало из FR3

            if WorkMode.Upravlenie then //----------------------------- если АРМ управляет
            begin
              if not ObjZav[Ptr].bParam[14] and //------- нет программного замыкания и ...
              ObjZav[Ptr].bParam[9] then //------------------ есть трассировка ППР из АРМа
              begin // при трассировке светить немигающую
                OVBuffer[VidBuf].Param[12] := //--------- поездное начало табло состоит из
                ObjZav[Ptr].bParam[9]; //------------ из поездной трассировки объекта АРМа
              end else //------------------------------ при наличии программного замыкания

              //-------- здесь организуется мигание начала поездных при различии со "STAN"
              if tab_page then //-------------- проверка выдачи команды установки маршрута
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //перекрывная занята и
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then  // перекрывная замкнута
                OVBuffer[VidBuf].Param[12] := false //------ снять поездное начало в табло
                else
                OVBuffer[VidBuf].Param[12] := //---- иначе поездое начало табло состоит из
                ObjZav[Ptr].bParam[8] and //------------------- начало П из FR3 ("stan") и
                not ObjZav[Ptr].bParam[34] //---------------------- если нет сброса трассы
              end else
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //перекрывная занята и
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then  // перекрывная замкнута
                OVBuffer[VidBuf].Param[12]:=false //-------- снять поездное начало в табло
                else
                OVBuffer[VidBuf].Param[12] := ObjZav[Ptr].bParam[9]; //из ППР объекта АРМа
              end;
            end else //------------------------------------------- если нет управления, то
            OVBuffer[VidBuf].Param[12] := ObjZav[Ptr].bParam[8]; //------- начало П из FR3
          end else //------------------------------------------------------- есть любой ВС
          begin
            OVBuffer[VidBuf].Param[11] := false;//---------- снять маневровое начало табло
            OVBuffer[VidBuf].Param[12] := false;//------------ снять поездное начало табло
          end;
        end else //-------------------------------------- открыт какой-либо сигнал или МУС
        begin
          OVBuffer[VidBuf].Param[2] := false; //------------------------- убрать МВС табло
          OVBuffer[VidBuf].Param[4] := false;//-------------------------- убрать ПВС табло
          OVBuffer[VidBuf].Param[11] := false;//-------------------- убрать М начало табло
          OVBuffer[VidBuf].Param[12] := false;//-------------------- убрать П начало табло
        end;

        sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
        if (ObjZav[Ptr].iParam[2] = 0) and //индекс горы для сигналов надвига (признак ГВ)
        (ObjZav[Ptr].iParam[3] = 0) and //---- индекс горы для сигналов надвига признак УН
        not ObjZav[Ptr].bParam[18] then //------------------------------------- признак РМ
        begin //- контроль перекрытия сигнала, если не установлен маршрут надвига на горку
          if ((sost and 1) = 1) and not ObjZav[Ptr].bParam[18] then
          begin //----------------------------------------- фиксируем перекрытие светофора
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
{$ENDIF}
              if WorkMode.OU[0] then
              begin //------------------------------ перекрытие в режиме управления с АРМа
                InsArcNewMsg(Ptr,396+$1000,0); //------------ "Зафиксировано перекрытие $"
                AddFixMessage(GetShortMsg(1,396,ObjZav[Ptr].Liter,0),4,1);
              end else
              begin //---------------------------- перекрытие в режиме управления с пульта
                InsArcNewMsg(Ptr,403+$1000,0); //------- "Зафиксировано перекрытие $ (АУ)"
                AddFixMessage(GetShortMsg(1,403,ObjZav[Ptr].Liter,0),4,1);
              end;
{$IFDEF RMDSP}
            end;
            ObjZav[Ptr].bParam[23] :=
            WorkMode.Upravlenie and WorkMode.OU[0]; //Фиксировать,если включено управление
{$ENDIF}
{$IFNDEF RMDSP}
            ObjZav[Ptr].dtParam[2] := LastTime;
            inc(ObjZav[Ptr].siParam[2]);
            ObjZav[Ptr].bParam[23] := true; //------------------ Фиксировать неисправность
{$ENDIF}
          end;
        end
        else  ObjZav[Ptr].bParam[23] := false; //если гора или МУ - снять фиксацию ненормы
        inc(LiveCounter);
        //--------------------------------------------------------{FR4}-------------------
        ObjZav[Ptr].bParam[12] := //-------------- установить или снять блокировку сигнала
        GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
  {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU=config.ru) then//управление в своем  РУ
        begin
          if tab_page
          then OVBuffer[VidBuf].Param[32] := ObjZav[Ptr].bParam[13] //------- блок из АРМа
          else OVBuffer[VidBuf].Param[32] :=  ObjZav[Ptr].bParam[12]; //----- блок из STAN
        end else
{$ENDIF}
        OVBuffer[VidBuf].Param[32] := ObjZav[Ptr].bParam[12]//----------------- иначе STAN
      end;

      //------------------------ в любом случае ------------------------------------------
      OVBuffer[VidBuf].Param[13] := ObjZav[Ptr].bParam[23]; //----------------- перекрытие

      Aktiv := true; // Активизация2
      Nepar:= false; // Непарафазность2
      ObjZav[Ptr].bParam[30] := false;

      jso := GetFR3(ObjZav[Ptr].ObjConstI[9],Nepar,Aktiv);//-------------------------- ЖСо
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      zso :=  GetFR3(ObjZav[Ptr].ObjConstI[10],Nepar,Aktiv);//------------------------ зСо
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      so :=  GetFR3(ObjZav[Ptr].ObjConstI[25],Nepar,Aktiv);//-------------------------- Co
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      vnp := GetFR3(ObjZav[Ptr].ObjConstI[26],Nepar,Aktiv);//------------------------- ВНП
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      n :=   GetFR3(ObjZav[Ptr].ObjConstI[11],Nepar,Aktiv);//--------------------------- А
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      kz := GetFR3(ObjZav[Ptr].ObjConstI[30],Nepar,Aktiv);//--------------------------- Кз
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] :=  Nepar;
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar; //----- непарафазность 2

      if not ObjZav[Ptr].bParam[30] then //---------------------------- если парафазность2
      begin
        if jso <> ObjZav[Ptr].bParam[15] then
        begin //-------------------------------------------------------- изменение ЖСо(Со)
          if jso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].ObjConstI[10] = 0 then //--- если в объекте нет датчика зСо
                begin
                  if ObjZav[Ptr].bParam[4] then //------------------- если открыт поездной
                  InsArcNewMsg(Ptr,300+$1000,1)// "Неисправность разреш. огня светофора $"
                end
                else //---------------------------------------------- если есть датчик зСо
                begin
                  if ObjZav[Ptr].bParam[4] then //------------------- если открыт поездной
                  InsArcNewMsg(Ptr,485+$1000,0)// Неиспр. осн.нить лампы Жогня светофора $
                end;
              end;
{$ELSE}       //----------------------------- далее для АРМ ШН ---------------------------
              if ObjZav[Ptr].ObjConstI[10] = 0 then  //---- если в объекте нет датчика зСо
              begin
                if ObjZav[Ptr].bParam[4]
                then InsArcNewMsg(Ptr,300+$1000,0); //Неисправность разреш. огня светофора $
              end else
              begin
                if ObjZav[Ptr].bParam[4]
                then InsArcNewMsg(Ptr,485+$1000,0);
                //----------- "Неисправность основной нити лампы желтого огня светофора $"
              end;
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- сброс восприятия неисправности
        end;
        ObjZav[Ptr].bParam[15] := jso; //---------------------------- запомнить текущее Со

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if zso <> ObjZav[Ptr].bParam[24] then
        begin //------------------------------------------------------------ изменение зСо
          if zso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].bParam[4] then //-------------------------- открыт поездной
                begin
                  InsArcNewMsg(Ptr,486+$1000,0);//"неисправна основная нить зеленой лампы"
                  AddFixMessage(GetShortMsg(1,486,ObjZav[Ptr].Liter,0),4,4);
                  SingleBeep4 := true;
                end;
              end;
{$ELSE}       //--------------------------------------------------------- далее для АРМ ШН
              if ObjZav[Ptr].bParam[4] then
              InsArcNewMsg(Ptr,486+$1000,0);
              //-------------- Неисправность основной нити лампы зеленого огня светофора $
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- сброс восприятия неисправности
        end;
        ObjZav[Ptr].bParam[24] := zso; //--------------------------------------------- зСо

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if vnp  and ObjZav[Ptr].bParam[4] then //------------------- ВНП и открыт поездной
        begin
          if ObjZav[Ptr].Timers[4].Active = false then  //----- если таймен не был запущен
          begin
            ObjZav[Ptr].Timers[4].Active := true; //--------------------- запустить таймер
            ObjZav[Ptr].Timers[4].First := LastTime; //-------------- зафиксировать начало
            ObjZav[Ptr].Timers[4].Second := LastTime + 2/86400; //-------- ожидаемый конец
          end else
          begin //---------------------------------------------- если таймер активизирован
            if vnp and (ObjZav[Ptr].Timers[4].Second < LastTime) then   //---- время вышло
            begin
              ObjZav[Ptr].Timers[4].Active := false;
              ObjZav[Ptr].Timers[4].First := 0;
              ObjZav[Ptr].Timers[4].Second := 0;
              if vnp then
              begin
                if ( WorkMode.FixedMsg and ((ObjZav[Ptr].iParam[10] and $80) = 0)) then
                begin
{$IFDEF RMDSP}
                  if ObjZav[Ptr].RU = config.ru then
                  begin
                    InsArcNewMsg(Ptr,300+$1000,1);//- "Неисправен разрешающий светофора $"
                    AddFixMessage(GetShortMsg(1,300,ObjZav[Ptr].Liter,1),4,4);
                    ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $80; //фиксация NN
                  end;
                end;
{$ELSE}
                  InsArcNewMsg(Ptr,300+$1000,1);
                  SingleBeep4 := true;
                  ObjZav[Ptr].dtParam[3] := LastTime;
                  inc(ObjZav[Ptr].siParam[3]);
                  ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $80; //- фиксация NN
                end;
{$ENDIF}
                ObjZav[Ptr].bParam[25] := vnp;
              end;
            end else
            begin
              ObjZav[Ptr].bParam[25] := vnp;
              ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FF7F; //сброс фиксации
            end;
          end;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if so and ObjZav[Ptr].bParam[4] then //---------------------- Со и открыт поездной
        begin
          if ObjZav[Ptr].Timers[3].Active = false then  //----- если таймен не был запущен
          begin
            ObjZav[Ptr].Timers[3].Active := true; //--------------------- запустить таймер
            ObjZav[Ptr].Timers[3].First := LastTime; //-------------- зафиксировать начало
            ObjZav[Ptr].Timers[3].Second := LastTime + 2/86400; //-------- ожидаемый конец
          end else
          begin //---------------------------------------------- если таймер активизирован
            if so and (ObjZav[Ptr].Timers[3].Second < LastTime) then   //----- время вышло
            begin
              ObjZav[Ptr].Timers[3].Active := false;
              ObjZav[Ptr].Timers[3].First := 0;
              ObjZav[Ptr].Timers[3].Second := 0;
              if WorkMode.FixedMsg and ((ObjZav[Ptr].iParam[10] and $100) = 0) then
              begin
{$IFDEF RMDSP}
                if ObjZav[Ptr].RU = config.ru then
                begin
                  InsArcNewMsg(Ptr,544+$1000,0);// "Неисправна нить разреш. лампы светофора"
                  AddFixMessage(GetShortMsg(1,544,ObjZav[Ptr].Liter,0),4,4);
                  ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $100;
                end;
              end;
{$ELSE}
                InsArcNewMsg(Ptr,544+$1000,0);//Неисправна основная разрешающ.огня светофора
                SingleBeep4 := true;
                ObjZav[Ptr].dtParam[3] := LastTime;
                inc(ObjZav[Ptr].siParam[3]);
                ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $100;
              end;
{$ENDIF}
              ObjZav[Ptr].bParam[26] := so;
            end;
          end;
        end else
        begin
          ObjZav[Ptr].bParam[26] := so;
          ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FF; //----- сброс фиксации
        end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if n <> ObjZav[Ptr].bParam[17] then
        begin //-------------------------------------------------------------- Изменение А
          if n then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,338+$1000,0); //----- "Авария шкафа входного светофора $"
                AddFixMessage(GetShortMsg(1,338,ObjZav[Ptr].Liter,0),4,4);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,338+$1000,0);
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[4] := LastTime;
              inc(ObjZav[Ptr].siParam[4]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- сброс восприятия неисправности
        end;
        ObjZav[Ptr].bParam[17] := n;


        if kz <> ObjZav[Ptr].bParam[16] then
        begin //-------------------------------------------------------- Изменение Кз (Лс)
          if kz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].bParam[4] then //-------------- если открыт поездной сигнал
                begin
                  InsArcNewMsg(Ptr,497+$1000,1); //Неисправен контроль разрешающих огней $
                  AddFixMessage(GetShortMsg(1,497,ObjZav[Ptr].Liter,1),4,4);
                end else
                begin
                  InsArcNewMsg(Ptr,497+$1000,1);
                  AddFixMessage(GetShortMsg(1,497,ObjZav[Ptr].Liter,1),4,4);
                end;
              end;
{$ELSE}       //------------------ для АРМ ШН --------------------------------------------
              if ObjZav[Ptr].bParam[4]
              then InsArcNewMsg(Ptr,487+$1000,1)// Переключение сигналов зеленый на желтый
              else InsArcNewMsg(Ptr,497+$1000,1);
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[5] := LastTime;
              inc(ObjZav[Ptr].siParam[5]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- сброс восприятия неисправности
        end;
        ObjZav[Ptr].bParam[16] := kz;
        inc(LiveCounter);

        OVBuffer[VidBuf].Param[17] := ObjZav[Ptr].bParam[20]; //- восприятие неисправности
        OVBuffer[VidBuf].Param[7] := ObjZav[Ptr].bParam[30];//----------- непарафазность 2
        if ObjZav[Ptr].bParam[4] then
        begin
          OVBuffer[VidBuf].Param[8] := ObjZav[Ptr].bParam[26];//--------------- Со в табло
          OVBuffer[VidBuf].Param[15] := ObjZav[Ptr].bParam[24];//--------------------- зСо
          OVBuffer[VidBuf].Param[29] := ObjZav[Ptr].bParam[15];//--------------------- ЖСо
          OVBuffer[VidBuf].Param[19] := ObjZav[Ptr].bParam[25]; //-------------------- ВНП
        end;
        OVBuffer[VidBuf].Param[9] :=  ObjZav[Ptr].bParam[16]; //----------------------- Кз
        OVBuffer[VidBuf].Param[10] := ObjZav[Ptr].bParam[17]; //------------------------ А
        OVBuffer[VidBuf].Param[14] := ObjZav[Ptr].bParam[14];//----------------- змк РМДСП
      end;
    end;
  except
  {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepSvetofor]');
   {$ENDIF}   
    Application.Terminate;
  end;
end;
//------------------------------------------------------------------------------
//-------------------------------- подготовка объекта ограждения пути к выводу на табло #6
procedure PrepPTO(Ptr : Integer);
  var zo,og : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  zo := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Оз
  og := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // оГ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // СоГ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU); // район управления активизирован
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := false;

      if og <> ObjZav[Ptr].bParam[2] then
      begin
        if og then
        begin // установлено
          if not zo then
          begin // если нет запроса на ограждение - запустить таймер
            ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].bParam[4] := false; // разблокировать ловушку неисправности ОГ
            ObjZav[Ptr].bParam[5] := false;
          end;
        end else
        begin // снято
          ObjZav[Ptr].Timers[1].Active := false;
        end;
      end;
      ObjZav[Ptr].bParam[2] := og;

      if zo <> ObjZav[Ptr].bParam[1] then
      begin
        if zo then
        begin // получен запрос ограждения
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = ObjZav[ptr].RU) then
            begin
              InsArcNewMsg(Ptr,295,7);
              if WorkMode.Upravlenie
              then AddFixMessage(GetShortMsg(1,295,ObjZav[Ptr].Liter,7),4,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,295,7);
{$ENDIF}
          end;
        end else
        begin // снят запрос ограждения
          ObjZav[Ptr].bParam[4] := false; // разблокировать ловушку неисправности ОГ
          ObjZav[Ptr].bParam[5] := false;
          ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
          ObjZav[Ptr].Timers[1].Active := true;
        end;
      end;
      ObjZav[Ptr].bParam[1] := zo;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];
      if ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].bParam[1] then
      begin // ограждение без запроса
        if ObjZav[Ptr].Timers[1].Active then
        begin
          if (ObjZav[Ptr].Timers[1].First > LastTime) or ObjZav[Ptr].bParam[4] then
          begin // ожидаем установленную выдержку времени
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[2];
          end else
          begin
            if not ObjZav[Ptr].bParam[5] then
            begin // фиксируем неисправность ОГ
              ObjZav[Ptr].bParam[5] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if (config.ru = ObjZav[ptr].RU) then
                begin
                  InsArcNewMsg(Ptr,337+$1000,1);
                  AddFixMessage(GetShortMsg(1,337,ObjZav[Ptr].Liter,1),4,3);
                end;
{$ELSE}
                InsArcNewMsg(Ptr,337+$1000,1);
//                SingleBeep := true;
                ObjZav[Ptr].dtParam[1] := LastTime;
                inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
              end;
            end;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := true;
          end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
      end else
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[1];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[2];
        ObjZav[Ptr].Timers[1].Active := false;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPTO]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------------- Подготовка объекта пригласительного сигнала для вывода на табло #7
procedure PrepPriglasit(Ptr : Integer);
  var i : integer; ps : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность
  ps:=GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// ПС

  if ObjZav[Ptr].ObjConstI[3] > 0 then
  ObjZav[Ptr].bParam[2] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//ПСо

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if ps <> ObjZav[Ptr].bParam[1] then
      begin
        if ps then
        begin
{$IFDEF RMDSP or $IFDEF RMSHN}
          if config.ru = ObjZav[Ptr].RU then begin
            InsArcNewMsg(Ptr,380+$2000,0);
            AddFixMessage(GetShortMsg(1,380,ObjZav[Ptr].Liter,0),0,6);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,380+$2000,0);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[1] := ps;

      i := ObjZav[Ptr].ObjConstI[1] * 2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[1];
      if ObjZav[Ptr].ObjConstI[3] > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i+1] := ObjZav[Ptr].bParam[2];
        if ObjZav[Ptr].bParam[1] then
        begin //----------------------------------- если ПС открыт - проверить исправность
          if ObjZav[Ptr].bParam[2] then
          begin
            if not ObjZav[Ptr].bParam[19] then
            begin // подождать 3 секунд
              if ObjZav[Ptr].Timers[1].Active then
              begin
                if ObjZav[Ptr].Timers[1].First < LastTime then
                begin
                  if WorkMode.FixedMsg then
                  begin
{$IFDEF RMDSP}
                    if (config.ru = ObjZav[Ptr].RU) then
                    begin
                      InsArcNewMsg(Ptr,454+$1000,1);
                      AddFixMessage(GetShortMsg(1,454,ObjZav[Ptr].Liter,1),4,4);
                    end;
{$ELSE}
                    InsArcNewMsg(Ptr,454+$1000,1); SingleBeep4 := true;
{$ENDIF}
                    ObjZav[Ptr].bParam[19] := true; // фиксация неисправности ПС
                  end;
                end;
              end else
              begin
                ObjZav[Ptr].Timers[1].Active := true;
                ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
              end;
            end;
          end else
          begin
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].bParam[19] := false; // сброс фиксации неисправности ПС
          end;
        end else
        begin
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].bParam[19] := false; // сброс фиксации неисправности ПС
        end;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPriglasit]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------------------------------------- подготовка объекта УТС к выводу на экран #8
procedure PrepUTS(Ptr : Integer);
  var uu : Boolean; p : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УС
  uu := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УУ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // СУС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

      if uu <> ObjZav[Ptr].bParam[2] then
      begin
        p := ObjZav[Ptr].BaseObject;
        if (p > 0) and not ObjZav[Ptr].bParam[3] and uu and not ObjZav[Ptr].bParam[4] then
        begin
          if (not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[4]) or
             (not ObjZav[ObjZav[Ptr].BaseObject].bParam[3] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[15]) then
          begin // фиксируем изменение положения упора в установленном маршруте приема на путь
            ObjZav[Ptr].bParam[4] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,495+$2000,1);
                AddFixMessage(GetShortMsg(1,495,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,495+$2000,1);
{$ENDIF}
            end;
          end;
        end;
        if uu and not ObjZav[Ptr].bParam[1] then
        begin // Упор установлен
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[Ptr].RU then
            begin
              InsArcNewMsg(Ptr,108+$2000,1);
              AddFixMessage(GetShortMsg(1,108,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,108+$2000,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := uu;
      if not (uu xor ObjZav[Ptr].bParam[1]) then
      begin // нет контроля положения
        p := ObjZav[Ptr].BaseObject;
        if (p > 0) and not ObjZav[Ptr].bParam[3] and not ObjZav[Ptr].bParam[4] then
        begin
          if (not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[4]) or
             (not ObjZav[ObjZav[Ptr].BaseObject].bParam[3] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[15]) then
          begin // фиксируем изменение положения упора в установленном маршруте приема на путь
            ObjZav[Ptr].bParam[4] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,496+$2000,1);
                AddFixMessage(GetShortMsg(1,496,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,496+$2000,1);
{$ENDIF}
            end;
          end;
        end;
        if not WorkMode.FixedMsg then ObjZav[Ptr].bParam[4] := true; // блокировать на старте системы
        if not ObjZav[Ptr].bParam[4] then
        begin // не зафиксировано сообщение о потере контроля
          if ObjZav[Ptr].Timers[1].Active then
          begin
            if ObjZav[Ptr].Timers[1].First < LastTime then
            begin // Зафиксировать потерю контроля положения упора
              ObjZav[Ptr].bParam[4] := true;
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,109+$1000,1);
                AddFixMessage(GetShortMsg(1,109,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,1);
              end;
{$ELSE}
//              InsArcNewMsg(Ptr,109+$1000);
              SingleBeep := true;
{$ENDIF}
            end;
          end else
          begin // начать отсчет времени
            ObjZav[Ptr].Timers[1].First := LastTime+ 15/86400;
            ObjZav[Ptr].Timers[1].Active := true;
          end;
        end;
      end else
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[4] := false;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepUTS]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------------- Подготовка объекта ручного замыкания стрелок для вывода на табло #9
procedure PrepRZS(Ptr : Integer);
var
  rz,dzs,odzs : boolean;
  ii,cod,Vbufer,DatRZ,DatDZS,DatODZS: integer;
  TXT : string;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    DatRZ  := ObjZav[Ptr].ObjConstI[6];
    DatDZS := ObjZav[Ptr].ObjConstI[2];
    DatODZS := ObjZav[Ptr].ObjConstI[4];

    for ii := 1 to 32 do ObjZav[Ptr].NParam[ii] := false; //--------------- Непарафазность

    rz :=  GetFR3(DatRZ,ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    if DatDZS > 0 then
    dzs := GetFR3(DatDZS,ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31])
    else dzs := rz;

    if DatODZS > 0 then
    odzs := GetFR3(DatODZS,ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31])
    else odzs := rz;

    cod := 0;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      Vbufer := ObjZav[Ptr].VBufferIndex;
      OVBuffer[Vbufer].Param[16] := ObjZav[Ptr].bParam[31];

      if ObjZav[Ptr].bParam[31] then
      begin
        if rz then cod := cod + 1;
        if dzs then cod := cod + 2;
        if odzs then cod := cod + 4;

        ObjZav[Ptr].bParam[1] := rz;
        OVBuffer[Vbufer].Param[2] := rz;
        OVBuffer[VBufer].NParam[2] := ObjZav[Ptr].NParam[1]; //------------------------ Рз

        ObjZav[Ptr].bParam[2] := dzs;
        OVBuffer[VBufer].Param[3] := dzs;
        OVBuffer[VBufer].NParam[3] := ObjZav[Ptr].NParam[2]; //----------------------- ДзС

        ObjZav[Ptr].bParam[3] := odzs;
        OVBuffer[VBufer].Param[4] := odzs;
        OVBuffer[VBufer].NParam[4] := ObjZav[Ptr].NParam[3]; //---------------------- оДзС

        if cod <> ObjZav[Ptr].iParam[1] then //---------- если изменился код состояния РзС
        begin
          if not ObjZav[Ptr].Timers[1].Active then
          begin
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400;
          end;
        end;

        if ObjZav[Ptr].Timers[1].Active and
        (LastTime > ObjZav[Ptr].Timers[1].First) then
        begin
{$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru=ObjZav[ptr].RU) and not WorkMode.RU[0] then
          case cod of
            0:  //---------------------------------------------------------- РзС отключено
            begin
              InsArcNewMsg(Ptr,559+$2000,7);  //------- отключено ручное замыкание стрелок
              TXT := GetShortMsg(1,559,ObjZav[Ptr].Liter,7);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            1:  //----------------------------------------------- РзС включено без команды
            begin
              InsArcNewMsg(Ptr,560+$2000,1);//------------ РЗ стрелок включено без команды
              TXT := GetShortMsg(1,560,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,4,3);
              PutShortMsg(1,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            2,4,6: //---------------------------- при выполненных командах РзС не включено
            begin
              InsArcNewMsg(Ptr,561+$2000,1); // ручного замыкания стрелок нет при  команде
              TXT := GetShortMsg(1,561,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,4,3);
              PutShortMsg(1,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            5: //------------------------ выполнена предварительная команда отключения РзС
            begin
              InsArcNewMsg(Ptr,562+$2000,1); // ручного замыкания стрелок нет при  команде
              TXT := GetShortMsg(1,562,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            3,7: //----------------------------------------------- выполнено включение РзС
            begin
              InsArcNewMsg(Ptr,558+$2000,7);  //-------  включено ручное замыкание стрелок
              TXT := GetShortMsg(1,558,ObjZav[Ptr].Liter,7);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;
          end;
{$ELSE}
          case cod of
            0:  //---------------------------------------------------------- РзС отключено
            begin
              InsArcNewMsg(Ptr,559+$2000,7);  //------- отключено ручное замыкание стрелок
              SingleBeep3 := true;
            end;

            1:  //----------------------------------------------- РзС включено без команды
            begin
              InsArcNewMsg(Ptr,560+$2000,1); // ручное замык. стрелок включено без команды
              SingleBeep3 := true;
            end;

            2,3,4,6: //-------------------------- при выполненных командах РзС не включено
            begin
              InsArcNewMsg(Ptr,561+$2000,1); // ручного замыкания стрелок нет при  команде
              SingleBeep3 := true;
            end;

            5: //------------------------ выполнена предварительная команда отключения РзС
            begin
              InsArcNewMsg(Ptr,562+$2000,1); // ручного замыкания стрелок нет при  команде
              SingleBeep3 := true;
            end;

            7: //------------------------------------------------- выполнено включение РзС
            begin
              InsArcNewMsg(Ptr,558+$2000,7);  //-------  включено ручное замыкание стрелок
              SingleBeep3 := true;
            end;
          end;
{$ENDIF}
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].Timers[1].First := 0;
        end;
        ObjZav[Ptr].iParam[1] := cod;
      end;
    end;
  except
    ReportF('Ошибка [MainLoop.PrepRZS]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ Подготовка объекта управления переездом для вывода на табло #10
procedure PrepUPer(Ptr : Integer);
var
  rz : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    for ii := 1 to 32  do ObjZav[Ptr].NParam[ii] := false;//--------------- Непарафазность

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация

    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]); // зП

    ObjZav[Ptr].bParam[11] :=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]); //ПИВ

    ObjZav[Ptr].bParam[12] :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]); //УзП

    ObjZav[Ptr].bParam[13] :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);//УзПД


    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[12]; //---- УзП
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[12] := ObjZav[Ptr].NParam[12]; //--- УзП

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[13]; //----УзПД
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[13] := ObjZav[Ptr].NParam[13]; //-- УзПД

        if rz <> ObjZav[Ptr].bParam[10] then
        begin
          if rz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,575+$2000,0); //------------------------------- нажата ЗП
                AddFixMessage(GetShortMsg(1,575,ObjZav[Ptr].Liter,0),0,2);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,575+$2000,0);
{$ENDIF}
            end;
          end else
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,576+$2000,0);  //------------------ освобождена кнопка ЗП
                AddFixMessage(GetShortMsg(1,576,ObjZav[Ptr].Liter,0),0,2);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,576+$2000,0);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[10] := rz;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[10];
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[10] := ObjZav[Ptr].NParam[10];

{$IFDEF RMDSP}
        if config.ru = ObjZav[ptr].RU then
        begin
          if rz then
          begin //--------------------------------------------------------- переезд закрыт
            if ObjZav[Ptr].Timers[1].Active then
            begin
              if ObjZav[Ptr].Timers[1].First < LastTime then
              begin //------ выдать сообщение о длительном закрытии переезда под кнопку зП
                InsArcNewMsg(Ptr,514+$2000,0);
                if ObjZav[Ptr].bParam[5] then
                AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter,0),4,4)
                else AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter,0),4,3);
                ObjZav[Ptr].bParam[5] := true;
                ObjZav[Ptr].Timers[1].First := LastTime + 60 / 86400;//ожидание повторного
              end;
            end else
            begin //--------------------------------- задать ожидание первичного сообщения
              ObjZav[Ptr].Timers[1].First := LastTime + 600 / 86400;
              ObjZav[Ptr].Timers[1].Active := true;
            end;
          end else
          begin //--------------------------------------------------------- переезд открыт
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].bParam[5] := false;//- сброс фиксации длительного закрытия перезда
          end;
        end;
{$ENDIF}

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[11]; //----- ПИ
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[11] := ObjZav[Ptr].NParam[11]; //---- ПИ
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end;
  except
    reportf('Ошибка [MainLoop.PrepUPer]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ Подготовка объекта контроля(1) переезда для вывода на табло #11
procedure PrepKPer(Ptr : Integer);
var
  Npi,Cpi,kop,knp,kap,zg,kzp,Nepar : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    Nepar := false;  //---------------------------------------------------- Непарафазность

    kap :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],Nepar,ObjZav[Ptr].bParam[31]); //----------------- КПА
    ObjZav[Ptr].NParam[2] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    knp := GetFR3(ObjZav[Ptr].ObjConstI[3],Nepar,ObjZav[Ptr].bParam[31]); //---------- КПН
    ObjZav[Ptr].NParam[3] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    kzp :=  GetFR3(ObjZav[Ptr].ObjConstI[4],Nepar,ObjZav[Ptr].bParam[31]); //--------- КзП
    ObjZav[Ptr].NParam[4] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    zg := GetFR3(ObjZav[Ptr].ObjConstI[14],Nepar,ObjZav[Ptr].bParam[31]);//------------ зГ
    ObjZav[Ptr].NParam[14] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    kop := GetFR3(ObjZav[Ptr].ObjConstI[9],Nepar,ObjZav[Ptr].bParam[31]); //---------- КоП
    ObjZav[Ptr].NParam[9] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    Npi := GetFR3(ObjZav[Ptr].ObjConstI[8],Nepar,ObjZav[Ptr].bParam[31]); //---------- НПИ
    ObjZav[Ptr].NParam[8] := Nepar;

    Nepar := false;  //---------------------------------------------------- Непарафазность
    Cpi := GetFR3(ObjZav[Ptr].ObjConstI[10],Nepar,ObjZav[Ptr].bParam[31]); //--------- ЧПИ
    ObjZav[Ptr].NParam[10] := Nepar;

    ObjZav[Ptr].bParam[8] := Npi or Cpi;
    ObjZav[Ptr].bParam[9] := kop;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      if ObjZav[Ptr].bParam[31] then
      begin
        if kap <> ObjZav[Ptr].bParam[2] then
        begin
          if kap then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,143+$1000,0);  //---------------------- "авария переезда"
                AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter,0),4,3);
                SingleBeep3 := true;
              end;
{$ELSE}
              InsArcNewMsg(Ptr,143+$1000,0);
{$ENDIF}
          end;
        end;
      end;

      ObjZav[Ptr].bParam[2] := kap;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; //-------- КПА
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2]; //------- КПА
      if knp <> ObjZav[Ptr].bParam[3] then
      begin
        if knp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,144+$1000,0); //------------------ "неиспарвность переезда"
              AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter,0),4,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000,0);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := knp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3]; //-------- КПН
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3]; //------- КПН

      if kzp <> ObjZav[Ptr].bParam[4] then
      begin
        if kzp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,371+$2000,0); //-------------------------- "Закрыт переезд"
              AddFixMessage(GetShortMsg(1,371,ObjZav[Ptr].Liter,0),4,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,371+$2000,0);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,372+$2000,0); //-------------------------- "Открыт переезд"
              AddFixMessage(GetShortMsg(1,372,ObjZav[Ptr].Liter,0),0,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,372+$2000,0);
{$ENDIF}
          end;
        end
      end;
      ObjZav[Ptr].bParam[4] := kzp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4]; //-------- КзП
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4]; //------- КзП


      if zg <> ObjZav[Ptr].bParam[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000,0); //"включена заград. сигнализация на переезде"
              AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[14]; //--------ЗГ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];  //------- КзП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];  //------- КОП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[8];  //-------- ПИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[14] := ObjZav[Ptr].NParam[14]; //-------ЗГ
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];  //------ КзП
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[9] := ObjZav[Ptr].NParam[9];  //------ КОП
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[8] := ObjZav[Ptr].NParam[8];  //------- ПИ

    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepKPer]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------ Подготовка объекта контроля(2) переезда для вывода на табло #12
procedure PrepK2Per(Ptr : Integer);
var
  knp,knzp,kop,zg : Boolean;
  ii : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //--------------- Активизация предварительно установлена

  for ii := 2 to 14 do  ObjZav[Ptr].NParam[ii] := false; //--- Непарафазность убрать везде

  knp :=   //------------------------------------------------------ неисправность переезда
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);// КНП/КПН

  knzp :=  //--------------------------------------------------------- закрытость переезда
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//КНзП/КзП

  zg :=  //--------------------------------------------------------- заградительный сигнал
  GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]); //-- зГ

  if ObjZav[Ptr].ObjConstI[9] >0  then //---------------------- если существует датчик КоП
  kop := //----------------------------------------------------------- открытость переезда
  GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]) //--- КоП
  else kop := not knzp; //------------------------- если датчика Коп нет, то инверсия КНзП

  ObjZav[Ptr].bParam[8] := //------------------------------------------ нечетное извещение
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //--- НПИ

  ObjZav[Ptr].bParam[10] := //------------------------------------------- четное извещение
  GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]);//-- ЧПИ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

    if ObjZav[Ptr].bParam[31] then
    begin
      if knp <> ObjZav[Ptr].bParam[3] then
      begin //----------------------------- изменение по датчику неисправности на переезде
        if knp then
        begin //----------------------------- зафиксировать переход исправен -> неисправен
          ObjZav[Ptr].Timers[2].First := LastTime + 10/86400; //зарядить таймер на 10 сек.
          ObjZav[Ptr].Timers[2].Active := true;  //---------------------- запустить таймер
        end else
        begin //----------------------------- зафиксировать переход неисправен -> исправен
          ObjZav[Ptr].Timers[2].First := 0;
          ObjZav[Ptr].Timers[2].Active := false;
          ObjZav[Ptr].bParam[3] := false; //---- сбросить индикацию неисправности переезда
          ObjZav[Ptr].bParam[3] := knp;
        end;
      end;


      if not ObjZav[Ptr].bParam[3] and ObjZav[Ptr].Timers[2].Active then
      begin //-------------------- ожидание 10 секунд по датчику неисправности на переезде
        if ObjZav[Ptr].Timers[2].First < LastTime then
        begin //------------------------------------- отображаем неисправность на переезде
          ObjZav[Ptr].bParam[3] := true;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,144+$1000,0); //"неисправность на переезде"
              AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;

      if knzp and not kop then //--------------------- получен контроль закрытого переезда
      begin
        ObjZav[Ptr].bParam[4] := true; //--------------------------------------------- КзП
        ObjZav[Ptr].bParam[9] := false; //-------------------------------------------- КоП
        ObjZav[Ptr].bParam[2] := false;  //------------------------------------------- КПА
        ObjZav[Ptr].Timers[1].First := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[6] := false;  //---------------------------------- Фиксация КАП
      end else
      if kop and not knzp then //--------------------- получен контроль открытого переезда
      begin
        ObjZav[Ptr].bParam[4] := false; //-------------------------------------------- КзП
        ObjZav[Ptr].bParam[9] := true; //--------------------------------------------- КоП
        ObjZav[Ptr].bParam[2] := false; //-------------------------------------------- КПА
        ObjZav[Ptr].Timers[1].First := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[6] := false; //----------------------------------- Фиксация КАП
      end else
      begin //--------------------------------------------------------- авария на переезде
        if not ObjZav[Ptr].Timers[1].Active then
        begin //------------------------------- зафиксировать изменение исправен -> авария
          ObjZav[Ptr].Timers[1].First := LastTime+10/86400;
          ObjZav[Ptr].Timers[1].Active := true;
          ObjZav[Ptr].bParam[6] := true;     //Фиксация КАП
        end else
        if not ObjZav[Ptr].bParam[2] then   // КПА
        begin // ожидаем 10 секунд по датчику аварии на переезде
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin // отображаем аварию на переезде
            ObjZav[Ptr].bParam[1] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
               begin
                InsArcNewMsg(Ptr,143+$1000,0);      // "авария переезда"
                AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter,0),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,143+$1000,0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[4] := false;    //КзП
        ObjZav[Ptr].bParam[9] := false;    //КОП
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for ii := 1 to 30 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; //кпа

      if ObjZav[Ptr].bParam[3] then // авария на переезде
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]
      else // неисправность на переезде
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];  //кнп
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];    //кзп
      if zg <> ObjZav[Ptr].bParam[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000,0); //"включена заград. сигнализация на переезде"
              AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[14];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[10];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepK2Per]');
  Application.Terminate;
end;
end;
 //========================================================================================
//------------------------- Подготовка объекта оповещения монтеров для вывода на табло #13
procedure PrepOM(Ptr : Integer);
var
  nepar,rz,rrm,vo,vod : boolean;
  i,VidBufer : integer;
begin
try
  inc(LiveCounter);

  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность

  for i := 0 to 32 do ObjZav[Ptr].NParam[i] := false;
  nepar := false;
  rz :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],nepar,ObjZav[Ptr].bParam[31]);//---------------- Во(УРО)
  ObjZav[Ptr].NParam[2] := nepar;

  nepar := false;
  rrm :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],nepar,ObjZav[Ptr].bParam[31]);//-------------------- РРМ
  ObjZav[Ptr].NParam[3] := nepar;

  nepar := false;
  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],nepar,ObjZav[Ptr].bParam[31]);//--------------- ВКо(ОМП)
  ObjZav[Ptr].NParam[4] := nepar;

  nepar := false;
  ObjZav[Ptr].bParam[5] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],nepar,ObjZav[Ptr].bParam[31]);//--------------- ВВМ(ВСВ)
  ObjZav[Ptr].NParam[5] := nepar;

  nepar := false;
  vo:=
  GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,ObjZav[Ptr].bParam[31]);//--------------------- Вo
  ObjZav[Ptr].NParam[6] := nepar;

  nepar := false;
  vod:=
  GetFR3(ObjZav[Ptr].ObjConstI[7],nepar,ObjZav[Ptr].bParam[31]);//--- ВоД
  ObjZav[Ptr].NParam[7] := nepar;

  VidBufer := ObjZav[Ptr].VBufferIndex;
  if VidBufer > 0 then
  begin
    for i := 1 to 32 do OVBuffer[VidBufer].NParam[i] := ObjZav[Ptr].NParam[i];
    nepar := false;
    for i := 1 to 32 do nepar := nepar or OVBuffer[VidBufer].NParam[i];


    OVBuffer[VidBufer].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[VidBufer].Param[1] := ObjZav[Ptr].bParam[32];

    if ObjZav[Ptr].bParam[31] and not nepar then
    begin
      if rz <> ObjZav[Ptr].bParam[2] then //--------------------------- если изменилось Во
      begin
        if rz then //------------------------------------------------------------- если Во
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin //----------------------------------------------------- подключаемый УРО
              if ObjZav[Ptr].bParam[3] and (config.ru = ObjZav[ptr].RU) then
              begin
                InsArcNewMsg(Ptr,374+$2000,7);    //--------- отключено оповещение "поезд"
                AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,7),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,373+$2000,7); //------------- включено оповещение "поезд"
                AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter,7),0,2);
              end;
            end;
{$ELSE}     //----------------------------------------------------------------- для АРМ ШН
            if ObjZav[ptr].ObjConstB[1] then InsArcNewMsg(Ptr,374+$2000,7)
            else InsArcNewMsg(Ptr,373+$2000,7);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin //----------------------------------------------------- подключаемый УРО
              if rrm and (config.ru = ObjZav[ptr].RU) then
              begin
                InsArcNewMsg(Ptr,373+$2000,1);
                AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter,1),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,374+$2000,1);
                AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,1),0,2);
              end;
            end;
{$ELSE}
            if ObjZav[ptr].ObjConstB[1] then InsArcNewMsg(Ptr,373+$2000,1)
            else InsArcNewMsg(Ptr,374+$2000,1);
{$ENDIF}
          end;
        end;
      end;

      ObjZav[Ptr].bParam[2] := rz;

      if ObjZav[ptr].ObjConstB[1] then
      // для подключаемого УРО фиксировать общее выключение как отключ. оповещения "ПОЕЗД"
      begin
        if rrm <> ObjZav[Ptr].bParam[3] then
        begin
          if not rrm and not rz and WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,374+$2000,1);
              AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,1),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,374+$2000,1)
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] :=  rrm;

      if ObjZav[ptr].ObjConstB[1] then
      begin //----------------------------------------------------------- подключаемый УРО
        OVBuffer[VidBufer].Param[3] :=
        not ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[3];
      end
      else  OVBuffer[VidBufer].Param[3] := ObjZav[Ptr].bParam[2]; //--- Во

      if (vo <> ObjZav[Ptr].bParam[6]) or (vod <> ObjZav[Ptr].bParam[7]) then //Во или ВоД
      begin
        if WorkMode.FixedMsg then
        begin
          if (not vo  and not vod) then
          begin
            InsArcNewMsg(Ptr,534+$2000,7);    //-------------- "отключен запрет монтерам "
            AddFixMessage(GetShortMsg(1,534,ObjZav[Ptr].Liter,7),0,2);
          end;
          end else
          if(vo and vod) then
          begin
            InsArcNewMsg(Ptr,518+$2000,7); //------------------- "включен запрет монтерам"
            AddFixMessage(GetShortMsg(1,518,ObjZav[Ptr].Liter,1),0,2);
          end;
        end;
      end;

      ObjZav[Ptr].bParam[6] := vo;
      ObjZav[Ptr].bParam[7] := vod;
      OVBuffer[VidBufer].Param[6] := ObjZav[Ptr].bParam[6];
      OVBuffer[VidBufer].Param[7] := ObjZav[Ptr].bParam[7];

      OVBuffer[VidBufer].Param[2] := ObjZav[Ptr].bParam[2]; //------------------------ РРМ
      OVBuffer[VidBufer].Param[4] := ObjZav[Ptr].bParam[4]; //------------------------ ВКо
      OVBuffer[VidBufer].Param[5] := ObjZav[Ptr].bParam[5]; //------------------------ ВВМ
    end;
  except
    reportf('Ошибка [MainLoop.PrepOM]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- Подготовка объекта УКСПС для вывода на табло #14
procedure PrepUKSPS(Ptr : Integer);
var
  d1,d2,kzk1,kzk2,dvks : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность

  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ИКС

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Пред.К

  d1 :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//--- 1КС

  d2 :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//--- 2КС

  kzk1 :=
  GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- КзК1

  kzk2 :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- КзК2

  ObjZav[Ptr].bParam[7]  :=
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ДВКС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if d1 <> ObjZav[Ptr].bParam[3] then //----------------- датчик 1кс изменил состояние
      begin
        if d1 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,125+$1000,0); //-------------------- Сработал датчик1 УКСПС
              AddFixMessage(GetShortMsg(1,125,ObjZav[Ptr].Liter,0),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,125+$1000,0);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := d1;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[3];

      if d2 <> ObjZav[Ptr].bParam[4] then  //---------------- датчик 2кс изменил состояние
      begin
        if d2 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,126+$1000,0); //---------------- Сработал датчик2 УКСПС $
              AddFixMessage(GetShortMsg(1,126,ObjZav[Ptr].Liter,0),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,126+$1000,0);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[4] := d2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[4];

      if kzk1 <> ObjZav[Ptr].bParam[5] then
      begin
        if kzk1 then
        begin //---------------------------------------------- неисправность линии-1 УКСПС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,127+$1000,1); //--------------------- Неисправность линии-1
              AddFixMessage(GetShortMsg(1,127,ObjZav[Ptr].Liter,1),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,127+$1000,1);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[5] := kzk1;

      if kzk2 <> ObjZav[Ptr].bParam[6] then
      begin
        if kzk2 then
        begin //---------------------------------------------- неисправность линии-2 УКСПС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,525+$1000,1); //--------------------- Неисправность линии-2 $
              AddFixMessage(GetShortMsg(1,525,ObjZav[Ptr].Liter,1),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,525+$1000,1);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[6] := kzk2;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepUKSPS]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------- Подготовка объекта смены направления на перегоне для вывода на табло #15
procedure PrepAB(Ptr : Integer);
var
  kj,ip1,ip2,zs : boolean;
  uch_1ip,uch_2ip,dat_V,dat_SN,dat_KP,dat_KJ,dat_D1,dat_D2,dat_ZS,Video_Buf : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность
    //----------------------------------------------------- взять из базы индексы датчиков
    dat_V := ObjZav[Ptr].ObjConstI[2];
    uch_1ip := ObjZav[Ptr].ObjConstI[3];
    uch_2ip := ObjZav[Ptr].ObjConstI[4];
    dat_SN := ObjZav[Ptr].ObjConstI[5];
    dat_KP := ObjZav[Ptr].ObjConstI[6];
    dat_KJ := ObjZav[Ptr].ObjConstI[7];
    dat_D1 := ObjZav[Ptr].ObjConstI[8];
    dat_ZS := ObjZav[Ptr].ObjConstI[9];
    dat_D2 := ObjZav[Ptr].ObjConstI[11];
    Video_Buf := ObjZav[Ptr].VBufferIndex;

    ObjZav[Ptr].bParam[1] :=
    GetFR3(dat_V,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---------------------- В

    ip1 :=  not GetFR3(uch_1ip,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//------ 1ИП

    ip2 := not GetFR3(uch_2ip,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //------ 2ИП

    ObjZav[Ptr].bParam[4] :=
    GetFR3(dat_SN,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     //--------------- СН

    ObjZav[Ptr].bParam[5] :=
    not GetFR3(dat_KP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--------------- КП
    OVBuffer[Video_Buf].Param[5] := ObjZav[Ptr].bParam[5]; //------------- кп в видеобуфер

    kj := not GetFR3(dat_KJ,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-------- КЖ

    ObjZav[Ptr].bParam[7] :=
    GetFR3(dat_D1,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-------------------- Д1

    zs := GetFR3(dat_ZS,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //------ запрос СН

    ObjZav[Ptr].bParam[16] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // Л

    ObjZav[Ptr].bParam[8] :=
    GetFR3(dat_D2,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   //----------------- Д2

    ObjZav[Ptr].bParam[11] :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// 3ИП

    ObjZav[Ptr].bParam[17] :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//согласие смены направления

    if Video_Buf > 0 then
    begin
      OVBuffer[Video_Buf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[Video_Buf].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if zs <> ObjZav[Ptr].bParam[10] then
        begin //-------------------------------------- получен запрос на смену направления
          if ObjZav[Ptr].bParam[4] and WorkMode.FixedMsg then
          begin //------------------------------------------------- перегон по отправлению
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
{$ENDIF}
              if zs then
              begin //-------------------------------------------------- запрос установлен
                InsArcNewMsg(Ptr,439+$2000,0);//Получен запрос смены направлен.на перегоне
                AddFixMessage(GetShortMsg(1,439,ObjZav[Ptr].Liter,0),0,6);
              end else
              if ObjZav[Ptr].bParam[1] then //-------------- не начата смена (В под током)
              begin //----------------------------------------------------- запрос сброшен
                if ObjZav[Ptr].bParam[17] then //------- выдано согласие смены направления
                InsArcNewMsg(Ptr,56+$2000,7)//-- Выдана команда согласия на СН на перегоне
              else //--------------------------------------------------------- Снят запрос
                InsArcNewMsg(Ptr,440+$2000,0); //Снят запрос смены направления на перегоне
                AddFixMessage(GetShortMsg(1,440,ObjZav[Ptr].Liter,0),0,6);
              end;
{$IFDEF RMDSP}
            end;
{$ENDIF}
          end;
        end;
        inc(LiveCounter);
        ObjZav[Ptr].bParam[10] := zs;
        if ObjZav[Ptr].bParam[17] then //---------------------- если выдано согласие на СН
        OVBuffer[Video_Buf].Param[18] := tab_page //-- согласие смены направления - мигать
        else
        OVBuffer[Video_Buf].Param[18] := ObjZav[Ptr].bParam[10];//запрос смены направления

        OVBuffer[Video_Buf].Param[17] := ObjZav[Ptr].bParam[16];    //------------------ Л
        OVBuffer[Video_Buf].Param[4] := not ObjZav[Ptr].bParam[11]; //---------------- 3ип

        if kj <> ObjZav[Ptr].bParam[6] then
        begin
          if kj then
          begin //------------------------------------------------------------ вставлен КЖ
            ObjZav[Ptr].bParam[9] := false; //--------------- сброс отправления хоз.поезда
          end else //------------------------------------------------------------ Изъят КЖ
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
              InsArcNewMsg(Ptr,357+$2000,0);   //----------- Ключ-жезл $ изъят из аппарата
              AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter,0),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,357+$2000,0);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := kj;
        OVBuffer[Video_Buf].Param[11] := ObjZav[Ptr].bParam[6];

        if ip1 <> ObjZav[Ptr].bParam[2] then
        begin
          if ObjZav[Ptr].bParam[2] then  //------------------------- занятие 1 известителя
          begin
            if not ObjZav[Ptr].bParam[6] //-------------------------- если изъят ключ-жезл
            then ObjZav[Ptr].bParam[9] := true; //------------ дать отправление хоз.поезда

            if ObjZav[Ptr].ObjConstB[2] then //-------------------- есть смена направления
            begin
              if ObjZav[Ptr].ObjConstB[3] then  //------------------ подключаемый комплект
              begin
                if ObjZav[Ptr].ObjConstB[4] then  //- по приему если не подключен комплект
                begin
                  if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                  begin //---------------------------------------- если комплект подключен
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip1Beep := true;
                  end else //------------------------------------------- комплект отключен
                  if config.ru = ObjZav[ptr].RU then Ip1Beep := true;
                end else
                if ObjZav[Ptr].ObjConstB[5] then //----- по отправлению, если не подключен
                begin
                  if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then// Д2 и !Д1
                  begin
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)//- прием
                    then Ip1Beep := true;
                  end;
                end;
              end else //-------------------------------------- комплект включен постоянно
              if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
              then Ip1Beep := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU)
            then Ip1Beep := true; //------------------------------------ по приему звонить
          end;
        end;
        ObjZav[Ptr].bParam[2] := ip1;
        OVBuffer[Video_Buf].Param[2] := ObjZav[Ptr].bParam[2];

        if ip2 <> ObjZav[Ptr].bParam[3] then  //----------------------- если изменился ИП2
        begin
          if ObjZav[Ptr].bParam[3] then  //---------------------------------- если занятие
          begin //-------------------------------------------------- занятие 2 известителя
            if ObjZav[Ptr].ObjConstB[2] then  //-------------- если есть смена направления
            begin //----------------------------------------------- есть смена направления
              if ObjZav[Ptr].ObjConstB[3] then //-------------- если комплект СН подключен
              begin //---------------------------------------------- подключаемый комплект
                if ObjZav[Ptr].ObjConstB[4] then  //--------------------------- если прием
                begin //-------------------------------------------------------- по приему
                  if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                  begin //--------------------------------------------- комплект подключен
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip2Beep := true;
                  end else //------------------------------------------- комплект отключен
                  if config.ru = ObjZav[ptr].RU then Ip2Beep := true;
                end else
                if ObjZav[Ptr].ObjConstB[5] then
                begin //--------------------------------------------------- по отправлению
                  if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                  begin //--------------------------------------------- комплект подключен
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip2Beep := true;
                  end;
                end;
              end else //-------------------------------------- комплект включен постоянно
              if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
              then Ip2Beep := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) //---- если прием
            then Ip2Beep := true; //------------------------------------ по приему звонить
          end;
        end;
        ObjZav[Ptr].bParam[3] := ip2;
        OVBuffer[Video_Buf].Param[3] := ObjZav[Ptr].bParam[3];

        if ObjZav[Ptr].ObjConstB[2] then
        begin //--------------------------------------------------- есть смена направления
          OVBuffer[Video_Buf].Param[5] := ObjZav[Ptr].bParam[5];
          if ObjZav[Ptr].ObjConstB[3] then
          begin //-------------------------------- Комплект смены направления подключается
            inc(LiveCounter);
            if ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[8] then
            begin //------------------------------------------- неверно подключен комплект
              OVBuffer[Video_Buf].Param[10] := false;
              OVBuffer[Video_Buf].Param[12] := false;
            end else
            begin
              if ObjZav[Ptr].ObjConstB[4] then
              begin //-------------------------------------------------------- Путь приема
                if ObjZav[Ptr].bParam[7] then
                begin //-------------------------------------------------------------- Д1П
                  OVBuffer[Video_Buf].Param[6] := ObjZav[Ptr].bParam[1];
                  OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
                  OVBuffer[Video_Buf].Param[10] := true;
                  OVBuffer[Video_Buf].Param[12] := true;
                end else
                if ObjZav[Ptr].bParam[8] then
                begin //-------------------------------------------------------------- Д2У
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := false;
                end else
                begin
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := true;
                end;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin //--------------------------------------------------- Путь отправления
                if ObjZav[Ptr].bParam[7] then
                begin //-------------------------------------------------------------- Д1П
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := false;
                end else
                if ObjZav[Ptr].bParam[8] then
                begin //-------------------------------------------------------------- Д2У
                  OVBuffer[Video_Buf].Param[6] :=ObjZav[Ptr].bParam[1];
                  OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
                  OVBuffer[Video_Buf].Param[10] := true;
                  OVBuffer[Video_Buf].Param[12] := true;
                end else
                begin
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := true;
                end;
              end;
            end;
          end else
          begin //--------------------------- Комплект смены направления включен постоянно
            OVBuffer[Video_Buf].Param[6] := ObjZav[Ptr].bParam[1];
            OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
          end;
        end;
      end;
      //------------------------------------------------------------------------------ FR4
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- выключено управление
        if tab_page
        then OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[13]
        else OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[12];
      end else
{$ENDIF}
      OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[12];
      if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
      begin //----------------------------------------------------------- есть электротяга
        ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[24]
          else OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[27];
        end else
{$ENDIF}
        OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[27];
        if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
        begin //-------------------------------------------------- есть 2 вида электротяги
          ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[3]{ div 8 * 8});
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page
            then OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[25]
            else OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[28];
          end else
{$ENDIF}
          OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[28];
          ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 *8 +1);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page
            then OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[26]
            else OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[29];
          end else
{$ENDIF}
          OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[29];
        end;
      end;

      if ObjZav[Ptr].BaseObject > 0 then
      begin //---------------------------- последняя секция маршрута отправления прописана
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin //-------------------------------------------------------- секция разомкнута
          ObjZav[Ptr].bParam[14] := false; //---------------- сброс программного замыкания
          ObjZav[Ptr].bParam[15] := false; // сброс замыкалки маршрута отправл. на перегон
          //------------------------- сюда добавить обработку ловушки КЖ при необходимости
        end else
        begin //---------------------------------------------------------- секция замкнута
        end;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepAB]');
    Application.Terminate;
  end;
end;
//========================================================================================
// Подготовка объекта вспомогательной смены направления на перегон для вывода на табло #16
procedure PrepVSNAB(Ptr : Integer);
var
  ind_VP,ind_DVP,ind_VO,ind_DVO,VideoBuf : integer;
begin
  ind_VP := ObjZav[Ptr].ObjConstI[3];
  ind_DVP := ObjZav[Ptr].ObjConstI[5];
  ind_VO := ObjZav[Ptr].ObjConstI[2];
  ind_DVO := ObjZav[Ptr].ObjConstI[4];
  VideoBuf := ObjZav[Ptr].VBufferIndex;
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    ObjZav[Ptr].bParam[1] :=
    GetFR3(ind_VP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //------------------ ВП

    ObjZav[Ptr].bParam[2] :=
    GetFR3(ind_DVP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //---------------- ДВП

    ObjZav[Ptr].bParam[3] :=
    GetFR3(ind_VO,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //------------------ Во

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ind_DVO,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //---------------- ДВо

    if  VideoBuf > 0 then
    begin
      OVBuffer[VideoBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VideoBuf].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        OVBuffer[VideoBuf].Param[12] := ObjZav[Ptr].bParam[3];
        OVBuffer[VideoBuf].Param[13] := ObjZav[Ptr].bParam[4];
        OVBuffer[VideoBuf].Param[14] := ObjZav[Ptr].bParam[1];
        OVBuffer[VideoBuf].Param[15] := ObjZav[Ptr].bParam[2];
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepVSNAB]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------ Подготовка объекта магистрали рабочего тока стрелок для вывода на табло #17
procedure PrepMagStr(Ptr : Integer);
var
  lar : boolean;
  i,Videobuf : integer;
begin
  try
    Videobuf := ObjZav[Ptr].VBufferIndex;
    for i := 1 to 32 do
    ObjZav[Ptr].NParam[i] := false;

    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    ObjZav[Ptr].bParam[1] :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//--- Сз

    ObjZav[Ptr].bParam[2] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);//-- ВНП

    lar :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //- ЛАР

    if Videobuf > 0 then
    begin
      OVBuffer[Videobuf].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 2 to 30 do OVBuffer[Videobuf].NParam[i-1]:=ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[Videobuf].Param[16] := ObjZav[Ptr].bParam[31];
        OVBuffer[Videobuf].Param[1] := ObjZav[Ptr].bParam[1]; //------- сз
        OVBuffer[Videobuf].NParam[1] :=ObjZav[Ptr].NParam[1]; //непараф сз
        OVBuffer[Videobuf].Param[2] := ObjZav[Ptr].bParam[2]; //------ внп
        OVBuffer[Videobuf].NParam[2]:= ObjZav[Ptr].NParam[2];//непараф внп

        if lar <> ObjZav[Ptr].bParam[3] then
        begin //-------------------------------------------------- изменение состояния ЛАР
          if lar then
          begin //----------------------------------------------- неисправность питания РЦ
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,484+$1000,1);
                AddFixMessage(GetShortMsg(1,484,ObjZav[Ptr].Liter,1),0,1);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,484+$1000,1);//------ Неисправность питания рельсовых цепей
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[3] := lar;
        OVBuffer[Videobuf].Param[3] := ObjZav[Ptr].bParam[3];
      end;
    end;
  except
    Reportf('Ошибка [MainLoop.PrepMagStr]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------- Подготовка объекта магистрали макета стрелок для вывода на табло #18
procedure PrepMagMakS(Ptr : Integer);
var
  rz : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; // Активизация
    ObjZav[Ptr].bParam[32] := false; // Непарафазность
    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ВМ

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if rz <> ObjZav[Ptr].bParam[1] then
        begin
          if rz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
            if (config.ru = ObjZav[ptr].RU) and (maket_strelki_index > 0) then
              begin
                InsArcNewMsg(maket_strelki_index,377+$2000,1);
                AddFixMessage(GetShortMsg(1,377,ObjZav[maket_strelki_index].Liter,1),0,2);
              end;
{$ELSE}
              InsArcNewMsg(maket_strelki_index,377+$2000,1); //Перевод стрелки $ на макете
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[1] := rz;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepMagMakS]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------- Подготовка объекта аварийного перевода стрелок для вывода на табло #19
procedure PrepAPStr(Ptr : Integer);
var
  rz : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность
    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ГВК

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if rz <> ObjZav[Ptr].bParam[1] then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              if rz then
              begin
                InsArcNewMsg(Ptr,378+$2000,0); //- Нажата кнопка вспомогательного перевода
                AddFixMessage(GetShortMsg(1,378,ObjZav[Ptr].Liter,0),0,2);
              end else
              begin
                InsArcNewMsg(Ptr,379+$2000,0);// Отпущена кнопка вспомогательного перевода
                AddFixMessage(GetShortMsg(1,379,ObjZav[Ptr].Liter,0),0,2);
              end;
            end;
{$ELSE}
            if rz then InsArcNewMsg(Ptr,378+$2000,0)
            else InsArcNewMsg(Ptr,379+$2000,0);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[1] := rz;
      end else
      begin //--------------- Сбросить признак вспомогательного перевода при неисправности
        ObjZav[Ptr].bParam[1] := false;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  except
    reportf('Ошибка [MainLoop.PrepAPStr]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------- Подготовка объекта контроля макета для вывода на табло #20
procedure PrepMaket(Ptr : Integer);
var
  km : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    for ii := 1 to 34 do  ObjZav[Ptr].NParam[ii] := false; //-------------- Непарафазность

    km :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);  // КМ

    ObjZav[Ptr].bParam[3] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);  // МПК

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);  // ММК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

    for ii := 1 to 30 do
    OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

    if ObjZav[Ptr].bParam[31] then
    begin
      if km <> ObjZav[Ptr].bParam[2] then
      begin
        if km then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (ObjZav[Ptr].RU = config.ru) then
            begin
              InsArcNewMsg(Ptr,301+$1000,0);
              AddFixMessage(GetShortMsg(1,301,'',0),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,301+$2000,0); //--------------------- Подключен макет стрелки
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := km;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMaket]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------------- Подготовка объекта выдержки времени отмены для вывода на табло #21
procedure PrepOtmen(Ptr : Integer);
var
  om,op,os,vv : boolean;
  i,t_os,t_om,t_op : integer;  //----------------- таймеры свободный, маневровый, поездной
begin
  try
    inc(LiveCounter);
    t_os := ObjZav[Ptr].ObjConstI[5];
    t_om := ObjZav[Ptr].ObjConstI[6];
    t_op := ObjZav[Ptr].ObjConstI[7];

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    ObjZav[Ptr].NParam[2] := false;

    os:=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]); //- ГОТ
    if (ObjZav[Ptr].ObjConstI[32] and $8) = 8 then  os := not os;


    ObjZav[Ptr].NParam[3] := false;
    om:=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); //- МВ1

    if (ObjZav[Ptr].ObjConstI[32] and $4) = 4 then  om := not om;


    ObjZav[Ptr].NParam[4] := false;
    op:=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //- ПВ1
    if (ObjZav[Ptr].ObjConstI[32] and $2) = 2 then  op := not op;

    ObjZav[Ptr].NParam[11] := false;

    vv:=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);//- ВВ

    if (t_os = t_om) and not vv then
    begin
      Timer[t_os] := 0;
      ObjZav[Ptr].Timers[t_os].Active := false;
      ObjZav[Ptr].Timers[t_os].First := 0;
      ObjZav[Ptr].Timers[t_os].Second := 0;
    end;

    ObjZav[Ptr].NParam[8] := false;

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //-- ов

    ObjZav[Ptr].NParam[9] := false;
    ObjZav[Ptr].bParam[5] :=
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]); //-- МВ

    ObjZav[Ptr].NParam[10] := false;
    ObjZav[Ptr].bParam[6] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]); // ПВ

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 1 to 30 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] :=  ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        //----------------------------------------------------------- отмена со свободного
        if ObjZav[Ptr].ObjConstI[11] = 0 then //---------------------- если нет датчика ВВ
        begin
          if t_os > 0 then
          begin //---------------------------- если таймер отмены со свободного существует
            if os <> ObjZav[Ptr].bParam[1] then //------------------ если изменился бит ОС
            begin
              if ObjZav[Ptr].Timers[t_os].Active then //------- если таймер ОС был включен
              begin //--------------------------------------------- отключить счет времени
                if t_om <> t_os then  ObjZav[Ptr].Timers[t_os].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[1] := Timer[t_os];
{$ENDIF}
                if t_om <> t_os then Timer[t_os] := 0;
              end;
            end;
          end;
        end else //------------------------------------------------ если датчик ВВ имеется
        begin
          if t_os > 0 then //----------------------------------  если существует таймер ОС
          begin
            if vv <>  ObjZav[Ptr].bParam[7] then //----------------- если изменился бит ВВ
            begin
              if ObjZav[Ptr].Timers[t_os].Active then //------- если таймер ОС был включен
              begin //--------------------------------------------- отключить счет времени
                if t_os <> t_om then ObjZav[Ptr].Timers[t_os].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[1] := Timer[t_os];
{$ENDIF}
                if t_os <> t_om then Timer[t_os] := 0;
              end else
              begin //------------ если таймер был выключен, то начать счет времени с нуля
                ObjZav[Ptr].Timers[t_os].Active := true;
                ObjZav[Ptr].Timers[t_os].First := LastTime;
                Timer[t_os] := 0;
              end;
            end;
          end;
          ObjZav[Ptr].bParam[7] := vv;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];
        end;
        ObjZav[Ptr].bParam[1] := os;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];

        //------------------------------------------------------------ отмена маневровая
        if ObjZav[Ptr].ObjConstI[11] = 0 then //--------- если нет датчика ВВ (ЭЦ 12-90)
        begin
          if ObjZav[Ptr].ObjConstI[6] > 0 then
          begin //----------------------------- если таймер маневровой отмены существует
            if om <> ObjZav[Ptr].bParam[2] then //---------------- если изменился бит ОМ
            begin
              if ObjZav[Ptr].Timers[t_om].Active then //----- если таймер ОС был включен
              begin //------------------------------------------- отключить счет времени
                ObjZav[Ptr].Timers[t_om].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[2] := Timer[t_om];
{$ENDIF}
                Timer[t_om] := 0;
              end else
              begin //----------------- если таймер был выключен, то начать счет времени
                ObjZav[Ptr].Timers[t_om].Active := true;
                ObjZav[Ptr].Timers[t_om].First := LastTime;
                Timer[t_om] := 0;
              end;
            end;
          end;
        end else //------------------------------------------------ если датчик ВВ имеется
        begin
          if t_om > 0 then
          begin //----------------------------------------------- таймер отмены маневровой
            if om <> ObjZav[Ptr].bParam[2] then
            begin
              if (t_om <> t_os) and ObjZav[Ptr].Timers[t_om].Active then
              begin //--------------------------------------------- отключить счет времени
                ObjZav[Ptr].Timers[t_om].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[2] := Timer[t_om];
{$ENDIF}
                Timer[t_om] := 0;
              end else
              begin //------------------------------------------------ начать счет времени
                ObjZav[Ptr].Timers[t_om].Active := true;
                if t_om <> t_os then
                begin
                  ObjZav[Ptr].Timers[t_om].First := LastTime;
                  Timer[t_om] := 0;
                end;
              end;
            end;
          end;

          ObjZav[Ptr].bParam[2] := om;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];

          if t_op > 0 then
          begin //------------------------------------------------- таймер отмены поездной
            if op <> ObjZav[Ptr].bParam[3] then
            begin
              if ObjZav[Ptr].Timers[t_op].Active then
              begin //--------------------------------------------- отключить счет времени
                ObjZav[Ptr].Timers[t_op].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[3] := Timer[t_op];
{$ENDIF}
                if t_op <> t_om then Timer[t_op] := 0;
              end else
              begin //---------------------------------------------- начать счет времени
                ObjZav[Ptr].Timers[t_op].Active := true;
                ObjZav[Ptr].Timers[t_op].First := LastTime;
                Timer[t_op] := 0;
              end;
            end;
          end;
        end;

        ObjZav[Ptr].bParam[3] := op;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];

        if ObjZav[Ptr].Timers[t_os].Active then
        begin //------------------------- обновить значение времени отмены со свободного
          Timer[t_os] := Round((LastTime - ObjZav[Ptr].Timers[t_os].First)*86400);
          if Timer[t_os] > 300 then Timer[t_os] := 300;
        end;

        if (t_om <> t_os) and ObjZav[Ptr].Timers[t_om].Active then
        begin //---------------------------- обновить значение времени отмены маневровой
          Timer[t_om] := Round((LastTime - ObjZav[Ptr].Timers[t_om].First)*86400);
          if Timer[t_om] > 300  then Timer[t_om] := 300;
        end;

        if (t_op <> t_om) and ObjZav[Ptr].Timers[t_op].Active then
        begin //------------------------------ обновить значение времени отмены поездной
          Timer[t_op] := Round((LastTime - ObjZav[Ptr].Timers[t_op].First)*86400);
          if Timer[t_op] > 300 then Timer[t_op] := 300;
        end;
      end else
      begin // сброс счетчиков при неисправном входном интерфейсе или отсутсвии информации
        if t_os > 0 then  Timer[t_os] := 0;
        ObjZav[Ptr].Timers[t_os].Active := false;
        ObjZav[Ptr].bParam[1] := false;

        if t_om > 0 then  Timer[t_om] := 0;
        ObjZav[Ptr].Timers[t_om].Active := false;
        ObjZav[Ptr].bParam[2] := false;

        if t_op > 0 then  Timer[t_op] := 0;
        ObjZav[Ptr].Timers[t_op].Active := false;
        ObjZav[Ptr].bParam[3] := false;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepOtmen]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------------------- Подготовка объекта ГРИ для вывода на табло #22
procedure PrepGRI(Ptr : Integer);
var
  rz : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
    for ii := 1 to 34 do ObjZav[Ptr].NParam[ii] := false; //----------------- Непарафазность

    rz:=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//- ГРИ1

    ObjZav[Ptr].bParam[3]:=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); //- ГРИ

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //-- ИВ

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      for ii:=1 to 32 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii]:=ObjZav[Ptr].NParam[ii];

      if ObjZav[Ptr].bParam[31] then
      begin
        if rz <> ObjZav[Ptr].bParam[2] then //------------- если изменилось состояние ГРИ1
        begin
          if ObjZav[Ptr].ObjConstI[5] > 0 then //если есть таймер искусственного размыкания
          begin
            if ObjZav[Ptr].Timers[1].Active then //------------------- если таймер активен
            begin
              ObjZav[Ptr].Timers[1].Active := false; //------------ отключить счет времени
{$IFDEF RMSHN}
              ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]]; // индекс таймера
{$ENDIF}
              Timer[ObjZav[Ptr].ObjConstI[5]] := 0; //------------- сбросить таймер в ноль
            end else  //--------------------------------------------- если таймер пассивен
            begin
              ObjZav[Ptr].Timers[1].Active := true;  //--------------- начать счет времени
              ObjZav[Ptr].Timers[1].First := LastTime;
              Timer[ObjZav[Ptr].ObjConstI[5]] := 0;  //--------------------- начать с нуля
            end;
          end;

          if rz then
          begin
            if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
            begin
              InsArcNewMsg(Ptr,375+$2000,0); //------------------- "Начало выдержки времени"
              AddFixMessage(GetShortMsg(1,375,ObjZav[Ptr].Liter,0),0,6);
            end;
          end;
        end;

        ObjZav[Ptr].bParam[2] := rz;      //------------ фиксируем текущее состояние гри 1
        //--------------------------------------------------  обновляем видеобуфер объекта
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[6];

        if ObjZav[Ptr].Timers[1].Active then
        begin //--------------------------------------------- обновить значение времени РИ
          Timer[ObjZav[Ptr].ObjConstI[5]] :=
          Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
          if Timer[ObjZav[Ptr].ObjConstI[5]] > 300
          then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
        end;
      end else
      begin //сброс счетчиков при неисправности входного интерфейса или отсутсвии информации
        if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[1] := false;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepGRI]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------------------------------- Подготовка объекта увязки с МЭЦ для вывода на табло #23
procedure PrepMEC(Ptr : Integer);
  var mo,mp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  mp := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МП
  mo := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МО
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ЭГС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if mp <> ObjZav[Ptr].bParam[1] then
      begin
        if WorkMode.FixedMsg then
        begin
          if mp then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,385,1);
              AddFixMessage(GetShortMsg(1,385,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,385,1);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,386,1);
              AddFixMessage(GetShortMsg(1,386,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,386,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := mp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      if mo <> ObjZav[Ptr].bParam[2] then
      begin
        if WorkMode.FixedMsg then
        begin
          if mo then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,387,1);
              AddFixMessage(GetShortMsg(1,387,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,387,1);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,388,1);
              AddFixMessage(GetShortMsg(1,388,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,388,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := mo;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      if egs <> ObjZav[Ptr].bParam[3] then
      begin
        if egs then
        begin // зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := egs;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //эгс
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMEC]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------ Подготовка объекта увязки с запросом согласия для вывода на табло #24
procedure PrepZapros(Ptr : Integer);
  var zpp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Запрос ПО
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // получен запрос отправления
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // ЭГС
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ИП
  zpp := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                       // Запрос ПП
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // П
  ObjZav[Ptr].bParam[8] := not GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ЧИ
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);    // ЧКМ
  ObjZav[Ptr].bParam[10] := not GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//НИ
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  НКМ
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  МС
  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  ФС

  if ObjZav[Ptr].ObjConstI[20] > 0 then
  begin
    OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[1] := ObjZav[Ptr].bParam[32];
  end;
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[10]; //ни
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[8];  //чи
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[11]; //нкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[9];  //чкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[7];  //п
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];  //ип

      if egs <> ObjZav[Ptr].bParam[3] then
      begin
        if egs then
        begin // зафиксировать нажатие ЭГС для светофора по отправлению (приему в соседний парк)
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[3] := egs;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //эгс

      if zpp <> ObjZav[Ptr].bParam[6] then
      begin
        if zpp then
        begin // зафиксировать получение запроса поездного приема
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,292,0);
              AddFixMessage(GetShortMsg(1,292,ObjZav[ObjZav[Ptr].BaseObject].Liter,0),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,292+$2000,0);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := zpp;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6]; //зпч
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[2]; //зопч
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[1]; //зон
      // светофор увязки
      if ObjZav[Ptr].ObjConstI[20] > 0 then
      begin
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[3] := ObjZav[Ptr].bParam[12]; //мс
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[5] := ObjZav[Ptr].bParam[13]; //фс
      end;
    end;

    // FR4
    ObjZav[Ptr].bParam[14] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[15]
      else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepZapros]');
  Application.Terminate;
end;
end;
//========================================================================================
//---------------- Подготовка объекта маневровой колонки (вытяжки) для вывода на табло #25
procedure PrepManevry(Ptr : Integer);
  var rm,v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rm := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // РМ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // оТ
  ObjZav[Ptr].bParam[3] := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // МИ
  ObjZav[Ptr].bParam[4] := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // оИ/Д
  v := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                         // B
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ЭГС
  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // предв.иск.размыкание
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // РМК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if rm <> ObjZav[Ptr].bParam[1] then
      begin
        if rm then
        begin
          ObjZav[Ptr].bParam[14] := false; // сброс признака выдачи команды на сервер
          ObjZav[Ptr].bParam[8] := false; // сброс признака выдачи команды РМ
        end;
        ObjZav[Ptr].bParam[1] := rm;
      end;

      if v <> ObjZav[Ptr].bParam[5] then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = ObjZav[ptr].RU) {$ENDIF} then
        begin
          if v then
          begin // Получено восприятие маневров
            InsArcNewMsg(Ptr,389+$2000,7); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,389,ObjZav[Ptr].Liter,7),0,6); {$ENDIF}
          end else
          begin // Снято восприятие маневров
            InsArcNewMsg(Ptr,390+$2000,7); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,390,ObjZav[Ptr].Liter,7),0,6); {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[5] := v;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[5]; //В
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1]; //РМ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2]; //оТ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; //оИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[3]; //МИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[7]; //предв МИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[6]; //эгс
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[8]; //выдана команда РМ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[9]; //РМК
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepManevry]');
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------- Подготовка объекта ПАБ для вывода на табло #26
procedure PrepPAB(Ptr : Integer);
  var fp,gp,kj,o : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// По

  fp :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ФП

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предварительная команда

  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ДСо

  ObjZav[Ptr].bParam[5] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// оП

  ObjZav[Ptr].bParam[6] :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //---- Л

  kj :=
  not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// КЖ

  o :=
  GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //-- о

  gp :=
  not GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//ИП

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if kj <> ObjZav[Ptr].bParam[7] then
      begin
        if not kj then// Изъят КЖ
        begin
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then
          begin
            InsArcNewMsg(Ptr,357+$2000,0);
            AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter,0),0,6);
          end;
{$ELSE}
           InsArcNewMsg(Ptr,357+$2000,0);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[7] := kj;  // КЖ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7];

      if o <> ObjZav[Ptr].bParam[8] then
      begin
        if o then
        begin // неисправен предупредительный светофор
          if WorkMode.FixedMsg then begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000,1); AddFixMessage(GetShortMsg(1,405,'П'+ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,4);
            end;
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := o;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := o;

      if gp <> ObjZav[Ptr].bParam[9] then
      begin //
        if not gp and (config.ru = ObjZav[ptr].RU) then Ip1Beep := not ObjZav[Ptr].bParam[1] and WorkMode.Upravlenie;
      end;
      ObjZav[Ptr].bParam[9] := gp; // ИП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := gp;

      if ObjZav[Ptr].BaseObject > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := false;

      if not ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[5] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
      end else
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[4];

        if fp <> ObjZav[Ptr].bParam[2] then
        begin // включить звонок прибытия поезда
          if fp and (config.ru = ObjZav[ptr].RU)
          then SingleBeep := WorkMode.Upravlenie; // Дать сообщение о прибытии поезда на станцию (контроль прибытия)
        end;
        ObjZav[Ptr].bParam[2] := fp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := fp;

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[3];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
      end;
    end;

    inc(LiveCounter);
    // FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPAB]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------------------- Подготовка объекта охранности стрелок для вывода на табло #27
procedure PrepDZStrelki(Ptr : Integer);
var
  ohr,
  videobuf,
  kontr,
  sp_kont,
  hvost_ohr,
  rzs : integer;
begin
  try
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstI[3] > 0 then  //------------------- если есть охранная стрелка
    begin //---------------------------------------- Обработать состояние охранной стрелки
      kontr := ObjZav[Ptr].ObjConstI[1]; //---- Индекс стрелки, находящейся на трассировке
      sp_kont := ObjZav[Ptr].ObjConstI[2]; //---- Индекс СП контрольной стрелки (в трассе)
      ohr := ObjZav[Ptr].ObjConstI[3]; //----------------- Индекс объекта охранной стрелки
      videobuf := ObjZav[ohr].VBufferIndex; //---------------- Видеобуфер охранной стрелки
      hvost_ohr := ObjZav[ohr].BaseObject; //----- Индекс объекта "хвост охранной стрелки"
      rzs := ObjZav[hvost_ohr].ObjConstI[12];//---------- объект ручного замыкания стрелок

      if kontr > 0 then //---------------------------------- если есть контрольная стрелка
      begin
        if not ObjZav[rzs].bParam[1] and //----------- нет ручного замыкания стрелок и ...
        ObjZav[hvost_ohr].bParam[21] then //--- охранная стрелка не замкнута через свою СП
        begin
          if (ObjZav[Ptr].ObjConstB[1] and //-- если стрелка контролируется по плюсу и ...
          ObjZav[kontr].bParam[1]) or //- контрольная стрелка установлена по плюсу или ...

          (ObjZav[Ptr].ObjConstB[2] and //---- если стрелка контролируется по минусу и ...
          ObjZav[kontr].bParam[2]) //----------- контрольная стрелка установлена по минусу
          then
          begin

            ObjZav[ohr].bParam[4] := //дополнительное замыкание охранной стрелки через ...
            ObjZav[ohr].bParam[25] or ObjZav[ohr].bParam[33] or //---- НАС или ЧАС или ...
            (not ObjZav[sp_kont].bParam[2]); //---------- замыкание СП контрольной стрелки

            ObjZav[hvost_ohr].bParam[4] := // доп. замыкание хвоста охранной стрелки через
            not ObjZav[sp_kont].bParam[2]; //------------ замыкание СП контрольной стрелки

            OVBuffer[videobuf].Param[7] := ObjZav[hvost_ohr].bParam[4];

          end;
        end;

        if not ObjZav[hvost_ohr].bParam[21] and not ObjZav[rzs].bParam[1]
        then //------------------------------- хвост охранной стрелки замкнут от своего СП
        begin
          ObjZav[ohr].bParam[4] := false; //--- сбросить дополнительное замыкание охранной
          ObjZav[ohr].bParam[4] := ObjZav[ohr].bParam[4] or
          ObjZav[ohr].bParam[26] or ObjZav[ohr].bParam[27];

          ObjZav[hvost_ohr].bParam[4] := false; //сбросить дополнительное замыкание хвоста
          ObjZav[ohr].bParam[14] := false; //----- сбросить программное замыкание охранной
          ObjZav[hvost_ohr].bParam[14] := false; //- сбросить программное замыкание хвоста
        end;

        //--------------------------------- Трассировка маршрута через описание охранности
        if ObjZav[kontr].bParam[14] then //--- если есть программное замыкание контрольной
        begin
          ObjZav[Ptr].bParam[23] := true; //--- готовить предв. замыкание охранной стрелки
          if ObjZav[Ptr].ObjConstB[1] then //--------- контролируемая трассируется в плюсе
          begin
            if ObjZav[kontr].bParam[6] then //----------------------------- если выдано ПУ
            begin
              if  (not ObjZav[kontr].bParam[11] or//если нет первого прохода по трассе или
              ObjZav[kontr].bParam[12]) then //- контрольная стрелка -  пошерстная в плюсе
              begin
                if ObjZav[Ptr].ObjConstB[3] then //---------- Охранная должна быть в плюсе
                begin
                  if not ObjZav[ohr].bParam[1] //---------------- охранная пока не в плюсе
                  then ObjZav[Ptr].bParam[8] := true; //- активно ожидание перевода в плюс
                end else
                if ObjZav[Ptr].ObjConstB[4] then //--------- Охранная должна быть в минусе
                begin
                  if not ObjZav[ohr].bParam[2] //--------------- охранная пока не в минусе
                  then ObjZav[Ptr].bParam[8] := true; // активно ожидание перевода в минус
                end;
              end;
            end;
          end else
          if ObjZav[Ptr].ObjConstB[2] then //-------- контролируемая трассируется в минусе
          begin
            if ObjZav[kontr].bParam[7] then //----------------------------------------- МУ
            begin
              if ObjZav[Ptr].ObjConstB[3] then //------------ Охранная должна быть в плюсе
              begin
                if not ObjZav[ohr].bParam[1]
                then ObjZav[Ptr].bParam[8] := true;
              end else
              if ObjZav[Ptr].ObjConstB[4] then //----------- Охранная должна быть в минусе
              begin
                if not ObjZav[ohr].bParam[2]
                then ObjZav[Ptr].bParam[8] := true;
              end;
            end;
          end;
        end else

        ObjZav[Ptr].bParam[23] := false;//------ сброс предварительного замыкания охранной

        if not ObjZav[Ptr].bParam[8] then //-- если нет ожидания перевода охранной стрелки
        begin //--------------------------- Трассировка маршрута черех описание охранности
          if ObjZav[Ptr].ObjConstB[1] then //- контролируемая стрелка трассируется в плюсе
          begin
            if ((ObjZav[kontr].bParam[10] and
            not ObjZav[kontr].bParam[11]) or
            ObjZav[kontr].bParam[12])
            then ObjZav[Ptr].bParam[5] := true; //------------- требуется перевод охранной
          end else
          if ObjZav[Ptr].ObjConstB[2] then // контролируемая стрелка трассируется в минусе
          begin
            if ((ObjZav[kontr].bParam[10] and
            ObjZav[kontr].bParam[11]) or
            ObjZav[kontr].bParam[13])
            then  ObjZav[Ptr].bParam[5] := true;//------------- требуется перевод охранной
          end;
        end;
      end;

      //---------------------------- если в хвосте охран. нет признака требования перевода
      if not ObjZav[hvost_ohr].bParam[5] then
      ObjZav[hvost_ohr].bParam[5] := ObjZav[Ptr].bParam[5]; // копировать требование из ДЗ

      //------------------------------ если в хвосте охран. нет признака ожидания перевода
      if not ObjZav[hvost_ohr].bParam[8] then
      ObjZav[hvost_ohr].bParam[8] := ObjZav[Ptr].bParam[8]; //-- копировать ожидание из ДЗ

      if not ObjZav[hvost_ohr].bParam[23] then //если нет признака трассивоки как охранной
      ObjZav[hvost_ohr].bParam[23] := ObjZav[Ptr].bParam[23]; // признак трассировки из ДЗ
    end;
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [MainLoop.PrepDZStrelki]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------- Подготовка объекта дачи поездного приема для вывода на табло #30
procedure PrepDSPP(Ptr : Integer);
var
  egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  egs := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ЭГС
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // И

  // ЭГС
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if egs <> ObjZav[Ptr].bParam[1] then
      begin
        if egs then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000,1); AddFixMessage(GetShortMsg(1,105,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,6);
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := egs;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepDSPP]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------- Подготовка объекта повторительного светофора для вывода на табло #31
procedure PrepPSvetofor(Ptr : Integer);
var
  o,sign : boolean;
  VidBuf,IndPovt,Sig,Cod : Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность
    VidBuf := ObjZav[Ptr].VBufferIndex;
    IndPovt := ObjZav[Ptr].ObjConstI[2];
    Sig := ObjZav[Ptr].BaseObject;
    //-------------------------------------------------------------- состояние повторителя
    o :=  GetFR3(IndPovt,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);
    sign := ObjZav[Sig].bParam[4];

    Cod := 0;
    if sign then Cod := Cod + 2;
    if o then Cod := Cod + 1;

    if VidBuf > 0 then //--------------------------------- если есть отображение на экране
    begin
      OVBuffer[VidBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VidBuf].Param[1] := ObjZav[Ptr].bParam[32];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if Cod <> ObjZav[Ptr].iParam[1] then
        if not ObjZav[Ptr].Timers[1].Active then
        begin
          ObjZav[Ptr].Timers[1].Active := true;
          ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
        end;

        if ObjZav[Ptr].Timers[1].Active then
        begin //------------------------------------------------------ было изменение кода
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin //---------------------------------------------------- ожидали 3-4 секунды
            //------ сначала считаем, что сигнал закрыт, ПНо = 0 (нормально для закрытого)
            ObjZav[Ptr].bParam[1] := false; //---------------- снять признак неисправности
            ObjZav[Ptr].bParam[2] := false; //-------- снять признак включения повторителя
            ObjZav[Ptr].bParam[3] := false; //------------- снять признак нарушения логики

            case Cod of
              1:
              begin
                ObjZav[Ptr].bParam[2] := true;
                ObjZav[Ptr].bParam[3] := true; //---- сигнал закрыт, ПНо = 1(несуразность)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZav[ptr].RU then
                  begin
                    InsArcNewMsg(Ptr,579+$1000,0); //--- Неисправность датчика повторителя
                    AddFixMessage(GetShortMsg(1,579,ObjZav[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsArcNewMsg(Ptr,579+$1000,1); SingleBeep4 := true;
{$ENDIF}
                end;
              end;

              2:
              begin
                ObjZav[Ptr].bParam[1] := true; //--- сигнал открыт, ПНо = 0(неисправность)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZav[ptr].RU then
                  begin
                    InsArcNewMsg(Ptr,339+$1000,0);//---- Неисправность датчика повторителя
                    AddFixMessage(GetShortMsg(1,339,ObjZav[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsArcNewMsg(Ptr,339+$1000,1); SingleBeep4 := true;
{$ENDIF}
                end;
              end;

              3:  ObjZav[Ptr].bParam[2] := true; //сигнал открыт, ПНо = 1(норма открытого)
            end;
            ObjZav[Ptr].iParam[1]:= Cod;
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].Timers[1].First := 0;
          end;
        end;
        OVBuffer[VidBuf].Param[3] := ObjZav[Ptr].bParam[1];
        OVBuffer[VidBuf].Param[4] := ObjZav[Ptr].bParam[3];
      end;
      OVBuffer[VidBuf].Param[2] := ObjZav[Ptr].bParam[2];
    end;
  except
    reportf('Ошибка [MainLoop.PrepPSvetofor]');
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------------- Подготовка объекта надвига на горку для вывода на табло #32
procedure PrepNadvig(Ptr : Integer);
  var egs,sn,sm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность
  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //-- зо

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- Жо

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- Бо

  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- УН

  ObjZav[Ptr].bParam[5] :=
  GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- Соо

  ObjZav[Ptr].bParam[6] :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- оо

  egs :=
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ЭГС

  sn :=
  GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- СН

  sm :=
  GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- СМ

  ObjZav[Ptr].bParam[10] :=
  GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---- В

  ObjZav[Ptr].bParam[11] :=
  GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---- П

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];

      if egs <> ObjZav[Ptr].bParam[7] then
      begin
        if egs then
        begin //------------------------------------------------ зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
{$ENDIF}
          end;
        end;
      end;

      ObjZav[Ptr].bParam[7] := egs;
      if sn <> ObjZav[Ptr].bParam[8] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sn then
          begin //---------------------------------------------- получено согласие надвига
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,381+$2000,1);
              AddFixMessage(GetShortMsg(1,381,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,381+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end else
          begin //------------------------------------------------- снято согласие надвига
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,382+$2000,1);
              AddFixMessage(GetShortMsg(1,382,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,382+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := sn;

      if sm <> ObjZav[Ptr].bParam[9] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sm then
          begin //--------------------------------------------- получено согласие маневров
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,383+$2000,1);
              AddFixMessage(GetShortMsg(1,383,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,383+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end else
          begin //------------------------------------------------ снято согласие маневров
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,384+$2000,1);
              AddFixMessage(GetShortMsg(1,384,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,384+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[9] := sm;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7]  := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8]  := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9]  := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[11];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[10];

      {FR4}
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepNadvig]');
  Application.Terminate;
end;
end;
//========================================================================================
//---------------------------------- Подготовка одиночного датчика для вывода на табло #33
procedure PrepSingle(Ptr : Integer);
var
  b : boolean;
  i : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    for i := 0 to 34 do ObjZav[Ptr].NParam[i] := false;

    if ObjZav[Ptr].ObjConstB[1] then //--------------------------- если инверсия состояния
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31])
    else //--------------------------------------------------------- если прямое состояние
    b := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    if not ObjZav[Ptr].bParam[31] then //---------------------------------- нет активности
    begin
      if ObjZav[Ptr].VBufferIndex > 0 then //---------------------------- есть видеообъект
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      end;
    end else
    begin
      if ObjZav[Ptr].VBufferIndex > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      end;
      if ObjZav[Ptr].bParam[1] <> b then
      begin
        if ObjZav[Ptr].ObjConstB[2] then
        begin //------ регистрация изменения состояния датчика - вывод сообщения оператору
          if b then
          begin
            if ObjZav[Ptr].ObjConstI[2] > 0 then //------- если есть сообщение о включении
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                if ObjZav[Ptr].ObjConstI[4] = 1   //------------- если цвет текста красный
                then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[2],0)
                else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);

                if ObjZav[Ptr].ObjConstI[4] = 1 then
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[2]],4,3)
                else
                begin //--------------------------------------------- сообщение диалоговое
                  PutShortMsg(ObjZav[Ptr].ObjConstI[4],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[2]]);
                  SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[4] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000 + ObjZav[Ptr].ObjConstI[2],0);
                SingleBeep3 := true;
              end
              else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);

{$ENDIF}
            end;
          end else
          begin
            if ObjZav[Ptr].ObjConstI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                if ObjZav[Ptr].ObjConstI[5] = 1
                then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3],0)
                else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],0);
                if ObjZav[Ptr].ObjConstI[5] = 1 then // сообщение фиксируемое
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[3]],4,3)
                else
                begin //--------------------------------------------- сообщение диалоговое
                  PutShortMsg(ObjZav[Ptr].ObjConstI[5],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[3]]);
//                  SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[5] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3],0);
                SingleBeep3 := true;
              end
              else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],0);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[1] := b;
      end;
      if ObjZav[Ptr].VBufferIndex > 0 then
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[1] := ObjZav[Ptr].NParam[1];
    end;
  except
    reportf('Ошибка [MainLoop.PrepSingle]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------- Подготовка объекта контроля электропитания для вывода на табло #34
procedure PrepPitanie(Ptr : Integer);
var
  k1f,k2f,k3f,vf1,vf2,kpp,kpa,szk,ak,k1shvp,k2shvp,knb,knz,dsn,saut,vmg : Boolean;
  fk1,fk2,fu1,fu2,vf,pf1,la,at,kmgt : Boolean;
  i : Integer;
begin
  try

    for i := 1 to 34 do ObjZav[Ptr].NParam[i] := false;

    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    k1f:=
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);//-- к1ф

    k2f :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//-- к2ф

    k3f :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);//-- кзф

    vf1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//-- 1вф

    vf2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);//-- 2ВФ

    kpp :=
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].NParam[6],ObjZav[Ptr].bParam[31]); //- КПП

    kpa :=
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].NParam[7],ObjZav[Ptr].bParam[31]);//-- КПА

    szk :=
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //- СзК

    ak :=
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]); //-- АК

    k1shvp :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]);//К1ЩВ

    k2shvp :=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);//К2ЩВ

    knz :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]);// КНз

    knb :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);// КНБ

    dsn :=
    GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]);// ДСН

    saut :=
    GetFR3(ObjZav[Ptr].ObjConstI[15],ObjZav[Ptr].NParam[15],ObjZav[Ptr].bParam[31]);//САУТ

    vmg :=
    GetFR3(ObjZav[Ptr].ObjConstI[18],ObjZav[Ptr].NParam[18],ObjZav[Ptr].bParam[31]); //ВМГ

    fk1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[19],ObjZav[Ptr].NParam[19],ObjZav[Ptr].bParam[31]); //1фк

    fk2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[20],ObjZav[Ptr].NParam[20],ObjZav[Ptr].bParam[31]); //2фк

    fu1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[21],ObjZav[Ptr].NParam[21],ObjZav[Ptr].bParam[31]); //1фу

    fu2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[22],ObjZav[Ptr].NParam[22],ObjZav[Ptr].bParam[31]); //2фу

    vf :=
    GetFR3(ObjZav[Ptr].ObjConstI[23],ObjZav[Ptr].NParam[23],ObjZav[Ptr].bParam[31]); // вф

    pf1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[24],ObjZav[Ptr].NParam[24],ObjZav[Ptr].bParam[31]); //пф1

    la :=
    GetFR3(ObjZav[Ptr].ObjConstI[25],ObjZav[Ptr].NParam[25],ObjZav[Ptr].bParam[31]); // ла

    at :=
    GetFR3(ObjZav[Ptr].ObjConstI[26],ObjZav[Ptr].NParam[26],ObjZav[Ptr].bParam[31]); // АТ

    kmgt :=
    GetFR3(ObjZav[Ptr].ObjConstI[27],ObjZav[Ptr].NParam[27],ObjZav[Ptr].bParam[31]); //МГТ

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 1 to 32 do //------------------------ переписать все непарафазности побитно
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        if dsn <> ObjZav[Ptr].bParam[14] then //-------------------------------------- ДСН
        begin
          if WorkMode.FixedMsg then
          begin
            if dsn then
            begin
              InsArcNewMsg(Ptr,358+$2000,0); //------------- включен режим светомаскировки
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,358,'',7),4,4);
              {$ELSE}  SingleBeep4 := true; {$ENDIF}
            end  else
            begin
              InsArcNewMsg(Ptr,359+$2000,0); //------------ отключен режим светомаскировки
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,359,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[14] := dsn;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := dsn;

        if saut <> ObjZav[Ptr].bParam[15] then//------------------------------------- САУТ
        begin
         if saut then
         begin
           InsArcNewMsg(Ptr,524+$1000,1); //------------------------- "Неисправность САУТ"
           {$IFDEF RMDSP}  AddFixMessage(GetShortMsg(1,524,'',0),4,3);
           {$ELSE} SingleBeep2 := true; {$ENDIF}
         end;
         ObjZav[Ptr].bParam[15] := saut;
         OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := saut;
        end;

        if ObjZav[Ptr].ObjConstB[1] then//----------------------------------------- ФИДЕРА
        begin //----------------------- Для малой станции (один контроль активных фидеров)
          if k1f <> ObjZav[Ptr].bParam[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000,0); //-------------- "Восстановление 1-го фидера"
              {$IFDEF RMDSP}  AddFixMessage(GetShortMsg(1,303,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,302+$1000,0); //------------------ "Выключение 1-го фидера"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := k1f;

          if k2f <> ObjZav[Ptr].bParam[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000,0); //-------------- "Восстановление 2-го фидера"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,304+$1000,0);//------------------- "Выключение 2-го фидера"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k2f;

          if k3f <> ObjZav[Ptr].bParam[3] then
          begin
            if WorkMode.FixedMsg then
            if not k3f then
            begin
              InsArcNewMsg(Ptr,308+$2000,0); //-------------- "Переключено питание на ДГА"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k3f;

          if vf1 <> ObjZav[Ptr].bParam[4] then  //------ изменилась активность 1-го фидера
          begin
            if WorkMode.FixedMsg then
            if not vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000,7); //------- "Переключено питание на 1-ый фидер"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,307+$2000,0); //------- "Переключено питание на 2-ой фидер"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,307,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vf1;

          ObjZav[Ptr].bParam[1] := k1f;
          ObjZav[Ptr].bParam[2] := k2f;
          ObjZav[Ptr].bParam[3] := k3f;
          ObjZav[Ptr].bParam[4] := vf1;
          ObjZav[Ptr].bParam[5] := vf2;
        end
        else
        begin //---------------------- Для крупной станции (два контроля активных фидеров)
          if k1f <> ObjZav[Ptr].bParam[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000,0); //----------------- "восстановление фидера 1"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,303,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,302+$1000,0);  //-------------------- "выключение фидера 1"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := k1f;

          if k2f <> ObjZav[Ptr].bParam[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000,0); //----------------- "восстановление фидера 2"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,304+$1000,0); //--------------------- "выключение фидера 2"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k2f;

          if k3f <> ObjZav[Ptr].bParam[3] then
          begin
            if WorkMode.FixedMsg then
            if k3f then //------------------------------------- переключено питание на ДГА
            begin
              InsArcNewMsg(Ptr,308+$2000,0);
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k3f;

          if vf1 <> ObjZav[Ptr].bParam[4] then
          begin
            if WorkMode. FixedMsg then
            if not vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000,0);  //----------- Переключено питание на 1 фидер
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vf1;

          if vf2 <> ObjZav[Ptr].bParam[5] then
          begin
            if WorkMode.FixedMsg then
            if not vf2 then
            begin
              InsArcNewMsg(Ptr,307+$2000,0);
              {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,307,'',0),5,2);
              {$ELSE}
              SingleBeep2 := true;
              {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vf2;
          ObjZav[Ptr].bParam[1] := k1f;
          ObjZav[Ptr].bParam[2] := k2f;
          ObjZav[Ptr].bParam[3] := k3f;
          ObjZav[Ptr].bParam[4] := vf1;
          ObjZav[Ptr].bParam[5] := vf2;
        end;
//------------------------------------------------------------------------------------ КПП
        if kpp <> ObjZav[Ptr].bParam[6] then
        begin
          if WorkMode.FixedMsg and kpp then
          begin
            InsArcNewMsg(Ptr,284+$1000,0); //---------------- "Перегорание предохранителя"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,284,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        //---------------------------------------------------------------------------- КПА
        if kpa <> ObjZav[Ptr].bParam[7] then
        begin
          if WorkMode.FixedMsg and kpa then
          begin
            InsArcNewMsg(Ptr,285+$1000,0); // Неисправность питания схем контроля предохр.
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,285,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := kpp;
        ObjZav[Ptr].bParam[7] := kpa;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := kpp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := kpa;
        //---------------------------------------------------------------------------- СЗК
        if szk <> ObjZav[Ptr].bParam[8] then
        begin
          if WorkMode.FixedMsg then
          begin
            if szk then
            begin
              InsArcNewMsg(Ptr,286+$1000,0); //--------- "Понижение изоляции схем питания"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,286,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,404+$2000,0); //Выключ. сигнализатора изоляции схем питания
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,404,'',0),0,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[8] := szk;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := szk;

        //----------------------------------------------------------------------------- АК
        if ak <> ObjZav[Ptr].bParam[9] then
        begin
          if WorkMode.FixedMsg and ak then
          begin
            InsArcNewMsg(Ptr,287+$1000,0); // Неисправ.питания схем кодир. рельсовых цепей
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,287,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[9] := ak;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ak;

        //-------------------------------------------------------------------------- К1ЩВП
        if k1shvp <> ObjZav[Ptr].bParam[10] then
        begin
          if WorkMode.FixedMsg and k1shvp then
          begin
            InsArcNewMsg(Ptr,288+$2000,0); //--------------------------- "Отключение ЩВП1"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,288,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[10] := k1shvp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := k1shvp;
        //-------------------------------------------------------------------------- К2ЩВП
        if k2shvp <> ObjZav[Ptr].bParam[11] then
        begin
          if WorkMode.FixedMsg and k2shvp then
          begin
            InsArcNewMsg(Ptr,289+$2000,0); //--------------------------- "Отключение ЩВП2"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,289,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[11] := k2shvp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := k2shvp;

        //---------------------------------------------------------------------------- КНЗ
        if knz <> ObjZav[Ptr].bParam[12] then
        begin
          if WorkMode.FixedMsg and knz then
          begin
            InsArcNewMsg(Ptr,290+$1000,0); //------------- "Форсированный заряд батареи 1"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,290,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[12] := knz;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := knz;

        //---------------------------------------------------------------------------- КНБ
        if knb <> ObjZav[Ptr].bParam[13] then
        begin
          if WorkMode.FixedMsg and knb then
          begin
            InsArcNewMsg(Ptr,291+$1000,0); //-------------- "Нет нормы напряжения батареи"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,291,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[13] := knb;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := knb;

        //---------------------------------------------------------------------------- ВМГ
        if vmg <> ObjZav[Ptr].bParam[18] then
        begin
          if WorkMode.FixedMsg and vmg then
          begin
            InsArcNewMsg(Ptr,515+$1000,0); //--------------- "Неисправен комплект мигания"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,515,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[18] := vmg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := vmg;

        //--------------------------------------- 1ФК контроль чередования фаз 1-го фидера

        if fk1 <> ObjZav[Ptr].bParam[19] then
        begin
          if WorkMode.FixedMsg and fk1 then
          begin
            InsArcNewMsg(Ptr,537+$1000,0); //---------- "Нет нормы чередования фаз фидера"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,537,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[19] := fk1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := fk1;

        //--------------------------------------- 2ФК контроль чередования фаз 2-го фидера
        if fk2 <> ObjZav[Ptr].bParam[20] then
        begin
          if WorkMode.FixedMsg and fk2 then
          begin
            InsArcNewMsg(Ptr,537+$1000,0); //---------- "Нет нормы чередования фаз фидера"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,537,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := fk2;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := fk2;

        //-------------------------------------------- 1ФУ контроль напряжения 1-го фидера
        if fu1 <> ObjZav[Ptr].bParam[21] then
        begin
          if WorkMode.FixedMsg and fu1 then
          begin
            InsArcNewMsg(Ptr,538+$1000,0); //--------------- "Нет нормы напряжения фидера"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,538,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[21] := fu1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[21] := fu1;

        //-------------------------------------------- 2ФУ контроль напряжения 2-го фидера
        if fu2 <> ObjZav[Ptr].bParam[22] then
        begin
          if WorkMode.FixedMsg and fu2 then
          begin
            InsArcNewMsg(Ptr,538+$1000,0); //--------------- "Нет нормы напряжения фидера"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,538,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[22] := fu2;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[22] := fu2;

        //----------------------------------------------- контроль отключения 2-ух фидеров
        if vf <> ObjZav[Ptr].bParam[23] then
        begin
          if WorkMode.FixedMsg and vf then
          begin
            InsArcNewMsg(Ptr,539+$1000,0); //---- "Зафиксировано отключение обоих фидеров"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,539,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[23] := vf;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[23] := vf;

        //------------------------------------------------ контроль фильтрации кодирования
        if pf1 <> ObjZav[Ptr].bParam[24] then
        begin
          if WorkMode.FixedMsg and pf1 then
          begin
            InsArcNewMsg(Ptr,540+$1000,0); //---------- "Нет нормы фильтрации кодирования"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,540,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[24] := pf1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[24] := pf1;

        //----------------------------------------------- контроль питания рельсовых цепей
        if la <> ObjZav[Ptr].bParam[25] then
        begin
          if WorkMode.FixedMsg and la then
          begin
            InsArcNewMsg(Ptr,484+$1000,0); //------- Неисправность питания рельсовых цепей
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,484,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[25] := la;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[25] := la;

        //--------------------------------------------------------- контроль питания табло
        if at <> ObjZav[Ptr].bParam[26] then
        begin
          if WorkMode.FixedMsg and at then
          begin
            InsArcNewMsg(Ptr,484+$1000,0); //----------------- Неисправность питания табло
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,545,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[26] := at;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[26] := at;

        if kmgt <> ObjZav[Ptr].bParam[27] then
        begin
          if WorkMode.FixedMsg and kmgt then
          begin
            InsArcNewMsg(Ptr,574+$1000,0); //----------------- Неисправность мигания табло
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,574,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[27] := kmgt;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[27] := kmgt;
      end;

      for i := 1 to 34 do //------------------------ переписать все непарафазности побитно
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[i];
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end;
  except
    reportf('Ошибка [MainLoop.PrepPitanie]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------------------------------- Доступ к внутренним параметрам объекта зависимостей #35
procedure PrepInside(Ptr : Integer);
var
  MainObj,MainCod,cvet_lamp : Integer;
  TXT : string;
begin
  try
    inc(LiveCounter);
    if ObjZav[Ptr].BaseObject > 0 then
    begin
      MainObj := ObjZav[Ptr].BaseObject; //-------------------------------- базовый объект
      case ObjZav[Ptr].ObjConstI[1] of
        1 :
        begin //------------------------------------------------------------------------ Н
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[8] or //------- Н из FR3 или ...
          (ObjZav[MainObj].bParam[9] and ObjZav[MainObj].bParam[14]); //---- ППР и ПрогЗам
        end;

        2 :
        begin //----------------------------------------------------------------------- НМ
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[6] or //------ НМ из FR3 или ...
          (ObjZav[MainObj].bParam[7] and ObjZav[MainObj].bParam[14]);//----- МПР и ПрогЗам
        end;

        3 :
        begin //--------------------------------------------------------------------- Н&НМ
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[6] or //------ НМ из FR3 или ...
          ObjZav[MainObj].bParam[8] or //-------------------------------- Н из FR3 или ...
          ((ObjZav[MainObj].bParam[7] or ObjZav[MainObj].bParam[9]) //---- МПР или ППР ...
          and ObjZav[MainObj].bParam[14]); //----------------------------------- и ПрогЗам
        end;

        4 : //----------------------------------- доступ к 2-битному объекту контроля кода
        begin
          MainCod := 0;
          if ObjZav[MainObj].bParam[1] then MainCod := MainCod + 1;
          if ObjZav[MainObj].bParam[2] then MainCod := MainCod + 2;
          if MainCod <> ObjZav[MainObj].iParam[1] then //------------- есть изменение кода
          begin
            if ((ObjZav[Ptr].ObjConstI[MainCod+1]) <> 0) and (MainCod <> 0) then
            begin
              if MainCod = 1 then cvet_lamp := ObjZav[Ptr].ObjConstI[10];
              if MainCod = 2 then cvet_lamp := ObjZav[Ptr].ObjConstI[11];
              if MainCod = 3 then cvet_lamp := ObjZav[Ptr].ObjConstI[12];
              if cvet_lamp = 28  then cvet_lamp := 1;
              if cvet_lamp = 27  then cvet_lamp := 1;
              if cvet_lamp = 29  then cvet_lamp := 2;
              if cvet_lamp = 26  then cvet_lamp := 9;
              if cvet_lamp = 7 then cvet_lamp := 1;
              
              TXT := MsgList[ObjZav[Ptr].ObjConstI[MainCod+1]];
              PutShortMsg(cvet_lamp,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
              AddFixMessage(TXT,cvet_lamp,0);
            end;
          end;
          ObjZav[MainObj].iParam[1] := MainCod;
        end;

        5://------------------------------------- доступ к 3-битному объекту контроля кода
        begin
          MainCod := 0;
          if ObjZav[MainObj].bParam[1] then MainCod := MainCod + 1;
          if ObjZav[MainObj].bParam[2] then MainCod := MainCod + 2;
          if ObjZav[MainObj].bParam[3] then MainCod := MainCod + 4;
          if MainCod <> ObjZav[MainObj].iParam[1] then //------------- есть изменение кода
          begin
            if ObjZav[Ptr].ObjConstI[MainCod+1] <> 0 then
            begin
              TXT := MsgList[ObjZav[Ptr].ObjConstI[MainCod+1]];
              PutShortMsg(0,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
              AddFixMessage(TXT,0,0);
            end;
          end;
          ObjZav[MainObj].iParam[1] := MainCod;
        end;

        else ObjZav[Ptr].bParam[1] := false;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepInside]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------ Подготовка кнопки(вкл/откл) для вывода на табло #36
procedure PrepSwitch(Ptr : Integer);
var
  b : array[1..5] of boolean;
  ii,ColorVkl,ColorOtkl : integer;
  TXT : string;
  nep : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    for ii := 1 to 32 do  ObjZav[Ptr].NParam[32] := false; //-------------- Непарафазность
    //---------------------------------------------------- Обрабатываем 5 датчиков объекта
    for ii := 1 to 5 do
    begin
      nep := false;
      b[ii] := //-------------------------------------------------------- прямое состояние
      GetFR3(ObjZav[Ptr].ObjConstI[10+ii],nep,ObjZav[Ptr].bParam[31]);
      ObjZav[Ptr].NParam[ii] := nep;
      if ObjZav[Ptr].ObjConstB[ii] then //---------- если нужна инверсия состояния датчика
      b[ii] := not b[ii];
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := false;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      //---------------------------------------------------------- обработка 5-ти датчиков
      for ii := 1 to 5 do
      if ObjZav[Ptr].bParam[ii] <> b[ii] then //------------ если датчик изменил состояние
      begin
        if ObjZav[Ptr].ObjConstB[ii+5] then  //-------------------- если нужна регистрация
        begin //------ регистрация изменения состояния датчика - вывод сообщения оператору
          if b[ii] then //--------------------------------------- если произошло включение
          begin
            if ((ii = 1) and (ObjZav[Ptr].ObjConstI[2] > 0)) or
            ((ii > 1) and (ObjZav[Ptr].ObjConstI[16+(ii-2)*2] > 0)) then//есть сооб. o вкл
              if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);
                SingleBeep2 := WorkMode.Upravlenie;
                if ObjZav[Ptr].ObjConstI[23+ii] = 1 then
                begin
                  ColorVkl := 7; //------------------------------------------------ желтый
                  ColorOtkl := 7; //----------------------------------------------- желтый
                end else
                if ObjZav[Ptr].ObjConstI[23+ii] = 2 then
                begin
                  ColorVkl := 1; //----------------------------------------------- красный
                  ColorOtkl := 2; //---------------------------------------------- зеленый
                end else
                if ObjZav[Ptr].ObjConstI[23+ii] = 3 then
                begin
                  ColorVkl := 2; //----------------------------------------------- зеленый
                  ColorOtkl := 7; //----------------------------------------------- желтый
                end else
                begin
                  ColorVkl := 15; //------------------------------------------------ серый
                  ColorOtkl := 15; //----------------------------------------------- серый
                end;

                if ii = 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[2]];
                if ii > 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[16+(ii-2)*2]];
                PutShortMsg(ColorVkl,LastX,LastY,TXT);
                SingleBeep2 := WorkMode.Upravlenie;
                AddFixMessage(TXT,0,1);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);
{$ENDIF}
            end;
          end else
          begin
            if ObjZav[Ptr].ObjConstI[3] > 0 then //----- если есть сообщение об отключении
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ii = 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[3]];
              if ii > 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[17+(ii-2)*2]];

              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],ColorOtkl);
                AddFixMessage(TXT,0,1);
                SingleBeep2 := WorkMode.Upravlenie;
                PutShortMsg(7,LastX,LastY,TXT);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],ColorOtkl);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[ii] := b[ii];
      end;

      if ObjZav[Ptr].VBufferIndex > 0 then
      for ii := 1 to 5 do
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepSwitch]');
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------------- Подготовка объекта маршрута надвига для вывода на табло #38
procedure PrepMarhNadvig(Ptr : Integer);
  var v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  v := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if v <> ObjZav[Ptr].bParam[1] then
  begin
    if v then
    begin // зафиксировано восприятие маршрута надвига
      SetNadvigParam(ObjZav[Ptr].ObjConstI[10]); // установить признак ГВ на маршрут надвига
    end;
  end;
  ObjZav[Ptr].bParam[1] := v;  //

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMarhNadvig]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------------------------- Подготовка к выводу на табло контроллера ТУМС/МСТУ #37
procedure PrepIKTUMS(Ptr : Integer);
var
  r,ao,ar,a,b,p,kp1,kp2,otu,rotu : Boolean;
  i,ii : integer;
  myt,svaz1 : byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация

    for i:= 1 to 32 do ObjZav[Ptr].NParam[i] :=false;

    r := //----------------------------------------------------------------------------- Р
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    ao :=//---------------------------------------------------------------------------- Ао
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);

    ar :=//---------------------------------------------------------------------------- Ар
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[4] :=//---------------------------------------------мультивtибратор
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);

    kp1 :=  //------------------------------------------------------------------------ КП1
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);

    kp2 := //------------------------------------------------------------------------- КП2
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].NParam[6],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[7] := //--------------------------------------------------------- К
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].NParam[7],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[11] := //------------------------------------------------------- РУ
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[12] :=//-------------------------------------------------------- оУ
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]);

    otu :=  //------------------------------------------------------------------------ оТУ
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);

    rotu := //----------------------------------------------------------------------- РоТУ
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]);

    //---------------- получить состояние стойки в маршрутной команде --------------------
    i := ObjZav[Ptr].ObjConstI[8] div 8;  //------ вычислить индекс приема данных по MYTHX
    if i > 0 then
    begin
      myt := FR3[i] and $38;   //------------------------- проверочные биты занятости ТУМС
      if myt > 0 then
      begin
        if myt = $38 then
        begin //-------------------------- выполняется установка маршрута-----------------
          ObjZav[Ptr].bParam[8] := true;  //---------------- фиксировать признак занятости
          ObjZav[Ptr].bParam[9] := false; //----------- сброс фиксации удачного завершения
          ObjZav[Ptr].bParam[10] := false; //-------- сброс фиксации неудачного завершения
        end else //--------------------------- если нет текущей установки маршрута в ТУМСе
        begin
          ObjZav[Ptr].bParam[8] := false; //---------------- сброс фиксации занятости ТУМС
          if myt = $28 then //----------------------- проверочные биты удачного завершения
          begin //----------------------------- если успешное завершение устаноки маршрута
            ObjZav[Ptr].bParam[9] := true; //-------------- фиксировать удачное завершение
            ObjZav[Ptr].bParam[10] := false; //------------- сбросить неудачное завершение
          end else
          begin //--------------------------- если неудачное завершение установки маршрута
            ObjZav[Ptr].bParam[9] := false; //---------------- сбросить удачное завершение
            if not ObjZav[Ptr].bParam[10] then //--------------- если неудачное завершение
            begin
              InsArcNewMsg(Ptr,4+$3000,0); //-------------------- "Маршрут не установлен "
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,4,'',0),4,4);
              {$ENDIF}
            end;
            ObjZav[Ptr].bParam[10] := true; //----------- фиксировать неудачное завершение
          end;
        end;
      end;
    end;

    a := false; b := false; p := false; //------------ сбросить вспомогательные переменные

    if ObjZav[Ptr].VBufferIndex > 0 then //-------------------------- если есть видеобуфер
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];//-активность
      for ii := 1 to 32 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

      if ObjZav[Ptr].bParam[31] then
      begin
        //------------------------------------------------ если произошло изменение по КП1
        if kp1 <> ObjZav[Ptr].bParam[5] and not ObjZav[Ptr].NParam[5] then
        begin
          if WorkMode.FixedMsg then //----------------------------- если включена фиксация
          begin
            if kp1 then //------------------------ если неисправно основное питание стойки
            begin
              InsArcNewMsg(Ptr,493+$3000,0); //- "неисправность основного источника питания"
              {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,493,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[5] := kp1; //----------------------- запомнить значение для КП1

        //------------------------------------------------ если произошло изменение по КП2
        if kp2 <> ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].NParam[6] then
        begin
          if WorkMode.FixedMsg then
          begin
            if kp2 then//------------------------ если неисправно резервное питание стойки
            begin
              InsArcNewMsg(Ptr,494+$3000,0); //неисправность резервного источника питания
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,494,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[6] := kp2; //---------------------------------------- Запомнить

        //---------------------------------------- если изменение основного комплекта МПСУ
        if ao <> ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].NParam[2] then
        begin
          if WorkMode.FixedMsg then
          begin
            a := true;
            if ao then //--------------------------------- если остановка 1 комплекта МПСУ
            begin
              InsArcNewMsg(Ptr,366+$3000,0); //"Остановка МПСУ-1"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,366,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //---------------------------------------------- если включен 1 комплект
              InsArcNewMsg(Ptr,367+$3000,0); //------------------------ "Включение МПСУ-1"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,367,ObjZav[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[2] := ao;//------------------------------------------ Запомнить

        //--------------------------------------- если изменение резервного комплекта МПСУ
        if ar <> ObjZav[Ptr].bParam[3] and not ObjZav[Ptr].NParam[3] then
        begin
          if WorkMode.FixedMsg then
          begin
            b := true;
            if ar then
            begin//-------------------------------------------- остановка 2 комплекта МПСУ
              InsArcNewMsg(Ptr,368+$3000,0); //"остановка МПСУ-2"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,368,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //------------------------------------------------ если включен комплект
              InsArcNewMsg(Ptr,369+$3000,0); //------------------------ "Включение МПСУ-2"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,369,ObjZav[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[3] := ar;//------------------------------------------ Запомнить

        if ObjZav[Ptr].ObjConstB[1]  then //------------------------- если контроллер МСТУ
        begin
          //------------------------------------------------ если изменилось состояние ОТУ
          if otu <> ObjZav[Ptr].bParam[13] and not ObjZav[Ptr].NParam[13] then
          begin
            if WorkMode.FixedMsg then
            begin
              if otu then //---------------------- если остановлен интерфейс ОТУ комплекта
              begin
                InsArcNewMsg(Ptr,500+$3000,0); //отключен интерфейс ОК основного комплекта
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,500,ObjZav[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //------------------------------------ включен интерфейс ОТУ комплекта
                InsArcNewMsg(Ptr,501+$3000,0); //-включен интерфейс ОК основного комплекта
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,501,ObjZav[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZav[Ptr].bParam[13] := otu;  //------------------------------------ запомнить

          //------------------------------------------ изменение состояния интерфейса РОТУ
          if rotu <> ObjZav[Ptr].bParam[14] and not ObjZav[Ptr].NParam[14] then
          begin
            if WorkMode.FixedMsg then
            begin
              if rotu then //------------------------- остановлен интерфейс РОТУ комплекта
              begin
                InsArcNewMsg(Ptr,502+$3000,0);//отключен интерфейс ОК резервного комплекта
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,502,ObjZav[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //----------------------------------- включен интерфейс РОТУ комплекта
                InsArcNewMsg(Ptr,503+$3000,0); //включен интерфейс ОК резервного комплекта
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,503,ObjZav[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZav[Ptr].bParam[14] := rotu;  //----------------------------------- запомнить
        end;


        if r <> ObjZav[Ptr].bParam[1] then  //---------- если переключение комплектов МПСУ
        begin
          if WorkMode.FixedMsg then p := true;
          ObjZav[Ptr].bParam[1] := r; //---------------------------------------- запомнить
        end;

        if p or a or b then  // если переключение или  изменение МПСУ1 или изменение МПСУ2
        begin //------------------------------- зафиксировать переключение комплектов МПСУ
          if r and not ar then //------------------------------ включен резервный комплект
          begin
            InsArcNewMsg(Ptr,365+$3000,0); //---------------------------- "в работе МПСУ2"
            {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,365,ObjZav[Ptr].Liter,0),5,2);
            {$ENDIF}
          end else
          if not r and not ao then //--------------------------- включен основной комплект
          begin
            InsArcNewMsg(Ptr,364+$3000,0); //---------------------------- "в работе МПСУ1"
            {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,364,ObjZav[Ptr].Liter,0),5,2);
            {$ENDIF}
          end;
          ObjZav[Ptr].bParam[1] := r; //---------------------------------------- запомнить
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //-------------------------------------------------------- Работа с каналами связи
        if (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][2]) and
        (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][3]) then
        svaz1 := config.SVAZ_TUMS[1][1] //------------- состояние параметра контроля связи
        else exit;

        if svaz1 <> ObjZav[Ptr].iParam[1] then //------------- изменилось состояние канала
        begin
          if (svaz1 and $40) = $40 then WorkMode.OKError := true
          else WorkMode.OKError := false;

          if ObjZav[Ptr].ObjConstI[13] = 1 then//------------------------------ для ТУМС 1
          begin
            if (svaz1 and $1) = $1 then //----------------------------------- потеря связи
            begin
              ObjZav[Ptr].bParam[18] := true;
              if not ObjZav[Ptr].bParam[33] then //--------- не было фиксации потери связи
              begin
                AddFixMessage(GetShortMsg(1,433,'1',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[33] := true;
              end;
            end else //-------------------------------------------------- нет потери связи
            begin
              if ObjZav[Ptr].bParam[33] then //---------------- была фиксация потери связи
              begin
                AddFixMessage(GetShortMsg(1,434,'1',0),5,2);
                InsArcNewMsg(0,434+$1000,0);
                ObjZav[Ptr].bParam[33] := false;
              end;
              ObjZav[Ptr].bParam[18] := false;
            end;

            if (svaz1 and $4) = $4 then //-------------------------------------- потеря ТУ
            begin
              ObjZav[Ptr].bParam[17] := true;
              if not ObjZav[Ptr].bParam[30] then //------------ не было фиксации потери ТУ
              begin
                AddFixMessage(GetShortMsg(1,519,'1',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[30] := true;
              end;
            end else //----------------------------------------------------- нет потери ТУ
            begin
              if ObjZav[Ptr].bParam[30] then //------------------- была фиксация потери ТУ
              begin
                AddFixMessage(GetShortMsg(1,520,'1',0),5,2);
                InsArcNewMsg(0,520+$1000,0);
                ObjZav[Ptr].bParam[30] := false;
              end;
              ObjZav[Ptr].bParam[17] := false;
            end;
          end else
          if ObjZav[Ptr].ObjConstI[13] = 2 then //--------------------------------- ТУМС-2
          begin
            if (svaz1 and $2) = $2 then //----------------------------------- потеря связи
            begin
              ObjZav[Ptr].bParam[18] := true;
              if not ObjZav[Ptr].bParam[33] then //--------- не было фиксации потери связи
              begin
                AddFixMessage(GetShortMsg(1,433,'2',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[33] := true;
              end;
            end else //-------------------------------------------------- нет потери связи
            begin
              if ObjZav[Ptr].bParam[33] then //---------------- была фиксация потери связи
              begin
                AddFixMessage(GetShortMsg(1,434,'2',0), 5,2);
                InsArcNewMsg(0,434+$1000,0);
                ObjZav[Ptr].bParam[33] := false;
              end;
              ObjZav[Ptr].bParam[18] := false;
            end;

            if (svaz1 and $8) = $8 then //-------------------------------------- потеря ТУ
            begin
              ObjZav[Ptr].bParam[17] := true;
              if not ObjZav[Ptr].bParam[30] then //------------ не было фиксации потери ТУ
              begin
                AddFixMessage(GetShortMsg(1,519,'2',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[30] := true;
              end;
            end else //----------------------------------------------------- нет потери ТУ
            begin
              if ObjZav[Ptr].bParam[30] then //------------------- была фиксация потери ТУ
              begin
                AddFixMessage(GetShortMsg(1,520,'2',0),5,2);
                InsArcNewMsg(0,520+$1000,0);
                ObjZav[Ptr].bParam[30] := false;
              end;
              ObjZav[Ptr].bParam[17] := false;
            end;
          end;

          //-------------------------------------------------------------- перепут каналов
          if (svaz1 and $20) = $20 then
          begin
            ObjZav[Ptr].bParam[19] := true;
            if not ObjZav[Ptr].bParam[32] then //--------------- не было фиксации перепута
            begin
              AddFixMessage(GetShortMsg(1,521,'2',0),4,2);
              InsArcNewMsg(0,521+$1000,0);
              ObjZav[Ptr].bParam[32] := true;
            end;
          end else
          begin //--------------------------------------------------- нет перепута каналов
            if ObjZav[Ptr].bParam[32] then //---------------------- была фиксация перепута
            begin
              AddFixMessage(GetShortMsg(1,520,'2',0),5,2);
              InsArcNewMsg(0,520+$1000,0);
              ObjZav[Ptr].bParam[32] := false;
            end;
            ObjZav[Ptr].bParam[19] := false;
          end;

          //--------------------------- слежение за выдачей команды и получением квитанций
          if (svaz1 and $40) = $40 then KOMANDA_OUT := true //- выдана команда в канал УВК
          else KOMANDA_OUT := false;

          if(KOMANDA_OUT and (not KVITOK)) then //если выдана команда, но нет квитирования
          begin
            ObjZav[Ptr].bParam[21] := true; //------ фиксируем, что команда выдана в канал
            if not ObjZav[Ptr].bParam[29] then //--------- не было фиксации выдачи команды
            begin
              AddFixMessage(GetShortMsg(1,535,'',0),7,2);
              InsArcNewMsg(0,535+$1000,0);
              ObjZav[Ptr].bParam[29] := true; //- выставляем требование ожидания квитанции
            end;
          end;

          //------------------------------------------------------- потеря связи с соседом
          if (svaz1 and $10) = $10 then
          begin
            ObjZav[Ptr].bParam[20] := true;
            if not ObjZav[Ptr].bParam[34] then //---------- не было фиксации потери соседа
            begin
              AddFixMessage(GetShortMsg(1,522,'',0),4,2);
              InsArcNewMsg(0,522+$1000,0);
              ObjZav[Ptr].bParam[34] := true;
            end;
          end else
          begin //------------------------------------------------------ нет потери соседа
            if ObjZav[Ptr].bParam[34] then //----------------- была фиксация потери соседа
            begin
              AddFixMessage(GetShortMsg(1,523,'',0),5,2);
              InsArcNewMsg(0,523+$1000,0);
              ObjZav[Ptr].bParam[34] := false;
            end;
            ObjZav[Ptr].bParam[20] := false;
          end;

          if((not KOMANDA_OUT) and (not KVITOK)) then//если команда сброшена без квитанции
          begin
            if WorkMode.OtvKom and (NET_PRIEMA_UVK <> 0) then
            begin
                AddFixMessage(GetShortMsg(1,542,'',0),4,3); // Команду не удалось передать
                InsArcNewMsg(0,542+$1000,0);
                SingleBeep3 := true;
                NET_PRIEMA_UVK := 0;
                ObjZav[Ptr].bParam[29] := false; //----------- отменить ожидание квитанции
                ObjZav[Ptr].bParam[21] := false; //--------- сброс фиксации выдачи команды
                WorkMode.OtvKom := false;
            end else
            if ObjZav[Ptr].bParam[21] then //---------- была ранее фиксация выдачи команды
            begin
              inc(NET_PRIEMA_UVK);
              if WorkMode.OtvKom then inc(NET_PRIEMA_UVK);
              AddFixMessage(GetShortMsg(1,541,'',0),4,4); //----- Нет приема команды в УВК
              InsArcNewMsg(0,541+$1000,0);
              ObjZav[Ptr].bParam[29] := false; //------------- отменить ожидание квитанции
              ObjZav[Ptr].bParam[21] := false; //----------- сброс фиксации выдачи команды

              if NET_PRIEMA_UVK >= 2 then
              begin
                inc(NET_PRIEMA_UVK);
                AddFixMessage(GetShortMsg(1,542,'',0),4,3); // Команду не удалось передать
                InsArcNewMsg(0,542+$1000,0);
                SingleBeep3 := true;
                NET_PRIEMA_UVK := 0;
                ObjZav[Ptr].bParam[29] := false; //----------- отменить ожидание квитанции
                ObjZav[Ptr].bParam[21] := false; //--------- сброс фиксации выдачи команды
              end;
            end;
          end;

          if(KOMANDA_OUT and KVITOK) then //если выдана команда, и пришла квитанция от УВК
          begin //---------------------------------------------- есть квитанция на команду
            if ObjZav[Ptr].bParam[21] then //---------- была ранее фиксация выдачи команды
            begin
              AddFixMessage(GetShortMsg(1,536,'',0),5,2); //----------- УВК принял команду
              InsArcNewMsg(0,536+$1000,0);
              ObjZav[Ptr].bParam[29] := false; //------------- отменить ожидание квитанции
              ObjZav[Ptr].bParam[21] := false; //----------- сброс фиксации выдачи команды
            end;
          end;
          ObjZav[Ptr].iParam[1] := svaz1;
        end;

        //--------------------- заполнить параметры видеобуфера --------------------------
        for ii := 1 to 15 do
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
          OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
        end;

        for ii := 17 to 32 do
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
          OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
        end;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepIKTUMS]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------------------------- Контроль режима управления #39
var ops : array[1..3] of Integer;
procedure PrepKRU(Ptr : Integer);
var
  group,i : integer;
  lock,nepar,Ru,Ou,Su,Vsu,Du : boolean;
  ps : array[1..3] of Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    nepar := false; //----------------------------------------------------- Непарафазность


    Ru := GetFR3(ObjZav[Ptr].ObjConstI[2],nepar,ObjZav[Ptr].bParam[31]); //------------ РУ

    Ou := GetFR3(ObjZav[Ptr].ObjConstI[3],nepar,ObjZav[Ptr].bParam[31]); //------------ ОУ

    Su := GetFR3(ObjZav[Ptr].ObjConstI[4],nepar,ObjZav[Ptr].bParam[31]); //------------ СУ

    Vsu := GetFR3(ObjZav[Ptr].ObjConstI[5],nepar,ObjZav[Ptr].bParam[31]); //---------- ВСУ

    Du := GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,ObjZav[Ptr].bParam[31]); //------------ ДУ

    if (Ru <> ObjZav[Ptr].bParam[1]) or (Ou <> ObjZav[Ptr].bParam[2]) or
    (Su <> ObjZav[Ptr].bParam[3]) or (Vsu <> ObjZav[Ptr].bParam[4]) or
    (Du <> ObjZav[Ptr].bParam[5]) then   ChDirect := true;

    ObjZav[Ptr].bParam[1] := Ru; ObjZav[Ptr].bParam[2] := Ou; ObjZav[Ptr].bParam[3] := Su;
    ObjZav[Ptr].bParam[4] := Vsu;  ObjZav[Ptr].bParam[5] := Du;

    ObjZav[Ptr].bParam[32] := nepar; //------------------------------------ Непарафазность

    if ObjZav[Ptr].ObjConstI[7] > 0 then
    ObjZav[Ptr].bParam[6] :=
    not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])//КРУ
    else ObjZav[Ptr].bParam[6] := true;

    group := ObjZav[Ptr].ObjConstI[1];//------------------- номер группы объектов контроля

    if ObjZav[Ptr].ObjConstI[1] < 1 then group := 0;
    if ObjZav[Ptr].ObjConstI[1] > 8 then group := 0;

    //----------------------------------------------------- Присвоить параметры управления
    WorkMode.BU[group] := not ObjZav[Ptr].bParam[31]; //-------------- контроль активности

    WorkMode.NU[group] := ObjZav[Ptr].bParam[32];     //----------- контроль достоверности

    if ObjZav[Ptr].ObjConstI[2] > 0 //-------------------------------- если есть датчик РУ
    then WorkMode.RU[group] := ObjZav[Ptr].bParam[1];//получить активность режима "пульт"

    if ObjZav[Ptr].ObjConstI[3] > 0 //-------------------------------- если есть датчик ОУ
    then WorkMode.OU[group] := ObjZav[Ptr].bParam[2];//- получить активность режима "УВК"

    if ObjZav[Ptr].ObjConstI[4] > 0  //------------------------------- если есть датчик СУ
    then WorkMode.SUpr[group] := ObjZav[Ptr].bParam[3]; //-- получить активность режима СУ

    if ObjZav[Ptr].ObjConstI[5] > 0 //------------------------------- если есть датчик ВСУ
    then WorkMode.VSU[group] := ObjZav[Ptr].bParam[4]; //- получить активность датчика ВСУ

    if ObjZav[Ptr].ObjConstI[6] > 0 //---------------------------------если есть датчик ДУ
    then WorkMode.DU[group] := ObjZav[Ptr].bParam[5]; //--- получить активность датчика ДУ

    WorkMode.KRU[group] := ObjZav[Ptr].bParam[6];//------получить групповую готовность КРУ

    if group = 0 then
    begin //---------------------------------------- Определить признак фиксации сообщений
      lock := false;
      if WorkMode.BU[0] then
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        lock := true;
      end else
      begin
        if ObjZav[Ptr].Timers[1].Active then
        begin
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin //------------------ завершена выдержка после включения обмена с серверами
            lock := false;
            ObjZav[Ptr].Timers[1].Active := false;
          end;
        end else
        begin //---------------------- Начать отсчет задержки начала регистрации сообщений
          ObjZav[Ptr].Timers[1].First := LastTime + 15/80000;
          ObjZav[Ptr].Timers[1].Active := true;
        end;
      end;
      WorkMode.FixedMsg := not (StartRM or WorkMode.NU[0] or lock);
    end;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//---------ОУ
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1];//---------РУ
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := not ObjZav[Ptr].bParam[6];//----КРУ
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[3];//---------СУ
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];//--------ВСУ
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];//---------ДУ
      end;
    end;

    inc(LiveCounter);
    //----------------------------- проверить количество открытых пригласительных сигналов
    ps[1] := 0; ps[2] := 0; ps[3] := 0; //--- расчитано на максимум на 3 района управления
    for i := 1 to WorkMode.LimitObjZav do //-------------------- пройтись по всем объектам
    if ObjZav[i].TypeObj = 7 then //------------------ если попался пригласительный сигнал
    begin
      if ObjZav[i].bParam[1] then inc(ps[ObjZav[i].RU]); //если включен ПС, увеличить счет
    end;
    //---------------------------------------------------------------------------- Район 1
    if ps[1] <> ops[1] then //если изменилось число открытых пригласительных в 1-ом районе
    begin
      if (ps[1] > 1) and (ps[1] > ops[1]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 1) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0); //---- Открыто более одного пригласительного огня
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[19] := true; //----------- фиксация ненормы по ПС в 1-ом районе
      end
      else ObjZav[Ptr].bParam[19] := false;
      ops[1] := ps[1];
    end;
    //---------------------------------------------------------------------------- Район 2
    if ps[2] <> ops[2] then
    begin
      if (ps[2] > 1) and (ps[2] > ops[2]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 2) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0);
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[20] := true;
      end
      else ObjZav[Ptr].bParam[20] := false;
      ops[2] := ps[2];
    end;
    //---------------------------------------------------------------------------- Район 3
    if ps[3] <> ops[3] then
    begin
      if (ps[3] > 1) and (ps[3] > ops[3]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 3) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0);
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[21] := true;
      end
      else  ObjZav[Ptr].bParam[21] := false;
      ops[3] := ps[3];
    end;
  except
    reportf('Ошибка [MainLoop.PrepKRU]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------------------ Схема известителя #40
procedure PrepIzvPoezd(Ptr : Integer);
  var i : integer; z : boolean;
begin
try
  inc(LiveCounter);
  z := false;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      if not ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] then
      begin
        z := true;
        break;
      end;
    end;
  ObjZav[Ptr].bParam[1] := z;
except
  reportf('Ошибка [MainLoop.PrepIzvPoezd]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------- Подготовка объекта охранности стрелок в пути для маршрута отправления #41
procedure PrepVPStrelki(VPSTR : Integer);
var
  svet_otpr, //------------------------------------------------------ светофор отправления
  sp_otpr, //---------------------------------------------- перекрывная СП для отправления
  str_ohr, //------------------------------------------------- охраняемая стрелка (в пути)
  hvost_str_ohr, //-------------------------------------------------- хвост стрелки в пути
  RZS, //------------------------------------------------ объект ручного замыкания стрелки
  Para, //----------------------------------------------------------------- парная стрелка
  Para_hvost, //----------------------------------------------------- хвост парной стрелки
  i : integer;
  z,dzs : boolean;
begin
  try
    inc(LiveCounter);
    svet_otpr := ObjZav[VPSTR].BaseObject; //------------------------- светофор отравления

    if svet_otpr > 0 then //----------------------------- если указан светофор отправления
    if ((ObjZav[svet_otpr].bParam[3] or //------- если есть ВС в светофоре отправления или
    ObjZav[svet_otpr].bParam[4] or //------------- если есть С в светофоре отправления или
    ObjZav[svet_otpr].bParam[8]) and //- есть начало в светофоре отправления из STAN и ...
    not ObjZav[svet_otpr].bParam[1])
    then ObjZav[VPSTR].bParam[20] := true //-------- установить признак отправления поезда
    else ObjZav[VPSTR].bParam[20] := false;

    sp_otpr := ObjZav[VPSTR].UpdateObject; //----------- Индекс перекрывной СП отправления

    if sp_otpr > 0 then
    begin
      z := ObjZav[sp_otpr].bParam[2] or
      not ObjZav[VPSTR].bParam[20]; //--- Получить замыкание перекрывной СП маршрута отпр.

      if ObjZav[VPSTR].bParam[5] <> z then //------- если признак замыкания нужно обновить
      if z then //------ если произошло размыкание перекрывной секции маршрута отправления
      ObjZav[VPSTR].bParam[20] := false; //-- Снять признак поездного маршрута отправления

      ObjZav[VPSTR].bParam[5] := z; //----------------------------- состояние замыкания СП


      if (not ObjZav[VPSTR].bParam[20] or //-- если нет поездного маршрута отправления и
      ObjZav[VPSTR].bParam[21]) then exit; //----- нет трассировки поездного отправления
//----------------------------------------------------------------------------------------
      for i := 1 to 4 do
      begin
        str_ohr := ObjZav[VPSTR].ObjConstI[i];//-- Индекс объекта очередной стрелки в пути
        if str_ohr > 0 then //------------------------- если есть очередная стрелка в пути
        begin
          Para := ObjZav[str_ohr].ObjConstI[25]; //----------------- объект парной стрелки
          Para_hvost := 0;
          if Para > 0 then Para_hvost := ObjZav[Para].BaseObject; //- хвост парной стрелки
          hvost_str_ohr := ObjZav[str_ohr].BaseObject; //---------- хвост охранной стрелки
          RZS := ObjZav[hvost_str_ohr].ObjConstI[12];
          dzs := ObjZav[RZS].bParam[1];
          inc(LiveCounter);
          ObjZav[sp_otpr].bParam[14] := ObjZav[sp_otpr].bParam[14] and z;

          if ObjZav[VPSTR].ObjConstB[1] then //-------------------- для нечетных маршрутов
          ObjZav[str_ohr].bParam[27] := not z;

          if ObjZav[VPSTR].ObjConstB[2] then //---------------------- для четных маршрутов
          ObjZav[str_ohr].bParam[26] := not z;

          if not dzs then
          ObjZav[str_ohr].bParam[4] := //--------------- итоговое дополнительное замыкание
          ObjZav[str_ohr].bParam[27] or ObjZav[str_ohr].bParam[26] or
          ObjZav[str_ohr].bParam[33] or ObjZav[str_ohr].bParam[25]
          else ObjZav[str_ohr].bParam[4] := true;

          if Para_hvost > 0 then ObjZav[Para_hvost].bParam[4]:= ObjZav[str_ohr].bParam[4];

          OVBuffer[ObjZav[str_ohr].VBufferIndex].Param[7] :=
          ObjZav[str_ohr].bParam[4];//----------------------------------- вывести на экран

          if Para_hvost > 0 then
          OVBuffer[ObjZav[Para].VBufferIndex].Param[7] :=
          ObjZav[Para_hvost].bParam[4];//-------------------------------- вывести на экран


          //------------------------------- Трассировка маршрута через описание охранности
          if ObjZav[sp_otpr].bParam[14] then //---- секция отправления замкнута программно
          begin
            if (ObjZav[VPSTR].ObjConstI[i+4] = 0) or//в пути нет маневрового с красным или
            ((ObjZav[VPSTR].ObjConstI[i+4] > 0) and //------------ такой сигнал есть и ...
            (ObjZav[hvost_str_ohr].bParam[21] and //хвост стрелки в пути замкнут  СП и ...
            ObjZav[hvost_str_ohr].bParam[22])) then //--- хвост стрелки в пути занят из СП
            begin
              ObjZav[VPSTR].bParam[22+i] := true;//-- установить предварительное замыкание

              if ObjZav[VPSTR].ObjConstB[i*3] then // если i-я стрелка должна быть в плюсе
              begin
                if not ObjZav[str_ohr].bParam[1] //----------- если i-я стрелка не в плюсе
                then ObjZav[VPSTR].bParam[7+i] := true;//-- признак ожидания перевода i-ой
              end else
              if ObjZav[VPSTR].ObjConstB[i*3+1] then //стрелка должна должна быть в минусе
              begin
                if not ObjZav[str_ohr].bParam[2] //-------------- если стрелка не в минусе
                then ObjZav[VPSTR].bParam[7+i] := true; //- признак ожидания перевода i-ой
              end;
            end;
          end else //---------------------- если нет предварительного замыкания СП, то ...
          ObjZav[VPSTR].bParam[22+i] := false; //-- снять признак замыкания стрелки в пути

          if not ObjZav[VPSTR].bParam[7+i] then //--------- если нет ожидания перевода, то
          begin
            ObjZav[VPSTR].bParam[i] := //----- требование перевода i-ой стрелки состоит из
            not ObjZav[sp_otpr].bParam[8] and //-------- предв. трассировки СП отправления
            not ObjZav[sp_otpr].bParam[14];//-------------- прогр.замыкания СП отправления
          end
          else  ObjZav[VPSTR].bParam[i] := false;//- когда ждем перевода, снять требование

          if ObjZav[svet_otpr].bParam[9] then
          if not ObjZav[hvost_str_ohr].bParam[5] then //--- если хвост не требует перевода
          ObjZav[hvost_str_ohr].bParam[5] := ObjZav[VPSTR].bParam[i];//копировать значение

          if not ObjZav[hvost_str_ohr].bParam[8] then //--- если хвост не ожидает перевода
          ObjZav[hvost_str_ohr].bParam[8] := ObjZav[VPSTR].bParam[7+i];//------ копировать

          if not ObjZav[hvost_str_ohr].bParam[23] then //- если хвост не имеет трассировки
          ObjZav[hvost_str_ohr].bParam[23] := ObjZav[VPSTR].bParam[22+i];//---- копировать
        end;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepVPStrelki]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------- Схема перезамыкания поездного маршрута на маневроаый (ВП для стрелки в пути) #42
procedure PrepVP(Ptr : Integer);
var
  i,o,sp_v_p,svetofor : integer;

  z,nepar,VP : boolean;
begin
  try
    inc(LiveCounter);
    VP := GetFR3(ObjZav[Ptr].ObjConstI[11],nepar,ObjZav[Ptr].bParam[31]); //---- объект ВП
    sp_v_p := ObjZav[Ptr].UpdateObject; //------------------- объект СП для стрелки в пути
    svetofor := ObjZav[Ptr].BaseObject; //-------------- светофор прикрытия стрелки в пути
    z := ObjZav[sp_v_p].bParam[2]; //-------------------- Получить замыкалку секции в пути

    ObjZav[Ptr].bParam[1] := VP;

    if ObjZav[Ptr].bParam[3] <> z then //----------------------- если замыкалка изменилась
    if z then//---------------------------------------- произошло размыкание секции в пути
    begin
      ObjZav[Ptr].bParam[1] := false; //----------- Снять признак поездного приема на путь
      ObjZav[Ptr].bParam[2] := false; // Снять разрешение перезамыкания поездного маршрута
      ObjZav[Ptr].bParam[3] := false; //--------------------- сбросить состояние замыкалки
    end;


     //------ если  есть признак поездного приема, замыкание, отсутствие РИ  и свободность
    //------------------------------- стрелочной секции в пути, и маневровый сигнал закрыт
    if ObjZav[Ptr].bParam[1] and //------------------- есть маршрут поездного приема и ...
    not ObjZav[svetofor].bParam[1] and //------------- нет МС1 маневрового у стрелки и ...
    not ObjZav[svetofor].bParam[2] and //----------- нет МС2 у маневрового у стрелки и ...
    ObjZav[sp_v_p].bParam[1] and //------------------------------------- свободна СП и ...
    not ObjZav[sp_v_p].bParam[2] and  //-------------------------------- замкнута СП и ...
    not ObjZav[sp_v_p].bParam[3] then //--------------------------- нет признака РИ для СП
    begin
      z := true;
      ObjZav[Ptr].bParam[3] := z; //------------------------ запомнить состояние замыкалки
      for i := 1 to 4 do //----------------------- пройти по 4-м возможным стрелкам в пути
      begin //------------------------ проверить наличие плюсового контроля стрелок в пути
        o := ObjZav[Ptr].ObjConstI[i]; //----- охранная стрелка (очередная стрелка в пути)
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] //-------------------- если стрелка в пути не в плюсе
          then z := z and not z; //----------------- навязать для z false от любой стрелки
        end;
      end;

      if z then
      begin //--------------------------------- все стрелки в пути имеют контроль по плюсу
        o := ObjZav[Ptr].ObjConstI[10]; //---------- враждебный маневровый светофор в пути
        if o > 0 then //----------------------------------------- если есть такой светофор
        begin //------------------------------- проверка враждебного маневрового светофора
          if ObjZav[o].bParam[1] or //--------------------------------------- если МС1 или
          ObjZav[o].bParam[2] or //----------------------------------------------- МС2 или
          ObjZav[o].bParam[6] or //---------- если есть начало маневрового из STAN или ...
          ObjZav[o].bParam[7] //---------------------- есть признак маневровой трассировки
          then z := false;
        end;
      end;
      //------------------- установить признак разрешения перезамыкания поездного маршрута
      //-------------------------------------------- на маневровый по результатам проверки
      ObjZav[Ptr].bParam[2] := z;
    end else
    begin
      ObjZav[Ptr].bParam[3] := z;
      ObjZav[Ptr].bParam[2] := false; //- снять разрешение перезамыкания поездного маршрута
    end;
  except
    reportf('Ошибка [MainLoop.PrepVP]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- Объект исключения пути из маневрового района #43
procedure PrepOPI(Ptr : Integer);
  var k,o,p,j : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность

  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- опи

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- рпо

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      inc(LiveCounter);
      k := ObjZav[Ptr].BaseObject;
      if k > 0 then
      begin
        if ObjZav[k].bParam[3] then
        begin //------------------------------------------------------ не замкнуты маневры
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] :=
          ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end else
        begin //--------------------------------------------------------- маневры замкнуты
          if ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin //--------------------------------------------------------- есть ОПИ и РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
          begin //------------------------------------------------------- есть ОПИ нет РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin //------------------------------------------------------- есть ОПИ нет РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin //---------------------------------------------------------- нет ОПИ и РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end;
      end;
    end;
  end;

  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and not (ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2]) then
  begin //---------------------------- протрассировать выезд на пути из маневрового района
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstB[1] then p := 2
    else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj;
    p := ObjZav[Ptr].Neighbour[p].Pin;
    j := 50;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 :
        begin //------------------------------------------------------------------ стрелка
          case p of
            2 : ObjZav[ObjZav[o].BaseObject].bParam[10] := true;
            3 : ObjZav[ObjZav[o].BaseObject].bParam[11] := true;
          end;
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;

        44 :
        begin
          if not ObjZav[o].bParam[1] then
          ObjZav[o].bParam[1] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10];

          if not ObjZav[o].bParam[2] then
          ObjZav[o].bParam[2] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11];

          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin;
            o := ObjZav[o].Neighbour[2].Obj;
          end
          else
          begin
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;

        48 : begin //----------------------------------------------------------------- РПо
          ObjZav[o].bParam[1] := true;
          break;
        end;

        else
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin;
            o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(j);
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepOPI]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------- Объект исключения пути из маневрового района (подсветка охранности стрелок) #43
procedure PrepSOPI(Ptr : Integer);
  var o,p,j : integer;
begin
try
  if ObjZav[Ptr].UpdateObject = 0 then exit;
  inc(LiveCounter);

  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and
     ObjZav[o].bParam[1] and not ObjZav[o].bParam[4] and ObjZav[o].bParam[5] and not ObjZav[Ptr].bParam[2] and // маневровый район замкнут
     (MarhTracert[1].Rod = MarshP) and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[8] then // путь трассируется в поездном маршруте
  begin
    // отобразить охранность стрелок маневрового района
    if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 100;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              if ObjZav[ObjZav[o].BaseObject].bParam[11] then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[5] then ObjZav[ObjZav[o].BaseObject].bParam[5] := true; break;
              end;
            end;
            3 : begin
              if ObjZav[ObjZav[o].BaseObject].bParam[10] then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[5] then ObjZav[ObjZav[o].BaseObject].bParam[5] := true; break;
              end;
            end;
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
        48 : begin // РПо
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(j);
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepSOPI]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------------------------------------------- подготовка объекта СМИ #44
procedure PrepSMI(Ptr : Integer);
begin
try
{  o := ObjZav[Ptr].UpdateObject; // Индекс стрелки маневрового района
  if not ObjZav[ObjZav[o].BaseObject].bParam[5] then
    ObjZav[ObjZav[o].BaseObject].bParam[5] := ObjZav[Ptr].bParam[5];
  if not ObjZav[ObjZav[o].BaseObject].bParam[8] then
    ObjZav[ObjZav[o].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];}
except
  reportf('Ошибка [MainLoop.PrepSMI]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------------------------ Подготовка объекта выбора зоны оповещения #45
procedure PrepKNM(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ Активизация
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- Непарафазность

  ObjZav[Ptr].bParam[1] := //--------------------------------------------------------- КНМ
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  ObjZav[Ptr].bParam[2] := //---------------------------------------------------------- зМ
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepKNM]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------------------------------- подготовка объекта "Светофор с автодействием" #46
procedure PrepAutoSvetofor(Ptr : Integer);
{$IFDEF RMDSP}
var
  i,o : integer;
{$ENDIF}
begin
{$IFDEF RMDSP}
  try
    inc(LiveCounter);
    if not ObjZav[Ptr].bParam[1] then exit; //------------- выключено автодействие сигнала

    if not (WorkMode.Upravlenie and WorkMode.OU[0]
    and WorkMode.OU[ObjZav[Ptr].Group])// нет автодействия при  потере управления с РМ-ДСП
    then exit
    else
    if not WorkMode.CmdReady and not WorkMode.LockCmd then
    begin
      //------------------------------------------------------------------ сигнал открыт ?
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[2] := false;
        exit;
      end;

      //------------------------------------ проверить наличие плюсового положения стрелок
      for i := 1 to 10 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] then
          begin
            ObjZav[Ptr].bParam[2] := false;
            exit;
          end;
        end;
      end;

      //---------------------------------------- проверить таймаут между повторами команды
      if ObjZav[Ptr].Timers[1].Active then
      begin
        if ObjZav[Ptr].Timers[1].First > LastTime then exit;
      end;

      //---------------------------- Проверить возможность выдачи команды открытия сигнала
      if CheckAutoMarsh(Ptr,ObjZav[Ptr].ObjConstI[25]) then
      begin
        inc(LiveCounter);
        if SendCommandToSrv(ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[5] div 8,
        cmdfr3_svotkrauto,ObjZav[Ptr].BaseObject) then
        begin //--------------------------------------------- выдана команда на исполнение
          if SetProgramZamykanie(ObjZav[Ptr].ObjConstI[25],true) then
          begin
            if OperatorDirect > LastTime then // оператор что-то делает - подождать 15 секунд до очередной попытки выдачи команды открытия сигнала автодействием
            ObjZav[Ptr].Timers[1].First := LastTime + IntervalAutoMarsh / 86400
            else // оператор ничего не делает - подождать 10 секунд и выдать повторную команду
            ObjZav[Ptr].Timers[1].First := LastTime + 10 / 86400;
            ObjZav[Ptr].Timers[1].Active := true;
            // AddFixMessage(GetShortMsg(1,423,ObjZav[ObjZav[Ptr].BaseObject].Liter),5,1);
            SingleBeep5 := WorkMode.Upravlenie;
          end;
        end;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepAutoSvetofor]');
    Application.Terminate;
  end;
  {$ENDIF}
end;
//========================================================================================
//------------------------------- подготовка объекта "Включение автодействия сигналов" #47
procedure PrepAutoMarshrut(Ptr : Integer);
{$IFDEF RMDSP}
var
  i,j,o,p,q : integer;
{$ENDIF}
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    if ObjZav[Ptr].ObjConstI[2] >0 then
    begin
      ObjZav[Ptr].bParam[2] :=
      GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//РАС
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end
    else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := true;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] :=
      ObjZav[Ptr].bParam[1]; //---------------------------------- программное автодействие

      if not ObjZav[Ptr].bParam[1] then //-------------------- если автодействие отключено
      begin
        if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] :=
          ObjZav[Ptr].bParam[2];  //-------------------------------- релейное автодействие
        end;
      end;
    end;

{$IFDEF RMDSP}
    inc(LiveCounter);

    if ObjZav[Ptr].ObjConstB[1] then  //---------------------- объект четного автодействия
    begin
      if CHAS and not ObjZav[Ptr].bParam[1] then
      begin
        if not AutoMarsh(Ptr,true) then CHAS := false;
      end else
      if ObjZav[Ptr].bParam[1] and not CHAS
      then AutoMarsh(Ptr,false);
    end else
    begin   //---------------------------------------------- объект нечетного автодействия
      if NAS and not ObjZav[Ptr].bParam[1] then
      begin
        if not AutoMarsh(Ptr,true) then NAS := false;
      end else
      if ObjZav[Ptr].bParam[1] and not NAS
      then  AutoMarsh(Ptr,false);
    end;

    if not ObjZav[Ptr].bParam[1] then exit;

    if not(WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
    begin //----------------- сброс автодействия при  потере признаков управления с РМ-ДСП
      ObjZav[Ptr].bParam[1] := false;
      NAS := false;
      CHAS := false;
      for q := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[q] > 0 then
      begin
        ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
      end;
    end else
    //----------------------- проверить условия поддержки режима программного автодействия
    for i := 10 to 12 do //-------- пройти по описаниям входящих эл.маршрутов автодействий
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin //---------------------------------- просмотреть стартовый сигнал автодействия
        if ObjZav[ObjZav[o].BaseObject].bParam[23] then //-- если этот сигнал был перекрыт
        begin
          AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter,0),4,3);//Отключено автодействие
          ObjZav[Ptr].bParam[1] := false;

          for q := 10 to 12 do //------ пройти по всем элементарным маршрутам автодействия
          if ObjZav[Ptr].ObjConstI[q] > 0 then
          begin
            ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false; // отключить автодействие
            AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
          end;
          exit;
        end;

        for j := 1 to 10 do //--------- проход по всем стрелкам элементарного автодейсвтия
        begin
          p := ObjZav[o].ObjConstI[j];
          if p > 0 then
          begin
            if ObjZav[ObjZav[p].BaseObject].bParam[26] or
            ObjZav[ObjZav[p].BaseObject].bParam[32] then
            begin //-------- если зафиксирована потеря контроля стрелки или непарафазность
              AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter,0),4,3);//Откл. автодействие
              ObjZav[Ptr].bParam[1] := false;
              for q := 10 to 12 do
              if ObjZav[Ptr].ObjConstI[q] > 0 then
              begin
                ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
                AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
              end;
              exit;
            end;
          end;
        end;
      end;
    end;
{$ENDIF}
  except
    reportf('Ошибка [MainLoop.PrepAutoMarshrut]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------------- подготовка объекта РПО #48
procedure PrepRPO(Ptr : Integer);
begin
try
//  if ObjZav[Ptr].BaseObject > 0 then
//  begin
//
//  end;
except
  reportf('Ошибка [MainLoop.PrepRPO]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------------------------------------------ подготовка объекта АБТЦ #49
procedure PrepABTC(Ptr : Integer);
  var gpo,ak,kl,pkl,rkl : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  gpo := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ГПо
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //озП
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //УУ
  ak := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //АК
  kl := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //КЛ
  pkl := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ПКЛ
  rkl := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //РКЛ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    if gpo <> ObjZav[Ptr].bParam[1] then
      if gpo then
      begin // неисправность светофоров
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,488+$1000,0);
            AddFixMessage(GetShortMsg(1,488,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,488+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[1] := gpo;

    if ak <> ObjZav[Ptr].bParam[4] then
      if ak then
      begin // неисправность кодирования
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,489+$1000,0);
            AddFixMessage(GetShortMsg(1,489,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,489+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[4] := ak;

    if kl <> ObjZav[Ptr].bParam[5] then
      if kl then
      begin // неисправность линии
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,490+$1000,0);
            AddFixMessage(GetShortMsg(1,490,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,490+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[5] := kl;

    if pkl <> ObjZav[Ptr].bParam[6] then
      if pkl then
      begin //---------------------------------------- неисправность линии питающих концов
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,491+$1000,0);
            AddFixMessage(GetShortMsg(1,491,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,491+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[6] := pkl;

    if rkl <> ObjZav[Ptr].bParam[7] then
      if rkl then
      begin // неисправность линии питающих концов
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,492+$1000,0);
            AddFixMessage(GetShortMsg(1,492,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,492+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[7] := rkl;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // ГПо
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // озП
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // УУ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; // АК
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; // КЛ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; // ПКЛ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; // РКЛ
  end;

except
  reportf('Ошибка [MainLoop.PrepABTC]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------------------------------- подготовка объекта контроля сигнальных точек #50
procedure PrepDCSU(Ptr : Integer);
var
  activ,nepar : boolean;
begin
try
  inc(LiveCounter);
  activ := true; //----------------------------------------------------------- Активизация
  nepar := false; //------------------------------------------------------- Непарафазность

  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[1], nepar,activ); //---------- 1ПЖ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2], nepar,activ); //---------- 1оЖ

  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[3], nepar,activ); //---------- 2ПЖ
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[4], nepar,activ); //---------- 2оЖ

  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[5], nepar,activ); //---------- 3ПЖ
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,activ); //----------- 3оЖ

  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[7],nepar,activ); //----------- 4ПЖ
  ObjZav[Ptr].bParam[8] := GetFR3(ObjZav[Ptr].ObjConstI[8],nepar,activ); //----------- 4оЖ

  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],nepar,activ); //----------- 5ПЖ
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[10],nepar,activ);//---------- 5оЖ

  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[11],nepar,activ);//---------- 6ПЖ
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[12],nepar,activ);//---------- 6оЖ

  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[13],nepar,activ);//---------- 7ПЖ
  ObjZav[Ptr].bParam[14] := GetFR3(ObjZav[Ptr].ObjConstI[14],nepar,activ);//---------- 7оЖ

  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[15],nepar,activ);//---------- 8ПЖ
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[16],nepar,activ);//---------- 8оЖ

  ObjZav[Ptr].bParam[31]:= activ;
  ObjZav[Ptr].bParam[32]:= nepar;

  //-------------------------------------------------------- заглянуть в смену направления
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[31] and  //------------ если СН активна и ...
    not ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then //----------------------- парафазна
    begin
      ObjZav[Ptr].bParam[17] := not ObjZav[ObjZav[Ptr].BaseObject].bParam[4];//----- прием
      ObjZav[Ptr].bParam[18] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];    //-- передача
    end else
    begin //------------ -------------- иначе неизвестно состояние направления на перегоне
      ObjZav[Ptr].bParam[17] := false;
      ObjZav[Ptr].bParam[18] := false;
    end;
  end;

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; //---------- 1ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; //---------- 1оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; //---------- 2ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; //---------- 2оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; //---------- 3ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; //---------- 3оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; //---------- 4ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8]; //---------- 4оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9]; //--------- 5ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; //-------- 5оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[11]; //-------- 6ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[12]; //-------- 6оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[13]; //-------- 7ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[14]; //-------- 7оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[15]; //-------- 8ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[16]; //-------- 8оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := ObjZav[Ptr].bParam[17]; //------ прием
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := ObjZav[Ptr].bParam[18]; // отправление
  end;

except
  reportf('Ошибка [MainLoop.PrepDCSU]');
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------------------- Сборка дополнительных датчиков #51
procedure PrepDopDat(Ptr : Integer);
var
  i: Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true;
    ObjZav[Ptr].bParam[32] := false;
    for i := 1 to 34 do ObjZav[Ptr].NParam[i] := false;

    for i := 1 to 10 do
    begin
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin
        ObjZav[Ptr].bParam[i] :=
        GetFR3(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].NParam[i],ObjZav[Ptr].bParam[31]);
      end;
      if ObjZav[Ptr].ObjConstI[10+i] > 0 then // если предусмотрено сообщение на включение
      begin
        if ObjZav[Ptr].bParam[i] then //----------------------------------- есть включение
        begin
          if not ObjZav[Ptr].bParam[i+10] then //----------------------- не было сообщения
          begin
            ObjZav[Ptr].bParam[i+10] := true;
            ObjZav[Ptr].bParam[i+20] := false;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+10],0);
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[i+10]],4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+10],0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        if not ObjZav[Ptr].bParam[i] then //------------------------------ есть отключение
        ObjZav[Ptr].bParam[i+10] := false;
      end;


      if ObjZav[Ptr].ObjConstI[20+i] > 0 then //если предусмотрено сообщение на отключение
      begin
        if not ObjZav[Ptr].bParam[i] then //------------------------------ есть отключение
        begin
          if not ObjZav[Ptr].bParam[i+20] then //----------------------- не было сообщения
          begin
            ObjZav[Ptr].bParam[i+20] := true;
            ObjZav[Ptr].bParam[i+10] := false;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+20],0);
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[i+20]],4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+20],0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        if ObjZav[Ptr].bParam[i] then //----------------------------------- есть включение
        ObjZav[Ptr].bParam[i+20] := false;
      end;
    end;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    for i := 1 to 10 do
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[i];
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];
    end;
  except
    reportf('Ошибка [MainLoop.PrepDopDat]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ Объект трассировки МУС для светофора по пошерстным стрелкам #52
procedure PrepSVMUS(Ptr : Integer);
  var k,o,p,j : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[1] := false;
    k := ObjZav[Ptr].BaseObject;
    if k > 0 then
    begin
      if not ObjZav[k].bParam[3] and ObjZav[k].bParam[1] and ObjZav[k].bParam[4] and ObjZav[k].bParam[5] then
      begin // замкнуты маневры, есть РМ, Д, В
      // проверить противошерстные стрелки для выезда на объект сборки трассы МУС
        if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
        o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 50;
        while j > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :
            begin // стрелка
              case p of
                2 :
                begin
                  if not ObjZav[ObjZav[o].BaseObject].bParam[1] then break;
                end;
                3 :
                begin
                  if not ObjZav[ObjZav[o].BaseObject].bParam[2] then break;
                end;

                else   break;
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            53 :
            begin // ТРМУС
              if (ObjZav[Ptr].UpdateObject = o) and (k = ObjZav[o].BaseObject) then
              begin
                ObjZav[Ptr].bParam[1] := true;
                break;
              end
              else
              begin
                if p = 1 then
                begin
                  p := ObjZav[o].Neighbour[2].Pin;
                  o := ObjZav[o].Neighbour[2].Obj;
                end
                else
                begin
                  p := ObjZav[o].Neighbour[1].Pin;
                  o := ObjZav[o].Neighbour[1].Obj;
                end;
              end;
            end;
            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end
            else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(j);
        end;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepOPI]'); Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------- Подготовка объекта сигнальной точки для детской ЖД #54
procedure PrepST(Ptr : Integer);
  var o : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- Д1

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- Д2

  o := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//оГ

  if o <> ObjZav[Ptr].bParam[4] then
  begin //------------------------------------------------ огневое реле изменило состояние
    if o then
    begin //-------------------------------------------- неисправность огневушки появилась
      if WorkMode.FixedMsg then
      begin
{$IFDEF RMDSP}
        if config.ru = ObjZav[ptr].RU then
        begin
          InsArcNewMsg(Ptr,272+$1000,0);
          AddFixMessage(GetShortMsg(1,272, ObjZav[ptr].Liter,0),4,4);
          SingleBeep4 := true;
          ObjZav[Ptr].bParam[4] := o;
          ObjZav[Ptr].dtParam[1] := LastTime;
          inc(ObjZav[Ptr].siParam[1]);
        end;
{$ENDIF}
      end;
      ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
    end
    else ObjZav[Ptr].bParam[4] := o;
  end;
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //Активность
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32]; //Непарафазность
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//Д1
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];//Д2
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];//оГ
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepST]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------------------------ процедура подготовки дополнения к сигналу #55
procedure PrepDopSvet(Ptr : Integer);
var
  Signal : integer; //--------------- индекс объекта зависимостей соответствующего сигнала
  VidBuf : integer; //-------------------- номер видеобуфера для соостветствующего сигнала
  ij : integer;
begin
  try
    for ij:=1 to 6 do ObjZav[Ptr].bParam[ij] := false;

    Signal := ObjZav[Ptr].BaseObject;
    VidBuf := ObjZav[Signal].VBufferIndex;
    inc(LiveCounter);

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    if ObjZav[Ptr].ObjConstI[1] <> 0 then
    ObjZav[Ptr].bParam[1] :=
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ГМ

    if ObjZav[Ptr].ObjConstI[2] <> 0 then
    ObjZav[Ptr].bParam[2] :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ЛС

    if ObjZav[Ptr].ObjConstI[3] <> 0 then
    ObjZav[Ptr].bParam[3] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-2зС

    if ObjZav[Ptr].ObjConstI[4] <> 0 then
    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//- ЖМС

    if ObjZav[Ptr].ObjConstI[5] <> 0 then
    ObjZav[Ptr].bParam[5] :=
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-вкмг

    if ObjZav[Ptr].ObjConstI[6] <> 0 then
    ObjZav[Ptr].bParam[6] :=
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ПС

    if ObjZav[Ptr].ObjConstI[10] <> 0 then
    ObjZav[Ptr].bParam[10] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//- ЕН

    if VidBuf > 0 then
    begin
      OVBuffer[VidBuf].Param[20] := ObjZav[Ptr].bParam[1]; //-------------------------- ГМ
      OVBuffer[VidBuf].Param[22] := ObjZav[Ptr].bParam[2]; //---------------------- ЛС(зС)
      OVBuffer[VidBuf].Param[21] := ObjZav[Ptr].bParam[3]; //------------------------- 2зС
      OVBuffer[VidBuf].Param[23] := ObjZav[Ptr].bParam[4]; //------------------------- ЖМС
      OVBuffer[VidBuf].Param[24] := ObjZav[Ptr].bParam[5]; //-------------------------вкмг
      OVBuffer[VidBuf].Param[25] := ObjZav[Ptr].bParam[6]; //-------------------------- пс
      OVBuffer[VidBuf].Param[28] := ObjZav[Ptr].bParam[10]; //------------------------- ЕН
    end;
  except
    reportf('Ошибка [MainLoop.PrepDopSvet]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------------------- Подготовка объекта УКГ для вывода на табло #56
procedure PrepUKG(Ptr : Integer);
var
  vkgd,vkgd1,kg,okg : boolean;
  ob_vkgd,ob_vkgd1, kod,i : integer;
  TXT1 : string;
begin
  try
    kod := 0;
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    for i := 1 to 32 do ObjZav[Ptr].NParam[i] := false;
    ob_vkgd := ObjZav[Ptr].ObjConstI[4];
    ob_vkgd1 := ObjZav[Ptr].ObjConstI[5];

    kg :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]); //-УКГ

    okg :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); // оКГ

    vkgd :=
    GetFR3(ob_vkgd,ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//------------------ ВКГД

    vkgd1 :=
    GetFR3(ob_vkgd1,ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);//---------------- ВКГД1

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].NParam[2] or
      ObjZav[Ptr].NParam[3] or  ObjZav[Ptr].NParam[4] or  ObjZav[Ptr].NParam[5];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if kg then  kod := kod + 1;
        if okg then kod := kod + 2;
        if vkgd then kod := kod + 4;
        if vkgd1 then kod := kod + 8;


        ObjZav[Ptr].bParam[1] := kg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := KG;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2];

        ObjZav[Ptr].bParam[3] := vkgd;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vkgd;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];

        ObjZav[Ptr].bParam[4] := vkgd1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vkgd1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[5] := ObjZav[Ptr].NParam[5];

        ObjZav[Ptr].bParam[2] := okg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := okg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3];

        if kod <> ObjZav[Ptr].iParam[1] then   //-------------- изменился код состяния УКГ
        begin
          if not ObjZav[Ptr].Timers[1].Active then //-------------- если таймер не активен
          begin
            ObjZav[Ptr].Timers[1].Active := true; //---------------- активизировать таймер
            ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400; // заряд ожидания на 2сек
          end;
        end;

        if ObjZav[Ptr].Timers[1].Active and //------------------ если таймер активен и ...
        (LastTime > ObjZav[Ptr].Timers[1].First) then //----------- истекло время ожидания
        begin
{$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
          case kod of
            4,8,12:  //--------------------------------------------- исправно, но отключено
            begin
              InsArcNewMsg(Ptr,554+$1000,0); //------------------- необходимо включить УКГ
              TXT1 := GetShortMsg(1,554,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,2);
              PutShortMsg(7,LastX,LastY,TXT1);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            1,5,9,13://------------------------------------------- неисправное отключенное
            begin
              InsArcNewMsg(Ptr,553+$1000,0); //----------------------------- УКГ отключено
              TXT1 := GetShortMsg(1,553,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,2);
              PutShortMsg(7,LastX,LastY,TXT1);
            end;

            0://-------------------------------------- исправное состояние включенного УКГ
            begin
              InsArcNewMsg(Ptr,557+$1000,0); //------------------ УКГ возвращен в исходное
              TXT1 := GetShortMsg(1,557,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,0,2);
              PutShortMsg(2,LastX,LastY,TXT1);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            3: //-------------------------------------------- сработали датчики КГ1 и ОКГ
            begin
              InsArcNewMsg(Ptr,552+$1000,0); //----------------------- Сработал датчик УКГ
              TXT1:= GetShortMsg(1,552,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,3);
              PutShortMsg(1,LastX,LastY,TXT1);
            end;
            else
            begin
              InsArcNewMsg(Ptr,550+$1000,0); //---------------- неправильно работает схема
              TXT1 := GetShortMsg(1,550,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,3);
              PutShortMsg(11,LastX,LastY,TXT1);
            end;
          end;

{$ELSE}
          case kod of
            4,8,12:  //-------------------------------------------- исправно, но отключено
            begin
              InsArcNewMsg(Ptr,554+$1000,0);
              SingleBeep3 := true;
            end;

            5,9,13:
            begin
              InsArcNewMsg(Ptr,553+$1000,0);//Устройство контроля габаритов(УКГ) отключено
              SingleBeep3 := true;
            end;

            0://-------------------------------------- исправное состояние включенного УКГ
            begin
              InsArcNewMsg(Ptr,557+$1000,0); //------------------ УКГ возвращен в исходное
              SingleBeep3 := true;
            end;

            3:
            begin
              InsArcNewMsg(Ptr,552+$1000,0);
              SingleBeep3 := true;
            end;
            else
            begin
              InsArcNewMsg(Ptr,550+$1000,0); //---------------- неправильно работает схема
              SingleBeep3 := true;
            end;
          end;
{$ENDIF}
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].Timers[1].First := 0;
        end;

        ObjZav[Ptr].iParam[1] := kod;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepUKG]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------------------- подготовка для объекта День/Ночь #92
procedure PrepDN(Ptr : Integer);
var
  dnk,nnk,auk,dn : boolean;
  dnk_kod,nnk_kod,auk_kod,dn_kod,AllKod : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- Активизация
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ Непарафазность

    //--------------------- Читаем значение датчика кнопки "День"
    dnk := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);
    if dnk then dnk_kod := 1
    else dnk_kod :=0;

    //--------------------- Читаем значение датчика кнопки "Ночь"
    nnk := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].Nparam[2],ObjZav[Ptr].bParam[31]);
    if nnk then nnk_kod := 1
    else nnk_kod :=0;

    //------------------ Читаем значение датчика кнопки "Автомат"
    auk := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);
    if auk then auk_kod := 1
    else auk_kod :=0;

    //----------------------- Читаем значение датчика "День/Ночь"
    dn := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);
    if dn then dn_kod := 1
    else dn_kod :=0;
    AllKod := dnk_kod*8 + nnk_kod*4 + auk_kod*2 + dn_kod;

    if (ObjZav[Ptr].iParam[1] <> AllKod) then //если изменилось состояние любого датчика
    begin
      ObjZav[ptr].iParam[1] := AllKod;
      ObjZav[Ptr].dtParam[1] := LastTime;
      case AllKod of
        //-------------------------------------------------------------------------------
        2: //--------------------------------------------------- дневной режим в автомате
        begin // нажата кнопка "автомат"
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,362+$1000,0); //--------------------------- включен автомат
              AddFixMessage(GetShortMsg(1,362, ObjZav[ptr].Liter,0),4,4);
              InsArcNewMsg(Ptr,360+$1000,0); //------------------------------ включен день
              AddFixMessage(GetShortMsg(1,360, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
        end;
        //-------------------------------------------------------------------------------
        3: //---------------------------------------------------- ночной режим в автомате
        begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,362+$1000,0); //--------------------------- включен автомат
              AddFixMessage(GetShortMsg(1,362, ObjZav[ptr].Liter,0),4,4);
              InsArcNewMsg(Ptr,361+$1000,0); //----------------------------- включена ночь
              AddFixMessage(GetShortMsg(1,361, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
          {$ENDIF}
          end;
         end;

         4,6,7,9..15: //------------------------ ненормы схемы переключения
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,516+$1000,0);
              AddFixMessage(GetShortMsg(1,516, ObjZav[ptr].Liter,0),4,4);
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
         end;
         5: //------------------------------------------------------- ночь в ручном режиме
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,361+$1000,0);
              AddFixMessage(GetShortMsg(1,361, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
          {$ENDIF}
          end;
         end;
         8: //------------------------------------------------------- день в ручном режиме
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,360+$1000,0);
              AddFixMessage(GetShortMsg(1,360, ObjZav[ptr].Liter,0),4,4);
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
         end;
      end;
    end;
    ObjZav[Ptr].bParam[1] := dnk;
    ObjZav[Ptr].bParam[2] := nnk;
    ObjZav[Ptr].bParam[3] := auk;
    ObjZav[Ptr].bParam[4] := dn;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //Активность
      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[1];//кнопка "день"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[1] := ObjZav[Ptr].NParam[1];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//кнопка "ночь"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];//кнопка "авто"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];//- датчик "ДН"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];

        OVBuffer[ObjZav[Ptr].VBufferIndex].DZ3 := AllKod;
      end;
    end;
  except
    reportf('Ошибка [MainLoop.PrepST]');
    Application.Terminate;
  end;
end;
end.
