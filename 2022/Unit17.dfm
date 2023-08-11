object Form17: TForm17
  Left = 504
  Top = 226
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dados do emitente'
  ClientHeight = 461
  ClientWidth = 742
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 421
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 34
      Top = 40
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Raz'#227'o Social:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 35
      Top = 65
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Respons'#225'vel:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 51
      Top = 90
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Endere'#231'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 50
      Top = 165
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Munic'#237'pio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 76
      Top = 140
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'CEP:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 64
      Top = 190
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Estado:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 70
      Top = 15
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'CNPJ:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 87
      Top = 215
      Width = 13
      Height = 13
      Alignment = taRightJustify
      Caption = 'IE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 55
      Top = 315
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Telefone:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 70
      Top = 115
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bairro:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 70
      Top = 340
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'e-mail:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 64
      Top = 365
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'P'#225'gina:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 85
      Top = 240
      Width = 15
      Height = 13
      Alignment = taRightJustify
      Caption = 'IM:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image2: TImage
      Left = 620
      Top = 16
      Width = 95
      Height = 95
      OnClick = Image2Click
    end
    object Label16: TLabel
      Left = 75
      Top = 265
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'CRT:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 70
      Top = 290
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'CNAE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SMALL_DBEdit1: TSMALL_DBEdit
      Left = 110
      Top = 40
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'NOME'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit2: TSMALL_DBEdit
      Left = 110
      Top = 65
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'CONTATO'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit3: TSMALL_DBEdit
      Left = 110
      Top = 90
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'ENDERECO'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit4: TSMALL_DBEdit
      Left = 110
      Top = 165
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'MUNICIPIO'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 6
      OnChange = SMALL_DBEdit4Change
      OnEnter = SMALL_DBEdit4Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit5: TSMALL_DBEdit
      Left = 110
      Top = 140
      Width = 82
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'CEP'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 5
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit6: TSMALL_DBEdit
      Left = 110
      Top = 190
      Width = 35
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'ESTADO'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 7
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit7: TSMALL_DBEdit
      Left = 110
      Top = 15
      Width = 165
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'CGC'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnEnter = SMALL_DBEdit6Enter
      OnExit = SMALL_DBEdit7Exit
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit8: TSMALL_DBEdit
      Left = 110
      Top = 215
      Width = 165
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'IE'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 8
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit9: TSMALL_DBEdit
      Left = 110
      Top = 315
      Width = 165
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'TELEFO'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 12
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit10: TSMALL_DBEdit
      Left = 110
      Top = 115
      Width = 170
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'COMPLE'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit11: TSMALL_DBEdit
      Left = 110
      Top = 340
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'EMAIL'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 13
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit12: TSMALL_DBEdit
      Left = 110
      Top = 365
      Width = 500
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'HP'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 14
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object SMALL_DBEdit13: TSMALL_DBEdit
      Left = 110
      Top = 240
      Width = 165
      Height = 20
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = True
      DataField = 'IM'
      DataSource = DSEmitente
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 9
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = SMALL_DBEdit7KeyDown
    end
    object ComboBox7: TComboBox
      Left = 110
      Top = 290
      Width = 500
      Height = 22
      Style = csOwnerDrawVariable
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 11
      OnChange = ComboBox7Change
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = ComboBox1KeyDown
    end
    object ComboBox1: TComboBox
      Left = 110
      Top = 265
      Width = 500
      Height = 22
      Style = csOwnerDrawVariable
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 10
      OnChange = ComboBox1Change
      OnEnter = SMALL_DBEdit6Enter
      OnKeyDown = ComboBox1KeyDown
      Items.Strings = (
        '1 - Simples nacional '
        '2 - Simples nacional - Excesso de Sublimite de Receita Bruta'
        '3 - Regime normal')
    end
    object dbgPesquisa: TDBGrid
      Left = 110
      Top = 185
      Width = 500
      Height = 5
      Ctl3D = True
      DataSource = Form7.DataSource39
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 15
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -12
      TitleFont.Name = 'Fixedsys'
      TitleFont.Style = []
      Visible = False
      OnDblClick = dbgPesquisaDblClick
      OnKeyPress = dbgPesquisaKeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'NOME'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MEDIDA'
          Visible = False
        end>
    end
    object WebBrowser3: TWebBrowser
      Left = 16
      Top = 16
      Width = 33
      Height = 25
      TabOrder = 16
      ControlData = {
        4C00000069030000950200000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E12620A000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object CheckBox1: TCheckBox
      Left = 112
      Top = 400
      Width = 289
      Height = 17
      Caption = 'Microempreendedor Individual (MEI)'
      TabOrder = 17
      Visible = False
      OnClick = CheckBox1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 421
    Width = 742
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object Button2: TBitBtn
      Left = 210
      Top = 5
      Width = 129
      Height = 25
      Caption = 'Configura'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button2Click
      OnEnter = SMALL_DBEdit6Enter
    end
    object Button1: TBitBtn
      Left = 380
      Top = 5
      Width = 129
      Height = 25
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
      OnEnter = SMALL_DBEdit6Enter
    end
    object Button4: TBitBtn
      Left = 570
      Top = 5
      Width = 129
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = Button4Click
    end
  end
  object ibdMunicipios: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from MUNICIPIOS'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    InsertSQL.Strings = (
      'insert into MUNICIPIOS'
      '  (CODIGO, NOME, REGISTRO, UF)'
      'values'
      '  (:CODIGO, :NOME, :REGISTRO, :UF)')
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  NOME,'
      '  UF,'
      '  REGISTRO'
      'from MUNICIPIOS '
      'where'
      '  REGISTRO = :REGISTRO')
    SelectSQL.Strings = (
      'select * from MUNICIPIOS order by NOME')
    ModifySQL.Strings = (
      'update MUNICIPIOS'
      'set'
      '  CODIGO = :CODIGO,'
      '  NOME = :NOME,'
      '  REGISTRO = :REGISTRO,'
      '  UF = :UF'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    Filtered = True
    Left = 632
    Top = 139
    object ibdMunicipiosCODIGO: TIBStringField
      FieldName = 'CODIGO'
      Origin = '"MUNICIPIOS"."CODIGO"'
      Size = 7
    end
    object ibdMunicipiosNOME: TIBStringField
      DisplayWidth = 21
      FieldName = 'NOME'
      Origin = '"MUNICIPIOS"."NOME"'
      Size = 40
    end
    object ibdMunicipiosUF: TIBStringField
      FieldName = 'UF'
      Origin = '"MUNICIPIOS"."UF"'
      Size = 2
    end
    object ibdMunicipiosREGISTRO: TIBStringField
      FieldName = 'REGISTRO'
      Origin = '"MUNICIPIOS"."REGISTRO"'
      Size = 10
    end
  end
  object DSMunicipios: TDataSource
    DataSet = ibdMunicipios
    Left = 664
    Top = 139
  end
  object DSEmitente: TDataSource
    DataSet = ibdEmitente
    Left = 666
    Top = 197
  end
  object ibdEmitente: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    AfterPost = ibdEmitenteAfterPost
    BeforeInsert = ibdEmitenteBeforeInsert
    BeforePost = ibdEmitenteBeforePost
    OnDeleteError = ibdEmitenteDeleteError
    OnEditError = ibdEmitenteEditError
    OnNewRecord = ibdEmitenteNewRecord
    OnPostError = ibdEmitentePostError
    OnUpdateError = ibdEmitenteUpdateError
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from EMITENTE'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    InsertSQL.Strings = (
      'insert into EMITENTE'
      
        '  (NOME, CONTATO, ENDERECO, COMPLE, MUNICIPIO, CEP, ESTADO, CGC,' +
        ' IE, TELEFO, '
      
        '   EMAIL, HP, COPE, RESE, CVEN, IMPO, LUCR, ICME, ICMS, REGISTRO' +
        ', CRT, '
      '   CNAE, IM, ENCRYPTHASH)'
      'values'
      
        '  (:NOME, :CONTATO, :ENDERECO, :COMPLE, :MUNICIPIO, :CEP, :ESTAD' +
        'O, :CGC, '
      
        '   :IE, :TELEFO, :EMAIL, :HP, :COPE, :RESE, :CVEN, :IMPO, :LUCR,' +
        ' :ICME, '
      '   :ICMS, :REGISTRO, :CRT, :CNAE, :IM, :ENCRYPTHASH)')
    RefreshSQL.Strings = (
      'Select '
      '  NOME,'
      '  CONTATO,'
      '  ENDERECO,'
      '  COMPLE,'
      '  MUNICIPIO,'
      '  CEP,'
      '  ESTADO,'
      '  CGC,'
      '  IE,'
      '  TELEFO,'
      '  EMAIL,'
      '  HP,'
      '  COPE,'
      '  RESE,'
      '  CVEN,'
      '  IMPO,'
      '  LUCR,'
      '  ICME,'
      '  ICMS,'
      '  REGISTRO,'
      '  CRT,'
      '  CNAE,'
      '  IM,'
      '  ENCRYPTHASH'
      'from EMITENTE '
      'where'
      '  REGISTRO = :REGISTRO')
    SelectSQL.Strings = (
      'select * from EMITENTE'
      '')
    ModifySQL.Strings = (
      'update EMITENTE'
      'set'
      '  NOME = :NOME,'
      '  CONTATO = :CONTATO,'
      '  ENDERECO = :ENDERECO,'
      '  COMPLE = :COMPLE,'
      '  MUNICIPIO = :MUNICIPIO,'
      '  CEP = :CEP,'
      '  ESTADO = :ESTADO,'
      '  CGC = :CGC,'
      '  IE = :IE,'
      '  TELEFO = :TELEFO,'
      '  EMAIL = :EMAIL,'
      '  HP = :HP,'
      '  COPE = :COPE,'
      '  RESE = :RESE,'
      '  CVEN = :CVEN,'
      '  IMPO = :IMPO,'
      '  LUCR = :LUCR,'
      '  ICME = :ICME,'
      '  ICMS = :ICMS,'
      '  REGISTRO = :REGISTRO,'
      '  CRT = :CRT,'
      '  CNAE = :CNAE,'
      '  IM = :IM,'
      '  ENCRYPTHASH = :ENCRYPTHASH'
      'where'
      '  REGISTRO = :OLD_REGISTRO')
    Left = 634
    Top = 197
    object ibdEmitenteCGC: TIBStringField
      DisplayLabel = 'CPF/CNPJ'
      FieldName = 'CGC'
      OnSetText = ibdEmitenteCGCSetText
      Size = 18
    end
    object ibdEmitenteNOME: TIBStringField
      DisplayLabel = 'Raz'#227'o Social:'
      DisplayWidth = 35
      FieldName = 'NOME'
      Size = 60
    end
    object ibdEmitenteCONTATO: TIBStringField
      DisplayLabel = 'Respons'#225'vel'
      FieldName = 'CONTATO'
      Size = 35
    end
    object ibdEmitenteENDERECO: TIBStringField
      DisplayLabel = 'Endere'#231'o'
      FieldName = 'ENDERECO'
      Size = 35
    end
    object ibdEmitenteCOMPLE: TIBStringField
      DisplayLabel = 'Bairro'
      FieldName = 'COMPLE'
    end
    object ibdEmitenteCEP: TIBStringField
      FieldName = 'CEP'
      EditMask = '#####-###;1; '
      Size = 9
    end
    object ibdEmitenteMUNICIPIO: TIBStringField
      DisplayLabel = 'Munic'#237'pio'
      DisplayWidth = 40
      FieldName = 'MUNICIPIO'
      OnSetText = ibdEmitenteMUNICIPIOSetText
      Size = 40
    end
    object ibdEmitenteESTADO: TIBStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      OnSetText = ibdEmitenteESTADOSetText
      Size = 2
    end
    object ibdEmitenteIE: TIBStringField
      FieldName = 'IE'
      Size = 16
    end
    object ibdEmitenteIM: TIBStringField
      FieldName = 'IM'
      Origin = '"EMITENTE"."IM"'
      Size = 16
    end
    object ibdEmitenteTELEFO: TIBStringField
      DisplayLabel = 'Telefone'
      DisplayWidth = 21
      FieldName = 'TELEFO'
      EditMask = '!\(#xx##\)#########;1; '
      Size = 16
    end
    object ibdEmitenteEMAIL: TIBStringField
      DisplayLabel = 'e-mail'
      FieldName = 'EMAIL'
      Size = 70
    end
    object ibdEmitenteHP: TIBStringField
      DisplayLabel = 'P'#225'gina na internet'
      FieldName = 'HP'
      Size = 130
    end
    object ibdEmitenteCOPE: TFloatField
      DisplayLabel = '% Custo Operacional'
      FieldName = 'COPE'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteRESE: TFloatField
      DisplayLabel = 'reserva'
      FieldName = 'RESE'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteCVEN: TFloatField
      FieldName = 'CVEN'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteIMPO: TFloatField
      FieldName = 'IMPO'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteLUCR: TFloatField
      FieldName = 'LUCR'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteICME: TFloatField
      FieldName = 'ICME'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteICMS: TFloatField
      FieldName = 'ICMS'
      DisplayFormat = '#,##0.00'
      EditFormat = '##0.00'
    end
    object ibdEmitenteCRT: TIBStringField
      FieldName = 'CRT'
      Origin = 'EMITENTE.CRT'
      Size = 1
    end
    object ibdEmitenteCNAE: TIBStringField
      FieldName = 'CNAE'
      Origin = 'EMITENTE.CNAE'
      Size = 7
    end
    object ibdEmitenteREGISTRO: TIBStringField
      FieldName = 'REGISTRO'
      Origin = 'EMITENTE.REGISTRO'
      Size = 10
    end
    object ibdEmitenteENCRYPTHASH: TIBStringField
      FieldName = 'ENCRYPTHASH'
      Origin = 'EMITENTE.ENCRYPTHASH'
      Visible = False
      Size = 56
    end
    object ibdEmitenteLICENCA: TIBStringField
      FieldName = 'LICENCA'
      Origin = 'EMITENTE.LICENCA'
      Visible = False
      Size = 56
    end
  end
end
