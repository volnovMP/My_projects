unit Objsost;
//*****************************************************************************
//
//    Прорисовка на табло
//
//    версия   1
//    редакция 3
//
//    дата     07 июля 2006г.
//*****************************************************************************

interface

uses
  Forms, Windows, VarStruct, Classes, SysUtils, Math, Graphics, TypeRpc;

procedure DisplayItemTablo(Obj: POVStruct; form: TCanvas);

implementation

uses
  Commons,
  TabloForm;

//------------------------------------------------------------------------------
// Нарисовать элемент табло

var ptr : array[1..28] of TPoint; sLbl : string;

  fix : integer;

procedure DisplayItemTablo(Obj: POVStruct; form: TCanvas);

  function GetPenStyle(param : SmallInt) : TPenStyle;
  begin
    case param of
      1 : result := psDot;
      2 : result := psDash;
      3 : result := psDashDot;
      4 : result := psDashDotDot;
    else
      result := psSolid;
    end;
  end;

  function GetFontStyle(param : SmallInt) : TFontStyles;
  begin
    case param of
      1 : result := [fsBold];
      2 : result := [fsItalic];
      3 : result := [fsUnderline];
      4 : result := [fsStrikeOut];
    else
      result := [];
    end;
  end;

  function GetBrushStyle(param : SmallInt) : TBrushStyle;
  begin
    case param of
      1 : result := bsClear;
      2 : result := bsBDiagonal;
      3 : result := bsFDiagonal;
      4 : result := bsCross;
      5 : result := bsDiagCross;
      6 : result := bsHorizontal;
      7 : result := bsVertical;
    else
      result := bsSolid;
    end;
  end;

  // Прорисовка стрелочной секции на табло
  procedure DrawSP(form : TCanvas;         // Указатель на табло
                   buf  : SmallInt;        // Индекс записи в буфере отбражения
                   ptr : array of TPoint); // Перечень точек для построения ломаной

  label dsp1,dsp2;
  begin
  try
    if not Assigned(form) then
    begin
      reportf('Обнаружен неинициализированный указатель при вызове процедуры DrawSP'); Application.Terminate; exit;
    end;
    form.Brush.Style := bsSolid; form.Brush.Color := bkgndcolor;
    if not OVBuffer[buf].Param[16] then // нецентрализованное состояние
    begin
      form.Pen.Color := armcolor12; form.Pen.Width := 3; form.Pen.Style := psSolid;
      goto dsp1;
    end;
    if OVBuffer[buf].Param[1] then // непарафазность
    begin
      form.Pen.Color := armcolor14; form.Pen.Width := 3; form.Pen.Style := psSolid;
      goto dsp1;
    end;

    if OVBuffer[buf].Param[2] then // Есть РМ
    begin
      if WorkMode.Podsvet then goto dsp2; // Есть подсветка - Показать состояние датчиков секции
      if OVBuffer[buf].Param[3] then
      begin
      // нет МИ
        form.Pen.Color := armcolor13; form.Pen.Width := 1; form.Pen.Style := psSolid;
      end else
      begin
      // есть МИ
        form.Pen.Color := armcolor13; form.Pen.Width := 3; form.Pen.Style := psSolid;
      end;
      goto dsp1;
    end;

    if WorkMode.Podsvet then // Подсветка стрелок/ района местного управления
    begin
      if not OVBuffer[buf].Param[4] then goto dsp2; // Есть СП - Показать состояние датчиков секции
      if not OVBuffer[buf].Param[5] then goto dsp2; // Есть з  - Показать состояние датчиков секции
      if OVBuffer[buf].Param[7] then goto dsp2; // Есть РИ - Показать состояние датчиков секции
      if OVBuffer[buf].Param[10] then // Подсветка стрелок/ района местного управления
      begin // Подсветка положения стрелок
        form.Pen.Color := armcolor6; form.Pen.Width := 3; form.Pen.Style := psSolid;
        goto dsp1;
      end;
    end;

    // Определить состояния датчиков секции
  dsp2:
    if OVBuffer[buf].Param[4] then // СП свободен
    begin
      if OVBuffer[buf].Param[5] then // нет замыкания
      begin
        form.Pen.Color := clBlack; form.Pen.Width := 1; form.Pen.Style := psSolid;
      end else
      begin // есть замыкание
        form.Pen.Color := armcolor7; form.Pen.Width := 3; form.Pen.Style := psSolid;
      end;
    end else
    begin // СП занят
      if OVBuffer[buf].Param[5] then // нет замыкания
      begin
        form.Pen.Color := armcolor1; form.Pen.Width := 1; form.Pen.Style := psSolid;
      end else
      begin // есть замыкание
        form.Pen.Color := armcolor1; form.Pen.Width := 3; form.Pen.Style := psSolid;
      end;
    end;

  dsp1: // Нарисовать состояние датчиков секции
    form.Polyline(ptr);

    if OVBuffer[buf].Param[16] and not OVBuffer[buf].Param[1] then // достоверное состояние
    begin
  // Нарисовать признак предварительного замыкания секции (трассировка) и программное замыкание на сервере
      if not OVBuffer[buf].Param[1] and  // нет МИ
         not OVBuffer[buf].Param[2] and  // нет РМ
         not OVBuffer[buf].Param[6] and  // есть предв.замыкание
             OVBuffer[buf].Param[4] and  // нет СП
             OVBuffer[buf].Param[5] and  // нет З
         not OVBuffer[buf].Param[7] then // нет РИ
      begin
        form.Pen.Color := armcolor9; form.Pen.Style := psSolid;
        if OVBuffer[buf].Param[14] then form.Pen.Width := 3 else form.Pen.Width := 1;
        form.Polyline(ptr);
      end;
    end;


    if OVBuffer[buf].Param[16] and // централизованное состояние
       not OVBuffer[buf].Param[1] then // парафазность
    begin
  // Нарисовать признак искусственного размыкания секции
      if not OVBuffer[buf].Param[1] and
             OVBuffer[buf].Param[7] then
      begin
        form.Pen.Style := psDot;
        if OVBuffer[buf].Param[5] then form.Brush.Color := armcolor11 else form.Brush.Color := 0;
        form.Pen.Width := 1;
        form.Polyline(ptr);
      end;
    end;

  except
    reportf('Ошибка [ObjSost.DrawSP]'); Application.Terminate;
  end;
  end;


label str1, prigl;
var x1,y1,x2,y2 : integer; n,p,b1,b2,b3 : Boolean;
begin
try
  if not Assigned(Obj) or not Assigned(form) then
  begin
    reportf('Обнаружен неинициализированный указатель при вызове процедуры DisplayItemTablo'); Application.Terminate; exit;
  end;
  case Obj.TypeObj of

    94: begin
    //********************************
    //
    // нарисовать счетчик нажатий КОК
    //
    //********************************
fix := 94;
      if WorkMode.OKError then form.Brush.Color := armcolor14
      else if WorkMode.PushOK then form.Brush.Color := armcolor1
      else form.Brush.Color := armcolor8;
      form.Pen.Color := 0; form.Pen.Width := 1;
      form.RoundRect(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+22,4,20);
      form.Font.Color := clBlack; form.Font.Size := 10; form.Font.Style := [fsBold];
      x2 := KOKCounter; x1 := x2 div 100000; sLbl := intToStr(x1);
      x2 := x2 - x1 * 100000; x1 := x2 div 10000; sLbl := sLbl + intToStr(x1);
      x2 := x2 - x1 * 10000; x1 := x2 div 1000; sLbl := sLbl + intToStr(x1);
      x2 := x2 - x1 * 1000; x1 := x2 div 100; sLbl := sLbl + intToStr(x1);
      x2 := x2 - x1 * 100; x1 := x2 div 10; sLbl := sLbl + intToStr(x1);
      x2 := x2 - x1 * 10; sLbl := sLbl + intToStr(x2);
      form.TextOut(obj.Points[1].X+5,obj.Points[1].Y+3,'КОК');
      form.Brush.Color := armcolor9; form.Pen.Color := 0;
      form.Rectangle(obj.Points[1].X+40,obj.Points[1].Y+3, obj.Points[1].X+95,obj.Points[1].Y+19);
      form.Brush.Style := bsClear;
      form.TextOut(obj.Points[1].X+44,obj.Points[1].Y+3,sLbl);
    end;

    95: begin
    //************************************
    //
    // нарисовать иконку выключения звонка
    //
    //************************************
fix := 95;
      if sound then x1 := 1 else x1 := 0;
      TabloMain.ImageList32.Draw(form,obj.Points[1].X,obj.Points[1].Y,x1);
    end;


    96: begin
    //********************************
    //
    // нарисовать иконку режима работы
    //
    //********************************
fix := 96;
      if WorkMode.BU[0] or not WorkMode.KRU[0] then
      begin // нет информации о режиме управления
        x1 := 0;
      end else
      if WorkMode.NU[0] then
      begin // непарафазность датчиков состояния режима управления
        x1 := 6;
      end else
      begin // есть информация о состоянии датчиков
        if (StateRU and $40) = $40 then
        begin // установлен режим ОУ
          if WorkMode.OU[0] and not WorkMode.RU[0] then
          begin
            x1 := 2;
          end else
            x1 := 0;
        end else
        if WorkMode.RU[0] and not WorkMode.OU[0] then
        begin // установлен режим РУ
          x1 := 1;
        end else
          x1 := 0;
      end;
      TabloMain.ImageListRU.Draw(form,obj.Points[1].X,obj.Points[1].Y,x1);
      form.Font.Size := 12; form.Font.Style := [fsBold]; form.Font.Color := clBlack;

      // Вывести иконку района управления
      sLbl := obj.Title;
      if obj.ObjConstI[1] = 0 then sLbl := sLbl + ' '+IntToStr(config.ru);
      if WorkMode.RUError then form.Brush.Color := armcolor14 else
      if (DirState[1] and $80) = $80 then
        form.Brush.Color := armcolor5
      else
        form.Brush.Color := armcolor7;
      form.Pen.Color := form.Brush.Color;
      form.Rectangle(obj.Points[1].X,obj.Points[1].Y+66,obj.Points[1].X+64,obj.Points[1].Y+82);
      form.Brush.Style := bsClear; form.Font.Style := [];
      x1 := 32 - form.TextWidth(sLbl) div 2;
      form.TextOut(obj.Points[1].X+x1,obj.Points[1].Y+63,sLbl);
    end;


    97: begin
    //********************************
    //
    // нарисовать кнопку конца набора
    //
    //********************************
fix := 97;
      if WorkMode.MarhUpr and WorkMode.Upravlenie and WorkMode.GoTracert then
      begin
        form.Pen.Color := armcolor16; form.Brush.Color := armcolor16; form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor18; form.Brush.Color := armcolor18; form.Font.Color := clWhite;
      end;
      form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
      form.Font.Style := []; form.Font.Size := 8;
      form.TextOut(obj.Points[1].X+13,obj.Points[1].Y+2, 'Конец набора');
    end;


    103: begin
    //********************************************
    //
    // нарисовать кнопку подсветки номера поездов
    //
    //********************************************
fix := 103;
      if WorkMode.NumTrain then
      begin
        form.Pen.Color := armcolor16; form.Brush.Color := armcolor16; form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor18; form.Brush.Color := armcolor18; form.Font.Color := clWhite;
      end;
      form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
      form.Font.Style := []; form.Font.Size := 8;
      form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Подсветка поездов');
    end;


    102: begin
    //***************************************
    //
    // нарисовать кнопку ввода номера поезда
    //
    //***************************************
fix := 102;
      if WorkMode.InpTrain then
      begin
        form.Pen.Color := armcolor16; form.Brush.Color := armcolor16; form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor18; form.Brush.Color := armcolor18; form.Font.Color := clWhite;
      end;
      form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
      form.Font.Style := []; form.Font.Size := 8;
      form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Ввод номера поезда');
    end;


    101: begin
    //***********************************************
    //
    // нарисовать кнопку подсветки положения стрелок
    //
    //***********************************************
fix := 101;
      if WorkMode.Podsvet then
      begin
        form.Pen.Color := RGB(255,255,191); form.Brush.Color := RGB(255,255,191); form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := RGB(191,255,191); form.Brush.Color := RGB(191,255,191); form.Font.Color := clBlack;
      end;
      form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
      form.Font.Style := []; form.Font.Size := 8;
      form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Подсветка стрелок');
    end;


    104 : begin
    //******************************************
    //
    // Отображение состояния каналов связи с ДЦ
    //
    //******************************************
fix := 104;
       if Obj.ObjConstI[1] > 0 then
       begin
       // Состояние обмена АРМ - ЛП-ДЦ основной
       form.Pen.Color := 0; form.Pen.Style := psSolid;  form.Pen.Width := 1; form.Brush.Style := bsSolid; form.Font.Color := clBlack;
       form.Brush.Color := armcolor16; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsSolid;
       if ArmDCCh[1] = 1 then
         form.Brush.Color := armcolor1
       else
         form.Brush.Color := armcolor2;
       form.Rectangle(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+26,obj.Points[1].Y+14);
       form.Brush.Style := bsClear;
       form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+1,'ЛПо');
       form.Pen.Width := 0; form.Brush.Style := bsSolid;
       if ArmDCCh[1] = 1 then form.Pen.Color := armcolor1 else
       if ArmDCCh[1] = 2 then form.Pen.Color := armcolor7 else
       if ArmDCCh[1] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.Brush.Color := form.Pen.Color;
       form.Polygon([Point(obj.Points[1].X+26,obj.Points[1].Y+6),
                     Point(obj.Points[1].X+32,obj.Points[1].Y+2),
                     Point(obj.Points[1].X+38,obj.Points[1].Y+6),
                     Point(obj.Points[1].X+32,obj.Points[1].Y+10)]);
       end;
       if Obj.ObjConstI[2] > 0 then
       begin
       // Состояние обмена АРМ - ЛП-ДЦ резервный
       form.Pen.Color := 0; form.Pen.Style := psSolid;  form.Pen.Width := 1; form.Brush.Style := bsSolid; form.Font.Color := clBlack;
       form.Brush.Color := armcolor16; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsSolid;
       if ArmDCCh[2] = 1 then
         form.Brush.Color := armcolor1
       else
         form.Brush.Color := armcolor2;
       form.Rectangle(obj.Points[1].X,obj.Points[1].Y+16,obj.Points[1].X+26,obj.Points[1].Y+30);
       form.Brush.Style := bsClear;
       form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+17,'ЛПр');
       form.Pen.Width := 0; form.Brush.Style := bsSolid;
       if ArmDCCh[2] = 1 then form.Pen.Color := armcolor1 else
       if ArmDCCh[2] = 2 then form.Pen.Color := armcolor7 else
       if ArmDCCh[2] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.Brush.Color := form.Pen.Color;
       form.Polygon([Point(obj.Points[1].X+26,obj.Points[1].Y+22),
                     Point(obj.Points[1].X+32,obj.Points[1].Y+18),
                     Point(obj.Points[1].X+38,obj.Points[1].Y+22),
                     Point(obj.Points[1].X+32,obj.Points[1].Y+26)]);
       end;
    end;


    100 : begin
    //*****************************************************************
    //
    // Отображение состояния системы для варианта с программным каналом
    //
    //*****************************************************************
fix := 100;

       form.Pen.Color := 0; form.Pen.Style := psSolid;  form.Pen.Width := 1; form.Brush.Style := bsSolid; form.Font.Color := clBlack;
       form.Brush.Color := armcolor16; form.Font.Size := 8; form.Font.Style := [];

       // состояние оборудования серверов
       form.Brush.Style := bsSolid;
       if SrvCount = 1 then form.Brush.Color := armcolor7 else
       if SrvCount = 2 then form.Brush.Color := armcolor2 else
         form.Brush.Color := armcolor14;
       form.Rectangle(obj.Points[1].X,obj.Points[1].Y+11,obj.Points[1].X+46,obj.Points[1].Y+27);
       if SrvActive > 0 then sLbl := 'обмен'+ IntToStr(SrvActive) else sLbl := 'обмен?';

       form.TextOut(obj.Points[1].X+2,obj.Points[1].Y+12,sLbl);

       form.Pen.Width := 0;
       // Состояние обмена АРМ - Сервер
       if ArmSrvCh[1] = 1 then form.Pen.Color := armcolor1 else
       if ArmSrvCh[1] = 2 then form.Pen.Color := armcolor7 else
       if ArmSrvCh[1] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.Brush.Color := form.Pen.Color;
       form.Polygon([Point(obj.Points[1].X+10,obj.Points[1].Y+10),
                     Point(obj.Points[1].X+20,obj.Points[1].Y+10),
                     Point(obj.Points[1].X+15,obj.Points[1].Y)]);
       if ArmSrvCh[2] = 1 then form.Pen.Color := armcolor1 else
       if ArmSrvCh[2] = 2 then form.Pen.Color := armcolor7 else
       if ArmSrvCh[2] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.Brush.Color := form.Pen.Color;
       form.Polygon([Point(obj.Points[1].X+25,obj.Points[1].Y),
                     Point(obj.Points[1].X+35,obj.Points[1].Y),
                     Point(obj.Points[1].X+30,obj.Points[1].Y+10)]);

       form.Pen.Style := psSolid;

       // отобразить состояние стоек
       if Obj.ObjConstI[3] > 0 then begin x1 := 15; x2 := 2 end else
       if Obj.ObjConstI[2] > 0 then begin x1 := 23; x2 := 8 end else
       begin x1 := 45; x2 := 18 end;

       n := OVBuffer[Obj.ObjConstI[1]].Param[1]; p := not OVBuffer[Obj.ObjConstI[1]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[1]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[1]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[1]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Width := 1; form.Pen.Color := clBlack;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X,obj.Points[1].Y+27,obj.Points[1].X+x1,obj.Points[1].Y+40);
       if not p and not n and OVBuffer[Obj.ObjConstI[1]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+2,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+2,obj.Points[1].Y+38) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[1]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+x1-3,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+x1-3,obj.Points[1].Y+38) end;
       if tab_page and OVBuffer[Obj.ObjConstI[1]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+x2,obj.Points[1].Y+27, sLbl);

       if Obj.ObjConstI[2] > 0 then
       begin
         n := OVBuffer[Obj.ObjConstI[2]].Param[1]; p := not OVBuffer[Obj.ObjConstI[2]].Param[16];
         b1 := OVBuffer[Obj.ObjConstI[2]].Param[2];
         b2 := OVBuffer[Obj.ObjConstI[2]].Param[3];
         b3 := OVBuffer[Obj.ObjConstI[2]].Param[4];
         form.Brush.Style := bsSolid; form.Pen.Width := 1; form.Pen.Color := clBlack;
         if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
         form.Rectangle(obj.Points[1].X+x1,obj.Points[1].Y+27,obj.Points[1].X+(2*x1),obj.Points[1].Y+40);
         if not p and not n and OVBuffer[Obj.ObjConstI[2]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+x1+2,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+x1+2,obj.Points[1].Y+38) end;
         if not p and not n and OVBuffer[Obj.ObjConstI[2]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+x1+x1-3,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+x1+x1-3,obj.Points[1].Y+38) end;
         if tab_page and OVBuffer[Obj.ObjConstI[2]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
         if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+x1+x2,obj.Points[1].Y+27, sLbl);
       end;

       if Obj.ObjConstI[3] > 0 then
       begin
         n := OVBuffer[Obj.ObjConstI[3]].Param[1]; p := not OVBuffer[Obj.ObjConstI[3]].Param[16];
         b1 := OVBuffer[Obj.ObjConstI[3]].Param[2];
         b2 := OVBuffer[Obj.ObjConstI[3]].Param[3];
         b3 := OVBuffer[Obj.ObjConstI[3]].Param[4];
         form.Brush.Style := bsSolid; form.Pen.Width := 1; form.Pen.Color := clBlack;
         if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
         form.Rectangle(obj.Points[1].X+(2*x1),obj.Points[1].Y+30,obj.Points[1].X+(3*x1),obj.Points[1].Y+40);
         if not p and not n and OVBuffer[Obj.ObjConstI[3]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+x1+x1+2,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+x1+x1+2,obj.Points[1].Y+38) end;
         if not p and not n and OVBuffer[Obj.ObjConstI[3]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+x1+x1+x1-3,obj.Points[1].Y+28); form.LineTo(obj.Points[1].X+x1+x1+x1-3,obj.Points[1].Y+38) end;
         if tab_page and OVBuffer[Obj.ObjConstI[3]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
         if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+(2*x1)+x2,obj.Points[1].Y+27, sLbl);
       end;






{       case ArmAsuCh[1] of
         0 : begin // нет соединения
           form.Pen.Style := psSolid; form.Pen.Width := 1; form.Pen.Color := armcolor1;
           form.MoveTo(obj.Points[1].X,obj.Points[1].Y+5);
           form.LineTo(obj.Points[1].X+10,obj.Points[1].Y+5);
         end;
         1 : begin // ожидания соединения с дальним
           form.Pen.Style := psSolid; form.Pen.Width := 2; form.Pen.Color := armcolor7;
           form.MoveTo(obj.Points[1].X,obj.Points[1].Y+5);
           form.LineTo(obj.Points[1].X+10,obj.Points[1].Y+5);
           if tab_page then
           begin
             form.Pen.Width := 1; form.Pen.Color := armcolor1; form.Brush.Color := armcolor1; form.Brush.Style := bsSolid;
             form.Ellipse(obj.Points[1].X-2,obj.Points[1].Y+3,obj.Points[1].X+2,obj.Points[1].Y+7);
           end else
           begin
             form.Pen.Width := 1; form.Pen.Color := armcolor5; form.Brush.Color := armcolor5; form.Brush.Style := bsSolid;
             form.Ellipse(obj.Points[1].X+8,obj.Points[1].Y+3,obj.Points[1].X+12,obj.Points[1].Y+7);
           end;
         end;
         2 : begin // полное соединение
           form.Pen.Style := psSolid; form.Pen.Width := 3; form.Pen.Color := armcolor5;
           form.MoveTo(obj.Points[1].X,obj.Points[1].Y+5);
           form.LineTo(obj.Points[1].X+10,obj.Points[1].Y+5);
         end;
       end;}
    end;


    98 : begin
    //**********************************************************************
    //
    // Отображение состояния системы для варианта с серверами и 8-ю стойками
    //
    //**********************************************************************
fix := 98;

       form.Pen.Color := 0; form.Pen.Style := psSolid;  form.Pen.Width := 1; form.Brush.Style := bsSolid; form.Font.Color := clBlack;
       form.Brush.Color := armcolor16; form.Font.Size := 8;
       form.Rectangle(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+176,obj.Points[1].Y+37);

       // состояние оборудования верхнего уровня
       if StateRU > 0 then begin if (StateRU and $8) = $8 then form.Brush.Color := armcolor2 else form.Brush.Color := armcolor7; end else form.Brush.Color := armcolor1;
       form.Rectangle(obj.Points[1].X+2,obj.Points[1].Y+10,obj.Points[1].X+27,obj.Points[1].Y+27);
       form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;

       if (StateRU = 0) or WorkMode.NU[0] or WorkMode.BU[0] or not WorkMode.KRU[0] or (WorkMode.OU[0] and WorkMode.RU[0]) then sLbl := 'Н' else
       if ((StateRU and $40) = $40) and (WorkMode.OU[0]) then
       begin
         if WorkMode.Upravlenie then sLbl := 'Упр' else sLbl := 'Рез';
       end else
       if WorkMode.RU[0] then sLbl := 'АУ' else sLbl := 'Н';
       form.TextOut(obj.Points[1].X+4,obj.Points[1].Y+12,sLbl);

       // состояние оборудования серверов
       form.Brush.Style := bsSolid;
       if SrvCount = 1 then form.Brush.Color := armcolor1 else
       if SrvCount = 2 then form.Brush.Color := armcolor7 else
       if SrvCount = 3 then form.Brush.Color := armcolor2 else
       form.Brush.Color := armcolor14;
       form.Rectangle(obj.Points[1].X+30,obj.Points[1].Y+10,obj.Points[1].X+65,obj.Points[1].Y+27);
       sLbl := 'Срв.';
       if SrvActive > 0 then sLbl := sLbl + IntToStr(SrvActive) else sLbl := sLbl + '?';
       form.TextOut(obj.Points[1].X+33,obj.Points[1].Y+12,sLbl);

       // состояние оборудования нижнего уровня
       n := OVBuffer[Obj.ObjConstI[1]].Param[1]; p := not OVBuffer[Obj.ObjConstI[1]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[1]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[1]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[1]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+70,obj.Points[1].Y+10,obj.Points[1].X+82,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[1]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+70+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+70+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[1]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+82-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+82-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[1]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+72,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[2]].Param[1]; p := not OVBuffer[Obj.ObjConstI[2]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[2]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[2]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[2]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+83,obj.Points[1].Y+10,obj.Points[1].X+95,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[2]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+83+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+83+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[2]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+95-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+95-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[2]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+85,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[3]].Param[1]; p := not OVBuffer[Obj.ObjConstI[3]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[3]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[3]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[3]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+96,obj.Points[1].Y+10,obj.Points[1].X+108,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[3]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+96+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+96+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[3]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+108-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+108-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[3]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+98,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[4]].Param[1]; p := not OVBuffer[Obj.ObjConstI[4]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[4]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[4]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[4]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+109,obj.Points[1].Y+10,obj.Points[1].X+121,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[4]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+109+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+109+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[4]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+121-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+121-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[4]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+111,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[5]].Param[1]; p := not OVBuffer[Obj.ObjConstI[5]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[5]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[5]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[5]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+122,obj.Points[1].Y+10,obj.Points[1].X+134,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[5]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+122+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+122+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[5]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+134-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+134-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[5]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+124,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[6]].Param[1]; p := not OVBuffer[Obj.ObjConstI[6]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[6]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[6]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[6]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+135,obj.Points[1].Y+10,obj.Points[1].X+147,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[6]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+135+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+135+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[6]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+147-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+147-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[6]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+137,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[7]].Param[1]; p := not OVBuffer[Obj.ObjConstI[7]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[7]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[7]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[7]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+148,obj.Points[1].Y+10,obj.Points[1].X+160,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[7]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+148+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+148+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[7]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+160-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+160-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[7]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+150,obj.Points[1].Y+12, sLbl);

       n := OVBuffer[Obj.ObjConstI[8]].Param[1]; p := not OVBuffer[Obj.ObjConstI[8]].Param[16];
       b1 := OVBuffer[Obj.ObjConstI[8]].Param[2];
       b2 := OVBuffer[Obj.ObjConstI[8]].Param[3];
       b3 := OVBuffer[Obj.ObjConstI[8]].Param[4];
       form.Brush.Style := bsSolid; form.Pen.Color := clBlack; form.Pen.Width := 1;
       if p then form.Brush.Color := armcolor8 else if n then form.Brush.Color := armcolor14 else if not b2 and not b3 then form.Brush.Color := armcolor2 else if b2 and b3 then form.Brush.Color := armcolor1 else form.Brush.Color := armcolor7;
       form.Rectangle(obj.Points[1].X+161,obj.Points[1].Y+10,obj.Points[1].X+173,obj.Points[1].Y+27);
       if not p and not n and OVBuffer[Obj.ObjConstI[8]].Param[6] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+161+2,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+161+2,obj.Points[1].Y+25) end;
       if not p and not n and OVBuffer[Obj.ObjConstI[8]].Param[7] then begin form.Pen.Color := armcolor1; form.Pen.Width := 3; form.MoveTo(obj.Points[1].X+173-3,obj.Points[1].Y+11); form.LineTo(obj.Points[1].X+173-3,obj.Points[1].Y+25) end;
       if tab_page and OVBuffer[Obj.ObjConstI[8]].Param[9] then form.Font.Color := armcolor1 else form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
       if n or p or (b2 and b3) then sLbl := 'Н' else begin if b1 then sLbl := 'П' else sLbl := 'л'; end; form.TextOut(obj.Points[1].X+163,obj.Points[1].Y+12, sLbl);

       form.Pen.Width := 5;
       // Состояние канала1 связи АРМ - Сервера
       if ArmSrvCh[1] = 1 then form.Pen.Color := armcolor1 else
       if ArmSrvCh[1] = 2 then form.Pen.Color := armcolor7 else
       if ArmSrvCh[1] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.MoveTo(obj.Points[1].X+10,obj.Points[1].Y+5);
       form.LineTo(obj.Points[1].X+40,obj.Points[1].Y+5);

       // Состояние канала2 связи АРМ - Сервера
       if ArmSrvCh[2] = 1 then form.Pen.Color := armcolor1 else
       if ArmSrvCh[2] = 2 then form.Pen.Color := armcolor7 else
       if ArmSrvCh[2] = 4 then form.Pen.Color := armcolor5 else form.Pen.Color := armcolor8;
       form.MoveTo(obj.Points[1].X+10,obj.Points[1].Y+31);
       form.LineTo(obj.Points[1].X+40,obj.Points[1].Y+31);

       // Состояние каналов связи  Сервера - УВК
       if OVBuffer[Obj.ObjConstI[1]].Param[13] then
       begin
         if OVBuffer[Obj.ObjConstI[1]].Param[14] then
           form.Pen.Color := armcolor2
         else
           form.Pen.Color := armcolor7;
       end else
         form.Pen.Color := armcolor8;
       form.MoveTo(obj.Points[1].X+55,obj.Points[1].Y+5);
       form.LineTo(obj.Points[1].X+165,obj.Points[1].Y+5);
       form.MoveTo(obj.Points[1].X+55,obj.Points[1].Y+31);
       form.LineTo(obj.Points[1].X+165,obj.Points[1].Y+31);
    end;

    99 : begin
    //*************************
    //
    // Выбор режима управления
    //
    //*************************
fix := 99;
      case Obj.ObjConstI[1] of

        0 : begin // панель для крупной станции
          form.Brush.Style := bsSolid; form.Pen.Style := psSolid;
          if maket_strelki_index > 0 then form.Brush.Color := armcolor9 else form.Brush.Color := armcolor8;
          form.FillRect(rect(obj.Points[1].X+10,obj.Points[1].Y, obj.Points[1].X+110,obj.Points[1].Y+17)); // Макетная доска
          if maket_strelki_index > 0 then
          begin
            form.Font.Size := 10; form.Font.Style := [fsBold]; form.Font.Color := clBlack;
            x1 := form.TextWidth(maket_strelki_name) div 2;
            form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, maket_strelki_name);
          end else
          begin
            form.Font.Size := 10; form.Font.Style := [];
            if WorkMode.GoMaketSt then form.Font.Color := clRed else form.Font.Color := clWhite;
            x1 := form.TextWidth('Макет стрелки') div 2;
            form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, 'Макет стрелки');
          end;
          form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
          if WorkMode.Upravlenie then
          begin
            if WorkMode.RazdUpr then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+30, obj.Points[1].X+120,obj.Points[1].Y+47));
          form.TextOut(obj.Points[1].X+10,obj.Points[1].Y+32, 'Раздельный режим');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.MarhUpr then begin form.Brush.Color := armcolor2; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+50, obj.Points[1].X+120,obj.Points[1].Y+67));
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+52, 'Маршрутный режим');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.MarhOtm then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+70, obj.Points[1].X+120,obj.Points[1].Y+87));
          form.TextOut(obj.Points[1].X+39,obj.Points[1].Y+72, 'Отмена');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.InpOgr then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+100, obj.Points[1].X+120,obj.Points[1].Y+117));
          form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+102, 'Ограничения');

          if WorkMode.Upravlenie then
          begin
          if WorkMode.VspStr then begin form.Brush.Color := armcolor1; form.Font.Color := clBlack; end else
          begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+120, obj.Points[1].X+120,obj.Points[1].Y+137));
          form.TextOut(obj.Points[1].X+3,obj.Points[1].Y+122, 'Всп. перевод стрелок');

          if WorkMode.LockCmd and WorkMode.Upravlenie then
          begin
            form.Brush.Color := armcolor1; form.Font.Color := clBlack;
          end else
          if WorkMode.CmdReady then
          begin
            form.Brush.Color := armcolor7; form.Font.Color := clBlack;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+140, obj.Points[1].X+120,obj.Points[1].Y+157));
          form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+142, 'Сброс команд');

          // часы РМ-ДСП
          form.Brush.Color := RGB(220,255,220); form.Font.Color := clBlack;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+160, obj.Points[1].X+120,obj.Points[1].Y+180));
          DateTimeToString(sLbl, 'h:nn:ss', LastTime);
          form.Font.Size := 12; form.Font.Style := [fsBold];
          x1 := form.TextWidth(sLbl) div 2;
          form.TextOut(obj.Points[1].X-x1+60,obj.Points[1].Y+160, sLbl);
        end;

        1 : begin // панель для малой станции по решениям МСТУ
          form.Brush.Style := bsSolid; form.Pen.Style := psSolid;
          form.Font.Color := clBlack; form.Font.Size := 8; form.Font.Style := []; form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
          if WorkMode.Upravlenie then
          begin
            if WorkMode.RazdUpr then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y, obj.Points[1].X+120,obj.Points[1].Y+17));
          form.TextOut(obj.Points[1].X+10,obj.Points[1].Y+2, 'Раздельный режим');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.MarhUpr then begin form.Brush.Color := armcolor2; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+20, obj.Points[1].X+120,obj.Points[1].Y+37));
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+22, 'Маршрутный режим');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.MarhOtm then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+40, obj.Points[1].X+120,obj.Points[1].Y+57));
          form.TextOut(obj.Points[1].X+39,obj.Points[1].Y+42, 'Отмена');

          if WorkMode.Upravlenie then
          begin
            if WorkMode.InpOgr then begin form.Brush.Color := armcolor7; form.Font.Color := clBlack; end else
            begin form.Brush.Color := armcolor16; form.Font.Color := clBlack; end;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+70, obj.Points[1].X+120,obj.Points[1].Y+87));
          form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+72, 'Ограничения');

          if WorkMode.LockCmd and WorkMode.Upravlenie then
          begin
            form.Brush.Color := armcolor1; form.Font.Color := clBlack;
          end else
          if WorkMode.CmdReady then
          begin
            form.Brush.Color := armcolor7; form.Font.Color := clBlack;
          end else
          begin
            form.Brush.Color := armcolor18; form.Font.Color := armcolor9;
          end;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+90, obj.Points[1].X+120,obj.Points[1].Y+107));
          form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+92, 'Сброс команд');

          // часы РМ-ДСП
          form.Brush.Color := RGB(220,255,220); form.Font.Color := clBlack;
          form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+110, obj.Points[1].X+120,obj.Points[1].Y+130));
          DateTimeToString(sLbl, 'h:nn:ss', LastTime);
          form.Font.Size := 12; form.Font.Style := [fsBold];
          x1 := form.TextWidth(sLbl) div 2;
          form.TextOut(obj.Points[1].X-x1+60,obj.Points[1].Y+110, sLbl);
        end;
      end;
    end;




    1: begin
    //********************************
    //
    // нарисовать статическую ломаную
    //
    //********************************
fix := 1;
      form.Pen.Color   := GetColor(Obj.ObjConstI[1]);
      form.Pen.Style   := GetPenStyle(Obj.ObjConstI[2]);
      form.Pen.Width   := Obj.ObjConstI[3];
      form.Brush.Color := GetColor(Obj.ObjConstI[4]);
      form.Brush.Style := GetBrushStyle(Obj.ObjConstI[5]);
      form.MoveTo(Obj.Points[1].x, Obj.Points[1].y);
      form.LineTo(Obj.Points[2].x, Obj.Points[2].y);
      if Obj.Points[3].X > 0 then
      begin
        form.LineTo(Obj.Points[3].x, Obj.Points[3].y);
        if Obj.Points[4].X > 0 then
        begin
          form.LineTo(Obj.Points[4].x, Obj.Points[4].y);
          if Obj.Points[5].X > 0 then
          begin
            form.LineTo(Obj.Points[5].x, Obj.Points[5].y);
            if Obj.Points[6].X > 0 then
              form.LineTo(Obj.Points[6].x, Obj.Points[6].y);
          end;
        end;
      end;
    end;

    2: begin
    //********************************
    //
    // нарисовать статическую надпись
    //
    //********************************
fix := 2;
      form.font.Color  := GetColor(Obj.ObjConstI[1]);
      form.font.Style  := GetFontStyle(Obj.ObjConstI[2]);
      form.Brush.Color := GetColor(Obj.ObjConstI[3]);
      form.Brush.Style := GetBrushStyle(Obj.ObjConstI[4]);
      form.font.Size   := Obj.ObjConstI[5];
      form.TextOut(Obj.Points[1].x, Obj.Points[1].y, Obj.Title);
    end;

    3: begin
    //*************************************************************
    //
    // нарисовать статическую фигуру: рамку, эллипс, многоугольник
    //
    //*************************************************************
fix := 3;
      form.pen.Color   := GetColor(Obj.ObjConstI[1]);
      form.Pen.Style   := GetPenStyle(Obj.ObjConstI[2]);
      form.Pen.Width   := Obj.ObjConstI[3];
      form.Brush.Color := GetColor(Obj.ObjConstI[4]);
      form.Brush.Style := GetBrushStyle(Obj.ObjConstI[5]);
      case Obj.ObjConstI[6] of
        1 : form.Ellipse(rect(Obj.Points[1],Obj.Points[2]));
        2 : begin
          if Obj.Points[6].X > 0 then form.Polygon(Obj.Points) else
          if Obj.Points[5].X > 0 then form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else;
          if Obj.Points[4].X > 0 then form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else;
          if Obj.Points[3].X > 0 then form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3]]);
        end;
      else
        form.Rectangle(rect(Obj.Points[1],Obj.Points[2]));
      end;
    end;

    4: begin
    //*******************************
    //
    // нецентрализованное примыкание
    //
    //*******************************
fix := 4;
      form.pen.Color := RGB(220,220,220); form.Pen.Style := psSolid; form.Pen.Width := 5;
      form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
      case Obj.ObjConstI[1] of
        1 : begin
        // Тупик слева
          if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
          if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
          if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
          form.MoveTo(Obj.Points[2].X-2,Obj.Points[2].Y-4);
          form.LineTo(Obj.Points[2].X,Obj.Points[2].Y-4);
          form.LineTo(Obj.Points[2].X,Obj.Points[2].Y+4);
          form.LineTo(Obj.Points[2].X-2,Obj.Points[2].Y+4);
          form.pen.Color := armcolor12; form.Pen.Width := 1;
          if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
          if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
          if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
          form.MoveTo(Obj.Points[2].X-2,Obj.Points[2].Y-4);
          form.LineTo(Obj.Points[2].X,Obj.Points[2].Y-4);
          form.LineTo(Obj.Points[2].X,Obj.Points[2].Y+4);
          form.LineTo(Obj.Points[2].X-3,Obj.Points[2].Y+4);
        end;
        2 : begin
        // Тупик справа
          if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
          if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
          if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
          form.MoveTo(Obj.Points[3].X+2,Obj.Points[3].Y-4);
          form.LineTo(Obj.Points[3].X,Obj.Points[3].Y-4);
          form.LineTo(Obj.Points[3].X,Obj.Points[3].Y+4);
          form.LineTo(Obj.Points[3].X+2,Obj.Points[3].Y+4);
          form.pen.Color := armcolor12; form.Pen.Width := 1;
          if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
          if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
          if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
          form.MoveTo(Obj.Points[3].X+2,Obj.Points[3].Y-4);
          form.LineTo(Obj.Points[3].X,Obj.Points[3].Y-4);
          form.LineTo(Obj.Points[3].X,Obj.Points[3].Y+4);
          form.LineTo(Obj.Points[3].X+3,Obj.Points[3].Y+4);
        end;
        3 : begin
        // Значок увязки между парками симметричный
          x1 := form.TextWidth(obj.Title) div 2;
          y1 := form.TextHeight(obj.Title) div 2;
          form.Pen.Color := armcolor9;
          form.Pen.Width := 1;
          form.Brush.Color := armcolor9;
          form.Brush.Style := bsSolid;
          form.Polygon([Point(Obj.Points[1].X-6-x1,Obj.Points[1].Y),Point(Obj.Points[1].X-x1,Obj.Points[1].Y+6),
            Point(Obj.Points[1].X+x1,Obj.Points[1].Y+6),Point(Obj.Points[1].X+6+x1,Obj.Points[1].Y),
            Point(Obj.Points[1].X+x1,Obj.Points[1].Y-6),Point(Obj.Points[1].X-x1,Obj.Points[1].Y-6)]);
          form.Brush.Style := bsClear;
          form.Font.Color := armcolor12;
          form.font.Style := [];
          form.TextOut(Obj.Points[1].X-x1,Obj.Points[1].Y-y1,obj.Title);
          exit;
        end;
      else
      // Нет тупика - неконтролируемый подъездной путь
        if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
        if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
        if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
        if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
        form.pen.Color := armcolor12; form.Pen.Width := 1;
        if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]]) else
        if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]]) else
        if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]]) else
        if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
      end;
      if Obj.Points[1].X > 0 then
      begin
        form.font.Style := [];
        form.Brush.Style := bsClear; form.Font.Size := 8; form.Font.Color := armcolor12;
        form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
      end;
    end;

    5: begin
    //********************
    //
    // нарисовать логотип
    //
    //********************
fix := 5;
      TabloMain.ImageListRU.Draw(form,obj.Points[1].X,obj.Points[1].Y,5);
    end;

    10: begin
    //******************
    //
    // стрелочная секция
    //
    //******************
fix := 10;
      if Obj.Points[6].X > 0 then
        DrawSP(form,Obj.ObjConstI[1],[Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
      else if Obj.Points[5].X > 0 then
        DrawSP(form,Obj.ObjConstI[1],[Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
      else if Obj.Points[4].X > 0 then
        DrawSP(form,Obj.ObjConstI[1],[Obj.Points[2],Obj.Points[3],Obj.Points[4]])
      else
        DrawSP(form,Obj.ObjConstI[1],[Obj.Points[2],Obj.Points[3]]);

      if Obj.Points[1].X > 0 then
      begin
      // Нарисовать литер секции
        x1 := -1;
        if OVBuffer[Obj.ObjConstI[1]].Param[29] then
        begin // Закрыто для движения на электротяге
          x1 := 24;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
        begin // Закрыто для движения на 2-х родах тяги
          x1 := 2;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[30] then
        begin // Закрыто для движения на пер.т.
          x1 := 26
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[31] then
        begin // Закрыто для движения на пост.т.
          x1 := 25;
        end;
        if x1 > -1 then
        begin // нарисовать иконку ограничения электротяги
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
          case Obj.ObjConstI[7] of
            1 : begin // вправо по горизонтали
              TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,x1);
              form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
              form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+7,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            end;
            2 : begin // вниз по вертикали
              TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,x1);
              form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
              form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)+3);
            end;
            3 : begin // вверх по вертикали
              TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,x1);
              form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y-3);
              form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
            end;
          else // влево по горизонтали
            TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,x1);
            form.MoveTo(obj.Points[1].X-5,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          end;
        end;

        if OVBuffer[Obj.ObjConstI[1]].Param[32] then form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        if OVBuffer[Obj.ObjConstI[1]].Param[9] then
        begin // Предварительная команда РИ секции
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor9;
        end else
        begin // Нет предварительной команды РИ секции
          form.Brush.Style := bsClear;
        end;
        form.Font.Size := 8; form.font.Style := [];
        form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
        if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
        begin
          x1 := form.TextWidth(Obj.Title); form.font.Style := [fsBold]; form.Font.Color := armcolor1;
          form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!');
        end;
      end;
    end;

    11: begin
    //********************
    //
    // нарисовать стрелку
    //
    //********************
fix := 11;
      form.Pen.Style := psSolid;
      if OVBuffer[Obj.ObjConstI[4]].Param[31] then
      begin // Стрелка на макете
        TabloMain.ImageList.Draw(form,obj.Points[2].X-6,obj.Points[2].Y-6,0);
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[6] then
      begin // требование перевода охранной стрелки в охранное положение при трассировке
        form.Pen.Color := armcolor9; form.Pen.Width := 2; form.Brush.Style := bsClear;
        form.Rectangle(obj.Points[2].X-4,obj.Points[2].Y-4,obj.Points[2].X+5,obj.Points[2].Y+5);
      end else
      if OVBuffer[Obj.ObjConstI[4]].Param[5] then
      begin // Признак отсутствия контроля требуемого положения стрелки
        form.Brush.Color := armcolor9;
        form.FillRect(rect(obj.Points[2].X-4,obj.Points[2].Y-4,obj.Points[2].X+5,obj.Points[2].Y+5));
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[7] then
      begin // охранная стрелка замкнута в охранном положение
        form.Pen.Color := armcolor8; form.Pen.Width := 1; form.Brush.Style := bsClear;
        form.Rectangle(obj.Points[2].X-5,obj.Points[2].Y-5,obj.Points[2].X+6,obj.Points[2].Y+6);
      end else
      if OVBuffer[Obj.ObjConstI[4]].Param[12] then
      begin // Признак ожидания завершения выдержки времени МСП(Д)
        form.Pen.Color := armcolor7; form.Pen.Width := 1; form.Brush.Style := bsClear;
        form.Rectangle(obj.Points[2].X-5,obj.Points[2].Y-5,obj.Points[2].X+6,obj.Points[2].Y+6);
      end;

      form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[4]].Param[16] then
      begin // Проверить активизацию объекта
        form.Pen.Color := armcolor12; form.Pen.Width := 3; form.Font.Color := armcolor12; goto str1;
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[1] then
      begin // Непарафазность стрелки
        form.Pen.Color := armcolor14; form.Pen.Width := 3; form.Font.Color := armcolor14; goto str1;
      end else
      begin // Наличие макета на стрелке или МУ
        if OVBuffer[Obj.ObjConstI[4]].Param[4] then form.Font.Color := clBlack
        // Наличие контроля плюсового положения
        else if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then form.Font.Color := armcolor5
        // Наличие контроля минусового положения
        else if OVBuffer[Obj.ObjConstI[4]].Param[3] and not OVBuffer[Obj.ObjConstI[4]].Param[2] then form.Font.Color := armcolor7
        // Отсутствие контроля положения
        else form.Font.Color := armcolor4;
      end;

// Нарисовать литер стрелки
str1:
      form.Font.Size := 8; form.Font.Style := [fsBold]; form.Brush.Style := bsClear;
      if OVBuffer[Obj.ObjConstI[4]].Param[11] then
      begin // нажата кнопка вспомогательного перевода стрелки
        form.Pen.Color := armcolor9; form.Pen.Width := 1;
        x1 := form.TextWidth(Obj.Title)+2; y1 := form.TextHeight(Obj.Title);
        form.RoundRect(Obj.Points[1].X-1,Obj.Points[1].Y,Obj.Points[1].X+x1,Obj.Points[1].Y+y1,7,10);
      end;
      form.TextOut(Obj.Points[1].X,Obj.Points[1].Y,Obj.Title);
      form.Font.Style := [];
      form.Pen.Color := 0; form.Pen.Width := 2;
      case Obj.ObjConstI[1] of
        1 : begin
          form.MoveTo(Obj.Points[2].X+5,Obj.Points[2].Y+3); form.LineTo(Obj.Points[2].X+10,Obj.Points[2].Y+3);
        end;
        2 : begin
          form.MoveTo(Obj.Points[2].X+5,Obj.Points[2].Y+4); form.LineTo(Obj.Points[2].X+7,Obj.Points[2].Y+9);
        end;
        3 : begin
          form.MoveTo(Obj.Points[2].X+5,Obj.Points[2].Y-2); form.LineTo(Obj.Points[2].X+10,Obj.Points[2].Y-2);
        end;
        4 : begin
          form.MoveTo(Obj.Points[2].X+5,Obj.Points[2].Y-3); form.LineTo(Obj.Points[2].X+7,Obj.Points[2].Y-8);
        end;
        5 : begin
          form.MoveTo(Obj.Points[2].X-5,Obj.Points[2].Y+3); form.LineTo(Obj.Points[2].X-10,Obj.Points[2].Y+3);
        end;
        6 : begin
          form.MoveTo(Obj.Points[2].X-5,Obj.Points[2].Y+4); form.LineTo(Obj.Points[2].X-7,Obj.Points[2].Y+9);
        end;
        7 : begin
          form.MoveTo(Obj.Points[2].X-5,Obj.Points[2].Y-2); form.LineTo(Obj.Points[2].X-10,Obj.Points[2].Y-2);
        end;
        8 : begin
          form.MoveTo(Obj.Points[2].X-5,Obj.Points[2].Y-3); form.LineTo(Obj.Points[2].X-7,Obj.Points[2].Y-8);
        end;
      end;

      x1 := 0; x2 := 0; y1 := 0; y2 := 0;
// Нарисовать плюсовую ветку стрелки
      case Obj.ObjConstI[1] of
        1 : begin
          // Получить смещения для 1-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X+4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        2 : begin
          // Получить смещения для 2-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X+4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        3 : begin
          // Получить смещения для 3-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y+5; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X+4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        4 : begin
          // Получить смещения для 4-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y+5; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X+4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        5 : begin
          // Получить смещения для 5-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y-5; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X-4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        6 : begin
          // Получить смещения для 6-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y-5; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X-4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        7 : begin
          // Получить смещения для 7-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y+5; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X-4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
        8 : begin
          // Получить смещения для 8-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y+5; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-4; y2 := Obj.Points[2].Y;
          end else
          begin
            x1 := Obj.Points[2].X-4; y1 := Obj.Points[2].Y; x2 := 0; y2 := 0;
          end;
        end;
      end;

      if (x2 > 0) and (y2 > 0) then
        DrawSP(form,Obj.ObjConstI[2],[Point(x1,y1),Point(x2,y2),Obj.Points[3]])
      else
        DrawSP(form,Obj.ObjConstI[2],[Point(x1,y1),Obj.Points[3]]);

// Нарисовать минусовую ветку стрелки
      case Obj.ObjConstI[1] of
        1 : begin
          // Получить смещения для 1-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-3; y1 := Obj.Points[2].Y+4; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y+4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y+4;
          end else
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y+4; x2 := 0; y2 := 0;
          end;
        end;
        2 : begin
          // Получить смещения для 2-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y+4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-3; y1 := Obj.Points[2].Y+4; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y+4;
          end else
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y+4; x2 := 0; y2 := 0;
          end;
        end;
        3 : begin
          // Получить смещения для 3-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-3; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y-4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y-4;
          end else
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y-4; x2 := 0; y2 := 0;
          end;
        end;
        4 : begin
          // Получить смещения для 4-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y-4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X-3; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X+2; y2 := Obj.Points[2].Y-4;
          end else
          begin
            x1 := Obj.Points[2].X+2; y1 := Obj.Points[2].Y-4; x2 := 0; y2 := 0;
          end;
        end;
        5 : begin
          // Получить смещения для 5-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+3; y1 := Obj.Points[2].Y+4; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y+4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y+4;
          end else
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y+4; x2 := 0; y2 := 0;
          end;
        end;
        6 : begin
          // Получить смещения для 6-ой конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y+4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+3; y1 := Obj.Points[2].Y+4; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y+4;
          end else
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y+4; x2 := 0; y2 := 0;
          end;
        end;
        7 : begin
          // Получить смещения для 7-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+3; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y-4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y-4;
          end else
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y-4; x2 := 0; y2 := 0;
          end;
        end;
        8 : begin
          // Получить смещения для 8-й конфигурации
          if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X; y1 := Obj.Points[2].Y; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y-4;
          end else
          if not OVBuffer[Obj.ObjConstI[4]].Param[2] and OVBuffer[Obj.ObjConstI[4]].Param[3] then
          begin
            x1 := Obj.Points[2].X+3; y1 := Obj.Points[2].Y-4; x2 := Obj.Points[2].X-2; y2 := Obj.Points[2].Y-4;
          end else
          begin
            x1 := Obj.Points[2].X-2; y1 := Obj.Points[2].Y-4; x2 := 0; y2 := 0;
          end;
        end;
      end;

      if (x2 > 0) and (y2 > 0) then
      begin
        if Obj.Points[5].X > 0 then
          DrawSP(form,Obj.ObjConstI[3],[Point(x1,y1),Point(x2,y2),Obj.Points[4],Obj.Points[5]])
        else
          DrawSP(form,Obj.ObjConstI[3],[Point(x1,y1),Point(x2,y2),Obj.Points[4]]);
      end else
      begin
        if Obj.Points[5].X > 0 then
          DrawSP(form,Obj.ObjConstI[3],[Point(x1,y1),Obj.Points[4],Obj.Points[5]])
        else
          DrawSP(form,Obj.ObjConstI[3],[Point(x1,y1),Obj.Points[4]]);
      end;

    // Ограничения на стрелку
      if OVBuffer[Obj.ObjConstI[4]].Param[32] then
      begin // Стрелка выключена из управления
        form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
        case Obj.ObjConstI[7] of
          1 : begin // вправо по горизонтали
            TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,3);
            form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          end;
          2 : begin // вниз по вертикали
            TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,3);
            form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
            form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title));
          end;
          3 : begin // вверх по вертикали
            TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,3);
            form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y);
            form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
          end;
        else // влево по горизонтали
          TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,3);
          form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        end;
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[30] then
      begin // Стрелка закрыта для движения
        form.Brush.Color := armcolor4; form.Pen.Color := armcolor4; form.Pen.Width := 1; form.Pen.Style := psSolid;
        case Obj.ObjConstI[1] of
          1,2,3,4 : begin
            case Obj.ObjConstI[5] of
              1 : form.Polygon([Point(obj.Points[2].X-9,obj.Points[2].Y-5),
                                Point(obj.Points[2].X+2,obj.Points[2].Y-10),
                                Point(obj.Points[2].X+4,obj.Points[2].Y-6),
                                Point(obj.Points[2].X-7,obj.Points[2].Y-1)]);
              2 : form.Polygon([Point(obj.Points[2].X-7,obj.Points[2].Y+1),
                                Point(obj.Points[2].X+4,obj.Points[2].Y+6),
                                Point(obj.Points[2].X+2,obj.Points[2].Y+10),
                                Point(obj.Points[2].X-9,obj.Points[2].Y+5)]);
              else
                form.Polygon([Point(obj.Points[2].X-8,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-4,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-4,obj.Points[2].Y+7),
                              Point(obj.Points[2].X-8,obj.Points[2].Y+7)]);
              end;
          end;
        else
          case Obj.ObjConstI[5] of
            1 : form.Polygon([Point(obj.Points[2].X-4,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-2,obj.Points[2].Y-10),
                              Point(obj.Points[2].X+9,obj.Points[2].Y-5),
                              Point(obj.Points[2].X+7,obj.Points[2].Y-1)]);
            2 : form.Polygon([Point(obj.Points[2].X+7,obj.Points[2].Y+1),
                              Point(obj.Points[2].X+9,obj.Points[2].Y+5),
                              Point(obj.Points[2].X-2,obj.Points[2].Y+10),
                              Point(obj.Points[2].X-4,obj.Points[2].Y+6)]);
          else
            form.Polygon([Point(obj.Points[2].X+4,obj.Points[2].Y-6),
                          Point(obj.Points[2].X+8,obj.Points[2].Y-6),
                          Point(obj.Points[2].X+8,obj.Points[2].Y+7),
                          Point(obj.Points[2].X+4,obj.Points[2].Y+7)]);
          end;
        end;
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[29] then
      begin // Стрелка закрыта для противошерстного движения (если не закрыта для движения по всем направлениям - рисовать)
        form.Brush.Color := armcolor1; form.Pen.Color := armcolor1; form.Pen.Width := 1; form.Pen.Style := psSolid;
        case Obj.ObjConstI[1] of
          1,2,3,4 : begin
            case Obj.ObjConstI[5] of
              1 : form.Polygon([Point(obj.Points[2].X-7,obj.Points[2].Y-6),
                                Point(obj.Points[2].X,obj.Points[2].Y-9),
                                Point(obj.Points[2].X-1,obj.Points[2].Y-3)]);
              2 : form.Polygon([Point(obj.Points[2].X-1,obj.Points[2].Y+3),
                                Point(obj.Points[2].X,obj.Points[2].Y+9),
                                Point(obj.Points[2].X-7,obj.Points[2].Y+6)]);
              else
                form.Polygon([Point(obj.Points[2].X-8,obj.Points[2].Y-5),
                              Point(obj.Points[2].X-8,obj.Points[2].Y+5),
                              Point(obj.Points[2].X-3,obj.Points[2].Y)]);
              end;
          end;
        else
          case Obj.ObjConstI[5] of
            1 : form.Polygon([Point(obj.Points[2].X+1,obj.Points[2].Y-3),
                              Point(obj.Points[2].X,obj.Points[2].Y-9),
                              Point(obj.Points[2].X+7,obj.Points[2].Y-6)]);
            2 : form.Polygon([Point(obj.Points[2].X+1,obj.Points[2].Y+3),
                              Point(obj.Points[2].X+7,obj.Points[2].Y+6),
                              Point(obj.Points[2].X,obj.Points[2].Y+9)]);
          else
            form.Polygon([Point(obj.Points[2].X+8,obj.Points[2].Y-5),
                          Point(obj.Points[2].X+8,obj.Points[2].Y+5),
                          Point(obj.Points[2].X+3,obj.Points[2].Y)]);
          end;
        end;
      end;
    end;


    12: begin
    //************************
    //
    // Приемоотправочный путь (горизонтальный)
    //
    //************************
// Путь
fix := 12;
      // РМ не отображаем, всегда выводим на табло положение датчиков пути
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный путь
        form.Pen.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность пути
        form.Pen.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[4] then
      begin                                // Путь свободен
        form.Pen.Color := 0;
        if OVBuffer[obj.ObjConstI[1]].Param[2] and OVBuffer[obj.ObjConstI[1]].Param[3] then // маршрутное замыкание
        begin
          if OVBuffer[obj.ObjConstI[1]].Param[6] then
          begin // свободен и разомкнут
            form.Pen.Width := 1; form.Pen.Color := 0;
          end else
          begin // предварительное замыкание или программное на сервере
            if OVBuffer[obj.ObjConstI[1]].Param[14] then form.Pen.Width := 3 else form.Pen.Width := 1;
            form.Pen.Color := armcolor9;
          end;
        end else
        begin // замыкание при свободности
          form.Pen.Color := armcolor7; form.Pen.Width := 3;
        end;
      end else
      begin // Путь занят
        form.Pen.Width := 3; form.Pen.Color := armcolor1;
      end;
      form.Pen.Style := psSolid;
      form.MoveTo(obj.Points[2].X,obj.Points[2].Y); form.LineTo(obj.Points[3].X,obj.Points[3].Y);
      if OVBuffer[obj.ObjConstI[1]].Param[16] and not OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        if not OVBuffer[obj.ObjConstI[1]].Param[4] and not OVBuffer[obj.ObjConstI[1]].Param[6] then
        begin // занят и есть предварительное замыкание - белая полоса поверх занятого пути
          form.Pen.Width := 1; form.Pen.Color := armcolor9;
          form.MoveTo(obj.Points[2].X,obj.Points[2].Y); form.LineTo(obj.Points[3].X,obj.Points[3].Y);
        end;
      end;

      // Исключалки
      if OVBuffer[obj.ObjConstI[1]].Param[16] and not OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        if obj.Points[2].X < obj.Points[3].X then
        begin // Нечетные справа
          if not OVBuffer[obj.ObjConstI[1]].Param[3] then
          begin // нечетная исключалка
            form.Pen.Style := psSolid; form.Pen.Width := 2;
            if OVBuffer[obj.ObjConstI[1]].Param[7] then form.Pen.Color := armcolor7 else form.Pen.Color := armcolor5;
            x1 := obj.Points[2].X + 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X + 5; y2 := obj.Points[2].Y +4;
            form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
          end;
          if not OVBuffer[obj.ObjConstI[1]].Param[2] then
          begin // четная исключалка
            form.Pen.Style := psSolid; form.Pen.Width := 2;
            if OVBuffer[obj.ObjConstI[1]].Param[5] then form.Pen.Color := armcolor7 else form.Pen.Color := armcolor5;
            x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X - 5; y2 := obj.Points[3].Y +4;
            form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
          end;
        end else
        begin // Нечетные слева
          if not OVBuffer[obj.ObjConstI[1]].Param[2] then
          begin // нечетная исключалка
            form.Pen.Style := psSolid; form.Pen.Width := 2;
            if OVBuffer[obj.ObjConstI[1]].Param[5] then form.Pen.Color := armcolor7 else form.Pen.Color := armcolor5;
            x1 := obj.Points[3].X + 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X + 5; y2 := obj.Points[3].Y +4;
            form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
          end;
          if not OVBuffer[obj.ObjConstI[1]].Param[3] then
          begin // четная исключалка
            form.Pen.Style := psSolid; form.Pen.Width := 2;
            if OVBuffer[obj.ObjConstI[1]].Param[7] then form.Pen.Color := armcolor7 else form.Pen.Color := armcolor5;
            x1 := obj.Points[2].X - 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X - 5; y2 := obj.Points[2].Y +4;
            form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
          end;
        end;
      end else
      begin
        if not OVBuffer[obj.ObjConstI[1]].Param[16] then
        begin // нет информации
          form.Pen.Style := psSolid; form.Pen.Width := 1; form.Pen.Color := armcolor12;
          if obj.Points[2].X < obj.Points[3].X then
          begin x1 := obj.Points[2].X + 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X + 5; y2 := obj.Points[2].Y +4; end else
          begin x1 := obj.Points[2].X - 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X - 5; y2 := obj.Points[2].Y +4; end;
          form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
          if obj.Points[2].X < obj.Points[3].X then
          begin x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X - 5; y2 := obj.Points[3].Y +4; end else
          begin x1 := obj.Points[3].X + 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X + 5; y2 := obj.Points[3].Y +4; end;
          form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
        end else
        begin // непарофазность
          form.Pen.Style := psSolid; form.Pen.Width := 1; form.Pen.Color := armcolor14;
          if obj.Points[2].X < obj.Points[3].X then
          begin x1 := obj.Points[2].X + 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X + 5; y2 := obj.Points[2].Y +4; end else
          begin x1 := obj.Points[2].X - 11; y1 := obj.Points[2].Y - 4; x2 := obj.Points[2].X - 5; y2 := obj.Points[2].Y +4; end;
          form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
          if obj.Points[2].X < obj.Points[3].X then
          begin x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X - 5; y2 := obj.Points[3].Y +4; end else
          begin x1 := obj.Points[3].X + 11; y1 := obj.Points[3].Y - 4; x2 := obj.Points[3].X + 5; y2 := obj.Points[3].Y +4; end;
          form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
        end;
      end;

      if Obj.Points[1].X > 0 then
      begin
// Нарисовать литер пути
        x1 := -1;
        if OVBuffer[Obj.ObjConstI[1]].Param[29] then
        begin // Закрыто для движения на электротяге
          x1 := 24;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
        begin // Закрыто для движения на 2-х родах тяги
          x1 := 2;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[30] then
        begin // Закрыто для движения на пер.т.
          x1 := 26
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[31] then
        begin // Закрыто для движения на пост.т.
          x1 := 25;
        end;
        if x1 > -1 then
        begin // нарисовать иконку ограничения электротяги
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
          case Obj.ObjConstI[7] of
            1 : begin // вправо по горизонтали
              TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,x1);
              form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
              form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+7,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            end;
            2 : begin // вниз по вертикали
              TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,x1);
              form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
              form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)+3);
            end;
            3 : begin // вверх по вертикали
              TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,x1);
              form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y-3);
              form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
            end;
          else // влево по горизонтали
            TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,x1);
            form.MoveTo(obj.Points[1].X-5,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          end;
        end;

        form.Brush.Style := bsClear; form.Font.Size := 8; form.font.Style := [];
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
        if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
        begin
          x1 := form.TextWidth(Obj.Title); form.font.Style := [fsBold]; form.Font.Color := armcolor1;
          form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!');
        end;
      end;
    end;


    13 : begin
    //************************
    //
    // Маневровый известитель
    //
    //************************
// Путь
fix := 13;
      if obj.ObjConstI[2] = 1 then x1 := 4 else x1 := 2;
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный путь
        form.Pen.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность пути
        form.Pen.Color := armcolor14; form.Pen.Width := 3; form.Pen.Style := psSolid;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[x1] then // занятость пути
      begin
        form.Pen.Color := 0; form.Pen.Width := 1;
      end else
      begin
        form.Pen.Width := 1; form.Pen.Color := armcolor1;
      end;
      form.MoveTo(obj.Points[2].X,obj.Points[2].Y); form.LineTo(obj.Points[3].X,obj.Points[3].Y);

      if Obj.Points[1].X > 0 then
      begin
// Нарисовать литер маневрового известителя
        if OVBuffer[Obj.ObjConstI[1]].Param[19]
          or OVBuffer[Obj.ObjConstI[1]].Param[20] or OVBuffer[Obj.ObjConstI[1]].Param[21] or OVBuffer[Obj.ObjConstI[1]].Param[22]
          or OVBuffer[Obj.ObjConstI[1]].Param[23] or OVBuffer[Obj.ObjConstI[1]].Param[24] or OVBuffer[Obj.ObjConstI[1]].Param[25]
          or OVBuffer[Obj.ObjConstI[1]].Param[26] or OVBuffer[Obj.ObjConstI[1]].Param[27] or OVBuffer[Obj.ObjConstI[1]].Param[28]
          or OVBuffer[Obj.ObjConstI[1]].Param[29] or OVBuffer[Obj.ObjConstI[1]].Param[30] or OVBuffer[Obj.ObjConstI[1]].Param[31]
          or OVBuffer[Obj.ObjConstI[1]].Param[32] then form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        form.Brush.Style := bsClear; form.Font.Size := 8; form.font.Style := [];
        form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
        if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
        begin
          x1 := form.TextWidth(Obj.Title); form.font.Style := [fsBold]; form.Font.Color := armcolor1;
          form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!');
        end;
      end;
    end;


    14: begin
    //********************************
    //
    // нарисовать сбрасывающий башмак
    //
    //********************************
fix := 14;
      form.Pen.Style := psSolid;
      if OVBuffer[Obj.ObjConstI[4]].Param[31] then
      begin // башмак на макете
        TabloMain.ImageList.Draw(form,obj.Points[2].X-6,obj.Points[2].Y-6,0);
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[6] then
      begin // требование перевода охранной стрелки в охранное положение при трассировке
        form.Pen.Color := armcolor9; form.Pen.Width := 2; form.Brush.Style := bsClear;
        form.Rectangle(obj.Points[2].X-4,obj.Points[2].Y-4,obj.Points[2].X+5,obj.Points[2].Y+5);
      end else
      if OVBuffer[Obj.ObjConstI[4]].Param[5] then
      begin // Признак отсутствия контроля требуемого положения стрелки
        form.Brush.Color := armcolor9;
        form.FillRect(rect(obj.Points[2].X-4,obj.Points[2].Y-4,obj.Points[2].X+5,obj.Points[2].Y+5));
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[7] then
      begin // башмак замкнут в охранном положении
        form.Pen.Color := armcolor8; form.Pen.Width := 1; form.Brush.Style := bsClear;
        form.Rectangle(obj.Points[2].X-5,obj.Points[2].Y-5,obj.Points[2].X+6,obj.Points[2].Y+6);
      end;

    // Нарисовать башмак
      form.Brush.Style := bsSolid; form.Pen.Width := 1; form.Pen.Style := psSolid;
      if not OVBuffer[Obj.ObjConstI[4]].Param[16] then
      begin // Проверить активизацию объекта
        form.Brush.Color := armcolor12; form.Pen.Color := armcolor12; form.Font.Color := armcolor12;
        case Obj.ObjConstI[1] of
          1 : begin
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-8)]);
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+8)]);
          end;
          2 : begin
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X-5,Obj.Points[2].Y-8)]);
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X-5,Obj.Points[2].Y+8)]);
          end;
        end;
      end else
      if OVBuffer[Obj.ObjConstI[4]].Param[1] then
      begin // Непарафазность стрелки
        form.Brush.Color := armcolor14; form.Pen.Color := armcolor14; form.Font.Color := armcolor14;
        case Obj.ObjConstI[1] of
          1 : begin
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-8)]);
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+8)]);
          end;
          2 : begin
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X-5,Obj.Points[2].Y-8)]);
            form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X-5,Obj.Points[2].Y+8)]);
          end;
        end;
      end else
      begin // Наличие макета на стрелке или МУ
        if OVBuffer[Obj.ObjConstI[4]].Param[4] then form.Font.Color := clBlack
        // Наличие контроля плюсового положения (башмак на сброс)
        else if OVBuffer[Obj.ObjConstI[4]].Param[2] and not OVBuffer[Obj.ObjConstI[4]].Param[3] then
        begin
          form.Font.Color := armcolor5; form.Brush.Color := armcolor1; form.Pen.Color := armcolor1;
          case Obj.ObjConstI[1] of
            1 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-8)]);
            end;
            2 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X-5,Obj.Points[2].Y-8)]);
            end;
          end;
        end
        // Наличие контроля минусового положения (башмак отведен)
        else if OVBuffer[Obj.ObjConstI[4]].Param[3] and not OVBuffer[Obj.ObjConstI[4]].Param[2] then
        begin
          form.Font.Color := armcolor7; form.Brush.Color := armcolor18; form.Pen.Color := armcolor8;
          case Obj.ObjConstI[1] of
            1 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+8)]);
            end;
            2 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X-5,Obj.Points[2].Y+8)]);
            end;
          end;
        end
        // Отсутствие контроля положения
        else
        begin
          form.Font.Color := armcolor4; form.Brush.Color := armcolor18; form.Pen.Color := armcolor1;
          case Obj.ObjConstI[1] of
            1 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-8)]);
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+8)]);
            end;
            2 : begin
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y-3),Point(Obj.Points[2].X+5,Obj.Points[2].Y-3),Point(Obj.Points[2].X-5,Obj.Points[2].Y-8)]);
              form.Polygon([Point(Obj.Points[2].X-5,Obj.Points[2].Y+3),Point(Obj.Points[2].X+5,Obj.Points[2].Y+3),Point(Obj.Points[2].X-5,Obj.Points[2].Y+8)]);
            end;
          end;
        end;
      end;

    // Нарисовать литер башмака
      form.Font.Size := 8; form.Font.Style := [fsBold]; form.Brush.Style := bsClear;
      if OVBuffer[Obj.ObjConstI[4]].Param[11] then
      begin // нажата кнопка вспомогательного перевода стрелки
        form.Pen.Color := armcolor9; form.Pen.Width := 1;
        x1 := form.TextWidth(Obj.Title)+2; y1 := form.TextHeight(Obj.Title);
        form.RoundRect(Obj.Points[1].X-1,Obj.Points[1].Y,Obj.Points[1].X+x1,Obj.Points[1].Y+y1,7,10);
      end;
      form.TextOut(Obj.Points[1].X,Obj.Points[1].Y,Obj.Title);
      form.Font.Style := [];

    // Ограничения на стрелку
      if OVBuffer[Obj.ObjConstI[4]].Param[32] then
      begin // Стрелка выключена из управления
        form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
        case Obj.ObjConstI[7] of
          1 : begin // вправо по горизонтали
            TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,3);
            form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
            form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          end;
          2 : begin // вниз по вертикали
            TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,3);
            form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
            form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title));
          end;
          3 : begin // вверх по вертикали
            TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,3);
            form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y);
            form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
          end;
        else // влево по горизонтали
          TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,3);
          form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        end;
      end;
      if OVBuffer[Obj.ObjConstI[4]].Param[30] then
      begin // Башмак закрыт для движения
        form.Brush.Color := armcolor4; form.Pen.Color := armcolor4; form.Pen.Width := 1; form.Pen.Style := psSolid;
        case Obj.ObjConstI[1] of
          1 : begin
            case Obj.ObjConstI[5] of
              1 : form.Polygon([Point(obj.Points[2].X-9,obj.Points[2].Y-5),
                                Point(obj.Points[2].X+2,obj.Points[2].Y-10),
                                Point(obj.Points[2].X+4,obj.Points[2].Y-6),
                                Point(obj.Points[2].X-7,obj.Points[2].Y-1)]);
              2 : form.Polygon([Point(obj.Points[2].X-7,obj.Points[2].Y+1),
                                Point(obj.Points[2].X+4,obj.Points[2].Y+6),
                                Point(obj.Points[2].X+2,obj.Points[2].Y+10),
                                Point(obj.Points[2].X-9,obj.Points[2].Y+5)]);
              else
                form.Polygon([Point(obj.Points[2].X-8,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-4,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-4,obj.Points[2].Y+7),
                              Point(obj.Points[2].X-8,obj.Points[2].Y+7)]);
              end;
          end;
        else
          case Obj.ObjConstI[5] of
            1 : form.Polygon([Point(obj.Points[2].X-4,obj.Points[2].Y-6),
                              Point(obj.Points[2].X-2,obj.Points[2].Y-10),
                              Point(obj.Points[2].X+9,obj.Points[2].Y-5),
                              Point(obj.Points[2].X+7,obj.Points[2].Y-1)]);
            2 : form.Polygon([Point(obj.Points[2].X+7,obj.Points[2].Y+1),
                              Point(obj.Points[2].X+9,obj.Points[2].Y+5),
                              Point(obj.Points[2].X-2,obj.Points[2].Y+10),
                              Point(obj.Points[2].X-4,obj.Points[2].Y+6)]);
          else
            form.Polygon([Point(obj.Points[2].X+4,obj.Points[2].Y-6),
                          Point(obj.Points[2].X+8,obj.Points[2].Y-6),
                          Point(obj.Points[2].X+8,obj.Points[2].Y+7),
                          Point(obj.Points[2].X+4,obj.Points[2].Y+7)]);
          end;
        end;
      end;
    end;


    20 : begin
    //************************
    //
    // Маневровый светофор
    //
    //************************
fix := 20;
      case obj.ObjConstI[2] of // Определить ориентацию светофора
        1 : begin // нога справа
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
          end;
          ptr[7].X := Obj.Points[1].X+2; ptr[7].Y := Obj.Points[1].Y-6;
        end;

      else // нога слева
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
          end;
          form.Font.Style := []; ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-2; ptr[7].Y := Obj.Points[1].Y-6;
      end;

      // нога светофора
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        form.Pen.Color := 0; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end;
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      if ptr[3].X > 0 then
      begin
        form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
      end;

      // сигнальная ячейка
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // открыт маневровым показанием
          if OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // есть поездное показание - неисправность
            if OVBuffer[Obj.ObjConstI[1]].Param[32] then
            begin // Погасить неисправность если заблокирован
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8; form.Brush.Style := bsSolid;
            end else
            begin
              if tab_page then
              begin
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor9; form.Brush.Style := bsSolid;
              end else
              begin
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor2; form.Brush.Style := bsSolid;
              end;
            end;
          end else
          begin // Открыт маневровый
            form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor9; form.Brush.Style := bsSolid;
          end;
        end else
        begin
          if OVBuffer[Obj.ObjConstI[1]].Param[6] then
          begin // Неисправность огневушки
            if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then
            begin // неисправность воспринята
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
            end else
            begin // не подтвержденная неисправность
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Style := bsSolid;
              if tab_page then form.Brush.Color := armcolor8 else form.Brush.Color := armcolor15;
            end;
          end else
          begin // сигнал закрыт
            form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8; form.Brush.Style := bsSolid;
          end;
        end;
      end;
      form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

      // Нарисовать литер
      x1 := -1;
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin // Включено автодействие сигнала
        x1 := 27;
      end;
      if x1 > -1 then
      begin // нарисовать иконку
        form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
        case Obj.ObjConstI[7] of
          1 : begin // вправо по горизонтали
            if Obj.ObjConstI[2] = 0 then
            begin
              if Obj.ObjConstI[3] = 1 then x2 := 16 else x2 := 13;
            end else
              x2 := form.TextWidth(obj.Title)+3;
            TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
            form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
            form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          end;
          2 : begin // вниз по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -1;
            end else
              x2 := form.TextWidth(obj.Title)+2;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
          end;
          3 : begin // вверх по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -1;
            end else
              x2 := form.TextWidth(obj.Title)+2;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
          end;
        else // влево по горизонтали
          if Obj.ObjConstI[2] = 1 then
          begin
            if Obj.ObjConstI[3] = 1 then x2 := 15 else x2 := 12 ;
          end else
            x2 := form.TextWidth(obj.Title)+2;
          TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
          form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        end;
      end;

      if not OVBuffer[obj.ObjConstI[1]].Param[16] or OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        form.Brush.Style := bsClear;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1
        else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then // МВС
        begin
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then // ВС
          begin
            if tab_page then form.Font.Color := armcolor9 else form.Font.Color := armcolor2;
          end else
            form.Font.Color := armcolor9;
        end else
          form.Font.Color := clBlack;
        if OVBuffer[Obj.ObjConstI[1]].Param[11] and (Obj.ObjConstI[6] = 0) then
        begin // признак маневровой противоповторки/маневрового начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor9;
        end else
        begin // нет начала или МПР
          form.Brush.Style := bsClear;
        end;
      end;
      form.Font.Size := 8; form.Font.Style := [];
      form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);
      if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
      begin
        x1 := form.TextWidth(Obj.Title); form.Font.Color := armcolor1;
        if Obj.ObjConstI[2] = 1 then // нога справа
          form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')
        else // нога слева
          form.TextOut((ptr[7].X)-2, ptr[7].Y, '!');
      end;
    end;


    21 : begin
    //**********************
    //
    // Совмещенный светофор
    //
    //**********************
fix := 21;
      case obj.ObjConstI[2] of // Определить ориентацию светофора
        1 : begin // нога справа
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
          end;
          ptr[7].X := Obj.Points[1].X+6; ptr[7].Y := Obj.Points[1].Y-6;
          ptr[8].X := Obj.Points[1].X+2; ptr[8].Y := Obj.Points[1].Y-5;
          ptr[9].X := Obj.Points[1].X+6; ptr[9].Y := Obj.Points[1].Y+6;
        end;

      else // нога слева
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
          end;
          form.Font.Style := []; ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-6; ptr[7].Y := Obj.Points[1].Y-6;
          ptr[8].X := Obj.Points[1].X-5; ptr[8].Y := Obj.Points[1].Y-5;
          ptr[9].X := Obj.Points[1].X-1; ptr[9].Y := Obj.Points[1].Y+6;
      end;

      // нога светофора
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        form.Pen.Color := 0; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end;
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      if ptr[3].X > 0 then
      begin
        form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
      end;

      // Нарисовать сигнальную ячейку
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] and OVBuffer[Obj.ObjConstI[1]].Param[5] then
        begin // Ошибка - открыт маневровым и поездным
          if OVBuffer[Obj.ObjConstI[1]].Param[32] then
          begin // светофор заблокирован - потушить ложную индикацию
            form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8; form.Brush.Style := bsSolid;
          end else
          begin // иначе мигать З/Б
            if tab_page then
            begin
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor9; form.Brush.Style := bsSolid
            end else
            begin
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor2; form.Brush.Style := bsSolid;
            end;
          end;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // открыт маневровым показанием
          form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor9; form.Brush.Style := bsSolid;
        end else
        begin
          if OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // открыт поездным показанием
            form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor2; form.Brush.Style := bsSolid;
          end else
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[6] then
            begin // Неисправность огневушки
              if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then
              begin // неисправность воспринята
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
              end else
              begin // не подтвержденная неисправность
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Style := bsSolid;
                if tab_page then form.Brush.Color := armcolor8 else form.Brush.Color := armcolor15;
              end;
            end else
            begin // сигнал закрыт
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8; form.Brush.Style := bsSolid;
            end;
          end;
        end;
      end;
      form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

      // Нарисовать признак неистравности СО, Кз
      form.Pen.Width := 1; form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нет дополнительных датчиков
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // неисправность дополнительных датчиков
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[9] then
      begin // реконфигурация - переход с зеленого на желтый Kz
        if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then form.Brush.Color := armcolor7 else
        if tab_page then form.Brush.Color := armcolor15 else form.Brush.Color := armcolor7;
        form.Pen.Color := form.Brush.Color;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin // неисправность разрешительного огня Co
        if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then form.Brush.Color := armcolor2 else
        if tab_page then form.Brush.Color := armcolor15 else form.Brush.Color := armcolor2;
        form.Pen.Color := form.Brush.Color;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end;

      // Нарисовать литер
      x1 := -1;
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin // Включено автодействие сигнала
        x1 := 27;
      end;
      if x1 > -1 then
      begin // нарисовать иконку
        form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
        case Obj.ObjConstI[7] of
          1 : begin // вправо по горизонтали
            if Obj.ObjConstI[2] = 0 then
            begin
              if Obj.ObjConstI[3] = 1 then x2 := 16 else x2 := 13;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
            form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
            form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          end;
          2 : begin // вниз по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -5;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
          end;
          3 : begin // вверх по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -5;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
          end;
        else // влево по горизонтали
          if Obj.ObjConstI[2] = 1 then
          begin
            if Obj.ObjConstI[3] = 1 then x2 := 15 else x2 := 12 ;
          end else
            x2 := form.TextWidth(obj.Title)+6;
          TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
          form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        end;
      end;

      if not OVBuffer[obj.ObjConstI[1]].Param[16] or OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        form.Brush.Style := bsClear;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
        // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1
        else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] and OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin // ошибка - одновременно есть МВС и ВС
          if tab_page then form.Font.Color := armcolor9 else form.Font.Color := armcolor2;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin
          form.Font.Color := armcolor9;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin
          form.Font.Color := armcolor2;
        end else
          form.Font.Color := clBlack;
        if OVBuffer[Obj.ObjConstI[1]].Param[11] and OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin // признак неверных данных противоповторки/начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor11;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[11] and (Obj.ObjConstI[6] = 0) then
        begin // признак маневровой противоповторки/маневрового начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor9;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[12] and (Obj.ObjConstI[6] = 0) then
        begin // признак поездной противоповторки/поездного начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor2;
        end else
        begin // нет начала или ПП
          form.Brush.Style := bsClear;
        end;
      end;
      form.Font.Size := 8; form.Font.Style := [];
      form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);
      if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
      begin
        x1 := form.TextWidth(Obj.Title); form.Font.Color := armcolor1;
        if Obj.ObjConstI[2] = 1 then // нога справа
          form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')
        else // нога слева
          form.TextOut((ptr[7].X)-2, ptr[7].Y, '!');
      end;
    end;


    22 : begin
    //******************
    //
    // Входной светофор
    //
    //******************
fix := 22;
      case obj.ObjConstI[2] of // Определить ориентацию светофора
        1 : begin // нога справа
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
          end;
          ptr[7].X := Obj.Points[1].X+6; ptr[7].Y := Obj.Points[1].Y-6;
          ptr[8].X := Obj.Points[1].X+2; ptr[8].Y := Obj.Points[1].Y-5;
          ptr[9].X := Obj.Points[1].X+6; ptr[9].Y := Obj.Points[1].Y+6;
        end;

      else // нога слева
          ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
          ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
          if obj.ObjConstI[3] = 0 then
          begin // карликовый
            ptr[3].X := 0; ptr[4].X := 0;
            ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
          end else
          begin // мачтовый
            ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
            ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
            ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
          end;
          form.Font.Style := []; ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-6; ptr[7].Y := Obj.Points[1].Y-6;
          ptr[8].X := Obj.Points[1].X-5; ptr[8].Y := Obj.Points[1].Y-5;
          ptr[9].X := Obj.Points[1].X-1; ptr[9].Y := Obj.Points[1].Y+6;
      end;


      // нога светофора
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[7] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[10] then
        begin // Авария шкафа
          if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then form.Pen.Color := armcolor1 else
          if tab_page then form.Pen.Color := 0 else form.Pen.Color := armcolor1;
          form.Pen.Width := 2;
        end else
        begin // Исправный светофор
          form.Pen.Color := 0; form.Pen.Width := 1;
        end;
        form.Pen.Style := psSolid; form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
      end;
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      if ptr[3].X > 0 then
      begin
        form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
      end;

      // Нарисовать сигнальную ячейку
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
        form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] and OVBuffer[Obj.ObjConstI[1]].Param[5] then
        begin // Ошибка - открыт маневровым и поездным
          form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor11; form.Brush.Style := bsSolid;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // открыт маневровым показанием
          form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor9; form.Brush.Style := bsSolid;
        end else
        begin
          if OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // открыт поездным показанием
            form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor2; form.Brush.Style := bsSolid;
          end else
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[6] then
            begin // Неисправность огневушки
              if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then
              begin // неисправность воспринята
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
              end else
              begin // не подтвержденная неисправность
                form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Style := bsSolid;
                if tab_page then form.Brush.Color := armcolor4 else form.Brush.Color := armcolor15;
              end;
            end else
            begin // сигнал закрыт
              form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor4; form.Brush.Style := bsSolid;
            end;
          end;
        end;
      end;
      form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

      // Нарисовать признак неистравности СО, Кз
      form.Pen.Width := 1; form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нет дополнительных датчиков
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // неисправность дополнительных датчиков
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[9] then
      begin // реконфигурация - переход с зеленого на желтый Kz
        if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then form.Brush.Color := armcolor7 else
        if tab_page then form.Brush.Color := armcolor15 else form.Brush.Color := armcolor7;
        form.Pen.Color := form.Brush.Color;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin // неисправность разрешительного огня Co
        if OVBuffer[Obj.ObjConstI[1]].Param[17] or not WorkMode.Upravlenie or not OVBuffer[obj.ObjConstI[1]].Param[18] then form.Brush.Color := armcolor2 else
        if tab_page then form.Brush.Color := armcolor15 else form.Brush.Color := armcolor2;
        form.Pen.Color := form.Brush.Color;
        form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
      end;

      // Нарисовать литер
      x1 := -1;
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin // Включено автодействие сигнала
        x1 := 27;
      end;
      if x1 > -1 then
      begin // нарисовать иконку
        form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
        case Obj.ObjConstI[7] of
          1 : begin // вправо по горизонтали
            if Obj.ObjConstI[2] = 0 then
            begin
              if Obj.ObjConstI[3] = 1 then x2 := 16 else x2 := 13;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
            form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
            form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          end;
          2 : begin // вниз по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -5;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
          end;
          3 : begin // вверх по вертикали
            if Obj.ObjConstI[2] = 1 then
            begin
              x2 := -5;
            end else
              x2 := form.TextWidth(obj.Title)+7;
            TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
            form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
            form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
          end;
        else // влево по горизонтали
          if Obj.ObjConstI[2] = 1 then
          begin
            if Obj.ObjConstI[3] = 1 then x2 := 15 else x2 := 12 ;
          end else
            x2 := form.TextWidth(obj.Title)+6;
          TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
          form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
          form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        end;
      end;

      if not OVBuffer[obj.ObjConstI[1]].Param[16] or OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1 else form.Font.Color := clBlack;
        form.Brush.Style := bsClear;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then
        // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1
        else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] and OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin // ошибка - одновременно есть МВС и ВС
          form.Font.Color := armcolor11;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin
          form.Font.Color := armcolor9;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin
          form.Font.Color := armcolor2;
        end else
          form.Font.Color := clBlack;
        if OVBuffer[Obj.ObjConstI[1]].Param[11] and OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin // признак неверных данных противоповторки/начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor11;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[11] and (Obj.ObjConstI[6] = 0) then
        begin // признак маневровой противоповторки/маневрового начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor9;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[12] and (Obj.ObjConstI[6] = 0) then
        begin // признак поездной противоповторки/поездного начала
          form.Brush.Style := bsSolid; form.Brush.Color := armcolor2;
        end else
        begin // нет начала или ПП
          form.Brush.Style := bsClear;
        end;
      end;
      form.Font.Size := 8; form.Font.Style := [];
      form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);
      if OVBuffer[Obj.ObjConstI[1]].Param[13] and OVBuffer[Obj.ObjConstI[1]].Param[18] and tab_page then
      begin
        x1 := form.TextWidth(Obj.Title); form.Font.Color := armcolor1;
        if Obj.ObjConstI[2] = 1 then // нога справа
          form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')
        else // нога слева
          form.TextOut((ptr[7].X)-2, ptr[7].Y, '!');
      end;
    end;


    23 : begin
    //************************
    //
    // Пригласительный сигнал
    //
    //************************
fix := 23;
      ptr[1].X := obj.Points[1].X-4; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X+6; ptr[2].Y := obj.Points[1].Y+5;
      ptr[3].X := obj.Points[1].X+6; ptr[3].Y := obj.Points[1].Y-5;
      ptr[4].X := obj.Points[1].X-4; ptr[4].Y := obj.Points[1].Y+5;
      ptr[5].X := obj.points[1].X-5; ptr[5].Y := obj.points[1].Y-5;
      ptr[6].X := obj.points[1].X+6; ptr[6].Y := obj.points[1].Y+6;
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
        form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
        form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
        exit;
      end else
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
        form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
        form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
        exit;
      end;

      // Нарисовать пригласительный сигнал
      x1 := Obj.ObjConstI[2]*2;
      if OVBuffer[Obj.ObjConstI[1]].Param[x1] then
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[x1+1] then
        begin
        // Неисправность ПС
          form.Pen.Color := armcolor9; form.Pen.Width := 2; form.Brush.Color := armcolor15;
          form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
        end else
        begin
        // Исправный ПС
          form.Pen.Color := 0; form.Pen.Width := 1;
          form.Brush.Color := armcolor9;
          form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
          form.Pen.Width := 2; form.Pen.Color := armcolor9;     
          form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
          form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
        end;
      end;
    end;


    24 : begin
    //***********************
    //
    // Повторитель светофора
    //
    //***********************
fix := 24;
      form.Font.Style := [];
      if OVBuffer[obj.ObjConstI[1]].Param[1] or not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin
        if not OVBuffer[obj.ObjConstI[1]].Param[16] then
        begin // непарафазность
          form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
          form.Brush.Color := armcolor12; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        end else
        begin // нецентрализованный
          form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
          form.Brush.Color := armcolor14; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        end;
        form.MoveTo(obj.Points[1].X,obj.Points[1].Y-4); form.LineTo(obj.Points[1].X,obj.Points[1].Y+5);
        if Obj.ObjConstI[2] = 0 then
        begin
          form.PolyGon([Point(obj.points[1].X+1,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y+5),Point(obj.points[1].X+11,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y-5)]);
        end else
        begin
          form.PolyGon([Point(obj.points[1].X,obj.points[1].Y),Point(obj.points[1].X-5,obj.points[1].Y+5),Point(obj.points[1].X-10,obj.points[1].Y),Point(obj.points[1].X-5,obj.points[1].Y-5)]);
        end;
        form.Font.Size := 8; form.Font.Color := clBlack; form.Brush.Color := armcolor15; form.font.Style := [];
        if obj.ObjConstI[2] = 0 then
        begin
          form.TextOut(Obj.Points[1].X-form.TextWidth(Obj.Title)-2, Obj.Points[1].Y-6, Obj.Title);
        end else
        begin
          form.TextOut(Obj.Points[1].X+2, Obj.Points[1].Y-6, Obj.Title);
        end;
        exit;
      end;

      // Нарисовать повторитель светофора
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // Неисправность
          form.Pen.Color := 0; form.Pen.Width := 2; form.Brush.Color := armcolor15;
        end else
        begin // Исправный
          form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor2;
        end;
      end else
      begin
        form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8;
      end;
      if Obj.ObjConstI[2] = 0 then
      begin
        form.PolyGon([Point(obj.points[1].X+1,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y+5),Point(obj.points[1].X+11,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y-5)]);
      end else
      begin
        form.PolyGon([Point(obj.points[1].X,obj.points[1].Y),Point(obj.points[1].X-5,obj.points[1].Y+5),Point(obj.points[1].X-10,obj.points[1].Y),Point(obj.points[1].X-5,obj.points[1].Y-5)]);
      end;

      form.Pen.Width := 1;
      form.MoveTo(obj.Points[1].X,obj.Points[1].Y-4); form.LineTo(obj.Points[1].X,obj.Points[1].Y+5);

      form.Font.Size := 8; form.Font.Color := clBlack; form.Brush.Color := armcolor15;
      if obj.ObjConstI[2] = 0 then
      begin
        form.TextOut(Obj.Points[1].X-form.TextWidth(Obj.Title)-2, Obj.Points[1].Y-6, Obj.Title);
      end else
      begin
        form.TextOut(Obj.Points[1].X+2, Obj.Points[1].Y-6, Obj.Title);
      end;
    end;


    25 : begin
    //***************************
    //
    // Фиктивный сигнал (увязка)
    //
    //***************************
fix := 25;
      if OVBuffer[obj.ObjConstI[1]].Param[1] or not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin
        if not OVBuffer[obj.ObjConstI[1]].Param[16] then
        begin // непарафазность
          form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
          form.Brush.Color := armcolor12; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        end else
        begin // нецентрализованный
          form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
          form.Brush.Color := armcolor14; form.Brush.Style := bsSolid; form.Pen.Width := 1;
        end;
        if Obj.ObjConstI[2] = 0 then
        begin
          form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),Point(obj.points[1].X+6,obj.points[1].Y-4),Point(obj.points[1].X+10,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y+4),Point(obj.points[1].X,obj.points[1].Y+4)]);
        end else
        begin
          form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),Point(obj.points[1].X-6,obj.points[1].Y-4),Point(obj.points[1].X-10,obj.points[1].Y),Point(obj.points[1].X-6,obj.points[1].Y+4),Point(obj.points[1].X,obj.points[1].Y+4)]);
        end;
        exit;
      end;

      // Нарисовать фиктивный сигнал
      form.Pen.Width := 1;
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin // C
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // есть МС- неисправность
          if OVBuffer[Obj.ObjConstI[1]].Param[32] then
          begin // есть блокировка - серый!
            form.Pen.Color := 0; form.Brush.Color := armcolor8;
          end else
          begin
            if tab_page then
            begin
              form.Pen.Color := 0; form.Brush.Color := armcolor9;
            end else
            begin
              form.Pen.Color := 0; form.Brush.Color := armcolor2;
            end;
          end;
        end else
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor2;
        end;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin // ВС
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin // есть МВС- неисправность
          if OVBuffer[Obj.ObjConstI[1]].Param[32] then
          begin // есть блокировка - серый!
            form.Pen.Color := 0; form.Brush.Color := armcolor8;
          end else
          begin
            if tab_page then
            begin
              form.Pen.Color := 0; form.Brush.Color := armcolor9;
            end else
            begin
              form.Pen.Color := 0; form.Brush.Color := armcolor7;
            end;
          end;
        end else
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor7;
        end;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[12] and (Obj.ObjConstI[6] = 0) then
      begin // противоповторка
        form.Pen.Color := 0; form.Brush.Color := armcolor9;
      end else
      begin
        form.Pen.Color := 0; form.Brush.Color := armcolor8;
      end;
      if Obj.ObjConstI[2] = 0 then
      begin
        form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),Point(obj.points[1].X+6,obj.points[1].Y-4),Point(obj.points[1].X+10,obj.points[1].Y),Point(obj.points[1].X+6,obj.points[1].Y+4),Point(obj.points[1].X,obj.points[1].Y+4)]);
      end else
      begin
        form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),Point(obj.points[1].X-6,obj.points[1].Y-4),Point(obj.points[1].X-10,obj.points[1].Y),Point(obj.points[1].X-6,obj.points[1].Y+4),Point(obj.points[1].X,obj.points[1].Y+4)]);
      end;
    end;


    50 : begin
    //*****************
    //
    // Ограждение пути
    //
    //*****************
fix := 50;
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Pen.Width := 2;
        form.MoveTo(obj.Points[2].X+3,obj.Points[2].Y-4);
        form.LineTo(obj.Points[2].X,obj.Points[2].Y-4);
        form.LineTo(obj.Points[2].X,obj.Points[2].Y+4);
        form.LineTo(obj.Points[2].X+3,obj.Points[2].Y+4);
        form.MoveTo(obj.Points[3].X-4,obj.Points[3].Y-4);
        form.LineTo(obj.Points[3].X,obj.Points[3].Y-4);
        form.LineTo(obj.Points[3].X,obj.Points[3].Y+4);
        form.LineTo(obj.Points[3].X-4,obj.Points[3].Y+4);
        exit;
      end;
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Pen.Width := 2;
        form.MoveTo(obj.Points[2].X+3,obj.Points[2].Y-4);
        form.LineTo(obj.Points[2].X,obj.Points[2].Y-4);
        form.LineTo(obj.Points[2].X,obj.Points[2].Y+4);
        form.LineTo(obj.Points[2].X+3,obj.Points[2].Y+4);
        form.MoveTo(obj.Points[3].X-4,obj.Points[3].Y-4);
        form.LineTo(obj.Points[3].X,obj.Points[3].Y-4);
        form.LineTo(obj.Points[3].X,obj.Points[3].Y+4);
        form.LineTo(obj.Points[3].X-4,obj.Points[3].Y+4);
        exit;
      end;

      // Нарисовать ОГ
      if Obj.ObjConstI[6] = 0 then
      begin // свой
        if OVBuffer[Obj.ObjConstI[1]].Param[8] then
        begin // запрос на ограждение
          if OVBuffer[Obj.ObjConstI[1]].Param[7] then
          begin // установлено ограждение
            form.Pen.Color := armcolor1; form.Pen.Width := 2;
          end else
          begin // только запрос
            form.Pen.Color := armcolor7; form.Pen.Width := 2;
          end;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // установлено ограждение без запроса
          if OVBuffer[Obj.ObjConstI[1]].Param[6] or not WorkMode.Upravlenie then
          begin // неисправность воспринята или нет управления
            form.Pen.Color := armcolor11; form.Pen.Width := 2;
          end else
          if tab_page then exit else
          begin
            form.Pen.Color := armcolor11; form.Pen.Width := 2;
          end;
        end else
          exit;
      end else
      begin // чужой
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // установлено ограждение
          form.Pen.Color := armcolor1; form.Pen.Width := 2;
        end else
          exit;
      end;
      form.MoveTo(obj.Points[2].X+3,obj.Points[2].Y-4);
      form.LineTo(obj.Points[2].X,obj.Points[2].Y-4);
      form.LineTo(obj.Points[2].X,obj.Points[2].Y+4);
      form.LineTo(obj.Points[2].X+3,obj.Points[2].Y+4);
      form.MoveTo(obj.Points[3].X-4,obj.Points[3].Y-4);
      form.LineTo(obj.Points[3].X,obj.Points[3].Y-4);
      form.LineTo(obj.Points[3].X,obj.Points[3].Y+4);
      form.LineTo(obj.Points[3].X-4,obj.Points[3].Y+4);
    end;


    51 : begin
    //*****************
    //
    //       УТС
    //
    //*****************
fix := 51;
      if not OVBuffer[obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Pen.Width   := 1;
        if obj.ObjConstI[2] = 1 then
          form.Polygon([Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X-7,obj.Points[1].Y-11),
                        Point(obj.Points[1].X-2,obj.Points[1].Y-6)])
        else
          form.Polygon([Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X+7,obj.Points[1].Y-11),
                        Point(obj.Points[1].X+2,obj.Points[1].Y-6)]);
        exit;
      end;
      if OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor14; form.Pen.Width := 1;
        if obj.ObjConstI[2] = 1 then
          form.Polygon([Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X-7,obj.Points[1].Y-11),
                        Point(obj.Points[1].X-2,obj.Points[1].Y-6)])
        else
          form.Polygon([Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X+7,obj.Points[1].Y-11),
                        Point(obj.Points[1].X+2,obj.Points[1].Y-6)]);
        exit;
      end;

      // Нарисовать УТС
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin // есть блокировка упора
        TabloMain.ImageList.Draw(form,obj.Points[1].X-6,obj.Points[1].Y-20,1,true);
      end;

      form.Pen.Color := 0; form.Pen.Style := psSolid; form.Pen.Width := 1;
      if OVBuffer[Obj.ObjConstI[1]].Param[2] and not OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin // Упор не установлен
        form.Brush.Color := armcolor8;
        if obj.ObjConstI[2] = 1 then
          form.Polygon([Point(obj.Points[1].X+7,obj.Points[1].Y-2), Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X-7,obj.Points[1].Y-11), Point(obj.Points[1].X-2,obj.Points[1].Y-6)])
        else
          form.Polygon([Point(obj.Points[1].X-7,obj.Points[1].Y-2), Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                        Point(obj.Points[1].X+7,obj.Points[1].Y-11), Point(obj.Points[1].X+2,obj.Points[1].Y-6)]);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[3] and not OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // Упор установлен
        form.Brush.Color := armcolor7;
        if obj.ObjConstI[2] = 1 then
          form.Polygon([Point(obj.Points[1].X+7,obj.Points[1].Y-2), Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                      Point(obj.Points[1].X-7,obj.Points[1].Y-11), Point(obj.Points[1].X-2,obj.Points[1].Y-6)])
        else
          form.Polygon([Point(obj.Points[1].X-7,obj.Points[1].Y-2), Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                      Point(obj.Points[1].X+7,obj.Points[1].Y-11), Point(obj.Points[1].X+2,obj.Points[1].Y-6)]);
      end else
      begin // Упор без контроля положения
        form.Brush.Color := armcolor1;
        if obj.ObjConstI[2] = 1 then
          form.Polygon([Point(obj.Points[1].X+7,obj.Points[1].Y-2), Point(obj.Points[1].X-7,obj.Points[1].Y-2),
                      Point(obj.Points[1].X-7,obj.Points[1].Y-11), Point(obj.Points[1].X-2,obj.Points[1].Y-6)])
        else
          form.Polygon([Point(obj.Points[1].X-7,obj.Points[1].Y-2), Point(obj.Points[1].X+7,obj.Points[1].Y-2),
                      Point(obj.Points[1].X+7,obj.Points[1].Y-11), Point(obj.Points[1].X+2,obj.Points[1].Y-6)]);
      end;
    end;


    52 : begin
    //****************************************
    //
    //                 УКСПС
    //
    //****************************************
fix := 52;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
        form.Brush.Color := armcolor12; form.Pen.Width := 1;
        form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
        form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
        exit;
      end;
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := GetPenStyle(0);
        form.Brush.Color := armcolor14; form.Pen.Width := 3;
        form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
        form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
        exit;
      end;

      if OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // Выдана предварительная команда выключения из зависимостей
        form.Pen.Color := armcolor9; form.Pen.Width := 1; form.Brush.Color := armcolor9;
        form.Rectangle(obj.Points[1].X-7,obj.Points[1].Y-11,obj.Points[1].X+7,obj.Points[1].Y-1);
      end;

      if obj.ObjConstI[2] = 1 then
      begin // первый датчик
        if (Obj.ObjConstI[3] = 1) and OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // зависимая индикация при неисправности ближней точки
          form.Pen.Width := 1; form.Pen.Color := 0; form.Brush.Color := armcolor8;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[5] then
        begin // выключен из зависимостей
          if OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin // неисправность датчика
            form.Pen.Width := 2; form.Pen.Color := armcolor1; form.Brush.Color := armcolor7;
          end else
          begin // датчик исправен
            form.Pen.Width := 1; form.Pen.Color := 0; form.Brush.Color := armcolor7;
          end;
        end else
        begin // включен в зависимости
          form.Pen.Width := 1; form.Pen.Color := 0;
          if OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin // неисправность датчика
            form.Brush.Color := armcolor1;
          end else
          begin // датчик исправен
            form.Brush.Color := armcolor2;
          end;
        end;
        form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
      end else
      begin // второй датчик
        if OVBuffer[Obj.ObjConstI[1]].Param[5] then
        begin // выключен из зависимостей
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin // неисправность датчика
            form.Pen.Width := 2; form.Pen.Color := armcolor1; form.Brush.Color := armcolor7;
          end else
          begin // датчик исправен
            form.Pen.Width := 1; form.Pen.Color := 0; form.Brush.Color := armcolor7;
          end;
        end else
        begin // включен в зависимости
          form.Pen.Width := 1; form.Pen.Color := 0;
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin // неисправность датчика
            form.Brush.Color := armcolor1;
          end else
          begin // датчик исправен
            form.Brush.Color := armcolor2;
          end;
        end;
        form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
      end;

      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin // Неисправность линии
        form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor1;
        form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
      end else
      begin // Линия исправна
        form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8;
        form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
      end;

    end;


    53 : begin
    //******************************************************
    //
    // Отображение охранного положения сбрасывающей стрелки
    //
    //******************************************************
fix := 53;
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin // Охранное положение сбрасывающей стрелки
        form.Brush.Color := armcolor1; form.Pen.Color := armcolor1; form.Pen.Width := 1;
        form.Polygon([obj.Points[1],obj.Points[2],obj.Points[3],obj.Points[4]]);
      end;
    end;


    54 : begin
    //**************************
    //
    // Двухцветная лампа/кнопка
    //
    //**************************
fix := 54;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // отсутствие информации
        form.Brush.Color := armcolor8; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность датчиков
        form.Brush.Color := armcolor14; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then
      begin // Лампа включена
        form.Brush.Color := GetColor(Obj.ObjConstI[5]); form.Pen.Color := GetColor(Obj.ObjConstI[6]);
        form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[6]);
      end else
      begin // Лампа выключена
        form.Brush.Color := GetColor(Obj.ObjConstI[3]); form.Pen.Color := GetColor(Obj.ObjConstI[4]);
        form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[4]);
      end;
      case Obj.ObjConstI[7] of
        1: form.Polygon([Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X+26,obj.Points[1].Y), Point(obj.Points[1].X+20,obj.Points[1].Y+6), Point(obj.Points[1].X-20,obj.Points[1].Y+6)]);
        2: form.Polygon([Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X-26,obj.Points[1].Y), Point(obj.Points[1].X-20,obj.Points[1].Y+6), Point(obj.Points[1].X+20,obj.Points[1].Y+6)]);
        3: begin
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
          form.Rectangle(obj.Points[1].X-19,obj.Points[1].Y-5,obj.Points[1].X+19,obj.Points[1].Y+6);
          form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+19,obj.Points[1].Y-6);
          form.LineTo(obj.Points[1].X-20,obj.Points[1].Y-6);
          form.LineTo(obj.Points[1].X-20,obj.Points[1].Y+6);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-19,obj.Points[1].Y+6);
          form.LineTo(obj.Points[1].X+20,obj.Points[1].Y+6);
          form.LineTo(obj.Points[1].X+20,obj.Points[1].Y-6);
        end;
        4: begin
          form.Polygon([Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X+26,obj.Points[1].Y), Point(obj.Points[1].X+20,obj.Points[1].Y+6), Point(obj.Points[1].X-20,obj.Points[1].Y+6)]);
          form.Rectangle(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7);
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+20,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y+6);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-20,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+27,obj.Points[1].Y);
        end;
        5: begin
          form.Polygon([Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X-26,obj.Points[1].Y), Point(obj.Points[1].X-20,obj.Points[1].Y+6), Point(obj.Points[1].X+20,obj.Points[1].Y+6)]);
          form.Rectangle(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7);
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+20,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-27,obj.Points[1].Y);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-20,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y-6);
        end;
      else
        form.RoundRect(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7, 4,30);
      end;
      form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8;
      x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
      form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
    end;


    55 : begin
    //**************************
    //
    // Трехцветная лампа/кнопка
    //
    //**************************
fix := 55;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // отсутствие информации
        form.Brush.Color := armcolor8; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность датчиков
        form.Brush.Color := armcolor14; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      begin
        x1 := 0;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
        case x1 of
          1 : form.Brush.Color := GetColor(Obj.ObjConstI[7]);
          2 : form.Brush.Color := GetColor(Obj.ObjConstI[8]);
          3 : form.Brush.Color := GetColor(Obj.ObjConstI[9]);
        else // Лампа выключена
          form.Brush.Color := GetColor(Obj.ObjConstI[5]);
        end;
        if x1 > 0 then
        begin
          form.Pen.Color := GetColor(Obj.ObjConstI[6]); form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[6]);
        end else
        begin
          form.Pen.Color := GetColor(Obj.ObjConstI[4]); form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[4]);
        end;
      end;
      case Obj.ObjConstI[10] of
        1: form.Polygon([Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X+26,obj.Points[1].Y), Point(obj.Points[1].X+20,obj.Points[1].Y+6), Point(obj.Points[1].X-20,obj.Points[1].Y+6)]);
        2: form.Polygon([Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X-26,obj.Points[1].Y), Point(obj.Points[1].X-20,obj.Points[1].Y+6), Point(obj.Points[1].X+20,obj.Points[1].Y+6)]);
        3: begin // Кнопка
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
          form.Rectangle(obj.Points[1].X-19,obj.Points[1].Y-5,obj.Points[1].X+19,obj.Points[1].Y+6);
          form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+19,obj.Points[1].Y-6);
          form.LineTo(obj.Points[1].X-20,obj.Points[1].Y-6);
          form.LineTo(obj.Points[1].X-20,obj.Points[1].Y+6);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-19,obj.Points[1].Y+6);
          form.LineTo(obj.Points[1].X+20,obj.Points[1].Y+6);
          form.LineTo(obj.Points[1].X+20,obj.Points[1].Y-6);
        end;
        4: begin // стрелка влево
          form.Polygon([Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X+26,obj.Points[1].Y), Point(obj.Points[1].X+20,obj.Points[1].Y+6), Point(obj.Points[1].X-20,obj.Points[1].Y+6)]);
          form.Rectangle(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7);
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+20,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y+6);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-20,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+27,obj.Points[1].Y);
        end;
        5: begin // стрелка вправо
          form.Polygon([Point(obj.Points[1].X+20,obj.Points[1].Y-6), Point(obj.Points[1].X-20,obj.Points[1].Y-6), Point(obj.Points[1].X-26,obj.Points[1].Y), Point(obj.Points[1].X-20,obj.Points[1].Y+6), Point(obj.Points[1].X+20,obj.Points[1].Y+6)]);
          form.Rectangle(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7);
          form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
          form.MoveTo(obj.Points[1].X+20,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-21,obj.Points[1].Y-7);
          form.LineTo(obj.Points[1].X-27,obj.Points[1].Y);
          form.Pen.Color := armcolor17;
          form.MoveTo(obj.Points[1].X-20,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y+7);
          form.LineTo(obj.Points[1].X+21,obj.Points[1].Y-6);
        end;
        6: begin // Рупор
          form.Polygon([Point(obj.Points[1].X+8,obj.Points[1].Y-7), Point(obj.Points[1].X+7,obj.Points[1].Y), Point(obj.Points[1].X+8,obj.Points[1].Y+7), Point(obj.Points[1].X,obj.Points[1].Y+5), Point(obj.Points[1].X-8,obj.Points[1].Y+7), Point(obj.Points[1].X-7,obj.Points[1].Y), Point(obj.Points[1].X-8,obj.Points[1].Y-7), Point(obj.Points[1].X,obj.Points[1].Y-5)]);
        end;
      else
        form.RoundRect(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7, 4,30);
      end;
      form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8;
      x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
      form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
    end;


    56 : begin
    //*********************
    //
    // Трехцветная надпись
    //
    //*********************
fix := 56;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нет датчиков
        form.Font.Color := armcolor8;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность датчиков
        form.Font.Color := armcolor14;
      end else
      begin
        x1 := 0;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
        case x1 of
          1 : form.Font.Color := GetColor(Obj.ObjConstI[5]);
          2 : form.Font.Color := GetColor(Obj.ObjConstI[6]);
          3 : form.Font.Color := GetColor(Obj.ObjConstI[7]);
        else // Надпись выключена
          form.Font.Color := GetColor(Obj.ObjConstI[4]);
        end;
      end;
      form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8;
      x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
      form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
    end;


    57 : begin
    //************************************************
    //
    // Дополнительный (3) известитель автоблокировки
    //
    //************************************************
fix := 57;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if Obj.ObjConstI[2] = 0 then
      begin // индикация включена постоянно
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin // участок приближения свободен
          form.Pen.Width := 3; form.Pen.Color := armcolor7;
        end else
        begin // участок приближения занят
          form.Pen.Width := 3; form.Pen.Color := armcolor1;
        end;
      end else
      begin // индикация подключается выбором комплекта
        if not OVBuffer[Obj.ObjConstI[1]].Param[10] then
        begin // участок отключен
          form.Pen.Width := 1; form.Pen.Color := 0;
        end else
        if not OVBuffer[Obj.ObjConstI[1]].Param[7] then // участок подключается при отправлении
        begin // участок отключен
          form.Pen.Width := 1; form.Pen.Color := 0;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin // участок приближения свободен
          form.Pen.Width := 3; form.Pen.Color := armcolor7;
        end else
        begin // участок приближения занят
          form.Pen.Width := 3; form.Pen.Color := armcolor1;
        end;
      end;
      form.MoveTo(obj.Points[1].X,obj.Points[1].Y); form.LineTo(obj.Points[1].X+22,obj.Points[1].Y);
    end;

    58: begin
    //*************************************************************
    //
    // нарисовать управляемый контур многоугольника
    //
    //*************************************************************
fix := 58;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // отсутствие информации
        form.Pen.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность датчиков
        form.Pen.Color := armcolor14;
      end else
      begin
        x1 := 0;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
        case x1 of
          1 : form.Pen.Color := GetColor(Obj.ObjConstI[7]);
          2 : form.Pen.Color := GetColor(Obj.ObjConstI[8]);
          3 : form.Pen.Color := GetColor(Obj.ObjConstI[9]);
        else // Лампа выключена
          form.Pen.Color := GetColor(Obj.ObjConstI[5]);
        end;
      end;
      form.Pen.Style := psDashDotDot; form.Pen.Width := 1; form.Brush.Style := bsClear;
      if Obj.Points[1].X > 0 then
      begin
        form.MoveTo(Obj.Points[1].X,Obj.Points[1].Y);
        if Obj.Points[2].X > 0 then form.LineTo(Obj.Points[2].X,Obj.Points[2].Y);
        if Obj.Points[3].X > 0 then form.LineTo(Obj.Points[3].X,Obj.Points[3].Y);
        if Obj.Points[4].X > 0 then form.LineTo(Obj.Points[4].X,Obj.Points[4].Y);
        if Obj.Points[5].X > 0 then form.LineTo(Obj.Points[5].X,Obj.Points[5].Y);
        if Obj.Points[6].X > 0 then form.LineTo(Obj.Points[6].X,Obj.Points[6].Y);
        form.LineTo(Obj.Points[1].X,Obj.Points[1].Y);
      end;
    end;


    59 : begin
    //*********************
    //
    // Счетчик времени
    //
    //*********************
fix := 59;
      if Obj.ObjConstI[1] > 0 then
      begin
        case Obj.ObjConstI[2] of
          1 : begin // графический образ обратного отсчета
            x1 := Timer[Obj.ObjConstI[1]] - 1;
            if x1 > -1 then
            begin
              x2 := (Obj.ObjConstI[3] - x1) * 24 div Obj.ObjConstI[3]; if x2 < 0 then x2 := 0;
              TabloMain.ilClock.Draw(form,obj.Points[1].X,obj.Points[1].Y,x2);
            end;
          end;
        else
        // числовое отображение интервала
          if Timer[Obj.ObjConstI[1]] > 0 then
          begin
            sLbl := IntToStr(Timer[Obj.ObjConstI[1]]);
            form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8; form.Font.Color := clBlack;
            x1 := form.TextWidth(sLbl) div 2; y1 := form.TextHeight(sLbl) div 2;
            form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,sLbl);
          end;
        end;
      end;
    end;


    60 : begin
    //***************************************************
    //
    // Двухцветная лампа контроля дополнительных датчиков
    //
    //***************************************************
fix := 60;
      if not OVBuffer[Obj.ObjConstI[1]].ParamA[Obj.ObjConstI[2]] then
      begin // отсутствие информации
        form.Brush.Color := armcolor8; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].ParamN[Obj.ObjConstI[2]] then
      begin // непарафазность датчиков
        form.Brush.Color := armcolor14; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then
      begin // Лампа включена
        form.Brush.Color := GetColor(Obj.ObjConstI[5]); form.Pen.Color := GetColor(Obj.ObjConstI[6]); form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[6]);
      end else
      begin // Лампа выключена
        form.Brush.Color := GetColor(Obj.ObjConstI[3]); form.Pen.Color := GetColor(Obj.ObjConstI[4]); form.Pen.Width := 1; form.Font.Color := GetColor(Obj.ObjConstI[4]);
      end;

      form.RoundRect(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7, 4,30);
      form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8;
      x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
      form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
    end;


    70 : begin
    //********************
    //
    // Питающая установка
    //
    //********************
fix := 70;
      case Obj.ObjConstI[2] of
        0 : begin // для крупной станции - 2кф
          form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack; form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[5] then // Питание ЭЦ от 1-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 1-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 1-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+40,obj.Points[1].Y+13, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y,'К1Ф');

          form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[6] then // Питание ЭЦ от 2-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 2-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 2-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y+20,obj.Points[1].X+40,obj.Points[1].Y+33, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+20,'К2Ф');

          form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then // ДГА включен
            form.Brush.Color := armcolor2
          else
          begin // ДГА выключен
            form.Brush.Color := armcolor15; form.Pen.Color := armcolor8; form.Font.Color := armcolor8;
          end;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y+40,obj.Points[1].X+40,obj.Points[1].Y+53, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+40,'ДГА');
        end;
        1 : begin // для малой станции - 1кф
          form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack; form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[5] then // Питание ЭЦ от 1-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 1-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 1-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+40,obj.Points[1].Y+13, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y,'К1Ф');

          form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin
            if not OVBuffer[Obj.ObjConstI[1]].Param[5] then // Питание ЭЦ от 2-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 2-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 2-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y+20,obj.Points[1].X+40,obj.Points[1].Y+33, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+20,'К2Ф');

          form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then // ДГА включен
            form.Brush.Color := armcolor2
          else
          begin // ДГА выключен
            form.Brush.Color := armcolor15; form.Pen.Color := armcolor8; form.Font.Color := armcolor8;
          end;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y+40,obj.Points[1].X+40,obj.Points[1].Y+53, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+40,'ДГА');
        end;
      else // для малой станции - 1кф нет ДГА
          form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack; form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[5] then // Питание ЭЦ от 1-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 1-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 1-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+40,obj.Points[1].Y+13, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y,'К1Ф');

          form.Brush.Style := bsSolid;
          if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
          begin // активизация датчиков
            form.Brush.Color := armcolor8;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[1] then
          begin // непарафазность датчиков
            form.Brush.Color := armcolor14;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin
            if not OVBuffer[Obj.ObjConstI[1]].Param[5] then // Питание ЭЦ от 2-го фидера
              form.Brush.Color := armcolor2
            else // Есть напряжение на 2-ом фидере
              form.Brush.Color := armcolor7;
          end else // Нет напряжения на 2-ом фидере
            form.Brush.Color := armcolor1;
          form.RoundRect(obj.Points[1].X,obj.Points[1].Y+20,obj.Points[1].X+40,obj.Points[1].Y+33, 4,30);
          form.Brush.Style := bsClear; form.Font.Style := [];
          form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+20,'К2Ф');
      end;
    end;

    71: begin
    //************************************
    //
    // нарисовать графическую кнопку
    //
    //************************************
fix := 71;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then x1 := 5 else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then x1 := 4 else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1 else x1 := 0;
        if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
      end;
      x1 := Obj.ObjConstI[x1+4];
      if (x1 < 0) or (x1 > (TabloMain.ImageList32.Count-1)) then x1 := 0;
      TabloMain.ImageList32.Draw(form,obj.Points[1].X,obj.Points[1].Y,x1);
    end;


    30 : begin
    //*******************
    //
    // Контроль переезда
    //
    //*******************
fix := 30;
      form.Pen.Color := 0; form.Pen.Width := 1;
      form.MoveTo(obj.Points[1].X-6,obj.Points[1].Y); form.LineTo(obj.Points[1].X-13,obj.Points[1].Y);
      form.MoveTo(obj.Points[1].X-9,obj.Points[1].Y); form.LineTo(obj.Points[1].X-9,obj.Points[1].Y+10);
      if Obj.ObjConstI[2] = 0 then form.LineTo(obj.Points[1].X,obj.Points[1].Y+14);
      form.MoveTo(obj.Points[2].X+5,obj.Points[2].Y); form.LineTo(obj.Points[2].X+12,obj.Points[2].Y);
      form.MoveTo(obj.Points[2].X+8,obj.Points[2].Y); form.LineTo(obj.Points[2].X+8,obj.Points[2].Y-10);
      if Obj.ObjConstI[2] = 0 then form.LineTo(obj.Points[2].X,obj.Points[2].Y-14);

    // Неисправность или авария на переезде
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin  // есть авария
        form.Pen.Color := armcolor4; form.Pen.Width := 2;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin  // есть неисправность
        form.Pen.Color := armcolor7; form.Pen.Width := 2;
      end else
      begin
        form.Pen.Color := 0; form.Pen.Width := 1;
      end;
      form.MoveTo(obj.Points[1].X,obj.Points[1].Y); form.LineTo(obj.Points[1].X+5,obj.Points[1].Y+5); form.LineTo(obj.Points[1].X+5,obj.Points[2].Y-5); form.LineTo(obj.Points[1].X,obj.Points[2].Y);
      form.MoveTo(obj.Points[2].X,obj.Points[1].Y); form.LineTo(obj.Points[2].X-5,obj.Points[1].Y+5); form.LineTo(obj.Points[2].X-5,obj.Points[2].Y-5); form.LineTo(obj.Points[2].X,obj.Points[2].Y);

    // Извещение на переезд
      form.Pen.Style := psSolid; form.Pen.Width := 1;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin  // есть извещение
        form.Brush.Color := armcolor9; form.Pen.Color := 0; form.Pen.Width := 1;
      end else
      begin  // нет извещения
        form.Brush.Color := armcolor8; form.Pen.Color := 0; form.Pen.Width := 1;
      end;
      form.Ellipse(obj.Points[1].X,obj.Points[1].Y+2,obj.Points[1].X-8,obj.Points[1].Y+10);
      form.Ellipse(obj.Points[1].X-9,obj.Points[1].Y+2,obj.Points[1].X-17,obj.Points[1].Y+10);
      form.Ellipse(obj.Points[2].X,obj.Points[2].Y-2,obj.Points[2].X+8,obj.Points[2].Y-10);
      form.Ellipse(obj.Points[2].X+9,obj.Points[2].Y-2,obj.Points[2].X+17,obj.Points[2].Y-10);

    // закрытие переезда
      form.Pen.Style := psSolid;
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin  // есть контроль закрытия
        if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
        begin // нецентрализованный
          form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[1] then
        begin // непарафазность
          form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
        end else
          form.Pen.Color := armcolor4; form.Pen.Width := 3;
        form.MoveTo(obj.Points[1].X+5,obj.Points[1].Y); form.LineTo(obj.Points[2].X-6,obj.Points[1].Y);
        form.MoveTo(obj.Points[1].X+5,obj.Points[2].Y); form.LineTo(obj.Points[2].X-6,obj.Points[2].Y);
      end;

    // включение зГ на переезде
      form.Pen.Style := psSolid;
      if OVBuffer[Obj.ObjConstI[1]].Param[9] then
      begin  // есть зГ
        if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
        begin // нецентрализованный
          form.Pen.Color := armcolor12; 
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[1] then
        begin // непарафазность
          form.Pen.Color := armcolor14;
        end else
          form.Pen.Color := armcolor1;
        form.Brush.Color := form.Pen.Color; form.Pen.Width := 1; form.Brush.Style := bsSolid;
        form.FillRect(rect(obj.Points[1].X+7,obj.Points[1].Y+15,obj.Points[2].X-7,obj.Points[2].Y-15));
      end;
    end;


    31 : begin
    //******************************************************************
    //
    // Увязка с автоблокировкой без проходных сигналов и одним участком
    //
    //******************************************************************
fix := 31;
      case Obj.ObjConstI[2] of
        0 : // привязка слева снизу
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-25; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-26; ptr[3].Y := obj.Points[1].Y+5;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y+5;
          ptr[5].X := obj.Points[1].X-36; ptr[5].Y := obj.Points[1].Y-10;
          ptr[6].X := obj.Points[1].X-36; ptr[6].Y := obj.Points[1].Y+1;
          ptr[7].X := obj.Points[1].X-36; ptr[7].Y := obj.Points[1].Y-10;
          ptr[8].X := obj.Points[1].X-47; ptr[8].Y := obj.Points[1].Y+1;
          ptr[9].X := obj.Points[1].X-27; ptr[9].Y := obj.Points[1].Y-17;
          ptr[10].X := obj.Points[1].X-21; ptr[10].Y := obj.Points[1].Y-24;
          ptr[11].X := obj.Points[1].X-21; ptr[11].Y := obj.Points[1].Y-14;
          ptr[12].X := obj.Points[1].X-14; ptr[12].Y := obj.Points[1].Y-21;
          ptr[13].X := obj.Points[1].X-21; ptr[13].Y := obj.Points[1].Y-28;
          ptr[14].X := obj.Points[1].X-34; ptr[14].Y := obj.Points[1].Y-17;
          ptr[15].X := obj.Points[1].X-40; ptr[15].Y := obj.Points[1].Y-24;
          ptr[16].X := obj.Points[1].X-41; ptr[16].Y := obj.Points[1].Y-14;
          ptr[17].X := obj.Points[1].X-48; ptr[17].Y := obj.Points[1].Y-21;
          ptr[18].X := obj.Points[1].X-41; ptr[18].Y := obj.Points[1].Y-28;
          ptr[19].X := obj.Points[1].X-28; ptr[19].Y := obj.Points[1].Y-17;
          ptr[20].X := obj.Points[1].X-33; ptr[20].Y := obj.Points[1].Y-24;
          ptr[21].X := obj.Points[1].X-34; ptr[21].Y := obj.Points[1].Y-16;
        end;
        1 :
        begin
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+25; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+26; ptr[3].Y := obj.Points[1].Y-5;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y-5;
          ptr[5].X := obj.Points[1].X+36; ptr[5].Y := obj.Points[1].Y-1;
          ptr[6].X := obj.Points[1].X+36; ptr[6].Y := obj.Points[1].Y+10;
          ptr[7].X := obj.Points[1].X+37; ptr[7].Y := obj.Points[1].Y-1;
          ptr[8].X := obj.Points[1].X+48; ptr[8].Y := obj.Points[1].Y+10;
          ptr[9].X := obj.Points[1].X+28; ptr[9].Y := obj.Points[1].Y-20;
          ptr[10].X := obj.Points[1].X+22; ptr[10].Y := obj.Points[1].Y-27;
          ptr[11].X := obj.Points[1].X+21; ptr[11].Y := obj.Points[1].Y-17;
          ptr[12].X := obj.Points[1].X+14; ptr[12].Y := obj.Points[1].Y-24;
          ptr[13].X := obj.Points[1].X+21; ptr[13].Y := obj.Points[1].Y-31;
          ptr[14].X := obj.Points[1].X+35; ptr[14].Y := obj.Points[1].Y-20;
          ptr[15].X := obj.Points[1].X+41; ptr[15].Y := obj.Points[1].Y-27;
          ptr[16].X := obj.Points[1].X+41; ptr[16].Y := obj.Points[1].Y-17;
          ptr[17].X := obj.Points[1].X+48; ptr[17].Y := obj.Points[1].Y-24;
          ptr[18].X := obj.Points[1].X+41; ptr[18].Y := obj.Points[1].Y-31;
          ptr[19].X := obj.Points[1].X+29; ptr[19].Y := obj.Points[1].Y-20;
          ptr[20].X := obj.Points[1].X+34; ptr[20].Y := obj.Points[1].Y-27;
          ptr[21].X := obj.Points[1].X+26; ptr[21].Y := obj.Points[1].Y-19;
        end;
        2 :
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-25; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-26; ptr[3].Y := obj.Points[1].Y+5;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y+5;
          ptr[5].X := obj.Points[1].X-36; ptr[5].Y := obj.Points[1].Y-10;
          ptr[6].X := obj.Points[1].X-36; ptr[6].Y := obj.Points[1].Y+1;
          ptr[7].X := obj.Points[1].X-36; ptr[7].Y := obj.Points[1].Y-10;
          ptr[8].X := obj.Points[1].X-47; ptr[8].Y := obj.Points[1].Y+1;
          ptr[9].X := obj.Points[1].X-28; ptr[9].Y := obj.Points[1].Y+28;
          ptr[10].X := obj.Points[1].X-22; ptr[10].Y := obj.Points[1].Y+21;
          ptr[11].X := obj.Points[1].X-22; ptr[11].Y := obj.Points[1].Y+31;
          ptr[12].X := obj.Points[1].X-15; ptr[12].Y := obj.Points[1].Y+24;
          ptr[13].X := obj.Points[1].X-22; ptr[13].Y := obj.Points[1].Y+17;
          ptr[14].X := obj.Points[1].X-35; ptr[14].Y := obj.Points[1].Y+28;
          ptr[15].X := obj.Points[1].X-41; ptr[15].Y := obj.Points[1].Y+21;
          ptr[16].X := obj.Points[1].X-42; ptr[16].Y := obj.Points[1].Y+31;
          ptr[17].X := obj.Points[1].X-49; ptr[17].Y := obj.Points[1].Y+24;
          ptr[18].X := obj.Points[1].X-42; ptr[18].Y := obj.Points[1].Y+17;
          ptr[19].X := obj.Points[1].X-29; ptr[19].Y := obj.Points[1].Y+28;
          ptr[20].X := obj.Points[1].X-34; ptr[20].Y := obj.Points[1].Y+21;
          ptr[21].X := obj.Points[1].X-38; ptr[21].Y := obj.Points[1].Y+8;
        end;
      else
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+25; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+26; ptr[3].Y := obj.Points[1].Y-5;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y-5;
          ptr[5].X := obj.Points[1].X+36; ptr[5].Y := obj.Points[1].Y-1;
          ptr[6].X := obj.Points[1].X+36; ptr[6].Y := obj.Points[1].Y+10;
          ptr[7].X := obj.Points[1].X+37; ptr[7].Y := obj.Points[1].Y-1;
          ptr[8].X := obj.Points[1].X+48; ptr[8].Y := obj.Points[1].Y+10;
          ptr[9].X := obj.Points[1].X+28; ptr[9].Y := obj.Points[1].Y+23;
          ptr[10].X := obj.Points[1].X+22; ptr[10].Y := obj.Points[1].Y+16;
          ptr[11].X := obj.Points[1].X+21; ptr[11].Y := obj.Points[1].Y+26;
          ptr[12].X := obj.Points[1].X+14; ptr[12].Y := obj.Points[1].Y+19;
          ptr[13].X := obj.Points[1].X+21; ptr[13].Y := obj.Points[1].Y+12;
          ptr[14].X := obj.Points[1].X+35; ptr[14].Y := obj.Points[1].Y+23;
          ptr[15].X := obj.Points[1].X+41; ptr[15].Y := obj.Points[1].Y+16;
          ptr[16].X := obj.Points[1].X+41; ptr[16].Y := obj.Points[1].Y+26;
          ptr[17].X := obj.Points[1].X+48; ptr[17].Y := obj.Points[1].Y+19;
          ptr[18].X := obj.Points[1].X+41; ptr[18].Y := obj.Points[1].Y+12;
          ptr[19].X := obj.Points[1].X+29; ptr[19].Y := obj.Points[1].Y+16;
          ptr[20].X := obj.Points[1].X+34; ptr[20].Y := obj.Points[1].Y+23;
          ptr[21].X := obj.Points[1].X+23; ptr[21].Y := obj.Points[1].Y+3;
      end;

      // изобразить элементы увязки
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin // перегон свободен
        form.Brush.Color := armcolor8;
      end else
      begin // перегон занят
        form.Brush.Color := armcolor1;
      end;
      form.Pen.Color := form.Brush.Color; form.Pen.Width := 1; form.Pen.Style := psSolid;
      form.Rectangle(rect(ptr[19], ptr[20]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // ближний участок приближения свободен
        form.Pen.Color := armcolor7; form.Pen.Width := 3;
      end else
      begin // ближний участок приближения занят
        form.Pen.Color := armcolor1; form.Pen.Width := 3;
      end;
      form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] or not OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // перегон стоит на отправлении или ближний занят - участок не имеет сигнального показания
        form.Pen.Color := armcolor12; form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // дальний участок свободен
          form.Pen.Width := 3; form.Pen.Color := armcolor7;
        end else
        begin // дальний участок занят
          form.Pen.Width := 3; form.Pen.Color := armcolor1;
        end;
      end;
      form.MoveTo(ptr[3].X, ptr[3].Y); form.LineTo(ptr[4].X, ptr[4].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[17] then
      begin // светофор открыт по линейной цепи
        form.Pen.Color := 0; form.Brush.Color := armcolor2;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // перегон стоит по отправлению
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin // светофор открыт по удалению
            form.Pen.Color := 0; form.Brush.Color := armcolor2;
          end else
          begin // светофор закрыт
            form.Pen.Color := 0; form.Brush.Color := armcolor8;
          end;
        end else
        begin // перегон стоит на приеме - светофор не имеет сигнального показания
          form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
        end;
      end;
      form.Pen.Width := 1;
      form.MoveTo(ptr[5].X, ptr[5].Y); form.LineTo(ptr[6].X, ptr[6].Y);
      form.Ellipse(ptr[7].X, ptr[7].Y, ptr[8].X, ptr[8].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // перегон стоит на отправлении - символ не имеет сигнального показания
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      begin // установлено направление на прием
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end;
      form.Polygon([ptr[11], ptr[12], ptr[13]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // перегон стоит на отправлении - символ не имеет сигнального показания
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      begin // установлено направление на прием
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end;
      form.Rectangle(ptr[9].X, ptr[9].Y, ptr[10].X, ptr[10].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // перегон стоит на приеме - символ не имеет сигнального показания
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      begin // установлено направление на отправление
        form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
      end;
      form.Polygon([ptr[16], ptr[17], ptr[18]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // перегон стоит на приеме - символ не имеет сигнального показания
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      begin // установлено направление на отправление
        form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
      end;
      form.Rectangle(ptr[14].X, ptr[14].Y, ptr[15].X, ptr[15].Y);

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,25);
      end;
    end;


    32 : begin
    //**************************************************************
    //
    // Увязка с автоблокировкой с проходными светофорами, капремонт
    //
    //**************************************************************
fix := 32;
      case Obj.ObjConstI[2] of
        0 : // привязка слева снизу
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y-17;
          ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y-24;
          ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y-14;
          ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y-21;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y-28;
          ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y-17;
          ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y-24;
          ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y-14;
          ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y-21;
          ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y-28;
          ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y-17;
          ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y-24;
          ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y-16;
        end;

        1 :
        begin
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y-17;
          ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y-24;
          ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y-14;
          ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y-21;
          ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y-28;
          ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y-17;
          ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y-24;
          ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y-14;
          ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y-21;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y-28;
          ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y-17;
          ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y-24;
          ptr[17].X := obj.Points[1].X+26; ptr[17].Y := obj.Points[1].Y-16;
        end;

        2 :
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y+23;
          ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y+16;
          ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y+26;
          ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y+19;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y+12;
          ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y+23;
          ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y+16;
          ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y+26;
          ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y+19;
          ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y+12;
          ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y+23;
          ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y+16;
          ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y+3;
        end;

      else
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y+23;
          ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y+16;
          ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y+26;
          ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y+19;
          ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y+12;
          ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y+23;
          ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y+16;
          ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y+26;
          ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y+19;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y+12;
          ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y+23;
          ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y+16;
          ptr[17].X := obj.Points[1].X+26; ptr[17].Y := obj.Points[1].Y+3;
      end;

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // комплект подключен
        if OVBuffer[Obj.ObjConstI[1]].Param[5] then
        begin // перегон свободен
          form.Brush.Color := armcolor8;
        end else
        begin // перегон занят
          form.Brush.Color := armcolor1;
        end;
      end else
      begin // Комплект отключен
        form.Brush.Color := armcolor8;
      end;
      form.Pen.Color := form.Brush.Color; form.Pen.Width := 1; form.Pen.Style := psSolid;
      form.Rectangle(rect(ptr[15], ptr[16]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // ближний участок приближения свободен
        form.Pen.Color := armcolor7;
      end else
      begin // ближний участок приближения занят
        form.Pen.Color := armcolor1;
      end;
      form.Pen.Width := 3;
      form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if (Obj.ObjConstI[3] = 1) and (Obj.ObjConstI[4] = 1) and
         (not OVBuffer[Obj.ObjConstI[1]].Param[2] or
         (not OVBuffer[Obj.ObjConstI[1]].Param[7] and OVBuffer[Obj.ObjConstI[1]].Param[10])) then
      begin // путь перегона по отправлению - ближний участок занят или контроль по приему
        form.Pen.Color := 0; form.Pen.Width := 1;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // дальний участок свободен
          form.Pen.Width := 3; form.Pen.Color := armcolor7;
        end else
        begin // дальний участок занят
          form.Pen.Width := 3; form.Pen.Color := armcolor1;
        end;
      end;
      form.MoveTo(ptr[3].X, ptr[3].Y); form.LineTo(ptr[4].X, ptr[4].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // комплект подключен
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // перегон стоит на отправлении - символ не имеет сигнального показания
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end else
        begin // установлено направление на прием
          form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
        end;
      end else
      begin // Комплект отключен
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin
          if Obj.ObjConstI[3] = 0 then
          begin
            form.Pen.Color := 0; form.Brush.Color := 0;
          end else
          begin
           form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
         end;
        end else
        begin
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end;
      form.Pen.Width := 1;
      form.Polygon([ptr[7], ptr[8], ptr[9]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // комплект подключен
        if OVBuffer[Obj.ObjConstI[1]].Param[6] then
        begin // перегон стоит на отправлении - символ не имеет сигнального показания
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end else
        begin // установлено направление на прием
          form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
        end;
      end else
      begin // Комплект отключен
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin
          if Obj.ObjConstI[3] = 0 then
          begin
            form.Pen.Color := 0; form.Brush.Color := 0;
          end else
          begin
           form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
         end;
        end else
        begin
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end;
      form.Pen.Width := 1;
      form.Rectangle(rect(ptr[5], ptr[6]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // комплект подключен
        if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // перегон стоит на приеме - символ не имеет сигнального показания
              form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end else
        begin // установлено направление на отправление
          form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
        end;
      end else
      begin // Комплект отключен
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin
          if Obj.ObjConstI[3] = 1 then
          begin
            form.Pen.Color := 0; form.Brush.Color := 0;
          end else
          begin
           form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
         end;
        end else
        begin
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end;
      form.Pen.Width := 1;
      form.Polygon([ptr[12], ptr[13], ptr[14]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // комплект подключен
        if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
        begin // перегон стоит на приеме - символ не имеет сигнального показания
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end else
        begin // установлено направление на отправление
          form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
        end;
      end else
      begin // Комплект отключен
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin
          if Obj.ObjConstI[3] = 1 then
          begin
            form.Pen.Color := 0; form.Brush.Color := 0;
          end else
          begin
           form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
         end;
        end else
        begin
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end;
      form.Pen.Width := 1;
      form.Rectangle(rect(ptr[10], ptr[11]));

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,25);
      end;
    end;


    33 : begin
    //*****************************************
    //
    // Увязка с полуавтоматической блокировкой
    //
    //*****************************************
fix := 33;
      case Obj.ObjConstI[2] of
        0 : begin
          ptr[1].X := obj.Points[1].X-52-form.TextWidth(obj.Title); ptr[1].Y := obj.Points[1].Y+2;
          ptr[2].X := obj.Points[1].X-2; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-50; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y+4;
          ptr[5].X := obj.Points[1].X-50; ptr[5].Y := obj.Points[1].Y+15;
          ptr[6].X := obj.Points[1].X-39; ptr[6].Y := obj.Points[1].Y+4;
          ptr[7].X := obj.Points[1].X-50; ptr[7].Y := obj.Points[1].Y+15;
          ptr[8].X := obj.Points[1].X-29; ptr[8].Y := obj.Points[1].Y-20;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y-27;
          ptr[10].X := obj.Points[1].X-22; ptr[10].Y := obj.Points[1].Y-17;
          ptr[11].X := obj.Points[1].X-15; ptr[11].Y := obj.Points[1].Y-24;
          ptr[12].X := obj.Points[1].X-22; ptr[12].Y := obj.Points[1].Y-31;
          ptr[13].X := obj.Points[1].X-34; ptr[13].Y := obj.Points[1].Y-20;
          ptr[14].X := obj.Points[1].X-41; ptr[14].Y := obj.Points[1].Y-27;
          ptr[15].X := obj.Points[1].X-42; ptr[15].Y := obj.Points[1].Y-17;
          ptr[16].X := obj.Points[1].X-49; ptr[16].Y := obj.Points[1].Y-24;
          ptr[17].X := obj.Points[1].X-42; ptr[17].Y := obj.Points[1].Y-31;
          ptr[18].X := obj.Points[1].X-35; ptr[18].Y := obj.Points[1].Y-19;
        end;

        1 : begin
          ptr[1].X := obj.Points[1].X+52; ptr[1].Y := obj.Points[1].Y-16;
          ptr[2].X := obj.Points[1].X+2; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+50; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y-5;
          ptr[5].X := obj.Points[1].X+50; ptr[5].Y := obj.Points[1].Y-16;
          ptr[6].X := obj.Points[1].X+39; ptr[6].Y := obj.Points[1].Y-4;
          ptr[7].X := obj.Points[1].X+50; ptr[7].Y := obj.Points[1].Y-15;
          ptr[8].X := obj.Points[1].X+29; ptr[8].Y := obj.Points[1].Y-20;
          ptr[9].X := obj.Points[1].X+22; ptr[9].Y := obj.Points[1].Y-27;
          ptr[10].X := obj.Points[1].X+21; ptr[10].Y := obj.Points[1].Y-17;
          ptr[11].X := obj.Points[1].X+14; ptr[11].Y := obj.Points[1].Y-24;
          ptr[12].X := obj.Points[1].X+21; ptr[12].Y := obj.Points[1].Y-31;
          ptr[13].X := obj.Points[1].X+34; ptr[13].Y := obj.Points[1].Y-20;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y-27;
          ptr[15].X := obj.Points[1].X+41; ptr[15].Y := obj.Points[1].Y-17;
          ptr[16].X := obj.Points[1].X+48; ptr[16].Y := obj.Points[1].Y-24;
          ptr[17].X := obj.Points[1].X+41; ptr[17].Y := obj.Points[1].Y-31;
          ptr[18].X := obj.Points[1].X+23; ptr[18].Y := obj.Points[1].Y-19;
        end;

        2 : begin
          ptr[1].X := obj.Points[1].X-52-form.TextWidth(obj.Title); ptr[1].Y := obj.Points[1].Y+2;
          ptr[2].X := obj.Points[1].X-2; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-50; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y+4;
          ptr[5].X := obj.Points[1].X-50; ptr[5].Y := obj.Points[1].Y+15;
          ptr[6].X := obj.Points[1].X-39; ptr[6].Y := obj.Points[1].Y+4;
          ptr[7].X := obj.Points[1].X-50; ptr[7].Y := obj.Points[1].Y+15;
          ptr[8].X := obj.Points[1].X-29; ptr[8].Y := obj.Points[1].Y+29;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y+22;
          ptr[10].X := obj.Points[1].X-22; ptr[10].Y := obj.Points[1].Y+32;
          ptr[11].X := obj.Points[1].X-15; ptr[11].Y := obj.Points[1].Y+25;
          ptr[12].X := obj.Points[1].X-22; ptr[12].Y := obj.Points[1].Y+18;
          ptr[13].X := obj.Points[1].X-34; ptr[13].Y := obj.Points[1].Y+29;
          ptr[14].X := obj.Points[1].X-41; ptr[14].Y := obj.Points[1].Y+22;
          ptr[15].X := obj.Points[1].X-42; ptr[15].Y := obj.Points[1].Y+32;
          ptr[16].X := obj.Points[1].X-49; ptr[16].Y := obj.Points[1].Y+25;
          ptr[17].X := obj.Points[1].X-42; ptr[17].Y := obj.Points[1].Y+18;
          ptr[18].X := obj.Points[1].X-37; ptr[18].Y := obj.Points[1].Y+9;
        end;

      else
          ptr[1].X := obj.Points[1].X+52; ptr[1].Y := obj.Points[1].Y-16;
          ptr[2].X := obj.Points[1].X+2; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+50; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y-5;
          ptr[5].X := obj.Points[1].X+50; ptr[5].Y := obj.Points[1].Y-16;
          ptr[6].X := obj.Points[1].X+39; ptr[6].Y := obj.Points[1].Y-4;
          ptr[7].X := obj.Points[1].X+50; ptr[7].Y := obj.Points[1].Y-15;
          ptr[8].X := obj.Points[1].X+29; ptr[8].Y := obj.Points[1].Y+23;
          ptr[9].X := obj.Points[1].X+22; ptr[9].Y := obj.Points[1].Y+16;
          ptr[10].X := obj.Points[1].X+21; ptr[10].Y := obj.Points[1].Y+26;
          ptr[11].X := obj.Points[1].X+14; ptr[11].Y := obj.Points[1].Y+19;
          ptr[12].X := obj.Points[1].X+21; ptr[12].Y := obj.Points[1].Y+12;
          ptr[13].X := obj.Points[1].X+34; ptr[13].Y := obj.Points[1].Y+23;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y+16;
          ptr[15].X := obj.Points[1].X+41; ptr[15].Y := obj.Points[1].Y+26;
          ptr[16].X := obj.Points[1].X+48; ptr[16].Y := obj.Points[1].Y+19;
          ptr[17].X := obj.Points[1].X+41; ptr[17].Y := obj.Points[1].Y+12;
          ptr[18].X := obj.Points[1].X+26; ptr[18].Y := obj.Points[1].Y+3;
      end;

      form.Brush.Style := bsClear; form.font.Style := []; form.font.Color := clBlack;
      form.TextOut(ptr[1].X,ptr[1].Y,obj.Title);

      form.Brush.Style := bsSolid;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // участок приближения свободен
        form.Pen.Color := armcolor7;
      end else
      begin // участок приближения занят
        form.Pen.Color := armcolor1;
      end;
      form.Pen.Width := 3;
      form.MoveTo(ptr[2].X, ptr[2].Y); form.LineTo(ptr[3].X, ptr[3].Y);

      form.Pen.Width := 1; form.Pen.Color := 0;
      form.MoveTo(ptr[4].X, ptr[4].Y); form.LineTo(ptr[5].X, ptr[5].Y);
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin // светофор неисправен
        form.Pen.Color := 0; form.Brush.Color := armcolor15;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin // входной светофор открыт
          form.Pen.Color := 0; form.Brush.Color := armcolor2;
        end else
        begin // входной светофор закрыт
          form.Pen.Color := 0; form.Brush.Color := armcolor8;
        end;
      end;
      form.Ellipse(ptr[6].X, ptr[6].Y, ptr[7].X, ptr[7].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // есть блок-сигнал поездного отправления с соседней станции
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // перегон занят
        form.Pen.Color := armcolor1; form.Brush.Color := armcolor1;
      end else
      begin // перегон свободен по приему
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end;
      form.Pen.Width := 1;
      form.Rectangle(rect(ptr[8], ptr[9]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[13] then
      begin // выдана предварительная команда искусственного прибытия
        form.Pen.Color := armcolor9; form.Brush.Color := armcolor9;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin // выдано согласие на отправление поезда
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end else
      begin // перегон свободен по приему
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end;
      form.Pen.Width := 1;
      form.Polygon([ptr[10], ptr[11], ptr[12]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[12] then
      begin // неверная комбинация датчиков
        form.Pen.Color := armcolor11; form.Brush.Color := armcolor11;        //////////////////////////////////////////\\
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin // перегон занят по отправлению
        form.Pen.Color := armcolor1; form.Brush.Color := armcolor1;
      end else
      begin // перегон свободен по отправлению
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end;
      form.Rectangle(rect(ptr[13], ptr[14]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[12] then
      begin // неверная комбинация датчиков
        form.Pen.Color := armcolor11; form.Brush.Color := armcolor11;        //////////////////////////////////////////\\
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[11] then
      begin // перегон занят по отправлению хозяйственного поезда
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // получено согласие на отправление поезда
        form.Pen.Color := armcolor5; form.Brush.Color := armcolor5;
      end else
      begin // перегон свободен по отправлению
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end;
      form.Polygon([ptr[15], ptr[16], ptr[17]]);

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,25);
      end;
    end;


    34 : begin
    //****************************************
    //
    //              Ключ-жезл
    //
    //****************************************
fix := 34;
      form.Font.Color := armcolor12; form.Brush.Color := armcolor15; form.font.Style := []; form.Font.Size := 8;
      form.TextOut(obj.Points[1].X-form.TextWidth(obj.Title) div 2,obj.Points[1].Y-20, obj.Title);
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентнрализованное состояние
        form.Brush.Color := armcolor12; form.Pen.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Brush.Color := armcolor14; form.Pen.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[11] then
      begin // КЖ вставлен
        form.Brush.Color := 0; form.Pen.Color := 0;
      end else
      begin // КЖ изъят
        form.Brush.Color := armcolor4; form.Pen.Color := armcolor4;
      end;
      form.Pen.Width := 1;
      form.Ellipse(obj.Points[1].X-3,obj.Points[1].Y-3,obj.Points[1].X+4,obj.Points[1].Y+4);
      form.Pen.Width := 3;
      form.MoveTo(obj.Points[1].X,obj.Points[1].Y); form.LineTo(obj.Points[1].X,obj.Points[1].Y+15);
    end;


    35 : begin
    //************************************************
    //
    // Увязка с автоблокировкой без смены направления
    //
    //************************************************
fix := 35;
      case Obj.ObjConstI[2] of
        0 : begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          if Obj.ObjConstI[3] = 1 then
          begin
            ptr[5].X := obj.Points[1].X-37; ptr[5].Y := obj.Points[1].Y-19;
            ptr[6].X := obj.Points[1].X-34; ptr[6].Y := obj.Points[1].Y-22;
            ptr[7].X := obj.Points[1].X-17; ptr[7].Y := obj.Points[1].Y-22;
            ptr[8].X := obj.Points[1].X-17; ptr[8].Y := obj.Points[1].Y-16;
            ptr[9].X := obj.Points[1].X-34; ptr[9].Y := obj.Points[1].Y-16;
          end else
          begin
            ptr[5].X := obj.Points[1].X-20; ptr[5].Y := obj.Points[1].Y-19;
            ptr[6].X := obj.Points[1].X-23; ptr[6].Y := obj.Points[1].Y-22;
            ptr[7].X := obj.Points[1].X-40; ptr[7].Y := obj.Points[1].Y-22;
            ptr[8].X := obj.Points[1].X-40; ptr[8].Y := obj.Points[1].Y-16;
            ptr[9].X := obj.Points[1].X-23; ptr[9].Y := obj.Points[1].Y-16;
          end;
          ptr[10].X := obj.Points[1].X-52; ptr[10].Y := obj.Points[1].Y-24;
        end;

        1 : begin
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          if Obj.ObjConstI[3] = 1 then
          begin
            ptr[5].X := obj.Points[1].X+37; ptr[5].Y := obj.Points[1].Y-19;
            ptr[6].X := obj.Points[1].X+34; ptr[6].Y := obj.Points[1].Y-22;
            ptr[7].X := obj.Points[1].X+17; ptr[7].Y := obj.Points[1].Y-22;
            ptr[8].X := obj.Points[1].X+17; ptr[8].Y := obj.Points[1].Y-16;
            ptr[9].X := obj.Points[1].X+34; ptr[9].Y := obj.Points[1].Y-16;
          end else
          begin
            ptr[5].X := obj.Points[1].X+20; ptr[5].Y := obj.Points[1].Y-19;
            ptr[6].X := obj.Points[1].X+23; ptr[6].Y := obj.Points[1].Y-22;
            ptr[7].X := obj.Points[1].X+40; ptr[7].Y := obj.Points[1].Y-22;
            ptr[8].X := obj.Points[1].X+40; ptr[8].Y := obj.Points[1].Y-16;
            ptr[9].X := obj.Points[1].X+23; ptr[9].Y := obj.Points[1].Y-16;
          end;
          ptr[10].X := obj.Points[1].X+41; ptr[10].Y := obj.Points[1].Y-24;
        end;

        2 : begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          if Obj.ObjConstI[3] = 1 then
          begin
            ptr[5].X := obj.Points[1].X-37; ptr[5].Y := obj.Points[1].Y+19;
            ptr[6].X := obj.Points[1].X-34; ptr[6].Y := obj.Points[1].Y+22;
            ptr[7].X := obj.Points[1].X-17; ptr[7].Y := obj.Points[1].Y+22;
            ptr[8].X := obj.Points[1].X-17; ptr[8].Y := obj.Points[1].Y+16;
            ptr[9].X := obj.Points[1].X-34; ptr[9].Y := obj.Points[1].Y+16;
          end else
          begin
            ptr[5].X := obj.Points[1].X-20; ptr[5].Y := obj.Points[1].Y+19;
            ptr[6].X := obj.Points[1].X-23; ptr[6].Y := obj.Points[1].Y+22;
            ptr[7].X := obj.Points[1].X-40; ptr[7].Y := obj.Points[1].Y+22;
            ptr[8].X := obj.Points[1].X-40; ptr[8].Y := obj.Points[1].Y+16;
            ptr[9].X := obj.Points[1].X-23; ptr[9].Y := obj.Points[1].Y+16;
          end;
          ptr[10].X := obj.Points[1].X-52; ptr[10].Y := obj.Points[1].Y+13;
        end;

      else
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          if Obj.ObjConstI[3] = 1 then
          begin
            ptr[5].X := obj.Points[1].X+37; ptr[5].Y := obj.Points[1].Y+19;
            ptr[6].X := obj.Points[1].X+34; ptr[6].Y := obj.Points[1].Y+22;
            ptr[7].X := obj.Points[1].X+17; ptr[7].Y := obj.Points[1].Y+22;
            ptr[8].X := obj.Points[1].X+17; ptr[8].Y := obj.Points[1].Y+16;
            ptr[9].X := obj.Points[1].X+34; ptr[9].Y := obj.Points[1].Y+16;
          end else
          begin
            ptr[5].X := obj.Points[1].X+20; ptr[5].Y := obj.Points[1].Y+19;
            ptr[6].X := obj.Points[1].X+23; ptr[6].Y := obj.Points[1].Y+22;
            ptr[7].X := obj.Points[1].X+40; ptr[7].Y := obj.Points[1].Y+22;
            ptr[8].X := obj.Points[1].X+40; ptr[8].Y := obj.Points[1].Y+16;
            ptr[9].X := obj.Points[1].X+23; ptr[9].Y := obj.Points[1].Y+16;
          end;
          ptr[10].X := obj.Points[1].X+40; ptr[10].Y := obj.Points[1].Y+13;
      end;

      form.Brush.Color := armcolor8; form.Pen.Color := clBlack; form.Pen.Width := 1; form.Pen.Style := psSolid;
      form.Polygon([ptr[5],ptr[6],ptr[7],ptr[8],ptr[9]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // ближний участок приближения свободен
        form.Pen.Width := 3; form.Pen.Color := armcolor7;
      end else
      begin // ближний участок приближения занят
        form.Pen.Width := 3; form.Pen.Color := armcolor1;
      end;
      form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if (Obj.ObjConstI[4] = 1) and not OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // ближний участок занят и есть признак гашения дальнего участка
        form.Pen.Width := 1; form.Pen.Color := 0;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin // дальний участок свободен
        form.Pen.Width := 3; form.Pen.Color := armcolor7;
      end else
      begin // дальний участок занят
        form.Pen.Width := 3; form.Pen.Color := armcolor1;
      end;
      form.MoveTo(ptr[3].X, ptr[3].Y); form.LineTo(ptr[4].X, ptr[4].Y);

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,25);
      end;
    end;


    36 : begin
    //*******************************
    //
    // Увязка межпостовая с запросом
    //
    //*******************************
fix := 36;
      case Obj.ObjConstI[2] of
        0 : begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-43; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-47; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-99; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X-19; ptr[5].Y := obj.Points[1].Y;
          ptr[6].X := obj.Points[1].X-24; ptr[6].Y := obj.Points[1].Y-5;
          ptr[7].X := obj.Points[1].X-24; ptr[7].Y := obj.Points[1].Y+5;
          ptr[8].X := obj.Points[1].X-31; ptr[8].Y := obj.Points[1].Y;
          ptr[9].X := obj.Points[1].X-26; ptr[9].Y := obj.Points[1].Y-5;
          ptr[10].X := obj.Points[1].X-26; ptr[10].Y := obj.Points[1].Y+5;
          ptr[11].X := obj.Points[1].X-99; ptr[11].Y := obj.Points[1].Y-12;
          ptr[12].X := obj.Points[1].X-99; ptr[12].Y := obj.Points[1].Y-18;
          ptr[14].X := obj.Points[1].X-69; ptr[14].Y := obj.Points[1].Y-5;
          ptr[15].X := obj.Points[1].X-93; ptr[15].Y := obj.Points[1].Y-6;
          ptr[16].X := obj.Points[1].X-95; ptr[16].Y := obj.Points[1].Y-18;
          ptr[17].X := obj.Points[1].X-30; ptr[17].Y := obj.Points[1].Y+12;
          ptr[18].X := obj.Points[1].X-36; ptr[18].Y := obj.Points[1].Y+18;
          ptr[19].X := obj.Points[1].X-61; ptr[19].Y := obj.Points[1].Y+18;
          ptr[20].X := obj.Points[1].X-61; ptr[20].Y := obj.Points[1].Y+6;
          ptr[21].X := obj.Points[1].X-36; ptr[21].Y := obj.Points[1].Y+6;
          ptr[22].X := obj.Points[1].X-59; ptr[22].Y := obj.Points[1].Y+6;
          ptr[23].X := obj.Points[1].X-66; ptr[23].Y := obj.Points[1].Y-18;
          ptr[24].X := obj.Points[1].X-30; ptr[24].Y := obj.Points[1].Y-5;
          ptr[25].X := obj.Points[1].X-62; ptr[25].Y := obj.Points[1].Y-18;
          ptr[26].X := obj.Points[1].X-12; ptr[26].Y := obj.Points[1].Y-6;
        end;
      else
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+43; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+47; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+99; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X+19; ptr[5].Y := obj.Points[1].Y;
          ptr[6].X := obj.Points[1].X+24; ptr[6].Y := obj.Points[1].Y-5;
          ptr[7].X := obj.Points[1].X+24; ptr[7].Y := obj.Points[1].Y+5;
          ptr[8].X := obj.Points[1].X+31; ptr[8].Y := obj.Points[1].Y;
          ptr[9].X := obj.Points[1].X+26; ptr[9].Y := obj.Points[1].Y-5;
          ptr[10].X := obj.Points[1].X+26; ptr[10].Y := obj.Points[1].Y+5;
          ptr[11].X := obj.Points[1].X+99; ptr[11].Y := obj.Points[1].Y-12;
          ptr[12].X := obj.Points[1].X+99; ptr[12].Y := obj.Points[1].Y-18;
          ptr[14].X := obj.Points[1].X+69; ptr[14].Y := obj.Points[1].Y-5;
          ptr[15].X := obj.Points[1].X+71; ptr[15].Y := obj.Points[1].Y-6;
          ptr[16].X := obj.Points[1].X+72; ptr[16].Y := obj.Points[1].Y-18;
          ptr[17].X := obj.Points[1].X+30; ptr[17].Y := obj.Points[1].Y+12;
          ptr[18].X := obj.Points[1].X+36; ptr[18].Y := obj.Points[1].Y+18;
          ptr[19].X := obj.Points[1].X+61; ptr[19].Y := obj.Points[1].Y+18;
          ptr[20].X := obj.Points[1].X+61; ptr[20].Y := obj.Points[1].Y+6;
          ptr[21].X := obj.Points[1].X+36; ptr[21].Y := obj.Points[1].Y+6;
          ptr[22].X := obj.Points[1].X+37; ptr[22].Y := obj.Points[1].Y+6;
          ptr[23].X := obj.Points[1].X+30; ptr[23].Y := obj.Points[1].Y-18;
          ptr[24].X := obj.Points[1].X+66; ptr[24].Y := obj.Points[1].Y-5;
          ptr[25].X := obj.Points[1].X+33; ptr[25].Y := obj.Points[1].Y-18;
          ptr[26].X := obj.Points[1].X+1; ptr[26].Y := obj.Points[1].Y-6;
      end;

      form.Pen.Style := psSolid; form.Pen.Width := 3;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // участок приближения свободен
        form.Pen.Color := 0;
      end else
      begin // участок приближения занят
        form.Pen.Color := armcolor1;
      end;
      form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin
        form.Pen.Color := armcolor12;
      end else
      begin // Замкнут маршрут с соседнего поста
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // ИП свободен
          form.Pen.Color := 0;
        end else
        begin // ИП занят
          form.Pen.Color := armcolor1;
        end;
      end;
      form.MoveTo(ptr[3].X, ptr[3].Y); form.LineTo(ptr[4].X, ptr[4].Y);

      form.Pen.Width := 1;
      if OVBuffer[Obj.ObjConstI[1]].Param[16] and not OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
        if not OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // Замкнут маршрут с соседнего поста
          if OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // есть КМ
            form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
          end else
          begin // нет КМ
            form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
          end;
          form.PolyGon([ptr[5],ptr[6],ptr[7]]);
        end;
      end;

      if OVBuffer[Obj.ObjConstI[1]].Param[16] and not OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
        if not OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin // Замкнут маршрут с соседнего поста
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then
          begin // есть КМ
            form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
          end else
          begin // нет КМ
            form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
          end;
          form.PolyGon([ptr[8],ptr[9],ptr[10]]);
        end;
      end;

      form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[11] then
      begin
        form.Pen.Color := 0; form.Brush.Color := armcolor2;
      end else
      begin // нет разрешения на отправление
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin // дан запрос на отправление
          form.Brush.Color := armcolor7;
        end else
        begin // нет запроса на отправление
          form.Brush.Color := bkkeycolor;
        end;
      end;
      form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
      form.Rectangle(ptr[12].X,ptr[12].Y,ptr[14].X,ptr[14].Y);
      form.Pen.Color := armcolor16;
      form.MoveTo(ptr[14].X,ptr[12].Y);
      form.LineTo(ptr[12].X,ptr[12].Y);
      form.LineTo(ptr[12].X,ptr[14].Y);
      form.Pen.Color := armcolor17;
      form.LineTo(ptr[14].X,ptr[14].Y);
      form.LineTo(ptr[14].X,ptr[12].Y);

      form.Brush.Style := bsClear; form.Font.Style := [];
      if Obj.ObjConstI[3] = 1 then form.TextOut(ptr[16].X, ptr[16].Y,'очП') else form.TextOut(ptr[16].X, ptr[16].Y,'оНП');

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin // получен запрос на прием
        form.Pen.Color := 0; form.Font.Color := clBlack; form.Brush.Color := armcolor7;
      end else
      begin // нет запроса на прием
        form.Pen.Color := armcolor8; form.Font.Color := armcolor8; form.Brush.Color := armcolor15;
      end;
      form.PolyGon([ptr[17],ptr[18],ptr[19],ptr[20],ptr[21]]);
      form.Brush.Style := bsClear;
      if Obj.ObjConstI[3] = 1 then form.TextOut(ptr[22].X, ptr[22].Y,'ПНП') else form.TextOut(ptr[22].X, ptr[22].Y,'ПчП');


      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin // получен 1ЭГС
        form.Pen.Color := 0; form.Font.Color := clBlack; form.Brush.Color := armcolor1;
      end else
      begin // нет 1ЭГС
        form.Pen.Color := armcolor8; form.Font.Color := armcolor8; form.Brush.Color := armcolor15;
      end;
      form.RoundRect(ptr[23].X,ptr[23].Y,ptr[24].X,ptr[24].Y,4,30);
      form.Brush.Style := bsClear;
      if Obj.ObjConstI[3] = 1 then form.TextOut(ptr[25].X, ptr[25].Y,'чЭГС') else form.TextOut(ptr[25].X, ptr[25].Y,'НЭГС');

      form.Font.Color := clBlack; form.Brush.Style := bsClear;
      form.TextOut(obj.Points[2].X, obj.Points[2].Y,obj.Title);

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,25);
      end;
    end;


    37 : begin
    //**************
    //
    // Увязка с ГАЦ
    //
    //**************
fix := 37;
      case Obj.ObjConstI[2] of
        0 : // привязка слева
        begin
            ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y;
            ptr[2].X := obj.Points[1].X-150; ptr[2].Y := obj.Points[1].Y;
            ptr[3].X := obj.Points[1].X-58; ptr[3].Y := obj.Points[1].Y-16;
            ptr[4].X := obj.Points[1].X-20; ptr[4].Y := obj.Points[1].Y-3;
            ptr[5].X := obj.Points[1].X-60; ptr[5].Y := obj.Points[1].Y-16;
            ptr[6].X := obj.Points[1].X-81; ptr[6].Y := obj.Points[1].Y-16;
            ptr[7].X := obj.Points[1].X-87; ptr[7].Y := obj.Points[1].Y-10;
            ptr[8].X := obj.Points[1].X-81; ptr[8].Y := obj.Points[1].Y-4;
            ptr[9].X := obj.Points[1].X-60; ptr[9].Y := obj.Points[1].Y-4;
            ptr[10].X := obj.Points[1].X-58; ptr[10].Y := obj.Points[1].Y+4;
            ptr[11].X := obj.Points[1].X-30; ptr[11].Y := obj.Points[1].Y+4;
            ptr[12].X := obj.Points[1].X-24; ptr[12].Y := obj.Points[1].Y+10;
            ptr[13].X := obj.Points[1].X-30; ptr[13].Y := obj.Points[1].Y+16;
            ptr[14].X := obj.Points[1].X-58; ptr[14].Y := obj.Points[1].Y+16;
            ptr[15].X := obj.Points[1].X; ptr[15].Y := obj.Points[1].Y-5;
            ptr[16].X := obj.Points[1].X; ptr[16].Y := obj.Points[1].Y-16;
            ptr[17].X := obj.Points[1].X; ptr[17].Y := obj.Points[1].Y-10;
            ptr[18].X := obj.Points[1].X-4; ptr[18].Y := obj.Points[1].Y-10;
            ptr[19].X := obj.Points[1].X-14; ptr[19].Y := obj.Points[1].Y-15;
            ptr[20].X := obj.Points[1].X-3; ptr[20].Y := obj.Points[1].Y-4;
            ptr[21].X := obj.Points[1].X-130; ptr[21].Y := obj.Points[1].Y;
            ptr[22].X := obj.Points[1].X-110; ptr[22].Y := obj.Points[1].Y-10;
            ptr[23].X := obj.Points[1].X-90; ptr[23].Y := obj.Points[1].Y;
            ptr[24].X := obj.Points[1].X-110; ptr[24].Y := obj.Points[1].Y+10;
            ptr[25].X := obj.Points[1].X+2; ptr[25].Y := obj.Points[1].Y-16;
            ptr[26].X := obj.Points[1].X+4; ptr[26].Y := obj.Points[1].Y;
            ptr[27].X := obj.Points[1].X+80; ptr[27].Y := obj.Points[1].Y;
            ptr[28].X := obj.Points[1].X+30; ptr[28].Y := obj.Points[1].Y-15;
        end;
      else
            // привязка справа
            ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y;
            ptr[2].X := obj.Points[1].X+150; ptr[2].Y := obj.Points[1].Y;
            ptr[3].X := obj.Points[1].X+20; ptr[3].Y := obj.Points[1].Y-16;
            ptr[4].X := obj.Points[1].X+58; ptr[4].Y := obj.Points[1].Y-3;
            ptr[5].X := obj.Points[1].X+60; ptr[5].Y := obj.Points[1].Y-4;
            ptr[6].X := obj.Points[1].X+60; ptr[6].Y := obj.Points[1].Y-16;
            ptr[7].X := obj.Points[1].X+80; ptr[7].Y := obj.Points[1].Y-16;
            ptr[8].X := obj.Points[1].X+86; ptr[8].Y := obj.Points[1].Y-11;
            ptr[9].X := obj.Points[1].X+80; ptr[9].Y := obj.Points[1].Y-4;
            ptr[10].X := obj.Points[1].X+28; ptr[10].Y := obj.Points[1].Y+4;
            ptr[11].X := obj.Points[1].X+22; ptr[11].Y := obj.Points[1].Y+10;
            ptr[12].X := obj.Points[1].X+28; ptr[12].Y := obj.Points[1].Y+16;
            ptr[13].X := obj.Points[1].X+58; ptr[13].Y := obj.Points[1].Y+16;
            ptr[14].X := obj.Points[1].X+58; ptr[14].Y := obj.Points[1].Y+4;
            ptr[15].X := obj.Points[1].X; ptr[15].Y := obj.Points[1].Y+5;
            ptr[16].X := obj.Points[1].X; ptr[16].Y := obj.Points[1].Y+16;
            ptr[17].X := obj.Points[1].X; ptr[17].Y := obj.Points[1].Y+10;
            ptr[18].X := obj.Points[1].X+4; ptr[18].Y := obj.Points[1].Y+10;
            ptr[19].X := obj.Points[1].X+4; ptr[19].Y := obj.Points[1].Y+16;
            ptr[20].X := obj.Points[1].X+15; ptr[20].Y := obj.Points[1].Y+5;
            ptr[21].X := obj.Points[1].X+140; ptr[21].Y := obj.Points[1].Y;
            ptr[22].X := obj.Points[1].X+120; ptr[22].Y := obj.Points[1].Y-10;
            ptr[23].X := obj.Points[1].X+100; ptr[23].Y := obj.Points[1].Y;
            ptr[24].X := obj.Points[1].X+120; ptr[24].Y := obj.Points[1].Y+10;
            ptr[25].X := obj.Points[1].X-2-form.TextWidth(obj.Title); ptr[25].Y := obj.Points[1].Y+5;
            ptr[26].X := obj.Points[1].X-4; ptr[26].Y := obj.Points[1].Y;
            ptr[27].X := obj.Points[1].X-80; ptr[27].Y := obj.Points[1].Y;
            ptr[28].X := obj.Points[1].X-50; ptr[28].Y := obj.Points[1].Y-15;
      end;

      // путь
      form.Pen.Width := 5; form.Pen.Color := RGB(220,220,220); form.Pen.Style := psSolid;
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      // бугор
      form.Pen.Color := RGB(220,220,220); form.Brush.Color := RGB(220,220,220); form.Brush.Style := bsVertical; form.Pen.Width := 1;
      form.Polygon([ptr[21],ptr[22],ptr[23],ptr[24]]);
      form.Pen.Color := armcolor12; 
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      // ЭГС
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[8] then
        begin
        // есть ЭГС
          form.Pen.Color := 0; form.Brush.Color := armcolor1; form.Font.Color := clBlack;
        end else
        begin
        // нет ЭГС
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.RoundRect(ptr[3].X,ptr[3].Y,ptr[4].X,ptr[4].Y,4,30);
      form.Brush.Style := bsClear; form.Font.Style := [];
      form.TextOut(ptr[3].X+3,ptr[3].Y,obj.Title+'ЭГС');
      // согласие
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[6] then
        begin // есть согласие надвига
          if OVBuffer[Obj.ObjConstI[1]].Param[7] and tab_page then
          begin // есть согласие маневров - мигать с зеленого на белый
            form.Pen.Color := 0; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := 0; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end;
        end else
        begin // нет согласия надвига
          if OVBuffer[Obj.ObjConstI[1]].Param[7] then
          begin // есть согласие маневров
            form.Pen.Color := 0; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
          end;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Polygon([ptr[5],ptr[6],ptr[7],ptr[8],ptr[9]]);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[6].X+1,ptr[6].Y,obj.Title+'С');
      // октказ от осаживания
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[9] then
        begin
        // есть согласие отказа осаживания
          if OVBuffer[Obj.ObjConstI[1]].Param[10] then
          begin
          // есть отказ от осаживания
            form.Pen.Color := 0; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := 0; form.Brush.Color := armcolor7; form.Font.Color := clBlack;
          end;
        end else
        begin
        // нет согласия отказа осаживания
          if OVBuffer[Obj.ObjConstI[1]].Param[10] then
          begin
          // есть отказ от осаживания
            form.Pen.Color := 0; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
          end;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Polygon([ptr[10],ptr[11],ptr[12],ptr[13],ptr[14]]);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[10].X+1,ptr[10].Y,obj.Title+'оо');
      // горочный светофор
      form.Pen.Style := psSolid; form.Pen.Color := 0; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.MoveTo(ptr[15].X,ptr[15].Y); form.LineTo(ptr[16].X,ptr[16].Y);
      form.MoveTo(ptr[17].X,ptr[17].Y); form.LineTo(ptr[18].X,ptr[18].Y);
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin // есть маневровый огонь
          if OVBuffer[Obj.ObjConstI[1]].Param[3] and tab_page then
          begin // маневры с осаживанием - недопустимое состояние датчиков
            form.Pen.Color := 0; form.Brush.Color := armcolor1; form.Font.Color := clBlack;
          end else
          if (OVBuffer[Obj.ObjConstI[1]].Param[4] or OVBuffer[Obj.ObjConstI[1]].Param[5]) and tab_page then
          begin // маневры с надвигом - недопустимое состояние датчиков
            form.Pen.Color := 0; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end else
          begin // Маневровое показание
            form.Pen.Color := 0; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end;
        end else
        begin // нет маневрового огня
          if OVBuffer[Obj.ObjConstI[1]].Param[3] then
          begin // есть осаживание
            form.Pen.Color := 0; form.Brush.Color := armcolor1; form.Font.Color := clBlack;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[4] or OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // есть надвиг
            form.Pen.Color := 0; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := 0; form.Brush.Color := armcolor8; form.Font.Color := clBlack;
          end;
        end;
      end;
      form.Ellipse(ptr[19].X,ptr[19].Y,ptr[20].X,ptr[20].Y);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[28].X,ptr[28].Y,obj.Title+'П');
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack; form.Pen.Width := 3;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[11] then
        begin
        // есть занятость горы
          form.Pen.Color := armcolor1; form.Brush.Color := armcolor1;
        end else
        begin
        // гора свободна
          form.Pen.Color := 0; form.Brush.Color := armcolor15;
        end;
        if OVBuffer[Obj.ObjConstI[1]].Param[12] then
        begin
        // есть замыкание горы
          form.Pen.Width := 3;
        end else
        begin
        // гора разомкнута
          form.Pen.Width := 1;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid;
      form.MoveTo(ptr[26].X,ptr[26].Y); form.LineTo(ptr[27].X,ptr[27].Y);
      form.Brush.Style := bsClear;
      if not OVBuffer[obj.ObjConstI[1]].Param[16] or OVBuffer[obj.ObjConstI[1]].Param[1] then
      begin
        form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[19]
          or OVBuffer[Obj.ObjConstI[1]].Param[20] or OVBuffer[Obj.ObjConstI[1]].Param[21] or OVBuffer[Obj.ObjConstI[1]].Param[22]
          or OVBuffer[Obj.ObjConstI[1]].Param[23] or OVBuffer[Obj.ObjConstI[1]].Param[24] or OVBuffer[Obj.ObjConstI[1]].Param[25]
          or OVBuffer[Obj.ObjConstI[1]].Param[26] or OVBuffer[Obj.ObjConstI[1]].Param[27] or OVBuffer[Obj.ObjConstI[1]].Param[28]
          or OVBuffer[Obj.ObjConstI[1]].Param[29] or OVBuffer[Obj.ObjConstI[1]].Param[30] or OVBuffer[Obj.ObjConstI[1]].Param[31]
          or OVBuffer[Obj.ObjConstI[1]].Param[32] then
      // светофор заблокирован (колпачек)
          form.Font.Color := armcolor1
        else form.Font.Color := clBlack;
      end;
      form.TextOut(ptr[25].X,ptr[25].Y,obj.Title);
    end;


    38 : begin
    //********************
    //
    // Маневровая колонка
    //
    //********************
fix := 38;
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y;
      ptr[2].X := obj.Points[1].X+64; ptr[2].Y := obj.Points[1].Y+35;
      ptr[3].X := obj.Points[1].X+3; ptr[3].Y := obj.Points[1].Y+20;
      ptr[4].X := obj.Points[1].X+24; ptr[4].Y := obj.Points[1].Y+33;
      ptr[5].X := obj.Points[1].X+26; ptr[5].Y := obj.Points[1].Y+20;
      ptr[6].X := obj.Points[1].X+37; ptr[6].Y := obj.Points[1].Y+33;
      ptr[7].X := obj.Points[1].X+3; ptr[7].Y := obj.Points[1].Y+2;
      ptr[8].X := obj.Points[1].X+61; ptr[8].Y := obj.Points[1].Y+17;
      ptr[9].X := obj.Points[1].X+40; ptr[9].Y := obj.Points[1].Y+20;
      ptr[10].X := obj.Points[1].X+61; ptr[10].Y := obj.Points[1].Y+33;
      ptr[11].X := obj.Points[2].X; ptr[11].Y := obj.Points[2].Y;
      ptr[12].X := obj.Points[3].X; ptr[12].Y := obj.Points[3].Y;
      ptr[13].X := obj.Points[4].X; ptr[13].Y := obj.Points[4].Y;
      ptr[14].X := obj.Points[5].X; ptr[14].Y := obj.Points[5].Y;
      ptr[15].X := obj.Points[6].X; ptr[15].Y := obj.Points[6].Y;

      form.Pen.Style := psSolid; form.Brush.Style := bsClear; form.Brush.Color := bkkeycolor;
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then
      begin
        form.Pen.Color := armcolor9; form.Pen.Width := 2;
      end else
      begin
        form.Pen.Color := 0; form.Pen.Width := 1;
      end;
      form.Rectangle(ptr[1].X,ptr[1].Y,ptr[2].X,ptr[2].Y);
      if (ptr[11].X > 0) and (ptr[12].X > 0) then
      begin // нарисовать хвост (ногу колонки)
        form.MoveTo(ptr[11].X,ptr[11].Y); form.LineTo(ptr[12].X,ptr[12].Y);
        if ptr[13].X > 0 then
        begin
          form.LineTo(ptr[13].X,ptr[13].Y);
          if ptr[14].X > 0 then
          begin
            form.LineTo(ptr[14].X,ptr[14].Y);
            if ptr[15].X > 0 then
              form.LineTo(ptr[15].X,ptr[15].Y);
          end;
        end;
      end;
      form.Pen.Width := 1;
      // РМ+ОТ
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := clBlack; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := clBlack; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // есть РМ
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then
          begin // есть ОТ
            form.Pen.Color := clBlack; form.Brush.Color := armcolor11; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := clBlack; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
          end;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[11] then
        begin // есть РМК
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then
          begin // есть ОТ
            form.Pen.Color := clBlack; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := clBlack; form.Brush.Color := armcolor7; form.Font.Color := clBlack;
          end;
        end else
        begin // нет РМ и РМК
          if OVBuffer[Obj.ObjConstI[1]].Param[4] then
          begin // есть ОТ
            form.Pen.Color := clBlack; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
          end;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Rectangle(ptr[3].X,ptr[3].Y,ptr[4].X,ptr[4].Y);
      form.Brush.Style := bsClear; form.Font.Style := [];
      form.TextOut(ptr[3].X+2,ptr[3].Y,'РМ');
      // В
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := clBlack; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := clBlack; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin // есть В
          form.Pen.Color := clBlack; form.Brush.Color := armcolor7; form.Font.Color := clBlack;
        end else
        begin // нет В
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Rectangle(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[5].X+2,ptr[5].Y,'В');
      // Искусственное размыкание
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := 0; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := 0; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[7] then
        begin // есть предв МИ
          if OVBuffer[Obj.ObjConstI[1]].Param[8] then
          begin // есть исп МИ
            form.Pen.Color := clBlack; form.Brush.Color := armcolor1; form.Font.Color := clBlack;
          end else
          begin
            form.Pen.Color := clBlack; form.Brush.Color := armcolor9; form.Font.Color := clBlack;
          end;
        end else
        begin // нет предв МИ
          if OVBuffer[Obj.ObjConstI[1]].Param[8] then
          begin // есть исп МИ
            form.Brush.Color := armcolor1; form.Font.Color := 0;
          end else
          begin
            form.Brush.Color := bkkeycolor; form.Font.Color := armcolor8;
          end;
        end;
      end;
      form.Brush.Style := bsSolid; form.FillRect(rect(ptr[7],ptr[8]));
      x1 := (ptr[7].X + ptr[8].X - form.TextWidth(obj.Title)) div 2; form.Font.Color := clBlack;
      form.Brush.Style := bsClear; form.TextOut(x1,ptr[7].Y+1,obj.Title);
      // МИ+ОИ
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := clBlack; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := clBlack; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[6] then
        begin // не замкнуты маневры
          if OVBuffer[Obj.ObjConstI[1]].Param[5] then
          begin // нет децентрализации стрелок
            form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
          end else
          begin
            form.Pen.Color := clBlack; form.Brush.Color := armcolor11; form.Font.Color := clBlack;
          end;
        end else
        begin // маневры замкнуты
          form.Pen.Color := clBlack; form.Brush.Color := armcolor2; form.Font.Color := clBlack;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Rectangle(ptr[9].X,ptr[9].Y,ptr[10].X,ptr[10].Y);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[9].X+2,ptr[9].Y,'МИ');
    end;


    39 : begin
    //**************
    //
    // Увязка с МЭЦ
    //
    //**************
fix := 39;
      case Obj.ObjConstI[2] of
        0 : // МЭЦ справа
        begin
            ptr[1].X := obj.Points[1].X-1; ptr[1].Y := obj.Points[1].Y;
            ptr[2].X := obj.Points[1].X-7; ptr[2].Y := obj.Points[1].Y+6;
            ptr[3].X := obj.Points[1].X-27; ptr[3].Y := obj.Points[1].Y+6;
            ptr[4].X := obj.Points[1].X-27; ptr[4].Y := obj.Points[1].Y-6;
            ptr[5].X := obj.Points[1].X-7; ptr[5].Y := obj.Points[1].Y-6;
            ptr[6].X := obj.Points[1].X-25; ptr[6].Y := obj.Points[1].Y-6;
            ptr[7].X := obj.Points[1].X+1; ptr[7].Y := obj.Points[1].Y;
            ptr[8].X := obj.Points[1].X+7; ptr[8].Y := obj.Points[1].Y-6;
            ptr[9].X := obj.Points[1].X+27; ptr[9].Y := obj.Points[1].Y-6;
            ptr[10].X := obj.Points[1].X+27; ptr[10].Y := obj.Points[1].Y+6;
            ptr[11].X := obj.Points[1].X+7; ptr[11].Y := obj.Points[1].Y+6;
            ptr[12].X := obj.Points[1].X+9; ptr[12].Y := obj.Points[1].Y-6;
        end;
      else
            // МЭЦ слева
            ptr[7].X := obj.Points[1].X-1; ptr[7].Y := obj.Points[1].Y;
            ptr[8].X := obj.Points[1].X-7; ptr[8].Y := obj.Points[1].Y+6;
            ptr[9].X := obj.Points[1].X-27; ptr[9].Y := obj.Points[1].Y+6;
            ptr[10].X := obj.Points[1].X-27; ptr[10].Y := obj.Points[1].Y-6;
            ptr[11].X := obj.Points[1].X-7; ptr[11].Y := obj.Points[1].Y-6;
            ptr[12].X := obj.Points[1].X-25; ptr[12].Y := obj.Points[1].Y-6;
            ptr[1].X := obj.Points[1].X+1; ptr[1].Y := obj.Points[1].Y;
            ptr[2].X := obj.Points[1].X+7; ptr[2].Y := obj.Points[1].Y-6;
            ptr[3].X := obj.Points[1].X+27; ptr[3].Y := obj.Points[1].Y-6;
            ptr[4].X := obj.Points[1].X+27; ptr[4].Y := obj.Points[1].Y+6;
            ptr[5].X := obj.Points[1].X+7; ptr[5].Y := obj.Points[1].Y+6;
            ptr[6].X := obj.Points[1].X+9; ptr[6].Y := obj.Points[1].Y-6;
      end;

      // МП
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin
        // есть МП
          form.Pen.Color := 0; form.Brush.Color := armcolor7; form.Font.Color := clBlack;
        end else
        begin
        // нет МП
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Polygon([ptr[1],ptr[2],ptr[3],ptr[4],ptr[5]]);
      form.Brush.Style := bsClear; form.Font.Style := [];
      form.TextOut(ptr[6].X,ptr[6].Y,'МП');
      // МО
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin
      // нецентрализованный
        form.Pen.Color := armcolor12; form.Brush.Color := armcolor12; form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin
      // непарафазность
        form.Pen.Color := armcolor14; form.Brush.Color := armcolor14; form.Font.Color := clBlack;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin
        // есть МО
          form.Pen.Color := 0; form.Brush.Color := armcolor7; form.Font.Color := clBlack;
        end else
        begin
        // нет МО
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor15; form.Font.Color := armcolor8;
        end;
      end;
      form.Pen.Style := psSolid; form.Brush.Style := bsSolid; form.Pen.Width := 1;
      form.Polygon([ptr[7],ptr[8],ptr[9],ptr[10],ptr[11]]);
      form.Brush.Style := bsClear;
      form.TextOut(ptr[12].X,ptr[12].Y,'Мо');
    end;


    40 : begin
    //************************************************************************
    //
    // Увязка с автоблокировкой с проходными светофорами, постоянного действия
    //
    //************************************************************************
fix := 40;
      case Obj.ObjConstI[2] of
        0 : // привязка слева снизу
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y-18;
          ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y-25;
          ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y-15;
          ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y-22;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y-29;
          ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y-18;
          ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y-25;
          ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y-15;
          ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y-22;
          ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y-29;
          ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y-18;
          ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y-25;
          ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y-17;
        end;

        1 :
        begin
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y-18;
          ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y-25;
          ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y-15;
          ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y-22;
          ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y-29;
          ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y-18;
          ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y-25;
          ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y-15;
          ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y-22;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y-29;
          ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y-18;
          ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y-25;
          ptr[17].X := obj.Points[1].X+25; ptr[17].Y := obj.Points[1].Y-17;
        end;

        2 :
        begin
          ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y+23;
          ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y+16;
          ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y+26;
          ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y+19;
          ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y+12;
          ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y+23;
          ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y+16;
          ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y+26;
          ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y+19;
          ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y+12;
          ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y+23;
          ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y+16;
          ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y+3;
        end;

      else
          ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y;
          ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;
          ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;
          ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y+23;
          ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y+16;
          ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y+26;
          ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y+19;
          ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y+12;
          ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y+23;
          ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y+16;
          ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y+26;
          ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y+19;
          ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y+12;
          ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y+23;
          ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y+16;
          ptr[17].X := obj.Points[1].X+25; ptr[17].Y := obj.Points[1].Y+3;
      end;

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 1;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin // перегон свободен
        form.Brush.Color := armcolor8;
      end else
      begin // перегон занят
        form.Brush.Color := armcolor1;
      end;
      form.Pen.Color := form.Brush.Color; form.Pen.Width := 1; form.Pen.Style := psSolid;
      form.Rectangle(rect(ptr[15], ptr[16]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then
      begin // ближний участок приближения свободен
        form.Pen.Color := armcolor7;
      end else
      begin // ближний участок приближения занят
        form.Pen.Color := armcolor1;
      end;
      form.Pen.Width := 3;
      form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12; form.Pen.Width := 3;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14; form.Pen.Width := 3;
      end else
      if Obj.ObjConstI[4] = 1 then
      begin // гасить 2ИП / з
        if Obj.ObjConstI[3] = 1 then
        begin
          if not OVBuffer[Obj.ObjConstI[1]].Param[2] and OVBuffer[Obj.ObjConstI[1]].Param[7] then
          begin // путь перегона по отправлению - ближний участок занят
            form.Pen.Color := 0; form.Pen.Width := 1;
          end else
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[3] then
            begin // дальний участок свободен
              form.Pen.Width := 3; form.Pen.Color := armcolor7;
            end else
            begin // дальний участок занят
              form.Pen.Width := 3; form.Pen.Color := armcolor1;
            end;
          end;
        end else
        begin // не различать прием/отправление
          if not OVBuffer[Obj.ObjConstI[1]].Param[2] then
          begin // ближний участок занят - погасить дальний участок
            form.Pen.Color := 0; form.Pen.Width := 1;
          end else
          begin
            if OVBuffer[Obj.ObjConstI[1]].Param[3] then
            begin // дальний участок свободен
              form.Pen.Width := 3; form.Pen.Color := armcolor7;
            end else
            begin // дальний участок занят
              form.Pen.Width := 3; form.Pen.Color := armcolor1;
            end;
          end;
        end;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[3] then
        begin // дальний участок свободен
          form.Pen.Width := 3; form.Pen.Color := armcolor7;
        end else
        begin // дальний участок занят
          form.Pen.Width := 3; form.Pen.Color := armcolor1;
        end;
      end;
      form.MoveTo(ptr[3].X, ptr[3].Y); form.LineTo(ptr[4].X, ptr[4].Y);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // перегон стоит на отправлении
        if OVBuffer[Obj.ObjConstI[1]].Param[18] then
        begin // получен запрос на смену направления
          form.Pen.Color := armcolor9; form.Brush.Color := armcolor9;
        end else
        begin // не имеет сигнального показания
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end else
      begin // установлено направление на прием
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end;
      form.Pen.Width := 1;
      form.Polygon([ptr[7], ptr[8], ptr[9]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // перегон стоит на отправлении - не имеет сигнального показания
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end else
      begin // установлено направление на прием
        form.Pen.Color := armcolor7; form.Brush.Color := armcolor7;
      end;
      form.Pen.Width := 1;
      form.Rectangle(rect(ptr[5], ptr[6]));

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
      begin // перегон стоит на приеме - символ не имеет сигнального показания
        if OVBuffer[Obj.ObjConstI[1]].Param[18] then
        begin // получен запрос на смену направления
          form.Pen.Color := armcolor9; form.Brush.Color := armcolor9;
        end else
        begin // не имеет сигнального показания
          form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
        end;
      end else
      begin // установлено направление на отправление
        form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
      end;
      form.Pen.Width := 1;
      form.Polygon([ptr[12], ptr[13], ptr[14]]);

      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // нецентрализованный
        form.Pen.Color := armcolor12; form.Pen.Style := psSolid; form.Brush.Color := armcolor12;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность
        form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Brush.Color := armcolor14;
      end else
      if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
      begin // перегон стоит на приеме - символ не имеет сигнального показания
        form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      end else
      begin // установлено направление на отправление
        form.Pen.Color := armcolor2; form.Brush.Color := armcolor2;
      end;
      form.Pen.Width := 1;
      form.Rectangle(rect(ptr[10], ptr[11]));

      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,3);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[29] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,24);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,2);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[30] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,26);
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[31] then
      begin
        TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,25);
      end;
    end;


    42 : begin
    //**************************
    //
    // Контроль перегонной точки
    //
    //**************************
fix := 42;
      p := false;
      if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
      begin // отсутствие информации
        form.Brush.Color := armcolor8; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
        ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
        ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
        ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
        ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
        ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
        x1 := 2;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[1] then
      begin // непарафазность датчиков
        form.Brush.Color := armcolor14; form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;
        ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
        ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
        ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
        ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
        ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
        x1 := 3;
      end else
      begin
        x1 := 1;
        if OVBuffer[Obj.ObjConstI[1]].Param[19] then
        begin // перегон по приему
          if Obj.ObjConstI[3] = 0 then
          begin
            ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
            ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
          end
          else
          begin
            ptr[2].X := obj.Points[1].X + 7; ptr[2].Y := obj.Points[1].Y - 5;
            ptr[3].X := obj.Points[1].X + 12; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X + 7; ptr[4].Y := obj.Points[1].Y + 5;
          end;

          if Obj.ObjConstI[3] = 0 then
          begin
            ptr[5].X := obj.Points[1].X - 7; ptr[5].Y := obj.Points[1].Y + 5;
            ptr[6].X := obj.Points[1].X - 12; ptr[6].Y := obj.Points[1].Y;
            ptr[1].X := obj.Points[1].X - 7; ptr[1].Y := obj.Points[1].Y - 5;
          end
          else
          begin
            ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
            ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
            ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
          end;
        end else
        if OVBuffer[Obj.ObjConstI[1]].Param[20] then
        begin // перегон по отправлению
          if Obj.ObjConstI[3] = 0 then
          begin
            ptr[2].X := obj.Points[1].X + 7; ptr[2].Y := obj.Points[1].Y - 5;
            ptr[3].X := obj.Points[1].X + 12; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X + 7; ptr[4].Y := obj.Points[1].Y + 5;
          end
          else
          begin
            ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
            ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
            ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
          end;

          if Obj.ObjConstI[3] = 0 then
          begin
            ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
            ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
            ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
          end
          else
          begin
            ptr[5].X := obj.Points[1].X - 7; ptr[5].Y := obj.Points[1].Y + 5;
            ptr[6].X := obj.Points[1].X - 12; ptr[6].Y := obj.Points[1].Y;
            ptr[1].X := obj.Points[1].X - 7; ptr[1].Y := obj.Points[1].Y - 5;
          end;
        end else
        begin // перегон без направления
          ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
          ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
          ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
          ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
          ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
          ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
        end;

        case Obj.ObjConstI[4] of
          1 : begin // только прием
            if OVBuffer[Obj.ObjConstI[1]].Param[19] then
            begin
              case Obj.ObjConstI[2] of
                1 : p := OVBuffer[Obj.ObjConstI[1]].Param[2];
                2 : p := OVBuffer[Obj.ObjConstI[1]].Param[4];
                3 : p := OVBuffer[Obj.ObjConstI[1]].Param[6];
                4 : p := OVBuffer[Obj.ObjConstI[1]].Param[8];
                5 : p := OVBuffer[Obj.ObjConstI[1]].Param[10];
                6 : p := OVBuffer[Obj.ObjConstI[1]].Param[12];
                7 : p := OVBuffer[Obj.ObjConstI[1]].Param[14];
                8 : p := OVBuffer[Obj.ObjConstI[1]].Param[17];
              else
                x1 := 0;
              end;
            end else
              x1 := 0; // требуется обсерить точку
          end;

          2 : begin // только отправление
            if OVBuffer[Obj.ObjConstI[1]].Param[20] then
            begin
              case Obj.ObjConstI[2] of
                1 : p := OVBuffer[Obj.ObjConstI[1]].Param[3];
                2 : p := OVBuffer[Obj.ObjConstI[1]].Param[5];
                3 : p := OVBuffer[Obj.ObjConstI[1]].Param[7];
                4 : p := OVBuffer[Obj.ObjConstI[1]].Param[9];
                5 : p := OVBuffer[Obj.ObjConstI[1]].Param[11];
                6 : p := OVBuffer[Obj.ObjConstI[1]].Param[13];
                7 : p := OVBuffer[Obj.ObjConstI[1]].Param[15];
                8 : p := OVBuffer[Obj.ObjConstI[1]].Param[18];
              else
                x1 := 0;
              end;
            end else
              x1 := 0; // требуется обсерить точку
          end;

        else // двунаправленный
          if OVBuffer[Obj.ObjConstI[1]].Param[19] then
          begin
            case Obj.ObjConstI[2] of
              1 : p := OVBuffer[Obj.ObjConstI[1]].Param[2];
              2 : p := OVBuffer[Obj.ObjConstI[1]].Param[4];
              3 : p := OVBuffer[Obj.ObjConstI[1]].Param[6];
              4 : p := OVBuffer[Obj.ObjConstI[1]].Param[8];
              5 : p := OVBuffer[Obj.ObjConstI[1]].Param[10];
              6 : p := OVBuffer[Obj.ObjConstI[1]].Param[12];
              7 : p := OVBuffer[Obj.ObjConstI[1]].Param[14];
              8 : p := OVBuffer[Obj.ObjConstI[1]].Param[17];
            else
              x1 := 0;
            end;
          end else
          if OVBuffer[Obj.ObjConstI[1]].Param[20] then
          begin
            case Obj.ObjConstI[2] of
              1 : p := OVBuffer[Obj.ObjConstI[1]].Param[3];
              2 : p := OVBuffer[Obj.ObjConstI[1]].Param[5];
              3 : p := OVBuffer[Obj.ObjConstI[1]].Param[7];
              4 : p := OVBuffer[Obj.ObjConstI[1]].Param[9];
              5 : p := OVBuffer[Obj.ObjConstI[1]].Param[11];
              6 : p := OVBuffer[Obj.ObjConstI[1]].Param[13];
              7 : p := OVBuffer[Obj.ObjConstI[1]].Param[15];
              8 : p := OVBuffer[Obj.ObjConstI[1]].Param[18];
            else
              x1 := 0;
            end;
          end else
          begin
            case Obj.ObjConstI[2] of
              1 : p := OVBuffer[Obj.ObjConstI[1]].Param[2] or OVBuffer[Obj.ObjConstI[1]].Param[3];
              2 : p := OVBuffer[Obj.ObjConstI[1]].Param[4] or OVBuffer[Obj.ObjConstI[1]].Param[5];
              3 : p := OVBuffer[Obj.ObjConstI[1]].Param[6] or OVBuffer[Obj.ObjConstI[1]].Param[7];
              4 : p := OVBuffer[Obj.ObjConstI[1]].Param[8] or OVBuffer[Obj.ObjConstI[1]].Param[9];
              5 : p := OVBuffer[Obj.ObjConstI[1]].Param[10] or OVBuffer[Obj.ObjConstI[1]].Param[11];
              6 : p := OVBuffer[Obj.ObjConstI[1]].Param[12] or OVBuffer[Obj.ObjConstI[1]].Param[13];
              7 : p := OVBuffer[Obj.ObjConstI[1]].Param[14] or OVBuffer[Obj.ObjConstI[1]].Param[15];
              8 : p := OVBuffer[Obj.ObjConstI[1]].Param[17] or OVBuffer[Obj.ObjConstI[1]].Param[18];
            else
              x1 := 0;
            end;
          end;
        end;

      end;

      form.Brush.Style := bsSolid; form.Pen.Width := 1; form.Pen.Style := psSolid;

      if x1 = 0 then
      begin // погасить точку
        form.Pen.Color := armcolor8; form.Font.Color := armcolor8; form.Brush.Color := armcolor15;
      end else
      if x1 = 1 then
      begin
        if p then
        begin // занять точку
          form.Pen.Color := armcolor8; form.Font.Color := 0; form.Brush.Color := armcolor1;
        end else
        begin // освободить точку
          form.Pen.Color := armcolor8; form.Font.Color := 0; form.Brush.Color := armcolor9;
        end;
      end;

      form.Polygon([ptr[1], ptr[2], ptr[3], ptr[4], ptr[5], ptr[6]]);
      form.Brush.Style := bsClear; form.Font.Style := []; form.Font.Size := 8;
      x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
      form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
    end;


  else
    form.Brush.Color := clRed;
    form.FillRect(rect(0,0,10,10));
  end;
except
  on e:EOverflow do begin reportf('Ошибка Overflow : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EUnderflow do begin reportf('Ошибка Underflow : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EExternal do begin reportf('Ошибка External : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EInvalidArgument do begin reportf('Ошибка InvalidArgument : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EInvalidOp do begin reportf('Ошибка InvalidOp : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EStackOverflow do begin reportf('Ошибка StackOverflow : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EPrivilege do begin reportf('Ошибка Privilege : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EAccessViolation do begin reportf('Ошибка AcessViolation : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EIntError do begin reportf('Ошибка IntError : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EZeroDivide do begin reportf('Ошибка ZeroDivide : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EMathError do begin reportf('Ошибка MathError : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
  on e:EDivByZero do begin reportf('Ошибка DivByZero : '+e.Message+ ' [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate; end;
else
  reportf('Ошибка [ObjSost.DisplayItemTablo] fix='+ IntToStr(fix)); Application.Terminate;
end;
end;

end.


