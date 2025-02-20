object Form13: TForm13
  Left = 340
  Top = 179
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Grade - Cor e tamanho'
  ClientHeight = 362
  ClientWidth = 512
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 362
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label2: TLabel
      Left = 20
      Top = 284
      Width = 376
      Height = 16
      Caption = '12345678901234567890123456789012345678901234567'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label38: TLabel
      Left = 20
      Top = 15
      Width = 69
      Height = 13
      BiDiMode = bdRightToLeft
      Caption = 'Grade do item:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 312
      Width = 32
      Height = 13
      Caption = 'Label1'
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
    object Button2: TButton
      Left = 382
      Top = 320
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 257
      Top = 320
      Width = 100
      Height = 25
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Edit2: TEdit
      Left = 20
      Top = 35
      Width = 460
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'Edit2'
    end
  end
end
