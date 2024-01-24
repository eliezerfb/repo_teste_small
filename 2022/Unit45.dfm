object Form45: TForm45
  Left = 650
  Top = 484
  Caption = 'Fator de convers'#227'o'
  ClientHeight = 157
  ClientWidth = 639
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object Label85: TLabel
    Left = 20
    Top = 30
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Unidade de entrada:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label86: TLabel
    Left = 20
    Top = 60
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Fator de convers'#227'o:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label87: TLabel
    Left = 20
    Top = 90
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Unidade  de sa'#237'da:'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label88: TLabel
    Left = 264
    Top = 30
    Width = 64
    Height = 16
    Caption = 'Exemplo:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label89: TLabel
    Left = 264
    Top = 60
    Width = 99
    Height = 13
    Caption = 'Compra... e vende ...'
  end
  object ComboBox12: TComboBox
    Left = 130
    Top = 30
    Width = 70
    Height = 22
    Style = csOwnerDrawVariable
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object SMALL_DBEdit64: TSMALL_DBEdit
    Left = 130
    Top = 60
    Width = 70
    Height = 22
    AutoSize = False
    BevelInner = bvLowered
    BevelOuter = bvNone
    Ctl3D = True
    DataField = 'FATORC'
    DataSource = Form7.DataSource4
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
  end
  object ComboBox13: TComboBox
    Left = 130
    Top = 90
    Width = 70
    Height = 22
    Style = csOwnerDrawVariable
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
