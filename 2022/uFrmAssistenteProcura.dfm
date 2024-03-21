object FrmAssistenteProcura: TFrmAssistenteProcura
  Left = 313
  Top = 696
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Assistente de procura'
  ClientHeight = 220
  ClientWidth = 450
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 220
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitWidth = 447
    ExplicitHeight = 202
    object Image1: TImage
      Left = 42
      Top = 30
      Width = 70
      Height = 70
      AutoSize = True
      Stretch = True
      Transparent = True
    end
    object Label3: TLabel
      Left = 150
      Top = 20
      Width = 210
      Height = 13
      Caption = 'Digite a informa'#231#227'o a ser localizada e clique '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 150
      Top = 35
      Width = 127
      Height = 13
      Caption = #39'Avan'#231'ar'#39' ou tecle <enter>.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 150
      Top = 60
      Width = 23
      Height = 13
      Caption = 'com:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 150
      Top = 80
      Width = 229
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      OnEnter = Edit1Enter
      OnKeyDown = Edit1KeyDown
      OnKeyPress = Edit1KeyPress
    end
    object MemoPesquisa: TMemo
      Left = 150
      Top = 110
      Width = 229
      Height = 45
      BorderStyle = bsNone
      Color = clBtnHighlight
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Visible = False
      OnKeyDown = MemoPesquisaKeyDown
    end
    object Button3: TButton
      Left = 19
      Top = 177
      Width = 100
      Height = 24
      Caption = '< &Anterior'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button1: TButton
      Left = 123
      Top = 177
      Width = 100
      Height = 24
      Caption = '&Pr'#243'ximo >'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 227
      Top = 177
      Width = 100
      Height = 24
      Caption = '&OK'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button2: TButton
      Left = 331
      Top = 177
      Width = 100
      Height = 24
      Cursor = crArrow
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button2Click
    end
    object Panel1: TPanel
      Left = 150
      Top = 10
      Width = 280
      Height = 145
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 6
      Visible = False
      object Label8: TLabel
        Left = 0
        Top = 20
        Width = 45
        Height = 13
        Caption = 'Localizar:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 0
        Top = 68
        Width = 64
        Height = 13
        Caption = 'Substituir por:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Edit2: TEdit
        Left = 0
        Top = 40
        Width = 229
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnKeyDown = Edit2KeyDown
        OnKeyPress = Edit1KeyPress
      end
      object Edit3: TEdit
        Left = 0
        Top = 88
        Width = 229
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        OnKeyDown = Edit3KeyDown
        OnKeyPress = Edit1KeyPress
      end
    end
  end
end
