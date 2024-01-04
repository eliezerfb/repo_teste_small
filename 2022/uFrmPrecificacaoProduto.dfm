inherited FrmPrecificacaoProduto: TFrmPrecificacaoProduto
  Left = 581
  Top = 274
  BorderIcons = []
  Caption = 'Precifica'#231#227'o dos Produtos'
  ClientHeight = 483
  ClientWidth = 896
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 912
  ExplicitHeight = 522
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
    Left = 754
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
    TabOrder = 3
    OnClick = btnCancelarClick
  end
  object btnOK: TBitBtn
    Left = 620
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
    TabOrder = 2
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
    DrawingStyle = gdsClassic
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
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    OnDrawColumnCell = dbgPrincipalDrawColumnCell
    OnKeyDown = dbgPrincipalKeyDown
    Columns = <
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'PRODUTO'
        ReadOnly = True
        Width = 435
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'PRECO_CUSTO'
        ReadOnly = True
        Width = 100
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'PRECO_VENDA'
        ReadOnly = True
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PERC_LUC'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_NOVO'
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
    TabOrder = 0
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
      'Select'
      #9'REGISTRO,'
      #9'PRODUTO,'
      #9'PRECO_CUSTO,'
      #9'PRECO_VENDA,'
      #9'Case'
      #9#9'When LISTA > 0 then (((LISTA / PRECO_CUSTO) -1 ) * 100)'
      #9#9'When Coalesce(MARGEMLB,0) > 0 then MARGEMLB '
      #9#9'Else (((Coalesce(PRECO,0) / PRECO_CUSTO) -1 ) * 100)'
      #9'End PERC_LUC,'
      #9'Case'
      #9#9'When LISTA > 0 then LISTA'
      
        #9#9'When Coalesce(MARGEMLB,0) > 0 then PRECO_CUSTO + (PRECO_CUSTO ' +
        '* (MARGEMLB / 100) )'
      #9#9'Else Coalesce(PRECO,0)'
      #9'End PRECO_NOVO'
      'From'
      #9'(Select '
      #9#9'I.REGISTRO,'
      #9#9'I.DESCRICAO PRODUTO,'
      #9#9'Coalesce(I.LISTA,0) LISTA,'
      
        #9#9'(I.UNITARIO + (Coalesce(I.VICMSST,0) + Coalesce(I.VIPI,0) + Co' +
        'alesce(I.VFCPST,0)) / I.QUANTIDADE)  +'
      #9#9#9'('
      #9#9#9#9'(I.UNITARIO / C.MERCADORIA) * '
      
        #9#9#9#9'(Coalesce(C.FRETE,0) + Coalesce(C.SEGURO,0) + Coalesce(C.DES' +
        'PESAS,0) - Coalesce(C.DESCONTO,0))      '#9#9
      #9#9#9') PRECO_CUSTO,'
      #9#9'Coalesce(E.PRECO,0) PRECO_VENDA,'
      #9#9'E.MARGEMLB,'
      #9#9'E.PRECO'#9#9
      #9'From ITENS002 I'
      
        #9#9'Left Join COMPRAS C on C.NUMERONF = I.NUMERONF and C.FORNECEDO' +
        'R = I.FORNECEDOR'
      #9#9'Left Join ESTOQUE E on E.DESCRICAO = I.DESCRICAO'
      #9'Where I.NUMERONF = :NUMERONF'
      #9#9'and I.FORNECEDOR  =  :FORNECEDOR  '
      #9#9'and Coalesce(I.CODIGO,'#39#39') <> '#39#39
      #9') A'
      'Order By REGISTRO')
    ParamCheck = True
    UniDirectional = False
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
    object cdsProdutosNotaREGISTRO: TIBStringField
      FieldName = 'REGISTRO'
      Required = True
      Size = 10
    end
    object cdsProdutosNotaPRODUTO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'PRODUTO'
      Size = 45
    end
    object cdsProdutosNotaPRECO_CUSTO: TFloatField
      DisplayLabel = 'Custo de Compra'
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
      OnSetText = cdsProdutosNotaPRECO_NOVOSetText
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
  end
end
