object Form9: TForm9
  Left = 441
  Top = 153
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Tab. '#205'ndice T'#233'cnico Produ'#231#227'o'
  ClientHeight = 362
  ClientWidth = 584
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 322
    Width = 584
    Height = 40
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Button2: TBitBtn
      Left = 190
      Top = 7
      Width = 100
      Height = 25
      Caption = 'Arquivo'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TBitBtn
      Left = 300
      Top = 7
      Width = 100
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 584
    Height = 322
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Indent = 19
    ParentFont = False
    TabOrder = 1
  end
end
