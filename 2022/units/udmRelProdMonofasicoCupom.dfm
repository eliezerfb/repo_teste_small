object dmRelProdMonofasicoCupom: TdmRelProdMonofasicoCupom
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 316
  Width = 600
  PixelsPerInch = 96
  object cdsDados: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'DATA'
        DataType = ftDateTime
      end
      item
        Name = 'CAIXA'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'CUPOM'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'CODIGO'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'DESCRICAO'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'TOTAL'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'CST'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'PISPERC'
        DataType = ftFMTBcd
        Precision = 8
        Size = 4
      end
      item
        Name = 'PISVLR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'COFINSPERC'
        DataType = ftFMTBcd
        Precision = 8
        Size = 4
      end
      item
        Name = 'COFINSVLR'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'CFOP'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'NCM'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'CSTICMS'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'CSOSN'
        DataType = ftWideString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 72
    Top = 136
    object cdsDadosDATA: TDateTimeField
      DisplayLabel = 'Data'
      FieldName = 'DATA'
    end
    object cdsDadosCAIXA: TWideStringField
      DisplayLabel = 'Caixa'
      FieldName = 'CAIXA'
    end
    object cdsDadosCUPOM: TWideStringField
      DisplayLabel = 'Cupom'
      FieldName = 'CUPOM'
    end
    object cdsDadosCODIGO: TWideStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
    end
    object cdsDadosDESCRICAO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
    end
    object cdsDadosTOTAL: TFMTBCDField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      Precision = 18
      Size = 2
    end
    object cdsDadosCST: TWideStringField
      FieldName = 'CST'
    end
    object cdsDadosPISPERC: TFMTBCDField
      DisplayLabel = '% PIS'
      FieldName = 'PISPERC'
      Precision = 8
      Size = 4
    end
    object cdsDadosPISVLR: TFMTBCDField
      DisplayLabel = 'R$ PIS'
      FieldName = 'PISVLR'
      Precision = 18
      Size = 2
    end
    object cdsDadosCOFINSPERC: TFMTBCDField
      DisplayLabel = '% COFINS'
      FieldName = 'COFINSPERC'
      Precision = 8
      Size = 4
    end
    object cdsDadosCOFINSVLR: TFMTBCDField
      DisplayLabel = 'R$ COFINS'
      FieldName = 'COFINSVLR'
      Precision = 18
      Size = 2
    end
    object cdsDadosCFOP: TWideStringField
      FieldName = 'CFOP'
    end
    object cdsDadosNCM: TWideStringField
      FieldName = 'NCM'
    end
    object cdsDadosCSTICMS: TWideStringField
      DisplayLabel = 'CST ICMS'
      FieldName = 'CSTICMS'
    end
    object cdsDadosCSOSN: TWideStringField
      FieldName = 'CSOSN'
    end
  end
  object qryDados: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 72
    Top = 64
  end
  object cdsCFOP: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CFOP'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'TOTAL'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 144
    Top = 136
    object cdsCFOPCFOP: TWideStringField
      FieldName = 'CFOP'
    end
    object cdsCFOPTOTAL: TFMTBCDField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      Precision = 18
      Size = 2
    end
  end
  object cdsCSTICMSCSOSN: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CSTICMS'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'CSOSN'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'TOTAL'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 240
    Top = 136
    object cdsCSTICMSCSOSNCSTICMS: TWideStringField
      FieldName = 'CSTICMS'
    end
    object cdsCSTICMSCSOSNCSOSN: TWideStringField
      FieldName = 'CSOSN'
    end
    object cdsCSTICMSCSOSNTOTAL: TFMTBCDField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      Precision = 18
      Size = 2
    end
  end
end
