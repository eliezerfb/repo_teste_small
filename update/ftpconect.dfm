object Form1: TForm1
  Left = 306
  Top = 133
  Width = 561
  Height = 468
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'FTP - Conector automatico'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000330077000000000000000000000000003B077070000000000000
    000000000000BB807007000000000000000000000300B0007000700000000000
    00000000330070070700070000000000000000003B0700700070007000000000
    00000000BB800700000700070000000000000300B00070000000700070000000
    0000330070070000000007000700000000003B07007000000000007007000000
    0000BB800700000000000007070000000300B000700000000070000077000000
    330070070000000007000000803300003B070070000000000000000800330000
    BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
    70070000000707000000803300003B070070000000707000000800330000BB80
    07000000070700000080BBBB0000B000700000000070000008000BB000007007
    0000000007000000803300000000707000007770000000080033000000008700
    0007070700000080BBBB00000000080000077777000008000BB0000000000080
    0007070700008033000000000000000800007770000800330000000000000000
    800000000080BBBB00000000000000000800000008000BB00000000000000000
    0080000080330000000000000000000000080008003300000000000000000000
    00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
    33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
    0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
    000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
    0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 553
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 267
    Width = 553
    Height = 155
    Align = alBottom
    TabOrder = 1
    OnClick = Panel2Click
    object Label1: TLabel
      Left = 120
      Top = 56
      Width = 68
      Height = 13
      Caption = 'ID do Usuario:'
    end
    object Label2: TLabel
      Left = 120
      Top = 104
      Width = 34
      Height = 13
      Caption = 'Senha:'
    end
    object Label3: TLabel
      Left = 120
      Top = 5
      Width = 69
      Height = 13
      Caption = 'Nome do host:'
    end
    object Label4: TLabel
      Left = 120
      Top = 149
      Width = 3
      Height = 13
    end
    object Label5: TLabel
      Left = 304
      Top = 128
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Label6: TLabel
      Left = 517
      Top = 21
      Width = 22
      Height = 13
      Caption = 'dias.'
    end
    object Label7: TLabel
      Left = 440
      Top = 21
      Width = 34
      Height = 13
      Caption = 'Últimos'
    end
    object Label8: TLabel
      Left = 304
      Top = 112
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Button1: TButton
      Left = 5
      Top = 15
      Width = 100
      Height = 25
      Caption = 'Conectar'
      Enabled = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 5
      Top = 47
      Width = 100
      Height = 25
      Caption = 'Desconectar'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 5
      Top = 79
      Width = 100
      Height = 25
      Caption = 'Listar'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 5
      Top = 111
      Width = 100
      Height = 25
      Caption = 'Senha ?'
      TabOrder = 4
      OnClick = Button4Click
    end
    object Edit1: TEdit
      Left = 120
      Top = 72
      Width = 169
      Height = 21
      TabOrder = 5
      Text = 'ftpcompu'
    end
    object Edit2: TEdit
      Left = 120
      Top = 120
      Width = 169
      Height = 21
      PasswordChar = '*'
      TabOrder = 6
      Text = '72648yz'
    end
    object Edit3: TEdit
      Left = 120
      Top = 24
      Width = 169
      Height = 21
      TabOrder = 7
      Text = 'ftp.netcon.com.br'
    end
    object Button5: TButton
      Left = 300
      Top = 15
      Width = 132
      Height = 25
      Caption = 'Atualizar revendas'
      TabOrder = 0
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 300
      Top = 47
      Width = 132
      Height = 25
      Caption = 'Copiar Arquivos'
      TabOrder = 8
      OnClick = Button6Click
    end
    object ComboBox1: TComboBox
      Left = 480
      Top = 16
      Width = 35
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        '30'
        '60'
        '90')
      TabOrder = 9
      Text = '60'
    end
    object Button7: TButton
      Left = 300
      Top = 80
      Width = 133
      Height = 25
      Caption = 'E-mail personalizado'
      Enabled = False
      TabOrder = 10
      OnClick = Button7Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 553
    Height = 267
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 0
    Top = 0
    Width = 553
    Height = 267
    Align = alClient
    Lines.Strings = (
      '')
    TabOrder = 3
    Visible = False
  end
  object NMFTP1: TNMFTP
    Port = 110
    ReportLevel = 0
    OnDisconnect = NMFTP1Disconnect
    OnConnect = NMFTP1Connect
    OnInvalidHost = NMFTP1InvalidHost
    OnConnectionFailed = NMFTP1ConnectionFailed
    OnError = NMFTP1Error
    OnFailure = NMFTP1Failure
    OnSuccess = NMFTP1Success
    OnListItem = NMFTP1ListItem
    Vendor = 2411
    ParseList = False
    ProxyPort = 0
    Left = 448
    Top = 352
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 488
    Top = 346
  end
  object Table1: TTable
    DatabaseName = 'c:\Projeto 2001\2001'
    TableName = 'CLIENTES.DBF'
    Left = 488
    Top = 378
    object Table1NOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Size = 35
    end
    object Table1CONTATO: TStringField
      DisplayLabel = 'Contato'
      FieldName = 'CONTATO'
      Size = 35
    end
    object Table1CIDADE: TStringField
      DisplayLabel = 'Cidade'
      FieldName = 'CIDADE'
      Size = 25
    end
    object Table1ESTADO: TStringField
      DisplayLabel = 'UF'
      FieldName = 'ESTADO'
      Size = 2
    end
    object Table1EMAIL: TStringField
      DisplayLabel = 'e-mail'
      FieldName = 'EMAIL'
      Size = 80
    end
    object Table1OBS: TStringField
      FieldName = 'OBS'
      Size = 254
    end
    object Table1ULTIMACO: TDateField
      FieldName = 'ULTIMACO'
    end
    object Table1ATIVO: TBooleanField
      FieldName = 'ATIVO'
    end
    object Table1CREDITO: TFloatField
      FieldName = 'CREDITO'
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 368
    Top = 387
  end
  object NMSMTP1: TNMSMTP
    Host = 'smtp.netcon.com.br'
    Port = 25
    ReportLevel = 0
    OnDisconnect = NMSMTP1Disconnect
    OnConnect = NMSMTP1Connect
    OnInvalidHost = NMSMTP1InvalidHost
    OnHostResolved = NMSMTP1HostResolved
    OnStatus = NMSMTP1Status
    OnConnectionFailed = NMSMTP1ConnectionFailed
    OnPacketSent = NMSMTP1PacketSent
    OnConnectionRequired = NMSMTP1ConnectionRequired
    PostMessage.LocalProgram = 'NetMasters SMTP Demo'
    EncodeType = uuMime
    ClearParams = True
    SubType = mtPlain
    OnRecipientNotFound = NMSMTP1RecipientNotFound
    OnHeaderIncomplete = NMSMTP1HeaderIncomplete
    OnSendStart = NMSMTP1SendStart
    OnSuccess = NMSMTP1Success
    OnFailure = NMSMTP1Failure
    Left = 408
    Top = 387
  end
end
