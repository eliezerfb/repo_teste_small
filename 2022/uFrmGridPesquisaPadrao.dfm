inherited FrmGridPesquisaPadrao: TFrmGridPesquisaPadrao
  Left = 484
  Top = 312
  BorderIcons = []
  Caption = 'Pesquisa'
  ClientHeight = 420
  ClientWidth = 975
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 991
  ExplicitHeight = 459
  PixelsPerInch = 96
  DesignSize = (
    975
    420)
  TextHeight = 16
  object lblTitulo2: TLabel
    Left = 20
    Top = 78
    Width = 937
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
    Top = 15
    Width = 935
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
    Top = 98
    Width = 935
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
    Top = 45
    Width = 935
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Date = 35796.000000000000000000
    Time = 0.376154398152721100
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
    Top = 132
    Width = 935
    Height = 225
    Anchors = [akLeft, akTop, akRight]
    DataSource = DSPesquisa
    DrawingStyle = gdsClassic
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
    OnKeyDown = dbGridPrincipalKeyDown
  end
  object btnOK: TBitBtn
    Left = 712
    Top = 376
    Width = 120
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = '&OK'
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
    Left = 836
    Top = 376
    Width = 120
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
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 144
    Top = 156
  end
  object DSPesquisa: TDataSource
    DataSet = IBQPESQUISA
    Left = 184
    Top = 156
  end
end
