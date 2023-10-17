inherited FrmProdutosDevolucao: TFrmProdutosDevolucao
  Left = 563
  Top = 337
  BorderIcons = []
  Caption = 'Produtos para devolu'#231#227'o'
  ClientHeight = 483
  ClientWidth = 994
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label10: TLabel
    Left = 12
    Top = 11
    Width = 549
    Height = 19
    AutoSize = False
    Caption = 
      'Selecione quais produtos ser'#227'o devolvidos e ajuste a quantidade ' +
      'deles, se necess'#225'rio.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 39
    Width = 961
    Height = 402
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    DataSource = DSProdutos
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'MARCADO'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        Width = 61
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UNITARIO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VBC'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VICMS'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VBCST'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VICMSST'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VIPI'
        Width = 85
        Visible = True
      end>
  end
  object btnOK: TBitBtn
    Left = 846
    Top = 448
    Width = 132
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object btnCancelar: TBitBtn
    Left = 715
    Top = 448
    Width = 132
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object DSProdutos: TDataSource
    DataSet = cdsProdutosNota
    Left = 184
    Top = 144
  end
  object cdsProdutosNota: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspProdutosNota'
    Left = 216
    Top = 144
    object cdsProdutosNotaMARCADO: TStringField
      FieldName = 'MARCADO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object cdsProdutosNotaNUMERONF: TStringField
      FieldName = 'NUMERONF'
      Origin = 'ITENS002.NUMERONF'
      Size = 12
    end
    object cdsProdutosNotaCODIGO: TStringField
      FieldName = 'CODIGO'
      Origin = 'ITENS002.CODIGO'
      Size = 5
    end
    object cdsProdutosNotaDESCRICAO: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Origin = 'ITENS002.DESCRICAO'
      Size = 45
    end
    object cdsProdutosNotaST: TStringField
      FieldName = 'ST'
      Origin = 'ITENS002.ST'
      Size = 3
    end
    object cdsProdutosNotaIPI: TFloatField
      FieldName = 'IPI'
      Origin = 'ITENS002.IPI'
    end
    object cdsProdutosNotaICM: TFloatField
      FieldName = 'ICM'
      Origin = 'ITENS002.ICM'
    end
    object cdsProdutosNotaBASE: TFloatField
      FieldName = 'BASE'
      Origin = 'ITENS002.BASE'
    end
    object cdsProdutosNotaMEDIDA: TStringField
      FieldName = 'MEDIDA'
      Origin = 'ITENS002.MEDIDA'
      Size = 3
    end
    object cdsProdutosNotaQUANTIDADE: TFloatField
      DisplayLabel = 'Qtd.'
      FieldName = 'QUANTIDADE'
      Origin = 'ITENS002.QUANTIDADE'
    end
    object cdsProdutosNotaUNITARIO: TFloatField
      DisplayLabel = 'Unit'#225'rio'
      FieldName = 'UNITARIO'
      Origin = 'ITENS002.UNITARIO'
    end
    object cdsProdutosNotaTOTAL: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      Origin = 'ITENS002.TOTAL'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object cdsProdutosNotaPESO: TFloatField
      FieldName = 'PESO'
      Origin = 'ITENS002.PESO'
    end
    object cdsProdutosNotaCST_PIS_COFINS: TStringField
      FieldName = 'CST_PIS_COFINS'
      Origin = 'ITENS002.CST_PIS_COFINS'
      Size = 2
    end
    object cdsProdutosNotaALIQ_PIS: TBCDField
      FieldName = 'ALIQ_PIS'
      Origin = 'ITENS002.ALIQ_PIS'
      Precision = 18
    end
    object cdsProdutosNotaVICMS: TBCDField
      DisplayLabel = 'Valor do ICMS'
      FieldName = 'VICMS'
      Origin = 'ITENS002.VICMS'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBC: TBCDField
      DisplayLabel = 'BC ICMS'
      FieldName = 'VBC'
      Origin = 'ITENS002.VBC'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVICMSST: TBCDField
      DisplayLabel = 'Valor ICMS ST'
      FieldName = 'VICMSST'
      Origin = 'ITENS002.VICMSST'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVIPI: TBCDField
      DisplayLabel = 'Valor IPI'
      FieldName = 'VIPI'
      Origin = 'ITENS002.VIPI'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaCST_IPI: TStringField
      FieldName = 'CST_IPI'
      Origin = 'ITENS002.CST_IPI'
      Size = 2
    end
    object cdsProdutosNotaCST_ICMS: TStringField
      FieldName = 'CST_ICMS'
      Origin = 'ITENS002.CST_ICMS'
      Size = 3
    end
    object cdsProdutosNotaVBCFCP: TBCDField
      FieldName = 'VBCFCP'
      Origin = 'ITENS002.VBCFCP'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaPFCP: TBCDField
      FieldName = 'PFCP'
      Origin = 'ITENS002.PFCP'
      Precision = 18
    end
    object cdsProdutosNotaVFCP: TBCDField
      FieldName = 'VFCP'
      Origin = 'ITENS002.VFCP'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBCFCPST: TBCDField
      FieldName = 'VBCFCPST'
      Origin = 'ITENS002.VBCFCPST'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaPFCPST: TBCDField
      FieldName = 'PFCPST'
      Origin = 'ITENS002.PFCPST'
      Precision = 18
    end
    object cdsProdutosNotaVFCPST: TBCDField
      FieldName = 'VFCPST'
      Origin = 'ITENS002.VFCPST'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaICMS_DESONERADO: TBCDField
      FieldName = 'ICMS_DESONERADO'
      Origin = 'ITENS002.ICMS_DESONERADO'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBCST: TBCDField
      DisplayLabel = 'BC ST'
      FieldName = 'VBCST'
      Origin = 'ITENS002.VBCST'
      Precision = 18
      Size = 2
    end
  end
  object ibdProdutosNota: TIBDataSet
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = True
    SelectSQL.Strings = (
      'Select '
      #9#39'S'#39' Marcado,'
      #9'I.NUMERONF,'
      #9'I.CODIGO,'
      #9'I.DESCRICAO,'
      #9'I.ST,'
      #9'I.IPI,'
      #9'I.ICM,'
      #9'I.BASE,'
      #9'I.MEDIDA,'
      #9'I.QUANTIDADE,'
      #9'I.UNITARIO,'
      #9'I.TOTAL,'
      #9'I.PESO,'
      #9'I.CST_PIS_COFINS,'
      #9'I.ALIQ_PIS,'
      #9'I.VICMS,'
      #9'I.VBC,'
      #9'I.VBCST,'
      #9'I.VICMSST,'
      #9'I.VIPI,'
      #9'I.CST_IPI,'
      #9'I.CST_ICMS,'
      #9'I.VBCFCP,'
      #9'I.PFCP,'
      #9'I.VFCP,'
      #9'I.VBCFCPST,'
      #9'I.PFCPST,'
      #9'I.VFCPST,'
      #9'I.ICMS_DESONERADO'
      'From ITENS002 I'
      'Where I.NUMERONF = '#39'000000000001'#39
      #9'and I.FORNECEDOR = '#39'Adega Catarinense Ind e Com Ltda'#39)
    Left = 280
    Top = 144
    object ibdProdutosNotaMARCADO: TIBStringField
      FieldName = 'MARCADO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object ibdProdutosNotaNUMERONF: TIBStringField
      FieldName = 'NUMERONF'
      Origin = 'ITENS002.NUMERONF'
      Size = 12
    end
    object ibdProdutosNotaCODIGO: TIBStringField
      FieldName = 'CODIGO'
      Origin = 'ITENS002.CODIGO'
      Size = 5
    end
    object ibdProdutosNotaDESCRICAO: TIBStringField
      FieldName = 'DESCRICAO'
      Origin = 'ITENS002.DESCRICAO'
      Size = 45
    end
    object ibdProdutosNotaST: TIBStringField
      FieldName = 'ST'
      Origin = 'ITENS002.ST'
      Size = 3
    end
    object ibdProdutosNotaIPI: TFloatField
      FieldName = 'IPI'
      Origin = 'ITENS002.IPI'
    end
    object ibdProdutosNotaICM: TFloatField
      FieldName = 'ICM'
      Origin = 'ITENS002.ICM'
    end
    object ibdProdutosNotaBASE: TFloatField
      FieldName = 'BASE'
      Origin = 'ITENS002.BASE'
    end
    object ibdProdutosNotaMEDIDA: TIBStringField
      FieldName = 'MEDIDA'
      Origin = 'ITENS002.MEDIDA'
      Size = 3
    end
    object ibdProdutosNotaQUANTIDADE: TFloatField
      FieldName = 'QUANTIDADE'
      Origin = 'ITENS002.QUANTIDADE'
    end
    object ibdProdutosNotaUNITARIO: TFloatField
      FieldName = 'UNITARIO'
      Origin = 'ITENS002.UNITARIO'
    end
    object ibdProdutosNotaTOTAL: TFloatField
      FieldName = 'TOTAL'
      Origin = 'ITENS002.TOTAL'
    end
    object ibdProdutosNotaPESO: TFloatField
      FieldName = 'PESO'
      Origin = 'ITENS002.PESO'
    end
    object ibdProdutosNotaCST_PIS_COFINS: TIBStringField
      FieldName = 'CST_PIS_COFINS'
      Origin = 'ITENS002.CST_PIS_COFINS'
      Size = 2
    end
    object ibdProdutosNotaALIQ_PIS: TIBBCDField
      FieldName = 'ALIQ_PIS'
      Origin = 'ITENS002.ALIQ_PIS'
      Precision = 18
      Size = 4
    end
    object ibdProdutosNotaVICMS: TIBBCDField
      FieldName = 'VICMS'
      Origin = 'ITENS002.VICMS'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBC: TIBBCDField
      FieldName = 'VBC'
      Origin = 'ITENS002.VBC'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVICMSST: TIBBCDField
      FieldName = 'VICMSST'
      Origin = 'ITENS002.VICMSST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVIPI: TIBBCDField
      FieldName = 'VIPI'
      Origin = 'ITENS002.VIPI'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaCST_IPI: TIBStringField
      FieldName = 'CST_IPI'
      Origin = 'ITENS002.CST_IPI'
      Size = 2
    end
    object ibdProdutosNotaCST_ICMS: TIBStringField
      FieldName = 'CST_ICMS'
      Origin = 'ITENS002.CST_ICMS'
      Size = 3
    end
    object ibdProdutosNotaVBCFCP: TIBBCDField
      FieldName = 'VBCFCP'
      Origin = 'ITENS002.VBCFCP'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaPFCP: TIBBCDField
      FieldName = 'PFCP'
      Origin = 'ITENS002.PFCP'
      Precision = 18
      Size = 4
    end
    object ibdProdutosNotaVFCP: TIBBCDField
      FieldName = 'VFCP'
      Origin = 'ITENS002.VFCP'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBCFCPST: TIBBCDField
      FieldName = 'VBCFCPST'
      Origin = 'ITENS002.VBCFCPST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaPFCPST: TIBBCDField
      FieldName = 'PFCPST'
      Origin = 'ITENS002.PFCPST'
      Precision = 18
      Size = 4
    end
    object ibdProdutosNotaVFCPST: TIBBCDField
      FieldName = 'VFCPST'
      Origin = 'ITENS002.VFCPST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaICMS_DESONERADO: TIBBCDField
      FieldName = 'ICMS_DESONERADO'
      Origin = 'ITENS002.ICMS_DESONERADO'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBCST: TIBBCDField
      FieldName = 'VBCST'
      Origin = 'ITENS002.VBCST'
      Precision = 18
      Size = 2
    end
  end
  object dspProdutosNota: TDataSetProvider
    DataSet = ibdProdutosNota
    Left = 248
    Top = 144
  end
end
