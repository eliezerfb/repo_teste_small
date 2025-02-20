inherited frmRelResumoVendas: TfrmRelResumoVendas
  Left = 467
  Top = 502
  Caption = 'Resumo das vendas'
  ClientWidth = 769
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 785
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnVoltar: TBitBtn
    OnClick = btnVoltarClick
  end
  object pnlPrincipal: TPanel
    Left = 180
    Top = 15
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 3
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 53
      Height = 13
      Caption = 'Per'#237'odo de'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 0
      Top = 45
      Width = 16
      Height = 13
      Caption = 'At'#233
    end
    object dtInicial: TDateTimePicker
      Left = 0
      Top = 15
      Width = 212
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object dtFinal: TDateTimePicker
      Left = 0
      Top = 60
      Width = 212
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object cbAgruparGrupo: TCheckBox
      Left = 0
      Top = 89
      Width = 193
      Height = 17
      Caption = 'Separado por grupo de mercadoria'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnlSelOperacoes: TPanel
    Left = 496
    Top = 22
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    Visible = False
    object Label8: TLabel
      Left = 0
      Top = 0
      Width = 169
      Height = 13
      Caption = 'Selecione abaixo as opera'#231#245'es que'
    end
    object Label9: TLabel
      Left = 0
      Top = 16
      Width = 182
      Height = 13
      Caption = 'devem ser listadas (relat'#243'rio de Notas).'
    end
    object chkOperacoes: TCheckListBox
      Left = 0
      Top = 49
      Width = 230
      Height = 106
      Hint = 'Opera'#231#245'es que devem ser listadas'
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnMarcarTodosOper: TBitBtn
      Left = 0
      Top = 158
      Width = 100
      Height = 23
      Caption = 'Marcar todas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnMarcarTodosOperClick
    end
    object btnDesmarcarTodosOper: TBitBtn
      Left = 130
      Top = 158
      Width = 100
      Height = 23
      Caption = 'Desmarcar todas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnDesmarcarTodosOperClick
    end
  end
  object cdsExcluidos: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NOME'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'VALOR'
        DataType = ftBCD
        Precision = 18
        Size = 4
      end>
    IndexDefs = <>
    Params = <
      item
        DataType = ftUnknown
        ParamType = ptUnknown
      end>
    StoreDefs = True
    Left = 56
    Top = 192
    object cdsExcluidosNOME: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'NOME'
      Size = 50
    end
    object cdsExcluidosVALOR: TBCDField
      DisplayLabel = 'Total'
      FieldName = 'VALOR'
      Precision = 18
    end
  end
  object cdsTotalGrupo: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Ordem'
        DataType = ftInteger
      end
      item
        Name = 'Grupo'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'Custo compra'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'Vendido por'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'Lucro bruto'
        DataType = ftFMTBcd
        Precision = 18
        Size = 6
      end
      item
        Name = 'Quantidade'
        DataType = ftFMTBcd
        Precision = 32
        Size = 4
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 80
    Top = 128
    object cdsTotalGrupoOrdem: TIntegerField
      FieldName = 'Ordem'
    end
    object cdsTotalGrupoGrupo: TStringField
      FieldName = 'Grupo'
      Size = 80
    end
    object cdsTotalGrupoQuantidade: TFMTBCDField
      FieldName = 'Quantidade'
      Precision = 18
      Size = 2
    end
    object cdsTotalGrupoCustocompra: TFMTBCDField
      FieldName = 'Custo compra'
      Precision = 18
      Size = 6
    end
    object cdsTotalGrupoVendidopor: TFMTBCDField
      FieldName = 'Vendido por'
      Precision = 18
      Size = 6
    end
    object cdsTotalGrupoLucrobruto: TFMTBCDField
      FieldName = 'Lucro bruto'
      Precision = 18
      Size = 6
    end
  end
end
