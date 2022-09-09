object Form1: TForm1
  Left = 356
  Top = 278
  Width = 623
  Height = 519
  Caption = 'SMALL MOBILE MONITOR'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMinimized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 607
    Height = 447
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssHorizontal
    TabOrder = 2
    OnClick = Memo1Click
  end
  object baixa: TButton
    Left = 456
    Top = 56
    Width = 137
    Height = 25
    Caption = 'Baixa Arquivos'
    TabOrder = 0
    Visible = False
    OnClick = baixaClick
  end
  object mandaarquivos: TButton
    Left = 456
    Top = 88
    Width = 137
    Height = 25
    Caption = 'Manda Arquivos'
    TabOrder = 1
    Visible = False
    OnClick = mandaarquivosClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 607
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Color = 15921906
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 464
    Top = 16
  end
  object LbBlowfish1: TLbBlowfish
    CipherMode = cmECB
    Left = 528
    Top = 16
  end
  object LbRSASSA1: TLbRSASSA
    HashMethod = hmMD5
    PrimeTestIterations = 20
    KeySize = aks512
    Left = 560
    Top = 16
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.CacheControl = 'no-cache'
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Pragma = 'NO-CACHE'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 496
    Top = 16
  end
end
