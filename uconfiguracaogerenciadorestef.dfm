object FConfiguracaoGerenciadoresTEF: TFConfiguracaoGerenciadoresTEF
  Left = 364
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Adquirentes'
  ClientHeight = 741
  ClientWidth = 1011
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    1011
    741)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 12
    Width = 1024
    Height = 19
    AutoSize = False
    Caption = 'Configura'#231#227'o de TEF'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 579
    Top = 40
    Width = 106
    Height = 13
    Caption = 'N'#250'mero Serial do POS'
  end
  object Label4: TLabel
    Left = 427
    Top = 40
    Width = 107
    Height = 13
    Caption = 'ID do Estabelecimento'
  end
  object Label3: TLabel
    Left = 126
    Top = 40
    Width = 102
    Height = 13
    Caption = 'Chave de Requisi'#231#227'o'
  end
  object Label2: TLabel
    Left = 24
    Top = 40
    Width = 28
    Height = 13
    Caption = 'Nome'
  end
  object Label6: TLabel
    Left = 811
    Top = 40
    Width = 24
    Height = 13
    Caption = 'Ativo'
  end
  object Label7: TLabel
    Left = 871
    Top = 40
    Width = 34
    Height = 13
    Caption = 'Padr'#227'o'
  end
  object Label8: TLabel
    Left = 698
    Top = 40
    Width = 81
    Height = 13
    Caption = 'Gerenciador TEF'
  end
  object lbOrientacao: TLabel
    Left = 22
    Top = 280
    Width = 963
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lbOrientacao'
    Visible = False
    WordWrap = True
  end
  object Button1: TBitBtn
    Left = 350
    Top = 360
    Width = 100
    Height = 40
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 2
    Top = 431
    Width = 1008
    Height = 312
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      inherited PAnel1: TPanel
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object GRIDADQUIRENTES: TDBGrid
    Left = 18
    Top = 58
    Width = 975
    Height = 213
    Ctl3D = False
    DataSource = DSADQUIRENTES
    Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnCellClick = GRIDADQUIRENTESCellClick
    OnColEnter = GRIDADQUIRENTESColEnter
    OnDrawColumnCell = GRIDADQUIRENTESDrawColumnCell
    OnEnter = GRIDADQUIRENTESEnter
    OnExit = GRIDADQUIRENTESExit
    OnKeyDown = GRIDADQUIRENTESKeyDown
    OnKeyUp = GRIDADQUIRENTESKeyUp
    Columns = <
      item
        Expanded = False
        FieldName = 'ADQUIRENTE'
        Title.Caption = 'Adquirente'
        Width = 103
        Visible = True
      end
      item
        Color = clBtnFace
        Expanded = False
        FieldName = 'CHAVEREQUISICAO'
        ReadOnly = True
        Title.Caption = 'Chave de Requisi'#231#227'o'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IDESTABELECIMENTO'
        Title.Caption = 'ID do Estabelecimento'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SERIALPOS'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GERENCIADORTEF'
        Title.Caption = 'Gerenciador TEF'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ATIVO'
        Title.Caption = 'Ativo'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PADRAO'
        Title.Caption = 'Padr'#227'o'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EXCLUIR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Title.Caption = 'Excluir'
        Width = 30
        Visible = True
      end>
  end
  object Button2: TBitBtn
    Left = 462
    Top = 360
    Width = 100
    Height = 40
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object CDSADQUIRENTES: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ADQUIRENTE'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'CHAVEREQUISICAO'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'IDESTABELECIMENTO'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SERIALPOS'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'GERENCIADORTEF'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'ATIVO'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'PADRAO'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'EXCLUIR'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterInsert = CDSADQUIRENTESAfterInsert
    BeforePost = CDSADQUIRENTESBeforePost
    OnPostError = CDSADQUIRENTESPostError
    Left = 160
    object CDSADQUIRENTESADQUIRENTE: TStringField
      DisplayWidth = 21
      FieldName = 'ADQUIRENTE'
      Required = True
      OnSetText = CDSADQUIRENTESADQUIRENTESetText
      Size = 50
    end
    object CDSADQUIRENTESCHAVEREQUISICAO: TStringField
      DisplayWidth = 60
      FieldName = 'CHAVEREQUISICAO'
      Required = True
      Size = 50
    end
    object CDSADQUIRENTESIDESTABELECIMENTO: TStringField
      DisplayWidth = 60
      FieldName = 'IDESTABELECIMENTO'
      Required = True
      Size = 50
    end
    object CDSADQUIRENTESSERIALPOS: TStringField
      DisplayWidth = 60
      FieldName = 'SERIALPOS'
      Required = True
      OnSetText = CDSADQUIRENTESSERIALPOSSetText
      Size = 50
    end
    object CDSADQUIRENTESGERENCIADORTEF: TStringField
      FieldName = 'GERENCIADORTEF'
      Size = 50
    end
    object CDSADQUIRENTESATIVO: TStringField
      FieldName = 'ATIVO'
      Required = True
      OnSetText = CDSADQUIRENTESATIVOSetText
      Size = 3
    end
    object CDSADQUIRENTESPADRAO: TStringField
      FieldName = 'PADRAO'
      Required = True
      OnSetText = CDSADQUIRENTESPADRAOSetText
      Size = 3
    end
    object CDSADQUIRENTESEXCLUIR: TStringField
      Alignment = taCenter
      FieldName = 'EXCLUIR'
      ReadOnly = True
      Size = 1
    end
  end
  object DSADQUIRENTES: TDataSource
    DataSet = CDSADQUIRENTES
    Left = 200
  end
end
