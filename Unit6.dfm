object Form6: TForm6
  Left = 630
  Top = 32
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 594
  ClientWidth = 274
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 19
    Top = 50
    Width = 87
    Height = 13
    Caption = 'Desconto em %'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 19
    Top = 101
    Width = 94
    Height = 13
    Caption = 'Desconto em R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 19
    Top = 153
    Width = 91
    Height = 13
    Caption = 'Acr'#233'scimo em %'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 19
    Top = 203
    Width = 98
    Height = 13
    Caption = 'Acr'#233'scimo em R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbTotalPagar: TLabel
    Left = 19
    Top = 0
    Width = 78
    Height = 13
    Caption = 'Total A Pagar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object SMALL_DBEdit1: TSMALL_DBEdit
    Left = 19
    Top = 65
    Width = 227
    Height = 31
    Color = clWhite
    Ctl3D = False
    DataField = 'VALOR_1'
    DataSource = Form1.DataSource25
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnEnter = SMALL_DBEdit1Enter
    OnExit = SMALL_DBEdit1Exit
    OnKeyDown = SMALL_DBEdit1KeyDown
  end
  object SMALL_DBEdit2: TSMALL_DBEdit
    Left = 19
    Top = 116
    Width = 227
    Height = 31
    Color = clWhite
    Ctl3D = False
    DataField = 'VALOR_2'
    DataSource = Form1.DataSource25
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    OnExit = SMALL_DBEdit2Exit
    OnKeyDown = SMALL_DBEdit1KeyDown
  end
  object Button1: TBitBtn
    Left = 18
    Top = 252
    Width = 100
    Height = 40
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TBitBtn
    Left = 147
    Top = 252
    Width = 100
    Height = 40
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button2Click
  end
  object SMALL_DBEdit3: TSMALL_DBEdit
    Left = 19
    Top = 168
    Width = 227
    Height = 31
    Color = clWhite
    Ctl3D = False
    DataField = 'VALOR_3'
    DataSource = Form1.DataSource25
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    OnExit = SMALL_DBEdit3Exit
    OnKeyDown = SMALL_DBEdit1KeyDown
  end
  object SMALL_DBEdit4: TSMALL_DBEdit
    Left = 19
    Top = 218
    Width = 227
    Height = 31
    Color = clWhite
    Ctl3D = False
    DataField = 'VALOR_4'
    DataSource = Form1.DataSource25
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    OnExit = SMALL_DBEdit4Exit
    OnKeyDown = SMALL_DBEdit1KeyDown
  end
  object Panel2: TPanel
    Left = -1
    Top = 292
    Width = 514
    Height = 305
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 7
    inline Frame_teclado1: TFrame_teclado
      Left = 1
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      inherited PAnel1: TPanel
        Left = -758
        Top = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object edTotalPagar: TEdit
    Left = 19
    Top = 15
    Width = 227
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '0,00'
    Visible = False
    OnExit = edTotalPagarExit
    OnKeyDown = edTotalPagarKeyDown
  end
end
