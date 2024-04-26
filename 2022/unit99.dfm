object Form99: TForm99
  Left = 336
  Top = 163
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Definir uma senha '
  ClientHeight = 161
  ClientWidth = 484
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 161
    Align = alClient
    BevelOuter = bvNone
    Color = 16042061
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 10
      Width = 369
      Height = 20
      Caption = 'Confirme a senha digitada. Memorize-a, e mantenha'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 30
      Width = 79
      Height = 20
      Caption = 'o segredo. '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 102
      Top = 60
      Width = 88
      Height = 20
      Alignment = taRightJustify
      Caption = '&Nova senha:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 31
      Top = 110
      Width = 159
      Height = 20
      Alignment = taRightJustify
      Caption = '&Confirmar nova senha:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 200
      Top = 60
      Width = 220
      Height = 32
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvSpace
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      OnExit = Edit1Exit
      OnKeyDown = Edit1KeyDown
      OnKeyUp = Edit1KeyUp
    end
    object Edit2: TEdit
      Left = 200
      Top = 110
      Width = 220
      Height = 32
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvSpace
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      OnExit = Edit2Exit
      OnKeyDown = Edit2KeyDown
      OnKeyUp = Edit2KeyUp
    end
    object Button2: TButton
      Left = 50
      Top = 180
      Width = 200
      Height = 30
      Caption = 'Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 270
      Top = 180
      Width = 200
      Height = 30
      Caption = 'OK'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
  end
end
