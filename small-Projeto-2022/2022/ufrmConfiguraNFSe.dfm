inherited frmConfiguraNFSe: TfrmConfiguraNFSe
  BorderIcons = []
  Caption = 'Configura'#231#227'o NFS-e'
  ClientHeight = 565
  ClientWidth = 805
  Font.Name = 'Microsoft Sans Serif'
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 823
  ExplicitHeight = 612
  PixelsPerInch = 96
  TextHeight = 16
  object btnGravar: TBitBtn
    Left = 719
    Top = 535
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Gravar'
    TabOrder = 0
    OnClick = btnGravarClick
  end
  object pgConexoesNFSe: TPageControl
    Left = 2
    Top = 1
    Width = 792
    Height = 531
    ActivePage = tsConexaoPrefeitura
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object tsConexaoPrefeitura: TTabSheet
      Caption = 'Transmiss'#227'o'
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
        TabOrder = 0
      end
      object edtSenhaWeb: TEdit
        Left = 134
        Top = 138
        Width = 126
        Height = 22
        PasswordChar = '*'
        TabOrder = 1
      end
      object edtUserWeb: TEdit
        Left = 7
        Top = 138
        Width = 124
        Height = 22
        TabOrder = 2
      end
      object edtFraseSecWeb: TEdit
        Left = 7
        Top = 188
        Width = 254
        Height = 22
        TabOrder = 3
      end
      object edtChaveAcessoWeb: TEdit
        Left = 7
        Top = 238
        Width = 255
        Height = 22
        TabOrder = 4
      end
      object edtChaveAutorizWeb: TEdit
        Left = 7
        Top = 286
        Width = 255
        Height = 22
        TabOrder = 5
      end
      object cbSSLLib: TComboBox
        Left = 433
        Top = 15
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 6
        OnChange = cbSSLLibChange
      end
      object cbCryptLib: TComboBox
        Left = 433
        Top = 42
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 7
        OnChange = cbCryptLibChange
      end
      object cbHttpLib: TComboBox
        Left = 433
        Top = 69
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 8
        OnChange = cbHttpLibChange
      end
      object cbXmlSignLib: TComboBox
        Left = 433
        Top = 96
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 9
        OnChange = cbXmlSignLibChange
      end
      object cbSSLType: TComboBox
        Left = 433
        Top = 126
        Width = 160
        Height = 24
        Hint = 'Depende de configura'#231#227'o de  SSL.HttpLib'
        Style = csDropDownList
        TabOrder = 10
      end
      object cbLayoutNFSe: TComboBox
        Left = 8
        Top = 87
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 11
      end
      object mmCertificado: TMemo
        Left = 7
        Top = 342
        Width = 747
        Height = 123
        Lines.Strings = (
          'mmCertificado')
        ReadOnly = True
        TabOrder = 12
      end
      object btnSelecionaCertificado: TBitBtn
        Left = 7
        Top = 471
        Width = 160
        Height = 25
        Caption = 'Selecionar Certificado'
        TabOrder = 13
        OnClick = btnSelecionaCertificadoClick
      end
    end
    object tbOutrasInformacoes: TTabSheet
      Caption = 'Outras informa'#231#245'es'
      ImageIndex = 1
      DesignSize = (
        784
        500)
      object DBGCONFIG: TDBGrid
        Left = 2
        Top = 8
        Width = 778
        Height = 489
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Ctl3D = False
        DataSource = DSConfig
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'PARAMETRO'
            Title.Caption = 'Par'#226'metro'
            Width = 273
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR'
            Title.Caption = 'Valor'
            Width = 450
            Visible = True
          end>
      end
    end
  end
  object DSConfig: TDataSource
    DataSet = CDSConfig
    Left = 96
    Top = 32
  end
  object CDSConfig: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 32
    object CDSConfigPARAMETRO: TStringField
      FieldName = 'PARAMETRO'
      Size = 150
    end
    object CDSConfigVALOR: TStringField
      FieldName = 'VALOR'
      Size = 300
    end
  end
end
