object Form14: TForm14
  Left = 90
  Top = 5
  Width = 1024
  Height = 728
  Caption = 'Registro manual de NF de venda a consumidor (modelo 02)'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    1008
    689)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 759
    Top = 84
    Width = 498
    Height = 13
    Caption = 
      'c) para registro autom'#225'tico ou manual,  das informa'#231#245'es necess'#225'r' +
      'ias '#224' gera'#231#227'o do arquivo de que trata o '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label4: TLabel
    Left = 759
    Top = 99
    Width = 670
    Height = 13
    Caption = 
      'requisito XXVIII, referente a documentos fiscais  emitidos... (R' +
      'egistros 61 e 61R do SINTEGRA e C300, C310, C320 e C321 do SPED ' +
      'FISCAL)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label9: TLabel
    Left = 15
    Top = 78
    Width = 231
    Height = 13
    Caption = '- Nota fiscal de venda a consumidor (modelo 02).'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 15
    Top = 105
    Width = 150
    Height = 13
    Caption = 'Informe os dados manualmente:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 15
    Top = 32
    Width = 111
    Height = 13
    Caption = 'Requisito XXVIII, item 7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 15
    Top = 122
    Width = 680
    Height = 520
    Anchors = [akLeft, akTop, akBottom]
    Ctl3D = False
    DataSource = DataSource027
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnKeyDown = DBGrid1KeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'DATA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PEDIDO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SERIE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SUBSERIE'
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
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        ReadOnly = True
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CFOP'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CNPJ'
        Visible = True
      end>
  end
  object Button1: TBitBtn
    Left = 404
    Top = 650
    Width = 200
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Processar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBGrid2: TDBGrid
    Left = 700
    Top = 122
    Width = 290
    Height = 520
    Anchors = [akLeft, akTop, akBottom]
    Ctl3D = False
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnKeyDown = DBGrid1KeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'DATA'
        Title.Caption = 'Data'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NF'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Title.Caption = 'R$ Total'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Itens'
        Visible = True
      end>
  end
  object ibDataSet027: TIBDataSet
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction1
    AfterInsert = ibDataSet027AfterInsert
    AfterPost = ibDataSet027AfterPost
    BeforeDelete = ibDataSet027BeforeDelete
    BeforeInsert = ibDataSet027BeforeInsert
    BeforePost = ibDataSet027BeforePost
    OnNewRecord = ibDataSet027NewRecord
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from ALTERACA'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    InsertSQL.Strings = (
      'insert into ALTERACA'
      
        '  (CODIGO, DESCRICAO, QUANTIDADE, MEDIDA, UNITARIO, TOTAL, DATA,' +
        ' TIPO, '
      
        '   PEDIDO, ITEM, CLIFOR, VENDEDOR, CAIXA, VALORICM, ALIQUICM, RE' +
        'GISTRO, '
      
        '   ENCRYPTHASH, COO, CCF, CNPJ, REFERENCIA, HORA, DAV, TIPODAV, ' +
        'ANVISA, '
      
        '   DESCONTO, CST_ICMS, CST_PIS_COFINS, ALIQ_PIS, ALIQ_COFINS, OB' +
        'S, STATUS, CFOP, SERIE, SUBSERIE, CSOSN)'
      'values'
      
        '  (:CODIGO, :DESCRICAO, :QUANTIDADE, :MEDIDA, :UNITARIO, :TOTAL,' +
        ' :DATA, '
      
        '   :TIPO, :PEDIDO, :ITEM, :CLIFOR, :VENDEDOR, :CAIXA, :VALORICM,' +
        ' :ALIQUICM, '
      
        '   :REGISTRO, :ENCRYPTHASH, :COO, :CCF, :CNPJ, :REFERENCIA, :HOR' +
        'A, :DAV, '
      
        '   :TIPODAV, :ANVISA, :DESCONTO, :CST_ICMS, :CST_PIS_COFINS, :AL' +
        'IQ_PIS, '
      
        '   :ALIQ_COFINS, :OBS, :STATUS, :CFOP, :SERIE, :SUBSERIE, :CSOSN' +
        ')')
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  DESCRICAO,'
      '  QUANTIDADE,'
      '  MEDIDA,'
      '  UNITARIO,'
      '  TOTAL,'
      '  DATA,'
      '  TIPO,'
      '  PEDIDO,'
      '  ITEM,'
      '  CLIFOR,'
      '  VENDEDOR,'
      '  CAIXA,'
      '  VALORICM,'
      '  ALIQUICM,'
      '  REGISTRO,'
      '  ENCRYPTHASH,'
      '  COO,'
      '  CCF,'
      '  CNPJ,'
      '  REFERENCIA,'
      '  HORA,'
      '  DAV,'
      '  TIPODAV,'
      '  ANVISA,'
      '  DESCONTO,'
      '  CST_ICMS,'
      '  CST_PIS_COFINS,'
      '  ALIQ_PIS,'
      '  ALIQ_COFINS,'
      '  OBS,'
      '  STATUS,'
      '  CFOP,'
      '  SERIE,'
      '  SUBSERIE,'
      '  CSOSN'
      'from ALTERACA '
      'where'
      '  REGISTRO = :REGISTRO')
    SelectSQL.Strings = (
      'select * from ALTERACA')
    ModifySQL.Strings = (
      'update ALTERACA'
      'set'
      '  CODIGO = :CODIGO,'
      '  DESCRICAO = :DESCRICAO,'
      '  QUANTIDADE = :QUANTIDADE,'
      '  MEDIDA = :MEDIDA,'
      '  UNITARIO = :UNITARIO,'
      '  TOTAL = :TOTAL,'
      '  DATA = :DATA,'
      '  TIPO = :TIPO,'
      '  PEDIDO = :PEDIDO,'
      '  ITEM = :ITEM,'
      '  CLIFOR = :CLIFOR,'
      '  VENDEDOR = :VENDEDOR,'
      '  CAIXA = :CAIXA,'
      '  VALORICM = :VALORICM,'
      '  ALIQUICM = :ALIQUICM,'
      '  REGISTRO = :REGISTRO,'
      '  ENCRYPTHASH = :ENCRYPTHASH,'
      '  COO = :COO,'
      '  CCF = :CCF,'
      '  CNPJ = :CNPJ,'
      '  REFERENCIA = :REFERENCIA,'
      '  HORA = :HORA,'
      '  DAV = :DAV,'
      '  TIPODAV = :TIPODAV,'
      '  ANVISA = :ANVISA,'
      '  DESCONTO = :DESCONTO,'
      '  CST_ICMS = :CST_ICMS,'
      '  CST_PIS_COFINS = :CST_PIS_COFINS,'
      '  ALIQ_PIS = :ALIQ_PIS,'
      '  ALIQ_COFINS = :ALIQ_COFINS,'
      '  OBS = :OBS,'
      '  STATUS = :STATUS,'
      '  CFOP = :CFOP,'
      '  SERIE = :SERIE,'
      '  SUBSERIE = :SUBSERIE,'
      '  CSOSN = :CSOSN'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    Left = 384
    Top = 80
    object ibDataSet027DATA: TDateField
      DisplayLabel = 'Data'
      FieldName = 'DATA'
      DisplayFormat = 'dd/mm/yyyy'
      EditMask = '!99/99/0000;1;_'
    end
    object ibDataSet027PEDIDO: TStringField
      DisplayLabel = 'NF'
      FieldName = 'PEDIDO'
      Size = 6
    end
    object ibDataSet027SERIE: TIBStringField
      DisplayLabel = 'S'#233'rie'
      FieldName = 'SERIE'
      Origin = 'ALTERACA.SERIE'
      FixedChar = True
      Size = 4
    end
    object ibDataSet027SUBSERIE: TIBStringField
      DisplayLabel = 'Sub'
      FieldName = 'SUBSERIE'
      Origin = 'ALTERACA.SUBSERIE'
      FixedChar = True
      Size = 3
    end
    object ibDataSet027CODIGO: TIBStringField
      FieldName = 'CODIGO'
      Origin = 'ALTERACA.CODIGO'
      Visible = False
      Size = 5
    end
    object ibDataSet027DESCRICAO: TStringField
      DisplayLabel = 'C'#243'digo/Descri'#231#227'o'
      DisplayWidth = 25
      FieldName = 'DESCRICAO'
      Size = 45
    end
    object ibDataSet027QUANTIDADE: TFloatField
      DisplayLabel = 'Qtd.'
      DisplayWidth = 6
      FieldName = 'QUANTIDADE'
      OnChange = ibDataSet027QUANTIDADEChange
      DisplayFormat = '###,##0.00'
      EditFormat = '##0.00'
    end
    object ibDataSet027UNITARIO: TFloatField
      DisplayLabel = 'R$ UNITARIO'
      FieldName = 'UNITARIO'
      Origin = 'ALTERACA.UNITARIO'
      Visible = False
      OnChange = ibDataSet027UNITARIOChange
    end
    object ibDataSet027TOTAL: TFloatField
      DisplayLabel = 'R$ Total'
      FieldName = 'TOTAL'
      OnChange = ibDataSet027TOTALChange
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibDataSet027CFOP: TIBStringField
      FieldName = 'CFOP'
      Origin = 'ALTERACA.CFOP'
      FixedChar = True
      Size = 4
    end
    object ibDataSet027CNPJ: TIBStringField
      FieldName = 'CNPJ'
      Origin = 'ALTERACA.CNPJ'
      Size = 19
    end
    object ibDataSet027ALIQUICM: TStringField
      FieldName = 'ALIQUICM'
      Visible = False
      Size = 5
    end
    object ibDataSet027CST_ICMS: TIBStringField
      FieldName = 'CST_ICMS'
      Origin = 'ALTERACA.CST_ICMS'
      Visible = False
      FixedChar = True
      Size = 3
    end
    object ibDataSet027CST_PIS_COFINS: TIBStringField
      FieldName = 'CST_PIS_COFINS'
      Origin = 'ALTERACA.CST_PIS_COFINS'
      Visible = False
      Size = 2
    end
    object ibDataSet027ALIQ_PIS: TIBBCDField
      FieldName = 'ALIQ_PIS'
      Origin = 'ALTERACA.ALIQ_PIS'
      Visible = False
      Precision = 18
      Size = 4
    end
    object ibDataSet027ALIQ_COFINS: TIBBCDField
      FieldName = 'ALIQ_COFINS'
      Origin = 'ALTERACA.ALIQ_COFINS'
      Visible = False
      Precision = 18
      Size = 4
    end
    object ibDataSet027REGISTRO: TIBStringField
      FieldName = 'REGISTRO'
      Origin = 'ALTERACA.REGISTRO'
      Visible = False
      Size = 10
    end
    object ibDataSet027TIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = 'ALTERACA.TIPO'
      Visible = False
      Size = 6
    end
    object ibDataSet027MEDIDA: TIBStringField
      FieldName = 'MEDIDA'
      Origin = 'ALTERACA.MEDIDA'
      Visible = False
      Size = 3
    end
    object ibDataSet027ITEM: TIBStringField
      FieldName = 'ITEM'
      Origin = 'ALTERACA.ITEM'
      Visible = False
      Size = 6
    end
    object ibDataSet27CAIXA: TStringField
      FieldName = 'CAIXA'
      Size = 3
    end
    object ibDataSet27VALORICM: TFloatField
      FieldName = 'VALORICM'
    end
    object ibDataSet27HORA: TIBStringField
      FieldName = 'HORA'
      Origin = '"ALTERACA"."HORA"'
      Size = 8
    end
    object ibDataSet27DAV: TIBStringField
      FieldName = 'DAV'
      Origin = '"ALTERACA"."DAV"'
      Size = 10
    end
    object ibDataSet27TIPODAV: TIBStringField
      FieldName = 'TIPODAV'
      Origin = '"ALTERACA"."TIPODAV"'
      Size = 10
    end
    object ibDataSet27COO: TIBStringField
      FieldName = 'COO'
      Origin = 'ALTERACA.COO'
      Size = 6
    end
    object ibDataSet27CCF: TIBStringField
      FieldName = 'CCF'
      Origin = 'ALTERACA.CCF'
      Size = 6
    end
    object ibDataSet27REFERENCIA: TIBStringField
      FieldName = 'REFERENCIA'
      Origin = '"ALTERACA"."REFERENCIA"'
      Size = 14
    end
    object ibDataSet27ENCRYPTHASH: TIBStringField
      FieldName = 'ENCRYPTHASH'
      Origin = 'ALTERACA.ENCRYPTHASH'
      Size = 56
    end
    object ibDataSet27VENDEDOR: TStringField
      FieldName = 'VENDEDOR'
      Visible = False
      Size = 30
    end
    object ibDataSet27CLIFOR: TStringField
      FieldName = 'CLIFOR'
      Visible = False
      Size = 35
    end
    object ibDataSet027CSOSN: TStringField
      FieldName = 'CSOSN'
      Size = 3
    end
  end
  object DataSource027: TDataSource
    DataSet = ibDataSet027
    Left = 416
    Top = 80
  end
  object IBDataSet1: TIBDataSet
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from ALTERACA'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    InsertSQL.Strings = (
      'insert into ALTERACA'
      
        '  (CODIGO, DESCRICAO, QUANTIDADE, MEDIDA, UNITARIO, TOTAL, DATA,' +
        ' TIPO, '
      
        '   PEDIDO, ITEM, CLIFOR, VENDEDOR, CAIXA, VALORICM, ALIQUICM, RE' +
        'GISTRO, '
      
        '   CST_PIS_COFINS, DESCONTO, ANVISA, ENCRYPTHASH, COO, CCF, CNPJ' +
        ', REFERENCIA, '
      
        '   HORA, DAV, TIPODAV, CST_ICMS, ALIQ_PIS, ALIQ_COFINS, OBS, STA' +
        'TUS, SERIE, '
      '   SUBSERIE, CFOP)'
      'values'
      
        '  (:CODIGO, :DESCRICAO, :QUANTIDADE, :MEDIDA, :UNITARIO, :TOTAL,' +
        ' :DATA, '
      
        '   :TIPO, :PEDIDO, :ITEM, :CLIFOR, :VENDEDOR, :CAIXA, :VALORICM,' +
        ' :ALIQUICM, '
      
        '   :REGISTRO, :CST_PIS_COFINS, :DESCONTO, :ANVISA, :ENCRYPTHASH,' +
        ' :COO, '
      
        '   :CCF, :CNPJ, :REFERENCIA, :HORA, :DAV, :TIPODAV, :CST_ICMS, :' +
        'ALIQ_PIS, '
      '   :ALIQ_COFINS, :OBS, :STATUS, :SERIE, :SUBSERIE, :CFOP)')
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  DESCRICAO,'
      '  QUANTIDADE,'
      '  MEDIDA,'
      '  UNITARIO,'
      '  TOTAL,'
      '  DATA,'
      '  TIPO,'
      '  PEDIDO,'
      '  ITEM,'
      '  CLIFOR,'
      '  VENDEDOR,'
      '  CAIXA,'
      '  VALORICM,'
      '  ALIQUICM,'
      '  REGISTRO,'
      '  CST_PIS_COFINS,'
      '  DESCONTO,'
      '  ANVISA,'
      '  ENCRYPTHASH,'
      '  COO,'
      '  CCF,'
      '  CNPJ,'
      '  REFERENCIA,'
      '  HORA,'
      '  DAV,'
      '  TIPODAV,'
      '  CST_ICMS,'
      '  ALIQ_PIS,'
      '  ALIQ_COFINS,'
      '  OBS,'
      '  STATUS,'
      '  SERIE,'
      '  SUBSERIE,'
      '  CFOP'
      'from ALTERACA '
      'where'
      '  REGISTRO = :REGISTRO')
    SelectSQL.Strings = (
      'select * from ALTERACA')
    ModifySQL.Strings = (
      'update ALTERACA'
      'set'
      '  CODIGO = :CODIGO,'
      '  DESCRICAO = :DESCRICAO,'
      '  QUANTIDADE = :QUANTIDADE,'
      '  MEDIDA = :MEDIDA,'
      '  UNITARIO = :UNITARIO,'
      '  TOTAL = :TOTAL,'
      '  DATA = :DATA,'
      '  TIPO = :TIPO,'
      '  PEDIDO = :PEDIDO,'
      '  ITEM = :ITEM,'
      '  CLIFOR = :CLIFOR,'
      '  VENDEDOR = :VENDEDOR,'
      '  CAIXA = :CAIXA,'
      '  VALORICM = :VALORICM,'
      '  ALIQUICM = :ALIQUICM,'
      '  REGISTRO = :REGISTRO,'
      '  CST_PIS_COFINS = :CST_PIS_COFINS,'
      '  DESCONTO = :DESCONTO,'
      '  ANVISA = :ANVISA,'
      '  ENCRYPTHASH = :ENCRYPTHASH,'
      '  COO = :COO,'
      '  CCF = :CCF,'
      '  CNPJ = :CNPJ,'
      '  REFERENCIA = :REFERENCIA,'
      '  HORA = :HORA,'
      '  DAV = :DAV,'
      '  TIPODAV = :TIPODAV,'
      '  CST_ICMS = :CST_ICMS,'
      '  ALIQ_PIS = :ALIQ_PIS,'
      '  ALIQ_COFINS = :ALIQ_COFINS,'
      '  OBS = :OBS,'
      '  STATUS = :STATUS,'
      '  SERIE = :SERIE,'
      '  SUBSERIE = :SUBSERIE,'
      '  CFOP = :CFOP'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    Left = 536
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = IBDataSet1
    Left = 568
    Top = 80
  end
  object IBQPESQUISA: TIBQuery
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 632
    Top = 80
  end
end
