object Form2: TForm2
  Left = 218
  Top = 189
  Width = 459
  Height = 165
  BorderIcons = [biSystemMenu]
  Caption = 'Adiciona com m'#225'scara'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 293
    Height = 13
    Caption = 'Entre com a unidade + pasta + m'#225'scara ex:( C:\Dados\*.DBF)'
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 433
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 344
    Top = 66
    Width = 97
    Height = 19
    Caption = 'Visualizar pastas'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 366
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 280
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = Button3Click
  end
end
