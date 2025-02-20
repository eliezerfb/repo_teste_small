object Senhas2: TSenhas2
  Left = 452
  Top = 538
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Senha'
  ClientHeight = 161
  ClientWidth = 384
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = [fsBold]
  OnActivate = FormActivate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 161
    Align = alClient
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Color = 16042061
    Ctl3D = False
    ParentBiDiMode = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Label4: TLabel
      Left = 20
      Top = 30
      Width = 50
      Height = 16
      Caption = 'Usu'#225'rio:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 20
      Top = 100
      Width = 42
      Height = 16
      Caption = 'Senha:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object USUARIO: TEdit
      Left = 20
      Top = 50
      Width = 350
      Height = 21
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvSpace
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'Administrador'
      OnKeyUp = FormKeyUp
    end
    object SENHA: TEdit
      Left = 20
      Top = 120
      Width = 350
      Height = 21
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvSpace
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      OnKeyDown = SENHAKeyDown
      OnKeyUp = FormKeyUp
    end
    object Button2: TButton
      Left = 60
      Top = 200
      Width = 180
      Height = 40
      Caption = 'Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 270
      Top = 200
      Width = 180
      Height = 40
      Caption = 'Ok'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnClick = Button1Click
    end
  end
end
