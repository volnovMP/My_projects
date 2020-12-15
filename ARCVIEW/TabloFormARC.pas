unit TabloFormARC;
{$UNDEF TEST}
interface

uses
  Windows,  Messages,  SysUtils,  Classes,  Graphics,  Controls,  Forms,  Dialogs,
  ExtCtrls, Registry,  Menus,  MMSystem, ImgList, StdCtrls;

type
  TTabloMain = class(TForm)
    ImageList: TImageList;
    MainTimer: TTimer;
    ImageListRU: TImageList;
    ImageList32: TImageList;
    ImageList16: TImageList;
    PaintBox1: TPaintBox;
    TimerSync: TTimer;
    PopupMenu: TPopupMenu;
    pmmLoad: TMenuItem;
    pmmSoob: TMenuItem;
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
    procedure TimerSyncTimer(Sender: TObject);
    procedure pmmLoadClick(Sender: TObject);
    procedure pmmSoobClick(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
  private
    function RefreshTablo : Boolean; //--------------------------- ���������� ������ �����
  public
    STOP : boolean;
    PopupMenuCmd  : TPopupMenu;
  end;

var
  TabloMain: TTabloMain;

procedure ChangeRegion(RU : Byte);
procedure ResetCommands; //------------------------------------ ����� ���� �������� ������

const
  CurTablo1   = 1;
  RepFileName = 'ARC_VIEW.rpt';
  KeyNameDsp        : string = '\Software\DSPRPCTUMS';
  KeyNameShn        : string = '\Software\SHNRPCTUMS';
  KeyName           : string = '\Software\ARCRPCTUMS';
  KeyRegMainForm    : string = '\Software\ARCRPCTUMS\MainForm';
  KeyRegDirectForm  : string = '\Software\ARCRPCTUMS\DirectForm';
  KeyRegMsgForm     : string = '\Software\ARCRPCTUMS\MsgForm';
  KeyRegValListForm : string = '\Software\ARCRPCTUMS\ListForm';

//-------------------------------------------------------------- ��������������� ���������
procedure PresetObjParams;

implementation

uses
  TypeALL,
  Load,
  Objsost,
  Commands,
  MainLoop,
  CMenu,
  Commons,
  MsgForm,
  DirectForm;

{$R *.DFM}
//========================================================================================

//========================================================================================
procedure TTabloMain.FormDestroy(Sender: TObject);

begin
{    //reg := TRegistry.Create;
    //------------------------------------------------------ ��������� ��������� � �������
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyRegMainForm, true) then
    begin
      reg.WriteInteger('left', TabloMain.Left);
      reg.WriteInteger('top', TabloMain.Top);
      reg.WriteInteger('width', TabloMain.Width);
      reg.WriteInteger('height', TabloMain.Height);
      reg.CloseKey;
    end;

    if Reg.OpenKey(KeyName, true) then
    begin
      reg.WriteInteger('MaxOld', Trunc(ArcMaxOldTime));
      reg.WriteString('arcpath', config.arcpath);
      reg.CloseKey;
    end;
      if Reg.OpenKey(KeyRegDirectForm, true) then
    begin
      reg.WriteInteger('left', DirectFormDlg.Left);
      reg.WriteInteger('top', DirectFormDlg.Top);
      reg.CloseKey;
    end;
  }
    //Reg.Free;

  if Assigned(Tablo1) then Tablo1.Free;
  if Assigned(Tablo2) then Tablo2.Free;
end;

//========================================================================================
procedure TTabloMain.FormCreate(Sender: TObject);
var
  err: boolean;
  i : integer;
  cok : string;
begin
  STOP := false;
  Caption := '����� ���������� �������';
  //MsgFormDlg := TMsgFormDlg.Create(self);

  //PopupMenuCmd := TPopupMenu.Create(self);
 // PopupMenuCmd.AutoPopup := false;
  shiftxscr := 0;
  shiftyscr := 0;

  err := false;
  cok := '';
  reg := TRegistry.Create; //-------------------------------- ������ ��� ������� � �������
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyName, false) then
  begin
    if reg.ValueExists('arcpath') then config.arcpath := reg.ReadString('arcpath')
    else config.arcpath := 'c:\arc';

    if reg.ValueExists('MaxOld') then
    begin //------------------- ��������� ����������������� ������� � ������ ������ ������
      i := reg.ReadInteger('MaxOld');
      ArcMaxOldTime := i;
    end
    else ArcMaxOldTime := 31.0;
    reg.CloseKey;
  end;

  if Reg.OpenKey(KeyNameDsp, false) then
  begin
    if reg.ValueExists('databasepath') then database := reg.ReadString('databasepath')
    else err := true;

    if reg.ValueExists('path') then config.path := reg.ReadString('path')
    else err := true;

    if reg.ValueExists('ru') then config.ru := reg.ReadInteger('ru')
    else err := true;

    if reg.ValueExists('RMID') then config.RMID := reg.ReadInteger('RMID')
    else err := true;

    reg.CloseKey;

    if not FileExists(database) then err := true;
  end else
  if Reg.OpenKey(KeyNameShn, false) then
  begin
    if reg.ValueExists('databasepath') then database := reg.ReadString('databasepath')
    else err := true;

    if reg.ValueExists('path') then config.path := reg.ReadString('path')
    else err := true;

    if reg.ValueExists('ru') then config.ru := reg.ReadInteger('ru')
    else err := true;

    if reg.ValueExists('RMID') then config.RMID := reg.ReadInteger('RMID')
    else err := true;

    reg.CloseKey;

    if not FileExists(database) then err := true;
  end else
  begin
    ShowMessage('���������� ������ ��-�� ����������� ������ ��� ������������� ���������.');
    Application.Terminate;
  end;

  Left := 0;
  Top := 0;
  mem_page := false;

  Tablo1 := TBitmap.Create;
  Tablo2 := TBitmap.Create;
  ImageList.BkColor   := bkgndcolor;
  ImageListRU.BkColor := bkgndcolor;

  screen.Cursors[curTablo1] := LoadCursor(HInstance, IDC_ARROW);

  //------------------------------------------------------------- �������� ��� ������ ����
  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspMenu.obj := -1;

  StartObj  := 1;
  DiagnozON := true;
  ArcReady := false;

  //----------------------------------------------------------------- �������� ���� ������
  if not LoadBase(database) then err := true;

  //---------------------------------------------- �������� ������� ���� ����������� �����
  if Reg.OpenKey(KeyRegMainForm, true) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left')else Left := 0;

    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top') else Top  := 0;

    if reg.ValueExists('width') then Width := reg.ReadInteger('width')else Width := Screen.Width;

    if reg.ValueExists('height')  then Height  := reg.ReadInteger('height')
    else
    begin
      i := Screen.Height;
      if Screen.Height < (configRU[config.ru].T_S.Y+50) then Height := i
      else Height := configRU[config.ru].T_S.Y+50;
    end;
    reg.CloseKey;
  end;

  SetParamTablo;

  //--------------------------------------------------- �������� �������� ��������� ��-���
  if not LoadLex(config.path + 'LEX.SDB') then err := true;

  if not LoadLex2(config.path + 'LEX2.SDB') then err := true;

  if not LoadLex3(config.path + 'LEX3.SDB') then err := true;

  if not LoadMsg(config.path + 'MSG.SDB') then err := true;

  //-------------------------------------------------------------- �������� ��������� ����
  if not LoadAKNR(config.path + 'AKNR.SDB') then err := true;

  StateRU := 0; //-------------------------------------- �������� ��������� ��� � ��������
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
  
  if err then
  begin
    ShowMessage('���������� ������ ��-�� ����������� ������ ��� ������������� ���������.');
    Application.Terminate;
  end;
  AppStart := true;
end;

//========================================================================================
//---------------------------------------------------------------------- ����������� �����
procedure TTabloMain.FormActivate(Sender: TObject);
begin
  if not AppStart then exit;
  AppStart := false;

  if configRU[config.ru].T_S.X > 0 then
  DirectFormDlg.Region.ItemIndex := config.ru-1;

  PresetObjParams;  //---- ���������� ��������� �������� ������������ � �������� ���������
  Cursor := curTablo1;
  DrawTablo(Tablo1);
  DrawTablo(Tablo2);

  MainTimer.Enabled := true;
  LastRcv := Date+Time;
  StartRM := true;        //--------------------------- ��������� ��������� ������ �������
  StartTime := CmdSendT;  //---------------------------------------- ������ ������� ��-���
  LockTablo := false;
end;

//========================================================================================
procedure TTabloMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MainTimer.Enabled := false;
  TimerSync.Enabled := false;
  lock_maintimer := false;
  canClose := true;
  STOP := true;
  ShowWindow(Application.Handle,SW_HIDE);
  DirectFormDlg.Close;
end;

//========================================================================================
procedure TTabloMain.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if not mem_page then PaintBox1.Canvas.Draw(0,0,tablo2)
  else PaintBox1.Canvas.Draw(0,0,tablo1);
end;

//========================================================================================
//---------------------------------------------- ���������� �� ������ ��������� ����������
procedure TTabloMain.FormPaint(Sender: TObject);
  var shiftx,shifty : integer;
begin
  shiftx := HorzScrollBar.Position;
  shifty := VertScrollBar.Position;
  // ���������� ������ �� ��������
  if (cur_obj > 0) and (ObjUprav[cur_obj].MenuID > 0) then
    with canvas do
    begin
      Pen.Color := clRed; Pen.Mode := pmCopy; Pen.Width := 1;
      MoveTo(ObjUprav[cur_obj].Box.Left-shiftx, ObjUprav[cur_obj].Box.Top-shifty);
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

//========================================================================================
procedure TTabloMain.DrawTablo(tablo: TBitmap);
var
  i : integer;
begin
  Tablo.Canvas.Lock;
  Tablo.Canvas.Brush.Color := bkgndcolor;
  Tablo.canvas.FillRect(rect(0, 0, tablo.width, tablo.height));

  //------------------------------------------ ���������� ���� ������������ �������� �����
  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 0)
  then DisplayItemTablo(i, Tablo.Canvas);

  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 1)
  then DisplayItemTablo(i, Tablo.Canvas);

  for i := configRU[config.RU].OVmin to configRU[config.RU].OVmax do
  if (ObjView[i].TypeObj > 0) and (ObjView[i].Layer = 2)
  then DisplayItemTablo(i, Tablo.Canvas);

  Tablo.Canvas.UnLock;
end;

//========================================================================================
procedure TTabloMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i,shiftx,shifty,o: integer;
begin
  //if PopupMenuCmd.PopupComponent <> nil then exit;

  shiftx := HorzScrollBar.Position;
  shifty := VertScrollBar.Position;
  LastMove := Date+Time;
  LastX := x; LastY := y;

  //----------------------------------------------------------- ����� ������� ������������
  o := cur_obj;
  cur_obj := -1;
  for i := configRU[config.ru].OUmin to configRU[config.ru].OUmax do
  begin
    if (x+shiftxscr >= ObjUprav[i].Box.Left) and (y+shiftyscr >= ObjUprav[i].Box.Top) and (x+shiftxscr <= ObjUprav[i].Box.Right) and (y+shiftyscr <= ObjUprav[i].Box.Bottom) then
    begin
      cur_obj := i; ID_obj := ObjUprav[i].IndexObj; ID_menu := ObjUprav[i].MenuID; break;
    end;
  end;

  if o <> cur_obj then
  begin
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
        DspCom.Com := DspMenu.Items[i].Command;
        DspCom.Obj := DspMenu.Items[i].Obj;
        DspCom.Active  := true;
        SelectCommand;
        exit;
      end;
  end;
end;

//========================================================================================
procedure ResetCommands;
begin
  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspCom.Active := false;
  DspMenu.obj := -1;
  WorkMode.GoTracert := false;
  WorkMode.GoMaketSt := false;
  WorkMode.GoOtvKom  := false;
  Workmode.MarhOtm   := false;
  Workmode.VspStr    := false;
  Workmode.InpOgr    := false;
  RSTMsg; // �������� ��� �������� ���������
end;

//========================================================================================
procedure TTabloMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
  // ������ ����� ������ �����
   // if CreateDspMenu(ID_menu,0,0) then UpdateKeyList(ID_ViewObj);
  end;
end;

//------------------------------------------------------------------------------
// ��������� ������� �� ����������
procedure TTabloMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  var
{$IFDEF TEST} s,z : string; i,o,p : integer; {$ENDIF}
//    sl : TStringList;
    shifts : integer;
begin
  shifts := HorzScrollBar.Position;
  if PopupMenuCmd.PopupComponent <> nil then exit;
  case Key of

    VK_LEFT :
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Sosed[1] > 0 then cur_obj := ObjUPrav[cur_obj].Sosed[1];
      end else
        cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shifts-2, ObjUPrav[cur_obj].Box.Bottom-2);
    end;

    VK_RIGHT :
    begin
      if cur_obj > 0 then
      begin
        if ObjUPrav[cur_obj].Sosed[2] > 0 then cur_obj := ObjUPrav[cur_obj].Sosed[2];
      end else
        cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shifts-2, ObjUPrav[cur_obj].Box.Bottom-2);
    end;

    VK_UP :
    begin
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Sosed[3] > 0 then cur_obj := ObjUPrav[cur_obj].Sosed[3];
        end else
          cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shifts-2, ObjUPrav[cur_obj].Box.Bottom-2);
      end;
    end;

    VK_DOWN :
    begin
      if Shift = [] then
      begin
        if cur_obj > 0 then
        begin
          if ObjUPrav[cur_obj].Sosed[4] > 0 then cur_obj := ObjUPrav[cur_obj].Sosed[4];
        end else
          cur_obj := StartObj;
        if cur_obj > 0 then SetCursorPos(ObjUPrav[cur_obj].Box.Right-shifts-2, ObjUPrav[cur_obj].Box.Bottom-2);
      end;
    end;

    VK_RETURN :
    begin

    end;

{$IFDEF TEST}
    VK_F1 :
    begin
      if Shift = [ssAlt] then // ��������������� �������
      begin
      s := '';
      if InputQuery('������ �������� FR3','��������',s) then
      begin
        if s <> '' then
        begin
          i := 1;
          while i <= Length(s) do
          begin
            o := 0; p := 0; z := '';
            if getinteger(i,s,o)   then exit;
            if not getstring(i,s,z)    then exit;
            if o = 0 then exit;
            case Length(z) of
              0 : z := '00000000';
              1 : z := z + '0000000';
              2 : z := z + '000000';
              3 : z := z + '00000';
              4 : z := z + '0000';
              5 : z := z + '000';
              6 : z := z + '00';
              7 : z := z + '0';
            else
              SetLength(z,8);
            end;
            if z[1] = '1' then p := 1;
            if z[2] = '1' then p := p + 2;
            if z[3] = '1' then p := p + 4;
            if z[4] = '1' then p := p + 8;
            if z[5] = '1' then p := p + 16;
            if z[6] = '1' then p := p + 32;
            if z[7] = '1' then p := p + 64;
            if z[8] = '1' then p := p + 128;
            FR3inp[o] := char(p);
          end;
        end else
          ShowMessage('�������� �� ����������');
        end;
      end;


      if Shift = [ssShift] then // ��������������� �������
      begin
      s := '';
      if InputQuery('������ �������� FR4','��������',s) then
      begin
        if s <> '' then
        begin
          i := 1;
          while i <= Length(s) do
          begin
            o := 0; p := 0; z := '';
            if getinteger(i,s,o)   then exit;
            if not getstring(i,s,z)    then exit;
            if o = 0 then exit;
            case Length(z) of
              0 : z := '00000000';
              1 : z := z + '0000000';
              2 : z := z + '000000';
              3 : z := z + '00000';
              4 : z := z + '0000';
              5 : z := z + '000';
              6 : z := z + '00';
              7 : z := z + '0';
            else
              SetLength(z,8);
            end;
            if z[1] = '1' then p := 1;
            if z[2] = '1' then p := p + 2;
            if z[3] = '1' then p := p + 4;
            if z[4] = '1' then p := p + 8;
            if z[5] = '1' then p := p + 16;
            if z[6] = '1' then p := p + 32;
            if z[7] = '1' then p := p + 64;
            if z[8] = '1' then p := p + 128;
            FR4inp[o] := char(p);
          end;
        end else
          ShowMessage('�������� �� ����������');
        end;
      end;
    end;

    VK_F2 :
    begin
      if Shift = [ssCtrl] then // ��������������� �������
      begin
      // ������������� ���� ������
        if not LoadBase(database) then ShowMessage('������ � ��������!');
      end;
    end;

    VK_F3 :
    begin


      if Shift = [ssCtrl] then // ��������������� �������
      begin
      // ���������� �������� ��������� ��������
        PresetObjParams;
        for i := 1 to High(ObjZav) do
        begin
          case ObjZav[i].TypeObj of
            1 : begin
              p := ObjZav[i].ObjConstI[2] div 8;
              FR3inp[p] := #1;
            end;
            8 : begin
              p := ObjZav[i].ObjConstI[2] div 8;
              FR3inp[p] := #1;
            end;
            12 : begin
              p := ObjZav[i].ObjConstI[6] div 8;
              FR3inp[p] := #16;
            end;
            15 : begin
              p := ObjZav[i].ObjConstI[2] div 8;
              FR3inp[p] := #2;
              p := ObjZav[i].ObjConstI[5] div 8;
              FR3inp[p] := #2;
            end;
            34 : begin
              p := ObjZav[i].ObjConstI[1] div 8;
              FR3inp[p] := #11;
            end;
          end;
        end;
      end;
    end;
{$ENDIF}

    VK_F4 :
    begin
    end;

    VK_F5 :
    begin // ������� ������ ���������
      MsgFormDlg.Show;
    end;

    VK_PRIOR :
    begin // �������� 1 �����
      ChangeRegion(1);
      DirectFormDlg.Region.ItemIndex := 0;
    end;

    VK_NEXT :
    begin // �������� 2 �����
      ChangeRegion(2);
      DirectFormDlg.Region.ItemIndex := 1;
    end;

    VK_F9 :
    begin
    end;

  else
    inherited;
  end;
end;

procedure TTabloMain.pmmLoadClick(Sender: TObject);
begin
 DirectFormDlg.Show;
end;

procedure TTabloMain.pmmSoobClick(Sender: TObject);
begin
  MsgFormDlg.Show;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure TTabloMain.TimerSyncTimer(Sender: TObject);
var
  DeltaSyncArc : Double;
begin
  DeltaSyncArc := Date+Time - LastSyncArc;
  LastSyncArc := Date+Time;
  try
    TimerSync.Enabled := false;
    if YStep then
    begin
      if SpeedZoom <= 0 then
      begin //------------------------------- �������� ��������� ��� ������������� �������
        if FrameOffset < Length(arhiv) then
        begin
          while ((FrameOffset > 0) and (FrameOffset < Length(arhiv))) do
          begin
            FrameOffset := ArcStep(FrameOffset);
            if TypeLastFrame < 11 then break;
          end;
        end else
        begin
          YStep := false;
          with DirectFormDlg do
          begin
            BtnOpen.Enabled := true;
            BtnStart.Enabled := false;
            BtnStop.Enabled := false;
            BtnStep.Enabled := false;
            BtnPrev.Enabled := true;
            edittime.ReadOnly := false;
          end;
          ShowMessage('�������� ��������!');
        end;
      end else
      begin //--------------------------------------- ��������� � ���������� �������������
        CurrentTime := CurrentTime + DeltaSyncArc * SpeedZoom;
        if CheckSyncStep(FrameOffset,CurrentTime) then
        begin
          if (FrameOffset > 0) and (FrameOffset < Length(arhiv)) then
          begin
            while ((FrameOffset > 0) and (FrameOffset < Length(arhiv))) do
            begin
              FrameOffset := ArcStep(FrameOffset);
              if CurrentTime < DTFrameOffset then break;
            end;
          end else
          begin
            YStep := false;
            with DirectFormDlg do
            begin
              BtnOpen.Enabled := true;
              BtnStart.Enabled := false;
              BtnStop.Enabled := false;
              BtnStep.Enabled := false;
              BtnPrev.Enabled := true;
              edittime.ReadOnly := false;
            end;
            ShowMessage('�������� ��������!');
          end;
        end;
      end;
    end;
  finally
    TimerSync.Enabled := true;
  end;
end;

//========================================================================================
//------------------------------------------------------ ���������� �������� ������� �����
procedure TTabloMain.MainTimerTimer(Sender: TObject);
var
  Err,i : integer;
begin
  LastTime := DTFrameOffset;
  if LockTablo then exit;
  try
    try
      LockTablo := true; MainTimer.Enabled := false;

      //------------------------------------------ ����������� ��������� ������ ����������
      if WorkMode.ArmStateSoob > 0 then
      begin
        WorkMode.Upravlenie := true;
        WorkMode.LockCmd    := false;
        WorkMode.RazdUpr    := (FR3[WorkMode.ArmStateSoob] and 1)   = 1;
        WorkMode.MarhUpr    := (FR3[WorkMode.ArmStateSoob] and 2)   = 2;
        WorkMode.MarhOtm    := (FR3[WorkMode.ArmStateSoob] and 4)   = 4;
        WorkMode.InpOgr     := (FR3[WorkMode.ArmStateSoob] and 8)   = 8;
        WorkMode.VspStr     := (FR3[WorkMode.ArmStateSoob] and $10) = $10;
        WorkMode.KOK_TUMS   := (FR3[WorkMode.ArmStateSoob] and $20) = $20;
        WorkMode.Podsvet    := (FR3[WorkMode.ArmStateSoob] and $40) = $40;
        WorkMode.GoTracert  := (FR3[WorkMode.ArmStateSoob] and $80) = $80;
      end;

      //------------------------------------------------- �������� ������������� ���������
      for i := 1 to High(ObjZv) do
      begin //---------------------------------------------- �������� �������� �����������
        case ObjZv[i].TypeObj of
          3 :   ObjZv[i].bP[19] := false;//---------------------------------- �������
          4 :   ObjZv[i].bP[19] := false;//------------------------------------- ����
          5 :   ObjZv[i].bP[23] := false;//--------------------------------- ��������
        end;
      end;

      if not STOP then RefreshTablo;  //------------------------------- ����������� ������

      {���������� ��������� �������}
      // UpdateValueList(ID_ViewObj); // ������� ��������� �������

      if NewNeisprav then
      begin
        MsgFormDlg.Memo.Text := LstNN;
        MsgFormDlg.MemoUVK.Text := ListDiagnoz;
        if SndNewWar then
        begin
          playsound('media\sound1.wav',0,SND_ASYNC);
          SndNewWar := false;
        end else
        if SndNewUvk then
        begin
          playsound('media\sound2.wav',0,SND_ASYNC);
          SndNewUvk := false;
        end else
        if SndNewMsg then
        begin
          playsound('media\sound6.wav',0,SND_ASYNC);
          SndNewMsg := false;
        end;
        SndNewWar := false;
        SndNewMsg := false;
      end;
    except
      Err := GetLastError();
    end;

  finally
    LockTablo := false;
    MainTimer.Enabled := true;
  end;
end;

procedure TTabloMain.PaintBox1Click(Sender: TObject);
begin

end;

//========================================================================================
//---------------------------------------------------------------- ���������� ������ �����
function TTabloMain.RefreshTablo : Boolean;
begin
  LastSync := LastTime;
  PrepareOZ;

  WorkMode.NU[0] := false;
  WorkMode.BU[0] := false;
  StateRU := FR3[WorkMode.DirectStateSoob] and $F0;


  mem_page := not mem_page;
  if not mem_page then tab_page := not tab_page;

  if mem_page then DrawTablo(Tablo2) //----------------- ���������� �����2 ��� �����������
  else DrawTablo(Tablo1);            //----------------- ���������� �����1 ��� �����������
  Invalidate;                        //-------------------------------- ����������� ������
  result := true;
end;

//========================================================================================
//------------------------------------ ���������� ��������� �������� ���������� � ��������
procedure PresetObjParams;
var
  i : integer;
begin
  for i := 1 to High(ObjZv) do
  case ObjZv[i].TypeObj of
    2 : begin ObjZv[i].bP[4]:= false; ObjZv[i].bP[5] := false; end; //------------ �������
    3 : begin ObjZv[i].bP[8]:= true; end; //--------------------------------------- ������
    4 : begin ObjZv[i].bP[8]:= true; end; //----------------------------------------- ����
    5 : begin ObjZv[i].iP[1]:= 0; ObjZv[i].iP[2] := 0; ObjZv[i].iP[3] := 0; end;//��������
   15 : begin ObjZv[i].bP[9] := true; end; //------------------------------------------ ��
   34 : begin ObjZv[i].bP[1] := true; ObjZv[i].bP[2] := true; end; //------------- �������
   38 : begin ObjZv[i].bP[1] := false;  end; //-------------------------- �������� �������
  end;
  for i := 1 to 4096 do FR3s[i] := LastTime; //���������� ������� ���������� �������� FR3s
end;

//========================================================================================
//-------------------------------------------------------------- �������� ����� ����������
procedure ChangeRegion(RU : Byte);
var
  i: Integer;
  f : Byte;
begin
  ChRegion := false; config.ru := RU;
  for i := 1 to High(ObjZv) do
  begin //-------------------------------------------------- ���������� ��������� ��������
    case ObjZv[i].TypeObj of
      1 :
      begin //-------------------------------------------------------------- ����� �������
        f := fr4[ObjZv[i].ObCI[1] div 8]; //------------------------------------- ���� FR4
        //------------------------------------- �������� ����� ������� �� �������� �������
        if ((f and $2) = $2) and (ObjZv[i].RU = config.ru) then
        begin  maket_strelki_index := i; maket_strelki_name  := ObjZv[i].Liter; end;
      end;
    end;
  end;
  SetParamTablo;
end;

end.

