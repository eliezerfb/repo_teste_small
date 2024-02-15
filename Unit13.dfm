object Form13: TForm13
  Left = 154
  Top = 111
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Grade - Cor e tamanho'
  ClientHeight = 664
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 354
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Label2: TLabel
      Left = 24
      Top = 281
      Width = 337
      Height = 26
      AutoSize = False
      Caption = '12345678901234567890123456789012345678901234567'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label38: TLabel
      Left = 20
      Top = 15
      Width = 83
      Height = 13
      BiDiMode = bdLeftToRight
      Caption = 'Grade do item:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
    end
    object StringGrid2: TStringGrid
      Left = 20
      Top = 76
      Width = 460
      Height = 200
      BorderStyle = bsNone
      Color = clWhite
      ColCount = 20
      Ctl3D = False
      DefaultColWidth = 91
      DefaultRowHeight = 32
      Enabled = False
      FixedColor = clWhite
      FixedCols = 0
      RowCount = 20
      FixedRows = 0
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      GridLineWidth = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goEditing]
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
      Visible = False
      OnSetEditText = StringGrid1SetEditText
    end
    object StringGrid1: TStringGrid
      Left = 20
      Top = 76
      Width = 460
      Height = 200
      BorderStyle = bsNone
      Color = clWhite
      ColCount = 20
      Ctl3D = False
      DefaultColWidth = 91
      DefaultRowHeight = 32
      DrawingStyle = gdsClassic
      FixedColor = clBtnShadow
      FixedCols = 0
      RowCount = 20
      FixedRows = 0
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      GridLineWidth = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goEditing]
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 1
      OnClick = StringGrid1Click
      OnDrawCell = StringGrid1DrawCell
      OnKeyPress = StringGrid1KeyPress
      OnKeyUp = StringGrid1KeyUp
      OnSetEditText = StringGrid1SetEditText
    end
    object Button2: TBitBtn
      Left = 382
      Top = 307
      Width = 100
      Height = 40
      Caption = 'Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TBitBtn
      Left = 257
      Top = 307
      Width = 100
      Height = 40
      Caption = 'Ok'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Edit2: TEdit
      Left = 20
      Top = 35
      Width = 460
      Height = 19
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = 'Edit2'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 354
    Width = 1008
    Height = 310
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    inline Frame_teclado1: TFrame_teclado
      Left = 0
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      ExplicitHeight = 301
      inherited PAnel1: TPanel
        Left = -5
        Top = 5
        ExplicitLeft = -5
        ExplicitTop = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
end
