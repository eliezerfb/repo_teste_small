object Form32: TForm32
  Left = 294
  Top = 169
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Invent'#225'rio'
  ClientHeight = 384
  ClientWidth = 604
  Color = clWhite
  Constraints.MaxHeight = 423
  Constraints.MaxWidth = 620
  Constraints.MinHeight = 423
  Constraints.MinWidth = 620
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
    Width = 604
    Height = 384
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitLeft = -8
    object Image1: TImage
      Left = 15
      Top = 15
      Width = 148
      Height = 250
      Center = True
      Transparent = True
    end
    object Label4: TLabel
      Left = 180
      Top = 302
      Width = 215
      Height = 13
      Caption = 'Ou clique no bot'#227'o "Imprimir"  para continuar.'
    end
    object Label5: TLabel
      Left = 180
      Top = 15
      Width = 202
      Height = 13
      Caption = 'O invent'#225'rio pode ser calculado pelo custo'
    end
    object Label7: TLabel
      Left = 180
      Top = 30
      Width = 181
      Height = 13
      Caption = 'da '#250'ltima compra ou pelo custo m'#233'dio.'
    end
    object Label8: TLabel
      Left = 180
      Top = 107
      Width = 205
      Height = 13
      Caption = 'O livro de registro de invent'#225'rio '#233' numerado'
    end
    object Label9: TLabel
      Left = 180
      Top = 123
      Width = 209
      Height = 13
      Caption = 'sequencialmente, informe o pr'#243'ximo n'#250'mero:'
    end
    object Label10: TLabel
      Left = 180
      Top = 287
      Width = 221
      Height = 13
      Caption = 'Fale com o seu contador em caso de d'#250'vidas, '
    end
    object Label11: TLabel
      Left = 180
      Top = 181
      Width = 79
      Height = 13
      Caption = 'Referente ao dia'
    end
    object RadioButton1: TRadioButton
      Left = 180
      Top = 53
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
      Top = 71
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
      Top = 142
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
      Left = 381
      Top = 341
      Width = 100
      Height = 24
      Caption = '&Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button2: TButton
      Left = 485
      Top = 341
      Width = 100
      Height = 24
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 277
      Top = 341
      Width = 100
      Height = 24
      Caption = '&Gerar arquivo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 180
      Top = 200
      Width = 212
      Height = 21
      Date = 39448.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 6
    end
    object CheckBox1: TCheckBox
      Left = 180
      Top = 235
      Width = 450
      Height = 17
      Caption = 'Listar quantidade negativa ou zerada'
      TabOrder = 7
    end
    object cbMovGerencial: TCheckBox
      Left = 180
      Top = 254
      Width = 227
      Height = 17
      Caption = 'Considerar movimento gerencial'
      TabOrder = 8
    end
  end
  object IBQuery1: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 56
    Top = 192
  end
  object IBQuery2: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 56
    Top = 232
  end
  object IBQuery3: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 96
    Top = 192
  end
  object IBQuery4: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 96
    Top = 232
  end
  object IBQuery5: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 56
    Top = 272
  end
  object IBQuery6: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 96
    Top = 272
  end
  object qryGerencial: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 136
    Top = 272
  end
end
