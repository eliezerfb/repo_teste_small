inherited frmSelecionaTEF: TfrmSelecionaTEF
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Selecionar TEF'
  ClientHeight = 314
  ClientWidth = 474
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 490
  ExplicitHeight = 353
  PixelsPerInch = 96
  TextHeight = 16
  object lbxTEFs: TListBox
    Left = 0
    Top = 0
    Width = 474
    Height = 263
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 29
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 263
    Width = 474
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TBitBtn
      Left = 106
      Top = 6
      Width = 129
      Height = 35
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancelar: TBitBtn
      Left = 240
      Top = 6
      Width = 129
      Height = 35
      Caption = '&Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
end
