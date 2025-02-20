inherited frmConfigEmailAutContab: TfrmConfigEmailAutContab
  Left = 707
  Top = 427
  BorderStyle = bsDialog
  Caption = 'Envio autom'#225'tico de XML'
  ClientHeight = 264
  ClientWidth = 510
  Font.Charset = ANSI_CHARSET
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 526
  ExplicitHeight = 303
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 200
    Top = 168
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
  object Image1: TImage
    Left = 15
    Top = 15
    Width = 121
    Height = 97
    AutoSize = True
    Center = True
    Transparent = True
  end
  object edtEmailContab: TEdit
    Left = 200
    Top = 183
    Width = 290
    Height = 19
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object cbAtivarEnvio: TCheckBox
    Left = 200
    Top = 14
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
    OnClick = cbAtivarEnvioClick
  end
  object btnOk: TBitBtn
    Left = 370
    Top = 221
    Width = 120
    Height = 25
    Caption = 'OK'
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancelar: TBitBtn
    Left = 200
    Top = 221
    Width = 120
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = btnCancelarClick
  end
  object gbDocumentos: TGroupBox
    Left = 200
    Top = 36
    Width = 290
    Height = 82
    Caption = 'Enviar os XML'#39's de:'
    TabOrder = 1
    object cbNFeSaida: TCheckBox
      Left = 9
      Top = 18
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
    object cbNFeEntrada: TCheckBox
      Left = 9
      Top = 38
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
    object cbNFCeSAT: TCheckBox
      Left = 9
      Top = 58
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
  end
  object cbIncluirRelatorio: TCheckBox
    Left = 200
    Top = 126
    Width = 169
    Height = 17
    Caption = 'Incluir relat'#243'rio de totalizadores'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cbIncluirRelMonofasicos: TCheckBox
    Left = 200
    Top = 146
    Width = 209
    Height = 17
    Caption = 'Incluir relat'#243'rio de produtos monof'#225'sicos'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
end
