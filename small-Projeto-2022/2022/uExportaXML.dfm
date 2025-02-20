object frmExportaXML: TfrmExportaXML
  Left = 1464
  Top = 780
  BorderStyle = bsDialog
  Caption = 'Exportar XML'
  ClientHeight = 285
  ClientWidth = 443
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 15
    Top = 15
    Width = 121
    Height = 97
    AutoSize = True
    Center = True
    Transparent = True
  end
  object Label3: TLabel
    Left = 200
    Top = 60
    Width = 19
    Height = 13
    Caption = 'At'#233':'
  end
  object Label2: TLabel
    Left = 200
    Top = 15
    Width = 56
    Height = 13
    Caption = 'Per'#237'odo de:'
  end
  object Label4: TLabel
    Left = 200
    Top = 177
    Width = 111
    Height = 13
    Caption = 'e-mail da contabilidade:'
  end
  object dtInicial: TDateTimePicker
    Left = 200
    Top = 30
    Width = 225
    Height = 21
    Date = 35796.000000000000000000
    Time = 0.376154398101789400
    DateFormat = dfLong
    TabOrder = 0
  end
  object dtFinal: TDateTimePicker
    Left = 200
    Top = 75
    Width = 225
    Height = 21
    Date = 35796.000000000000000000
    Time = 0.376154398101789400
    DateFormat = dfLong
    TabOrder = 1
  end
  object edtEmailContab: TEdit
    Left = 200
    Top = 192
    Width = 225
    Height = 21
    TabOrder = 5
  end
  object btnAvancar: TButton
    Left = 210
    Top = 242
    Width = 100
    Height = 25
    Caption = '&Avan'#231'ar >'
    TabOrder = 6
    OnClick = btnAvancarClick
  end
  object btnCancelar: TButton
    Left = 320
    Top = 242
    Width = 100
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 7
    OnClick = btnCancelarClick
  end
  object cbNFeSaida: TCheckBox
    Left = 200
    Top = 108
    Width = 112
    Height = 17
    Caption = 'NF-e'#39's de Sa'#237'da'
    TabOrder = 2
  end
  object cbNFeEntrada: TCheckBox
    Left = 200
    Top = 128
    Width = 112
    Height = 17
    Caption = 'NF-e'#39's de Entrada'
    TabOrder = 3
  end
  object cbNFCeSAT: TCheckBox
    Left = 200
    Top = 148
    Width = 112
    Height = 17
    Caption = 'NFC-e/SAT'
    TabOrder = 4
  end
end
