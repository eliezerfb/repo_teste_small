object Form10: TForm10
  Left = 737
  Top = 343
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Administradora'
  ClientHeight = 191
  ClientWidth = 297
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnBotoes: TPanel
    Left = 0
    Top = 151
    Width = 297
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Visible = False
    object btnMais: TBitBtn
      Left = 15
      Top = 8
      Width = 75
      Height = 25
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnMaisClick
    end
    object btnMenos: TBitBtn
      Left = 111
      Top = 7
      Width = 75
      Height = 25
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnMenosClick
    end
    object Button3: TBitBtn
      Left = 207
      Top = 7
      Width = 75
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 151
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 297
      Height = 151
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 29
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      OnKeyDown = ListBox1KeyDown
    end
  end
end
