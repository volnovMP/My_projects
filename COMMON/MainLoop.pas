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

procedure SetDateTimeARM;
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
procedure PrepareOZ;
procedure GoOVBuffer(Ptr,Steps : Integer);

procedure DiagnozUVK;
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
function Get_ManK(Ptr : SmallInt) : Boolean;

procedure PrepXStrelki(Xstr : Integer); //------------------------------ хвост стрелки (1)
procedure PrepStrelka(Str : Integer);//-------------------------------------- стрелкка (2)
procedure PrepOxranStrelka(StrOh : Integer);
procedure PrepSekciya(SP : Integer); //------------------------------ секция СП или УП (3)
procedure PrepPuti(PUT : Integer);  //------------------------------------------- путь (4)
procedure PrepSvetofor(SVTF : Integer);
procedure PrepRZS(RZST : Integer);//-------------------------- ручное замыкание стрелок(9)
procedure PrepMagStr(Ptr : Integer);
procedure PrepMagMakS(MagM : Integer); //-------------------------- магистраль макета (18)
procedure PrepPTO(PTO : Integer);
procedure PrepUTS(UTS : Integer);
procedure PrepUPer(UPER : Integer);
procedure PrepKPer(KPER : Integer);
procedure PrepK2Per(KPER2 : Integer);
procedure PrepOM(OPV : Integer);    //--------------------------- оповещение монтеров (13)
procedure PrepUKSPS(UKS : Integer); //------------- контроль схода подвижного состава (14)
procedure PrepAB(AB : Integer);    //------------ увязка с перегоном, автоблокировкой (15)
procedure PrepVSNAB(VSN : Integer); //------------- вспомогательная смена направления (16)
procedure PrepAPStr(AVP : Integer); //--------------------- аварийный перевод стрелок (19)
procedure PrepMaket(MAK : Integer); //----------------------------------------- макет (20)
procedure PrepOtmen(OTM : Integer); //                                                (21)
procedure PrepGRI(GRI : Integer);   //------------------------------------------- ГРИ (22)
procedure PrepPAB(PAB : Integer); //------------------- полуавтоматическая блокировка (26)
procedure PrepDZStrelki(Dz : Integer); //--------- дополнительная зависимость стрелки (27)
procedure PrepDSPP(Ptr : Integer);
procedure PrepPSvetofor(Ptr : Integer);
procedure PrepPriglasit(PRIG : Integer);
procedure PrepNadvig(NAD : Integer); //--------------------- увязка с горкой - надвиг (32)
procedure PrepMarhNadvig(Ptr : Integer);
procedure PrepMEC(MEC : Integer);       //------------------------------ увязка с МЭЦ - 23
procedure PrepZapros(UPST : Integer); //------------------------ увязка между постами - 24
procedure PrepManevry(MNK : Integer); //-------------------------- маневровая колонка - 25
procedure PrepSingle(Ptr : Integer);
procedure PrepInside(Ptr : Integer);
procedure PrepPitanie(Ptr : Integer);
procedure PrepSwitch(Ptr : Integer);
procedure PrepIKTUMS(Ptr : Integer);
procedure PrepKRU(KRU : Integer);
procedure PrepIzvPoezd(Ptr : Integer);
procedure PrepVPStrelki(VPSTR : Integer); //--------------------------- стрелка в пути #41
procedure PrepVP(SVP : Integer);//----------------------- перезамыкание стрелки в пути #42
procedure PrepOPI(Ptr : Integer);
procedure PrepSOPI(Ptr : Integer);
procedure PrepSMI(Ptr : Integer);
procedure PrepZon(Zon : Integer); //---------------------------------- зона оповещения #45
procedure PrepRPO(Ptr : Integer);
procedure PrepAutoSvetofor(AvtoS : Integer);//----------------- "автодействие сигнала" #46
procedure PrepAutoMarshrut(AvtoM : Integer);//---------------- "автодействие маршрута" #47
procedure PrepABTC(ABTC : Integer);
procedure PrepDCSU(Ptr : Integer);
procedure PrepDopDat(Ptr : Integer);//-----------------
procedure PrepSVMUS(MUS : Integer);
procedure PrepST(SiT : Integer);    //------------------------------ сигнальная точка (54)
procedure PrepDN(Ptr : Integer);
procedure PrepDopSvet(SvtDop : Integer); //------------ объект дополнения к светофору (55)
procedure PrepUKG(UKG : Integer); //---------------------------------------------- УКГ(56)
procedure PrepRDSH(RDSH : Integer); //--------------- релейный дешифратор контроллера (60)
const
  DiagUVK : SmallInt  = 5120; // адрес сообщения о неисправности плат УВК
  DateTimeSync : Word =    1; //6144 адрес сообщения для синхронизации времени системы
{$IFDEF RMSHN}
  StatStP = 5;// количество переводов для вычисления средней длительности перевода стрелки
{$ENDIF}


implementation

uses
  Marshrut,
  Commands,
  TypeALL,
{$IFDEF RMDSP}
  //PipeProc,
  TabloDSP,
  KanalArmSrvDSP,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
  ValueList,
  TabloSHN,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

  Commons;
var
  s,dt  : string;


procedure SetDateTimeARM;

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
  if FR8 > 0 then
  begin
    time64 := FR8; err := false;
    Sc := time64 and $00000000000000ff;  time64 := time64 shr 8;  //-------------- секунды
    Mn := time64 and $00000000000000ff;  time64 := time64 shr 8;  //--------------- минуты
    Hr := time64 and $00000000000000ff;  time64 := time64 shr 8;  //----------------- часы
    Dy := time64 and $00000000000000ff;  time64 := time64 shr 8;  //----------------- день
    Mt := time64 and $00000000000000ff;  time64 := time64 shr 8;  //---------------- месяц
    Yr := (time64 and $00000000000000ff) + 2000; //----------------------------------- год

    if not TryEncodeTime(Hr,Mn,Sc,0,nt) then
    begin
      err := true;
      InsNewMsg(0,507,1,'');
      AddFixMes(GetSmsg(1,507,'',1) + 'Попытка установки времени '+
      IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;

    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsNewMsg(0,507,1,'');
      AddFixMes(GetSmsg(1,507,'',1) + 'Попытка установки даты '+
      IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
    end;

    if not err then
    begin
      ndt := nd + nt; delta := ndt - LastTime;
      DateTimeToSystemTime(ndt,uts);
      SystemTimeToTzSpecificLocalTime(nil,uts,lt);
      cdt := SystemTimeToDateTime(lt) - ndt;
      ndt := ndt - cdt;
      DateTimeToSystemTime(ndt,uts);
      SetSystemTime(uts);

      //-------------------------------------------------- коррекция отметок времени в FR3
      for i := 1 to high(FR3s) do if FR3s[i] > 0.00000001 then FR3s[i] := FR3s[i] - delta;

      //-------------------------------------------------- коррекция отметок времени в FR3
      for i := 1 to high(FR4s) do if FR4s[i] > 0.00000001 then FR4s[i] := FR4s[i] - delta;

      for i := 1 to high(ObjZv) do
      begin //-------------------------- коррекция отметок времени в объектах зависимостей
        if ObjZv[i].T[1].Activ then    ObjZv[i].T[1].F := ObjZv[i].T[1].F - delta;
        if ObjZv[i].T[2].Activ  then   ObjZv[i].T[2].F := ObjZv[i].T[2].F - delta;
        if ObjZv[i].T[3].Activ then    ObjZv[i].T[3].F := ObjZv[i].T[3].F - delta;
        if ObjZv[i].T[4].Activ then    ObjZv[i].T[4].F := ObjZv[i].T[4].F - delta;
        if ObjZv[i].T[5].Activ then    ObjZv[i].T[5].F := ObjZv[i].T[5].F - delta;
      end;
      LastSync := ndt;
      LastTime := ndt;
    end;
    //------------------------------------------------------------------ сбросить параметр
    FR8 := 0;
  end;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------------------- проход по буферу отображения
procedure GoOVBuffer(Ptr,Steps : Integer);
var
  LastStep, cPtr : integer;
begin
  LastStep := Steps;
  cPtr := Ptr;
  while LastStep > 0 do  StepOVBuffer(cPtr,LastStep);
end;

//========================================================================================
//------------------------------------------------------ Сделать шаг по буферу отображения
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
var
  oPtr : integer;
begin
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
        Ptr := OVBuffer[Ptr].Jmp2;
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
        if not ObjZv[OVBuffer[oPtr].DZ1].bP[2] then   //------------------ не МК стрелки
        begin
          if ObjZv[OVBuffer[oPtr].DZ1].bP[1] then  //------------------- есть ПК стрелки
          begin
            if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24] //если Мест.упр.
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

          if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24]//--------- стрелка на МУ
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

          OVBuffer[Ptr].Param[5] :=OVBuffer[oPtr].Param[5];//копировать маршрутное "З"
          OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7]; //------- копировать "РИ"

          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //---------- копировать МСП
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //-- копировать подсветку
        end;

        if ObjZv[OVBuffer[oPtr].DZ1].bP[7] or //-если активно управление МУ или ...
        (ObjZv[OVBuffer[oPtr].DZ1].bP[10] and //----- первый проход по трассе и ...
        ObjZv[OVBuffer[oPtr].DZ1].bP[11]) or //---- второй проход по трассе или ...
        ObjZv[OVBuffer[oPtr].DZ1].bP[13] then //--------------- пошерстная в минусе
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
        if not ObjZv[OVBuffer[oPtr].DZ1].bP[1] then //----------------- если нет ПК
        begin
          if ObjZv[OVBuffer[oPtr].DZ1].bP[2] then //------------------ если есть МК
          begin
            if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24] // стрелка на МУ
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
          if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24]//--------- если МУ
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
          OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];  //------------ копия "З"
          OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];  //----------- копия "РИ"
          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];   //------------- копия МСП
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //------- копия подсветки
        end;

//------------------------------------------------------- не зависимо от положения стрелки
//      if not ObjZv[OVBuffer[oPtr].DZ1].bP[3] then //---------------- если не "Вз"
//      OVBuffer[Ptr].Param[10] := false;

        if ObjZv[OVBuffer[oPtr].DZ1].bP[6] or // если активно управление ПУ или ...
        (ObjZv[OVBuffer[oPtr].DZ1].bP[10] and //--- первый проход трассировки и ...
        not ObjZv[OVBuffer[oPtr].DZ1].bP[11]) or //не второй проход трассировки или
        ObjZv[OVBuffer[oPtr].DZ1].bP[12] then //---- пошерстная в плюсе по маршруту
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
end;

//========================================================================================
//-------- перенести в хвост стрелки признаки программного замыкания (нужно для спаренной)
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
var
  Xstr, str1, str2 : Integer;
begin
  Xstr := ObjZv[ptr].BasOb; //----------------------------------------- хвост стрелки
  str1 := ObjZv[Xstr].ObCI[8]; //------------------- спаренная стрелка (тип2) ближняя
  Str2 := ObjZv[Xstr].ObCI[9]; //------------------- спаренная стрелка (тип2) дальняя
  if ObjZv[ptr].bP[14] then ObjZv[Xstr].bP[14] := true //- стрелка замкнута,замкнуть хвост
  else
  begin //------------------- если нет замыкания стрелки - проверить условия для спаренной
    if ObjZv[Xstr].ObCI[9] = 0 then ObjZv[Xstr].bP[14] := false //--------- одиночная
    else
    begin //-------------------------------------------------------------------- спаренная
      if ObjZv[Xstr].ObCI[8] = ptr then //-- вышли на хвост через разомкнутую ближнюю
      begin
        if not ObjZv[str2].bP[14] then ObjZv[Xstr].bP[14] := false; //- дальняя разомкнута
      end else
      begin //-------------------------------------------- вышли через разомкнутую дальнюю
        if not ObjZv[str1].bP[14] then  ObjZv[Xstr].bP[14] := false; // ближняя разомкнута
      end;
    end;
  end;
end;

//========================================================================================
//---------------------------------- Обработка диагностики о неисправностях аппаратуры УВК
procedure DiagnozUVK;
var
  u,m,p,o,z,c : int64;
  t : boolean;
  msg,ii : Integer;
begin
  c := FR7;
  if NenormUVK[1] <> c then
  begin
    if c > 0 then
    begin
      u := c and $f0000000; u := u shr 28;  //---------------------- получить номер стойки
      m := c and $0c000000; m := m shr 26;  //----------------- получить номер контроллера
      o := c and $ff0000;   o := o shr 16;  //--------- получить номер выставленной группы
      z := c and $ffff;  //-------------------------------------- получить принятые группы

      if (u > 0) and (m > 0) and (o > 0) then
      begin
        s := 'УВК' + IntToStr(u)+ ' МПСУ' + IntToStr(m);
        s := s + '. на группу' + IntToStr(o) + ' принят адрес ' + IntToHex(z,4);
        AddFixMes('Сообщение диагностики '+ s,4,4);
        DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
        s := dt + ' > '+ s;
        ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
        NewNeisprav := true; SBeep[4] := true;
        InsNewMsg(0,$3003,1,'');
      end else
      begin //--------------------------------------------------- Неопределенное сообщение
        InsNewMsg(0,508,1,'');
        AddFixMes(GetSmsg(1,508,'',1),4,4);
      end;
      FR7 := 0; // Сбросить обработанное сообщение
    end;
  end else
  begin
    if NenormUVK[1] = FR7 then exit else NenormUVK[1] := FR7;
    if NenormUVK[2] = FR9 then exit else NenormUVK[2] := FR9;
    c := FR7;
    if c > 0 then
    begin
      s := 'Неисправен датчик ';
      if ii < 10 then
      begin
        s := s + NameGrup[ii];
        if c = 1 then s := s +'1' else s := s + '2';
      end else
      begin
        if ii >= 21 then exit;
        if c = 1 then s := s + NameO1[ii-9]  else s := s + NameO2[ii-9];
      end;
      AddFixMes('Сообщение диагностики '+ s,4,4);
      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
      s := dt + ' > '+ s;
      ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
      NewNeisprav := true; SBeep[4] := true;
      z := ii shl 8;
      z := z or c;
      InsNewMsg(z,3008,1,'');
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------ Получить РМ из маневровой колонки
function Get_ManK(Ptr : SmallInt) : Boolean;
begin
  // признак разрешения маневров (без учета нажатия кнопки восприятия маневров на колонке)
  //-------------------------------------------------------- результат равен РМ и не ОИ(Д)
  result := ObjZv[Ptr].bP[1] and  not ObjZv[Ptr].bP[4];
end;

//========================================================================================
//---------------------------------------- подготовка объектов зависимостей для прорисовки
procedure PrepareOZ;
var
  c,Ptr,ii,k,l,jj,i,j,cfp: integer;
  s : string;
  st : byte;
  fix,fp,fn : Boolean;
begin
  c := 0; k := 1;
  SetDateTimeARM;  //-------------- Отработать команду синхронизации времени
  if DiagnozON then DiagnozUVK;//------------- Обработать диагностику о неисправностях УВК

  //---- НЕПАРАФАЗНОСТИ ##################################################################
  if NewFr6 <> OldFr6 then //------------- если обнаружена новая непарафазность в датчиках
  begin
    if NewFr6 > 0 then
    begin
      s :=  'Неисправен датчик ';   ii :=  NewFr6 and $FF;
      for l := 0 to 7 do
      begin
        k := 1 shl l;    c :=  ii and k;
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

        if NewFr6 > 0 then //--------------------- сохранить имя неисправного бита объекта
        begin
          jj := (NewFr6 shr 8)*8 + k; s := s+LinkFr[jj].Name+';';
          InsNewMsg(jj,$3010,1,'');
        end;
      end;
      OldFr6 := NewFr6;
      AddFixMes('Сообщение диагностики '+ s,4,4);
      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime); s := dt + ' > '+ s;
      ListDiagnoz := s + #13#10 + ListDiagnoz;
      NewNeisprav := true;  SBeep[4] := true;
      OldFr6 := NewFr6;
    end;
  end;

{$IFNDEF RMARC}
  //------------------------------------------------------------ копировать буфера FR3,FR4
  if DiagnozON and WorkMode.FixedMsg then
  begin //-------------------------- выполнить проверку непарафазности входных интерфейсов
    for Ptr := 1 to FR_LIMIT do
    begin
      if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
      begin  //------------- если не объект реконфигурации и не объект управления сервером
        st := byte(FR3inp[Ptr]);
        if (st and $20) <> (FR3[Ptr] and $20) then //-- Проверить изменение непарафазности
        begin
          if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4])
          and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr<> MYT[8])
          and (Ptr <> MYT[9]) then
          begin //----------------- если объекты канала не относятся к мифам - фиксировать
            if ((st and $20) <> $20)  then
            begin
              InsNewMsg(Ptr,$3002,7,''); //- "зафиксир.восстановление входного интерфейса"
              FR6[Ptr]:=0;  NewFR6 :=0;  OldFr6 := 0;
            end else InsNewMsg(Ptr,$3001,1,'');// зафикс.неисправность входного интерфейса
          end;
        end;
        FR3[Ptr] := st;
      end;
      if FR4inp[Ptr] > char(0) then FR4s[Ptr] := LastTime;
    end;
  end else
  begin //------------ если диагностика не фиксируется, то просто переписать входной буфер
{$ENDIF}
    for Ptr := 1 to FR_LIMIT do
    begin {$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}  end;
{$IFNDEF RMARC}
  end;
  //-------------------------------------------------------------- сбросить блокировку FR5
  if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

  //########################################### подготовка исходных состояний перед циклом
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    for ii := 1 to 32 do OVBuffer[ObjZv[ptr].VBufInd].Param[ii] := false;
    case ObjZv[Ptr].TypeObj of
      1 :  //----------------------------------------------------- в хвосте каждой стрелки
      begin
        ObjZv[Ptr].bP[5] := false; //----------------- снять  требование перевода охранной
        ObjZv[Ptr].bP[8] := false; //------------ снять признак ожидания перевода охранной
        ObjZv[Ptr].bP[10] := false;//------ снять ПСМИ(исключить перевод в + при маневрах)
        ObjZv[Ptr].bP[11] := false;//------ снять МСМИ(исключить перевод в - при маневрах)
      end;

      27 : //------------------------------- обработка объекта дополнительных зависимостей
      begin
        ObjZv[Ptr].bP[5] := false; //------------------ снять требование перевода охранной
        ObjZv[Ptr].bP[8] := false; //------------ снять признак ожидания перевода охранной
      end;

      41 : //-------------------------------------------- объект охранности стрелок в пути
      begin
        ObjZv[Ptr].bP[1] := false; //----------------- снять признак перевода 1-ой стрелки
        ObjZv[Ptr].bP[2] := false; //----------------- снять признак перевода 2-ой стрелки
        ObjZv[Ptr].bP[3] := false; //----------------- снять признак перевода 3-ей стрелки
        ObjZv[Ptr].bP[4] := false; //----------------- снять признак перевода 4-ой стрелки
        ObjZv[Ptr].bP[8] := false; //---------------- снять признак ожидания перевода 1-ой
        ObjZv[Ptr].bP[9] := false; //---------------- снять признак ожидания перевода 2-ой
        ObjZv[Ptr].bP[10] := false;//---------------- снять признак ожидания перевода 3-ей
        ObjZv[Ptr].bP[11] := false;//---------------- снять признак ожидания перевода 4-ой
      end;

      44 : //--------------------------------------------- исключение стрелки при маневрах
      begin
        ObjZv[Ptr].bP[1] := false; //-------------------  снять исключение перевода в плюс
        ObjZv[Ptr].bP[2] := false; //------------------- снять исключение перевода в минус
        ObjZv[Ptr].bP[5] := false; //------------------ снять требование перевода охранной
        ObjZv[Ptr].bP[8] := true; //-------------- установить ожидание перевода охранной
      end;

      48 : ObjZv[Ptr].bP[1] := false; //РПО ----------- снять разрешение маневров в районе
    end;
  end;

  //------------------------------------------------------ подготовка отображения на табло
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
  //  1 : --------------------------------------------- хвост стрелки обрабатывается далее
  //  2 : --------------------------------------------------- стрелка обрабатывается далее
      3  : PrepSekciya(Ptr);//----------------------------------------------------- секция
      4  : PrepPuti(Ptr); //--------------------------------------------------------- путь
//    5 : --------------------------------------------------- сигнал обрабатывается дальше
      6  : PrepPTO(Ptr);       //----------------------------------------- ограждение пути
      7  : PrepPriglasit(Ptr); //---------------------------------- пригласительный сигнал
      8  : PrepUTS(Ptr);  //----------------------------------------- тормозной упор (УТС)
      9  : PrepRZS(Ptr);  //------------------------------------- ручное замыкание стрелок
      10 : PrepUPer(Ptr); //----------------------------------------- управление переездом
      11 : PrepKPer(Ptr); //------------------------------------- контроль переезда (тип1)
      12 : PrepK2Per(Ptr);//------------------------------------- контроль переезда (тип2)
      13 : PrepOM(Ptr);  //------------------------------------------- оповещение монтеров
      14 : PrepUKSPS(Ptr); //--------------------------- контроль схода подвижного состава
      15 : PrepAB(Ptr);    //------------------------------------ увязка с автоблокировкой
      16 : PrepVSNAB(Ptr); //-------------------------- вспомогательная смена направлвения
      17 : PrepMagStr(Ptr);//--------------------------------------- стрелочная магистраль
      18 : PrepMagMakS(Ptr); //--------------------------------- магистраль макета стрелок
      19 : PrepAPStr(Ptr); //----------------------------------- аварийный перевод стрелок
      20 : PrepMaket(Ptr); //----------------------------------------------- макет стрелки
      21 : PrepOtmen(Ptr); //----------------------------------- комплект отмены маршрутов
      22 : PrepGRI(Ptr); //---------------------------------------- искусственная разделка
      23 : PrepMEC(Ptr); //------------------------------- Подготовка объекта увязки с МЭЦ
      24 : PrepZapros(Ptr); //-------------- Подготовка объекта увязки с запросом согласия
      25 : PrepManevry(Ptr); //--------------------- Подготовка объекта маневровой колонки
      26 : PrepPAB(Ptr); //--------------------------------- полуавтоматическая блокировка
//    27 : ------------------------------------------ ДЗ для стрелки обрабатывается дальше
//    28 : PrepPI(Ptr) ------------------------------ не требует предварительной обработки
//    29 : -------------------------------- ДЗ для СП не требует предварительной обработки
      30 : PrepDSPP(Ptr); //-------------------------------- объекта дачи поездного приема
      31 : PrepPSvetofor(Ptr); //----------------------------------- повторитель светофора
      32 : PrepNadvig(Ptr);   //--------------------------------- увязка с горкой (надвиг)
      33 : PrepSingle(Ptr);     //------------------------------ объект - одиночный датчик
      34 : PrepPitanie(Ptr); //----------------------------------- объект электроснабжения
      35 : PrepInside(Ptr); //-------- Доступ к внутренним параметрам объекта зависимостей
      36 : PrepSwitch(Ptr);      //-------------------------- объект - кнопка + 5 датчиков
      37 : PrepIKTUMS(Ptr);       //-------------- объект - исполнительный контроллер ТУМС
      38 : PrepMarhNadvig(Ptr); //---------------------------------------- надвиг на горку
      39 : PrepKRU(Ptr); //------------------------------------ комплект режима управления
      40 : PrepIzvPoezd(Ptr);  //------------------------------------ поездной известитель
//    41 : ------------------------------------------- стрелка в пути обрабатывается далее
      42 : PrepVP(Ptr); //----------------------------------- перезамыкание стрелки в пути
      43 : PrepOPI(Ptr);  //------------------------ исключение пути из маневрового района
      45 : PrepZon(Ptr); //--------------------- Подготовка объекта выбора зоны оповещения
      46 : PrepAutoSvetofor(Ptr); //------------------------------- автодействие светофора
      48 : PrepRPO(Ptr); //------------- разрешение приема/отправления в маневровом районе
      49 : PrepABTC(Ptr);
      50 : PrepDCSU(Ptr);
      51 : PrepDopDat(Ptr);
      52 : PrepSVMUS(Ptr);
//    53 : ------------------------ Сборка трассы МУС не требует предварительной обработки
      54 : PrepST(Ptr);    //-------------------------------------------- сигнальная точка
      55 : PrepDopSvet(Ptr);
      56 : PrepUKG(Ptr); //------------------------ объект "Устройство контроля габаритов"
      60 : PrepRDSH(Ptr); //--------------------- объект "Релейный дешифратор контроллера"
      92 : PrepDN(Ptr); //--------------------------------------------- объект "День-Ночь"
    end;
    inc(c);
    if c > 500 then c := 0;
  end;

  //-------------------------------------------------------- обработка вторичных состояний
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
  end;


  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      2  : PrepOxranStrelka(Ptr);
      27 : PrepDZStrelki(Ptr);
    end;
  end;

  //--------------------------------------------- Вывод на табло охранностей стрелки и др.
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      2  : PrepStrelka(Ptr);
      41 : PrepVPStrelki(Ptr);
      43 : PrepSOPI(Ptr);
      47 : PrepAutoMarshrut(Ptr);
    end;
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
  begin //---------------------------------------------------------------------- с кнопкой
    if (SrvState and $7) = 0 then
    begin //--------------------------------------- неисправность кнопки выбора управления
      SrvCount := 1;
      WorkMode.RUError := WorkMode.RUError or $4;
    end else
    begin //----------------------------------------- исправность кнопки выбора управления
      SrvCount := 2;
      WorkMode.RUError :=  WorkMode.RUError and $FB;
    end;
    //--------------------------------------------------------------- номер рабочего места
    if SrvState and $30 = $10 then SrvActive := 1 else
    if SrvState and $30 = $20 then SrvActive := 2 else
    if SrvState and $30 = $30 then SrvActive := 3 else
    SrvActive := 0;
  end else
  begin //--------------------------------------------------------------------- на сервере
    //---------------------------------------------------------------- количество серверов
    if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or
    ((SrvState and $7) = 0) then SrvCount := 1
    else
    if (SrvState and $7) = 7 then SrvCount := 3 else SrvCount := 2;
    //------------------------------------------------------------ номер активного сервера
    if ((LastRcv + MaxTimeOutRecave) > LastTime) then
    begin
      if (SrvState and $30) = $10 then SrvActive := 1
      else
      if (SrvState and $30) = $20 then SrvActive := 2
      else
      if (SrvState and $30) = $30 then SrvActive := 3 else SrvActive := 0;
    end else SrvActive := 0;
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
    if FixNotify[i].Enable and
    ((FixNotify[i].Datchik[1]>0) or (FixNotify[i].Datchik[2]>0) or
    (FixNotify[i].Datchik[3]>0) or (FixNotify[i].Datchik[4]>0)
    or (FixNotify[i].Datchik[5] > 0) or (FixNotify[i].Datchik[6] > 0)) then

    for j := 1 to 6 do
    if FixNotify[i].Datchik[j] > 0 then
    begin
      fp := GetFR3(LinkFR[FixNotify[i].Datchik[j]].FR3,fn,fn);//-------- состояние датчика
      fix := (FixNotify[i].State[j] = fp) and not fn;
      if fix then inc(cfp);
    end;

    if cfp > 0 then
    begin //---------------------------------------------------- выдать реакцию на событие
      for k := 1 to 6 do if FixNotify[i].Datchik[k] > 0 then dec(cfp);

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
      end else FixNotify[i].fix := false;
    end else  FixNotify[i].fix := false;
  end;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------- Подготовка объекта хвоста стрелки #1
procedure PrepXStrelki(Xstr : Integer);
var
  i, oDZ, kSP, kST, p, str_1, str_2, sp_1, sp_2, RMU, grp : integer;
  pk,mk,pks,nps,d,bl : boolean;
  {$IFDEF RMSHN} dvps : Double; {$ENDIF}   //--------------- длительность перевода стрелки
begin
  with ObjZv[Xstr] do
  begin
    str_1 := ObCI[8]; str_2 := ObCI[9];//-- 1 стрелка хвоста(ближ),2 стрелка хвоста (даль)
    sp_1 := ObjZv[str_1].UpdOb; //---------------------------- СП первой стрелки (ближней)
    if str_2 > 0 then sp_2 := ObjZv[str_2].UpdOb  //---------- СП парной стрелки (дальней)
    else sp_2 := 0;

    grp := Group; //----------------------------------------------------------- группа КРУ

    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false;//----------------------------------------------------- Непарафазность

    pk  := GetFR3(ObCI[2],bP[32],bP[31]); //------------------------------------------- ПК
    mk  := GetFR3(ObCI[3],bP[32],bP[31]); //------------------------------------------- МК
    nps := GetFR3(ObCI[4],bP[32],bP[31]); //------------------------- непостановка стрелки
    pks := GetFR3(ObCI[5],bP[32],bP[31]); //---------------------- потеря контроля стрелки

    if bP[31] and not bP[32] then  //----------- если парафазность и активность информации
    begin
{$IFDEF RMSHN}  //------------------------------------------------------------ для АРМа ШН
      if not(pk or mk or pks or T[1].Activ or T[2].Activ) then
      begin //---------------------------------- нет ПК, МК, ПКС, не активны таймеры 1 и 2
        //----------------------- предыдущее положение "минус" , фиксируем время потери МК
        if sbP[2] then begin T[2].Activ  := true; T[2].F := LastTime; end;
        //-------------------- если предыдущее положение "плюс", фиксируем время потери ПК
        if sbP[1] then  begin  T[1].Activ  := true;  T[1].F := LastTime; end;
      end;
{$ENDIF}
      if pk and mk then begin  pk := false; mk := false; end; // сбросить ПК и МК если оба

      if (bP[25] <> nps) and nps then // изменился бит неперевода стрелки и есть неперевод
      begin
        if WorkMode.FixedMsg then
        begin //---------------- время события "неперевод стрелки", увеличить счет событий
{$IFDEF RMSHN} InsNewMsg(Xstr,270+$1000,1,'');dtP[2] := LastTime; inc(siP[3]);
{$ELSE}
          if config.ru = RU then
          begin //------------------------------------------- "стрелка <Xstr> не переведа"
            InsNewMsg(Xstr,270+$1000,1,'');
            AddFixMes(GetSmsg(1,270,Liter,1),4,1);
          end;
{$ENDIF}
        end;
      end;
      bP[25] := nps;  //------------------------------ бита неперевода вписать в параметры

      for i := 6 to 7 do
      begin
        d := false;
        oDZ := ObCI[i];  //------------------------- берем индекс для возможного района МУ
        if oDZ > 0 then //---- если стрелка имеет связь с МУ проверить передачу управления
        case ObjZv[oDZ].TypeObj of //--------------------- переключиться по типу района МУ
          25: d:= Get_ManK(oDZ); //------------- если маневровая колонка, то получить РМ&Д
          44: d:= Get_ManK(ObjZv[oDZ].BasOb);//---------------- исключ. из маневров - РМ&Д
        end;
        if d then break;
      end;

      //-- если РМ, то ставим признак "местн.управл", если нет РМ, то снимаем признак "МУ"
      if d then bP[24] := true else bP[24] := false;

      if bP[26] <> pks then //---------------------  изменился бит потери контроля стрелки
      begin
        if pks then //----------------------------------- получена потеря контроля стрелки
        begin
{$IFDEF RMSHN}
          //-------------------- для АРМ ШН заполнить параметры статистики потери контроля
          T[1].Activ := false; T[2].Activ := false; //---- сбросить таймеры потери "+","-"
          //----------------------------- если фиксация и управление от УВК и КРУ и нет РМ
          if WorkMode.FixedMsg and WorkMode.OU[0] and WorkMode.OU[grp] and not d then
          begin// -------------------------------------------- "стрелка потеряла контроль"
            InsNewMsg(Xstr,271+$1000,0,''); SBeep[3] := true; dtP[1] := LastTime;

            //-------------------------------------------------- если стрелка была в плюсе
            if sbP[1] then  begin if bP[22] then inc(siP[1]) else inc(siP[6]);  end;

            //------------------------------------------------- если стрелка была в минусе
            if sbP[2] then begin if bP[22] then inc(siP[2]) else inc(siP[7]); end;
          end;
{$ELSE}
          if WorkMode.FixedMsg and not d and (config.ru = RU) then
          begin //-------------------------------------------- "стрелка потеряла контроль"
            InsNewMsg(Xstr,271+$1000,0,''); AddFixMes(GetSmsg(1,271,Liter,0),4,3);
          end;
{$ENDIF}
        end else //------------------------------------------- если контроль восстановился
        begin
          if WorkMode.FixedMsg and not d then//- "восстановлен контроль положения стрелки"
          begin
{$IFDEF RMSHN} InsNewMsg(Xstr,345+$1000,0,''); SBeep[2] := true;
{$ELSE}
            if config.ru = RU then
            begin
             InsNewMsg(Xstr,345+$1000,0,'');AddFixMes(GetSmsg(1,345,Liter,0),5,2);
            end;
{$ENDIF}
          end;
        end;
      end;
      bP[26] := pks;

      bP[1] := pk;   bP[2] := mk;

{$IFDEF RMSHN}
      if pk then //---------------------------------------------------если стрелка в плюсе
      begin
        T[1].Activ  := false;
        if T[2].Activ then
        begin //----------------------------------- фиксируем длительность перевода в плюс
          T[2].Activ  := false; dvps := LastTime - T[2].F; //--- длительность перевода в +
          if dvps > 1/86400 then
          begin //------------------------------------ если переводов больше миним.выборки
            if siP[4] > StatStP then dvps := (dtP[3] * StatStP + dvps)/(StatStP+1)
            else  dvps := (dtP[3]*siP[4]+dvps)/(siP[4]+1);  //----------- набор статистики
            dtP[3] := dvps;
          end;
        end;
        if not sbP[1] //- была не в "+", помнить последние ПК и МК и увеличить счетчик "+"
        then begin sbP[1] := pk; sbP[2] := mk; if not StartRM then inc(siP[4]); end;
      end;

      if mk then//---------------------------------------------------если стрелка в минусе
      begin
        T[2].Activ  := false;
        if T[1].Activ  then
        begin //---------------------------------- фиксируем длительность перевода в минус
          T[1].Activ  := false; dvps := LastTime - T[1].F;//считаем время перевода в -
          if dvps > 1/86400 then
          begin
            if siP[5] > StatStP then dvps := (dtP[4] * StatStP + dvps)/(StatStP+1)
            else dvps := (dtP[4] * siP[5] + dvps)/(siP[5]+1);
            dtP[4] := dvps;
          end;
        end;
        if not sbP[2] then   //---------------------- если раньше стрелка была не в минусе
        begin
          sbP[1]:= pk; sbP[2]:= mk; //---------------------------- запомним значение ПК,МК
          if not StartRM then inc(siP[5]);//--------------- увеличить счетчик переводов  -
        end;
      end;
{$ENDIF}

      if ObCB[3] then  //-------------------- если для стрелки надо проверять МСП или МСПД
      begin //------------------------------------------------------------- сбор МСП из СП
        bP[20] :=  true;
        bP[13] :=  true;

        if ObjZv[str_1].ObCB[9] then //----- если 1-ая стрелка имеет в хвосте МСП или МСПД
        //---------------------------------------------- значения МСПД и МСП из объекта СП
        begin bP[20] :=  ObjZv[sp_1].bP[4]; bP[13] :=  ObjZv[sp_1].bP[11]; end;

        if (str_2 > 0) and ObjZv[str_2].ObCB[9] then //есть вторая стрелка и она имеет МСП
        begin
          //----------------------------- добавить в объект МСПД данные из СП 2-ой стрелки
          bP[20] := bP[20] and ObjZv[SP_2].bP[4];
          //-------------------- добавить в объект МСП автовозврата данные из СП 2 стрелки
          bP[13] := bP[13] and ObjZv[SP_2].bP[11];
        end;
      end else begin bP[20] := true; bP[13] := true; end;//-- не надо проверять МСП и МСПД

      //--------------------------------------- сбор замыканий из СП ---------------------
      d := ObjZv[sp_1].bP[2];//-------------------------- значение замыкания из СП ближней
      if (str_2 > 0) then d := d and ObjZv[SP_2].bP[2]; //добавить замыкание из СП дальней

      if d <> bP[21] then //-------------------------- если состояние замыкания изменилось
      begin
        bP[6] := false; bP[7] := false; //------------------------ сброс признаков ПУ и МУ

        //----------------------------------- перенести в признак активизации автовозврата
        bl :=  ObjZv[sp_1].bP[20];//------------ блокировка из ближней по неисправности СП
        if (str_2 > 0) then //------- если есть дальняя, добавить к  блокировке из ближней
        bl := bl or ObjZv[sp_2].bP[20]; //-------------------------------- блокировка 2-ой

        // подготовка АВ = замыкание СП и нет блокировки и  признак  АВ и стрелка в минусе
        bP[3] := bP[3] or (d and not bl and ObCB[2] and bP[2] and not bP[1]);
      end;
      bP[21] := d; //--------------------------------------- запомнить состояние замыкания

      //------------------------------------------------------------- сбор занятости из СП
      bP[22] := ObjZv[sp_1].bP[1]; //----------------------- взять занятость из ближней СП
       //- есть дальняя стрелка и не было занятости от ближней, то взять занятость дальней
      if (str_2 > 0) and bP[22] then bP[22] := ObjZv[sp_2].bP[1];

      //------------------------------------------------------ Сброс признаков трассировки
      bP[23] := false;

      //------------------------------------------ проверка передачи на местное управление
      bP[9] := false; //---------------------------------------------- сбросить признак РМ

      for i := 20 to 24 do //------------------------- пройти по 5-ти возможным районам МУ
      if ObCI[i] > 0 then //-------------- если такой район на станции существует, то
      begin
        RMU := ObCI[i]; //------------------------------ объект района местного управления
        case ObjZv[RMU].TypeObj of //------------------------ переключатель по типу района
          //----------------------------------------------------------- маневровая колонка
          25 : if not bP[9] then bP[9]:= Get_ManK(RMU);//--------- если нет РМ,то РМ= РМ&Д
           //---------------------------------------------- исключение стрелки из маневров
          44 : if not bP[9] then bP[9]:= Get_ManK(ObjZv[RMU].BasOb);
        end;
      end;

      //----------------------------------------------- Проверка дополнительного замыкания
      ObjZv[str_1].bP[4] := false; //--------------------- сброс дополнительного замыкания
      ObjZv[str_1].bP[4] := ObjZv[str_1].bP[4] or
      ObjZv[str_1].bP[33] or ObjZv[str_1].bP[25]; //--------------------- если НАС или ЧАС

      //--------------------------------------------------------- ручное замыкание стрелки
      if (ObCI[12]> 0) and ObjZv[ObCI[12]].bP[1] then ObjZv[str_1].bP[4]:= true;

      if bP[21] then //--------------------------------- если нет признака замыкания от СП
      begin
        //--------------------------------------------------- проверки двойного управления
        if not ObjZv[str_1].bP[4] then //---------------------- если нет дополн. замыкания
        for i := 6 to 7 do //------------------------- пройти по 2-ум возможным районам МУ
        begin
          RMU := ObCI[i];//-------------------------------------- взять индекс района
          if RMU > 0 then //---------------------------------- если для стрелки есть район
          begin
            if (ObjZv[RMU].TypeObj = 44) then RMU := ObjZv[RMU].BasOb;// ман. колонка
            if(ObjZv[RMU].TypeObj = 25) and not ObjZv[RMU].bP[3] then  //--------- если МИ
            begin ObjZv[str_1].bP[4] := true; break;end;
          end;
        end;

        //-------------------------------------------------------------- проверки маневров
        for i := 20 to 24 do //-------------- пройти по 5-ти возможным объектам районов МУ
        begin
          RMU := ObCI[i]; //------------------- получить очередной объект
          if RMU > 0 then
          begin
            if (ObjZv[RMU].TypeObj = 44) then RMU := ObjZv[RMU].BasOb;//----- ман. колонка
            if(ObjZv[RMU].TypeObj = 25) and not ObjZv[RMU].bP[3] then  //--------- если МИ
            begin ObjZv[str_1].bP[4] := true; break;end;
          end;
        end;


        if not ObjZv[str_1].bP[4] then//--------------- если нет дополнительного замыкания
        //-------------------------------------------------------- проверки хвоста стрелки
        for i := 14 to 19 do //--------------- пройти по 6-ти возможным объектам замыкания
        begin
          oDZ := ObCI[i];//---------------------------------------------- очередной объект
          if oDZ > 0 then //---------------------------------------- если этот объект есть
          begin
            case ObjZv[oDZ].TypeObj of //------------------- переключатель по типу объекта

              //------------------------------ СП: если замкнута, установить доп.замыкание
              3: if not ObjZv[oDZ].bP[2] then begin ObjZv[str_1].bP[4]:= true; break; end;

              //-------------------- маневровая колонка: если МИ, установить доп.замыкание
              25: if not ObjZv[oDZ].bP[3] then begin ObjZv[str_1].bP[4]:= true; break;end;

              27 ://------------------------------------ данная стрелка = охранная стрелка
              begin
                kST:=ObjZv[oDZ].ObCI[1];kSP:=ObjZv[oDZ].ObCI[2];//контрольные стрелка и СП
                if not ObjZv[kSP].bP[2] then //------ если СП контрольной стрелки замкнута
                begin
                  if ObjZv[oDZ].ObCB[1] and not ObjZv[kST].bP[2] then // контроль по плюсу
                  begin ObjZv[str_1].bP[4]:=true;break;end //нет МК, установить доп.замык.
                  else
                  if ObjZv[oDZ].ObCB[2] and not ObjZv[kST].bP[1] then //контроль по минусу
                  begin ObjZv[str_1].bP[4]:=true;break;end;//нет ПК, установить доп.замык.
                end;
              end;

              41 :  //---------------- охранность стрелки в пути для маршрутов отправления
              begin //-- если есть признак поездного отправления и контрольная СП замкнута
                kSP := ObjZv[oDZ].UpdOb;
                if ObjZv[oDZ].bP[20] and not ObjZv[kSP].bP[2] then //отправление и замкнут
                begin ObjZv[str_1].bP[4] := true; break; end;  //---------- доп. замыкание
              end;

              46 : //----------------------------------------------- автодействие сигналов
              begin //----------------------- если включено автодействие -  доп. замыкание
                if ObjZv[oDZ].bP[1] then begin ObjZv[str_1].bP[4] := true; break; end;
              end;
            end;
          end;
        end;

        //если нет дополнит.замыкания ближней стрелки, и НГ стык следует замыкать по плюсу
        //данное замыкание формируется на основе анализа наличия за НГ стыком замкнутого
        //маршрута, раз такой маршрут найдет, следовательно стрелка 
        if not ObjZv[str_1].bP[4] and (str_1 > 0) and ObjZv[str_1].ObCB[7] then
        begin
          oDZ := ObjZv[str_1].Sosed[2].Obj; p := ObjZv[str_1].Sosed[2].Pin;// сосед по "+"

          //------------------------------------------ просмотр объектов за плюсом стрелки
          i := 100;//------------ установить допустимое число шагов(более чем достаточное)
          while i > 0 do //---------------------- цикл до максимума, если не выйдем раньше
          begin
            case ObjZv[oDZ].TypeObj of //переключать по типу примыкающего объекта по плюсу
              2 : //-------------------------------------------------------------- стрелка
              begin
                case p of//----------------------- переключать по номеру точки подключения
                  //------------------------------- Вход на соседнюю стрелку через её плюс
                  2: if ObjZv[oDZ].bP[2] then break;//стрелка в отводе по минусу, прервать

                  //------------------------------ Вход на соседнюю стрелку через её минус
                  3: if ObjZv[oDZ].bP[1] then break; //--------- стрелка в отводе по плюсу

                  //------------------------------- если вышли на точку 1 соседней стрелки
                  else ObjZv[str_1].bP[4] := true; break; //- замкнуть и прервать (ошибка)
                end;
                p:= ObjZv[oDZ].Sosed[1].Pin;oDZ:= ObjZv[oDZ].Sosed[1].Obj;//сосед соседа 1
              end;

              //участок,путь: уст. доп. замыкание по состоянию замыкающего реле СП,УП,пути
              3,4 : begin ObjZv[str_1].bP[4] := not ObjZv[oDZ].bP[2]; break; end;

              else //---------------------------------- для прочих объектов простой проход
                if p = 1 then //---------------------- если подключились к точке 1 объекта
                begin p := ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
                else //-------------------- если подключились к другой точке (это точка 2)
                begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;

            if (oDZ = 0) or (p < 1) then break;  //----если 0-объект или 0-точка, то выйти
            dec(i);
          end;
        end;

        //если нет дополнительного замыкания,по ближней стрелке НГ стык замыкать по минусу
        if not ObjZv[str_1].bP[4] and (str_1 > 0) and (ObjZv[str_1].ObCB[8]) then
        begin
          oDZ:= ObjZv[str_1].Sosed[3].Obj; p:= ObjZv[str_1].Sosed[3].Pin; //---- сосед "-"

          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2 :   //------------------------------------------------------------ стрелка
              begin
                case p of
                  //------------------------------------------------ Вход со стороны плюса
                  2: if ObjZv[oDZ].bP[2] then break; //--- если стрелка в отводе по минусу

                  //----------------------------------------------- Вход со стороны минуса
                  3: if ObjZv[oDZ].bP[1] then break; //---- если стрелка в отводе по плюсу

                  else  ObjZv[str_1].bP[4] := true; break; //-------- ошибка в базе данных
                end;
                p:= ObjZv[oDZ].Sosed[1].Pin;oDZ:= ObjZv[oDZ].Sosed[1].Obj;//сосед точки №1
              end;

              //----------------------------- участок,путь - по состоянию замыкающего реле
              3,4: begin ObjZv[str_1].bP[4] := not ObjZv[oDZ].bP[2]; break; end;

              else //------------------------------------------------------ другие объекты
                if p= 1 then
                begin p:= ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
                else
                begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;

            if (oDZ = 0) or (p < 1) then break; //  ---если 0-объект или 0-точка, то выйти
            dec(i);
          end;
        end;

        //если нет дополнительного замыкания, по дальней стрелке НГ стык замыкать по плюсу
        if not ObjZv[str_1].bP[4] and (str_2>0) and ObjZv[str_2].ObCB[7] then
        begin//------------------------- взять объект со стороны "+" , № точки объекта "+"
          oDZ := ObjZv[ObCI[9]].Sosed[2].Obj; p := ObjZv[ObCI[9]].Sosed[2].Pin;

          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2 : //------------------------------------------------------ сосед = стрелка
              begin
                case p of
                  2: begin if ObjZv[oDZ].bP[2] then break;end;//выход, стрелка-сосед в "-"
                  3: begin if ObjZv[oDZ].bP[1] then break;end;//выход, стрелка-сосед в "+"
                  else ObjZv[str_1].bP[4] := true; break; //--------- ошибка в базе данных
                end;
                //------ получить № точки соседа, и самого соседа,подключенного к точке 1
                p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj;
              end;

              //------------------------- участок,путь доп. замыкание по реле участка,пути
              3,4 : begin ObjZv[str_1].bP[4]:= not ObjZv[oDZ].bP[2]; break; end;

              else //------------------------------- для всех прочих объектов продвигаться
              if p = 1 then //------------- для точки 1 взять то, что подключено к точке 2
              begin p := ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
              else//----------------------- для точки 2 взять то, что подключено к точке 1
              begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;
            if (oDZ = 0) or (p < 1) then break; //-----для 0-объекта или 0-точки завершить
            dec(i);
          end;
        end;

        //------ если нет доп.замыкания, есть дальняя стрелка и если надо замыкать по "-"
        if not ObjZv[str_1].bP[4] and (str_2 > 0) and (ObjZv[str_2].ObCB[8]) then
        begin   //------------------------------ сосед за минусом? точка соседа за минусом
          oDZ := ObjZv[ObCI[9]].Sosed[3].Obj; p := ObjZv[ObCI[9]].Sosed[3].Pin;
          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2: //--------------------------------------------------------------- стрелка
              begin
                case p of
                  2:begin if ObjZv[oDZ].bP[2] then break;end;//вход по "+",а стрелка в "-"
                  3:begin if ObjZv[oDZ].bP[1] then break;end;//вход по "-",а стрелка в "+"
                  else ObjZv[str_1].bP[4] := true; break; //--------- ошибка в базе данных
                end;
                p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj;
              end;

              3,4: begin ObjZv[str_1].bP[4]:= not ObjZv[oDZ].bP[2];break;end;//СП,П по ЗАМ

              else if p = 1 then
              begin p:= ObjZv[oDZ].Sosed[2].Pin; oDZ:= ObjZv[oDZ].Sosed[2].Obj; end
              else begin p:= ObjZv[oDZ].Sosed[1].Pin; oDZ:= ObjZv[oDZ].Sosed[1].Obj;end;
            end;
            if (oDZ = 0) or (p < 1) then break;
            dec(i);
          end;
        end;
      end;
{$IFDEF RMDSP}
      //-------------------------- ПРОВЕРКА УСЛОВИЙ АВТОВОЗВРАТА -------------------------
      if ObCB[2] then //------------------------------------- если стрелка с автовозвратом
      begin
        if bP[3] then //--------------------------------------- если есть размыкание из СП
        begin
          bP[3] := false; //------------------------------------------ сбросить размыкание
          //------------------------------------- блокировать автовозврат при запуске АРМа
          if StartRM then begin ObjZv[str_1].T[1].Activ := false; end else
          //-------------------- нет плюса, есть минус, есть управление, есть ОУ, есть КРУ
          if not bP[1] and bP[2] and WorkMode.Upravlenie and WorkMode.OU[grp] then
          begin //-------------------- возбудить признак активизации проверки автовозврата
            //-------------------- активировать признак автовозврата и таймер перевода в +
            bP[12] := true; ObjZv[str_1].T[1].Activ  := true;
            //--------------- в СП включен таймер автовозврата, копировать время в стрелку
//            if ObjZv[sp_1].T[2].F > 0 then ObjZv[str_1].T[1] := ObjZv[sp_1].T[2];
          end;
        end else //если нет размыкания или уже выполнено,проверить допустимость команды АВ
        if bP[12] and not bP[1] and bP[2] and //------------ взведен АВ и нет ПК и есть МК
        not ObjZv[str_1].bP[4] and not bP[8] and //нет доп.зам. и не ожидает перевода в ОП
        not bP[14] and not bP[18] and // стрелка не в трассе, не отключена от управления и
        not bP[19] and bP[13] and //-- стрелка не на макете,окончилась выдержка МСП для АВ
        bP[20] and bP[21] and bP[22] and //------- нет МСПД и нет замыкания и занятости СП
        not bP[23] and not bP[9] and not bP[10] and not bP[24]//не охр.трассы,нет РМ,МИ,МУ
        then
        begin
          if ObjZv[ObCI[10]].bP[3] then //-------------------- если ЛАР магистрали стрелок
          begin //--- есть авария питания рельсовых цепей - сброс активизации автовозврата
            bP[12]:= false;
            ObjZv[str_1].T[1].Activ:= false;
            ObjZv[sp_1].T[2].Activ:= false;
          end else
          begin //--------------------------------------- исправно питание рельсовых цепей
            d := not bP[19]; //----------------------------------------------------- макет
            if d then d := not bP[15]; //- если макет не установлен в АРМ, взять макет FR4

            if d then d := not ObjZv[ObCI[8]].bP[18]; //------- выключение из ближней
            // если нет запретов для стрелки //---- не 1-ый ход трасс и
            if d then
            d := not ObjZv[str_1].bP[10] and not ObjZv[str_1].bP[12] and not ObjZv[str_1].bP[13];

          if str_2 > 0 then //--------------------------------------- есть дальняя стрелка
          begin
            if d then //-------------------------------------- если не было ранее запретов
            d := not ObjZv[str_2].bP[18]; //----- нет выключение упр-ия

            if d then //------------------------------------------------ если нет запретов
            d := not ObjZv[str_2].bP[10] and not ObjZv[str_2].bP[12] and not ObjZv[str_2].bP[13];
          end;
          
          if d and //------------------------------------- если нет запретов для стрелки и
          ObjZv[str_1].T[1].Activ and (T[1].F < LastTime) then   //---------- прошло время
          begin
            //------------ если нет раздельных команд для передачи и не нажата кнопка ОК и
            if (CmdCnt = 0) and not WorkMode.OtvKom and not WorkMode.VspStr and
            not WorkMode.GoMaketSt and  WorkMode.Upravlenie and //управление от АРМа ДСП и
            not WorkMode.LockCmd and not WorkMode.CmdReady and WorkMode.OU[grp] then
            begin // есть признак активизации автовозврата и нет ожидающих команд в буфере
              bP[12] := false; ObjZv[str_1].T[1].Activ := false; //---- сброс автовозврата
              //---------------------------- послать команду автовозврата стрелки в сервер
              if  SendCommandToSrv(ObCI[2] div 8, _strautorun,Xstr)
              then AddFixMes(GetSmsg(1,418, Liter,7),5,5);//"выдана команда перевода стрелки в охранное положение"

            end;
          end;
        end;
      end;
    end else //------------------------------ если для стрелки не предусмотрен автовозврат
    begin //--------------------------------- не фиксируется размыкание стрелочной секции,
          //--------------------------------------- если нет признака автовозврата стрелки
      bP[3] := false;
      bP[12] := false;
      ObjZv[str_1].T[1].Activ  := false;
    end;
{$ENDIF}
  end else
  begin //------------------------------------ потерять контроль при отсутствии информации
    bP[1] := false;
    bP[2] := false;
    bP[3] := false;
{$IFDEF RMSHN}
    bP[19] := false;
{$ENDIF}
  end;

  {FR4}

  bP[18] := GetFR4State(ObCI[1]-5);//--------------------------- выключено управление
  bP[15] := GetFR4State(ObCI[1]-4);//------------------------------------------ макет
  bP[16] := GetFR4State(ObCI[1]-3);//--------------------------- закрыто движ.ближняя
  bP[17] := GetFR4State(ObCI[1]-2);//--------------------------- закрыто движ.дальняя
  bP[33] := GetFR4State(ObCI[1]-1); //---------------------------- закрыта ПШ ближняя
  bP[34] := GetFR4State(ObCI[1]); //------------------------------ закрыта ПШ дальняя
  end;
end;

//========================================================================================
//------------------- Подготовка объекта стрелки в качестве охранной для вывода на табло 2
procedure PrepOxranStrelka(StrOh : Integer);
var
  s1,s2,VBuf,Xstr : Integer;
begin
  with ObjZv[StrOh] do
  begin
    VBuf := VBufInd;   Xstr := BasOb;
    //---------------------------- 1ый или 2ой проход трассировки или пошерстная (+ или -)
    if bP[10] or bP[11] or bP[12] or bP[13] then
    begin
      OVBuffer[VBuf].Param[6] := false; //--------------------- охранность на зкране снять
      OVBuffer[VBuf].Param[5] := false; //------------------------- признак перевода снять
      exit;
    end else
    begin
      if ObjZv[StrOh].bP[5] = false then //--------- если нет требования перевода охранной
      begin
        s1 := ObjZv[Xstr].ObCI[8]; //-------------- получить объект 1-ой стрелки (ближней)
        s2 := ObjZv[Xstr].ObCI[9]; //-------------- получить объект 2-ой стрелки (дальней)

        if (s2 > 0) and (s2 <> StrOh) then  //----- если есть дальняя стрелка и она другая
        begin
          //------------------------------ 1й или 2й проход или пошерстная (по + или по -)
          if(ObjZv[s2].bP[10] or ObjZv[s2].bP[11] or ObjZv[s2].bP[12] or ObjZv[s2].bP[13])
          then  OVBuffer[VBuf].Param[6] := true //-------- охранность на зкране установить
          else OVBuffer[VBuf].Param[6] := false; //------ иначе охранность на экране снять
        end else
        if (s1 > 0) and (s1 <> StrOh) then  //-- если есть ближняя стрелка и она другая
        begin
          if(ObjZv[s1].bP[10] or ObjZv[s1].bP[11] or ObjZv[s1].bP[12] or ObjZv[s1].bP[13])
          then OVBuffer[VBuf].Param[6] := true
          else OVBuffer[VBuf].Param[6] := false;
        end
        else  OVBuffer[VBuf].Param[6] := false; //------- иначе охранность на экране снять
      end
      else  OVBuffer[VBuf].Param[6] := true;
    end;
  end;
  //------------------- Подсветка ожидания перевода стрелок, не входящих в трассу маршрута
  //--------------------------------------------------- если программное замыкание стрелки
  if ObjZv[Xstr].bP[14] then OVBuffer[VBuf].Param[5]:= false //- снять требование перевода
  else OVBuffer[VBuf].Param[5]:=ObjZv[Xstr].bP[8];//-------------- треб.перевода из хвоста
end;

//========================================================================================
//---------------------- Подготовка объекта "маршрут через стрелку" для вывода на табло #2
procedure PrepStrelka(Str : Integer);
var
  i, ohr, ob, p, DZ, SPohr, SPstr, VBuf, Xstr, rzs, Maket_str, Mag_str, grp  : integer;
  text : string;
begin
  with ObjZv[Str] do
  begin
    Dz := 0;
    VBuf      :=  VBufInd;
    Xstr      :=  BasOb;  //------------------------------------------------ хвост стрелки
    SPstr     :=  UpdOb; //---------------------------------------------------- СП стрелки
    Mag_str   :=  ObjZv[Xstr].ObCI[11]; //------------------------------ магистраль макета
    Maket_str :=  ObjZv[Mag_str].BasOb; //---------------------------------- макет стрелки
    grp       :=  Group;

    OVBuffer[VBuf].Param[16] := ObjZv[Xstr].bP[31]; //------------------------- активность
    OVBuffer[VBuf].Param[1] := ObjZv[Xstr].bP[32];//------------------------- парафазность

    //---------------------------------------------------------------- ПК,  МК, РЗ стрелок
    bP[1] := ObjZv[Xstr].bP[1]; bP[2] := ObjZv[Xstr].bP[2]; rzs := ObjZv[Xstr].ObCI[12];

    bP[4] := false; //-------------------------------------- считаем что доп.замыкания нет

    if ObjZv[Xstr].bP[8] then  bP[4] := ObjZv[Xstr].bP[8];//------------- Замыкание хвоста
    bP[4] := bP[4] or bP[33] or bP[25]; //---------------------------------------- ЧАС/НАС

    //--------------------------------------- если есть РЗС или АВТОД-отобразить на экране
    if ObjZv[rzs].bP[1] or bP[33] or bP[25] then  OVBuffer[VBuf].Param[7] := true
    else //--------------------------------------- иначе, если oбъект СП стрелки разомкнут
    if ObjZv[SPstr].bP[2] then OVBuffer[VBuf].Param[7] := bP[4] //дополнительное замыкание
    else OVBuffer[VBuf].Param[7] := false; //---- иначе не отображать допол. замык.стрелки

    if not ObjZv[Xstr].bP[31] or ObjZv[Xstr].bP[32] then // недостоверность или НПФ хвоста
    begin  //---------------------------------------- сбросить  видеоинформацию по стрелке
      OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := false; //-- нет ПК и МК
      OVBuffer[VBuf].Param[8] := false; //----------------- нет охранности с автовозвратом
      OVBuffer[VBuf].Param[9] := false; //----------------- нет охранности с автовозвратом
      OVBuffer[VBuf].Param[10] := false;//----------------- нет охранности с автовозвратом
      OVBuffer[VBuf].Param[12] := false;//---------------------------- нет выдержки МСП(Д)
    end else
    begin

      bP[9] := ObjZv[XStr].bP[9]; //-------- признак разрешения маневров из хвоста стрелки

      if not WorkMode.Upravlenie then
      begin
        ObjZv[XStr].T[3].Activ:= false; ObjZv[XStr].T[3].F:= 0; //------------------ макет
      end;

      //========================= Р А Б О Т А  С  М А К Е Т О М  =========================
      if ({$IFDEF RMDSP}(XStr = maket_strelki_index) or {$ENDIF} // для ДСП если на макете
      ObjZv[XStr].bP[24]) and not WorkMode.Podsvet then //---- или если МУ и нет подсветки
      begin //- включен макет стрелки или местное управление - не рисовать остряки стрелки
        if not WorkMode.Upravlenie or (ObjZv[XStr].T[3].F <> 0) then
        begin //---------------- если не управляющий АРМ или была выдача команд для макета
          if not WorkMode.Upravlenie or (LastTime > ObjZv[XStr].T[3].F) then
          begin //---------------------- если не управляющий АРМ или макету пора исполнить
            if not WorkMode.Upravlenie or (ObjZv[XStr].iP[5] = _strmakplus) then
            begin //------------------ если не управляющий АРМ или переводили макет в плюс
              if not ObjZv[Maket_str].bP[4] and ObjZv[Maket_str].bP[3] and //- МПК без ММК
              (not ObjZv[XStr].bP[2] and ObjZv[XStr].bP[1]) then //------------- ПК без МК
              begin
                //---------------------------- стрелка на макете в плюсе - сбросить таймер
                ObjZv[XStr].T[3].Activ := false;  ObjZv[XStr].T[3].F := 0;
                ObjZv[XStr].bP[4] := ObjZv[XStr].bP[5]; //биты установки макета совместить
              end else
              begin
                if ObjZv[XStr].T[3].Activ then  //------------ макетная стрелка не в плюсе
                begin
                  InsNewMsg(XStr,577+$2000,0,'');//----- Ошибка перевода стрелки на макете
                  AddFixMes(GetSmsg(1,577,ObjZv[XStr].Liter,0),4,4);
                  ObjZv[XStr].T[3].Activ := false;
                end;
              end;
            end;

            if not WorkMode.Upravlenie or (ObjZv[XStr].iP[5] = _strmakminus) then
            begin //--------------------------------------------------- переводили в минус
              if ObjZv[Maket_str].bP[4] and not ObjZv[Maket_str].bP[3] and //- ММК без МПК
              (ObjZv[XStr].bP[2] and not ObjZv[XStr].bP[1]) then //------------- МК без ПК
              begin //----------------------- стрелка на макете в минусе - сбросить таймер
                ObjZv[XStr].T[3].Activ := false; ObjZv[XStr].T[3].F := 0;
                ObjZv[XStr].bP[4] := ObjZv[XStr].bP[5]; //биты установки макета совместить
              end else
              begin
                if ObjZv[XStr].T[3].Activ then
                begin
                  InsNewMsg(XStr,577+$2000,0,'');//- Ошибка при переводе стрелки на макете
                  AddFixMes(GetSmsg(1,577,ObjZv[XStr].Liter,0),4,4);
                  ObjZv[XStr].T[3].Activ := false;
                end;
              end;
            end;
          end;
        end;

        //--------------- дальше - если управляющий или  не было выдачи команды для макета
        if ObjZv[Maket_str].bP[2] then //------------------------ если шнур макета включен
        begin
          if WorkMode.Upravlenie and (ObjZv[XStr].bP[4] <> ObjZv[XStr].bP[5]) then
          begin //-------------------- если АРМ основной и команда для макета не исполнена
            OVBuffer[VBuf].Param[2] := false; //----------------------------------- нет ПК
            OVBuffer[VBuf].Param[3] := false; //----------------------------------- нет МК
          end else  //-------------------------- если команда исполнена  или резервный АРМ
          begin
            //------------------------------------------------------------------  ПК & MПК
            OVBuffer[VBuf].Param[2] := ObjZv[XStr].bP[1] and ObjZv[Maket_str].bP[3];

            //------------------------------------------------------------------  МК & MМК
            OVBuffer[VBuf].Param[3] :=  ObjZv[XStr].bP[2] and ObjZv[Maket_str].bP[4];

            if ObjZv[XStr].bP[1] and ObjZv[Maket_str].bP[3] then
            begin
              ObjZv[XStr].iP[4] := _strmakplus;
              ObjZv[XStr].iP[5] := _strmakplus;
            end;

            if ObjZv[XStr].bP[2] and ObjZv[Maket_str].bP[4] then
            begin
              ObjZv[XStr].iP[4] := _strmakminus;
              ObjZv[XStr].iP[5] := _strmakminus;
            end;
          end;

          if WorkMode.Upravlenie then
          begin
            //------------------------------------ если команда "минус" или не было ничего
            if (ObjZv[XStr].iP[4] = _strmakminus) or (ObjZv[XStr].iP[4] = 0) then
            begin
              //---- если нет ММК или есть МПК или нет МК или есть ПК = что-то не в минусе
              if not ObjZv[Maket_str].bP[4] or  ObjZv[Maket_str].bP[3] or
              not ObjZv[XStr].bP[2]  or ObjZv[XStr].bP[1] then
              begin
                OVBuffer[VBuf].Param[2] := false; //--------------- снять ПК в отображении
                OVBuffer[VBuf].Param[3] := false;//---------------- снять МК в отображении

                if not ObjZv[XStr].bP[27] then    //---------- не было регистрации ненормы
                begin
                  InsNewMsg(XStr,271+$1000,0,'');//----------- "стрелка потеряла контроль"
                  AddFixMes(GetSmsg(1,271,ObjZv[XStr].Liter,0),4,3);
                  ObjZv[XStr].bP[27] := true;  //------------- установить признак фиксации
                end;
              end;
            end else

            //----------------------------------- если была команда "+" или не было ничего
            if (ObjZv[XStr].iP[4] =  _strmakplus) or (ObjZv[XStr].iP[4] = 0) then
            begin
              //-------------- если ММК или нет МПК или  МК или нет ПК = что-то не в плюсе
              if ObjZv[Maket_str].bP[4] or not ObjZv[Maket_str].bP[3] or
              ObjZv[XStr].bP[2]  or not ObjZv[XStr].bP[1]  then
              begin
                OVBuffer[VBuf].Param[2] := false; //----------------------------- снять ПК
                OVBuffer[VBuf].Param[3] := false;//------------------------------ снять МК
                if not ObjZv[XStr].bP[27] then  //------------------- нет фиксации ненормы
                begin
                  InsNewMsg(XStr,271+$1000,0,'');//----- "стрелка <Ptr> потеряла контроль"
                  AddFixMes(GetSmsg(1,271,ObjZv[XStr].Liter,0),4,3);
                  ObjZv[XStr].bP[27] := true;
                end;
              end;
            end;
          end;
        end;

        if OVBuffer[VBuf].Param[2] <> OVBuffer[VBuf].Param[3] then
        ObjZv[XStr].bP[27] := false; //---------- контроль восстановлен, сбросить фиксацию
      end else //------------------------------------------------------------ не на макете
      begin
        if bP[1] then // ----------------------------------------- если есть ПК
        begin
          if bP[2] then //-------------------------------- одновременно есть МК
          begin
            //--------------------------------------------- для экрана снять ПК и снять МК
            OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := false;
          end else
          begin //----------------------------------------------------------------- нет МК
            //--------------- установить признак последнего контроля в плюсе и не в минусе
            bP[20] := true;  bP[21] := false;

            bP[22] := false; bP[23] := false;

            //----------------------------------------------------- для экрана ПК и нет МК
            OVBuffer[VBuf].Param[2] := true; OVBuffer[VBuf].Param[3] := false;
          end;
        end else
        if bP[2] then //-------------------------------------------- есть минус
        begin
          //------------------------------ установить признак последнего контроля в минусе
          bP[20] := false;   bP[21] := true;

          bP[22] := false;  bP[23] := false;

          //--------------------------------------------------- для экрана нет ПК, есть МК
          OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := true;
        end else
        begin
          //------------------------------------- для экрана нет ПК, нет МК = нет контроля
          OVBuffer[VBuf].Param[2] := false;  OVBuffer[VBuf].Param[3] := false;
        end;
      end;

      //---------------------------------------------------- признак выдержки времени МСПД
      OVBuffer[VBuf].Param[12] :=  ObCB[9] and  //- проверять МСП(Д) и ...
      not ObjZv[SPstr].bP[4] and ObjZv[SPstr].bP[1] and ObjZv[SPstr].bP[2];//-- мспд,п и з

      //--------------------------------------------------------------- собрать Вз стрелки
      bP[3] :=  ObjZv[SPstr].bP[5]; //-------------------------- МИ из секции

      //------------------------------------------------- проверить охранности для стрелки
      for i := 1 to 10 do
      if ObCI[i] > 0 then //--------------------------------------- если есть очередной Вз
      begin
        ohr := 0;
        Dz := ObCI[i];
        case ObjZv[Dz].TypeObj of
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          27 :
          begin //--------------------------------------------- охранное положение стрелки
            SPohr := ObjZv[DZ].ObCI[2];//---------- объект СП для охранного замыкания
            if ObjZv[DZ].ObCB[1] then //------- если зависимость для ходовой  в плюсе
            begin
              if bP[1] then //-------------------- если ходовая стрелка в плюсе
              begin
                ohr := ObjZv[DZ].ObCI[3]; //------------------------ охранная стрелка
                if ohr > 0 then
                begin
                  if ObjZv[DZ].ObCB[3] then //------- если охранная должна быть в "+"
                  begin
                    if ObjZv[ohr].bP[1] = false then //---------- если охранная не в плюсе
                    begin ObjZv[ohr].bP[3] := false; break; end //---- замкнуть в маршруте
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2];
                  end else
                  if ObjZv[DZ].ObCB[4] then //------------- если охранность по минусу
                  begin
                    if ObjZv[ohr].bP[2] = false then //------------------ если не в минусе
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //-- копировать замыкание
                  end;
                end;
              end;
            end else
            if ObjZv[DZ].ObCB[2] then //---------- если ходовая должна быть по минусу
            begin
              if bP[2] then //--------------------------- если стрелка в минусе
              begin
                ohr := ObjZv[Dz].ObCI[3]; //------------------------ охранная стрелка
                if ohr > 0 then
                begin
                  if ObjZv[DZ].ObCB[3] then//------ если охранная должна быть в плюсе
                  begin
                    if ObjZv[ohr].bP[1] = false then //---------------- стрелка не в плюсе
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //------- копировать замк
                  end else //------------------------ если охранная должна быть не в плюсе
                  if ObjZv[DZ].ObCB[4] then //---- если охранная должна быть в минусе
                  begin
                    if ObjZv[ohr].bP[2] = false then //------ охранная стрелка не в минусе
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //-- копировать замыкание
                  end;
                end;
              end;
            end;

            if ohr > 0 then
            begin
              ObjZv[ohr].bP[4] := //-------------------- замыкание охранной состоит из ...
              ObjZv[ohr].bP[4] or //-------------- собственное замыкание охраннной или ...
              (not ObjZv[SPohr].bP[2]) or //------------------------- разомкнутость СП или
              ObjZv[ohr].bP[33] or //------------------------ четного автодействия или ...
              ObjZv[ohr].bP[25]; //-------------------------------- нечетного автодействия

              OVBuffer[ObjZv[ohr].VBufInd].Param[7] := ObjZv[ohr].bP[4];
              OVBuffer[ObjZv[ohr].VBufInd].Param[6] := ObjZv[ohr].bP[14];
            end;
          end; //---------------------------------------------------------------- конец 27

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          6 : //---------------------------------------------------------- Ограждение пути
          begin
            for p := 14 to 17 do   //------------------------- пройти по охранным стрелкам
            begin
              if ObjZv[Dz].ObCI[p] = Str then  //-------- если нашлась данная стрелка
              begin
                if ObjZv[Dz].bP[2] then  //---------------------- если включено ограждение
                begin
                  if bP[1] then    //--------------------- если стрелка в плюсе
                  begin
                    if not ObjZv[Dz].ObCB[p*2-27] then //-- если охранное не плюсовое
                    begin  bP[3] := false; break; end;  //------------ сброс Вз
                  end else
                  if bP[2] then //----------------------- если стрелка в минусе
                  begin
                    if not ObjZv[Dz].ObCB[p*2-26] then //----- если охранное не минус
                    begin bP[3] := false; break;  end; //------------- сброс Вз
                  end;
                end;
              end;
            end;
          end; //6
        end; //case
      end; //for

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ob := 0;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Проверка негабаритности
      if bP[3] then  //------------------------------------------------ если Вз
      begin
        //---------------- Искать негабаритность через стык и отведенное положение стрелок
        if bP[1] then    //------------------------------- если стрелка в плюсе
        begin
          if (Sosed[3].TypeJmp = LnkNeg) or //---------- есть негабаритный стык
          (ObCB[8]) then//-------------- или замкнуть через стык по минусу
          begin
            ob := Sosed[3].Obj; p := Sosed[3].Pin;
            i := 100;

            while i > 0 do
            begin
              case ObjZv[ob].TypeObj of  //------------ переходы по типу соседа за минусом
                2 :   //---------------------------------------------------------- стрелка
                begin
                  case p of
                    2 ://------------------------------------ Вход на соседнюю через плюс,
                    begin if ObjZv[ob].bP[2] then break; end;//-------- а стрелка в минусе

                    3 ://------------------------------------ Вход на соседнюю через минус
                    begin if ObjZv[ob].bP[1] then break; end; //-------- а стрелка в плюсе

                    else bP[3] := false; break; //------ ошибка в базе данных
                  end;
                  p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;//-- выход 1
                end;

                3,4 : //----------------------------------------------------- участок,путь
                begin
                  if Sosed[3].TypeJmp = LnkNeg then
                  bP[3] := ObjZv[ob].bP[1]//-------- состояние путевого датчика
                  else  bP[3] := false;
                  break;
                end;

                else  //--------------------------------------------------- прочие объекты
                  if p = 1 then
                  begin p:= ObjZv[ob].Sosed[2].Pin;ob := ObjZv[ob].Sosed[2].Obj;end else
                  begin p:= ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
              end;

              if (ob = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end else
        if bP[2] then //------------------------------------------ если есть МК
        begin
          if (Sosed[2].TypeJmp = LnkNeg) or //--------------- негабаритный стык
          (ObCB[7]) then //----- или проверка отводящего положения стрелок
          begin //------------------------------------------------ по плюсовому примыканию
            ob:= Sosed[2].Obj; p:= Sosed[2].Pin; i:= 100;
            while i > 0 do
            begin
              case ObjZv[ob].TypeObj of
                2 : //------------------------------------------------------------ стрелка
                begin
                  case p of
                    2 :  //------------------------------------------------- Вход по плюсу
                    begin if ObjZv[ob].bP[2] then break; end;// стрелка в отводе по минусу

                    3 :   //----------------------------------------------- Вход по минусу
                    begin if ObjZv[ob].bP[1] then break; end;//- стрелка в отводе по плюсу

                    else  bP[3] := false; break; //------- ошибка в базе данных
                  end;
                  p := ObjZv[ob].Sosed[1].Pin;  ob := ObjZv[ob].Sosed[1].Obj;
                end;

                3,4 : //----------------------------------------------------- участок,путь
                begin
                  if Sosed[2].TypeJmp = LnkNeg then
                  bP[3]:=ObjZv[ob].bP[1]//---------- состояние путевого датчика
                  else  bP[3] := false;
                  break;
                end;

                else
                  if p = 1 then
                  begin p:= ObjZv[ob].Sosed[2].Pin; ob:=ObjZv[ob].Sosed[2].Obj; end else
                  begin p:= ObjZv[ob].Sosed[1].Pin; ob:=ObjZv[ob].Sosed[1].Obj; end;
              end;

              if (ob = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end;
      end;

      //++++++++++++++++++++++++++++++++++++++++ проверка охранного положения сбрасывающей
      if ObjZv[XStr].ObCB[1] then //------------------------------------- есть признак КОП
      begin
        if bP[1] and not bP[2] then //---------------------------------------- стрелка в +
        begin
          bP[19] := false; //-------------------------- сброс сигнала отсутствия охранного
          T[1].Activ := false; //---------------------- сброс фикс.времени стрелки не в ОП
          OVBuffer[VBuf].Param[8] := true; //--------------------------------- КОП в норме
          OVBuffer[VBuf].Param[9] := false; //-------------------------------- АВ не нужен
          OVBuffer[VBuf].Param[10] := false; //------------------------------- КОП в норме
        end else
        begin
          if not ObjZv[XStr].bP[21] then //------------------------ СП замкнута в маршруте
          begin
            bP[19] := false;//------------------------- сброс сигнала отсутствия охранного
            T[1].Activ  := false; //------------------ сброс счета времени стрелки не в ОП
            OVBuffer[VBuf].Param[8] := false; //---------------------------- нет охранного
            OVBuffer[VBuf].Param[9] := false; //------------------------- нельзя перевести
            OVBuffer[VBuf].Param[10] := false;
          end else
          if not ObjZv[XStr].bP[20] or not ObjZv[XStr].bP[22] then //-- МСПД или занятость
          begin
            bP[19] := false;//------------------------- сброс сигнала отсутствия охранного
            T[1].Activ  := false; //--------------------- сброс фиксации врем.вывода из ОП
            OVBuffer[VBuf].Param[8] := false;
            OVBuffer[VBuf].Param[9] := false;
            OVBuffer[VBuf].Param[10] := true;
          end else
          begin //---------------------------------------- выведена из охранного положения
            if not bP[1] and bP[2] then
            begin
              if T[1].Activ then
              begin //---- вывести признак отсутствия охранного положения длительное время
                if LastTime >= T[1].F then
                begin
                  if (ObjZv[XStr].ObCI[8] = Str) and //--------- стрелка первая для хвоста
                  not bP[19] and not bP[18] and
                  not ObjZv[XStr].bP[18] and not ObjZv[XStr].bP[15] then//- Колпачек,макет
                  begin
{$IFDEF RMDSP}
                    if WorkMode.OU[0] and WorkMode.OU[grp] and
                    (RU = config.ru) then //---------------- сообщение, при АРМ-управлении
                    begin
                      InsNewMsg(XStr,477+$1000,1,'');
                      text := GetSmsg(1,477,ObjZv[XStr].Liter,7);
                      AddFixMes(text,4,3); //------------- стрелка не в охранном положении
                      ShowSMsg(477,LastX,LastY,ObjZv[XStr].Liter);
                    end;
{$ELSE}
                    InsNewMsg(XStr,477+$1000,2,'');
{$ENDIF}
                  end;
                  T[1].Activ  := false;
                  bP[19] := true;
                end;
              end else
              begin //---------- зафиксировать время вывода стрелки из охранного положения
                T[1].Activ  := true;
                T[1].F := LastTime + ObjZv[SPstr].ObCI[15]/86400;
              end;
            end else //-------------------------------------- нет контроля - сброс мигалки
            begin
              bP[19] := false;
              T[1].Activ  := false;
            end;

            if bP[19] and  not bP[18] and
            not ObjZv[XStr].bP[18] and not ObjZv[XStr].bP[15] and //------ Колпачок, макет
            WorkMode.Upravlenie then
            begin //--------------------------------------------------------------- мигать
              OVBuffer[VBuf].Param[8] := false;
              OVBuffer[VBuf].Param[9] := tab_page;
              OVBuffer[VBuf].Param[10] := false;
            end else
            begin //------------------------------------------------------------ не мигать
              OVBuffer[VBuf].Param[8] := false;
              OVBuffer[VBuf].Param[9] := true;
              OVBuffer[VBuf].Param[10] := false;
            end;
          end;
        end;
      end;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Аварийный перевод стрелки
      if ObjZv[XStr].ObCI[13] > 0 then  //--- существует объект аварийного перевода
      begin
        if ObjZv[ObjZv[XStr].ObCI[13]].bP[1] then  OVBuffer[VBuf].Param[11] := true
        else  OVBuffer[VBuf].Param[11] := false;
      end;

      //--------- если замыкание СП или PM или МИ , то снять виртуальное замыкание стрелки
      if not ObjZv[SPstr].bP[2] or ObjZv[SPstr].bP[9] or not ObjZv[SPstr].bP[5] then
      begin
        bP[14] := false; //----------------------- убрать программное замыкание
        bP[6] := false; //------------------------------------------- убрать ПУ
        bP[7] := false; //------------------------------------------- убрать МУ
        bP[10] := false; //------------------------------ убрать первый прооход
        bP[11] := false; //------------------------------ убрать второй прооход
        bP[12] := false; //----------------------- убрать "прошерстная в плюсе"
        bP[13] := false; //---------------------- убрать "прошерстная в минусе"
        SetPrgZamykFromXStrelka(Str); //-------- сброс замыкания, если разрешает спаренная
      end;

      OVBuffer[VBuf].Param[7] := OVBuffer[VBuf].Param[7] or bP[33]; //----- ЧАС
      OVBuffer[VBuf].Param[7] := OVBuffer[VBuf].Param[7] or bP[25]; //----- НАС


      if not WorkMode.Podsvet and //------------------------- если нет подсветки стрелок и
      (ObjZv[XStr].bP[4] <> ObjZv[XStr].bP[5]) and //----------------- перевод макета и ..
      (ObjZv[XStr].bP[15] or  //------------------------ есть Макет из Fr4 стрелки или ...
{$IFDEF RMSHN} ObjZv[XStr].bP[19] or {$ENDIF}//------------------ Макет из объекта "Макет"
      ObjZv[Xstr].bP[24]) then //--------------------------- стрелка на местном управлении
      OVBuffer[VBuf].Param[4] := true //---------------------------- выключить цвет литера
      else OVBuffer[VBuf].Param[4] := false; //---------------------- включить цвет литера
    end;

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ FR4
    if ObCB[6] then //------------------ если спаренная и при этом дальняя
    begin
      //-------------------------------- закрытие  для движения --------------------------
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[30] := bP[16]
        else  OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[17];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[17];
      //--------------------------------------------- закрыт для противошерстного движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[17]
        else OVBuffer[VBuf].Param[29] :=  ObjZv[Xstr].bP[34];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[29] :=  ObjZv[Xstr].bP[34];
    end else
    begin //-------------------------------------------------------- одиночная или ближняя
      //------------------------------------------------------------- закрыта для движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[30] := bP[16]
        else  OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[16];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[16];
      //------------------------------------------- закрыт для противошерстного движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[17]
        else  OVBuffer[VBuf].Param[29] := ObjZv[Xstr].bP[33];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[29] := ObjZv[Xstr].bP[33];
    end;
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //------------------------------------------------------------------------ макет
      if tab_page then OVBuffer[VBuf].Param[31] :=  ObjZv[Xstr].bP[19]
      else  OVBuffer[VBuf].Param[31] := ObjZv[Xstr].bP[15];
    end else
{$ENDIF}
    OVBuffer[VBuf].Param[31] := ObjZv[Xstr].bP[15];
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //--------------------------------------------------------- выключено управление
      if tab_page then  OVBuffer[VBuf].Param[32] := bP[18]
      else OVBuffer[VBuf].Param[32] := ObjZv[Xstr].bP[18];
    end else
{$ENDIF}
    OVBuffer[VBuf].Param[32] := ObjZv[Xstr].bP[18];
  end;
end;

//========================================================================================
//--------------------------------------- Подготовка объекта секции для вывода на табло #3
procedure PrepSekciya(SP : Integer);
var
  p, mspd, msp, z, mi, ri : boolean;
  i, VBuf, MU, MK, StrA : integer;
  sost : byte;
begin
  with ObjZv[SP] do
  begin
    bP[31] := true; bP[32] := false;  //---------------------- активизация, непарафазность
    VBuf := VBufInd;
    StrA := ObCI[10]; //------------------------------------------ стрелка с автовозвратом
    p  := not GetFR3(ObCI[2], bP[32],bP[31]);
    z  := not GetFR3(ObCI[3], bP[32],bP[31]);
    ri := GetFR3(ObCI[4], bP[32],bP[31]);

    if ObCI[5]  > 0 then mspd := not GetFR3(ObCI[5] , bP[32],bP[31]) else mspd := true;
    if ObCI[13] > 0 then msp  := not GetFR3(ObCI[13], bP[32],bP[31]) else msp  := true;
    if ObCI[6]  > 0 then mi   := not GetFR3(ObCI[6] , bP[32],bP[31]) else mi   := true;

    

    bP[6] := GetFR3(ObCI[7],bP[32],bP[31]);  //------------------------ предварительный РИ
    bP[7] := not GetFR3(ObCI[12],bP[32],bP[31]);//------ предварительное замыкание из STAN


    OVBuffer[VBuf].Param[16] := bP[31]; OVBuffer[VBuf].Param[1] := bP[32];

    if bP[31] and not bP[32] then
    begin
      //------------------------- если в базе есть таймер МСПД и указана выдержка для МСПД
      if (ObCI[8] > 0) and(ObCI[9] > 0) then
      begin
        if p <> bP[1] then //----------------------------------------- изменение занятости
        begin
          if p then //----------------------------------------------- освобождение участка
          begin
            if mspd then T[1].Activ  := false //----------------- если конец выдержки МСПД
            else //------------------------------------------- если началась выдержка МСПД
            if not T[1].Activ  then
            begin //------------------------------------------------ начать отсчет времени
              T[1].F :=LastTime; T[1].Activ := true;
            end;
          end else T[1].Activ  := false;//------------- участок занят, сброс счетчика МСПД
        end;


        if mspd <> bP[4] then //-------------------------------------- есть изменение МСПД
        begin
          if mspd then //--------------------------------- возбужден МСПД = конец выдержки
          begin
{$IFDEF RMSHN}
            if T[1].Activ then dtP[3]:= LastTime - T[1].F;//- запомнить время выдержки
{$ENDIF}
            T[1].Activ := false; //----------------------------------- сброс счетчика МСПД
          end;
        end;
      end;
      bP[1] := p; bP[4] := mspd; //----------------- занятость,  замыкание от потери шунта


      //-------------- если в базе есть таймер МСП и указана выдержка для МСП автовозврата
      if (ObCI[14] > 0) and(ObCI[15] > 0) then
      begin
        if p and z then //-------------------------------- изменение занятости и замыкания
        begin
          if msp then T[2].Activ  := false //--------------------- если конец выдержки МСП
          else //---------------------------------------------- если началась выдержка МСП
          if not T[2].Activ  then
          begin //-------------------------------------------------- начать отсчет времени
            ObjZv[StrA].T[1].S := ObjZv[StrA].T[1].F;
            ObjZv[StrA].T[1].F := ObjZv[StrA].T[1].F + ObCI[15]/86400;
            T[2].F := LastTime; T[2].Activ := true;
          end;
        end
        else
        begin
          T[2].Activ  := false; //---------- участок занят, или замкнут сброс счетчика МСП
          ObjZv[StrA].T[1].Activ := false;
          ObjZv[StrA].T[1].F := 0;
        end;

        if msp <> bP[11] then //--------------------------------------- есть изменение МСП
        begin
          if msp then //----------------------------------- возбужден МСП = конец выдержки
          begin
{$IFDEF RMSHN}
            if T[2].Activ then dtP[4]:= LastTime - T[2].F;//----- запомнить время выдержки
{$ENDIF}
            T[2].Activ := false; //------------------------------------ сброс счетчика МСП
          end;
        end;
      end;
      bP[11] := msp;



      if ObCI[9] > 0 then //---------------------------------------- если есть таймер МСПД
      begin
        if T[1].Activ  then Timer[ObCI[9]] := 1 + Round((LastTime - T[1].F) * 86400)
        else Timer[ObCI[9]] := 0;//----------------------------------------- скрыть таймер
      end;

      if ObCI[14] > 0 then //---------------------------------------- если есть таймер МСП
      begin
        if T[2].Activ  then Timer[ObCI[14]] := 1 + Round((LastTime - T[2].F) * 86400)
        else Timer[ObCI[14]] := 0;//---------------------------------------- скрыть таймер
      end;



      if bP[21] then //--------------- выполнена фиксация недостоверности информации по СП
      begin bP[20] := true;bP[21] := false; end // запомнить восприятие, сбросить фиксацию
      else bP[20] := false;//------------------ нет фиксации - сбросить признак восприятия


      OVBuffer[VBuf].Param[18] :=  (config.ru = RU) and WorkMode.Upravlenie; // активность

      if bP[2] <> z then //------------------------------------------ изменилось замыкание
      begin
        bP[8]:= true; bP[14]:= false;//- снять предварительное З и виртуальную трассировку
        if z then //------------------------------------------------ при размыкании секции
        //------------------------- сброс индекса светофора, индекса горы, снять 1КМ и 2КМ
        begin
          ObjZv[StrA].T[1].F := ObjZv[StrA].T[1].F + ObCI[15]/86400;
          iP[2] := 0; iP[3] := 0; bP[15] := false; bP[16] := false;
        end;
      end;
      bP[2] := z;  //--------------------------------- установить текущее значение для "З"

      if bP[5] <> mi then //------------------------------------------------ изменилось МИ
      begin
        bP[8]:=true; bP[14]:=false; //----------------------- снять трассу и пред.замык.
        if mi then begin bP[15]:=false;bP[16]:=false; end;//размыкание МИ СП снять 1 и 2КМ
      end;
      bP[5] := mi;  //----------------------------------------------------------------- МИ

      bP[9] := false; //----- проверка передачи на местное управление, считаем, что нет РМ

      for i := 20 to 24 do //------------------------------ проход по возможным районам МУ
      if ObCI[i] > 0 then
      begin
        MU := ObCI[i]; //--------------------- выделяем очередной район местного упрвления
        case ObjZv[MU].TypeObj of
          25 : if not bP[9] then bP[9] := Get_ManK(MU); //------------- маневровая колонка
          44 : begin MK:=ObjZv[MU].BasOb;if not bP[9] then bP[9]:= Get_ManK(MK); end;//СМИ
        end;
      end;

      OVBuffer[VBuf].Param[2] := bP[9];  //------------------------------------ признак РМ
      OVBuffer[VBuf].Param[3] := bP[5];  //-------------------------------------------- МИ
      OVBuffer[VBuf].Param[4] := bP[1];  //--------------------------------------------- П
      OVBuffer[VBuf].Param[5] := bP[2];  //--------------------------------------------- З

{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if not bP[14] then //---------------------- при наличии программного замыкания DSP
        begin
          if not bP[7] then //------------------ если есть программное замыкание из STAN
          //---------------------- показать трассирующее замыкание и программное замыкание
          begin OVBuffer[VBuf].Param[6] := false; OVBuffer[VBuf].Param[14] := true; end
          else //-------- нет виртуального из STAN, светить немигающую тонкую белую полосу
          //--------------------- снять программное замыкание, показать трассировку из DSP
          begin OVBuffer[VBuf].Param[14] := false; OVBuffer[VBuf].Param[6] := bP[8]; end;
        end else //------------------------------------------- если нет трассировки из DSP
        begin
          if not bP[7] then //----------------------------------- есть виртуальное из STAN
          //----------------------------- показать трассу и показать программное замыкание
          begin OVBuffer[VBuf].Param[6] := false; OVBuffer[VBuf].Param[14] := true; end
          else //------------------------------------------------ нет виртуального из STAN
          begin //------------------------------------------------------ снять программное
            OVBuffer[VBuf].Param[14] := false;
            if tab_page then OVBuffer[VBuf].Param[6] := true //--------- сброс трассировки
            else  OVBuffer[VBuf].Param[6] :=  bP[8]; //--------------- трассировка из АРМа
          end;
        end;
      end else //----------- нет управления от данного АРМ, берем замыкание из FR3 от STAN
      begin {$ENDIF}
        OVBuffer[VBuf].Param[6] := bP[7]; OVBuffer[VBuf].Param[14] := not bP[7];
        {$IFDEF RMDSP}
      end;
        {$ENDIF}

      if bP[3] <> ri then  //-------------------------------------- изменилось значение РИ
      begin
        if ri and not StartRM then
        begin //-------------------------------------------- фиксируем выбор секции для ИР
{$IFDEF RMDSP}
          if RU = config.ru then AddFixMes(GetSmsg(1,84,Liter,7),0,2);{$ENDIF}
          InsNewMsg(SP,84+$2000,7,''); //--------- выполняется искусственное размыкание СП
        end;
      end;
      bP[3] := ri;
      OVBuffer[VBuf].Param[7] := bP[3]; OVBuffer[VBuf].Param[9] := bP[6]; //-- РИ и предРИ
      OVBuffer[VBuf].Param[8] := bP[4]; //------------------------------------------- МСПД

      sost := GetFR5(ObCI[1]); //--------------------------------------------- диагностика
      if bP[5] and (iP[3] = 0) then //------------------------------- нет МИ и нет надвига
      begin
        if ((sost and 1) = 1) then //------------------- фиксируем лoжную занятость секции
        begin
          {$IFDEF RMSHN}  dtP[1] := LastTime; inc(siP[1]);{$ELSE}
          if RU = config.ru then AddFixMes(GetSmsg(1,394,Liter,0),4,1); {$ENDIF}
          InsNewMsg(SP,394+$1000,0,''); bP[19] := true;//----------- Зафиксировано занятие
        end;

        if ((sost and 2) = 2) and not bP[9] then //--- фиксируем лoжную свободность секции
        begin
          {$IFDEF RMSHN}  dtP[2] := LastTime; inc(siP[2]); {$ELSE}
          if RU = config.ru then  AddFixMes(GetSmsg(1,395,Liter,0),4,1); {$ENDIF}
          InsNewMsg(SP,395+$1000,0,'');//---------------------- Зафиксировано освобождение
          bP[19] := true;
        end;
      end;

      //---------------------------------------------------------------- подсветка стрелок
      if WorkMode.Podsvet and ObCB[6] then OVBuffer[VBuf].Param[10] := true
      else OVBuffer[VBuf].Param[10] := false;
    end else //---------------------------------- переход в недостоверное состояние данных
    begin
      if ObCI[9] > 0 then Timer[ObCI[9]] := 0; //------------------------------------ МСПД
      if ObCI[14] > 0 then Timer[ObCI[14]] := 0; //----------------------------------- МСП
      bP[21] := true; //------------------------ установить ловушку недостоверности данных
    end;

    OVBuffer[VBuf].Param[13] := bP[19]; //------------------ фиксация неисправности секции

    //-------------------------------------------------------------------------------- FR4
    bP[12] := GetFR4State(ObCI[1]*8+2); //------------------------- закрытие движения STAN
    {$IFDEF RMDSP}
    if WorkMode.Upravlenie and (RU = config.ru) then
    begin
      if tab_page then OVBuffer[VBuf].Param[32]:=bP[13] //---------- показать закрытие DSP
      else OVBuffer[VBuf].Param[32] := bP[12];      //------------- показать закрытие STAN
    end else
    {$ENDIF}
    OVBuffer[VBuf].Param[32] := bP[12]; //------------ если в STAN закрытие, то не мигнает

    if ObCB[8] or ObCB[9] then
    begin //------------------------------------------------------------- есть электротяга
      bP[27] := GetFR4State(ObCI[1]*8+3);//-------------------------- закрытие на ЭТ(STAN)

      {$IFDEF RMDSP}
      if WorkMode.Upravlenie and (RU = config.ru) then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[24] //-------- закрытие на ЭТ(DSP)
        else OVBuffer[VBuf].Param[29] := bP[27]; //------------------ закрытие на ЭТ(STAN)
      end else
      {$ENDIF}

      OVBuffer[VBuf].Param[29] := bP[27];//----------- не мигать,если закрытие на ЭТ(STAN)

      if ObCB[8] and ObCB[9] then //------------------------------ есть 2 вида электротяги
      begin
        bP[28] := GetFR4State(ObCI[1]*8); //------------------------- закрыто Пост.Т(STAN)
        {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then  OVBuffer[VBuf].Param[30] := bP[25]
          else  OVBuffer[VBuf].Param[30] := bP[28];
        end else
        {$ENDIF}
        OVBuffer[VBuf].Param[30] := bP[28];

        bP[29] := GetFR4State(ObCI[1]*8+1);
        {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBuf].Param[29] := bP[26]
          else OVBuffer[VBuf].Param[29] := bP[29];
        end else
        {$ENDIF}
        OVBuffer[VBuf].Param[29] := bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------- Подготовка объекта пути для вывода на табло #4
procedure PrepPuti(PUT : Integer);
var
  ni_, chi_, mic, min, Nepar, Activ : boolean;
  i, PutCH, PutN, Ni, CHi, CHkm, Nkm, MI_CH, MI_N, PrZC, PrZN, VidB, RMU : integer;
  sost,sost1,sost2 : Byte;
begin
  Nepar := false;  Activ := true;

  PutCH := ObjZv[PUT].ObCI[2];//- № датчика пути четной горловины (при стыковке ТУМС)
  CHi   := ObjZv[PUT].ObCI[3]; //--------------------------------------- № датчика ЧИ
  CHkm  := ObjZv[PUT].ObCI[5]; //-------------------------------------- № датчика ЧКМ
  MI_CH := ObjZv[PUT].ObCI[6]; //------------------------------------ № датчика МИ(ч)
  PrZC  := ObjZv[PUT].ObCI[11]; //--- № датчика предварительного замыкания Ч маршрута

  PutN  := ObjZv[PUT].ObCI[9];//№ датчика пути нечетной горловины (при стыковке ТУМС)
  Ni    := ObjZv[PUT].ObCI[4]; //--------------------------------------- № датчика НИ
  Nkm   := ObjZv[PUT].ObCI[7]; //-------------------------------------- № датчика НКМ
  MI_N  := ObjZv[PUT].ObCI[8]; //------------------------------------ № датчика МИ(Н)
  PrZN  := ObjZv[PUT].ObCI[12]; //--- № датчика предварительного замыкания Н маршрута

  VidB :=  ObjZv[PUT].VBufInd;

  //----------------------------------------- Занятости пути в четной и в нечетной стойках
  ObjZv[PUT].bP[1] := not GetFR3(PutCH,Nepar,Activ);//------------------------------- П(ч)
  ObjZv[PUT].bP[16] := not GetFR3(PutN,Nepar,Activ);//------------------------------- П(н)

  ni_ :=  not GetFR3(Ni,Nepar,Activ);//------------------------------------------------ НИ
  chi_ :=  not GetFR3(CHi,Nepar,Activ);//---------------------------------------------- ЧИ

  ObjZv[PUT].bP[4] := GetFR3(CHkm,Nepar,Activ); //------------------------------------ ЧКМ

  if MI_CH > 0 then  mic := not GetFR3(MI_CH,Nepar,Activ)//- если есть объект МИ,проверить
  else mic := true; //-------------------------------------------------------- иначе МИ(ч)

  ObjZv[PUT].bP[15] := GetFR3(Nkm,Nepar,Activ); //------------------------------------ НКМ

  if MI_N > 0 then min := not GetFR3(MI_N,Nepar,Activ) //--------------------------- МИ(н)
  else min := true;

  ObjZv[PUT].bP[7] := not GetFR3(PrZC,Nepar,Activ);//--------------------- - замк чет STAN
  ObjZv[PUT].bP[11] := not GetFR3(PrZN,Nepar,Activ); //----------- предв замык неч из STAN

  ObjZv[PUT].bP[31] := Activ; //---------------------------------------------- Активизация
  ObjZv[PUT].bP[32] := Nepar; //------------------------------------------- Непарафазность

  if  VidB > 0 then
  begin
    OVBuffer[VidB].Param[16] := Activ; OVBuffer[VidB].Param[1] := Nepar;
    if Activ and not Nepar then
    begin
      OVBuffer[VidB].Param[18] := (config.ru = ObjZv[PUT].RU) and  WorkMode.Upravlenie;
      if ObjZv[PUT].bP[3] <> ni_ then //-------------------------------- если НИ обновился
      begin
        if ObjZv[PUT].bP[3] then
        begin
          ObjZv[PUT].iP[2] := 0;
          ObjZv[PUT].bP[8] := true; //---------------------------------- снять трассировку
          ObjZv[PUT].bP[14] := false; //------------------ снять предварительное замыкание
        end;
      end;
      ObjZv[PUT].bP[3] := ni_;  //----------------------------------------------------- нИ

      if ObjZv[PUT].bP[2] <> chi_  then //------------------------------ если ЧИ обновился
      begin
        if ObjZv[PUT].bP[2] then
        begin
          ObjZv[PUT].iP[3] := 0;
          ObjZv[PUT].bP[8] := true; //---------------------------------- снять трассировку
          ObjZv[PUT].bP[14] := false; //------------------ снять предварительное замыкание
        end;
      end;
      ObjZv[PUT].bP[2] := chi_;  //---------------------------------------------------- чИ

      if ObjZv[PUT].bP[5] <> mic then
      begin
        if ObjZv[PUT].bP[5] then
        begin
          ObjZv[PUT].bP[8] := true; //---------------------------------- снять трассировку
          ObjZv[PUT].bP[14] := false; //------------------ снять предварительное замыкание
        end;
      end;
      ObjZv[PUT].bP[5] := mic;  //-------------------------------------------------- МИ(ч)

      if ObjZv[PUT].bP[6] <> min then
      begin
        if ObjZv[PUT].bP[6] then
        begin
          ObjZv[PUT].bP[8] := true; //---------------------------------- снять трассировку
          ObjZv[PUT].bP[14] := false; //------------------ снять предварительное замыкание
        end;
      end;
      ObjZv[PUT].bP[6] := min;  //-------------------------------------------------- МИ(н)

      //------------------------------------------ проверка передачи на местное управление
      ObjZv[PUT].bP[9] := false;

      for i := 20 to 24 do //--------------------------- пройтись по номерам возможных РМУ
      if ObjZv[PUT].ObCI[i] > 0 then
      begin
        RMU := ObjZv[PUT].ObCI[i];
        case ObjZv[RMU].TypeObj of //---------------------------------------- по типу РМУ
           //------------------------------------------------------ маневровая колонка
          25 : if not ObjZv[PUT].bP[9] then ObjZv[PUT].bP[9] := Get_ManK(RMU); //------------------------------------------ если нет РМ
           //------------------------------------------- оПИ - исключение пути из маневров
          43 : if not ObjZv[PUT].bP[9] then ObjZv[PUT].bP[9]:= Get_ManK(ObjZv[RMU].BasOb);
        end;
      end;

        OVBuffer[VidB].Param[2] := ObjZv[PUT].bP[3]; //--------------------------- ни
        OVBuffer[VidB].Param[3] := ObjZv[PUT].bP[2]; //--------------------------- чи
{$IFDEF RMDSP}
        //------------------------------------------- собираем занятости из соседних стоек
        OVBuffer[VidB].Param[4] := ObjZv[PUT].bP[1] and ObjZv[PUT].bP[16];
{$ELSE}
        if tab_page  then OVBuffer[VidB].Param[4]:=ObjZv[PUT].bP[1] //--- занятость Ч
        else OVBuffer[VidB].Param[4] := ObjZv[PUT].bP[16]; //------------ занятость Н
{$ENDIF}
        OVBuffer[VidB].Param[5] := ObjZv[PUT].bP[4];   //------------------------ чкм
        OVBuffer[VidB].Param[7] := ObjZv[PUT].bP[15];  //------------------------ нкм
        OVBuffer[VidB].Param[9] := ObjZv[PUT].bP[9];   //------------------------- рм
        OVBuffer[VidB].Param[10] := ObjZv[PUT].bP[5]  and ObjZv[PUT].bP[6];// ми
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if not ObjZv[PUT].bP[14] then //--- если нет программное замыкание в РМ ДСП
          begin
            if not ObjZv[PUT].bP[7] or not ObjZv[PUT].bP[11] then //Чз, Нз в FR3
            begin
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin //--------------------------------- светить немигающую тонкую белую полосу
              OVBuffer[VidB].Param[14] := false;
              OVBuffer[VidB].Param[6] := ObjZv[PUT].bP[8];
            end;
          end else
          begin
            if not ObjZv[PUT].bP[7] or not ObjZv[PUT].bP[11] then
            begin //--------------------------------------------------------------- из FR3
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin
              OVBuffer[VidB].Param[14] := false;
              if tab_page then  OVBuffer[VidB].Param[6] := true//
              else OVBuffer[VidB].Param[6] :=  ObjZv[PUT].bP[8]; //------- из объекта
            end;
          end;
        end else
        begin //------------------------------------------------------------------- из FR3
{$ENDIF}
          OVBuffer[VidB].Param[6] := ObjZv[PUT].bP[7] and ObjZv[PUT].bP[11];
          OVBuffer[VidB].Param[14]:= not OVBuffer[VidB].Param[6];
{$IFDEF RMDSP}
        end;
{$ENDIF}

        sost1 := GetFR5(PutCH  div 8);

        if (PutN > 0) and (PutCH <> PutN) then sost2 := GetFR5(PutN div 8)//составной путь
        else sost2 := 0;

        sost := sost1 or sost2;

        //роверить наличие блокировки дубляжа диагностики от разных контроллеров за 1 сек.
        ObjZv[PUT].T[1].Activ  := ObjZv[PUT].T[1].F < LastTime;

        if (sost > 0) and
        ((sost <> byte(ObjZv[PUT].bP[4])) or ObjZv[PUT].T[1].Activ ) then
        begin
          ObjZv[PUT].iP[4] := SmallInt(sost);
{$IFDEF RMSHN}
          //-------------------------------- зафиксировать время блокировки диагностики ШН
          ObjZv[PUT].T[1].F := LastTime + 1 / 86400;
{$ELSE}
          //------------------------------- зафиксировать время блокировки диагностики ДСП
          ObjZv[PUT].T[1].F := LastTime + 2 / 86400;
{$ENDIF}
          if (sost and 4) = 4 then
          begin //---------------------------------------- фиксируем отсутствие теста пути
{$IFDEF RMSHN}
              InsNewMsg(PUT,397+$1000,0,'');
//            SBeep[1] := true;
              ObjZv[PUT].bP[19] := true;
              ObjZv[PUT].dtP[3] := LastTime;
              inc(ObjZv[PUT].siP[3]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,397+$1000,0,'');
                AddFixMes(GetSmsg(1,397,ObjZv[PUT].Liter,0),4,1);
              end;
              //----------------------- Фиксировать неисправность если включено управление
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie;
{$ENDIF}
            end;

            if (sost and 1) = 1 then
            begin //--------------------------------------- фиксируем лoжную занятость пути
{$IFDEF RMSHN}
              InsNewMsg(PUT,394+$1000,0,'');
              ObjZv[PUT].bP[19] := true;
              ObjZv[PUT].dtP[1] := LastTime;
              inc(ObjZv[PUT].siP[1]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,394+$1000,0,'');
                AddFixMes(GetSmsg(1,394,ObjZv[PUT].Liter,0),4,1);
              end;
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie; // Фиксировать при управлении
{$ENDIF}
            end;
            if (sost and 2) = 2 then
            begin //------------------------------------ фиксируем ложную свободность пути
{$IFDEF RMSHN}
              InsNewMsg(PUT,395+$1000,0,'');
              ObjZv[PUT].dtP[2] := LastTime;
              inc(ObjZv[PUT].siP[2]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,395+$1000,0,'');
                AddFixMes(GetSmsg(1,395,ObjZv[PUT].Liter,0),4,1);
              end;
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie; //- Фиксировать неисправность
{$ENDIF}
            end;
          end;
        end;

        OVBuffer[VidB].Param[13] := ObjZv[PUT].bP[19];

        //---------------------------------------------------------------------------- FR4
        ObjZv[PUT].bP[12] := GetFR4State(PutCH div 8 * 8 + 2);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[13]
          else OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[12];
        end else
{$ENDIF}
        OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[12];

        if ObjZv[PUT].ObCB[8] or ObjZv[PUT].ObCB[9] then
        begin //--------------------------------------------------------- есть электротяга
          ObjZv[PUT].bP[27] := GetFR4State(PutCH div 8 * 8 + 3);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
          begin
            if tab_page then OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[24]
            else OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[27];
          end else
{$ENDIF}
          OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[27];

          if ObjZv[PUT].ObCB[8] and ObjZv[PUT].ObCB[9] then
          begin //------------------------------------------------ есть 2 вида электротяги
            ObjZv[PUT].bP[28] := GetFR4State(PutCH div 8 * 8);
{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
            begin
              if tab_page
              then OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[25]
              else OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[28];
            end else
{$ENDIF}
            OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[28];
            ObjZv[PUT].bP[29] := GetFR4State(ObjZv[PUT].ObCI[1] div 8 * 8 + 1);

{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
            begin
              if tab_page then OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[26]
              else OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[29];
            end else
{$ENDIF}
              OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[29];
          end;
        end;
      end;
end;

//========================================================================================
//------------------------------------ Подготовка объекта светофора для вывода на табло #5
procedure PrepSvetofor(SVTF : Integer);
var
  i,j,VidBuf,SP,MU,MK : integer;
  n,o,zso,so,jso,vnp,kz,Nepar,Aktiv : boolean;
  sost : Byte;
begin
  SP := 0;
  MU := 0;
  MK := 0;

    ObjZv[SVTF].bP[31] := true; //-------------------------------------------- Активизация
    ObjZv[SVTF].bP[32] := false; //---------------------------------------- Непарафазность

    ObjZv[SVTF].bP[1] :=  //------------------------------------------ МС1 (ВС маневровый)
    GetFR3(ObjZv[SVTF].ObCI[2],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[2] := //----------------------------------------------------------- МС2
    GetFR3(ObjZv[SVTF].ObCI[3],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[3] := //---------------------------------------------- С1 (ВС поездной)
    GetFR3(ObjZv[SVTF].ObCI[4],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[4] := //------------------------------------------------------------ С2
    GetFR3(ObjZv[SVTF].ObCI[5],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    o :=   //--------------------------------------------------------------------- огневое
    GetFR3(ObjZv[SVTF].ObCI[7],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[6] := //------------------------ признак "маневровое начало НМ" из STAN
    GetFR3(ObjZv[SVTF].ObCI[12],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[8] := //--------------------------- признак "поездное начало Н" из STAN
    GetFR3(ObjZv[SVTF].ObCI[13],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[10] := // Ко ------------------------------ включение сигнала прикрытия
    GetFR3(ObjZv[SVTF].ObCI[8],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    if ObjZv[SVTF].bP[4] and //-------------------------- если включен С2 - поездной и ...
    (ObjZv[SVTF].BasOb = 0) then  //-------------------------- нет перекрывной секции
    begin
      ObjZv[SVTF].bP[9] := false; ObjZv[SVTF].bP[14] := false; //------- снять трассировку
    end;

    if ObjZv[SVTF].VBufInd > 0 then
    begin
      VidBuf := ObjZv[SVTF].VBufInd;

      OVBuffer[VidBuf].Param[16] := ObjZv[SVTF].bP[31];
      OVBuffer[VidBuf].Param[1] := ObjZv[SVTF].bP[32];

      if ObjZv[SVTF].bP[31] and not ObjZv[SVTF].bP[32] then //-------- активен и парафазен
      begin
        OVBuffer[VidBuf].Param[18] := (config.ru = ObjZv[SVTF].RU);//район упр-ния активен

        //-------------------------------------------------------- обработка огневого реле
        if o <> ObjZv[SVTF].bP[5] then //----------------- огневое реле изменило состояние
        begin
          if o then //---------------------------------- неисправность огневушки появилась
          begin
            if ObjZv[SVTF].T[3].Activ = false then  //------------- если таймер не активен
            begin
              ObjZv[SVTF].T[3].Activ := true; ObjZv[SVTF].T[3].F := LastTime;
            end else //------------------------------- если таймер был ранее активизирован
            begin
              if (LastTime - ObjZv[SVTF].T[3].F) > 5/80000 then // прошло 5 секунд
              begin
                if not ObjZv[SVTF].bP[2] and not ObjZv[SVTF].bP[4] then//------- не МС2,С2
                begin
                  if WorkMode.FixedMsg then //------------- если работа с фиксацией ошибок
                  begin
{$IFDEF RMDSP}
                    if config.ru = ObjZv[SVTF].RU then //------- если наш район управления
                    begin
                      if ObjZv[SVTF].bP[10] then //------------- если это сигнал прикрытия
                      begin
                        //-------------"Неисправность красного огня светофора прикрытия $"
                        InsNewMsg(SVTF,481+$1000,1,'');
                        AddFixMes(GetSmsg(1,481, ObjZv[SVTF].Liter,1),4,4);
                      end else
                      begin
                        InsNewMsg(SVTF,272+$1000,0,'');//------------ "Неисправен светофор $"
                        AddFixMes(GetSmsg(1,272, ObjZv[SVTF].Liter,0),4,4);
                      end;
                    end;
{$ELSE}
                    if ObjZv[SVTF].bP[10] then
                    InsNewMsg(SVTF,481+$1000,0,'') //------- "Неисправен сигнал прикрытия"
                    else   InsNewMsg(SVTF,272+$1000,0,''); // Неисправен запрещающий огонь
                    SBeep[4] := true;
                    ObjZv[SVTF].dtP[1] := LastTime; //------ время последней неисправности
                    inc(ObjZv[SVTF].siP[1]); //------------- увеличить счет неисправностей
{$ENDIF}
                    ObjZv[SVTF].bP[5] := o;  //--------- обновить значение огневого реле О
                  end;   //------------------------------------------------ конец фиксации
                end;//-------------------------------------------- конец закрытого сигнала

                ObjZv[SVTF].bP[20] := false; //------------ сброс восприятия неисправности
                ObjZv[SVTF].T[3].Activ:= false;
                ObjZv[SVTF].T[3].F := 0; //--------------------------------- сброс таймера

              end;//-------------------------------------------------- конец времени 5 сек
            end; //----------------------------------------------- конец таймера активного
          end else //---------------------------------------------- конец огневушка = true
          begin  //----------------------------------------------------- огневушка в норме
            ObjZv[SVTF].T[3].Activ := false;  //---------------------------- сброс таймера
            ObjZv[SVTF].T[3].F :=0;
            ObjZv[SVTF].bP[5] := o;  //----------------- обновить значение огневого реле О
          end;
        end;
        //---------------------------------------------------- конец работы с огневым реле

        if ObjZv[SVTF].bP[1] or ObjZv[SVTF].bP[3] or
        ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[4]  then //------- открыт или выдержка времени
        begin

          if MarhTrac.SvetBrdr = SVTF then //-------- данный сигнал открылся в трассе
          begin
            for j := 1 to 10 do MarhTrac.MarhCmd[j] := 0; // сброс маршрутной команды

            ObjZv[SVTF].bP[14] := false; //------ сбросить программное замыкание сигнала
            ObjZv[SVTF].bP[7] := false;//------- сбросить маневровую трассировку сигнала
            ObjZv[SVTF].bP[9] := false;//--------- сбросить поездную трассировку сигнала

            j := MarhTrac.HTail; //------------------------------- выделить хвост трассы
            ObjZv[j].bP[14] := false; //------------- снять программное замыкание хвоста
            ObjZv[j].bP[7] := false;//----------- сбросить маневровую трассировку хвоста
            ObjZv[j].bP[9] := false;//------------- сбросить поездную трассировку хвоста

            j := MarhTrac.PutPriem; //---------------- выделить путь приема для маршрута
            ObjZv[j].bP[14] := false; //--------------- снять программное замыкание пути
            ObjZv[j].bP[7] := false;//------------- сбросить маневровую трассировку пути
            ObjZv[j].bP[9] := false;//--------------- сбросить поездную трассировку пути
          end;


          ObjZv[SVTF].iP[1] := 0; //------------------- сбросить индекс маршрута в сигнале
          ObjZv[SVTF].bP[34] := false; //--------------- отменить признак повтора для STAN

          if(((ObjZv[SVTF].iP[10] and $4)= 0) and //-- нет фиксации неисправности ЖСо и...
          (//-------------------------------- МС1 и С1 без общего ВС (два ВС одновременно)
          ((ObjZv[SVTF].bP[1] and ObjZv[SVTF].bP[3]) and  not ObjZv[SVTF].ObCB[22])
          or //------------------------------------------------------------------- или ...
          (ObjZv[SVTF].bP[2] and ObjZv[SVTF].bP[4]))) then //МС2 и С2 (два сигнала вместе)
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[SVTF].RU then
              begin
                InsNewMsg(SVTF,300+$1000,1,'');// Неисправен разрешающий огонь светофора $
                AddFixMes(GetSmsg(1,300, ObjZv[SVTF].Liter,1),4,4)
              end;
{$ELSE}
              InsNewMsg(SVTF,300+$1000,1,'');
{$ENDIF}
            end;
            ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $4;//------------ фиксация ненормы
          end;
        end
        else ObjZv[SVTF].iP[10]:=ObjZv[SVTF].iP[10] and $FFFB;//сброс фиксации,если закрыт

        //--------------------------------------------------------------------------------
        if ObjZv[SVTF].BasOb > 0 then //---------------- если есть перекрывная секция
        begin
          SP := ObjZv[SVTF].BasOb;
          if ObjZv[SVTF].bP[11] <> ObjZv[SP].bP[2] then
          begin //------------------------------------------ замыкание в секции изменилось
            if ObjZv[SVTF].bP[11] then  //------------------ если раньше замыкания не было
            begin
              ObjZv[SVTF].iP[1] := 0;  //------------------------ сбросить индекс маршрута
              ObjZv[SVTF].bP[34] := false; //--------- сбросить признак повтора на сервере
            end else
            begin //--- если раньше было замыкание перекрывной секции, теперь разомкнулась
              ObjZv[SVTF].bP[14] := false; //----------------- снять программное замыкание
              ObjZv[SVTF].bP[7] := false;  //---------------- Сброс маневровой трассировки
              ObjZv[SVTF].bP[9] := false;  //------------------ Сброс поездной трассировки
              ObjZv[SVTF].iP[2] := 0;      //------------------------------------ Сброс ГВ
              ObjZv[SVTF].iP[3] := 0;      //------------------------------------ Сброс УН
            end;
            ObjZv[SVTF].bP[11] := ObjZv[SP].bP[2];//------------------------------ копия З
          end;
        end;


        //---------------------------------------- проверка передачи на местное управление
        ObjZv[SVTF].bP[18] := false;  //-------------------- сбросить признаки "РМ или МИ"
        ObjZv[SVTF].bP[21] := false; //-------------------------------------- сбросить МУС

        for i := 20 to 24 do //---------------------------- пройти по возможным районам МУ
        begin
          MU := ObjZv[SVTF].ObCI[i];

          if MU > 0 then //----------------------------- если есть принадлежность к району
          begin
            case ObjZv[MU].TypeObj of //--------------------- переключатель по типу района
              25 :
              begin //-------------------------------------------- МК (маневровая колонка)
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18] :=  Get_ManK(MU);

                if ObjZv[SVTF].ObCB[18] and not ObjZv[SVTF].bP[21] then
                begin //------------------------------------------------------ Собрать МУС
                  ObjZv[SVTF].bP[21] := ObjZv[MU].bP[1] and     //--------------- РМ и ...
                  not ObjZv[MU].bP[4] and ObjZv[MU].bP[5]; //-------- оИ  и  В(восприятие)
                end;

                ObjZv[SVTF].bP[18] := ObjZv[SVTF].bP[18] or
                not ObjZv[MU].bP[3]; //-------------------------------------- РМ&ОИ или МИ
              end;

              43 :
              begin //---------------------------------------------------------------- оПИ
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18]:= Get_ManK(MK);

                if ObjZv[SVTF].ObCB[18] and //------------- если отображать МУС и ...
                not ObjZv[SVTF].bP[21] then //-------------------------------- МУС = false
                begin //------------------------------------------------------ Собрать МУС
                  ObjZv[SVTF].bP[21] := ObjZv[MK].bP[1] and //------------------------- РМ
                  not ObjZv[MK].bP[4] and ObjZv[MK].bP[5] and  //--------------оИ и В и...
                  not ObjZv[MU].bP[2]; //--------------------------------------------- РПо
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//РМ&ОИ или МИ
              end;

              48 :
              begin //---------------------------------------------------------------- РПо
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18] := Get_ManK(MK);

                if ObjZv[SVTF].ObCB[18] and //-------------- если отображать МУС и ...
                not ObjZv[SVTF].bP[21] then //--------------------------------- МУС = false
                begin //------------------------------------------------------ Собрать МУС
                  ObjZv[SVTF].bP[21] :=   ObjZv[MK].bP[1] and //------------------------ РМ
                  not ObjZv[MK].bP[4] and //------------------------- оИ
                  ObjZv[MK].bP[5] and    //------------------- В и
                  ObjZv[MU].bP[1]; //--------------------------- разрешены маневры на путь
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//РМ&ОИ или МИ
              end;

              52 :
              begin //-------------------------------------------------------------- СВМУС
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then
                ObjZv[SVTF].bP[18] :=  Get_ManK(MK);
                if ObjZv[SVTF].ObCB[18] and not ObjZv[SVTF].bP[21] then
                begin //------------------------------------------------------ Собрать МУС
                  ObjZv[SVTF].bP[21] := ObjZv[MK].bP[1] and //-------------------------- РМ
                  not ObjZv[MK].bP[4] and ObjZv[MK].bP[5] and //--------------------оИ & В
                  ObjZv[MU].bP[1]; //------------------ есть проход по пошерстным стрелкам
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//РМ&ОИ  МИ
              end;
            end; //--------------------------------- конец переключателя по типу района МУ
          end; //---------------------------------------- конец принадлежности к району МУ
        end; //------------------------------------- конец прохода по возможным районам МУ

        if (ObjZv[SVTF].iP[2] = 0) and //-------------------------------------- признак ГВ
        (ObjZv[SVTF].iP[3] = 0) and //----------------------------------------- признак УН
        not ObjZv[SVTF].bP[18] then //----------------------------------------- признак РМ
        begin //------------------------------- контролировать замедление сигнального реле
          if ObjZv[SP].bP[1] then ObjZv[SVTF].T[1].Activ  := false // если СП свободна
          else  //---------------------------------------------- перекрывная секция занята
          if ObjZv[SVTF].bP[4] then //------------------------------ если открыт сигнал С2
          begin
            if not ObjZv[SVTF].T[1].Activ  then //---------------------- таймер не активен
            begin //--------------------------------------------- фиксируем начало отсчета
              ObjZv[SVTF].T[1].Activ  := true;
              ObjZv[SVTF].T[1].F := LastTime;
            end;
          end else
          begin //------------------------------------------------------ сигнал перекрылся
            if ObjZv[SVTF].T[1].Activ  then
            begin
              ObjZv[SVTF].T[1].Activ  := false;
{$IFDEF RMSHN}
              ObjZv[SVTF].dtP[6] := LastTime - ObjZv[SVTF].T[1].F;
{$ENDIF}
            end;
          end;
        end;

        if (ObjZv[SVTF].iP[2] = 0) and (ObjZv[SVTF].iP[3] = 0) and //нет признаков ГВ и УН
        not ObjZv[SVTF].bP[18]      //------------------------------------ нет признака РМ
{$IFDEF RMDSP}
        and (ObjZv[SVTF].RU = config.ru) //----------- в РМ-ДСП - есть соответствие района
        and WorkMode.Upravlenie          //-------------------------- и наличие управления
{$ENDIF}
        then
        begin //-------------------------------------------------- контроль работы сигнала
          if ObjZv[SP].bP[2] then //--------------------- нет замыкания перекрывной секции
          begin
            if not ObjZv[SVTF].T[1].Activ  and //-------------------- не включена выдержка
            not ObjZv[SVTF].bP[8] and not ObjZv[SVTF].bP[9] then //--- нет Н и трассировки
            begin
              if ObjZv[SVTF].bP[4] then//------------------------ есть С (открыт поездной)
              begin
                if((ObjZv[SVTF].iP[10] and $2)=0) then //- нет фиксации этой неисправности 
                begin
                  if WorkMode.FixedMsg then
                  begin
                    InsNewMsg(SVTF,510+$1000,0,'');
                    //---------- "Зафиксировано открытие сигнала $ без установки маршрута"
                    AddFixMes(GetSmsg(1,510,ObjZv[SVTF].Liter,0),4,1);
                  end;
                end;
                ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $2; //-- зафиксировать ненорму
              end
              else ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FFD; //иначе убрать фикс.
            end;

            if ObjZv[SVTF].bP[2] then //--------------------- если МС2 (открыт манавровый)
            begin
              if not ObjZv[SVTF].bP[6] and not ObjZv[SVTF].bP[7] then//нет НМ и нет трассы
              begin //---------------------------------------- есть МС без начала маршрута
                if ObjZv[SVTF].T[2].Activ  then //-------------------- если запущен таймер
                begin //-------------- ожидание обестачивания маневрового сигнального реле
                  if LastTime > ObjZv[SVTF].T[2].F then //----------- время ожидания вышло
                  begin
                    if ((ObjZv[SVTF].iP[10] and $1) = 0) then //------------- нет фиксации
                    begin
                      if WorkMode.FixedMsg then
                      begin
                        //-------- Зафиксировано открытие сигнала $ без установки маршрута
                        InsNewMsg(SVTF,510+$1000,0,'');
                        AddFixMes(GetSmsg(1,510,ObjZv[SVTF].Liter,0),4,1);
                        ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $1;
                      end;
                    end;
                  end;
                end else
                begin //---------- нет ожидания обестачивания маневрового сигнального реле
                  ObjZv[SVTF].T[2].F := LastTime + 5 / 86400;
                  ObjZv[SVTF].T[2].Activ  := true;
                end;
              end;
            end  else
            begin
              ObjZv[SVTF].T[2].Activ  := false;//--------- сброс таймера,маневровый закрыт
              ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FFFE;
            end;
          end else //------------------------------------------ есть замыкание перекрывной
          if ObjZv[SVTF].bP[6] or ObjZv[SVTF].bP[8] then //------ есть НМ или Н из сервера
          begin
            if not ObjZv[SP].bP[1] then //-------------------------- занята перекрывная СП
            begin
              if not ObjZv[SVTF].bP[27] then //--------- нет фиксации занятия СП в сигнале
              begin
                if not (ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[4]) then//не включ. МС2 или С2
                begin //---------------------------------------------------- сигнал закрыт
                  if WorkMode.FixedMsg then
                  begin
                    InsNewMsg(SVTF,509+$1000,0,'');//----- Занятие СП  до открытия сигнала
                    AddFixMes(GetSmsg(1,509,ObjZv[SVTF].Liter,0),4,1);
                    ObjZv[SVTF].bP[19] := true; //------------- выставить признак фиксации
                  end;
                end;
                ObjZv[SVTF].bP[27] := true; //------- фиксируем занятие перекрывной секции
              end;
            end;
          end;
        end;

        if ObjZv[SP].bP[1] then ObjZv[SVTF].bP[27] := false;//-- сброс фиксации занятия СП

        if ObjZv[SVTF].ObCI[28] > 0 then
        begin //-------------------------------- отобразить состояние автодействия сигнала
          OVBuffer[VidBuf].Param[31] := ObjZv[ObjZv[SVTF].ObCI[28]].bP[1];
        end else OVBuffer[VidBuf].Param[31] := false;

        OVBuffer[VidBuf].Param[3] :=  //-------------------------  маневровый сигнал табло
        ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[21]; //--------- маневровый или МУС объекта OZ

        OVBuffer[VidBuf].Param[5] := ObjZv[SVTF].bP[4];//------------------------ Поездной
        OVBuffer[VidBuf].Param[6] := ObjZv[SVTF].bP[5];//----------------------- огневушка

        if not ObjZv[SVTF].bP[2] and  //-------------------------- закрыт маневровый и ...
        not ObjZv[SVTF].bP[4] and //-------------------------------- закрыт поездной и ...
        not ObjZv[SVTF].bP[21] then //-------------------------------------------- нет МУС
        begin
          OVBuffer[VidBuf].Param[2] := ObjZv[SVTF].bP[1]; //----- перенос в видеобуфер МВС

          OVBuffer[VidBuf].Param[4] := ObjZv[SVTF].bP[3]; //----- в видеобуфер поездной ВС

          if not ObjZv[SVTF].bP[1] and not ObjZv[SVTF].bP[3] then //- если нет никакого ВС
          begin
            if WorkMode.Upravlenie then //----------------------------- если АРМ управляет
            begin
              if not ObjZv[SVTF].bP[14] and //--------------- нет программного замыкания и
              ObjZv[SVTF].bP[7] then    //------------------------------- есть трассировка
              begin //--------------------------------- при трассировке светить немигающую
                OVBuffer[VidBuf].Param[11] := ObjZv[SVTF].bP[7]; //-трассировка из объекта
              end else

              //-------- здесь организуется мигание начала маневров при различии со "STAN"
              if tab_page then //-------------- проверка выдачи команды установки маршрута
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //СП занята и замкнута
                OVBuffer[VidBuf].Param[11]:=false //--- снять маневр. начало в видеобуфере
                else
                OVBuffer[VidBuf].Param[11]:=//--- иначе маневровое начало табло состоит из
                ObjZv[SVTF].bP[6] and not ObjZv[SVTF].bP[34]  // НМ и сброс трассы из STAN
              end else
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //СП занята и замкнута
                OVBuffer[VidBuf].Param[11] := false //---- снять маневровое начало в табло
                else OVBuffer[VidBuf].Param[11] := //-- маневровое начало табло состоит из
                ObjZv[SVTF].bP[7]; //-------------------------------------- МПР из объекта
              end;
            end
            else //------------------------------------------- если нет управления от АРМа
            OVBuffer[VidBuf].Param[11] := ObjZv[SVTF].bP[6];//-- маневровое начало из STAN

            if WorkMode.Upravlenie then //----------------------------- если АРМ управляет
            begin
              if not ObjZv[SVTF].bP[14] and ObjZv[SVTF].bP[9] then //нет замыкания, трасса
              begin //--------------------------------- при трассировке светить немигающую
                OVBuffer[VidBuf].Param[12] := //--------- поездное начало табло состоит из
                ObjZv[SVTF].bP[9]; //---------------- из поездной трассировки объекта АРМа
              end else //------------------------------ при наличии программного замыкания

              //-------- здесь организуется мигание начала поездных при различии со "STAN"
              if tab_page then //-------------- проверка выдачи команды установки маршрута
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //СП занята и замкнута
                OVBuffer[VidBuf].Param[12] := false //------ снять поездное начало в табло
                else
                OVBuffer[VidBuf].Param[12] := //-- иначе поездое начало в табло состоит из
                ObjZv[SVTF].bP[8] and //----------------------- начало П из FR3 ("stan") и
                not ObjZv[SVTF].bP[34] //---------------------- нет сброса трассы для STAN
              end else
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //СП занята и замкнута
                OVBuffer[VidBuf].Param[12]:=false //-------- снять поездное начало в табло
                else
                OVBuffer[VidBuf].Param[12] := ObjZv[SVTF].bP[9]; //--- из ППР объекта АРМа
              end;
            end else //------------------------------------------- если нет управления, то
            OVBuffer[VidBuf].Param[12] := ObjZv[SVTF].bP[8]; //----------- начало П из FR3
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

        sost := GetFR5(ObjZv[SVTF].ObCI[1]);

        if (ObjZv[SVTF].iP[2] = 0) and //--- индекс горы для сигналов надвига (признак ГВ)
        (ObjZv[SVTF].iP[3] = 0) and //--- индекс горы для сигналов осаживания (признак УН)
        not ObjZv[SVTF].bP[18] then //----------------------------------------- признак РМ
        begin //- контроль перекрытия сигнала, если не установлен маршрут надвига на горку
          if ((sost and 1) = 1) and not ObjZv[SVTF].bP[18] then
          begin //----------------------------------------- фиксируем перекрытие светофора
{$IFDEF RMDSP}
            if ObjZv[SVTF].RU = config.ru then
            begin
{$ENDIF}
              if WorkMode.OU[0] then
              begin //------------------------------ перекрытие в режиме управления с АРМа
                InsNewMsg(SVTF,396+$1000,0,''); //----------- "Зафиксировано перекрытие $"
                AddFixMes(GetSmsg(1,396,ObjZv[SVTF].Liter,0),4,1);
              end else
              begin //---------------------------- перекрытие в режиме управления с пульта
                InsNewMsg(SVTF,403+$1000,0,''); //------ "Зафиксировано перекрытие $ (АУ)"
                AddFixMes(GetSmsg(1,403,ObjZv[SVTF].Liter,0),4,1);
              end;
{$IFDEF RMDSP}
            end;
            ObjZv[SVTF].bP[23] :=
            WorkMode.Upravlenie and WorkMode.OU[0]; //Фиксировать,если включено управление
{$ENDIF}
{$IFNDEF RMDSP}
            ObjZv[SVTF].dtP[2] := LastTime;
            inc(ObjZv[SVTF].siP[2]);
            ObjZv[SVTF].bP[23] := true; //---------------------- Фиксировать неисправность
{$ENDIF}
          end;
        end
        else  ObjZv[SVTF].bP[23] := false; //--- если гора или МУ - снять фиксацию ненормы
        ;
        //--------------------------------------------------------{FR4}-------------------
        ObjZv[SVTF].bP[12] := //------------------ установить или снять блокировку сигнала
        GetFR4State(ObjZv[SVTF].ObCI[1]*8+2);
  {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[SVTF].RU=config.ru) then//управление в своем  РУ
        begin
          if tab_page
          then OVBuffer[VidBuf].Param[32] := ObjZv[SVTF].bP[13] //----------- блок из АРМа
          else OVBuffer[VidBuf].Param[32] :=  ObjZv[SVTF].bP[12]; //--------- блок из STAN
        end else
{$ENDIF}
        OVBuffer[VidBuf].Param[32] := ObjZv[SVTF].bP[12]//--------------------- иначе STAN
      end;

      //------------------------ в любом случае ------------------------------------------
      OVBuffer[VidBuf].Param[13] := ObjZv[SVTF].bP[23]; //--------------------- перекрытие

      Aktiv := true; //------------------------------------------------------ Активизация2
      Nepar:= false; //--------------------------------------------------- Непарафазность2
      ObjZv[SVTF].bP[30] := false;

      jso := GetFR3(ObjZv[SVTF].ObCI[9],Nepar,Aktiv);//-------------------------- ЖСо
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      zso :=  GetFR3(ObjZv[SVTF].ObCI[10],Nepar,Aktiv);//------------------------ зСо
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      so :=  GetFR3(ObjZv[SVTF].ObCI[25],Nepar,Aktiv);//-------------------------- Co
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      vnp := GetFR3(ObjZv[SVTF].ObCI[26],Nepar,Aktiv);//------------------------- ВНП
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      n :=   GetFR3(ObjZv[SVTF].ObCI[11],Nepar,Aktiv);//--------------------------- А
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      kz := GetFR3(ObjZv[SVTF].ObCI[30],Nepar,Aktiv);//--------------------------- Кз
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      OVBuffer[ObjZv[SVTF].VBufInd].Param[7] :=  Nepar;
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar; //-------------- непарафазность 2

      if not ObjZv[SVTF].bP[30] then //-------------------------------- если парафазность2
      begin
        if jso <> ObjZv[SVTF].bP[15] then
        begin //-------------------------------------------------------- изменение ЖСо(Со)
          if jso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].ObCI[10] = 0 then //--- если в объекте нет датчика зСо
                begin
                  if ObjZv[SVTF].bP[4] then //----------------------- если открыт поездной
                  InsNewMsg(SVTF,300+$1000,1,'')//"Неисправность разреш. огня светофора $"
                end
                else //---------------------------------------------- если есть датчик зСо
                begin
                  if ObjZv[SVTF].bP[4] then //----------------------- если открыт поездной
                  InsNewMsg(SVTF,485+$1000,0,'')//Неиспр. осн.нить лампы Жогня светофора $
                end;
              end;
{$ELSE}       //----------------------------- далее для АРМ ШН ---------------------------
              if ObjZv[SVTF].ObCI[10] = 0 then  //---- если в объекте нет датчика зСо
              begin
                if ObjZv[SVTF].bP[4]
                then InsNewMsg(SVTF,300+$1000,0,'');//Неисправность разр. огня светофора $
              end else
              begin
                if ObjZv[SVTF].bP[4]
                then InsNewMsg(SVTF,485+$1000,0,'');
                //----------- "Неисправность основной нити лампы желтого огня светофора $"
              end;
              SBeep[4] := true;
              ObjZv[SVTF].dtP[3] := LastTime;
              inc(ObjZv[SVTF].siP[3]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ сброс восприятия неисправности
        end;
        ObjZv[SVTF].bP[15] := jso; //-------------------------------- запомнить текущее Со

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if zso <> ObjZv[SVTF].bP[24] then
        begin //------------------------------------------------------------ изменение зСо
          if zso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].bP[4] then //------------------------------ открыт поездной
                begin
                  InsNewMsg(SVTF,486+$1000,0,'');// неисправна основная нить зеленой лампы
                  AddFixMes(GetSmsg(1,486,ObjZv[SVTF].Liter,0),4,4);
                  SBeep[4] := true;
                end;
              end;
{$ELSE}       //--------------------------------------------------------- далее для АРМ ШН
              if ObjZv[SVTF].bP[4] then
              InsNewMsg(SVTF,486+$1000,0,'');
              //-------------- Неисправность основной нити лампы зеленого огня светофора $
              SBeep[4] := true;
              ObjZv[SVTF].dtP[3] := LastTime;
              inc(ObjZv[SVTF].siP[3]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ сброс восприятия неисправности
        end;
        ObjZv[SVTF].bP[24] := zso; //------------------------------------------------- зСо

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if vnp  and ObjZv[SVTF].bP[4] then //----------------------- ВНП и открыт поездной
        begin
          if ObjZv[SVTF].T[4].Activ = false then  //----------- если таймен не был запущен
          begin
            ObjZv[SVTF].T[4].Activ := true; //--------------------------- запустить таймер
            ObjZv[SVTF].T[4].F := LastTime; //------------------- зафиксировать начало
            ObjZv[SVTF].T[4].S:= LastTime + 2/86400; //------------- ожидаемый конец
          end else
          begin //---------------------------------------------- если таймер активизирован
            if vnp and (ObjZv[SVTF].T[4].S< LastTime) then   //--------- время вышло
            begin
              ObjZv[SVTF].T[4].Activ := false;
              ObjZv[SVTF].T[4].F := 0;
              ObjZv[SVTF].T[4].S:= 0;
              if vnp then
              begin
                if ( WorkMode.FixedMsg and ((ObjZv[SVTF].iP[10] and $80) = 0)) then
                begin
{$IFDEF RMDSP}
                  if ObjZv[SVTF].RU = config.ru then
                  begin
                    InsNewMsg(SVTF,300+$1000,1,'');// "Неисправен разрешающий светофора $"
                    AddFixMes(GetSmsg(1,300,ObjZv[SVTF].Liter,1),4,4);
                    ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $80; //------- фиксация NN
                  end;
                end;
{$ELSE}
                  InsNewMsg(SVTF,300+$1000,1,'');
                  SBeep[4] := true;
                  ObjZv[SVTF].dtP[3] := LastTime;
                  inc(ObjZv[SVTF].siP[3]);
                  ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $80; //--------- фиксация NN
                end;
{$ENDIF}
                ObjZv[SVTF].bP[25] := vnp;
              end;
            end else
            begin
              ObjZv[SVTF].bP[25] := vnp;
              ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FF7F; //--------сброс фиксации
            end;
          end;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if so and ObjZv[SVTF].bP[4] then //-------------------------- Со и открыт поездной
        begin
          if ObjZv[SVTF].T[3].Activ = false then  //----------- если таймен не был запущен
          begin
            ObjZv[SVTF].T[3].Activ := true; //--------------------------- запустить таймер
            ObjZv[SVTF].T[3].F := LastTime; //------------------- зафиксировать начало
            ObjZv[SVTF].T[3].S:= LastTime + 2/86400; //------------- ожидаемый конец
          end else
          begin //---------------------------------------------- если таймер активизирован
            if so and (ObjZv[SVTF].T[3].S< LastTime) then   //---------- время вышло
            begin
              ObjZv[SVTF].T[3].Activ := false;
              ObjZv[SVTF].T[3].F := 0;
              ObjZv[SVTF].T[3].S:= 0;
              if WorkMode.FixedMsg and ((ObjZv[SVTF].iP[10] and $100) = 0) then
              begin
{$IFDEF RMDSP}
                if ObjZv[SVTF].RU = config.ru then
                begin
                  InsNewMsg(SVTF,544+$1000,0,'');// Неисправна нить разреш.лампы светофора
                  AddFixMes(GetSmsg(1,544,ObjZv[SVTF].Liter,0),4,4);
                  ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $100;
                end;
              end;
{$ELSE}
                InsNewMsg(SVTF,544+$1000,0,'');//- Неисправ.осн.нить разреш.огня светофора
                SBeep[4] := true;
                ObjZv[SVTF].dtP[3] := LastTime;
                inc(ObjZv[SVTF].siP[3]);
                ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $100;
              end;
{$ENDIF}
              ObjZv[SVTF].bP[26] := so;
            end;
          end;
        end else
        begin
          ObjZv[SVTF].bP[26] := so;
          ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FF; //------------- сброс фиксации
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if n <> ObjZv[SVTF].bP[17] then
        begin //-------------------------------------------------------------- Изменение А
          if n then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                InsNewMsg(SVTF,338+$1000,0,''); //---- "Авария шкафа входного светофора $"
                AddFixMes(GetSmsg(1,338,ObjZv[SVTF].Liter,0),4,4);
              end;
{$ELSE}
              InsNewMsg(SVTF,338+$1000,0,'');
              SBeep[4] := true;
              ObjZv[SVTF].dtP[4] := LastTime;
              inc(ObjZv[SVTF].siP[4]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ сброс восприятия неисправности
        end;
        ObjZv[SVTF].bP[17] := n;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if kz <> ObjZv[SVTF].bP[16] then
        begin //-------------------------------------------------------- Изменение Кз (Лс)
          if kz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].bP[4] then //------------------ если открыт поездной сигнал
                begin
                  InsNewMsg(SVTF,497+$1000,1,''); // Неисправен контроль разрешающих огней
                  AddFixMes(GetSmsg(1,497,ObjZv[SVTF].Liter,1),4,4);
                end else
                begin
                  InsNewMsg(SVTF,497+$1000,1,'');
                  AddFixMes(GetSmsg(1,497,ObjZv[SVTF].Liter,1),4,4);
                end;
              end;
{$ELSE}       //------------------ для АРМ ШН --------------------------------------------
              if ObjZv[SVTF].bP[4]
              then InsNewMsg(SVTF,487+$1000,1,'')//Переключение сигналов зеленый на желтый
              else InsNewMsg(SVTF,497+$1000,1,'');
              SBeep[4] := true;
              ObjZv[SVTF].dtP[5] := LastTime;
              inc(ObjZv[SVTF].siP[5]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ сброс восприятия неисправности
        end;
        ObjZv[SVTF].bP[16] := kz;


        OVBuffer[VidBuf].Param[17] := ObjZv[SVTF].bP[20]; //----- восприятие неисправности
        OVBuffer[VidBuf].Param[7] := ObjZv[SVTF].bP[30];//--------------- непарафазность 2
        if ObjZv[SVTF].bP[4] then
        begin
          OVBuffer[VidBuf].Param[8] := ObjZv[SVTF].bP[26];//------------------- Со в табло
          OVBuffer[VidBuf].Param[15] := ObjZv[SVTF].bP[24];//------------------------- зСо
          OVBuffer[VidBuf].Param[29] := ObjZv[SVTF].bP[15];//------------------------- ЖСо
          OVBuffer[VidBuf].Param[19] := ObjZv[SVTF].bP[25]; //------------------------ ВНП
        end;
        OVBuffer[VidBuf].Param[9] :=  ObjZv[SVTF].bP[16]; //--------------------------- Кз
        OVBuffer[VidBuf].Param[10] := ObjZv[SVTF].bP[17]; //---------------------------- А
        OVBuffer[VidBuf].Param[14] := ObjZv[SVTF].bP[14];//--------------------- змк РМДСП
      end;
    end;
end;

//========================================================================================
//-------------------------------- подготовка объекта ограждения пути к выводу на табло #6
procedure PrepPTO(PTO : Integer);
var
  zo,og : boolean;
  VBUF,OZ,OGR,SOG : integer;
begin
  OZ := ObjZv[PTO].ObCI[2];
  OGR := ObjZv[PTO].ObCI[3];
  SOG := ObjZv[PTO].ObCI[4];

  ObjZv[PTO].bP[31] := true; //----------------------------------------------- Активизация
  ObjZv[PTO].bP[32] := false; //------------------------------------------- Непарафазность
  VBUF := ObjZv[PTO].VBufInd;

  zo := GetFR3(OZ,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //----------------------------- Оз
  og := GetFR3(OGR,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //---------------------------- оГ

  ObjZv[PTO].bP[3] := GetFR3(SOG,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //------------- СоГ

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[PTO].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[PTO].bP[32];
    if ObjZv[PTO].bP[31] and not ObjZv[PTO].bP[32] then
    begin
      OVBuffer[VBUF].Param[18] := (config.ru = ObjZv[PTO].RU); //-------- РУ соответствует
      OVBuffer[VBUF].Param[16] := ObjZv[PTO].bP[31];
      OVBuffer[VBUF].Param[1] := false;

      if og <> ObjZv[PTO].bP[2] then
      begin
        if og then //---------------------------------------------- установлено ограждение
        begin
          if not zo then //------------- если нет запроса на ограждение - запустить таймер
          begin
            ObjZv[PTO].T[1].F := LastTime + 3/80000;
            ObjZv[PTO].T[1].Activ  := true;
            ObjZv[PTO].bP[4] := false; //--------- разблокировать ловушку неисправности ОГ
            ObjZv[PTO].bP[5] := false;
          end;
        end else  ObjZv[PTO].T[1].Activ  := false; //------------------------------- снято
      end;

      ObjZv[PTO].bP[2] := og;

      if zo <> ObjZv[PTO].bP[1] then
      begin
        if zo then  //------------------------------------------ получен запрос ограждения
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = ObjZv[PTO].RU) then
            begin
              InsNewMsg(PTO,295,7,''); //-------------------- Получен запрос на ограждение
              if WorkMode.Upravlenie
              then AddFixMes(GetSmsg(1,295,ObjZv[PTO].Liter,7),4,6);
            end;
{$ELSE}
            InsNewMsg(PTO,295,7,'');
{$ENDIF}
          end;
        end else
        begin //--------------------------------------------------- снят запрос ограждения
          ObjZv[PTO].bP[4] := false; //----------- разблокировать ловушку неисправности ОГ
          ObjZv[PTO].bP[5] := false;
          ObjZv[PTO].T[1].F := LastTime + 3/80000;
          ObjZv[PTO].T[1].Activ  := true;
        end;
      end;
      ObjZv[PTO].bP[1] := zo;

      OVBuffer[VBUF].Param[6] := ObjZv[PTO].bP[4];

      if ObjZv[PTO].bP[2] and not ObjZv[PTO].bP[1] then
      begin //----------------------------------------------------- ограждение без запроса
        if ObjZv[PTO].T[1].Activ  then
        begin
          if (ObjZv[PTO].T[1].F > LastTime) or ObjZv[PTO].bP[4]  //------- время вышло
          then  OVBuffer[VBUF].Param[7] := ObjZv[PTO].bP[2]
          else
          begin
            if not ObjZv[PTO].bP[5] then
            begin //------------------------------------------- фиксируем неисправность ОГ
              ObjZv[PTO].bP[5] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if (config.ru = ObjZv[PTO].RU) then
                begin
                  InsNewMsg(PTO,337+$1000,1,''); //--- Неисправность схемы ограждения пути
                  AddFixMes(GetSmsg(1,337,ObjZv[PTO].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(PTO,337+$1000,1,'');
                ObjZv[PTO].dtP[1] := LastTime;
                inc(ObjZv[PTO].siP[1]);
{$ENDIF}
              end;
            end;
            OVBuffer[VBUF].Param[7] := true;
          end;
        end;
        OVBuffer[VBUF].Param[8] := false;
      end else
      begin
        OVBuffer[VBUF].Param[6] := false;
        OVBuffer[VBUF].Param[8] := ObjZv[PTO].bP[1];
        OVBuffer[VBUF].Param[7] := ObjZv[PTO].bP[2];
        ObjZv[PTO].T[1].Activ  := false;
      end;
    end;
  end;
end;

//========================================================================================
//--------------------- Подготовка объекта пригласительного сигнала для вывода на табло #7
procedure PrepPriglasit(PRIG : Integer);
var
  i,prs,pso,VBUF : integer;
  ps : boolean;
begin
  prs := ObjZv[PRIG].ObCI[2];
  pso := ObjZv[PRIG].ObCI[3];
  ObjZv[PRIG].bP[31] := true; //---------------------------------------------- Активизация
  ObjZv[PRIG].bP[32] := false; //------------------------------------------ Непарафазность

  ps := GetFR3(prs,ObjZv[PRIG].bP[32],ObjZv[PRIG].bP[31]);//--------------------------- ПС

  if  pso > 0 then
  ObjZv[PRIG].bP[2] := not GetFR3(pso,ObjZv[PRIG].bP[32],ObjZv[PRIG].bP[31]);//------- ПСо

  if ObjZv[PRIG].VBufInd > 0 then
  begin
    VBUF := ObjZv[PRIG].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[PRIG].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[PRIG].bP[32];
    if ObjZv[PRIG].bP[31] and not ObjZv[PRIG].bP[32] then
    begin
      if ps <> ObjZv[PRIG].bP[1] then
      begin
        if ps then
        begin
{$IFDEF RMDSP or $IFDEF RMSHN}
          if config.ru = ObjZv[PRIG].RU then begin
            InsNewMsg(PRIG,380+$2000,0,'');
            AddFixMes(GetSmsg(1,380,ObjZv[PRIG].Liter,0),0,6);
          end;
{$ELSE}
          InsNewMsg(PRIG,380+$2000,0,'');
{$ENDIF}
        end;
      end;
      ObjZv[PRIG].bP[1] := ps;

      i := ObjZv[PRIG].ObCI[1] * 2;  //------ номер параметра ПС в буфере отображения

      OVBuffer[VBUF].Param[i] := ObjZv[PRIG].bP[1]; //--------- копировать значение для ПС

      if ObjZv[PRIG].ObCI[3] > 0 then  //------------------------------ если есть ПСо
      begin
        OVBuffer[VBUF].Param[i+1] := ObjZv[PRIG].bP[2]; //--- скопировать значение для ПСо
        if ObjZv[PRIG].bP[1] then
        begin //----------------------------------- если ПС открыт - проверить исправность
          if ObjZv[PRIG].bP[2] then
          begin
            if not ObjZv[PRIG].bP[19] then //------------------------- если не фиксирована
            begin //--------------------------------------------------- подождать 3 секунд
              if ObjZv[PRIG].T[1].Activ  then
              begin
                if ObjZv[PRIG].T[1].F < LastTime then //------------------ время вышло
                begin
                  if WorkMode.FixedMsg then
                  begin
{$IFDEF RMDSP}
                    if (config.ru = ObjZv[PRIG].RU) then
                    begin
                      InsNewMsg(PRIG,454+$1000,1,'');//Неисправность пригласительного огня
                      AddFixMes(GetSmsg(1,454,ObjZv[PRIG].Liter,1),4,4);
                    end;
{$ELSE}
                    InsNewMsg(PRIG,454+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                    ObjZv[PRIG].bP[19] := true; //-------------- фиксация неисправности ПС
                  end;
                end;
              end else
              begin
                ObjZv[PRIG].T[1].Activ  := true;
                ObjZv[PRIG].T[1].F := LastTime + 3/80000; //----------- запуск таймера
              end;
            end;
          end else
          begin
            ObjZv[PRIG].T[1].Activ  := false;
            ObjZv[PRIG].bP[19] := false; //--------------- сброс фиксации неисправности ПС
          end;
        end else
        begin
          ObjZv[PRIG].T[1].Activ  := false;
          ObjZv[PRIG].bP[19] := false; //----------------- сброс фиксации неисправности ПС
        end;
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------- подготовка объекта УТС к выводу на экран #8
procedure PrepUTS(UTS : Integer);
var
  uu : Boolean;
  PUT : integer;
begin
  with ObjZv[UTS] do
  begin
    bP[31] := true;  bP[32] := false; //----------------------- Активизация и парафазность
    bP[1] := GetFR3(ObCI[2],bP[32],bP[31]); //---------------------- датчик УС (упор снят)
    uu := GetFR3(ObCI[3],bP[32],bP[31]);    //---------------- датчик УУ (упор установлен)
    bP[3] := GetFR3(ObCI[4],bP[32],bP[31]); //- датчик СУС (упор выключен из зависимостей)

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31]; OVBuffer[VBufInd].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        PUT := BasOb;
        if uu <> bP[2] then
        begin
          if (PUT > 0) and not bP[3] and uu and not bP[4] then //упор установлен, не выкл.
          begin
            // фиксируем изменение положения упора в установленном маршруте приема на путь
            if (not ObjZv[PUT].bP[2] and not ObjZv[PUT].bP[4]) or  //- если ЧИ без ЧКМ или
            (not ObjZv[PUT].bP[3] and not ObjZv[PUT].bP[15]) then //----------- НИ без НКМ
            begin
              bP[4] := true; //--------------------------------------------------- ловушка
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  //---------- Установлен тормозной упор $ при замкнутом поездном маршруте
                  InsNewMsg(UTS,495+$2000,1,'');
                  AddFixMes(GetSmsg(1,495,ObjZv[BasOb].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(UTS,495+$2000,1,'');
{$ENDIF}
              end;
            end;
          end;

          if uu and not bP[1] then
          begin //-------------------------------------------------------- Упор установлен
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UTS,108+$2000,1,''); //------------------ Установлен тормозной упор
                AddFixMes(GetSmsg(1,108,ObjZv[BasOb].Liter,1),0,2);
              end;
{$ELSE}
              InsNewMsg(UTS,108+$2000,1,'');
{$ENDIF}
            end;
          end;
        end;
        bP[2] := uu;

        if not (uu xor bP[1]) then
        begin //--------------------------------------------------- нет контроля положения
          if (PUT > 0) and not bP[3] and not bP[4] then
          begin
            if (not ObjZv[BasOb].bP[2] and not ObjZv[BasOb].bP[4]) or
            (not ObjZv[BasOb].bP[3] and not ObjZv[BasOb].bP[15]) then
            begin //-------- фиксируем изменение положения упора в маршруте приема на путь
              bP[4] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  //-- Изменено положение тормозного упора при замкнутом поездном маршруте
                  InsNewMsg(UTS,496+$2000,1,'');
                  AddFixMes(GetSmsg(1,496,ObjZv[BasOb].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(UTS,496+$2000,1,'');
{$ENDIF}
              end;
            end;
          end;
          if not WorkMode.FixedMsg then bP[4] := true; //--- блокировать на старте системы
          if not bP[4] then
          begin //--------------------------- не зафиксировано сообщение о потере контроля
            if T[1].Activ  then
            begin
              if T[1].F < LastTime then
              begin //---------------------- Зафиксировать потерю контроля положения упора
                bP[4] := true;
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  InsNewMsg(UTS,109+$1000,1,''); //Тормозной упор не имеет контроля положения
                  AddFixMes(GetSmsg(1,109,ObjZv[BasOb].Liter,1),4,1);
                end;
{$ELSE}
                InsNewMsg(UTS,109+$1000,1,'');
                SBeep[1] := true;
{$ENDIF}
              end;
            end else
            begin //------------------------------------------------ начать отсчет времени
              T[1].F := LastTime+ 15/86400;
              T[1].Activ  := true;
            end;
          end;
        end else
        begin
          T[1].Activ  := false;
          bP[4] := false;
        end;
        OVBuffer[VBufInd].Param[2] := bP[1];
        OVBuffer[VBufInd].Param[3] := bP[2];
        OVBuffer[VBufInd].Param[4] := bP[3];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------- Подготовка объекта ручного замыкания стрелок для вывода на табло #9
procedure PrepRZS(RZST : Integer);
var
  rz,dzs,odzs : boolean;
  ii,cod,Vbufer,DatRZ,DatDZS,DatODZS,Ns,Alr,Clr: integer;
  TXT : string;
begin
  with ObjZv[RZST]do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    DatRZ  := ObCI[6];    DatDZS := ObCI[2];   DatODZS := ObCI[4]; //---- индексы датчиков
    for ii := 1 to 32 do NParam[ii] := false; //----------------------------- парафазность

    rz :=  GetFR3(DatRZ,NParam[1],bP[31]);
    if  DatDZS > 0 then dzs := GetFR3(DatDZS,NParam[2],bP[31])   else  dzs := rz;
    if DatODZS > 0 then odzs := GetFR3(DatODZS,NParam[3],bP[31]) else odzs := rz;

    cod := 0;

    if VBufInd > 0 then
    begin
      Vbufer := VBufInd; OVBuffer[Vbufer].Param[16] := bP[31];

      if bP[31] then
      begin
        if rz then cod:= cod + 1; if dzs then cod:= cod + 2; if odzs then cod:= cod + 4;

        bP[1] := rz;
        OVBuffer[Vbufer].Param[2]:= rz; OVBuffer[VBufer].NParam[2]:= NParam[1]; //----- Рз

        bP[2] := dzs;
        OVBuffer[VBufer].Param[3]:= dzs;  OVBuffer[VBufer].NParam[3]:= NParam[2]; //-- ДзС

        bP[3] := odzs;
        OVBuffer[VBufer].Param[4]:= odzs; OVBuffer[VBufer].NParam[4]:= NParam[3]; //- оДзС

        if cod <> iP[1] then //-------------------------- если изменился код состояния РзС
        begin
          if not T[1].Activ then begin T[1].Activ:= true;T[1].F:= LastTime + 2/86400; end;
        end;

        if T[1].Activ and (LastTime > T[1].F) then
        begin
        {$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru=RU) and not WorkMode.RU[0] then
          case cod of
            0    : begin Ns := 559; Clr := 7; Alr := 2; end; //------------- РзС отключено
            1    : begin Ns := 560; Clr := 1; Alr := 3; end; //-- РзС включено без команды
            2,4,6: begin Ns := 561; Clr := 1; Alr := 3; end;//при командах РзС не включено
            5    : begin Ns := 562; Clr := 7; Alr := 2; end;//------ пред.команда откл.РзС
            3,7  : begin Ns := 558; Clr := 7; Alr := 2; end; //--- выполнено включение РзС
          end;
          InsNewMsg(RZST,Ns+$2000,Clr,'');
          TXT := GetSmsg(1,Ns,Liter,Clr);
          if Alr = 2 then AddFixMes(TXT,0,Alr) else AddFixMes(TXT,4,Alr);
          PutSMsg(Clr,LastX,LastY,TXT);
          SBeep[2] := WorkMode.Upravlenie;
          {$ELSE}
          case cod of
            0       : begin Ns := 559; Clr := 7; end; //-------------------- РзС отключено
            1       : begin Ns := 560; Clr := 1; end; //--------- РзС включено без команды
            2,3,4,6 : begin Ns := 561; Clr := 1; end; //----- при командах РзС не включено
            5       : begin Ns := 562; Clr := 1; end; //-- выполнена пред.команда откл.РзС
            7       : begin Ns := 558; Clr := 7; end; //---------- выполнено включение РзС
          end;
          InsNewMsg(RZST,Ns+$2000,Clr,'');
          SBeep[3] := true;
{$ENDIF}
          T[1].Activ  := false;
          T[1].F := 0;
        end;
        iP[1] := cod;
      end;
    end;
  end;
end;

//========================================================================================
//------------------------ Подготовка объекта управления переездом для вывода на табло #10
procedure PrepUPer(UPER : Integer);
var
  rz : boolean;
  VBUF,ii, Zp, Piv, Uzp, Uzpd : integer;
begin
  Zp   := ObjZv[UPER].ObCI[10];
  Piv  := ObjZv[UPER].ObCI[11];
  Uzp  := ObjZv[UPER].ObCI[12];
  Uzpd :=  ObjZv[UPER].ObCI[13];
  for ii := 1 to 32  do ObjZv[UPER].NParam[ii] := false;//----------------- Непарафазность

  ObjZv[UPER].bP[31] := true; //---------------------------------------------- Активизация
  rz := GetFR3(Zp,ObjZv[UPER].NParam[10],ObjZv[UPER].bP[31]); //----------------------- зП
  ObjZv[UPER].bP[11] := GetFR3(Piv,ObjZv[UPER].NParam[11],ObjZv[UPER].bP[31]); //----- ПИВ
  ObjZv[UPER].bP[12] := GetFR3(Uzp,ObjZv[UPER].NParam[12],ObjZv[UPER].bP[31]); //----- УзП
  ObjZv[UPER].bP[13] := GetFR3(Uzpd,ObjZv[UPER].NParam[13],ObjZv[UPER].bP[31]);//---- УзПД

  if ObjZv[UPER].VBufInd > 0 then
  begin
    VBUF := ObjZv[UPER].VBufInd;
    if ObjZv[UPER].bP[31] then
    begin
      OVBuffer[VBUF].Param[12]  := ObjZv[UPER].bP[12]; //----------------------------- УзП
      OVBuffer[VBUF].NParam[12] := ObjZv[UPER].NParam[12]; //------------------------- УзП

      OVBuffer[VBUF].Param[13] := ObjZv[UPER].bP[13]; //----------------------------- УзПД
      OVBuffer[VBUF].NParam[13] := ObjZv[UPER].NParam[13]; //--------- непарафазность УзПД

      if rz <> ObjZv[UPER].bP[10] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPER].RU then
            begin
              InsNewMsg(UPER,575+$2000,0,''); //----------------------------------- нажата ЗП
              AddFixMes(GetSmsg(1,575,ObjZv[UPER].Liter,0),0,2);
            end;
{$ELSE}
            InsNewMsg(UPER,575+$2000,0,'');
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPER].RU then
            begin
              InsNewMsg(UPER,576+$2000,0,'');  //------------------- освобождена кнопка ЗП
              AddFixMes(GetSmsg(1,576,ObjZv[UPER].Liter,0),0,2);
            end;
{$ELSE}
            InsNewMsg(UPER,576+$2000,0,'');
{$ENDIF}
          end;
        end;
      end;

      ObjZv[UPER].bP[10] := rz;
      OVBuffer[VBUF].Param[10] := ObjZv[UPER].bP[10];
      OVBuffer[VBUF].NParam[10] := ObjZv[UPER].NParam[10];

{$IFDEF RMDSP}
      if config.ru = ObjZv[UPER].RU then
      begin
        if rz then
        begin //----------------------------------------------------------- переезд закрыт
          if ObjZv[UPER].T[1].Activ  then
          begin
            if ObjZv[UPER].T[1].F < LastTime then
            begin //-------- выдать сообщение о длительном закрытии переезда под кнопку зП
              if not ObjZv[UPER].bP[5] then
              begin
                InsNewMsg(UPER,514+$2000,0,''); //---- Переезд длительно закрыт кнопкой зП
                AddFixMes(GetSmsg(1,514,ObjZv[UPER].Liter,0),4,4);
                ObjZv[UPER].T[1].F := LastTime + 60 / 86400;//---- ожидание повторного
                ObjZv[UPER].bP[5] := true;
              end;
            end else ObjZv[UPER].bP[5] := false;
          end else
          begin //----------------------------------- задать ожидание первичного сообщения
            ObjZv[UPER].T[1].F := LastTime + 600 / 86400;
            ObjZv[UPER].T[1].Activ  := true;
          end;
        end else
        begin //----------------------------------------------------------- переезд открыт
          ObjZv[UPER].T[1].Activ  := false;
          ObjZv[UPER].bP[5] := false;//------ сброс фиксации длительного закрытия перезда
        end;
      end;
{$ENDIF}

      OVBuffer[VBUF].Param[11] := ObjZv[UPER].bP[11]; //------------------------------- ПИ
      OVBuffer[VBUF].NParam[11] := ObjZv[UPER].NParam[11]; //-------------------------- ПИ
    end;
    OVBuffer[VBUF].Param[16] := ObjZv[UPER].bP[31];
  end;
end;

//========================================================================================
//------------------------ Подготовка объекта контроля(1) переезда для вывода на табло #11
procedure PrepKPer(KPER : Integer);
var
  Npi,Cpi,kop,knp,kap,zg,kzp,Nepar : boolean;
  ii : integer;
begin
  ObjZv[KPER].bP[31] := true; //---------------------------------------------- Активизация
  Nepar := false;  //------------------------------------------------------ Непарафазность

  kap :=  GetFR3(ObjZv[KPER].ObCI[2],Nepar,ObjZv[KPER].bP[31]); //--------------- КПА
  ObjZv[KPER].NParam[2] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  knp := GetFR3(ObjZv[KPER].ObCI[3],Nepar,ObjZv[KPER].bP[31]); //---------------- КПН
  ObjZv[KPER].NParam[3] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  kzp :=  GetFR3(ObjZv[KPER].ObCI[4],Nepar,ObjZv[KPER].bP[31]); //--------------- КзП
  ObjZv[KPER].NParam[4] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  zg := GetFR3(ObjZv[KPER].ObCI[14],Nepar,ObjZv[KPER].bP[31]);//------------------ зГ
  ObjZv[KPER].NParam[14] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  kop := GetFR3(ObjZv[KPER].ObCI[9],Nepar,ObjZv[KPER].bP[31]); //---------------- КоП
  ObjZv[KPER].NParam[9] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  Npi := GetFR3(ObjZv[KPER].ObCI[8],Nepar,ObjZv[KPER].bP[31]); //---------------- НПИ
  ObjZv[KPER].NParam[8] := Nepar;

  Nepar := false;  //------------------------------------------------------ Непарафазность
  Cpi := GetFR3(ObjZv[KPER].ObCI[10],Nepar,ObjZv[KPER].bP[31]); //--------------- ЧПИ
  ObjZv[KPER].NParam[10] := Nepar;

  ObjZv[KPER].bP[8] := Npi or Cpi;
  ObjZv[KPER].bP[9] := kop;

  if ObjZv[KPER].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[KPER].VBufInd].Param[16] := ObjZv[KPER].bP[31];
    if ObjZv[KPER].bP[31] then
    begin
      if kap <> ObjZv[KPER].bP[2] then
      begin
        if kap then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,143+$1000,0,'');  //---------------------- "авария переезда"
              AddFixMes(GetSmsg(1,143,ObjZv[KPER].Liter,0),4,3);
              SBeep[3] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,143+$1000,0,'');
{$ENDIF}
          end;
        end;
      end;

      ObjZv[KPER].bP[2] := kap;
      OVBuffer[ObjZv[KPER].VBufInd].Param[2] := ObjZv[KPER].bP[2]; //------------ КПА
      OVBuffer[ObjZv[KPER].VBufInd].NParam[2] := ObjZv[KPER].NParam[2]; //------- КПА
      if knp <> ObjZv[KPER].bP[3] then
      begin
        if knp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,144+$1000,0,''); //----------------- "неиспарвность переезда"
              AddFixMes(GetSmsg(1,144,ObjZv[KPER].Liter,0),4,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,144+$1000,0,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER].bP[3] := knp;
      OVBuffer[ObjZv[KPER].VBufInd].Param[3] := ObjZv[KPER].bP[3]; //------------ КПН
      OVBuffer[ObjZv[KPER].VBufInd].NParam[3] := ObjZv[KPER].NParam[3]; //------- КПН

      if kzp <> ObjZv[KPER].bP[4] then
      begin
        if kzp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,371+$2000,0,''); //------------------------ "Закрыт переезд"
              AddFixMes(GetSmsg(1,371,ObjZv[KPER].Liter,0),4,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,371+$2000,0,'');
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,372+$2000,0,''); //------------------------- "Открыт переезд"
              AddFixMes(GetSmsg(1,372,ObjZv[KPER].Liter,0),0,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,372+$2000,0,'');
{$ENDIF}
          end;
        end
      end;
      ObjZv[KPER].bP[4] := kzp;
      OVBuffer[ObjZv[KPER].VBufInd].Param[4] := ObjZv[KPER].bP[4]; //------------ КзП
      OVBuffer[ObjZv[KPER].VBufInd].NParam[4] := ObjZv[KPER].NParam[4]; //------- КзП

      if zg <> ObjZv[KPER].bP[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,107+$2000,0,'');//"включена заград. сигнализация на переезде"
              AddFixMes(GetSmsg(1,107,ObjZv[KPER].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER,107+$2000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER].bP[14] := zg;
      OVBuffer[ObjZv[KPER].VBufInd].Param[14] := ObjZv[KPER].bP[14]; //------------ЗГ
      OVBuffer[ObjZv[KPER].VBufInd].Param[4] := ObjZv[KPER].bP[4];  //----------- КзП
      OVBuffer[ObjZv[KPER].VBufInd].Param[9] := ObjZv[KPER].bP[9];  //----------- КОП
      OVBuffer[ObjZv[KPER].VBufInd].Param[8] := ObjZv[KPER].bP[8];  //------------ ПИ
      OVBuffer[ObjZv[KPER].VBufInd].NParam[14] := ObjZv[KPER].NParam[14]; //-------ЗГ
      OVBuffer[ObjZv[KPER].VBufInd].NParam[4] := ObjZv[KPER].NParam[4];  //------ КзП
      OVBuffer[ObjZv[KPER].VBufInd].NParam[9] := ObjZv[KPER].NParam[9];  //------ КОП
      OVBuffer[ObjZv[KPER].VBufInd].NParam[8] := ObjZv[KPER].NParam[8];  //------- ПИ
    end;
  end;
end;

//========================================================================================
//------------------------ Подготовка объекта контроля(2) переезда для вывода на табло #12
procedure PrepK2Per(KPER2 : Integer);
var
  knp,knzp,kop,zg : Boolean;
  ii : integer;
begin
  ObjZv[KPER2].bP[31] := true; //-------------------- Активизация предварительно установлена

  for ii := 2 to 14 do  ObjZv[KPER2].NParam[ii] := false; //--- Непарафазность убрать везде

  knp :=   //------------------------------------------------------ неисправность переезда
  GetFR3(ObjZv[KPER2].ObCI[3],ObjZv[KPER2].NParam[3],ObjZv[KPER2].bP[31]);// КНП/КПН

  knzp :=  //--------------------------------------------------------- закрытость переезда
  GetFR3(ObjZv[KPER2].ObCI[4],ObjZv[KPER2].NParam[4],ObjZv[KPER2].bP[31]);//КНзП/КзП

  zg :=  //--------------------------------------------------------- заградительный сигнал
  GetFR3(ObjZv[KPER2].ObCI[14],ObjZv[KPER2].NParam[14],ObjZv[KPER2].bP[31]); //-- зГ

  if ObjZv[KPER2].ObCI[9] >0  then //---------------------- если существует датчик КоП
  kop := //----------------------------------------------------------- открытость переезда
  GetFR3(ObjZv[KPER2].ObCI[9],ObjZv[KPER2].NParam[9],ObjZv[KPER2].bP[31]) //--- КоП
  else kop := not knzp; //------------------------- если датчика Коп нет, то инверсия КНзП

  ObjZv[KPER2].bP[8] := //------------------------------------------ нечетное извещение
  GetFR3(ObjZv[KPER2].ObCI[8],ObjZv[KPER2].NParam[8],ObjZv[KPER2].bP[31]); //--- НПИ

  ObjZv[KPER2].bP[10] := //------------------------------------------- четное извещение
  GetFR3(ObjZv[KPER2].ObCI[10],ObjZv[KPER2].NParam[10],ObjZv[KPER2].bP[31]);//-- ЧПИ

  if ObjZv[KPER2].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[KPER2].VBufInd].Param[16] := ObjZv[KPER2].bP[31];

    if ObjZv[KPER2].bP[31] then
    begin
      if knp <> ObjZv[KPER2].bP[3] then
      begin //----------------------------- изменение по датчику неисправности на переезде
        if knp then
        begin //----------------------------- зафиксировать переход исправен -> неисправен
          ObjZv[KPER2].T[2].F := LastTime + 10/86400; //------- зарядить таймер на 10 сек.
          ObjZv[KPER2].T[2].Activ  := true;  //-------------------------- запустить таймер
        end else
        begin //----------------------------- зафиксировать переход неисправен -> исправен
          ObjZv[KPER2].T[2].F := 0;
          ObjZv[KPER2].T[2].Activ := false;
          ObjZv[KPER2].bP[3] := false; //------- сбросить индикацию неисправности переезда
          ObjZv[KPER2].bP[3] := knp;
        end;
      end;


      if not ObjZv[KPER2].bP[3] and ObjZv[KPER2].T[2].Activ  then
      begin //-------------------- ожидание 10 секунд по датчику неисправности на переезде
        if ObjZv[KPER2].T[2].F < LastTime then
        begin //------------------------------------- отображаем неисправность на переезде
          ObjZv[KPER2].bP[3] := true;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER2].RU then
            begin
              InsNewMsg(KPER2,144+$1000,0,''); //"неисправность на переезде"
              AddFixMes(GetSmsg(1,144,ObjZv[KPER2].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER2,144+$1000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;

      if knzp and not kop then //--------------------- получен контроль закрытого переезда
      begin
        ObjZv[KPER2].bP[4] := true; //--------------------------------------------- КзП
        ObjZv[KPER2].bP[9] := false; //-------------------------------------------- КоП
        ObjZv[KPER2].bP[2] := false;  //------------------------------------------- КПА
        ObjZv[KPER2].T[1].F := 0;
        ObjZv[KPER2].T[1].Activ  := false;
        ObjZv[KPER2].bP[6] := false;  //---------------------------------- Фиксация КАП
      end else
      if kop and not knzp then //--------------------- получен контроль открытого переезда
      begin
        ObjZv[KPER2].bP[4] := false; //-------------------------------------------- КзП
        ObjZv[KPER2].bP[9] := true; //--------------------------------------------- КоП
        ObjZv[KPER2].bP[2] := false; //-------------------------------------------- КПА
        ObjZv[KPER2].T[1].F := 0;
        ObjZv[KPER2].T[1].Activ  := false;
        ObjZv[KPER2].bP[6] := false; //----------------------------------- Фиксация КАП
      end else
      begin //--------------------------------------------------------- авария на переезде
        if not ObjZv[KPER2].T[1].Activ  then
        begin //------------------------------- зафиксировать изменение исправен -> авария
          ObjZv[KPER2].T[1].F := LastTime+10/86400;
          ObjZv[KPER2].T[1].Activ  := true;
          ObjZv[KPER2].bP[6] := true;     //Фиксация КАП
        end else
        if not ObjZv[KPER2].bP[2] then   // КПА
        begin // ожидаем 10 секунд по датчику аварии на переезде
          if ObjZv[KPER2].T[1].F < LastTime then
          begin // отображаем аварию на переезде
            ObjZv[KPER2].bP[1] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[KPER2].RU then
               begin
                InsNewMsg(KPER2,143+$1000,0,'');      // "авария переезда"
                AddFixMes(GetSmsg(1,143,ObjZv[KPER2].Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(KPER2,143+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        ObjZv[KPER2].bP[4] := false;    //КзП
        ObjZv[KPER2].bP[9] := false;    //КОП
      end;

      OVBuffer[ObjZv[KPER2].VBufInd].Param[16] := ObjZv[KPER2].bP[31];

      for ii := 1 to 30 do
      OVBuffer[ObjZv[KPER2].VBufInd].NParam[ii] := ObjZv[KPER2].NParam[ii];

      OVBuffer[ObjZv[KPER2].VBufInd].Param[2] := ObjZv[KPER2].bP[2]; //кпа

      if ObjZv[KPER2].bP[3] then // авария на переезде
      OVBuffer[ObjZv[KPER2].VBufInd].Param[3] := ObjZv[KPER2].bP[2]
      else // неисправность на переезде
        OVBuffer[ObjZv[KPER2].VBufInd].Param[3] := ObjZv[KPER2].bP[3];  //кнп
      OVBuffer[ObjZv[KPER2].VBufInd].Param[4] := ObjZv[KPER2].bP[4];    //кзп
      if zg <> ObjZv[KPER2].bP[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER2].RU then begin
              InsNewMsg(KPER2,107+$2000,0,''); //"включена заград. сигнализация на переезде"
              AddFixMes(GetSmsg(1,107,ObjZv[KPER2].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER2,107+$2000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER2].bP[14] := zg;
      OVBuffer[ObjZv[KPER2].VBufInd].Param[14] := ObjZv[KPER2].bP[14];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[9] := ObjZv[KPER2].bP[9];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[4] := ObjZv[KPER2].bP[4];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[8] := ObjZv[KPER2].bP[8];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[10] := ObjZv[KPER2].bP[10];
    end;
  end;
end;

//========================================================================================
//------------------------- Подготовка объекта оповещения монтеров для вывода на табло #13
procedure PrepOM(OPV : Integer);
var
  nepar,rz,rrm,vod,vo : boolean;
  i : integer;
begin
  with ObjZv[OPV] do
  begin
    bP[31] := true;  bP[32] := false; //------------------------Активизация Непарафазность
    for i := 1 to 34 do NParam[i] := false;

    rz    := GetFR3(ObCI[2],NParam[2],bP[31]);//---------------------------------- Во(УРО)
    rrm   := GetFR3(ObCI[3],NParam[3],bP[31]);//-------------------------------------- РРМ
    bP[4] := GetFR3(ObCI[4],NParam[4],bP[31]);//--------------------------------- ВКо(ОМП)
    bP[5] := GetFR3(ObCI[5],NParam[5],bP[31]);//--------------------------------- ВВМ(ВСВ)
    vo    := GetFR3(ObCI[6],NParam[6],bP[31]);//--------------------------------------- Вo
    vod   := GetFR3(ObCI[7],NParam[7],bP[31]);//-------------------------------------- ВоД

    for i := 2 to 7 do nepar := nepar or NParam[i];
    bp[32] := nepar;

    if VBufInd > 0 then
    begin
      for i := 1 to 32 do OVBuffer[VBufInd].NParam[i] := NParam[i];
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];

      if bP[31] and not nepar then
      begin
        if rz <> bP[2] then //----------------------------------------- если изменилось Во
        begin
          if rz then //----------------------------------------------------------- если Во
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObCB[1] then
              begin //--------------------------------------------------- подключаемый УРО
                if bP[3] and (config.ru = RU) then
                begin
                  InsNewMsg(OPV,374+$2000,7,'');  //------------ отключено оповещение "поезд"
                  AddFixMes(GetSmsg(1,374,Liter,7),0,2);
                end;
              end else
              begin
                if config.ru = ObjZv[OPV].RU then
                begin
                  InsNewMsg(OPV,373+$2000,7,''); //------------- включено оповещение "поезд"
                  AddFixMes(GetSmsg(1,373,Liter,7),0,2);
                end;
              end;
{$ELSE}     //----------------------------------------------------------------- для АРМ ШН
              if ObCB[1] then InsNewMsg(OPV,374+$2000,7,'')
              else InsNewMsg(OPV,373+$2000,7,'');
{$ENDIF}
            end;
          end else
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObCB[1] then
              begin //--------------------------------------------------- подключаемый УРО
                if rrm and (config.ru = RU) then
                begin
                  InsNewMsg(OPV,373+$2000,1,'');
                  AddFixMes(GetSmsg(1,373,Liter,1),0,2);
                end;
              end else
              begin
                if config.ru = RU then
                begin
                  InsNewMsg(OPV,374+$2000,1,'');
                  AddFixMes(GetSmsg(1,374,Liter,1),0,2);
                end;
              end;
{$ELSE}
              if ObCB[1] then InsNewMsg(OPV,373+$2000,1,'')
              else InsNewMsg(OPV,374+$2000,1,'');
{$ENDIF}
            end;
          end;
        end;

        ObjZv[OPV].bP[2] := rz;

        if ObCB[1] and( rrm <> bP[3])then
        //для подключаемого УРО фиксировать общее выключение как отключ.оповещения "ПОЕЗД"
        begin
          if not rrm and not rz and WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then AddFixMes(GetSmsg(1,374,Liter,1),0,2); {$ENDIF}
            InsNewMsg(OPV,374+$2000,1,'')
          end;
        end;
        bP[3] :=  rrm;

      //----------------------------------------------------------------- подключаемый УРО
        if ObCB[1] then  OVBuffer[VBufInd].Param[3] :=  not bP[2] and bP[3]
        else  OVBuffer[VBufInd].Param[3] := bP[2]; //------------------------------------ Во

        if (vo <> bP[6]) or (vod <> bP[7]) then //--------- Во или ВоД
        if WorkMode.FixedMsg then
        begin
          if (not vo  and not vod) then
          begin
            InsNewMsg(OPV,534+$2000,7,'');    //-------------- "отключен запрет монтерам "
            AddFixMes(GetSmsg(1,534,Liter,7),0,2);
          end;
        end else
        if(vo and vod) then
        begin
          InsNewMsg(OPV,518+$2000,7,''); //--------------------- "включен запрет монтерам"
          AddFixMes(GetSmsg(1,518,Liter,1),0,2);
        end;
      end;

      ObjZv[OPV].bP[6] := vo;
      ObjZv[OPV].bP[7] := vod;
      OVBuffer[VBufInd].Param[6] := bP[6];
      OVBuffer[VBufInd].Param[7] := bP[7];

      OVBuffer[VBufInd].Param[2] := bP[2]; //----------------------------- РРМ
      OVBuffer[VBufInd].Param[4] := bP[4]; //----------------------------- ВКо
      OVBuffer[VBufInd].Param[5] := bP[5]; //----------------------------- ВВМ
    end;
  end;
end;

//========================================================================================
//--------------------------------------- Подготовка объекта УКСПС для вывода на табло #14
procedure PrepUKSPS(UKS : Integer);
var
  d1,d2,kzk1,kzk2,dvks : boolean;
begin
  with ObjZv[UKS] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false; //---------------------------------------------------- Непарафазность
    bP[1] := GetFR3(ObCI[2],bP[32],bP[31]); //---------------------------------------- ИКС
    bP[2]:=GetFR3(ObCI[3],bP[32],bP[31]); //--------------------------------- Пред.команда
    d1 :=  GetFR3(ObCI[4],bP[32],bP[31]); //------------------------------------------ 1КС
    d2 :=  GetFR3(ObCI[5],bP[32],bP[31]); //------------------------------------------ 2КС
    kzk1 := GetFR3(ObCI[6],bP[32],bP[31]); //---------------------------------------- КзК1
    kzk2 := GetFR3(ObCI[7],bP[32],bP[31]); //---------------------------------------- КзК2
    bP[7]:= GetFR3(ObCI[8],bP[32],bP[31]); //-----------------------------------------ДВКС

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];

      if bP[31] and not bP[32] then
      begin
        if d1 <> bP[3] then //------------------------------- датчик 1кс изменил состояние
        begin
          if d1 then
            begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,125+$1000,0,''); //------------------ Сработал датчик1 УКСПС
                AddFixMes(GetSmsg(1,125,Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(UKS,125+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[3] := d1;
        OVBuffer[VBufInd].Param[2] := bP[3];

        if d2 <> bP[4] then  //------------------------------ датчик 2кс изменил состояние
        begin
          if d2 then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,126+$1000,0,''); //---------------- Сработал датчик2 УКСПС $
                AddFixMes(GetSmsg(1,126,Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(UKS,126+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[4] := d2;
        OVBuffer[VBufInd].Param[3] := bP[4];

        if kzk1 <> bP[5] then
        begin
          if kzk1 then
          begin //-------------------------------------------- неисправность линии-1 УКСПС
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,127+$1000,1,''); //------------------- Неисправность линии-1
                AddFixMes(GetSmsg(1,127,Liter,1),4,3);
                sMsgCvet[1] := 0;
              end;
{$ELSE}
              InsNewMsg(UKS,127+$1000,1,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[5] := kzk1;
        OVBuffer[VBufInd].Param[4] := bP[5];

        if kzk2 <> bP[6] then
        begin
          if kzk2 then
          begin //-------------------------------------------- неисправность линии-2 УКСПС
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,525+$1000,1,''); //----------------- Неисправность линии-2 $
                AddFixMes(GetSmsg(1,525,Liter,1),4,3);
                sMsgCvet[1] := 0;
              end;
{$ELSE}
              InsNewMsg(UKS,525+$1000,1,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[6] := kzk2;
        OVBuffer[VBufInd].Param[8] := bP[6];
        OVBuffer[VBufInd].Param[9] := bP[7];
        OVBuffer[VBufInd].Param[5] := bP[1];
        OVBuffer[VBufInd].Param[6] := bP[2];
      end;
    end;
  end;
end;

//========================================================================================
//--------------- Подготовка объекта смены направления на перегоне для вывода на табло #15
procedure PrepAB(AB : Integer);
var
  kj,ip1,ip2,zs : boolean;
  VBUF : integer;
begin
  ObjZv[AB].bP[31] := true; ObjZv[AB].bP[32] := false; //-----  Активизация,Непарафазность
  with ObjZv[AB] do
  begin
    VBUF := VBufInd;
    bP[1] :=      GetFR3(ObCI[2],bP[32],bP[31]);//-------------------------------------- В
    ip1   :=  not GetFR3(ObCI[3],bP[32],bP[31]);//------------------------------------ 1ИП
    ip2   :=  not GetFR3(ObCI[4],bP[32],bP[31]); //----------------------------------- 2ИП
    bP[4] :=      GetFR3(ObCI[5],bP[32],bP[31]); //------------------------------------ СН
    bP[5] :=  not GetFR3(ObCI[6],bP[32],bP[31]); //------------------------------------ КП
    kj     := not GetFR3(ObCI[7], bP[32],bP[31]); //----------------------------------- КЖ
    bP[7]  :=     GetFR3(ObCI[8], bP[32],bP[31]);//------------------------------------ Д1
    zs     :=     GetFR3(ObCI[9], bP[32],bP[31]); //---------------------------- запрос СН
    bP[16] :=     GetFR3(ObCI[10],bP[32],bP[31]);//------------------------------------- Л
    bP[8]  :=     GetFR3(ObCI[11],bP[32],bP[31]);   //--------------------------------- Д2
    bP[11] :=     GetFR3(ObCI[12],bP[32],bP[31]);//------------------------------  рон/роч
    bP[17] :=     GetFR3(ObCI[13],bP[32],bP[31]);//--------------------------- согласие СН

    if VBUF > 0 then
    begin
      OVBuffer[VBUF].Param[16] := bP[31]; OVBuffer[VBUF].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBUF].Param[5] := bP[5]; //------------------------------ кп в видеобуфер
        if zs <> bP[10] then
        begin //-------------------------------------- получен запрос на смену направления
          if bP[4] and WorkMode.FixedMsg then
          begin //------------------------------------------------- перегон по отправлению
            {$IFDEF RMDSP}
            if RU = config.ru then
            begin   {$ENDIF}
              if zs then
              begin
                InsNewMsg(AB,439+$2000,0,'');// Получен запрос смены направлен.на перегоне
                AddFixMes(GetSmsg(1,439,Liter,0),0,6);
              end else
              if bP[1] then //------------------------------ не начата смена (В под током)
              begin
                if bP[17] then InsNewMsg(AB,56+$2000,7,'') // Дана команда согл.СН перегон
                else
                begin  //----------------------------------------------------- Снят запрос
                  InsNewMsg(AB,440+$2000,0,'');//Снят запрос смены направления на перегоне
                  AddFixMes(GetSmsg(1,440,Liter,0),0,6);
                end;
              end;
              {$IFDEF RMDSP}
            end; {$ENDIF}
          end;
        end;
        bP[10] := zs;

        if bP[17] then OVBuffer[VBUF].Param[18] := tab_page//если дано согласие СН- мигать
        else  OVBuffer[VBUF].Param[18] := bP[10];//-------------- запрос смены направления

        OVBuffer[VBUF].Param[17] := bP[16]; OVBuffer[VBUF].Param[4] := not bP[11];//Л, 3ип

        if kj <> bP[6] then
        begin
          if kj then bP[9] := false else //----- вставлен КЖ, сброс отправления хоз.поезда
          begin //--------------------------------------------------------------- Изъят КЖ
            {$IFDEF RMDSP}
            if RU= config.ru then AddFixMes(GetSmsg(1,357,Liter,0),0,6);{$ENDIF}
            InsNewMsg(AB,357+$2000,0,''); //---------------- Ключ-жезл $ изъят из аппарата
          end;
        end;
        bP[6] := kj;  OVBuffer[VBUF].Param[11] := bP[6];

        if ip1 <> bP[2] then
        begin
          if bP[2] then  //----------------------------------------- занятие 1 известителя
          begin
            if not bP[6] then bP[9]:= true; // изъят ключ-жезл,дать отправление хоз.поезда
            if ObCB[2] then //------------------------------------- есть смена направления
            begin
              if ObCB[3] then  //----------------------------------- подключаемый комплект
              begin
                if ObCB[4] then  //------------------ по приему если не подключен комплект
                begin
                  if bP[7] and not bP[8] then
                  begin //---------------------------------------- если комплект подключен
                    if not bP[4] and (config.ru = RU) then IpBeep[1] := true;
                  end else //------------------------------------------- комплект отключен
                  if config.ru = RU then IpBeep[1] := true;
                end else
                if ObCB[5] then //---------------------- по отправлению, если не подключен
                begin
                  if bP[8] and not bP[7] then //------------------------------- Д2 и не Д1
                  begin
                    if not bP[4] and (config.ru = RU)//- прием
                    then IpBeep[1] := true;
                  end;
                end;
              end else //-------------------------------------- комплект включен постоянно
              if not bP[4] and (config.ru = RU) then IpBeep[1] := true;
            end else
            if ObCB[4] and (config.ru = RU) then IpBeep[1] := true; //-- по приему звонить
          end;
        end;
        bP[2] := ip1; OVBuffer[VBUF].Param[2] := bP[2];

        if ip2 <> bP[3] then  //--------------------------------------- если изменился ИП2
        begin
          if bP[3] then  //-------------------------------------------------- если занятие
          begin //-------------------------------------------------- занятие 2 известителя
            if ObCB[2] then  //------------------------------- если есть смена направления
            begin
              if ObCB[3] then
              begin //---------------------------------------------- подключаемый комплект
                if ObCB[4] then  //---------------------------- если прием при отключенном
                begin
                  if bP[7] and not bP[8] then //----------------------- комплект подключен
                  begin
                    if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---- прием
                  end else if config.ru = RU then IpBeep[2] := true;//-- комплект отключен
                end else
                if ObCB[5] then //------------  если отправление при отключенном комплекте
                begin
                  if bP[8] and not bP[7] then //----------------------- комплект подключен
                  begin
                    if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---- прием
                  end;
                end;
              end else //-------------------------------------- комплект включен постоянно
              if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---------- прием
            end else //--------------------------------------------- нет смены направления
            if ObCB[4] and (config.ru = RU) then IpBeep[2] := true; //-- по приему звонить
          end;
        end;
        bP[3] := ip2; OVBuffer[VBUF].Param[3] := bP[3];

        if ObCB[2] then
        begin //--------------------------------------------------- есть смена направления
          OVBuffer[VBUF].Param[5] := bP[5]; //------------------------------------ перегон
          if ObCB[3] then
          begin //-------------------------------- Комплект смены направления подключается
            if bP[7] and bP[8] then
            begin //------------------------------------------- неверно подключен комплект
              OVBuffer[VBUF].Param[10] := false;  OVBuffer[VBUF].Param[12] := false;
            end else
            begin
              if ObCB[4] then //---------------------------------------------- Путь приема
              begin
                if bP[7] then //------------------------------------------------------ Д1П
                begin
                  OVBuffer[VBUF].Param[6] := bP[1];   OVBuffer[VBUF].Param[7] := bP[4];
                  OVBuffer[VBUF].Param[10] := true;   OVBuffer[VBUF].Param[12] := true;
                end else
                if bP[8] then
                begin //-------------------------------------------------------------- Д2У
                  OVBuffer[VBUF].Param[10] := false;   OVBuffer[VBUF].Param[12] := false;
                end else
                begin
                  OVBuffer[VBUF].Param[10] := false;   OVBuffer[VBUF].Param[12] := true;
                end;
              end else
              if ObCB[5] then
              begin //--------------------------------------------------- Путь отправления
                if bP[7] then
                begin //-------------------------------------------------------------- Д1П
                  OVBuffer[VBUF].Param[10] := false; OVBuffer[VBUF].Param[12] := false;
                end else
                if bP[8] then
                begin //-------------------------------------------------------------- Д2У
                  OVBuffer[VBUF].Param[6] := bP[1];  OVBuffer[VBUF].Param[7] := bP[4];
                  OVBuffer[VBUF].Param[10] := true;  OVBuffer[VBUF].Param[12] := true;
                end else
                begin
                  OVBuffer[VBUF].Param[10] := false; OVBuffer[VBUF].Param[12] := true;
                end;
              end;
            end;
          end else
          begin //--------------------------- Комплект смены направления включен постоянно
            OVBuffer[VBUF].Param[6] := bP[1]; OVBuffer[VBUF].Param[7] := bP[4];
          end;
        end;
      end;
      //------------------------------------------------------------------------------ FR4
      bP[12] := GetFR4State(ObCI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- выключено управление
        if tab_page
        then OVBuffer[VBUF].Param[32] := bP[13]  else OVBuffer[VBUF].Param[32] := bP[12];
      end else
{$ENDIF}
      OVBuffer[VBUF].Param[32] := bP[12];
      if ObCB[8] or ObCB[9] then
      begin //----------------------------------------------------------- есть электротяга
        bP[27] := GetFR4State(ObCI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[29] := bP[24]
          else OVBuffer[VBUF].Param[29] := bP[27];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[29] := bP[27];
        if ObCB[8] and ObCB[9] then
        begin //-------------------------------------------------- есть 2 вида электротяги
          bP[28] := GetFR4State(ObCI[3]{ div 8 * 8});
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (RU = config.ru) then
          begin
            if tab_page then OVBuffer[VBUF].Param[31] := bP[25]
            else OVBuffer[VBUF].Param[31] := bP[28];
          end else
{$ENDIF}
          OVBuffer[VBUF].Param[31] := bP[28];
          bP[29] := GetFR4State(ObCI[3] div 8 *8 +1);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (RU = config.ru) then
          begin
            if tab_page then OVBuffer[VBUF].Param[30] := bP[26]
            else OVBuffer[VBUF].Param[30] := bP[29];
          end else
{$ENDIF}
          OVBuffer[VBUF].Param[30] := bP[29];
        end;
      end;

      if BasOb > 0 then
      begin //---------------------------- последняя секция маршрута отправления прописана
        if ObjZv[BasOb].bP[2] then
        begin //-------------------------- секция разомкнута- сброс программного замыкания
          bP[14] := false; bP[15] := false; //сброс замыкалки маршрута отправл. на перегон
          //------------------------- сюда добавить обработку ловушки КЖ при необходимости
        end;
      end;
    end;
  end;
end;

//========================================================================================
// Подготовка объекта вспомогательной смены направления на перегон для вывода на табло #16
procedure PrepVSNAB(VSN : Integer);
var
  VBUF,ij : integer;
begin
  VBUF := ObjZv[VSN].VBufInd;
  with ObjZv[VSN] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false; //---------------------------------------------------- Непарафазность
    for ij := 1 to 32 do NParam[ij] := false;
    bP[1] :=  GetFR3(ObCI[3],NParam[1],bP[31]);  //------------------------------------ ВП
    bP[2] :=  GetFR3(ObCI[5],NParam[2],bP[31]);  //----------------------------------- ДВП
    bP[3] :=  GetFR3(ObCI[2],NParam[3],bP[31]);  //------------------------------------ Во
    bP[4] :=  GetFR3(ObCI[4],NParam[4],bP[31]);  //----------------------------------- ДВо
    bp[32] := NParam[1] and NParam[2] and NParam[3] and NParam[4];
    if  VBuf > 0 then
    begin
      OVBuffer[VBuf].Param[16] := bP[31];
      OVBuffer[VBuf].Param[1] := bP[32];
      if bP[31] then
      begin
        OVBuffer[VBuf].Param[12] := bP[3]; OVBuffer[VBuf].NParam[12] := NParam[3];
        OVBuffer[VBuf].Param[13] := bP[4]; OVBuffer[VBuf].NParam[13] := NParam[4];
        OVBuffer[VBuf].Param[14] := bP[1]; OVBuffer[VBuf].NParam[14] := NParam[1];
        OVBuffer[VBuf].Param[15] := bP[2]; OVBuffer[VBuf].NParam[15] := NParam[2];
      end;
    end;
  end;
end;

//========================================================================================
//------------ Подготовка объекта магистрали рабочего тока стрелок для вывода на табло #17
procedure PrepMagStr(Ptr : Integer);
var
  lar : boolean;
  i,Videobuf : integer;
begin
    Videobuf := ObjZv[Ptr].VBufInd;
    for i := 1 to 32 do
    ObjZv[Ptr].NParam[i] := false;

    ;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    ObjZv[Ptr].bP[32] := false; //------------------------------------ Непарафазность

    ObjZv[Ptr].bP[1] :=
    GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);//--- Сз

    ObjZv[Ptr].bP[2] :=
    GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);//-- ВНП

    lar :=
    GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]); //- ЛАР

    if Videobuf > 0 then
    begin
      OVBuffer[Videobuf].Param[16] := ObjZv[Ptr].bP[31];

      for i := 2 to 30 do OVBuffer[Videobuf].NParam[i-1]:=ObjZv[Ptr].NParam[i];

      if ObjZv[Ptr].bP[31] then
      begin
        OVBuffer[Videobuf].Param[16] := ObjZv[Ptr].bP[31];
        OVBuffer[Videobuf].Param[1] := ObjZv[Ptr].bP[1]; //------- сз
        OVBuffer[Videobuf].NParam[1] :=ObjZv[Ptr].NParam[1]; //непараф сз
        OVBuffer[Videobuf].Param[2] := ObjZv[Ptr].bP[2]; //------ внп
        OVBuffer[Videobuf].NParam[2]:= ObjZv[Ptr].NParam[2];//непараф внп

        if lar <> ObjZv[Ptr].bP[3] then
        begin //-------------------------------------------------- изменение состояния ЛАР
          if lar then
          begin //----------------------------------------------- неисправность питания РЦ
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,484+$1000,1,'');
                AddFixMes(GetSmsg(1,484,ObjZv[Ptr].Liter,1),0,1);
              end;
{$ELSE}
              InsNewMsg(Ptr,484+$1000,1,'');//------ Неисправность питания рельсовых цепей
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[3] := lar;
        OVBuffer[Videobuf].Param[3] := ObjZv[Ptr].bP[3];
      end;
    end;
end;

//========================================================================================
//------------------- Подготовка объекта магистрали макета стрелок для вывода на табло #18
procedure PrepMagMakS(MagM : Integer);
var
  rz : boolean;
  VBUF : Integer;
begin
  with ObjZv[MagM] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false; //---------------------------------------------------- Непарафазность
    rz :=  GetFR3(ObCI[2],bP[32],bP[31]); //-------------------------------------- ВМ
    if bP[31] and not bP[32] then
    begin
      if rz <> bP[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = RU) and (maket_strelki_index > 0) then
            begin
              InsNewMsg(maket_strelki_index,377+$2000,1,'');
              AddFixMes(GetSmsg(1,377,ObjZv[maket_strelki_index].Liter,1),0,2);
            end;
{$ELSE}
            InsNewMsg(maket_strelki_index,377+$2000,1,''); //- Перевод стрелки $ на макете
{$ENDIF}
          end;
        end;
      end;
    end;
    bP[1] := rz;
    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] := bP[32];
      OVBuffer[VBUF].Param[2] := bP[1];
    end;
  end;
end;

//========================================================================================
//----------------- Подготовка объекта аварийного перевода стрелок для вывода на табло #19
procedure PrepAPStr(AVP : Integer);
var
  rz : boolean;
  VBUF : integer;
begin
  with ObjZv[AVP] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false; //---------------------------------------------------- Непарафазность
    rz :=  GetFR3(ObCI[2],bP[32],bP[31]); //------------------------------------- ГВК

    if bP[31] and not bP[32] then
    begin
      if rz <> bP[1] then
      begin
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = RU then
          begin
            if rz then
            begin
              InsNewMsg(AVP,378+$2000,0,''); //- Нажата кнопка вспомогательного перевода
              AddFixMes(GetSmsg(1,378,Liter,0),0,2);
            end else
            begin
              InsNewMsg(AVP,379+$2000,0,'');// Отпущена кнопка вспомогательного перевода
              AddFixMes(GetSmsg(1,379,Liter,0),0,2);
            end;
          end;
{$ELSE}
          if rz then InsNewMsg(AVP,378+$2000,0,'')
          else InsNewMsg(AVP,379+$2000,0,'');
{$ENDIF}
        end;
      end;
      bP[1] := rz;
    end else bP[1] := false; //---------------- Сброс признака вспомогательного перевода
    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] :=  bP[32];
      OVBuffer[VBUF].Param[2] := bP[1];
    end;
  end;
end;

//========================================================================================
//----------------------------- Подготовка объекта контроля макета для вывода на табло #20
procedure PrepMaket(MAK : Integer);
var
  km : boolean;
  ii,VBUF : integer;
begin
  ObjZv[MAK].bP[31] := true; //---------------------------------------- Активизация
  for ii := 1 to 34 do  ObjZv[MAK].NParam[ii] := false; //-------------- Непарафазность

  km :=  GetFR3(ObjZv[MAK].ObCI[2],ObjZv[MAK].NParam[2],ObjZv[MAK].bP[31]);  // КМ

  ObjZv[MAK].bP[3]:=GetFR3(ObjZv[MAK].ObCI[3],ObjZv[MAK].NParam[3],ObjZv[MAK].bP[31]);  // МПК
  ObjZv[MAK].bP[4]:=GetFR3(ObjZv[MAK].ObCI[4],ObjZv[MAK].NParam[4],ObjZv[MAK].bP[31]);  // ММК

  if ObjZv[MAK].VBufInd > 0 then
  begin
    VBUF := ObjZv[MAK].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[MAK].bP[31];

    for ii := 1 to 30 do  OVBuffer[VBUF].NParam[ii] := ObjZv[MAK].NParam[ii];

    if ObjZv[MAK].bP[31] then
    begin
      if km <> ObjZv[MAK].bP[2] then
      begin
        if km then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (ObjZv[MAK].RU = config.ru) then
            begin
              InsNewMsg(MAK,301+$1000,0,'');
              AddFixMes(GetSmsg(1,301,'',0),0,2);
            end;
{$ELSE}
            InsNewMsg(MAK,301+$2000,0,''); //--------------------- Подключен макет стрелки
{$ENDIF}
          end;
        end;
      end;
      ObjZv[MAK].bP[2] := km;

      OVBuffer[VBUF].Param[2] := ObjZv[MAK].bP[2];
      OVBuffer[VBUF].Param[3] := ObjZv[MAK].bP[3];
      OVBuffer[VBUF].Param[4] := ObjZv[MAK].bP[4];
    end;
  end;
end;

//========================================================================================
//--------------------- Подготовка объекта выдержки времени отмены для вывода на табло #21
procedure PrepOtmen(OTM : Integer);
var
  om,op,os,vv : boolean;
  i,VBUF,t_os,t_om,t_op : integer;  //------------ таймеры свободный, маневровый, поездной
begin
  with ObjZv[OTM] do
  begin
    //------------------------- таймеры отмены свободного,маневрового и поездного маршрута
    t_os := ObCI[5]; t_om := ObCI[6]; t_op := ObCI[7];  //------------------ таймеры отмен

    bP[31] := true; bP[32] := false; //----------------------- Активизация, Непарафазность

    NParam[2] := false;  os:= GetFR3(ObCI[2],NParam[2],bP[31]); //-------------------- ГОТ
    if (ObCI[32] and $8) = 8 then  os := not os;

    NParam[3] := false;  om:= GetFR3(ObCI[3],NParam[3],bP[31]); //--------------------- ОМ
    if (ObCI[32] and $4) = 4 then  om := not om;

    NParam[4] := false; op:= GetFR3(ObCI[4],NParam[4],bP[31]); //---------------------- ОП
    if (ObCI[32] and $2) = 2 then  op := not op;

    if ObCI[11]>0 then
    begin NParam[7] := false; vv:= GetFR3(ObCI[11],NParam[7],bP[31]); end; //---------- ВВ

    if (t_os = t_om) and not vv then
    begin Timer[t_os]:=0;T[t_os].Activ:=false;T[t_os].F:= 0;T[t_os].S:=0; end;

    NParam[4]:= false;  bP[4]:= GetFR3(ObCI[8],NParam[4],bP[31]); //------------------- ос
    NParam[5] := false; bP[5]:= GetFR3(ObCI[9],NParam[5],bP[31]); //------------------- МВ
    NParam[6] := false; bP[6]:= GetFR3(ObCI[10],NParam[6],bP[31]); //------------------ ПВ

    if bP[31] then
    begin
      //------------------------------------------------------------- отмена со свободного
      if ObCI[11] = 0 then //------------------------------ если нет группового датчика ВВ
      begin
        if (t_os> 0) and (os <> bP[1]) then //- если таймер отмены со свободного изменился
        begin
          if T[t_os].Activ then //----------------------------- если таймер ОС был включен
          begin //------------------------------------------------- отключить счет времени
            if t_om <> t_os then  T[t_os].Activ := false;
            {$IFDEF RMSHN}  siP[1] := Timer[t_os]; {$ENDIF}
            if t_om <> t_os then Timer[t_os] := 0;
          end else
          begin
             T[t_os].Activ := true; T[t_os].F := LastTime;
             Timer[t_os] := 0;
          end;
        end;
      end else //-------------------------------------------------- если датчик ВВ имеется
      begin
        if (t_os > 0)and(vv <> bP[7]) then //-- если существует таймер ОС изменился бит ВВ
        begin
          if T[t_os].Activ then //----------------------------- если таймер ОС был включен
          begin //------------------------------------------------- отключить счет времени
            if t_os <> t_om then T[t_os].Activ := false;
            {$IFDEF RMSHN}  siP[1] := Timer[t_os]; {$ENDIF}
            if t_os <> t_om then Timer[t_os] := 0;
          end else //------------------ таймер был выключен, то начать счет времени с нуля
          begin T[t_os].Activ := true; T[t_os].F := LastTime; Timer[t_os] := 0; end;
        end;
      end;

      //---------------------------------------------------------------- отмена маневровая
      if ObCI[6] > 0 then
      begin //----------------------------------- если таймер маневровой отмены существует
        if om <> bP[2] then //-------------------------------------- если изменился бит ОМ
        begin
          if T[t_om].Activ then //----------------------------- если таймер ОМ был включен
          begin //------------------------------------------------- отключить счет времени
            T[t_om].Activ := false;
            {$IFDEF RMSHN}   siP[2] := Timer[t_om]; {$ENDIF}
          end else //------------------ если таймер был выключен, то начать счет времени
          begin T[t_om].Activ := true; T[t_om].F := LastTime; Timer[t_om] := 0; end;
        end;
      end;


      if t_om > 0 then
      begin //--------------------------------------------------- таймер отмены маневровой
        if om <> ObjZv[OTM].bP[2] then
        begin
          if (t_om <> t_os) and ObjZv[OTM].T[t_om].Activ then
          begin //--------------------------------------------- отключить счет времени
            T[t_om].Activ := false;
            {$IFDEF RMSHN}  siP[2] := Timer[t_om]; {$ENDIF}
            Timer[t_om] := 0;
          end else
          begin //---------------------------------------------------- начать счет времени
            T[t_om].Activ := true;
            if t_om <> t_os then
            begin T[t_om].F := LastTime; Timer[t_om] := 0; end;
          end;
        end;
      end;



      if t_op > 0 then
      begin //--------------------------------------------------- таймер отмены поездной
        if op <> bP[3] then
        begin
          if T[t_op].Activ then
          begin //----------------------------------------------- отключить счет времени
            T[t_op].Activ := false;
            {$IFDEF RMSHN}  siP[3] := Timer[t_op]; {$ENDIF}
            if t_op <> t_om then Timer[t_op] := 0;
          end else //------------------------------------------------- начать счет времени
          begin T[t_op].Activ := true; T[t_op].F := LastTime; Timer[t_op] := 0; end;
        end;
      end;


      if T[t_os].Activ then
      begin //--------------------------- обновить значение времени отмены со свободного
        Timer[t_os] := Round((LastTime - T[t_os].F)*86400);
        if Timer[t_os] > 300 then Timer[t_os] := 300;
      end;

      if (t_om <> t_os) and T[t_om].Activ then
      begin //------------------------------ обновить значение времени отмены маневровой
        Timer[t_om] := Round((LastTime - T[t_om].F)*86400);
        if Timer[t_om] > 300  then Timer[t_om] := 300;
      end;

      if (t_op <> t_om) and T[t_op].Activ then
      begin //-------------------------------- обновить значение времени отмены поездной
        Timer[t_op] := Round((LastTime - T[t_op].F)*86400);
        if Timer[t_op] > 300 then Timer[t_op] := 300;
      end;
    end else
    begin //-- сброс счетчиков при неисправном входном интерфейсе или отсутсвии информации
      if t_os > 0 then  Timer[t_os] := 0;
      T[t_os].Activ := false;
      bP[1] := false;

      if t_om > 0 then  Timer[t_om] := 0;
      T[t_om].Activ := false;
      bP[2] := false;

      if t_op > 0 then  Timer[t_op] := 0;
      T[t_op].Activ := false;
      bP[3] := false;
    end;

    bP[3] := op;
    bP[2] := om;
    bP[1] := os;
    bP[7] := vv;

    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      for i := 1 to 32 do OVBuffer[VBUF].NParam[i] :=  NParam[i];
      OVBuffer[VBUF].Param[2] := bP[1];
      OVBuffer[VBUF].Param[8] := bP[7];
      OVBuffer[VBUF].Param[3] := bP[2];
      OVBuffer[VBUF].Param[4] := bP[3];
      OVBuffer[VBUF].Param[5] := bP[4];
      OVBuffer[VBUF].Param[6] := bP[5];
      OVBuffer[VBUF].Param[7] := bP[6];
    end;

  end;
end;

//========================================================================================
//----------------------------------------- Подготовка объекта ГРИ для вывода на табло #22
procedure PrepGRI(GRI : Integer);
var
  rz : boolean;
  ii,VBUF : integer;
begin
  with ObjZv[GRI] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    for ii := 1 to 34 do NParam[ii] := false; //--------------------------- Непарафазность

    rz    := GetFR3(ObCI[2], NParam[2], bP[31]);//------------------------------ ГРИ1
    bP[3] := GetFR3(ObCI[3], NParam[3], bP[31]); //------------------------------ ГРИ
    bP[4] := GetFR3(ObCI[4], NParam[4], bP[31]); //------------------------------- ИВ

    if bP[31] then
    begin
      if rz <> bP[2] then //------------------------------- если изменилось состояние ГРИ1
      begin
        if ObCI[5] > 0 then //------------ если есть таймер искусственного размыкания
        begin
          if T[1].Activ  then //-------------------------------------- если таймер активен
          begin
            T[1].Activ  := false; //------------------------------- отключить счет времени
            {$IFDEF RMSHN}  siP[1] := Timer[ObCI[5]]; {$ENDIF}//-- индекс таймера
            Timer[ObCI[5]] := 0; //--------------------------- сбросить таймер в ноль
          end else  //-------------------------- если таймер пассивен, начать счет времени
          begin T[1].Activ := true; T[1].F := LastTime; Timer[ObCI[5]] := 0; end;
        end;

        if rz then
        begin
          if WorkMode.FixedMsg and (config.ru = RU) then
          begin
            InsNewMsg(GRI,375+$2000,0,''); //----------------- "Начало выдержки времени"
            AddFixMes(GetSmsg(1,375,Liter,0),0,6);
          end;
        end;
      end;
      bP[2] := rz;      //------------------------------- фиксируем текущее состояние гри1

      if T[1].Activ  then
      begin //--------------------------------------------- обновить значение времени РИ
        Timer[ObCI[5]] := Round((LastTime- T[1].F)*86400);
        if Timer[ObCI[5]]> 300 then Timer[ObCI[5]] := 300;
      end;
    end else
    begin //сброс счетчиков при неисправности входного интерфейса или отсутсвии информации
      if ObCI[5] > 0 then Timer[ObCI[5]] := 0;
      T[1].Activ  := false;
      bP[1] := false;
    end;

    if VBufInd > 0 then
    begin
      VBUF := ObjZv[GRI].VBufInd;
      OVBuffer[VBUF].Param[16] := ObjZv[GRI].bP[31];
      for ii:=1 to 32 do OVBuffer[VBUF].NParam[ii]:=ObjZv[GRI].NParam[ii];
      //--------------------------------------------------  обновляем видеобуфер объекта
      OVBuffer[VBUF].Param[2] := bP[2];
      OVBuffer[VBUF].Param[3] := bP[3];
      OVBuffer[VBUF].Param[4] := bP[4];
      OVBuffer[VBUF].Param[5] := bP[5];
      OVBuffer[VBUF].Param[6] := bP[6];
    end;
  end;
end;

//========================================================================================
//-------------------------------- Подготовка объекта увязки с МЭЦ для вывода на табло #23
procedure PrepMEC(MEC : Integer);
var
  mo,mp,egs : boolean;
  VBUF : integer;
begin
  VBUF := ObjZv[MEC].VBufInd;
  ObjZv[MEC].bP[31] := true; //----------------------------------------------- Активизация
  ObjZv[MEC].bP[32] := false; //------------------------------------------- Непарафазность
  mp := GetFR3(ObjZv[MEC].ObCI[2],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]);  //------- МП
  mo := GetFR3(ObjZv[MEC].ObCI[3],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]);  //------- МО
  egs := GetFR3(ObjZv[MEC].ObCI[4],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]); //------ ЭГС

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[MEC].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[MEC].bP[32];
    if ObjZv[MEC].bP[31] and not ObjZv[MEC].bP[32] then
    begin
      if (mp <> ObjZv[MEC].bP[1]) and WorkMode.FixedMsg then
      begin
        if mp then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,385,1,''); //-------------- Получено согласие маневров по приему
            AddFixMes(GetSmsg(1,385,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,385,1,'');
{$ENDIF}
        end else
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,386,1,''); //----------------- Снято согласие маневров по приему
            AddFixMes(GetSmsg(1,386,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,386,1,'');
{$ENDIF}
        end;
      end;
      ObjZv[MEC].bP[1] := mp;
      OVBuffer[VBUF].Param[2] := ObjZv[MEC].bP[1];

      if(mo <> ObjZv[MEC].bP[2]) and WorkMode.FixedMsg then
      begin
        if mo then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,387,1,'');
            AddFixMes(GetSmsg(1,387,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,387,1,''); //----------- Получено согласие маневров по отправлению
{$ENDIF}
        end else
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,388,1,'');  //----------- Снято согласие маневров по отправлению
            AddFixMes(GetSmsg(1,388,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,388,1,'');
{$ENDIF}
        end;
      end;

      ObjZv[MEC].bP[2] := mo;
      OVBuffer[VBUF].Param[3] := ObjZv[MEC].bP[2];

      if egs <> ObjZv[MEC].bP[3] then
      begin
        if egs then
        begin //------------------------------------------------ зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[MEC].RU then
            begin
              InsNewMsg(MEC,105+$2000,1,'');
              AddFixMes(GetSmsg(1,105,ObjZv[MEC].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(MEC,105+$2000,1,''); //--- Нажата кнопка экстренного гашения сигнала
{$ENDIF}
          end;
        end;
      end;
      ObjZv[MEC].bP[3] := egs;
      OVBuffer[VBUF].Param[8] := ObjZv[MEC].bP[3];  //-------------------------------- эгс
    end;
  end;
end;

//========================================================================================
//------------------------ Подготовка объекта увязки между постами с запросом согласия #24
procedure PrepZapros(UPST : Integer);
var
  zpp,egs : boolean;
  Zpr,ZPo,PPo,VBUF,Gs, Izp, Put, CHI, CHkm, NI, Nkm, MS, FS, SigUv : integer;
begin
  VBUF := VBUF;
  ZPo := ObjZv[UPST].ObCI[2];
  PPo := ObjZv[UPST].ObCI[3];
  Gs := ObjZv[UPST].ObCI[4];
  Izp := ObjZv[UPST].ObCI[6];
  Zpr := ObjZv[UPST].ObCI[7];
  Put := ObjZv[UPST].ObCI[8];
  CHI := ObjZv[UPST].ObCI[9];
  CHkm := ObjZv[UPST].ObCI[10];
  NI := ObjZv[UPST].ObCI[11];
  Nkm := ObjZv[UPST].ObCI[12];
  MS := ObjZv[UPST].ObCI[13];
  FS := ObjZv[UPST].ObCI[14];
  SigUv := ObjZv[UPST].ObCI[20];
  ObjZv[UPST].bP[31] := true; //---------------------------------------------- Активизация
  ObjZv[UPST].bP[32] := false; //------------------------------------------ Непарафазность
  ObjZv[UPST].bP[1] := GetFR3(ZPo,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);//запрос ПО (выд)
  ObjZv[UPST].bP[2] := GetFR3(PPo,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);// запрос ПО(прм)
  egs := GetFR3(Gs,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------------------------- ЭГС
  ObjZv[UPST].bP[5] := not GetFR3(Izp,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------- ИП
  zpp := GetFR3(Zpr,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //---- Запрос Поездного Приема
  ObjZv[UPST].bP[7] := not GetFR3(Put,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //-------- П
  ObjZv[UPST].bP[8] := not GetFR3(CHI,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------- ЧИ
  ObjZv[UPST].bP[9] := GetFR3(CHkm,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);    //------ ЧКМ
  ObjZv[UPST].bP[10] := not GetFR3(NI,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);//-------- НИ
  ObjZv[UPST].bP[11] := GetFR3(Nkm,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //-------  НКМ
  ObjZv[UPST].bP[12] := GetFR3(MS,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //---------- МС
  ObjZv[UPST].bP[13] := GetFR3(FS,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //---------  ФС

  if SigUv > 0 then
  begin
    OVBuffer[SigUv].Param[16] := ObjZv[UPST].bP[31];
    OVBuffer[SigUv].Param[1] := ObjZv[UPST].bP[32];
  end;

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[UPST].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[UPST].bP[32];
    if ObjZv[UPST].bP[31] and not ObjZv[UPST].bP[32] then
    begin
      OVBuffer[VBUF].Param[2] := ObjZv[UPST].bP[10]; //-------------------------------- ни
      OVBuffer[VBUF].Param[3] := ObjZv[UPST].bP[8];  //-------------------------------- чи
      OVBuffer[VBUF].Param[4] := ObjZv[UPST].bP[11]; //------------------------------- нкм
      OVBuffer[VBUF].Param[5] := ObjZv[UPST].bP[9];  //------------------------------- чкм
      OVBuffer[VBUF].Param[6] := ObjZv[UPST].bP[7];  //--------------------------------- п
      OVBuffer[VBUF].Param[7] := ObjZv[UPST].bP[5];  //-------------------------------- ип

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if egs <> ObjZv[UPST].bP[3] then
      begin
        if egs then
        begin//фиксировать нажатие ЭГС для сигнала по отправлению (приему в соседний парк)
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPST].RU then
            begin
              InsNewMsg(UPST,105+$2000,1,''); // Нажата кнопка экстренного гашения сигнала
              AddFixMes(GetSmsg(1,105,ObjZv[UPST].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(UPST,105+$2000,1,'');
{$ENDIF}
          end;
        end;
        ObjZv[UPST].bP[3] := egs;
      end;
      OVBuffer[VBUF].Param[8] := ObjZv[UPST].bP[3];  //------------------------------- эгс

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if zpp <> ObjZv[UPST].bP[6] then
      begin
        if zpp then
        begin //------------------------- зафиксировать получение запроса поездного приема
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPST].RU then
            begin
              InsNewMsg(ObjZv[UPST].BasOb,292,0,'');//Получен запрос поездного приема
              AddFixMes(GetSmsg(1,292,ObjZv[ObjZv[UPST].BasOb].Liter,0),0,6);
            end;
{$ELSE}
            InsNewMsg(UPST,292+$2000,0,'');
{$ENDIF}
          end;
        end;
        ObjZv[UPST].bP[6] := zpp;
      end;

      OVBuffer[VBUF].Param[10] := ObjZv[UPST].bP[6]; //зпч
      OVBuffer[VBUF].Param[11] := ObjZv[UPST].bP[2]; //зопч
      OVBuffer[VBUF].Param[12] := ObjZv[UPST].bP[1]; //зон
      //------------------------------------------------------------------ светофор увязки
      if SigUv > 0 then
      begin
        OVBuffer[SigUv].Param[3] := ObjZv[UPST].bP[12]; //мс
        OVBuffer[SigUv].Param[5] := ObjZv[UPST].bP[13]; //фс
      end;
    end;

    ObjZv[UPST].bP[14] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //--------------------------------------------------------- выключено управление
      if tab_page then OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[15]
      else OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[14];
    end else
{$ENDIF}

    OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[14];

    if ObjZv[UPST].ObCB[8] or ObjZv[UPST].ObCB[9] then
    begin //------------------------------------------------------------- есть электротяга
      ObjZv[UPST].bP[27] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[24]
        else OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[27];
      end else
{$ENDIF}
      OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[27];

      if ObjZv[UPST].ObCB[8] and ObjZv[UPST].ObCB[9] then
      begin //---------------------------------------------------- есть 2 вида электротяги
        ObjZv[UPST].bP[28] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[25]
          else OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[28];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[28];
        ObjZv[UPST].bP[29] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8 + 1);
{$IFDEF RMDSP}

        if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[26]
          else OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[29];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//---------------- Подготовка объекта маневровой колонки (вытяжки) для вывода на табло #25
procedure PrepManevry(MNK : Integer);
var
  rm, v, Act, NPar : boolean;
  VBUF, RazM, Ot, Mi, OiD, Vsp, Egs, PredMi, RMK : integer;
begin
  RazM := ObjZv[MNK].ObCI[2];
  Ot := ObjZv[MNK].ObCI[3];
  Mi := ObjZv[MNK].ObCI[4];
  OiD := ObjZv[MNK].ObCI[5];
  Vsp := ObjZv[MNK].ObCI[6];
  Egs := ObjZv[MNK].ObCI[7];
  PredMi :=  ObjZv[MNK].ObCI[8];
  RMK :=  ObjZv[MNK].ObCI[9];
  Act := true; //------------------------------------------------------------- Активизация
  NPar := false; //-------------------------------------------------------- Непарафазность
  rm := GetFR3(RazM,Npar,Act); //------------------------------------------------------ РМ

  ObjZv[MNK].bP[2] := GetFR3(Ot,Npar,Act); //----------------------------- отмена маневров
  ObjZv[MNK].bP[3] := not GetFR3(Mi,NPar,Act); //---------------------------- замыкание МИ
  ObjZv[MNK].bP[4] := not GetFR3(OiD,NPar,Act);//-------------------------- состояние оИ/Д
  v := GetFR3(Vsp,Npar,Act);//------------------------------------------------- Bосприятие
  ObjZv[MNK].bP[6] := GetFR3(Egs,NPar,Act); //--------------------------------------- ЭГС
  ObjZv[MNK].bP[7] := GetFR3(PredMi,NPar,Act); //-------------------- предв.иск.размыкание
  ObjZv[MNK].bP[9] := GetFR3(RMK,NPar,Act); //---------------------------------------- РМК

  ObjZv[MNK].bP[31] := Act; //------------------------------------------------ Активизация
  ObjZv[MNK].bP[32] := NPar; //-------------------------------------------- Непарафазность

  if ObjZv[MNK].VBufInd > 0 then
  begin
    VBUF := ObjZv[MNK].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[MNK].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[MNK].bP[32];

    if ObjZv[MNK].bP[31] and not ObjZv[MNK].bP[32] then
    begin
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if rm <> ObjZv[MNK].bP[1] then
      begin
        if rm then
        begin
          ObjZv[MNK].bP[14] := false; //---------- сброс признака выдачи команды на сервер
          ObjZv[MNK].bP[8] := false; //------------------ сброс признака выдачи команды РМ
        end;
        ObjZv[MNK].bP[1] := rm;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if v <> ObjZv[MNK].bP[5] then
      begin
        if WorkMode.FixedMsg
{$IFDEF RMDSP}
        and (config.ru = ObjZv[MNK].RU)
{$ENDIF}
        then
        begin
          if v then
          begin //------------------------------------------- Получено восприятие маневров
            InsNewMsg(MNK,389+$2000,7,'');
{$IFDEF RMDSP}
            AddFixMes(GetSmsg(1,389,ObjZv[MNK].Liter,7),0,6);
{$ENDIF}
          end else
          begin //---------------------------------------------- Снято восприятие маневров
            InsNewMsg(MNK,390+$2000,7,'');
{$IFDEF RMDSP}
            AddFixMes(GetSmsg(1,390,ObjZv[MNK].Liter,7),0,6);
{$ENDIF}
          end;
        end;
        ObjZv[MNK].bP[5] := v;
      end;
      OVBuffer[VBUF].Param[2] := ObjZv[MNK].bP[5]; //----------------------------------- В
      OVBuffer[VBUF].Param[3] := ObjZv[MNK].bP[1]; //---------------------------------- РМ
      OVBuffer[VBUF].Param[4] := ObjZv[MNK].bP[2]; //---------------------------------- оТ
      OVBuffer[VBUF].Param[5] := ObjZv[MNK].bP[4]; //---------------------------------- оИ
      OVBuffer[VBUF].Param[6] := ObjZv[MNK].bP[3]; //---------------------------------- МИ
      OVBuffer[VBUF].Param[7] := ObjZv[MNK].bP[7]; //---------------------------- предв МИ
      OVBuffer[VBUF].Param[9] := ObjZv[MNK].bP[6]; //--------------------------------- эгс
      OVBuffer[VBUF].Param[10] := ObjZv[MNK].bP[8]; //------------------ выдана команда РМ
      OVBuffer[VBUF].Param[11] := ObjZv[MNK].bP[9]; //-------------------------------- РМК
    end;
  end;
end;

//========================================================================================
//----------------------------------------- Подготовка объекта ПАБ для вывода на табло #26
procedure PrepPAB(PAB : Integer);
var
  fp, gp, kj, o, Act, NPar : Boolean;
  VBUF, SvVh : integer;
begin
  Act := true; //------------------------------------------------------------- Активизация
  NPar := false; //-------------------------------------------------------- Непарафазность
  with ObjZv[PAB] do
  begin
    SvVh := BasOb;

    bP[1] := not GetFR3(ObCI[2],NPar,Act);//-------------------------------------- По
    fp := GetFR3(ObCI[3],NPar,Act); //-------------------------------------------- ФП

    bP[3] := GetFR3(ObCI[4],NPar,Act); //-------------------- предварительная команда
    bP[4] := GetFR3(ObCI[5],NPar,Act); //---------------------------------------- ДСо
    bP[5] := not GetFR3(ObCI[6],NPar,Act);//-------  занятость перегона - отправление
    bP[6] := GetFR3(ObCI[7],NPar,Act); //----------------- занятость перегона - прием
    kj := not GetFR3(ObCI[8],NPar,Act);//----------------------------------------- КЖ
    o := GetFR3(ObCI[12],NPar,Act);  //-------------------- неисправность повторителя
    gp := not GetFR3(ObCI[13],NPar,Act);//---------------------------------------- ИП
    bP[31] := Act;
    bP[32] := NPar;


    if bP[31] and not bP[32] then
    begin
      if (kj <> bP[7]) and not kj then //---------------------------------------- Изъят КЖ
      begin
{$IFDEF RMDSP}
        if RU = config.ru then
        begin
          InsNewMsg(PAB,357+$2000,0,''); AddFixMes(GetSmsg(1,357,Liter,0),0,6);
        end;
{$ELSE}
        InsNewMsg(PAB,357+$2000,0,'');
{$ENDIF}
      end;
      bP[7] := kj;  //----------------------------------------------------------------- КЖ

      if (o <> bP[8]) and o then
      begin //-------------------------------------- неисправен предупредительный светофор
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if RU = config.ru then
          begin
            InsNewMsg(SvVh,405+$1000,1,'');
            AddFixMes(GetSmsg(1,405,'П'+ObjZv[SvVh].Liter,1),0,4);
          end;
{$ELSE}
          InsNewMsg(SvVh,405+$1000,1,'');//--------- Неисправен предупредительный светофор
{$ENDIF}
        end;
      end;
      bP[8] := o;
    end;


    if (gp <> bP[9]) and not gp and (config.ru = RU) then
    IpBeep[1] := not bP[1] and WorkMode.Upravlenie;
    bP[9] := gp; //------------------------------------------------------- ИП

    if VBufInd > 0 then
    begin
      VBUF := ObjZv[PAB].VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] := bP[32];
      OVBuffer[VBUF].Param[11] := bP[7];
      OVBuffer[VBUF].Param[3] := o;
      OVBuffer[VBUF].Param[2] := bp[9];

      if SvVh > 0 then  OVBuffer[VBUF].Param[4] := ObjZv[SvVh].bP[4]
      else  OVBuffer[VBUF].Param[4] := false;
    end;

    if not bP[1] and not bP[5] then OVBuffer[VBUF].Param[12] := true
    else
    begin
      OVBuffer[VBUF].Param[6] := bP[1];
      OVBuffer[VBUF].Param[5] := bP[5];
      OVBuffer[VBUF].Param[7] := bP[6];
      OVBuffer[VBUF].Param[8] := bP[4];

      if fp <> bP[2] then
      begin //-------------------------------------------- включить звонок прибытия поезда
        if fp and (config.ru = RU)
        then SBeep[1] := WorkMode.Upravlenie; // сообщение о прибытии(контроль прибытия)
      end;

      bP[2] := fp;
      OVBuffer[VBUF].Param[10] := fp;

      OVBuffer[VBUF].Param[13] := bP[3];
      OVBuffer[VBUF].Param[12] := false;
    end;

    bP[12] := GetFR4State(ObCI[13] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[VBUF].Param[32] := bP[13]
      else OVBuffer[VBUF].Param[32] := bP[12];
    end else
{$ENDIF}
      OVBuffer[VBUF].Param[32] := bP[12];
    if ObCB[8] or ObCB[9] then
    begin //------------------------------------------------------------- есть электротяга
      bP[27] := GetFR4State(ObCI[13] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[VBUF].Param[29] := bP[24]
        else OVBuffer[VBUF].Param[29] := bP[27];
      end else
{$ENDIF}
        OVBuffer[VBUF].Param[29] := bP[27];
      if ObCB[8] and ObCB[9] then
      begin //---------------------------------------------------- есть 2 вида электротяги
        bP[28] := GetFR4State(ObCI[13] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[31] := bP[25]
          else OVBuffer[VBUF].Param[31] := bP[28];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[31] := bP[28];
        bP[29] := GetFR4State(ObCI[13] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[30] := bP[26]
          else OVBuffer[VBUF].Param[30] := bP[29];
        end else
{$ENDIF}
          OVBuffer[VBUF].Param[30] := bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------- Подготовка объекта охранности стрелок для вывода на табло #27
procedure PrepDZStrelki(Dz : Integer);
var
  STrO,  VBUF,  StrK,  SpK,  XStrO,  rzs : integer;
begin
  with ObjZv[Dz] do
  begin
    if ObCI[3] > 0 then  //---------------------------- если указана охранная стрелка
    begin //---------------------------------------- Обработать состояние охранной стрелки
      StrK := ObCI[1]; //----------------- Индекс стрелки, находящейся на трассировке
      SpK := ObCI[2]; //-------------------- Индекс СП контрольной стрелки (в трассе)
      StrO := ObCI[3]; //---------------------------- Индекс объекта охранной стрелки

      VBUF := ObjZv[StrO].VBufInd; //-------------------- Видеобуфер охранной стрелки
      XStrO := ObjZv[StrO].BasOb; //--------- Индекс объекта "хвост охранной стрелки"
      rzs := ObjZv[XStrO].ObCI[12];//--------------- объект ручного замыкания стрелок

      if StrK > 0 then //------------------------------------- если есть контрольная стрелка
      begin
        if not ObjZv[rzs].bP[1] and //---------------- нет ручного замыкания стрелок и ...
        ObjZv[XStrO].bP[21] then //------------ охранная стрелка не замкнута через свою СП
        begin
          if (ObCB[1] and //-------------- если стрелка контролируется по плюсу и ...
          ObjZv[StrK].bP[1]) or //------- контрольная стрелка установлена по плюсу или ...
          (ObCB[2] and //---------------- если стрелка контролируется по минусу и ...
          ObjZv[StrK].bP[2]) //----------------- контрольная стрелка установлена по минусу
          then
          begin
            ObjZv[StrO].bP[4] := //--- дополнительное замыкание охранной стрелки через ...
            ObjZv[StrO].bP[25] or ObjZv[StrO].bP[33] or //------------ НАС или ЧАС или ...
            (not ObjZv[SpK].bP[2]); //------------- через замыкание СП контрольной стрелки

            OVBuffer[VBUF].Param[7] := ObjZv[StrO].bP[4];
          end;
        end;

        if not ObjZv[XStrO].bP[21] and not ObjZv[rzs].bP[1]
        then //------------------------------- хвост охранной стрелки замкнут от своего СП
        begin
          ObjZv[StrO].bP[4] := false; //------- сбросить дополнительное замыкание охранной
          ObjZv[StrO].bP[4] := ObjZv[StrO].bP[4] or
          ObjZv[StrO].bP[26] or ObjZv[StrO].bP[27];
          ObjZv[StrO].bP[14] := false; //--------- сбросить программное замыкание охранной
          ObjZv[XStrO].bP[14] := false; //---------- сбросить программное замыкание хвоста
        end;

        //--------------------------------- Трассировка маршрута через описание охранности
        if ObjZv[StrK].bP[14] then //--------- если есть программное замыкание контрольной
        begin
          bP[23] := true; //------------------  предварительное замыкание охранной стрелки

          if ObCB[1] then //--------------------- контролируемая трассируется в плюсе
          begin
            if ObjZv[StrK].bP[6] then //----------------------------------- если выдано ПУ
            begin
              //- нет первого прохода по трассе или контрольная стрелка пошерстная в плюсе
              if (not ObjZv[StrK].bP[11] or ObjZv[StrK].bP[12]) then
              begin
                if ObCB[3] then //---------------------- Охранная должна быть в плюсе
                begin
                  if not ObjZv[StrO].bP[1] then bP[8]:=true; // активно ждет перевода(в +)
                end else
                if ObCB[4] and not ObjZv[StrO].bP[2] // Охранная должна быть в минусе
                then bP[8] := true; //-------------------- активно ждет перевода (в минус)
              end;
            end;
          end else
          if ObCB[2] then //-------------------- контролируемая трассируется в минусе
          begin
            if ObjZv[StrK].bP[7] then //----------------------------------------------- МУ
            begin
              if ObCB[3] then //------------------------ Охранная должна быть в плюсе
              begin
                if not ObjZv[StrO].bP[1] then bP[8] := true;
              end else
              //-------------------------------------------- Охранная должна быть в минусе
              if ObCB[4] and not ObjZv[StrO].bP[2] then bP[8] := true;
            end;
          end;
        end else bP[23] := false;//------------- сброс предварительного замыкания охранной

        if not bP[8] then //------------------ если нет ожидания перевода охранной стрелки
        begin //--------------------------- Трассировка маршрута черех описание охранности
          if ObCB[1] then //------------- контролируемая стрелка трассируется в плюсе
          begin
            if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or ObjZv[StrK].bP[12])
            then bP[5] := true; //----------------------------- требуется перевод охранной
          end else
          if ObCB[2] then //------------ контролируемая стрелка трассируется в минусе
          begin
            if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
            ObjZv[StrK].bP[13])  then  bP[5] := true; //------- требуется перевод охранной
          end;
        end;
      end;

      //---------------------------- если в хвосте охран. нет признака требования перевода
      if not ObjZv[XStrO].bP[5] then
      ObjZv[XStrO].bP[5] := bP[5]; //------------------------- копировать требование из ДЗ

      //------------------------------ если в хвосте охран. нет признака ожидания перевода
      if not ObjZv[XStrO].bP[8] then
      ObjZv[XStrO].bP[8] := bP[8]; //--------------------------- копировать ожидание из ДЗ

      if not ObjZv[XStrO].bP[23] then //-------- если нет признака трассивоки как охранной
      ObjZv[XStrO].bP[23] := bP[23]; //------------------------- признак трассировки из ДЗ
    end;
  end;
end;

//========================================================================================
//----------------------- Подготовка объекта дачи поездного приема для вывода на табло #30
procedure PrepDSPP(Ptr : Integer);
var
  egs : boolean;
begin
  ObjZv[Ptr].bP[31] := true; // Активизация
  ObjZv[Ptr].bP[32] := false; // Непарафазность
  egs := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);  // ЭГС
  ObjZv[Ptr].bP[2] := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);  // И

  // ЭГС
  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];
    if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
    begin
      if egs <> ObjZv[Ptr].bP[1] then
      begin
        if egs then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            InsNewMsg(ObjZv[Ptr].BasOb,105+$2000,1,''); AddFixMes(GetSmsg(1,105,ObjZv[ObjZv[Ptr].BasOb].Liter,1),0,6);
{$ELSE}
            InsNewMsg(ObjZv[Ptr].BasOb,105+$2000,1,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[Ptr].bP[1] := egs;
      OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1];
    end;
  end;
end;

//========================================================================================
//------------------- Подготовка объекта повторительного светофора для вывода на табло #31
procedure PrepPSvetofor(Ptr : Integer);
var
  o,sign : boolean;
  VidBuf,IndPovt,Sig,Cod : Integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    ObjZv[Ptr].bP[32] := false; //------------------------------------ Непарафазность
    VidBuf := ObjZv[Ptr].VBufInd;
    IndPovt := ObjZv[Ptr].ObCI[2];
    Sig := ObjZv[Ptr].BasOb;
    //-------------------------------------------------------------- состояние повторителя
    o :=  GetFR3(IndPovt,ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);
    sign := ObjZv[Sig].bP[4];

    Cod := 0;
    if sign then Cod := Cod + 2;
    if o then Cod := Cod + 1;

    if VidBuf > 0 then //--------------------------------- если есть отображение на экране
    begin
      OVBuffer[VidBuf].Param[16] := ObjZv[Ptr].bP[31];
      OVBuffer[VidBuf].Param[1] := ObjZv[Ptr].bP[32];

      if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
      begin
        if Cod <> ObjZv[Ptr].iP[1] then
        if not ObjZv[Ptr].T[1].Activ  then
        begin
          ObjZv[Ptr].T[1].Activ  := true;
          ObjZv[Ptr].T[1].F := LastTime + 3/80000;
        end;

        if ObjZv[Ptr].T[1].Activ  then
        begin //------------------------------------------------------ было изменение кода
          if ObjZv[Ptr].T[1].F < LastTime then
          begin //---------------------------------------------------- ожидали 3-4 секунды
            //------ сначала считаем, что сигнал закрыт, ПНо = 0 (нормально для закрытого)
            ObjZv[Ptr].bP[1] := false; //---------------- снять признак неисправности
            ObjZv[Ptr].bP[2] := false; //-------- снять признак включения повторителя
            ObjZv[Ptr].bP[3] := false; //------------- снять признак нарушения логики

            case Cod of
              1:
              begin
                ObjZv[Ptr].bP[2] := true;
                ObjZv[Ptr].bP[3] := true; //---- сигнал закрыт, ПНо = 1(несуразность)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZv[ptr].RU then
                  begin
                    InsNewMsg(Ptr,579+$1000,0,''); //--- Неисправность датчика повторителя
                    AddFixMes(GetSmsg(1,579,ObjZv[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsNewMsg(Ptr,579+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                end;
              end;

              2:
              begin
                ObjZv[Ptr].bP[1] := true; //--- сигнал открыт, ПНо = 0(неисправность)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZv[ptr].RU then
                  begin
                    InsNewMsg(Ptr,339+$1000,0,'');//---- Неисправность датчика повторителя
                    AddFixMes(GetSmsg(1,339,ObjZv[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsNewMsg(Ptr,339+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                end;
              end;

              3:  ObjZv[Ptr].bP[2] := true; //сигнал открыт, ПНо = 1(норма открытого)
            end;
            ObjZv[Ptr].iP[1]:= Cod;
            ObjZv[Ptr].T[1].Activ  := false;
            ObjZv[Ptr].T[1].F := 0;
          end;
        end;
        OVBuffer[VidBuf].Param[3] := ObjZv[Ptr].bP[1];
        OVBuffer[VidBuf].Param[4] := ObjZv[Ptr].bP[3];
      end;
      OVBuffer[VidBuf].Param[2] := ObjZv[Ptr].bP[2];
    end;
end;

//========================================================================================
//---------------------------- Подготовка объекта надвига на горку для вывода на табло #32
procedure PrepNadvig(NAD : Integer);
var
  egs,sn,sm : boolean;
  VBUF : integer;
begin
  ObjZv[NAD].bP[31] := true; //----------------------------------------------- Активизация
  ObjZv[NAD].bP[32] := false; //------------------------------------------- Непарафазность

  ObjZv[NAD].bP[1] :=
  GetFR3(ObjZv[NAD].ObCI[2],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);  //------------- зо


  ObjZv[NAD].bP[2] :=
  GetFR3(ObjZv[NAD].ObCI[3],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- Жо

  ObjZv[NAD].bP[3] :=
  GetFR3(ObjZv[NAD].ObCI[4],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- Бо

  ObjZv[NAD].bP[4] :=
  GetFR3(ObjZv[NAD].ObCI[5],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- УН

  ObjZv[NAD].bP[5] :=
  GetFR3(ObjZv[NAD].ObCI[6],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- Соо

  ObjZv[NAD].bP[6] :=
  GetFR3(ObjZv[NAD].ObCI[7],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- оо

  egs :=
  GetFR3(ObjZv[NAD].ObCI[8],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- ЭГС

  sn :=
  GetFR3(ObjZv[NAD].ObCI[9],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- СН

  sm :=
  GetFR3(ObjZv[NAD].ObCI[10],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- СМ

  ObjZv[NAD].bP[10] :=
  GetFR3(ObjZv[NAD].ObCI[11],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);//--------------- В

  ObjZv[NAD].bP[11] :=
  GetFR3(ObjZv[NAD].ObCI[12],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);//--------------- П

  if ObjZv[NAD].VBufInd > 0 then
  begin
    VBUF := ObjZv[NAD].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[NAD].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[NAD].bP[32];
    if ObjZv[NAD].bP[31] and not ObjZv[NAD].bP[32] then
    begin

      OVBuffer[VBUF].Param[2] := ObjZv[NAD].bP[3];
      OVBuffer[VBUF].Param[3] := ObjZv[NAD].bP[4];
      OVBuffer[VBUF].Param[4] := ObjZv[NAD].bP[2];
      OVBuffer[VBUF].Param[5] := ObjZv[NAD].bP[1];
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if egs <> ObjZv[NAD].bP[7] then
      begin
        if egs then
        begin //------------------------------------------------ зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,105+$2000,1,''); //- Нажата кнопка экстренного гашения сигнала
              AddFixMes(GetSmsg(1,105,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,105+$2000,1,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[7] := egs;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if sn <> ObjZv[NAD].bP[8] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sn then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,381+$2000,1,''); //----------------- получено согласие надвига
              AddFixMes(GetSmsg(1,381,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,381+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,382+$2000,1,''); //-------------------- снято согласие надвига
              AddFixMes(GetSmsg(1,382,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,382+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[8] := sn;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if sm <> ObjZv[NAD].bP[9] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sm then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,383+$2000,1,''); //---------------- получено согласие маневров
              AddFixMes(GetSmsg(1,383,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,383+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,384+$2000,1,'');//-------------------- снято согласие маневров
              AddFixMes(GetSmsg(1,384,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,384+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[9] := sm;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      OVBuffer[VBUF].Param[6]  := ObjZv[NAD].bP[8];
      OVBuffer[VBUF].Param[7]  := ObjZv[NAD].bP[9];
      OVBuffer[VBUF].Param[8]  := ObjZv[NAD].bP[7];
      OVBuffer[VBUF].Param[9]  := ObjZv[NAD].bP[5];
      OVBuffer[VBUF].Param[10] := ObjZv[NAD].bP[6];
      OVBuffer[VBUF].Param[11] := ObjZv[NAD].bP[11];
      OVBuffer[VBUF].Param[12] := ObjZv[NAD].bP[10];

      {FR4}
      ObjZv[NAD].bP[12] := GetFR4State(ObjZv[NAD].ObCI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[13]
        else OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[12];
      end else
{$ENDIF}
        OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[12];
    end;
  end;
end;

//========================================================================================
//---------------------------------- Подготовка одиночного датчика для вывода на табло #33
procedure PrepSingle(Ptr : Integer);
var
  b : boolean;
  i : integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    ObjZv[Ptr].bP[32] := false; //------------------------------------ Непарафазность

    for i := 0 to 34 do ObjZv[Ptr].NParam[i] := false;

    if ObjZv[Ptr].ObCB[1] then //--------------------------- если инверсия состояния
    b := not GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31])
    else //--------------------------------------------------------- если прямое состояние
    b := GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);

    if not ObjZv[Ptr].bP[31] then //---------------------------------- нет активности
    begin
      if ObjZv[Ptr].VBufInd > 0 then //---------------------------- есть видеообъект
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
      end;
    end else
    begin
      if ObjZv[Ptr].VBufInd > 0 then
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
      end;
      if ObjZv[Ptr].bP[1] <> b then
      begin
        if ObjZv[Ptr].ObCB[2] then
        begin //------ регистрация изменения состояния датчика - вывод сообщения оператору
          if b then
          begin
            if ObjZv[Ptr].ObCI[2] > 0 then //------- если есть сообщение о включении
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                if ObjZv[Ptr].ObCI[4] = 1   //------------- если цвет текста красный
                then InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[2],0,'')
                else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');

                if ObjZv[Ptr].ObCI[4] = 1 then
                AddFixMes(MsgList[ObjZv[Ptr].ObCI[2]],4,3)
                else
                begin //--------------------------------------------- сообщение диалоговое
                  PutSMsg(ObjZv[Ptr].ObCI[4],LastX,LastY,MsgList[ObjZv[Ptr].ObCI[2]]);
                  SBeep[1] := true;
                end;
              end;
{$ELSE}
              if ObjZv[Ptr].ObCI[4] = 1 then
              begin
                InsNewMsg(Ptr,$1000 + ObjZv[Ptr].ObCI[2],0,'');
                SBeep[3] := true;
              end
              else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');

{$ENDIF}
            end;
          end else
          begin
            if ObjZv[Ptr].ObCI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                if ObjZv[Ptr].ObCI[5] = 1
                then InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[3],0,'')
                else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],0,'');
                if ObjZv[Ptr].ObCI[5] = 1 then // сообщение фиксируемое
                AddFixMes(MsgList[ObjZv[Ptr].ObCI[3]],4,3)
                else
                begin //--------------------------------------------- сообщение диалоговое
                  PutSMsg(ObjZv[Ptr].ObCI[5],LastX,LastY,MsgList[ObjZv[Ptr].ObCI[3]]);
//                  SBeep[1] := true;
                end;
              end;
{$ELSE}
              if ObjZv[Ptr].ObCI[5] = 1 then
              begin
                InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[3],0,'');
                SBeep[3] := true;
              end
              else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],0,'');
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[1] := b;
      end;
      if ObjZv[Ptr].VBufInd > 0 then
      OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[1];
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[1] := ObjZv[Ptr].NParam[1];
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
    for i := 1 to 34 do ObjZv[Ptr].NParam[i] := false;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    ObjZv[Ptr].bP[32] := false; //------------------------------------ Непарафазность

    k1f:= GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);//-- к1ф

    k2f := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);//-- к2ф

    k3f := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);//-- кзф

    vf1 := GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);//-- 1вф

    vf2 := GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[5],ObjZv[Ptr].bP[31]);//-- 2ВФ

    kpp := GetFR3(ObjZv[Ptr].ObCI[6],ObjZv[Ptr].NParam[6],ObjZv[Ptr].bP[31]); //- КПП

    kpa := GetFR3(ObjZv[Ptr].ObCI[7],ObjZv[Ptr].NParam[7],ObjZv[Ptr].bP[31]);//-- КПА

    szk := GetFR3(ObjZv[Ptr].ObCI[8],ObjZv[Ptr].NParam[8],ObjZv[Ptr].bP[31]); //- СзК

    ak :=  GetFR3(ObjZv[Ptr].ObCI[9],ObjZv[Ptr].NParam[9],ObjZv[Ptr].bP[31]); //-- АК

    k1shvp := GetFR3(ObjZv[Ptr].ObCI[10],ObjZv[Ptr].NParam[10],ObjZv[Ptr].bP[31]);//К1ЩВ

    k2shvp := GetFR3(ObjZv[Ptr].ObCI[11],ObjZv[Ptr].NParam[11],ObjZv[Ptr].bP[31]);//К2ЩВ

    knz :=   GetFR3(ObjZv[Ptr].ObCI[12],ObjZv[Ptr].NParam[12],ObjZv[Ptr].bP[31]);// КНз

    knb :=   GetFR3(ObjZv[Ptr].ObCI[13],ObjZv[Ptr].NParam[13],ObjZv[Ptr].bP[31]);// КНБ

    dsn :=   GetFR3(ObjZv[Ptr].ObCI[14],ObjZv[Ptr].NParam[14],ObjZv[Ptr].bP[31]);// ДСН

    saut :=  GetFR3(ObjZv[Ptr].ObCI[15],ObjZv[Ptr].NParam[15],ObjZv[Ptr].bP[31]);//САУТ

    vmg :=   GetFR3(ObjZv[Ptr].ObCI[18],ObjZv[Ptr].NParam[18],ObjZv[Ptr].bP[31]); //ВМГ

    fk1 :=   GetFR3(ObjZv[Ptr].ObCI[19],ObjZv[Ptr].NParam[19],ObjZv[Ptr].bP[31]); //1фк

    fk2 :=   GetFR3(ObjZv[Ptr].ObCI[20],ObjZv[Ptr].NParam[20],ObjZv[Ptr].bP[31]); //2фк

    fu1 :=   GetFR3(ObjZv[Ptr].ObCI[21],ObjZv[Ptr].NParam[21],ObjZv[Ptr].bP[31]); //1фу

    fu2 :=   GetFR3(ObjZv[Ptr].ObCI[22],ObjZv[Ptr].NParam[22],ObjZv[Ptr].bP[31]); //2фу

    vf :=    GetFR3(ObjZv[Ptr].ObCI[23],ObjZv[Ptr].NParam[23],ObjZv[Ptr].bP[31]); // вф

    pf1 :=   GetFR3(ObjZv[Ptr].ObCI[24],ObjZv[Ptr].NParam[24],ObjZv[Ptr].bP[31]); //пф1

    la :=    GetFR3(ObjZv[Ptr].ObCI[25],ObjZv[Ptr].NParam[25],ObjZv[Ptr].bP[31]); // ла

    at :=    GetFR3(ObjZv[Ptr].ObCI[26],ObjZv[Ptr].NParam[26],ObjZv[Ptr].bP[31]); // АТ

    kmgt :=  GetFR3(ObjZv[Ptr].ObCI[27],ObjZv[Ptr].NParam[27],ObjZv[Ptr].bP[31]); //МГТ

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];

      for i := 1 to 32 do //------------------------ переписать все непарафазности побитно
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[i] := ObjZv[Ptr].NParam[i];

      if ObjZv[Ptr].bP[31] then
      begin
        if dsn <> ObjZv[Ptr].bP[14] then //-------------------------------------- ДСН
        begin
          if WorkMode.FixedMsg then
          begin
            if dsn then
            begin
              InsNewMsg(Ptr,358+$2000,0,''); //------------- включен режим светомаскировки
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,358,'',7),4,4);
              {$ELSE}  SBeep[4] := true; {$ENDIF}
            end  else
            begin
              InsNewMsg(Ptr,359+$2000,0,''); //------------ отключен режим светомаскировки
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,359,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[14] := dsn;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[14] := dsn;

        if saut <> ObjZv[Ptr].bP[15] then//------------------------------------- САУТ
        begin
         if saut then
         begin
           InsNewMsg(Ptr,524+$1000,1,''); //------------------------- "Неисправность САУТ"
           {$IFDEF RMDSP}  AddFixMes(GetSmsg(1,524,'',0),4,3);
           {$ELSE} SBeep[2] := true; {$ENDIF}
         end;
         ObjZv[Ptr].bP[15] := saut;
         OVBuffer[ObjZv[Ptr].VBufInd].Param[15] := saut;
        end;

        if ObjZv[Ptr].ObCB[1] then//----------------------------------------- ФИДЕРА
        begin //----------------------- Для малой станции (один контроль активных фидеров)
          if k1f <> ObjZv[Ptr].bP[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsNewMsg(Ptr,303+$2000,0,''); //-------------- "Восстановление 1-го фидера"
              {$IFDEF RMDSP}  AddFixMes(GetSmsg(1,303,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,302+$1000,0,''); //------------------ "Выключение 1-го фидера"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,302,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := k1f;

          if k2f <> ObjZv[Ptr].bP[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsNewMsg(Ptr,305+$2000,0,''); //-------------- "Восстановление 2-го фидера"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,305,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,304+$1000,0,'');//------------------- "Выключение 2-го фидера"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,304,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := k2f;

          if k3f <> ObjZv[Ptr].bP[3] then
          begin
            if WorkMode.FixedMsg then
            if not k3f then
            begin
              InsNewMsg(Ptr,308+$2000,0,''); //-------------- "Переключено питание на ДГА"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,308,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := k3f;

          if vf1 <> ObjZv[Ptr].bP[4] then  //------ изменилась активность 1-го фидера
          begin
            if WorkMode.FixedMsg then
            if not vf1 then
            begin
              InsNewMsg(Ptr,306+$2000,7,''); //------- "Переключено питание на 1-ый фидер"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,306,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,307+$2000,0,''); //------- "Переключено питание на 2-ой фидер"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,307,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := vf1;

          ObjZv[Ptr].bP[1] := k1f;
          ObjZv[Ptr].bP[2] := k2f;
          ObjZv[Ptr].bP[3] := k3f;
          ObjZv[Ptr].bP[4] := vf1;
          ObjZv[Ptr].bP[5] := vf2;
        end
        else
        begin //---------------------- Для крупной станции (два контроля активных фидеров)
          if k1f <> ObjZv[Ptr].bP[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsNewMsg(Ptr,303+$2000,0,''); //----------------- "восстановление фидера 1"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,303,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,302+$1000,0,'');  //-------------------- "выключение фидера 1"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,302,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := k1f;

          if k2f <> ObjZv[Ptr].bP[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsNewMsg(Ptr,305+$2000,0,''); //----------------- "восстановление фидера 2"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,305,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,304+$1000,0,''); //--------------------- "выключение фидера 2"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,304,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := k2f;

          if k3f <> ObjZv[Ptr].bP[3] then
          begin
            if WorkMode.FixedMsg then
            if k3f then //------------------------------------- переключено питание на ДГА
            begin
              InsNewMsg(Ptr,308+$2000,0,'');
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,308,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := k3f;

          if vf1 <> ObjZv[Ptr].bP[4] then
          begin
            if WorkMode. FixedMsg then
            if not vf1 then
            begin
              InsNewMsg(Ptr,306+$2000,0,'');  //----------- Переключено питание на 1 фидер
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,306,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := vf1;

          if vf2 <> ObjZv[Ptr].bP[5] then
          begin
            if WorkMode.FixedMsg then
            if not vf2 then
            begin
              InsNewMsg(Ptr,307+$2000,0,'');
              {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,307,'',0),5,2);
              {$ELSE}
              SBeep[2] := true;
              {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[5] := vf2;
          ObjZv[Ptr].bP[1] := k1f;
          ObjZv[Ptr].bP[2] := k2f;
          ObjZv[Ptr].bP[3] := k3f;
          ObjZv[Ptr].bP[4] := vf1;
          ObjZv[Ptr].bP[5] := vf2;
        end;
//------------------------------------------------------------------------------------ КПП
        if kpp <> ObjZv[Ptr].bP[6] then
        begin
          if WorkMode.FixedMsg and kpp then
          begin
            InsNewMsg(Ptr,284+$1000,0,''); //---------------- "Перегорание предохранителя"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,284,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        //---------------------------------------------------------------------------- КПА
        if kpa <> ObjZv[Ptr].bP[7] then
        begin
          if WorkMode.FixedMsg and kpa then
          begin
            InsNewMsg(Ptr,285+$1000,0,''); // Неисправность питания схем контроля предохр.
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,285,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[6] := kpp;
        ObjZv[Ptr].bP[7] := kpa;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[6] := kpp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[7] := kpa;
        //---------------------------------------------------------------------------- СЗК
        if szk <> ObjZv[Ptr].bP[8] then
        begin
          if WorkMode.FixedMsg then
          begin
            if szk then
            begin
              InsNewMsg(Ptr,286+$1000,0,''); //--------- "Понижение изоляции схем питания"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,286,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,404+$2000,0,''); //Выключ. сигнализатора изоляции схем питания
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,404,'',0),0,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[8] := szk;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[8] := szk;

        //----------------------------------------------------------------------------- АК
        if ak <> ObjZv[Ptr].bP[9] then
        begin
          if WorkMode.FixedMsg and ak then
          begin
            InsNewMsg(Ptr,287+$1000,0,''); // Неисправ.питания схем кодир. рельсовых цепей
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,287,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[9] := ak;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[9] := ak;

        //-------------------------------------------------------------------------- К1ЩВП
        if k1shvp <> ObjZv[Ptr].bP[10] then
        begin
          if WorkMode.FixedMsg and k1shvp then
          begin
            InsNewMsg(Ptr,288+$2000,0,''); //--------------------------- "Отключение ЩВП1"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,288,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[10] := k1shvp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[10] := k1shvp;
        //-------------------------------------------------------------------------- К2ЩВП
        if k2shvp <> ObjZv[Ptr].bP[11] then
        begin
          if WorkMode.FixedMsg and k2shvp then
          begin
            InsNewMsg(Ptr,289+$2000,0,''); //--------------------------- "Отключение ЩВП2"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,289,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[11] := k2shvp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[11] := k2shvp;

        //---------------------------------------------------------------------------- КНЗ
        if knz <> ObjZv[Ptr].bP[12] then
        begin
          if WorkMode.FixedMsg and knz then
          begin
            InsNewMsg(Ptr,290+$1000,0,''); //------------- "Форсированный заряд батареи 1"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,290,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[12] := knz;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[12] := knz;

        //---------------------------------------------------------------------------- КНБ
        if knb <> ObjZv[Ptr].bP[13] then
        begin
          if WorkMode.FixedMsg and knb then
          begin
            InsNewMsg(Ptr,291+$1000,0,''); //-------------- "Нет нормы напряжения батареи"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,291,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[13] := knb;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[13] := knb;

        //---------------------------------------------------------------------------- ВМГ
        if vmg <> ObjZv[Ptr].bP[18] then
        begin
          if WorkMode.FixedMsg and vmg then
          begin
            InsNewMsg(Ptr,515+$1000,0,''); //--------------- "Неисправен комплект мигания"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,515,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[18] := vmg;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[18] := vmg;

        //--------------------------------------- 1ФК контроль чередования фаз 1-го фидера

        if fk1 <> ObjZv[Ptr].bP[19] then
        begin
          if WorkMode.FixedMsg and fk1 then
          begin
            InsNewMsg(Ptr,537+$1000,0,''); //---------- "Нет нормы чередования фаз фидера"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,537,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[19] := fk1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[19] := fk1;

        //--------------------------------------- 2ФК контроль чередования фаз 2-го фидера
        if fk2 <> ObjZv[Ptr].bP[20] then
        begin
          if WorkMode.FixedMsg and fk2 then
          begin
            InsNewMsg(Ptr,537+$1000,0,''); //---------- "Нет нормы чередования фаз фидера"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,537,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[20] := fk2;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[20] := fk2;

        //-------------------------------------------- 1ФУ контроль напряжения 1-го фидера
        if fu1 <> ObjZv[Ptr].bP[21] then
        begin
          if WorkMode.FixedMsg and fu1 then
          begin
            InsNewMsg(Ptr,538+$1000,0,''); //--------------- "Нет нормы напряжения фидера"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,538,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[21] := fu1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[21] := fu1;

        //-------------------------------------------- 2ФУ контроль напряжения 2-го фидера
        if fu2 <> ObjZv[Ptr].bP[22] then
        begin
          if WorkMode.FixedMsg and fu2 then
          begin
            InsNewMsg(Ptr,538+$1000,0,''); //--------------- "Нет нормы напряжения фидера"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,538,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[22] := fu2;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[22] := fu2;

        //----------------------------------------------- контроль отключения 2-ух фидеров
        if vf <> ObjZv[Ptr].bP[23] then
        begin
          if WorkMode.FixedMsg and vf then
          begin
            InsNewMsg(Ptr,539+$1000,0,''); //---- "Зафиксировано отключение обоих фидеров"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,539,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[23] := vf;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[23] := vf;

        //------------------------------------------------ контроль фильтрации кодирования
        if pf1 <> ObjZv[Ptr].bP[24] then
        begin
          if WorkMode.FixedMsg and pf1 then
          begin
            InsNewMsg(Ptr,540+$1000,0,''); //---------- "Нет нормы фильтрации кодирования"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,540,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[24] := pf1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[24] := pf1;

        //----------------------------------------------- контроль питания рельсовых цепей
        if la <> ObjZv[Ptr].bP[25] then
        begin
          if WorkMode.FixedMsg and la then
          begin
            InsNewMsg(Ptr,484+$1000,0,''); //------- Неисправность питания рельсовых цепей
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,484,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[25] := la;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[25] := la;

        //--------------------------------------------------------- контроль питания табло
        if at <> ObjZv[Ptr].bP[26] then
        begin
          if WorkMode.FixedMsg and at then
          begin
            InsNewMsg(Ptr,484+$1000,0,''); //----------------- Неисправность питания табло
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,545,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[26] := at;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[26] := at;

        if kmgt <> ObjZv[Ptr].bP[27] then
        begin
          if WorkMode.FixedMsg and kmgt then
          begin
            InsNewMsg(Ptr,574+$1000,0,''); //----------------- Неисправность мигания табло
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,574,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[27] := kmgt;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[27] := kmgt;
      end;

      for i := 1 to 34 do //------------------------ переписать все непарафазности побитно
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[i] := ObjZv[Ptr].NParam[i];
        OVBuffer[ObjZv[Ptr].VBufInd].Param[i] := ObjZv[Ptr].bP[i];
      end;
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    end;
end;

//========================================================================================
//-------------------------------- Доступ к внутренним параметрам объекта зависимостей #35
procedure PrepInside(Ptr : Integer);
var
  i,j,MainObj,MainCod,cvet_lamp : Integer;
  TXT : string;
begin
    cvet_lamp := 0;
    if ObjZv[Ptr].BasOb > 0 then
    begin
      MainObj := ObjZv[Ptr].BasOb; //-------------------------------- базовый объект
      case ObjZv[Ptr].ObCI[1] of
        1 :
        begin //------------------------------------------------------------------------ Н
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[8] or //------- Н из FR3 или ...
          (ObjZv[MainObj].bP[9] and ObjZv[MainObj].bP[14]); //---- ППР и ПрогЗам
        end;

        2 :
        begin //----------------------------------------------------------------------- НМ
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[6] or //------ НМ из FR3 или ...
          (ObjZv[MainObj].bP[7] and ObjZv[MainObj].bP[14]);//----- МПР и ПрогЗам
        end;

        3 :
        begin //--------------------------------------------------------------------- Н&НМ
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[6] or //---------------- НМ из FR3 или ...
          ObjZv[MainObj].bP[8] or //------------------------------------- Н из FR3 или ...
          ((ObjZv[MainObj].bP[7] or ObjZv[MainObj].bP[9]) //-------------- МПР или ППР ...
          and ObjZv[MainObj].bP[14]); //---------------------------------------- и ПрогЗам
        end;

        4 : //----------------------------------- доступ к 2-битному объекту контроля кода
        begin
          for i := 1 to 32 do
          begin
            ObjZv[Ptr].bP[i] := ObjZv[MainObj].bP[i];
            ObjZv[Ptr].NParam[i] := ObjZv[MainObj].NParam[i];
          end;

          MainCod := 0;
          if ObjZv[MainObj].bP[1] then MainCod := MainCod + 1;
          if ObjZv[MainObj].bP[2] then MainCod := MainCod + 2;
          //--------------------------------------------- MainCod может быть равен 0,1,2,3
          if MainCod <> ObjZv[MainObj].iP[1] then //------------- есть изменение кода
          begin
            if ((ObjZv[Ptr].ObCI[MainCod+1]) <> 0) and (MainCod <> 0) then
            begin
              if MainCod = 1 then cvet_lamp := ObjZv[Ptr].ObCI[10];
              if MainCod = 2 then cvet_lamp := ObjZv[Ptr].ObCI[11];
              if MainCod = 3 then cvet_lamp := ObjZv[Ptr].ObCI[12];
              if cvet_lamp = 28  then cvet_lamp := 1;
              if cvet_lamp = 27  then cvet_lamp := 1;
              if cvet_lamp = 29  then cvet_lamp := 2;
              if cvet_lamp = 26  then cvet_lamp := 9;
              if cvet_lamp = 7 then cvet_lamp := 1;

              TXT := MsgList[ObjZv[Ptr].ObCI[MainCod+1]];
              PutSMsg(cvet_lamp,LastX,LastY,TXT);
              SBeep[2] := WorkMode.Upravlenie;
              AddFixMes(TXT,cvet_lamp,0);
{$IFDEF RMSHN}
            InsNewMsg(Ptr,ObjZv[Ptr].ObCI[MainCod+1]+$1000,1,''); //----------------
            ObjZv[Ptr].dtP[1] := LastTime; //------------------- запомни время события
            inc(ObjZv[Ptr].siP[1]); //---------------------- увеличить счетчик событий
{$ENDIF}
            end;
          end;
          ObjZv[MainObj].iP[1] := MainCod;
        end;

        5://------------------------------------- доступ к 3-битному объекту контроля кода
        begin
          MainCod := 0;
          if ObjZv[MainObj].bP[1] then MainCod := MainCod + 1;
          if ObjZv[MainObj].bP[2] then MainCod := MainCod + 2;
          if ObjZv[MainObj].bP[3] then MainCod := MainCod + 4;
          if MainCod <> ObjZv[MainObj].iP[1] then //------------- есть изменение кода
          begin
            if ObjZv[Ptr].ObCI[MainCod+1] <> 0 then
            begin
              TXT := MsgList[ObjZv[Ptr].ObCI[MainCod+1]];
              PutSMsg(0,LastX,LastY,TXT);
              SBeep[2] := WorkMode.Upravlenie;
              AddFixMes(TXT,0,0);
            end;
          end;
          ObjZv[MainObj].iP[1] := MainCod;
        end;

        else ObjZv[Ptr].bP[1] := false;
      end;
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
    ColorVkl := 0;
    ColorOtkl := 0;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    for ii := 1 to 32 do  ObjZv[Ptr].NParam[32] := false; //-------------- Непарафазность
    //---------------------------------------------------- Обрабатываем 5 датчиков объекта
    for ii := 1 to 5 do
    begin
      nep := false;
      b[ii] := //-------------------------------------------------------- прямое состояние
      GetFR3(ObjZv[Ptr].ObCI[10+ii],nep,ObjZv[Ptr].bP[31]);
      ObjZv[Ptr].NParam[ii] := nep;
      if ObjZv[Ptr].ObCB[ii] then //---------- если нужна инверсия состояния датчика
      b[ii] := not b[ii];
    end;
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := false;

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];

      //---------------------------------------------------------- обработка 5-ти датчиков
      for ii := 1 to 5 do
      if ObjZv[Ptr].bP[ii] <> b[ii] then //------------ если датчик изменил состояние
      begin
        if ObjZv[Ptr].ObCB[ii+5] then  //-------------------- если нужна регистрация
        begin //------ регистрация изменения состояния датчика - вывод сообщения оператору
          if b[ii] then //--------------------------------------- если произошло включение
          begin
            if ((ii = 1) and (ObjZv[Ptr].ObCI[2] > 0)) or
            ((ii > 1) and (ObjZv[Ptr].ObCI[16+(ii-2)*2] > 0)) then//есть сооб. o вкл
              if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');
                SBeep[2] := WorkMode.Upravlenie;
                if ObjZv[Ptr].ObCI[23+ii] = 1 then
                begin
                  ColorVkl := 7; //------------------------------------------------ желтый
                  ColorOtkl := 7; //----------------------------------------------- желтый
                end else
                if ObjZv[Ptr].ObCI[23+ii] = 2 then
                begin
                  ColorVkl := 1; //----------------------------------------------- красный
                  ColorOtkl := 2; //---------------------------------------------- зеленый
                end else
                if ObjZv[Ptr].ObCI[23+ii] = 3 then
                begin
                  ColorVkl := 2; //----------------------------------------------- зеленый
                  ColorOtkl := 7; //----------------------------------------------- желтый
                end else
                begin
                  ColorVkl := 15; //------------------------------------------------ серый
                  ColorOtkl := 15; //----------------------------------------------- серый
                end;

                if ii = 1 then TXT := MsgList[ObjZv[Ptr].ObCI[2]];
                if ii > 1 then TXT := MsgList[ObjZv[Ptr].ObCI[16+(ii-2)*2]];
                PutSMsg(ColorVkl,LastX,LastY,TXT);
                SBeep[2] := WorkMode.Upravlenie;
                AddFixMes(TXT,0,1);
              end;
{$ELSE}
              InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');
{$ENDIF}
            end;
          end else
          begin
            if ObjZv[Ptr].ObCI[3] > 0 then //----- если есть сообщение об отключении
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ii = 1 then TXT := MsgList[ObjZv[Ptr].ObCI[3]];
              if ii > 1 then TXT := MsgList[ObjZv[Ptr].ObCI[17+(ii-2)*2]];

              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],ColorOtkl,'');
                AddFixMes(TXT,0,1);
                SBeep[2] := WorkMode.Upravlenie;
                PutSMsg(7,LastX,LastY,TXT);
              end;
{$ELSE}
              InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],ColorOtkl,'');
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[ii] := b[ii];
      end;

      if ObjZv[Ptr].VBufInd > 0 then
      for ii := 1 to 5 do
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
      end;
    end;
end;

//========================================================================================
//---------------------------- Подготовка объекта маршрута надвига для вывода на табло #38
procedure PrepMarhNadvig(Ptr : Integer);
  var v : boolean;
begin
  ObjZv[Ptr].bP[31] := true; // Активизация
  ObjZv[Ptr].bP[32] := false; // Непарафазность
  v := GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);

  if v <> ObjZv[Ptr].bP[1] then
  begin
    if v then
    begin // зафиксировано восприятие маршрута надвига
      SetNadvigParam(ObjZv[Ptr].ObCI[10]); // установить признак ГВ на маршрут надвига
    end;
  end;
  ObjZv[Ptr].bP[1] := v;  //

  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];
    if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1];
    end;
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
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация

    for i:= 1 to 32 do ObjZv[Ptr].NParam[i] :=false;

    r := //----------------------------------------------------------------------------- Р
    GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);

    ao :=//---------------------------------------------------------------------------- Ао
    GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);

    ar :=//---------------------------------------------------------------------------- Ар
    GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[4] :=//---------------------------------------------мультивtибратор
    GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);

    kp1 :=  //------------------------------------------------------------------------ КП1
    GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[5],ObjZv[Ptr].bP[31]);

    kp2 := //------------------------------------------------------------------------- КП2
    GetFR3(ObjZv[Ptr].ObCI[6],ObjZv[Ptr].NParam[6],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[7] := //-------------------------------------------------------------- К
    GetFR3(ObjZv[Ptr].ObCI[7],ObjZv[Ptr].NParam[7],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[11] := //------------------------------------------------------------ РУ
    GetFR3(ObjZv[Ptr].ObCI[9],ObjZv[Ptr].NParam[11],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[12] :=//------------------------------------------------------------- оУ
    GetFR3(ObjZv[Ptr].ObCI[10],ObjZv[Ptr].NParam[12],ObjZv[Ptr].bP[31]);

    otu :=  //------------------------------------------------------------------------ оТУ
    GetFR3(ObjZv[Ptr].ObCI[11],ObjZv[Ptr].NParam[13],ObjZv[Ptr].bP[31]);

    rotu := //----------------------------------------------------------------------- РоТУ
    GetFR3(ObjZv[Ptr].ObCI[12],ObjZv[Ptr].NParam[14],ObjZv[Ptr].bP[31]);

    //---------------- получить состояние стойки в маршрутной команде --------------------
    i := ObjZv[Ptr].ObCI[8] div 8;  //------ вычислить индекс приема данных по MYTHX
    if i > 0 then
    begin
      myt := FR3[i] and $38;   //------------------------- проверочные биты занятости ТУМС
      if myt > 0 then
      begin
        if myt = $38 then
        begin //-------------------------- выполняется установка маршрута-----------------
          ObjZv[Ptr].bP[8] := true;  //--------------------- фиксировать признак занятости
          ObjZv[Ptr].bP[9] := false; //---------------- сброс фиксации удачного завершения
          ObjZv[Ptr].bP[10] := false; //------------ сброс фиксации неудачного завершения
        end else //--------------------------- если нет текущей установки маршрута в ТУМСе
        begin
          ObjZv[Ptr].bP[8] := false; //--------------------- сброс фиксации занятости ТУМС
          if myt = $28 then //----------------------- проверочные биты удачного завершения
          begin //----------------------------- если успешное завершение устаноки маршрута
            ObjZv[Ptr].bP[9] := true; //------------------- фиксировать удачное завершение
            ObjZv[Ptr].bP[10] := false; //------------------ сбросить неудачное завершение
          end else
          begin //--------------------------- если неудачное завершение установки маршрута
            ObjZv[Ptr].bP[9] := false; //--------------------- сбросить удачное завершение
            if not ObjZv[Ptr].bP[10] then //-------------------- если неудачное завершение
            begin
              InsNewMsg(Ptr,4+$3000,0,''); //-------------------- "Маршрут не установлен "
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,4,'',0),4,4);
              {$ENDIF}
            end;
            ObjZv[Ptr].bP[10] := true; //----------- фиксировать неудачное завершение
          end;
        end;
      end;
    end;

    a := false; b := false; p := false; //------------ сбросить вспомогательные переменные

    if ObjZv[Ptr].VBufInd > 0 then //-------------------------- если есть видеобуфер
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];//-активность
      for ii := 1 to 32 do
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];

      if ObjZv[Ptr].bP[31] then
      begin
        //------------------------------------------------ если произошло изменение по КП1
        if kp1 <> ObjZv[Ptr].bP[5] and not ObjZv[Ptr].NParam[5] then
        begin
          if WorkMode.FixedMsg then //----------------------------- если включена фиксация
          begin
            if kp1 then //------------------------ если неисправно основное питание стойки
            begin
              InsNewMsg(Ptr,493+$3000,0,''); //- "неисправность основного источника питания"
              {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,493,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[5] := kp1; //----------------------- запомнить значение для КП1

        //------------------------------------------------ если произошло изменение по КП2
        if kp2 <> ObjZv[Ptr].bP[6] and not ObjZv[Ptr].NParam[6] then
        begin
          if WorkMode.FixedMsg then
          begin
            if kp2 then//------------------------ если неисправно резервное питание стойки
            begin
              InsNewMsg(Ptr,494+$3000,0,''); //неисправность резервного источника питания
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,494,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[6] := kp2; //---------------------------------------- Запомнить

        //---------------------------------------- если изменение основного комплекта МПСУ
        if ao <> ObjZv[Ptr].bP[2] and not ObjZv[Ptr].NParam[2] then
        begin
          if WorkMode.FixedMsg then
          begin
            a := true;
            if ao then //--------------------------------- если остановка 1 комплекта МПСУ
            begin
              InsNewMsg(Ptr,366+$3000,0,''); //"Остановка МПСУ-1"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,366,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //---------------------------------------------- если включен 1 комплект
              InsNewMsg(Ptr,367+$3000,0,''); //------------------------ "Включение МПСУ-1"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,367,ObjZv[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[2] := ao;//------------------------------------------ Запомнить

        //--------------------------------------- если изменение резервного комплекта МПСУ
        if ar <> ObjZv[Ptr].bP[3] and not ObjZv[Ptr].NParam[3] then
        begin
          if WorkMode.FixedMsg then
          begin
            b := true;
            if ar then
            begin//-------------------------------------------- остановка 2 комплекта МПСУ
              InsNewMsg(Ptr,368+$3000,0,''); //"остановка МПСУ-2"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,368,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //------------------------------------------------ если включен комплект
              InsNewMsg(Ptr,369+$3000,0,''); //------------------------ "Включение МПСУ-2"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,369,ObjZv[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[3] := ar;//------------------------------------------ Запомнить

        if ObjZv[Ptr].ObCB[1]  then //------------------------- если контроллер МСТУ
        begin
          //------------------------------------------------ если изменилось состояние ОТУ
          if otu <> ObjZv[Ptr].bP[13] and not ObjZv[Ptr].NParam[13] then
          begin
            if WorkMode.FixedMsg then
            begin
              if otu then //---------------------- если остановлен интерфейс ОТУ комплекта
              begin
                InsNewMsg(Ptr,500+$3000,0,''); //отключен интерфейс ОК основного комплекта
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,500,ObjZv[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //------------------------------------ включен интерфейс ОТУ комплекта
                InsNewMsg(Ptr,501+$3000,0,''); //-включен интерфейс ОК основного комплекта
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,501,ObjZv[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZv[Ptr].bP[13] := otu;  //------------------------------------ запомнить

          //------------------------------------------ изменение состояния интерфейса РОТУ
          if rotu <> ObjZv[Ptr].bP[14] and not ObjZv[Ptr].NParam[14] then
          begin
            if WorkMode.FixedMsg then
            begin
              if rotu then //------------------------- остановлен интерфейс РОТУ комплекта
              begin
                InsNewMsg(Ptr,502+$3000,0,'');//отключен интерфейс ОК резервного комплекта
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,502,ObjZv[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //----------------------------------- включен интерфейс РОТУ комплекта
                InsNewMsg(Ptr,503+$3000,0,''); //включен интерфейс ОК резервного комплекта
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,503,ObjZv[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZv[Ptr].bP[14] := rotu;  //----------------------------------- запомнить
        end;


        if r <> ObjZv[Ptr].bP[1] then  //---------- если переключение комплектов МПСУ
        begin
          if WorkMode.FixedMsg then p := true;
          ObjZv[Ptr].bP[1] := r; //---------------------------------------- запомнить
        end;

        if p or a or b then  // если переключение или  изменение МПСУ1 или изменение МПСУ2
        begin //------------------------------- зафиксировать переключение комплектов МПСУ
          if r and not ar then //------------------------------ включен резервный комплект
          begin
            InsNewMsg(Ptr,365+$3000,0,''); //---------------------------- "в работе МПСУ2"
            {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,365,ObjZv[Ptr].Liter,0),5,2);
            {$ENDIF}
          end else
          if not r and not ao then //--------------------------- включен основной комплект
          begin
            InsNewMsg(Ptr,364+$3000,0,''); //---------------------------- "в работе МПСУ1"
            {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,364,ObjZv[Ptr].Liter,0),5,2);
            {$ENDIF}
          end;
          ObjZv[Ptr].bP[1] := r; //---------------------------------------- запомнить
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //-------------------------------------------------------- Работа с каналами связи
        if (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][2]) and
        (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][3]) then
        svaz1 := config.SVAZ_TUMS[1][1] //------------- состояние параметра контроля связи
        else exit;

        if svaz1 <> ObjZv[Ptr].iP[1] then //----------------- изменилось состояние канала
        begin
          if (svaz1 and $40) = $40 then WorkMode.OKError := true
          else WorkMode.OKError := false;

          if ObjZv[Ptr].ObCI[13] = 1 then//------------------------------ для ТУМС 1
          begin
            if (svaz1 and $1) = $1 then //----------------------------------- потеря связи
            begin
              ObjZv[Ptr].bP[18] := true;
              if not ObjZv[Ptr].bP[33] then //--------- не было фиксации потери связи
              begin
                AddFixMes(GetSmsg(1,433,'1',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[33] := true;
              end;
            end else //-------------------------------------------------- нет потери связи
            begin
              if ObjZv[Ptr].bP[33] then //---------------- была фиксация потери связи
              begin
                AddFixMes(GetSmsg(1,434,'1',0),5,2);
                InsNewMsg(0,434+$1000,0,'');
                ObjZv[Ptr].bP[33] := false;
              end;
              ObjZv[Ptr].bP[18] := false;
            end;

            if (svaz1 and $4) = $4 then //-------------------------------------- потеря ТУ
            begin
              ObjZv[Ptr].bP[17] := true;
              if not ObjZv[Ptr].bP[30] then //------------ не было фиксации потери ТУ
              begin
                AddFixMes(GetSmsg(1,519,'1',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[30] := true;
              end;
            end else //----------------------------------------------------- нет потери ТУ
            begin
              if ObjZv[Ptr].bP[30] then //------------------- была фиксация потери ТУ
              begin
                AddFixMes(GetSmsg(1,520,'1',0),5,2);
                InsNewMsg(0,520+$1000,0,'');
                ObjZv[Ptr].bP[30] := false;
              end;
              ObjZv[Ptr].bP[17] := false;
            end;
          end else
          if ObjZv[Ptr].ObCI[13] = 2 then //--------------------------------- ТУМС-2
          begin
            if (svaz1 and $2) = $2 then //----------------------------------- потеря связи
            begin
              ObjZv[Ptr].bP[18] := true;
              if not ObjZv[Ptr].bP[33] then //--------- не было фиксации потери связи
              begin
                AddFixMes(GetSmsg(1,433,'2',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[33] := true;
              end;
            end else //-------------------------------------------------- нет потери связи
            begin
              if ObjZv[Ptr].bP[33] then //---------------- была фиксация потери связи
              begin
                AddFixMes(GetSmsg(1,434,'2',0), 5,2);
                InsNewMsg(0,434+$1000,0,'');
                ObjZv[Ptr].bP[33] := false;
              end;
              ObjZv[Ptr].bP[18] := false;
            end;

            if (svaz1 and $8) = $8 then //-------------------------------------- потеря ТУ
            begin
              ObjZv[Ptr].bP[17] := true;
              if not ObjZv[Ptr].bP[30] then //------------ не было фиксации потери ТУ
              begin
                AddFixMes(GetSmsg(1,519,'2',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[30] := true;
              end;
            end else //----------------------------------------------------- нет потери ТУ
            begin
              if ObjZv[Ptr].bP[30] then //------------------- была фиксация потери ТУ
              begin
                AddFixMes(GetSmsg(1,520,'2',0),5,2);
                InsNewMsg(0,520+$1000,0,'');
                ObjZv[Ptr].bP[30] := false;
              end;
              ObjZv[Ptr].bP[17] := false;
            end;
          end;

          //-------------------------------------------------------------- перепут каналов
          if (svaz1 and $20) = $20 then
          begin
            ObjZv[Ptr].bP[19] := true;
            if not ObjZv[Ptr].bP[32] then //-------------------- не было фиксации перепута
            begin
              AddFixMes(GetSmsg(1,521,'2',0),4,2);
              InsNewMsg(0,521+$1000,0,'');
              ObjZv[Ptr].bP[32] := true;
            end;
          end else
          begin //--------------------------------------------------- нет перепута каналов
            if ObjZv[Ptr].bP[32] then //--------------------------- была фиксация перепута
            begin
              AddFixMes(GetSmsg(1,520,'2',0),5,2);  InsNewMsg(0,520+$1000,0,'');
              ObjZv[Ptr].bP[32] := false;
            end;
            ObjZv[Ptr].bP[19] := false;
          end;

          //--------------------------- слежение за выдачей команды и получением квитанций
          if (svaz1 and $40) = $40 then KOMANDA_OUT := true //- выдана команда в канал УВК
          else KOMANDA_OUT := false;

          if(KOMANDA_OUT and (not KVITOK)) then //если выдана команда, но нет квитирования
          begin
            ObjZv[Ptr].bP[21] := true; //------ фиксируем, что команда выдана в канал
            if not ObjZv[Ptr].bP[29] then //--------- не было фиксации выдачи команды
            begin
              AddFixMes(GetSmsg(1,535,'',0),7,2);
              InsNewMsg(0,535+$1000,0,'');
              ObjZv[Ptr].bP[29] := true; //- выставляем требование ожидания квитанции
            end;
          end;

          //------------------------------------------------------- потеря связи с соседом
          if (svaz1 and $10) = $10 then
          begin
            ObjZv[Ptr].bP[20] := true;
            if not ObjZv[Ptr].bP[34] then //--------------- не было фиксации потери соседа
            begin
              AddFixMes(GetSmsg(1,522,'',0),4,2); InsNewMsg(0,522+$1000,0,'');
              ObjZv[Ptr].bP[34] := true;
            end;
          end else
          begin //------------------------------------------------------ нет потери соседа
            if ObjZv[Ptr].bP[34] then //---------------------- была фиксация потери соседа
            begin
              AddFixMes(GetSmsg(1,523,'',0),5,2);InsNewMsg(0,523+$1000,0,'');
              ObjZv[Ptr].bP[34] := false;
            end;
            ObjZv[Ptr].bP[20] := false;
          end;

          if((not KOMANDA_OUT) and (not KVITOK)) then//если команда сброшена без квитанции
          begin
            if WorkMode.OtvKom and (NET_PRIEMA_UVK <> 0) then
            begin
                AddFixMes(GetSmsg(1,542,'',0),4,3); // Команду не удалось передать
                InsNewMsg(0,542+$1000,0,'');
                SBeep[3] := true;
                NET_PRIEMA_UVK := 0;
                ObjZv[Ptr].bP[29] := false; //----------- отменить ожидание квитанции
                ObjZv[Ptr].bP[21] := false; //--------- сброс фиксации выдачи команды
                WorkMode.OtvKom := false;
            end else
            if ObjZv[Ptr].bP[21] then //---------- была ранее фиксация выдачи команды
            begin
              inc(NET_PRIEMA_UVK);
              if WorkMode.OtvKom then inc(NET_PRIEMA_UVK);
              AddFixMes(GetSmsg(1,541,'',0),4,4); //----- Нет приема команды в УВК
              InsNewMsg(0,541+$1000,0,'');
              ObjZv[Ptr].bP[29] := false; //------------- отменить ожидание квитанции
              ObjZv[Ptr].bP[21] := false; //----------- сброс фиксации выдачи команды

              if NET_PRIEMA_UVK >= 2 then
              begin
                inc(NET_PRIEMA_UVK);
                AddFixMes(GetSmsg(1,542,'',0),4,3); // Команду не удалось передать
                InsNewMsg(0,542+$1000,0,'');
                SBeep[3] := true;
                NET_PRIEMA_UVK := 0;
                ObjZv[Ptr].bP[29] := false; //----------- отменить ожидание квитанции
                ObjZv[Ptr].bP[21] := false; //--------- сброс фиксации выдачи команды
              end;
            end;
          end;

          if(KOMANDA_OUT and KVITOK) then //если выдана команда, и пришла квитанция от УВК
          begin //---------------------------------------------- есть квитанция на команду
            if ObjZv[Ptr].bP[21] then //---------- была ранее фиксация выдачи команды
            begin
              AddFixMes(GetSmsg(1,536,'',0),5,2); //----------- УВК принял команду
              InsNewMsg(0,536+$1000,0,'');
              ObjZv[Ptr].bP[29] := false; //------------- отменить ожидание квитанции
              ObjZv[Ptr].bP[21] := false; //----------- сброс фиксации выдачи команды
            end;
          end;
          ObjZv[Ptr].iP[1] := svaz1;
        end;

        //--------------------- заполнить параметры видеобуфера --------------------------
        for ii := 1 to 15 do
        begin
          OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
          OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
        end;

        for ii := 17 to 32 do
        begin
          OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
          OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
        end;
      end;
    end;
end;

//========================================================================================
//--------------------------------------------------------- Контроль режима управления #39
procedure PrepKRU(KRU : Integer);
var
  ops,ps : array[1..3] of Integer;
  gr,i : integer;
  lock,nepar,bRu,bOu,Su,Vsu,Du : boolean;
begin
  with ObjZv[KRU] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    nepar := false; //----------------------------------------------------- Непарафазность
    bRu  := GetFR3(ObCI[2],nepar,bP[31]); //------------------------------------------- РУ
    bOu  := GetFR3(ObCI[3],nepar,bP[31]); //------------------------------------------- ОУ
    Su  := GetFR3(ObCI[4],nepar,bP[31]); //-------------------------------------------- СУ
    Vsu := GetFR3(ObCI[5],nepar,bP[31]); //------------------------------------------- ВСУ
    Du  := GetFR3(ObCI[6],nepar,bP[31]); //-------------------------------------------- ДУ

    if (bRu<> bP[1]) or (bOu <> bP[2]) or  (Su<> bP[3]) or (Vsu<> bP[4]) or (Du<> bP[5])
    then   ChDirect := true;

    bP[1] := bRu; bP[2] := bOu; bP[3] := Su; bP[4] := Vsu;  bP[5] := Du;
    bP[32] := nepar; //---------------------------------------------------- Непарафазность

    if ObCI[7] > 0 then bP[6] := not GetFR3(ObCI[7],bP[32],bP[31]) //----------------- КРУ
    else bP[6] := true;

    gr := ObCI[1];//--------------------------------------- номер группы объектов контроля
    if (ObCI[1] < 1) or (ObCI[1] > 8) then gr := 0;

    //----------------------------------------------------- Присвоить параметры управления
    WorkMode.BU[gr] := not bP[31]; //--------------------------------- контроль активности
    WorkMode.NU[gr] := bP[32];     //------------------------------ контроль достоверности
    if ObCI[2]> 0 then WorkMode.RU[gr] := bP[1];//есть датчик РУ,активность режима "пульт"
    if ObCI[3] > 0 then WorkMode.OU[gr] := bP[2];//есть датчик ОУ, активность режима "УВК"
    if ObCI[4] > 0 then WorkMode.SUpr[gr] := bP[3]; //есть датчик СУ, активность режима СУ
    if ObCI[6] > 0 then WorkMode.DU[gr] := bP[5];//- есть датчик ДУ, активность датчика ДУ

    WorkMode.KRU[gr] := bP[6];//------------------------ получить групповую готовность КРУ

    if gr = 0 then
    begin //---------------------------------------- Определить признак фиксации сообщений
      lock := false;
      if WorkMode.BU[0] then
      begin T[1].Activ  := false;    lock := true; end else
      begin
        if T[1].Activ  then
        begin //-------------- проверить конец выдержки после включения обмена с серверами
          if T[1].F < LastTime then begin lock := false; T[1].Activ  := false; end;
        end //------------------------ Начать отсчет задержки начала регистрации сообщений
        else begin T[1].F := LastTime + 15/80000;  T[1].Activ  := true; end;
      end;
      WorkMode.FixedMsg := not (StartRM or WorkMode.NU[0] or lock);
    end;

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16]:= bP[31]; OVBuffer[VBufInd].Param[1]:= bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBufInd].Param[2] := bP[2];    //---------------------------------ОУ
        OVBuffer[VBufInd].Param[3] := bP[1];    //---------------------------------РУ
        OVBuffer[VBufInd].Param[4] := not bP[6];//------------------------------- КРУ
        OVBuffer[VBufInd].Param[5] := bP[3];    //-------------------------------- СУ
        OVBuffer[VBufInd].Param[6] := bP[4];    //------------------------------- ВСУ
        OVBuffer[VBufInd].Param[7] := bP[5];//-------------- ДУ
      end;
    end;

    //----------------------------- проверить количество открытых пригласительных сигналов
    ps[1] := 0; ps[2] := 0; ps[3] := 0; //------ расчитано максимум на 3 района управления

    for i := 1 to WorkMode.LimitObjZav do //-------------------- пройтись по всем объектам
    if ObjZv[i].TypeObj = 7 then //------------------- если попался пригласительный сигнал
    begin
      if ObjZv[i].bP[1] then inc(ps[ObjZv[i].RU]); //----- если включен ПС, увеличить счет
    end;
    //---------------------------------------------------------------------------- Район 1
    if ps[1] <> ops[1] then //если изменилось число открытых пригласительных в 1-ом районе
    begin
      if (ps[1] > 1) and (ps[1] > ops[1]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 1) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,''); //---- Открыто более одного пригласительного огня
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[19] := true; //--------------------------- фиксация ненормы по ПС в 1-ом районе
      end  else bP[19] := false;
      ops[1] := ps[1];
    end;
    //---------------------------------------------------------------------------- Район 2
    if ps[2] <> ops[2] then
    begin
      if (ps[2] > 1) and (ps[2] > ops[2]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 2) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,'');
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[20] := true;
      end  else bP[20] := false;
      ops[2] := ps[2];
    end;
    //---------------------------------------------------------------------------- Район 3
    if ps[3] <> ops[3] then
    begin
      if (ps[3] > 1) and (ps[3] > ops[3]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 3) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,'');
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[21] := true;
      end else  bP[21] := false;
      ops[3] := ps[3];
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------------------ Схема известителя #40
procedure PrepIzvPoezd(Ptr : Integer);
  var i : integer; z : boolean;
begin
  z := false;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      if not ObjZv[ObjZv[Ptr].ObCI[i]].bP[1] then
      begin
        z := true;
        break;
      end;
    end;
   ObjZv[Ptr].bP[1] := z;
end;

//========================================================================================
//-------------- Подготовка объекта охранности стрелок в пути для маршрута отправления #41
procedure PrepVPStrelki(VPSTR : Integer);
var
  SVotp, //---------------------------------------------------------- светофор отправления
  SP_ot, //------------------------------------------------ перекрывная СП для отправления
  ST_oh, //--------------------------------------------------- охраняемая стрелка (в пути)
  XST_oh, //--------------------------------------------------------- хвост стрелки в пути
  RZS, //------------------------------------------------ объект ручного замыкания стрелки
  Para, //----------------------------------------------------------------- парная стрелка
  Para_Xst, //------------------------------------------------------- хвост парной стрелки
  i : integer;
  z, dzs : boolean;
begin
  SVotp := ObjZv[VPSTR].BasOb; //---------------------------- светофор отравления

  //------------- если указан светофор отправления и (поездной открыт или начало поездное)
  if(SVotp>0) and ((ObjZv[SVotp].bP[3] or ObjZv[SVotp].bP[4] or ObjZv[SVotp].bP[8]) and
  not ObjZv[SVotp].bP[1]) then ObjZv[VPSTR].bP[20] := true
  else ObjZv[VPSTR].bP[20] := false; //------------------------ признак отправления поезда

  SP_ot := ObjZv[VPSTR].UpdOb; //-------------- Индекс перекрывной СП отправления

  if SP_ot > 0 then
  begin
    z:=ObjZv[SP_ot].bP[2] or not ObjZv[VPSTR].bP[20];//- "З" перекрывной СП маршрута отпр.

    //------------------ если произошло размыкание перекрывной секции маршрута отправления
    if (ObjZv[VPSTR].bP[5] <> z) and z then ObjZv[VPSTR].bP[20] := false; // Снять признак
    ObjZv[VPSTR].bP[5] := z; //------------------------------------ состояние замыкания СП

    //---- если нет поездного маршрута отправления и нет трассировки поездного отправления
    if (not ObjZv[VPSTR].bP[20] or ObjZv[VPSTR].bP[21]) then exit;
//----------------------------------------------------------------------------------------
    for i := 1 to 4 do
    begin
      ST_oh := ObjZv[VPSTR].ObCI[i];//------- Индекс объекта очередной стрелки в пути
      if ST_oh > 0 then //----------------------------- если есть очередная стрелка в пути
      begin
        Para := ObjZv[ST_oh].ObCI[25]; //---------------------- объект парной стрелки
        Para_Xst := 0;
        if Para > 0 then Para_Xst := ObjZv[Para].BasOb; //------ хвост парной стрелки
        XST_oh := ObjZv[ST_oh].BasOb; //---------------------- хвост охранной стрелки
        RZS := ObjZv[XST_oh].ObCI[12];
        dzs := ObjZv[RZS].bP[1];

        ObjZv[SP_ot].bP[14] := ObjZv[SP_ot].bP[14] and z;

        if ObjZv[VPSTR].ObCB[1] then ObjZv[ST_oh].bP[27]:= not z;//- для НЧ маршрутов

        if ObjZv[VPSTR].ObCB[2] then ObjZv[ST_oh].bP[26] := not z;//- для Ч маршрутов

        //---------------------------------------------- итоговое дополнительное замыкание
        if not dzs then ObjZv[ST_oh].bP[4]:= ObjZv[ST_oh].bP[27] or ObjZv[ST_oh].bP[26] or
        ObjZv[ST_oh].bP[33] or ObjZv[ST_oh].bP[25]
        else ObjZv[ST_oh].bP[4] := true;

        if Para_Xst > 0 then ObjZv[Para_Xst].bP[4] := ObjZv[ST_oh].bP[4];

        OVBuffer[ObjZv[ST_oh].VBufInd].Param[7] :=
        ObjZv[ST_oh].bP[4];//----------------------------------- вывести на экран

        if Para_Xst > 0 then
        OVBuffer[ObjZv[Para].VBufInd].Param[7] :=
        ObjZv[Para_Xst].bP[4];//-------------------------------- вывести на экран


        //------------------------------- Трассировка маршрута через описание охранности
        if ObjZv[SP_ot].bP[14] then //---- секция отправления замкнута программно
        begin
          if (ObjZv[VPSTR].ObCI[i+4] = 0) or//в пути нет маневрового с красным или
          ((ObjZv[VPSTR].ObCI[i+4] > 0) and //------------ такой сигнал есть и ...
          (ObjZv[XST_oh].bP[21] and //хвост стрелки в пути замкнут  СП и ...
          ObjZv[XST_oh].bP[22])) then //--- хвост стрелки в пути занят из СП
          begin
            ObjZv[VPSTR].bP[22+i] := true;//-- установить предварительное замыкание

            if ObjZv[VPSTR].ObCB[i*3] then // если i-я стрелка должна быть в плюсе
            begin
              if not ObjZv[ST_oh].bP[1] //----------- если i-я стрелка не в плюсе
              then ObjZv[VPSTR].bP[7+i] := true;//-- признак ожидания перевода i-ой
            end else
            if ObjZv[VPSTR].ObCB[i*3+1] then //стрелка должна должна быть в минусе
            begin
              if not ObjZv[ST_oh].bP[2] //-------------- если стрелка не в минусе
              then ObjZv[VPSTR].bP[7+i] := true; //- признак ожидания перевода i-ой
            end;
          end;
        end else //---------------------- если нет предварительного замыкания СП, то ...
        ObjZv[VPSTR].bP[22+i] := false; //-- снять признак замыкания стрелки в пути

        if not ObjZv[VPSTR].bP[7+i] then //--------- если нет ожидания перевода, то
        begin
          ObjZv[VPSTR].bP[i] := //----- требование перевода i-ой стрелки состоит из
          not ObjZv[SP_ot].bP[8] and //-------- предв. трассировки СП отправления
          not ObjZv[SP_ot].bP[14];//-------------- прогр.замыкания СП отправления
        end
        else  ObjZv[VPSTR].bP[i] := false;//- когда ждем перевода, снять требование

        if ObjZv[SP_ot].bP[9] then
        if not ObjZv[XST_oh].bP[5] then //--- если хвост не требует перевода
        ObjZv[XST_oh].bP[5] := ObjZv[VPSTR].bP[i];//копировать значение

        if not ObjZv[XST_oh].bP[8] then //--- если хвост не ожидает перевода
        ObjZv[XST_oh].bP[8] := ObjZv[VPSTR].bP[7+i];//------ копировать

        if not ObjZv[XST_oh].bP[23] then //- если хвост не имеет трассировки
        ObjZv[XST_oh].bP[23] := ObjZv[VPSTR].bP[22+i];//---- копировать
      end;
    end;
  end;
end;

//========================================================================================
//------ Схема перезамыкания поездного маршрута на маневроаый (СВП для стрелки в пути) #42
procedure PrepVP(SVP : Integer);
var
  i,ohr,Sm,SP,SVTF : integer;
  Zm,nepar,VP : boolean;
begin
  VP := GetFR3(ObjZv[SVP].ObCI[11],nepar,ObjZv[SVP].bP[31]); //состояние релейного ВП
  SP := ObjZv[SVP].UpdOb; //-------------------------- объект СП для стрелки в пути
  SVTF := ObjZv[SVP].BasOb; //--------------------- светофор прикрытия стрелки в пути
  Zm := ObjZv[SP].bP[2]; //------------------------------ Получить замыкалку секции в пути

  ObjZv[SVP].bP[1] := VP;

  if (ObjZv[SVP].bP[3] <> Zm) and Zm then //----- если состоялось размыкание секции в пути
  begin //------------ Снять признак П-приема на путь, разрешение перезамыкания П-маршрута
    ObjZv[SVP].bP[1] := false; ObjZv[SVP].bP[2] := false; ObjZv[SVP].bP[3] := Zm;
  end;

  //------------ есть П-маршрут и нет МС1 и МС2 у стрелки, свободна и замкнута СП и нет РИ
  if ObjZv[SVP].bP[1] and not ObjZv[SVTF].bP[1] and not ObjZv[SVTF].bP[2] and
  ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] and not ObjZv[SP].bP[3] then
  begin
    Zm := true;
    ObjZv[SVP].bP[3] := Zm; //------------------------------ запомнить состояние замыкалки

    for i := 1 to 4 do //------------------------- пройти по 4-м возможным стрелкам в пути
    begin //-------------------------- проверить наличие плюсового контроля стрелок в пути
      ohr := ObjZv[SVP].ObCI[i]; //------ охранная стрелка (очередная стрелка в пути)
      //----- если хотя бы одна стрелка в пути не в плюсе, навязать z = false всех стрелок
      if(ohr > 0) and not ObjZv[ohr].bP[1] then Zm := Zm and not Zm;
    end;

    if Zm then  //---------------------------------------------------- если все разомкнуты
    begin //----------------------------------- все стрелки в пути имеют контроль по плюсу
      Sm := ObjZv[SVP].ObCI[10]; //------------ враждебный маневровый светофор в пути
      if Sm > 0 then //------------------------------------------ если есть такой светофор
      begin //--------------------------------- проверка враждебного маневрового светофора
        //-------- если МС1 или МС2 или есть НМ из STAN или признак маневровой трассировки
        if ObjZv[Sm].bP[1] or ObjZv[Sm].bP[2] or ObjZv[Sm].bP[6] or ObjZv[Sm].bP[7]
        then Zm := false;
      end;
    end;
    //--------------------- установить признак разрешения перезамыкания поездного маршрута
    //---------------------------------------------- на маневровый по результатам проверки
    ObjZv[SVP].bP[2] := Zm;   //-------------------- разрешить или запретить перезамыкание
  end else
  begin
    ObjZv[SVP].bP[3] := Zm; ObjZv[SVP].bP[2] := false;//снять разрешение перезам.маршрута
  end;
end;

//========================================================================================
//--------------------------------------- Объект исключения пути из маневрового района #43
procedure PrepOPI(Ptr : Integer);
var
  MK,Str,Xstr,o,p,j : integer;
begin
  with ObjZv[Ptr] do
  begin
    bP[31] := true; bP[32] := false;//----------------------- Активизация и непарафазность
    bP[1]:= GetFR3(ObCI[1],bP[32],bP[31]); bP[2]:= GetFR3(ObCI[2],bP[32],bP[31]);//опи,рпо
    OVBuffer[VBufInd].Param[16] := bP[31]; OVBuffer[VBufInd].Param[1] := bP[32];
    MK := BasOb;   //-------------------------------------------------- маневровая колонка

    if bP[31] and not bP[32] then
    begin
      if MK > 0 then
      begin
        //если МИ = не замкнуты маневры, то показать оПИ или РПо
        if ObjZv[MK].bP[3] then
        begin
          OVBuffer[VBufInd].Param[2]:= bP[1] or bP[2]; OVBuffer[VBufInd].Param[3]:= false;
        end else //------------------------------------------------------ маневры замкнуты
        if bP[1] and bP[2] then //----------------------------------------- есть ОПИ и РПО
        begin OVBuffer[VBufInd].Param[2]:=true; OVBuffer[VBufInd].Param[3]:=true; end else
        begin OVBuffer[VBufInd].Param[2]:=bP[2];OVBuffer[VBufInd].Param[3]:=bP[1];end;
      end;

      if (MK > 0) and not (bP[1] or bP[2]) then  //------ есть колонка и нет оПИ и нет РПо
      begin //------------------------ протрассировать выезд на пути из маневрового района
        if ObCB[1] then p := 2 else p := 1;

        o := Sosed[p].Obj; p := Sosed[p].Pin;
        j := 50;
        while j > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin //-------------------------------------------------------------- стрелка
              Xstr := ObjZv[o].BasOb;
              case p of
                2: ObjZv[Xstr].bP[10]:= true; //----------- запрет "+" перевода в маневрах
                3: ObjZv[Xstr].bP[11]:= true;//------------ запрет "-" перевода в маневрах
              end;
              p := ObjZv[Xstr].Sosed[1].Pin;  o := ObjZv[Xstr].Sosed[1].Obj;
            end;

            44 :
            begin
              Str  := ObjZv[o].UpdOb; XStr := ObjZv[Str].BasOb;

              if not ObjZv[o].bP[1] then ObjZv[o].bP[1]:= ObjZv[XStr].bP[10]; //----- ПСМИ
              if not ObjZv[o].bP[2] then ObjZv[o].bP[2]:= ObjZv[XStr].bP[11]; //----- ПСМИ

              if p = 1 then
              begin p:= ObjZv[o].Sosed[2].Pin; o:= ObjZv[o].Sosed[2].Obj; end else
              begin p:= ObjZv[o].Sosed[1].Pin; o:= ObjZv[o].Sosed[1].Obj; end;
            end;

            48 : begin  ObjZv[o].bP[1] := true; break; end;  //----------------------- РПо

            else
              if p = 1 then
              begin p := ObjZv[o].Sosed[2].Pin;  o := ObjZv[o].Sosed[2].Obj; end else
              begin p := ObjZv[o].Sosed[1].Pin;  o := ObjZv[o].Sosed[1].Obj; end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(j);
        end;
      end;
    end;
  end;
end;

//========================================================================================
//-------- Объект исключения пути из маневрового района (подсветка охранности стрелок) #43
procedure PrepSOPI(Ptr : Integer);
var
  MKol,ob,p,j,Put,Xstr : integer;
begin
    if ObjZv[Ptr].UpdOb = 0 then exit;

    Put := ObjZv[Ptr].UpdOb;
    MKol := ObjZv[Ptr].BasOb;

    //------ управление передано на местное и нет ОИ и есть восприятие и ...
    if(MKol > 0) and ObjZv[MKol].bP[1] and not ObjZv[MKol].bP[4] and ObjZv[MKol].bP[5] and

    not ObjZv[Ptr].bP[2] and //------------------------- маневровый район замкнут
    (MarhTrac.Rod= MarshP) and not ObjZv[Put].bP[8] then//путь в поездном маршруте
    begin
      //--------------------------------- отобразить охранность стрелок маневрового района
      if ObjZv[Ptr].ObCB[1] then p := 2 else p := 1;    //------ если проверять 1->2

      ob := ObjZv[Ptr].Sosed[p].Obj;  p := ObjZv[Ptr].Sosed[p].Pin; j := 100;

      while j > 0 do
      begin
        case ObjZv[ob].TypeObj of
          2 :
          begin //---------------------------------------------------------------- стрелка
            Xstr := ObjZv[ob].BasOb;
            case p of
              2 :
              begin
                if ObjZv[Xstr].bP[11] then  // МСМИ ----- исключение перевода в минус
                begin
                  if not ObjZv[Xstr].bP[5]// если нет требования перевода в охраннное
                  then ObjZv[Xstr].bP[5] := true; //------- установить это требование
                  break;
                end;
              end;
              3 :
              begin
                if ObjZv[Xstr].bP[10] then // ПСМИ ------- исключение перевода в плюс
                begin
                  if not ObjZv[Xstr].bP[5] then ObjZv[Xstr].bP[5] := true;break;
                end;
              end;
            end;
            p := ObjZv[ob].Sosed[1].Pin;
            ob := ObjZv[ob].Sosed[1].Obj;
          end;

          48 : break;  //------------------------------------------------------------- РПо

          else
            if p = 1 then
            begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
            else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;
        if (ob = 0) or (p < 1) then break;
        dec(j);
      end;
    end;
end;

//========================================================================================
//------------------------------------------------------------- подготовка объекта СМИ #44
procedure PrepSMI(Ptr : Integer);
begin
{
  o := ObjZv[Ptr].UpdOb; // Индекс стрелки маневрового района
  if not ObjZv[ObjZv[o].BasOb].bP[5] then
    ObjZv[ObjZv[o].BasOb].bP[5] := ObjZv[Ptr].bP[5];
  if not ObjZv[ObjZv[o].BasOb].bP[8] then
    ObjZv[ObjZv[o].BasOb].bP[8] := ObjZv[Ptr].bP[8];
}
end;

//========================================================================================
//------------------------------------------ Подготовка объекта выбора зоны оповещения #45
procedure PrepZon(Zon : Integer);
begin
  with ObjZv[Zon] do
  begin
    bP[31] := true; //-------------------------------------------------------- Активизация
    bP[32] := false; //---------------------------------------------------- Непарафазность

    bP[1] := //----------------------------------------------------------------------- КНМ
    GetFR3(ObCI[2],bP[32],bP[31]);
    bP[2] := //------------------------------------------------------------------------ зМ
    GetFR3(ObCI[3],bP[32],bP[31]);

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBufInd].Param[2] := bP[1];
        OVBuffer[VBufInd].Param[3] := bP[2];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------- подготовка объекта "Светофор с автодействием" #46
procedure PrepAutoSvetofor(AvtoS : Integer);
{$IFDEF RMDSP}
var
  sig,i,str : integer;
{$ENDIF}
begin
{$IFDEF RMDSP}
    Sig := ObjZv[AvtoS].BasOb;
    if not ObjZv[AvtoS].bP[1] then exit; //---------------- выключено автодействие сигнала

    if not (WorkMode.Upravlenie and WorkMode.OU[0]
    and WorkMode.OU[ObjZv[AvtoS].Group])//нет автодействия при  потере управления с РМ-ДСП
    then exit
    else
    if not WorkMode.CmdReady and not WorkMode.LockCmd then
    begin
      if ObjZv[sig].bP[4] then //---------------------------------- поездной сигнал открыт
      begin
        ObjZv[AvtoS].T[1].Activ  := false;
        ObjZv[AvtoS].bP[2] := false;
        exit;
      end;

      //------------------------------------ проверить наличие плюсового положения стрелок
      for i := 1 to 10 do
      begin
        str := ObjZv[AvtoS].ObCI[i];
        if str > 0 then
        begin
          if not ObjZv[str].bP[1] then  begin ObjZv[AvtoS].bP[2] := false; exit; end;
        end;
      end;

      //---------------------------------------- проверить таймаут между повторами команды
      if ObjZv[AvtoS].T[1].Activ  then
      begin
        if ObjZv[AvtoS].T[1].F > LastTime then exit;
      end;

      //---------------------------- Проверить возможность выдачи команды открытия сигнала
      if CheckAutoMarsh(AvtoS,ObjZv[AvtoS].ObCI[25]) then
      begin
        if SendCommandToSrv(ObjZv[Sig].ObCI[5] div 8, _svotkrauto,Sig) then
        begin //--------------------------------------------- выдана команда на исполнение
          if SetProgramZamykanie(ObjZv[AvtoS].ObCI[25],true) then
          begin
            //если оператор что-то делает, подождать 15 секунд до очередной попытки выдачи
            //------------------------------------- команды открытия сигнала автодействием
            if OperatorDirect > LastTime then
            ObjZv[AvtoS].T[1].F := LastTime + IntervalAutoMarsh / 86400
            //оператор ничего не делает, подождать 10 секунд и повторно выдать команду
            else ObjZv[AvtoS].T[1].F := LastTime + 10 / 86400; // зарядить таймер
            ObjZv[AvtoS].T[1].Activ  := true;
            SBeep[5] := WorkMode.Upravlenie;
          end;
        end;
      end;
    end;
  {$ENDIF}
end;

//========================================================================================
//----------------------------------------- подготовка объекта "Автодействие маршрута" #47
procedure PrepAutoMarshrut(AvtoM : Integer);
var
  {$IFDEF RMDSP} i,j,AvtoS,Signal,Xstr,Str,q,{$ENDIF}
  VBuf : integer;
begin
  with ObjZv[AvtoM] do
  begin
    bP[31] := true; bP[32] := false; //---------------------- Активизация и непарафазность
    VBuf := VBufInd;

    //------------ если существует релейное автодействие, состояние релейного автодействия
    if ObCI[2] >0 then bP[2] := GetFR3(ObCI[2],bP[32],bP[31])
    else bP[2] := false;


    if VBuf > 0 then
    begin
      OVBuffer[VBuf].Param[16] := bP[31]; //----------------------------- видео активность
      OVBuffer[VBuf].Param[2] := bP[1]; //-------------- показать программное автодействие

      //------------------ если АРМ-автодействие отключено, показать релейное автодействие
      if not bP[1] and bP[31] and not bP[32] then OVBuffer[VBuf].Param[3] := bP[2];
    end;

{$IFDEF RMDSP}
    if ObCB[1] then  //------------------------- если это объект четного автодействия
    begin //-------------------- если задано четное АРМ-автодействие и не удалось включить
      if CHAS and not bP[1] then begin if not AutoMarsh(AvtoM,true) then CHAS:= false; end
      else if bP[1] and not CHAS then AutoMarsh(AvtoM,false);
    end else //--------------------------------------------- объект нечетного автодействия
    begin
      if NAS and not bP[1] then  begin if not AutoMarsh(AvtoM,true) then NAS := false; end
      else  if bP[1] and not NAS then  AutoMarsh(AvtoM,false);
    end;

    if not bP[1] then exit;

    if not(WorkMode.OU[0] and WorkMode.OU[Group]) then
    begin //----------------- сброс автодействия при  потере признаков управления с РМ-ДСП
      bP[1] := false;   NAS := false;  CHAS := false;
      for q := 10 to 12 do
      if ObCI[q] > 0 then
      begin
        AvtoS:=ObCI[q]; ObjZv[AvtoS].bP[1]:=false; AutoMarshOFF(AvtoS,ObCB[1]);
      end;
    end else

    //----------------------- проверить условия поддержки режима программного автодействия
    for i := 10 to 12 do //------------ пройти по описаниям входящих сигналов автодействия
    begin
      AvtoS := ObCI[i];
      if AvtoS > 0 then
      begin //---------------------------------- просмотреть стартовый сигнал автодействия
        Signal := ObjZv[AvtoS].BasOb;
        if ObjZv[Signal].bP[23] then //--------------------- если этот сигнал был перекрыт
        begin
          AddFixMes(GetSmsg(1,430,Liter,0),4,3);//------  "Отключено автодействие"
          bP[1] := false;   //------------ снять признак включенного автодействия маршрута

          for q := 10 to 12 do //---------------- пройти по входящим сигналам автодействия
          if ObCI[q] > 0 then
          begin
            AvtoS := ObCI[q]; ObjZv[AvtoS].bP[1] := false;//откл.автодействие сигнала
            AutoMarshOFF(AvtoS,ObCB[1]); //---------------- отключить четное/нечетное
          end;
          exit;
        end;

        for j := 1 to 10 do //--------- проход по всем стрелкам элементарного автодейсвтия
        begin
          Str := ObjZv[AvtoS].ObCI[j];
          if Str > 0 then
          begin
            Xstr :=  ObjZv[Str].BasOb;
            if ObjZv[Xstr].bP[26] or ObjZv[Xstr].bP[32] then
            begin //-------- если зафиксирована потеря контроля стрелки или непарафазность
              AddFixMes(GetSmsg(1,430,Liter,0),4,3);//-------------- "Откл.автод."
              bP[1] := false;
              for q := 10 to 12 do
              if ObCI[q] > 0 then
              begin
                AvtoS := ObCI[q]; ObjZv[AvtoS].bP[1] := false;
                AutoMarshOFF(AvtoS,ObCB[1]);
              end;
              exit;
            end;
          end;
        end;
      end;
    end;
{$ENDIF}
  end;
end;

//========================================================================================
//------------------------------------------------------------- подготовка объекта РПО #48
procedure PrepRPO(Ptr : Integer);
begin
//  if ObjZv[Ptr].BasOb > 0 then
//  begin
//
//  end;
end;

//========================================================================================
//------------------------------------------------------------ подготовка объекта АБТЦ #49
procedure PrepABTC(ABTC : Integer);
var
  gpo,ak,kl,pkl,rkl : boolean;
begin
  with ObjZv[ABTC] do
  begin
    bP[31]:= true; //--------------------------------------------------------- Активизация
    bP[32]:= false; //----------------------------------------------------- Непарафазность
    gpo   := GetFR3(ObCI[1],bP[32],bP[31]); //---------------------------------------- ГПо
    bP[2] := GetFR3(ObCI[2],bP[32],bP[31]);//----------------------------------------- озП
    bP[3] := GetFR3(ObCI[3],bP[32],bP[31]);//-----------------------------------------  УУ
    ak    := GetFR3(ObCI[4],bP[32],bP[31]);//------------------------------------------ АК
    kl    := GetFR3(ObCI[5],bP[32],bP[31]);//------------------------------------------ КЛ
    pkl   := GetFR3(ObCI[6],bP[32],bP[31]); //---------------------------------------- ПКЛ
    rkl   := GetFR3(ObCI[7],bP[32],bP[31]); //---------------------------------------- РКЛ

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];  OVBuffer[VBufInd].Param[1] := bP[32];

      if (gpo <> bP[1]) and gpo then
      begin //--------------------------------------------------- неисправность светофоров
        if WorkMode.FixedMsg then
        begin
          {$IFDEF RMDSP}
          if config.ru = RU then
          begin InsNewMsg(ABTC,488+$1000,0,''); AddFixMes(GetSmsg(1,488,Liter,0),4,4); end;
          {$ELSE}  InsNewMsg(ABTC,488+$1000,0,''); {$ENDIF}
        end;
        bP[1] := gpo;

        if (ak <> bP[4]) and ak then
        begin //------------------------------------------------ неисправность кодирования
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,489+$1000,0,''); AddFixMes(GetSmsg(1,489,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,489+$1000,0,'');   {$ENDIF}
          end;
        end;
        bP[4] := ak;

        if (kl <> bP[5]) and kl then
        begin //------------------------------------------------------ неисправность линии
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,490+$1000,0,''); AddFixMes(GetSmsg(1,490,Liter,0),4,4); end;
            {$ELSE} InsNewMsg(ABTC,490+$1000,0,''); {$ENDIF}
          end;
        end;
        bP[5] := kl;

        if (pkl <> bP[6]) and pkl then
        begin //-------------------------------------- неисправность линии питающих концов
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,491+$1000,0,'');AddFixMes(GetSmsg(1,491,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,491+$1000,0,''); {$ENDIF}
          end;
        end;
        bP[6] := pkl;

        if (rkl <> bP[7]) and rkl then
        begin //---------------------------------------- неисправность линии питающих концов
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,492+$1000,0,''); AddFixMes(GetSmsg(1,492,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,492+$1000,0,'');  {$ENDIF}
          end;
        end;
        bP[7] := rkl;

        OVBuffer[VBufInd].Param[2] := bP[1]; //--------------------------------------- ГПо
        OVBuffer[VBufInd].Param[3] := bP[2]; //--------------------------------------- озП
        OVBuffer[VBufInd].Param[4] := bP[3]; //---------------------------------------- УУ
        OVBuffer[VBufInd].Param[5] := bP[4]; //---------------------------------------- АК
        OVBuffer[VBufInd].Param[6] := bP[5]; //---------------------------------------- КЛ
        OVBuffer[VBufInd].Param[7] := bP[6]; //--------------------------------------- ПКЛ
        OVBuffer[VBufInd].Param[8] := bP[7]; //--------------------------------------- РКЛ
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------------- подготовка объекта контроля сигнальных точек #50
procedure PrepDCSU(Ptr : Integer);
var
  activ,nepar : boolean;
begin
  activ := true; //----------------------------------------------------------- Активизация
  nepar := false; //------------------------------------------------------- Непарафазность

  ObjZv[Ptr].bP[1] := GetFR3(ObjZv[Ptr].ObCI[1], nepar,activ); //---------- 1ПЖ
  ObjZv[Ptr].bP[2] := GetFR3(ObjZv[Ptr].ObCI[2], nepar,activ); //---------- 1оЖ

  ObjZv[Ptr].bP[3] := GetFR3(ObjZv[Ptr].ObCI[3], nepar,activ); //---------- 2ПЖ
  ObjZv[Ptr].bP[4] := GetFR3(ObjZv[Ptr].ObCI[4], nepar,activ); //---------- 2оЖ

  ObjZv[Ptr].bP[5] := GetFR3(ObjZv[Ptr].ObCI[5], nepar,activ); //---------- 3ПЖ
  ObjZv[Ptr].bP[6] := GetFR3(ObjZv[Ptr].ObCI[6],nepar,activ); //----------- 3оЖ

  ObjZv[Ptr].bP[7] := GetFR3(ObjZv[Ptr].ObCI[7],nepar,activ); //----------- 4ПЖ
  ObjZv[Ptr].bP[8] := GetFR3(ObjZv[Ptr].ObCI[8],nepar,activ); //----------- 4оЖ

  ObjZv[Ptr].bP[9] := GetFR3(ObjZv[Ptr].ObCI[9],nepar,activ); //----------- 5ПЖ
  ObjZv[Ptr].bP[10] := GetFR3(ObjZv[Ptr].ObCI[10],nepar,activ);//---------- 5оЖ

  ObjZv[Ptr].bP[11] := GetFR3(ObjZv[Ptr].ObCI[11],nepar,activ);//---------- 6ПЖ
  ObjZv[Ptr].bP[12] := GetFR3(ObjZv[Ptr].ObCI[12],nepar,activ);//---------- 6оЖ

  ObjZv[Ptr].bP[13] := GetFR3(ObjZv[Ptr].ObCI[13],nepar,activ);//---------- 7ПЖ
  ObjZv[Ptr].bP[14] := GetFR3(ObjZv[Ptr].ObCI[14],nepar,activ);//---------- 7оЖ

  ObjZv[Ptr].bP[15] := GetFR3(ObjZv[Ptr].ObCI[15],nepar,activ);//---------- 8ПЖ
  ObjZv[Ptr].bP[16] := GetFR3(ObjZv[Ptr].ObCI[16],nepar,activ);//---------- 8оЖ

  ObjZv[Ptr].bP[31]:= activ;
  ObjZv[Ptr].bP[32]:= nepar;

  //-------------------------------------------------------- заглянуть в смену направления
  if ObjZv[Ptr].BasOb > 0 then
  begin
    if ObjZv[ObjZv[Ptr].BasOb].bP[31] and  //------------ если СН активна и ...
    not ObjZv[ObjZv[Ptr].BasOb].bP[32] then //----------------------- парафазна
    begin
      ObjZv[Ptr].bP[17] := not ObjZv[ObjZv[Ptr].BasOb].bP[4];//----- прием
      ObjZv[Ptr].bP[18] := ObjZv[ObjZv[Ptr].BasOb].bP[4];    //-- передача
    end else
    begin //------------ -------------- иначе неизвестно состояние направления на перегоне
      ObjZv[Ptr].bP[17] := false;
      ObjZv[Ptr].bP[18] := false;
    end;
  end;

  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];

    OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1]; //---------- 1ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := ObjZv[Ptr].bP[2]; //---------- 1оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := ObjZv[Ptr].bP[3]; //---------- 2ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[5] := ObjZv[Ptr].bP[4]; //---------- 2оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[6] := ObjZv[Ptr].bP[5]; //---------- 3ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[7] := ObjZv[Ptr].bP[6]; //---------- 3оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[8] := ObjZv[Ptr].bP[7]; //---------- 4ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[9] := ObjZv[Ptr].bP[8]; //---------- 4оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[10] := ObjZv[Ptr].bP[9]; //--------- 5ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[11] := ObjZv[Ptr].bP[10]; //-------- 5оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[12] := ObjZv[Ptr].bP[11]; //-------- 6ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[13] := ObjZv[Ptr].bP[12]; //-------- 6оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[14] := ObjZv[Ptr].bP[13]; //-------- 7ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[15] := ObjZv[Ptr].bP[14]; //-------- 7оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[17] := ObjZv[Ptr].bP[15]; //-------- 8ПЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[18] := ObjZv[Ptr].bP[16]; //-------- 8оЖ
    OVBuffer[ObjZv[Ptr].VBufInd].Param[19] := ObjZv[Ptr].bP[17]; //------ прием
    OVBuffer[ObjZv[Ptr].VBufInd].Param[20] := ObjZv[Ptr].bP[18]; // отправление
  end;
end;

//========================================================================================
//----------------------------------------------------- Сборка дополнительных датчиков #51
procedure PrepDopDat(Ptr : Integer);
var
  Vid_Buf, i: Integer;
begin
  ObjZv[Ptr].bP[31] := true; ObjZv[Ptr].bP[32] := false;
  for i := 1 to 34 do ObjZv[Ptr].NParam[i] := false;

  for i := 1 to 10 do
  begin
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      ObjZv[Ptr].bP[i] :=
      GetFR3(ObjZv[Ptr].ObCI[i],ObjZv[Ptr].NParam[i],ObjZv[Ptr].bP[31]);
    end;
    if ObjZv[Ptr].ObCI[10+i] > 0 then //--- если предусмотрено сообщение на включение
    begin
      if ObjZv[Ptr].bP[i] then //------------------------------------------ есть включение
      begin
        if not ObjZv[Ptr].bP[i+10] then //------------------------------ не было сообщения
        begin
          ObjZv[Ptr].bP[i+10] := true; ObjZv[Ptr].bP[i+20] := false;

          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[Ptr].RU then
            begin
              InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+10],0,'');
              AddFixMes(MsgList[ObjZv[Ptr].ObCI[i+10]],4,3);
            end;
{$ELSE}
            InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+10],0,'');
            SBeep[3] := true;
{$ENDIF}
          end;
        end;
      end;
      if not ObjZv[Ptr].bP[i] then ObjZv[Ptr].bP[i+10] := false; //------- есть отключение
    end;


    if ObjZv[Ptr].ObCI[20+i] > 0 then //-- если предусмотрено сообщение на отключение
    begin
      if not ObjZv[Ptr].bP[i] then //------------------------------------- есть отключение
      begin
        if not ObjZv[Ptr].bP[i+20] then //------------------------------ не было сообщения
        begin
          ObjZv[Ptr].bP[i+20] := true;  ObjZv[Ptr].bP[i+10] := false;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[Ptr].RU then
            begin
              InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+20],0,'');
              AddFixMes(MsgList[ObjZv[Ptr].ObCI[i+20]],4,3);
            end;
{$ELSE}
            InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+20],0,'');
            SBeep[3] := true;
{$ENDIF}
          end;
        end;
      end;
      if ObjZv[Ptr].bP[i] then ObjZv[Ptr].bP[i+20] := false;//------------- есть включение
      
    end;
  end;
  Vid_Buf := ObjZv[Ptr].VBufInd;

  if Vid_Buf > 0 then
  begin
    OVBuffer[Vid_Buf].Param[16] := ObjZv[Ptr].bP[31];
    for i := 1 to 10 do
    begin
      OVBuffer[Vid_Buf].Param[i] := ObjZv[Ptr].bP[i];
      OVBuffer[Vid_Buf].NParam[i] := ObjZv[Ptr].NParam[i];
    end;
  end;
end;

//========================================================================================
//------------------------ Объект трассировки МУС для светофора по пошерстным стрелкам #52
procedure PrepSVMUS(MUS : Integer);
var
  MNK,Sos,Pin,j : integer;
begin
  ObjZv[MUS].bP[1] := false;
  MNK := ObjZv[MUS].BasOb;
  if MNK > 0 then
  begin
    if not ObjZv[MNK].bP[3] and ObjZv[MNK].bP[1]
    and ObjZv[MNK].bP[4] and ObjZv[MNK].bP[5] then
    begin //-------------------------------------------- замкнуты маневры, есть РМ, Д, В
      //---------------------- проверить ПШ стрелки для выезда на объект сборки трассы МУС
      if ObjZv[MUS].ObCB[1] then Pin := 2 else Pin := 1;

      Sos := ObjZv[MUS].Sosed[Pin].Obj; Pin := ObjZv[MUS].Sosed[Pin].Pin;

      j := 50;
      while j > 0 do
      begin
        case ObjZv[Sos].TypeObj of
          2 :
          begin //---------------------------------------------------------------- стрелка
            case Pin of
              2 : if not ObjZv[ObjZv[Sos].BasOb].bP[1] then break;
              3 : if not ObjZv[ObjZv[Sos].BasOb].bP[2] then break;
              else   break;
            end;
            Pin := ObjZv[Sos].Sosed[1].Pin;
            Sos := ObjZv[Sos].Sosed[1].Obj;
          end;

          53 : //------------------------------------------------------------------- ТРМУС
          begin
            if (ObjZv[MUS].UpdOb = Sos) and (MNK = ObjZv[Sos].BasOb)
            then  begin  ObjZv[MUS].bP[1] := true;  break; end else
            if Pin = 1
            then begin Pin := ObjZv[Sos].Sosed[2].Pin; Sos := ObjZv[Sos].Sosed[2].Obj; end
            else begin Pin:=ObjZv[Sos].Sosed[1].Pin; Sos:=ObjZv[Sos].Sosed[1].Obj;end;
          end;

          else
            if Pin = 1 then
            begin Pin := ObjZv[Sos].Sosed[2].Pin; Sos := ObjZv[Sos].Sosed[2].Obj; end
            else begin Pin:=ObjZv[Sos].Sosed[1].Pin; Sos := ObjZv[Sos].Sosed[1].Obj; end;
        end;
        if (Sos = 0) or (Pin < 1) then break;
        dec(j);
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------- Подготовка объекта сигнальной точки для детской ЖД #54
procedure PrepST(SiT: Integer);
var
  Og : boolean;
begin
  ObjZv[SiT].bP[31] := true; //----------------------------------------------- Активизация
  ObjZv[SiT].bP[32] := false; //------------------------------------------- Непарафазность

  ObjZv[SiT].bP[2] :=
  GetFR3(ObjZv[SiT].ObCI[1],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]); //-------------- Д1

  ObjZv[SiT].bP[3] :=
  GetFR3(ObjZv[SiT].ObCI[2],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]); //-------------- Д2

  Og := GetFR3(ObjZv[SiT].ObCI[3],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]);//--------- оГ

  if Og <> ObjZv[SiT].bP[4] then
  begin //------------------------------------------------ огневое реле изменило состояние
    if Og then
    begin //-------------------------------------------- неисправность огневушки появилась
      if WorkMode.FixedMsg then
      begin
{$IFDEF RMDSP}
        if config.ru = ObjZv[SiT].RU then
        begin
          InsNewMsg(SiT,272+$1000,0,''); //------- Неисправна нить лампы запрещающего огня
          AddFixMes(GetSmsg(1,272, ObjZv[SiT].Liter,0),4,4);
          SBeep[4] := true;
          ObjZv[SiT].bP[4] := Og;
          ObjZv[SiT].dtP[1] := LastTime;
          inc(ObjZv[SiT].siP[1]);
        end;
{$ELSE}
          InsNewMsg(Sit,272+$1000,0,'');
          SBeep[3] := true;
{$ENDIF}
      end;
      ObjZv[SiT].bP[20] := false; //----------------------- сброс восприятия неисправности
    end
    else ObjZv[SiT].bP[4] := Og;
  end;
  if ObjZv[SiT].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[SiT].VBufInd].Param[16] := ObjZv[SiT].bP[31]; //------- Активность
    OVBuffer[ObjZv[SiT].VBufInd].Param[1] := ObjZv[SiT].bP[32]; //---- Непарафазность
    if ObjZv[SiT].bP[31] and not ObjZv[SiT].bP[32] then
    begin
      OVBuffer[ObjZv[SiT].VBufInd].Param[2] := ObjZv[SiT].bP[2];//---------------- Д1
      OVBuffer[ObjZv[SiT].VBufInd].Param[3] := ObjZv[SiT].bP[3];//---------------- Д2
      OVBuffer[ObjZv[SiT].VBufInd].Param[4] := ObjZv[SiT].bP[4];//---------------- оГ
    end;
  end;
end;

//========================================================================================
//------------------------------------------ процедура подготовки дополнения к сигналу #55
procedure PrepDopSvet(SvtDop : Integer);
var
  Signal : integer; //--------------- индекс объекта зависимостей соответствующего сигнала
  VBUF : integer; //---------------------- номер видеобуфера для соостветствующего сигнала
  ij, GM, LS, Zs2, JMS, VKMG, PrS, EN : integer;
  Act, Nepar : boolean;
begin
  for ij:=1 to 6 do ObjZv[SvtDop].bP[ij] := false;

  GM   := ObjZv[SvtDop].ObCI[1];
  LS   := ObjZv[SvtDop].ObCI[2];
  Zs2  := ObjZv[SvtDop].ObCI[3];
  JMS  := ObjZv[SvtDop].ObCI[4];
  VKMG := ObjZv[SvtDop].ObCI[5];
  PrS  := ObjZv[SvtDop].ObCI[6];
  EN   := ObjZv[SvtDop].ObCI[10];

  Signal := ObjZv[SvtDop].BasOb;
  VBUF   := ObjZv[Signal].VBufInd;

  Act := true; //------------------------------------------------------------- Активизация
  Nepar := false; //------------------------------------------------------- Непарафазность

  if GM  <>  0 then ObjZv[SvtDop].bP[1]:=  GetFR3(GM, Nepar,Act); //------------------- ГМ
  if LS  <>  0 then ObjZv[SvtDop].bP[2] := GetFR3(LS,Nepar,Act);  //------------------- ЛС
  if Zs2 <>  0 then ObjZv[SvtDop].bP[3] := GetFR3(Zs2,Nepar,Act); //------------------ 2зС
  if JMS <>  0 then ObjZv[SvtDop].bP[4] := GetFR3(JMS,Nepar,Act); //------------------ ЖМС
  if VKMG <> 0 then ObjZv[SvtDop].bP[5] := GetFR3(VKMG,Nepar,Act);//----------------- вкмг
  if PrS  <> 0 then ObjZv[SvtDop].bP[6] := GetFR3(PrS,Nepar,Act); //------------------- ПС
  if EN   <> 0 then ObjZv[SvtDop].bP[10]:= GetFR3(EN,Nepar,Act);  //------------------- ЕН

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[20] := ObjZv[SvtDop].bP[1]; //-------------------------------- ГМ
    OVBuffer[VBUF].Param[22] := ObjZv[SvtDop].bP[2]; //---------------------------- ЛС(зС)
    OVBuffer[VBUF].Param[21] := ObjZv[SvtDop].bP[3]; //------------------------------- 2зС
    OVBuffer[VBUF].Param[23] := ObjZv[SvtDop].bP[4]; //------------------------------- ЖМС
    OVBuffer[VBUF].Param[24] := ObjZv[SvtDop].bP[5]; //-------------------------------вкмг
    OVBuffer[VBUF].Param[25] := ObjZv[SvtDop].bP[6]; //-------------------------------- пс
    OVBuffer[VBUF].Param[28] := ObjZv[SvtDop].bP[10]; //------------------------------- ЕН
  end;

  ObjZv[SvtDop].bP[31] := Act;   //------------------------------------------- Активизация
  ObjZv[SvtDop].bP[32] := Nepar; //---------------------------------------- Непарафазность

end;

//========================================================================================
//----------------------------------------- Подготовка объекта УКГ для вывода на табло #56
procedure PrepUKG(UKG : Integer);
var
  vkgd,vkgd1,kg,okg : boolean;
  ob_vkgd,ob_vkgd1, kod,i : integer;
  TXT1 : string;
begin
  kod := 0;
  ObjZv[UKG].bP[31] := true; //----------------------------------------------- Активизация
  ObjZv[UKG].bP[32] := false; //------------------------------------------- Непарафазность

  for i := 1 to 32 do ObjZv[UKG].NParam[i] := false;
  ob_vkgd := ObjZv[UKG].ObCI[4];
  ob_vkgd1 := ObjZv[UKG].ObCI[5];

  kg    := GetFR3(ObjZv[UKG].ObCI[2],ObjZv[UKG].NParam[2],ObjZv[UKG].bP[31]); //- УКГ
  okg   := GetFR3(ObjZv[UKG].ObCI[3],ObjZv[UKG].NParam[3],ObjZv[UKG].bP[31]); //- оКГ
  vkgd  := GetFR3(ob_vkgd,ObjZv[UKG].NParam[4],ObjZv[UKG].bP[31]);//----------------- ВКГД
  vkgd1 := GetFR3(ob_vkgd1,ObjZv[UKG].NParam[5],ObjZv[UKG].bP[31]);//--------------- ВКГД1

  if ObjZv[UKG].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[UKG].VBufInd].Param[16] := ObjZv[UKG].bP[31];
    OVBuffer[ObjZv[UKG].VBufInd].Param[1] := ObjZv[UKG].NParam[2] or
    ObjZv[UKG].NParam[3] or  ObjZv[UKG].NParam[4] or  ObjZv[UKG].NParam[5];

    if ObjZv[UKG].bP[31] and not ObjZv[UKG].bP[32] then
    begin
      if kg then  kod := kod + 1;
      if okg then kod := kod + 2;
      if vkgd then kod := kod + 4;
      if vkgd1 then kod := kod + 8;

      ObjZv[UKG].bP[1] := kg;
      OVBuffer[ObjZv[UKG].VBufInd].Param[2] := KG;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[2] := ObjZv[UKG].NParam[2];

      ObjZv[UKG].bP[3] := vkgd;
      OVBuffer[ObjZv[UKG].VBufInd].Param[4] := vkgd;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[4] := ObjZv[UKG].NParam[4];

      ObjZv[UKG].bP[4] := vkgd1;
      OVBuffer[ObjZv[UKG].VBufInd].Param[5] := vkgd1;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[5] := ObjZv[UKG].NParam[5];

      ObjZv[UKG].bP[2] := okg;
      OVBuffer[ObjZv[UKG].VBufInd].Param[3] := okg;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[3] := ObjZv[UKG].NParam[3];

      if kod <> ObjZv[UKG].iP[1] then   //--------------------- изменился код состяния УКГ
      begin
        if not ObjZv[UKG].T[1].Activ  then //---------------------- если таймер не активен
        begin
          ObjZv[UKG].T[1].Activ  := true; //------------------------ активизировать таймер
          ObjZv[UKG].T[1].F := LastTime + 2 / 86400; //-------- заряд ожидания на 2сек
        end;
      end;

      if ObjZv[UKG].T[1].Activ  and //-------------------------- если таймер активен и ...
      (LastTime > ObjZv[UKG].T[1].F) then //------------------- истекло время ожидания
      begin
{$IFDEF RMDSP}
        if WorkMode.FixedMsg and (config.ru = ObjZv[UKG].RU) then
        case kod of
          4,8,12:  //---------------------------------------------- исправно, но отключено
          begin
            InsNewMsg(UKG,554+$1000,0,''); //--------------------- необходимо включить УКГ
            TXT1 := GetSmsg(1,554,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,2);
            PutSMsg(7,LastX,LastY,TXT1);
            SBeep[2] := WorkMode.Upravlenie;
          end;

          1,5,9,13://--------------------------------------------- неисправное отключенное
          begin
            InsNewMsg(UKG,553+$1000,0,''); //------------------------------- УКГ отключено
            TXT1 := GetSmsg(1,553,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,2);
            PutSMsg(7,LastX,LastY,TXT1);
          end;

          0://---------------------------------------- исправное состояние включенного УКГ
          begin
            InsNewMsg(UKG,557+$1000,0,''); //-------------------- УКГ возвращен в исходное
            TXT1 := GetSmsg(1,557,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,0,2);
            PutSMsg(2,LastX,LastY,TXT1);
            SBeep[2] := WorkMode.Upravlenie;
          end;

          3: //----------------------------------------------- сработали датчики КГ1 и ОКГ
          begin
            InsNewMsg(UKG,552+$1000,0,''); //------------------------- Сработал датчик УКГ
            TXT1:= GetSmsg(1,552,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,3);
            PutSMsg(1,LastX,LastY,TXT1);
          end;

          else
          begin
            InsNewMsg(UKG,550+$1000,0,''); //------------------ неправильно работает схема
            TXT1 := GetSmsg(1,550,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,3);
            PutSMsg(11,LastX,LastY,TXT1);
          end;
        end;

{$ELSE}
        case kod of
          4,8,12:  //---------------------------------------------- исправно, но отключено
          begin   InsNewMsg(UKG,554+$1000,0,''); SBeep[3] := true; end;
          5,9,13:  //------------------------ Устройство контроля габаритов(УКГ) отключено
          begin  InsNewMsg(UKG,553+$1000,0,'');  SBeep[3] := true; end;

          0: //------------- исправное состояние включенного УКГ, УКГ возвращен в исходное
          begin InsNewMsg(UKG,557+$1000,0,''); SBeep[3] := true; end;

          3: //--------------------------------- Внимание! Зафиксировано срабатывание КГУ!
          begin InsNewMsg(UKG,552+$1000,0,''); SBeep[3] := true; end;

          else //---------------------------------------------- неправильно работает схема
          begin InsNewMsg(UKG,550+$1000,0,''); SBeep[3] := true; end;
        end;
{$ENDIF}
        ObjZv[UKG].T[1].Activ  := false;
        ObjZv[UKG].T[1].F := 0;
      end;

      ObjZv[UKG].iP[1] := kod;
    end;
  end;
end;

//========================================================================================
//----------------------------------------- Подготовка объекта РДШ для вывода на табло #60
procedure PrepRDSH(RDSH : Integer);
var
  i,rele,Vbufer : integer;
  TXT1 : string;
begin
    ObjZv[RDSH].bP[31] := true; //-------------------------------------------- Активизация
    ObjZv[RDSH].bP[32] := false; //---------------------------------------- Непарафазность

    for i := 1 to 32 do ObjZv[RDSH].NParam[i] := false;

    for i := 1 to 24 do
    begin
      rele := ObjZv[RDSH].ObCI[i];
      if rele > 0 then
      ObjZv[RDSH].bP[i] :=
      GetFR3(rele+2,ObjZv[RDSH].NParam[i],ObjZv[RDSH].bP[31]) or
      GetFR3(rele+3,ObjZv[RDSH].NParam[i],ObjZv[RDSH].bP[31]);
    end;

    if ObjZv[RDSH].VBufInd > 0 then
    begin
      Vbufer := ObjZv[RDSH].VBufInd;
      OVBuffer[VBufer].Param[1] := false;
      OVBuffer[VBufer].NParam[1] := false;
      OVBuffer[VBufer].Param[16] := ObjZv[RDSH].bP[31];

      for i := 1 to 24 do
      begin
        OVBuffer[VBufer].Param[1] :=  OVBuffer[VBufer].Param[1] or ObjZv[RDSH].bP[i];
        if ObjZv[RDSH].bP[i] then break;
        OVBuffer[VBufer].NParam[1] := OVBuffer[VBufer].NParam[1] or ObjZv[RDSH].NParam[i];
      end;

      if i <= 24 then
      begin
        rele := ObjZv[RDSH].ObCI[i];  TXT1 := LinkFr[rele].Name;
      end;

      if not OVBuffer[VBufer].Param[1] then ObjZv[RDSH].T[1].F := 0;
{$IFDEF RMDSP}
      if WorkMode.FixedMsg and (config.ru = ObjZv[RDSH].RU)
      and OVBuffer[VBufer].Param[1] and (ObjZv[RDSH].T[1].F = 0) then
      begin
        InsNewMsg(rele{RDSH},581 + $1000,0,TXT1); //---- неисправность релейного дешифратора УВК
        TXT1 := GetSmsg(1,581,TXT1,0);
        AddFixMes(TXT1,4,2);
        PutSMsg(7,LastX,LastY,TXT1);
        ObjZv[RDSH].T[1].F := LastTime;
        SBeep[2] := WorkMode.Upravlenie;
      end;
{$ELSE}
      if OVBuffer[ObjZv[RDSH].VBufInd].Param[1] and (ObjZv[RDSH].T[1].F = 0) then
      begin
       InsNewMsg(RDSH,581+$1000,0,TXT1);
       ObjZv[RDSH].T[1].F := LastTime;
       SBeep[3] := true;
      end;
{$ENDIF}
    end;
end;

//========================================================================================
//--------------------------------------------------- подготовка для объекта День/Ночь #92
procedure PrepDN(Ptr : Integer);
var
  dnk,nnk,auk,dn : boolean;
  dnk_kod,nnk_kod,auk_kod,dn_kod,AllKod : integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- Активизация
    ObjZv[Ptr].bP[32] := false; //------------------------------------ Непарафазность

    //--------------------- Читаем значение датчика кнопки "День"
    dnk := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);
    if dnk then dnk_kod := 1
    else dnk_kod :=0;

    //--------------------- Читаем значение датчика кнопки "Ночь"
    nnk := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].Nparam[2],ObjZv[Ptr].bP[31]);
    if nnk then nnk_kod := 1
    else nnk_kod :=0;

    //------------------ Читаем значение датчика кнопки "Автомат"
    auk := GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);
    if auk then auk_kod := 1
    else auk_kod :=0;

    //----------------------- Читаем значение датчика "День/Ночь"
    dn := GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);
    if dn then dn_kod := 1
    else dn_kod :=0;
    AllKod := dnk_kod*8 + nnk_kod*4 + auk_kod*2 + dn_kod;

    if (ObjZv[Ptr].iP[1] <> AllKod) then //если изменилось состояние любого датчика
    begin
      ObjZv[ptr].iP[1] := AllKod;
      ObjZv[Ptr].dtP[1] := LastTime;
      case AllKod of
        //-------------------------------------------------------------------------------
        2: //--------------------------------------------------- дневной режим в автомате
        begin // нажата кнопка "автомат"
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,362+$1000,0,''); //--------------------------- включен автомат
              AddFixMes(GetSmsg(1,362, ObjZv[ptr].Liter,0),4,4);
              InsNewMsg(Ptr,360+$1000,0,''); //------------------------------ включен день
              AddFixMes(GetSmsg(1,360, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
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
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,362+$1000,0,''); //--------------------------- включен автомат
              AddFixMes(GetSmsg(1,362, ObjZv[ptr].Liter,0),4,4);
              InsNewMsg(Ptr,361+$1000,0,''); //----------------------------- включена ночь
              AddFixMes(GetSmsg(1,361, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
            end;
          {$ENDIF}
          end;
         end;

         4,6,7,9..15: //------------------------ ненормы схемы переключения
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,516+$1000,0,'');
              AddFixMes(GetSmsg(1,516, ObjZv[ptr].Liter,0),4,4);
              ObjZv[Ptr].dtP[1] := LastTime;
              inc(ObjZv[Ptr].siP[1]);
            end;
            {$ENDIF}
          end;
         end;
         5: //------------------------------------------------------- ночь в ручном режиме
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,361+$1000,0,'');
              AddFixMes(GetSmsg(1,361, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
            end;
          {$ENDIF}
          end;
         end;
         8: //------------------------------------------------------- день в ручном режиме
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,360+$1000,0,'');
              AddFixMes(GetSmsg(1,360, ObjZv[ptr].Liter,0),4,4);
              ObjZv[Ptr].dtP[1] := LastTime;
              inc(ObjZv[Ptr].siP[1]);
            end;
            {$ENDIF}
          end;
         end;
      end;
    end;
    ObjZv[Ptr].bP[1] := dnk;
    ObjZv[Ptr].bP[2] := nnk;
    ObjZv[Ptr].bP[3] := auk;
    ObjZv[Ptr].bP[4] := dn;

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31]; //Активность
      if ObjZv[Ptr].bP[31] then
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[1];//кнопка "день"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[1] := ObjZv[Ptr].NParam[1];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[2];//кнопка "ночь"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[2] := ObjZv[Ptr].NParam[2];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := ObjZv[Ptr].bP[3];//кнопка "авто"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[3] := ObjZv[Ptr].NParam[3];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := ObjZv[Ptr].bP[4];//- датчик "ДН"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[4] := ObjZv[Ptr].NParam[4];

        OVBuffer[ObjZv[Ptr].VBufInd].DZ3 := AllKod;
      end;
    end;
end;
end.
