object FrmQRCodePixEst: TFrmQRCodePixEst
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'QrCode para PIX'
  ClientHeight = 441
  ClientWidth = 486
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  DesignSize = (
    486
    441)
  TextHeight = 15
  object lblValor: TLabel
    Left = 0
    Top = 0
    Width = 486
    Height = 33
    Align = alTop
    Alignment = taCenter
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 108
  end
  object btnCancel: TBitBtn
    Left = 350
    Top = 376
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object Memo1: TMemo
    Left = 40
    Top = 104
    Width = 385
    Height = 233
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
