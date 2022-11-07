object Form17: TForm17
  Left = 512
  Top = 330
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      OnExit = SMALL_DBEdit4Exit
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      DataSource = Form7.DataSource13
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
      Items.Strings = (
        '111301 - Cultivo de arroz'
        '111302 - Cultivo de milho'
        '111303 - Cultivo de trigo'
        
          '111399 - Cultivo de outros cereais n'#227'o especificados anteriormen' +
          'te'
        '112101 - Cultivo de algod'#227'o herb'#225'ceo'
        '112102 - Cultivo de juta'
        
          '112199 - Cultivo de outras fibras de lavoura tempor'#225'ria n'#227'o espe' +
          'cificadas anteriormente'
        '113000 - Cultivo de canadea'#231#250'car'
        '114800 - Cultivo de fumo'
        '115600 - Cultivo de soja'
        '116401 - Cultivo de amendoim'
        '116402 - Cultivo de girassol'
        '116403 - Cultivo de mamona'
        
          '116499 - Cultivo de outras oleaginosas de lavoura tempor'#225'ria n'#227'o' +
          ' especificadas anteriormente'
        '119901 - Cultivo de abacaxi'
        '119902 - Cultivo de alho'
        '119903 - Cultivo de batatainglesa'
        '119904 - Cultivo de cebola'
        '119905 - Cultivo de feij'#227'o'
        '119906 - Cultivo de mandioca'
        '119907 - Cultivo de mel'#227'o'
        '119908 - Cultivo de melancia'
        '119909 - Cultivo de tomate rasteiro'
        
          '119999 - Cultivo de outras plantas de lavoura tempor'#225'ria n'#227'o esp' +
          'ecificadas anteriormente'
        '121101 - Horticultura, exceto morango'
        '121102 - Cultivo de morango'
        '122900 - Cultivo de flores e plantas ornamentais'
        '131800 - Cultivo de laranja'
        '132600 - Cultivo de uva'
        '133401 - Cultivo de a'#231'a'#237
        '133402 - Cultivo de banana'
        '133403 - Cultivo de caju'
        '133404 - Cultivo de c'#237'tricos, exceto laranja'
        '133405 - Cultivo de cocodaba'#237'a'
        '133406 - Cultivo de guaran'#225
        '133407 - Cultivo de ma'#231#227
        '133408 - Cultivo de mam'#227'o'
        '133409 - Cultivo de maracuj'#225
        '133410 - Cultivo de manga'
        '133411 - Cultivo de p'#234'ssego'
        
          '133499 - Cultivo de frutas de lavoura permanente n'#227'o especificad' +
          'as anteriormente'
        '134200 - Cultivo de caf'#233
        '135100 - Cultivo de cacau'
        '139301 - Cultivo de ch'#225'da'#237'ndia'
        '139302 - Cultivo de ervamate'
        '139303 - Cultivo de pimentadoreino'
        
          '139304 - Cultivo de plantas para condimento, exceto pimentadorei' +
          'no'
        '139305 - Cultivo de dend'#234
        '139306 - Cultivo de seringueira'
        
          '139399 - Cultivo de outras plantas de lavoura permanente n'#227'o esp' +
          'ecificadas anteriormente'
        
          '141501 - Produ'#231#227'o de sementes certificadas, exceto de forrageira' +
          's para pasto'
        
          '141502 - Produ'#231#227'o de sementes certificadas de forrageiras para f' +
          'orma'#231#227'o de pasto'
        
          '142300 - Produ'#231#227'o de mudas e outras formas de propaga'#231#227'o vegetal' +
          ', certificadas'
        '151201 - Cria'#231#227'o de bovinos para corte'
        '151202 - Cria'#231#227'o de bovinos para leite'
        '151203 - Cria'#231#227'o de bovinos, exceto para corte e leite'
        '152101 - Cria'#231#227'o de bufalinos'
        '152102 - Cria'#231#227'o de eq'#252'inos'
        '152103 - Cria'#231#227'o de asininos e muares'
        '153901 - Cria'#231#227'o de caprinos'
        '153902 - Cria'#231#227'o de ovinos, inclusive para produ'#231#227'o de l'#227
        '154700 - Cria'#231#227'o de su'#237'nos'
        '155501 - Cria'#231#227'o de frangos para corte'
        '155502 - Produ'#231#227'o de pintos de um dia'
        '155503 - Cria'#231#227'o de outros galin'#225'ceos, exceto para corte'
        '155504 - Cria'#231#227'o de aves, exceto galin'#225'ceos'
        '155505 - Produ'#231#227'o de ovos'
        '159801 - Apicultura'
        '159802 - Cria'#231#227'o de animais de estima'#231#227'o'
        '159803 - Cria'#231#227'o de escarg'#244
        '159804 - Cria'#231#227'o de bichodaseda'
        
          '159899 - Cria'#231#227'o de outros animais n'#227'o especificados anteriormen' +
          'te'
        '161001 - Servi'#231'o de pulveriza'#231#227'o e controle de pragas agr'#237'colas'
        '161002 - Servi'#231'o de poda de '#225'rvores para lavouras'
        '161003 - Servi'#231'o de prepara'#231#227'o de terreno, cultivo e colheita'
        
          '161099 - Atividades de apoio '#224' agricultura n'#227'o especificadas ant' +
          'eriormente'
        '162801 - Servi'#231'o de insemina'#231#227'o artificial em animais'
        '162802 - Servi'#231'o de tosquiamento de ovinos'
        '162803 - Servi'#231'o de manejo de animais'
        
          '162899 - Atividades de apoio '#224' pecu'#225'ria n'#227'o especificadas anteri' +
          'ormente'
        '163600 - Atividades de p'#243'scolheita'
        '170900 - Ca'#231'a e servi'#231'os relacionados'
        '210101 - Cultivo de eucalipto'
        '210102 - Cultivo de ac'#225'cianegra'
        '210103 - Cultivo de pinus'
        '210104 - Cultivo de teca'
        
          '210105 - Cultivo de esp'#233'cies madeireiras, exceto eucalipto, ac'#225'c' +
          'ianegra, pinus e teca'
        '210106 - Cultivo de mudas em viveiros florestais'
        '210107 - Extra'#231#227'o de madeira em florestas plantadas'
        '210108 - Produ'#231#227'o de carv'#227'o vegetal  florestas plantadas'
        '210109 - Produ'#231#227'o de casca de ac'#225'cianegra  florestas plantadas'
        
          '210199 - Produ'#231#227'o de produtos n'#227'omadeireiros n'#227'o especificados a' +
          'nteriormente em florestas plantadas'
        '220901 - Extra'#231#227'o de madeira em florestas nativas'
        '220902 - Produ'#231#227'o de carv'#227'o vegetal  florestas nativas'
        '220903 - Coleta de castanhadopar'#225' em florestas nativas'
        '220904 - Coleta de l'#225'tex em florestas nativas'
        '220905 - Coleta de palmito em florestas nativas'
        '220906 - Conserva'#231#227'o de florestas nativas'
        
          '220999 - Coleta de produtos n'#227'omadeireiros n'#227'o especificados ant' +
          'eriormente em florestas nativas'
        '230600 - Atividades de apoio '#224' produ'#231#227'o florestal'
        '311601 - Pesca de peixes em '#225'gua salgada'
        '311602 - Pesca de crust'#225'ceos e moluscos em '#225'gua salgada'
        '311603 - Coleta de outros produtos marinhos'
        '311604 - Atividades de apoio '#224' pesca em '#225'gua salgada'
        '312401 - Pesca de peixes em '#225'gua doce'
        '312402 - Pesca de crust'#225'ceos e moluscos em '#225'gua doce'
        '312403 - Coleta de outros produtos aqu'#225'ticos de '#225'gua doce'
        '312404 - Atividades de apoio '#224' pesca em '#225'gua doce'
        '321301 - Cria'#231#227'o de peixes em '#225'gua salgada e salobra'
        '321302 - Cria'#231#227'o de camar'#245'es em '#225'gua salgada e salobra'
        '321303 - Cria'#231#227'o de ostras e mexilh'#245'es em '#225'gua salgada e salobra'
        '321304 - Cria'#231#227'o de peixes ornamentais em '#225'gua salgada e salobra'
        
          '321305 - Atividades de apoio '#224' aq'#252'icultura em '#225'gua salgada e sal' +
          'obra'
        
          '321399 - Cultivos e semicultivos da aq'#252'icultura em '#225'gua salgada ' +
          'e salobra n'#227'o especificados anteriormente'
        '322101 - Cria'#231#227'o de peixes em '#225'gua doce'
        '322102 - Cria'#231#227'o de camar'#245'es em '#225'gua doce'
        '322103 - Cria'#231#227'o de ostras e mexilh'#245'es em '#225'gua doce'
        '322104 - Cria'#231#227'o de peixes ornamentais em '#225'gua doce'
        '322105 - Ranicultura'
        '322106 - Cria'#231#227'o de jacar'#233
        '322107 - Atividades de apoio '#224' aq'#252'icultura em '#225'gua doce'
        
          '322199 - Cultivos e semicultivos da aq'#252'icultura em '#225'gua doce n'#227'o' +
          ' especificados anteriormente'
        '500301 - Extra'#231#227'o de carv'#227'o mineral'
        '500302 - Beneficiamento de carv'#227'o mineral'
        '600001 - Extra'#231#227'o de petr'#243'leo e g'#225's natural'
        '600002 - Extra'#231#227'o e beneficiamento de xisto'
        '600003 - Extra'#231#227'o e beneficiamento de areias betuminosas'
        '710301 - Extra'#231#227'o de min'#233'rio de ferro'
        
          '710302 - Pelotiza'#231#227'o, sinteriza'#231#227'o e outros beneficiamentos de m' +
          'in'#233'rio de ferro'
        '721901 - Extra'#231#227'o de min'#233'rio de alum'#237'nio'
        '721902 - Beneficiamento de min'#233'rio de alum'#237'nio'
        '722701 - Extra'#231#227'o de min'#233'rio de estanho'
        '722702 - Beneficiamento de min'#233'rio de estanho'
        '723501 - Extra'#231#227'o de min'#233'rio de mangan'#234's'
        '723502 - Beneficiamento de min'#233'rio de mangan'#234's'
        '724301 - Extra'#231#227'o de min'#233'rio de metais preciosos'
        '724302 - Beneficiamento de min'#233'rio de metais preciosos'
        '725100 - Extra'#231#227'o de minerais radioativos'
        '729401 - Extra'#231#227'o de min'#233'rios de ni'#243'bio e tit'#226'nio'
        '729402 - Extra'#231#227'o de min'#233'rio de tungst'#234'nio'
        '729403 - Extra'#231#227'o de min'#233'rio de n'#237'quel'
        
          '729404 - Extra'#231#227'o de min'#233'rios de cobre, chumbo, zinco e outros m' +
          'inerais met'#225'licos n'#227'oferrosos n'#227'o especificados anteriormente'
        
          '729405 - Beneficiamento de min'#233'rios de cobre, chumbo, zinco e ou' +
          'tros minerais met'#225'licos n'#227'oferrosos n'#227'o especificados anteriorme' +
          'nte'
        '810001 - Extra'#231#227'o de ard'#243'sia e beneficiamento associado'
        '810002 - Extra'#231#227'o de granito e beneficiamento associado'
        '810003 - Extra'#231#227'o de m'#225'rmore e beneficiamento associado'
        
          '810004 - Extra'#231#227'o de calc'#225'rio e dolomita e beneficiamento associ' +
          'ado'
        '810005 - Extra'#231#227'o de gesso e caulim'
        
          '810006 - Extra'#231#227'o de areia, cascalho ou pedregulho e beneficiame' +
          'nto associado'
        '810007 - Extra'#231#227'o de argila e beneficiamento associado'
        '810008 - Extra'#231#227'o de saibro e beneficiamento associado'
        '810009 - Extra'#231#227'o de basalto e beneficiamento associado'
        '810010 - Beneficiamento de gesso e caulim associado '#224' extra'#231#227'o'
        
          '810099 - Extra'#231#227'o e britamento de pedras e outros materiais para' +
          ' constru'#231#227'o e beneficiamento associado'
        
          '891600 - Extra'#231#227'o de minerais para fabrica'#231#227'o de adubos, fertili' +
          'zantes e outros produtos qu'#237'micos'
        '892401 - Extra'#231#227'o de sal marinho'
        '892402 - Extra'#231#227'o de salgema'
        '892403 - Refino e outros tratamentos do sal'
        '893200 - Extra'#231#227'o de gemas (pedras preciosas e semipreciosas)'
        '899101 - Extra'#231#227'o de grafita'
        '899102 - Extra'#231#227'o de quartzo'
        '899103 - Extra'#231#227'o de amianto'
        
          '899199 - Extra'#231#227'o de outros minerais n'#227'omet'#225'licos n'#227'o especifica' +
          'dos anteriormente'
        
          '910600 - Atividades de apoio '#224' extra'#231#227'o de petr'#243'leo e g'#225's natura' +
          'l'
        '990401 - Atividades de apoio '#224' extra'#231#227'o de min'#233'rio de ferro'
        
          '990402 - Atividades de apoio '#224' extra'#231#227'o de minerais met'#225'licos n'#227 +
          'oferrosos'
        '990403 - Atividades de apoio '#224' extra'#231#227'o de minerais n'#227'omet'#225'licos'
        '1011201 - Frigor'#237'fico  abate de bovinos'
        '1011202 - Frigor'#237'fico  abate de eq'#252'inos'
        '1011203 - Frigor'#237'fico  abate de ovinos e caprinos'
        '1011204 - Frigor'#237'fico  abate de bufalinos'
        
          '1011205 - Matadouro  abate de reses sob contrato, exceto abate d' +
          'e su'#237'nos'
        '1012101 - Abate de aves'
        '1012102 - Abate de pequenos animais'
        '1012103 - Frigor'#237'fico  abate de su'#237'nos'
        '1012104 - Matadouro  abate de su'#237'nos sob contrato'
        '1013901 - Fabrica'#231#227'o de produtos de carne'
        '1013902 - Prepara'#231#227'o de subprodutos do abate'
        '1020101 - Preserva'#231#227'o de peixes, crust'#225'ceos e moluscos'
        
          '1020102 - Fabrica'#231#227'o de conservas de peixes, crust'#225'ceos e molusc' +
          'os'
        '1031700 - Fabrica'#231#227'o de conservas de frutas'
        '1032501 - Fabrica'#231#227'o de conservas de palmito'
        
          '1032599 - Fabrica'#231#227'o de conservas de legumes e outros vegetais, ' +
          'exceto palmito'
        
          '1033301 - Fabrica'#231#227'o de sucos concentrados de frutas, hortali'#231'as' +
          ' e legumes'
        
          '1033302 - Fabrica'#231#227'o de sucos de frutas, hortali'#231'as e legumes, e' +
          'xceto concentrados'
        
          '1041400 - Fabrica'#231#227'o de '#243'leos vegetais em bruto, exceto '#243'leo de ' +
          'milho'
        
          '1042200 - Fabrica'#231#227'o de '#243'leos vegetais refinados, exceto '#243'leo de' +
          ' milho'
        
          '1043100 - Fabrica'#231#227'o de margarina e outras gorduras vegetais e d' +
          'e '#243'leos n'#227'ocomest'#237'veis de animais'
        '1051100 - Prepara'#231#227'o do leite'
        '1052000 - Fabrica'#231#227'o de latic'#237'nios'
        '1053800 - Fabrica'#231#227'o de sorvetes e outros gelados comest'#237'veis'
        '1061901 - Beneficiamento de arroz'
        '1061902 - Fabrica'#231#227'o de produtos do arroz'
        '1062700 - Moagem de trigo e fabrica'#231#227'o de derivados'
        '1063500 - Fabrica'#231#227'o de farinha de mandioca e derivados'
        
          '1064300 - Fabrica'#231#227'o de farinha de milho e derivados, exceto '#243'le' +
          'os de milho'
        '1065101 - Fabrica'#231#227'o de amidos e f'#233'culas de vegetais'
        '1065102 - Fabrica'#231#227'o de '#243'leo de milho em bruto'
        '1065103 - Fabrica'#231#227'o de '#243'leo de milho refinado'
        '1066000 - Fabrica'#231#227'o de alimentos para animais'
        
          '1069400 - Moagem e fabrica'#231#227'o de produtos de origem vegetal n'#227'o ' +
          'especificados anteriormente'
        '1071600 - Fabrica'#231#227'o de a'#231#250'car em bruto'
        '1072401 - Fabrica'#231#227'o de a'#231#250'car de cana refinado'
        
          '1072402 - Fabrica'#231#227'o de a'#231#250'car de cereais (dextrose) e de beterr' +
          'aba'
        '1081301 - Beneficiamento de caf'#233
        '1081302 - Torrefa'#231#227'o e moagem de caf'#233
        '1082100 - Fabrica'#231#227'o de produtos '#224' base de caf'#233
        '1091100 - Fabrica'#231#227'o de produtos de panifica'#231#227'o'
        '1092900 - Fabrica'#231#227'o de biscoitos e bolachas'
        
          '1093701 - Fabrica'#231#227'o de produtos derivados do cacau e de chocola' +
          'tes'
        
          '1093702 - Fabrica'#231#227'o de frutas cristalizadas, balas e semelhante' +
          's'
        '1094500 - Fabrica'#231#227'o de massas aliment'#237'cias'
        
          '1095300 - Fabrica'#231#227'o de especiarias, molhos, temperos e condimen' +
          'tos'
        '1096100 - Fabrica'#231#227'o de alimentos e pratos prontos'
        '1099601 - Fabrica'#231#227'o de vinagres'
        '1099602 - Fabrica'#231#227'o de p'#243's aliment'#237'cios'
        '1099603 - Fabrica'#231#227'o de fermentos e leveduras'
        '1099604 - Fabrica'#231#227'o de gelo comum'
        '1099605 - Fabrica'#231#227'o de produtos para infus'#227'o (ch'#225', mate, etc.)'
        '1099606 - Fabrica'#231#227'o de ado'#231'antes naturais e artificiais'
        
          '1099699 - Fabrica'#231#227'o de outros produtos aliment'#237'cios n'#227'o especif' +
          'icados anteriormente'
        '1111901 - Fabrica'#231#227'o de aguardente de canadea'#231#250'car'
        '1111902 - Fabrica'#231#227'o de outras aguardentes e bebidas destiladas'
        '1112700 - Fabrica'#231#227'o de vinho'
        '1113501 - Fabrica'#231#227'o de malte, inclusive malte u'#237'sque'
        '1113502 - Fabrica'#231#227'o de cervejas e chopes'
        '1121600 - Fabrica'#231#227'o de '#225'guas envasadas'
        '1122401 - Fabrica'#231#227'o de refrigerantes'
        
          '1122402 - Fabrica'#231#227'o de ch'#225' mate e outros ch'#225's prontos para cons' +
          'umo'
        
          '1122403 - Fabrica'#231#227'o de refrescos, xaropes e p'#243's para refrescos,' +
          ' exceto refrescos de frutas'
        
          '1122499 - Fabrica'#231#227'o de outras bebidas n'#227'oalco'#243'licas n'#227'o especif' +
          'icadas anteriormente'
        '1210700 - Processamento industrial do fumo'
        '1220401 - Fabrica'#231#227'o de cigarros'
        '1220402 - Fabrica'#231#227'o de cigarrilhas e charutos'
        '1220403 - Fabrica'#231#227'o de filtros para cigarros'
        
          '1220499 - Fabrica'#231#227'o de outros produtos do fumo, exceto cigarros' +
          ', cigarrilhas e charutos'
        '1311100 - Prepara'#231#227'o e fia'#231#227'o de fibras de algod'#227'o'
        
          '1312000 - Prepara'#231#227'o e fia'#231#227'o de fibras t'#234'xteis naturais, exceto' +
          ' algod'#227'o'
        '1313800 - Fia'#231#227'o de fibras artificiais e sint'#233'ticas'
        '1314600 - Fabrica'#231#227'o de linhas para costurar e bordar'
        '1321900 - Tecelagem de fios de algod'#227'o'
        
          '1322700 - Tecelagem de fios de fibras t'#234'xteis naturais, exceto a' +
          'lgod'#227'o'
        '1323500 - Tecelagem de fios de fibras artificiais e sint'#233'ticas'
        '1330800 - Fabrica'#231#227'o de tecidos de malha'
        
          '1340501 - Estamparia e texturiza'#231#227'o em fios, tecidos, artefatos ' +
          't'#234'xteis e pe'#231'as do vestu'#225'rio'
        
          '1340502 - Alvejamento, tingimento e tor'#231#227'o em fios, tecidos, art' +
          'efatos t'#234'xteis e pe'#231'as do vestu'#225'rio'
        
          '1340599 - Outros servi'#231'os de acabamento em fios, tecidos, artefa' +
          'tos t'#234'xteis e pe'#231'as do vestu'#225'rio'
        '1351100 - Fabrica'#231#227'o de artefatos t'#234'xteis para uso dom'#233'stico'
        '1352900 - Fabrica'#231#227'o de artefatos de tape'#231'aria'
        '1353700 - Fabrica'#231#227'o de artefatos de cordoaria'
        '1354500 - Fabrica'#231#227'o de tecidos especiais, inclusive artefatos'
        
          '1359600 - Fabrica'#231#227'o de outros produtos t'#234'xteis n'#227'o especificado' +
          's anteriormente'
        '1411801 - Confec'#231#227'o de roupas '#237'ntimas'
        '1411802 - Fac'#231#227'o de roupas '#237'ntimas'
        
          '1412601 - Confec'#231#227'o de pe'#231'as do vestu'#225'rio, exceto roupas '#237'ntimas' +
          ' e as confeccionadas sob medida'
        
          '1412602 - Confec'#231#227'o, sob medida, de pe'#231'as do vestu'#225'rio, exceto r' +
          'oupas '#237'ntimas'
        '1412603 - Fac'#231#227'o de pe'#231'as do vestu'#225'rio, exceto roupas '#237'ntimas'
        '1413401 - Confec'#231#227'o de roupas profissionais, exceto sob medida'
        '1413402 - Confec'#231#227'o, sob medida, de roupas profissionais'
        '1413403 - Fac'#231#227'o de roupas profissionais'
        
          '1414200 - Fabrica'#231#227'o de acess'#243'rios do vestu'#225'rio, exceto para seg' +
          'uran'#231'a e prote'#231#227'o'
        '1421500 - Fabrica'#231#227'o de meias'
        
          '1422300 - Fabrica'#231#227'o de artigos do vestu'#225'rio, produzidos em malh' +
          'arias e tricotagens, exceto meias'
        '1510600 - Curtimento e outras prepara'#231#245'es de couro'
        
          '1521100 - Fabrica'#231#227'o de artigos para viagem, bolsas e semelhante' +
          's de qualquer material'
        
          '1529700 - Fabrica'#231#227'o de artefatos de couro n'#227'o especificados ant' +
          'eriormente'
        '1531901 - Fabrica'#231#227'o de cal'#231'ados de couro'
        '1531902 - Acabamento de cal'#231'ados de couro sob contrato'
        '1532700 - Fabrica'#231#227'o de t'#234'nis de qualquer material'
        '1533500 - Fabrica'#231#227'o de cal'#231'ados de material sint'#233'tico'
        
          '1539400 - Fabrica'#231#227'o de cal'#231'ados de materiais n'#227'o especificados ' +
          'anteriormente'
        
          '1540800 - Fabrica'#231#227'o de partes para cal'#231'ados, de qualquer materi' +
          'al'
        '1610201 - Serrarias com desdobramento de madeira'
        '1610202 - Serrarias sem desdobramento de madeira'
        
          '1621800 - Fabrica'#231#227'o de madeira laminada e de chapas de madeira ' +
          'compensada, prensada e aglomerada'
        '1622601 - Fabrica'#231#227'o de casas de madeira pr'#233'fabricadas'
        
          '1622602 - Fabrica'#231#227'o de esquadrias de madeira e de pe'#231'as de made' +
          'ira para instala'#231#245'es industriais e comerciais'
        
          '1622699 - Fabrica'#231#227'o de outros artigos de carpintaria para const' +
          'ru'#231#227'o'
        
          '1623400 - Fabrica'#231#227'o de artefatos de tanoaria e de embalagens de' +
          ' madeira'
        
          '1629301 - Fabrica'#231#227'o de artefatos diversos de madeira, exceto m'#243 +
          'veis'
        
          '1629302 - Fabrica'#231#227'o de artefatos diversos de corti'#231'a, bambu, pa' +
          'lha, vime e outros materiais tran'#231'ados, exceto m'#243'veis'
        
          '1710900 - Fabrica'#231#227'o de celulose e outras pastas para a fabrica'#231 +
          #227'o de papel'
        '1721400 - Fabrica'#231#227'o de papel'
        '1722200 - Fabrica'#231#227'o de cartolina e papelcart'#227'o'
        '1731100 - Fabrica'#231#227'o de embalagens de papel'
        '1732000 - Fabrica'#231#227'o de embalagens de cartolina e papelcart'#227'o'
        
          '1733800 - Fabrica'#231#227'o de chapas e de embalagens de papel'#227'o ondula' +
          'do'
        '1741901 - Fabrica'#231#227'o de formul'#225'rios cont'#237'nuos'
        
          '1741902 - Fabrica'#231#227'o de produtos de papel, cartolina, papelcart'#227 +
          'o e papel'#227'o ondulado para uso comercial e de escrit'#243'rio, exceto ' +
          'formul'#225'rio cont'#237'nuo'
        '1742701 - Fabrica'#231#227'o de fraldas descart'#225'veis'
        '1742702 - Fabrica'#231#227'o de absorventes higi'#234'nicos'
        
          '1742799 - Fabrica'#231#227'o de produtos de papel para uso dom'#233'stico e h' +
          'igi'#234'nicosanit'#225'rio n'#227'o especificados anteriormente'
        
          '1749400 - Fabrica'#231#227'o de produtos de pastas celul'#243'sicas, papel, c' +
          'artolina, papelcart'#227'o e papel'#227'o ondulado n'#227'o especificados anter' +
          'iormente'
        '1811301 - Impress'#227'o de jornais'
        
          '1811302 - Impress'#227'o de livros, revistas e outras publica'#231#245'es per' +
          'i'#243'dicas'
        '1812100 - Impress'#227'o de material de seguran'#231'a'
        '1813001 - Impress'#227'o de material para uso publicit'#225'rio'
        '1813099 - Impress'#227'o de material para outros usos'
        '1821100 - Servi'#231'os de pr'#233'impress'#227'o'
        '1822900 - Servi'#231'os de acabamentos gr'#225'ficos'
        '1830001 - Reprodu'#231#227'o de som em qualquer suporte'
        '1830002 - Reprodu'#231#227'o de v'#237'deo em qualquer suporte'
        '1830003 - Reprodu'#231#227'o de software em qualquer suporte'
        '1910100 - Coquerias'
        '1921700 - Fabrica'#231#227'o de produtos do refino de petr'#243'leo'
        '1922501 - Formula'#231#227'o de combust'#237'veis'
        '1922502 - Rerrefino de '#243'leos lubrificantes'
        
          '1922599 - Fabrica'#231#227'o de outros produtos derivados do petr'#243'leo, e' +
          'xceto produtos do refino'
        '1931400 - Fabrica'#231#227'o de '#225'lcool'
        '1932200 - Fabrica'#231#227'o de biocombust'#237'veis, exceto '#225'lcool'
        '2011800 - Fabrica'#231#227'o de cloro e '#225'lcalis'
        '2012600 - Fabrica'#231#227'o de intermedi'#225'rios para fertilizantes'
        '2013400 - Fabrica'#231#227'o de adubos e fertilizantes'
        '2014200 - Fabrica'#231#227'o de gases industriais'
        '2019301 - Elabora'#231#227'o de combust'#237'veis nucleares'
        
          '2019399 - Fabrica'#231#227'o de outros produtos qu'#237'micos inorg'#226'nicos n'#227'o' +
          ' especificados anteriormente'
        '2021500 - Fabrica'#231#227'o de produtos petroqu'#237'micos b'#225'sicos'
        
          '2022300 - Fabrica'#231#227'o de intermedi'#225'rios para plastificantes, resi' +
          'nas e fibras'
        
          '2029100 - Fabrica'#231#227'o de produtos qu'#237'micos org'#226'nicos n'#227'o especifi' +
          'cados anteriormente'
        '2031200 - Fabrica'#231#227'o de resinas termopl'#225'sticas'
        '2032100 - Fabrica'#231#227'o de resinas termofixas'
        '2033900 - Fabrica'#231#227'o de elast'#244'meros'
        '2040100 - Fabrica'#231#227'o de fibras artificiais e sint'#233'ticas'
        '2051700 - Fabrica'#231#227'o de defensivos agr'#237'colas'
        '2052500 - Fabrica'#231#227'o de desinfestantes domissanit'#225'rios'
        '2061400 - Fabrica'#231#227'o de sab'#245'es e detergentes sint'#233'ticos'
        '2062200 - Fabrica'#231#227'o de produtos de limpeza e polimento'
        
          '2063100 - Fabrica'#231#227'o de cosm'#233'ticos, produtos de perfumaria e de ' +
          'higiene pessoal'
        '2071100 - Fabrica'#231#227'o de tintas, vernizes, esmaltes e lacas'
        '2072000 - Fabrica'#231#227'o de tintas de impress'#227'o'
        
          '2073800 - Fabrica'#231#227'o de impermeabilizantes, solventes e produtos' +
          ' afins'
        '2091600 - Fabrica'#231#227'o de adesivos e selantes'
        '2092401 - Fabrica'#231#227'o de p'#243'lvoras, explosivos e detonantes'
        '2092402 - Fabrica'#231#227'o de artigos pirot'#233'cnicos'
        '2092403 - Fabrica'#231#227'o de f'#243'sforos de seguran'#231'a'
        '2093200 - Fabrica'#231#227'o de aditivos de uso industrial'
        '2094100 - Fabrica'#231#227'o de catalisadores'
        
          '2099101 - Fabrica'#231#227'o de chapas, filmes, pap'#233'is e outros materiai' +
          's e produtos qu'#237'micos para fotografia'
        
          '2099199 - Fabrica'#231#227'o de outros produtos qu'#237'micos n'#227'o especificad' +
          'os anteriormente'
        '2110600 - Fabrica'#231#227'o de produtos farmoqu'#237'micos'
        '2121101 - Fabrica'#231#227'o de medicamentos alop'#225'ticos para uso humano'
        
          '2121102 - Fabrica'#231#227'o de medicamentos homeop'#225'ticos para uso human' +
          'o'
        
          '2121103 - Fabrica'#231#227'o de medicamentos fitoter'#225'picos para uso huma' +
          'no'
        '2122000 - Fabrica'#231#227'o de medicamentos para uso veterin'#225'rio'
        '2123800 - Fabrica'#231#227'o de prepara'#231#245'es farmac'#234'uticas'
        '2211100 - Fabrica'#231#227'o de pneum'#225'ticos e de c'#226'marasdear'
        '2212900 - Reforma de pneum'#225'ticos usados'
        
          '2219600 - Fabrica'#231#227'o de artefatos de borracha n'#227'o especificados ' +
          'anteriormente'
        
          '2221800 - Fabrica'#231#227'o de laminados planos e tubulares de material' +
          ' pl'#225'stico'
        '2222600 - Fabrica'#231#227'o de embalagens de material pl'#225'stico'
        
          '2223400 - Fabrica'#231#227'o de tubos e acess'#243'rios de material pl'#225'stico ' +
          'para uso na constru'#231#227'o'
        
          '2229301 - Fabrica'#231#227'o de artefatos de material pl'#225'stico para uso ' +
          'pessoal e dom'#233'stico'
        
          '2229302 - Fabrica'#231#227'o de artefatos de material pl'#225'stico para usos' +
          ' industriais'
        
          '2229303 - Fabrica'#231#227'o de artefatos de material pl'#225'stico para uso ' +
          'na constru'#231#227'o, exceto tubos e acess'#243'rios'
        
          '2229399 - Fabrica'#231#227'o de artefatos de material pl'#225'stico para outr' +
          'os usos n'#227'o especificados anteriormente'
        '2311700 - Fabrica'#231#227'o de vidro plano e de seguran'#231'a'
        '2312500 - Fabrica'#231#227'o de embalagens de vidro'
        '2319200 - Fabrica'#231#227'o de artigos de vidro'
        '2320600 - Fabrica'#231#227'o de cimento'
        
          '2330301 - Fabrica'#231#227'o de estruturas pr'#233'moldadas de concreto armad' +
          'o, em s'#233'rie e sob encomenda'
        
          '2330302 - Fabrica'#231#227'o de artefatos de cimento para uso na constru' +
          #231#227'o'
        
          '2330303 - Fabrica'#231#227'o de artefatos de fibrocimento para uso na co' +
          'nstru'#231#227'o'
        '2330304 - Fabrica'#231#227'o de casas pr'#233'moldadas de concreto'
        
          '2330305 - Prepara'#231#227'o de massa de concreto e argamassa para const' +
          'ru'#231#227'o'
        
          '2330399 - Fabrica'#231#227'o de outros artefatos e produtos de concreto,' +
          ' cimento, fibrocimento, gesso e materiais semelhantes'
        '2341900 - Fabrica'#231#227'o de produtos cer'#226'micos refrat'#225'rios'
        '2342701 - Fabrica'#231#227'o de azulejos e pisos'
        
          '2342702 - Fabrica'#231#227'o de artefatos de cer'#226'mica e barro cozido par' +
          'a uso na constru'#231#227'o, exceto azulejos e pisos'
        '2349401 - Fabrica'#231#227'o de material sanit'#225'rio de cer'#226'mica'
        
          '2349499 - Fabrica'#231#227'o de produtos cer'#226'micos n'#227'orefrat'#225'rios n'#227'o es' +
          'pecificados anteriormente'
        '2391501 - Britamento de pedras, exceto associado '#224' extra'#231#227'o'
        
          '2391502 - Aparelhamento de pedras para constru'#231#227'o, exceto associ' +
          'ado '#224' extra'#231#227'o'
        
          '2391503 - Aparelhamento de placas e execu'#231#227'o de trabalhos em m'#225'r' +
          'more, granito, ard'#243'sia e outras pedras'
        '2392300 - Fabrica'#231#227'o de cal e gesso'
        
          '2399101 - Decora'#231#227'o, lapida'#231#227'o, grava'#231#227'o, vitrifica'#231#227'o e outros ' +
          'trabalhos em cer'#226'mica, lou'#231'a, vidro e cristal'
        
          '2399199 - Fabrica'#231#227'o de outros produtos de minerais n'#227'omet'#225'licos' +
          ' n'#227'o especificados anteriormente'
        '2411300 - Produ'#231#227'o de ferrogusa'
        '2412100 - Produ'#231#227'o de ferroligas'
        '2421100 - Produ'#231#227'o de semiacabados de a'#231'o'
        
          '2422901 - Produ'#231#227'o de laminados planos de a'#231'o ao carbono, revest' +
          'idos ou n'#227'o'
        '2422902 - Produ'#231#227'o de laminados planos de a'#231'os especiais'
        '2423701 - Produ'#231#227'o de tubos de a'#231'o sem costura'
        '2423702 - Produ'#231#227'o de laminados longos de a'#231'o, exceto tubos'
        '2424501 - Produ'#231#227'o de arames de a'#231'o'
        
          '2424502 - Produ'#231#227'o de relaminados, trefilados e perfilados de a'#231 +
          'o, exceto arames'
        '2431800 - Produ'#231#227'o de tubos de a'#231'o com costura'
        '2439300 - Produ'#231#227'o de outros tubos de ferro e a'#231'o'
        '2441501 - Produ'#231#227'o de alum'#237'nio e suas ligas em formas prim'#225'rias'
        '2441502 - Produ'#231#227'o de laminados de alum'#237'nio'
        '2442300 - Metalurgia dos metais preciosos'
        '2443100 - Metalurgia do cobre'
        '2449101 - Produ'#231#227'o de zinco em formas prim'#225'rias'
        '2449102 - Produ'#231#227'o de laminados de zinco'
        '2449103 - Produ'#231#227'o de soldas e '#226'nodos para galvanoplastia'
        
          '2449199 - Metalurgia de outros metais n'#227'oferrosos e suas ligas n' +
          #227'o especificados anteriormente'
        '2451200 - Fundi'#231#227'o de ferro e a'#231'o'
        '2452100 - Fundi'#231#227'o de metais n'#227'oferrosos e suas ligas'
        '2511000 - Fabrica'#231#227'o de estruturas met'#225'licas'
        '2512800 - Fabrica'#231#227'o de esquadrias de metal'
        '2513600 - Fabrica'#231#227'o de obras de caldeiraria pesada'
        
          '2521700 - Fabrica'#231#227'o de tanques, reservat'#243'rios met'#225'licos e calde' +
          'iras para aquecimento central'
        
          '2522500 - Fabrica'#231#227'o de caldeiras geradoras de vapor, exceto par' +
          'a aquecimento central e para ve'#237'culos'
        '2531401 - Produ'#231#227'o de forjados de a'#231'o'
        
          '2531402 - Produ'#231#227'o de forjados de metais n'#227'oferrosos e suas liga' +
          's'
        '2532201 - Produ'#231#227'o de artefatos estampados de metal'
        '2532202 - Metalurgia do p'#243
        
          '2539000 - Servi'#231'os de usinagem, solda, tratamento e revestimento' +
          ' em metais'
        '2541100 - Fabrica'#231#227'o de artigos de cutelaria'
        
          '2542000 - Fabrica'#231#227'o de artigos de serralheria, exceto esquadria' +
          's'
        '2543800 - Fabrica'#231#227'o de ferramentas'
        
          '2550101 - Fabrica'#231#227'o de equipamento b'#233'lico pesado, exceto ve'#237'cul' +
          'os militares de combate'
        '2550102 - Fabrica'#231#227'o de armas de fogo e muni'#231#245'es'
        '2591800 - Fabrica'#231#227'o de embalagens met'#225'licas'
        
          '2592601 - Fabrica'#231#227'o de produtos de trefilados de metal padroniz' +
          'ados'
        
          '2592602 - Fabrica'#231#227'o de produtos de trefilados de metal, exceto ' +
          'padronizados'
        
          '2593400 - Fabrica'#231#227'o de artigos de metal para uso dom'#233'stico e pe' +
          'ssoal'
        
          '2599301 - Servi'#231'os de confec'#231#227'o de arma'#231#245'es met'#225'licas para a con' +
          'stru'#231#227'o'
        
          '2599399 - Fabrica'#231#227'o de outros produtos de metal n'#227'o especificad' +
          'os anteriormente'
        '2610800 - Fabrica'#231#227'o de componentes eletr'#244'nicos'
        '2621300 - Fabrica'#231#227'o de equipamentos de inform'#225'tica'
        
          '2622100 - Fabrica'#231#227'o de perif'#233'ricos para equipamentos de inform'#225 +
          'tica'
        
          '2631100 - Fabrica'#231#227'o de equipamentos transmissores de comunica'#231#227 +
          'o, pe'#231'as e acess'#243'rios'
        
          '2632900 - Fabrica'#231#227'o de aparelhos telef'#244'nicos e de outros equipa' +
          'mentos de comunica'#231#227'o, pe'#231'as e acess'#243'rios'
        
          '2640000 - Fabrica'#231#227'o de aparelhos de recep'#231#227'o, reprodu'#231#227'o, grava' +
          #231#227'o e amplifica'#231#227'o de '#225'udio e v'#237'deo'
        
          '2651500 - Fabrica'#231#227'o de aparelhos e equipamentos de medida, test' +
          'e e controle'
        '2652300 - Fabrica'#231#227'o de cron'#244'metros e rel'#243'gios'
        
          '2660400 - Fabrica'#231#227'o de aparelhos eletrom'#233'dicos e eletroterap'#234'ut' +
          'icos e equipamentos de irradia'#231#227'o'
        
          '2670101 - Fabrica'#231#227'o de equipamentos e instrumentos '#243'pticos, pe'#231 +
          'as e acess'#243'rios'
        
          '2670102 - Fabrica'#231#227'o de aparelhos fotogr'#225'ficos e cinematogr'#225'fico' +
          's, pe'#231'as e acess'#243'rios'
        '2680900 - Fabrica'#231#227'o de m'#237'dias virgens, magn'#233'ticas e '#243'pticas'
        
          '2710401 - Fabrica'#231#227'o de geradores de corrente cont'#237'nua e alterna' +
          'da, pe'#231'as e acess'#243'rios'
        
          '2710402 - Fabrica'#231#227'o de transformadores, indutores, conversores,' +
          ' sincronizadores e semelhantes, pe'#231'as e acess'#243'rios'
        '2710403 - Fabrica'#231#227'o de motores el'#233'tricos, pe'#231'as e acess'#243'rios'
        
          '2721000 - Fabrica'#231#227'o de pilhas, baterias e acumuladores el'#233'trico' +
          's, exceto para ve'#237'culos automotores'
        
          '2722801 - Fabrica'#231#227'o de baterias e acumuladores para ve'#237'culos au' +
          'tomotores'
        
          '2722802 - Recondicionamento de baterias e acumuladores para ve'#237'c' +
          'ulos automotores'
        
          '2731700 - Fabrica'#231#227'o de aparelhos e equipamentos para distribui'#231 +
          #227'o e controle de energia el'#233'trica'
        
          '2732500 - Fabrica'#231#227'o de material el'#233'trico para instala'#231#245'es em ci' +
          'rcuito de consumo'
        
          '2733300 - Fabrica'#231#227'o de fios, cabos e condutores el'#233'tricos isola' +
          'dos'
        '2740601 - Fabrica'#231#227'o de l'#226'mpadas'
        
          '2740602 - Fabrica'#231#227'o de lumin'#225'rias e outros equipamentos de ilum' +
          'ina'#231#227'o'
        
          '2751100 - Fabrica'#231#227'o de fog'#245'es, refrigeradores e m'#225'quinas de lav' +
          'ar e secar para uso dom'#233'stico, pe'#231'as e acess'#243'rios'
        
          '2759701 - Fabrica'#231#227'o de aparelhos el'#233'tricos de uso pessoal, pe'#231'a' +
          's e acess'#243'rios'
        
          '2759799 - Fabrica'#231#227'o de outros aparelhos eletrodom'#233'sticos n'#227'o es' +
          'pecificados anteriormente, pe'#231'as e acess'#243'rios'
        
          '2790201 - Fabrica'#231#227'o de eletrodos, contatos e outros artigos de ' +
          'carv'#227'o e grafita para uso el'#233'trico, eletro'#237'm'#227's e isoladores'
        '2790202 - Fabrica'#231#227'o de equipamentos para sinaliza'#231#227'o e alarme'
        
          '2790299 - Fabrica'#231#227'o de outros equipamentos e aparelhos el'#233'trico' +
          's n'#227'o especificados anteriormente'
        
          '2811900 - Fabrica'#231#227'o de motores e turbinas, pe'#231'as e acess'#243'rios, ' +
          'exceto para avi'#245'es e ve'#237'culos rodovi'#225'rios'
        
          '2812700 - Fabrica'#231#227'o de equipamentos hidr'#225'ulicos e pneum'#225'ticos, ' +
          'pe'#231'as e acess'#243'rios, exceto v'#225'lvulas'
        
          '2813500 - Fabrica'#231#227'o de v'#225'lvulas, registros e dispositivos semel' +
          'hantes, pe'#231'as e acess'#243'rios'
        
          '2814301 - Fabrica'#231#227'o de compressores para uso industrial, pe'#231'as ' +
          'e acess'#243'rios'
        
          '2814302 - Fabrica'#231#227'o de compressores para uso n'#227'oindustrial, pe'#231 +
          'as e acess'#243'rios'
        '2815101 - Fabrica'#231#227'o de rolamentos para fins industriais'
        
          '2815102 - Fabrica'#231#227'o de equipamentos de transmiss'#227'o para fins in' +
          'dustriais, exceto rolamentos'
        
          '2821601 - Fabrica'#231#227'o de fornos industriais, aparelhos e equipame' +
          'ntos n'#227'oel'#233'tricos para instala'#231#245'es t'#233'rmicas, pe'#231'as e acess'#243'rios'
        
          '2821602 - Fabrica'#231#227'o de estufas e fornos el'#233'tricos para fins ind' +
          'ustriais, pe'#231'as e acess'#243'rios'
        
          '2822401 - Fabrica'#231#227'o de m'#225'quinas, equipamentos e aparelhos para ' +
          'transporte e eleva'#231#227'o de pessoas, pe'#231'as e acess'#243'rios'
        
          '2822402 - Fabrica'#231#227'o de m'#225'quinas, equipamentos e aparelhos para ' +
          'transporte e eleva'#231#227'o de cargas, pe'#231'as e acess'#243'rios'
        
          '2823200 - Fabrica'#231#227'o de m'#225'quinas e aparelhos de refrigera'#231#227'o e v' +
          'entila'#231#227'o para uso industrial e comercial, pe'#231'as e acess'#243'rios'
        
          '2824101 - Fabrica'#231#227'o de aparelhos e equipamentos de ar condicion' +
          'ado para uso industrial'
        
          '2824102 - Fabrica'#231#227'o de aparelhos e equipamentos de ar condicion' +
          'ado para uso n'#227'oindustrial'
        
          '2825900 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para saneamento ' +
          'b'#225'sico e ambiental, pe'#231'as e acess'#243'rios'
        
          '2829101 - Fabrica'#231#227'o de m'#225'quinas de escrever, calcular e outros ' +
          'equipamentos n'#227'oeletr'#244'nicos para escrit'#243'rio, pe'#231'as e acess'#243'rios'
        
          '2829199 - Fabrica'#231#227'o de outras m'#225'quinas e equipamentos de uso ge' +
          'ral n'#227'o especificados anteriormente, pe'#231'as e acess'#243'rios'
        '2831300 - Fabrica'#231#227'o de tratores agr'#237'colas, pe'#231'as e acess'#243'rios'
        
          '2832100 - Fabrica'#231#227'o de equipamentos para irriga'#231#227'o agr'#237'cola, pe' +
          #231'as e acess'#243'rios'
        
          '2833000 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para a agricultu' +
          'ra e pecu'#225'ria, pe'#231'as e acess'#243'rios, exceto para irriga'#231#227'o'
        '2840200 - Fabrica'#231#227'o de m'#225'quinasferramenta, pe'#231'as e acess'#243'rios'
        
          '2851800 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para a prospec'#231#227 +
          'o e extra'#231#227'o de petr'#243'leo, pe'#231'as e acess'#243'rios'
        
          '2852600 - Fabrica'#231#227'o de outras m'#225'quinas e equipamentos para uso ' +
          'na extra'#231#227'o mineral, pe'#231'as e acess'#243'rios, exceto na extra'#231#227'o de p' +
          'etr'#243'leo'
        
          '2853400 - Fabrica'#231#227'o de tratores, pe'#231'as e acess'#243'rios, exceto agr' +
          #237'colas'
        
          '2854200 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para terraplenag' +
          'em, pavimenta'#231#227'o e constru'#231#227'o, pe'#231'as e acess'#243'rios, exceto trator' +
          'es'
        
          '2861500 - Fabrica'#231#227'o de m'#225'quinas para a ind'#250'stria metal'#250'rgica, p' +
          'e'#231'as e acess'#243'rios, exceto m'#225'quinasferramenta'
        
          '2862300 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para as ind'#250'stri' +
          'as de alimentos, bebidas e fumo, pe'#231'as e acess'#243'rios'
        
          '2863100 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para a ind'#250'stria' +
          ' t'#234'xtil, pe'#231'as e acess'#243'rios'
        
          '2864000 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para as ind'#250'stri' +
          'as do vestu'#225'rio, do couro e de cal'#231'ados, pe'#231'as e acess'#243'rios'
        
          '2865800 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para as ind'#250'stri' +
          'as de celulose, papel e papel'#227'o e artefatos, pe'#231'as e acess'#243'rios'
        
          '2866600 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para a ind'#250'stria' +
          ' do pl'#225'stico, pe'#231'as e acess'#243'rios'
        
          '2869100 - Fabrica'#231#227'o de m'#225'quinas e equipamentos para uso industr' +
          'ial espec'#237'fico n'#227'o especificados anteriormente, pe'#231'as e acess'#243'ri' +
          'os'
        '2910701 - Fabrica'#231#227'o de autom'#243'veis, camionetas e utilit'#225'rios'
        
          '2910702 - Fabrica'#231#227'o de chassis com motor para autom'#243'veis, camio' +
          'netas e utilit'#225'rios'
        
          '2910703 - Fabrica'#231#227'o de motores para autom'#243'veis, camionetas e ut' +
          'ilit'#225'rios'
        '2920401 - Fabrica'#231#227'o de caminh'#245'es e '#244'nibus'
        '2920402 - Fabrica'#231#227'o de motores para caminh'#245'es e '#244'nibus'
        
          '2930101 - Fabrica'#231#227'o de cabines, carrocerias e reboques para cam' +
          'inh'#245'es'
        '2930102 - Fabrica'#231#227'o de carrocerias para '#244'nibus'
        
          '2930103 - Fabrica'#231#227'o de cabines, carrocerias e reboques para out' +
          'ros ve'#237'culos automotores, exceto caminh'#245'es e '#244'nibus'
        
          '2941700 - Fabrica'#231#227'o de pe'#231'as e acess'#243'rios para o sistema motor ' +
          'de ve'#237'culos automotores'
        
          '2942500 - Fabrica'#231#227'o de pe'#231'as e acess'#243'rios para os sistemas de m' +
          'archa e transmiss'#227'o de ve'#237'culos automotores'
        
          '2943300 - Fabrica'#231#227'o de pe'#231'as e acess'#243'rios para o sistema de fre' +
          'ios de ve'#237'culos automotores'
        
          '2944100 - Fabrica'#231#227'o de pe'#231'as e acess'#243'rios para o sistema de dir' +
          'e'#231#227'o e suspens'#227'o de ve'#237'culos automotores'
        
          '2945000 - Fabrica'#231#227'o de material el'#233'trico e eletr'#244'nico para ve'#237'c' +
          'ulos automotores, exceto baterias'
        
          '2949201 - Fabrica'#231#227'o de bancos e estofados para ve'#237'culos automot' +
          'ores'
        
          '2949299 - Fabrica'#231#227'o de outras pe'#231'as e acess'#243'rios para ve'#237'culos ' +
          'automotores n'#227'o especificadas anteriormente'
        
          '2950600 - Recondicionamento e recupera'#231#227'o de motores para ve'#237'cul' +
          'os automotores'
        '3011301 - Constru'#231#227'o de embarca'#231#245'es de grande porte'
        
          '3011302 - Constru'#231#227'o de embarca'#231#245'es para uso comercial e para us' +
          'os especiais, exceto de grande porte'
        '3012100 - Constru'#231#227'o de embarca'#231#245'es para esporte e lazer'
        
          '3031800 - Fabrica'#231#227'o de locomotivas, vag'#245'es e outros materiais r' +
          'odantes'
        
          '3032600 - Fabrica'#231#227'o de pe'#231'as e acess'#243'rios para ve'#237'culos ferrovi' +
          #225'rios'
        '3041500 - Fabrica'#231#227'o de aeronaves'
        
          '3042300 - Fabrica'#231#227'o de turbinas, motores e outros componentes e' +
          ' pe'#231'as para aeronaves'
        '3050400 - Fabrica'#231#227'o de ve'#237'culos militares de combate'
        '3091100 - Fabrica'#231#227'o de motocicletas, pe'#231'as e acess'#243'rios'
        
          '3092000 - Fabrica'#231#227'o de bicicletas e triciclos n'#227'omotorizados, p' +
          'e'#231'as e acess'#243'rios'
        
          '3099700 - Fabrica'#231#227'o de equipamentos de transporte n'#227'o especific' +
          'ados anteriormente'
        '3101200 - Fabrica'#231#227'o de m'#243'veis com predomin'#226'ncia de madeira'
        '3102100 - Fabrica'#231#227'o de m'#243'veis com predomin'#226'ncia de metal'
        
          '3103900 - Fabrica'#231#227'o de m'#243'veis de outros materiais, exceto madei' +
          'ra e metal'
        '3104700 - Fabrica'#231#227'o de colch'#245'es'
        '3211601 - Lapida'#231#227'o de gemas'
        '3211602 - Fabrica'#231#227'o de artefatos de joalheria e ourivesaria'
        '3211603 - Cunhagem de moedas e medalhas'
        '3212400 - Fabrica'#231#227'o de bijuterias e artefatos semelhantes'
        
          '3220500 - Fabrica'#231#227'o de instrumentos musicais, pe'#231'as e acess'#243'rio' +
          's'
        '3230200 - Fabrica'#231#227'o de artefatos para pesca e esporte'
        '3240001 - Fabrica'#231#227'o de jogos eletr'#244'nicos'
        
          '3240002 - Fabrica'#231#227'o de mesas de bilhar, de sinuca e acess'#243'rios ' +
          'n'#227'o associada '#224' loca'#231#227'o'
        
          '3240003 - Fabrica'#231#227'o de mesas de bilhar, de sinuca e acess'#243'rios ' +
          'associada '#224' loca'#231#227'o'
        
          '3240099 - Fabrica'#231#227'o de outros brinquedos e jogos recreativos n'#227 +
          'o especificados anteriormente'
        
          '3250701 - Fabrica'#231#227'o de instrumentos n'#227'oeletr'#244'nicos e utens'#237'lios' +
          ' para uso m'#233'dico, cir'#250'rgico, odontol'#243'gico e de laborat'#243'rio'
        
          '3250702 - Fabrica'#231#227'o de mobili'#225'rio para uso m'#233'dico, cir'#250'rgico, o' +
          'dontol'#243'gico e de laborat'#243'rio'
        
          '3250703 - Fabrica'#231#227'o de aparelhos e utens'#237'lios para corre'#231#227'o de ' +
          'defeitos f'#237'sicos e aparelhos ortop'#233'dicos em geral sob encomenda'
        
          '3250704 - Fabrica'#231#227'o de aparelhos e utens'#237'lios para corre'#231#227'o de ' +
          'defeitos f'#237'sicos e aparelhos ortop'#233'dicos em geral, exceto sob en' +
          'comenda'
        '3250705 - Fabrica'#231#227'o de materiais para medicina e odontologia'
        '3250706 - Servi'#231'os de pr'#243'tese dent'#225'ria'
        '3250707 - Fabrica'#231#227'o de artigos '#243'pticos'
        
          '3250708 - Fabrica'#231#227'o de artefatos de tecido n'#227'o tecido para uso ' +
          'odontom'#233'dicohospitalar'
        '3291400 - Fabrica'#231#227'o de escovas, pinc'#233'is e vassouras'
        
          '3292201 - Fabrica'#231#227'o de roupas de prote'#231#227'o e seguran'#231'a e resiste' +
          'ntes a fogo'
        
          '3292202 - Fabrica'#231#227'o de equipamentos e acess'#243'rios para seguran'#231'a' +
          ' pessoal e profissional'
        '3299001 - Fabrica'#231#227'o de guardachuvas e similares'
        
          '3299002 - Fabrica'#231#227'o de canetas, l'#225'pis e outros artigos para esc' +
          'rit'#243'rio'
        
          '3299003 - Fabrica'#231#227'o de letras, letreiros e placas de qualquer m' +
          'aterial, exceto luminosos'
        '3299004 - Fabrica'#231#227'o de pain'#233'is e letreiros luminosos'
        '3299005 - Fabrica'#231#227'o de aviamentos para costura'
        
          '3299099 - Fabrica'#231#227'o de produtos diversos n'#227'o especificados ante' +
          'riormente'
        
          '3311200 - Manuten'#231#227'o e repara'#231#227'o de tanques, reservat'#243'rios met'#225'l' +
          'icos e caldeiras, exceto para ve'#237'culos'
        
          '3312101 - Manuten'#231#227'o e repara'#231#227'o de equipamentos transmissores d' +
          'e comunica'#231#227'o'
        
          '3312102 - Manuten'#231#227'o e repara'#231#227'o de aparelhos e instrumentos de ' +
          'medida, teste e controle'
        
          '3312103 - Manuten'#231#227'o e repara'#231#227'o de aparelhos eletrom'#233'dicos e el' +
          'etroterap'#234'uticos e equipamentos de irradia'#231#227'o'
        
          '3312104 - Manuten'#231#227'o e repara'#231#227'o de equipamentos e instrumentos ' +
          #243'pticos'
        
          '3313901 - Manuten'#231#227'o e repara'#231#227'o de geradores, transformadores e' +
          ' motores el'#233'tricos'
        
          '3313902 - Manuten'#231#227'o e repara'#231#227'o de baterias e acumuladores el'#233't' +
          'ricos, exceto para ve'#237'culos'
        
          '3313999 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas, aparelhos e materi' +
          'ais el'#233'tricos n'#227'o especificados anteriormente'
        
          '3314701 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas motrizes n'#227'oel'#233'tric' +
          'as'
        
          '3314702 - Manuten'#231#227'o e repara'#231#227'o de equipamentos hidr'#225'ulicos e p' +
          'neum'#225'ticos, exceto v'#225'lvulas'
        '3314703 - Manuten'#231#227'o e repara'#231#227'o de v'#225'lvulas industriais'
        '3314704 - Manuten'#231#227'o e repara'#231#227'o de compressores'
        
          '3314705 - Manuten'#231#227'o e repara'#231#227'o de equipamentos de transmiss'#227'o ' +
          'para fins industriais'
        
          '3314706 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas, aparelhos e equipa' +
          'mentos para instala'#231#245'es t'#233'rmicas'
        
          '3314707 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e aparelhos de refr' +
          'igera'#231#227'o e ventila'#231#227'o para uso industrial e comercial'
        
          '3314708 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas, equipamentos e apa' +
          'relhos para transporte e eleva'#231#227'o de cargas'
        
          '3314709 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas de escrever, calcul' +
          'ar e de outros equipamentos n'#227'oeletr'#244'nicos para escrit'#243'rio'
        
          '3314710 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' uso geral n'#227'o especificados anteriormente'
        
          '3314711 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' agricultura e pecu'#225'ria'
        '3314712 - Manuten'#231#227'o e repara'#231#227'o de tratores agr'#237'colas'
        '3314713 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinasferramenta'
        
          '3314714 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' a prospec'#231#227'o e extra'#231#227'o de petr'#243'leo'
        
          '3314715 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' uso na extra'#231#227'o mineral, exceto na extra'#231#227'o de petr'#243'leo'
        '3314716 - Manuten'#231#227'o e repara'#231#227'o de tratores, exceto agr'#237'colas'
        
          '3314717 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos de t' +
          'erraplenagem, pavimenta'#231#227'o e constru'#231#227'o, exceto tratores'
        
          '3314718 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas para a ind'#250'stria me' +
          'tal'#250'rgica, exceto m'#225'quinasferramenta'
        
          '3314719 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' as ind'#250'strias de alimentos, bebidas e fumo'
        
          '3314720 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e equipamentos para' +
          ' a ind'#250'stria t'#234'xtil, do vestu'#225'rio, do couro e cal'#231'ados'
        
          '3314721 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e aparelhos para a ' +
          'ind'#250'stria de celulose, papel e papel'#227'o e artefatos'
        
          '3314722 - Manuten'#231#227'o e repara'#231#227'o de m'#225'quinas e aparelhos para a ' +
          'ind'#250'stria do pl'#225'stico'
        
          '3314799 - Manuten'#231#227'o e repara'#231#227'o de outras m'#225'quinas e equipament' +
          'os para usos industriais n'#227'o especificados anteriormente'
        '3315500 - Manuten'#231#227'o e repara'#231#227'o de ve'#237'culos ferrovi'#225'rios'
        
          '3316301 - Manuten'#231#227'o e repara'#231#227'o de aeronaves, exceto a manuten'#231 +
          #227'o na pista'
        '3316302 - Manuten'#231#227'o de aeronaves na pista'
        ' - Manuten'#231#227'o e repara'#231#227'o de embarca'#231#245'es e estruturas flutuantes'
        '3329501 - Servi'#231'os de montagem de m'#243'veis de qualquer material'
        
          '3329599 - Instala'#231#227'o de outros equipamentos n'#227'o especificados an' +
          'teriormente'
        '3511500 - Gera'#231#227'o de energia el'#233'trica'
        '3512300 - Transmiss'#227'o de energia el'#233'trica'
        '3513100 - Com'#233'rcio atacadista de energia el'#233'trica'
        '3514000 - Distribui'#231#227'o de energia el'#233'trica'
        '3520401 - Produ'#231#227'o de g'#225's; processamento de g'#225's natural'
        '3520402 - Distribui'#231#227'o de combust'#237'veis gasosos por redes urbanas'
        
          '3530100 - Produ'#231#227'o e distribui'#231#227'o de vapor, '#225'gua quente e ar con' +
          'dicionado'
        '3600601 - Capta'#231#227'o, tratamento e distribui'#231#227'o de '#225'gua'
        '3600602 - Distribui'#231#227'o de '#225'gua por caminh'#245'es'
        '3701100 - Gest'#227'o de redes de esgoto'
        
          '3702900 - Atividades relacionadas a esgoto, exceto a gest'#227'o de r' +
          'edes'
        '3811400 - Coleta de res'#237'duos n'#227'operigosos'
        '3812200 - Coleta de res'#237'duos perigosos'
        '3821100 - Tratamento e disposi'#231#227'o de res'#237'duos n'#227'operigosos'
        '3822000 - Tratamento e disposi'#231#227'o de res'#237'duos perigosos'
        '3831901 - Recupera'#231#227'o de sucatas de alum'#237'nio'
        '3831999 - Recupera'#231#227'o de materiais met'#225'licos, exceto alum'#237'nio'
        '3832700 - Recupera'#231#227'o de materiais pl'#225'sticos'
        '3839401 - Usinas de compostagem'
        
          '3839499 - Recupera'#231#227'o de materiais n'#227'o especificados anteriormen' +
          'te'
        
          '3900500 - Descontamina'#231#227'o e outros servi'#231'os de gest'#227'o de res'#237'duo' +
          's'
        '4110700 - Incorpora'#231#227'o de empreendimentos imobili'#225'rios'
        '4120400 - Constru'#231#227'o de edif'#237'cios'
        '4211101 - Constru'#231#227'o de rodovias e ferrovias'
        
          '4211102 - Pintura para sinaliza'#231#227'o em pistas rodovi'#225'rias e aerop' +
          'ortos'
        '4212000 - Constru'#231#227'o de obrasdearte especiais'
        '4213800 - Obras de urbaniza'#231#227'o  ruas, pra'#231'as e cal'#231'adas'
        
          '4221901 - Constru'#231#227'o de barragens e represas para gera'#231#227'o de ene' +
          'rgia el'#233'trica'
        
          '4221902 - Constru'#231#227'o de esta'#231#245'es e redes de distribui'#231#227'o de ener' +
          'gia el'#233'trica'
        
          '4221903 - Manuten'#231#227'o de redes de distribui'#231#227'o de energia el'#233'tric' +
          'a'
        '4221904 - Constru'#231#227'o de esta'#231#245'es e redes de telecomunica'#231#245'es'
        '4221905 - Manuten'#231#227'o de esta'#231#245'es e redes de telecomunica'#231#245'es'
        
          '4222701 - Constru'#231#227'o de redes de abastecimento de '#225'gua, coleta d' +
          'e esgoto e constru'#231#245'es correlatas, exceto obras de irriga'#231#227'o'
        '4222702 - Obras de irriga'#231#227'o'
        
          '4223500 - Constru'#231#227'o de redes de transportes por dutos, exceto p' +
          'ara '#225'gua e esgoto'
        '4291000 - Obras portu'#225'rias, mar'#237'timas e fluviais'
        '4292801 - Montagem de estruturas met'#225'licas'
        '4292802 - Obras de montagem industrial'
        '4299501 - Constru'#231#227'o de instala'#231#245'es esportivas e recreativas'
        
          '4299599 - Outras obras de engenharia civil n'#227'o especificadas ant' +
          'eriormente'
        '4311801 - Demoli'#231#227'o de edif'#237'cios e outras estruturas'
        '4311802 - Prepara'#231#227'o de canteiro e limpeza de terreno'
        '4312600 - Perfura'#231#245'es e sondagens'
        '4313400 - Obras de terraplenagem'
        
          '4319300 - Servi'#231'os de prepara'#231#227'o do terreno n'#227'o especificados an' +
          'teriormente'
        '4321500 - Instala'#231#227'o e manuten'#231#227'o el'#233'trica'
        '4322301 - Instala'#231#245'es hidr'#225'ulicas, sanit'#225'rias e de g'#225's'
        
          '4322302 - Instala'#231#227'o e manuten'#231#227'o de sistemas centrais de ar con' +
          'dicionado, de ventila'#231#227'o e refrigera'#231#227'o'
        '4322303 - Instala'#231#245'es de sistema de preven'#231#227'o contra inc'#234'ndio'
        '4329101 - Instala'#231#227'o de pain'#233'is publicit'#225'rios'
        
          '4329102 - Instala'#231#227'o de equipamentos para orienta'#231#227'o '#224' navega'#231#227'o' +
          ' mar'#237'tima, fluvial e lacustre'
        
          '4329103 - Instala'#231#227'o, manuten'#231#227'o e repara'#231#227'o de elevadores, esca' +
          'das e esteiras rolantes, exceto de fabrica'#231#227'o pr'#243'pria'
        
          '4329104 - Montagem e instala'#231#227'o de sistemas e equipamentos de il' +
          'umina'#231#227'o e sinaliza'#231#227'o em vias p'#250'blicas, portos e aeroportos'
        '4329105 - Tratamentos t'#233'rmicos, ac'#250'sticos ou de vibra'#231#227'o'
        
          '4329199 - Outras obras de instala'#231#245'es em constru'#231#245'es n'#227'o especif' +
          'icadas anteriormente'
        '4330401 - Impermeabiliza'#231#227'o em obras de engenharia civil'
        
          '4330402 - Instala'#231#227'o de portas, janelas, tetos, divis'#243'rias e arm' +
          #225'rios embutidos de qualquer material'
        '4330403 - Obras de acabamento em gesso e estuque'
        '4330404 - Servi'#231'os de pintura de edif'#237'cios em geral'
        
          '4330405 - Aplica'#231#227'o de revestimentos e de resinas em interiores ' +
          'e exteriores'
        '4330499 - Outras obras de acabamento da constru'#231#227'o'
        '4391600 - Obras de funda'#231#245'es'
        '4399101 - Administra'#231#227'o de obras'
        
          '4399102 - Montagem e desmontagem de andaimes e outras estruturas' +
          ' tempor'#225'rias'
        '4399103 - Obras de alvenaria'
        
          '4399104 - Servi'#231'os de opera'#231#227'o e fornecimento de equipamentos pa' +
          'ra transporte e eleva'#231#227'o de cargas e pessoas para uso em obras'
        '4399105 - Perfura'#231#227'o e constru'#231#227'o de po'#231'os de '#225'gua'
        
          '4399199 - Servi'#231'os especializados para constru'#231#227'o n'#227'o especifica' +
          'dos anteriormente'
        
          '4511101 - Com'#233'rcio a varejo de autom'#243'veis, camionetas e utilit'#225'r' +
          'ios novos'
        
          '4511102 - Com'#233'rcio a varejo de autom'#243'veis, camionetas e utilit'#225'r' +
          'ios usados'
        
          '4511103 - Com'#233'rcio por atacado de autom'#243'veis, camionetas e utili' +
          't'#225'rios novos e usados'
        '4511104 - Com'#233'rcio por atacado de caminh'#245'es novos e usados'
        
          '4511105 - Com'#233'rcio por atacado de reboques e semireboques novos ' +
          'e usados'
        
          '4511106 - Com'#233'rcio por atacado de '#244'nibus e micro'#244'nibus novos e u' +
          'sados'
        
          '4512901 - Representantes comerciais e agentes do com'#233'rcio de ve'#237 +
          'culos automotores'
        '4512902 - Com'#233'rcio sob consigna'#231#227'o de ve'#237'culos automotores'
        
          '4520001 - Servi'#231'os de manuten'#231#227'o e repara'#231#227'o mec'#226'nica de ve'#237'culo' +
          's automotores'
        
          '4520002 - Servi'#231'os de lanternagem ou funilaria e pintura de ve'#237'c' +
          'ulos automotores'
        
          '4520003 - Servi'#231'os de manuten'#231#227'o e repara'#231#227'o el'#233'trica de ve'#237'culo' +
          's automotores'
        
          '4520004 - Servi'#231'os de alinhamento e balanceamento de ve'#237'culos au' +
          'tomotores'
        
          '4520005 - Servi'#231'os de lavagem, lubrifica'#231#227'o e polimento de ve'#237'cu' +
          'los automotores'
        '4520006 - Servi'#231'os de borracharia para ve'#237'culos automotores'
        
          '4520007 - Servi'#231'os de instala'#231#227'o, manuten'#231#227'o e repara'#231#227'o de aces' +
          's'#243'rios para ve'#237'culos automotores'
        
          '4530701 - Com'#233'rcio por atacado de pe'#231'as e acess'#243'rios novos para ' +
          've'#237'culos automotores'
        '4530702 - Com'#233'rcio por atacado de pneum'#225'ticos e c'#226'marasdear'
        
          '4530703 - Com'#233'rcio a varejo de pe'#231'as e acess'#243'rios novos para ve'#237 +
          'culos automotores'
        
          '4530704 - Com'#233'rcio a varejo de pe'#231'as e acess'#243'rios usados para ve' +
          #237'culos automotores'
        '4530705 - Com'#233'rcio a varejo de pneum'#225'ticos e c'#226'marasdear'
        
          '4530706 - Representantes comerciais e agentes do com'#233'rcio de pe'#231 +
          'as e acess'#243'rios novos e usados para ve'#237'culos automotores'
        '4541201 - Com'#233'rcio por atacado de motocicletas e motonetas'
        
          '4541202 - Com'#233'rcio por atacado de pe'#231'as e acess'#243'rios para motoci' +
          'cletas e motonetas'
        '4541203 - Com'#233'rcio a varejo de motocicletas e motonetas novas'
        '4541204 - Com'#233'rcio a varejo de motocicletas e motonetas usadas'
        
          '4541205 - Com'#233'rcio a varejo de pe'#231'as e acess'#243'rios para motocicle' +
          'tas e motonetas'
        
          '4542101 - Representantes comerciais e agentes do com'#233'rcio de mot' +
          'ocicletas e motonetas, pe'#231'as e acess'#243'rios'
        '4542102 - Com'#233'rcio sob consigna'#231#227'o de motocicletas e motonetas'
        '4543900 - Manuten'#231#227'o e repara'#231#227'o de motocicletas e motonetas'
        
          '4611700 - Representantes comerciais e agentes do com'#233'rcio de mat' +
          #233'riasprimas agr'#237'colas e animais vivos'
        
          '4612500 - Representantes comerciais e agentes do com'#233'rcio de com' +
          'bust'#237'veis, minerais, produtos sider'#250'rgicos e qu'#237'micos'
        
          '4613300 - Representantes comerciais e agentes do com'#233'rcio de mad' +
          'eira, material de constru'#231#227'o e ferragens'
        
          '4614100 - Representantes comerciais e agentes do com'#233'rcio de m'#225'q' +
          'uinas, equipamentos, embarca'#231#245'es e aeronaves'
        
          '4615000 - Representantes comerciais e agentes do com'#233'rcio de ele' +
          'trodom'#233'sticos, m'#243'veis e artigos de uso dom'#233'stico'
        
          '4616800 - Representantes comerciais e agentes do com'#233'rcio de t'#234'x' +
          'teis, vestu'#225'rio, cal'#231'ados e artigos de viagem'
        
          '4617600 - Representantes comerciais e agentes do com'#233'rcio de pro' +
          'dutos aliment'#237'cios, bebidas e fumo'
        
          '4618401 - Representantes comerciais e agentes do com'#233'rcio de med' +
          'icamentos, cosm'#233'ticos e produtos de perfumaria'
        
          '4618402 - Representantes comerciais e agentes do com'#233'rcio de ins' +
          'trumentos e materiais odontom'#233'dicohospitalares'
        
          '4618403 - Representantes comerciais e agentes do com'#233'rcio de jor' +
          'nais, revistas e outras publica'#231#245'es'
        
          '4618499 - Outros representantes comerciais e agentes do com'#233'rcio' +
          ' especializado em produtos n'#227'o especificados anteriormente'
        
          '4619200 - Representantes comerciais e agentes do com'#233'rcio de mer' +
          'cadorias em geral n'#227'o especializado'
        '4621400 - Com'#233'rcio atacadista de caf'#233' em gr'#227'o'
        '4622200 - Com'#233'rcio atacadista de soja'
        '4623101 - Com'#233'rcio atacadista de animais vivos'
        
          '4623102 - Com'#233'rcio atacadista de couros, l'#227's, peles e outros sub' +
          'produtos n'#227'ocomest'#237'veis de origem animal'
        '4623103 - Com'#233'rcio atacadista de algod'#227'o'
        '4623104 - Com'#233'rcio atacadista de fumo em folha n'#227'o beneficiado'
        '4623105 - Com'#233'rcio atacadista de cacau'
        
          '4623106 - Com'#233'rcio atacadista de sementes, flores, plantas e gra' +
          'mas'
        '4623107 - Com'#233'rcio atacadista de sisal'
        
          '4623108 - Com'#233'rcio atacadista de mat'#233'riasprimas agr'#237'colas com at' +
          'ividade de fracionamento e acondicionamento associada'
        '4623109 - Com'#233'rcio atacadista de alimentos para animais'
        
          '4623199 - Com'#233'rcio atacadista de mat'#233'riasprimas agr'#237'colas n'#227'o es' +
          'pecificadas anteriormente'
        '4631100 - Com'#233'rcio atacadista de leite e latic'#237'nios'
        
          '4632001 - Com'#233'rcio atacadista de cereais e leguminosas beneficia' +
          'dos'
        '4632002 - Com'#233'rcio atacadista de farinhas, amidos e f'#233'culas'
        
          '4632003 - Com'#233'rcio atacadista de cereais e leguminosas beneficia' +
          'dos, farinhas, amidos e f'#233'culas, com atividade de fracionamento ' +
          'e acondicionamento associada'
        
          '4633801 - Com'#233'rcio atacadista de frutas, verduras, ra'#237'zes, tub'#233'r' +
          'culos, hortali'#231'as e legumes frescos'
        '4633802 - Com'#233'rcio atacadista de aves vivas e ovos'
        
          '4633803 - Com'#233'rcio atacadista de coelhos e outros pequenos anima' +
          'is vivos para alimenta'#231#227'o'
        
          '4634601 - Com'#233'rcio atacadista de carnes bovinas e su'#237'nas e deriv' +
          'ados'
        '4634602 - Com'#233'rcio atacadista de aves abatidas e derivados'
        '4634603 - Com'#233'rcio atacadista de pescados e frutos do mar'
        
          '4634699 - Com'#233'rcio atacadista de carnes e derivados de outros an' +
          'imais'
        '4635401 - Com'#233'rcio atacadista de '#225'gua mineral'
        '4635402 - Com'#233'rcio atacadista de cerveja, chope e refrigerante'
        
          '4635403 - Com'#233'rcio atacadista de bebidas com atividade de fracio' +
          'namento e acondicionamento associada'
        
          '4635499 - Com'#233'rcio atacadista de bebidas n'#227'o especificadas anter' +
          'iormente'
        '4636201 - Com'#233'rcio atacadista de fumo beneficiado'
        
          '4636202 - Com'#233'rcio atacadista de cigarros, cigarrilhas e charuto' +
          's'
        '4637101 - Com'#233'rcio atacadista de caf'#233' torrado, mo'#237'do e sol'#250'vel'
        '4637102 - Com'#233'rcio atacadista de a'#231#250'car'
        '4637103 - Com'#233'rcio atacadista de '#243'leos e gorduras'
        
          '4637104 - Com'#233'rcio atacadista de p'#227'es, bolos, biscoitos e simila' +
          'res'
        '4637105 - Com'#233'rcio atacadista de massas aliment'#237'cias'
        '4637106 - Com'#233'rcio atacadista de sorvetes'
        
          '4637107 - Com'#233'rcio atacadista de chocolates, confeitos, balas, b' +
          'ombons e semelhantes'
        
          '4637199 - Com'#233'rcio atacadista especializado em outros produtos a' +
          'liment'#237'cios n'#227'o especificados anteriormente'
        '4639701 - Com'#233'rcio atacadista de produtos aliment'#237'cios em geral'
        
          '4639702 - Com'#233'rcio atacadista de produtos aliment'#237'cios em geral,' +
          ' com atividade de fracionamento e acondicionamento associada'
        '4641901 - Com'#233'rcio atacadista de tecidos'
        '4641902 - Com'#233'rcio atacadista de artigos de cama, mesa e banho'
        '4641903 - Com'#233'rcio atacadista de artigos de armarinho'
        
          '4642701 - Com'#233'rcio atacadista de artigos do vestu'#225'rio e acess'#243'ri' +
          'os, exceto profissionais e de seguran'#231'a'
        
          '4642702 - Com'#233'rcio atacadista de roupas e acess'#243'rios para uso pr' +
          'ofissional e de seguran'#231'a do trabalho'
        '4643501 - Com'#233'rcio atacadista de cal'#231'ados'
        
          '4643502 - Com'#233'rcio atacadista de bolsas, malas e artigos de viag' +
          'em'
        
          '4644301 - Com'#233'rcio atacadista de medicamentos e drogas de uso hu' +
          'mano'
        
          '4644302 - Com'#233'rcio atacadista de medicamentos e drogas de uso ve' +
          'terin'#225'rio'
        
          '4645101 - Com'#233'rcio atacadista de instrumentos e materiais para u' +
          'so m'#233'dico, cir'#250'rgico, hospitalar e de laborat'#243'rios'
        '4645102 - Com'#233'rcio atacadista de pr'#243'teses e artigos de ortopedia'
        '4645103 - Com'#233'rcio atacadista de produtos odontol'#243'gicos'
        
          '4646001 - Com'#233'rcio atacadista de cosm'#233'ticos e produtos de perfum' +
          'aria'
        '4646002 - Com'#233'rcio atacadista de produtos de higiene pessoal'
        
          '4647801 - Com'#233'rcio atacadista de artigos de escrit'#243'rio e de pape' +
          'laria'
        
          '4647802 - Com'#233'rcio atacadista de livros, jornais e outras public' +
          'a'#231#245'es'
        
          '4649401 - Com'#233'rcio atacadista de equipamentos el'#233'tricos de uso p' +
          'essoal e dom'#233'stico'
        
          '4649402 - Com'#233'rcio atacadista de aparelhos eletr'#244'nicos de uso pe' +
          'ssoal e dom'#233'stico'
        
          '4649403 - Com'#233'rcio atacadista de bicicletas, triciclos e outros ' +
          've'#237'culos recreativos'
        '4649404 - Com'#233'rcio atacadista de m'#243'veis e artigos de colchoaria'
        
          '4649405 - Com'#233'rcio atacadista de artigos de tape'#231'aria; persianas' +
          ' e cortinas'
        '4649406 - Com'#233'rcio atacadista de lustres, lumin'#225'rias e abajures'
        
          '4649407 - Com'#233'rcio atacadista de filmes, CDs, DVDs, fitas e disc' +
          'os'
        
          '4649408 - Com'#233'rcio atacadista de produtos de higiene, limpeza e ' +
          'conserva'#231#227'o domiciliar'
        
          '4649409 - Com'#233'rcio atacadista de produtos de higiene, limpeza e ' +
          'conserva'#231#227'o domiciliar, com atividade de fracionamento e acondic' +
          'ionamento associada'
        
          '4649410 - Com'#233'rcio atacadista de j'#243'ias, rel'#243'gios e bijuterias, i' +
          'nclusive pedras preciosas e semipreciosas lapidadas'
        
          '4649499 - Com'#233'rcio atacadista de outros equipamentos e artigos d' +
          'e uso pessoal e dom'#233'stico n'#227'o especificados anteriormente'
        '4651601 - Com'#233'rcio atacadista de equipamentos de inform'#225'tica'
        '4651602 - Com'#233'rcio atacadista de suprimentos para inform'#225'tica'
        
          '4652400 - Com'#233'rcio atacadista de componentes eletr'#244'nicos e equip' +
          'amentos de telefonia e comunica'#231#227'o'
        
          '4661300 - Com'#233'rcio atacadista de m'#225'quinas, aparelhos e equipamen' +
          'tos para uso agropecu'#225'rio; partes e pe'#231'as'
        
          '4662100 - Com'#233'rcio atacadista de m'#225'quinas, equipamentos para ter' +
          'raplenagem, minera'#231#227'o e constru'#231#227'o; partes e pe'#231'as'
        
          '4663000 - Com'#233'rcio atacadista de m'#225'quinas e equipamentos para us' +
          'o industrial; partes e pe'#231'as'
        
          '4664800 - Com'#233'rcio atacadista de m'#225'quinas, aparelhos e equipamen' +
          'tos para uso odontom'#233'dicohospitalar; partes e pe'#231'as'
        
          '4665600 - Com'#233'rcio atacadista de m'#225'quinas e equipamentos para us' +
          'o comercial; partes e pe'#231'as'
        
          '4669901 - Com'#233'rcio atacadista de bombas e compressores; partes e' +
          ' pe'#231'as'
        
          '4669999 - Com'#233'rcio atacadista de outras m'#225'quinas e equipamentos ' +
          'n'#227'o especificados anteriormente; partes e pe'#231'as'
        '4671100 - Com'#233'rcio atacadista de madeira e produtos derivados'
        '4672900 - Com'#233'rcio atacadista de ferragens e ferramentas'
        '4673700 - Com'#233'rcio atacadista de material el'#233'trico'
        '4674500 - Com'#233'rcio atacadista de cimento'
        '4679601 - Com'#233'rcio atacadista de tintas, vernizes e similares'
        '4679602 - Com'#233'rcio atacadista de m'#225'rmores e granitos'
        '4679603 - Com'#233'rcio atacadista de vidros, espelhos e vitrais'
        
          '4679604 - Com'#233'rcio atacadista especializado de materiais de cons' +
          'tru'#231#227'o n'#227'o especificados anteriormente'
        
          '4679699 - Com'#233'rcio atacadista de materiais de constru'#231#227'o em gera' +
          'l'
        
          '4681801 - Com'#233'rcio atacadista de '#225'lcool carburante, biodiesel, g' +
          'asolina e demais derivados de petr'#243'leo, exceto lubrificantes, n'#227 +
          'o realizado por transportador retalhista (TRR)'
        
          '4681802 - Com'#233'rcio atacadista de combust'#237'veis realizado por tran' +
          'sportador retalhista (TRR)'
        
          '4681803 - Com'#233'rcio atacadista de combust'#237'veis de origem vegetal,' +
          ' exceto '#225'lcool carburante'
        
          '4681804 - Com'#233'rcio atacadista de combust'#237'veis de origem mineral ' +
          'em bruto'
        '4681805 - Com'#233'rcio atacadista de lubrificantes'
        
          '4682600 - Com'#233'rcio atacadista de g'#225's liq'#252'efeito de petr'#243'leo (GLP' +
          ')'
        
          '4683400 - Com'#233'rcio atacadista de defensivos agr'#237'colas, adubos, f' +
          'ertilizantes e corretivos do solo'
        '4684201 - Com'#233'rcio atacadista de resinas e elast'#244'meros'
        '4684202 - Com'#233'rcio atacadista de solventes'
        
          '4684299 - Com'#233'rcio atacadista de outros produtos qu'#237'micos e petr' +
          'oqu'#237'micos n'#227'o especificados anteriormente'
        
          '4685100 - Com'#233'rcio atacadista de produtos sider'#250'rgicos e metal'#250'r' +
          'gicos, exceto para constru'#231#227'o'
        '4686901 - Com'#233'rcio atacadista de papel e papel'#227'o em bruto'
        '4686902 - Com'#233'rcio atacadista de embalagens'
        '4687701 - Com'#233'rcio atacadista de res'#237'duos de papel e papel'#227'o'
        
          '4687702 - Com'#233'rcio atacadista de res'#237'duos e sucatas n'#227'omet'#225'licos' +
          ', exceto de papel e papel'#227'o'
        '4687703 - Com'#233'rcio atacadista de res'#237'duos e sucatas met'#225'licos'
        
          '4689301 - Com'#233'rcio atacadista de produtos da extra'#231#227'o mineral, e' +
          'xceto combust'#237'veis'
        
          '4689302 - Com'#233'rcio atacadista de fios e fibras t'#234'xteis beneficia' +
          'dos'
        
          '4689399 - Com'#233'rcio atacadista especializado em outros produtos i' +
          'ntermedi'#225'rios n'#227'o especificados anteriormente'
        
          '4691500 - Com'#233'rcio atacadista de mercadorias em geral, com predo' +
          'min'#226'ncia de produtos aliment'#237'cios'
        
          '4692300 - Com'#233'rcio atacadista de mercadorias em geral, com predo' +
          'min'#226'ncia de insumos agropecu'#225'rios'
        
          '4693100 - Com'#233'rcio atacadista de mercadorias em geral, sem predo' +
          'min'#226'ncia de alimentos ou de insumos agropecu'#225'rios'
        
          '4711301 - Com'#233'rcio varejista de mercadorias em geral, com predom' +
          'in'#226'ncia de produtos aliment'#237'cios  hipermercados'
        
          '4711302 - Com'#233'rcio varejista de mercadorias em geral, com predom' +
          'in'#226'ncia de produtos aliment'#237'cios  supermercados'
        
          '4712100 - Com'#233'rcio varejista de mercadorias em geral, com predom' +
          'in'#226'ncia de produtos aliment'#237'cios  minimercados, mercearias e arm' +
          'az'#233'ns'
        '4713001 - Lojas de departamentos ou magazines'
        
          '4713002 - Lojas de variedades, exceto lojas de departamentos ou ' +
          'magazines'
        '4713003 - Lojas duty free de aeroportos internacionais'
        
          '4721101 - Padaria e confeitaria com predomin'#226'ncia de produ'#231#227'o pr' +
          #243'pria'
        '4721102 - Padaria e confeitaria com predomin'#226'ncia de revenda'
        '4721103 - Com'#233'rcio varejista de latic'#237'nios e frios'
        
          '4721104 - Com'#233'rcio varejista de doces, balas, bombons e semelhan' +
          'tes'
        '4722901 - Com'#233'rcio varejista de carnes  a'#231'ougues'
        '4722902 - Peixaria'
        '4723700 - Com'#233'rcio varejista de bebidas'
        '4724500 - Com'#233'rcio varejista de hortifrutigranjeiros'
        '4729601 - Tabacaria'
        
          '4729699 - Com'#233'rcio varejista de produtos aliment'#237'cios em geral o' +
          'u especializado em produtos aliment'#237'cios n'#227'o especificados anter' +
          'iormente'
        
          '4731800 - Com'#233'rcio varejista de combust'#237'veis para ve'#237'culos autom' +
          'otores'
        '4732600 - Com'#233'rcio varejista de lubrificantes'
        '4741500 - Com'#233'rcio varejista de tintas e materiais para pintura'
        '4742300 - Com'#233'rcio varejista de material el'#233'trico'
        '4743100 - Com'#233'rcio varejista de vidros'
        '4744001 - Com'#233'rcio varejista de ferragens e ferramentas'
        '4744002 - Com'#233'rcio varejista de madeira e artefatos'
        '4744003 - Com'#233'rcio varejista de materiais hidr'#225'ulicos'
        
          '4744004 - Com'#233'rcio varejista de cal, areia, pedra britada, tijol' +
          'os e telhas'
        
          '4744005 - Com'#233'rcio varejista de materiais de constru'#231#227'o n'#227'o espe' +
          'cificados anteriormente'
        '4744099 - Com'#233'rcio varejista de materiais de constru'#231#227'o em geral'
        
          '4751200 - Com'#233'rcio varejista especializado de equipamentos e sup' +
          'rimentos de inform'#225'tica'
        
          '4752100 - Com'#233'rcio varejista especializado de equipamentos de te' +
          'lefonia e comunica'#231#227'o'
        
          '4753900 - Com'#233'rcio varejista especializado de eletrodom'#233'sticos e' +
          ' equipamentos de '#225'udio e v'#237'deo'
        '4754701 - Com'#233'rcio varejista de m'#243'veis'
        '4754702 - Com'#233'rcio varejista de artigos de colchoaria'
        '4754703 - Com'#233'rcio varejista de artigos de ilumina'#231#227'o'
        '4755501 - Com'#233'rcio varejista de tecidos'
        '4755502 - Comercio varejista de artigos de armarinho'
        '4755503 - Comercio varejista de artigos de cama, mesa e banho'
        
          '4756300 - Com'#233'rcio varejista especializado de instrumentos music' +
          'ais e acess'#243'rios'
        
          '4757100 - Com'#233'rcio varejista especializado de pe'#231'as e acess'#243'rios' +
          ' para aparelhos eletroeletr'#244'nicos para uso dom'#233'stico, exceto inf' +
          'orm'#225'tica e comunica'#231#227'o'
        
          '4759801 - Com'#233'rcio varejista de artigos de tape'#231'aria, cortinas e' +
          ' persianas'
        
          '4759899 - Com'#233'rcio varejista de outros artigos de uso dom'#233'stico ' +
          'n'#227'o especificados anteriormente'
        '4761001 - Com'#233'rcio varejista de livros'
        '4761002 - Com'#233'rcio varejista de jornais e revistas'
        '4761003 - Com'#233'rcio varejista de artigos de papelaria'
        '4762800 - Com'#233'rcio varejista de discos, CDs, DVDs e fitas'
        '4763601 - Com'#233'rcio varejista de brinquedos e artigos recreativos'
        '4763602 - Com'#233'rcio varejista de artigos esportivos'
        
          '4763603 - Com'#233'rcio varejista de bicicletas e triciclos; pe'#231'as e ' +
          'acess'#243'rios'
        '4763604 - Com'#233'rcio varejista de artigos de ca'#231'a, pesca e camping'
        
          '4763605 - Com'#233'rcio varejista de embarca'#231#245'es e outros ve'#237'culos re' +
          'creativos; pe'#231'as e acess'#243'rios'
        
          '4771701 - Com'#233'rcio varejista de produtos farmac'#234'uticos, sem mani' +
          'pula'#231#227'o de f'#243'rmulas'
        
          '4771702 - Com'#233'rcio varejista de produtos farmac'#234'uticos, com mani' +
          'pula'#231#227'o de f'#243'rmulas'
        
          '4771703 - Com'#233'rcio varejista de produtos farmac'#234'uticos homeop'#225'ti' +
          'cos'
        '4771704 - Com'#233'rcio varejista de medicamentos veterin'#225'rios'
        
          '4772500 - Com'#233'rcio varejista de cosm'#233'ticos, produtos de perfumar' +
          'ia e de higiene pessoal'
        '4773300 - Com'#233'rcio varejista de artigos m'#233'dicos e ortop'#233'dicos'
        '4774100 - Com'#233'rcio varejista de artigos de '#243'ptica'
        
          '4781400 - Com'#233'rcio varejista de artigos do vestu'#225'rio e acess'#243'rio' +
          's'
        '4782201 - Com'#233'rcio varejista de cal'#231'ados'
        '4782202 - Com'#233'rcio varejista de artigos de viagem'
        '4783101 - Com'#233'rcio varejista de artigos de joalheria'
        '4783102 - Com'#233'rcio varejista de artigos de relojoaria'
        '4784900 - Com'#233'rcio varejista de g'#225's liq'#252'efeito de petr'#243'leo (GLP)'
        '4785701 - Com'#233'rcio varejista de antig'#252'idades'
        '4785799 - Com'#233'rcio varejista de outros artigos usados'
        
          '4789001 - Com'#233'rcio varejista de suvenires, bijuterias e artesana' +
          'tos'
        '4789002 - Com'#233'rcio varejista de plantas e flores naturais'
        '4789003 - Com'#233'rcio varejista de objetos de arte'
        
          '4789004 - Com'#233'rcio varejista de animais vivos e de artigos e ali' +
          'mentos para animais de estima'#231#227'o'
        
          '4789005 - Com'#233'rcio varejista de produtos saneantes domissanit'#225'ri' +
          'os'
        
          '4789006 - Com'#233'rcio varejista de fogos de artif'#237'cio e artigos pir' +
          'ot'#233'cnicos'
        '4789007 - Com'#233'rcio varejista de equipamentos para escrit'#243'rio'
        
          '4789008 - Com'#233'rcio varejista de artigos fotogr'#225'ficos e para film' +
          'agem'
        '4789009 - Com'#233'rcio varejista de armas e muni'#231#245'es'
        
          '4789099 - Com'#233'rcio varejista de outros produtos n'#227'o especificado' +
          's anteriormente'
        '4911600 - Transporte ferrovi'#225'rio de carga'
        
          '4912401 - Transporte ferrovi'#225'rio de passageiros intermunicipal e' +
          ' interestadual'
        
          '4912402 - Transporte ferrovi'#225'rio de passageiros municipal e em r' +
          'egi'#227'o metropolitana'
        '4912403 - Transporte metrovi'#225'rio'
        
          '4921301 - Transporte rodovi'#225'rio coletivo de passageiros, com iti' +
          'ner'#225'rio fixo, municipal'
        
          '4921302 - Transporte rodovi'#225'rio coletivo de passageiros, com iti' +
          'ner'#225'rio fixo, intermunicipal em regi'#227'o metropolitana'
        
          '4922101 - Transporte rodovi'#225'rio coletivo de passageiros, com iti' +
          'ner'#225'rio fixo, intermunicipal, exceto em regi'#227'o metropolitana'
        
          '4922102 - Transporte rodovi'#225'rio coletivo de passageiros, com iti' +
          'ner'#225'rio fixo, interestadual'
        
          '4922103 - Transporte rodovi'#225'rio coletivo de passageiros, com iti' +
          'ner'#225'rio fixo, internacional'
        '4923001 - Servi'#231'o de t'#225'xi'
        
          '4923002 - Servi'#231'o de transporte de passageiros  loca'#231#227'o de autom' +
          #243'veis com motorista'
        '4924800 - Transporte escolar'
        
          '4929901 - Transporte rodovi'#225'rio coletivo de passageiros, sob reg' +
          'ime de fretamento, municipal'
        
          '4929902 - Transporte rodovi'#225'rio coletivo de passageiros, sob reg' +
          'ime de fretamento, intermunicipal, interestadual e internacional'
        
          '4929903 - Organiza'#231#227'o de excurs'#245'es em ve'#237'culos rodovi'#225'rios pr'#243'pr' +
          'ios, municipal'
        
          '4929904 - Organiza'#231#227'o de excurs'#245'es em ve'#237'culos rodovi'#225'rios pr'#243'pr' +
          'ios, intermunicipal, interestadual e internacional'
        
          '4929999 - Outros transportes rodovi'#225'rios de passageiros n'#227'o espe' +
          'cificados anteriormente'
        
          '4930201 - Transporte rodovi'#225'rio de carga, exceto produtos perigo' +
          'sos e mudan'#231'as, municipal'
        
          '4930202 - Transporte rodovi'#225'rio de carga, exceto produtos perigo' +
          'sos e mudan'#231'as, intermunicipal, interestadual e internacional'
        '4930203 - Transporte rodovi'#225'rio de produtos perigosos'
        '4930204 - Transporte rodovi'#225'rio de mudan'#231'as'
        '4940000 - Transporte dutovi'#225'rio'
        '4950700 - Trens tur'#237'sticos, telef'#233'ricos e similares'
        '5011401 - Transporte mar'#237'timo de cabotagem  Carga'
        '5011402 - Transporte mar'#237'timo de cabotagem  passageiros'
        '5012201 - Transporte mar'#237'timo de longo curso  Carga'
        '5012202 - Transporte mar'#237'timo de longo curso  Passageiros'
        
          '5021101 - Transporte por navega'#231#227'o interior de carga, municipal,' +
          ' exceto travessia'
        
          '5021102 - Transporte por navega'#231#227'o interior de carga, intermunic' +
          'ipal, interestadual e internacional, exceto travessia'
        
          '5022001 - Transporte por navega'#231#227'o interior de passageiros em li' +
          'nhas regulares, municipal, exceto travessia'
        
          '5022002 - Transporte por navega'#231#227'o interior de passageiros em li' +
          'nhas regulares, intermunicipal, interestadual e internacional, e' +
          'xceto travessia'
        '5030101 - Navega'#231#227'o de apoio mar'#237'timo'
        '5030102 - Navega'#231#227'o de apoio portu'#225'rio'
        '5091201 - Transporte por navega'#231#227'o de travessia, municipal'
        '5091202 - Transporte por navega'#231#227'o de travessia, intermunicipal'
        '5099801 - Transporte aquavi'#225'rio para passeios tur'#237'sticos'
        
          '5099899 - Outros transportes aquavi'#225'rios n'#227'o especificados anter' +
          'iormente'
        '5111100 - Transporte a'#233'reo de passageiros regular'
        
          '5112901 - Servi'#231'o de t'#225'xi a'#233'reo e loca'#231#227'o de aeronaves com tripu' +
          'la'#231#227'o'
        
          '5112999 - Outros servi'#231'os de transporte a'#233'reo de passageiros n'#227'o' +
          'regular'
        '5120000 - Transporte a'#233'reo de carga'
        '5130700 - Transporte espacial'
        '5211701 - Armaz'#233'ns gerais  emiss'#227'o de warrant'
        '5211702 - Guardam'#243'veis'
        
          '5211799 - Dep'#243'sitos de mercadorias para terceiros, exceto armaz'#233 +
          'ns gerais e guardam'#243'veis'
        '5212500 - Carga e descarga'
        
          '5221400 - Concession'#225'rias de rodovias, pontes, t'#250'neis e servi'#231'os' +
          ' relacionados'
        '5222200 - Terminais rodovi'#225'rios e ferrovi'#225'rios'
        '5223100 - Estacionamento de ve'#237'culos'
        
          '5229001 - Servi'#231'os de apoio ao transporte por t'#225'xi, inclusive ce' +
          'ntrais de chamada'
        '5229002 - Servi'#231'os de reboque de ve'#237'culos'
        
          '5229099 - Outras atividades auxiliares dos transportes terrestre' +
          's n'#227'o especificadas anteriormente'
        '5231101 - Administra'#231#227'o da infraestrutura portu'#225'ria'
        '5231102 - Opera'#231#245'es de terminais'
        '5232000 - Atividades de agenciamento mar'#237'timo'
        
          '5239700 - Atividades auxiliares dos transportes aquavi'#225'rios n'#227'o ' +
          'especificadas anteriormente'
        '5240101 - Opera'#231#227'o dos aeroportos e campos de aterrissagem'
        
          '5240199 - Atividades auxiliares dos transportes a'#233'reos, exceto o' +
          'pera'#231#227'o dos aeroportos e campos de aterrissagem'
        '5250801 - Comissaria de despachos'
        '5250802 - Atividades de despachantes aduaneiros'
        
          '5250803 - Agenciamento de cargas, exceto para o transporte mar'#237't' +
          'imo'
        '5250804 - Organiza'#231#227'o log'#237'stica do transporte de carga'
        '5250805 - Operador de transporte multimodal  OTM'
        '5310501 - Atividades do Correio Nacional'
        
          '5310502 - Atividades de franqueadas e permission'#225'rias do Correio' +
          ' Nacional'
        
          '5320201 - Servi'#231'os de malote n'#227'o realizados pelo Correio Naciona' +
          'l'
        '5320202 - Servi'#231'os de entrega r'#225'pida'
        '5510801 - Hot'#233'is'
        '5510802 - Aparthot'#233'is'
        '5510803 - Mot'#233'is'
        '5590601 - Albergues, exceto assistenciais'
        '5590602 - Campings'
        '5590603 - Pens'#245'es (alojamento)'
        '5590699 - Outros alojamentos n'#227'o especificados anteriormente'
        '5611201 - Restaurantes e similares'
        
          '5611202 - Bares e outros estabelecimentos especializados em serv' +
          'ir bebidas'
        '5611203 - Lanchonetes, casas de ch'#225', de sucos e similares'
        '5612100 - Servi'#231'os ambulantes de alimenta'#231#227'o'
        
          '5620101 - Fornecimento de alimentos preparados preponderantement' +
          'e para empresas'
        '5620102 - Servi'#231'os de alimenta'#231#227'o para eventos e recep'#231#245'es  buf'#234
        '5620103 - Cantinas  servi'#231'os de alimenta'#231#227'o privativos'
        
          '5620104 - Fornecimento de alimentos preparados preponderantement' +
          'e para consumo domiciliar'
        '5811500 - Edi'#231#227'o de livros'
        '5812300 - Edi'#231#227'o de jornais'
        '5813100 - Edi'#231#227'o de revistas'
        '5819100 - Edi'#231#227'o de cadastros, listas e outros produtos gr'#225'ficos'
        '5821200 - Edi'#231#227'o integrada '#224' impress'#227'o de livros'
        '5822100 - Edi'#231#227'o integrada '#224' impress'#227'o de jornais'
        '5823900 - Edi'#231#227'o integrada '#224' impress'#227'o de revistas'
        
          '5829800 - Edi'#231#227'o integrada '#224' impress'#227'o de cadastros, listas e ou' +
          'tros produtos gr'#225'ficos'
        '5911101 - Est'#250'dios cinematogr'#225'ficos'
        '5911102 - Produ'#231#227'o de filmes para publicidade'
        
          '5911199 - Atividades de produ'#231#227'o cinematogr'#225'fica, de v'#237'deos e de' +
          ' programas de televis'#227'o n'#227'o especificadas anteriormente'
        '5912001 - Servi'#231'os de dublagem'
        '5912002 - Servi'#231'os de mixagem sonora em produ'#231#227'o audiovisual'
        
          '5912099 - Atividades de p'#243'sprodu'#231#227'o cinematogr'#225'fica, de v'#237'deos e' +
          ' de programas de televis'#227'o n'#227'o especificadas anteriormente'
        
          '5913800 - Distribui'#231#227'o cinematogr'#225'fica, de v'#237'deo e de programas ' +
          'de televis'#227'o'
        '5914600 - Atividades de exibi'#231#227'o cinematogr'#225'fica'
        '5920100 - Atividades de grava'#231#227'o de som e de edi'#231#227'o de m'#250'sica'
        '6010100 - Atividades de r'#225'dio'
        '6021700 - Atividades de televis'#227'o aberta'
        '6022501 - Programadoras'
        
          '6022502 - Atividades relacionadas '#224' televis'#227'o por assinatura, ex' +
          'ceto programadoras'
        '6110801 - Servi'#231'os de telefonia fixa comutada  STFC'
        
          '6110802 - Servi'#231'os de redes de transporte de telecomunica'#231#245'es  S' +
          'RTT'
        '6110803 - Servi'#231'os de comunica'#231#227'o multim'#237'dia  SCM'
        
          '6110899 - Servi'#231'os de telecomunica'#231#245'es por fio n'#227'o especificados' +
          ' anteriormente'
        '6120501 - Telefonia m'#243'vel celular'
        '6120502 - Servi'#231'o m'#243'vel especializado  SME'
        
          '6120599 - Servi'#231'os de telecomunica'#231#245'es sem fio n'#227'o especificados' +
          ' anteriormente'
        '6130200 - Telecomunica'#231#245'es por sat'#233'lite'
        '6141800 - Operadoras de televis'#227'o por assinatura por cabo'
        '6142600 - Operadoras de televis'#227'o por assinatura por microondas'
        '6143400 - Operadoras de televis'#227'o por assinatura por sat'#233'lite'
        '6190601 - Provedores de acesso '#224's redes de comunica'#231#245'es'
        '6190602 - Provedores de voz sobre protocolo internet  VOIP'
        
          '6190699 - Outras atividades de telecomunica'#231#245'es n'#227'o especificada' +
          's anteriormente'
        
          '6201500 - Desenvolvimento de programas de computador sob encomen' +
          'da'
        
          '6202300 - Desenvolvimento e licenciamento de programas de comput' +
          'ador customiz'#225'veis'
        
          '6203100 - Desenvolvimento e licenciamento de programas de comput' +
          'ador n'#227'ocustomiz'#225'veis'
        '6204000 - Consultoria em tecnologia da informa'#231#227'o'
        
          '6209100 - Suporte t'#233'cnico, manuten'#231#227'o e outros servi'#231'os em tecno' +
          'logia da informa'#231#227'o'
        
          '6311900 - Tratamento de dados, provedores de servi'#231'os de aplica'#231 +
          #227'o e servi'#231'os de hospedagem na internet'
        
          '6319400 - Portais, provedores de conte'#250'do e outros servi'#231'os de i' +
          'nforma'#231#227'o na internet'
        '6391700 - Ag'#234'ncias de not'#237'cias'
        
          '6399200 - Outras atividades de presta'#231#227'o de servi'#231'os de informa'#231 +
          #227'o n'#227'o especificadas anteriormente'
        '6410700 - Banco Central'#13)
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
    object DBGrid3: TDBGrid
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
      OnDblClick = DBGrid3DblClick
      OnKeyPress = DBGrid3KeyPress
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
end
