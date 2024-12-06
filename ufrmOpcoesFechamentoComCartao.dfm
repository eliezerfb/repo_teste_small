object FrmOpcoesFechamentoComCartao: TFrmOpcoesFechamentoComCartao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmOpcoesFechamentoComCartao'
  ClientHeight = 184
  ClientWidth = 220
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel1: TBevel
    Left = 1
    Top = 1
    Width = 216
    Height = 182
    Shape = bsFrame
    Style = bsRaised
  end
  object DBGOPCOES: TDBGrid
    Left = 4
    Top = 6
    Width = 212
    Height = 176
    BorderStyle = bsNone
    Color = clWhite
    DataSource = DSOPCOES
    DrawingStyle = gdsClassic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDrawDataCell = DBGOPCOESDrawDataCell
    OnDblClick = DBGOPCOESDblClick
  end
  object DSOPCOES: TDataSource
    DataSet = CDSOPCOES
    Left = 112
    Top = 96
  end
  object CDSOPCOES: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDSOPCOESAfterScroll
    Left = 114
    Top = 46
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
