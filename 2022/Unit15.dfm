object Form15: TForm15
  Left = 355
  Top = 117
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Etiquetas'
  ClientHeight = 534
  ClientWidth = 652
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 20
    Top = 21
    Width = 140
    Height = 104
    AutoSize = True
    Center = True
  end
  object Panel1: TPanel
    Left = 15
    Top = 140
    Width = 355
    Height = 180
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 2
    object Label2: TLabel
      Left = 5
      Top = 0
      Width = 101
      Height = 13
      Caption = 'Modelo das etiquetas'
    end
    object ComboBox1: TComboBox
      Left = 5
      Top = 15
      Width = 350
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = ComboBox1Change
      OnEnter = ComboBox1Enter
      OnKeyPress = ComboBox1KeyPress
    end
    object GroupBox2: TGroupBox
      Left = 185
      Top = 40
      Width = 170
      Height = 90
      Caption = 'Quantidade'
      TabOrder = 2
      object Label3: TLabel
        Left = 70
        Top = 56
        Width = 52
        Height = 13
        Caption = 'etiqueta(s).'
      end
      object RadioButton2: TRadioButton
        Left = 8
        Top = 16
        Width = 129
        Height = 17
        Caption = 'Uma para cada pe'#231'a'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButton1: TRadioButton
        Left = 8
        Top = 32
        Width = 129
        Height = 17
        Caption = '1 para cada item'
        TabOrder = 1
        OnClick = RadioButton1Click
        OnExit = RadioButton1Exit
      end
      object SpinEdit1: TSpinEdit
        Left = 24
        Top = 50
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 1
        TabOrder = 2
        Value = 1
        Visible = False
        OnChange = SpinEdit1Change
        OnExit = SpinEdit1Exit
      end
    end
    object GroupBox1: TGroupBox
      Left = 5
      Top = 40
      Width = 170
      Height = 90
      Caption = 'Etiquetas de'
      TabOrder = 3
      object RadioButton3: TRadioButton
        Left = 8
        Top = 50
        Width = 97
        Height = 17
        Caption = #218'ltimas compras'
        TabOrder = 0
        OnClick = RadioButton5Click
      end
      object RadioButton4: TRadioButton
        Left = 8
        Top = 35
        Width = 121
        Height = 17
        Caption = 'Altera'#231#245'es de pre'#231'o'
        TabOrder = 1
        OnClick = RadioButton5Click
      end
      object RadioButton5: TRadioButton
        Left = 8
        Top = 20
        Width = 113
        Height = 17
        Caption = 'Em estoque'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = RadioButton5Click
      end
      object RadioButton6: TRadioButton
        Left = 8
        Top = 65
        Width = 121
        Height = 17
        Caption = 'Relacionar produtos'
        TabOrder = 3
        OnClick = RadioButton6Click
      end
    end
    object CheckBox2: TCheckBox
      Left = 5
      Top = 135
      Width = 226
      Height = 17
      AllowGrayed = True
      Caption = 'Imprimir etiqueta de mala direta COM o " '#192' "'
      Checked = True
      State = cbChecked
      TabOrder = 4
      Visible = False
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 5
      Top = 155
      Width = 300
      Height = 17
      Caption = 'Seguir a partir do registro atual'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CheckBox1: TCheckBox
      Left = 5
      Top = 135
      Width = 300
      Height = 17
      Caption = 'Etiqueta de c'#243'digo de barras'
      TabOrder = 6
      Visible = False
      OnClick = CheckBox1Click
    end
    object GroupBox3: TGroupBox
      Left = 155
      Top = 40
      Width = 350
      Height = 90
      TabOrder = 1
      object Label7: TLabel
        Left = 130
        Top = 50
        Width = 8
        Height = 16
        Caption = '1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 19
        Top = 50
        Width = 108
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etiqueta(s) por registro:'
      end
      object Label14: TLabel
        Left = 40
        Top = 15
        Width = 87
        Height = 13
        Alignment = taRightJustify
        Caption = 'Iniciar da etiqueta:'
      end
      object Label13: TLabel
        Left = 130
        Top = 15
        Width = 8
        Height = 16
        Caption = '1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ScrollBar1: TScrollBar
        Left = 150
        Top = 45
        Width = 13
        Height = 25
        Ctl3D = False
        Kind = sbVertical
        Min = 1
        PageSize = 0
        ParentCtl3D = False
        Position = 100
        TabOrder = 0
        OnChange = ScrollBar1Change
      end
      object ScrollBar2: TScrollBar
        Left = 150
        Top = 10
        Width = 13
        Height = 25
        Ctl3D = False
        Kind = sbVertical
        Min = 1
        PageSize = 0
        ParentCtl3D = False
        Position = 100
        TabOrder = 1
        OnChange = ScrollBar2Change
      end
    end
  end
  object Panel5: TPanel
    Left = 284
    Top = 483
    Width = 340
    Height = 38
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Button1: TButton
      Left = 10
      Top = 5
      Width = 100
      Height = 25
      Hint = 'Permite configurar a etiqueta'
      Caption = 'Confi&gura'#231#245'es'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button5: TButton
      Left = 120
      Top = 5
      Width = 100
      Height = 25
      Hint = 'Imprime as etiquetas'
      Caption = 'Imprimir'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button5Click
    end
    object Button7: TButton
      Left = 230
      Top = 5
      Width = 100
      Height = 25
      Hint = 'Cancela a impress'#227'o'
      Caption = 'Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button7Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 320
    Width = 617
    Height = 160
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    Visible = False
    object Label8: TLabel
      Left = 20
      Top = 4
      Width = 277
      Height = 13
      Caption = 'Relacione abaixo os produtos desejados para a impress'#227'o:'
    end
    object Label9: TLabel
      Left = 20
      Top = 114
      Width = 66
      Height = 13
      Caption = 'N'#250'mero/S'#233'rie'
    end
    object Label10: TLabel
      Left = 100
      Top = 114
      Width = 100
      Height = 13
      Caption = 'Nome do fornecedor:'
    end
    object DBGrid2: TDBGrid
      Left = 20
      Top = 24
      Width = 515
      Height = 87
      Color = clWhite
      Ctl3D = False
      DataSource = Form7.DataSource40
      FixedColor = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Microsoft Sans Serif'
      TitleFont.Style = [fsBold]
      OnColEnter = DBGrid2ColEnter
      OnDrawDataCell = DBGrid2DrawDataCell
      OnKeyPress = DBGrid2KeyPress
      OnKeyUp = DBGrid2KeyUp
    end
    object Edit1: TEdit
      Left = 20
      Top = 129
      Width = 70
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '000001'
      OnExit = Edit1Exit
      OnKeyPress = Edit1KeyPress
    end
    object ComboBox2: TComboBox
      Left = 100
      Top = 129
      Width = 414
      Height = 21
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 2
      OnKeyPress = ComboBox2KeyPress
    end
    object Button2: TButton
      Left = 528
      Top = 129
      Width = 65
      Height = 25
      Caption = 'Importar >'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object PrintDialog1: TPrintDialog
    Collate = True
    FromPage = 1
    Left = 296
    Top = 72
  end
  object IBDataSet1: TIBDataSet
    BufferChunks = 1000
    CachedUpdates = False
    Left = 264
    Top = 72
  end
end
