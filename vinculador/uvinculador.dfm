object Form1: TForm1
  Left = 192
  Top = 125
  Caption = 'Form1'
  ClientHeight = 431
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 86
    Height = 13
    Caption = 'CNPJ Contribuinte'
  end
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Gerar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edcnpjemitente: TEdit
    Left = 8
    Top = 24
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 88
    Width = 529
    Height = 337
    ReadOnly = True
    TabOrder = 2
  end
end
