inherited frmRelProdMonofasicoNota: TfrmRelProdMonofasicoNota
  Caption = 'Produtos monof'#225'sicos (NF-e)'
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnCancelar: TBitBtn
    TabOrder = 3
  end
  inherited btnAvancar: TBitBtn
    TabOrder = 2
  end
  inherited btnVoltar: TBitBtn
    TabOrder = 1
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
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 0
    end
    object dtFinal: TDateTimePicker
      Left = 8
      Top = 54
      Width = 225
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 1
    end
  end
end
