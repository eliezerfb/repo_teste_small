inherited frmConfigEmailAutContab: TfrmConfigEmailAutContab
  Left = 707
  Top = 427
  BorderStyle = bsDialog
  Caption = 'Envio autom'#225'tico de XML'
  ClientHeight = 225
  ClientWidth = 330
  Font.Charset = ANSI_CHARSET
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 20
    Top = 126
    Width = 111
    Height = 13
    Caption = 'e-mail da contabilidade:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edtEmailContab: TEdit
    Left = 20
    Top = 141
    Width = 290
    Height = 19
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cbAtivarEnvio: TCheckBox
    Left = 20
    Top = 12
    Width = 290
    Height = 17
    Caption = 'Envio autom'#225'tico dos XML'#39's na primeira abertura do m'#234's'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object gbDocumentosEnviar: TGroupBox
    Left = 20
    Top = 35
    Width = 290
    Height = 86
    Caption = 'Enviar os XML'#39's de:'
    TabOrder = 1
    object cbNFCeSAT: TCheckBox
      Left = 10
      Top = 60
      Width = 112
      Height = 17
      Caption = 'NFC-e/SAT'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cbNFeEntrada: TCheckBox
      Left = 10
      Top = 40
      Width = 112
      Height = 17
      Caption = 'NF-e'#39's de Entrada'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object cbNFeSaida: TCheckBox
      Left = 10
      Top = 20
      Width = 112
      Height = 17
      Caption = 'NF-e'#39's de Sa'#237'da'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object btnOk: TBitBtn
    Left = 190
    Top = 180
    Width = 120
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancelar: TBitBtn
    Left = 20
    Top = 180
    Width = 120
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = btnCancelarClick
  end
end
