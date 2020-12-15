object ViewBaza: TViewBaza
  Left = 0
  Top = 0
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1073#1098#1077#1082#1090#1086#1074' OZ '#1080' OV'
  ClientHeight = 572
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    Caption = #1053#1086#1084#1077#1088'  OZ'
  end
  object NameOZ: TLabel
    Left = 75
    Top = 30
    Width = 22
    Height = 13
    Caption = #1048#1084#1103' '
  end
  object Label3: TLabel
    Left = 131
    Top = 8
    Width = 60
    Height = 13
    Caption = #1053#1086#1084#1077#1088' BV = '
  end
  object NomOZ: TEdit
    Left = 8
    Top = 27
    Width = 49
    Height = 21
    TabOrder = 0
    Text = '0'
    OnDblClick = NomOZDblClick
  end
  object ParamOZ: TStringGrid
    Left = 8
    Top = 54
    Width = 113
    Height = 489
    ColCount = 2
    DefaultColWidth = 50
    DefaultRowHeight = 13
    RowCount = 34
    FixedRows = 0
    TabOrder = 1
    RowHeights = (
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13
      13)
  end
  object ParamOV: TStringGrid
    Left = 127
    Top = 27
    Width = 112
    Height = 494
    ColCount = 2
    DefaultColWidth = 50
    DefaultRowHeight = 14
    RowCount = 32
    FixedRows = 0
    TabOrder = 2
    RowHeights = (
      17
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14
      14)
  end
end
