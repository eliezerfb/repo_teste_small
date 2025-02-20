object Form34: TForm34
  Left = 1443
  Top = 513
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Aumento de pre'#231'o de venda'
  ClientHeight = 262
  ClientWidth = 457
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 457
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image1: TImage
      Left = 20
      Top = 20
      Width = 70
      Height = 70
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label1: TLabel
      Left = 206
      Top = 20
      Width = 101
      Height = 16
      Caption = 'Aumentar  sobre:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 206
      Top = 120
      Width = 99
      Height = 16
      Caption = '% de aumento 1:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 206
      Top = 140
      Width = 99
      Height = 16
      Caption = '% de aumento 2:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object RadioButton1: TRadioButton
      Left = 250
      Top = 54
      Width = 113
      Height = 17
      Caption = 'Pre'#231'o de venda'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 250
      Top = 74
      Width = 153
      Height = 17
      Caption = 'Custo da '#250'ltima compra'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TRadioButton
      Left = 250
      Top = 94
      Width = 153
      Height = 17
      Caption = 'Atualizar pelo US$'
      TabOrder = 2
      OnClick = RadioButton3Click
    end
    object SMALL_DBEdit1: TSMALL_DBEdit
      Left = 310
      Top = 140
      Width = 65
      Height = 19
      DataField = 'ACUMULADO1'
      DataSource = Form7.DataSource25
      TabOrder = 3
      Visible = False
      OnChange = SMALL_DBEdit1Change
      OnKeyPress = SMALL_DBEdit1KeyPress
    end
    object Button5: TButton
      Left = 15
      Top = 220
      Width = 100
      Height = 25
      Caption = '&Sim'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 123
      Top = 220
      Width = 100
      Height = 25
      Caption = '&N'#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 231
      Top = 220
      Width = 100
      Height = 25
      Caption = 'Todos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button4: TButton
      Left = 231
      Top = 220
      Width = 100
      Height = 25
      Caption = 'Aumentar'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Button4Click
    end
    object Button2: TButton
      Left = 340
      Top = 220
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = Button2Click
    end
  end
end
