unit TimeInput;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Registry, Buttons, ComCtrls, DateUtils;

type
  TTimeInputDlg = class(TForm)
    Label1: TLabel;
    Hr: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    HrUpDown: TUpDown;
    Mn: TEdit;
    MnUpDown: TUpDown;
    ScUpDown: TUpDown;
    Sc: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  TimeInputDlg: TTimeInputDlg;
  TimeInputPos : TPoint;
  NewTime : Double;

implementation

{$R *.dfm}

uses
  Commands,
  Commons,
  KanalArmSrv,
  MainLoop,
  TypeALL;

procedure TTimeInputDlg.OKBtnClick(Sender: TObject);
  var uts,lt : TSystemTime; ndt,nd,nt : TDateTime; time64 : int64; err : boolean;
      cdt,delta : Double; Hr,Mn,Sc,Yr,Mt,Dy : Word; i : integer;
begin
  if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 /24) then
  begin
    ndt := EncodeTime(HrUpDown.Position,MnUpDown.Position,ScUpDown.Position,0);
    DateTimeToSystemTime(Date + ndt,uts);

    time64 := (uts.wYear - 2000) shl 8;
    time64 := (time64 + uts.wMonth) shl 8;
    time64 := (time64 + uts.wDay) shl 8;
    time64 := (time64 + uts.wHour) shl 8;
    time64 := (time64 + uts.wMinute) shl 8;
    time64 := time64 + uts.wSecond;

    if WorkMode.ServerSync then // Установить новое время через сервер
      SendDoubleToSrv(time64,cmdfr3_newdatetime,DateTimeSync);

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
      err := true;
      AddFixMessage('Сбой службы времени. Попытка установки времени '+ IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;
    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true;
      AddFixMessage('Сбой службы времени. Попытка установки даты '+ IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
    end;
    if not err then
    begin
      ndt := nd+nt;
      NewTime := ndt;
      DateTimeToSystemTime(ndt,uts);
      SystemTimeToTzSpecificLocalTime(nil,uts,lt);
      cdt := SystemTimeToDateTime(lt) - ndt;
      ndt := ndt - cdt;
      if not WorkMode.ServerSync then
      begin // установить время у себя
        DateTimeToSystemTime(ndt,uts);
        SetSystemTime(uts);
        delta := ndt - LastTime;
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
    end;
    ModalResult := mrOk; // принять новое время
  end else
    ModalResult := mrNo; // отказано в установке времени из-за недопустимого времени
end;

procedure TTimeInputDlg.FormActivate(Sender: TObject);
  var hrw,mnw,scw,msecw : Word;
begin
  Left := TimeInputPos.X; Top := TimeInputPos.Y;
  DecodeTime(Time, Hrw, Mnw, Scw, msecw);
  HrUpDown.Position := Hrw; MnUpDown.Position := Mnw; ScUpDown.Position := Scw;
end;

end.

