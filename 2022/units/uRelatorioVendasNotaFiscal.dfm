inherited frmRelVendasNotaFiscal: TfrmRelVendasNotaFiscal
  Caption = 'Relat'#243'rio de vendas (notas fiscais)'
  ClientWidth = 765
  OnClose = FormClose
  ExplicitWidth = 781
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnCancelar: TBitBtn
    TabOrder = 4
  end
  inherited btnAvancar: TBitBtn
    TabOrder = 3
  end
  inherited btnVoltar: TBitBtn
    TabOrder = 2
    OnClick = btnVoltarClick
  end
  object pnlPrincipal: TPanel
    Left = 180
    Top = 15
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 53
      Height = 13
      Caption = 'Per'#237'odo de'
    end
    object Label3: TLabel
      Left = 0
      Top = 45
      Width = 16
      Height = 13
      Caption = 'At'#233
    end
    object dtInicial: TDateTimePicker
      Left = 0
      Top = 15
      Width = 212
      Height = 20
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object dtFinal: TDateTimePicker
      Left = 0
      Top = 60
      Width = 212
      Height = 20
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object rbRelatorioICMS: TRadioButton
      Left = 0
      Top = 92
      Width = 185
      Height = 17
      Caption = 'Relat'#243'rio de ICMS'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = rbRelatorioICMSClick
    end
    object rbItemPorITem: TRadioButton
      Left = 0
      Top = 112
      Width = 185
      Height = 17
      Caption = 'Item por item'
      TabOrder = 3
      TabStop = True
      OnClick = rbItemPorITemClick
    end
    object cbListarCodigos: TCheckBox
      Left = 25
      Top = 131
      Width = 97
      Height = 17
      Caption = 'Listar c'#243'digos'
      Enabled = False
      TabOrder = 4
    end
  end
  object pnlSelOperacoes: TPanel
    Left = 496
    Top = 15
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object Label8: TLabel
      Left = 0
      Top = 0
      Width = 169
      Height = 13
      Caption = 'Selecione abaixo as opera'#231#245'es que'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 0
      Top = 16
      Width = 182
      Height = 13
      Caption = 'devem ser listadas (relat'#243'rio de Notas).'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object chkOperacoes: TCheckListBox
      Left = 0
      Top = 49
      Width = 230
      Height = 106
      Hint = 'Opera'#231#245'es que devem ser listadas'
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnMarcarTodosOper: TBitBtn
      Left = 130
      Top = 160
      Width = 100
      Height = 23
      Caption = 'Marcar todas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnMarcarTodosOperClick
    end
    object btnDesmarcarTodosOper: TBitBtn
      Left = 0
      Top = 160
      Width = 100
      Height = 23
      Caption = 'Desmarcar todas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnDesmarcarTodosOperClick
    end
  end
  object cdsRelICMS: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NOTA'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'EMISSAO'
        DataType = ftDate
      end
      item
        Name = 'CLIENTE'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'MERCADORIA'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'SERVICOS'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'FRETE'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'DESCONTO'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'DESPESAS'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'TOTAL'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'ICMS'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 40
    Top = 120
    object cdsRelICMSNOTA: TStringField
      DisplayLabel = 'Nota'
      FieldName = 'NOTA'
      Size = 12
    end
    object cdsRelICMSEMISSAO: TDateField
      DisplayLabel = 'Data'
      FieldName = 'EMISSAO'
    end
    object cdsRelICMSCLIENTE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE'
      Size = 200
    end
    object cdsRelICMSMERCADORIA: TFMTBCDField
      DisplayLabel = 'Produtos R$'
      FieldName = 'MERCADORIA'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSSERVICOS: TFMTBCDField
      DisplayLabel = 'Servi'#231'os R$'
      FieldName = 'SERVICOS'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSFRETE: TFMTBCDField
      DisplayLabel = 'Frete R$'
      FieldName = 'FRETE'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSDESCONTO: TFMTBCDField
      DisplayLabel = 'Desconto R$'
      FieldName = 'DESCONTO'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSDESPESAS: TFMTBCDField
      DisplayLabel = 'Outras R$'
      FieldName = 'DESPESAS'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSTOTAL: TFMTBCDField
      DisplayLabel = 'TOTAL R$'
      FieldName = 'TOTAL'
      Precision = 18
      Size = 6
    end
    object cdsRelICMSICMS: TFMTBCDField
      DisplayLabel = 'ICMS R$'
      FieldName = 'ICMS'
      Precision = 18
      Size = 6
    end
  end
  object cdsItemPorItem: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NOTA'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'EMISSAO'
        DataType = ftDate
      end
      item
        Name = 'CODIGO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DESCRICAO'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'QUANTIDADE'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'VENDIDOPOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'CUSTOCOMPRA'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 40
    Top = 152
    object cdsItemPorItemNOTA: TStringField
      DisplayLabel = 'Nota'
      FieldName = 'NOTA'
      Size = 12
    end
    object cdsItemPorItemEMISSAO: TDateField
      DisplayLabel = 'Data'
      FieldName = 'EMISSAO'
    end
    object cdsItemPorItemCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
    end
    object cdsItemPorItemDESCRICAO: TStringField
      DisplayLabel = 'Descri'#231#227'o do item'
      FieldName = 'DESCRICAO'
      Size = 150
    end
    object cdsItemPorItemQUANTIDADE: TFMTBCDField
      DisplayLabel = 'Quantidade'
      FieldName = 'QUANTIDADE'
      Precision = 18
      Size = 6
    end
    object cdsItemPorItemVENDIDOPOR: TFMTBCDField
      DisplayLabel = 'Vendido por'
      FieldName = 'VENDIDOPOR'
      Precision = 18
      Size = 6
    end
    object cdsItemPorItemCUSTOCOMPRA: TFMTBCDField
      DisplayLabel = 'Custo compra'
      FieldName = 'CUSTOCOMPRA'
      Precision = 18
      Size = 6
    end
  end
end
