inherited frmConfiguraNFSe: TfrmConfiguraNFSe
  BorderIcons = []
  Caption = 'Configura'#231#227'o NFS-e'
  ClientHeight = 507
  ClientWidth = 762
  Font.Name = 'Microsoft Sans Serif'
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 780
  ExplicitHeight = 554
  PixelsPerInch = 96
  TextHeight = 16
  object Label30: TLabel
    Left = 134
    Top = 117
    Width = 36
    Height = 15
    Caption = 'Senha'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label33: TLabel
    Left = 7
    Top = 117
    Width = 43
    Height = 15
    Caption = 'Usu'#225'rio'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label34: TLabel
    Left = 7
    Top = 166
    Width = 76
    Height = 15
    Caption = 'Frase Secreta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label41: TLabel
    Left = 7
    Top = 216
    Width = 93
    Height = 15
    Caption = 'Chave de Acesso'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label44: TLabel
    Left = 7
    Top = 264
    Width = 118
    Height = 15
    Caption = 'Chave de Autoriza'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lSSLLib: TLabel
    Left = 379
    Top = 23
    Width = 43
    Height = 16
    Alignment = taRightJustify
    Caption = 'SSLLib'
    Color = clBtnFace
    ParentColor = False
  end
  object lCryptLib: TLabel
    Left = 373
    Top = 50
    Width = 49
    Height = 16
    Alignment = taRightJustify
    Caption = 'CryptLib'
    Color = clBtnFace
    ParentColor = False
  end
  object lHttpLib: TLabel
    Left = 380
    Top = 77
    Width = 42
    Height = 16
    Alignment = taRightJustify
    Caption = 'HttpLib'
    Color = clBtnFace
    ParentColor = False
  end
  object lXmlSign: TLabel
    Left = 351
    Top = 104
    Width = 71
    Height = 16
    Alignment = taRightJustify
    Caption = 'XMLSignLib'
    Color = clBtnFace
    ParentColor = False
  end
  object lSSLLib1: TLabel
    Left = 372
    Top = 134
    Width = 49
    Height = 15
    Alignment = taRightJustify
    Caption = 'SSLType'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label49: TLabel
    Left = 8
    Top = 65
    Width = 101
    Height = 16
    Alignment = taRightJustify
    Caption = 'Layout da NFS-e'
    Color = clBtnFace
    ParentColor = False
  end
  object Label3: TLabel
    Left = 7
    Top = 320
    Width = 67
    Height = 16
    Caption = 'Certificado:'
  end
  object lbCertificado1: TLabel
    Left = 351
    Top = 224
    Width = 515
    Height = 66
    Cursor = crHandPoint
    AutoSize = False
    Caption = 'N'#250'mero de S'#233'rie + Nome'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
    WordWrap = True
    OnClick = lbCertificado1Click
  end
  object btnGravar: TBitBtn
    Left = 676
    Top = 472
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Gravar'
    TabOrder = 0
    OnClick = btnGravarClick
  end
  object rgTipoAmb: TRadioGroup
    Left = 7
    Top = 4
    Width = 249
    Height = 52
    Caption = 'Ambiente'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      'Produ'#231#227'o'
      'Homologa'#231#227'o')
    ParentFont = False
    TabOrder = 1
  end
  object edtSenhaWeb: TEdit
    Left = 134
    Top = 138
    Width = 126
    Height = 22
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtUserWeb: TEdit
    Left = 7
    Top = 138
    Width = 124
    Height = 22
    TabOrder = 3
  end
  object edtFraseSecWeb: TEdit
    Left = 7
    Top = 188
    Width = 254
    Height = 22
    TabOrder = 4
  end
  object edtChaveAcessoWeb: TEdit
    Left = 7
    Top = 238
    Width = 255
    Height = 22
    TabOrder = 5
  end
  object edtChaveAutorizWeb: TEdit
    Left = 7
    Top = 286
    Width = 255
    Height = 22
    TabOrder = 6
  end
  object cbSSLLib: TComboBox
    Left = 433
    Top = 15
    Width = 160
    Height = 24
    Style = csDropDownList
    TabOrder = 7
    OnChange = cbSSLLibChange
  end
  object cbCryptLib: TComboBox
    Left = 433
    Top = 42
    Width = 160
    Height = 24
    Style = csDropDownList
    TabOrder = 8
    OnChange = cbCryptLibChange
  end
  object cbHttpLib: TComboBox
    Left = 433
    Top = 69
    Width = 160
    Height = 24
    Style = csDropDownList
    TabOrder = 9
    OnChange = cbHttpLibChange
  end
  object cbXmlSignLib: TComboBox
    Left = 433
    Top = 96
    Width = 160
    Height = 24
    Style = csDropDownList
    TabOrder = 10
    OnChange = cbXmlSignLibChange
  end
  object cbSSLType: TComboBox
    Left = 433
    Top = 126
    Width = 160
    Height = 24
    Hint = 'Depende de configura'#231#227'o de  SSL.HttpLib'
    Style = csDropDownList
    TabOrder = 11
  end
  object cbLayoutNFSe: TComboBox
    Left = 8
    Top = 87
    Width = 160
    Height = 24
    Style = csDropDownList
    TabOrder = 12
  end
  object mmCertificado: TMemo
    Left = 7
    Top = 342
    Width = 747
    Height = 123
    Lines.Strings = (
      'mmCertificado')
    ReadOnly = True
    TabOrder = 13
  end
  object btnSelecionaCertificado: TBitBtn
    Left = 7
    Top = 471
    Width = 160
    Height = 25
    Caption = 'Selecionar Certificado'
    TabOrder = 14
    OnClick = btnSelecionaCertificadoClick
  end
  object BitBtn1: TBitBtn
    Left = 232
    Top = 472
    Width = 160
    Height = 25
    Caption = 'Outras configura'#231#245'es'
    TabOrder = 15
    OnClick = BitBtn1Click
  end
end
