object frmSelecionaCertificadoNFSe: TfrmSelecionaCertificadoNFSe
  Left = 856
  Top = 275
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Selecione o certificado'
  ClientHeight = 359
  ClientWidth = 645
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 318
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Color = clWhite
    TabOrder = 0
    ExplicitWidth = 493
    object lbList: TListBox
      Left = 10
      Top = 10
      Width = 135
      Height = 63
      Align = alCustom
      ItemHeight = 13
      TabOrder = 0
      Visible = False
      OnDblClick = lbListDblClick
    end
    object Panel1: TPanel
      Left = 10
      Top = 10
      Width = 625
      Height = 298
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clWhite
      TabOrder = 1
      ExplicitWidth = 473
      object dbcgCertificados: TDBCtrlGrid
        Left = 2
        Top = 2
        Width = 621
        Height = 294
        Align = alClient
        AllowDelete = False
        AllowInsert = False
        DataSource = DSCertificados
        PanelHeight = 49
        PanelWidth = 604
        TabOrder = 0
        RowCount = 6
        SelectedColor = 14120960
        OnDblClick = dbcgCertificadosDblClick
        ExplicitHeight = 882
        object DBText1: TDBText
          Left = 8
          Top = 7
          Width = 425
          Height = 17
          DataField = 'Descricao'
          DataSource = DSCertificados
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnDblClick = dbcgCertificadosDblClick
        end
        object DBText2: TDBText
          Left = 64
          Top = 25
          Width = 89
          Height = 17
          DataField = 'Validade'
          DataSource = DSCertificados
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnDblClick = dbcgCertificadosDblClick
        end
        object Label1: TLabel
          Left = 8
          Top = 25
          Width = 51
          Height = 15
          Caption = 'Validade:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnDblClick = dbcgCertificadosDblClick
        end
        object DBText3: TDBText
          Left = 224
          Top = 25
          Width = 369
          Height = 17
          DataField = 'NUMEROSERIE'
          DataSource = DSCertificados
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnDblClick = dbcgCertificadosDblClick
        end
        object Label2: TLabel
          Left = 168
          Top = 25
          Width = 48
          Height = 15
          Caption = 'N'#250'mero:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnDblClick = dbcgCertificadosDblClick
        end
      end
    end
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 318
    Width = 645
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    ExplicitWidth = 493
    DesignSize = (
      645
      41)
    object btnSelect: TBitBtn
      Left = 479
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
      ExplicitLeft = 327
    end
    object btnCancel: TBitBtn
      Left = 559
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 407
    end
    object btnRemove: TBitBtn
      Left = 162
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
      Visible = False
      ExplicitLeft = 10
    end
  end
  object DSCertificados: TDataSource
    DataSet = cdsCertificados
    Left = 24
    Top = 112
  end
  object cdsCertificados: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 152
    object cdsCertificadosCERTIFICADO: TStringField
      DisplayLabel = 'Certificado'
      FieldName = 'CERTIFICADO'
      Size = 300
    end
    object cdsCertificadosVALIDADE: TStringField
      DisplayLabel = 'Validade'
      FieldName = 'VALIDADE'
      Size = 15
    end
    object cdsCertificadosDESCRICAO: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 200
    end
    object cdsCertificadosNUMEROSERIE: TStringField
      DisplayLabel = 'N'#250'mero de S'#233'rie'
      FieldName = 'NUMEROSERIE'
      Size = 50
    end
    object cdsCertificadosTIPO: TStringField
      DisplayLabel = 'Tipo'
      FieldName = 'TIPO'
      Size = 10
    end
  end
end
