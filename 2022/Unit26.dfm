object Form26: TForm26
  Left = 656
  Top = 329
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configura'#231#227'o do bloqueto banc'#225'rio'
  ClientHeight = 422
  ClientWidth = 584
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 15
    Top = 15
    Width = 455
    Height = 350
    Caption = 'Formul'#225'rio Cont'#237'nuo'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    Visible = False
    object Label27: TLabel
      Left = 48
      Top = 294
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = 'altura da p'#225'gina'
    end
    object Label1: TLabel
      Left = 23
      Top = 46
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'local de pagamento'
    end
    object Label2: TLabel
      Left = 61
      Top = 71
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Caption = 'vencimento'
    end
    object Label3: TLabel
      Left = 39
      Top = 96
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = 'data documento'
    end
    object Label4: TLabel
      Left = 63
      Top = 121
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'documento'
    end
    object Label5: TLabel
      Left = 23
      Top = 146
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'esp'#233'cie documento'
    end
    object Label6: TLabel
      Left = 87
      Top = 171
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'aceite'
    end
    object Label7: TLabel
      Left = 61
      Top = 196
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Caption = 'processado'
    end
    object Label8: TLabel
      Left = 22
      Top = 221
      Width = 94
      Height = 13
      Alignment = taRightJustify
      Caption = 'valor do documento'
    end
    object Label9: TLabel
      Left = 14
      Top = 246
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'linha 1 das instru'#231#245'es'
    end
    object Label10: TLabel
      Left = 14
      Top = 271
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'linha 2 das instru'#231#245'es'
    end
    object Label21: TLabel
      Left = 204
      Top = 46
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'linha 3 das instru'#231#245'es'
    end
    object Label22: TLabel
      Left = 204
      Top = 71
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'linha 4 das instru'#231#245'es'
    end
    object Label23: TLabel
      Left = 204
      Top = 96
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'linha 5 das instru'#231#245'es'
    end
    object Label24: TLabel
      Left = 227
      Top = 121
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = 'nome do sacado'
    end
    object Label25: TLabel
      Left = 208
      Top = 146
      Width = 98
      Height = 13
      Alignment = taRightJustify
      Caption = 'endere'#231'o do sacado'
    end
    object Label26: TLabel
      Left = 232
      Top = 171
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = 'CEP do sacado'
    end
    object Label28: TLabel
      Left = 221
      Top = 196
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = 'cidade do sacado'
    end
    object Label29: TLabel
      Left = 221
      Top = 221
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = 'estado do sacado'
    end
    object Label30: TLabel
      Left = 226
      Top = 246
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'CNPJ do sacado'
    end
    object Label31: TLabel
      Left = 225
      Top = 271
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = 'valor por extenso'
    end
    object Label11: TLabel
      Left = 198
      Top = 294
      Width = 140
      Height = 13
      Alignment = taRightJustify
      Caption = 'tamanho do valor por extenso'
    end
    object Label12: TLabel
      Left = 21
      Top = 319
      Width = 103
      Height = 13
      Alignment = taRightJustify
      Caption = 'repetir a 2'#170' coluna em'
    end
    object Label13: TLabel
      Left = 131
      Top = 22
      Width = 17
      Height = 13
      Alignment = taRightJustify
      Caption = 'LIN'
    end
    object Label14: TLabel
      Left = 167
      Top = 22
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = 'COL'
    end
    object Label15: TLabel
      Left = 315
      Top = 22
      Width = 17
      Height = 13
      Alignment = taRightJustify
      Caption = 'LIN'
    end
    object Label16: TLabel
      Left = 351
      Top = 22
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = 'COL'
    end
    object MaskEdit41: TMaskEdit
      Left = 131
      Top = 294
      Width = 33
      Height = 20
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit1: TMaskEdit
      Left = 131
      Top = 46
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit2: TMaskEdit
      Left = 131
      Top = 71
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit3: TMaskEdit
      Left = 131
      Top = 96
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit4: TMaskEdit
      Left = 131
      Top = 121
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit5: TMaskEdit
      Left = 131
      Top = 146
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit6: TMaskEdit
      Left = 131
      Top = 171
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit7: TMaskEdit
      Left = 131
      Top = 196
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit8: TMaskEdit
      Left = 131
      Top = 222
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit9: TMaskEdit
      Left = 131
      Top = 245
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit10: TMaskEdit
      Left = 131
      Top = 271
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit11: TMaskEdit
      Left = 315
      Top = 46
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit12: TMaskEdit
      Left = 315
      Top = 71
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit13: TMaskEdit
      Left = 315
      Top = 96
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit14: TMaskEdit
      Left = 315
      Top = 121
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit15: TMaskEdit
      Left = 315
      Top = 146
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit16: TMaskEdit
      Left = 315
      Top = 171
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit17: TMaskEdit
      Left = 315
      Top = 196
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit18: TMaskEdit
      Left = 315
      Top = 221
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit19: TMaskEdit
      Left = 315
      Top = 246
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit20: TMaskEdit
      Left = 315
      Top = 271
      Width = 22
      Height = 19
      Hint = 'Linha'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 20
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit21: TMaskEdit
      Left = 163
      Top = 46
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit22: TMaskEdit
      Left = 163
      Top = 71
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit23: TMaskEdit
      Left = 163
      Top = 96
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 23
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit24: TMaskEdit
      Left = 163
      Top = 121
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 24
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit25: TMaskEdit
      Left = 163
      Top = 146
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 25
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit26: TMaskEdit
      Left = 163
      Top = 171
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 26
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit27: TMaskEdit
      Left = 163
      Top = 196
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 27
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit28: TMaskEdit
      Left = 163
      Top = 221
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 28
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit29: TMaskEdit
      Left = 163
      Top = 246
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 29
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit30: TMaskEdit
      Left = 163
      Top = 271
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 30
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit31: TMaskEdit
      Left = 347
      Top = 46
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 31
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit32: TMaskEdit
      Left = 347
      Top = 71
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 32
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit33: TMaskEdit
      Left = 347
      Top = 96
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 33
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit34: TMaskEdit
      Left = 347
      Top = 121
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 34
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit35: TMaskEdit
      Left = 347
      Top = 146
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 35
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit36: TMaskEdit
      Left = 347
      Top = 171
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 36
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit37: TMaskEdit
      Left = 347
      Top = 196
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 37
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit38: TMaskEdit
      Left = 347
      Top = 221
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 38
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit39: TMaskEdit
      Left = 347
      Top = 246
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 39
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit40: TMaskEdit
      Left = 347
      Top = 271
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 40
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit400: TMaskEdit
      Left = 347
      Top = 294
      Width = 33
      Height = 19
      Hint = 'Coluna'
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!999;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 41
      Text = '   '
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit51: TMaskEdit
      Left = 131
      Top = 319
      Width = 33
      Height = 20
      AutoSize = False
      Color = clWhite
      Ctl3D = True
      EditMask = '!99;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 42
      Text = '  '
      OnKeyDown = MaskEdit1KeyDown
    end
  end
  object Button2: TButton
    Left = 320
    Top = 380
    Width = 250
    Height = 25
    Caption = 'Ok'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button2Click
    OnKeyDown = MaskEdit1KeyDown
  end
  object GroupBox2: TGroupBox
    Left = 15
    Top = 15
    Width = 555
    Height = 350
    Caption = 'Configura'#231#227'o do campo livre'
    ParentBackground = False
    TabOrder = 1
    object Label17: TLabel
      Left = 71
      Top = 25
      Width = 96
      Height = 13
      Alignment = taRightJustify
      Caption = 'c'#243'digo do banco (B)'
    end
    object Label18: TLabel
      Left = 70
      Top = 50
      Width = 97
      Height = 13
      Alignment = taRightJustify
      Caption = 'carteira/varia'#231#227'o (K)'
    end
    object Label19: TLabel
      Left = 113
      Top = 100
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = 'ag'#234'ncia (A)'
    end
    object Label20: TLabel
      Left = 16
      Top = 246
      Width = 203
      Height = 13
      Caption = 'M'#225'scara do campo livre (posi'#231#245'es 20 a 44)'
    end
    object Label32: TLabel
      Left = 62
      Top = 125
      Width = 105
      Height = 13
      Alignment = taRightJustify
      Caption = 'c'#243'digo do cedente (C)'
    end
    object Label33: TLabel
      Left = 81
      Top = 150
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = 'nosso n'#250'mero  (N)'
    end
    object Label34: TLabel
      Left = 16
      Top = 294
      Width = 123
      Height = 13
      Alignment = taRightJustify
      Caption = 'Resultado do campo livre '
    end
    object Label39: TLabel
      Left = 23
      Top = 175
      Width = 144
      Height = 13
      Alignment = taRightJustify
      Caption = 'vencimento formato juniano (J)'
    end
    object Label40: TLabel
      Left = 57
      Top = 75
      Width = 110
      Height = 13
      Alignment = taRightJustify
      Caption = 'c'#243'digo do conv'#234'nio (X)'
    end
    object Label41: TLabel
      Left = 16
      Top = 199
      Width = 151
      Height = 13
      Alignment = taRightJustify
      Caption = 'd'#237'gito verificador, m'#243'dulo 11 (D)'
    end
    object Label42: TLabel
      Left = 15
      Top = 219
      Width = 152
      Height = 13
      Alignment = taRightJustify
      Caption = 'd'#237'gito verificador, m'#243'dulo 10 (M)'
    end
    object Label001: TLabel
      Left = 324
      Top = 30
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Panel1Click
    end
    object Label002: TLabel
      Left = 324
      Top = 102
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Panel1Click
    end
    object Label003: TLabel
      Left = 324
      Top = 126
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Panel1Click
    end
    object MaskEdit42: TMaskEdit
      Left = 170
      Top = 25
      Width = 150
      Height = 19
      Hint = 'C'#243'digo do banco'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      EditMask = 'ccccc;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 5
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '     '
      OnChange = MaskEdit45Change
      OnExit = MaskEdit42Exit
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit43: TMaskEdit
      Left = 170
      Top = 50
      Width = 150
      Height = 19
      Hint = 'carteira/n'#250'mero'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      EditMask = 'ccccccccc;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 9
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '         '
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit44: TMaskEdit
      Left = 170
      Top = 100
      Width = 150
      Height = 19
      Hint = 'ag'#234'ncia/conta'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      EditMask = 'ccccccccc;1; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 9
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '         '
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit45: TMaskEdit
      Left = 16
      Top = 266
      Width = 260
      Height = 24
      Hint = 'ag'#234'ncia/conta'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      EditMask = 'aaaaaaaaaaaaaaaaaaaaaaaaa;1; '
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      MaxLength = 25
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '                         '
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit46: TMaskEdit
      Left = 170
      Top = 125
      Width = 150
      Height = 19
      Hint = 'ag'#234'ncia/conta'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnChange = MaskEdit45Change
      OnExit = MaskEdit46Exit
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit47: TMaskEdit
      Left = 170
      Top = 150
      Width = 150
      Height = 19
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit48: TMaskEdit
      Left = 16
      Top = 312
      Width = 260
      Height = 24
      Hint = 'ag'#234'ncia/conta'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      EditMask = 'CCCCCCCCCCCCCCCCCCCCCCCCC;1; '
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      MaxLength = 25
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 7
      Text = '                         '
      OnKeyDown = MaskEdit1KeyDown
    end
    object Panel1: TPanel
      Left = 330
      Top = 208
      Width = 200
      Height = 54
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 8
      OnClick = Panel1Click
      object Label37: TLabel
        Left = 84
        Top = 9
        Width = 76
        Height = 13
        Caption = 'Clique aqui para'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 15381041
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Panel1Click
      end
      object Label38: TLabel
        Left = 94
        Top = 29
        Width = 56
        Height = 13
        Caption = 'obter ajuda.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 15381041
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Panel1Click
      end
      object Label35: TLabel
        Left = 44
        Top = 0
        Width = 28
        Height = 55
        Caption = '?'
        Font.Charset = ANSI_CHARSET
        Font.Color = 15381041
        Font.Height = -48
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = Panel1Click
      end
    end
    object MaskEdit49: TMaskEdit
      Left = 170
      Top = 175
      Width = 150
      Height = 19
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 9
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object MaskEdit50: TMaskEdit
      Left = 170
      Top = 75
      Width = 150
      Height = 19
      Hint = 'carteira/n'#250'mero'
      AutoSize = False
      Color = clWhite
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = MaskEdit45Change
      OnKeyDown = MaskEdit1KeyDown
    end
    object ComboBox1: TComboBox
      Left = 288
      Top = 266
      Width = 253
      Height = 21
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 10
      Text = '<Personalizado>'
      OnChange = ComboBox1Change
      Items.Strings = (
        '<Personalizado>'
        'AILOS - Sistema de Cooperativas de Cr'#233'dito'
        'SICOOB - Sem registro'
        'SICOOB - Com registro'
        'Banco do Brasil - Com registro 7 posi'#231#245'es'
        'Banco do Brasil - Com registro 6 posi'#231#245'es'
        'Banco do Brasil - Sem registro          '
        'Caixa Econ'#244'mica - Com registro'
        'Caixa Econ'#244'mica - Sem registro'
        'Bradesco - Com registro'
        'Santander - Com registro'
        'Banrisul - Com registro'
        'Ita'#250' - Com registro'
        'SICREDI - Com registro'
        'Unibanco')
    end
    object chkCNAB400: TCheckBox
      Left = 288
      Top = 312
      Width = 97
      Height = 17
      Caption = 'CNAB 400'
      TabOrder = 11
    end
    object chkCNAB240: TCheckBox
      Left = 416
      Top = 312
      Width = 97
      Height = 17
      Caption = 'CNAB 240'
      TabOrder = 12
    end
  end
end
