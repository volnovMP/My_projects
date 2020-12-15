unit TabloSHN;

{$UNDEF TEST}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ImgList, StdCtrls, ComCtrls, Registry, Menus, MMSystem;

type
  TTabloMain = class(TForm)
    ImageList: TImageList;
    MainTimer: TTimer;
    ImageListRU: TImageList;
    ImageList32: TImageList;
    ImageList16: TImageList;
    PaintBox1: TPaintBox;
    PopupMenu: TPopupMenu;
    pmmSoob: TMenuItem;
    N2: TMenuItem;
    pmmRU1: TMenuItem;
    pmmRU2: TMenuItem;
    OpenDialog: TOpenDialog;
    pmmRU3: TMenuItem;
    pmmObjList: TMenuItem;
    SaveDialog: TSaveDialog;
    TimerView: TTimer;
    N1: TMenuItem;
    pmPhoto: TMenuItem;
    pmArxiv: TMenuItem;
    ilClock: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure DrawTablo(tablo: TBitmap);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure FormActivate(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DspPopupHandler(Sender: TObject);
    procedure pmmSoobClick(Sender: TObject);
    procedure pmmRU1Click(Sender: TObject);
    procedure pmmRU2Click(Sender: TObject);
    procedure pmmObjListClick(Sender: TObject);
    procedure TimerViewTimer(Sender: TObject);
    procedure pmNotifyClick(Sender: TObject);
    procedure pmPhotoClick(Sender: TObject);
    procedure pmArxivClick(Sender: TObject);
//    procedure DCTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    function RefreshTablo : Boolean; // ���������� ������ �����
    procedure SaveArcToFloppy;       // ��������� ����� ������ �� �������
    procedure SaveTablo;             // ��������� ������� ��������� �����
  public
    PopupMenuCmd  : TPopupMenu;
    TmpTablo : TBitmap;
  end;

var
  TabloMain: TTabloMain;
  Sound : Boolean;
  LastX : SmallInt;
  LastY : SmallInt;
  lock_maintimer : boolean; //---------- ���������� ��������� ����� �������� ������� �����
  RefreshTimeOut : Double;  //-------- ������������ ����� �������� ������������� �� ������
  StartTime      : Double;  //-------------------------------------- ����� ������� �������
  LastReper      : Double;  //����� ���������� ���������� 10-�� ��������� ������ ���������
  TimeLockCmdDsp : Double;  //------------------ ����� ������������ �������� ������ ������
  IsCloseRMDSP   : Boolean;
  AppStart       : Boolean;
  SendToSrvCloseRMDSP : Boolean;

  shiftxscr : integer; //-------------------------------------------------- ����� ��������
  shiftyscr : integer; //-------------------------------------------------- ����� ��������

procedure ChangeRegion(RU : Byte); //---------------------------- ����� ������ �����������
procedure ResetCommands;       //------------------------------ ����� ���� �������� ������

const
  CurTablo1   = 1;
  MigInterval : double = 0.5;

  ReportFileName = 'Shn.rpt';
  KeyName           : string = '\Software\SHNRPCTUMS';
  KeyRegMainForm    : string = '\Software\SHNRPCTUMS\MainForm';
  KeyRegMsgForm     : string = '\Software\SHNRPCTUMS\MsgForm';
  KeyRegValListForm : string = '\Software\SHNRPCTUMS\ListForm';
  KeyRegViewObjForm : string = '\Software\SHNRPCTUMS\ObjForm';
  KeyRegNotifyForm  : string = '\Software\SHNRPCTUMS\NotifyForm';


//-------------------------------------------------------------- ��������������� ���������
procedure PresetObjParams;
procedure Plakat(X,Y : integer);

implementation

uses
  TypeALL,
  Load,
  KanalArmSrvSHN,
//  KanalArmDc,
  Objsost,
  Commands,
  MainLoop,
  CMenu,
  Commons,
  ValueList,
  MsgForm,
  Password,
  ViewFr,
  ViewObj,
//  Notify,
  Clock;

{$R *.DFM}

var
  s,cok : string;
  dMigTablo : Double; // ���������� ��� ������������ ��������� �������� ��������� �����

procedure TTabloMain.FormDestroy(Sender: TObject);
begin
  try
    NotifyWav.Destroy; 
    DestroyKanalSrv;
    if Assigned(Tablo1) then Tablo1.Free;
    if Assigned(Tablo2) then Tablo2.Free;
    if Assigned(ObjectWav) then ObjectWav.Free;
    if Assigned(IpWav) then IpWav.Free;
//    ResetEvent(hWaitKanal);
//    CloseHandle(hWaitKanal);
    Sleep(500);
    reportf('���������� ������ ���������'+ DateTimeToStr(Date+Time));
  except
    reportf('������ FormDestroy '+ DateTimeToStr(Date+Time));
  end;
end;
//========================================================================================
procedure TTabloMain.FormCreate(Sender: TObject);
var
  err: boolean;
  i,h : integer;
  sr : TSearchRec;
begin //------------------------------ ������� ������ ������� ��� ��������� ������� ������
{$IFDEF USEC}
  Caption := '��������� USEC - �������� ������� � �������� �������';
{$ENDIF}  
  LockTablo := false;

  IsCloseRMDSP := false;
  SendToSrvCloseRMDSP := false;


  reg := TRegistry.Create; //-------------------------------- ������ ��� ������� � �������
  reg.RootKey := HKEY_LOCAL_MACHINE;

  if FileExists(ReportFileName) then
  begin
    h := FileOpen(ReportFileName,fmOpenRead); //------------ ��������� ���������� ��������
    if h > 0 then
    begin
      i := FileSeek(h,0,2);
      FileClose(h);
      if i > 99999 then DeleteFile(ReportFileName);
    end;
  end;
  DateTimeToString(s, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
  reportf('@');
  reportf('������ ������ ��������� '+ s);

  PopupMenuCmd := TPopupMenu.Create(self);
  PopupMenuCmd.AutoPopup := false;
  err := false;
  cok := '';
  if Reg.OpenKey(KeyName, false) then
  begin
    if reg.ValueExists('databasepath') then database    := reg.ReadString('databasepath')
    else begin err := true; reportf('��� ����� "databasepath"'); end;

    if reg.ValueExists('path')         then config.path := reg.ReadString('path')
    else begin err := true; reportf('��� ����� "path"'); end;

    if reg.ValueExists('arcpath')      then config.arcpath := reg.ReadString('arcpath')
    else begin err := true; reportf('��� ����� "arcpath"'); end;

    if reg.ValueExists('ru')           then config.ru   := reg.ReadInteger('ru')
    else begin err := true; reportf('��� ����� "ru"'); end;

    if reg.ValueExists('RMID')         then config.RMID := reg.ReadInteger('RMID')
    else begin err := true; reportf('��� ����� "RMID"'); end;

    if reg.ValueExists('configkanal')  then s := reg.ReadString('configkanal')
    else begin err := true; reportf('��� ����� "configkanal"'); end;
    KanalSrv[1].config := s; KanalSrv[2].config := s;

    if reg.ValueExists('namepipein') then KanalSrv[1].nPipe:= reg.ReadString('namepipein')
    else s := '';

    if reg.ValueExists('namepipeout') then KanalSrv[2].nPipe := reg.ReadString('namepipeout')
    else s := '';

    if (KanalSrv[1].nPipe = '') and (KanalSrv[2].nPipe = '')
    then KanalType := 0 else
      if (KanalSrv[1].nPipe <> '') and (KanalSrv[2].nPipe <> '')
      then KanalType := 1 else
        begin err := true; reportf('������� ��������� ��� ������ ����� � ��������'); end;

    if reg.ValueExists('AnsverTimeOut')
    then AnsverTimeOut := reg.ReadDateTime('AnsverTimeOut')
    else begin err := true; reportf('��� ����� "AnsverTimeOut"'); end;

    if reg.ValueExists('RefreshTimeOut')
    then RefreshTimeOut := reg.ReadDateTime('RefreshTimeOut')
    else begin err := true; reportf('��� ����� "RefreshTimeOut"'); end;

    if reg.ValueExists('TimeOutRdy')
    then MaxTimeOutRecave := reg.ReadDateTime('TimeOutRdy')
    else begin err := true; reportf('��� ����� "TimeOutRdy"'); end;

    if reg.ValueExists('kanal1') then
    begin
      i := reg.ReadInteger('kanal1');
      if i = 0 then reportf('�������� ����� ������ � ��������� ��������.');
      KanalSrv[1].Index := i;
    end else
    begin KanalSrv[1].Index := 0; err := true; reportf('��� ����� "kanal1"'); end;

    if reg.ValueExists('kanal2') then
    begin
      i := reg.ReadInteger('kanal2');
      if i = 0 then reportf('��������� ����� ������ � ��������� ��������.');
      KanalSrv[2].Index := i;
    end else
    begin KanalSrv[2].Index := 0; err := true; reportf('��� ����� "kanal2"'); end;
    reg.CloseKey;

    if not FileExists(database) then
    begin err := true; reportf('���� ������������ ���� ������ ������� �� ������.'); end;
  end else
  begin
    reg.Destroy;
    reportf('��� ����� "SHNRPCTUMS"');
    ShowMessage('���������� ������. ���������� ������ ������������� ���������. �������� �������� ������ � ����� shn.rpt');
    Application.Terminate;
  end;
  Left := 0; Top := 0;
  mem_page := false;

  CreateKanalSrv;
  InitKanalSrv(1);

  Tablo1 := TBitmap.Create;
  Tablo2 := TBitmap.Create;
  ImageList.BkColor := bkgndcolor;
  ilClock.BkColor := bkgndcolor;
  ImageListRU.BkColor := bkgndcolor;


  screen.Cursors[curTablo1]   := LoadCursor(HInstance, IDC_ARROW);

  // �������� ��� ������ ����
  DspMenu.Ready := false; DspMenu.WC := false; DspMenu.obj := -1;

  StartObj := 1;
  DiagnozON := true;
//  CurrDCSoob := 1;

  // �������� ������ �������� ������ ��� ����������� ������� �� ����� %armshn%\media\wav\*.wav
  NotifyWav := TStringList.Create;
  if FindFirst(config.path+'media\wav\*.wav',faAnyFile,sr) = 0 then
  begin
    repeat
      NotifyWav.Add(config.path+'media\wav\'+sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  IpWav := TStringList.Create;
  IpWav.Add(config.path+'media\ip1.wav');
  IpWav.Add(config.path+'media\ip2.wav');
  ObjectWav := TStringList.Create;
  ObjectWav.Add(config.path+'media\sound1.wav');
  ObjectWav.Add(config.path+'media\sound2.wav');
  ObjectWav.Add(config.path+'media\sound3.wav');
  ObjectWav.Add(config.path+'media\sound4.wav');
  ObjectWav.Add(config.path+'media\sound5.wav');
  ObjectWav.Add(config.path+'media\sound6.wav');

  // �������� ���� ������
  if not LoadBase(database) then err := true;
  if configRU[1].Tablo_Size.X > 0 then pmmRU1.Visible := true else pmmRU1.Visible := false;
  if configRU[2].Tablo_Size.X > 0 then pmmRU2.Visible := true else pmmRU2.Visible := false;
  if configRU[3].Tablo_Size.X > 0 then pmmRU3.Visible := true else pmmRU3.Visible := false;


  // �������� ������� ���� ����������� �����
  if Reg.OpenKey(KeyRegMainForm, true) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    if reg.ValueExists('width') then Width := reg.ReadInteger('width') else Width := Screen.Width;
    if reg.ValueExists('height')  then Height  := reg.ReadInteger('height')  else
    begin
      i := Screen.Height;
      if Screen.Height < (configRU[config.ru].Tablo_Size.Y+50)
      then Height := i
      else Height := configRU[config.ru].Tablo_Size.Y+50;
    end;
    reg.CloseKey;
  end;

  SetParamTablo;
  // �������� �������� ��������� ��-���
  if not LoadLex(config.path + 'LEX.SDB') then err := true;
  if not LoadLex2(config.path + 'LEX2.SDB') then err := true;
  if not LoadLex3(config.path + 'LEX3.SDB') then err := true;
  if not LoadMsg(config.path + 'MSG.SDB') then err := true;
//  if not LoadLinkFR(config.path + 'FR3.SDB') then err := true;
 // if not LoadLinkDC(config.path + 'DC.SDB') then err := true;
  // �������� ��������� ����
  if not LoadAKNR(config.path + 'AKNR.SDB') then err := true;
  LoadDiagnoze(config.arcpath+ '\stat.ini'); // ��������� ����������
  GetMYTHX;

  StateRU          := 0; // �������� ��������� ��� � ��������
  WorkMode.RazdUpr := false;
  WorkMode.MarhUpr := true;
  WorkMode.MarhOtm := false;
  WorkMode.VspStr  := false;
  WorkMode.InpOgr  := false;
  WorkMode.OtvKom  := false;
  WorkMode.Podsvet := false;
  WorkMode.GoTracert  := false;
  WorkMode.GoOtvKom   := false;
  WorkMode.GoMaketSt  := false;
  WorkMode.Upravlenie := false;
  WorkMode.LockCmd    := true;
  hWaitKanal := CreateEvent(nil,false,false,nil);
  reg.Destroy;
  if err then
  begin
    ShowMessage('���������� ������ ��-�� ����������� ������ ��� ������������� ���������.');
    Application.Terminate;
  end;
  AppStart := true;
end;

//------------------------------------------------------------------------------
// ����������� �����
procedure TTabloMain.FormActivate(Sender: TObject);
begin
  if not AppStart then exit;
  AppStart := false;

  PresetObjParams;     // ���������� ��������� �������� ������������ � �������� ���������
  Cursor := curTablo1;
  DrawTablo(Tablo1);
  DrawTablo(Tablo2);

  ConnectKanalSrv(1);

  MainTimer.Enabled := true;
  LastRcv := Date+Time;
  StartRM := true;           // ��������� ��������� ������ �������
  CmdSendT := Date + Time;   // ������ ������ ������� ����� ������� ����������� ����������
  StartTime := CmdSendT;     // ������ ������� ��-���
  LastReper := Date + Time;  // ������ ������ 10-�� �������� ������� ���������
  LockTablo := false;

  ClockForm.Show; // ������� ���� � ������
end;

//========================================================================================
//-------- ��������� ���������� � ������� � ��������������� �������� ����� ��������� �����
procedure TTabloMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//var  ec : cardinal;
begin
  try
    if IsCloseRMDSP then
    begin //--------------------------------- �������� ���������� ���������� ������ ��-���
      DisconnectKanalSrv(1);
      TimerView.Enabled := false;
    end
    else
    if not SendToSrvCloseRMDSP then //---------------- ���� ������� �� ����������� �������
    begin
      ShowWindow(Application.Handle,SW_SHOW);//�������������� � ���������� ���� ����������
      if PasswordDlg.ShowModal = mrOk then
      begin
        InsArcNewMsg(0,89,7); //--------------------- "��������� ���������� ������ �� ���"
        TabloMain.Canvas.Font.Size := 20;
        TabloMain.Canvas.Font.Color := clRed;
        TabloMain.Canvas.Font.Style := [fsBold];
        TabloMain.Canvas.TextOut(100,100,'��������� ��������� ���� ������');
        Sleep(1000);
        SendCommandToSrv(WorkMode.DirectStateSoob,cmdfr3_logoff,0);  //- ���������� ������
        CmdCnt := 1;
        SendToSrvCloseRMDSP := true; //----- ��������� �������� �������� � ��������� �����
      end;
      ShowWindow(Application.Handle,SW_HIDE);
    end;
    CanClose := false;
  except
    reportf('������ [FormClose]');
  end;
end;
//========================================================================================
procedure TTabloMain.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if not mem_page
  then PaintBox1.Canvas.Draw(0,0,tablo2)
  else PaintBox1.Canvas.Draw(0,0,tablo1);
end;

//========================================================================================
//---------------------------------------------- ���������� �� ������ ��������� ����������
procedure TTabloMain.FormPaint(Sender: TObject);
var
  shiftx,shifty,x,y,i : integer;
begin
  shiftx := HorzScrollBar.Position;
  shifty := VertScrollBar.Position;
  VertScrollBar.Range := Tablo1.Height;
  HorzScrollBar.Range := Tablo1.Width;

    x := configRU[config.ru].MonSize.X;
    if configRU[config.ru].Tablo_Size.X < x
    then x := configRU[config.ru].Tablo_Size.X;
    y := configRU[config.ru].Tablo_Size.Y;
    for i := 1 to High(shortmsg) do
    begin
      canvas.Brush.Style := bsSolid;
      canvas.Font.Style := [];
      if shortmsg[i] <> '' then
      begin
        //---------------------------------------------------- ������� �������� ���������
        canvas.Brush.Color := shortmsgcolor[i];
        canvas.FillRect(rect((i-1)*X, Y-15, i*X-32, Y));
        canvas.Font.Color  := clBlack;
        TekFontSize := canvas.Font.Size;
        canvas.Font.Size := 10;
        canvas.TextOut((i-1)*X+3, Y-15,shortmsg[i]);//-------------------- ����� ���������
        canvas.Brush.Color := clWhite; canvas.FillRect(rect(i*X-32, Y-15, i*X-16, Y));
        canvas.Brush.Color := clRed; canvas.FillRect(rect(i*X-31, Y-14, i*X-27, Y-1));
        canvas.Brush.Color := clGreen; canvas.FillRect(rect(i*X-26, Y-14, i*X-22, Y-1));
        canvas.Brush.Color := clBlue; canvas.FillRect(rect(i*X-21, Y-14, i*X-17, Y-1));
        canvas.Font.Size := TekFontSize;
        if (ObjHintIndex > 0) and ((LastTime - LastMove) < (30/86400)) then
        begin ImageList16.Draw(canvas,i*X-16, Y-15,1); end
        else
        if ShowWarning then
        begin
          if tab_page then ImageList16.Draw(canvas,i*X-16, Y-15,5)
          else ImageList16.Draw(canvas,i*X-16, Y-15,0);
        end;
      end else
      begin
        canvas.Brush.Color := bkgndcolor; canvas.FillRect(rect((i-1)*X, Y-15, i*X-32, Y));
        canvas.Brush.Color := clWhite; canvas.FillRect(rect(i*X-32, Y-15, i*X-16, Y));
        canvas.Brush.Color := clRed; canvas.FillRect(rect(i*X-31, Y-14, i*X-27, Y-1));
        canvas.Brush.Color := clGreen; canvas.FillRect(rect(i*X-26, Y-14, i*X-22, Y-1));
        canvas.Brush.Color := clBlue; canvas.FillRect(rect(i*X-21, Y-14, i*X-17, Y-1));
      end;
    end;



  // ���������� ������ �� ��������
  if (cur_obj > 0) and (ObjUprav[cur_obj].MenuID > 0) then
    with canvas do
    begin
      Pen.Color := clRed; Pen.Mode := pmCopy; Pen.Width := 1;
      MoveTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Top-shifty);  // ��������� !!!
      LineTo(ObjUprav[cur_obj].Box.Right-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftx, ObjUprav[cur_obj].Box.Bottom-shifty);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Bottom-shifty);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
    end;
  Canvas.Brush.Color := bkgndcolor;
  if tablo1.Width < TabloMain.ClientWidth then
  canvas.FillRect(rect(tablo1.width, 0, TabloMain.width, TabloMain.height));

  if tablo1.Height < TabloMain.ClientHeight then
  canvas.FillRect(rect(0, tablo1.height, tablo1.width, TabloMain.height));
end;

procedure TTabloMain.DrawTablo(tablo: TBitmap);
  var i,x,c : integer;
begin
  Tablo.Canvas.Lock;
  Tablo.Canvas.Brush.Color := bkgndcolor;
  Tablo.canvas.FillRect(rect(0, 0, tablo.width, tablo.height));

  //--------------------------------------------------------- ���������� ����� �� ��������
  Tablo.Canvas.Pen.Color := armcolor8;
  Tablo.Canvas.Brush.Color := armcolor18;
  Tablo.Canvas.Pen.Style := psSolid;
  Tablo.Canvas.Pen.Width := 2;
  Tablo.Canvas.Rectangle(configRU[config.ru].BoxLeft,configRU[config.ru].BoxTop,
  configRU[config.ru].BoxLeft+12*20+7,configRU[config.ru].BoxTop+16);

  for i := 0 to 19 do
  begin
    x := 1 + i * 12;
    if i > 10 then x := x + 3;
    case i of
        1 : c := 14;  2 : c := 15;  3 : c := 16;  4 : c := 17;  5 : c := 18;
        6 : c := 19;  7 : c := 20;  8 : c := 21;  9 : c := 22; 10 : c := 23;
       11 : c := 4;  12 : c := 5;  13 : c := 6;  14 : c := 7;  15 : c := 8;
       16 : c := 9;  17 : c := 10; 18 : c := 11; 19 : c := 12;
    else
      c := 13;
    end;
    ImageList.Draw(Tablo.Canvas,configRU[config.ru].BoxLeft+x, configRU[config.ru].BoxTop+1,c, Stellaj[i+1]);
  end;


  //------------------------------------------------------------- ���������� ������ � ����
  for i := 1 to High(Ikonki) do
  begin
    if Ikonki[i,1] > 0 then
    ImageList.Draw(Tablo.Canvas,Ikonki[i,2],Ikonki[i,3],Ikonki[i,1],true);
  end;

  // �� �� ������ � �������� ������������� WinXP    ????????????????????????????
  // ���������� ����������� ��������� ��������: ????????????????????????????
  Tablo.Canvas.Brush.Style := bsClear;
  Tablo.Canvas.Font.Color := clRed;
  Tablo.Canvas.Font.Color := clBlack;
  // ����� ���������, ����������� ������ WinXP

  //------------------------------------------ ���������� ���� ������������ �������� �����
  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 0) then
    DisplayItemTablo(@ObjView[i], Tablo.Canvas);
  end;

  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 1) then
    DisplayItemTablo(@ObjView[i], Tablo.Canvas);
  end;

  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  begin
    if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 2) then
    DisplayItemTablo(@ObjView[i], Tablo.Canvas);
  end;

  Tablo.Canvas.UnLock;
end;

procedure TTabloMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  var i,shiftx,shifty,o: integer;
begin
  if PopupMenuCmd.PopupComponent <> nil then exit;
  LastMove := Date+Time;
  LastX := x; LastY := y;
  // ����� ������� ������������
  o := cur_obj; cur_obj := -1;
  for i := configRU[config.ru].OUmin to configRU[config.ru].OUmax do
  begin
    if (x >= ObjUprav[i].Box.Left) and (y >= ObjUprav[i].Box.Top) and (x <= ObjUprav[i].Box.Right) and (y <= ObjUprav[i].Box.Bottom) then
    begin
      cur_obj := i; ID_obj := ObjUprav[i].IndexObj; ID_menu := ObjUprav[i].MenuID; break;
    end;
  end;

  if o <> cur_obj then
  begin
    shiftx := HorzScrollBar.Position;
    shifty := VertScrollBar.Position;
    canvas.Pen.Width := 1;
    if o > 0 then
    with canvas do
    begin
      Pen.Color := bkgndcolor; Pen.Mode := pmCopy;
      MoveTo(ObjUprav[o].Box.Left-shiftx, ObjUprav[o].Box.Top-shifty);
      LineTo(ObjUprav[o].Box.Right-shiftx, ObjUprav[o].Box.Top-shifty);
      LineTo(ObjUprav[o].Box.Right-shiftx, ObjUprav[o].Box.Bottom-shifty);
      LineTo(ObjUprav[o].Box.Left-shiftx, ObjUprav[o].Box.Bottom-shifty);
      LineTo(ObjUprav[o].Box.Left-shiftx, ObjUprav[o].Box.Top-shifty);
    end;
    if (cur_obj > 0) and (ObjUprav[cur_obj].MenuID > 0) then
    with canvas do
    begin
      Pen.Color := clRed; Pen.Mode := pmCopy;
      MoveTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
      LineTo(ObjUprav[cur_obj].Box.Right-shiftx, ObjUprav[cur_obj].Box.Bottom-shifty);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Bottom-shifty);
      LineTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
    end else
    begin
      ID_obj := -1; ID_menu := -1;
    end;
  end;
end;

//------------------------------------------------------------------------------
// ��������� ������� ������ ������ � ����
procedure TTabloMain.DspPopupHandler(Sender: TObject);
  var i : integer;
begin
  with Sender as TMenuItem do begin
    for i := 1 to Length(DspMenu.Items) do
      if DspMenu.Items[i].ID = Command then
      begin
        DspCommand.Command := DspMenu.Items[i].Command;
        DspCommand.Obj := DspMenu.Items[i].Obj;
        DspCommand.Active  := true;
        SelectCommand;
        exit;
      end;
  end;
end;

procedure ResetCommands;
begin

  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspCommand.Active := false;
  DspMenu.obj := -1;
  WorkMode.GoTracert := false;
  WorkMode.GoMaketSt := false;
  WorkMode.GoOtvKom  := false;
  Workmode.MarhOtm   := false;
  Workmode.VspStr    := false;
  Workmode.InpOgr    := false;
  ResetShortMsg; // �������� ��� �������� ���������
end;

//------------------------------------------------------------------------------
// ������ � �������� �� �����
procedure Plakat(X,Y : integer);
  var i,j,dx : integer; uu : boolean;
begin
  uu := false;
  for j := 0 to 19 do
  begin
    dx := j * 12 + 1; if j > 10 then dx := dx + 3;
    if (X >= configRU[config.ru].BoxLeft+dx) and
       (Y >= configRU[config.ru].BoxTop) and
       (X < configRU[config.ru].BoxLeft+dx+12) and
       (Y < configRU[config.ru].BoxTop+13) then
    begin
      for i := 1 to 20 do if i <> (j+1) then stellaj[i] := false else stellaj[i] := not stellaj[i];
      uu := true;
    end;
  end;

  if not uu then
  begin
    // ����� ���� �������
    j := 0;
    for i := 1 to High(Stellaj) do if stellaj[i] then begin j := i; break; end;

    if j > 0 then
    begin // ���������� ������
      for i := 1 to High(Ikonki) do
      begin
        if Ikonki[i,1] = 0 then
        begin // ��������� ������ �� �����
          case j of
            1  : Ikonki[i,1] := 13;
            2  : Ikonki[i,1] := 14;
            3  : Ikonki[i,1] := 15;
            4  : Ikonki[i,1] := 16;
            5  : Ikonki[i,1] := 17;
            6  : Ikonki[i,1] := 18;
            7  : Ikonki[i,1] := 19;
            8  : Ikonki[i,1] := 20;
            9  : Ikonki[i,1] := 21;
            10 : Ikonki[i,1] := 22;
            11 : Ikonki[i,1] := 23;
            12 : Ikonki[i,1] := 4;
            13 : Ikonki[i,1] := 5;
            14 : Ikonki[i,1] := 6;
            15 : Ikonki[i,1] := 7;
            16 : Ikonki[i,1] := 8;
            17 : Ikonki[i,1] := 9;
            18 : Ikonki[i,1] := 10;
            19 : Ikonki[i,1] := 11;
            20 : Ikonki[i,1] := 12;
          end;
          Ikonki[i,2] := X; Ikonki[i,3] := Y; uu := true; break;
        end;
      end;
      if not uu then Beep;
    end else
    begin // ������ ������
      for i := High(Ikonki) downto 1 do
        if Ikonki[i,1] > 0 then
        begin
          if (Ikonki[i,2] <= X) and (Ikonki[i,2]+12 >= X) and (Ikonki[i,3] <= Y) and (Ikonki[i,3]+12 >= Y) then
          begin
            Ikonki[i,1] := 0; break;
          end;
        end;
    end;
    // ����� �� �����
    for i := 1 to High(Stellaj) do stellaj[i] := false;
  end;
end;

procedure ResetAllPlakat;
  var i : integer;
begin
  for i := 1 to High(Ikonki) do
  begin
    Ikonki[i,1] := 0; Ikonki[i,2] := 0; Ikonki[i,3] := 0;
  end;
end;

procedure TTabloMain.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if PopupMenuCmd.PopupComponent <> nil then exit;
  //ID_ViewObj := DspMenu.obj;
  if Button = mbLeft then
  begin
  // ������ ����� ������ �����
    if ID_menu < 1 then
    begin // ��������� �� ����� �� �����
      Plakat(X,Y);
    end else
    if CreateDspMenu(ID_menu,0,0) then
    UpdateKeyList(ID_ViewObj);
  end;
end;

//------------------------------------------------------------------------------
// ��������� ������� �� ����������
procedure TTabloMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  var shiftx,shifty : integer;
begin
  shiftx := HorzScrollBar.Position;
  shifty := VertScrollBar.Position;
  if PopupMenuCmd.PopupComponent <> nil then exit;
  case Key of

    VK_LEFT :
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Neighbour[1] > 0 then cur_obj := ObjUPrav[cur_obj].Neighbour[1];
      end else
        cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftx-2, ObjUPrav[cur_obj].Box.Bottom-shifty-2);
    end;

    VK_RIGHT :
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Neighbour[2] > 0 then cur_obj := ObjUPrav[cur_obj].Neighbour[2];
      end else
        cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftx-2, ObjUPrav[cur_obj].Box.Bottom-shifty-2);
    end;

    VK_UP :
    begin
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Neighbour[3] > 0 then cur_obj := ObjUPrav[cur_obj].Neighbour[3];
        end else
          cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftx-2, ObjUPrav[cur_obj].Box.Bottom-shifty-2);
      end;
    end;

    VK_DOWN :
    begin
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Neighbour[4] > 0 then cur_obj := ObjUPrav[cur_obj].Neighbour[4];
        end else
          cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shiftx-2, ObjUPrav[cur_obj].Box.Bottom-shifty-2);
      end;
    end;

    VK_RETURN :
    begin

    end;

    VK_F4 :
    begin
      if Shift = [] then
      SaveDiagnoze(config.arcpath+ '\stat.ini'); // ��������� ����������
    end;

    VK_F10 :
    begin
    end;

    VK_PRIOR :
    begin // �������� 1,2 �����
      case config.ru of
        2 : begin
          if configRU[1].Tablo_Size.X > 0 then
          begin
            pmmRU1.Checked := true; NewRegion := 1; ChRegion := true;
          end;
        end;
        3 : begin
          if configRU[2].Tablo_Size.X > 0 then
          begin
            pmmRU2.Checked := true; NewRegion := 2; ChRegion := true;
          end;
        end;
      end;
    end;

    VK_NEXT :
    begin // �������� 2,3 �����
      case config.ru of
        1 : begin
          if configRU[2].Tablo_Size.X > 0 then
          begin
            pmmRU2.Checked := true;
            NewRegion := 2;
            ChRegion := true;
          end;
        end;
        2 : begin
          if configRU[3].Tablo_Size.X > 0 then
          begin
            pmmRU3.Checked := true;
            NewRegion := 3;
            ChRegion := true;
          end;
        end;
      end;
    end;

    VK_INSERT :
    begin
      if Shift = [ssCtrl,ssShift] then
      begin // ������� �������� FR3,FR4
        FrForm.Show;
      end;
    end;
  else
    inherited;
  end;
end;

procedure TTabloMain.pmmSoobClick(Sender: TObject);
begin
  MsgFormDlg.Show;
end;

procedure TTabloMain.pmmRU1Click(Sender: TObject);
begin
  NewRegion := 1; ChRegion := true;
end;

procedure TTabloMain.pmmRU2Click(Sender: TObject);
begin
  NewRegion := 2; ChRegion := true;
end;

//========================================================================================
//------------------------------------------------------ ���������� �������� ������� �����
procedure TTabloMain.MainTimerTimer(Sender: TObject);
var
  st,i : integer;
begin
  try
    LastTime := Date+Time; //-------------------------- ������ ���������� ������ �� ������
    if dMigTablo < LastTime then
    begin //---------------------------------------------- ������������ �������� ���������
      tab_page := not tab_page;
      dMigTablo := LastTime + MigInterval/86400; //--------- ����������� ������� � �������
    end;

    if dMigTablo < LastTime then
    begin //---------------------------------------------- ������������ �������� ���������
      tab_page := not tab_page;
      dMigTablo := LastTime + MigInterval / 86400;
    end;

    SyncReady; //--------------- �������� ����� ������ � ������������� ������ ������-���
    if (not IsCloseRMDSP) and SendToSrvCloseRMDSP
    and ((CmdSendT + (3/86400)) <  LastTime) then
    begin
      IsCloseRMDSP := true;
      Application.Terminate;
      exit;
    end;
    if IsCloseRMDSP then
    begin
      MainTimer.Enabled := false;
      exit;
   end
   else MainTimer.Enabled := true;

    if LastTime - LastSync > RefreshTimeOut then //------------------- �������� 0,33 ���.
    begin
      try //------------------------------------------------------- ���� �������� �� �����
        //------------------------------- ���������� ��������� ������ �� ������ ���-������
        if KanalSrv[1].lastcnt < 70 then inc(KanalSrv[1].lostcnt)
        else KanalSrv[1].lostcnt := 0;
        if KanalSrv[1].lostcnt > 6 then
        begin
          KanalSrv[1].iserror := true;
          KanalSrv[1].lostcnt := 0;
        end;
        if KanalSrv[2].lastcnt < 70 then inc(KanalSrv[2].lostcnt)
        else KanalSrv[2].lostcnt := 0;
        if KanalSrv[2].lostcnt > 6 then
        begin
          KanalSrv[2].iserror := true;
          KanalSrv[2].lostcnt := 0;
        end;

        //------------------------------------------------------------- ����������� ������
        if not RefreshTablo then
        begin
          DateTimeToString(s, 'dd/mm/yy h:nn:ss.zzz', LastTime);
          reportf('���� ����������� ����� '+ s);
        end;

        //----------------------------- ��������� ��������� ������� � ������� ���� � �����
        if (NewFR[1] <> '') or (NewFR[2] <> '') then SaveArch(1);

        if LastReper + 600 / 86400 < LastTime then
        begin //--------------------------------- ��������� 10-�� �������� ����� ���������
          LastReper := LastTime;
          SaveArch(2);
        end;

        if (MsgFormDlg <> nil) and MsgFormDlg.Visible then
        begin
          if NewNeisprav then
          begin
            NewNeisprav := false;
            MsgFormDlg.BtnUpdate.Enabled := true;
            MsgFormDlg.TabSheet1.Highlighted := newListMessages;
            MsgFormDlg.TabSheet2.Highlighted := newListDiagnoz;
            MsgFormDlg.TabSheet3.Highlighted := newListNeisprav;
          end;

          if UpdateMsgQuery then
          begin
            MsgFormDlg.BtnUpdate.Enabled := false;
            UpdateMsgQuery := false;
            st := 1;
            i := 0;
            while st <= Length(ListMessages) do
            begin
              if ListMessages[st] = #10 then inc(i);
              if i < 700 then inc(st)
              else
              begin
                SetLength(ListMessages,st);
                break;
              end;
            end;

            MsgFormDlg.Memo.Lines.Text := ListMessages;
            st := 1;
            i := 0;

            while st <= Length(LstNN) do
            begin
              if LstNN[st] = #10 then inc(i);
              if i < 700 then inc(st)
              else
              begin
                SetLength(LstNN,st);
                break;
              end;
            end;
            MsgFormDlg.MemoNeispr.Lines.Text := LstNN;
            st := 1; i := 0;
            while st <= Length(ListDiagnoz) do
            begin
              if ListDiagnoz[st] = #10 then inc(i);
              if i < 700 then inc(st)
              else
              begin
                SetLength(ListDiagnoz,st);
                break;
              end;
            end;
            MsgFormDlg.MemoUVK.Lines.Text := ListDiagnoz;
          end;
        end;

        //--------------------------------------------------- ���������� ��������� �������
        if ChRegion then ChangeRegion(NewRegion);//- ��������� ��������� ������ ����������
        if Ip1Beep then
        begin
          PlaySound(PAnsiChar(IpWav.Strings[0]),0,SND_ASYNC);
          Ip1Beep := false
        end else
        if Ip2Beep then
        begin
          PlaySound(PAnsiChar(IpWav.Strings[1]),0,SND_ASYNC);
          Ip2Beep := false
        end else
        if SingleBeep  then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[0]),0,SND_ASYNC);
          SingleBeep := false
        end else
        if SingleBeep2 then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[1]),0,SND_ASYNC);
          SingleBeep2 := false
        end else
        if SingleBeep3 then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[2]),0,SND_ASYNC);
          SingleBeep3 := false
        end else
        if SingleBeep4 then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[3]),0,SND_ASYNC);
          SingleBeep4 := false
        end else
        if SingleBeep5 then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[4]),0,SND_ASYNC);
          SingleBeep5 := false
        end else
        if SingleBeep6 then
        begin
          PlaySound(PAnsiChar(ObjectWav.Strings[5]),0,SND_ASYNC);
          SingleBeep6 := false
        end;

        for i := 1 to 10 do
        begin //--------------------- ������������� ����� �������������� ������� (�������)
          if FixNotify[i].beep then
          PlaySound(PAnsiChar(NotifyWav.Strings[FixNotify[i].Sound]),0,SND_ASYNC);
          FixNotify[i].beep := false;
        end;

        MySync[1] := false; MySync[2] := false;

        if CmdCnt > 0 then
        begin //---------------------------------------------------- ����� ������ ��������
          if CmdSendT + (2/86400) < LastTime then
          if not IsCloseRMDSP then
          begin //--------------------------------------- ��������� ����� �������� �������
            CmdCnt := 0;
            WorkMode.CmdReady := false; //----------------------------------- ����� ������
            if not StartRM then AddFixMessage(GetShortMsg(1,296,'',0),4,0);
          end;
        end;

        if StartRM and (StartTime < LastTime - 10/86400) then
        begin //------------------------------------------------- ��������� ������ �������
          if (KanalSrv[1].issync or KanalSrv[2].issync)
          then StartRM := false;
        end;
        //--------------------------------------- ���������� ������� ������������� �������
        SetDateTimeARM(DateTimeSync);
      finally
        LockTablo := false;
      end;
    end;
  except
    reportf('������ [TabloSHN.MainTimerTimer]');
    Application.Terminate;
  end;
end;

procedure TTabloMain.N1Click(Sender: TObject);
begin

end;

//---------------------------------------------------------------------------
// ���������� ��������� ��������
procedure TTabloMain.TimerViewTimer(Sender: TObject);
begin
  if Assigned(ValueListDlg) then
  //if DspMenu.obj <> 0 then ID_ViewObj := DspMenu.obj;
  if ValueListDlg.Visible then UpdateValueList(ID_ViewObj); // ������� ��������� �������
end;

//----------------------------------------------------------------------------------------
//---------------------------------------------------------------- ���������� ������ �����
function TTabloMain.RefreshTablo : Boolean;
begin
  LastSync := LastTime;
  PrepareOZ;

  mem_page := not mem_page;

  if mem_page then DrawTablo(Tablo2) // ���������� �����2 ��� �����������
  else DrawTablo(Tablo1);            // ���������� �����1 ��� �����������
  Invalidate;                        // ����������� ������
  result := true;
end;

//------------------------------------------------------------------------------
// ���������� ��������� �������� ���������� � ��������
procedure PresetObjParams;
  var i : integer;
begin
  for i := 1 to High(ObjZav) do
    case ObjZav[i].TypeObj of
      2 : begin // �������
        ObjZav[i].bParam[4] := false; //���.���������
        ObjZav[i].bParam[5] := false; //������� ��������
      end;
      3 : begin // ������
        ObjZav[i].bParam[8] := true; //����.���������
      end;
      4 : begin // ����
        ObjZav[i].bParam[8] := true; //����.���������
      end;
      5 : begin // ��������
        ObjZav[i].iParam[1] := 0; //������ ��������
        ObjZav[i].iParam[2] := 0; //������ ���� ��� �������
        ObjZav[i].iParam[3] := 0; //������ ���� ��� ����������
      end;
      15 : begin // ��
        ObjZav[i].bParam[9] := true; //���.�����
      end;
      34 : begin // �������
        ObjZav[i].bParam[1] := true; //�1�
        ObjZav[i].bParam[2] := true; //�2�
      end;
      38 : begin // �������� �������
        ObjZav[i].bParam[1] := false; //������ �
      end;

    end;
end;

//------------------------------------------------------------------------------
// �������� ����� ����������
procedure ChangeRegion(RU : Byte);
  var i: Integer; f : Byte;
begin
  cur_obj := 0;
  ChRegion := false;
  config.ru := RU;
  for i := 1 to High(ObjZav) do
  begin // ���������� ��������� ��������
    case ObjZav[i].TypeObj of
      1 : begin // ����� �������
        f := fr4[ObjZav[i].ObjConstI[1] div 8]; // ����� FR4
        if ((f and $2) = $2) and (ObjZav[i].RU = config.ru) then
        begin // �������� ����� ������� �� �������� �������
          maket_strelki_index := i; maket_strelki_name  := ObjZav[i].Liter;
        end;
      end;
    end;
  end;
  SetParamTablo;
end;

//------------------------------------------------------------------------------
// ��������� ����� ������ �� �������
procedure TTabloMain.SaveArcToFloppy;
  var cErr : integer;
begin
  OpenDialog.InitialDir := config.arcpath;
  if OpenDialog.Execute then
  begin
    s := 'arj.exe a a:\arcshn.arj '+ OpenDialog.FileName;
    cErr := WinExec(pchar(s),SW_SHOW);
    if cErr <= 31 then
    begin
      Beep; ShowMessage('����������� ������ �� ���������!');
    end;
  end;
end;

//------------------------------------------------------------------------------
// ��������� ��������� ������� ��������� �����
procedure TTabloMain.SaveTablo;
begin
  try
    TmpTablo := TBitmap.Create;
    TmpTablo.Width := Tablo1.Width;
    TmpTablo.Height := Tablo1.Height;
    TmpTablo.Assign(Tablo1);
    SaveDialog.InitialDir := config.arcpath;
    if SaveDialog.Execute then
    TmpTablo.SaveToFile(SaveDialog.FileName);
    if Assigned(TmpTablo) then TmpTablo.Free;
  except
    ShowMessage('������ c��������� ���������� ����� ');
  end;
end;

//---------------------------------------------------------------------------
// ������� ������ �������� �����������
procedure TTabloMain.pmmObjListClick(Sender: TObject);
begin
  ViewObjForm.Show;
end;

//----------------------------------------------------------------------------
// ������� ����� ���������� �������������� �������
procedure TTabloMain.pmNotifyClick(Sender: TObject);
begin
  //NotifyForm.Show;
end;

//----------------------------------------------------------------------------
// ��������� ����� �����
procedure TTabloMain.pmPhotoClick(Sender: TObject);
begin
  SaveTablo;
end;

//----------------------------------------------------------------------------
// ��������� ����� �������
procedure TTabloMain.pmArxivClick(Sender: TObject);
begin
  SaveArcToFloppy;
end;
{
//----------------------------------------------------------------------------
// ��������� ������ ������ � ��-��
procedure TTabloMain.DCTimer(Sender: TObject);
begin
  SyncDCReady
end;
}
end.

