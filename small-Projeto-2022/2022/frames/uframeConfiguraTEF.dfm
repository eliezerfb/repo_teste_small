object frameConfiguraTEF: TframeConfiguraTEF
  Left = 0
  Top = 0
  Width = 991
  Height = 298
  TabOrder = 0
  PixelsPerInch = 96
  object Label5: TLabel
    Left = 514
    Top = 2
    Width = 109
    Height = 15
    Caption = 'Diret'#243'rio de resposta'
  end
  object Label4: TLabel
    Left = 353
    Top = 2
    Width = 119
    Height = 15
    Caption = 'Diret'#243'rio de requisi'#231#227'o'
  end
  object Label3: TLabel
    Left = 163
    Top = 2
    Width = 28
    Height = 15
    Caption = 'Pasta'
  end
  object Label2: TLabel
    Left = 43
    Top = 2
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object Label6: TLabel
    Left = 9
    Top = 2
    Width = 28
    Height = 15
    Caption = 'Ativo'
  end
  object Label8: TLabel
    Left = 674
    Top = 2
    Width = 125
    Height = 15
    Caption = 'Caminho do execut'#225'vel'
  end
  object btnOK: TBitBtn
    Left = 390
    Top = 251
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
    Left = 8
    Top = 20
    Width = 975
    Height = 213
    Ctl3D = False
    DataSource = dsTEFs
    DrawingStyle = gdsClassic
    Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
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
    Left = 502
    Top = 251
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
    Left = 198
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
    Left = 238
  end
end
