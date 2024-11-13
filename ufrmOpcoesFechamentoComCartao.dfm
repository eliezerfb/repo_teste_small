object FrmOpcoesFechamentoComCartao: TFrmOpcoesFechamentoComCartao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmOpcoesFechamentoComCartao'
  ClientHeight = 307
  ClientWidth = 434
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  DesignSize = (
    434
    307)
  TextHeight = 15
  object DBGOPCOES: TDBGrid
    Left = 2
    Top = 1
    Width = 431
    Height = 303
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Ctl3D = True
    DataSource = DSOPCOES
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Options = [dgColumnResize, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGOPCOESDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'TIPO'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OPCAO'
        Width = 375
        Visible = True
      end>
  end
  object DSOPCOES: TDataSource
    DataSet = CDSOPCOES
    Left = 224
    Top = 88
  end
  object CDSOPCOES: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 384
    Top = 88
    object CDSOPCOESTIPO: TStringField
      FieldName = 'TIPO'
      Size = 3
    end
    object CDSOPCOESOPCAO: TStringField
      FieldName = 'OPCAO'
      Size = 100
    end
  end
end
