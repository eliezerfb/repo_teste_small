object Form4: TForm4
  Left = 415
  Top = 223
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Tabela de al'#237'quotas'
  ClientHeight = 353
  ClientWidth = 412
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
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
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Label1'
    Color = clGray
    ParentColor = False
    Visible = False
  end
  object Label2: TLabel
    Left = 200
    Top = 32
    Width = 43
    Height = 13
    Caption = 'Aten'#231#227'o:'
  end
  object Label3: TLabel
    Left = 210
    Top = 56
    Width = 182
    Height = 13
    Caption = 'Ao cadastrar uma nova al'#237'quota voc'#234' '
  end
  object Label4: TLabel
    Left = 210
    Top = 72
    Width = 164
    Height = 13
    Caption = 'estar'#225' alterando a mem'#243'ria  CMOS'
  end
  object Label5: TLabel
    Left = 210
    Top = 88
    Width = 182
    Height = 13
    Caption = 'da impressora fiscal. Esta al'#237'quota n'#227'o'
  end
  object Label6: TLabel
    Left = 210
    Top = 104
    Width = 185
    Height = 13
    Caption = 'poder'#225' ser alterada ou removida, a n'#227'o'
  end
  object Label7: TLabel
    Left = 210
    Top = 120
    Width = 155
    Height = 13
    Caption = 'ser por uma interven'#231#227'o t'#233'cnica.'
  end
  object Label8: TLabel
    Left = 200
    Top = 152
    Width = 190
    Height = 13
    Caption = 'Se voc'#234' tiver alguma d'#250'vida sobre este '
  end
  object Label9: TLabel
    Left = 200
    Top = 168
    Width = 148
    Height = 13
    Caption = 'assunto, clique em <Cancelar>.'
  end
  object MaskEdit1: TMaskEdit
    Left = 40
    Top = 16
    Width = 57
    Height = 15
    BorderStyle = bsNone
    Color = 11796479
    Ctl3D = False
    EditMask = '!##,##;1; '
    MaxLength = 5
    ParentCtl3D = False
    TabOrder = 0
    Text = '  ,  '
    Visible = False
    OnExit = MaskEdit1Exit
  end
  object Button3: TBitBtn
    Left = 12
    Top = 316
    Width = 76
    Height = 23
    Caption = '< &Voltar'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button1: TBitBtn
    Left = 88
    Top = 316
    Width = 76
    Height = 23
    Caption = 'Avan'#231'ar >'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TBitBtn
    Left = 325
    Top = 316
    Width = 73
    Height = 23
    Caption = '&Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Panel2: TPanel
    Left = 18
    Top = 8
    Width = 168
    Height = 275
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    object Label10: TLabel
      Left = 1
      Top = 1
      Width = 165
      Height = 16
      AutoSize = False
      Caption = ' Ordem           ISS    %ICMS'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object CheckBox1: TCheckBox
    Left = 202
    Top = 280
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'CheckBox1'
    TabOrder = 5
    Visible = False
  end
end
