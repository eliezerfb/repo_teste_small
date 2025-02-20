object frmSelectCertificate: TfrmSelectCertificate
  Left = 379
  Top = 292
  Width = 509
  Height = 398
  BorderIcons = []
  Caption = 'Selecione o certificado'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 493
    Height = 318
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object lbList: TListBox
      Left = 10
      Top = 10
      Width = 473
      Height = 298
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = lbListDblClick
    end
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 318
    Width = 493
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    DesignSize = (
      493
      41)
    object btnSelect: TBitBtn
      Left = 334
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Selecionar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnSelectClick
    end
    object btnCancel: TBitBtn
      Left = 414
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
    object btnRemove: TBitBtn
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Remover'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 2
      OnClick = btnRemoveClick
    end
  end
end
