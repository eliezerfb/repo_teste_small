object fFrameCampo: TfFrameCampo
  Left = 0
  Top = 0
  Width = 323
  Height = 23
  Color = clWhite
  Ctl3D = False
  ParentBackground = False
  ParentColor = False
  ParentCtl3D = False
  TabOrder = 0
  DesignSize = (
    323
    23)
  object txtCampo: TEdit
    Left = 0
    Top = 0
    Width = 314
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = txtCampoChange
    OnKeyDown = txtCampoKeyDown
  end
  object gdRegistros: TDBGrid
    Left = 0
    Top = 22
    Width = 314
    Height = 101
    Anchors = [akLeft, akTop, akRight]
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Visible = False
    OnDblClick = gdRegistrosDblClick
    OnKeyDown = gdRegistrosKeyDown
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
