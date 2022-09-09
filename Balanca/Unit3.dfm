object Form3: TForm3
  Left = 252
  Top = 124
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Configura'#231#227'o Urano'
  ClientHeight = 276
  ClientWidth = 497
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 247
    Top = 66
    Width = 54
    Height = 13
    Caption = 'Porta Serial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 247
    Top = 10
    Width = 77
    Height = 13
    Caption = 'Modelo Balan'#231'a'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ComboBox3: TComboBox
    Left = 247
    Top = 86
    Width = 126
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'ComboBox3'
  end
  object ComboBox1: TComboBox
    Left = 247
    Top = 30
    Width = 234
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox1'
  end
  object Button1: TButton
    Left = 345
    Top = 230
    Width = 130
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 230
    Width = 130
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = Button2Click
  end
end
