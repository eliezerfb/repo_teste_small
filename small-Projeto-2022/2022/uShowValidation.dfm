object frmShowValidation: TfrmShowValidation
  Left = 415
  Top = 240
  Width = 523
  Height = 292
  Caption = 'Valida'#231#227'o'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 507
    Height = 215
    Align = alClient
    ReadOnly = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 215
    Width = 507
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btOk: TButton
      Left = 424
      Top = 8
      Width = 75
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
