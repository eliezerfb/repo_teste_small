object dmRelProdMonofasicoNota: TdmRelProdMonofasicoNota
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 201
  Width = 389
  PixelsPerInch = 96
  object cdsDados: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'DATA'
        DataType = ftDateTime
      end
      item
        Name = 'NF'
        DataType = ftWideString
        Size = 12
      end
      item
        Name = 'CODIGO'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'DESCRICAO'
        DataType = ftWideString
        Size = 120
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
        Size = 3
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
        Size = 4
      end
      item
        Name = 'NCM'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'CSTICMS'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'CSOSN'
        DataType = ftWideString
        Size = 6
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 48
    Top = 104
    object cdsDadosDATA: TDateTimeField
      DisplayLabel = 'Data'
      FieldName = 'DATA'
    end
    object cdsDadosNF: TWideStringField
      FieldName = 'NF'
      Size = 12
    end
    object cdsDadosCODIGO: TWideStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 6
    end
    object cdsDadosDESCRICAO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 120
    end
    object cdsDadosTOTAL: TFMTBCDField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      Precision = 18
      Size = 2
    end
    object cdsDadosCST: TWideStringField
      FieldName = 'CST'
      Size = 3
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
      Size = 4
    end
    object cdsDadosNCM: TWideStringField
      FieldName = 'NCM'
      Size = 10
    end
    object cdsDadosCSTICMS: TWideStringField
      DisplayLabel = 'CST ICMS'
      FieldName = 'CSTICMS'
      Size = 6
    end
    object cdsDadosCSOSN: TWideStringField
      FieldName = 'CSOSN'
      Size = 6
    end
  end
  object qryDados: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 48
    Top = 32
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
    Left = 120
    Top = 104
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
    Left = 216
    Top = 104
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
