inherited FrmProdutosDevolucao: TFrmProdutosDevolucao
  Left = 551
  Top = 279
  BorderIcons = []
  Caption = 'Produtos Devolu'#231#227'o'
  ClientHeight = 483
  ClientWidth = 994
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 1010
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 16
  object lblTitulo: TLabel
    Left = 16
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
  object imgCheck: TImage
    Left = 699
    Top = 8
    Width = 20
    Height = 18
    AutoSize = True
    Picture.Data = {
      07544269746D61706E040000424D6E0400000000000036000000280000001400
      0000120000000100180000000000380400000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D81521D81
      521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFFFFFFFFFF
      81521DEFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFD
      FDFEFEFEFFFFFFFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DED
      F0F0EFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD
      FEFEFEFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DEBEEEEEDF0
      F0EFF2F2F1F3F3F3F5F522A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFDFE
      FEFEFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE8ECECEBEEEEEDF0F0
      EFF2F222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFDFEFE
      FE81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE6EAEAE8ECECEBEEEE22A12222
      A12222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD81521D
      FFFFFFFFFFFFFFFFFFFFFFFF81521DE4E8E8E6EAEA22A12222A12222A12222A1
      2222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFD81521DFFFFFFFF
      FFFFFFFFFFFFFFFF81521DE2E6E6E4E8E822A12222A12222A122EDF0F022A122
      22A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFB81521DFFFFFFFFFFFFFFFF
      FFFFFFFF81521DE0E4E4E2E6E622A12222A122E8ECECEBEEEEEDF0F022A12222
      A12222A12222A122F6F8F8F8F9F9F9FAFA81521DFFFFFFFFFFFFFFFFFFFFFFFF
      81521DDEE3E3E0E4E422A122E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A1
      2222A12222A122F6F8F8F8F9F981521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDD
      E2E2DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A122
      22A122F5F6F6F6F8F881521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2
      E2DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A122F3
      F5F5F5F6F681521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2
      DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A122F1F3F3F3F5
      F581521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DE
      E3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F2F1F3F381521D
      FFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DDE2E2DEE3
      E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F281521DFFFFFFFF
      FFFFFFFFFFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D
      81521D81521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Visible = False
  end
  object imgUnCheck: TImage
    Left = 728
    Top = 8
    Width = 20
    Height = 18
    AutoSize = True
    Picture.Data = {
      07544269746D61706E040000424D6E0400000000000036000000280000001400
      0000120000000100180000000000380400000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D81521D81
      521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFFFFFFFFFF
      81521DEFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFD
      FDFEFEFEFFFFFFFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DED
      F0F0EFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD
      FEFEFEFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DEBEEEEEFF1
      F1F1F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFFFFFFFFFFFFFE
      FEFEFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE8ECECECEFEFEFF1F1
      F1F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFFFFFFFDFDFDFEFE
      FE81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE6EAEAE9ECECECEFEFEFF1F1F1
      F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFCFDFDFDFDFD81521D
      FFFFFFFFFFFFFFFFFFFFFFFF81521DE4E8E8E5E8E8E9ECECECEFEFEFF1F1F1F3
      F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFBFBFBFCFDFD81521DFFFFFFFF
      FFFFFFFFFFFFFFFF81521DE2E6E6E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3
      F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDF9FAFAFBFBFB81521DFFFFFFFFFFFFFFFF
      FFFFFFFF81521DE0E4E4DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4
      F5F5F6F7F7F8F9F9FAFBFBF8F9F9F9FAFA81521DFFFFFFFFFFFFFFFFFFFFFFFF
      81521DDEE3E3DBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5
      F5F6F7F7F8F9F9F6F8F8F8F9F981521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDD
      E2E2D9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5F5
      F6F7F7F5F6F6F6F8F881521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DC
      DCD9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5F5F3
      F5F5F5F6F681521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DCDCD7DCDC
      D9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F1F3F3F3F5
      F581521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DCDCD7DCDCD7DCDCD9
      DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1EFF2F2F1F3F381521D
      FFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DDE2E2DEE3
      E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F281521DFFFFFFFF
      FFFFFFFFFFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D
      81521D81521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Visible = False
  end
  object imgEdit: TImage
    Left = 760
    Top = 8
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
      001008060000001FF3FF61000000097048597300000B1300000B1301009A9C18
      0000008D4944415478DA6364A01030D2D3000520DE06C49B80B8821C03560271
      1894DD09338418034036D7007115106F04620B20BE06C4DAC41800D2BC1F4AEF
      00E278209E0CC4E540FC809001C89A61602E10A71013887250CD4A48628F80D8
      1188EF11328068CDD80C204933BA01246B4637E03E5A803D806A7E8027A0510C
      F84F8ACDF80C205A33B6402419506C00005AAE22117E3D5D170000000049454E
      44AE426082}
    Visible = False
  end
  object dbgPrincipal: TDBGrid
    Left = 16
    Top = 39
    Width = 961
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
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    OnCellClick = dbgPrincipalCellClick
    OnDrawColumnCell = dbgPrincipalDrawColumnCell
    OnDblClick = dbgPrincipalDblClick
    OnKeyDown = dbgPrincipalKeyDown
    Columns = <
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'MARCADO'
        ReadOnly = True
        Width = 21
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'DESCRICAO'
        ReadOnly = True
        Width = 302
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'UNITARIO'
        ReadOnly = True
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'TOTAL'
        ReadOnly = True
        Width = 76
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'VBC'
        ReadOnly = True
        Width = 73
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'VICMS'
        ReadOnly = True
        Width = 85
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'VBCST'
        ReadOnly = True
        Width = 68
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'VICMSST'
        ReadOnly = True
        Width = 85
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'VIPI'
        ReadOnly = True
        Width = 72
        Visible = True
      end>
  end
  object btnOK: TBitBtn
    Left = 718
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
  object btnCancelar: TBitBtn
    Left = 852
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
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 448
    Width = 126
    Height = 25
    Caption = 'Desmarcar todos'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn1Click
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
    AfterInsert = cdsProdutosNotaAfterInsert
    BeforeDelete = cdsProdutosNotaBeforeDelete
    Left = 216
    Top = 144
    object cdsProdutosNotaMARCADO: TWideStringField
      DisplayLabel = ' '
      FieldName = 'MARCADO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object cdsProdutosNotaNUMERONF: TIBStringField
      FieldName = 'NUMERONF'
      Origin = 'ITENS002.NUMERONF'
      Size = 12
    end
    object cdsProdutosNotaDESCRICAO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 45
    end
    object cdsProdutosNotaCODIGO: TIBStringField
      FieldName = 'CODIGO'
      Origin = 'ITENS002.CODIGO'
      Size = 5
    end
    object cdsProdutosNotaST: TIBStringField
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
    object cdsProdutosNotaMEDIDA: TIBStringField
      FieldName = 'MEDIDA'
      Origin = 'ITENS002.MEDIDA'
      Size = 3
    end
    object cdsProdutosNotaQUANTIDADE: TFloatField
      DisplayLabel = 'Qtd.'
      FieldName = 'QUANTIDADE'
      Origin = 'ITENS002.QUANTIDADE'
      OnChange = cdsProdutosNotaQUANTIDADEChange
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object cdsProdutosNotaUNITARIO: TFloatField
      DisplayLabel = 'Unit'#225'rio'
      FieldName = 'UNITARIO'
      Origin = 'ITENS002.UNITARIO'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
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
    object cdsProdutosNotaCST_PIS_COFINS: TIBStringField
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
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBC: TBCDField
      DisplayLabel = 'BC ICMS'
      FieldName = 'VBC'
      Origin = 'ITENS002.VBC'
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVICMSST: TBCDField
      DisplayLabel = 'Valor ICMS ST'
      FieldName = 'VICMSST'
      Origin = 'ITENS002.VICMSST'
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVIPI: TBCDField
      DisplayLabel = 'Valor IPI'
      FieldName = 'VIPI'
      Origin = 'ITENS002.VIPI'
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaCST_IPI: TIBStringField
      FieldName = 'CST_IPI'
      Origin = 'ITENS002.CST_IPI'
      Size = 2
    end
    object cdsProdutosNotaCST_ICMS: TIBStringField
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
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaQUANTIDADE_ANT: TFloatField
      FieldName = 'QUANTIDADE_ANT'
    end
    object cdsProdutosNotaVIPI_ANT: TBCDField
      FieldName = 'VIPI_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaICM_ANT: TFloatField
      FieldName = 'ICM_ANT'
    end
    object cdsProdutosNotaVICMS_ANT: TBCDField
      FieldName = 'VICMS_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBC_ANT: TBCDField
      FieldName = 'VBC_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBCST_ANT: TBCDField
      FieldName = 'VBCST_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVICMSST_ANT: TBCDField
      FieldName = 'VICMSST_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVBCFCPST_ANT: TBCDField
      FieldName = 'VBCFCPST_ANT'
      Precision = 18
      Size = 2
    end
    object cdsProdutosNotaVFCPST_ANT: TBCDField
      FieldName = 'VFCPST_ANT'
      Precision = 18
      Size = 2
    end
  end
  object ibdProdutosNota: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
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
      #9'I.ICMS_DESONERADO,'#9
      #9'I.QUANTIDADE QUANTIDADE_ANT,'
      #9'I.VIPI VIPI_ANT, '
      #9'I.ICM ICM_ANT,'
      #9'I.VICMS VICMS_ANT,'
      #9'I.VBC VBC_ANT,'
      #9'I.VBCST VBCST_ANT,'
      #9'I.VICMSST VICMSST_ANT,'
      #9'I.VBCFCPST VBCFCPST_ANT,'
      #9'I.VFCPST VFCPST_ANT'
      'From ITENS002 I'
      'Where I.NUMERONF =  :NUMERONF  '
      #9'and I.FORNECEDOR  =  :FORNECEDOR ')
    ParamCheck = True
    UniDirectional = False
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
    object ibdProdutosNotaQUANTIDADE_ANT: TFloatField
      FieldName = 'QUANTIDADE_ANT'
      Origin = 'ITENS002.QUANTIDADE'
    end
    object ibdProdutosNotaVIPI_ANT: TIBBCDField
      FieldName = 'VIPI_ANT'
      Origin = 'ITENS002.VIPI'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaICM_ANT: TFloatField
      FieldName = 'ICM_ANT'
      Origin = 'ITENS002.ICM'
    end
    object ibdProdutosNotaVICMS_ANT: TIBBCDField
      FieldName = 'VICMS_ANT'
      Origin = 'ITENS002.VICMS'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBC_ANT: TIBBCDField
      FieldName = 'VBC_ANT'
      Origin = 'ITENS002.VBC'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBCST_ANT: TIBBCDField
      FieldName = 'VBCST_ANT'
      Origin = 'ITENS002.VBCST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVICMSST_ANT: TIBBCDField
      FieldName = 'VICMSST_ANT'
      Origin = 'ITENS002.VICMSST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVBCFCPST_ANT: TIBBCDField
      FieldName = 'VBCFCPST_ANT'
      Origin = 'ITENS002.VBCFCPST'
      Precision = 18
      Size = 2
    end
    object ibdProdutosNotaVFCPST_ANT: TIBBCDField
      FieldName = 'VFCPST_ANT'
      Origin = 'ITENS002.VFCPST'
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
