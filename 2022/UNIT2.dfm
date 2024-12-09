object Form2: TForm2
  Left = 479
  Top = 134
  AlphaBlendValue = 220
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Liberar os m'#243'dulos:'
  ClientHeight = 598
  ClientWidth = 684
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Button2: TButton
    Left = 554
    Top = 389
    Width = 100
    Height = 22
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 598
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      684
      598)
    object Label1: TLabel
      Left = 20
      Top = 10
      Width = 39
      Height = 13
      Caption = 'Usu'#225'rio:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 20
      Top = 60
      Width = 32
      Height = 13
      Caption = #205'cone'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label_8: TLabel
      Left = 338
      Top = 100
      Width = 179
      Height = 16
      Caption = 'Notas de vendas bloqueadas'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 338
      Top = 60
      Width = 110
      Height = 13
      Caption = 'Status da libera'#231#227'o'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage
      Left = 20
      Top = 90
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image2: TImage
      Tag = 1
      Left = 20
      Top = 265
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image3: TImage
      Tag = 1
      Left = 20
      Top = 300
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image4: TImage
      Tag = 1
      Left = 20
      Top = 335
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image7: TImage
      Tag = 1
      Left = 20
      Top = 510
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image8: TImage
      Tag = 1
      Left = 20
      Top = 545
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Label8: TLabel
      Left = 75
      Top = 60
      Width = 47
      Height = 13
      Caption = 'M'#243'dulos'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label_3: TLabel
      Tag = 1
      Left = 338
      Top = 275
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_1: TLabel
      Tag = 1
      Left = 338
      Top = 310
      Width = 93
      Height = 16
      Caption = 'Somente leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_5: TLabel
      Tag = 1
      Left = 338
      Top = 345
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_4: TLabel
      Tag = 1
      Left = 338
      Top = 415
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_6: TLabel
      Tag = 1
      Left = 338
      Top = 450
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_14: TLabel
      Tag = 1
      Left = 338
      Top = 520
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_16: TLabel
      Tag = 1
      Left = 338
      Top = 555
      Width = 79
      Height = 16
      Caption = 'N'#227'o liberado'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Image10: TImage
      Tag = 1
      Left = 20
      Top = 370
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Label_2: TLabel
      Tag = 1
      Left = 338
      Top = 380
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Image_: TImage
      Left = 20
      Top = 195
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Label_7: TLabel
      Left = 338
      Top = 205
      Width = 97
      Height = 16
      Caption = 'Somente Leitura'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Image5: TImage
      Tag = 1
      Left = 20
      Top = 405
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image6: TImage
      Tag = 1
      Left = 20
      Top = 440
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image9: TImage
      Tag = 1
      Left = 20
      Top = 475
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Label4: TLabel
      Tag = 1
      Left = 338
      Top = 485
      Width = 79
      Height = 16
      Caption = 'N'#227'o liberado'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label9: TLabel
      Left = 646
      Top = 60
      Width = 122
      Height = 13
      Caption = 'Painel de indicadores'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Image1__2: TImage
      Left = 20
      Top = 125
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Image1__3: TImage
      Left = 20
      Top = 160
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object Label_c: TLabel
      Left = 338
      Top = 135
      Width = 187
      Height = 16
      Caption = 'Notas de compras bloqueadas'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label_s: TLabel
      Left = 338
      Top = 170
      Width = 188
      Height = 16
      Caption = 'Notas de servi'#231'os  bloqueadas'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object imgOrcamento: TImage
      Tag = 1
      Left = 20
      Top = 230
      Width = 35
      Height = 35
      Stretch = True
      Transparent = True
    end
    object lblOrcamento: TLabel
      Left = 338
      Top = 240
      Width = 79
      Height = 16
      Caption = 'N'#227'o liberado'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Usuario: TComboBox
      Left = 65
      Top = 10
      Width = 290
      Height = 24
      BevelInner = bvNone
      BevelOuter = bvNone
      Style = csDropDownList
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 23
      OnClick = UsuarioClick
      OnDblClick = UsuarioDblClick
      OnExit = UsuarioExit
      OnKeyUp = UsuarioKeyUp
    end
    object CheckBox8: TCheckBox
      Left = 75
      Top = 100
      Width = 88
      Height = 13
      Caption = 'Vendas'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 24
      OnClick = CheckBox8Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox3: TCheckBox
      Tag = 1
      Left = 75
      Top = 275
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Estoque'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 25
      OnClick = CheckBox3Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 75
      Top = 310
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Cadastro'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 26
      OnClick = CheckBox1Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox5: TCheckBox
      Tag = 1
      Left = 75
      Top = 345
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Contas a receber'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 27
      OnClick = CheckBox5Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox4: TCheckBox
      Tag = 1
      Left = 75
      Top = 415
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Livro Caixa'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 28
      OnClick = CheckBox4Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox6: TCheckBox
      Tag = 1
      Left = 75
      Top = 450
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Bancos'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 29
      OnClick = CheckBox6Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox14: TCheckBox
      Tag = 1
      Left = 75
      Top = 520
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Configura'#231#245'es'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 30
      OnClick = CheckBox14Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox16: TCheckBox
      Tag = 1
      Left = 75
      Top = 555
      Width = 120
      Height = 17
      Caption = 'Backup'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 31
      OnClick = CheckBox16Click
      OnKeyUp = CheckBox8KeyUp
    end
    object Panel2: TPanel
      Left = 312
      Top = 55
      Width = 1
      Height = 525
      Anchors = [akLeft, akTop, akBottom]
      BevelOuter = bvNone
      Color = clBlack
      Ctl3D = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 32
    end
    object Panel3: TPanel
      Left = 65
      Top = 55
      Width = 1
      Height = 525
      Anchors = [akLeft, akTop, akBottom]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clBlack
      Ctl3D = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 33
    end
    object Panel4: TPanel
      Left = 20
      Top = 80
      Width = 644
      Height = 1
      BevelOuter = bvNone
      Color = clBlack
      Ctl3D = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 34
    end
    object CheckBox2: TCheckBox
      Tag = 1
      Left = 75
      Top = 380
      Width = 120
      Height = 17
      AllowGrayed = True
      Caption = 'Contas a pagar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 35
      OnClick = CheckBox2Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox7: TCheckBox
      Left = 75
      Top = 205
      Width = 120
      Height = 17
      Caption = 'Ordem de servi'#231'o'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 36
      OnClick = CheckBox7Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox9: TCheckBox
      Left = 75
      Top = 135
      Width = 112
      Height = 17
      Caption = 'Compras'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 37
      OnClick = CheckBox9Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox10: TCheckBox
      Tag = 1
      Left = 75
      Top = 485
      Width = 120
      Height = 17
      Caption = 'Dashboard'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 38
      OnClick = CheckBox10Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox11: TCheckBox
      Left = 646
      Top = 100
      Width = 140
      Height = 17
      Caption = 'Calend'#225'rio do m'#234's '
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
      OnClick = CheckBox11Click
      OnKeyUp = CheckBox8KeyUp
    end
    object Panel5: TPanel
      Left = 636
      Top = 55
      Width = 1
      Height = 525
      Anchors = [akLeft, akTop, akBottom]
      BevelOuter = bvNone
      Color = clBlack
      Ctl3D = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 39
      Visible = False
    end
    object CheckBox12: TCheckBox
      Left = 646
      Top = 147
      Width = 140
      Height = 17
      Caption = 'Inadimpl'#234'ncia 90 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = CheckBox12Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox13: TCheckBox
      Left = 646
      Top = 123
      Width = 140
      Height = 17
      Caption = 'Fluxo de caixa 60 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = CheckBox13Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox15: TCheckBox
      Left = 646
      Top = 217
      Width = 140
      Height = 17
      Caption = 'Receita mensal'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Visible = False
      OnClick = CheckBox15Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox17: TCheckBox
      Left = 646
      Top = 241
      Width = 140
      Height = 17
      Caption = 'Despesa mensal'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
      OnClick = CheckBox17Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox18: TCheckBox
      Left = 646
      Top = 264
      Width = 140
      Height = 17
      Caption = 'Lucro mensal'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Visible = False
      OnClick = CheckBox18Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox19: TCheckBox
      Left = 806
      Top = 100
      Width = 170
      Height = 17
      Caption = 'Vendas vendedor neste m'#234's'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
      Visible = False
      OnClick = CheckBox19Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox20: TCheckBox
      Left = 646
      Top = 170
      Width = 140
      Height = 17
      Caption = 'Inadimpl'#234'ncia 360 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnClick = CheckBox20Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox21: TCheckBox
      Left = 646
      Top = 194
      Width = 140
      Height = 17
      Caption = 'Inadimpl'#234'ncia total'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Visible = False
      OnClick = CheckBox21Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox22: TCheckBox
      Left = 646
      Top = 288
      Width = 140
      Height = 17
      Caption = 'Receita anual'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Visible = False
      OnClick = CheckBox22Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox23: TCheckBox
      Left = 646
      Top = 311
      Width = 140
      Height = 17
      Caption = 'Despesa anual'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Visible = False
      OnClick = CheckBox23Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox24: TCheckBox
      Left = 646
      Top = 335
      Width = 140
      Height = 17
      Caption = 'Lucro anual'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Visible = False
      OnClick = CheckBox24Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox25: TCheckBox
      Left = 646
      Top = 358
      Width = 140
      Height = 17
      Caption = 'Curva ABC de clientes'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Visible = False
      OnClick = CheckBox25Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox26: TCheckBox
      Left = 646
      Top = 429
      Width = 180
      Height = 17
      Caption = 'Curva ABC do estoque'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      Visible = False
      OnClick = CheckBox26Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox27: TCheckBox
      Left = 646
      Top = 405
      Width = 180
      Height = 17
      Caption = 'Registros no cadastro'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      Visible = False
      OnClick = CheckBox27Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox28: TCheckBox
      Left = 646
      Top = 382
      Width = 180
      Height = 17
      Caption = 'Curva ABC de fornecedores'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Visible = False
      OnClick = CheckBox28Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox29: TCheckBox
      Left = 646
      Top = 452
      Width = 180
      Height = 17
      Caption = 'Principais despesas 360 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      Visible = False
      OnClick = CheckBox29Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox30: TCheckBox
      Left = 646
      Top = 476
      Width = 180
      Height = 17
      Caption = 'Principais receitas 360 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
      Visible = False
      OnClick = CheckBox30Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox31: TCheckBox
      Left = 806
      Top = 123
      Width = 170
      Height = 17
      Caption = 'Vendas vendedor m'#234's anterior'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
      Visible = False
      OnClick = CheckBox31Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox32: TCheckBox
      Left = 646
      Top = 500
      Width = 180
      Height = 17
      Caption = 'Principais despesas  m'#234's anterior'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      Visible = False
      OnClick = CheckBox32Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox33: TCheckBox
      Left = 806
      Top = 147
      Width = 170
      Height = 17
      Caption = 'Comparativo vendas 90 dias'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
      Visible = False
      OnClick = CheckBox33Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox34: TCheckBox
      Left = 806
      Top = 170
      Width = 170
      Height = 17
      Caption = 'Vendas mensais'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 21
      Visible = False
      OnClick = CheckBox34Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox35: TCheckBox
      Left = 806
      Top = 191
      Width = 170
      Height = 17
      Caption = 'Vendas anuais'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 22
      Visible = False
      OnClick = CheckBox35Click
      OnKeyUp = CheckBox8KeyUp
    end
    object CheckBox36: TCheckBox
      Left = 806
      Top = 215
      Width = 170
      Height = 17
      Caption = 'Vendas parciais'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 40
      Visible = False
      OnClick = CheckBox36Click
      OnKeyUp = CheckBox8KeyUp
    end
    object Button1: TButton
      Left = 565
      Top = 6
      Width = 100
      Height = 24
      Caption = 'Op'#231#245'es'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 41
      OnClick = Button1Click
    end
    object CheckBox37: TCheckBox
      Left = 75
      Top = 170
      Width = 104
      Height = 17
      Caption = 'Servi'#231'os'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 42
      OnClick = CheckBox37Click
      OnKeyUp = CheckBox8KeyUp
    end
    object chkOrcamento: TCheckBox
      Left = 75
      Top = 240
      Width = 120
      Height = 17
      Caption = 'Or'#231'amento'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 43
      OnClick = chkOrcamentoClick
      OnKeyUp = CheckBox8KeyUp
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 384
    Top = 8
    object Resetdo1: TMenuItem
      Caption = 'Reset do Usu'#225'rio'
      OnClick = Resetdo1Click
    end
    object ResetGeral1: TMenuItem
      Caption = 'Reset Geral'
      OnClick = ResetGeral1Click
    end
    object Auditoria1: TMenuItem
      Caption = 'Auditoria'
      OnClick = Auditoria1Click
    end
  end
end
