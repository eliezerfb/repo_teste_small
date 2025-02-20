object Form36: TForm36
  Left = 338
  Top = 269
  Caption = 'Carta de Corre'#231#227'o Eletronica (CC-e)'
  ClientHeight = 636
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 12
    Top = 420
    Width = 3
    Height = 13
  end
  object Memo1: TMemo
    Left = 12
    Top = 220
    Width = 800
    Height = 200
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Ctl3D = False
    MaxLength = 1000
    ParentBiDiMode = False
    ParentCtl3D = False
    TabOrder = 0
    OnChange = Memo1Change
  end
  object Button1: TButton
    Left = 344
    Top = 470
    Width = 100
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
