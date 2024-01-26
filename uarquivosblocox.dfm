object FArquivosBlocoX: TFArquivosBlocoX
  Left = 313
  Top = 150
  BorderStyle = bsDialog
  ClientHeight = 635
  ClientWidth = 1296
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    1296
    635)
  TextHeight = 13
  object Label5: TLabel
    Left = 8
    Top = 102
    Width = 17
    Height = 13
    Caption = 'Xml'
  end
  object Label2: TLabel
    Left = 8
    Top = 447
    Width = 97
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Mensagem da Sefaz'
    ExplicitTop = 448
  end
  object Label1: TLabel
    Left = 8
    Top = 35
    Width = 84
    Height = 13
    Caption = 'Tipos de arquivos'
  end
  object Label3: TLabel
    Left = 168
    Top = 35
    Width = 42
    Height = 13
    Caption = 'Situa'#231#227'o'
  end
  object Label4: TLabel
    Left = 696
    Top = 35
    Width = 170
    Height = 13
    Caption = 'N'#250'mero de Cred'#234'nciamento do PAF'
  end
  object lbCredenciamentoDesatualizadoXML: TLabel
    Left = 880
    Top = 35
    Width = 240
    Height = 13
    Caption = 'N'#250'mero de Cred'#234'nciamento do PAF Desatualizado'
  end
  object reMensagem: TRichEdit
    Left = 8
    Top = 417
    Width = 1262
    Height = 167
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitTop = 425
    ExplicitWidth = 1264
  end
  object cbTipo: TComboBox
    Left = 8
    Top = 56
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = cbTipoChange
    OnKeyUp = cbTipoKeyUp
    Items.Strings = (
      'Estoque'
      'Redu'#231#227'o'
      'Todos')
  end
  object cbSituacao: TComboBox
    Left = 168
    Top = 56
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemIndex = 3
    TabOrder = 2
    Text = 'Todos'
    OnChange = cbSituacaoChange
    OnKeyUp = cbSituacaoKeyUp
    Items.Strings = (
      'Aguardando'
      'Pendente'
      'Sucesso'
      'Todos')
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 120
    Width = 1277
    Height = 312
    Hint = 'Clique com bot'#227'o contr'#225'rio exibe op'#231#245'es'
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DSBLOCOX
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDrawDataCell = DBGrid1DrawDataCell
    OnKeyDown = DBGrid1KeyDown
    OnKeyUp = DBGrid1KeyUp
    Columns = <
      item
        Expanded = False
        FieldName = 'DATAHORA'
        Title.Caption = 'Data gerado'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TIPO'
        Width = 94
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SERIE'
        Title.Caption = 'S'#233'rie ECF'
        Width = 254
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAREFERENCIA'
        Width = 105
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'XMLENVIO'
        Width = 500
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RECIBO'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'XMLRESPOSTA'
        Width = 500
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTADORZ'
        Title.Caption = 'CRZ'
        Visible = True
      end>
  end
  object Edit1: TEdit
    Left = 696
    Top = 56
    Width = 177
    Height = 19
    ReadOnly = True
    TabOrder = 4
  end
  object edCredenciamentoDesatualizadoXML: TEdit
    Left = 880
    Top = 56
    Width = 177
    Height = 19
    ReadOnly = True
    TabOrder = 5
  end
  object chkCrzNaoGerado: TCheckBox
    Left = 776
    Top = 99
    Width = 177
    Height = 17
    Caption = 'Exibir Redu'#231#245'es sem XML'
    TabOrder = 6
    Visible = False
  end
  object edEmitente: TEdit
    Left = 8
    Top = 1
    Width = 1277
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 7
    Text = 'edEmitente'
  end
  object BitBtn1: TBitBtn
    Left = 104
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 8
    Visible = False
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 56
    Width = 153
    Height = 25
    Caption = 'Transmitir pendentes'
    TabOrder = 9
    OnClick = BitBtn2Click
  end
  object btnOmisso: TBitBtn
    Left = 496
    Top = 56
    Width = 153
    Height = 25
    Caption = 'Gerar XML omisso'
    TabOrder = 10
    OnClick = btnOmissoClick
  end
  object DSBLOCOX: TDataSource
    DataSet = IBDSBLOCOX
    Left = 48
    Top = 144
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 256
    Top = 96
    object VisualizarXMLdeEnvio1: TMenuItem
      Caption = 'Visualizar XML Enviado'
      OnClick = VisualizarXMLdeEnvio1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object VisualizarXMLdeRespostadaSEFAZ1: TMenuItem
      Caption = 'Visualizar XML Resposta SEFAZ'
      OnClick = VisualizarXMLdeRespostadaSEFAZ1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object RecriarXMLparaEnvio1: TMenuItem
      Caption = 'Recriar XML para Envio'
      ShortCut = 113
      OnClick = RecriarXMLparaEnvio1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ConsultaRecibo1: TMenuItem
      Caption = 'Consulta Recibo'
      ShortCut = 118
      OnClick = ConsultaRecibo1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Corrigir1: TMenuItem
      Caption = 'Corrigir N'#250'mero de Credenciamento do PAF'
      ShortCut = 114
      OnClick = Corrigir1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object RecuperarRecibodeXMLjenviado1: TMenuItem
      Caption = 'Recuperar Recibo de XML J'#225' Enviado'
      ShortCut = 115
      OnClick = RecuperarRecibodeXMLjenviado1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Gravarnmerodorecibo1: TMenuItem
      Caption = 'Gravar n'#250'mero do recibo'
      ShortCut = 117
      OnClick = Gravarnmerodorecibo1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ShortCut = 116
      OnClick = Refresh1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Reprocessararquivos1: TMenuItem
      Caption = 'Reprocessar arquivos'
      ShortCut = 119
      OnClick = Reprocessararquivos1Click
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object ransmitirpendentes1: TMenuItem
      Caption = 'Transmitir pendentes'
      Hint = 'Corrige erros informados pela SEFAZ antes de transmitir'
      ShortCut = 120
      OnClick = ransmitirpendentes1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Verificarpendncias1: TMenuItem
      Caption = 'Verificar pend'#234'ncias'
      OnClick = Verificarpendncias1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object SomarTag1: TMenuItem
      Caption = 'Somar Tag'
      OnClick = SomarTag1Click
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object GerarXMLRZOmisso1: TMenuItem
      Caption = 'Gerar XML Redu'#231#227'o Z omisso...'
      OnClick = GerarXMLRZOmisso1Click
    end
    object GerarXMLEstoqueomisso1: TMenuItem
      Caption = 'Gerar XML Estoque omisso...'
      OnClick = GerarXMLEstoqueomisso1Click
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object ImportarAC17041: TMenuItem
      Caption = 'Importar AC17/04...'
      Visible = False
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object Anlisedomovimento1: TMenuItem
      Caption = 'An'#225'lise do movimento...'
      Visible = False
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object ConsultaPendnciaUsuriosPAF1: TMenuItem
      Caption = 'Consulta Pend'#234'ncia Usu'#225'rios PAF'
      Visible = False
      OnClick = ConsultaPendnciaUsuriosPAF1Click
    end
  end
  object IBDSBLOCOX: TIBDataSet
    Database = IBDatabase
    Transaction = IBTransaction
    AfterOpen = IBDSBLOCOXAfterOpen
    AfterScroll = IBDSBLOCOXAfterScroll
    BufferChunks = 100
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = False
    Left = 48
    Top = 112
  end
  object IBQREDUCOES: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    BufferChunks = 100
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 128
    Top = 120
  end
  object LbBlowfish1: TLbBlowfish
    CipherMode = cmECB
    Left = 184
    Top = 96
  end
  object IBTransaction: TIBTransaction
    DefaultDatabase = IBDatabase
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 48
    Top = 64
  end
  object PopupMenuOmissos: TPopupMenu
    Left = 536
    Top = 96
    object XMLReduoZ1: TMenuItem
      Caption = 'XML Redu'#231#227'o Z'
      OnClick = GerarXMLRZOmisso1Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object XMLEstoque1: TMenuItem
      Caption = 'XML Estoque'
      OnClick = GerarXMLEstoqueomisso1Click
    end
  end
  object IBDatabase: TIBDatabase
    LoginPrompt = False
    ServerType = 'IBServer'
    AllowStreamedConnected = False
    Left = 16
    Top = 64
  end
end
