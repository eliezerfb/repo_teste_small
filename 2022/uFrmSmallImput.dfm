inherited FrmSmallImput: TFrmSmallImput
  Left = 952
  Top = 487
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Imput'
  ClientHeight = 91
  ClientWidth = 267
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object btnOK: TBitBtn
    Left = 146
    Top = 49
    Width = 106
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnOKClick
  end
  object edtValor: TEdit
    Left = 16
    Top = 16
    Width = 236
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnKeyDown = edtValorKeyDown
    OnKeyPress = edtValorKeyPress
  end
end
