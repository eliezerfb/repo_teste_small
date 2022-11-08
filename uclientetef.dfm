object FClienteTef: TFClienteTef
  Left = 228
  Top = 130
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FClienteTef'
  ClientHeight = 741
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    1008
    741)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TBitBtn
    Left = 454
    Top = 360
    Width = 100
    Height = 40
    Caption = 'Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 2
    Top = 431
    Width = 1008
    Height = 312
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      inherited PAnel1: TPanel
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object sgClienteTef: TStringGrid
    Left = 16
    Top = 24
    Width = 977
    Height = 329
    Anchors = [akLeft, akTop, akRight]
    ColCount = 6
    Ctl3D = False
    DefaultColWidth = 90
    ParentCtl3D = False
    TabOrder = 2
    ColWidths = (
      90
      90
      90
      90
      160
      51)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
end
