object form6: form6
  Left = 374
  Top = 309
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Agenda'
  ClientHeight = 320
  ClientWidth = 567
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 320
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 7
      Width = 166
      Height = 22
      Caption = 'Agenda da ofic'#237'na'
      Color = clSilver
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 10
      Top = 5
      Width = 166
      Height = 22
      Caption = 'Agenda da of'#237'cina'
      Color = clSilver
      Font.Charset = ANSI_CHARSET
      Font.Color = 15381041
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object SStringGrid1: TSStringGrid
      Left = 10
      Top = 35
      Width = 533
      Height = 265
      ColCount = 1
      Ctl3D = False
      DefaultColWidth = 80
      DefaultRowHeight = 11
      FixedColor = clWhite
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      HorFonte.Charset = ANSI_CHARSET
      HorFonte.Color = clRed
      HorFonte.Height = -11
      HorFonte.Name = 'Microsoft Sans Serif'
      HorFonte.Style = []
      TitFonte.Charset = DEFAULT_CHARSET
      TitFonte.Color = clBlue
      TitFonte.Height = -11
      TitFonte.Name = 'MS Sans Serif'
      TitFonte.Style = []
      HorInicial = 8
      HorFinal = 18
      CantoColor = clWhite
      HorariosColor = clWhite
      SelectColor = clYellow
      Tecnicos.Strings = (
        'Ronei'
        'Daniel'
        'Darlan')
      Table = Form1.Table1
    end
  end
end
