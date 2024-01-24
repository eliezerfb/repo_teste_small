inherited FrmSmallImput: TFrmSmallImput
  Left = 952
  Top = 487
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Imput'
  ClientHeight = 98
  ClientWidth = 362
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 378
  ExplicitHeight = 137
  PixelsPerInch = 96
  TextHeight = 16
  object lblDescricao: TLabel
    Left = 16
    Top = 9
    Width = 331
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Descricao'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object btnOK: TBitBtn
    Left = 241
    Top = 60
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
    Top = 27
    Width = 331
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnKeyDown = edtValorKeyDown
    OnKeyPress = edtValorKeyPress
  end
end
