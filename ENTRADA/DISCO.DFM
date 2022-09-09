object BtnBottomDlg: TBtnBottomDlg
  Left = 269
  Top = 240
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 87
  ClientWidth = 302
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  PixelsPerInch = 96
  Position = poScreenCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 31
    Top = 16
    Width = 239
    Height = 16
    Caption = 'Insira o disco 2 e, em seguida, clique Ok'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TBitBtn
    Left = 70
    Top = 52
    Width = 77
    Height = 27
    TabOrder = 0
    OnClick = OKBtnClick
    Kind = bkOK
    Margin = 2
    Spacing = -1
    IsControl = True
  end
  object CancelBtn: TBitBtn
    Left = 154
    Top = 52
    Width = 77
    Height = 27
    TabOrder = 1
    Kind = bkCancel
    Margin = 2
    Spacing = -1
    IsControl = True
  end
end
