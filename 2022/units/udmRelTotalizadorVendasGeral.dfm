object dmRelTotalizadorVendasGeral: TdmRelTotalizadorVendasGeral
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 318
  Width = 816
  PixelsPerInch = 96
  object cdsTotalPorFormaPgto: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'FORMA'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VALOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 400
    Top = 24
    object cdsTotalPorFormaPgtoFORMA: TStringField
      DisplayLabel = 'Forma de pagamento'
      FieldName = 'FORMA'
      Size = 100
    end
    object cdsTotalPorFormaPgtoVALOR: TFMTBCDField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
      Precision = 18
      Size = 2
    end
    object cdsTotalPorFormaPgtoTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 80
    end
  end
  object qryDocumentosDescAcresc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 40
    Top = 32
  end
  object qryFormaPgto: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 152
    Top = 32
  end
  object qryDescontoItemCFOP: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 136
    Top = 104
  end
  object cdsTotalCFOP: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CFOP'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VALOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 400
    Top = 80
    object cdsTotalCFOPCFOP: TStringField
      FieldName = 'CFOP'
      Size = 100
    end
    object cdsTotalCFOPVALOR: TFMTBCDField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
      Precision = 18
      Size = 2
    end
    object cdsTotalCFOPTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 80
    end
  end
  object cdsTotalCSOSN: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CSOSN'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VALOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 400
    Top = 136
    object cdsTotalCSOSNCSOSN: TStringField
      FieldName = 'CSOSN'
      Size = 100
    end
    object cdsTotalCSOSNVALOR: TFMTBCDField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
      Precision = 18
      Size = 2
    end
    object cdsTotalCSOSNTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 80
    end
  end
  object qryDadosCST: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 40
    Top = 104
  end
  object qryDescontoDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 136
    Top = 160
  end
  object qryAcrescimoDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 136
    Top = 216
  end
  object qryTotalItens: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 224
    Top = 32
  end
  object qryTotalDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 224
    Top = 104
  end
  object DataSetNF: TIBDataSet
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = False
    Left = 248
    Top = 216
  end
  object DataSetItensNF: TIBDataSet
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = False
    Left = 328
    Top = 216
  end
  object qryDescontoItemCSOSN: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 48
    Top = 176
  end
  object qryItensDocumento: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 40
    Top = 232
  end
  object qryDescontoItem: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 232
    Top = 168
  end
  object qryNFs: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 288
    Top = 96
  end
  object cdsTotalCFOPTemp: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CFOP'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VALOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 528
    Top = 80
    object cdsTotalCFOPTempCFOP: TStringField
      FieldName = 'CFOP'
      Size = 100
    end
    object cdsTotalCFOPTempVALOR: TFMTBCDField
      FieldName = 'VALOR'
      Precision = 18
      Size = 6
    end
    object cdsTotalCFOPTempTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 80
    end
  end
  object cdsTotalCSOSNTemp: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CSOSN'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VALOR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 4
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 528
    Top = 136
    object cdsTotalCSOSNTempCSOSN: TStringField
      FieldName = 'CSOSN'
      Size = 100
    end
    object cdsTotalCSOSNTempVALOR: TFMTBCDField
      FieldName = 'VALOR'
      Precision = 18
    end
    object cdsTotalCSOSNTempTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 80
    end
  end
  object qryEmitente: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 296
    Top = 32
  end
end
