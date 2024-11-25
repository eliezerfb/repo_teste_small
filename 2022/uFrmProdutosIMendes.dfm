inherited FrmProdutosIMendes: TFrmProdutosIMendes
  BorderIcons = [biSystemMenu]
  Caption = 'Selecione o produto correspondente'
  ClientHeight = 380
  ClientWidth = 588
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  OnCreate = FormCreate
  ExplicitWidth = 604
  ExplicitHeight = 419
  PixelsPerInch = 96
  TextHeight = 15
  object dbgProdutos: TDBGrid
    Left = 20
    Top = 5
    Width = 548
    Height = 312
    Ctl3D = False
    DataSource = DSProdutos
    DrawingStyle = gdsClassic
    FixedColor = clWindow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgProdutosDrawColumnCell
    OnDblClick = dbgProdutosDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Descricao'
        Width = 527
        Visible = True
      end>
  end
  object btnOk: TBitBtn
    Left = 469
    Top = 336
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnOkClick
  end
  object DSProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 24
    Top = 327
  end
  object cdsProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 327
    object cdsProdutosCodImendes: TIntegerField
      FieldName = 'CodImendes'
    end
    object cdsProdutosDescricao: TStringField
      FieldName = 'Descricao'
      Size = 200
    end
    object cdsProdutosCodEAN: TStringField
      FieldName = 'CodEAN'
    end
    object cdsProdutosCest: TStringField
      FieldName = 'Cest'
    end
  end
end
