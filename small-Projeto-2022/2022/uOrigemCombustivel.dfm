object frmOrigemCombustivel: TfrmOrigemCombustivel
  Left = 261
  Top = 124
  Width = 326
  Height = 318
  Caption = 'frmOrigemCombustivel'
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    310
    279)
  PixelsPerInch = 96
  TextHeight = 13
  object lbLegenda: TLabel
    Left = 9
    Top = 239
    Width = 137
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '* Os campos s'#227'o obrigat'#243'rios'
  end
  object GridOrigem: TDBGrid
    Left = 8
    Top = 32
    Width = 295
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DSORIGEM
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = GridOrigemDrawColumnCell
    OnExit = GridOrigemExit
    OnKeyDown = GridOrigemKeyDown
    OnKeyPress = GridOrigemKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'INDIMPORT'
        Title.Caption = 'Indicador'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UFORIGEM'
        Title.Caption = 'UF Origem'
        Width = 86
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PORIGEM'
        Title.Caption = 'Percentual'
        Visible = True
      end>
  end
  object btnOk: TBitBtn
    Left = 227
    Top = 248
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 1
  end
  object CDSORIGEM: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 56
    object CDSORIGEMINDIMPORT: TIntegerField
      FieldName = 'INDIMPORT'
      DisplayFormat = '0'
      EditFormat = '0'
    end
    object CDSORIGEMUFORIGEM: TStringField
      FieldName = 'UFORIGEM'
      Size = 2
    end
    object CDSORIGEMPORIGEM: TFloatField
      FieldName = 'PORIGEM'
    end
  end
  object DSORIGEM: TDataSource
    DataSet = CDSORIGEM
    Left = 96
    Top = 56
  end
end
