object Form11: TForm11
  Left = 256
  Top = 11
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 741
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 40
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Identificador 1:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label1Click
    OnMouseMove = Label1MouseMove
    OnMouseLeave = Label1MouseLeave
  end
  object Label6: TLabel
    Left = 20
    Top = 10
    Width = 182
    Height = 20
    Caption = 'Ordem de Servi'#231'o: 001'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 20
    Top = 120
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Identificador 2:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label1Click
    OnMouseMove = Label1MouseMove
    OnMouseLeave = Label1MouseLeave
  end
  object Label3: TLabel
    Left = 20
    Top = 200
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Identificador 3:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label1Click
    OnMouseMove = Label1MouseMove
    OnMouseLeave = Label1MouseLeave
  end
  object Label4: TLabel
    Left = 510
    Top = 40
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Identificador 4:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label1Click
    OnMouseMove = Label1MouseMove
    OnMouseLeave = Label1MouseLeave
  end
  object Label5: TLabel
    Left = 510
    Top = 120
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Identificador 5:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = Label1Click
    OnMouseMove = Label1MouseMove
    OnMouseLeave = Label1MouseLeave
  end
  object Edit1: TEdit
    Left = 20
    Top = 62
    Width = 470
    Height = 19
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Button1: TBitBtn
    Left = 454
    Top = 344
    Width = 100
    Height = 40
    Caption = 'Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 0
    Top = 429
    Width = 1008
    Height = 312
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 6
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      ExplicitLeft = -5
      ExplicitHeight = 301
      inherited PAnel1: TPanel
        Top = 5
        ExplicitTop = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object Edit2: TEdit
    Left = 20
    Top = 143
    Width = 470
    Height = 19
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnKeyDown = Edit1KeyDown
  end
  object Edit3: TEdit
    Left = 20
    Top = 223
    Width = 470
    Height = 19
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    OnKeyDown = Edit1KeyDown
  end
  object Edit5: TEdit
    Left = 510
    Top = 143
    Width = 470
    Height = 19
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    OnKeyDown = Edit1KeyDown
  end
  object Edit4: TEdit
    Left = 510
    Top = 63
    Width = 470
    Height = 19
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    OnKeyDown = Edit1KeyDown
  end
end
