inherited frmRelatorioPadrao: TfrmRelatorioPadrao
  Left = 1058
  Top = 599
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio padr'#227'o'
  ClientHeight = 262
  ClientWidth = 454
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
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
    Left = 330
    Top = 220
    Width = 100
    Height = 23
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object btnAvancar: TBitBtn
    Left = 215
    Top = 220
    Width = 100
    Height = 23
    Caption = 'Avan'#231'ar >'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnAvancarClick
  end
  object btnVoltar: TBitBtn
    Left = 100
    Top = 220
    Width = 100
    Height = 23
    Caption = '< Voltar'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
end
