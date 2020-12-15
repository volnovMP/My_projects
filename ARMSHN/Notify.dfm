object NotifyForm: TNotifyForm
  Left = 192
  Top = 107
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1081
  ClientHeight = 354
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 400
    Height = 321
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheet1: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot1: TComboBox
        Left = 0
        Top = 4
        Width = 393
        Height = 21
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 1'
        DropDownCount = 20
        ImeMode = imAlpha
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = cbNot1Change
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9')
      end
      object cbRunStop1: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop1Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams1: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams1StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj1: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj1Change
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot2: TComboBox
        Left = 0
        Top = 4
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 2'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot2Change
      end
      object cbRunStop2: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop2Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams2: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams2StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj2: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj2Change
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'3'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot3: TComboBox
        Left = 0
        Top = 4
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 3'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot3Change
      end
      object cbRunStop3: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop3Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams3: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams3StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj3: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj3Change
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'4'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot4: TComboBox
        Left = -1
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 4'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot4Change
      end
      object cbRunStop4: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop4Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams4: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams4StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj4: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj4Change
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'5'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot5: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 5'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot5Change
      end
      object cbRunStop5: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop5Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams5: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams5StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj5: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj5Change
      end
    end
    object TabSheet6: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'6'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot6: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 6'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot6Change
      end
      object cbRunStop6: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop6Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams6: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams6StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj6: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj6Change
      end
    end
    object TabSheet7: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'7'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot7: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 7'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot7Change
      end
      object cbRunStop7: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop7Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams7: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams7StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj7: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj7Change
      end
    end
    object TabSheet8: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'8'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot8: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 8'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot8Change
      end
      object cbRunStop8: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop8Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams8: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams8StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj8: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj8Change
      end
    end
    object TabSheet9: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'9'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot9: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 9'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot9Change
      end
      object cbRunStop9: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop9Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams9: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams9StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj9: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj9Change
      end
    end
    object TabSheet10: TTabSheet
      Caption = #1057#1086#1073#1099#1090#1080#1077'10'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cbNot10: TComboBox
        Left = 0
        Top = 7
        Width = 393
        Height = 22
        Hint = #1047#1074#1091#1082#1086#1074#1086#1081' '#1089#1080#1075#1085#1072#1083' '#1089#1086#1073#1099#1090#1080#1103' 10'
        Style = csOwnerDrawFixed
        DropDownCount = 20
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = cbNot10Change
      end
      object cbRunStop10: TComboBox
        Left = 0
        Top = 264
        Width = 129
        Height = 22
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' / '#1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRunStop10Change
        Items.Strings = (
          #1054#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
          #1054#1078#1080#1076#1072#1085#1080#1077)
      end
      object veParams10: TValueListEditor
        Left = 0
        Top = 32
        Width = 306
        Height = 225
        DefaultRowHeight = 16
        DropDownRows = 20
        ScrollBars = ssVertical
        Strings.Strings = (
          #1054#1073#1098#1077#1082#1090'1='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'1='
          #1054#1073#1098#1077#1082#1090'2='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'2='
          #1054#1073#1098#1077#1082#1090'3='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'3='
          #1054#1073#1098#1077#1082#1090'4='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'4='
          #1054#1073#1098#1077#1082#1090'5='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'5='
          #1054#1073#1098#1077#1082#1090'6='
          #1057#1086#1089#1090#1086#1103#1085#1080#1077'6=')
        TabOrder = 2
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        OnStringsChange = veParams10StringsChange
        ColWidths = (
          150
          150)
      end
      object cbViewObj10: TComboBox
        Left = 136
        Top = 264
        Width = 169
        Height = 22
        Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1082#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1089#1090#1091#1087#1083#1077#1085#1080#1080' '#1089#1086#1073#1099#1090#1080#1103
        Style = csOwnerDrawVariable
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 3
        OnChange = cbViewObj10Change
      end
    end
  end
  object btnTestSound: TButton
    Left = 0
    Top = 324
    Width = 65
    Height = 25
    Hint = #1042#1086#1089#1087#1088#1086#1080#1079#1074#1077#1089#1090#1080' '#1079#1074#1091#1082' '#1089#1086#1073#1099#1090#1080#1103
    Caption = #1055#1088#1086#1073#1072
    TabOrder = 1
    OnClick = btnTestSoundClick
  end
  object btnClose: TButton
    Left = 320
    Top = 325
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCloseClick
  end
end
