object Form11: TForm11
  Left = 585
  Top = 385
  BorderIcons = []
  Caption = 'NF de produtor rural referenciada'
  ClientHeight = 281
  ClientWidth = 484
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 130
    Top = 20
    Width = 75
    Height = 13
    Caption = 'UF do emitente:'
  end
  object Label2: TLabel
    Left = 13
    Top = 50
    Width = 192
    Height = 13
    Caption = 'Ano e M'#234's da emiss'#227'o da NF-e (AAMM):'
  end
  object Label3: TLabel
    Left = 92
    Top = 80
    Width = 113
    Height = 13
    Caption = 'CNPJ/CPF do emitente:'
  end
  object Label4: TLabel
    Left = 133
    Top = 110
    Width = 72
    Height = 13
    Caption = 'IE do Emitente:'
  end
  object Label5: TLabel
    Left = 69
    Top = 140
    Width = 136
    Height = 13
    Caption = 'Modelo do documento fiscal:'
  end
  object Label6: TLabel
    Left = 82
    Top = 170
    Width = 123
    Height = 13
    Caption = 'S'#233'rie do documento fscal:'
  end
  object Label7: TLabel
    Left = 67
    Top = 200
    Width = 138
    Height = 13
    Caption = 'N'#250'mero do documento fiscal:'
  end
  object Button1: TButton
    Left = 384
    Top = 240
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 210
    Top = 20
    Width = 25
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    Text = 'SC'
    OnExit = Edit1Exit
    OnKeyDown = Edit1KeyDown
  end
  object Edit2: TEdit
    Left = 210
    Top = 50
    Width = 33
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 2
    Text = '0000'
    OnKeyDown = Edit1KeyDown
  end
  object Edit3: TEdit
    Left = 210
    Top = 80
    Width = 161
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 3
    Text = '00000000000'
    OnKeyDown = Edit1KeyDown
  end
  object Edit4: TEdit
    Left = 210
    Top = 110
    Width = 161
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 4
    Text = '00000000'
    OnKeyDown = Edit1KeyDown
  end
  object ComboBox7: TComboBox
    Left = 210
    Top = 140
    Width = 247
    Height = 22
    Style = csOwnerDrawVariable
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnKeyDown = Edit1KeyDown
    Items.Strings = (
      '01 - NF avulsa'
      '04 - NF de Produtor')
  end
  object Edit5: TEdit
    Left = 210
    Top = 170
    Width = 33
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 6
    Text = '000'
    OnExit = Edit5Exit
    OnKeyDown = Edit1KeyDown
  end
  object Edit6: TEdit
    Left = 210
    Top = 200
    Width = 73
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 7
    Text = '000000'
    OnChange = Edit6Change
    OnKeyDown = Edit1KeyDown
  end
end
