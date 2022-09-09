object Form28: TForm28
  Left = 1464
  Top = 780
  BorderStyle = bsDialog
  Caption = 'Exportar NF-e'#180's '
  ClientHeight = 222
  ClientWidth = 442
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
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
    Top = 105
    Width = 111
    Height = 13
    Caption = 'e-mail da contabilidade:'
  end
  object DateTimePicker1: TDateTimePicker
    Left = 200
    Top = 30
    Width = 225
    Height = 21
    Date = 35796.376154398100000000
    Time = 35796.376154398100000000
    DateFormat = dfLong
    TabOrder = 0
  end
  object DateTimePicker2: TDateTimePicker
    Left = 200
    Top = 75
    Width = 225
    Height = 21
    Date = 35796.376154398100000000
    Time = 35796.376154398100000000
    DateFormat = dfLong
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 200
    Top = 120
    Width = 225
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 210
    Top = 170
    Width = 100
    Height = 25
    Caption = '&Avan'#231'ar >'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 320
    Top = 170
    Width = 100
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 4
    OnClick = Button2Click
  end
end
