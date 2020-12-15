unit Objsost;
//******************************************************************************
//                  Прорисовка на табло
//******************************************************************************
{$INCLUDE d:\sapr2012\CfgProject}

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  TypeALL;

procedure DisplayItemTablo(Obj: POVStruct; form: TCanvas);
procedure DrawSP(form : TCanvas; Buf,Utol  : SmallInt; ptr:array of TPoint);
// ptr1,ptr2 : TPoint);
function GetPenStyle(param : SmallInt) : TPenStyle;
function GetBrushStyle(param : SmallInt) : TBrushStyle;
function GetFontStyle(param : SmallInt) : TFontStyles;
procedure DisplayStatLine(Obj: POVStruct;form: TCanvas);//нарисовать статическую ломаную 1
procedure DisplayStatText(Obj: POVStruct;form: TCanvas);//нарисовать статическую надпись 2
procedure DisplayStatFigur(Obj: POVStruct;form: TCanvas);//нарисовать статическую фигуру 3
procedure DisplayNecentral(Obj: POVStruct;form: TCanvas);//нецентрализованное примыкание 4
procedure DisplayKGU(Obj: POVStruct;form: TCanvas);//----- устройство контроля габаритов 7
procedure DispKnop1to2(Obj: POVStruct;form: TCanvas);// кнопка управления 2умя объектами 8
procedure DisplaySP(Obj: POVStruct;form: TCanvas); //---------------- стрелочная секция 10
procedure DisplayStrelka(Obj: POVStruct;form: TCanvas);//----------- нарисовать стрелку 11
procedure DisplayPut(Obj: POVStruct;form: TCanvas);//------------------ нарисовать путь 12
procedure DisplayManevrIzvest(Obj: POVStruct;form: TCanvas);//-- маневровый известитель 13
procedure DisplayManevrSvet(Obj: POVStruct;form: TCanvas);//------- маневровый светофор 20
procedure DisplaySvetSovm(Obj: POVStruct;form: TCanvas);//- нарисовать совмещ. светофор 21
procedure DisplaySvetVhod(Obj: POVStruct;form: TCanvas); // нарисовать входной светофор 22
procedure DisplaySvetPrig(Obj: POVStruct;form: TCanvas);// нарисовать приглас. светофор 23
procedure DisplaySvetPovtor(Obj: POVStruct;form: TCanvas);//нарисовать повтор.светофора 24
procedure DisplayFictSignal(Obj: POVStruct;form: TCanvas); // фиктивный сигнал (увязка) 25
procedure DisplayKTAB(Obj: POVStruct;form: TCanvas); //---------- контр. точка перегона 26
procedure DisplayKontrPereezd(Obj: POVStruct;form: TCanvas); //------ контроль переезда 30
procedure DisplayUviazkaAB(Obj: POVStruct;form: TCanvas); //----- увязка с перегоном АБ 31
procedure DisplayUviazkaABSvet(Obj:POVStruct;form:TCanvas);// АБ с прох.свет.,капремонт 32
procedure DisplayPAB(Obj: POVStruct;form: TCanvas);//--------------------- увязка с ПАБ 33
procedure DisplayKluchJezl(Obj: POVStruct;form: TCanvas); //--- изображение ключа-жезла 34
procedure DisplayABbezSN(Obj: POVStruct;form: TCanvas);//----------- Увязка с АБ без СН 35
procedure DisplayMejPost(Obj: POVStruct;form: TCanvas); //Увязка межпостовая с запросом 36
procedure DisplayGAC(Obj: POVStruct;form: TCanvas); //-------------------- Увязка с ГАЦ 37
procedure DisplayManevrKolon(Obj: POVStruct;form: TCanvas);//------- маневровая колонка 38
procedure DisplayMEC(Obj: POVStruct;form: TCanvas); //-------------------- увязка с МЭЦ 39
procedure DisplayABPost(Obj: POVStruct;form: TCanvas); //Увязка с АБ с прох. светоф.,ПД 40
procedure DisplayPerToch(Obj: POVStruct;form: TCanvas); //-- Увязка с перегонноя точкой 42
procedure DisplayKnopColor8(Obj: POVStruct;form: TCanvas);//лампа/кнопка в 3-х датчиках 43
procedure DisplayOgradPuti(Obj:POVStruct; form: TCanvas); //----------- ограждение пути 50
procedure DisplayUTS(Obj: POVStruct; form: TCanvas);//------------------ нарисовать UTS 51
procedure DisplayUKSPS(Obj: POVStruct;form: TCanvas);//--------------- нарисовать UKSPS 52
procedure DisplayOhrStr(Obj: POVStruct;form: TCanvas); // нарисовать охранность стрелки 53
procedure DisplayKnopColor2(Obj: POVStruct;form: TCanvas);//-------- кнопка 2-х цветная 54
procedure DisplayKnopColor3(Obj: POVStruct;form: TCanvas);//-------- кнопка 3-х цветная 55
procedure Display3Nadpis(Obj: POVStruct;form: TCanvas);//нарисовать 3-х цветную надпись 56
procedure DisplayIzvestAB(Obj: POVStruct;form: TCanvas);//нарисовать доп.(3)изв-тель АБ 57
procedure DisplayZonaOpov(Obj: POVStruct;form: TCanvas);//-- нарисовать зону оповещения 58
procedure CounterTimer(Obj: POVStruct;form: TCanvas); //---- нарисовать счетчик времени 59
procedure Display2CvetLamp(Obj: POVStruct; form: TCanvas);//2цветная лампа доп.датчиков 60
procedure DisplayPitUst(Obj: POVStruct; form: TCanvas);//----------- Питающая установка 70
procedure DisplayDenNoch(Obj: POVStruct;form: TCanvas);//------- нарисовать "День/Ночь" 92
procedure DisplaySchetKOK(Obj: POVStruct; form: TCanvas); //- счетчик числа нажатий КОК 94
procedure DisplayIconRing(Obj: POVStruct;form: TCanvas); //--- иконка выключения звонка 95
procedure DisplayIconRegim(Obj: POVStruct;form: TCanvas);//------- иконка режима работы 96
procedure DisplayKnopKonec(Obj: POVStruct;form: TCanvas); //------- кнопка конца набора 97
procedure Display_3Serv_8TUMS(Obj: POVStruct;form: TCanvas);//------ 3 Сервера и 8 ТУМС 98
procedure DisplayTabloRegim(Obj: POVStruct;form: TCanvas);//------ выбор режимов работы 99
procedure DisplayArmServPipe(Obj: POVStruct;form: TCanvas);//АРМ с программным каналом 100
procedure DisplayPodsvetStr(Obj: POVStruct;form: TCanvas);//подсвет. положения стрелок 101
procedure DisplayVvodNomer(Obj: POVStruct;form: TCanvas);//-- кнопка ввода № поезда -- 102
procedure DisplayPoezdNomer(Obj: POVStruct;form: TCanvas);//кнопка подсвет. №№ поездов 103
procedure LS_GMS(Obj: POVStruct; var MIG,LS,GMS: boolean; var niz,verh : Integer);//для сиг."Ногинск"
procedure GMS_VKG(Obj: POVStruct; var VKMG,GMS,MIG: boolean; var niz,verh: Integer);

implementation
uses

{$IFDEF RMDSP}
  TabloForm,
  KanalArmSrv,
{$ENDIF}

{$IFDEF RMSHN}
  TabloSHN,
  KanalArmSrvSHN,
{$ENDIF}


{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}


{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

  Commons;

//========================================================================================
//--------------------------------------------------------------- Нарисовать элемент табло
var
  ptr : array[1..28] of TPoint;
  sLbl,testfr : string;
  //obzav,vidbuf, x1,obfr3,y_start,x_start : integer;

procedure DisplayItemTablo(Obj: POVStruct; form: TCanvas);
label
  str1, prigl;
begin
//
//  {$IFNDEF TABLO}
{
  obzav := 70; obfr3 := 70;  //---- 1P
  y_start := 380;
  x_start := 140;
  vidbuf := integer(ObjZav[obzav].VBufferIndex);
  form.Pen.Width := 1; form.Font.Color := clBlack;
  form.Font.Size := 10; form.Font.Style := [];

  form.TextOut(410,y_start,'Name');
  testfr := ObjZav[obzav].Title;  form.TextOut(480,y_start,testfr);

  form.TextOut(10,y_start+15,'fr3');
  x1 := integer(FR3inp[obfr3]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+15,testfr);

  form.TextOut(10,y_start+30,'непарафаз');
  x1 := integer(ObjZav[obzav].bParam[32] );
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+30,testfr);

  form.TextOut(10,y_start+45,'OZ[obzav].bp[1]');
  x1 := integer(ObjZav[obzav].bParam[1]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+45,testfr);

  form.TextOut(10,y_start+60,'OZ[obzav].bp[2]');
  x1 := integer(ObjZav[obzav].bParam[2]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+60,testfr);

  form.TextOut(10,y_start+75,'OZ[obzav].bp[3]');
  x1 := integer(ObjZav[obzav].bParam[3]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+75,testfr);


  form.TextOut(10,y_start+90,'OZ[obzav].bp[4]');
  x1 := integer(ObjZav[obzav].bParam[4]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+90,testfr);

  form.TextOut(10,y_start+105,'OZ[obzav].bp[5]');
  x1 := integer(ObjZav[obzav].bParam[5]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+105,testfr);

  form.TextOut(10,y_start+120,'OVbuffer.Param[1]');
  x1 := integer(OVbuffer[vidbuf].Param[1]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+120,testfr);

  form.TextOut(10,y_start+135,'OVbuffer.Param[2]');
  x1 := integer(OVbuffer[vidbuf].Param[2]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+135,testfr);

  form.TextOut(10,y_start+150,'OVbuffer.Param[3]');
  x1 := integer(OVbuffer[vidbuf].Param[3]);
  testfr :=IntToStr(x1) ;
  form.TextOut(x_start,y_start+150,testfr);

}
  //{$ENDIF}
  try
  //TabloMain.Show;
    case Obj.TypeObj of
      1:  DisplayStatLine(Obj,form);//--------------------- нарисовать статическую ломаную
      2:  DisplayStatText(Obj,form);//--------------------- нарисовать статическую надпись
      3:  DisplayStatFigur(Obj,form);//--------------------- нарисовать статическую фигуру
      4:  DisplayNecentral(Obj,form);//--------------------- нецентрализованное примыкание
      5:  TabloMain.ImageListRU.Draw(form,obj.Points[1].X,obj.Points[1].Y,5);//----логотип
      7:  DisplayKGU(Obj,form);   //------------------------ устройство контроля габаритов
      8:  DispKnop1to2(Obj,form); //-- одна кнопка управляющая двумя дискретными объектами
      10: DisplaySP(Obj,form);    //------------------------------------ стрелочная секция
      11: DisplayStrelka(Obj,form);//---------------------------------- нарисовать стрелку
      12: DisplayPut(Obj,form); //---------------------------------------- нарисовать путь
      13: DisplayManevrIzvest(Obj,form);//-------------- нарисовать маневровый известитель
      20: DisplayManevrSvet(Obj,form);//------------------- нарисовать маневровый светофор
      21: DisplaySvetSovm(Obj,form);//-------------------- нарисовать совмещенный светофор
      22: DisplaySvetVhod(Obj,form); //----------------------- нарисовать входной светофор
      23: DisplaySvetPrig(Obj,form);//---------------- нарисовать пригласительный светофор
      24: DisplaySvetPovtor(Obj,form);//----------------- нарисовать повторитель светофора
      25: DisplayFictSignal(Obj,form);//------------------------ Фиктивный сигнал (увязка)
      26: DisplayKTAB(Obj,form);//----------------------------- контрольная точка перегона
      30: DisplayKontrPereezd(Obj,form);//--------------------------- контрольная переезда
      31: DisplayUviazkaAB(Obj,form);//--------------------------------------- увязка с АБ
      32: DisplayUviazkaABSvet(Obj,form);//увязка с АБ с проходными светофорами, капремонт
      33: DisplayPAB(Obj,form);//-------------------------------------------- увязка с ПАБ
      34: DisplayKluchJezl(Obj,form); //-------------------------- изображение ключа-жезла
      35: DisplayABbezSN(Obj,form);//---------------------------------- Увязка с АБ без СН
      36: DisplayMejPost(Obj,form); //---------------------- Увязка межпостовая с запросом
      37: DisplayGAC(Obj,form); //------------------------------------------- Увязка с ГАЦ
      38: DisplayManevrKolon(Obj,form);//------------------------------ маневровая колонка
      39: DisplayMEC(Obj,form);  //------------------------------------------ увязка с МЭЦ
      40: DisplayABPost(Obj,form); //--------------------------- увязка с АБ пост.действия
      42: DisplayPerToch(Obj,form); //----------------------- отображение перегонной точки
      43: DisplayKnopColor8(Obj,form);//--------- нарисовать лампу/кнопку для 3-х датчиков
      50: DisplayOgradPuti(Obj,form); //---------------------------------- ограждение пути
      51: DisplayUTS(Obj,form);//------------------------------------------ нарисовать UTS
      52: DisplayUKSPS(Obj,form);//-------------------------------------- нарисовать UKSPS
      53: DisplayOhrStr(Obj,form);//------------------------ нарисовать охранность стрелки
      54: DisplayKnopColor2(Obj,form);//-------------------- нарисовать кнопку 2-х цветную
      55: DisplayKnopColor3(Obj,form);//-------------------- нарисовать кнопку 3-х цветную
      56: Display3Nadpis(Obj,form);//---------------------- нарисовать 3-х цветную надпись
      57: DisplayIzvestAB(Obj,form);//------- нарисовать дополнительный (3) известитель АБ
      58: DisplayZonaOpov(Obj,form);//------------------------- нарисовать зону оповещения
      59: CounterTimer(Obj,form);//---------------------------- нарисовать счетчик времени
      60: Display2CvetLamp(Obj,form);// нарисовать двухцветную лампу контроля доп.датчиков
      70: DisplayPitUst(Obj,form);  //--------------------------------- Питающая установка
      92: DisplayDenNoch(Obj,form);//--------------- нарисовать кнопки объекта "День/Ночь"
      94: DisplaySchetKOK(Obj,form); //------------------------------- счетчик нажатий КОК
      95: DisplayIconRing(Obj,form); //-------------------------- иконка выключения звонка
      96: DisplayIconRegim(Obj,form);//------------------- нарисовать иконку режима работы
      97: DisplayKnopKonec(Obj,form);//-------------------- нарисовать кнопку конца набора
      98: Display_3Serv_8TUMS(Obj,form);//----------состояния системы "3 Сервера и 8 ТУМС"
      99: DisplayTabloRegim(Obj,form);//---------- отображение табло выбора режимов работы
     100: DisplayArmServPipe(Obj,form);// сост. системы для варианта с программным каналом
     101: DisplayPodsvetStr(Obj,form);//-----нарисовать кнопку подсветки положения стрелок
     102: DisplayVvodNomer(Obj,form);//------------- нарисовать кнопку ввода номера поезда
     103: DisplayPoezdNomer(Obj,form);//------- нарисовать кнопку подсветки номера поездов
     else form.Brush.Color := clRed; form.FillRect(rect(0,0,10,10));
   end;
  except
{$IFNDEF TABLO}
    reportf('Ошибка при выполнении [ObjSost.DisplayItemTablo]');
{$ENDIF}
  end;
end;
//========================================================================================
//------------------------------------------------------- нарисовать статическую линию (1)
procedure DisplayStatLine(Obj: POVStruct;form: TCanvas);
var
  Stil1 : TPenStyle;
  Stil2 : TBrushStyle;
begin
  Stil1 := form.Pen.Style;
  Stil2 := form.Brush.Style;
  form.Pen.Color   := GetColor1(Obj.ObjConstI[1]);
  form.Pen.Style   := GetPenStyle(Obj.ObjConstI[2]);
  form.Pen.Width   := Obj.ObjConstI[3];
  form.Brush.Color := GetColor1(Obj.ObjConstI[4]);
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
        if Obj.Points[6].X > 0 then form.LineTo(Obj.Points[6].x, Obj.Points[6].y);
      end;
    end;
  end;
  form.Pen.Style := Stil1;
  form.Brush.Style := Stil2;
end;
//========================================================================================
//----------------------------------------------------- нарисовать статическую надпись (2)
procedure DisplayStatText(Obj: POVStruct;form: TCanvas);
begin
  form.font.Color  := GetColor1(Obj.ObjConstI[1]);
  form.font.Style  := GetFontStyle(Obj.ObjConstI[2]);
  form.Brush.Color := GetColor1(Obj.ObjConstI[3]);
  form.Brush.Style := GetBrushStyle(Obj.ObjConstI[4]);
  form.font.Size   := Obj.ObjConstI[5];
  form.TextOut(Obj.Points[1].x, Obj.Points[1].y, Obj.Title);
end;
//========================================================================================
//------------------------ нарисовать статическую фигуру: рамку, эллипс, многоугольник (3)
procedure DisplayStatFigur(Obj: POVStruct;form: TCanvas);
begin
  form.pen.Color   := GetColor1(Obj.ObjConstI[1]);
  form.Pen.Style   := GetPenStyle(Obj.ObjConstI[2]);
  form.Pen.Width   := Obj.ObjConstI[3];
  form.Brush.Color := GetColor1(Obj.ObjConstI[4]);
  form.Brush.Style := GetBrushStyle(Obj.ObjConstI[5]);
  case Obj.ObjConstI[6] of
    1 : form.Ellipse(rect(Obj.Points[1],Obj.Points[2])); //------------------ круг, эллипс
    2 :  //----------------------------------------------------------------------- полигон
    begin
      if Obj.Points[6].X > 0 then form.Polygon(Obj.Points)
      else
        if Obj.Points[5].X > 0 then
        form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
        else;
        if Obj.Points[4].X > 0 then
        form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3],Obj.Points[4]])
        else;
        if Obj.Points[3].X > 0 then
        form.Polygon([Obj.Points[1],Obj.Points[2],Obj.Points[3]]);
    end;
    else form.Rectangle(rect(Obj.Points[1],Obj.Points[2]));
  end;
end;
//========================================================================================
//------------------------------------------------------ нецентрализованное примыкание (4)
procedure DisplayNecentral(Obj: POVStruct;form: TCanvas);
var x1,y1: integer;
begin
  form.pen.Color := RGB(220,220,220);
  form.Pen.Style := psSolid;
  form.Pen.Width := 5;
  form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
  case Obj.ObjConstI[1] of
    1 : //-------------------------------------------------------------------- Тупик слева
    begin
      if Obj.Points[6].X > 0 then
      form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
      else
        if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
        else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
          else
            if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
      form.MoveTo(Obj.Points[2].X-2,Obj.Points[2].Y-4);
      form.LineTo(Obj.Points[2].X,Obj.Points[2].Y-4);
      form.LineTo(Obj.Points[2].X,Obj.Points[2].Y+4);
      form.LineTo(Obj.Points[2].X-2,Obj.Points[2].Y+4);
      form.pen.Color := armcolor12; form.Pen.Width := 1;
      if Obj.Points[6].X > 0 then
      form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
      else
        if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
        else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
          else
            if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
      form.MoveTo(Obj.Points[2].X-2,Obj.Points[2].Y-4);
      form.LineTo(Obj.Points[2].X,Obj.Points[2].Y-4);
      form.LineTo(Obj.Points[2].X,Obj.Points[2].Y+4);
      form.LineTo(Obj.Points[2].X-3,Obj.Points[2].Y+4);
    end;

    2 : //------------------------------------------------------------------- Тупик справа
    begin
      if Obj.Points[6].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
      else
        if Obj.Points[5].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
        else
          if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
          else
            if Obj.Points[3].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3]]);
      form.MoveTo(Obj.Points[3].X+2,Obj.Points[3].Y-4);
      form.LineTo(Obj.Points[3].X,Obj.Points[3].Y-4);
      form.LineTo(Obj.Points[3].X,Obj.Points[3].Y+4);
      form.LineTo(Obj.Points[3].X+2,Obj.Points[3].Y+4);
      form.pen.Color := armcolor12; form.Pen.Width := 1;
      if Obj.Points[6].X > 0 then
      form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
      else
        if Obj.Points[5].X > 0 then
        form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
        else
          if Obj.Points[4].X > 0 then
          form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
          else
            if Obj.Points[3].X > 0 then
            form.PolyLine([Obj.Points[2],Obj.Points[3]]);
      form.MoveTo(Obj.Points[3].X+2,Obj.Points[3].Y-4);
      form.LineTo(Obj.Points[3].X,Obj.Points[3].Y-4);
      form.LineTo(Obj.Points[3].X,Obj.Points[3].Y+4);
      form.LineTo(Obj.Points[3].X+3,Obj.Points[3].Y+4);
    end;

    3 : //--------------------------------------- Значок увязки между парками симметричный
    begin
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

    else //--------------------------------- Нет тупика - неконтролируемый подъездной путь
    if Obj.Points[6].X > 0 then
    form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
    else
      if Obj.Points[5].X > 0 then
      form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
      else
        if Obj.Points[4].X > 0 then form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
        else
          if Obj.Points[3].X > 0 then
          form.PolyLine([Obj.Points[2],Obj.Points[3]]);
    form.pen.Color := armcolor12; form.Pen.Width := 1;
    if Obj.Points[6].X > 0 then
    form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5],Obj.Points[6]])
    else
      if Obj.Points[5].X > 0 then
      form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
      else
        if Obj.Points[4].X > 0 then
        form.PolyLine([Obj.Points[2],Obj.Points[3],Obj.Points[4]])
        else
          if Obj.Points[3].X > 0 then
          form.PolyLine([Obj.Points[2],Obj.Points[3]]);
  end;

  if Obj.Points[1].X > 0 then
  begin
    form.font.Style := [];
    form.Brush.Style := bsClear; form.Font.Size := 8; form.Font.Color := armcolor12;
    form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
  end;
end;
//========================================================================================
//-------------------------------------------------------- Устройство контроля габаритов 7
procedure DisplayKGU(Obj: POVStruct;form: TCanvas);
var
  Buf,Cod : integer;
begin
  Buf := obj.ObjConstI[1];
  if not OVBuffer[Buf].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Pen.Width := 3;
    form.MoveTo(Obj.Points[1].X,obj.Points[1].Y-4);
    form.LineTo(obj.Points[1].X,obj.Points[1].Y-16);
    form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-16);
    form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-4);
    exit;
  end;

  if OVBuffer[Buf].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14; form.Pen.Style := psSolid; form.Pen.Width := 2;
    form.MoveTo(Obj.Points[1].X,obj.Points[1].Y-4);
    form.LineTo(obj.Points[1].X,obj.Points[1].Y-16);
    form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-16);
    form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-4);
    exit;
  end;

  Cod := 0;
  if OVBuffer[Buf].Param[2] then Cod := Cod + 1; //------------------------------------ КГ
  if OVBuffer[Buf].Param[3] then Cod := Cod + 2; //----------------------------------- оКГ

  case Cod of
    0 : form.Pen.Color := armcolor8; //-------------------------------- цвет серый - норма
    1 : form.Pen.Color := armcolor7; //-------------------------------------------- желтый
    2 : form.Pen.Color := armcolor11; //--------------------------------- нарушение логики
    3 : form.Pen.Color := armcolor1; //--------------------------- сработало УКГ (красный)
  end;

  //----------------------------------------------------------------------- Нарисовать КГУ
  form.Pen.Width := 2;

  form.MoveTo(Obj.Points[1].X,obj.Points[1].Y-4);
  form.LineTo(obj.Points[1].X,obj.Points[1].Y-16);
  form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-16);
  form.LineTo(obj.Points[1].X-10,obj.Points[1].Y-4);
end;
//========================================================================================
//----------------------------------------------------- кнопка управления 2умя объектами 8
procedure DispKnop1to2(Obj: POVStruct;form: TCanvas);
var
  deltaX,x1,y1,Buffer,Param1,Param2,Zavis,Cod : integer;
  Text,TextKnop : string;
begin
  Cod := 255; //----------------------------------------------- сначала - недопустимый код 
  Buffer :=  Obj.ObjConstI[1];
  Param1 := Obj.ObjConstI[12];
  Param2 := Obj.ObjConstI[13];
  Zavis :=  Obj.ObjConstI[16];
  form.Font.Style := [];
  form.Font.Size := 8;
  form.Pen.Style := psSolid;
  deltaX := TabloMain.Canvas.TextWidth(Obj.Title) div 2;
  Text := '';
  if not OVBuffer[Buffer].Param[16] then //------------------------- отсутствие информации
  begin
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end
  else
  if OVBuffer[Buffer].NParam[Param1] or OVBuffer[Buffer].NParam[Param2]
  then //------------------------------------------------------ непарафазен любой параметр
  begin
    form.Brush.Color := armcolor14;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end
  else
  begin
    Cod := 0;
    if OVBuffer[Buffer].Param[Param1] then Cod := Cod + 1;
    if OVBuffer[Buffer].Param[Param2] then Cod := Cod + 2;
  end;

  case Cod of
    0:
    begin
      form.Brush.Color := GetColor1(Obj.ObjConstI[2]);
      form.Font.Color := GetColor1(Obj.ObjConstI[8]);
      ObjZav[Zavis].bParam[27] := false;
      ObjZav[Zavis].Timers[1].Active := false;
      ObjZav[Zavis].Timers[1].First := 0;
      if ObjZav[Obj.ObjConstI[16]].ObjConstI[9] > 0 then
      TextKnop := MsgList[ObjZav[Obj.ObjConstI[16]].ObjConstI[9]];
    end;

    1,2:    //---------------------------------------- объекты не соответствуют друг-другу
    begin
      if tab_page then form.Brush.Color := GetColor1(Obj.ObjConstI[2])
      else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);

      if not ObjZav[Zavis].bParam[27] then //-- если данная ненорма не фиксировалась ранее
      if ObjZav[Zavis].Timers[1].Active then //-------- если ранее был запущен таймер и ...
      begin
        if(LastTime > ObjZav[Zavis].Timers[1].First) then //--------- время ожидания вышло
        begin
          InsArcNewMsg(ID_Obj,550+$4000,0);   //------------ " неправильно работает схема"
          Text := GetShortMsg(1,550,Obj.Title,0);
          AddFixMessage(Text,4,3);
          ObjZav[Zavis].Timers[1].Active := false;
          ObjZav[Zavis].Timers[1].First := 0;
          ObjZav[Zavis].bParam[27] := true;
        end;
      end else
      begin
        ObjZav[Zavis].Timers[1].Active := true; //---------------- активизировать таймер 1
        ObjZav[Zavis].Timers[1].First := LastTime + 3/80000; // запомнить время завершения
      end;
    end;

    3:
    begin
      form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
      form.Font.Color := GetColor1(Obj.ObjConstI[11]);
      ObjZav[Zavis].bParam[27] := false;
      ObjZav[Zavis].Timers[1].Active := false;
      ObjZav[Zavis].Timers[1].First := 0;
      if ObjZav[Obj.ObjConstI[16]].ObjConstI[8] > 0 then
      TextKnop := MsgList[ObjZav[Obj.ObjConstI[16]].ObjConstI[8]];
    end;
  end;



    case Obj.ObjConstI[14] of
    1: //------------------------------------------------------------------ стрелка вправо
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
    end;

    2://-------------------------------------------------------------------- стрелка влево
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
    end;

    3: //------------------------------------------------------------------ простая кнопка
    begin
      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      form.Pen.Color := form.Brush.Color;
      form.Rectangle(obj.Points[1].X-deltaX+1,obj.Points[1].Y-5,
      obj.Points[1].X+deltaX-1,obj.Points[1].Y+6);

      form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX-1,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y+6);

      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX+1,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y-6);
    end;

    4:
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y+6);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+7,obj.Points[1].Y);
    end;

    5:
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX, obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-7,obj.Points[1].Y);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y-6);
    end;
    else form.RoundRect(obj.Points[1].X-deltaX-4,obj.Points[1].Y-6,
    obj.Points[1].X+deltaX+4,obj.Points[1].Y+7, 4,30);
  end;
  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  if Text = '' then
  begin
    x1 := form.TextWidth(Obj.Title) div 2;
    y1 := form.TextHeight(Obj.Title) div 2;
    form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
  end  else
  begin
    x1 := form.TextWidth(Text) div 2;
    y1 := form.TextHeight(Text) div 2;
    form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,TextKnop);
  end
end;
//==================================== 10 ================================================
//----------------------------------------------------------------- стрелочная секция (10)
procedure DisplaySP(Obj: POVStruct;form: TCanvas);
var
  x1, Utol, VidBuf : integer;
begin
  Utol := Obj.ObjConstI[2];
  VidBuf := Obj.ObjConstI[1];

  if Obj.Points[5].X > 0 then
  DrawSP(form,VidBuf,Utol,[Obj.Points[2],Obj.Points[3],Obj.Points[4],Obj.Points[5]])
//  ,Obj.Points[6],Obj.Points[1])
  else
    if Obj.Points[4].X > 0 then
    DrawSP(form,VidBuf,Utol,[Obj.Points[2],Obj.Points[3],Obj.Points[4]])
    //,Obj.Points[6],Obj.Points[1])
    else DrawSP(form,VidBuf,Utol,[Obj.Points[2],Obj.Points[3]]);
    //,Obj.Points[6],Obj.Points[1]);

  if Obj.Points[1].X > 0 then
  begin //-------------------------------------------------------- Нарисовать литер секции
    x1 := -1;
    if OVBuffer[VidBuf].Param[29]
    then x1 := 24//----------------------------------- Закрыто для движения на электротяге
    else
      if OVBuffer[VidBuf].Param[30] and OVBuffer[VidBuf].Param[31]
      then x1 := 2  //----------------------------- Закрыто для движения на 2-х родах тяги
      else
        if OVBuffer[VidBuf].Param[30]
        then x1 := 26 //----------------------------------- Закрыто для движения на пер.т.
        else
          if OVBuffer[VidBuf].Param[31]
          then x1 := 25; //------------------------------- Закрыто для движения на пост.т.

  if x1 > -1 then
  begin //------------------------------------ нарисовать иконку ограничения электротяги
    form.Pen.Width := 1;    form.Pen.Style := psSolid;    form.Pen.Color := armcolor1;

    case Obj.ObjConstI[7] of
      1 :
      begin //---------------------------------------------------- вправо по горизонтали
        TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,x1);
        form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+7,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
      end;

      2 :
      begin // ------------------------------------------------------- вниз по вертикали
        TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,x1);
        form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
        form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)+3);
      end;

      3 :
      begin //------------------------------------------------------- вверх по вертикали
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
  end;

  if OVBuffer[VidBuf].Param[32] then form.Font.Color := armcolor1 //- закрыто для движения
  else form.Font.Color := clBlack;

  if OVBuffer[VidBuf].Param[9] then //-------- Предварительная команда РИ секции выполнена
  begin
    form.Brush.Style := bsSolid;
    form.Brush.Color := armcolor9;
  end
  else  form.Brush.Style := bsClear;//--- Нет выполнения предварительной команды РИ секции

  form.Font.Size := 8; form.font.Style := [];
  form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);

  if OVBuffer[VidBuf].Param[13] and OVBuffer[VidBuf].Param[18] then
  begin
   if tab_page then form.Font.Color := armcolor1
   else form.Font.Color := clBlack;

   x1 := form.TextWidth(Obj.Title);
   form.font.Style := [fsBold];
   if x1>10 then form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!');
  end;
end;
//============================================== 11 ======================================
//---------------------------------------------------------------- нарисовать стрелку (11)
procedure DisplayStrelka(Obj: POVStruct;form: TCanvas);
label
  str1;
var
  ObjZ,Hvost,x1,x2,y1,y2,ris_dop_zam,bufer,delta,ugol,BufP,BufM : integer;
  TheRect : TRect;
  ImaT,BT : TPoint; //----------------------- литерная и базовая точки изображения стрелки
  T1,T2,M1,M2 : TPoint; //-------------------------------- точки переключателя стрелки +/-
  Cherta : array[1..2] of TPoint;
begin
  ris_dop_zam := 1;
  form.Pen.Style := psSolid;
  ugol := Obj.ObjConstI[10];
  ObjZ := Obj.ObjConstI[16]; //-------------------- стрелка в зависимостях (тип объекта 2)
  Hvost := ObjZav[ObjZ].BaseObject; // хвост стрелки в зависимостях (указывается в макете)
  bufer := Obj.ObjConstI[4]; //------------------------------------------------ видеобуфер

  OVBuffer[bufer].Param[28] := ObjZav[ObjZ].bParam[33];  //------------------ автодействие

  BT := Obj.Points[2]; //-------------------------------- координата базовой точки стрелки
  ImaT := Obj.Points[1]; //----------------------------------- координата литерала стрелки

  form.Brush.Style := bsSolid;
  begin //----------------------------------------------- Наличие макета на стрелке или МУ
    //----------------------------------------------- Наличие контроля плюсового положения
    if OVBuffer[Bufer].Param[2] and not OVBuffer[Bufer].Param[3]
    then form.Font.Color := armcolor5 //------------------------------------------ зеленый
    //---------------------------------------------- Наличие контроля минусового положения
    else
    if OVBuffer[Bufer].Param[3] and not OVBuffer[Bufer].Param[2]
    then form.Font.Color := armcolor7 //------------------------------------------- желтый
    //------------------------------------------------------ Отсутствие контроля положения
    else form.Font.Color := armcolor4;//------------------------------------------ красный
  end;
 {
  //------------------------------------ сначала стереть все признаки наложенных замыканий
  form.Pen.Width := 1;
  form.Brush.Color := armcolor15; //-------------------------------------------- цвет фона
  TheRect:= Rect(BT.X-5,BT.Y-5,BT.X+6,BT.Y+6);
  form.FrameRect(TheRect);
  }
  if not OVBuffer[bufer].Param[16] then
  begin //------------------------------------------- неактивная стрелка =  толстый черный
    form.Pen.Color := armcolor12; form.Pen.Width := 3; form.Font.Color := armcolor12;
  end else
  if OVBuffer[bufer].Param[1] then
  begin //------------------------------------------ Непарафазность стрелки = толстый циан
    form.Pen.Color := armcolor14;  form.Pen.Width := 3; form.Font.Color := armcolor14;
  end else form.Pen.Width := 1;



//--------------------------------------------------------------- Нарисовать литер стрелки
  form.Font.Size := 8; form.Font.Style := [fsBold]; form.Brush.Style := bsClear;
  if OVBuffer[Bufer].Param[11] then //----------- если признак "аварийный перевод стрелки"
  begin //-------------------------------- нажата кнопка вспомогательного перевода стрелки
    form.Pen.Color := armcolor9;  form.Pen.Width := 1;
    x1 := form.TextWidth(Obj.Title)+2;
    y1 := form.TextHeight(Obj.Title);
    form.RoundRect(ImaT.X-1,ImaT.Y,ImaT.X+x1,ImaT.Y+y1,7,10);
  end;
  form.TextOut(ImaT.X,ImaT.Y,Obj.Title);
  form.Font.Style := [];
  form.Pen.Color := 0; form.Pen.Width := 1;

  //------------------------------------------------ изображение указателей плюсовой ветви
  case Obj.ObjConstI[1] of //-----------------------------переключатель по коду начертания
    1 :  begin  form.MoveTo(BT.X + 10,BT.Y+4); form.LineTo(BT.X + 16,BT.Y+4); end;

    2 :
    begin
      if ugol = 45 then
      begin
        form.MoveTo(BT.X + 8,BT.Y+4);
        form.LineTo(BT.X + 13,BT.Y+9); form.LineTo(BT.X + 8,BT.Y+4);
      end else
      if ugol = 60 then
      begin
        form.MoveTo(BT.X + 8,BT.Y + 9);
        form.LineTo(BT.X + 6,BT.Y+4); form.LineTo(BT.X + 8,BT.Y + 9);
      end;
    end;

    3 : begin form.MoveTo(BT.X + 10,BT.Y-4); form.LineTo(BT.X + 16,BT.Y-4); end;

    4 :
    begin
      if ugol = 45 then
      begin
        form.MoveTo(BT.X + 8,BT.Y-4);
        form.LineTo(BT.X + 13,BT.Y-9); form.LineTo(BT.X + 8,BT.Y-4);
      end else
      if ugol = 60 then
      begin
        form.MoveTo(BT.X + 8,BT.Y - 9);
        form.LineTo(BT.X + 6,BT.Y-4); form.LineTo(BT.X + 8,BT.Y - 9);
      end;
    end;

    5 : begin form.MoveTo(BT.X - 10,BT.Y+4); form.LineTo(BT.X - 16,BT.Y+4); end;

    6 :
    begin
      if ugol = 45 then
      begin
        form.MoveTo(BT.X - 8,BT.Y+4);
        form.LineTo(BT.X - 13,BT.Y+9); form.LineTo(BT.X - 8,BT.Y+4);
      end else
      if ugol = 60 then
      begin
        form.MoveTo(BT.X - 8,BT.Y + 9);
        form.LineTo(BT.X - 6,BT.Y+4); form.LineTo(BT.X - 8,BT.Y + 9);
      end;
    end;

    7 : begin form.MoveTo(BT.X - 10,BT.Y-4); form.LineTo(BT.X - 16,BT.Y-4); end;

    8 :
    begin
      if ugol  = 45 then
      begin
        form.MoveTo(BT.X - 8,BT.Y-4);
        form.LineTo(BT.X - 13 ,BT.Y-9);form.LineTo(BT.X - 8,BT.Y-4);
      end else
      if ugol = 60 then
      begin
        form.MoveTo(BT.X - 8,BT.Y-9);
        form.LineTo(BT.X - 6,BT.Y-4);  form.LineTo(BT.X - 8,BT.Y-9);
      end;
    end;
  end;

  T1.X := 0; T1.Y := 0;
  T2.X := 0; T2.Y := 0;

  //====================== РИСУЕМ ВЕТКУ СТРЕЛКИ, НЕ ДАЮЩУЮ ОТКЛОНЕНИЯ ====================
  case Obj.ObjConstI[1] of //------------------------------------------ по коду начертания
    1 :
    begin //-------------------------- Получить смещение разрывчика  для 1-ой конфигурации
      if OVBuffer[Bufer].Param[2] and not OVBuffer[Bufer].Param[3] then //--- если в плюсе
      begin T1 := BT; T2.X := BT.X + 7; T2.Y := BT.Y; end else

      if not OVBuffer[Bufer].Param[2] and OVBuffer[Bufer].Param[3] then //-- если в минусе
      begin
        if ugol = 45 then
        begin
          T1.X := BT.X + 1; T1.Y := BT.Y - 6;
          T2.X := BT.X + 7; T2.Y := BT.Y;
        end else
        if ugol = 60 then
        begin
          T1.X := BT.X + 5; T1.Y := BT.Y - 5;
          T2.X := BT.X + 7; T2.Y := BT.Y;
        end;
      end else
      begin T1.X := BT.X + 4;T1.Y := BT.Y; T2.X := 0;  T2.Y := 0; end;// если без контроля
    end;

    2 :
    begin     //---------------------- Получить смещение разрывчика для 2-ой конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //------- в плюсе
      begin
        if ugol = 45 then
        begin T1.X := BT.X + 1; T1.Y := BT.Y - 6; T2.X := BT.X + 7; T2.Y := BT.Y; end else
        if ugol = 60 then
        begin T1.X := BT.X + 5; T1.Y := BT.Y - 5; T2.X := BT.X + 7; T2.Y := BT.Y; end;
      end  else

      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin  T1 := BT; T2.X := BT.X + 7; T2.Y := BT.Y;   end else
      begin  T1.X := BT.X+4; T1.Y := BT.Y; T2.X := 0;   T2.Y := 0; end; //--- без контроля
    end;

    3 :
    begin //---------------------------- Получить смещение разрывчика для 3-й конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then
      begin T1 := BT; T2.X := BT.X+7; T2.Y := BT.Y; end else  //------------------ в плюсе

      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then  //------ в минусе
      begin
        if ugol = 45 then
        begin  T1.X := BT.X+2; T1.Y := BT.Y+5; T2.X := BT.X + 7; T2.Y := BT.Y;  end else

        if ugol = 60 then
        begin   T1.X := BT.X + 5; T1.Y := BT.Y + 5; T2.X := BT.X + 7; T2.Y := BT.Y; end;
      end else
      begin
        T1.X := BT.X+4; T1.Y := BT.Y;    T2.X := 0;      T2.Y := 0;    end;
    end;

    4 :
    begin     //---------------------- Получить смещение разрывчика для 2-ой конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //------- в плюсе
      begin
        if ugol = 45 then
        begin T1.X := BT.X + 1; T1.Y := BT.Y + 6; T2.X := BT.X + 7; T2.Y := BT.Y; end else
        if ugol = 60 then
        begin T1.X := BT.X + 5; T1.Y := BT.Y + 5; T2.X := BT.X + 7; T2.Y := BT.Y; end;
      end  else

      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin  T1 := BT; T2.X := BT.X + 7; T2.Y := BT.Y;   end else
      begin  T1.X := BT.X+4; T1.Y := BT.Y; T2.X := 0;   T2.Y := 0; end; //--- без контроля
    end;


    5 :
    begin  //-------------------------- Получить смещение разрывчика для 5-ой конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then
      begin T1 := BT; T2.X := BT.X - 7; T2.Y := BT.Y; end else

      if not OVBuffer[Bufer].Param[2] and OVBuffer[Bufer].Param[3] then //-- если в минусе
      begin
        if ugol = 45 then
        begin
          T1.X := BT.X - 1; T1.Y := BT.Y - 6;
          T2.X := BT.X - 7; T2.Y := BT.Y;
        end else
        if ugol = 60 then
        begin
          T1.X := BT.X - 5; T1.Y := BT.Y - 5;
          T2.X := BT.X - 7; T2.Y := BT.Y;
        end;
      end else
      begin T1.X := BT.X - 4;T1.Y := BT.Y; T2.X := 0;  T2.Y := 0; end;// если без контроля
    end;

    6 :
    begin     //---------------------- Получить смещение разрывчика для 6-ой конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //------- в плюсе
      begin
        if ugol = 45 then
        begin T1.X := BT.X - 1; T1.Y := BT.Y - 6; T2.X := BT.X - 7; T2.Y := BT.Y; end else
        if ugol = 60 then
        begin T1.X := BT.X - 5; T1.Y := BT.Y - 5; T2.X := BT.X - 7; T2.Y := BT.Y; end;
      end  else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin  T1 := BT; T2.X := BT.X - 7; T2.Y := BT.Y;   end else
      begin  T1.X := BT.X-4; T1.Y := BT.Y; T2.X := 0;   T2.Y := 0; end; //--- без контроля
    end;

    7 :
    begin   //-------------------------- Получить смещение разрывчика для 7-й конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then
      begin T1 := BT; T2.X := BT.X-7; T2.Y := BT.Y; end else  //------------------ в плюсе

      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then  //------ в минусе
      begin
        if ugol = 45 then
        begin T1.X := BT.X - 2; T1.Y := BT.Y + 5; T2.X := BT.X - 7; T2.Y := BT.Y; end else

        if ugol = 60 then
        begin  T1.X := BT.X - 5; T1.Y := BT.Y + 5; T2.X := BT.X - 7; T2.Y := BT.Y; end;
      end else
      begin T1.X := BT.X - 4;  T1.Y := BT.Y;  T2.X := 0;  T2.Y := 0; end;
    end;

    8 :
    begin   //-------------------------- Получить смещение разрывчика для 8-й конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //------- в плюсе
      begin
        if ugol = 45 then
        begin T1.X := BT.X - 1; T1.Y := BT.Y + 6; T2.X := BT.X - 7; T2.Y := BT.Y; end else
        if ugol = 60 then
        begin T1.X := BT.X - 5; T1.Y := BT.Y + 5; T2.X := BT.X - 7; T2.Y := BT.Y; end;
      end  else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin  T1 := BT; T2.X := BT.X - 7; T2.Y := BT.Y;   end else
      begin  T1.X := BT.X-4; T1.Y := BT.Y; T2.X := 0;   T2.Y := 0; end; //--- без контроля
    end;
  end;

  BufP := Obj.ObjConstI[2];

  if (T2.X > 0) and (T2.Y > 0) then DrawSP(form,BufP,0,[T1,T2,Obj.Points[3]])
  else DrawSP(form,BufP,0,[T1,Obj.Points[3]]);


  if ((Obj.Points[6].X > 0) and (Obj.ObjConstI[8] = 0))then //псевдо-СП и окраска по плюсу
  begin form.MoveTo(BT.X,BT.Y);form.LineTo(Obj.Points[6].X,Obj.Points[6].Y); end;

  if ((form.Pen.Color = armcolor1)or(form.Pen.Color = armcolor7)) and
  (form.Pen.Width = 3) and (not OVBuffer[bufer].Param[28]) and
  (not ObjZav[Hvost].bParam[4]) and (not ObjZav[ObjZ].bParam[4])
  then ris_dop_zam := 0;

  if ris_dop_zam = 1 then
  begin
   form.Brush.Color := armcolor8;
   TheRect := Rect(BT.X-5,BT.Y-5,BT.X+6,BT.Y+6);
   if OVBuffer[bufer].Param[6] then     //---------- охранность при трассировке
   begin //----- требование перевода охранной стрелки в охранное положение при трассировке
    form.Brush.Color := armcolor9; //----------------------------------------- перо  белое
    form.Pen.Width := 1;
    form.FrameRect(TheRect);
   end else
   if OVBuffer[bufer].Param[5] then //----------------------- требуется перевод
   begin //---------------------- Признак отсутствия контроля требуемого положения стрелки
    form.Brush.Color := armcolor9;  //----------------------------------------- перо белое
    form.FrameRect(TheRect);
   end;

   OVBuffer[bufer].Param[7] := ObjZav[Hvost].bParam[4] or ObjZav[ObjZ].bParam[4];

   if OVBuffer[bufer].Param[7] or OVBuffer[bufer].Param[28]  then //- замыкание в охранном
   begin //------------- охранная стрелка замкнута в охранное положение или в автодействии
    form.Brush.Color := armcolor8;
    form.Pen.Width := 1;
    form.FrameRect(TheRect);
   end;
  end;

  if OVBuffer[bufer].Param[31] then //----------------------------- если cтрелка на макете
  begin
    form.Pen.Style := psSolid;
    TabloMain.ImageList.Draw(form,obj.Points[2].X-6,obj.Points[2].Y-6,0);
    maket_strelki_index := Hvost;
    maket_strelki_name  := ObjZav[maket_strelki_index].Liter;
  end else //--------------------------------------------------- если стрелка не на макете
  if maket_strelki_index = Hvost  then
  begin
    maket_strelki_index := 0;
    maket_strelki_name  := '';
  end;

  M1.X := 0; M1.Y := 0;
  M2.X := 0; M2.Y := 0;
  //=========================== РИСУЕМ ОТКЛОНЯЮЩУЮ ВЕТКУ СТРЕЛККИ ========================
  case Obj.ObjConstI[1] of
    1 :
    begin  //------------------------------------- Получить смещения для 1-ой конфигурации
      if OVBuffer[bufer].Param[2] and  not OVBuffer[bufer].Param[3] then //------- в плюсе
      begin
        if ugol = 45 then
        begin M1.X := BT.X - 4; M1.Y := BT.Y+3; M2.X := BT.X + 3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1.X := BT.X - 5; M1.Y := BT.Y+4; M2.X := BT.X+2; M2.Y := BT.Y+4; end;
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin
        if ugol = 45 then
        begin  M1 := BT; M2.X := BT.X+3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X+2; M2.Y := BT.Y+5; end;
      end else //------------------------------------------------------------ без контроля
      begin
        if ugol = 45 then
        begin  M1.X := BT.X+3;  M1.Y := BT.Y+3;  M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin  M1.X := BT.X+2;  M1.Y := BT.Y+4;  M2.X := 0; M2.Y := 0; end;
      end;
    end;

    2 :  //--------------------------------------- Получить смещения для 2-ой конфигурации
    begin
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //стрелка в плюсе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X+3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X+1; M2.Y := BT.Y+3; end else
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1.X := BT.X-4; M1.Y := BT.Y+3; M2.X := BT.X+3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1.X := BT.X-5; M1.Y := BT.Y+4; M2.X := BT.X+2; M2.Y := BT.Y+4; end;
      end else
      begin //------------------------------------------------------- стрелка без контроля
        if ugol = 45 then
        begin M1.X := BT.X+3; M1.Y := BT.Y+3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X+2; M1.Y := BT.Y+4; M2.X := 0; M2.Y := 0; end;
      end;
    end;

    3 :  //---------------------------------------- Получить смещения для 3-й конфигурации
    begin
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then // стрелка в плюсе
      begin
         if ugol = 45 then
        begin M1.X := BT.X-4; M1.Y := BT.Y-3; M2.X := BT.X+3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1.X := BT.X-5; M1.Y := BT.Y-4; M2.X := BT.X+2; M2.Y := BT.Y-4; end;
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X+3;  M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X+1;  M2.Y := BT.Y-3; end else
      end else //---------------------------------------------------- стрелка без контроля
      begin
        if ugol = 45 then
        begin M1.X := BT.X+3; M1.Y := BT.Y-3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X+2; M1.Y := BT.Y-4; M2.X := 0; M2.Y := 0; end;
      end;
    end;

    4 :  //--------------------------------------- Получить смещения для 4-ой конфигурации
    begin
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //стрелка в плюсе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X+3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X+1; M2.Y := BT.Y-3; end else
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1.X := BT.X-4; M1.Y := BT.Y-3; M2.X := BT.X+3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1.X := BT.X-5; M1.Y := BT.Y-4; M2.X := BT.X+2; M2.Y := BT.Y-4; end;
      end else
      begin //------------------------------------------------------- стрелка без контроля
        if ugol = 45 then
        begin M1.X := BT.X+3; M1.Y := BT.Y-3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X+2; M1.Y := BT.Y-4; M2.X := 0; M2.Y := 0; end;
      end;
    end;

    5 :
    begin  //------------------------------------- Получить смещения для 5-ой конфигурации
      if OVBuffer[bufer].Param[2] and  not OVBuffer[bufer].Param[3] then //------- в плюсе
      begin
        if ugol = 45 then
        begin M1.X := BT.X + 4; M1.Y := BT.Y+3; M2.X := BT.X - 3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1.X := BT.X + 5; M1.Y := BT.Y+4; M2.X := BT.X-2; M2.Y := BT.Y+4; end;
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //------- в минусе
      begin
        if ugol = 45 then
        begin  M1 := BT; M2.X := BT.X-3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X-2; M2.Y := BT.Y+4; end;
      end else //------------------------------------------------------------ без контроля
      begin
        if ugol = 45 then
        begin  M1.X := BT.X-3;  M1.Y := BT.Y+3;  M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin  M1.X := BT.X-2;  M1.Y := BT.Y+4;  M2.X := 0; M2.Y := 0; end;
      end;
    end;

    6 :  //--------------------------------------- Получить смещения для 6-ой конфигурации
    begin
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //стрелка в плюсе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X-3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X-1; M2.Y := BT.Y+3; end else
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1.X := BT.X+4; M1.Y := BT.Y+3; M2.X := BT.X-3; M2.Y := BT.Y+3; end else
        if ugol = 60 then
        begin M1.X := BT.X+5; M1.Y := BT.Y+4; M2.X := BT.X-2; M2.Y := BT.Y+4; end;
      end else
      begin //------------------------------------------------------- стрелка без контроля
        if ugol = 45 then
        begin M1.X := BT.X-3; M1.Y := BT.Y+3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X-2; M1.Y := BT.Y+4; M2.X := 0; M2.Y := 0; end;
      end;
    end;

    7 :
    begin
      //------------------------------------------- Получить смещения для 7-й конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then // стрелка в плюсе
      begin
        if ugol = 45 then
        begin M1.X := BT.X+4; M1.Y := BT.Y-3; M2.X := BT.X-3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1.X := BT.X+5; M1.Y := BT.Y-4; M2.X := BT.X-2; M2.Y := BT.Y-4; end;
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X-3;  M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X-2;  M2.Y := BT.Y-4; end else
      end else //---------------------------------------------------- стрелка без контроля
      begin
        if ugol = 45 then
        begin M1.X := BT.X-3; M1.Y := BT.Y-3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X-2; M1.Y := BT.Y-4; M2.X := 0; M2.Y := 0; end;
      end;
    end;

    8 :
    begin //--------------------------------------- Получить смещения для 8-й конфигурации
      if OVBuffer[bufer].Param[2] and not OVBuffer[bufer].Param[3] then  //стрелка в плюсе
      begin
        if ugol = 45 then
        begin M1 := BT; M2.X := BT.X-3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1 := BT; M2.X := BT.X-2; M2.Y := BT.Y-4; end else
      end else
      if not OVBuffer[bufer].Param[2] and OVBuffer[bufer].Param[3] then //стрелка в минусе
      begin
        if ugol = 45 then
        begin M1.X := BT.X+4; M1.Y := BT.Y-3; M2.X := BT.X-3; M2.Y := BT.Y-3; end else
        if ugol = 60 then
        begin M1.X := BT.X+5; M1.Y := BT.Y-4; M2.X := BT.X-2; M2.Y := BT.Y-4; end;
      end else
      begin //------------------------------------------------------- стрелка без контроля
        if ugol = 45 then
        begin M1.X := BT.X-3; M1.Y := BT.Y-3; M2.X := 0; M2.Y := 0; end else
        if ugol = 60 then
        begin M1.X := BT.X-2; M1.Y := BT.Y-4; M2.X := 0; M2.Y := 0; end;
      end;
    end;
  end;

  BufM := Obj.ObjConstI[3];
  if (M2.X > 0) and (M2.Y > 0) then //----------------------------- стрелка имеет контроль
  begin
    if Obj.Points[5].X > 0 then
    begin
      case Obj.ObjConstI[1] of
        1,2,5,6 : DrawSP(form,BufM,0,[M1,M2,Obj.Points[4],Obj.Points[5]])
        else DrawSP(form,BufM,0,[Obj.Points[5],Obj.Points[4],M2,M1]);
      end;
    end  else
    begin
      case Obj.ObjConstI[1] of
        1,2,5,6 : DrawSP(form,BufM,0,[M1,M2,Obj.Points[4]])
        else DrawSP(form,BufM,0,[Obj.Points[4],M2,M1]);
      end;
    end;
  end else //-------------------------------------------------------- стрелка без контроля
  begin
    if Obj.Points[5].X > 0 then
    begin
      case Obj.ObjConstI[1] of
        1,2,5,6 : DrawSP(form,BufM,0,[M1,Obj.Points[4],Obj.Points[5]])
        else DrawSP(form,BufM,0,[Obj.Points[5],Obj.Points[4],M1]);
      end;
    end else
    begin
      case Obj.ObjConstI[1] of
        1,2,5,6 : DrawSP(form,BufM,0,[M1,Obj.Points[4]])
        else DrawSP(form,BufM,0,[Obj.Points[4],M1]);
      end;
    end;
  end;

  if ((Obj.Points[6].X > 0) and (Obj.ObjConstI[8] = 1))then//псевдо-СП и окраска по минусу
  begin
    form.MoveTo(BT.X,BT.Y); form.LineTo(Obj.Points[6].X,Obj.Points[6].Y);
  end;

  if((form.Pen.Color = armcolor1)or(form.Pen.Color = armcolor7))and(form.Pen.Width = 3)
  then ris_dop_zam := 0;


   //--------------------------------------------------------------- Ограничения на стрелку
  if OVBuffer[bufer].Param[32] then //-------------------- Стрелка выключена из управления
  begin
    form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
    case Obj.ObjConstI[7] of
      1 :
      begin //------------------------------------------------------ вправо по горизонтали
        TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,3);
        form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
      end;
      2 :
      begin //---------------------------------------------------------- вниз по вертикали
        TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,3);
        form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
        form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title));
      end;
      3 :
      begin //--------------------------------------------------------- вверх по вертикали
        TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,3);
        form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y);
        form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
      end;
      else //-------------------------------------------------------- влево по горизонтали
        TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,3);
        form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
    end;
  end;

  if OVBuffer[bufer].Param[30] then //----------------------- Стрелка закрыта для движения
  begin
    form.Brush.Color := armcolor4;
    form.Pen.Color := armcolor4;
    form.Pen.Width := 1;
    form.Pen.Style := psSolid;
    case Obj.ObjConstI[1] of
      1,2,3,4 : //-------------------------------- код начертания стрелки - по плюсу прямо
      begin
        case Obj.ObjConstI[5] of //--- ---------------------------- направление отрезка СП
          1 : //-------------------------------------------------------------------- вверх
            form.Polygon([Point(obj.Points[2].X-9,obj.Points[2].Y-5),
            Point(obj.Points[2].X+2,obj.Points[2].Y-10),
            Point(obj.Points[2].X+4,obj.Points[2].Y-6),
            Point(obj.Points[2].X-7,obj.Points[2].Y-1)]);
          2 : //--------------------------------------------------------------------- вниз
            form.Polygon([Point(obj.Points[2].X-7,obj.Points[2].Y+1),
            Point(obj.Points[2].X+4,obj.Points[2].Y+6),
            Point(obj.Points[2].X+2,obj.Points[2].Y+10),
            Point(obj.Points[2].X-9,obj.Points[2].Y+5)]);
          else //----------------------------------------------------------- горизонтально
            form.Polygon([Point(obj.Points[2].X-8,obj.Points[2].Y-6),
            Point(obj.Points[2].X-4,obj.Points[2].Y-6),
            Point(obj.Points[2].X-4,obj.Points[2].Y+7),
            Point(obj.Points[2].X-8,obj.Points[2].Y+7)]);
        end;
      end;
      else //-------------------------------------------- код начертания - по минусу прямо
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
    if OVBuffer[bufer].Param[29] then //---------- Стрелка закрыта для противошерст.движ-я
    begin//-----------------(если не закрыта для движения по всем направлениям - рисовать)
      form.Brush.Color := armcolor1;
      form.Pen.Color := armcolor1;
      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      case Obj.ObjConstI[1] of  //---------------------------- переключатель по начертанию
        1,2,3,4 : //-------------------------------------- код начертания - по плюсу прямо
          case Obj.ObjConstI[5] of
            1 :  form.Polygon([Point(obj.Points[2].X-7,obj.Points[2].Y-6),
                    Point(obj.Points[2].X,obj.Points[2].Y-9),
                    Point(obj.Points[2].X-1,obj.Points[2].Y-3)]);
            2 :  form.Polygon([Point(obj.Points[2].X-1,obj.Points[2].Y+3),
                    Point(obj.Points[2].X,obj.Points[2].Y+9),
                    Point(obj.Points[2].X-7,obj.Points[2].Y+6)]);
            else form.Polygon([Point(obj.Points[2].X-8,obj.Points[2].Y-5),
                    Point(obj.Points[2].X-8,obj.Points[2].Y+5),
                    Point(obj.Points[2].X-3,obj.Points[2].Y)]);
          end;
        else //------------------------------------------ код начертания - по минусу прямо
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
//========================================================================================
//------------------------------------ отображение на экране приемо-отправочного пути (12)
procedure DisplayPut(Obj: POVStruct; form: TCanvas);
//---------------------- РМ не отображаем, всегда выводим на табло положение датчиков пути
var
  x1,x2,y1,y2 : integer;
begin
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then //------------- нецентрализованный путь
  begin
    form.Pen.Color := armcolor12; form.Pen.Width := 3; //------------ черная толстая линия
  end
  else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then //---------------------- непарафазность пути
  begin
    form.Pen.Color := armcolor14; form.Pen.Width := 3; //-------------- толстая циан-линия
  end
  else
  if OVBuffer[obj.ObjConstI[1]].Param[4] then //----------------------- если путь свободен
  begin
    form.Pen.Color := 0;
    if OVBuffer[obj.ObjConstI[1]].Param[2] and //------------- если нет замыкания по НИ и
    OVBuffer[obj.ObjConstI[1]].Param[3] then //----------------------- нет замыкания по ЧИ
    begin
      if OVBuffer[obj.ObjConstI[1]].Param[6] then //-- если нет предварительного замыкания
      begin //------------------------------------------------------- свободен и разомкнут
        form.Pen.Width := 1; form.Pen.Color := 0; //------------------ тонкая черная линия
      end
      else
      begin //----------------------- предварительное замыкание или программное на сервере
        if OVBuffer[obj.ObjConstI[1]].Param[14] //-------------- если замыкание на сервере
        then form.Pen.Width := 3 //-------------------------------------- то линия толстая
        else form.Pen.Width := 1; //----------------------------------------- иначе тонкая
        form.Pen.Color := armcolor9; //--------------------------------------------- белая
      end;
    end
    else //---------------------------- если есть замыкания по релейным условиям НИ или ЧИ
    begin //---------------------------------------------------- замыкание при свободности
      form.Pen.Color := armcolor7; //----------------------------------------- цвет желтый
      form.Pen.Width := 3; //----------------------------------------------- линия толстая
    end;
  end else  //-------------------------------------------------------- если занятость пути
  begin //--------------------------------------------------------------------- Путь занят
    form.Pen.Width := 3; //------------------------------------------------- линия толстая
    form.Pen.Color := armcolor1; //------------------------------------------ цвет красный
  end;
  form.Pen.Style := psSolid;
  form.MoveTo(obj.Points[2].X,obj.Points[2].Y);
  form.LineTo(obj.Points[3].X,obj.Points[3].Y);
  if OVBuffer[obj.ObjConstI[1]].Param[16] and //----------- если есть активность объекта и
  not OVBuffer[obj.ObjConstI[1]].Param[1] then  //--------------------- нет непарафазности
  begin
    if not OVBuffer[obj.ObjConstI[1]].Param[4] and //--------------- если занятость пути и
    not OVBuffer[obj.ObjConstI[1]].Param[6] then  //------- есть предварительное замыкание
    begin //--- занят и есть предварительное замыкание - белая полоса поверх занятого пути
      form.Pen.Width := 1;
      form.Pen.Color := armcolor9;
      form.MoveTo(obj.Points[2].X,obj.Points[2].Y);
      form.LineTo(obj.Points[3].X,obj.Points[3].Y);
    end;
  end;
  //--------------------------------------------------------------------------- Исключалки
  if OVBuffer[obj.ObjConstI[1]].Param[16] and
  not OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin//------------------------------------------------------------- активен и парафазен
    if obj.Points[2].X < obj.Points[3].X then //---------- если путь начинается из точки 2
    begin //--------------------------------------------------------------- Нечетные слева
      if not OVBuffer[obj.ObjConstI[1]].Param[3] then //----------- если есть ЧИ-замыкание
      begin //---------------------------------------------------------- четная исключалка
        form.Pen.Style := psSolid; form.Pen.Width := 2;
        if OVBuffer[obj.ObjConstI[1]].Param[7] // ------------------------------- если НКМ
        then form.Pen.Color := armcolor7       // --------------------------------- желтый
        else form.Pen.Color := armcolor5;      // -------------------------------- зеленый
        x1 := obj.Points[2].X + 11;  y1 := obj.Points[2].Y - 4;
        x2 := obj.Points[2].X + 5;   y2 := obj.Points[2].Y +4;
        form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
      end;
      if not OVBuffer[obj.ObjConstI[1]].Param[2] then //-------------------------- если НИ
      begin //-------------------------------------------------------- нечетная исключалка
        form.Pen.Style := psSolid;
        form.Pen.Width := 2;
        if OVBuffer[obj.ObjConstI[1]].Param[5]
        then form.Pen.Color := armcolor7
        else form.Pen.Color := armcolor5;
        x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4;
        x2 := obj.Points[3].X - 5;  y2 := obj.Points[3].Y +4;
        form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
      end;
    end else //------------------------------------------- если путь начинается из точки 3
    begin //-------------------------------------------------------------- Нечетные справа
      if not OVBuffer[obj.ObjConstI[1]].Param[3] then
      begin //---------------------------------------------------------- четная исключалка
        form.Pen.Style := psSolid; form.Pen.Width := 2;
        if OVBuffer[obj.ObjConstI[1]].Param[7]
        then form.Pen.Color := armcolor7
        else form.Pen.Color := armcolor5;
        x1 := obj.Points[2].X - 11; y1 := obj.Points[2].Y - 4;
        x2 := obj.Points[2].X - 5;  y2 := obj.Points[2].Y +4;
        form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
      end;
      if not OVBuffer[obj.ObjConstI[1]].Param[2] then
      begin //-------------------------------------------------------- нечетная исключалка
        form.Pen.Style := psSolid; form.Pen.Width := 2;
        if OVBuffer[obj.ObjConstI[1]].Param[5]
        then form.Pen.Color := armcolor7
        else form.Pen.Color := armcolor5;
        x1 := obj.Points[3].X + 11; y1 := obj.Points[3].Y - 4;
        x2 := obj.Points[3].X + 5;  y2 := obj.Points[3].Y +4;
        form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
      end;
    end;
  end else
  begin
    if not OVBuffer[obj.ObjConstI[1]].Param[16] then
    begin //--------------------------------------------------------------- нет информации
      form.Pen.Style := psSolid; form.Pen.Width := 1; form.Pen.Color := armcolor12;
      x1 := obj.Points[2].X + 11; y1 := obj.Points[2].Y - 4;
      x2 := obj.Points[2].X + 5;  y2 := obj.Points[2].Y +4;
      form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
      x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4;
      x2 := obj.Points[3].X - 5;  y2 := obj.Points[3].Y +4;
      form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
    end else
    begin //--------------------------------------------------------------- непарофазность
      form.Pen.Style := psSolid; form.Pen.Width := 1; form.Pen.Color := armcolor14;
      x1 := obj.Points[2].X + 11; y1 := obj.Points[2].Y - 4;
      x2 := obj.Points[2].X + 5; y2 := obj.Points[2].Y +4;
      form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[2].Y); form.LineTo(x1,y2);
      x1 := obj.Points[3].X - 11; y1 := obj.Points[3].Y - 4;
      x2 := obj.Points[3].X - 5;  y2 := obj.Points[3].Y +4;
      form.MoveTo(x1,y1); form.LineTo(x2,obj.Points[3].Y); form.LineTo(x1,y2);
    end;
  end;

  if Obj.Points[1].X > 0 then //------------------------------------------ если есть литер
  begin
    x1 := -1;
    if OVBuffer[Obj.ObjConstI[1]].Param[29] then x1 := 24//Закрыт для движ.на электротяге
    else
      if OVBuffer[Obj.ObjConstI[1]].Param[30]
      and OVBuffer[Obj.ObjConstI[1]].Param[31] then x1 := 2// Закрыт для движ.на 2-х родах тяги
      else
        if OVBuffer[Obj.ObjConstI[1]].Param[30] then x1 := 26 // Закрыт для движ. на пер.т.
        else
          if OVBuffer[Obj.ObjConstI[1]].Param[31] then x1 := 25; //Закрыт для движ. на пост.т.
    if x1 > -1 then
    begin //------------------------------------ нарисовать иконку ограничения электротяги
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
      case Obj.ObjConstI[7] of
        1 :
        begin //---------------------------------------------------- вправо по горизонтали
          TabloMain.ImageList.Draw(form,obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y,x1);
          form.MoveTo(obj.Points[1].X+form.TextWidth(obj.Title)-2,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          form.LineTo(obj.Points[1].X+form.TextWidth(obj.Title)+7,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
        end;
        2 :
        begin //-------------------------------------------------------- вниз по вертикали
          TabloMain.ImageList.Draw(form,obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-2,x1);
          form.MoveTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
          form.LineTo(obj.Points[1].X,obj.Points[1].Y+form.TextHeight(obj.Title)+3);
        end;
        3 :
        begin //------------------------------------------------------- вверх по вертикали
          TabloMain.ImageList.Draw(form,obj.Points[1].X-9+form.TextWidth(obj.Title),obj.Points[1].Y-10,x1);
          form.MoveTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y-3);
          form.LineTo(obj.Points[1].X+2+form.TextWidth(obj.Title),obj.Points[1].Y+6);
        end;
        else //------------------------------------------------------ влево по горизонтали
          TabloMain.ImageList.Draw(form,obj.Points[1].X-12,obj.Points[1].Y,x1);
          form.MoveTo(obj.Points[1].X-5,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
          form.LineTo(obj.Points[1].X+4,obj.Points[1].Y+form.TextHeight(obj.Title)-2);
      end;
    end;
    form.Brush.Style := bsClear; form.Font.Size := 8; form.font.Style := [];
    if OVBuffer[Obj.ObjConstI[1]].Param[32] then
    form.Font.Color := armcolor1
    else  form.Font.Color := clBlack;
    form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
    if OVBuffer[Obj.ObjConstI[1]].Param[13] and //--------------------- если диагностика и
    OVBuffer[Obj.ObjConstI[1]].Param[18] and // --------------- активен район управления и
    tab_page then   //------------------------------------- если надо включить при мигании
    begin
      x1 := form.TextWidth(Obj.Title);
      form.font.Style := [fsBold];
      form.Font.Color := armcolor1;
      form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!'); //-отметить восклицательным
    end;
  end;
end;
//========================================================================================
//------------------------------------------------- изобразить маневровый известитель (13)
procedure DisplayManevrIzvest(Obj: POVStruct;form: TCanvas);
var x1 : integer;
begin
  if obj.ObjConstI[2] = 1 then x1 := 4 //если включен в зависимости и рисовать в виде пути
  else x1 := 2; //----------------------------- если вне зависимостей и рисуется лампочкой
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //-------------------------------------------------------- нецентрализованный путь
    form.Pen.Color := armcolor12; form.Pen.Width := 3;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin //------------------------------------------------------------ непарафазность пути
    form.Pen.Color := armcolor14; form.Pen.Width := 3; form.Pen.Style := psSolid;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[x1] then //-------------------------- занятость пути
  begin
    form.Pen.Color := 0; form.Pen.Width := 1;
  end else
  begin
    form.Pen.Width := 1; form.Pen.Color := armcolor1;
  end;
  form.MoveTo(obj.Points[2].X,obj.Points[2].Y);
  form.LineTo(obj.Points[3].X,obj.Points[3].Y);
  if Obj.Points[1].X > 0 then
  begin //--------------------------------------- Нарисовать литер маневрового известителя
    if OVBuffer[Obj.ObjConstI[1]].Param[19] or
    OVBuffer[Obj.ObjConstI[1]].Param[20] or
    OVBuffer[Obj.ObjConstI[1]].Param[21] or
    OVBuffer[Obj.ObjConstI[1]].Param[22] or
    OVBuffer[Obj.ObjConstI[1]].Param[23] or
    OVBuffer[Obj.ObjConstI[1]].Param[24] or
    OVBuffer[Obj.ObjConstI[1]].Param[25] or
    OVBuffer[Obj.ObjConstI[1]].Param[26] or
    OVBuffer[Obj.ObjConstI[1]].Param[27] or
    OVBuffer[Obj.ObjConstI[1]].Param[28] or
    OVBuffer[Obj.ObjConstI[1]].Param[29] or
    OVBuffer[Obj.ObjConstI[1]].Param[30] or
    OVBuffer[Obj.ObjConstI[1]].Param[31] or
    OVBuffer[Obj.ObjConstI[1]].Param[32]
    then form.Font.Color := armcolor1
    else form.Font.Color := clBlack;
    form.Brush.Style := bsClear; form.Font.Size := 8; form.font.Style := [];
    form.TextOut(Obj.Points[1].X, Obj.Points[1].Y, Obj.Title);
    if OVBuffer[Obj.ObjConstI[1]].Param[13] and
    OVBuffer[Obj.ObjConstI[1]].Param[18] and
    tab_page then
    begin
      x1 := form.TextWidth(Obj.Title);
      form.font.Style := [fsBold];
      form.Font.Color := armcolor1;
      form.TextOut(Obj.Points[1].X+ x1, Obj.Points[1].Y, '!');
    end;
  end;
end;
//========================================================================================
//--------------------------------------------------------------- маневровый светофор (20)
procedure DisplayManevrSvet(Obj: POVStruct;form: TCanvas);
var
  x1,x2 : integer;
  cvet_pen,cvet_kist : Tcolor;
begin
  cvet_pen := form.Pen.Color;
  cvet_kist := form.Brush.Color;
  form.Font.Size := 8; form.Font.Style := [];
  case obj.ObjConstI[2] of //----------------------------- Определить ориентацию светофора
    1 ://--------------------------------------------------------------------- нога справа
    begin
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
      if obj.ObjConstI[3] = 0 then //------------------------------------------ карликовый
      begin
        ptr[3].X := 0; ptr[4].X := 0;
        ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
      end else//----------------------------------------------------------------- мачтовый
      begin
        ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
        ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
      end;
      ptr[7].X := Obj.Points[1].X+2;
      ptr[7].Y := Obj.Points[1].Y-6;
    end;
    else //-------------------------------------------------------------------- нога слева
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
      if obj.ObjConstI[3] = 0 then //------------------------------------------ карликовый
      begin
        ptr[3].X := 0; ptr[4].X := 0;
        ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
      end else //---------------------------------------------------------------- мачтовый
      begin
        ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
        ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
      end;
      form.Font.Style := [];
      ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-2;
      ptr[7].Y := Obj.Points[1].Y-6;
  end;

  //----------------------------------------------------------------------- нога светофора
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then //----------------- если нет активности
  begin
    form.Pen.Color := armcolor12; //--------------------------------------------- черный
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then //------------------------- непарафазность
  begin
    form.Pen.Color := armcolor15; //----------------------------------------------- циан
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor15;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[30] then  //---------- если нужно погасить на экране
  begin
    form.Pen.Color := armcolor15; //-------------------------------------------------- фон
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor15;
    form.Font.Color := armcolor15;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  begin
    form.Pen.Color := 0;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor15; //---------------------------------------- цвет фона
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end;
  form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);

  if ptr[3].X > 0 then
  begin
    form.MoveTo(ptr[3].X,ptr[3].Y);
    form.LineTo(ptr[4].X,ptr[4].Y);
  end;

  //-------------------------------------------------------------------- сигнальная ячейка
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //----------------------------------------------------------------- нет активности
    form.Pen.Color := armcolor12; //----------------------------------------------- черный
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14; //------------------------------------------------- циан
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then //------ если открыт маневровым показанием
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then //------ есть и поездное - неисправность
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[32] then // гасить неисправность(заблокирован)
        begin
          form.Pen.Color := 0; form.Pen.Width := 1;
          form.Brush.Color := armcolor8; //--------------------------------------- серый
          form.Brush.Style := bsSolid;
        end else //-------------------------------------------------- если не заблокирован
        begin
          if tab_page then   //------------------------------------ если 0-ой такт мигания
          begin
            form.Pen.Color := 0;  form.Pen.Width := 1;
            form.Brush.Color := armcolor2; //----------------------------------- зеленый
            form.Brush.Style := bsSolid;
          end;
        end;
      end else
      begin //-------------------------------------------- если открыт только маневровый
        form.Pen.Color := 0; form.Pen.Width := 1;
        form.Brush.Color := armcolor9; //----------------------------------------- белый
        form.Brush.Style := bsSolid;
      end;
    end else //-------------------------------------------------- если маневровый закрыт
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[6] then //------- если неисправность огневушки
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[17] or //-------- если уже есть фиксация или
        not WorkMode.Upravlenie or //------------------ отключено управления от АРМа или
        not OVBuffer[obj.ObjConstI[1]].Param[18] then //-- нет активности района упр-ния
        begin
          form.Pen.Color := armcolor1;
          form.Pen.Width := 1;
          form.Brush.Color := armcolor15; //---------------------------------- цвет фона
          form.Brush.Style := bsSolid;
        end else
        begin //----------------------------------- если не подтвержденная неисправность
          form.Pen.Color := armcolor1;
          form.Pen.Width := 1;
          form.Brush.Style := bsSolid;
          if tab_page //----------------------------------------- если 1-ый цикл мигания
          then form.Brush.Color := armcolor8 //----------------------------------- серый
          else form.Brush.Color := armcolor15; //-------- для нулевого цикла - цвет фона
        end;
      end else //-------------------------------------- сигнал закрыт огневушка исправна
      if not OVBuffer[obj.ObjConstI[1]].Param[30] then  //---------- если нужно погасить на экране
      begin
        form.Pen.Color := 0;
        form.Pen.Width := 1;
        form.Brush.Color := armcolor8; //----------------------------------------- серый
        form.Brush.Style := bsSolid;
      end;
    end;
  end;
  form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

  //------------------------------------------------------------------- Нарисовать литер
  x1 := -1;
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then x1 := 27;//-включено автодействие сигнала
  if x1 > -1 then      //---------------------------- если включено автодействие сигнала
  begin //------------------------------------------------------------ нарисовать иконку
    form.Pen.Width := 1;
    form.Pen.Style := psSolid;
    form.Pen.Color := armcolor1;
    case Obj.ObjConstI[7] of  //------------------------ расположение знаков ограничения
      1 :   //---------------------------------------------------- вправо по горизонтали
      begin
        if Obj.ObjConstI[2] = 0 then //------------- если сигнал на экране смотрит влево
        begin
          if Obj.ObjConstI[3] = 1 then x2 := 16 //-------------- если есть признак мачты
          else x2 := 13; //--------------------------------------------- если карликовый
        end
        else  x2 := form.TextWidth(obj.Title)+3; //----------------- если смотрит вправо
        TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
        form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
      end;
      2 :  //--------------------------------------------------------- вниз по вертикали
      begin
        if Obj.ObjConstI[2] = 1 then  x2 := -1  //------------ если сигнал смотрит влево
        else x2 := form.TextWidth(obj.Title)+2; //------------------ если смотрит вправо
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
      end;
      3 :   //------------------------------------------------------- вверх по вертикали
      begin
        if Obj.ObjConstI[2] = 1 then x2 := -1  //-------------------- если смотрит влево
        else x2 := form.TextWidth(obj.Title)+2;//------------------- если смотрит вправо
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
      end;
      else //------------------------------------------------------ влево по горизонтали
        if Obj.ObjConstI[2] = 1 then //------------------------------ если смотрит влево
        begin
          if Obj.ObjConstI[3] = 1 then x2 := 15 //------------------------ если мачтовый
          else x2 := 12 ;  //------------------------------------------- если карликовый
        end
        else  x2 := form.TextWidth(obj.Title)+2; //----------------- если смотрит вправо
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
    end;
  end;

  if not OVBuffer[obj.ObjConstI[1]].Param[16] or //------------------ если неактивен или
  OVBuffer[obj.ObjConstI[1]].Param[1] then //---------------------------- непарафазность
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[32] then //---- светофор заблокирован (колпачек)
    form.Font.Color := armcolor1 //--------------------------------------------- красный
    else form.Font.Color := clBlack; //------------------------------------------ черный
    form.Brush.Style := bsClear;
  end else
  begin //---------------------------------------------------------- активен и парафазен
    if OVBuffer[Obj.ObjConstI[1]].Param[32] then //---- светофор заблокирован (колпачек)
    form.Font.Color := armcolor1 //--------------------------------------------- красный
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then //------------------- если маневровый ВС
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then //------------- если еще и поездной ВС
      begin
        if tab_page then form.Font.Color := armcolor9 //------- 1-й цикл мигания - белый
        else form.Font.Color := armcolor2; //---------------- 0-й цикл мигания - зеленый
      end else  form.Font.Color := armcolor9; //----------- только маневровый ВС - белый
    end else
    if not OVBuffer[obj.ObjConstI[1]].Param[30] then
    form.Font.Color := clBlack; //---------------- нет маневрового ВС - черный

    if OVBuffer[Obj.ObjConstI[1]].Param[11] and //------------- если маневровое начало и
    (Obj.ObjConstI[6] = 0) then //------------------------- управление от оператора АРМа
    begin
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor9; //------------------------------------- белая кисть
    end
    else form.Brush.Style := bsClear;//------------------------------ нет начала или МПР
  end;

  form.Font.Size := 8;
  form.Font.Style := [];
  form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);

  if OVBuffer[Obj.ObjConstI[1]].Param[13] and //-------- если есть фиксация перекрытия и
  OVBuffer[Obj.ObjConstI[1]].Param[18] and //---------------- активен район управления и
  tab_page then //----------------------------------------------------- 1-й цикл мигания
  begin
    x1 := form.TextWidth(Obj.Title);
    form.Font.Color := armcolor1;
    if Obj.ObjConstI[2] = 1 then form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')//--нога справа
    else form.TextOut((ptr[7].X)-2, ptr[7].Y, '!');//------------------------ нога слева
  end;
  form.Pen.Color := cvet_pen;
  form.Brush.Color := cvet_kist;
end;

//========================================================================================
//--------------------------------------------------- нарисовать совмещенный светофор (21)
procedure DisplaySvetSovm(Obj: POVStruct;form: TCanvas);
var
  x1,x2,niz,verh,buferOV : integer;
  ris,nabor,kod,dopoln : integer;
  EN : integer;
begin
  EN := 0;
  verh :=0;
  niz := 0;
  form.Font.Size := 8; form.Font.Style := [];
  case obj.ObjConstI[2] of //----------------------------- Определить ориентацию светофора
    1 :
    begin //------------------------------------------------------------------ нога справа
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
      if obj.ObjConstI[3] = 0 then //------------------------------------------- нет мачты
      begin //----------------------------------------------------------------- карликовый
        ptr[3].X := 0; ptr[4].X := 0;
        ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
      end else
      begin //------------------------------------------------------------------- мачтовый
        ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
        ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
      end;
      ptr[7].X := Obj.Points[1].X+6; ptr[7].Y := Obj.Points[1].Y-6;
      ptr[8].X := Obj.Points[1].X+2; ptr[8].Y := Obj.Points[1].Y-5;
      ptr[9].X := Obj.Points[1].X+6; ptr[9].Y := Obj.Points[1].Y+6;
    end;
    else //-------------------------------------------------------------------- нога слева
    ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
    ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
    if obj.ObjConstI[3] = 0 then
    begin //------------------------------------------------------------------- карликовый
      ptr[3].X := 0; ptr[4].X := 0;
      ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
      ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
    end else
    begin //--------------------------------------------------------------------- мачтовый
      ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
      ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
      ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
      ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
    end;
    form.Font.Style := [];
    ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-6;
    ptr[7].Y := Obj.Points[1].Y-6;
    ptr[8].X := Obj.Points[1].X-5;
    ptr[8].Y := Obj.Points[1].Y-5;
    ptr[9].X := Obj.Points[1].X-1;
    ptr[9].Y := Obj.Points[1].Y+6;
  end;
  form.Pen.Color := 0;
  //----------------------------------------------------------------------- нога светофора
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  begin
    form.Pen.Color := 0;
    form.Pen.Style := psSolid;
    form.Brush.Color := 0; //--------------------------------------------------- цвет фона
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end;
  form.MoveTo(ptr[1].X,ptr[1].Y);
  form.LineTo(ptr[2].X,ptr[2].Y);
  if ptr[3].X > 0 then
  begin
    form.MoveTo(ptr[3].X,ptr[3].Y);
    form.LineTo(ptr[4].X,ptr[4].Y);
  end;
    form.Pen.Color := armcolor15;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor15; //------------------------------------------ цвет фона
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;

  BuferOV := Obj.ObjConstI[1];

  nabor := 0;

  if Obj.ObjConstI[8] = 1 then //-------------------------- если у сигнала есть дополнение
  begin
    dopoln := Obj.ObjConstI[16]; //-------------- получить объект зависимостей для сигнала
    dopoln := ObjZav[dopoln].UpdateObject; //------ получить объект дополнения для сигнала
    //----------------------------- если открыт пригласительный или закрыт поездной сигнал
    if OVBuffer[BuferOV].Param[25] or (not OVBuffer[BuferOV].Param[5]) then ris := 0
    else
    begin
      nabor := ObjZav[dopoln].ObjConstI[15];
      ris := $FF;
    end;

    if ris <> 0 then
    case nabor of
      1:
      begin
        kod := 0;
        if OVBuffer[BuferOV].Param[20] then kod := kod + 4; //------------------------- ГМ
        if OVBuffer[BuferOV].Param[22] then kod := kod + 2; //------------------------- ЛС
        if OVBuffer[BuferOV].Param[23] then kod := kod + 1; //------------------------ ЖМС

        if kod = $B then
        begin
          if OVBuffer[BuferOV].Param[24] then ris := 5
          else ris := 3;
        end else
        if (kod = 3) or (kod = 7) then
        begin
          if OVBuffer[BuferOV].Param[24] then ris := 2
          else ris := 1;
        end else
        if (kod > $B) then ris := 4
        else
        if (kod < 7) and (kod <> 3) then ris := 1
        else ris := 3;
      end;

      2:
      begin
        if OVBuffer[BuferOV].Param[22] then ris := 6
        else ris := 3;
      end;

      3:
      begin
        kod := 0;
        if OVBuffer[BuferOV].Param[22] then kod := kod + 2; //------------------------- ЛС
        if OVBuffer[BuferOV].Param[23] then kod := kod + 1; //------------------------ ЖМС
        if kod = 2 then ris := 4
        else
        if kod = 1 then
        begin
          if OVBuffer[BuferOV].Param[24] then ris := 5
          else ris := 3;
        end
        else ris :=3;
      end;

      4:
      begin
        kod := 0;
        if OVBuffer[BuferOV].Param[22] then kod := kod + 1; //------------------------- ЛС
        if OVBuffer[BuferOV].Param[21] then kod := kod + 2; //------------------------ 2зС

        if kod > 1 then  ris := 1
        else
        if kod = 1 then ris := 4
        else ris := 3;
      end;

      5:
      begin
        if OVBuffer[BuferOV].Param[21] then ris := 1
        else ris :=3;
      end;

      else
      begin
        if not OVBuffer[BuferOV].Param[28] then //----------------------- если пассивен ЕН
        begin
          if not OVBuffer[BuferOV].Param[22] then  ris := 9 //---------------- пассивен ЛС
          else ris := 7;
        end else //------------------------------------------------------- если ЕН активен
        begin
        //  if not OVBuffer[BuferOV].Param[22] then  err := 1; //------------- ЛС пассивен
          ris := 8;
        end;
      end;
    end;
    
    case ris of
      0:
      begin
        verh := armcolor15; niz := clRed;
      end;

      1:
      begin
        verh := clYellow; niz := clYellow;
      end;

      2:
      begin
        if tab_page then verh := clYellow
        else verh := clGray;
        niz := clYellow;
      end;

      3:
      begin
        verh := clYellow; niz := clGray;
      end;

      4:
      begin
        verh := clGreen; niz := clGray;
      end;

      5:
      begin
        if tab_page then verh := clYellow
        else verh := clGray;
        niz := clGray;
      end;

      6:
      begin
        verh := clGreen; niz := clGray;
      end;

      7:
      begin
        verh := clGreen; niz := clWhite;
      end;

      8:
      begin
        verh := clYellow; niz := clWhite;
        EN := 1;
      end;

      9:
      begin
        verh := clYellow; niz := clWhite;
        EN := 0;
      end;
    end;

    if not OVBuffer[BuferOV].Param[16] then
    begin
      verh := armcolor12; //------------------------------------------------------- черный
      niz := armcolor12; //-------------------------------------------------------- черный
    end;
    if OVBuffer[BuferOV].Param[32] then
    begin
      verh := armcolor14; //--------------------------------------------------------- циан
      niz := armcolor14; //---------------------------------------------------------- циан
    end;

    form.Brush.Color := niz;   form.Pen.Style := psSolid;
    form.Brush.Color := niz;   form.Brush.Style := bsSolid;
    form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
    form.Pen.Color := 0;//--------------------------------------------------------- черный
    form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

    form.Pen.Color := verh;     form.Pen.Style := psSolid;
    form.Brush.Color := verh;   form.Brush.Style := bsSolid;
    form.Pen.Width := 1;

    if Obj.ObjConstI[2] = 1 then   //----------------------------------------- нога справа
    begin
      form.Ellipse(ptr[5].X-11,ptr[5].Y,ptr[6].X-11,ptr[6].Y);
      if verh <> armcolor15 then form.Pen.Color := 0 //---------------------------- черный
      else form.Pen.Color := verh;
      form.Ellipse(ptr[5].X-11,ptr[5].Y,ptr[6].X-11,ptr[6].Y);
    end else
    begin
      form.Ellipse(ptr[5].X+11,ptr[5].Y,ptr[6].X+11,ptr[6].Y);
      if verh <> armcolor15 then form.Pen.Color := 0 //---------------------------- черный
      else form.Pen.Color := verh;
      form.Ellipse(ptr[5].X+11,ptr[5].Y,ptr[6].X+11,ptr[6].Y);
    end;

    form.Pen.Color := armcolor15;
    form.Pen.Width := 2;
    if Obj.ObjConstI[8]= 1 then     //------------------------------------------ ЕН-сверху
      if obj.ObjConstI[2] = 1 then  //------------------------------- сигнал смотрит влево
      begin
        form.MoveTo(ptr[1].X-20,ptr[1].Y-10);
        form.LineTo(ptr[1].X-10,ptr[1].Y-10);

        form.MoveTo(ptr[1].X-17,ptr[1].Y-13);
        form.LineTo(ptr[1].X-20,ptr[1].Y-10);
        form.LineTo(ptr[1].X-16,ptr[1].Y-7);

        form.MoveTo(ptr[1].X-5,ptr[1].Y-10);
        form.LineTo(ptr[1].X+5,ptr[1].Y-10);

        form.MoveTo(ptr[1].X-2,ptr[1].Y-13);
        form.LineTo(ptr[1].X-5,ptr[1].Y-10);
        form.LineTo(ptr[1].X-1,ptr[1].Y-7);


        if EN = 1 then //----------------------------------------- ЕН включен (есть связь)
        begin
          form.Pen.Color := armcolor9;
          form.MoveTo(ptr[1].X-20,ptr[1].Y-10);
          form.LineTo(ptr[1].X-10,ptr[1].Y-10);

          form.MoveTo(ptr[1].X-17,ptr[1].Y-13);
          form.LineTo(ptr[1].X-20,ptr[1].Y-10);
          form.LineTo(ptr[1].X-16,ptr[1].Y-7);

          form.MoveTo(ptr[1].X-5,ptr[1].Y-10);
          form.LineTo(ptr[1].X+5,ptr[1].Y-10);

          form.MoveTo(ptr[1].X-2,ptr[1].Y-13);
          form.LineTo(ptr[1].X-5,ptr[1].Y-10);
          form.LineTo(ptr[1].X-1,ptr[1].Y-7);
        end;
      end;

    form.Pen.Color := 0;
  end else//----------------------------------------------------- у сигнала нет дополнения
  //--------------------------------------------------------- Нарисовать сигнальную ячейку
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12; //----------------------------------------------- черный
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14; //-------------------------------------------- цвет циан
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] and //---------------- если открыт маневровый и
    OVBuffer[Obj.ObjConstI[1]].Param[5] then //---------------------- если открыт поездной
    begin //-------------------------------------- Ошибка --- открыт маневровым и поездным
      if OVBuffer[Obj.ObjConstI[1]].Param[32] then
      begin //-------------------------- светофор заблокирован - потушить ложную индикацию
        form.Pen.Color := 0;
        form.Pen.Width := 1;
        form.Brush.Color := armcolor8;//-------------------------------------------- серый
        form.Brush.Style := bsSolid;
      end else
      begin //----------------------------------------------------------- иначе мигать З/Б
        if tab_page then
        begin
          form.Pen.Color := 0;
          form.Pen.Width := 1;
          form.Brush.Color := armcolor9; //----------------------------------------- белый
          form.Brush.Style := bsSolid
        end else
        begin
          form.Pen.Color := 0;
          form.Pen.Width := 1;
          form.Brush.Color := armcolor2; //--------------------------------------- зеленый
          form.Brush.Style := bsSolid;
        end;
      end;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //------------------------------------------ открыт только маневровым показанием
      form.Pen.Color := 0;
      form.Pen.Width := 1;
      form.Brush.Color := armcolor9; //--------------------------------------------- белый
      form.Brush.Style := bsSolid;
    end else
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //-------------------------------------------- если открыт поездным показанием
        form.Pen.Color := 0;
        form.Pen.Width := 1;
        if Obj.ObjConstI[4] = 1 then form.Brush.Color := armcolor7 //-------------- желтый
        else form.Brush.Color := armcolor2; //------------------------------------ зеленый
        form.Brush.Style := bsSolid;
      end else
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[6] then
        begin //-------------------------------------------------- Неисправность огневушки
          if OVBuffer[Obj.ObjConstI[1]].Param[17] or //если неисправность воспринята или
          not WorkMode.Upravlenie or //----------------------нет управлнения от АРМа или
          not OVBuffer[obj.ObjConstI[1]].Param[18] then //--------- район не активизирован
          begin //----------------------------------------------- неисправность воспринята
            form.Pen.Color := armcolor1;
            form.Pen.Width := 1;
            form.Brush.Color := armcolor15; //---------------------------------- цвет фона
            form.Brush.Style := bsSolid;
          end else
          begin //---------------------------------------- не подтвержденная неисправность
            form.Pen.Color := armcolor1;
            form.Pen.Width := 1;
            form.Brush.Style := bsSolid;
            if tab_page then form.Brush.Color := armcolor8  //-------------- мигание серый
            else form.Brush.Color := armcolor15; //--------------------------- мигание фон
          end;
        end else //---------------------------------------------------- огневушка исправна
        begin //------------------------------------------------------------ сигнал закрыт
          if obj.ObjConstI[5] = 0 then
          begin
            form.Pen.Color := 0;
            form.Brush.Color := armcolor8; //--------------------------------------- серый
          end
          else
          begin
            form.Pen.Color := 0;
            form.Brush.Color := armcolor1; //------------------------------------- красный
          end;
          form.Pen.Width := 1;
          form.Brush.Style := bsSolid;
        end;
      end;
    end;
  end;

  if Obj.ObjConstI[8] = 0 then //--------------------------- если нет дополнения у сигнала
  begin
    form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
  end;
  //---------------------------------------------- Нарисовать признак неистравности СО, Кз
  form.Pen.Width := 1;
  form.Brush.Style := bsSolid;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //---------------------------------------------------- нет дополнительных датчиков
    form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
    form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin // неисправность дополнительных датчиков
    form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
    form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[9] then
  begin //------------------------------- реконфигурация - переход с зеленого на желтый Kz
    if OVBuffer[Obj.ObjConstI[1]].Param[17] or //------------- если воспринята ненорма или
    not WorkMode.Upravlenie or //------------------------- если нет управления от АРМа или
    not OVBuffer[obj.ObjConstI[1]].Param[18] //--------------------- нет активности района
    then form.Brush.Color := armcolor7 //------------------------------------- цвет желтый
    else
    if tab_page then form.Brush.Color := armcolor15 //---------------- иначе 1-й миг белый
    else form.Brush.Color := armcolor7; //----------------------------------0-й миг желтый
    form.Pen.Color := form.Brush.Color;
    form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[8] or OVBuffer[Obj.ObjConstI[1]].Param[15]
  then //----------------------------------------------------------- если датчик Со или Кз
  begin //------------------------------------------ неисправность разрешительного огня Co
    if OVBuffer[Obj.ObjConstI[1]].Param[17] or //------- если воспринята неисправность или
    not WorkMode.Upravlenie or //------------------------------ нет управления от АРМа или
    not OVBuffer[obj.ObjConstI[1]].Param[18] //-------------------- не активизирован район
    then form.Brush.Color := armcolor2 //---------------------------- кисть светло-зеленая
    else
    if tab_page then form.Brush.Color := armcolor15 //---------- если миг 1-й - цвет белый
    else form.Brush.Color := armcolor2;             //-----если миг 0-й - цвет зеленый
    form.Pen.Color := form.Brush.Color;
    form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));//----------- подложка литера
  end;
  //--------------------------------------------------------------------- Нарисовать литер
  x1 := -1;
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then x1 := 27; //------------------ автодействие
  if x1 > -1 then
  begin //-------------------------------------------------------------- нарисовать иконку
    form.Pen.Width := 1;
    form.Pen.Style := psSolid;
    form.Pen.Color := armcolor1;
    case Obj.ObjConstI[7] of //--------- переключатель по расположению значков ограничений
      1 :
      begin //------------------------------------------------------ вправо по горизонтали
        if Obj.ObjConstI[2] = 0 then //------------------------------ нога с левой стороны
        begin
          if Obj.ObjConstI[3] = 1 then x2 := 16 //------------------------------- мачтовый
          else x2 := 13;//----------------------------------------------------- карликовый
        end
        else x2 := form.TextWidth(obj.Title)+7; //------------------ нога с правой стороны
        TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
        form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
      end;
      2 :
      begin //---------------------------------------------------------- вниз по вертикали
        if Obj.ObjConstI[2] = 1 then x2 := -5  //------------------- нога с правой стороны
        else  x2 := form.TextWidth(obj.Title)+7; //------------------ нога с левой стороны
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
      end;
      3 :
      begin //--------------------------------------------------------- вверх по вертикали
        if Obj.ObjConstI[2] = 1 then x2 := -5  //------------------- нога с правой стороны
        else  x2 := form.TextWidth(obj.Title)+7; //------------------ нога с левой стороны
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
      end;
      else //-------------------------------------------------------- влево по горизонтали
      if Obj.ObjConstI[2] = 1 then    //---------------------------- нога с правой стороны
      begin
        if Obj.ObjConstI[3] = 1 then x2 := 15 //--------------------------------- мачтовый
        else x2 := 12 ; //----------------------------------------------------- карликовый
      end
      else x2 := form.TextWidth(obj.Title)+6; //--------------------- нога с левой стороны
      TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
      form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
      form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
    end;
  end;

  if not OVBuffer[obj.ObjConstI[1]].Param[16] or //--------------- если нет активности или
  OVBuffer[obj.ObjConstI[1]].Param[1] then //------------------------------ непарафазность
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[32] //----------- светофор заблокирован (колпачек)
    then form.Font.Color := armcolor1 //------------------------------ цвет шрифта красный
    else form.Font.Color := clBlack; //-------------------------- иначе цвет шрифта черный
    form.Brush.Style := bsClear;
  end else //------------------------------------------------ светофор активен и парафазен
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[32] //------ если светофор заблокирован (колпачек)
    then  form.Font.Color := armcolor1 //----------------------------------- красный шрифт
    else //------------------------------------------------------------------------- иначе
    if OVBuffer[Obj.ObjConstI[1]].Param[2] and //-------------------- если маневровый ВС и
    OVBuffer[Obj.ObjConstI[1]].Param[4] then //------------------ одновременно поездной ВС
    begin //------------------------------------------ ошибка - одновременно есть МВС и ВС
      if tab_page then form.Font.Color := armcolor9 //--------------- если миг 1-й - белый
      else form.Font.Color := armcolor2; //------------------------ если миг 0-й - зеленый
    end else //-------------------------------------------------- иначе (когда нет ошибки)
    if OVBuffer[Obj.ObjConstI[1]].Param[2]
    then form.Font.Color := armcolor9//-------------- если только маневровый ВС, то белый
    else //-------------------------------------------------- иначе (если только поездной)
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then form.Font.Color := armcolor2 //--- зеленый
    else  form.Font.Color := clBlack; //----------------------- если никакого ВС то черный

    if OVBuffer[Obj.ObjConstI[1]].Param[11] and //---------- если есть маневровое начало и
    OVBuffer[Obj.ObjConstI[1]].Param[12] then //-------- одновременно есть поездное начало
    begin //------------------------------- признак неверных данных противоповторки/начала
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor11; //--------------------------------- фиолетовая кисть
    end  else //-------------------------------------------------- иначе (если нет ошибки)
    if OVBuffer[Obj.ObjConstI[1]].Param[11] and //---------- если есть маневровое начало и
    (Obj.ObjConstI[6] = 0) then                 //--------------------- огневушка исправна
    begin //------------------------ признак маневровой противоповторки/маневрового начала
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor9; //--------------------------------------- белая кисть
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[12] and //------------ если есть поездное начало и
    (Obj.ObjConstI[6] = 0) then               //----------------------- огневушка исправна
    begin //---------------------------- признак поездной противоповторки/поездного начала
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor2; //------------------------------------- кисть зеленая
    end
    else form.Brush.Style := bsClear;//--------------------------------- нет начала или ПП
  end;
  form.Font.Size := 8;
  form.Font.Style := [];
  form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title); //--------- пишем литер на цветной подложке
  if OVBuffer[Obj.ObjConstI[1]].Param[13] and //---------- если зафиксировано перекрытие и
  OVBuffer[Obj.ObjConstI[1]].Param[18] and //----------------- активный район управления и
  tab_page then                           //-------------------------------------- миг 1-й
  begin
    x1 := form.TextWidth(Obj.Title);
    form.Font.Color := armcolor1; //------------------------------------ цвет букв красный
    if Obj.ObjConstI[2] = 1 then form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')//----нога справа
    else form.TextOut((ptr[7].X)-5, ptr[7].Y, '!');   //----------------------- нога слева
  end;
end;
//========================================================================================
//------------------------------------------------------------------ Входной светофор (22)
procedure DisplaySvetVhod(Obj: POVStruct;form: TCanvas);
var
  x1,x2,VidBuf : integer;
begin
  form.Font.Style := [];  form.Font.Size := 8;
  VidBuf := Obj.ObjConstI[1];
  case obj.ObjConstI[2] of //----------------------------- Определить ориентацию светофора
    1 :
    begin //------------------------------------------------------------------ нога справа
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
      if obj.ObjConstI[3] = 0 then
      begin //----------------------------------------------------------------- карликовый
        ptr[3].X := 0; ptr[4].X := 0;
        ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
      end else
      begin //------------------------------------------------------------------- мачтовый
        ptr[3].X := obj.Points[1].X-4; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
        ptr[5].X := obj.Points[1].X-14; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X-3; ptr[6].Y := obj.Points[1].Y+6;
      end;
      ptr[7].X := Obj.Points[1].X+6; ptr[7].Y := Obj.Points[1].Y-6;
      ptr[8].X := Obj.Points[1].X+2; ptr[8].Y := Obj.Points[1].Y-5;
      ptr[9].X := Obj.Points[1].X+6; ptr[9].Y := Obj.Points[1].Y+6;
    end;
    else //-------------------------------------------------------------------- нога слева
      ptr[1].X := obj.Points[1].X; ptr[1].Y := obj.Points[1].Y-5;
      ptr[2].X := obj.Points[1].X; ptr[2].Y := obj.Points[1].Y+6;
      if obj.ObjConstI[3] = 0 then
      begin //----------------------------------------------------------------- карликовый
        ptr[3].X := 0; ptr[4].X := 0;
        ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X+1; ptr[6].Y := obj.Points[1].Y+6;
      end else
      begin //------------------------------------------------------------------- мачтовый
        ptr[3].X := obj.Points[1].X+4; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X; ptr[4].Y := obj.Points[1].Y;
        ptr[5].X := obj.Points[1].X+15; ptr[5].Y := obj.Points[1].Y-5;
        ptr[6].X := obj.Points[1].X+4; ptr[6].Y := obj.Points[1].Y+6;
      end;
      form.Font.Style := [];
      ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-6;
      ptr[7].Y := Obj.Points[1].Y-6;
      ptr[8].X := Obj.Points[1].X-5; ptr[8].Y := Obj.Points[1].Y-5;
      ptr[9].X := Obj.Points[1].X-1; ptr[9].Y := Obj.Points[1].Y+6;
    end;

    //--------------------------------------------------------------------- нога светофора
    if not OVBuffer[VidBuf].Param[16] then
    begin //------------------------------------------------------------------ не активный
      form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
      form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end else
    if OVBuffer[VidBuf].Param[7] then
    begin //--------------------------------------------------------------- непарафазность
      form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
      form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end else
    begin
      if OVBuffer[VidBuf].Param[10] then //--------------------------- если "Авария шкафа"
      begin
        if OVBuffer[VidBuf].Param[17] or  //----------------- если есть восприятие или ...
        not WorkMode.Upravlenie or //------------------------------ нет управления или ...
        not OVBuffer[VidBuf].Param[18] //------------------------------- нет активности РУ
        then form.Pen.Color := armcolor1 //---------------------------------- цвет красный
        else
        if tab_page then form.Pen.Color := 0     //------------------------ иначе мигающий
        else form.Pen.Color := armcolor1;
        form.Pen.Width := 2;
      end else
      begin //--------------------------------------------------- Исправный шкаф светофора
        form.Pen.Color := 0; form.Pen.Width := 1;
      end;
      form.Pen.Style := psSolid; form.Brush.Color := armcolor15;
      form.Brush.Style := bsSolid;
    end;

    form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);

    if ptr[3].X > 0 then
    begin
      form.MoveTo(ptr[3].X,ptr[3].Y);
      form.LineTo(ptr[4].X,ptr[4].Y);
    end;

    //------------------------------------------------------- Нарисовать сигнальную ячейку
    if not OVBuffer[VidBuf].Param[16] then //---------------------------- пассивный сигнал
    begin //----------------------------------------------------------- нецентрализованный
      form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
      form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end else
    if OVBuffer[VidBuf].Param[1] then //------------------------------ непарафазный сигнал
    begin
      form.Pen.Color := armcolor14; form.Pen.Style := psSolid;
      form.Brush.Color := armcolor14; form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end else
    begin
      if OVBuffer[VidBuf].Param[3] and OVBuffer[VidBuf].Param[5] then
      begin //-------------------------------------- Ошибка - открыт маневровым и поездным
        form.Pen.Color := 0; form.Pen.Width := 1;
        form.Brush.Color := armcolor11; form.Brush.Style := bsSolid;
      end else
      if OVBuffer[VidBuf].Param[3] then
      begin //----------------------------------------------- открыт маневровым показанием
        form.Pen.Color := 0; form.Pen.Width := 1;
        form.Brush.Color := armcolor9; form.Brush.Style := bsSolid;
      end else
      begin
        if OVBuffer[VidBuf].Param[5] then
        begin //----------------------------------------------- открыт поездным показанием
          form.Pen.Color := 0; form.Pen.Width := 1;
          form.Brush.Color := armcolor2; form.Brush.Style := bsSolid;
        end else
        begin
          if OVBuffer[VidBuf].Param[6] then
          begin //------------------------------------------------ Неисправность огневушки
            if OVBuffer[VidBuf].Param[17] or //------------------------ воспринята или ...
            not WorkMode.Upravlenie or //---------------------- АРМ не управляющий или ...
            not OVBuffer[VidBuf].Param[18] then //------------ район управления не активен
            begin //--------------------------------------------- неисправность воспринята
              form.Pen.Color := armcolor1;
              form.Pen.Width := 1;
              form.Brush.Color := armcolor15; form.Brush.Style := bsSolid;
            end else
            begin //-------------------------------------- не подтвержденная неисправность
              form.Pen.Color := armcolor1;
              form.Pen.Width := 1;
              form.Brush.Style := bsSolid;
              if tab_page then form.Brush.Color := armcolor4
              else form.Brush.Color := armcolor15;
            end;
          end else
          begin //---------------------------------------------------------- сигнал закрыт
            form.Pen.Color := 0; form.Pen.Width := 1;
            form.Brush.Color := armcolor4; form.Brush.Style := bsSolid;
          end;
        end;
      end;
    end;
    form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);

    //------------------------------------- Нарисовать признак неистравности СО,ЖСо,зСо,Кз
    form.Pen.Width := 1; form.Brush.Style := bsSolid;
    if not OVBuffer[VidBuf].Param[16] then  //-------------------- нет активности датчиков
    begin //-------------------------------------------------- нет дополнительных датчиков
      form.Pen.Color := armcolor8; form.Brush.Color := armcolor8;
      form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
    end else
    if OVBuffer[VidBuf].Param[7] then  //------------------------- непарафазность датчиков
    begin //---------------------------------------- неисправность дополнительных датчиков
      form.Pen.Color := armcolor14; form.Brush.Color := armcolor14;
      form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
    end else
    if OVBuffer[VidBuf].Param[9] then //--------- реконфигурация-переход с зел. на жел.,Kz
    begin
      if OVBuffer[VidBuf].Param[17] or //------------------------------ восприятие или ...
      not WorkMode.Upravlenie or  //------------------------------- нет управления или ...
      not OVBuffer[VidBuf].Param[18] //-------------- нет активности района управления, то
      then form.Brush.Color := armcolor7 //--------------------------------- цвет "Желтый"
      else
      if tab_page then form.Brush.Color := armcolor15 //---------- иначе "мигающий желтый"
      else form.Brush.Color := armcolor7;

      form.Pen.Color := form.Brush.Color;
      form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
    end else
    if OVBuffer[VidBuf].Param[8] then //---------------------------------------- если "СО"
    begin //---------------------------------------- неисправность разрешительного огня Co
      if OVBuffer[VidBuf].Param[17] or
      not WorkMode.Upravlenie or
      not OVBuffer[VidBuf].Param[18]
      then form.Brush.Color := armcolor2
      else
        if tab_page then form.Brush.Color := armcolor15
        else form.Brush.Color := armcolor2;
      form.Pen.Color := form.Brush.Color;
      form.FillRect(rect(ptr[8].X,ptr[8].Y,ptr[9].X,ptr[9].Y));
    end;

    //------------------------------------------------------------------- Нарисовать литер
    x1 := -1;
    if OVBuffer[VidBuf].Param[31] then x1 := 27;//---------- Включено автодействие сигнала
    if x1 > -1 then
    begin //------------------------------------------------------------ нарисовать иконку
    form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor1;
    case Obj.ObjConstI[7] of //--------------------- положение значков ограничений объекта
      1 :
      begin //------------------------------------------------------ вправо по горизонтали
        if Obj.ObjConstI[2] = 0 then //--------------------------------- если без поворота
        begin
          if Obj.ObjConstI[3] = 1 then x2 := 16 //---------------------------------- мачта
          else x2 := 13; //-------------------------------------------------------- карлик
        end
        else  x2 := form.TextWidth(obj.Title)+7;  //--------------------- если с поворотом
        TabloMain.ImageList.Draw(form,obj.Points[1].X+x2,obj.Points[1].Y-5,x1);
        form.MoveTo(obj.Points[1].X+x2-4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        form.LineTo(obj.Points[1].X+x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
      end;

      2 :
      begin //---------------------------------------------------------- вниз по вертикали
        if Obj.ObjConstI[2] = 1 then x2 := -5
        else  x2 := form.TextWidth(obj.Title)+7;
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-10);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-6);
      end;

      3:
      begin //--------------------------------------------------------- вверх по вертикали
        if Obj.ObjConstI[2] = 1 then x2 := -5
        else x2 := form.TextWidth(obj.Title)+7;
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2,obj.Points[1].Y-18,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y-6);
        form.LineTo(obj.Points[1].X-x2,obj.Points[1].Y-2);
      end;
      else //-------------------------------------------------------- влево по горизонтали
        if Obj.ObjConstI[2] = 1 then
        begin
          if Obj.ObjConstI[3] = 1 then x2 := 15
          else x2 := 12 ;
        end else x2 := form.TextWidth(obj.Title)+6;
        TabloMain.ImageList.Draw(form,obj.Points[1].X-x2-12,obj.Points[1].Y-5,x1);
        form.MoveTo(obj.Points[1].X-x2,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
        form.LineTo(obj.Points[1].X-x2+4,obj.Points[1].Y+form.TextHeight(obj.Title)-7);
      end;
    end;

    if not OVBuffer[VidBuf].Param[16] or
    OVBuffer[VidBuf].Param[1] then
    begin
      if OVBuffer[VidBuf].Param[32]
      then form.Font.Color := armcolor1 //--------------- светофор заблокирован (колпачек)
      else form.Font.Color := clBlack;
      form.Brush.Style := bsClear;
    end else
    begin
      if OVBuffer[VidBuf].Param[32]
      then form.Font.Color := armcolor1 //--------------- светофор заблокирован (колпачек)
      else
        if OVBuffer[VidBuf].Param[2] //------------------------------- маневровый ВС и ...
        and OVBuffer[VidBuf].Param[4] then //--------------------------------- поездной ВС
        begin //-------------------------------------- ошибка - одновременно есть МВС и ВС
          form.Font.Color := armcolor11;
        end else
        if OVBuffer[VidBuf].Param[2] then form.Font.Color := armcolor9 //------------- МВС
        else
          if OVBuffer[VidBuf].Param[4] then form.Font.Color := armcolor2 //ВС
          else form.Font.Color := clBlack;

      if OVBuffer[VidBuf].Param[11] and //------------------------ маневровое начало и ...
      OVBuffer[VidBuf].Param[12] then //---------------------------------- поездное начало
      begin //----------------------------- признак неверных данных противоповторки/начала
        form.Brush.Style := bsSolid;
        form.Brush.Color := armcolor11;
      end else
      if OVBuffer[VidBuf].Param[11] and (Obj.ObjConstI[6] = 0) then //-------- управляется
      begin //---------------------- признак маневровой противоповторки/маневрового начала
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor9;
    end else
    if OVBuffer[VidBuf].Param[12] and (Obj.ObjConstI[6] = 0) then //---------- управляется
    begin //---------------------------- признак поездной противоповторки/поездного начала
      form.Brush.Style := bsSolid;
      form.Brush.Color := armcolor2;
    end
    else form.Brush.Style := bsClear; //------------------------------ нет начала или ПП
  end;
  form.Font.Size := 8; form.Font.Style := [];
  form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);

  if OVBuffer[VidBuf].Param[13] and //----------------------------------- перекрытие и ...
  OVBuffer[VidBuf].Param[18] and tab_page then //---------------------------- нет фиксации
  begin
    x1 := form.TextWidth(Obj.Title); form.Font.Color := armcolor1;
    if Obj.ObjConstI[2] = 1 then form.TextOut(ptr[7].X+x1, ptr[7].Y, '!')//--- нога справа
    else form.TextOut((ptr[7].X)-8, ptr[7].Y, '!');//-------------------------- нога слева
  end;

  if OVBuffer[VidBuf].Param[14] then //----------------------------------------------- ЖСо
  form.Brush.Color := armcolor9
  else  form.Brush.Color := armcolor15;

  if Obj.ObjConstI[2] = 1 then //----------------------------------- если признак поворота
  form.FrameRect(Rect(ptr[1].X-16,ptr[1].Y-2,ptr[1].X+16+form.TextWidth(Obj.Title),ptr[1].Y+12))
  else
  form.FrameRect(Rect(ptr[1].X-form.TextWidth(Obj.Title)-7,ptr[1].Y-2,ptr[1].X+16,ptr[1].Y+12));
end;
//========================================================================================
//----------------------------------------------- нарисовать пригласительный светофор (23)
procedure DisplaySvetPrig(Obj: POVStruct;form: TCanvas);
var
  x1 : integer;
begin
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
  if OVBuffer[Obj.ObjConstI[1]].Param[x1] then  //------------------ если сигнал ПС открыт
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[x1+1] then
    begin
      //----------------------------------------------------------------- Неисправность ПС
      form.Pen.Color := armcolor9;
      form.Pen.Width := 2;
      form.Brush.Color := armcolor15;
      form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
    end else
    begin
      //--------------------------------------------------------------------- Исправный ПС
      form.Pen.Color := 0; form.Pen.Width := 1;
      form.Brush.Color := armcolor9;
      form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
      form.Pen.Width := 2; form.Pen.Color := armcolor9;
      form.MoveTo(ptr[1].X,ptr[1].Y); form.LineTo(ptr[2].X,ptr[2].Y);
      form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
    end;
  end;
end;
//========================================================================================
//--------------------------------------------------------------- Повторитель светофора 24
procedure DisplaySvetPovtor(Obj: POVStruct;form: TCanvas);
var
  VideoBuf : Integer;
  Ima : string;
begin
  form.Font.Style := [];
  VideoBuf := obj.ObjConstI[1];
  Ima := Obj.Title;
  form.Brush.Style := bsSolid;
  form.Brush.Color := armcolor8;
  //-------------------------------------------- если не парафазный или не активный датчик
  if OVBuffer[VideoBuf].Param[1] or not OVBuffer[VideoBuf].Param[16] then
  begin
    if not OVBuffer[VideoBuf].Param[16] then
    begin //----------------------------------------------------------- нецентрализованный
      form.Pen.Color := armcolor12;
      form.Pen.Style := psSolid;
      form.Brush.Color := armcolor12;
      form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end else
    begin //--------------------------------------------------------------- непарафазность
      form.Pen.Color := armcolor14;
      form.Pen.Style := psSolid;
      form.Brush.Color := armcolor14;
      form.Brush.Style := bsSolid;
      form.Pen.Width := 1;
    end;
    form.MoveTo(obj.Points[1].X,obj.Points[1].Y-4);
    form.LineTo(obj.Points[1].X,obj.Points[1].Y+5);

    if Obj.ObjConstI[2] = 0 then
    begin //--------------------------------- если повторитель на экране не повернут влево
      form.PolyGon([Point(obj.points[1].X+1,obj.points[1].Y),
      Point(obj.points[1].X+6,obj.points[1].Y+5),
      Point(obj.points[1].X+11,obj.points[1].Y),
      Point(obj.points[1].X+6,obj.points[1].Y-5)]);
    end else
    begin  //----------------------------------- если повторитель на экране повернут влево
      form.PolyGon([Point(obj.points[1].X,obj.points[1].Y),
      Point(obj.points[1].X-5,obj.points[1].Y+5),
      Point(obj.points[1].X-10,obj.points[1].Y),
      Point(obj.points[1].X-5,obj.points[1].Y-5)]);
    end;

    form.Font.Size := 8; form.Font.Color := clBlack;
    form.Brush.Color := armcolor15;
    form.font.Style := [];

    if obj.ObjConstI[2] = 0 then
    begin
      form.TextOut(Obj.Points[1].X-form.TextWidth(Ima)-2,Obj.Points[1].Y-6,Ima);
    end else
    begin
      form.TextOut(Obj.Points[1].X+2,Obj.Points[1].Y-6,Ima);
    end;
    exit;
  end;

  //----------------------------------------------------- Нарисовать повторитель светофора
  if not OVBuffer[VideoBuf].Param[4]then
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //---------------------------------------------------------------- Неисправность
      form.Pen.Color := 0;
      form.Pen.Width := 2;
      form.Brush.Color := armcolor15;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then //-------------------------------- включен
    begin //-------------------------------------------------------------------- Исправный
      form.Pen.Color := 0;
      form.Pen.Width := 1;
      form.Brush.Color := armcolor2;
    end;
  end else
  begin
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Brush.Color := armcolor8;
  end;

  if Obj.ObjConstI[2] = 0 then //------------------------------ если ПНо не повернут влево
  begin
    form.PolyGon([Point(obj.points[1].X+1,obj.points[1].Y),
    Point(obj.points[1].X+6,obj.points[1].Y+5),
    Point(obj.points[1].X+11,obj.points[1].Y),
    Point(obj.points[1].X+6,obj.points[1].Y-5)]);
  end else
  begin
    form.PolyGon([Point(obj.points[1].X,obj.points[1].Y),
    Point(obj.points[1].X-5,obj.points[1].Y+5),
    Point(obj.points[1].X-10,obj.points[1].Y),
    Point(obj.points[1].X-5,obj.points[1].Y-5)]);
  end;

  form.Pen.Width := 1;
  form.MoveTo(obj.Points[1].X,obj.Points[1].Y-4);
  form.LineTo(obj.Points[1].X,obj.Points[1].Y+5);

  form.Font.Size := 8;
  form.Font.Color := clBlack;
  form.Brush.Color := armcolor15;

  if obj.ObjConstI[2] = 0 then
  form.TextOut(Obj.Points[1].X-form.TextWidth(Ima)-2,Obj.Points[1].Y-6, Ima)
  else form.TextOut(Obj.Points[1].X+2,Obj.Points[1].Y-6, Obj.Title);

  form.Font.Size := 10;
  form.Font.Color := bkgndcolor;
  form.Font.Style := [fsBold];

  if OVBuffer[Obj.ObjConstI[1]].Param[4] then //--------------------- нелогичное состояние
  begin
    if tab_page then form.Font.Color := clYellow
    else form.Font.Color :=  bkgndcolor;
    form.Font.Style := [fsBold];
    if Obj.ObjConstI[2] <> 0 then //------------------------------ если ПНо повернут влево
    form.TextOut(Obj.Points[1].X + form.TextWidth(Ima) - 2,Obj.Points[1].Y-6, '!')
    else  form.TextOut(Obj.Points[1].X - form.TextWidth(Ima) -2 ,Obj.Points[1].Y-6, '!');
  end;
end;
//========================================================================================
//----------------------------------------------------------- фиктивный сигнал (увязка) 25
procedure DisplayFictSignal(Obj: POVStruct;form: TCanvas);
begin
  if OVBuffer[obj.ObjConstI[1]].Param[1] or //--------------------------- непарафазный или
  not OVBuffer[obj.ObjConstI[1]].Param[16] then //------------------------------ пассивный
  begin
    if not OVBuffer[obj.ObjConstI[1]].Param[16] then
    begin //--------------------------------------------------------------- нет активности
      form.Pen.Color := armcolor12; form.Pen.Style := psSolid; //-------- все серого цвета
      form.Brush.Color := armcolor12; form.Brush.Style := bsSolid; form.Pen.Width := 1;
    end else
    begin //----------------------------------------------------------------- непарафазный
      form.Pen.Color := armcolor14; form.Pen.Style := psSolid; //-------- все цвета "циан"
      form.Brush.Color := armcolor14; form.Brush.Style := bsSolid; form.Pen.Width := 1;
    end;
    if Obj.ObjConstI[2] = 0 then //----- если нет признака поворота, рисуем "утюг" направо
    begin
      form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),
      Point(obj.points[1].X+6,obj.points[1].Y-4),
      Point(obj.points[1].X+10,obj.points[1].Y),
      Point(obj.points[1].X+6,obj.points[1].Y+4),
      Point(obj.points[1].X,obj.points[1].Y+4)]);
    end else
    begin //------------------------------------ с признаком поворота рисуем "утюг" налево
      form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),Point(obj.points[1].X-6,
      obj.points[1].Y-4),Point(obj.points[1].X-10,obj.points[1].Y),Point(obj.points[1].X-6,
      obj.points[1].Y+4),Point(obj.points[1].X,obj.points[1].Y+4)]);
    end;
    exit;
  end;
  //------------------------------------- далее рисуем только активный и парафазный объект
  //---------------------------------------------------------- Нарисовать фиктивный сигнал
  form.Pen.Width := 1;
  if OVBuffer[Obj.ObjConstI[1]].Param[5] then //- если активно поездное показание (реле С)
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then  //---------- если активно маневровое (МС)
    begin //------------------------------------------------------- есть МС- неисправность
      if OVBuffer[Obj.ObjConstI[1]].Param[32] then //---------------- если есть блокировка
      begin
        form.Pen.Color := 0; form.Brush.Color := armcolor8; //- цвета черный и темно-серый
      end else //-------------------------------------------------- если же блокировки нет
      begin
        if tab_page then //------------------------------- если переменная мигания активна
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor9; //--------------- цвет белый
        end else //-------------------------------------- если переменная мигания пассивна
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor2; //------------- цвет зеленый
        end;
      end;
    end else //----------------------------------------- если же маневрового показания нет
    begin
      form.Pen.Color := 0; form.Brush.Color := armcolor2; //----------------- цвет зеленый
    end;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[4] then //----------------- если активен поездной ВС
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then //----- одновременно активен маневровый ВС
    begin //------------------------------------------------------ есть МВС- неисправность
      if OVBuffer[Obj.ObjConstI[1]].Param[32] then //---------------- если есть блокировка
      begin //------------------------------------------------------- если есть блокировка
        form.Pen.Color := 0; form.Brush.Color := armcolor8; //- цвета черный и темно-серый
      end else
      begin
        if tab_page then
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor9; //----------- мигание белого
        end else
        begin
          form.Pen.Color := 0; form.Brush.Color := armcolor7;//----------- мигание желтого
        end;
      end;
    end else
    begin
      form.Pen.Color := 0; form.Brush.Color := armcolor7; //без маневрового ВС цвет желтый
    end;
  end else //----------------------------------------- если нет активных поездных датчиков
  if OVBuffer[Obj.ObjConstI[1]].Param[12] and //--- если поездное начала у этого сигнала и
  (Obj.ObjConstI[6] = 0) then //---------------------------- сигнал управляется оператором
  begin
    form.Pen.Color := 0; form.Brush.Color := armcolor9; //------- перо черное, кисть белая
  end else
  begin
    form.Pen.Color := 0; form.Brush.Color := armcolor8;
  end;
  if Obj.ObjConstI[2] = 0 then //---------------------------- без поворота, "утюг" направо
  begin
    form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),
    Point(obj.points[1].X+6,obj.points[1].Y-4),
    Point(obj.points[1].X+10,obj.points[1].Y),
    Point(obj.points[1].X+6,obj.points[1].Y+4),
    Point(obj.points[1].X,obj.points[1].Y+4)]);
  end else
  begin  //---------------------------------------------------- с поворотом, "утюг" налево
    form.PolyGon([Point(obj.points[1].X,obj.points[1].Y-4),
    Point(obj.points[1].X-6,obj.points[1].Y-4),
    Point(obj.points[1].X-10,obj.points[1].Y),
    Point(obj.points[1].X-6,obj.points[1].Y+4),
    Point(obj.points[1].X,obj.points[1].Y+4)]);
  end;
end;
//========================================================================================
//-------------------------------------------------- Контрольная сигнальная точка перегона
procedure DisplayKTAB(Obj: POVStruct;form: TCanvas);
begin
  if obj.ObjConstI[2] = 1 then  //------------------------ Определить ориентацию светофора
  begin //-------------------------------------------------------------------- нога справа
    ptr[1].X := obj.Points[1].X;  ptr[1].Y := obj.Points[1].Y-5;
    ptr[2].X := obj.Points[1].X;  ptr[2].Y := obj.Points[1].Y+6;
    ptr[3].X := 0;
    ptr[4].X := 0;
    ptr[5].X := obj.Points[1].X-11; ptr[5].Y := obj.Points[1].Y-5;
    ptr[6].X := obj.Points[1].X; ptr[6].Y := obj.Points[1].Y+6;
    ptr[7].X := Obj.Points[1].X+2; ptr[7].Y := Obj.Points[1].Y-6;
  end
  else //---------------------------------------------------------------------- нога слева
  begin
    ptr[1].X := obj.Points[1].X;  ptr[1].Y := obj.Points[1].Y-5;
    ptr[2].X := obj.Points[1].X;  ptr[2].Y := obj.Points[1].Y+6;
    ptr[3].X := 0;
    ptr[4].X := 0;
    ptr[5].X := obj.Points[1].X+12; ptr[5].Y := obj.Points[1].Y-5;
    ptr[6].X := obj.Points[1].X+1;  ptr[6].Y := obj.Points[1].Y+6;
    ptr[7].X := Obj.Points[1].X-form.TextWidth(Obj.Title)-2;ptr[7].Y := Obj.Points[1].Y-6;
  end;
  form.Font.Style := [];  form.Font.Size := 8;
  form.Pen.Style := psSolid; form.Pen.Color := armcolor8;  //----------------- темно серый
  form.Brush.Style := bsSolid; form.Brush.Color := armcolor12; //----- черынй (без данных)
  form.Pen.Width := 1;
  form.MoveTo(ptr[1].X,ptr[1].Y);  form.LineTo(ptr[2].X,ptr[2].Y);
  if ptr[3].X > 0 then
  begin
    form.MoveTo(ptr[3].X,ptr[3].Y); form.LineTo(ptr[4].X,ptr[4].Y);
  end;
  //-------------------------------------------------------------------- сигнальная ячейка
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then  //-------------------- нет активизации
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12; form.Pen.Style := psSolid;   //------------------ черный
    form.Brush.Color := armcolor12; form.Brush.Style := bsSolid;
    form.Pen.Width := 1;
  end else
  if OVBuffer[obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Style := psSolid; form.Pen.Color := armcolor14;  //--------------------- циан
    form.Brush.Style := bsSolid; form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
  end else
  if not OVBuffer[obj.ObjConstI[1]].Param[16] or
  OVBuffer[obj.ObjConstI[1]].Param[1] then  //----------- неактивность или  непарафазность
  begin
    form.Font.Color := clBlack;  form.Brush.Style := bsClear;
  end else
  begin  //------------------------------------------------------ если активно и парафазно
    //------------------------------------------------------- 1 этап = выбор цвета сигнала
    if Obj.ObjConstI[3] = 0 then //---------------------------------- если на 000 - желтый
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[2] and
      not OVBuffer[Obj.ObjConstI[1]].Param[3] then //---------- датчик 1 =0 и датчик 2 = 0
      begin
        form.Brush.Color := armcolor7; //------------------------------------------ желтый
        form.Pen.Color := armcolor12;
      end
      else
      if not OVBuffer[Obj.ObjConstI[1]].Param[2] and
      OVBuffer[Obj.ObjConstI[1]].Param[3] then //--------------- датчик 1 =0 идатчик 2 = 1
      begin
        form.Brush.Color := armcolor2; //зеленый
        form.Pen.Color := armcolor12;
      end
      else
      if OVBuffer[Obj.ObjConstI[1]].Param[2] then //------------------------- датчик 1 = 1
      begin
        form.Brush.Color := armcolor1; //----------------------------------------- красный
        form.Pen.Color := armcolor12;
      end;
    end;

    if Obj.ObjConstI[3] = 1 then //----------------------------------- если на 000 зеленый
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[2] and
      not OVBuffer[Obj.ObjConstI[1]].Param[3] then //---------- датчик 1 =0 и датчик 2 = 0
      begin
        form.Brush.Color := armcolor2; //----------------------------------------- зеленый
        form.Pen.Color := armcolor12;
      end
      else
      begin
        if not OVBuffer[Obj.ObjConstI[1]].Param[2] and
        OVBuffer[Obj.ObjConstI[1]].Param[3] then //------------ датчик 1 =0 и датчик 2 = 1
        begin
          form.Brush.Color := armcolor7;//----------------------------------------- желтый
          form.Pen.Color := armcolor12;
        end
        else
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then
        begin
          form.Brush.Color := armcolor1; //--------------------------- датчик 1 =1 красный
          form.Pen.Color := armcolor12;
        end;
      end;
    end
    else form.Font.Color := clBlack;
  end;

  if not OVBuffer[Obj.ObjConstI[1]].Param[4] then  //---------------- если огневое в норме
  form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y)
  else
  begin
    form.Pen.Color := form.Brush.Color;
    form.Ellipse(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
    form.Brush.Color := armcolor15;
    form.Ellipse(ptr[5].X+1,ptr[5].Y+1,ptr[6].X-1,ptr[6].Y-1);
  end;
  //--------------------------------------------------------------------- Нарисовать литер
  form.Pen.Color := armcolor12;
  form.Pen.Style := psSolid;
  form.Brush.Color := armcolor15;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Font.Size := 8;
  form.Font.Style := [];
  form.TextOut(ptr[7].X, ptr[7].Y, Obj.Title);
  exit;
end;

//========================================================================================
//------------------------------------------------------------------- контроль переезда 30
procedure DisplayKontrPereezd(Obj: POVStruct;form: TCanvas);
var
  midl : integer;
begin
  form.Pen.Color:=0;form.Pen.Width:=1;
  form.Pen.Style:=psSolid;form.Brush.Style:=bsSolid;
  if Obj.ObjConstI[3] = 0 then
  begin
    form.MoveTo(obj.Points[1].X-6,obj.Points[1].Y);
    form.LineTo(obj.Points[1].X-13,obj.Points[1].Y);
    form.MoveTo(obj.Points[1].X-9,obj.Points[1].Y);
    form.LineTo(obj.Points[1].X-9,obj.Points[1].Y+10);
    if OVBuffer[Obj.ObjConstI[2]].NParam[2] then form.Pen.Color :=14;
    if Obj.ObjConstI[2] = 0   //------------------------------------------------------ кпа
    then form.LineTo(obj.Points[1].X,obj.Points[1].Y+14);

    form.MoveTo(obj.Points[2].X+5,obj.Points[2].Y);
    form.LineTo(obj.Points[2].X+12,obj.Points[2].Y);
    form.MoveTo(obj.Points[2].X+8,obj.Points[2].Y);
    form.LineTo(obj.Points[2].X+8,obj.Points[2].Y-10);
    if Obj.ObjConstI[2] = 0 then form.LineTo(obj.Points[2].X,obj.Points[2].Y-14); //-- кпа
  end;

  //------------------------------------------------- Неисправность или авария на переезде
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].NParam[2] or OVBuffer[Obj.ObjConstI[1]].NParam[3] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[2] then //-------------------------------------- кпа
  begin  //------------------------------------------------------------------- есть авария
    form.Pen.Color := armcolor4;
    form.Pen.Width := 2;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[3] then //-------------------------------------- кнп
  begin  //------------------------------------------------------------ есть неисправность
    form.Pen.Color := armcolor7;
    form.Pen.Width := 2;
  end else
  begin
    form.Pen.Color := 0;
    form.Pen.Width := 1;
  end;

  form.MoveTo(obj.Points[1].X,obj.Points[1].Y);
  form.LineTo(obj.Points[1].X+5,obj.Points[1].Y+5);
  form.LineTo(obj.Points[1].X+5,obj.Points[2].Y-5);
  form.LineTo(obj.Points[1].X,obj.Points[2].Y);
  form.MoveTo(obj.Points[2].X,obj.Points[1].Y);
  form.LineTo(obj.Points[2].X-5,obj.Points[1].Y+5);
  form.LineTo(obj.Points[2].X-5,obj.Points[2].Y-5);
  form.LineTo(obj.Points[2].X,obj.Points[2].Y);

  //----------------------------------------------------------------- Извещение на переезд
  form.Pen.Style := psSolid;
  form.Pen.Width := 1;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end
  else
  if OVBuffer[Obj.ObjConstI[1]].NParam[8] or //---------------------------------------- пи
  OVBuffer[Obj.ObjConstI[1]].NParam[4] then  //-------------------------------------- кнзп
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[8] then   //------------------------------------- пи
  begin  //---------------------------------------------------------------- есть извещение
        //----------------------------------------------------------------- закрыт переезд
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then form.Brush.Color := armcolor1 //------ кзп
    else  form.Brush.Color := armcolor7;
    form.Pen.Color := 0; form.Pen.Width := 1;
  end else
  begin  //----------------------------------------------------------------- нет извещения
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
  end;
  if Obj.ObjConstI[3] = 0 then
  begin
    form.Ellipse(obj.Points[1].X,obj.Points[1].Y+2,obj.Points[1].X-8,obj.Points[1].Y+10);
    form.Ellipse(obj.Points[1].X-9,obj.Points[1].Y+2,obj.Points[1].X-17,obj.Points[1].Y+10);
    form.Ellipse(obj.Points[2].X,obj.Points[2].Y-2,obj.Points[2].X+8,obj.Points[2].Y-10);
    form.Ellipse(obj.Points[2].X+9,obj.Points[2].Y-2,obj.Points[2].X+17,obj.Points[2].Y-10);
  end;

  //-------------------------------------------------------------------- закрытие переезда
  form.Pen.Style := psSolid;
  if OVBuffer[Obj.ObjConstI[1]].Param[4] then //-------------------------------------- кзп
  begin  //-------------------------------------------------------- есть контроль закрытия
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
    begin //----------------------------------------------------------- нецентрализованный
      form.Pen.Color := armcolor12;
      form.Brush.Color := armcolor12;
    end else
    if OVBuffer[Obj.ObjConstI[1]].NParam[4] then
    begin //--------------------------------------------------------------- непарафазность
      form.Pen.Color := armcolor14;
      form.Brush.Color := armcolor14;
    end
    else  form.Pen.Color := armcolor4;

    form.Pen.Width := 3;
    form.MoveTo(obj.Points[1].X+5,obj.Points[1].Y); form.LineTo(obj.Points[2].X-6,obj.Points[1].Y);
    form.MoveTo(obj.Points[1].X+5,obj.Points[2].Y); form.LineTo(obj.Points[2].X-6,obj.Points[2].Y);
  end;

  //------------------------------------------------------------- включение зГ на переезде
  form.Pen.Style := psSolid;
  if OVBuffer[Obj.ObjConstI[1]].Param[14] then
  begin  //----------------------------------------------------------------------- есть зГ
    midl := (obj.Points[1].X + obj.Points[2].X) div 2;
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] //--------------------- нецентрализованный
    then form.Pen.Color := armcolor12
    else
    if OVBuffer[Obj.ObjConstI[1]].NParam[14]  //--------------------------- непарафазность
    then form.Pen.Color := armcolor14
    else form.Pen.Color := armcolor1;
    form.Brush.Color := form.Pen.Color;
    form.Pen.Width := 1;
    form.Brush.Style := bsSolid;
    form.FillRect(rect(midl-3,obj.Points[1].Y+15,midl+3,obj.Points[2].Y-15));
  end;
end;
//========================================================================================
//----------------------- увязка с перегоном АБ без проходных сигналов и одним участком 31
procedure DisplayUviazkaAB(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 : //----------------------------------------------------------- привязка слева снизу
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

  //----------------------------------------------------------- изобразить элементы увязки
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[5] then //------------------------- перегон свободен
  form.Brush.Color := armcolor8
  else form.Brush.Color := armcolor1; //------------------------------------ перегон занят

  form.Pen.Color := form.Brush.Color;
  form.Pen.Width := 1;
  form.Pen.Style := psSolid;
  form.Rectangle(rect(ptr[19], ptr[20]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[2] then
  begin //------------------------------------------- ближний участок приближения свободен
    form.Pen.Color := armcolor7;
    form.Pen.Width := 3;
  end else
  begin //---------------------------------------------- ближний участок приближения занят
    form.Pen.Color := armcolor1;
    form.Pen.Width := 3;
  end;

  form.MoveTo(ptr[1].X, ptr[1].Y);
  form.LineTo(ptr[2].X, ptr[2].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[7] or
  not OVBuffer[Obj.ObjConstI[1]].Param[2] then
  begin //- перегон стоит на отправл. или ближний занят - участок не имеет сигн. показания
    form.Pen.Color := armcolor12;
    form.Pen.Width := 1;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //----------------------------------------------------- дальний участок свободен
      form.Pen.Width := 3;
      form.Pen.Color := armcolor7;
    end else
    begin //-------------------------------------------------------- дальний участок занят
      form.Pen.Width := 3;
      form.Pen.Color := armcolor1;
    end;
  end;

  form.MoveTo(ptr[3].X, ptr[3].Y);
  form.LineTo(ptr[4].X, ptr[4].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[17] then
  begin //----------------------------------------------- светофор открыт по линейной цепи
    form.Pen.Color := 0;
    form.Brush.Color := armcolor2;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then
    begin //------------------------------------------------- перегон стоит по отправлению
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin //------------------------------------------------ светофор открыт по удалению
        form.Pen.Color := 0;
        form.Brush.Color := armcolor2;
      end else
      begin //------------------------------------------------------------ светофор закрыт
        form.Pen.Color := 0;
        form.Brush.Color := armcolor8;
      end;
    end else
    begin //------------ перегон стоит на приеме - светофор не имеет сигнального показания
      form.Pen.Color := armcolor12;
      form.Brush.Color := armcolor12;
    end;
  end;

  form.Pen.Width := 1;
  form.MoveTo(ptr[5].X, ptr[5].Y);
  form.LineTo(ptr[6].X, ptr[6].Y);
  form.Ellipse(ptr[7].X, ptr[7].Y, ptr[8].X, ptr[8].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin //----------- перегон стоит на отправлении - символ не имеет сигнального показания
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  begin //----------------------------------------------- установлено направление на прием
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end;
  form.Polygon([ptr[11], ptr[12], ptr[13]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //----------- перегон стоит на отправлении - символ не имеет сигнального показания
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  begin //----------------------------------------------- установлено направление на прием
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end;

  form.Rectangle(ptr[9].X, ptr[9].Y, ptr[10].X, ptr[10].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin //-------------- перегон стоит на приеме --- символ не имеет сигнального показания
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  begin //----------------------------------------- установлено направление на отправление
    form.Pen.Color := armcolor2;
    form.Brush.Color := armcolor2;
  end;
  form.Polygon([ptr[16], ptr[17], ptr[18]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //---------------- перегон стоит на приеме - символ не имеет сигнального показания
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  begin //----------------------------------------- установлено направление на отправление
    form.Pen.Color := armcolor2;
    form.Brush.Color := armcolor2;
  end;
  form.Rectangle(ptr[14].X, ptr[14].Y, ptr[15].X, ptr[15].Y);

  if OVBuffer[Obj.ObjConstI[1]].Param[32] then
  TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29] then
  TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[21].X,ptr[21].Y,25);
end;
//========================================================================================
//-------------------------------------------------- увязка с АБ с прох.свет.,капремонт 32
procedure DisplayUviazkaABSvet(Obj:POVStruct;form:TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 : //----------------------------------------------------------- привязка слева снизу
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
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //------------------------------------------------------------- комплект подключен
    if OVBuffer[Obj.ObjConstI[1]].Param[5] then  //---------------------- перегон свободен
    form.Brush.Color := armcolor8
    else form.Brush.Color := armcolor1; //---------------------------------- перегон занят
  end
  else form.Brush.Color := armcolor8;//--------------------------------- Комплект отключен

  form.Pen.Color := form.Brush.Color;
  form.Pen.Width := 1; form.Pen.Style := psSolid;
  form.Rectangle(rect(ptr[15], ptr[16]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[2] then
  form.Pen.Color := armcolor7 //--------------------- ближний участок приближения свободен
  else  form.Pen.Color := armcolor1; //----------------- ближний участок приближения занят

  form.Pen.Width := 3;
  form.MoveTo(ptr[1].X, ptr[1].Y);
  form.LineTo(ptr[2].X, ptr[2].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if (Obj.ObjConstI[3] = 1) and (Obj.ObjConstI[4] = 1) and
  (not OVBuffer[Obj.ObjConstI[1]].Param[2] or
  (not OVBuffer[Obj.ObjConstI[1]].Param[7] and OVBuffer[Obj.ObjConstI[1]].Param[10])) then
  begin //---- путь перегона по отправлению - ближний участок занят или контроль по приему
    form.Pen.Color := 0;
    form.Pen.Width := 1;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //----------------------------------------------------- дальний участок свободен
      form.Pen.Width := 3;
      form.Pen.Color := armcolor7;
    end else
    begin //-------------------------------------------------------- дальний участок занят
      form.Pen.Width := 3;
      form.Pen.Color := armcolor1;
    end;
  end;

  form.MoveTo(ptr[3].X, ptr[3].Y);
  form.LineTo(ptr[4].X, ptr[4].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //------------------------------------------------------------- комплект подключен
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then
    begin //--------- перегон стоит на отправлении - символ не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end else
    begin //--------------------------------------------- установлено направление на прием
      form.Pen.Color := armcolor7;
      form.Brush.Color := armcolor7;
    end;
  end else
  begin //-------------------------------------------------------------- Комплект отключен
    if OVBuffer[Obj.ObjConstI[1]].Param[12] then
    begin
      if Obj.ObjConstI[3] = 0 then
      begin
        form.Pen.Color := 0;
        form.Brush.Color := 0;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor8;
      end;
    end else
    begin
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end;

  form.Pen.Width := 1;
  form.Polygon([ptr[7], ptr[8], ptr[9]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //------------------------------------------------------------- комплект подключен
    if OVBuffer[Obj.ObjConstI[1]].Param[6] then
    begin //--------- перегон стоит на отправлении - символ не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end else
    begin //--------------------------------------------- установлено направление на прием
      form.Pen.Color := armcolor7;
      form.Brush.Color := armcolor7;
    end;
  end else
  begin //-------------------------------------------------------------- Комплект отключен
    if OVBuffer[Obj.ObjConstI[1]].Param[12] then
    begin
      if Obj.ObjConstI[3] = 0 then
      begin
        form.Pen.Color := 0;
        form.Brush.Color := 0;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor8;
      end;
    end else
    begin
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end;
  form.Pen.Width := 1;
  form.Rectangle(rect(ptr[5], ptr[6]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //------------------------------------------------------------- комплект подключен
    if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
    begin //-------------- перегон стоит на приеме - символ не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end else
    begin //--------------------------------------- установлено направление на отправление
      form.Pen.Color := armcolor2;
      form.Brush.Color := armcolor2;
    end;
  end else
  begin //-------------------------------------------------------------- Комплект отключен
    if OVBuffer[Obj.ObjConstI[1]].Param[12] then
    begin
      if Obj.ObjConstI[3] = 1 then
      begin
        form.Pen.Color := 0;
        form.Brush.Color := 0;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor8;
      end;
    end else
    begin
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end;

  form.Pen.Width := 1;
  form.Polygon([ptr[12], ptr[13], ptr[14]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //------------------------------------------------------------- комплект подключен
    if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
    begin //-------------- перегон стоит на приеме - символ не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end else
    begin //--------------------------------------- установлено направление на отправление
      form.Pen.Color := armcolor2;
      form.Brush.Color := armcolor2;
    end;
  end else
  begin //-------------------------------------------------------------- Комплект отключен
    if OVBuffer[Obj.ObjConstI[1]].Param[12] then
    begin
      if Obj.ObjConstI[3] = 1 then
      begin
        form.Pen.Color := 0;
        form.Brush.Color := 0;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor8;
      end;
    end else
    begin
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end;

  form.Pen.Width := 1;
  form.Rectangle(rect(ptr[10], ptr[11]));

  if OVBuffer[Obj.ObjConstI[1]].Param[32] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,25);
end;
//========================================================================================
//------------------------------------------------------------------------ увязка с ПАБ 33
procedure DisplayPAB(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 :
    begin
      ptr[1].X := obj.Points[1].X-52-form.TextWidth(obj.Title);
      ptr[1].Y := obj.Points[1].Y+2;
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

    1 :
    begin
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

    2 :
    begin
      ptr[1].X := obj.Points[1].X-52-form.TextWidth(obj.Title);
      ptr[1].Y := obj.Points[1].Y+2;
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

  form.Brush.Style := bsClear;
  form.font.Style := [];
  form.font.Color := clBlack;
  form.TextOut(ptr[1].X,ptr[1].Y,obj.Title);

  form.Brush.Style := bsSolid;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[2] then form.Pen.Color := armcolor7// прибл.свободно
  else form.Pen.Color := armcolor1; //-------------------------- участок приближения занят
  form.Pen.Width := 3;
  form.MoveTo(ptr[2].X, ptr[2].Y);
  form.LineTo(ptr[3].X, ptr[3].Y);

  form.Pen.Width := 1;
  form.Pen.Color := 0;
  form.MoveTo(ptr[4].X, ptr[4].Y);
  form.LineTo(ptr[5].X, ptr[5].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[3] then
  begin //------------------------------------------------------------ светофор неисправен
    form.Pen.Color := 0;
    form.Brush.Color := armcolor15;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then
    begin //------------------------------------------------------ входной светофор открыт
      form.Pen.Color := 0;
      form.Brush.Color := armcolor2;
    end else
    begin //------------------------------------------------------ входной светофор закрыт
      form.Pen.Color := 0;
      form.Brush.Color := armcolor8;
    end;
  end;
  form.Ellipse(ptr[6].X, ptr[6].Y, ptr[7].X, ptr[7].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //---------------------- есть блок-сигнал поездного отправления с соседней станции
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //------------------------------------------------------------------ перегон занят
    form.Pen.Color := armcolor1;
    form.Brush.Color := armcolor1;
  end else
  begin //----------------------------------------------------- перегон свободен по приему
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end;
  form.Pen.Width := 1;
  form.Rectangle(rect(ptr[8], ptr[9]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[13] then
  begin //------------------------- выдана предварительная команда искусственного прибытия
    form.Pen.Color := armcolor9;
    form.Brush.Color := armcolor9;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[8] then
  begin //------------------------------------------ выдано согласие на отправление поезда
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end else
  begin //----------------------------------------------------- перегон свободен по приему
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end;
  form.Pen.Width := 1;
  form.Polygon([ptr[10], ptr[11], ptr[12]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[12] then
  begin //--------------------------------------------------- неверная комбинация датчиков
    form.Pen.Color := armcolor11;
    form.Brush.Color := armcolor11;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[5] then
  begin //--------------------------------------------------- перегон занят по отправлению
    form.Pen.Color := armcolor1;
    form.Brush.Color := armcolor1;
  end else
  begin //------------------------------------------------ перегон свободен по отправлению
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end;
  form.Rectangle(rect(ptr[13], ptr[14]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[12] then
  begin //--------------------------------------------------- неверная комбинация датчиков
    form.Pen.Color := armcolor11;
    form.Brush.Color := armcolor11;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[11] then
  begin //----------------------------- перегон занят по отправлению хозяйственного поезда
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin //---------------------------------------- получено согласие на отправление поезда
    form.Pen.Color := armcolor5;
    form.Brush.Color := armcolor5;
  end else
  begin //------------------------------------------------ перегон свободен по отправлению
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end;
  form.Polygon([ptr[15], ptr[16], ptr[17]]);

  if OVBuffer[Obj.ObjConstI[1]].Param[32] then
  TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29] then
  TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[18].X,ptr[18].Y,25);
end;
//========================================================================================
//------------------------------------------------------------- изображение ключа-жезла 34
procedure DisplayKluchJezl(Obj: POVStruct;form: TCanvas);
begin
  form.Font.Color := armcolor12;
  form.Brush.Color := armcolor15;
  form.font.Style := [];
  form.Font.Size := 8;
  form.TextOut(obj.Points[1].X-form.TextWidth(obj.Title) div 2,obj.Points[1].Y-20,obj.Title);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //-------------------------------------------------- нецентнрализованное состояние
    form.Brush.Color := armcolor12;
    form.Pen.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Brush.Color := armcolor14;
    form.Pen.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[11] then
  begin //-------------------------------------------------------------------- КЖ вставлен
    form.Brush.Color := 0;
    form.Pen.Color := 0;
  end else
  begin //----------------------------------------------------------------------- КЖ изъят
    form.Brush.Color := armcolor4;
    form.Pen.Color := armcolor4;
  end;

  form.Pen.Width := 1;
  form.Ellipse(obj.Points[1].X-3,obj.Points[1].Y-3,obj.Points[1].X+4,obj.Points[1].Y+4);
  form.Pen.Width := 3;
  form.MoveTo(obj.Points[1].X,obj.Points[1].Y);
  form.LineTo(obj.Points[1].X,obj.Points[1].Y+15);
end;
 //========================================================================================
//-------------------------------------  Увязка с автоблокировкой без смены направления 35
procedure DisplayABbezSN(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 :
    begin
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

    1 :
    begin
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

    2 :
    begin
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

  form.Brush.Color := armcolor12;
  form.Pen.Color := armcolor12;
  form.Pen.Width := 1;
  form.Pen.Style := psSolid;
  form.Polygon([ptr[5],ptr[6],ptr[7],ptr[8],ptr[9]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[2] then
  begin //------------------------------------------- ближний участок приближения свободен
    form.Pen.Width := 3;
    form.Pen.Color := armcolor7;
  end else
  begin //---------------------------------------------- ближний участок приближения занят
    form.Pen.Width := 3;
    form.Pen.Color := armcolor1;
  end;
  form.MoveTo(ptr[1].X, ptr[1].Y);
  form.LineTo(ptr[2].X, ptr[2].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if (Obj.ObjConstI[4] = 1) and
  not OVBuffer[Obj.ObjConstI[1]].Param[2] then
  begin //------------------ ближний участок занят и есть признак гашения дальнего участка
    form.Pen.Width := 1;
    form.Pen.Color := 0;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[3] then
  begin //------------------------------------------------------- дальний участок свободен
    form.Pen.Width := 3;
    form.Pen.Color := armcolor7;
  end else
  begin //---------------------------------------------------------- дальний участок занят
    form.Pen.Width := 3;
    form.Pen.Color := armcolor1;
  end;
  form.MoveTo(ptr[3].X, ptr[3].Y);
  form.LineTo(ptr[4].X, ptr[4].Y);

  if OVBuffer[Obj.ObjConstI[1]].Param[32] then
  TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29] then
  TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and
  OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[10].X,ptr[10].Y,25);
end;
 ///========================================================================================
//------------------------------------------------------- Увязка межпостовая с запросом 36
procedure DisplayMejPost(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 :
    begin
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

  form.Pen.Style := psSolid;
  form.Pen.Width := 3;

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[6] then //------------- участок приближения свободен
  form.Pen.Color := 0
  else form.Pen.Color := armcolor1; //-------------------------- участок приближения занят

  form.MoveTo(ptr[1].X, ptr[1].Y);
  form.LineTo(ptr[2].X, ptr[2].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[3] then form.Pen.Color := armcolor12
  else
  begin //---------------------------------------------- Замкнут маршрут с соседнего поста
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then form.Pen.Color := 0 //-------- ИП свободен
    else form.Pen.Color := armcolor1;//------------------------------------------ ИП занят
  end;

  form.MoveTo(ptr[3].X, ptr[3].Y);
  form.LineTo(ptr[4].X, ptr[4].Y);

  form.Pen.Width := 1;
  if OVBuffer[Obj.ObjConstI[1]].Param[16] and
  not OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin
    if not OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //-------------------------------------------- Замкнут маршрут с соседнего поста
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //-------------------------------------------------------------------- есть КМ
        form.Pen.Color := armcolor7;
        form.Brush.Color := armcolor7;
      end else
      begin //--------------------------------------------------------------------- нет КМ
        form.Pen.Color := armcolor2;
        form.Brush.Color := armcolor2;
      end;
      form.PolyGon([ptr[5],ptr[6],ptr[7]]);
    end;
  end;

  if OVBuffer[Obj.ObjConstI[1]].Param[16] and
  not OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin
    if not OVBuffer[Obj.ObjConstI[1]].Param[2] then
    begin //-------------------------------------------- Замкнут маршрут с соседнего поста
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin //-------------------------------------------------------------------- есть КМ
        form.Pen.Color := armcolor7;
        form.Brush.Color := armcolor7;
      end else
      begin //--------------------------------------------------------------------- нет КМ
        form.Pen.Color := armcolor2;
        form.Brush.Color := armcolor2;
      end;
      form.PolyGon([ptr[8],ptr[9],ptr[10]]);
    end;
  end;

  form.Pen.Color := 0;
  form.Pen.Width := 1;
  form.Font.Color := clBlack;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[11] then
  begin
    form.Pen.Color := 0;
    form.Brush.Color := armcolor2;
  end else
  begin //-------------------------------------------------- нет разрешения на отправление
    if OVBuffer[Obj.ObjConstI[1]].Param[12] then
    form.Brush.Color := armcolor7 //---------------------------- дан запрос на отправление
    else form.Brush.Color := bkkeycolor; //-------------------- нет запроса на отправление
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
  if Obj.ObjConstI[3] = 1 then
  form.TextOut(ptr[16].X, ptr[16].Y,'очП')
  else form.TextOut(ptr[16].X, ptr[16].Y,'оНП');

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[10] then
  begin //-------------------------------------------------------- получен запрос на прием
    form.Pen.Color := 0;
    form.Font.Color := clBlack;
    form.Brush.Color := armcolor7;
  end else
  begin //----------------------------------------------------------- нет запроса на прием
    form.Pen.Color := armcolor8;
    form.Font.Color := armcolor8;
    form.Brush.Color := armcolor15;
  end;

  form.PolyGon([ptr[17],ptr[18],ptr[19],ptr[20],ptr[21]]);
  form.Brush.Style := bsClear;
  if Obj.ObjConstI[3] = 1 then form.TextOut(ptr[22].X, ptr[22].Y,'ПНП')
  else form.TextOut(ptr[22].X, ptr[22].Y,'ПчП');

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[8] then
  begin //------------------------------------------------------------------- получен 1ЭГС
    form.Pen.Color := 0;
    form.Font.Color := clBlack;
    form.Brush.Color := armcolor1;
  end else
  begin //----------------------------------------------------------------------- нет 1ЭГС
    form.Pen.Color := armcolor8;
    form.Font.Color := armcolor8;
    form.Brush.Color := armcolor15;
  end;

  form.RoundRect(ptr[23].X,ptr[23].Y,ptr[24].X,ptr[24].Y,4,30);
  form.Brush.Style := bsClear;
  if Obj.ObjConstI[3] = 1 then form.TextOut(ptr[25].X, ptr[25].Y,'чЭГС')
  else form.TextOut(ptr[25].X, ptr[25].Y,'НЭГС');

  form.Font.Color := clBlack; form.Brush.Style := bsClear;
  form.TextOut(obj.Points[2].X, obj.Points[2].Y,obj.Title);

  if OVBuffer[Obj.ObjConstI[1]].Param[32] then
  TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29] then
  TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and
  OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[26].X,ptr[26].Y,25);
end;
//========================================================================================
//------------------------------------------------------------------------ Увязка с ГАЦ 37
procedure DisplayGAC(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 : //----------------------------------------------------------------- привязка слева
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
    else  //-------------------------------------------------------------- привязка справа
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
      ptr[25].X := obj.Points[1].X-2-form.TextWidth(obj.Title);
      ptr[25].Y := obj.Points[1].Y+5;
      ptr[26].X := obj.Points[1].X-4; ptr[26].Y := obj.Points[1].Y;
      ptr[27].X := obj.Points[1].X-80; ptr[27].Y := obj.Points[1].Y;
      ptr[28].X := obj.Points[1].X-50; ptr[28].Y := obj.Points[1].Y-15;
  end;

  //--------------------------------------------------------------------------------- путь
  form.Pen.Width := 3;
  form.Pen.Color := armcolor12;
  form.Pen.Style := psSolid;
  form.MoveTo(ptr[1].X,ptr[1].Y);
  form.LineTo(ptr[2].X,ptr[2].Y);
  //-------------------------------------------------------------------------------- бугор
  form.Brush.Color := armcolor12;
  form.Brush.Style := bsVertical;
  form.Pen.Width := 1;
  form.Polygon([ptr[21],ptr[22],ptr[23],ptr[24]]);

  //---------------------------------------------------------------------------------- ЭГС
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //------------------ нецентрализованный
  begin
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then //--------------------------- непарафазность
  begin
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[8] then //------------------------------- есть ЭГС
    begin
      form.Pen.Color := 0;
      form.Brush.Color := armcolor1;
      form.Font.Color := clBlack;
    end else //------------------------------------------------------------------- нет ЭГС
    begin
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor15;
      form.Font.Color := armcolor8;
    end;
  end;

  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.RoundRect(ptr[3].X,ptr[3].Y,ptr[4].X,ptr[4].Y,4,30);
  form.Brush.Style := bsClear; form.Font.Style := [];
  form.TextOut(ptr[3].X+3,ptr[3].Y,obj.Title+'ЭГС');
  //----------------------------------------------------------------------------- согласие
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //------------------ нецентрализованный
  begin
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then //--------------------------- непарафазность
  begin
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[6] then //------------------ есть согласие надвига
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then //--------------- есть согласие маневров
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor11;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end;
    end else
    begin //--------------------------------------------------------- нет согласия надвига
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then //--------------- есть согласие маневров
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor9;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor15;
        form.Font.Color := armcolor8;
      end;
    end;
  end;

  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Polygon([ptr[5],ptr[6],ptr[7],ptr[8],ptr[9]]);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[6].X+1,ptr[6].Y,obj.Title+'С');

  //------------------------------------------------------------------ отказ от осаживания
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then  //----------------- нецентрализованный
  begin
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then //--------------------------- непарафазность
  begin
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[9] then //-------- есть согласие отказа осаживания
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then //------------ есть отказ от осаживания
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor7;
        form.Font.Color := clBlack;
      end;
    end else //-------------------------------------------- нет согласия отказа осаживания
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then //------------ есть отказ от осаживания
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor15;
        form.Font.Color := armcolor8;
      end;
    end;
  end;

  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Polygon([ptr[10],ptr[11],ptr[12],ptr[13],ptr[14]]);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[10].X+1,ptr[10].Y,obj.Title+'оо');
  //-------------------------------------------------------------------- горочный светофор
  form.Pen.Style := psSolid;
  form.Pen.Color := 0;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.MoveTo(ptr[15].X,ptr[15].Y);
  form.LineTo(ptr[16].X,ptr[16].Y);
  form.MoveTo(ptr[17].X,ptr[17].Y);
  form.LineTo(ptr[18].X,ptr[18].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then  //----------------- нецентрализованный
  begin
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then //--------------------------- непарафазность
  begin
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then //------------------ есть маневровый огонь
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[3] or
      OVBuffer[Obj.ObjConstI[1]].Param[4] or
      OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //-------------------------------------------- недопустимое состояние датчиков
        form.Pen.Color := 0;
        form.Brush.Color := armcolor11;
        form.Font.Color := clBlack;
      end else //---------------------------------------------------- Маневровое показание
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor9;
        form.Font.Color := clBlack;
      end;
    end else
    begin //--------------------------------------------------------- нет маневрового огня
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      begin //------------------------------------------------------------ есть осаживание
        form.Pen.Color := 0;
        form.Brush.Color := armcolor1;
        form.Font.Color := clBlack;
      end else
      if OVBuffer[Obj.ObjConstI[1]].Param[4] or
      OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //---------------------------------------------------------------- есть надвиг
        form.Pen.Color := 0;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := 0;
        form.Brush.Color := armcolor8;
        form.Font.Color := clBlack;
      end;
    end;
  end;
  form.Ellipse(ptr[19].X,ptr[19].Y,ptr[20].X,ptr[20].Y);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[28].X,ptr[28].Y,obj.Title+'П');
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //------------------ нецентрализованный
  begin
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then //--------------------------- непарафазность
  begin
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
    form.Pen.Width := 3;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[11] then //------------------- есть занятость горы
    begin
      form.Pen.Color := armcolor1;
      form.Brush.Color := armcolor1;
    end else //------------------------------------------------------------- гора свободна
    begin
      form.Pen.Color := 0;
      form.Brush.Color := armcolor15;
    end;

    if OVBuffer[Obj.ObjConstI[1]].Param[12] then form.Pen.Width := 3// есть замыкание горы
    else form.Pen.Width := 1; //------------------------------------------ гора разомкнута
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.MoveTo(ptr[26].X,ptr[26].Y);
  form.LineTo(ptr[27].X,ptr[27].Y);
  form.Brush.Style := bsClear;

  if not OVBuffer[obj.ObjConstI[1]].Param[16] or
  OVBuffer[obj.ObjConstI[1]].Param[1] then   form.Font.Color := clBlack
  else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[19] or //-------- светофор заблокирован (колпачек)
    OVBuffer[Obj.ObjConstI[1]].Param[20] or
    OVBuffer[Obj.ObjConstI[1]].Param[21] or
    OVBuffer[Obj.ObjConstI[1]].Param[22] or
    OVBuffer[Obj.ObjConstI[1]].Param[23] or
    OVBuffer[Obj.ObjConstI[1]].Param[24] or
    OVBuffer[Obj.ObjConstI[1]].Param[25] or
    OVBuffer[Obj.ObjConstI[1]].Param[26] or
    OVBuffer[Obj.ObjConstI[1]].Param[27] or
    OVBuffer[Obj.ObjConstI[1]].Param[28] or
    OVBuffer[Obj.ObjConstI[1]].Param[29] or
    OVBuffer[Obj.ObjConstI[1]].Param[30] or
    OVBuffer[Obj.ObjConstI[1]].Param[31] or
    OVBuffer[Obj.ObjConstI[1]].Param[32] then form.Font.Color := armcolor1
    else form.Font.Color := clBlack;
  end;
  form.TextOut(ptr[25].X,ptr[25].Y,obj.Title);
end;
//========================================================================================
//------------------------------------------------------------------ маневровая колонка 38
procedure DisplayManevrKolon(Obj: POVStruct;form: TCanvas);
var
  x1 : integer;
begin
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
    form.Pen.Color := armcolor9;
    form.Pen.Width := 2;
  end else
  begin
    form.Pen.Color := 0;
    form.Pen.Width := 1;
  end;
  form.Rectangle(ptr[1].X,ptr[1].Y,ptr[2].X,ptr[2].Y);
  if (ptr[11].X > 0) and (ptr[12].X > 0) then
  begin //------------------------------------------------ нарисовать хвост (ногу колонки)
    form.MoveTo(ptr[11].X,ptr[11].Y);
    form.LineTo(ptr[12].X,ptr[12].Y);
    if ptr[13].X > 0 then
    begin
      form.LineTo(ptr[13].X,ptr[13].Y);
      if ptr[14].X > 0 then
      begin
        form.LineTo(ptr[14].X,ptr[14].Y);
        if ptr[15].X > 0 then form.LineTo(ptr[15].X,ptr[15].Y);
      end;
    end;
  end;
  form.Pen.Width := 1;
  //-------------------------------------------------------------------------------- РМ+ОТ
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //---------------------------------------------------------------------- есть РМ
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin //-------------------------------------------------------------------- есть ОТ
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor11;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[11] then
    begin //--------------------------------------------------------------------- есть РМК
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin //-------------------------------------------------------------------- есть ОТ
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor9;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor7;
        form.Font.Color := clBlack;
      end;
    end else
    begin //----------------------------------------------------------------- нет РМ и РМК
      if OVBuffer[Obj.ObjConstI[1]].Param[4] then
      begin //-------------------------------------------------------------------- есть ОТ
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor9;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor15;
        form.Font.Color := armcolor8;
      end;
    end;
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Rectangle(ptr[3].X,ptr[3].Y,ptr[4].X,ptr[4].Y);
  form.Brush.Style := bsClear; form.Font.Style := [];
  form.TextOut(ptr[3].X+2,ptr[3].Y,'РМ');
  //------------------------------------------------------------------------------------ В
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then
    begin //----------------------------------------------------------------------- есть В
      form.Pen.Color := clBlack;
      form.Brush.Color := armcolor7;
      form.Font.Color := clBlack;
    end else
    begin //------------------------------------------------------------------------ нет В
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor15;
      form.Font.Color := armcolor8;
    end;
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Rectangle(ptr[5].X,ptr[5].Y,ptr[6].X,ptr[6].Y);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[5].X+2,ptr[5].Y,'В');
  //------------------------------------------------------------- Искусственное размыкание
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := 0;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := 0;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then
    begin //---------------------------------------------------------------- есть предв МИ
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin //---------------------------------------------------------------- есть исп МИ
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor1;
        form.Font.Color := clBlack;
      end else
      begin
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor9;
        form.Font.Color := clBlack;
      end;
    end else
    begin //----------------------------------------------------------------- нет предв МИ
      if OVBuffer[Obj.ObjConstI[1]].Param[8] then
      begin //---------------------------------------------------------------- есть исп МИ
        form.Brush.Color := armcolor1;
        form.Font.Color := 0;
      end else
      begin
        form.Brush.Color := bkkeycolor;
        form.Font.Color := armcolor8;
      end;
    end;
  end;
  form.Brush.Style := bsSolid;
  form.FillRect(rect(ptr[7],ptr[8]));
  x1 := (ptr[7].X + ptr[8].X - form.TextWidth(obj.Title)) div 2;
  form.Font.Color := clBlack;
  form.Brush.Style := bsClear;
  form.TextOut(x1,ptr[7].Y+1,obj.Title);
  //-------------------------------------------------------------------------------- МИ+ОИ
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := clBlack;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[6] then
    begin //---------------------------------------------------------------------- есть МИ
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //-------------------------------------------------------------------- есть ОИ
        form.Pen.Color := armcolor8;
        form.Brush.Color := armcolor15;
        form.Font.Color := armcolor8;
      end else
      begin
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor11;
        form.Font.Color := clBlack;
      end;
    end else
    begin //----------------------------------------------------------------------- нет МИ
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then
      begin //---------------------------------------------------- есть ОИ - неисправность
        if OVBuffer[Obj.ObjConstI[1]].Param[4] then
        begin //------------------------------------------------------------------ есть ОТ
          form.Pen.Color := clBlack;
          form.Brush.Color := armcolor11;
          form.Font.Color := clBlack;
        end else
        begin //------------------------------------------------------------------- нет ОТ
          form.Pen.Color := clBlack;
          form.Brush.Color := armcolor2;
          form.Font.Color := clBlack;
        end;
      end else
      begin
        form.Pen.Color := clBlack;
        form.Brush.Color := armcolor2;
        form.Font.Color := clBlack;
      end;
    end;
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Rectangle(ptr[9].X,ptr[9].Y,ptr[10].X,ptr[10].Y);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[9].X+2,ptr[9].Y,'МИ');
end;
//========================================================================================
//------------------------------------------------------------------------ Увязка с МЭЦ 39
procedure DisplayMEC(Obj: POVStruct;form: TCanvas);
begin
  case Obj.ObjConstI[2] of
    0 : //--------------------------------------------------------------------- МЭЦ справа
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
    //-------------------------------------------------------------------------- МЭЦ слева
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

  //----------------------------------------------------------------------------------- МП
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin
    //----------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin
    //--------------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then
    begin
      //-------------------------------------------------------------------------- есть МП
      form.Pen.Color := 0;
      form.Brush.Color := armcolor7;
      form.Font.Color := clBlack;
    end else
    begin
      //--------------------------------------------------------------------------- нет МП
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor15;
      form.Font.Color := armcolor8;
    end;
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Polygon([ptr[1],ptr[2],ptr[3],ptr[4],ptr[5]]);
  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.TextOut(ptr[6].X,ptr[6].Y,'МП');
  //----------------------------------------------------------------------------------- МО
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin
    //----------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Brush.Color := armcolor12;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin
    //--------------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Brush.Color := armcolor14;
    form.Font.Color := clBlack;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin
      //-------------------------------------------------------------------------- есть МО
      form.Pen.Color := 0;
      form.Brush.Color := armcolor7;
      form.Font.Color := clBlack;
    end else
    begin
      //--------------------------------------------------------------------------- нет МО
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor15;
      form.Font.Color := armcolor8;
    end;
  end;
  form.Pen.Style := psSolid;
  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Polygon([ptr[7],ptr[8],ptr[9],ptr[10],ptr[11]]);
  form.Brush.Style := bsClear;
  form.TextOut(ptr[12].X,ptr[12].Y,'Мо');
end;
//========================================================================================
//------------- Увязка с автоблокировкой с проходными светофорами, постоянного действия 40
procedure DisplayABPost(Obj: POVStruct;form: TCanvas);
var
  VidBuf : Integer;
begin
  VidBuf := Obj.ObjConstI[1];
  case Obj.ObjConstI[2] of
    0 : //----------------------------------------------------------- привязка слева снизу
    begin

      ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y; //------------------ 1УП
      ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;

      ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;//------------------ 2УП
      ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;

      ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y-18;//----- НВ - ЧВ прием
      ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y-25;

      ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y-15;//--- НСН - ЧСН прием
      ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y-22;
      ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y-29;

      ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y-18;//НВ-ЧВ отправление
      ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y-25;

      ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y-15;//НСН-ЧСН отпр-ение
      ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y-22;
      ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y-29;

      ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y-18;
      ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y-25;//--------- перегон

      ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y-17;//точка ограничений
    end;

    1 :
    begin
      ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y; //------------------ 1УП
      ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;

      ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;//------------------ 2УП
      ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;

      ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y-18;//----- НВ - ЧВ прием
      ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y-25;

      ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y-15;//--- НСН - ЧСН прием
      ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y-22;
      ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y-29;

      ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y-18;//НВ-ЧВ отправление
      ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y-25;

      ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y-15;//НСН-ЧСН отпр-ение
      ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y-22;
      ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y-29;

      ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y-18;//--------- перегон
      ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y-25;

      ptr[17].X := obj.Points[1].X+25; ptr[17].Y := obj.Points[1].Y-17;//точка ограничений
    end;

    2 :
    begin
      ptr[1].X := obj.Points[1].X-2; ptr[1].Y := obj.Points[1].Y; //------------------ 1УП
      ptr[2].X := obj.Points[1].X-23; ptr[2].Y := obj.Points[1].Y;

      ptr[3].X := obj.Points[1].X-28; ptr[3].Y := obj.Points[1].Y;//------------------ 2УП
      ptr[4].X := obj.Points[1].X-50; ptr[4].Y := obj.Points[1].Y;

      ptr[5].X := obj.Points[1].X-28; ptr[5].Y := obj.Points[1].Y+23;//----- НВ - ЧВ прием
      ptr[6].X := obj.Points[1].X-22; ptr[6].Y := obj.Points[1].Y+16;

      ptr[7].X := obj.Points[1].X-22; ptr[7].Y := obj.Points[1].Y+26;//--- НСН - ЧСН прием
      ptr[8].X := obj.Points[1].X-15; ptr[8].Y := obj.Points[1].Y+19;
      ptr[9].X := obj.Points[1].X-22; ptr[9].Y := obj.Points[1].Y+12;

      ptr[10].X := obj.Points[1].X-35; ptr[10].Y := obj.Points[1].Y+23;//НВ-ЧВ отправление
      ptr[11].X := obj.Points[1].X-41; ptr[11].Y := obj.Points[1].Y+16;

      ptr[12].X := obj.Points[1].X-42; ptr[12].Y := obj.Points[1].Y+26;//НСН-ЧСН отпр-ение
      ptr[13].X := obj.Points[1].X-49; ptr[13].Y := obj.Points[1].Y+19;
      ptr[14].X := obj.Points[1].X-42; ptr[14].Y := obj.Points[1].Y+12;

      ptr[15].X := obj.Points[1].X-29; ptr[15].Y := obj.Points[1].Y+23;//--------- перегон
      ptr[16].X := obj.Points[1].X-34; ptr[16].Y := obj.Points[1].Y+16;

      ptr[17].X := obj.Points[1].X-37; ptr[17].Y := obj.Points[1].Y+3;//точка ограничений
    end;

    else
      ptr[1].X := obj.Points[1].X+2; ptr[1].Y := obj.Points[1].Y; //------------------ 1УП
      ptr[2].X := obj.Points[1].X+23; ptr[2].Y := obj.Points[1].Y;

      ptr[3].X := obj.Points[1].X+28; ptr[3].Y := obj.Points[1].Y;//------------------ 2УП
      ptr[4].X := obj.Points[1].X+50; ptr[4].Y := obj.Points[1].Y;

      ptr[5].X := obj.Points[1].X+28; ptr[5].Y := obj.Points[1].Y+23;//----- НВ - ЧВ прием
      ptr[6].X := obj.Points[1].X+22; ptr[6].Y := obj.Points[1].Y+16;

      ptr[7].X := obj.Points[1].X+21; ptr[7].Y := obj.Points[1].Y+26;//--- НСН - ЧСН прием
      ptr[8].X := obj.Points[1].X+14; ptr[8].Y := obj.Points[1].Y+19;
      ptr[9].X := obj.Points[1].X+21; ptr[9].Y := obj.Points[1].Y+12;

      ptr[10].X := obj.Points[1].X+35; ptr[10].Y := obj.Points[1].Y+23;//НВ-ЧВ отправление
      ptr[11].X := obj.Points[1].X+41; ptr[11].Y := obj.Points[1].Y+16;

      ptr[12].X := obj.Points[1].X+41; ptr[12].Y := obj.Points[1].Y+26;//НСН-ЧСН отпр-ение
      ptr[13].X := obj.Points[1].X+48; ptr[13].Y := obj.Points[1].Y+19;
      ptr[14].X := obj.Points[1].X+41; ptr[14].Y := obj.Points[1].Y+12;

      ptr[15].X := obj.Points[1].X+29; ptr[15].Y := obj.Points[1].Y+23;//--------- перегон
      ptr[16].X := obj.Points[1].X+34; ptr[16].Y := obj.Points[1].Y+16;

      ptr[17].X := obj.Points[1].X+25; ptr[17].Y := obj.Points[1].Y+3;// точка ограничений
  end;

  if not OVBuffer[VidBuf].Param[16] then //------------------------------ если не активный
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 1;
  end else
  if OVBuffer[VidBuf].Param[1] then //---------------------------------- если непарафазный
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
  end else
  if OVBuffer[VidBuf].Param[5] then //----------------------------------- если КП свободен
  form.Brush.Color := armcolor8  //-------------------------------------- перегон свободен
  else form.Brush.Color := armcolor1; //------------------------------------ перегон занят

  form.Pen.Color := form.Brush.Color;
  form.Pen.Width := 1;
  form.Pen.Style := psSolid;
  form.Rectangle(rect(ptr[15], ptr[16])); //--------------- отображение состояния перегона

  if not OVBuffer[VidBuf].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[VidBuf].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if OVBuffer[VidBuf].Param[2] then form.Pen.Color := armcolor7 //---- ближний УП свободен
  else form.Pen.Color := armcolor1;  //----------------- ближний участок приближения занят

  form.Pen.Width := 3;
  form.MoveTo(ptr[1].X, ptr[1].Y); form.LineTo(ptr[2].X, ptr[2].Y); //--- отображежние 1УП

  if not OVBuffer[VidBuf].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[VidBuf].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if (Obj.ObjConstI[3] = 1) and //------------------ прием и отправление различаются и ...
  (Obj.ObjConstI[4] = 1) and //------------------------- при отправлениии гасить 2УП и ...
  (not OVBuffer[VidBuf].Param[2]) and //---------------------------------- 1УП занят и ...
  OVBuffer[VidBuf].Param[7] //------------------------------------------ отправление
  //and OVBuffer[VidBuf].Param[10]
  then
  begin //---- путь перегона по отправлению - ближний участок занят или контроль по приему
    form.Pen.Color := 0;
    form.Pen.Width := 1;
  end else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin //----------------------------------------------------- дальний участок свободен
      form.Pen.Width := 3;
      form.Pen.Color := armcolor7;
    end else
    begin //-------------------------------------------------------- дальний участок занят
      form.Pen.Width := 3;
      form.Pen.Color := armcolor1;
    end;
  end;
  form.MoveTo(ptr[3].X, ptr[3].Y);
  form.LineTo(ptr[4].X, ptr[4].Y);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin //--------------------------------------------------- перегон стоит на отправлении
    if OVBuffer[Obj.ObjConstI[1]].Param[18] then
    begin //------------------------------------------ получен запрос на смену направления
      form.Pen.Color := armcolor9;
      form.Brush.Color := armcolor9;
    end else
    begin //----------------------------------------------- не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end else
  begin //----------------------------------------------- установлено направление на прием
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end;
  form.Pen.Width := 1;
  form.Polygon([ptr[7], ptr[8], ptr[9]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //------------------ перегон стоит на отправлении - не имеет сигнального показания
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end else
  begin //----------------------------------------------- установлено направление на прием
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
  end;
  form.Pen.Width := 1;
  form.Rectangle(rect(ptr[5], ptr[6]));

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[7] then
  begin //---------------- перегон стоит на приеме - символ не имеет сигнального показания
    if OVBuffer[Obj.ObjConstI[1]].Param[18] then
    begin //------------------------------------------ получен запрос на смену направления
      form.Pen.Color := armcolor9;
      form.Brush.Color := armcolor9;
    end else
    begin //----------------------------------------------- не имеет сигнального показания
      form.Pen.Color := armcolor8;
      form.Brush.Color := armcolor8;
    end;
  end else
  begin //----------------------------------------- установлено направление на отправление
    form.Pen.Color := armcolor2;
    form.Brush.Color := armcolor2;
  end;
  form.Pen.Width := 1;
  form.Polygon([ptr[12], ptr[13], ptr[14]]);

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
  end else
  if not OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //---------------- перегон стоит на приеме - символ не имеет сигнального показания
    form.Pen.Color := armcolor8;
    form.Brush.Color := armcolor8;
  end else
  begin //----------------------------------------- установлено направление на отправление
    form.Pen.Color := armcolor2;
    form.Brush.Color := armcolor2;
  end;

  form.Pen.Width := 1;
  form.Rectangle(rect(ptr[10], ptr[11]));

  if OVBuffer[Obj.ObjConstI[1]].Param[32]
  then TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,3)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[29]
  then  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,24)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] and
  OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,2)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[30] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,26)
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[31] then
  TabloMain.ImageList.Draw(form,ptr[17].X,ptr[17].Y,25);
end;
//========================================================================================
//-------------------------------------------------------- отображение перегонной точки 42
procedure DisplayPerToch(Obj: POVStruct;form: TCanvas);
var
  p : boolean;
  x1,y1,VidBuf : integer;
begin
  p := false;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //---------------------------------------------------------- отсутствие информации
    form.Brush.Color := armcolor8; form.Pen.Color := 0;
    form.Pen.Width := 1; form.Font.Color := clBlack;
    ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
    ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
    ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
    ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
    ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
    ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
    x1 := 2;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //-------------------------------------------------------- непарафазность датчиков
    form.Brush.Color := armcolor14; form.Pen.Color := 0;
    form.Pen.Width := 1; form.Font.Color := clBlack;
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
    begin //------------------------------------------------------------ перегон по приему
      if Obj.ObjConstI[3] = 0 then        //------------------- если на экране прием влево
      begin
        ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
        ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
      end else
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
      end else
      begin
        ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
        ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
        ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
      end;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[20] then
    begin //------------------------------------------------------- перегон по отправлению
      if Obj.ObjConstI[3] = 0 then
      begin
        ptr[2].X := obj.Points[1].X + 7; ptr[2].Y := obj.Points[1].Y - 5;
        ptr[3].X := obj.Points[1].X + 12; ptr[3].Y := obj.Points[1].Y;
        ptr[4].X := obj.Points[1].X + 7; ptr[4].Y := obj.Points[1].Y + 5;
      end else
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
      end else
      begin
        ptr[5].X := obj.Points[1].X - 7; ptr[5].Y := obj.Points[1].Y + 5;
        ptr[6].X := obj.Points[1].X - 12; ptr[6].Y := obj.Points[1].Y;
        ptr[1].X := obj.Points[1].X - 7; ptr[1].Y := obj.Points[1].Y - 5;
      end;
    end else
    begin //------------------------------------------------------ перегон без направления
      ptr[1].X := obj.Points[1].X - 8; ptr[1].Y := obj.Points[1].Y - 5;
      ptr[2].X := obj.Points[1].X + 8; ptr[2].Y := obj.Points[1].Y - 5;
      ptr[3].X := obj.Points[1].X + 7; ptr[3].Y := obj.Points[1].Y;
      ptr[4].X := obj.Points[1].X + 8; ptr[4].Y := obj.Points[1].Y + 5;
      ptr[5].X := obj.Points[1].X - 8; ptr[5].Y := obj.Points[1].Y + 5;
      ptr[6].X := obj.Points[1].X - 7; ptr[6].Y := obj.Points[1].Y;
    end;

    VidBuf := Obj.ObjConstI[1];
    case Obj.ObjConstI[4] of
      1 :
      begin //--------------------------------------------------------------- только прием
        if OVBuffer[VidBuf].Param[19] then
        begin
          case Obj.ObjConstI[2] of
            1 : p := OVBuffer[VidBuf].Param[2]; //------------------------------- 1ж прием
            2 : p := OVBuffer[VidBuf].Param[4]; //------------------------------- 2ж прием
            3 : p := OVBuffer[VidBuf].Param[6];//-------------------------------- 3ж прием
            4 : p := OVBuffer[VidBuf].Param[8];//-------------------------------- 4ж прием
            5 : p := OVBuffer[VidBuf].Param[10];//------------------------------- 5ж прием
            6 : p := OVBuffer[VidBuf].Param[12];//------------------------------- 6ж прием
            7 : p := OVBuffer[VidBuf].Param[14];//------------------------------- 7ж прием
            8 : p := OVBuffer[VidBuf].Param[17];//------------------------------- 8ж прием
            else  x1 := 0;
          end;
        end
        else x1 := 0; //------------------------------------- требуется обсерить точку
      end;

      2 :
      begin //--------------------------------------------------------- только отправление
        if OVBuffer[Obj.ObjConstI[1]].Param[20] then
        begin
          case Obj.ObjConstI[2] of
            1 : p := OVBuffer[VidBuf].Param[3];
            2 : p := OVBuffer[VidBuf].Param[5];
            3 : p := OVBuffer[VidBuf].Param[7];
            4 : p := OVBuffer[VidBuf].Param[9];
            5 : p := OVBuffer[VidBuf].Param[11];
            6 : p := OVBuffer[VidBuf].Param[13];
            7 : p := OVBuffer[VidBuf].Param[15];
            8 : p := OVBuffer[VidBuf].Param[18];
            else x1 := 0;
          end;
        end
        else x1 := 0; //----------------------------------------- требуется обсерить точку
      end;

      else //------------------------------------------------------------- двунаправленный
      if OVBuffer[VidBuf].Param[19] then
      begin
        case Obj.ObjConstI[2] of
          1 : p := OVBuffer[VidBuf].Param[2];
          2 : p := OVBuffer[VidBuf].Param[4];
          3 : p := OVBuffer[VidBuf].Param[6];
          4 : p := OVBuffer[VidBuf].Param[8];
          5 : p := OVBuffer[VidBuf].Param[10];
          6 : p := OVBuffer[VidBuf].Param[12];
          7 : p := OVBuffer[VidBuf].Param[14];
          8 : p := OVBuffer[VidBuf].Param[17];
          else x1 := 0;
        end;
      end else
      if OVBuffer[VidBuf].Param[20] then
      begin
        case Obj.ObjConstI[2] of
          1 : p := OVBuffer[VidBuf].Param[3];
          2 : p := OVBuffer[VidBuf].Param[5];
          3 : p := OVBuffer[VidBuf].Param[7];
          4 : p := OVBuffer[VidBuf].Param[9];
          5 : p := OVBuffer[VidBuf].Param[11];
          6 : p := OVBuffer[VidBuf].Param[13];
          7 : p := OVBuffer[VidBuf].Param[15];
          8 : p := OVBuffer[VidBuf].Param[18];
          else x1 := 0;
        end;
      end else
      begin
        case Obj.ObjConstI[2] of
          1 : p := OVBuffer[VidBuf].Param[2] or  OVBuffer[VidBuf].Param[3];
          2 : p := OVBuffer[VidBuf].Param[4] or  OVBuffer[VidBuf].Param[5];
          3 : p := OVBuffer[VidBuf].Param[6] or  OVBuffer[VidBuf].Param[7];
          4 : p := OVBuffer[VidBuf].Param[8] or  OVBuffer[VidBuf].Param[9];
          5 : p := OVBuffer[VidBuf].Param[10] or OVBuffer[VidBuf].Param[11];
          6 : p := OVBuffer[VidBuf].Param[12] or OVBuffer[VidBuf].Param[13];
          7 : p := OVBuffer[VidBuf].Param[14] or OVBuffer[VidBuf].Param[15];
          8 : p := OVBuffer[VidBuf].Param[17] or OVBuffer[VidBuf].Param[18];
          else x1 := 0;
        end;
      end;
    end;
  end;

  form.Brush.Style := bsSolid;
  form.Pen.Width := 1;
  form.Pen.Style := psSolid;

  if x1 = 0 then
  begin //----------------------------------------------------------------- погасить точку
    form.Pen.Color := armcolor15;
    form.Font.Color := armcolor15;
    form.Brush.Color := armcolor15;
  end else
  if x1 = 1 then
  begin
    if p then
    begin //----------------------------------------------------------------- занять точку
      form.Pen.Color := armcolor8;
      form.Font.Color := 0;
      form.Brush.Color := armcolor1;
    end else
    begin //------------------------------------------------------------- освободить точку
      form.Pen.Color := armcolor8;
      form.Font.Color := 0;
      form.Brush.Color := armcolor9;
    end;
  end;

  form.Polygon([ptr[1], ptr[2], ptr[3], ptr[4], ptr[5], ptr[6]]);
  form.Brush.Style := bsClear;
  form.Font.Style := []; form.Font.Size := 8;
  x1 := form.TextWidth(Obj.Title) div 2; y1 := form.TextHeight(Obj.Title) div 2;
  form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
end;

//========================================================================================
//------------------------------------- нарисовать кнопку 8-ми цветную для 3-х датчиков 43
procedure DisplayKnopColor8(Obj: POVStruct;form: TCanvas);
var
  deltaX,x1,y1,Cod : integer;
begin
  form.Font.Style := [];   form.Font.Size := 8;
  deltaX := TabloMain.Canvas.TextWidth(Obj.Title) div 2;
  Cod := 0;
  if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then Cod := Cod + 4;
  if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then Cod := Cod + 2;
  if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[4]] then Cod := Cod + 1;

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //---------------------------------------------------------- отсутствие информации
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end
  else
  if OVBuffer[Obj.ObjConstI[1]].NParam[1] or OVBuffer[Obj.ObjConstI[1]].NParam[2] or
  OVBuffer[Obj.ObjConstI[1]].NParam[3] then
  begin //-------------------------------------------------- непарафазность любого датчика
    form.Brush.Color := armcolor14;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end else
  begin
    form.Brush.Color := GetColor1(obj.ObjConstI[Cod + 5]);
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end;

  if OVBuffer[Obj.ObjConstI[1]].ParamInt[1] <> Cod then
  OVBuffer[Obj.ObjConstI[1]].ParamInt[1] := Cod;

  case Obj.ObjConstI[13] of
    //стрелка вправо
    1:
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
    end;

    //стрелка влево
    2:
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
    end;
    //простая кнопка
    3:
    begin
      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      form.Pen.Color := form.Brush.Color;
      form.Rectangle(obj.Points[1].X-deltaX+1,obj.Points[1].Y-5,
      obj.Points[1].X+deltaX-1,obj.Points[1].Y+6);

      form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX-1,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y+6);

      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX+1,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y-6);
    end;

    4:
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y+6);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+7,obj.Points[1].Y);
    end;

    5:
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX, obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-7,obj.Points[1].Y);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y-6);
    end;
    else form.RoundRect(obj.Points[1].X-deltaX-4,obj.Points[1].Y-6,
    obj.Points[1].X+deltaX+4,obj.Points[1].Y+7, 4,30);
  end;
  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  x1 := form.TextWidth(Obj.Title) div 2;
  y1 := form.TextHeight(Obj.Title) div 2;
  form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
end;


//========================================================================================
//--------------------------------------------------------------------- ограждение пути 50
procedure DisplayOgradPuti(Obj: POVStruct;form: TCanvas);
begin
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
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
  begin //----------------------------------------------------------------- непарафазность
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

  //------------------------------------------------------------------------ Нарисовать ОГ
  if Obj.ObjConstI[6] = 0 then  //------------------- если датчик ограждения пути исправен
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[8] then //------- если есть согласие на ограждение
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[7] then //----------- если  запрос на ограждение
      begin
        form.Pen.Color := armcolor1;form.Pen.Width := 2;//установлено ограждение (красный)
      end else
      begin //--------------------------------------------------------- если только запрос
        form.Pen.Color := armcolor7; form.Pen.Width := 2; //----------------------- желтый
      end;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then //----- установлено ограждение без запроса
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[6] or //--------- если ограждение неисправно или
      not WorkMode.Upravlenie then //---------------------- нет управления станцией с АРМа
      begin
        form.Pen.Color := armcolor11; form.Pen.Width := 2; //------------- цвет фиолетовый
      end else
      if tab_page then exit //----------------------- если в мигании первая фаза, то выйти
      else
      begin
        form.Pen.Color := armcolor11;
        form.Pen.Width := 2;
      end;
    end
    else exit;
  end else
  begin //-------------------------------------------------------------------------- чужой
    if OVBuffer[Obj.ObjConstI[1]].Param[7] then //----------------- установлено ограждение
    begin
      form.Pen.Color := armcolor1;
      form.Pen.Width := 2;
    end
    else exit;
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

//========================================================================================
//---------------------------------------------------------------------- нарисовать UTS 51
procedure DisplayUTS(Obj: POVStruct; form: TCanvas);
begin
  if not OVBuffer[obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
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
    //--------------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 1;
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

  //----------------------------------------------------------------------- Нарисовать УТС
  if OVBuffer[Obj.ObjConstI[1]].Param[4] then
  begin //---------------------------------------------------------- есть блокировка упора
    TabloMain.ImageList.Draw(form,obj.Points[1].X-6,obj.Points[1].Y-20,1,true);
  end;

  form.Pen.Color := 0; form.Pen.Style := psSolid; form.Pen.Width := 1;
  if OVBuffer[Obj.ObjConstI[1]].Param[2] and not OVBuffer[Obj.ObjConstI[1]].Param[3] then
  begin //------------------------------------------------------------- Упор не установлен
    form.Brush.Color := armcolor8;
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
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[3] and not OVBuffer[Obj.ObjConstI[1]].Param[2] then
  begin //---------------------------------------------------------------- Упор установлен
    form.Brush.Color := armcolor7;
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
  end else
  begin //---------------------------------------------------- Упор без контроля положения
    form.Brush.Color := armcolor1;
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
  end;
end;

//========================================================================================
//-------------------------------------------------------------------- нарисовать UKSPS 52
procedure DisplayUKSPS(Obj: POVStruct;form: TCanvas);
begin
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12; form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12; form.Pen.Width := 1;
    form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
    form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
    exit;
  end;
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14; form.Pen.Style := GetPenStyle(0);
    form.Brush.Color := armcolor14; form.Pen.Width := 3;
    form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
    form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
    exit;
  end;

  if OVBuffer[Obj.ObjConstI[1]].Param[6] then
  begin //---------------------- Выдана предварительная команда выключения из зависимостей
    form.Pen.Color := armcolor9; form.Pen.Width := 1; form.Brush.Color := armcolor9;
    form.Rectangle(obj.Points[1].X-7,obj.Points[1].Y-11,obj.Points[1].X+7,obj.Points[1].Y-1);
  end;

  if obj.ObjConstI[2] = 1 then //------------------------------------------- первый датчик
  begin
    //-------- если датчики независимы или второй исправен
    if (Obj.ObjConstI[3] = 0) or
    not (OVBuffer[Obj.ObjConstI[1]].Param[3])  then
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then //------------- выключен из зависимостей
      begin
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then //-------------- неисправность датчика
        begin
          form.Pen.Width := 2; form.Pen.Color := armcolor1; form.Brush.Color := armcolor7;
        end else
        begin //---------------------------------------------------------- датчик исправен
          form.Pen.Width := 1; form.Pen.Color := 0; form.Brush.Color := armcolor7;
        end;
      end else //--------------------------------------------------- включен в зависимости
      begin
        form.Pen.Width := 1; form.Pen.Color := 0;
        if OVBuffer[Obj.ObjConstI[1]].Param[2] then //-------------- неисправность датчика
        form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor2; //---------------------------- датчик исправен
      end;
      form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
    end else//------------------------------------------------------ если датчики зависимы
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then //---------- если неисправен второй датчик
    begin
      form.Brush.Color := armcolor12; //------------------------------- недоступный датчик
      form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
    end;
  end
  else
  begin //------------------------------------------------------------------ второй датчик
    if OVBuffer[Obj.ObjConstI[1]].Param[5] then //--------------- выключен из зависимостей
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then //---------------------------------- 2КС
      begin //------------------------------------------------------ неисправность датчика
        form.Pen.Width := 2; form.Pen.Color := armcolor1; form.Brush.Color := armcolor7;
      end else
      begin //------------------------------------------------------------ датчик исправен
        form.Pen.Width := 1;  form.Pen.Color := 0;  form.Brush.Color := armcolor7;
      end;
    end else
    begin //-------------------------------------------------------- включен в зависимости
      form.Pen.Width := 1; form.Pen.Color := 0;
      if OVBuffer[Obj.ObjConstI[1]].Param[3] then
      form.Brush.Color := armcolor1  //----------------------------- неисправность датчика
      else form.Brush.Color := armcolor2; //------------------------------ датчик исправен
    end;
    form.Ellipse(obj.Points[1].X-4,obj.Points[1].Y-9,obj.Points[1].X+4,obj.Points[1].Y-1);
  end;

  if OVBuffer[Obj.ObjConstI[1]].Param[4] then
  begin //========================================================== Неисправность линии 1
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Brush.Color := armcolor1;
    form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[8] then
  begin //========================================================== Неисправность линии 2
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Brush.Color := armcolor1;
    form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
  end else
  begin //---------------------------------------------------------------- Линия2 исправна
    form.Pen.Color := 0; form.Pen.Width := 1; form.Brush.Color := armcolor8;
    form.Rectangle(obj.Points[1].X-6,obj.Points[1].Y-5,obj.Points[1].X+6,obj.Points[1].Y-1);
  end;
end;

//========================================================================================
//------------------------------------------------------- нарисовать охранность стрелки 53
procedure DisplayOhrStr(Obj: POVStruct;form: TCanvas);
var
  zapomni : TFont;
begin
  zapomni := form.Font;
  if OVBuffer[Obj.ObjConstI[1]].Param[8] then
  begin //---------------------------------------- Охранное положение сбрасывающей стрелки
      form.Pen.Width := 1;
      form.Pen.Color := armcolor1;
      form.Brush.Color := armcolor1;
      form.Polygon([obj.Points[1],obj.Points[2],obj.Points[3],obj.Points[4]]);
      form.Brush.Color := armcolor15;
      form.Font.Color := clWindow;
      form.Font.Style := [];
      form.Font.Size := 8;
  end
  else //---------------------------------------------------- если нет охранного положения
  if OVBuffer[Obj.ObjConstI[1]].Param[9] then //------------------- не замкнута в маршруте
  begin
    form.Pen.Color := armcolor15;
    form.Brush.Color := armcolor15;
    form.Pen.Width := 1;
    form.Polygon([obj.Points[1],obj.Points[2],obj.Points[3],obj.Points[4]]);
    form.Font.Color := armcolor1;
    form.Font.Style := [fsBold];
    form.Font.Size := 10;
    form.Pen.Color := 4;
  end
  else //----------------------------------------------- замкнута в маршруте не в охранном
  begin
    form.Pen.Color := armcolor15;
    form.Brush.Color := armcolor15;
    form.Pen.Width := 1;
    form.Polygon([obj.Points[1],obj.Points[2],obj.Points[3],obj.Points[4]]);
    form.Font.Color := armcolor7;
    form.Font.Style := [fsBold];
    form.Font.Size := 10;
    form.Pen.Color := 4;
  end;
  if obj.Points[5].X <> 0 then form.TextOut(obj.Points[5].X,obj.Points[5].Y,obj.Name);
  form.Font := zapomni;
end;
//========================================================================================
//------------------------------------------------------- нарисовать кнопку 2-х цветную 54
procedure DisplayKnopColor2(Obj: POVStruct;form: TCanvas);
var
  deltaX,x1,y1 : integer;
  Text : string;
begin
  form.Font.Style := [];
  form.Font.Size := 8;
  form.Pen.Style := psSolid;
  deltaX := form.TextWidth(Obj.Title) div 2;
  Text := '';
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //---------------------------------------------------------- отсутствие информации
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end
  else
  if OVBuffer[Obj.ObjConstI[1]].NParam[Obj.ObjConstI[2]] then
  begin //-------------------------------------------------------- непарафазность датчиков
    form.Brush.Color := armcolor14;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then
  begin //----------------------------------------------------------------- Лампа включена
    form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
    form.Pen.Color := GetColor1(Obj.ObjConstI[6]);
    form.Pen.Width := 1;
    form.Font.Color := GetColor1(Obj.ObjConstI[6]);
    if ObjZav[Obj.ObjConstI[16]].ObjConstI[8] > 0 then
    Text := MsgList[ObjZav[Obj.ObjConstI[16]].ObjConstI[8]];
  end
  else
  begin //---------------------------------------------------------------- Лампа выключена
    form.Brush.Color := GetColor1(Obj.ObjConstI[3]);
    form.Pen.Color := GetColor1(Obj.ObjConstI[4]);
    form.Pen.Width := 1;
    form.Font.Color := GetColor1(Obj.ObjConstI[4]);
    if ObjZav[Obj.ObjConstI[16]].ObjConstI[9] > 0 then
    Text := MsgList[ObjZav[Obj.ObjConstI[16]].ObjConstI[9]];
  end;

  case Obj.ObjConstI[7] of
    //--------------------------------------------------------------------- стрелка вправо
    1:
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
    end;

    //---------------------------------------------------------------------- стрелка влево
    2:
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
    end;
    //--------------------------------------------------------------------- простая кнопка
    3:
    begin
      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      form.Pen.Color := form.Brush.Color;
      form.Rectangle(obj.Points[1].X-deltaX+1,obj.Points[1].Y-5,
      obj.Points[1].X+deltaX-1,obj.Points[1].Y+6);

      form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX-1,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y+6);

      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX+1,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y-6);
    end;

    4:
    begin
      form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y+6);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+7,obj.Points[1].Y);
    end;

    5:
    begin
      form.Polygon([Point(obj.Points[1].X+deltaX, obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
      Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);
      form.Rectangle(obj.Points[1].X-deltaX,obj.Points[1].Y-6,
      obj.Points[1].X+deltaX,obj.Points[1].Y+7);
      form.Pen.Width := 1; form.Pen.Style := psSolid; form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X+deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X-deltaX-7,obj.Points[1].Y);
      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X-deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X+deltaX+1,obj.Points[1].Y-6);
    end;
    else form.RoundRect(obj.Points[1].X-deltaX-4,obj.Points[1].Y-6,
    obj.Points[1].X+deltaX+4,obj.Points[1].Y+7, 4,30);
  end;

  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  if Text = '' then
  begin
    x1 := form.TextWidth(Obj.Title) div 2;
    y1 := form.TextHeight(Obj.Title) div 2;
    form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
  end  else
  begin
    x1 := form.TextWidth(Text) div 2;
    y1 := form.TextHeight(Text) div 2;
    form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Text);
  end
end;

//========================================================================================
//------------------------------------------------------- нарисовать кнопку 3-х цветную 55
procedure DisplayKnopColor3(Obj: POVStruct;form: TCanvas);
var
  deltaX,x1,y1,Mig : integer;
  Text : string;
begin
  Mig := 0;
  form.Font.Style := [];
  form.Font.Size := 8;
  form.Pen.Style := psSolid;
  Text := Obj.Title;
  if Text <> '' then deltaX := form.TextWidth(Text) div 2
  else deltaX := 20;

  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //--------------- отсутствие информации
  begin
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].NParam[Obj.ObjConstI[2]] or //---- непарафазность датчиков
  OVBuffer[Obj.ObjConstI[1]].NParam[Obj.ObjConstI[3]] then
  begin
    form.Brush.Color := armcolor14;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end else
  begin
    x1 := 0;
    if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1;
    form.Pen.Width := 1;
    if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
    case x1 of
      1 :
      begin
        form.Brush.Color := GetColor1(Obj.ObjConstI[7]); //------------------------ код 01
        form.Font.Color :=  GetColor1(Obj.ObjConstI[6]);
      end;

      2 :
      begin
        form.Brush.Color := GetColor1(Obj.ObjConstI[8]); //------------------------ код 10
        form.Font.Color :=  GetColor1(Obj.ObjConstI[12]);
      end;

      3 :
      begin
        form.Brush.Color := GetColor1(Obj.ObjConstI[9]); //------------------------ код 11
        form.Font.Color :=  GetColor1(Obj.ObjConstI[13]);
      end;
      else
        form.Brush.Color := GetColor1(Obj.ObjConstI[5]);//--------  Лампа выключена код 00
        form.Font.Color :=  GetColor1(Obj.ObjConstI[4]);        
    end;

    if x1 > 0 then
    begin
      form.Pen.Color := form.Font.Color;
      form.Pen.Width := 1;
    end else
    begin
      form.Pen.Color := form.Font.Color;
      form.Pen.Width := 1;
    end;
  end;
  Mig := form.Brush.Color;

  if Mig = armcolor25 then
  begin                   //------------------------------------------------ синее мигание
    if tab_page then  form.Brush.Color := GetColor1(3)
    else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
  end;

  if Mig = armcolor26 then
  begin                   //------------------------------------------------ белое мигание
    if tab_page then  form.Brush.Color := GetColor1(9)
    else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
  end;

  if Mig = armcolor27 then
  begin                   //----------------------------------------------- желтое мигание
    if tab_page then  form.Brush.Color := GetColor1(7)
    else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
  end;

  if Mig = armcolor28 then
  begin                   //---------------------------------------------- красное мигание
    if tab_page then  form.Brush.Color := GetColor1(1)
    else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
  end;

  if Mig = armcolor29 then
  begin                   //---------------------------------------------- зеленое мигание
    if tab_page then  form.Brush.Color := GetColor1(2)
    else form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
  end;

  if Mig = armcolor30 then form.Brush.Color := GetColor1(Obj.ObjConstI[5]);

  case  Obj.ObjConstI[10] of
    1:  //----------------------------------------------------------- лампа-стрелка вправо
    form.Polygon([Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
    Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
    Point(obj.Points[1].X+deltaX+6,obj.Points[1].Y),
    Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6),
    Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6)]);

    2:  //------------------------------------------------------------ лампа-стрелка влево
    form.Polygon([Point(obj.Points[1].X+deltaX,obj.Points[1].Y-6),
    Point(obj.Points[1].X-deltaX,obj.Points[1].Y-6),
    Point(obj.Points[1].X-deltaX-6,obj.Points[1].Y),
    Point(obj.Points[1].X-deltaX,obj.Points[1].Y+6),
    Point(obj.Points[1].X+deltaX,obj.Points[1].Y+6)]);

    3:
    begin //----------------------------------------------------------------------- Кнопка
      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      form.Pen.Color := form.Brush.Color;

      form.Rectangle(obj.Points[1].X - deltaX - 4,obj.Points[1].Y-5,
      obj.Points[1].X + deltaX + 4,obj.Points[1].Y+6);

      form.Pen.Color := armcolor16; //------------------- светлая окантовка = слева-вверху
      form.MoveTo(obj.Points[1].X + deltaX + 4, obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X - deltaX - 5, obj.Points[1].Y-6);
      form.LineTo(obj.Points[1].X - deltaX - 5,obj.Points[1].Y+6);

      form.Pen.Color := armcolor17; //------------------ темная окантовка = снизу - справа
      form.MoveTo(obj.Points[1].X - deltaX - 4, obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X + deltaX + 4, obj.Points[1].Y+6);
      form.LineTo(obj.Points[1].X + deltaX + 4, obj.Points[1].Y-6);
    end;

    4:
    begin //---------------------------------------------------------------- стрелка влево
      form.Polygon([Point(obj.Points[1].X - deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X + deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X + deltaX+6,obj.Points[1].Y),
      Point(obj.Points[1].X + deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X - deltaX,obj.Points[1].Y+6)]);

      form.Rectangle(obj.Points[1].X - deltaX,obj.Points[1].Y-6,
      obj.Points[1].X + deltaX,obj.Points[1].Y+7);

      form.Pen.Width := 1;
      form.Pen.Style := psSolid;
      form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X + deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X - deltaX - 1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X- deltaX - 1,obj.Points[1].Y+6);

      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X - deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X + deltaX + 1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X + deltaX + 7,obj.Points[1].Y);
    end;

    5:
    begin //--------------------------------------------------------------- стрелка вправо
      form.Polygon([Point(obj.Points[1].X + deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X - deltaX,obj.Points[1].Y-6),
      Point(obj.Points[1].X - deltaX - 6,obj.Points[1].Y),
      Point(obj.Points[1].X - deltaX,obj.Points[1].Y+6),
      Point(obj.Points[1].X + deltaX,obj.Points[1].Y+6)]);

      form.Rectangle(obj.Points[1].X - deltaX,obj.Points[1].Y-6,
      obj.Points[1].X + deltaX,obj.Points[1].Y+7);

      form.Pen.Width := 1; form.Pen.Style := psSolid;

      form.Pen.Color := armcolor16;
      form.MoveTo(obj.Points[1].X + deltaX,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X - deltaX - 1,obj.Points[1].Y-7);
      form.LineTo(obj.Points[1].X - deltaX - 7,obj.Points[1].Y);

      form.Pen.Color := armcolor17;
      form.MoveTo(obj.Points[1].X - deltaX,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X + deltaX + 1,obj.Points[1].Y+7);
      form.LineTo(obj.Points[1].X + deltaX + 1,obj.Points[1].Y-6);
    end;

    6:
    begin //------------------------------------------------------------------------ Рупор
      form.Polygon([Point(obj.Points[1].X+8,obj.Points[1].Y-7),
      Point(obj.Points[1].X+7,obj.Points[1].Y),
      Point(obj.Points[1].X+8,obj.Points[1].Y+7),
      Point(obj.Points[1].X,obj.Points[1].Y+5),
      Point(obj.Points[1].X-8,obj.Points[1].Y+7),
      Point(obj.Points[1].X-7,obj.Points[1].Y),
      Point(obj.Points[1].X-8,obj.Points[1].Y-7),
      Point(obj.Points[1].X,obj.Points[1].Y-5)]);
    end;

    else
      form.RoundRect(obj.Points[1].X - deltaX - 4,obj.Points[1].Y-6,
      obj.Points[1].X + deltaX + 4,obj.Points[1].Y+7, 4,30);
  end;

  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  x1 := form.TextWidth(Text) div 2;
  y1 := form.TextHeight(Text) div 2;
  form.TextOut(obj.Points[1].X-deltaX,obj.Points[1].Y-y1,Text);

  if Mig = armcolor30 then
  begin
    Mig := form.Font.Color;
    if tab_page then form.Font.Color := armcolor7
    else form.Font.Color := armcolor15;
    form.Font.Size := 12;
    form.Font.Style :=  [fsBold];
    form.TextOut(obj.Points[1].X-deltaX-10,obj.Points[1].Y-y1,'!');
    form.Font.Color := Mig;
    form.Font.Style := [];
  end;
end;

//========================================================================================
//------------------------------------------------------ нарисовать 3-х цветную надпись 56
procedure Display3Nadpis(Obj: POVStruct;form: TCanvas);
var
  x1,y1 : integer;
begin
  if not OVBuffer[Obj.ObjConstI[1]].Param[16]
  then form.Font.Color := armcolor8 //--------------------------------------- нет датчиков
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[1]
  then form.Font.Color := armcolor14 //--------------------------- непарафазность датчиков
  else
  begin
    x1 := 0;
    if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then x1 := 1;
    if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[3]] then x1 := x1 + 2;
    case x1 of
      1 : form.Font.Color := GetColor1(Obj.ObjConstI[5]);
      2 : form.Font.Color := GetColor1(Obj.ObjConstI[6]);
      3 : form.Font.Color := GetColor1(Obj.ObjConstI[7]);
      else form.Font.Color := GetColor1(Obj.ObjConstI[4]); //------------ Надпись выключена
    end;
  end;
  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  x1 := form.TextWidth(Obj.Title) div 2;
  y1 := form.TextHeight(Obj.Title) div 2;
  form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
end;

//========================================================================================
//---------------------------- нарисовать дополнительный (3) известитель автоблокировки 57
procedure DisplayIzvestAB(Obj: POVStruct;form: TCanvas);
begin
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin //------------------------------------------------------------- нецентрализованный
    form.Pen.Color := armcolor12;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor12;
    form.Pen.Width := 3;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[1] then
  begin //----------------------------------------------------------------- непарафазность
    form.Pen.Color := armcolor14;
    form.Pen.Style := psSolid;
    form.Brush.Color := armcolor14;
    form.Pen.Width := 3;
  end else
  if Obj.ObjConstI[2] = 0 then
  begin //--------------------------------------------------- индикация включена постоянно
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then
    begin //------------------------------------------------- участок приближения свободен
      form.Pen.Width := 3;
      form.Pen.Color := armcolor7;
    end else
    begin //---------------------------------------------------- участок приближения занят
      form.Pen.Width := 3;
      form.Pen.Color := armcolor1;
    end;
  end else
  begin //--------------------------------------- индикация подключается выбором комплекта
    if not OVBuffer[Obj.ObjConstI[1]].Param[10] then
    begin //------------------------------------------------------------- участок отключен
      form.Pen.Width := 1;
      form.Pen.Color := 0;
    end else
    if not OVBuffer[Obj.ObjConstI[1]].Param[7] then //участок подключается при отправлении
    begin //------------------------------------------------------------- участок отключен
      form.Pen.Width := 1;
      form.Pen.Color := 0;
    end else
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then
    begin //------------------------------------------------- участок приближения свободен
      form.Pen.Width := 3;
      form.Pen.Color := armcolor7;
    end else
    begin //---------------------------------------------------- участок приближения занят
      form.Pen.Width := 3;
      form.Pen.Color := armcolor1;
    end;
  end;
  form.MoveTo(obj.Points[1].X,obj.Points[1].Y);
  form.LineTo(obj.Points[1].X+22,obj.Points[1].Y);
end;

//========================================================================================
//---------------------------------------------------------- нарисовать зону оповещения 58
procedure DisplayZonaOpov(Obj: POVStruct;form: TCanvas);
var
  x1 : integer;
begin
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] //-------------------- отсутствие информации
  then form.Pen.Color := armcolor12
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[1]  //---------------------- непарафазность датчиков
  then form.Pen.Color := armcolor14
  else
  begin
    x1 := 0;
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then x1 := 1; //-------------------- кнм (хРРМ)
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then x1 := x1 + 2;//----------------- зМ (хОМП)
    case x1 of
      0 : form.Pen.Color := GetColor1(Obj.ObjConstI[2]); //--------------- Лампа выключена
      1 : form.Pen.Color := GetColor1(Obj.ObjConstI[5]);//-------------- цвет зоны для КНМ
      3 : form.Pen.Color := GetColor1(Obj.ObjConstI[3]);//--------- цвет зоне для КНМ + зМ
      else form.Pen.Color := GetColor1(Obj.ObjConstI[4]);//-------------- цвет зоны для ЗМ
    end;
  end;
  form.Pen.Style := psDashDotDot;
  form.Pen.Width := 1;
  form.Brush.Style := bsClear;
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

//========================================================================================
//---------------------------------------------------------- нарисовать счетчик времени 59
procedure CounterTimer(Obj: POVStruct;form: TCanvas);
var
  x1,y1 : integer;
{$IFNDEF RMARC}
{$IFNDEF RMSHN}
  x2 : integer;
{$ENDIF}
{$ENDIF}
begin
  if Obj.ObjConstI[1] > 0 then //-------------------------------- если есть индекс таймера
  begin
    case Obj.ObjConstI[2] of //----------------- переключатель по виду отображения таймера
      1 :
      begin //---------------------------------------- графический образ обратного отсчета
{$IFNDEF RMARC}
{$IFNDEF RMSHN}
        x1 := Timer[Obj.ObjConstI[1]] - 1;
        if x1 > -1 then
        begin
          x2 := 0;
          if Obj.ObjConstI[3] > 0
          then x2 := (Obj.ObjConstI[3] - x1) * 24 div Obj.ObjConstI[3];
          if x2 <= 0 then x2 := 0;
          TabloMain.ilClock.Draw(form,obj.Points[1].X,obj.Points[1].Y,x2);
        end;
{$ENDIF}
{$ENDIF}
      end;
      else  //--------------------------------------------- числовое отображение интервала
      if Timer[Obj.ObjConstI[1]] > 0 then
      begin
        sLbl := IntToStr(Timer[Obj.ObjConstI[1]]);
        form.Brush.Style := bsClear;
        form.Font.Style := [];
        form.Font.Size := 8;
        form.Font.Color := clBlack;
        x1 := form.TextWidth(sLbl) div 2;
        y1 := form.TextHeight(sLbl) div 2;
        form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,sLbl);
      end;
    end;
  end;
end;

//========================================================================================
//---------------------------------- Двухцветная лампа контроля дополнительных датчиков 60
procedure Display2CvetLamp(Obj: POVStruct; form: TCanvas);
var
  x1,y1 : integer;
begin
  if not OVBuffer[Obj.ObjConstI[1]].ParamA[Obj.ObjConstI[2]] then
  begin //---------------------------------------------------------- отсутствие информации
    form.Brush.Color := armcolor8;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].NParam[Obj.ObjConstI[2]] then
  begin //-------------------------------------------------------- непарафазность датчиков
    form.Brush.Color := armcolor14;
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
  end else
  if OVBuffer[Obj.ObjConstI[1]].Param[Obj.ObjConstI[2]] then
  begin //----------------------------------------------------------------- Лампа включена
    form.Brush.Color := GetColor1(Obj.ObjConstI[5]);
    form.Pen.Color := GetColor1(Obj.ObjConstI[6]);
    form.Pen.Width := 1;
    form.Font.Color := GetColor1(Obj.ObjConstI[6]);
  end else
  begin //---------------------------------------------------------------- Лампа выключена
    form.Brush.Color := GetColor1(Obj.ObjConstI[3]);
    form.Pen.Color := GetColor1(Obj.ObjConstI[4]);
    form.Pen.Width := 1;
    form.Font.Color := GetColor1(Obj.ObjConstI[4]);
  end;
  form.RoundRect(obj.Points[1].X-20,obj.Points[1].Y-6,obj.Points[1].X+20,obj.Points[1].Y+7, 4,30);
  form.Brush.Style := bsClear;
  form.Font.Style := [];
  form.Font.Size := 8;
  x1 := form.TextWidth(Obj.Title) div 2;
  y1 := form.TextHeight(Obj.Title) div 2;
  form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,Obj.Title);
end;


//========================================================================================
//------------------------------------------------------------------ Питающая установка 70
procedure DisplayPitUst(Obj: POVStruct; form: TCanvas);
begin
  if Obj.ObjConstI[2] = 1 then
  begin //-------------------------------------------------------- для малой станции - 1кф
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
    form.Brush.Style := bsSolid;

    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //-------------- активизация датчиков
    form.Brush.Color := armcolor8
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then //------------ Питание ЭЦ от 1-го фидера
      form.Brush.Color := armcolor2
      else form.Brush.Color := armcolor7; //--------------- Есть напряжение на 1-ом фидере
    end
    else form.Brush.Color := armcolor1; //------------------ Нет напряжения на 1-ом фидере

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+40,obj.Points[1].Y+13,4,30);
    form.Brush.Style := bsClear; form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y,'К1Ф');

    form.Brush.Style := bsSolid;

    if not OVBuffer[Obj.ObjConstI[1]].Param[16] //------------------- активизация датчиков
    then form.Brush.Color := armcolor8
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[5] then //-------- Питание ЭЦ от 2-го фидера
      form.Brush.Color := armcolor2
      else form.Brush.Color := armcolor7; //--------------- Есть напряжение на 2-ом фидере
    end
    else form.Brush.Color := armcolor1; //------------------ Нет напряжения на 2-ом фидере

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y+20,obj.Points[1].X+40,obj.Points[1].Y+33, 4,30);
    form.Brush.Style := bsClear; form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+20,'К2Ф');

    form.Brush.Style := bsSolid;
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //-------------- активизация датчиков
    form.Brush.Color := armcolor8
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then //---------------------------- ДГА включен
    form.Brush.Color := armcolor2
    else
    begin //----------------------------------------------------------------- ДГА выключен
      form.Brush.Color := armcolor15;
      form.Pen.Color := armcolor8;
      form.Font.Color := armcolor8;
    end;

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y+40,obj.Points[1].X+40,obj.Points[1].Y+53, 4,30);
    form.Brush.Style := bsClear; form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+40,'ДГА');
  end else
  begin //------------------------------------------------------ для крупной станции - 2кф
    form.Pen.Color := 0;
    form.Pen.Width := 1;
    form.Font.Color := clBlack;
    form.Brush.Style := bsSolid;
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
    form.Brush.Color := armcolor8  //-------------------------------- активизация датчиков
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[2] then
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[5] then //------------ Питание ЭЦ от 1-го фидера
      form.Brush.Color := armcolor2
      else form.Brush.Color := armcolor7; //--------------- Есть напряжение на 1-ом фидере
    end
    else form.Brush.Color := armcolor1; //------------------ Нет напряжения на 1-ом фидере

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+40,obj.Points[1].Y+13, 4,30);
    form.Brush.Style := bsClear; form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y,'К1Ф');

    form.Brush.Style := bsSolid;
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then //-------------- активизация датчиков
    form.Brush.Color := armcolor8
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[3] then
    begin
      if OVBuffer[Obj.ObjConstI[1]].Param[6] then //------------ Питание ЭЦ от 2-го фидера
      form.Brush.Color := armcolor2
      else form.Brush.Color := armcolor7; //--------------- Есть напряжение на 2-ом фидере
    end
    else form.Brush.Color := armcolor1; //------------------ Нет напряжения на 2-ом фидере

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y+20,obj.Points[1].X+40,obj.Points[1].Y+33, 4,30);
    form.Brush.Style := bsClear; form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+20,'К2Ф');

    form.Brush.Style := bsSolid;
    if not OVBuffer[Obj.ObjConstI[1]].Param[16] then  //------------- активизация датчиков
    form.Brush.Color := armcolor8
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //---------------- непарафазность датчиков
    form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then  //--------------------------- ДГА включен
    form.Brush.Color := armcolor2
    else
    begin //----------------------------------------------------------------- ДГА выключен
      form.Brush.Color := armcolor15;
      form.Pen.Color := armcolor8;
      form.Font.Color := armcolor8;
    end;

    form.RoundRect(obj.Points[1].X,obj.Points[1].Y+40,obj.Points[1].X+40,obj.Points[1].Y+53, 4,30);
    form.Brush.Style := bsClear;
    form.Font.Style := [];
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+40,'ДГА');
  end;
end;

//========================================================================================
//------------------------------ нарисовать кнопки управления для объекта "День/Ночь" (92)
procedure DisplayDenNoch(Obj: POVStruct;form: TCanvas);
var deltaX,x1,y1,ColorDay,ColorNight,ColorAUK : integer;
begin
  ColorDay := 0;
  ColorNight := 0;
  ColorAUK := 0;
  case OVBuffer[Obj.ObjConstI[1]].DZ3 of
    0,1:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[6]);
      ColorDay:=GetColor1(Obj.ObjConstI[2]);
      ColorNight:=GetColor1(Obj.ObjConstI[4]);
    end;
    2:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[3]);
      ColorDay:=GetColor1(Obj.ObjConstI[3]);
      ColorNight:=GetColor1(Obj.ObjConstI[4]);
    end;
    3:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[5]);
      ColorDay:=GetColor1(Obj.ObjConstI[2]);
      ColorNight:=GetColor1(Obj.ObjConstI[5]);
    end;
    4:
    begin
     ColorAUK:=GetColor1(Obj.ObjConstI[6]);
     ColorDay:=GetColor1(Obj.ObjConstI[2]);
     ColorNight:= armcolor11;
    end;
    5:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[6]);
      ColorDay:=GetColor1(Obj.ObjConstI[2]);
      ColorNight:=GetColor1(Obj.ObjConstI[5]);
    end;
    6,7:
    begin
      ColorAUK:=armcolor11;
      ColorDay:=GetColor1(Obj.ObjConstI[2]);
      ColorNight:=armcolor11;
    end;
    8:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[6]);
      ColorDay:=GetColor1(Obj.ObjConstI[3]);
      ColorNight:=GetColor1(Obj.ObjConstI[4]);
    end;
    9:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[6]);
      ColorDay:=armcolor11;
      ColorNight:=GetColor1(Obj.ObjConstI[4]);
    end;
    10:
    begin
      ColorAUK:=armcolor11;
      ColorDay:=armcolor11;
      ColorNight:=GetColor1(Obj.ObjConstI[4]);
    end;
    11,14,15:
    begin
      ColorAUK:=armcolor11;
      ColorDay:=armcolor11;
      ColorNight:=armcolor11;
    end;
    12,13:
    begin
      ColorAUK:=GetColor1(Obj.ObjConstI[6]);
      ColorDay:=armcolor11;
      ColorNight:=armcolor11;
    end;
  end;

  form.Font.Style := []; form.Font.Size := 10;
  form.Pen.Color := 0; form.Pen.Width := 1; form.Font.Color := clBlack;

  //-------------------------------------------------------------- работа с кнопкой "День"
  deltaX := form.TextWidth(' День ') div 2;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then form.Brush.Color := armcolor8
  else
  //------------------------------------------------------- если непарафазна кнопка "День"
  if OVBuffer[Obj.ObjConstI[1]].NParam[1] then form.Brush.Color := armcolor14
  else //---------------------------------------------------- если непарафазен датчик "ДН"
  if OVBuffer[Obj.ObjConstI[1]].NParam[4] then form.Brush.Color := armcolor14
  else form.Brush.Color := ColorDay; //-------------------------- кнопка "День"

  form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
  form.Rectangle(obj.Points[1].X-deltaX+1,obj.Points[1].Y-5,
  obj.Points[1].X+deltaX-1,obj.Points[1].Y+6);
  form.Pen.Color := armcolor16;
  form.MoveTo(obj.Points[1].X+deltaX-1,obj.Points[1].Y-6);
  form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y-6);
  form.LineTo(obj.Points[1].X-deltaX,obj.Points[1].Y+6);
   form.Pen.Color := armcolor17;
  form.MoveTo(obj.Points[1].X-deltaX+1,obj.Points[1].Y+6);
  form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y+6);
  form.LineTo(obj.Points[1].X+deltaX,obj.Points[1].Y-6);
  form.Brush.Style := bsClear;  form.Font.Style := [];  form.Font.Size := 10;
  x1 := form.TextWidth(' День ') div 2;
  y1 := form.TextHeight(' День ') div 2;
  form.TextOut(obj.Points[1].X-x1,obj.Points[1].Y-y1,' День ');

  //-------------------------------------------------------------- работа с кнопкой "Ночь"
  deltaX := form.TextWidth(' Ночь ') div 2;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then form.Brush.Color := armcolor8
  else
  //---------------------------------------------------------------- если непарафазна Ночь
  if OVBuffer[Obj.ObjConstI[1]].NParam[2] then form.Brush.Color := armcolor14
  else //---------------------------------------------------- если непарафазен датчик "ДН"
  if OVBuffer[Obj.ObjConstI[1]].NParam[4] then form.Brush.Color := armcolor14
  else  form.Brush.Color := ColorNight; //-------- отключена кнопка "Ночь"

  form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
  form.Rectangle(obj.Points[2].X-deltaX+1,obj.Points[2].Y-5,
  obj.Points[2].X+deltaX-1,obj.Points[2].Y+6);

  form.Pen.Color := armcolor16;
  form.MoveTo(obj.Points[2].X+deltaX-1,obj.Points[2].Y-6);
  form.LineTo(obj.Points[2].X-deltaX,obj.Points[2].Y-6);
  form.LineTo(obj.Points[2].X-deltaX,obj.Points[2].Y+6);

  form.Pen.Color := armcolor17;
  form.MoveTo(obj.Points[2].X-deltaX+1,obj.Points[2].Y+6);
  form.LineTo(obj.Points[2].X+deltaX,obj.Points[2].Y+6);
  form.LineTo(obj.Points[2].X+deltaX,obj.Points[2].Y-6);
  form.Brush.Style := bsClear;  form.Font.Style := [];  form.Font.Size := 10;
  x1 := form.TextWidth(' Ночь ') div 2;
  y1 := form.TextHeight(' Ночь ') div 2;
  form.TextOut(obj.Points[2].X-x1,obj.Points[2].Y-y1,' Ночь ');

  //----------------------------------------------------------- работа с кнопкой "Автомат"
  deltaX := form.TextWidth(' Автомат ') div 2;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then form.Brush.Color := armcolor8
  else
  //------------------------------------------------------------- если непарафазен Автомат
  if OVBuffer[Obj.ObjConstI[1]].NParam[3] then form.Brush.Color := armcolor14
  else //-------------------------------------------------------------- если неисправность
   if OVBuffer[Obj.ObjConstI[1]].Param[20] then form.Brush.Color := armcolor11
  else form.Brush.Color := ColorAUK;

  form.Pen.Style := psSolid; form.Pen.Color := form.Brush.Color;
  form.Rectangle(obj.Points[3].X-deltaX+1,obj.Points[3].Y-5,
  obj.Points[3].X+deltaX-1,obj.Points[3].Y+6);

  form.Pen.Color := armcolor16;
  form.MoveTo(obj.Points[3].X+deltaX-1,obj.Points[3].Y-6);
  form.LineTo(obj.Points[3].X-deltaX,obj.Points[3].Y-6);
  form.LineTo(obj.Points[3].X-deltaX,obj.Points[3].Y+6);

  form.Pen.Color := armcolor17;
  form.MoveTo(obj.Points[3].X-deltaX+1,obj.Points[3].Y+6);
  form.LineTo(obj.Points[3].X+deltaX,obj.Points[3].Y+6);
  form.LineTo(obj.Points[3].X+deltaX,obj.Points[3].Y-6);
  form.Brush.Style := bsClear;  form.Font.Style := [];  form.Font.Size := 10;
  x1 := form.TextWidth(' Автомат ') div 2;
  y1 := form.TextHeight(' Автомат ') div 2;
  form.TextOut(obj.Points[3].X-x1,obj.Points[3].Y-y1,' Автомат ');
end;

//========================================================================================
//---------------------------------------------------- нарисовать счетчик нажатий КОК (94)
procedure DisplaySchetKOK(Obj: POVStruct;form: TCanvas);
var x1,x2 : integer;
begin

{$IFDEF RMSHN}
    if ((StateRU and $20) = $20) then
    begin
      WorkMode.PushOK := true;
      WorkMode.OtvKom := true;  //------------------------------------- Есть разрешение ОК
    end else
    begin
      WorkMode.PushOK := false;
      WorkMode.OtvKom := false;  //------------------------------------ Есть разрешение ОК
    end;
{$ENDIF}
  if WorkMode.OKError then form.Brush.Color := armcolor14 //------------------------- циан
  else
    if WorkMode.PushOK then form.Brush.Color := armcolor1 //----------------- ярко красный
    else form.Brush.Color := armcolor8; //------------------------------------------ серый
  form.Pen.Color := 0; form.Pen.Width := 1; form.Pen.Style := psSolid;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+22);
  form.Font.Color := clBlack; TekFontSize := form.Font.Size; //----запомнить размер шрифта
  form.Font.Size := 10; //---------------------------------------- назначить размер шрифта
  form.Font.Style := [fsBold];
  x2 := KOKCounter;
  x1 := x2 div 100000; sLbl := intToStr(x1);
  x2 := x2 - x1 * 100000; x1 := x2 div 10000; sLbl := sLbl + intToStr(x1);
  x2 := x2 - x1 * 10000;  x1 := x2 div 1000;  sLbl := sLbl + intToStr(x1);
  x2 := x2 - x1 * 1000;   x1 := x2 div 100;   sLbl := sLbl + intToStr(x1);
  x2 := x2 - x1 * 100;    x1 := x2 div 10;    sLbl := sLbl + intToStr(x1);
  x2 := x2 - x1 * 10;                        sLbl := sLbl + intToStr(x2);
  form.TextOut(obj.Points[1].X+5,obj.Points[1].Y+3,'КОК');
  form.Brush.Color := armcolor9; //------------------------------------------------- белый
  form.Pen.Color := 0;
  form.Rectangle(obj.Points[1].X+40,obj.Points[1].Y+3,obj.Points[1].X+95,obj.Points[1].Y+19);
  form.Brush.Style := bsClear;
  form.TextOut(obj.Points[1].X+44,obj.Points[1].Y+3,sLbl);
  form.Font.Color := TekFontSize;
end;
//========================================================================================
//------------------------------------------------------------ иконка выключения звонка 95
procedure DisplayIconRing(Obj: POVStruct;form: TCanvas);
var x1 : integer;
begin
 if sound then x1 := 1 else x1 := 0;
 TabloMain.ImageList32.Draw(form,obj.Points[1].X,obj.Points[1].Y,x1);
end;
//========================================================================================
//--------------------------------------------------- нарисовать иконку режима работы (96)
procedure DisplayIconRegim(Obj: POVStruct;form: TCanvas);
var
  x1,VidBuf : integer;
begin
  VidBuf := Obj.ObjConstI[1];
  x1 := 0;
  if WorkMode.BU[0] or not WorkMode.KRU[0] then x1 := 0 // нет информации о режиме упр-ния
  else
    if WorkMode.NU[0] then x1 := 6//-- непарафазность датчиков состояния режима управления
    else
    begin //----------------------------------------- есть информация о состоянии датчиков
      if (StateRU and $40) = $40 then // ----------------------------- установлен режим ОУ
      begin

        if WorkMode.OU[0] and not WorkMode.RU[0] then
        begin
          {$IFDEF RMDSP}
          if WorkMode.DC = 0 then x1 := 2 //--------- в системе нет ДЦ, индекс картинки ОУ
          else x1 := 2; //-------------------------- в системе есть ДЦ, индекс картинки РУ
          if  OVBuffer[VidBuf].Param[7] then x1 := 3;
          {$ENDIF}

          {$IFDEF RMSHN}
          if WorkMode.DC = 0 then x1 :=  2 //-------- в системе нет ДЦ, индекс картинки ОУ
          else x1 := 2; //-------------------------- в системе есть ДЦ, индекс картинки РУ
          if  OVBuffer[VidBuf].Param[7] then x1 := 3;
          {$ENDIF}

          {$IFDEF RMARC}
          if WorkMode.DC = 0 then x1 :=  2 //-------- в системе нет ДЦ, индекс картинки ОУ
          else x1 := 2; //-------------------------- в системе есть ДЦ, индекс картинки РУ
          if  OVBuffer[VidBuf].Param[7] then x1 := 3;
          {$ENDIF}
        end
        else x1 := 0; //------------------------------------------- индекс пустой картинки
      end
      else
      if WorkMode.RU[0] and not WorkMode.OU[0] then x1 := 1 //--------- индекс картинки АУ
      else x1 := 0;  //-------------------------------------------- индекс пустой картинки
    end;

  TabloMain.ImageListRU.Draw(form,obj.Points[1].X,obj.Points[1].Y,x1);

  TekFontSize := form.Font.Size;
  form.Font.Size := 12;
  form.Font.Style := [fsBold];
  form.Font.Color := clBlack;

  {$IFDEF RMSHN}
   sLbl := obj.Title + '-ШН'; //----- Вывести имя АРМ
   {$ENDIF}

  {$IFDEF RMDSP}
    if SrvActive>0 then sLbl := obj.Title + '-'+ IntToStr(SrvActive) //--- Вывести имя АРМ
    else sLbl := obj.Title;
  {$ENDIF}

  {$IFDEF RMARC}
    if SrvActive>0 then sLbl := obj.Title + '-'+ IntToStr(SrvActive) //--- Вывести имя АРМ
    else sLbl := obj.Title;
  {$ENDIF}

  if WorkMode.RUError <> 0 then  form.Brush.Color := armcolor14 //------------------- циан
  else
    if (DirState[1] and $80) = $80 then form.Brush.Color := armcolor5 //---------- зеленый
    else form.Brush.Color := armcolor7; //----------------------------------------- желтый
  form.Pen.Color := form.Brush.Color;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+64,obj.Points[1].X+64,obj.Points[1].Y+84);
  form.Brush.Style := bsClear; form.Font.Style := [];
  x1 := 32 - form.TextWidth(sLbl) div 2;
  form.TextOut(obj.Points[1].X+x1,obj.Points[1].Y+64,sLbl);
  form.Font.Style := [];
  form.Font.Size := TekFontSize; //--------------------------------- вернуть размер шрифта
end;
//========================================================================================
//---------------------------------------------------- нарисовать кнопку конца набора (97)
procedure DisplayKnopKonec(Obj: POVStruct;form: TCanvas);
begin
  if WorkMode.MarhUpr and WorkMode.Upravlenie and WorkMode.GoTracert then
  begin
    form.Pen.Color := armcolor16; //-------------------------------------- светлая сторона
    form.Brush.Color := armcolor16;
    form.Font.Color := clBlack;
  end
  else
  begin
    form.Pen.Color := armcolor18; //------------------------------------------- фон кнопки
    form.Brush.Color := armcolor18;
    form.Font.Color := clWhite;
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0,obj.Points[1].X+100,obj.Points[1].Y+17);
  form.Font.Style := []; form.Font.Size := 8;
  form.TextOut(obj.Points[1].X+13,obj.Points[1].Y+2, 'Конец набора');
end;
//========================================================================================
//----------------------------------------------------- Система "3 Сервера и 8 ТУМС"  (98)
procedure Display_3Serv_8TUMS(Obj: POVStruct;form: TCanvas);
label str1, prigl;
var n,p,b1,b2,b3 : Boolean;
begin
  form.Pen.Color := 0; form.Pen.Style := psSolid;
  form.Pen.Width := 1; form.Brush.Style := bsSolid; form.Font.Color := clBlack;
  form.Brush.Color := armcolor16; form.Font.Size := 8;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y,obj.Points[1].X+176,obj.Points[1].Y+37);
  //----------------------------------------------- состояние оборудования верхнего уровня
  if StateRU > 0 then
  begin
    if (StateRU and $8) = $8
    then form.Brush.Color := armcolor2 //----------------------------------------- зеленый
    else form.Brush.Color := armcolor7; //----------------------------------------- желтый
  end
  else form.Brush.Color := armcolor1; //------------------------------------------ красный
  form.Rectangle(obj.Points[1].X+2,obj.Points[1].Y+10,obj.Points[1].X+27,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if (StateRU = 0) or   //-------- если из сервера ничего не поступило о его состоянии или
  WorkMode.NU[0] or     //------------------ непарафазность датчиков режима управления или
  WorkMode.BU[0] or     //--------------- нет активности по датчикам режима управления или
  not WorkMode.KRU[0] or //------------------------ нет соответствия режима управления или
  (WorkMode.OU[0] and WorkMode.RU[0]) //------------- режим управления с АРМа или с пульта
  then sLbl := 'Н' //-------------------------------- ------------------------то текст "Н"
  else //--------------------------------------------------------------------------- иначе
    if ((StateRU and $40) = $40) and  //--------------------------- если управление с АРМа
    (WorkMode.OU[0]) then //------------------------------------------ и это зафиксировано
    begin
      if WorkMode.Upravlenie then sLbl := 'Упр' //----- если АРМ в состоянии "Управляющий"
      else sLbl := 'Рез'; //----------------------------- если АРМ в состоянии "Резервный"
    end
    else
      if WorkMode.RU[0] then sLbl := 'АУ' //---------- если управления с резервного пульта
      else sLbl := 'Н';
  form.TextOut(obj.Points[1].X+4,obj.Points[1].Y+12,sLbl);
  //------------------------------------------------------ состояние оборудования серверов
  form.Brush.Style := bsSolid;
  if SrvCount = 1 then form.Brush.Color := armcolor1//------если один сервер- цвет красный
  else
    if SrvCount = 2 then form.Brush.Color := armcolor7 //---- если 2 сервера - цвет желтый
    else
      if SrvCount = 3 then form.Brush.Color := armcolor2 //- если 3 сервера - цвет зеленый
      else form.Brush.Color := armcolor14; //--------------------- нет сервера - цвет циан
  form.Rectangle(obj.Points[1].X+30,obj.Points[1].Y+10, obj.Points[1].X+65,obj.Points[1].Y+27);
  sLbl := 'Срв.';
  if SrvActive > 0 then sLbl := sLbl + IntToStr(SrvActive) //--- если есть активный сервер
  else sLbl := sLbl + '?';
  form.TextOut(obj.Points[1].X+33,obj.Points[1].Y+12,sLbl);
  //------------------------------------------------ состояние оборудования нижнего уровня
  //-------------- ТУМС1 -----------------------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[1]].Param[1];      //------------------------ непарафазность
  p := not OVBuffer[Obj.ObjConstI[1]].Param[16]; //-------------------- активность объекта
  b1 := OVBuffer[Obj.ObjConstI[1]].Param[2];     //------------------------------------- Р
  b2 := OVBuffer[Obj.ObjConstI[1]].Param[3];     //------------------------------------ Ао
  b3 := OVBuffer[Obj.ObjConstI[1]].Param[4];     //------------------------------------ Ар
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8  //--------------- если неактивен, то цвет серый
  else
   if n then form.Brush.Color := armcolor14 //------------ если непарафазный, то цвет циан
   else
    if not b2 and not b3 then form.Brush.Color := armcolor2 //-- если Ао и Ар цвет зеленый
    else
      if b2 and b3 then form.Brush.Color := armcolor1 //-- если не Ао и не Ар цвет красный
      else form.Brush.Color := armcolor7; //---------------------------------- цвет желтый
  form.Rectangle(obj.Points[1].X+70,obj.Points[1].Y+10,obj.Points[1].X+82,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) //---- если непарафазность или неактивность или (не Ао и не Ар)
  then sLbl := 'Н'
  else
  begin
    if b1 then sLbl := 'П' //------------------------------------------------------ если Р
    else sLbl := 'л';
  end;
  form.TextOut(obj.Points[1].X+72,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС2 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[2]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[2]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[2]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[2]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[2]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor1
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+83,obj.Points[1].Y+10,obj.Points[1].X+95,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+85,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС3 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[3]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[3]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[3]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[3]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[3]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+96,obj.Points[1].Y+10,obj.Points[1].X+108,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+98,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС4 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[4]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[4]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[4]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[4]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[4]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+109,obj.Points[1].Y+10,obj.Points[1].X+121,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+111,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС5 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[5]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[5]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[5]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[5]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[5]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+122,obj.Points[1].Y+10,obj.Points[1].X+134,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+124,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС6 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[6]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[6]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[6]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[6]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[6]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+135,obj.Points[1].Y+10,obj.Points[1].X+147,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+137,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС7 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[7]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[7]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[7]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[7]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[7]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+148,obj.Points[1].Y+10,obj.Points[1].X+160,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+150,obj.Points[1].Y+12, sLbl);
  //-------------- то же самое для ТУМС8 -------------------------------------------------
  n := OVBuffer[Obj.ObjConstI[8]].Param[1];
  p := not OVBuffer[Obj.ObjConstI[8]].Param[16];
  b1 := OVBuffer[Obj.ObjConstI[8]].Param[2];
  b2 := OVBuffer[Obj.ObjConstI[8]].Param[3];
  b3 := OVBuffer[Obj.ObjConstI[8]].Param[4];
  form.Brush.Style := bsSolid;
  if p then form.Brush.Color := armcolor8
  else
    if n then form.Brush.Color := armcolor14
    else
      if not b2 and not b3 then form.Brush.Color := armcolor2
      else
        if b2 and b3 then form.Brush.Color := armcolor1
        else form.Brush.Color := armcolor7;
  form.Rectangle(obj.Points[1].X+161,obj.Points[1].Y+10,obj.Points[1].X+173,obj.Points[1].Y+27);
  form.Font.Size := 8; form.Font.Style := []; form.Brush.Style := bsClear;
  if n or p or (b2 and b3) then sLbl := 'Н'
  else
    begin
      if b1 then sLbl := 'П'
      else sLbl := 'л';
    end;
  form.TextOut(obj.Points[1].X+163,obj.Points[1].Y+12, sLbl);
  form.Pen.Width := 5;
  //---------------------------- Состояние канала1 связи АРМ - Сервера--------------------
  if ArmSrvCh[1] = 1 then form.Pen.Color := armcolor1 //- если фиксирована ошибка, красный
  else
    if ArmSrvCh[1] = 2 then form.Pen.Color := armcolor7 //- если ошибок больше 2-х, желтый
    else
       if ArmSrvCh[1] = 4 then form.Pen.Color := armcolor5//- если получен маркер, зеленый
       else form.Pen.Color := armcolor8; //-------------------- пассивное состояние, серый
  form.MoveTo(obj.Points[1].X+10,obj.Points[1].Y+5);
  form.LineTo(obj.Points[1].X+40,obj.Points[1].Y+5);

  //----------------------------- Состояние канала2 связи АРМ - Сервера ------------------
  if ArmSrvCh[2] = 1 then form.Pen.Color := armcolor1
  else
    if ArmSrvCh[2] = 2 then form.Pen.Color := armcolor7
    else
      if ArmSrvCh[2] = 4 then form.Pen.Color := armcolor5
      else form.Pen.Color := armcolor8;
  form.MoveTo(obj.Points[1].X+10,obj.Points[1].Y+31);
  form.LineTo(obj.Points[1].X+40,obj.Points[1].Y+31);

  //---------------------- Состояние каналов связи  Сервера - УВК ------------------------
  if OVBuffer[Obj.ObjConstI[1]].Param[13] then //------------- если  активность в канале 2
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[14] then //------------ если активность в канале 1
    form.Pen.Color := armcolor2       //------------------------------------------ зеленый
    else form.Pen.Color := armcolor7; //------------------------------------------- желтый
  end
  else  form.Pen.Color := armcolor8;  //---------------------- нет активности, тогда серый
  form.MoveTo(obj.Points[1].X+55,obj.Points[1].Y+5);
  form.LineTo(obj.Points[1].X+165,obj.Points[1].Y+5);
  form.MoveTo(obj.Points[1].X+55,obj.Points[1].Y+31);
  form.LineTo(obj.Points[1].X+165,obj.Points[1].Y+31);
end;
//========================================================================================
//------------------------------------------------------- табло выбора режимов работы (99)
procedure DisplayTabloRegim(Obj: POVStruct;form: TCanvas);
var x1 : integer;
begin
//--------------------------------------- Выбор режима управления ************************
  case Obj.ObjConstI[1] of
  0 :
  begin //----------------------------------------------------- панель для крупной станции
    form.Brush.Style := bsSolid;
    form.Pen.Style := psSolid;
    if maket_strelki_index > 0 then form.Brush.Color := armcolor9 //-----------------белый
    else form.Brush.Color := armcolor8; //-------------------------------------------серый
    //------------------------------------------------------------- Макетная доска -------
    form.FillRect(rect(obj.Points[1].X+10,obj.Points[1].Y, obj.Points[1].X+110,obj.Points[1].Y+17));
    if maket_strelki_index > 0 then
    begin
      TekFontSize := form.Font.Size;
      form.Font.Size := 10;
      form.Font.Style := [fsBold];
      form.Font.Color := clBlack;
      x1 := form.TextWidth(maket_strelki_name) div 2;
      form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, maket_strelki_name);
      form.Font.Size := TekFontSize;
    end else
    begin
      if TabloP.System_Tip = 0 then//-----------------------------если тип системы 0 - РПЦ
      begin
        TekFontSize := form.Font.Size;
        form.Font.Size := 10;
        form.Font.Style := [];
        if WorkMode.GoMaketSt //--- Если выполняется выбор стрелки для постановки на макет
        then form.Font.Color := clRed
        else form.Font.Color := clWhite;
        x1 := form.TextWidth('Макет стрелки') div 2;
        form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, 'Макет стрелки');
        form.Font.Size := TekFontSize;
      end;
    end;
    form.Font.Color := clBlack;
    form.Font.Size := 8;
    form.Font.Style := [];
    form.Pen.Style := psSolid;
    form.Brush.Style := bsSolid;

    if WorkMode.Upravlenie then
    begin //------------------------------------------------------ если управление от АРМа
      if WorkMode.RazdUpr then //----------------------------------------- если раздельное
      begin
        form.Brush.Color := armcolor7;  //----------------------------------------- желтый
        form.Font.Color := clBlack;
      end else //----------------------------------------- если нет раздельного управления
      begin
        form.Brush.Color := armcolor16; //------------------------- светлая сторона кнопки
        form.Font.Color := clBlack;
      end;
    end else //----------------------------------------------- если нет управления от АРМа
    begin
      form.Brush.Color := armcolor18; //--------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+30, obj.Points[1].X+120,obj.Points[1].Y+47));
    form.TextOut(obj.Points[1].X+10,obj.Points[1].Y+32, 'Раздельный режим');
    if WorkMode.Upravlenie then //-------------------------------- если управление от АРМа
    begin
      if WorkMode.MarhUpr then //------------------------------ если маршрутное управление
      begin
        form.Brush.Color := armcolor2; //---------------------------------- светло зеленый
        form.Font.Color := clBlack;
      end else
      begin
        form.Brush.Color := armcolor16;  //------------------------ светлая сторона кнопки
        form.Font.Color := clBlack;
      end;
    end else//------------------------------------------------ если нет управления от АРМа
    begin
      form.Brush.Color := armcolor18; //--------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+50, obj.Points[1].X+120,obj.Points[1].Y+67));
    form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+52, 'Маршрутный режим');

    if WorkMode.Upravlenie then //-------------------------------- если управление от АРМа
    begin
      if WorkMode.MarhOtm then //------------------------------------ если отмена маршрута
      begin
        form.Brush.Color := armcolor7; //------------------------------------------ желтый
        form.Font.Color := clBlack;
      end else //------------------------------------------------ если нет отмены маршрута
      begin
        form.Brush.Color := armcolor16; //------------------------- светлая сторона кнопки
        form.Font.Color := clBlack;
      end;
    end else //----------------------------------------------- если нет управления от АРМа
    begin
      form.Brush.Color := armcolor18; //--------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+70, obj.Points[1].X+120,obj.Points[1].Y+87));
    form.TextOut(obj.Points[1].X+39,obj.Points[1].Y+72, 'Отмена');

    if WorkMode.Upravlenie then //-------------------------------- если управление от АРМа
    begin
      if WorkMode.InpOgr then //------------------------------------ если ввод ограничений
      begin
        form.Brush.Color := armcolor7; //------------------------------------------ желтый
        form.Font.Color := clBlack;
      end else  //--------------------------------------------- если нет ввода ограничений
      begin
        form.Brush.Color := armcolor16; //------------------------- светлая сторона кнопки
        form.Font.Color := clBlack;
      end;
    end else   //--------------------------------------------- если нет управления от АРМа
    begin
      form.Brush.Color := armcolor18; //--------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+100, obj.Points[1].X+120,obj.Points[1].Y+117));
    form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+102, 'Ограничения');

    if WorkMode.Upravlenie then //-------------------------------- если управление от АРМа
    begin
      if WorkMode.VspStr then //--------------------- если вспомогательный перевод стрелки
      begin
        form.Brush.Color := armcolor7; //------------------------------------------ желтый
        form.Font.Color := clBlack;
      end else
      begin
        form.Brush.Color := armcolor16;  //------------------------ светлая сторона кнопки
        form.Font.Color := clBlack;
      end;
    end else   //--------------------------------------------- если нет управления от АРМа
    begin
      form.Brush.Color := armcolor18;  //-------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+120, obj.Points[1].X+120,obj.Points[1].Y+137));
    form.TextOut(obj.Points[1].X+3,obj.Points[1].Y+122, 'Всп. перевод стрелок');

    if WorkMode.LockCmd and WorkMode.Upravlenie then
    begin
      form.Brush.Color := armcolor1;  //------------------------------------------ красный
      form.Font.Color := clBlack;
    end else
    if WorkMode.CmdReady then
    begin
      form.Brush.Color := armcolor7; //-------------------------------------------- желтый
      form.Font.Color := clBlack;
    end else
    begin
      form.Brush.Color := armcolor18;  //-------------------------------------- фон кнопки
      form.Font.Color := armcolor9; //---------------------------------------------- белый
    end;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+140, obj.Points[1].X+120,obj.Points[1].Y+157));
    form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+142, 'Сброс команд');

    //------------------------------------------------------------------------ часы РМ-ДСП
    form.Brush.Color := RGB(220,255,220);
    form.Font.Color := clBlack;
    form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+160, obj.Points[1].X+120,obj.Points[1].Y+180));
    DateTimeToString(sLbl, 'h:nn:ss', LastTime);
    TekFontSize := form.Font.Size;
    form.Font.Size := 12;
    form.Font.Style := [fsBold];
    x1 := form.TextWidth(sLbl) div 2;
    form.TextOut(obj.Points[1].X-x1+60,obj.Points[1].Y+160, sLbl);
    TekFontSize := form.Font.Size;
  end;

  1,2 :
  begin //------------------------------------------------------ панель для мелкой станции
    form.Brush.Style := bsSolid;  form.Pen.Style := psSolid;
    if Obj.ObjConstI[1] = 1 then //--------------------------------------------- если МСТУ
    begin
      if maket_strelki_index > 0 then form.Brush.Color := armcolor9
      else form.Brush.Color := armcolor8;
      form.FillRect(rect(obj.Points[1].X+10,obj.Points[1].Y, obj.Points[1].X+110,obj.Points[1].Y+17)); // Макетная доска

      if maket_strelki_index > 0 then
      begin
        TekFontSize := form.Font.Size;  form.Font.Size := 10; form.Font.Style := [fsBold];
        form.Font.Color := clBlack;
        x1 := form.TextWidth(maket_strelki_name) div 2;
        form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, maket_strelki_name);
        form.Font.Size := TekFontSize;
      end else
      begin
        TekFontSize := form.Font.Size; form.Font.Size := 10; form.Font.Style := [];
        if WorkMode.GoMaketSt then form.Font.Color := clRed
        else form.Font.Color := clWhite;
        x1 := form.TextWidth('Макет стрелки') div 2;
        form.TextOut(obj.Points[1].X+60-x1,obj.Points[1].Y, 'Макет стрелки');
        form.Font.Size := TekFontSize;
      end;
    end;
    form.Font.Color := clBlack;
    form.Font.Size := 8;
    form.Font.Style := [];
    form.Pen.Style := psSolid;
    form.Brush.Style := bsSolid;
    if WorkMode.Upravlenie then
    begin
      if WorkMode.RazdUpr then
      begin
        form.Brush.Color := armcolor7;
        form.Font.Color := clBlack;
      end else
      begin
          form.Brush.Color := armcolor16;
          form.Font.Color := clBlack;
        end;
      end else
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y, obj.Points[1].X+120,obj.Points[1].Y+17));
      form.TextOut(obj.Points[1].X+10,obj.Points[1].Y+2, 'Раздельный режим');

      if WorkMode.Upravlenie then
      begin
        if WorkMode.MarhUpr then
        begin
          form.Brush.Color := armcolor2;
          form.Font.Color := clBlack;
        end else
        begin
          form.Brush.Color := armcolor16;
          form.Font.Color := clBlack;
        end;
      end else
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+20, obj.Points[1].X+120,obj.Points[1].Y+37));
      form.TextOut(obj.Points[1].X+8,obj.Points[1].Y+22, 'Маршрутный режим');

      if WorkMode.Upravlenie then
      begin
        if WorkMode.MarhOtm then
        begin
          form.Brush.Color := armcolor7;
          form.Font.Color := clBlack;
        end else
        begin
          form.Brush.Color := armcolor16;
          form.Font.Color := clBlack;
        end;
      end else
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+40, obj.Points[1].X+120,obj.Points[1].Y+57));
      form.TextOut(obj.Points[1].X+39,obj.Points[1].Y+42, 'Отмена');
      if WorkMode.Upravlenie then  //---------------------------- если включено управления
      begin
        if WorkMode.InpOgr then   //--------------------------- если идет ввод ограничений
        begin
          form.Brush.Color := armcolor7;
          form.Font.Color := clBlack;
        end else    //----------------------------------------- если нет ввода ограничений
        begin
          form.Brush.Color := armcolor16;
          form.Font.Color := clBlack;
        end;
      end else //--------------------------------------------- если не включено управления
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+70, obj.Points[1].X+120,obj.Points[1].Y+87));
      form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+72, 'Ограничения');

      if WorkMode.Upravlenie then
      begin
        if WorkMode.VspStr then
        begin
          form.Brush.Color := armcolor1;
          form.Font.Color := clBlack;
        end else
        begin
          form.Brush.Color := armcolor16;
          form.Font.Color := clBlack;
        end;
      end else
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      if Obj.ObjConstI[1] = 1 then
      begin
        form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+90, obj.Points[1].X+120,obj.Points[1].Y+107));
        form.TextOut(obj.Points[1].X+3,obj.Points[1].Y+92, 'Всп. перевод стрелок');
      end;
      if WorkMode.LockCmd and WorkMode.Upravlenie then
      begin
        form.Brush.Color := armcolor1;
        form.Font.Color := clBlack;
      end else
      if WorkMode.CmdReady then
      begin
        form.Brush.Color := armcolor7;
        form.Font.Color := clBlack;
      end else
      begin
        form.Brush.Color := armcolor18;
        form.Font.Color := armcolor9;
      end;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+110, obj.Points[1].X+120,obj.Points[1].Y+127));
      form.TextOut(obj.Points[1].X+23,obj.Points[1].Y+112, 'Сброс команд');

      //---------------------------------------------------------------------- часы РМ-ДСП
      form.Brush.Color := RGB(220,255,220);
      form.Font.Color := clBlack;
      form.FillRect(rect(obj.Points[1].X,obj.Points[1].Y+130, obj.Points[1].X+120,obj.Points[1].Y+150));
      DateTimeToString(sLbl, 'h:nn:ss', LastTime);
      TekFontSize := form.Font.Size;
      form.Font.Size := 12;
      form.Font.Style := [fsBold];
      x1 := form.TextWidth(sLbl) div 2;
      form.TextOut(obj.Points[1].X-x1+60,obj.Points[1].Y+130, sLbl);
      form.Font.Size := TekFontSize;
    end;
  end;
end;
//========================================================================================
//----------------- Отображение состояния системы для варианта с программным каналом (100)
procedure DisplayArmServPipe(Obj: POVStruct;form: TCanvas);
begin
  form.Pen.Color := 0;  form.Pen.Style := psSolid;  form.Pen.Width := 1;
  form.Brush.Style := bsSolid;  form.Font.Color := clBlack;
  form.Brush.Color := armcolor16;
  form.Font.Size := 8;
  form.Font.Style := [];
  //---------------------------------------------------------  состояние оборудования ТУМС
  form.Brush.Style := bsSolid;
  if not OVBuffer[Obj.ObjConstI[1]].Param[16] then
  begin
    form.Brush.Color := armcolor8;
    form.Rectangle(obj.Points[1].X,obj.Points[1].Y+11,obj.Points[1].X+45,obj.Points[1].Y+27);
    if obj.ObjConstI[5] = 0 then  sLbl := ' ТУМС' + IntToStr(obj.ObjConstI[2]);
    if obj.ObjConstI[5] = 1 then  sLbl := ' МСТУ' + IntToStr(obj.ObjConstI[2]);
    if obj.ObjConstI[5] = 3 then  sLbl := ' ОСЭЦ' + IntToStr(obj.ObjConstI[2]);
    form.TextOut(obj.Points[1].X+2,obj.Points[1].Y+12,sLbl);
    form.Rectangle(obj.Points[1].X,obj.Points[1].Y+27,obj.Points[1].X+23,obj.Points[1].Y+43);
    form.Rectangle(obj.Points[1].X+23,obj.Points[1].Y+27,obj.Points[1].X+45,obj.Points[1].Y+43);
    form.Pen.Width := 0;
    exit;
  end
  else
  begin //------------------------------------------------------ отработка мультивибратора
    if OVBuffer[Obj.ObjConstI[1]].NParam[4] then form.Brush.Color := armcolor14
    else
    if OVBuffer[Obj.ObjConstI[1]].Param[4] then form.Brush.Color := armcolor2
    else form.Brush.Color := armcolor5;
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+11,obj.Points[1].X+45,obj.Points[1].Y+27);

  if obj.ObjConstI[5] = 0 then  sLbl := ' ТУМС' + IntToStr(obj.ObjConstI[2]);
  if obj.ObjConstI[5] = 1 then  sLbl := ' МСТУ' + IntToStr(obj.ObjConstI[2]);
  if obj.ObjConstI[5] = 3 then  sLbl := ' ОСЭЦ' + IntToStr(obj.ObjConstI[2]);

  if OVBuffer[Obj.ObjConstI[1]].Param[8] then //------------------ стойка занята маршрутом
  begin
    if tab_page then form.Font.Color := armcolor9
    else form.Font.Color :=  clBlack;
  end
  else
    if OVBuffer[Obj.ObjConstI[1]].Param[9] then
    form.Font.Color :=  clBlack //---------------------- стойка успешно установила маршрут
    else
      if OVBuffer[Obj.ObjConstI[1]].Param[10] then //--- стойка завершила маршрут неудачно
      form.Font.Color := armcolor1;
  form.TextOut(obj.Points[1].X+2,obj.Points[1].Y+12,sLbl);
  form.Font.Color :=  clBlack;
  //-------------------------------------------------------------- работа с левой корзиной
  if OVBuffer[Obj.ObjConstI[1]].NParam[1] or OVBuffer[Obj.ObjConstI[1]].NParam[2]
  then form.Brush.Color := armcolor14
  else
  begin
    if not OVBuffer[Obj.ObjConstI[1]].Param[1] then //-------- если левая корзина основная
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[2]
      then form.Brush.Color := armcolor2 //-------------------------------------- исправна
      else form.Brush.Color := armcolor1; //----------------------------------- неисправна
    end else  //---------------------------------------------------------- левая в резерве
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[2]
      then form.Brush.Color := armcolor7 //-------------------------------------- исправна
      else form.Brush.Color := armcolor1; //----------------------------------- неисправна
    end
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+27,obj.Points[1].X+23,obj.Points[1].Y+43);
  form.Pen.Width := 0;
  form.TextOut(obj.Points[1].X+6,obj.Points[1].Y+28,'Л');
  //------------------------------------------------------------- работа с правой корзиной
  if OVBuffer[Obj.ObjConstI[1]].NParam[1] or OVBuffer[Obj.ObjConstI[1]].NParam[3]
  then form.Brush.Color := armcolor14
  else
  begin
    if OVBuffer[Obj.ObjConstI[1]].Param[1] then //----------- если правая корзина основная
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[3]
      then form.Brush.Color := armcolor2 //-------------------------------------- исправна
      else form.Brush.Color := armcolor1; //----------------------------------- неисправна
    end else  //---------------------------------------------------------- левая в резерве
    begin
      if not OVBuffer[Obj.ObjConstI[1]].Param[3]
      then form.Brush.Color := armcolor7 //-------------------------------------- исправна
      else form.Brush.Color := armcolor1; //----------------------------------- неисправна
    end
  end;
  form.Rectangle(obj.Points[1].X+23,obj.Points[1].Y+27,obj.Points[1].X+45,obj.Points[1].Y+43);
  form.Pen.Width := 0;
  form.TextOut(obj.Points[1].X+29,obj.Points[1].Y+28,'П');
  //----------------------------------------------- Работа с состоянием источников питания
  //----------------------------------------------------------------------------- основной
  if OVBuffer[Obj.ObjConstI[1]].NParam[5] then form.Pen.Color := armcolor14
  else
    if OVBuffer[Obj.ObjConstI[1]].Param[5] then form.Pen.Color := armcolor4
    else form.Pen.Color := armcolor5;
  form.Pen.Width := 4;
  form.MoveTo(obj.Points[1].X, obj.Points[1].Y+45);
  form.LineTo(obj.Points[1].X+22,obj.Points[1].Y+45);
 //----------------------------------------------------------------------------- резервный
  if OVBuffer[Obj.ObjConstI[1]].NParam[6] then form.Pen.Color := armcolor14
  else
    if OVBuffer[Obj.ObjConstI[1]].Param[6] then form.Pen.Color := armcolor4
    else form.Pen.Color := armcolor5;
  form.Pen.Width := 4;
  form.MoveTo(obj.Points[1].X+24, obj.Points[1].Y+45);
  form.LineTo(obj.Points[1].X+45,obj.Points[1].Y+45);

  //-------------------------------------------------------------- работа с каналами связи
  form.Pen.Width := 0;
  //----------------------------------------------------------------------------- канал ТС
  if OVBuffer[Obj.ObjConstI[1]].Param[18] then form.Brush.Color := armcolor1
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[17]then form.Brush.Color := armcolor7
  else
  if OVBuffer[Obj.ObjConstI[1]].Param[19]then form.Brush.Color := armcolor7
  else form.Brush.Color := armcolor2;
  form.Pen.Color := form.Brush.Color;
  form.Polygon([Point(obj.Points[1].X+10,obj.Points[1].Y),
  Point(obj.Points[1].X+15,obj.Points[1].Y+10), Point(obj.Points[1].X+5,obj.Points[1].Y+10)]);
  //----------------------------------------------------------------------------- канал ТУ
  if OVBuffer[Obj.ObjConstI[1]].Param[17] or OVBuffer[Obj.ObjConstI[1]].Param[19]
  then form.Brush.Color := armcolor1
  else form.Brush.Color := armcolor2;
  form.Pen.Color := form.Brush.Color;
  form.Polygon([Point(obj.Points[1].X+25,obj.Points[1].Y), Point(obj.Points[1].X+35,obj.Points[1].Y),
  Point(obj.Points[1].X+30,obj.Points[1].Y+10)]);

  if obj.ObjConstI[5] <> 3 then
  begin
    //-------------------------------------------------------------------------- АРМ сосед
    if OVBuffer[Obj.ObjConstI[1]].Param[20] then form.Brush.Color := armcolor1
    else form.Brush.Color := armcolor2;
    form.Pen.Color := form.Brush.Color;
    form.Polygon([Point(obj.Points[1].X+55,obj.Points[1].Y-10),
    Point(obj.Points[1].X+65,obj.Points[1].Y-20), Point(obj.Points[1].X+65,obj.Points[1].Y)]);
    form.MoveTo(obj.Points[1].X+65, obj.Points[1].Y-10);
    form.LineTo(obj.Points[1].X+75,obj.Points[1].Y-10);
  end;
end;
//========================================================================================
//------------------------------------ нарисовать кнопку подсветки положения стрелок (101)
procedure DisplayPodsvetStr(Obj: POVStruct;form: TCanvas);
begin
  if WorkMode.Podsvet then
  begin
    form.Pen.Color := armcolor7;
    form.Brush.Color := armcolor7;
    form.Font.Color := clBlack;
  end else
  begin
    form.Pen.Color := armcolor9;
    form.Brush.Color := armcolor9;
    form.Font.Color := clBlack;
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
  form.Font.Style := []; form.Font.Size := 8;
  form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Подсветка стрелок');
end;
//========================================================================================
//-------------------------------------------- нарисовать кнопку ввода номера поезда (102)
procedure DisplayVvodNomer(Obj: POVStruct;form: TCanvas);
begin
  if WorkMode.InpTrain then
  begin
    form.Pen.Color := armcolor16;
    form.Brush.Color := armcolor16;
    form.Font.Color := clBlack;
  end else
  begin
    form.Pen.Color := armcolor18;
    form.Brush.Color := armcolor18;
    form.Font.Color := clWhite;
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
  form.Font.Style := [];
  form.Font.Size := 8;
  form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Ввод номера поезда');
end;
//========================================================================================
//--------------------------------------- нарисовать кнопку подсветки номера поездов (103)
procedure DisplayPoezdNomer(Obj: POVStruct;form: TCanvas);
begin
  if WorkMode.NumTrain then
  begin
    form.Pen.Color := armcolor16; form.Brush.Color := armcolor16; form.Font.Color := clBlack;
  end else
  begin
    form.Pen.Color := armcolor18;
    form.Brush.Color := armcolor18;
    form.Font.Color := clWhite;
  end;
  form.Rectangle(obj.Points[1].X,obj.Points[1].Y+0, obj.Points[1].X+100,obj.Points[1].Y+17);
  form.Font.Style := []; form.Font.Size := 8;
  form.TextOut(obj.Points[1].X+1,obj.Points[1].Y+2, 'Подсветка поездов');
end;

//========================================================================================
//------------------------------------------------------ получить стиль пера для рисования
function GetPenStyle(param : SmallInt) : TPenStyle;
begin
  case param of
    1 : result := psDot;
    2 : result := psDash;
    3 : result := psDashDot;
    4 : result := psDashDotDot;
    else result := psSolid;
  end;
end;
//========================================================================================
//------------------------------------------------------------------- получить стиль кисти
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
    else result := bsSolid;
  end;
end;
//========================================================================================
//-------------------------------------------------------------------- получить тип шрифта
function GetFontStyle(param : SmallInt) : TFontStyles;
begin
  case param of
    1 : result := [fsBold];
    2 : result := [fsItalic];
    3 : result := [fsUnderline];
    4 : result := [fsStrikeOut];
    else result := [];
  end;
end;
//========================================================================================
procedure DrawSP(form: TCanvas;Buf,Utol: SmallInt;ptr: array of TPoint);
//;ptr1,ptr2: TPoint);
//-------------------------------------------------- Прорисовка стрелочной секции на табло
//-------------------------------------------------------------- form - Указатель на табло
//-------------------------------------- Buf- видеобуфер для записи ветви стрелки (или СП)
//------------------------------------------- Utol - признак утолщения линии при занятости
//--------------------- ptr - Перечень точек ветви стрелки (или СП) для построения ломаной
var
  i,Cod_OB,tchk : Integer;
begin
  try
    tchk := High(ptr);
    form.Brush.Style := bsSolid;   form.Brush.Color := bkgndcolor;  Cod_Ob := 0;

    if not OVBuffer[buf].Param[16] then //------------------- нецентрализованное состояние
    begin
      form.Pen.Color := armcolor12; form.Pen.Width := 3; form.Pen.Style := psSolid;
      Cod_OB := 1;
    end;

    if OVBuffer[buf].Param[1] and (Cod_OB = 0) then //--------------------- непарафазность
    begin
      form.Pen.Color := armcolor14;  form.Pen.Width := 3; form.Pen.Style := psSolid;
      Cod_OB := 1;
    end;

    if OVBuffer[buf].Param[2] and (Cod_OB = 0) then //---------------------------- Есть РМ
    begin
      if WorkMode.Podsvet then Cod_OB := 2 // подсветка Показать состояние датчиков секции
      else
      begin
        if OVBuffer[buf].Param[3] then //------------------------------------- если нет МИ
        begin
          form.Pen.Color := armcolor13;  form.Pen.Width := 1; form.Pen.Style := psSolid;
        end else
        begin //------------------------------------------------------------- если есть МИ
          form.Pen.Color := armcolor13; form.Pen.Width := 3; form.Pen.Style := psSolid;
        end;
        Cod_OB := 1;
      end;
    end;

    if WorkMode.Podsvet and (Cod_OB = 0) then //----- Подсветка стрелок/ района управления
    begin
      if not OVBuffer[buf].Param[4] or //--------------- занята СП - Показать состояние СП
      not OVBuffer[buf].Param[5] or //---------------- замкнута СП - Показать состояние СП
      not OVBuffer[buf].Param[8] or //---------------- работа МСП  - Показать состояние СП
      OVBuffer[buf].Param[7] then Cod_OB := 2; //------- работа РИ - Показать состояние СП

      if OVBuffer[buf].Param[10] and (Cod_OB = 0) then //-------- Подсветка стрелок района
      begin //------------------------------------------------ Подсветка положения стрелок
        form.Pen.Color := armcolor6; form.Pen.Width := 3; form.Pen.Style := psSolid;
        Cod_OB := 1;
      end;
    end;

    if (Cod_OB = 2) or (Cod_OB = 0) then //---------- Определить состояния датчиков секции
    begin
      if OVBuffer[buf].Param[4] then //--------------------------------------- СП свободен
      begin
        if OVBuffer[buf].Param[5] then //----------------------------------- нет замыкания
        begin
          if OVBuffer[buf].Param[8] then //--------------------------------------- нет МСП
          begin
            form.Pen.Color := 0; form.Pen.Width := 1; form.Pen.Style := psSolid;
          end else
          begin //--------------------------------------------------------------- есть МСП
            form.Pen.Color := armcolor10; form.Pen.Width := 3; form.Pen.Style := psSolid;
          end;
        end else
        begin //----------------------------------------------------------- есть замыкание
          form.Pen.Color := armcolor7; form.Pen.Width := 3; form.Pen.Style := psSolid;
        end;
      end else
      begin //------------------------------------------------------------------- СП занят
        if OVBuffer[buf].Param[5] then //----------------------------------- нет замыкания
        begin
          form.Pen.Color := armcolor1; form.Pen.Width := 1; form.Pen.Style := psSolid;
        end else
        begin //----------------------------------------------------------- есть замыкание
          form.Pen.Color := armcolor1; form.Pen.Width := 3; form.Pen.Style := psSolid;
        end;
      end;
      Cod_OB := 1;
    end;

    if Cod_OB = 1 then   //-------------------------- Нарисовать состояние датчиков секции
    begin
      //form.Polyline(ptr);
        for i := 0 to tchk-1 do
        begin
          form.MoveTo(ptr[i].X,ptr[i].Y);
          form.LineTo(ptr[i+1].X,ptr[i+1].Y);
          form.LineTo(ptr[i].X,ptr[i].Y);
        end;
      if not OVBuffer[buf].Param[1] and OVBuffer[buf].Param[16] and
      not OVBuffer[buf].Param[4] and (Utol = 1) then
      begin
        form.Pen.Color := armcolor1; form.Pen.Width := 3; form.Pen.Style := psSolid;
       // form.MoveTo(ptr2.X,ptr[1].Y); form.LineTo(ptr2.X + 20,ptr[1].Y);
      end;
    end;

    if OVBuffer[buf].Param[16] and not OVBuffer[buf].Param[1] then//-достоверное состояние
    begin
      //--------------- Нарисовать признак предварительного замыкания секции (трассировка)
      //----------------------------------------------- и программное замыкание на сервере
      if not OVBuffer[buf].Param[1] and //----------------------------- нет непарафазности
      not OVBuffer[buf].Param[2] and    //----------------------------------------- нет РМ
      not OVBuffer[buf].Param[6] and    //--------------------------- есть предв.замыкание
      OVBuffer[buf].Param[4] and        //---------------------------------- нет занятости
      OVBuffer[buf].Param[5] and        //------------------------------------------ нет З
      not OVBuffer[buf].Param[7] then   //----------------------------------------- нет РИ
      begin
        form.Pen.Color := armcolor9; form.Pen.Style := psSolid;
        if OVBuffer[buf].Param[14] then form.Pen.Width := 3 else form.Pen.Width := 1;
        //form.Polyline(ptr);
        for i := 0 to tchk-1 do
        begin
          form.MoveTo(ptr[i].X,ptr[i].Y);
          form.LineTo(ptr[i+1].X,ptr[i+1].Y);
          form.LineTo(ptr[i].X,ptr[i].Y);
        end;
      end;
    end;


    if OVBuffer[buf].Param[16] and not OVBuffer[buf].Param[1] then //-- активна, парафазна
    begin
      //------------------------------ Нарисовать признак искусственного размыкания секции
      if not OVBuffer[buf].Param[1] and OVBuffer[buf].Param[7] then
      begin
        form.Pen.Style := psDot;
        if OVBuffer[buf].Param[5] then form.Brush.Color := armcolor11
        else form.Brush.Color := 0;
        form.Pen.Width := 1;
        //form.Polyline(ptr);
        for i := 0 to tchk-1 do
        begin
          form.MoveTo(ptr[i].X,ptr[i].Y);
          form.LineTo(ptr[i+1].X,ptr[i+1].Y);
          form.LineTo(ptr[i].X,ptr[i].Y);
        end;
      end;
    end;
  except
{$IFNDEF TABLO}
    reportf('Ошибка при выполнении [ObjSost.DrawSP]');
{$ENDIF}
  end;
end;
//========================================================================================
//----------------------------------------------------------------------------------------
procedure LS_GMS(Obj: POVStruct; var MIG,LS,GMS : boolean; var niz,verh : Integer);
var VKMG : Boolean;
begin
  VKMG := OVBuffer[Obj.ObjConstI[1]].Param[24];
  if Obj.ObjConstI[11] = 0 then  verh := armcolor7 //--------- если нет ЛС, то верх желтый
  else
  begin
    LS := OVBuffer[Obj.ObjConstI[1]].Param[22];
    if not LS then GMS_VKG(Obj,VKMG,GMS,MIG,niz,verh)
    else
    if (Obj.ObjConstI[12]>0) and GMS then verh := armcolor7
    else  verh := armcolor5;
  end;
end;
//========================================================================================
//----------------------------------------------------------------------------------------
procedure GMS_VKG(Obj: POVStruct; var VKMG,GMS,MIG: boolean;var niz,verh: Integer);
begin
  if (Obj.ObjConstI[12] > 0) and GMS and //------------------ если есть датчик ЖМС и ЖМС=1
  (Obj.ObjConstI[13] > 0) and VKMG     //------------------ если есть датчик ВКМГ и ВКМГ=1
  then
  begin
    verh := armcolor7; //---------------------------------------------------------- желтый
    MIG := true;
    OVBuffer[Obj.ObjConstI[1]].Param[26] := MIG;
    exit;
  end
  else
  begin
    verh := armcolor7; //---------------------------------------------------------- желтый
    MIG := false;
    OVBuffer[Obj.ObjConstI[1]].Param[26] := MIG;
    exit;
  end;
end;
end.


