object Form4: TForm4
  Left = 363
  Top = 195
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Lay-Out da Nota Fiscal'
  ClientHeight = 311
  ClientWidth = 557
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OnActivate = FormActivate
  OnClick = FormClick
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 557
    Height = 311
    Align = alClient
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 532
      Height = 287
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 0
      OnClick = FormClick
      OnDblClick = Panel1DblClick
    end
  end
end
