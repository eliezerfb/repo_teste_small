inherited frmOutrasConfiguracoesNFSe: TfrmOutrasConfiguracoesNFSe
  BorderIcons = []
  Caption = 'Outras Configura'#231#245'es da NFS-e'
  ClientHeight = 495
  ClientWidth = 1022
  Font.Name = 'Microsoft Sans Serif'
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 1040
  ExplicitHeight = 542
  PixelsPerInch = 96
  TextHeight = 16
  object DBGCONFIG: TDBGrid
    Left = 8
    Top = 8
    Width = 1004
    Height = 449
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
  object btnOk: TBitBtn
    Left = 923
    Top = 468
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOkClick
    ExplicitTop = 478
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
  object DSConfig: TDataSource
    DataSet = CDSConfig
    Left = 96
    Top = 32
  end
end
