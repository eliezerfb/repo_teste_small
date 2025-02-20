object Form18: TForm18
  Left = 341
  Top = 173
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Desdobramento das contas'
  ClientHeight = 382
  ClientWidth = 584
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 382
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label4: TLabel
      Left = 10
      Top = 10
      Width = 74
      Height = 13
      Caption = 'Quantas vezes:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 10
      Top = 290
      Width = 121
      Height = 13
      Caption = 'Documento de cobran'#231'a:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SMALL_DBEdit1: TSMALL_DBEdit
      Left = 10
      Top = 25
      Width = 140
      Height = 22
      BevelInner = bvNone
      Ctl3D = False
      DataField = 'DUPLICATAS'
      DataSource = Form7.DataSource15
      ParentCtl3D = False
      TabOrder = 0
      OnEnter = SMALL_DBEdit1Enter
      OnExit = SMALL_DBEdit1Exit
      OnKeyDown = SMALL_DBEdit1KeyDown
    end
    object DBGrid1: TDBGrid
      Left = 10
      Top = 60
      Width = 560
      Height = 200
      Ctl3D = False
      DataSource = Form7.DataSource7
      FixedColor = clWindow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Microsoft Sans Serif'
      TitleFont.Style = []
      OnColEnter = DBGrid1ColEnter
      OnDrawDataCell = DBGrid1DrawDataCell
      OnEnter = DBGrid1Enter
      OnKeyDown = DBGrid1KeyDown
      OnKeyPress = DBGrid1KeyPress
    end
    object ComboBox1: TComboBox
      Left = 10
      Top = 305
      Width = 560
      Height = 21
      Style = csDropDownList
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Items.Strings = (
        '<N'#227'o imprimir documento>')
    end
    object Button4: TBitBtn
      Left = 470
      Top = 345
      Width = 100
      Height = 25
      Caption = '&Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button4Click
    end
    object Panel9: TPanel
      Left = 10
      Top = 259
      Width = 560
      Height = 22
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = ' '
      Color = clWhite
      TabOrder = 4
      object Label45: TLabel
        Left = 239
        Top = 1
        Width = 28
        Height = 16
        Alignment = taRightJustify
        Caption = '0,00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 345
      Width = 343
      Height = 17
      Caption = 
        'Enviar NF-e, Consultar e Imprimir DANFE antes do doc de  cobran'#231 +
        'a'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Visible = False
      OnClick = CheckBox1Click
    end
  end
end
