inherited frmRelVendasPorCliente: TfrmRelVendasPorCliente
  Left = 1435
  Top = 693
  Width = 396
  Height = 247
  Caption = 'Vendas por cliente'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dtInicial: TDateTimePicker [1]
    Left = 142
    Top = 21
    Width = 225
    Height = 21
    Date = 35796.376154398100000000
    Time = 35796.376154398100000000
    DateFormat = dfLong
    TabOrder = 0
  end
  object dtFinal: TDateTimePicker [2]
    Left = 142
    Top = 53
    Width = 225
    Height = 21
    Date = 35796.376154398100000000
    Time = 35796.376154398100000000
    DateFormat = dfLong
    TabOrder = 1
  end
  inherited btnCancelar: TBitBtn
    Left = 269
    Top = 177
    TabOrder = 5
  end
  inherited btnImprimir: TBitBtn
    Left = 144
    Top = 177
    TabOrder = 4
  end
  object cbItemAItem: TCheckBox
    Left = 144
    Top = 142
    Width = 97
    Height = 17
    Caption = 'Item por item'
    TabOrder = 3
  end
  object gbTipoRelatorio: TGroupBox
    Left = 144
    Top = 88
    Width = 225
    Height = 49
    Caption = 'Relatorio'
    TabOrder = 2
    object cbNota: TCheckBox
      Left = 8
      Top = 21
      Width = 97
      Height = 17
      Caption = 'Nota'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbCupom: TCheckBox
      Left = 120
      Top = 21
      Width = 97
      Height = 17
      Caption = 'Cupom'
      TabOrder = 1
    end
  end
end
