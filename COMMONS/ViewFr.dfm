object FrForm: TFrForm
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = #1050#1072#1085#1072#1083' '#1057#1077#1088#1074#1077#1088' - '#1056#1052' '#1044#1057#1055
  ClientHeight = 188
  ClientWidth = 172
  Color = clBtnFace
  Constraints.MaxWidth = 180
  Constraints.MinWidth = 180
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
    172
    188)
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
    Width = 172
    Height = 154
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultRowHeight = 18
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
