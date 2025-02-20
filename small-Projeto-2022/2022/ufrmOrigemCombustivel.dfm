object FrmOrigemCombustivel: TFrmOrigemCombustivel
  Left = 261
  Top = 124
  BorderStyle = bsDialog
  Caption = 'Origem do combust'#237'vel'
  ClientHeight = 303
  ClientWidth = 387
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    387
    303)
  TextHeight = 13
  object lbLegenda: TLabel
    Left = 9
    Top = 263
    Width = 137
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '* Os campos s'#227'o obrigat'#243'rios'
  end
  object lbProduto: TLabel
    Left = 8
    Top = 2
    Width = 372
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Produto'
  end
  object btnOk: TBitBtn
    Left = 304
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object DBGridRastro: TDBGrid
    Left = 8
    Top = 24
    Width = 372
    Height = 233
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DSORIGEM
    DrawingStyle = gdsClassic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridRastroDrawColumnCell
    OnExit = DBGridRastroExit
    OnKeyDown = DBGridRastroKeyDown
    OnKeyPress = DBGridRastroKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'INDIMPORT'
        Title.Caption = 'Indicador de origem'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 144
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'UFORIGEM'
        Title.Caption = 'UF de origem'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 107
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PORIGEM'
        Title.Caption = 'Percentual'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 93
        Visible = True
      end>
  end
  object CDSORIGEM: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 120
    Top = 32
    object CDSORIGEMINDIMPORT: TIntegerField
      FieldName = 'INDIMPORT'
      DisplayFormat = '0'
      EditFormat = '0'
    end
    object CDSORIGEMUFORIGEM: TStringField
      FieldName = 'UFORIGEM'
      Size = 2
    end
    object CDSORIGEMPORIGEM: TFloatField
      FieldName = 'PORIGEM'
      DisplayFormat = '0.0000'
      EditFormat = '0.0000'
    end
  end
  object DSORIGEM: TDataSource
    DataSet = CDSORIGEM
    Left = 152
    Top = 32
  end
  object IBQORIGEM: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 64
    Top = 8
  end
end
