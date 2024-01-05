object Form33: TForm33
  Left = 411
  Top = 260
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Mala direta'
  ClientHeight = 212
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image1: TImage
      Left = 15
      Top = 15
      Width = 118
      Height = 158
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label5: TLabel
      Left = 200
      Top = 15
      Width = 214
      Height = 13
      Caption = 'O texto usado na carta pode ser alterado  na '
    end
    object Label7: TLabel
      Left = 300
      Top = 30
      Width = 103
      Height = 13
      Caption = 'Carta para mala direta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label7Click
    end
    object Label3: TLabel
      Left = 200
      Top = 54
      Width = 206
      Height = 13
      Caption = 'Use a op'#231#227'o filtro para escolher quem deve'
    end
    object Label4: TLabel
      Left = 200
      Top = 70
      Width = 75
      Height = 13
      Caption = 'receber a carta.'
    end
    object Label1: TLabel
      Left = 200
      Top = 100
      Width = 210
      Height = 13
      Caption = 'Clique no bot'#227'o <imprimir> para  imprimir uma'
    end
    object Label2: TLabel
      Left = 200
      Top = 116
      Width = 215
      Height = 13
      Caption = 'carta para cada cliente ou fornecedor filtrado.'
    end
    object Label6: TLabel
      Left = 200
      Top = 30
      Width = 94
      Height = 13
      Caption = 'clicando  na op'#231#227'o:'
    end
    object Button4: TButton
      Left = 200
      Top = 170
      Width = 100
      Height = 25
      Caption = 'Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button2: TButton
      Left = 310
      Top = 170
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 88
      Top = 170
      Width = 100
      Height = 25
      Caption = 'Visualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
  end
end
