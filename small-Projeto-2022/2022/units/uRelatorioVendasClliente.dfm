inherited frmRelVendasPorCliente: TfrmRelVendasPorCliente
  Left = 1435
  Top = 693
  Caption = 'Relat'#243'rio Vendas por cliente'
  ClientWidth = 762
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 778
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnCancelar: TBitBtn
    TabOrder = 4
  end
  inherited btnAvancar: TBitBtn
    TabOrder = 3
  end
  inherited btnVoltar: TBitBtn
    TabOrder = 2
    OnClick = btnVoltarClick
  end
  object pnlSelOperacoes: TPanel
    Left = 496
    Top = 22
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
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
  object pnlPrincipal: TPanel
    Left = 180
    Top = 16
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
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
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dtInicial: TDateTimePicker
      Left = 0
      Top = 15
      Width = 212
      Height = 20
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
      Height = 20
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
    object gbTipoRelatorio: TGroupBox
      Left = 0
      Top = 92
      Width = 237
      Height = 49
      Caption = 'Relat'#243'rio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object cbNota: TCheckBox
        Left = 14
        Top = 21
        Width = 97
        Height = 17
        Caption = 'Nota'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbCupom: TCheckBox
        Left = 127
        Top = 21
        Width = 97
        Height = 17
        Caption = 'Cupom'
        TabOrder = 1
      end
    end
    object cbItemAItem: TCheckBox
      Left = 0
      Top = 147
      Width = 97
      Height = 17
      Caption = 'Item por item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
end
