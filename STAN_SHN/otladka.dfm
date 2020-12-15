object Otladka1: TOtladka1
  Left = 10
  Top = 200
  Cursor = crHandPoint
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = Edit1
  BiDiMode = bdLeftToRight
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1042#1082#1083#1102#1095#1077#1085#1080#1077'/'#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077' '#1086#1090#1083#1072#1076#1082#1080
  ClientHeight = 43
  ClientWidth = 317
  Color = clBtnFace
  UseDockManager = True
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDesigned
  PrintScale = poNone
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 109
    Height = 16
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 136
    Top = 8
    Width = 81
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 0
    OnExit = Edit1Exit
  end
  object Button1: TButton
    Left = 232
    Top = 8
    Width = 57
    Height = 25
    Caption = #1042#1074#1086#1076
    TabOrder = 1
    OnClick = Button1Click
  end
end
