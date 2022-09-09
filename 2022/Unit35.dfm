object Form35: TForm35
  Left = 389
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configura'#231#245'es de etiquetas'
  ClientHeight = 441
  ClientWidth = 504
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 20
    Top = 20
    Width = 38
    Height = 13
    Caption = 'Modelo:'
  end
  object Label21: TLabel
    Left = 350
    Top = 20
    Width = 68
    Height = 13
    Caption = 'Impress'#227'o em:'
  end
  object Button5: TButton
    Left = 260
    Top = 400
    Width = 100
    Height = 25
    Hint = 'Permite salvar um novo modelo de etiquetas'
    Caption = 'Nova etiqueta'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 390
    Top = 400
    Width = 100
    Height = 25
    Hint = 'Confirma as configura'#231#245'es'
    Caption = 'OK'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = Button6Click
  end
  object GroupBox2: TGroupBox
    Left = 260
    Top = 70
    Width = 230
    Height = 85
    Caption = 'Op'#231#245'es de impress'#227'o'
    TabOrder = 2
    object RadioButton1: TRadioButton
      Left = 8
      Top = 20
      Width = 145
      Height = 17
      Caption = 'Imprimir nome do campo'
      TabOrder = 0
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Imprimir mala direta'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 60
      Width = 137
      Height = 17
      Caption = 'Imprimir apenas os dados'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = RadioButton3Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 260
    Top = 280
    Width = 230
    Height = 105
    Caption = 'Impress'#227'o de c'#243'digo de barras'
    TabOrder = 3
    object CheckBox4: TCheckBox
      Left = 8
      Top = 20
      Width = 160
      Height = 17
      Caption = 'Etiquetas de c'#243'digo de barras'
      TabOrder = 0
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 20
      Top = 40
      Width = 150
      Height = 17
      Caption = 'Com nome do produto'
      Enabled = False
      TabOrder = 1
    end
    object CheckBox6: TCheckBox
      Left = 20
      Top = 60
      Width = 150
      Height = 17
      Caption = 'Com pre'#231'o'
      Enabled = False
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 20
    Top = 280
    Width = 230
    Height = 105
    Caption = 'Coment'#225'rio'
    TabOrder = 4
    object Label19: TLabel
      Left = 8
      Top = 40
      Width = 55
      Height = 13
      Caption = 'Mensagem:'
    end
    object Edit2: TEdit
      Left = 8
      Top = 60
      Width = 210
      Height = 19
      Ctl3D = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Text = 'SMALLSOFT INFORMATICA LTDA'
      OnExit = Edit2Exit
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 20
      Width = 161
      Height = 17
      Caption = 'Imprimir coment'#225'rio'
      TabOrder = 0
      OnClick = CheckBox3Click
    end
  end
  object ComboBox1: TComboBox
    Left = 20
    Top = 35
    Width = 320
    Height = 21
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 5
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
    OnKeyDown = ComboBox1KeyDown
    OnKeyPress = ComboBox1KeyPress
  end
  object CheckBox1: TCheckBox
    Left = 20
    Top = 400
    Width = 161
    Height = 17
    Caption = 'Imprimir o N'#186' da p'#225'gina'
    Color = clWhite
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
  end
  object GroupBox5: TGroupBox
    Left = 20
    Top = 70
    Width = 230
    Height = 200
    Caption = 'Tamanho'
    TabOrder = 7
    object Label1: TLabel
      Left = 42
      Top = 20
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = 'largura do papel:'
    end
    object Label10: TLabel
      Left = 180
      Top = 20
      Width = 16
      Height = 13
      Caption = 'mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 48
      Top = 40
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = 'altura do papel:'
    end
    object Label11: TLabel
      Left = 180
      Top = 40
      Width = 16
      Height = 13
      Caption = 'mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 36
      Top = 60
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = 'altura da etiqueta:'
    end
    object Label12: TLabel
      Left = 180
      Top = 60
      Width = 16
      Height = 13
      Caption = 'mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 30
      Top = 80
      Width = 91
      Height = 13
      Alignment = taRightJustify
      Caption = 'largura da etiqueta:'
    end
    object Label13: TLabel
      Left = 180
      Top = 80
      Width = 16
      Height = 13
      Caption = 'mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 41
      Top = 100
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'margem superior:'
    end
    object Label14: TLabel
      Left = 180
      Top = 100
      Width = 16
      Height = 13
      Caption = 'mm'
    end
    object Label5: TLabel
      Left = 34
      Top = 120
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = 'margem esquerda:'
    end
    object Label15: TLabel
      Left = 180
      Top = 120
      Width = 16
      Height = 13
      Caption = 'mm'
    end
    object Label8: TLabel
      Left = 32
      Top = 140
      Width = 89
      Height = 13
      Alignment = taRightJustify
      Caption = 'etiquetas por linha:'
    end
    object Label16: TLabel
      Left = 180
      Top = 140
      Width = 16
      Height = 13
      Caption = 'mm'
    end
    object Label9: TLabel
      Left = 38
      Top = 160
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = 'linhas por p'#225'gina:'
    end
    object Label17: TLabel
      Left = 180
      Top = 160
      Width = 16
      Height = 13
      Caption = 'mm'
    end
    object Edit4: TEdit
      Left = 125
      Top = 20
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 0
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TEdit
      Left = 125
      Top = 40
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 1
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit5KeyPress
    end
    object Edit1: TEdit
      Left = 125
      Top = 60
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 2
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit1KeyPress
    end
    object Edit8: TEdit
      Left = 125
      Top = 80
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 3
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit8KeyPress
    end
    object Edit3: TEdit
      Left = 125
      Top = 100
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 4
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit3KeyPress
    end
    object Edit6: TEdit
      Left = 125
      Top = 120
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 5
      Text = '0'
      OnChange = Edit4Change
      OnKeyPress = Edit6KeyPress
    end
    object Edit7: TEdit
      Left = 125
      Top = 140
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 6
      Text = '0'
      OnChange = Edit9Change
      OnKeyPress = Edit7KeyPress
    end
    object Edit9: TEdit
      Left = 125
      Top = 160
      Width = 50
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 7
      Text = '0'
      OnChange = Edit9Change
      OnKeyPress = Edit9KeyPress
    end
  end
  object GroupBox6: TGroupBox
    Left = 260
    Top = 165
    Width = 230
    Height = 105
    Caption = 'Fontes'
    TabOrder = 8
    object Label18: TLabel
      Left = 18
      Top = 20
      Width = 151
      Height = 13
      Caption = 'tamanho da fonte de impress'#227'o:'
    end
    object Label23: TLabel
      Left = 38
      Top = 45
      Width = 131
      Height = 13
      Caption = 'tamanho da fonte do pre'#231'o:'
    end
    object Label20: TLabel
      Left = 18
      Top = 70
      Width = 151
      Height = 13
      Caption = 'tamanho da fonte de impress'#227'o:'
    end
    object SpinEdit1: TSpinEdit
      Left = 180
      Top = 20
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxValue = 20
      MinValue = 4
      ParentFont = False
      TabOrder = 0
      Value = 7
      OnExit = SpinEdit1Exit
    end
    object SpinEdit3: TSpinEdit
      Left = 180
      Top = 45
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxValue = 50
      MinValue = 4
      ParentFont = False
      TabOrder = 1
      Value = 7
      OnExit = SpinEdit1Exit
    end
    object SpinEdit2: TSpinEdit
      Left = 180
      Top = 70
      Width = 41
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 11
      TabOrder = 2
      Value = 14
      OnExit = SpinEdit2Exit
    end
  end
  object ComboBox2: TComboBox
    Left = 350
    Top = 35
    Width = 140
    Height = 21
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 9
    Text = 'Jato de tinta'
    OnChange = ComboBox2Change
    OnExit = ComboBox2Exit
    OnKeyPress = ComboBox2KeyPress
    Items.Strings = (
      'Jato de tinta'
      'Laser'
      'Matricial')
  end
  object ColorDialog1: TColorDialog
    Left = 200
    Top = 400
  end
end
