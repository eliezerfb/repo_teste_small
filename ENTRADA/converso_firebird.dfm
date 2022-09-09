object Form1: TForm1
  Left = 461
  Top = 243
  AlphaBlendValue = 150
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Assistente de configura'#231#227'o e convers'#227'o'
  ClientHeight = 382
  ClientWidth = 675
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 20
    Top = 149
    Width = 40
    Height = 20
    Caption = 'Teste'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 20
    Top = 209
    Width = 40
    Height = 20
    Caption = 'Teste'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 20
    Top = 99
    Width = 48
    Height = 20
    Caption = 'Label1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label5: TLabel
    Left = 20
    Top = 93
    Width = 48
    Height = 20
    Caption = 'Label1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label8: TLabel
    Left = 20
    Top = 10
    Width = 186
    Height = 29
    Caption = 'CONFIGURE O '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 20
    Top = 200
    Width = 4
    Height = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Gauge1: TGauge
    Left = 20
    Top = 280
    Width = 620
    Height = 26
    ForeColor = 16042061
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
    Visible = False
  end
  object Edit2: TEdit
    Left = 20
    Top = 229
    Width = 640
    Height = 26
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = 'c:\Arquivos de programas\smallsoft\small commerce'
  end
  object Edit1: TEdit
    Left = 20
    Top = 169
    Width = 640
    Height = 26
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = '192.168.254.4'
  end
  object Panel1: TPanel
    Left = 20
    Top = 97
    Width = 657
    Height = 232
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    object Label6: TLabel
      Left = 0
      Top = 0
      Width = 54
      Height = 20
      Caption = 'Label6'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RadioButton1: TRadioButton
      Left = 0
      Top = 62
      Width = 400
      Height = 35
      BiDiMode = bdLeftToRight
      Caption = 'Criar um novo Banco de Dados'
      Checked = True
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 0
      Top = 87
      Width = 497
      Height = 35
      BiDiMode = bdLeftToRight
      Caption = 'Procurar por arquivos XML para criar um Banco de Dados'
      Color = clWhite
      Ctl3D = False
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 0
      Top = 112
      Width = 400
      Height = 35
      BiDiMode = bdLeftToRight
      Caption = 'Criar um Banco de Dados exemplo'
      Color = clWhite
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
    end
  end
  object Button3: TButton
    Left = 360
    Top = 340
    Width = 140
    Height = 30
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button5: TButton
    Left = 190
    Top = 340
    Width = 140
    Height = 30
    Caption = '&Cancelar...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button5Click
  end
  object Table1: TTable
    Left = 360
    Top = 37
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'SMALL.GDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 328
    Top = 37
  end
  object IBTransaction1: TIBTransaction
    Active = False
    DefaultDatabase = IBDatabase1
    AutoStopAction = saNone
    Left = 504
    Top = 37
  end
  object IBTable1: TIBTable
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 432
    Top = 37
  end
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 400
    Top = 37
  end
  object IBQuery2: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 472
    Top = 37
  end
  object IdIPWatch1: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 552
    Top = 37
  end
  object XPManifest1: TXPManifest
    Left = 616
    Top = 40
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 256
    Top = 40
  end
  object XMLDocument1: TXMLDocument
    Left = 208
    Top = 40
    DOMVendorDesc = 'MSXML'
  end
end
