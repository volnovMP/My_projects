object ClockForm: TClockForm
  Left = 194
  Top = 680
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1063#1072#1089#1099
  ClientHeight = 62
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbClock: TLabel
    Left = 0
    Top = 0
    Width = 212
    Height = 35
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = '06:59:59'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lbCalendar: TLabel
    Left = 0
    Top = 38
    Width = 212
    Height = 24
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = '31 '#1072#1074#1075#1091#1089#1090#1072' 2006 '#1075'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object trClock: TTimer
    Interval = 300
    OnTimer = trClockTimer
    Left = 184
    Top = 32
  end
end
