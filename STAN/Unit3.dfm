object Tums2: TTums2
  Left = 20
  Top = 17
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BiDiMode = bdLeftToRight
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1059#1042#1050'2'
  ClientHeight = 442
  ClientWidth = 118
  Color = clBtnFace
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -8
  Font.Name = 'Small Fonts'
  Font.Pitch = fpFixed
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00EEEE
    EEEEEEEEEEEEEEEECCCCCCCCEEEEEEEECCCCCCCCEEEEEEEECCCCCCCCEEEEEEEE
    CCCCCCCCEEEEEEEECCCCCCCCEEEEEEEECCCCCCCCEEEEEEEECCCCCCCCEEEEEEEE
    CCCCCCCCEEEEEEEEC000000CEEEEEEEECCCCCCCCEEEEEEEEC000000CEEEEEEEE
    C000000CEEEEEEEEC000000CEEEEEEEECCCCCCCCEEEEEEEEEEEEEEEEEEEE0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  ParentBiDiMode = False
  PixelsPerInch = 96
  TextHeight = 10
  object DrG1: TStringGrid
    Left = 0
    Top = 0
    Width = 118
    Height = 417
    Align = alTop
    BiDiMode = bdLeftToRight
    ColCount = 2
    DefaultColWidth = 30
    DefaultRowHeight = 10
    FixedCols = 0
    RowCount = 37
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Pitch = fpFixed
    Font.Style = []
    Options = [goVertLine, goHorzLine]
    ParentBiDiMode = False
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = False
    TabOrder = 0
    ColWidths = (
      26
      86)
  end
  object Button1: TButton
    Left = 8
    Top = 424
    Width = 105
    Height = 17
    Caption = #1054#1095#1080#1089#1090#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
end
