unit DirectForm;
{$INCLUDE e:\Сапр_new\CfgProject}
interface

uses
  Windows,
  SysUtils,
  Classes,
  Forms,
  StdCtrls,
  Registry,
  ComCtrls,
  Dialogs,
  Controls;

type
  TDirectFormDlg = class(TForm)
    DateEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BtnStart: TButton;
    BtnStop: TButton;
    TimeStart: TDateTimePicker;
    TimeEnd: TDateTimePicker;
    BtnStep: TButton;
    BtnOpen: TButton;
    edittime: TEdit;
    Region: TComboBox;
    BtnPrev: TButton;
    Zoom: TComboBox;
    Label3: TLabel;
    Path: TEdit;
    Button1: TButton;
    OpenDialog: TOpenDialog;
    DateStart: TDateTimePicker;
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnStepClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure RegionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure ZoomChange(Sender: TObject);
    procedure edittimeExit(Sender: TObject);
    procedure edittimeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PathExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FindDateTimeFromArc(s : string; dt : Double; FindMode : Byte) : integer;
function CheckSyncStep(index : Integer; ct : Double) : Boolean;
function ArcStep(index : Integer) : Integer;
function FindStep(index : Integer) : Integer;

var
  DirectFormDlg: TDirectFormDlg;



var
  SoobCount : integer; //----------------------------------------------- счетчик сообщений
  SoobAdr   : integer; //----------------------------------------- базовый адрес сообщения
  ReperAdr  : integer; //-------------------------- базовый адрес последней реперной точки
  SoobBegin : Boolean; //-------------- признак обнаружения 1-го байта заголовка сообщения
  SoobHdr   : Boolean; //-------------------------------------- 2 байт заголовка сообщения
  SoobLen   : Boolean; //------------------------------------------------------ байт длины
  SoobType  : Boolean; //--------------------------------------------- байт типа сообщения
  SoobTime1 : Boolean; //-------------------------------------------------- 1 байт времени
  SoobTime2 : Boolean; //-------------------------------------------------- 2 байт времени
  SoobTime3 : Boolean; //-------------------------------------------------- 3 байт времени
  SoobTime4 : Boolean; //-------------------------------------------------- 4 байт времени
  SoobCont  : Boolean; // содержимое сообщения
  TypeSoob  : byte;    // тип сообщения
  LenSoob   : byte;    // длина сообщения
  TimeSoob  : Int64;   //------------------------------------------------- время сообщения
  NeedStep  : Boolean; // признак включения прокрутки клипа
  TypeLastFrame : Byte; //------------------------------------ тип последнего кадра данных
  ArcMaxOldTime : Double; //------------------------- ограничение доступа к старым архивам
  StartTime : Double;
  EndTime : Double;

implementation

{$R *.dfm}

uses
  TypeALL,
  CMenu,
  Commons,
  Commands,
  TabloForm,
  PackArmSrv;

var fn,fe : string; cBuf : array of char;

procedure TDirectFormDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if TabloMain.Active then TabloMain.Close; 
end;

procedure TDirectFormDlg.FormCreate(Sender: TObject);
begin
  reg   := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegDirectForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    reg.CloseKey;
  end;
  Path.Text := config.arcpath;
  Region.ItemIndex := 0;
  Zoom.Clear;
  Zoom.Items.Add('1'); // реальный масштаб
  Zoom.Items.Add('2'); //
  Zoom.Items.Add('4'); //
  Zoom.Items.Add('10');//
  Zoom.Items.Add('60');//
  Zoom.Items.Add('-1');// без синхронизации по времени
  Zoom.ItemIndex := 0;
  SpeedZoom := 1;
  TimeStart.Time := Time; DateStart.MaxDate := Date; DateStart.MinDate := Date - ArcMaxOldTime; DateStart.Date := Date;
  TimeEnd.Time := Time; DateEnd.MaxDate := Date; DateEnd.MinDate := Date - ArcMaxOldTime; DateEnd.Date := Date;
  BtnOpen.Enabled := true; BtnStart.Enabled := false; BtnStop.Enabled := false; BtnStep.Enabled := false; BtnPrev.Enabled := false; Path.ReadOnly := false;
end;

//========================================================================================
//----------------------------------------------------------------- Начать просмотр архива
procedure TDirectFormDlg.BtnOpenClick(Sender: TObject);
var
  dtn,dte : Double;
  i,hf : integer;
  len,hlen , rlen : cardinal;
begin
  arhiv := ''; //-------------------------------------------------- сбросить текущий архив
  dtn := DateStart.Date; dte := DateEnd.Date;
  if (Trunc(dte) - Trunc(dtn)) > 1 then
  begin
    ShowMessage('Длина запрашиваемого фрагмента превышает 2-е суток');
    exit;
  end;

  if (Trunc(dte) - Trunc(dtn)) < 0 then
  begin
    ShowMessage('Конец фрагмента определен не верно (предшествует началу фрагмента).');
    exit;
  end;

  DateTimeToString(fn,'yymmdd',dtn);
  fn := Path.Text+ '\'+ fn + '.ard';
  hf := CreateFile(pchar(fn),GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  hlen := 0;
  if hf > 0 then
  begin
    len := SetFilePointer(hf,0,@hlen,FILE_END);
    SetLength(cBuf,len);
    SetFilePointer(hf,0,@hlen,FILE_BEGIN);
    ReadFile(hf, cBuf[0], len, rlen, nil);
    for i := 0 to rlen-1 do arhiv := arhiv + cBuf[i];
    SetLength(cBuf,0);
    CloseHandle(hf);
  end else
  begin
    ShowMessage('Архив не найден'); exit;
  end;

  // найти начало фрагмента по времени
  DTFrameOffset := TimeStart.Time - Trunc(TimeStart.Time) + Trunc(DateStart.Date);
  LastTime := DTFrameOffset; DTFrameBegin := DTFrameOffset; StartTime := DTFrameOffset;

  //-------------- получить индекс символа, с которого начинается ближайшая реперная точка
  i := FindDateTimeFromArc(arhiv,DTFrameOffset,2);
  if i > 1 then
  begin
    hf := 1;
    while i <= Length(arhiv) do
    begin
      arhiv[hf] := arhiv[i]; inc(hf); inc(i);
    end;
    SetLength(arhiv,hf-1);
  end;

  // найти завершение архива по времени
  if Trunc(dtn) = Trunc(dte) then
  begin // фрагмент находится в одном файле целиком
    DTFrameOffset := TimeEnd.Time - Trunc(TimeEnd.Time) + Trunc(DateEnd.Date);
    i := FindDateTimeFromArc(arhiv,DTFrameOffset,1); // получить индекс символа, на котором заканчивается фрагмент
    if (i > 1) and (i < Length(arhiv)) then
      SetLength(arhiv,i);
  end else
  begin // фрагмент состоит из нескольких файлов
    DateTimeToString(fe,'yymmdd',dte);
    fe := Path.Text+ '\'+ fe + '.ard';
    hf := CreateFile(pchar(fe), GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    hlen := 0;
    if hf > 0 then
    begin
      len := SetFilePointer(hf,0,@hlen,FILE_END);
      SetLength(cBuf,len);
      SetFilePointer(hf,0,@hlen,FILE_BEGIN);
      ReadFile(hf, cBuf[0], len, rlen, nil);
      for i := 0 to rlen-1 do arhiv := arhiv + cBuf[i];
      SetLength(cBuf,0);
      CloseHandle(hf);
    end else
    begin
      ShowMessage('Архив не найден'); exit;
    end;
    DTFrameOffset := TimeEnd.Time - Trunc(TimeEnd.Time) + Trunc(DateEnd.Date);
    i := FindDateTimeFromArc(arhiv,DTFrameOffset,1); // получить индекс символа, на котором заканчивается фрагмент
    if (i > 1) and (i < Length(arhiv)) then
      SetLength(arhiv,i);
  end;

  EndTime := DTFrameOffset;

  ListNeisprav := ''; ListDiagnoz := '';
  FrameOffset := 1; // указатель в начало фрагмента

  while FrameOffset < Length(arhiv) do
  begin
    FrameOffset := ArcStep(FrameOffset);
    if TypeLastFrame < 11 then break;
  end;

  DTFrameOffset := TimeStart.Time - Trunc(TimeStart.Time) + Trunc(DateStart.Date);
  i := FindDateTimeFromArc(arhiv,DTFrameOffset,1);
  while (((FrameOffset < i) or (TypeLastFrame = 11)) and (FrameOffset < Length(arhiv))) do
    FrameOffset := ArcStep(FrameOffset);

  CurrentTime := DTFrameOffset; LastFixed := FrameOffset;
  edittime.ReadOnly := false; BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := true;
  ArcReady := true;
end;

procedure TDirectFormDlg.BtnStartClick(Sender: TObject);
begin
  edittime.ReadOnly := true; BtnOpen.Enabled := false; BtnStart.Enabled := false; BtnStop.Enabled := true; BtnStep.Enabled := false; BtnPrev.Enabled := false;
  NeedStep := true;
end;

procedure TDirectFormDlg.BtnStopClick(Sender: TObject);
begin
  edittime.ReadOnly := false;
  Region.SetFocus;
  BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := true;
  NeedStep := false;
end;

procedure TDirectFormDlg.BtnStepClick(Sender: TObject);
begin
  FrameOffset := ArcStep(FrameOffset);
  CurrentTime := DTFrameOffset;
  edittime.ReadOnly := false;
end;

procedure TDirectFormDlg.BtnPrevClick(Sender: TObject);
  var i,r,c, prevPtr, prevReper : integer;
begin
  if FrameOffset > 1 then
  begin
    // найти адрес предыдущей записи
    r := 1;
    PrevPtr := 1;
    for i := FrameOffset-1 downto 1 do
    begin
      if (arhiv[i] = #$ff) and (arhiv[i+1] = #0) and (arhiv[i+3] < #11) then
      begin
        c := byte(arhiv[i+2]);
        if (arhiv[i+3+c] = #$ff) and (arhiv[i+4+c] = #0) then
        begin
          if r < 1 then
          begin
            PrevPtr := i; break;
          end else
            dec(r);
        end;
      end;
    end;
    //
    if PrevPtr > 1 then
    begin
      // найти адрес предыдущей реперной точки
      prevReper := 1;
      for i := FrameOffset downto 1 do
      begin
        if (arhiv[i] = #$ff) and (arhiv[i+1] = #0) and (arhiv[i+3] = #11) then
        begin
          c := byte(arhiv[i+2]);
          if (arhiv[i+3+c] = #$ff) and (arhiv[i+4+c] = #0) then
          begin
            prevReper := i; break;
          end;
        end;
      end;
      // прокрутить до искомой точки
      FrameOffset := PrevReper;
      while FrameOffset <= PrevPtr do FrameOffset := ArcStep(FrameOffset);
      CurrentTime := DTFrameOffset;
      BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := true;
    end else
    begin // переместились в начало архива
      BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := false;
      FrameOffset := 1;
      while FrameOffset < Length(arhiv) do
      begin
        FrameOffset := ArcStep(FrameOffset);
        if TypeLastFrame < 11 then break;
      end;
      CurrentTime := DTFrameOffset;
    end;
    BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := true;
  end else
  begin // находимся в начале архива
    BtnOpen.Enabled := true; BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnPrev.Enabled := false;
  end;
  edittime.ReadOnly := false;
  NeedStep := false;
end;

var d,s,t,p : string;

procedure TDirectFormDlg.edittimeExit(Sender: TObject);
  var i,beg : integer; dy,mt,yr,hr,mn,sc : smallint; nd,nt,dt : TDateTime; wdy,wmt,wyr,whr,wmn,wsc : word;
begin
  s := edittime.Text;
  if s <> '' then
  begin // проверить введенную точку
    i := 1;
    while i < Length(s) do begin if s[i] = '.' then break else p := p + s[i]; inc(i); end; dy := StrToIntDef(p,0); inc(i); p := '';
    while i < Length(s) do begin if s[i] = '.' then break else p := p + s[i]; inc(i); end; mt := StrToIntDef(p,0); inc(i); p := '';
    while i < Length(s) do begin if s[i] = ' ' then break else p := p + s[i]; inc(i); end; yr := StrToIntDef(p,0); inc(i); p := '';
    while i < Length(s) do begin if s[i] = ':' then break else p := p + s[i]; inc(i); end; hr := StrToIntDef(p,-1); inc(i); p := '';
    while i < Length(s) do begin if s[i] = ':' then break else p := p + s[i]; inc(i); end; mn := StrToIntDef(p,-1); inc(i); p := '';
    while i <= Length(s) do begin if s[i] = ':' then break else p := p + s[i]; inc(i); end; sc := StrToIntDef(p,-1);
    if (dy > 0) and (mt > 0) and (yr > 0) and (hr > -1) and (mn > -1) and (sc > -1) then
    begin
      wdy := word(dy); wmt := word(mt); wyr := word(yr)+2000;
      if TryEncodeDate(wyr,wmt,wdy,nd) then
      begin
        whr := word(hr); wmn := word(mn); wsc := word(sc); if TryEncodeTime(whr,wmn,wsc,0,nt) then dt := nd+nt else exit;
      end else
        exit;
      FrameOffset := FindDateTimeFromArc(arhiv,dt,2);
      beg := FindDateTimeFromArc(arhiv,dt,1);
      while FrameOffset <= beg do FrameOffset := ArcStep(FrameOffset);
      CurrentTime := DTFrameOffset;
    end;
  end;
end;

procedure TDirectFormDlg.edittimeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN : begin
      BtnStart.Enabled := true; BtnStop.Enabled := false; BtnStep.Enabled := true; BtnStep.SetFocus;
    end;
  else
    inherited;
  end;
end;

procedure TDirectFormDlg.RegionChange(Sender: TObject);
  var i : integer;
begin
  i := Region.ItemIndex+1;
  if configRU[i].TabloSize.X = 0 then begin Region.ItemIndex := 0; i := 1; end;
  ChangeRegion(i);
end;

procedure TDirectFormDlg.ZoomChange(Sender: TObject);
begin
  try
    SpeedZoom := StrToFloat(Zoom.Text)-0.0001;
  except
    SpeedZoom := -1; Zoom.ItemIndex := 0;
  end;
  if SpeedZoom > 1000 then
  begin
    SpeedZoom := 999.999; Zoom.Text := FloatToStr(SpeedZoom);
  end;
end;
//========================================================================================
function FindDateTimeFromArc(s : string; dt : Double; FindMode : Byte) : integer;
var
  i,j : integer;
  DTime : Double;
begin
  result := -1;
  SoobCount := 0; //------------------------------------------- счетчик байтов в сообщении
  ReperAdr := -1;
  TimeSoob := 0;
  SoobAdr := -1;
  SoobBegin := false; //--------------- признак обнаружения 1-го байта заголовка сообщения
  SoobHdr := false;    //-------------------------------------- 2 байт заголовка сообщения
  SoobLen := false;    //------------------------------------------------------ байт длины
  SoobType := false;   //--------------------------------------------- байт типа сообщения
  SoobTime1 := false;  //-------------------------------------------------- 1 байт времени
  SoobTime2 := false;  //-------------------------------------------------- 2 байт времени
  SoobTime3 := false;  //-------------------------------------------------- 3 байт времени
  SoobTime4 := false;  //-------------------------------------------------- 4 байт времени
  d := ''; j := 0;
  for i := 1 to Length(s) do
  begin
    if not (SoobBegin or SoobHdr or SoobLen or SoobType or SoobTime1 or
    SoobTime2 or SoobTime3 or SoobTime4 or SoobCont) and (s[i] = #$ff) then
    begin //- если ранее не было никаких байт заголовка, и найден символ FF, то это начало
      SoobBegin := true;
      inc(SoobCount);
      j := 0;
    end;

    if SoobBegin then//если уже был обнаружен 1-ый байт заголовка, то значит найден второй
    begin
      SoobHdr := true;
      SoobBegin := false;
      SoobAdr := i;
    end else
    if SoobHdr then
    begin
      SoobLen := true;
      SoobHdr := false;
    end else
    if SoobLen then
    begin
      LenSoob := byte(s[i]);
      SoobType := true;
      SoobLen := false;
      inc(j);
    end else
    if SoobType then
    begin
      TypeSoob := byte(s[i]);
      SoobTime1 := true;
      SoobType := false;
      inc(j);
      case TypeSoob of
        11 : ReperAdr := SoobAdr; //--------- сохранить указатель на первую реперную точку
        12..32 : if ReperAdr < 1 then
        ReperAdr := SoobAdr; //----------- сохранить указатель на последнюю реперную точку
      end;
    end
    else
    if SoobTime1 then
    begin
      TimeSoob := byte(s[i]);
      SoobTime2 := true;
      SoobTime1 := false;
      inc(j);
    end
    else
    if SoobTime2 then
    begin
      TimeSoob := TimeSoob + byte(s[i]) * $100;
      SoobTime3 := true;
      SoobTime2 := false;
      inc(j);
    end
    else
    if SoobTime3 then
    begin
      TimeSoob := TimeSoob + byte(s[i]) * $10000;
      SoobTime4 := true;
      SoobTime3 := false;
      inc(j);
    end
    else
    if SoobTime4 then
    begin
      TimeSoob := TimeSoob + byte(s[i]) * $1000000;
      SoobCont := true;
      SoobTime4 := false;
      inc(j);
    end
    else
    if SoobCont then
    begin
      if j < LenSoob then inc(j) else
      begin //---------------------------------------------- сообщение прочитано полностью
        DTime := TimeSoob / 86400;
        case FindMode of
          1 :
          begin //------------------------------------------ поиск точки с указанной датой
            if DTime > dt then
            begin
              result := SoobAdr;
              exit;
            end;
          end;

          2 :
          begin //----------------------------------------- поиск ближайшей реперной точки
            if DTime > dt then
            begin
              result := ReperAdr;
              if result < 1 then result := SoobAdr;
              exit;
            end;
          end;
        end;
        //------------------------------------------------- переход к следующему сообщению
        SoobBegin := false; SoobHdr := false; SoobLen := false; SoobType := false;
        SoobTime1 := false; SoobTime2 := false; SoobTime3 := false; SoobTime4 := false;
        SoobCont := false;
        j := 0;
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------
// Поиск следующего шага при ошибке
function FindStep(index : Integer) : Integer;
  var i : integer; len : byte; cd : double;
begin
  result := index;
  if index > (Length(arhiv)-9) then begin result := Length(arhiv); exit; end;
  i := index;
  while i < (Length(arhiv)-9) do
  begin
    if (arhiv[i] = #$ff) and (arhiv[i+1] = #0) then
    begin
      len := byte(arhiv[i+2]);
      if (len >= 8) and (byte(arhiv[i+3]) > 0) then
      begin
        cd := (byte(arhiv[i+4])+byte(arhiv[i+5])*$100+byte(arhiv[i+6])*$10000+byte(arhiv[i+7])*$1000000) / 86400;
        if (cd > StartTime) and (cd < EndTime) then
        begin
          if (i+len+1) > Length(arhiv) then begin result := Length(arhiv); exit; end;
          if arhiv[i+len+3] = #$ff then begin result := i; break; end;
        end;
      end;
    end;
    inc(i);
  end;
end;

//------------------------------------------------------------------------------
// Проверить готовность данных для шага синхронизированной прокрутки архива
function CheckSyncStep(index : Integer; ct : Double) : Boolean;
  var i,len : integer; dt : double; lt,c : cardinal;
begin
  i := index;
  if (i+3) > Length(arhiv) then
  begin // архив закончился
    DirectFormDlg.edittime.ReadOnly := false; DirectFormDlg.Region.SetFocus; DirectFormDlg.BtnOpen.Enabled := true;
    DirectFormDlg.BtnStart.Enabled := true; DirectFormDlg.BtnStop.Enabled := false; DirectFormDlg.BtnStep.Enabled := true;
    DirectFormDlg.BtnPrev.Enabled := true; NeedStep := false; result := false; exit;
  end;
  if arhiv[i] <> #$ff then
  begin
    NeedStep := false;
    ShowMessage('ошибка при распаковке архива');
    result := false;
    exit;
  end;
  inc(i);
  if arhiv[i] <> #0 then
  begin
    NeedStep := false;
    ShowMessage('ошибка при распаковке архива');
    result := false; exit;
  end;
  inc(i);
  len := byte(arhiv[i]);
  inc(i);
  if (i+len) > Length(arhiv) then
  begin // архив закончился
    DirectFormDlg.edittime.ReadOnly := false; DirectFormDlg.Region.SetFocus; DirectFormDlg.BtnOpen.Enabled := true;
    DirectFormDlg.BtnStart.Enabled := true; DirectFormDlg.BtnStop.Enabled  := false; DirectFormDlg.BtnStep.Enabled := true;
    DirectFormDlg.BtnPrev.Enabled := true; NeedStep := false; result := false; exit;
  end;
  if arhiv[i+len] <> #$ff then
  begin
    NeedStep := false;
    ShowMessage('ошибка при распаковке архива');
    result := false;
    exit;
  end;
  inc(i);
  lt := byte(arhiv[i]); inc(i); c := byte(arhiv[i]) * $100; inc(i); lt := lt + c; c := byte(arhiv[i]) * $10000; inc(i); lt := lt + c; c := byte(arhiv[i]) * $1000000;
  lt := lt + c; dt := lt / (60*60*24);// время фрагмента
  result := (dt <= ct);
end;

//========================================================================================
//------------------------------------------------------------------ Сделать шаг по архиву
function ArcStep(index : Integer) : Integer;
var
  len,p,step : byte;
  i,j,ifr,cmd,imsg : integer;
  f4 : boolean;
  lt,c : cardinal;
  w : word;
begin
  if index > (Length(arhiv)-10) then
  begin
    NeedStep := false;
    ShowMessage('Конец фрагмента архива');
    result := Length(arhiv);
    exit;
  end;

  i := index;
  if arhiv[i] <> #$ff then
  begin
    NeedStep := false;
    ShowMessage('ошибка при распаковке архива');
    while(arhiv[i]<>#$ff) do
    begin
      inc(i);
    end;
    result := FindStep(i);
    exit;
  end;
  inc(i);
  if arhiv[i] <> #0 then
  begin
    NeedStep := false;
    ShowMessage('ошибка при распаковке архива');
    result := FindStep(index);
    exit;
  end;
  inc(i);

  len := byte(arhiv[i]); inc(i); j := 0;

  TypeLastFrame := byte(arhiv[i]); inc(i); inc(j);

  lt := byte(arhiv[i]); inc(i);     inc(j);
  c := byte(arhiv[i]) * $100;       inc(i);   inc(j);   lt := lt + c;
  c := byte(arhiv[i]) * $10000;     inc(i);   inc(j);   lt := lt + c;
  c := byte(arhiv[i]) * $1000000;   inc(i);   inc(j);   lt := lt + c;
  DTFrameOffset := lt / (60*60*24); //------------------------------------ время фрагмента
  DateTimeToString(s,'dd.mm.yy hh:nn:ss',DTFrameOffset);

  DirectFormDlg.edittime.Text := s;

  case TypeLastFrame of //------------------------------------- переключение по типу кадра
    1,2,3,4,5,6 :   begin step := 1; ifr := 0; f4 := false; imsg := 0;  end;

    //----------------------------------- определить начальный адрес записи реперной точки
    11..42 : begin  ifr := 125*(TypeLastFrame-11)+1; f4:=false; step:=0; imsg:=0; end;

    else ifr := 0; f4 := false; step := 0; imsg := 0;
  end;

  while j < len do //-------------------------------------------- работать до конца архива
  begin
    case TypeLastFrame of
      1,2 : //------------------------------------------------------------- распаковать ТС
      begin
        if TypeLastFrame = 1 then MySync[1] := true;
        if TypeLastFrame = 2 then MySync[2] := true;
        case step of
          1 : ifr := byte(arhiv[i]);
          2 : ifr := ifr + byte(arhiv[i]) * $100;
          else
            if (ifr > 0) and (ifr < 4096) then FR3[ifr] := byte(arhiv[i])
            else
              if (ifr >= 4096) and (ifr < 5120) then
              begin
                ifr := ifr - 4095;
                FR6[ifr] := byte(arhiv[i]); inc(j); inc(i);
                FR6[ifr] := FR6[ifr] + byte(arhiv[i]) * $100;
              end
              else
              if (ifr >= 5120) and (ifr < 6144) then
              begin
                ifr := ifr - 5119;
                FR7[ifr] := byte(arhiv[i]); inc(j); inc(i);
                FR7[ifr] := FR7[ifr] + byte(arhiv[i]) * $100; inc(j); inc(i);
                FR7[ifr] := FR7[ifr] + byte(arhiv[i]) * $10000; inc(j); inc(i);
                FR7[ifr] := FR7[ifr] + byte(arhiv[i]) * $1000000;
              end
              else
              if (ifr >= 6144) and (ifr < 7168) then
              begin
                ifr := ifr - 6143;
                FR8[ifr] := byte(arhiv[i]); inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $100; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $10000; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $1000000; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $100000000; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $10000000000; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $1000000000000; inc(j); inc(i);
                FR8[ifr] := FR8[ifr] + byte(arhiv[i]) * $100000000000000;
              end
              else
              if (ifr >= 7168) and (ifr < 8191) then
              begin  //-------------------------------------------------------------??????
              end
              else
              if (ifr and $e000) = $2000 then
              begin //-------------------------- коды диагностики состояния объектов (FR5)
                w := ifr and $1fff;
                if (w > 0) and (w < 4096) then
                begin
                  FR5[w] := FR5[w] or byte(arhiv[i]);
                end;
              end else
              if (ifr and $e000) = $4000 then
              begin //------------------------------- квитанция на команду, причина отказа
                w := ifr and $1fff;
                if (w > 0) and (w < 4096) then
                begin //-------------------------------------------------------???????????
                end;
              end
              else
              if (ifr and $e000) = $8000 then
              begin //---------------------------------------------------------------- FR4
                w := ifr and $1fff;
                if (w > 0) and (w < 4096) then
                begin
                  FR4[w] := byte(arhiv[i]);
                  FR4s[w] := DTFrameOffset;
                end;
              end;
              step := 0; ifr := 0; imsg := 0;
            end;
            inc(step);
          end;

          3,4 :
          begin
            cmd := byte(arhiv[i]); inc(i); inc(j);
            ifr := byte(arhiv[i]); inc(i); inc(j);
            ifr := ifr + byte(arhiv[i]) * $100;
            case cmd of
              cmdfr3_ustanovkastrelok,
              cmdfr3_povtormarhmanevr,
              cmdfr3_povtormarhpoezd,
              cmdfr3_marshrutlogic,
              cmdfr3_marshrutmanevr,
              cmdfr3_marshrutpoezd :  begin i := i+ 7; j := j+ 7; end;

              cmdfr3_autodatetime,
              cmdfr3_newdatetime :    begin i := i+ 6; j := j+ 6; end;
            end;

            CmdMsg(cmd,ifr,i);
          end;

      5 :
      begin
        ifr := byte(arhiv[i]); inc(i); inc(j);
        ifr := ifr + byte(arhiv[i]) * $100; inc(i); inc(j);
        imsg := byte(arhiv[i]); inc(i); inc(j);
        imsg := imsg + byte(arhiv[i]) * $100;
        if ifr >= $8000 then
        begin //------------------------------ распаковать протокол действий дежурного
          ifr := ifr and $7fff;
          if ifr = 0 then
          begin //----------------------- прямые команды оператора (без подтверждения)
            if imsg = 0 then s := 'Сброс команды <Esc>,<Пробел>' else s := '';
            if LastFixed < i then
            begin //---------------------------------------- добавить в список сообщений
              DateTimeToString(t,'dd-mm-yy hh:nn:ss', DTFrameOffset);
              s := t + ' > '+ s;
              ListNeisprav := s + #13#10 + ListNeisprav;
              NewNeisprav := true;
            end;
          end else
          if ifr <= High(ObjUprav) then
          begin
            ID_Obj := ObjUprav[ifr].IndexObj;
            CreateDspMenu(imsg,i,0);
          end;
        end else
        begin //------------------------------------ подтверждение команды или выдача ТУ
          CmdMsg(imsg,ifr,i);
        end;
      end;

      6 :
      begin //------------------------------------------- Распаковка текстовых сообщений
        case step of
          1 : ifr := byte(arhiv[i]);
          2 : ifr := ifr + byte(arhiv[i]) * $100;
          3 : imsg := byte(arhiv[i]);
          else
            imsg := imsg + byte(arhiv[i]) * $100;
            ArcMsg(ifr,imsg,i);
            step := 0; ifr := 0; imsg := 0;
        end;
        inc(step);
      end;

      11..42 :
      begin //----------------------------------------------- распаковка реперной записи
        p := byte(arhiv[i]);
        if f4 then begin FR4[ifr] := p; inc(ifr); f4 := false; end
        else begin FR3[ifr] := p; f4 := true; end;
      end;
    end;
    inc(j); inc(i);
  end;
  result := i;
  if LastFixed < i then LastFixed := i;
end;
//========================================================================================
procedure TDirectFormDlg.PathExit(Sender: TObject);
begin
  config.arcpath := Path.Text;
end;

procedure TDirectFormDlg.Button1Click(Sender: TObject);
  var cErr : integer;
begin
  OpenDialog.InitialDir := config.arcpath;
  if OpenDialog.Execute then
  begin
    s := 'arj.exe a a:\arcshn.arj '+ OpenDialog.FileName;
    cErr := WinExec(pchar(s),SW_SHOW);
    if cErr <= 31 then
    begin
      Beep; ShowMessage('Копирование архива НЕ ВЫПОЛНЕНО!');
    end;
  end;
end;

end.

