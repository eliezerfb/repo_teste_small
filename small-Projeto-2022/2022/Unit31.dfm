object Form31: TForm31
  Left = 240
  Top = 249
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o do cheque'
  ClientHeight = 310
  ClientWidth = 307
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 197
    Top = 38
    Width = 23
    Height = 13
    Alignment = taRightJustify
    Caption = 'valor'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 149
    Top = 63
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'extenso linha 1'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 149
    Top = 88
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'extenso linha 2'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 184
    Top = 113
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'nominal'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 188
    Top = 138
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'cidade'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 206
    Top = 163
    Width = 14
    Height = 13
    Alignment = taRightJustify
    Caption = 'dia'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label7: TLabel
    Left = 201
    Top = 188
    Width = 19
    Height = 13
    Alignment = taRightJustify
    Caption = 'm'#234's'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 202
    Top = 213
    Width = 18
    Height = 13
    Alignment = taRightJustify
    Caption = 'ano'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 100
    Top = 240
    Width = 123
    Height = 13
    Alignment = taRightJustify
    Caption = 'N'#250'mero de d'#237'gitos no ano'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 235
    Top = 14
    Width = 17
    Height = 13
    Alignment = taRightJustify
    Caption = 'Lin'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 265
    Top = 14
    Width = 18
    Height = 13
    Alignment = taRightJustify
    Caption = 'Col'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 146
    Top = 264
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = 'Altura da p'#225'gina'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object MaskEdit1: TMaskEdit
    Left = 230
    Top = 30
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit2: TMaskEdit
    Left = 230
    Top = 55
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit3: TMaskEdit
    Left = 230
    Top = 80
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit4: TMaskEdit
    Left = 230
    Top = 105
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit5: TMaskEdit
    Left = 230
    Top = 130
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 8
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit6: TMaskEdit
    Left = 230
    Top = 155
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 10
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit7: TMaskEdit
    Left = 230
    Top = 180
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 12
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit8: TMaskEdit
    Left = 230
    Top = 205
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 14
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit21: TMaskEdit
    Left = 258
    Top = 30
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit22: TMaskEdit
    Left = 258
    Top = 55
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit23: TMaskEdit
    Left = 258
    Top = 80
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit24: TMaskEdit
    Left = 258
    Top = 105
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 7
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit25: TMaskEdit
    Left = 258
    Top = 130
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 9
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit26: TMaskEdit
    Left = 258
    Top = 155
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 11
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit27: TMaskEdit
    Left = 258
    Top = 180
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 13
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit28: TMaskEdit
    Left = 258
    Top = 205
    Width = 29
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 15
    Text = '   '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit9: TMaskEdit
    Left = 230
    Top = 230
    Width = 57
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 16
    Text = '  '
    OnKeyDown = MaskEdit1KeyDown
  end
  object MaskEdit10: TMaskEdit
    Left = 230
    Top = 255
    Width = 57
    Height = 26
    AutoSize = False
    Color = clWhite
    Ctl3D = False
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 17
    Text = '  '
    OnKeyDown = MaskEdit1KeyDown
  end
end
