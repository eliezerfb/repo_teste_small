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
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    781
    506)
  TextHeight = 13
  object DBGCONFIG: TDBGrid
    Left = 8
    Top = 8
    Width = 763
    Height = 449
    Anchors = [akLeft, akTop, akRight]
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    DataSource = DSConfig
    DrawingStyle = gdsClassic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
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
    Caption = 'OK'
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
