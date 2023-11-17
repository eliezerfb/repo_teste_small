object Form30: TForm30
  Left = 644
  Top = 82
  AlphaBlendValue = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Ordem de Servi'#231'o'
  ClientHeight = 802
  ClientWidth = 1089
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1089
    Height = 802
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWhite
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 10
      Top = 5
      Width = 630
      Height = 715
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 15122040
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 44
        Width = 49
        Height = 13
        Caption = 'Atendente'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label3: TLabel
        Left = 260
        Top = 44
        Width = 74
        Height = 13
        Caption = 'Data agendada'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label4: TLabel
        Left = 345
        Top = 44
        Width = 23
        Height = 13
        Caption = 'Hora'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label6: TLabel
        Left = 475
        Top = 44
        Width = 42
        Height = 13
        Caption = 'Situa'#231#227'o'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label5: TLabel
        Left = 410
        Top = 44
        Width = 33
        Height = 13
        Caption = 'Tempo'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label14: TLabel
        Left = 15
        Top = 164
        Width = 95
        Height = 13
        Caption = 'Descri'#231#227'o do objeto'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label15: TLabel
        Left = 440
        Top = 164
        Width = 30
        Height = 13
        Caption = 'Marca'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label16: TLabel
        Left = 15
        Top = 204
        Width = 35
        Height = 13
        Caption = 'Modelo'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label17: TLabel
        Left = 190
        Top = 204
        Width = 24
        Height = 13
        Caption = 'S'#233'rie'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label18: TLabel
        Left = 365
        Top = 204
        Width = 44
        Height = 13
        Caption = 'Voltagem'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label19: TLabel
        Left = 15
        Top = 244
        Width = 96
        Height = 13
        Caption = 'Problema reclamado'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label10: TLabel
        Left = 515
        Top = 584
        Width = 24
        Height = 13
        Caption = 'Frete'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label11: TLabel
        Left = 515
        Top = 663
        Width = 42
        Height = 13
        Caption = 'Total OS'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label12: TLabel
        Left = 30
        Top = 670
        Width = 58
        Height = 13
        Caption = 'Observa'#231#227'o'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label30: TLabel
        Left = 535
        Top = 204
        Width = 80
        Height = 13
        AutoSize = False
        Caption = 'Garantia'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label25: TLabel
        Left = 17
        Top = 14
        Width = 601
        Height = 19
        Alignment = taCenter
        AutoSize = False
        Caption = 'ORDEM DE SERVI'#199'O 000001 '
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
      end
      object Label29: TLabel
        Left = 515
        Top = 624
        Width = 46
        Height = 13
        Caption = 'Desconto'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label8: TLabel
        Left = 15
        Top = 304
        Width = 112
        Height = 13
        Caption = 'Descri'#231#227'o dos produtos'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label27: TLabel
        Left = 350
        Top = 304
        Width = 20
        Height = 13
        Caption = 'Qtd.'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label31: TLabel
        Left = 425
        Top = 304
        Width = 36
        Height = 13
        Caption = 'Unit'#225'rio'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label32: TLabel
        Left = 503
        Top = 304
        Width = 24
        Height = 13
        Caption = 'Total'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label33: TLabel
        Left = 15
        Top = 444
        Width = 110
        Height = 13
        Caption = 'Descri'#231#227'o dos servi'#231'os'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label34: TLabel
        Left = 300
        Top = 444
        Width = 39
        Height = 13
        Caption = 'T'#233'cnico'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label35: TLabel
        Left = 387
        Top = 444
        Width = 20
        Height = 13
        Caption = 'Qtd.'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label36: TLabel
        Left = 439
        Top = 444
        Width = 36
        Height = 13
        Caption = 'Unit'#225'rio'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label37: TLabel
        Left = 516
        Top = 444
        Width = 24
        Height = 13
        Caption = 'Total'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        OnClick = Label15Click
        OnMouseMove = Label14MouseMove
        OnMouseLeave = Label14MouseLeave
      end
      object Label2: TLabel
        Left = 15
        Top = 84
        Width = 32
        Height = 13
        Caption = 'Cliente'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label7: TLabel
        Left = 320
        Top = 84
        Width = 37
        Height = 13
        Caption = 'Contato'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label9: TLabel
        Left = 475
        Top = 84
        Width = 42
        Height = 13
        Caption = 'Telefone'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label38: TLabel
        Left = 15
        Top = 124
        Width = 47
        Height = 13
        Caption = 'Munic'#237'pio'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label39: TLabel
        Left = 270
        Top = 124
        Width = 19
        Height = 13
        Caption = 'Cep'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label40: TLabel
        Left = 375
        Top = 124
        Width = 46
        Height = 13
        Caption = 'Endere'#231'o'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label13: TLabel
        Left = 15
        Top = 584
        Width = 58
        Height = 13
        Caption = 'Observa'#231#227'o'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object SMALL_DBEdit2: TSMALL_DBEdit
        Left = 15
        Top = 59
        Width = 240
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'TECNICO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnChange = SMALL_DBEdit2Change
        OnEnter = SMALL_DBEdit2Enter
        OnExit = SMALL_DBEdit2Exit
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit4: TSMALL_DBEdit
        Left = 260
        Top = 59
        Width = 80
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'DATA_PRO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit5: TSMALL_DBEdit
        Left = 345
        Top = 59
        Width = 60
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'HORA_PRO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit6: TSMALL_DBEdit
        Left = 410
        Top = 59
        Width = 60
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'TEMPO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 3
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit7: TSMALL_DBEdit
        Left = 475
        Top = 59
        Width = 140
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'SITUACAO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 4
        OnChange = SMALL_DBEdit7Change
        OnClick = SMALL_DBEdit7Click
        OnEnter = SMALL_DBEdit7Enter
        OnExit = SMALL_DBEdit7Exit
        OnKeyDown = SMALL_DBEdit7KeyDown
      end
      object SMALL_DBEdit3: TSMALL_DBEdit
        Left = 15
        Top = 99
        Width = 300
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'CLIENTE'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 5
        OnChange = SMALL_DBEdit3Change
        OnEnter = SMALL_DBEdit3Enter
        OnExit = SMALL_DBEdit3Exit
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit8: TSMALL_DBEdit
        Left = 320
        Top = 99
        Width = 150
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'CONTATO'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 6
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit10: TSMALL_DBEdit
        Left = 475
        Top = 99
        Width = 140
        Height = 22
        BevelInner = bvNone
        Color = clWhite
        Ctl3D = False
        DataField = 'FONE'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 7
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit9: TSMALL_DBEdit
        Left = 515
        Top = 599
        Width = 100
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'TOTAL_FRET'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 18
        OnChange = SMALL_DBEdit3Change
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit11: TSMALL_DBEdit
        Left = 515
        Top = 678
        Width = 100
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'TOTAL_OS'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 20
        OnChange = SMALL_DBEdit3Change
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit11KeyDown
      end
      object SMALL_DBEdit13: TSMALL_DBEdit
        Left = 535
        Top = 219
        Width = 80
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'GARANTIA'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 13
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object DBGrid1: TDBGrid
        Left = 15
        Top = 319
        Width = 600
        Height = 120
        Color = clWhite
        Ctl3D = False
        DataSource = Form7.DataSource16
        FixedColor = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgEditing, dgColumnResize, dgColLines, dgTabs, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 15
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        OnColExit = DBGrid1ColExit
        OnEnter = DBGrid1Enter
        OnKeyDown = DBGrid1KeyDown
        OnKeyPress = DBGrid1KeyPress
        OnKeyUp = DBGrid1KeyUp
      end
      object DBGrid2: TDBGrid
        Left = 15
        Top = 459
        Width = 600
        Height = 120
        Color = clWhite
        Ctl3D = False
        DataSource = Form7.DataSource35
        FixedColor = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgEditing, dgColumnResize, dgColLines, dgTabs, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 16
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        OnColEnter = DBGrid2ColEnter
        OnColExit = DBGrid2ColExit
        OnEnter = DBGrid2Enter
        OnKeyDown = DBGrid2KeyDown
        OnKeyPress = DBGrid2KeyPress
        OnKeyUp = DBGrid2KeyUp
      end
      object SMALL_DBEdit19: TSMALL_DBEdit
        Left = 515
        Top = 639
        Width = 100
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'DESCONTO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 19
        OnChange = SMALL_DBEdit3Change
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit20: TSMALL_DBEdit
        Left = 15
        Top = 139
        Width = 250
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'CIDADE'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 24
        OnChange = SMALL_DBEdit3Change
        OnEnter = SMALL_DBEdit3Enter
        OnExit = SMALL_DBEdit3Exit
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit21: TSMALL_DBEdit
        Left = 270
        Top = 139
        Width = 100
        Height = 22
        Color = clWhite
        Ctl3D = False
        DataField = 'CEP'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 25
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object SMALL_DBEdit22: TSMALL_DBEdit
        Left = 375
        Top = 139
        Width = 240
        Height = 22
        BevelInner = bvNone
        Color = clWhite
        Ctl3D = False
        DataField = 'ENDERE'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 26
        OnEnter = SMALL_DBEdit4Enter
        OnKeyDown = SMALL_DBEdit2KeyDown
      end
      object DBMemo1: TDBMemo
        Left = 15
        Top = 259
        Width = 600
        Height = 40
        Color = clWhite
        DataField = 'PROBLEMA'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        MaxLength = 254
        ParentFont = False
        TabOrder = 14
        OnChange = DBMemo1Change
        OnEnter = DBMemo1Enter
        OnExit = DBMemo1Exit
        OnKeyUp = DBMemo1KeyUp
      end
      object DBMemo2: TDBMemo
        Left = 15
        Top = 599
        Width = 495
        Height = 100
        Color = clWhite
        DataField = 'OBSERVACAO'
        DataSource = Form7.DataSource3
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        MaxLength = 254
        ParentFont = False
        TabOrder = 17
        OnEnter = DBMemo2Enter
        OnKeyUp = DBMemo1KeyUp
      end
      object ListBox1: TListBox
        Left = 475
        Top = 80
        Width = 140
        Height = 5
        BevelInner = bvNone
        Color = 15790320
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ItemHeight = 13
        Items.Strings = (
          'Agendada'
          'Aberta'
          'Fechada')
        ParentFont = False
        TabOrder = 22
        Visible = False
        OnClick = ListBox1Click
        OnDblClick = ListBox1DblClick
        OnKeyDown = ListBox1KeyDown
      end
      object ListBox2: TListBox
        Left = 400
        Top = 201
        Width = 175
        Height = 5
        BevelInner = bvNone
        Color = 15790320
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 23
        Visible = False
        OnClick = ListBox2Click
      end
      inline framePesquisaServOS: TframePesquisaServico
        Left = 15
        Top = 578
        Width = 600
        Height = 7
        TabOrder = 27
        Visible = False
        inherited pnlPrincipal: TPanel
          Width = 600
          Height = 7
          inherited dbgItensPesq: TDBGrid
            Width = 600
            Height = 7
            OnCellClick = framePesquisaServOSdbgItensPesqCellClick
            OnKeyDown = framePesquisaServOSdbgItensPesqKeyDown
            OnKeyPress = framePesquisaServOSdbgItensPesqKeyPress
          end
        end
      end
      inline fFrameIdentifi1: TfFrameCampo
        Left = 440
        Top = 179
        Width = 175
        Height = 22
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 9
        inherited txtCampo: TEdit
          Width = 175
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          OnEnter = fFrameIdentifi1txtCampoEnter
        end
        inherited gdRegistros: TDBGrid
          Top = 21
          Width = 175
          Font.Height = -11
        end
      end
      inline fFrameDescricao: TfFrameCampo
        Left = 15
        Top = 179
        Width = 420
        Height = 25
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 8
        inherited txtCampo: TEdit
          Width = 420
          OnEnter = fFrameDescricaotxtCampoEnter
        end
        inherited gdRegistros: TDBGrid
          Top = 21
          Width = 420
          Font.Height = -11
          OnDblClick = fFrameDescricaogdRegistrosDblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME'
              Width = 400
              Visible = True
            end>
        end
      end
      inline fFrameIdentifi2: TfFrameCampo
        Left = 15
        Top = 219
        Width = 170
        Height = 24
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 10
        inherited txtCampo: TEdit
          Width = 170
          OnEnter = fFrameIdentifi2txtCampoEnter
        end
        inherited gdRegistros: TDBGrid
          Top = 21
          Width = 170
          Font.Height = -11
        end
      end
      inline fFrameIdentifi3: TfFrameCampo
        Left = 190
        Top = 219
        Width = 170
        Height = 25
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 11
        inherited txtCampo: TEdit
          Width = 170
          OnEnter = fFrameIdentifi3txtCampoEnter
        end
        inherited gdRegistros: TDBGrid
          Top = 21
          Width = 170
          Font.Height = -11
        end
      end
      inline fFrameIdentifi4: TfFrameCampo
        Left = 365
        Top = 219
        Width = 165
        Height = 22
        Color = clWhite
        Ctl3D = False
        ParentBackground = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 12
        inherited txtCampo: TEdit
          Width = 165
          OnEnter = fFrameIdentifi4txtCampoEnter
        end
        inherited gdRegistros: TDBGrid
          Top = 21
          Width = 165
          Font.Height = -11
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME'
              Width = 150
              Visible = True
            end>
        end
      end
      object DBGrid3: TDBGrid
        Left = 15
        Top = 118
        Width = 300
        Height = 10
        Color = 15790320
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgColLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        ParentFont = False
        TabOrder = 21
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnDblClick = DBGrid3DblClick
        OnKeyDown = DBGrid3KeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            Title.Caption = 'Prateleira'
            Visible = False
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end>
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 724
      Width = 660
      Height = 40
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object Button1: TBitBtn
        Left = 540
        Top = 0
        Width = 99
        Height = 30
        Caption = 'Ok'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object PopupMenu3: TPopupMenu
    AutoHotkeys = maManual
    Left = 256
    Top = 22
    object Incluirnovoitemnoestoque1: TMenuItem
      Caption = 'Incluir novo item no estoque...'
      OnClick = Incluirnovoitemnoestoque1Click
    end
    object Incluirnovocliente1: TMenuItem
      Caption = 'Incluir novo cliente...'
      OnClick = Incluirnovocliente1Click
    end
  end
end
