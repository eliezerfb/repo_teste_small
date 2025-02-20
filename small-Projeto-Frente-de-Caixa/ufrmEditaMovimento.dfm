object FEditaMovimento: TFEditaMovimento
  Left = 446
  Top = 23
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FEditaMovimento'
  ClientHeight = 741
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbTotal: TLabel
    Left = 948
    Top = 328
    Width = 53
    Height = 29
    Alignment = taRightJustify
    Caption = '0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -25
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbAlerta: TLabel
    Left = 22
    Top = 328
    Width = 257
    Height = 13
    Caption = '*Produto composto, ou com grade ou controle de s'#233'rie'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object btnOk: TBitBtn
    Left = 462
    Top = 360
    Width = 100
    Height = 40
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnOkClick
  end
  object Panel2: TPanel
    Left = 2
    Top = 431
    Width = 1008
    Height = 312
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      ExplicitLeft = -5
      ExplicitHeight = 301
      inherited PAnel1: TPanel
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 24
    Top = 384
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 2
  end
  object DBGridItens: TDBGrid
    Left = 20
    Top = 32
    Width = 981
    Height = 289
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnCellClick = DBGridItensCellClick
    OnColEnter = DBGridItensColEnter
    OnDrawColumnCell = DBGridItensDrawColumnCell
    OnKeyDown = DBGridItensKeyDown
    OnKeyPress = DBGridItensKeyPress
    OnKeyUp = DBGridItensKeyUp
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'ITEM'
        Title.Caption = 'Item'
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 427
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        ReadOnly = False
        Title.Caption = 'Quantidade'
        Width = 154
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UNITARIO'
        ReadOnly = False
        Title.Caption = 'Valor Unit'#225'rio R$'
        Width = 144
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Title.Caption = 'Total R$'
        Width = 171
        Visible = True
      end>
  end
  object DataSource1: TDataSource
    DataSet = Form1.ibDataSet27
    OnDataChange = DataSource1DataChange
    Left = 184
    Top = 160
  end
  object CDSALTERACA: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 280
    Top = 208
  end
end
