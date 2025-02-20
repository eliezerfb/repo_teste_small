object Form32: TForm32
  Left = 294
  Top = 169
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Invent'#225'rio'
  ClientHeight = 280
  ClientWidth = 518
  Color = clWhite
  Constraints.MaxHeight = 319
  Constraints.MaxWidth = 534
  Constraints.MinHeight = 319
  Constraints.MinWidth = 534
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      518
      280)
    object Image1: TImage
      Left = 15
      Top = 15
      Width = 148
      Height = 250
      Center = True
      Transparent = True
    end
    object Label5: TLabel
      Left = 180
      Top = 15
      Width = 285
      Height = 13
      Caption = 'O invent'#225'rio pode ser calculado pelo custo da '#250'ltima compra'
    end
    object Label7: TLabel
      Left = 180
      Top = 30
      Width = 98
      Height = 13
      Caption = 'ou pelo custo m'#233'dio.'
    end
    object Label9: TLabel
      Left = 180
      Top = 93
      Width = 244
      Height = 13
      Caption = 'N'#250'mero sequencial do livro de registro de invent'#225'rio'
    end
    object Label11: TLabel
      Left = 180
      Top = 139
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object RadioButton1: TRadioButton
      Left = 180
      Top = 49
      Width = 150
      Height = 17
      Caption = 'Custo da '#250'ltima compra'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 180
      Top = 68
      Width = 150
      Height = 17
      Caption = 'Custo m'#233'dio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object MaskEdit1: TMaskEdit
      Left = 180
      Top = 110
      Width = 40
      Height = 20
      AutoSize = False
      EditMask = '#####;1; '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 5
      ParentFont = False
      TabOrder = 2
      Text = '1    '
      OnExit = MaskEdit1Exit
    end
    object Button5: TButton
      Left = 295
      Top = 237
      Width = 100
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = '&Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Button5Click
    end
    object Button2: TButton
      Left = 399
      Top = 237
      Width = 100
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 191
      Top = 237
      Width = 100
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = '&Gerar arquivo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = Button1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 180
      Top = 156
      Width = 212
      Height = 21
      Date = 39448.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 180
      Top = 185
      Width = 450
      Height = 17
      Caption = 'Listar quantidade negativa ou zerada'
      TabOrder = 4
    end
    object cbMovGerencial: TCheckBox
      Left = 180
      Top = 204
      Width = 227
      Height = 17
      Caption = 'Considerar movimento gerencial'
      TabOrder = 5
    end
  end
  object IBQuery1: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 32
    Top = 24
  end
  object IBQuery2: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 32
    Top = 64
  end
  object IBQuery3: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 72
    Top = 24
  end
  object IBQuery4: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 72
    Top = 64
  end
  object IBQuery5: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 32
    Top = 104
  end
  object IBQuery6: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 72
    Top = 104
  end
  object qryGerencial: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 112
    Top = 104
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 72
    Top = 176
  end
end
