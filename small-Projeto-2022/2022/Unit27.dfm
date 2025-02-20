object Form27: TForm27
  Left = 204
  Top = 591
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Fluxo de caixa'
  ClientHeight = 200
  ClientWidth = 442
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image1: TImage
      Left = 15
      Top = 15
      Width = 121
      Height = 97
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label2: TLabel
      Left = 200
      Top = 15
      Width = 56
      Height = 13
      Caption = 'Per'#237'odo de:'
    end
    object Label3: TLabel
      Left = 200
      Top = 60
      Width = 19
      Height = 13
      Caption = 'At'#233':'
    end
    object DateTimePicker1: TDateTimePicker
      Left = 200
      Top = 30
      Width = 225
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 0
    end
    object DateTimePicker2: TDateTimePicker
      Left = 200
      Top = 75
      Width = 225
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 1
    end
    object Button3: TButton
      Left = 100
      Top = 160
      Width = 100
      Height = 23
      Caption = '< Voltar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 210
      Top = 160
      Width = 100
      Height = 23
      Caption = 'Avan'#231'ar >'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button2: TButton
      Left = 320
      Top = 160
      Width = 100
      Height = 23
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button2Click
    end
  end
end
