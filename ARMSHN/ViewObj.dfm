object ViewObjForm: TViewObjForm
  Left = 192
  Top = 107
  Caption = #1057#1087#1080#1089#1086#1082' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1091#1077#1084#1099#1093' '#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 520
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    643
    520)
  PixelsPerInch = 96
  TextHeight = 13
  object ListObj: TListView
    Left = 0
    Top = 32
    Width = 644
    Height = 489
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #8470#8470
        Width = 40
      end
      item
        Caption = #1058#1080#1087
        Width = 100
      end
      item
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 100
      end
      item
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        Width = 400
      end>
    HotTrack = True
    HotTrackStyles = [htHandPoint]
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = ListObjClick
  end
  object RefTimer: TTimer
    Interval = 1013
    OnTimer = RefTimerTimer
    Left = 8
    Top = 56
  end
end
