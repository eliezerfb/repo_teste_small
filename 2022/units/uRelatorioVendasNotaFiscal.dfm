inherited frmRelVendasNotaFiscal: TfrmRelVendasNotaFiscal
  Caption = 'Relat'#243'rio de vendas (notas fiscais)'
  ClientWidth = 765
  OldCreateOrder = True
  OnClose = FormClose
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
  object pnlPrincipal: TPanel
    Left = 184
    Top = 16
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 0
      Width = 56
      Height = 13
      Caption = 'Per'#237'odo de:'
    end
    object Label3: TLabel
      Left = 8
      Top = 40
      Width = 19
      Height = 13
      Caption = 'At'#233':'
    end
    object dtInicial: TDateTimePicker
      Left = 8
      Top = 14
      Width = 225
      Height = 21
      Date = 35796.376154398100000000
      Time = 35796.376154398100000000
      DateFormat = dfLong
      TabOrder = 0
    end
    object dtFinal: TDateTimePicker
      Left = 8
      Top = 54
      Width = 225
      Height = 21
      Date = 35796.376154398100000000
      Time = 35796.376154398100000000
      DateFormat = dfLong
      TabOrder = 1
    end
    object rbRelatorioICMS: TRadioButton
      Left = 8
      Top = 81
      Width = 185
      Height = 17
      Caption = 'Relat'#243'rio de ICMS'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = rbRelatorioICMSClick
    end
    object rbItemPorITem: TRadioButton
      Left = 8
      Top = 101
      Width = 185
      Height = 17
      Caption = 'Item por item'
      TabOrder = 3
      TabStop = True
      OnClick = rbItemPorITemClick
    end
    object cbListarCodigos: TCheckBox
      Left = 25
      Top = 120
      Width = 97
      Height = 17
      Caption = 'Listar c'#243'digos'
      Enabled = False
      TabOrder = 4
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
    TabOrder = 1
    Visible = False
    object Label8: TLabel
      Left = 8
      Top = 0
      Width = 169
      Height = 13
      Caption = 'Selecione abaixo as opera'#231#245'es que'
    end
    object Label9: TLabel
      Left = 8
      Top = 16
      Width = 182
      Height = 13
      Caption = 'devem ser listadas (relat'#243'rio de Notas).'
    end
    object chkOperacoes: TCheckListBox
      Left = 11
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
      Left = 11
      Top = 158
      Width = 94
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
      Left = 110
      Top = 158
      Width = 94
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
end
