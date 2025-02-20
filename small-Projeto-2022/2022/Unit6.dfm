object Form6: TForm6
  Left = 606
  Top = 274
  Width = 377
  Height = 359
  Caption = 'Download do XML'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 0
    Top = 290
    Width = 361
    Height = 30
    Align = alBottom
    Color = clWhite
    ForeColor = 15116900
    ParentColor = False
    Progress = 0
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 361
    Height = 290
    Align = alClient
    TabOrder = 0
    OnProgressChange = WebBrowser1ProgressChange
    OnNavigateComplete2 = WebBrowser1NavigateComplete2
    OnDocumentComplete = WebBrowser1DocumentComplete
    ControlData = {
      4C0000004F250000F91D00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
