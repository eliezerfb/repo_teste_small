object frmExportaXML: TfrmExportaXML
  Left = 1464
  Top = 780
  BorderStyle = bsDialog
  Caption = 'Enviar XML'
  ClientHeight = 280
  ClientWidth = 518
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
    Left = 0
    Top = 15
    Width = 174
    Height = 127
    Align = alCustom
    Center = True
    Transparent = True
  end
  object Label3: TLabel
    Left = 180
    Top = 60
    Width = 16
    Height = 13
    Caption = 'At'#233
  end
  object Label2: TLabel
    Left = 180
    Top = 15
    Width = 53
    Height = 13
    Caption = 'Per'#237'odo de'
  end
  object Label4: TLabel
    Left = 180
    Top = 177
    Width = 111
    Height = 13
    Caption = 'e-mail da contabilidade:'
  end
  object dtInicial: TDateTimePicker
    Left = 180
    Top = 30
    Width = 212
    Height = 20
    Date = 401386.000000000000000000
    Time = 0.376154398079961500
    DateFormat = dfLong
    TabOrder = 0
  end
  object dtFinal: TDateTimePicker
    Left = 180
    Top = 75
    Width = 212
    Height = 20
    Date = 35796.000000000000000000
    Time = 0.376154398101789400
    DateFormat = dfLong
    TabOrder = 1
  end
  object edtEmailContab: TEdit
    Left = 180
    Top = 194
    Width = 319
    Height = 20
    TabOrder = 5
  end
  object btnAvancar: TButton
    Left = 295
    Top = 237
    Width = 100
    Height = 24
    Caption = '&Enviar'
    TabOrder = 6
    OnClick = btnAvancarClick
  end
  object btnCancelar: TButton
    Left = 399
    Top = 237
    Width = 100
    Height = 24
    Caption = '&Cancelar'
    TabOrder = 7
    OnClick = btnCancelarClick
  end
  object cbNFeSaida: TCheckBox
    Left = 180
    Top = 108
    Width = 112
    Height = 17
    Caption = 'NF-e'#39's de Sa'#237'da'
    TabOrder = 2
  end
  object cbNFeEntrada: TCheckBox
    Left = 180
    Top = 128
    Width = 112
    Height = 17
    Caption = 'NF-e'#39's de Entrada'
    TabOrder = 3
  end
  object cbNFCeSAT: TCheckBox
    Left = 180
    Top = 148
    Width = 112
    Height = 17
    Caption = 'NFC-e/SAT'
    TabOrder = 4
  end
end
