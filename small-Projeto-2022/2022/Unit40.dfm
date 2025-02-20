object Form40: TForm40
  Left = 482
  Top = 122
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'e-mail texto'
  ClientHeight = 673
  ClientWidth = 1175
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 30
    Width = 95
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Assunto:'
  end
  object Label2: TLabel
    Left = 0
    Top = 60
    Width = 95
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Mensagem:'
  end
  object Label3: TLabel
    Left = 423
    Top = 30
    Width = 72
    Height = 13
    Caption = 'Anexar Arquivo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Label4: TLabel
    Left = 680
    Top = 30
    Width = 74
    Height = 13
    Caption = 'e-mails por hora'
  end
  object Memo1: TMemo
    Left = 100
    Top = 60
    Width = 470
    Height = 280
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Lines.Strings = (
      '')
    ParentCtl3D = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 100
    Top = 30
    Width = 200
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 470
    Top = 350
    Width = 100
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object MaskEdit1: TMaskEdit
    Left = 625
    Top = 28
    Width = 49
    Height = 19
    Ctl3D = False
    EditMask = '##########;1; '
    MaxLength = 10
    ParentCtl3D = False
    TabOrder = 3
    Text = '20        '
  end
  object CheckBox1: TCheckBox
    Left = 104
    Top = 350
    Width = 249
    Height = 17
    Caption = 'Enviar boleto por e-mail'
    TabOrder = 4
    Visible = False
  end
  object Memo2: TMemo
    Left = 600
    Top = 60
    Width = 200
    Height = 573
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    TabOrder = 5
  end
  object Button2: TButton
    Left = 366
    Top = 350
    Width = 100
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 576
    Top = 16
  end
end
