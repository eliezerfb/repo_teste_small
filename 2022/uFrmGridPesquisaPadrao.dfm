inherited FrmGripPesquisaPadrao: TFrmGripPesquisaPadrao
  Left = 484
  Top = 312
  BorderIcons = []
  Caption = 'Pesquisa'
  ClientHeight = 421
  ClientWidth = 975
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    975
    421)
  PixelsPerInch = 96
  TextHeight = 16
  object lblTitulo2: TLabel
    Left = 20
    Top = 82
    Width = 933
    Height = 14
    AutoSize = False
    Caption = 'Titulo 2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lblTitulo1: TLabel
    Left = 20
    Top = 20
    Width = 933
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Titulo 1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edPesquisa: TEdit
    Left = 20
    Top = 102
    Width = 933
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnKeyDown = edPesquisaKeyDown
  end
  object dtpFiltro: TDateTimePicker
    Left = 20
    Top = 49
    Width = 933
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Date = 35796.376154398150000000
    Time = 35796.376154398150000000
    DateFormat = dfLong
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    OnClick = dtpFiltroClick
    OnCloseUp = dtpFiltroCloseUp
    OnKeyDown = dtpFiltroKeyDown
  end
  object dbGridPrincipal: TDBGrid
    Left = 20
    Top = 136
    Width = 933
    Height = 237
    Anchors = [akLeft, akTop, akRight]
    DataSource = DSPesquisa
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbGridPrincipalDblClick
  end
  object btnOK: TBitBtn
    Left = 698
    Top = 384
    Width = 122
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancelar: TBitBtn
    Left = 831
    Top = 384
    Width = 122
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnCancelarClick
  end
  object IBQPESQUISA: TIBQuery
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 144
    Top = 160
  end
  object DSPesquisa: TDataSource
    DataSet = IBQPESQUISA
    Left = 184
    Top = 160
  end
end
