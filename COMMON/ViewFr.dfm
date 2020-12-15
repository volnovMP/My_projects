object FrForm: TFrForm
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = #1050#1072#1085#1072#1083' '#1057#1077#1088#1074#1077#1088' - '#1056#1052' '#1044#1057#1055
  ClientHeight = 367
  ClientWidth = 305
  Color = clBtnFace
  Constraints.MaxWidth = 371
  Constraints.MinWidth = 179
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    305
    367)
  PixelsPerInch = 96
  TextHeight = 13
  object Refresh: TButton
    Left = 0
    Top = 2
    Width = 75
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 0
    OnClick = RefreshClick
  end
  object sgFr: TStringGrid
    Left = 0
    Top = 31
    Width = 305
    Height = 333
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultRowHeight = 18
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 1
    ColWidths = (
      64
      64
      64
      130)
    RowHeights = (
      18
      18)
  end
end
