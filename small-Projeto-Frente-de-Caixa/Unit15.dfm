object Form15: TForm15
  Left = 332
  Top = 229
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Senha'
  ClientHeight = 212
  ClientWidth = 504
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 504
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    ParentBiDiMode = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      504
      212)
    object Label5: TLabel
      Left = 95
      Top = 60
      Width = 57
      Height = 20
      Caption = 'Senha:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label4: TLabel
      Left = 95
      Top = 0
      Width = 67
      Height = 20
      Caption = 'Usu'#225'rio:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object LabelF10Indisponivel: TLabel
      Left = 8
      Top = 184
      Width = 489
      Height = 19
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'Menu Fiscal Indispon'#237'vel nesta tela'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Usuario: TComboBox
      Left = 95
      Top = 25
      Width = 310
      Height = 28
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnExit = UsuarioExit
      OnKeyDown = UsuarioKeyDown
      OnKeyUp = UsuarioKeyUp
    end
    object SENHA: TEdit
      Left = 95
      Top = 85
      Width = 310
      Height = 21
      HelpContext = 3
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      OnClick = SENHAClick
      OnEnter = SENHAEnter
      OnKeyDown = SENHAKeyDown
    end
    object Button1: TBitBtn
      Left = 270
      Top = 135
      Width = 140
      Height = 40
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TBitBtn
      Left = 95
      Top = 135
      Width = 140
      Height = 40
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button2Click
    end
  end
end
