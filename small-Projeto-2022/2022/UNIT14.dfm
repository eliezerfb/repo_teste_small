object Form14: TForm14
  Left = 718
  Top = 139
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Assistente de relat'#243'rios'
  ClientHeight = 212
  ClientWidth = 392
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image2: TImage
      Left = 47
      Top = 39
      Width = 70
      Height = 70
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label1: TLabel
      Left = 200
      Top = 10
      Width = 156
      Height = 13
      Caption = 'Selecione as colunas do relat'#243'rio'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 200
      Top = 26
      Width = 84
      Height = 13
      Caption = 'na janela ao lado.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 200
      Top = 50
      Width = 161
      Height = 13
      Caption = 'Clique <Avan'#231'ar>  para continuar.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 205
      Top = 72
      Width = 180
      Height = 45
      Visible = False
    end
    object Button2: TButton
      Left = 23
      Top = 170
      Width = 100
      Height = 25
      Caption = 'Configura'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 146
      Top = 170
      Width = 100
      Height = 23
      Caption = 'Avan'#231'ar>'
      DragCursor = crDefault
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 270
      Top = 170
      Width = 100
      Height = 23
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
  end
end
