object Form27: TForm27
  Left = 361
  Top = 90
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form27'
  ClientHeight = 741
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 20
    Top = 50
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'Label  2:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 20
    Top = 20
    Width = 1024
    Height = 19
    AutoSize = False
    Caption = 'Label 1:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TBitBtn
    Left = 454
    Top = 360
    Width = 100
    Height = 40
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
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
  object ComboBox1: TComboBox
    Left = 20
    Top = 70
    Width = 981
    Height = 28
    Color = clWhite
    Ctl3D = False
    DropDownCount = 5
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    OnEnter = ComboBox1Enter
    OnKeyDown = ComboBox1KeyDown
    Items.Strings = (
      '0101 - DIMEP D-SAT'
      '0102 - DIMEP D-SAT2.0'
      '0201 - SWEDA SS1000'
      '0202 - SWEDA SS-2000'
      '0301 - TANCA TS-1000'
      '0401 - GERTEC GerSat'
      '0402 - GERTEC GerSAT-W '
      '0501 - URANO SAT UR'
      '0502 - URANO U-S@T'
      '0601 - BEMATECH RB-1000 '
      '0602 - BEMATECH RB-2000'
      '0701 - ELGIN Linker'
      '0702 - ELGIN LinkerII'
      '0801 - KRYPTUS EASYS@T'
      '0901 - NITERE NSAT4200'
      '1001 - DARUMA DS-100i')
  end
end
