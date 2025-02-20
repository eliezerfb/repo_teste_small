inherited frmInformarDrawback: TfrmInformarDrawback
  BorderIcons = []
  Caption = 'C'#243'digo Drawback'
  ClientHeight = 616
  ClientWidth = 840
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Microsoft Sans Serif'
  Position = poScreenCenter
  OnClose = FormClose
  ExplicitWidth = 856
  ExplicitHeight = 655
  PixelsPerInch = 96
  TextHeight = 16
  object dbgPrincipal: TDBGrid
    Left = 20
    Top = 20
    Width = 800
    Height = 531
    Anchors = [akLeft, akTop, akRight]
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    DataSource = dsDrawback
    DrawingStyle = gdsClassic
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    OnDrawDataCell = dbgPrincipalDrawDataCell
    OnEnter = dbgPrincipalEnter
    OnKeyDown = dbgPrincipalKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 630
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DRAWBACK'
        Title.Caption = 'C'#243'digo Drawback'
        Width = 150
        Visible = True
      end>
  end
  object btnOK: TBitBtn
    Left = 614
    Top = 571
    Width = 100
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
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
    Left = 720
    Top = 571
    Width = 100
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
  object dsDrawback: TDataSource
    DataSet = cdsDrawback
    Left = 248
    Top = 177
  end
  object cdsDrawback: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CODIGO'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'DESCRICAO'
        DataType = ftString
        Size = 120
      end
      item
        Name = 'DRAWBACK'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'REGISTRO'
        DataType = ftString
        Size = 10
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforeInsert = cdsDrawbackBeforeInsert
    Left = 168
    Top = 176
    object cdsDrawbackCODIGO: TStringField
      FieldName = 'CODIGO'
      ReadOnly = True
      Size = 5
    end
    object cdsDrawbackDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      ReadOnly = True
      Size = 120
    end
    object cdsDrawbackDRAWBACK: TStringField
      FieldName = 'DRAWBACK'
      Size = 11
    end
    object cdsDrawbackREGISTRO: TStringField
      FieldName = 'REGISTRO'
      Visible = False
      Size = 10
    end
  end
end
