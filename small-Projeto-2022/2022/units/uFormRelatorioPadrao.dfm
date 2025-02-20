inherited frmRelatorioPadrao: TfrmRelatorioPadrao
  Left = 1058
  Top = 599
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio padr'#227'o'
  ClientHeight = 280
  ClientWidth = 518
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  ExplicitWidth = 534
  ExplicitHeight = 319
  PixelsPerInch = 96
  TextHeight = 13
  object ImgRel: TImage
    Left = 44
    Top = 20
    Width = 89
    Height = 89
    AutoSize = True
    Center = True
    Transparent = True
  end
  object btnCancelar: TBitBtn
    Left = 399
    Top = 237
    Width = 100
    Height = 24
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
    Left = 295
    Top = 237
    Width = 100
    Height = 24
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
    Left = 191
    Top = 237
    Width = 100
    Height = 24
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
