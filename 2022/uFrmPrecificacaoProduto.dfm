inherited FrmPrecificacaoProduto: TFrmPrecificacaoProduto
  Left = 711
  Top = 352
  BorderIcons = []
  Caption = 'Precifica'#231#227'o dos Produtos'
  ClientHeight = 483
  ClientWidth = 896
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lblTitulo: TLabel
    Left = 16
    Top = 11
    Width = 280
    Height = 19
    AutoSize = False
    Caption = 'Percentual de ajuste sobre o custo de compra'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnCancelar: TBitBtn
    Left = 620
    Top = 448
    Width = 126
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnCancelarClick
  end
  object btnOK: TBitBtn
    Left = 754
    Top = 448
    Width = 126
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnOKClick
  end
  object dbgPrincipal: TDBGrid
    Left = 16
    Top = 39
    Width = 863
    Height = 402
    Anchors = [akLeft, akTop, akRight]
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    DataSource = DSProdutos
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'PRODUTO'
        ReadOnly = True
        Width = 435
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_CUSTO'
        ReadOnly = True
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_VENDA'
        ReadOnly = True
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PERC_LUC'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_NOVO'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Width = 100
        Visible = True
      end>
  end
  object edtPercGeral: TEdit
    Left = 300
    Top = 9
    Width = 49
    Height = 21
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '0,00'
    OnExit = edtPercGeralExit
    OnKeyPress = edtPercGeralKeyPress
    OnKeyUp = edtPercGeralKeyUp
  end
  object DSProdutos: TDataSource
    DataSet = cdsProdutosNota
    Left = 184
    Top = 144
  end
  object ibdProdutosNota: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = True
    SelectSQL.Strings = (
      'Select '
      #9'I.REGISTRO,'
      #9'I.DESCRICAO PRODUTO,'
      #9'I.UNITARIO PRECO_CUSTO,'
      #9'Coalesce(E.PRECO,0) PRECO_VENDA,'
      #9'Coalesce(E.MARGEMLB,0) PERC_LUC,'
      #9'Coalesce(I.LISTA,0) PRECO_NOVO'
      'From ITENS002 I'
      #9'Left Join ESTOQUE E on E.DESCRICAO = I.DESCRICAO'
      'Where NUMERONF = :NUMERONF'
      #9'and I.FORNECEDOR  =  :FORNECEDOR  '
      'Order By I.REGISTRO')
    Left = 280
    Top = 144
    object ibdProdutosNotaREGISTRO: TIBStringField
      FieldName = 'REGISTRO'
      Origin = 'ITENS002.REGISTRO'
      Required = True
      Size = 10
    end
    object ibdProdutosNotaPRODUTO: TIBStringField
      FieldName = 'PRODUTO'
      Origin = 'ITENS002.DESCRICAO'
      Size = 45
    end
    object ibdProdutosNotaPRECO_CUSTO: TFloatField
      FieldName = 'PRECO_CUSTO'
      Origin = 'ITENS002.UNITARIO'
    end
    object ibdProdutosNotaPRECO_VENDA: TFloatField
      FieldName = 'PRECO_VENDA'
    end
    object ibdProdutosNotaPERC_LUC: TFloatField
      FieldName = 'PERC_LUC'
    end
    object ibdProdutosNotaPRECO_NOVO: TFloatField
      FieldName = 'PRECO_NOVO'
    end
  end
  object dspProdutosNota: TDataSetProvider
    DataSet = ibdProdutosNota
    Left = 248
    Top = 144
  end
  object cdsProdutosNota: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspProdutosNota'
    AfterInsert = cdsProdutosNotaAfterInsert
    BeforeDelete = cdsProdutosNotaBeforeDelete
    Left = 216
    Top = 144
    object cdsProdutosNotaREGISTRO: TStringField
      FieldName = 'REGISTRO'
      Required = True
      Size = 10
    end
    object cdsProdutosNotaPRODUTO: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'PRODUTO'
      Origin = 'ITENS002.DESCRICAO'
      Size = 45
    end
    object cdsProdutosNotaPRECO_CUSTO: TFloatField
      DisplayLabel = 'Pre'#231'o Custo'
      FieldName = 'PRECO_CUSTO'
      Origin = 'ITENS002.UNITARIO'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object cdsProdutosNotaPRECO_VENDA: TFloatField
      DisplayLabel = 'Pre'#231'o Atual'
      FieldName = 'PRECO_VENDA'
    end
    object cdsProdutosNotaPERC_LUC: TFloatField
      DisplayLabel = '% Lucro'
      FieldName = 'PERC_LUC'
      OnSetText = cdsProdutosNotaPERC_LUCSetText
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object cdsProdutosNotaPRECO_NOVO: TFloatField
      DisplayLabel = 'Novo Pre'#231'o'
      FieldName = 'PRECO_NOVO'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
  end
end
