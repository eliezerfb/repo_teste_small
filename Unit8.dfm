object Form8: TForm8
  Left = 306
  Top = 170
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Transfer'#234'ncia de mesas'
  ClientHeight = 342
  ClientWidth = 514
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    514
    342)
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 42
    Height = 13
    Caption = 'Da mesa'
  end
  object Label2: TLabel
    Left = 440
    Top = 10
    Width = 50
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Para mesa'
  end
  object lbTotalTransferencia: TLabel
    Left = 351
    Top = 296
    Width = 147
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Total da transfer'#234'ncia: R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TBitBtn
    Left = 14
    Top = 284
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Cancelar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TBitBtn
    Left = 108
    Top = 284
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Ok'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cbMesaOrigem: TComboBox
    Left = 15
    Top = 25
    Width = 60
    Height = 24
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = cbMesaOrigemChange
    OnExit = cbMesaOrigemExit
  end
  object cbMesaDestino: TComboBox
    Left = 440
    Top = 25
    Width = 60
    Height = 24
    Style = csDropDownList
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object GridOrigem: TStringGrid
    Left = 15
    Top = 55
    Width = 484
    Height = 219
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 6
    DefaultRowHeight = 18
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    TabOrder = 4
    OnDrawCell = GridOrigemDrawCell
    OnKeyDown = GridOrigemKeyDown
    OnKeyPress = GridOrigemKeyPress
    OnMouseDown = GridOrigemMouseDown
    OnSelectCell = GridOrigemSelectCell
    OnSetEditText = GridOrigemSetEditText
    ColWidths = (
      17
      44
      259
      63
      75
      64)
  end
  object CheckTodosOrigem: TCheckBox
    Left = 19
    Top = 58
    Width = 13
    Height = 14
    Hint = 'Marca/Desmarca todos itens listados'
    Color = clBtnFace
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = CheckTodosOrigemClick
  end
  object IBQuery1: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 224
    Top = 24
  end
end
