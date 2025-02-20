object FrmTransacoesItau: TFrmTransacoesItau
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Transa'#231#245'es Integra'#231#227'o Ita'#250
  ClientHeight = 440
  ClientWidth = 810
  Color = clWhite
  Constraints.MaxHeight = 479
  Constraints.MaxWidth = 826
  Constraints.MinHeight = 479
  Constraints.MinWidth = 826
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 20
    Top = 15
    Width = 770
    Height = 362
    DataSource = DSTransacoes
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DATAHORA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NUMERONF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Width = 116
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ORDERID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Width = 285
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATUS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Width = 104
        Visible = True
      end>
  end
  object btnOK: TBitBtn
    Left = 691
    Top = 396
    Width = 100
    Height = 25
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnAtualizar: TBitBtn
    Left = 17
    Top = 396
    Width = 100
    Height = 25
    Caption = 'Atualizar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnAtualizarClick
  end
  object btnCancelar: TBitBtn
    Left = 121
    Top = 396
    Width = 100
    Height = 25
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCancelarClick
  end
  object btnEstornar: TBitBtn
    Left = 225
    Top = 396
    Width = 100
    Height = 25
    Caption = 'Estornar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnEstornarClick
  end
  object DSTransacoes: TDataSource
    DataSet = ibqTransacoes
    OnDataChange = DSTransacoesDataChange
    Left = 512
    Top = 200
  end
  object ibqTransacoes: TIBDataSet
    Database = Form1.IBDatabase1
    Transaction = ibtTransacoes
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from ITAUTRANSACAO'
      'where'
      '  IDTRANSACAO = :OLD_IDTRANSACAO')
    RefreshSQL.Strings = (
      'Select '
      #9'IDTRANSACAO,'
      #9'NUMERONF,'
      #9'CAIXA,'
      #9'ORDERID,'
      #9'DATAHORA,'
      #9'STATUS,'
      #9'VALOR'
      'From ITAUTRANSACAO '
      'where'
      '  IDTRANSACAO = :IDTRANSACAO')
    SelectSQL.Strings = (
      'Select '
      #9'*'
      'From ITAUTRANSACAO')
    ModifySQL.Strings = (
      'update ITAUTRANSACAO'
      'set'
      '  '#9'NUMERONF = :NUMERONF,'
      #9'CAIXA = :CAIXA,'
      #9'ORDERID = :ORDERID,'
      #9'DATAHORA = :DATAHORA,'
      #9'STATUS = :STATUS,'
      #9'VALOR = :VALOR'
      'where'
      '  IDTRANSACAO = :OLD_IDTRANSACAO')
    ParamCheck = True
    UniDirectional = False
    Filtered = True
    Left = 587
    Top = 200
    object ibqTransacoesIDTRANSACAO: TIntegerField
      FieldName = 'IDTRANSACAO'
      Origin = 'ITAUTRANSACAO.IDTRANSACAO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibqTransacoesNUMERONF: TIBStringField
      DisplayLabel = 'N'#250'mero da venda'
      FieldName = 'NUMERONF'
      Origin = 'ITAUTRANSACAO.NUMERONF'
      Size = 6
    end
    object ibqTransacoesCAIXA: TIBStringField
      DisplayLabel = 'Caixa'
      FieldName = 'CAIXA'
      Origin = 'ITAUTRANSACAO.CAIXA'
      Size = 3
    end
    object ibqTransacoesORDERID: TIBStringField
      DisplayLabel = 'Order'
      FieldName = 'ORDERID'
      Origin = 'ITAUTRANSACAO.ORDERID'
      Size = 40
    end
    object ibqTransacoesDATAHORA: TDateTimeField
      DisplayLabel = 'Data e Hora'
      FieldName = 'DATAHORA'
      Origin = 'ITAUTRANSACAO.DATAHORA'
    end
    object ibqTransacoesSTATUS: TIBStringField
      DisplayLabel = 'Status'
      FieldName = 'STATUS'
      Origin = 'ITAUTRANSACAO.STATUS'
      Size = 12
    end
    object ibqTransacoesVALOR: TIBBCDField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
      Origin = 'ITAUTRANSACAO.VALOR'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
  end
  object ibtTransacoes: TIBTransaction
    DefaultDatabase = Form1.IBDatabase1
    Left = 664
    Top = 200
  end
end
