object FrmInformacoesRastreamento: TFrmInformacoesRastreamento
  Left = 416
  Top = 144
  BorderStyle = bsDialog
  Caption = 'Rastreabilidade'
  ClientHeight = 349
  ClientWidth = 884
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    884
    349)
  TextHeight = 13
  object lbLegenda: TLabel
    Left = 9
    Top = 296
    Width = 194
    Height = 13
    Caption = '* Os campos em amarelo s'#227'o obrigat'#243'rios'
  end
  object lbQuantidadeItem: TLabel
    Left = 8
    Top = 37
    Width = 134
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = 'Quantidade do item na nota:'
    ParentBiDiMode = False
  end
  object lbProduto: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 15
    Caption = 'Produto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbValorQuantidadeItem: TLabel
    Left = 149
    Top = 37
    Width = 6
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '0'
    ParentBiDiMode = False
  end
  object lbQuantidadeAcumulada: TLabel
    Left = 224
    Top = 37
    Width = 161
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = 'Quantidade acumulada nos lotes: '
    ParentBiDiMode = False
  end
  object DBTValorQuantidadeAcumulada: TDBText
    Left = 386
    Top = 37
    Width = 81
    Height = 13
    DataField = 'QUANTIDADEACUMULADA'
    DataSource = DSLOTES
  end
  object btnOk: TBitBtn
    Left = 342
    Top = 314
    Width = 265
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Confirmar e avan'#231'ar para o pr'#243'ximo item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancelar: TBitBtn
    Left = 611
    Top = 314
    Width = 265
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'N'#227'o informar para este item'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object DBGridRastro: TDBGrid
    Left = 8
    Top = 80
    Width = 867
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DSLOTES
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
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
        Expanded = False
        FieldName = 'NUMERO'
        Title.Caption = 'N'#250'mero do lote'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        Title.Caption = 'Quantidade no lote'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DTFABRICACAO'
        Title.Caption = 'Data de fabrica'#231#227'o'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DTVALIDADE'
        Title.Caption = 'Data de validade'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CODIGOAGREGACAO'
        Title.Caption = 'C'#243'digo de Agrega'#231#227'o'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Microsoft Sans Serif'
        Title.Font.Style = []
        Width = 220
        Visible = True
      end>
  end
  object CDSLOTES: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    AfterOpen = CDSLOTESAfterOpen
    Left = 24
    Top = 120
    object CDSLOTESNUMERO: TIBStringField
      FieldName = 'NUMERO'
    end
    object CDSLOTESQUANTIDADE: TFloatField
      FieldName = 'QUANTIDADE'
    end
    object CDSLOTESDTFABRICACAO: TDateField
      FieldName = 'DTFABRICACAO'
    end
    object CDSLOTESDTVALIDADE: TDateField
      FieldName = 'DTVALIDADE'
    end
    object CDSLOTESCODIGOAGREGACAO: TIBStringField
      FieldName = 'CODIGOAGREGACAO'
    end
    object CDSLOTESQUANTIDADEACUMULADA: TAggregateField
      DefaultExpression = '0'
      FieldName = 'QUANTIDADEACUMULADA'
      Active = True
      DisplayName = ''
      Expression = 'sum(QUANTIDADE)'
    end
  end
  object DSLOTES: TDataSource
    DataSet = CDSLOTES
    Left = 56
    Top = 120
  end
end
