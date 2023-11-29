inherited FrmAnexosOS: TFrmAnexosOS
  Left = 584
  Top = 293
  BorderIcons = [biSystemMenu]
  Caption = 'Anexos da Ordem de Servi'#231'o'
  ClientHeight = 432
  ClientWidth = 823
  PixelsPerInch = 96
  TextHeight = 16
  object Image5: TImage
    Left = 404
    Top = 11
    Width = 401
    Height = 358
    Center = True
    Stretch = True
  end
  object dbgPrincipal: TDBGrid
    Left = 14
    Top = 11
    Width = 379
    Height = 402
    BiDiMode = bdLeftToRight
    Color = clWhite
    Ctl3D = False
    DataSource = DSAnexosOS
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -12
    TitleFont.Name = 'Microsoft Sans Serif'
    TitleFont.Pitch = fpFixed
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'NOME'
        Width = 300
        Visible = True
      end>
  end
  object Button22: TBitBtn
    Left = 677
    Top = 388
    Width = 130
    Height = 25
    Caption = '&Selecionar arquivo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button13: TBitBtn
    Left = 540
    Top = 388
    Width = 130
    Height = 25
    Caption = '&Webcam'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 404
    Top = 388
    Width = 130
    Height = 25
    Caption = '&Inserir'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object DSAnexosOS: TDataSource
    DataSet = ibdAnexosOS
    Left = 568
    Top = 30
  end
  object ibdAnexosOS: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from OSANEXOS'
      'where'
      '  IDANEXO= :OLD_IDANEXO')
    InsertSQL.Strings = (
      'insert into OSANEXOS'
      '  (IDANEXO,IDOS,NOME,ANEXO)'
      'values'
      '  (:IDANEXO,:IDOS,:NOME,:ANEXO)')
    RefreshSQL.Strings = (
      'Select '
      '  IDANEXO,'
      '  IDOS,'
      '  NOME,'
      '  ANEXO'
      'from OSANEXOS '
      'where'
      '  IDANEXO= :IDANEXO')
    SelectSQL.Strings = (
      'select * from OSANEXOS')
    ModifySQL.Strings = (
      'update OSANEXOS'
      'set'
      '  IDANEXO=:IDANEXO,'
      '  IDOS=:IDOS,'
      '  NOME=:NOME,'
      '  ANEXO=:ANEXO'
      'where'
      '  IDANEXO= :OLD_IDANEXO')
    Filtered = True
    Left = 536
    Top = 30
    object ibdAnexosOSIDANEXO: TIntegerField
      FieldName = 'IDANEXO'
      Origin = 'OSANEXOS.IDANEXO'
      Required = True
    end
    object ibdAnexosOSIDOS: TIntegerField
      FieldName = 'IDOS'
      Origin = 'OSANEXOS.IDOS'
      Required = True
    end
    object ibdAnexosOSNOME: TIBStringField
      FieldName = 'NOME'
      Origin = 'OSANEXOS.NOME'
      Required = True
      Size = 100
    end
    object ibdAnexosOSANEXO: TMemoField
      FieldName = 'ANEXO'
      Origin = 'OSANEXOS.ANEXO'
      Required = True
      BlobType = ftMemo
      Size = 8
    end
  end
end
