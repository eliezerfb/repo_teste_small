object Form26: TForm26
  Left = 217
  Top = 161
  Width = 524
  Height = 353
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Configuração do boleto bancário'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000033333333000000000000000000000033333303333300000000
    00000000000337777803333333000000000000000003FFF80000033333300000
    00000000003FFFF00F0F00733330000000000000003FFFFFFF0F007773330000
    00000000003FFFF7000008777733000000000000003FFFF000007F7777330000
    00000000003FFFF00F0FFFF777330FFFFFFFFFFFFFF3FFF00F0F00FF77300FFF
    FFFFFFFFFFF3FFF7000088FFFF300FFFFFFFFFFF33FF3FFFFF0FFFFFF3300FFF
    FFF0FFFF333FF3FFFFFFFFFF33000FFFFFF708FFF333F077FFFFFF3300000FFF
    FFFF8788FF33300F3F3F370000000FFFFFFF78B30FF33000F3F3F00000000FFF
    FFFFF3BB30FF30003F3F330000000FFFFFFFFF3BB30FF003F3F3F30000000FFF
    FFFFFFF3BB30F0883FFF3F0000000FFFFFFFFFFF3BB300F883FFFFF000000FFF
    FFFFFFFFF3BB30FF883303FF00000FFFFFFFFFFFFF3BB300F880033330000FFF
    FFFFFFFFFFF3BB300000000300000FFFFFFFFFFFFFFF3BB30000000000000FFF
    FFFFFFFFFFFFF3BB3000000000000FFFFFFFFFFFFFFFF03BB800000000000FFF
    FFFFFFFFFFFFF003BB80000000000FFFFFFFFFFFFFFFF0003BB8000000000FFF
    FFFFFFFFFFFFF00003B9100000000FFFFFFFFFFFFFFFF0000019910000000FFF
    FFFFFFFFFFFFF00000019910000000000000000000000000000019000000FFFF
    C03FFFFF000FFFFE0003FFFE0001FFFC0001FFFC0000FFFC0000FFFC00000000
    0000000000010000000100000001000000030000000F0000203F0000307F0000
    303F0000203F0000003F0000001F0000008F0000118700000FEF000007FF0000
    03FF000001FF000020FF0000307F0000383F00003C1F00003E1F00003F3F}
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label27: TLabel
    Left = 24
    Top = 293
    Width = 76
    Height = 13
    Alignment = taRightJustify
    Caption = 'altura da página'
  end
  object Label1: TLabel
    Left = 23
    Top = 22
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = 'local de pagamento'
  end
  object Label2: TLabel
    Left = 61
    Top = 47
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = 'vencimento'
  end
  object Label3: TLabel
    Left = 39
    Top = 72
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = 'data documento'
  end
  object Label4: TLabel
    Left = 63
    Top = 97
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'documento'
  end
  object Label5: TLabel
    Left = 23
    Top = 122
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = 'espécie documento'
  end
  object Label6: TLabel
    Left = 87
    Top = 147
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'aceite'
  end
  object Label7: TLabel
    Left = 61
    Top = 172
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = 'processado'
  end
  object Label8: TLabel
    Left = 22
    Top = 197
    Width = 94
    Height = 13
    Alignment = taRightJustify
    Caption = 'valor do cocumento'
  end
  object Label9: TLabel
    Left = 14
    Top = 222
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'linha 1 das instruções'
  end
  object Label10: TLabel
    Left = 14
    Top = 247
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'linha 2 das instruções'
  end
  object Label21: TLabel
    Left = 204
    Top = 22
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'linha 3 das instruções'
  end
  object Label22: TLabel
    Left = 204
    Top = 47
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'linha 4 das instruções'
  end
  object Label23: TLabel
    Left = 204
    Top = 72
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'linha 5 das instruções'
  end
  object Label24: TLabel
    Left = 227
    Top = 97
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'nome do sacado'
  end
  object Label25: TLabel
    Left = 208
    Top = 122
    Width = 98
    Height = 13
    Alignment = taRightJustify
    Caption = 'endereço do sacado'
  end
  object Label26: TLabel
    Left = 232
    Top = 147
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = 'CEP do sacado'
  end
  object Label28: TLabel
    Left = 221
    Top = 172
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'cidade do sacado'
  end
  object Label29: TLabel
    Left = 221
    Top = 197
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'estado do sacado'
  end
  object Label30: TLabel
    Left = 231
    Top = 222
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = 'CGC do sacado'
  end
  object Label31: TLabel
    Left = 225
    Top = 247
    Width = 81
    Height = 13
    Alignment = taRightJustify
    Caption = 'valor por extenso'
  end
  object Button2: TButton
    Left = 269
    Top = 285
    Width = 100
    Height = 23
    Caption = '&Retornar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button2Click
  end
  object MaskEdit41: TMaskEdit
    Left = 104
    Top = 293
    Width = 22
    Height = 20
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = '  '
  end
  object MaskEdit1: TMaskEdit
    Left = 131
    Top = 22
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '  '
  end
  object MaskEdit2: TMaskEdit
    Left = 131
    Top = 47
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '  '
  end
  object MaskEdit3: TMaskEdit
    Left = 131
    Top = 72
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    Text = '  '
  end
  object MaskEdit4: TMaskEdit
    Left = 131
    Top = 97
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    Text = '  '
  end
  object MaskEdit5: TMaskEdit
    Left = 131
    Top = 122
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
    Text = '  '
  end
  object MaskEdit6: TMaskEdit
    Left = 131
    Top = 147
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 7
    Text = '  '
  end
  object MaskEdit7: TMaskEdit
    Left = 131
    Top = 172
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 8
    Text = '  '
  end
  object MaskEdit8: TMaskEdit
    Left = 131
    Top = 198
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 9
    Text = '  '
  end
  object MaskEdit9: TMaskEdit
    Left = 131
    Top = 221
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 10
    Text = '  '
  end
  object MaskEdit10: TMaskEdit
    Left = 131
    Top = 247
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 11
    Text = '  '
  end
  object MaskEdit11: TMaskEdit
    Left = 315
    Top = 22
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 12
    Text = '  '
  end
  object MaskEdit12: TMaskEdit
    Left = 315
    Top = 47
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 13
    Text = '  '
  end
  object MaskEdit13: TMaskEdit
    Left = 315
    Top = 72
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 14
    Text = '  '
  end
  object MaskEdit14: TMaskEdit
    Left = 315
    Top = 97
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 15
    Text = '  '
  end
  object MaskEdit15: TMaskEdit
    Left = 315
    Top = 122
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 16
    Text = '  '
  end
  object MaskEdit16: TMaskEdit
    Left = 315
    Top = 147
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 17
    Text = '  '
  end
  object MaskEdit17: TMaskEdit
    Left = 315
    Top = 172
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 18
    Text = '  '
  end
  object MaskEdit18: TMaskEdit
    Left = 315
    Top = 197
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 19
    Text = '  '
  end
  object MaskEdit19: TMaskEdit
    Left = 315
    Top = 222
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 20
    Text = '  '
  end
  object MaskEdit20: TMaskEdit
    Left = 315
    Top = 247
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 21
    Text = '  '
  end
  object MaskEdit21: TMaskEdit
    Left = 163
    Top = 22
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 22
    Text = '  '
  end
  object MaskEdit22: TMaskEdit
    Left = 163
    Top = 47
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 23
    Text = '  '
  end
  object MaskEdit23: TMaskEdit
    Left = 163
    Top = 72
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 24
    Text = '  '
  end
  object MaskEdit24: TMaskEdit
    Left = 163
    Top = 97
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 25
    Text = '  '
  end
  object MaskEdit25: TMaskEdit
    Left = 163
    Top = 122
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 26
    Text = '  '
  end
  object MaskEdit26: TMaskEdit
    Left = 163
    Top = 147
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 27
    Text = '  '
  end
  object MaskEdit27: TMaskEdit
    Left = 163
    Top = 172
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 28
    Text = '  '
  end
  object MaskEdit28: TMaskEdit
    Left = 163
    Top = 197
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 29
    Text = '  '
  end
  object MaskEdit29: TMaskEdit
    Left = 163
    Top = 222
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 30
    Text = '  '
  end
  object MaskEdit30: TMaskEdit
    Left = 163
    Top = 247
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 31
    Text = '  '
  end
  object MaskEdit31: TMaskEdit
    Left = 347
    Top = 22
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 32
    Text = '  '
  end
  object MaskEdit32: TMaskEdit
    Left = 347
    Top = 47
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 33
    Text = '  '
  end
  object MaskEdit33: TMaskEdit
    Left = 347
    Top = 72
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 34
    Text = '  '
  end
  object MaskEdit34: TMaskEdit
    Left = 347
    Top = 97
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 35
    Text = '  '
  end
  object MaskEdit35: TMaskEdit
    Left = 347
    Top = 122
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 36
    Text = '  '
  end
  object MaskEdit36: TMaskEdit
    Left = 347
    Top = 147
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 37
    Text = '  '
  end
  object MaskEdit37: TMaskEdit
    Left = 347
    Top = 172
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 38
    Text = '  '
  end
  object MaskEdit38: TMaskEdit
    Left = 347
    Top = 197
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 39
    Text = '  '
  end
  object MaskEdit39: TMaskEdit
    Left = 347
    Top = 222
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 40
    Text = '  '
  end
  object MaskEdit40: TMaskEdit
    Left = 347
    Top = 247
    Width = 22
    Height = 19
    AutoSize = False
    Color = clWhite
    Ctl3D = True
    EditMask = '!99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 41
    Text = '  '
  end
end
