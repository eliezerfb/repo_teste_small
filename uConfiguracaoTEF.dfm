object FConfiguracaoTEF: TFConfiguracaoTEF
  Left = 564
  Top = 207
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Configura'#231#227'o TEF'
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitulo: TLabel
    Left = 20
    Top = 12
    Width = 1024
    Height = 19
    AutoSize = False
    Caption = 'Configura'#231#227'o TEF'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 514
    Top = 40
    Width = 97
    Height = 13
    Caption = 'Diret'#243'rio de resposta'
  end
  object Label4: TLabel
    Left = 353
    Top = 40
    Width = 105
    Height = 13
    Caption = 'Diret'#243'rio de requisi'#231#227'o'
  end
  object Label3: TLabel
    Left = 173
    Top = 40
    Width = 27
    Height = 13
    Caption = 'Pasta'
  end
  object Label2: TLabel
    Left = 53
    Top = 40
    Width = 28
    Height = 13
    Caption = 'Nome'
  end
  object Label6: TLabel
    Left = 18
    Top = 40
    Width = 24
    Height = 13
    Caption = 'Ativo'
  end
  object Label8: TLabel
    Left = 674
    Top = 40
    Width = 111
    Height = 13
    Caption = 'Caminho do execut'#225'vel'
  end
  object btnOK: TBitBtn
    Left = 350
    Top = 289
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
    OnClick = btnOKClick
  end
  object dbgTEFs: TDBGrid
    Left = 18
    Top = 58
    Width = 975
    Height = 213
    Ctl3D = False
    DataSource = dsTEFs
    Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgTEFsCellClick
    OnColEnter = dbgTEFsColEnter
    OnDrawColumnCell = dbgTEFsDrawColumnCell
    OnEnter = dbgTEFsEnter
    OnExit = dbgTEFsExit
    OnKeyDown = dbgTEFsKeyDown
    OnKeyUp = dbgTEFsKeyUp
    Columns = <
      item
        Expanded = False
        FieldName = 'ATIVO'
        Title.Caption = 'Ativo'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Caption = 'Adquirente'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PASTA'
        Title.Caption = 'Chave de Requisi'#231#227'o'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DIRETORIOREQ'
        Title.Caption = 'ID do Estabelecimento'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DIRETORIORESP'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CAMINHOEXE'
        Title.Caption = 'Gerenciador TEF'
        Width = 312
        Visible = True
      end>
  end
  object btnCancelar: TBitBtn
    Left = 462
    Top = 289
    Width = 100
    Height = 40
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnCancelarClick
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
    TabOrder = 3
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
  object cdsTEFs: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NOME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'PASTA'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'DIRETORIOREQ'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'DIRETORIORESP'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CAMINHOEXE'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'ATIVO'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'IDNOME'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterInsert = cdsTEFsAfterInsert
    AfterPost = cdsTEFsAfterPost
    OnPostError = cdsTEFsPostError
    Left = 160
    object cdsTEFsNOME: TStringField
      FieldName = 'NOME'
      OnChange = cdsTEFsNOMEChange
      OnSetText = cdsTEFsNOMESetText
      Size = 100
    end
    object cdsTEFsPASTA: TStringField
      FieldName = 'PASTA'
      OnSetText = cdsTEFsPASTASetText
      Size = 500
    end
    object cdsTEFsDIRETORIOREQ: TStringField
      FieldName = 'DIRETORIOREQ'
      OnSetText = cdsTEFsDIRETORIOREQSetText
      Size = 500
    end
    object cdsTEFsDIRETORIORESP: TStringField
      FieldName = 'DIRETORIORESP'
      OnSetText = cdsTEFsDIRETORIORESPSetText
    end
    object cdsTEFsCAMINHOEXE: TStringField
      FieldName = 'CAMINHOEXE'
      OnSetText = cdsTEFsCAMINHOEXESetText
      Size = 500
    end
    object cdsTEFsATIVO: TStringField
      FieldName = 'ATIVO'
      OnSetText = cdsTEFsATIVOSetText
      Size = 3
    end
    object cdsTEFsIDNOME: TStringField
      FieldName = 'IDNOME'
      OnSetText = cdsTEFsIDNOMESetText
      Size = 100
    end
  end
  object dsTEFs: TDataSource
    DataSet = cdsTEFs
    Left = 200
  end
end
