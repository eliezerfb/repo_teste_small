object Form18: TForm18
  Left = 615
  Top = 215
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
  OnCloseQuery = FormCloseQuery
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
    DesignSize = (
      584
      382)
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
      Anchors = [akLeft, akBottom]
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
      Width = 109
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
      Anchors = [akLeft, akTop, akRight, akBottom]
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
      OnCellClick = DBGrid1CellClick
      OnColEnter = DBGrid1ColEnter
      OnColExit = DBGrid1ColExit
      OnDrawDataCell = DBGrid1DrawDataCell
      OnEnter = DBGrid1Enter
      OnExit = DBGrid1Exit
      OnKeyDown = DBGrid1KeyDown
      OnKeyPress = DBGrid1KeyPress
    end
    object cboDocCobranca: TComboBox
      Left = 10
      Top = 305
      Width = 560
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
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
      OnEnter = cboDocCobrancaEnter
      Items.Strings = (
        '<N'#227'o imprimir documento>')
    end
    object Button4: TBitBtn
      Left = 470
      Top = 345
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
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
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = ' '
      Color = clWhite
      TabOrder = 4
      object lbTotalParcelas: TLabel
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
      Anchors = [akLeft, akBottom]
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
    object edtQtdParc: TEdit
      Left = 128
      Top = 24
      Width = 89
      Height = 22
      TabOrder = 6
      Text = '1'
      Visible = False
      OnEnter = edtQtdParcEnter
      OnExit = edtQtdParcExit
      OnKeyDown = SMALL_DBEdit1KeyDown
      OnKeyPress = edtQtdParcKeyPress
    end
  end
  object IBQINSTITUICAOFINANCEIRA: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 328
    Top = 80
  end
  object IBQBANCOS: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 328
    Top = 40
  end
end
