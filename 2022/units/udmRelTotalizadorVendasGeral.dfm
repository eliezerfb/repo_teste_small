object dmRelTotalizadorVendasGeral: TdmRelTotalizadorVendasGeral
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 912
  Top = 336
  Height = 318
  Width = 639
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
      DisplayLabel = 'Forma'
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
      Size = 80
    end
  end
  object qryDocumentos: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 40
    Top = 32
  end
  object qryFormaPgto: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 128
    Top = 32
  end
  object qryDescontoItem: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
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
  end
  object qryDadosCST: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 40
    Top = 104
  end
  object qryDescontoDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 136
    Top = 160
  end
  object qryAcrescimoDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 136
    Top = 216
  end
  object qryTotalItens: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 224
    Top = 32
  end
  object qryTotalDoc: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 224
    Top = 104
  end
  object DataSetNF: TIBDataSet
    BufferChunks = 1000
    CachedUpdates = False
    Left = 248
    Top = 216
  end
  object DataSetItensNF: TIBDataSet
    BufferChunks = 1000
    CachedUpdates = False
    Left = 328
    Top = 216
  end
end
