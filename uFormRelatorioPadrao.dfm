object frmRelatorioPadrao: TfrmRelatorioPadrao
  Left = 1403
  Top = 604
  Width = 780
  Height = 359
  BorderIcons = [biSystemMenu]
  Caption = 'Relat'#243'rio padr'#227'o'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ImgRel: TImage
    Left = 20
    Top = 20
    Width = 89
    Height = 89
    AutoSize = True
    Center = True
    Transparent = True
  end
  object btnCancelar: TBitBtn
    Left = 181
    Top = 180
    Width = 100
    Height = 23
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object btnImprimir: TBitBtn
    Left = 70
    Top = 181
    Width = 100
    Height = 23
    Caption = 'Imprimir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnImprimirClick
  end
end
