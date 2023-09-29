object fFrameCampo: TfFrameCampo
  Left = 0
  Top = 0
  Width = 323
  Height = 22
  Color = clWhite
  Ctl3D = False
  ParentBackground = False
  ParentColor = False
  ParentCtl3D = False
  TabOrder = 0
  OnExit = FrameExit
  DesignSize = (
    323
    22)
  object txtCampo: TEdit
    Left = 0
    Top = 0
    Width = 323
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = txtCampoChange
    OnClick = txtCampoClick
    OnEnter = txtCampoEnter
    OnKeyDown = txtCampoKeyDown
  end
  object gdRegistros: TDBGrid
    Left = 0
    Top = 22
    Width = 323
    Height = 102
    Anchors = [akLeft, akTop, akRight]
    DataSource = DataSource
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Visible = False
    OnDblClick = gdRegistrosDblClick
    OnKeyDown = gdRegistrosKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'NOME'
        Visible = True
      end>
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 64
  end
  object Query: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 100
    CachedUpdates = False
    Left = 100
    Top = 65535
  end
end
