object FConfiguracaoNFSe: TFConfiguracaoNFSe
  Left = 981
  Top = 127
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o da NFS-e'
  ClientHeight = 506
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    781
    506)
  PixelsPerInch = 96
  TextHeight = 13
  object DBGCONFIG: TDBGrid
    Left = 8
    Top = 8
    Width = 763
    Height = 449
    Anchors = [akLeft, akTop, akRight]
    DataSource = DSConfig
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
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
    Left = 681
    Top = 472
    Width = 89
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btnOkClick
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
