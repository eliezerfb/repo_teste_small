object Form16: TForm16
  Left = 200
  Top = 136
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Assistente de filtro'
  ClientHeight = 262
  ClientWidth = 492
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image2: TImage
      Left = 15
      Top = 15
      Width = 70
      Height = 70
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label1: TLabel
      Left = 200
      Top = 15
      Width = 17
      Height = 13
      Caption = 'De:'
    end
    object Label3: TLabel
      Left = 200
      Top = 55
      Width = 19
      Height = 13
      Caption = 'At'#233':'
      Visible = False
    end
    object Label2: TLabel
      Left = 200
      Top = 105
      Width = 61
      Height = 13
      Caption = 'Filtros ativos:'
    end
    object DateTimePicker1: TDateTimePicker
      Left = 200
      Top = 30
      Width = 281
      Height = 21
      BevelInner = bvNone
      BevelOuter = bvNone
      Date = 35803.000000000000000000
      Time = 35803.000000000000000000
      DateFormat = dfLong
      TabOrder = 2
      Visible = False
    end
    object DateTimePicker2: TDateTimePicker
      Left = 200
      Top = 70
      Width = 280
      Height = 21
      BevelInner = bvNone
      BevelOuter = bvNone
      Date = 35803.000000000000000000
      Time = 35803.000000000000000000
      DateFormat = dfLong
      TabOrder = 3
      Visible = False
    end
    object MaskEdit1: TMaskEdit
      Left = 200
      Top = 30
      Width = 90
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = ''
      OnExit = MaskEdit1Exit
      OnKeyPress = MaskEdit1KeyPress
      OnKeyUp = MaskEdit1KeyUp
    end
    object MaskEdit2: TMaskEdit
      Left = 200
      Top = 70
      Width = 90
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = ''
      OnKeyPress = MaskEdit1KeyPress
      OnKeyUp = MaskEdit2KeyUp
    end
    object Button3: TButton
      Left = 10
      Top = 220
      Width = 100
      Height = 23
      Caption = '< Limpar filtros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 145
      Top = 220
      Width = 100
      Height = 23
      Caption = 'Ocultar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button2Click
    end
    object Button2: TButton
      Left = 245
      Top = 220
      Width = 100
      Height = 23
      Caption = 'Listar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 380
      Top = 220
      Width = 100
      Height = 23
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Button1Click
    end
    object ListBox1: TListBox
      Left = 200
      Top = 120
      Width = 281
      Height = 90
      Style = lbOwnerDrawVariable
      ItemHeight = 13
      TabOrder = 8
      OnDrawItem = ListBox1DrawItem
      OnKeyDown = ListBox1KeyDown
    end
  end
end
