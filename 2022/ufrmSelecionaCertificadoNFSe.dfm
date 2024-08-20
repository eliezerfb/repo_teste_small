object frmSelecionaCertificadoNFSe: TfrmSelecionaCertificadoNFSe
  Left = 856
  Top = 275
  BorderIcons = []
  Caption = 'Selecione o certificado'
  ClientHeight = 377
  ClientWidth = 598
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    598
    377)
  TextHeight = 16
  object btnRemove: TBitBtn
    Left = 115
    Top = 352
    Width = 100
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Remover'
    ModalResult = 1
    TabOrder = 0
    Visible = False
    ExplicitLeft = 107
  end
  object btnSelect: TBitBtn
    Left = 390
    Top = 352
    Width = 100
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Selecionar'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnSelectClick
  end
  object btnCancel: TBitBtn
    Left = 493
    Top = 352
    Width = 100
    Height = 22
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 4
    Top = 0
    Width = 589
    Height = 346
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    TabOrder = 3
    object dbcgCertificados: TDBCtrlGrid
      Left = 2
      Top = 2
      Width = 585
      Height = 342
      Align = alClient
      AllowDelete = False
      AllowInsert = False
      DataSource = DSCertificados
      PanelHeight = 57
      PanelWidth = 568
      TabOrder = 0
      RowCount = 6
      SelectedColor = 14120960
      OnDblClick = dbcgCertificadosDblClick
      ExplicitLeft = -6
      ExplicitWidth = 583
      object DBText1: TDBText
        Left = 8
        Top = 7
        Width = 425
        Height = 17
        DataField = 'Descricao'
        DataSource = DSCertificados
        OnDblClick = dbcgCertificadosDblClick
      end
      object DBText2: TDBText
        Left = 70
        Top = 25
        Width = 89
        Height = 17
        DataField = 'Validade'
        DataSource = DSCertificados
        OnDblClick = dbcgCertificadosDblClick
      end
      object Label1: TLabel
        Left = 8
        Top = 25
        Width = 58
        Height = 16
        Caption = 'Validade:'
        OnDblClick = dbcgCertificadosDblClick
      end
      object DBText3: TDBText
        Left = 229
        Top = 25
        Width = 369
        Height = 17
        DataField = 'NUMEROSERIE'
        DataSource = DSCertificados
        OnDblClick = dbcgCertificadosDblClick
      end
      object Label2: TLabel
        Left = 173
        Top = 25
        Width = 51
        Height = 16
        Caption = 'N'#250'mero:'
        OnDblClick = dbcgCertificadosDblClick
      end
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
