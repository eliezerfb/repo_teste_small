inherited frmRelatorioNotasFaltantes: TfrmRelatorioNotasFaltantes
  Caption = 'Notas faltantes'
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPrincipal: TPanel
    Left = 180
    Top = 15
    Width = 241
    Height = 187
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 3
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 53
      Height = 13
      Caption = 'Per'#237'odo de'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 0
      Top = 45
      Width = 16
      Height = 13
      Caption = 'At'#233
    end
    object dtInicial: TDateTimePicker
      Left = 0
      Top = 15
      Width = 212
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object dtFinal: TDateTimePicker
      Left = 0
      Top = 60
      Width = 212
      Height = 21
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object cdsNotasFaltantes: TClientDataSet
    PersistDataPacket.Data = {
      610000009619E0BD0100000018000000030000000000030000006100084E554D
      45524F4E460100490000000100055749445448020002000C0005534552494501
      00490000000100055749445448020002000300075449504F444F430400010000
      0000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NUMERONF'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'SERIE'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'TIPODOC'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 72
    Top = 136
    object cdsNotasFaltantesNUMERONF: TStringField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERONF'
      Size = 12
    end
    object cdsNotasFaltantesSERIE: TStringField
      DisplayLabel = 'S'#233'rie'
      FieldName = 'SERIE'
      Size = 3
    end
    object cdsNotasFaltantesTIPODOC: TIntegerField
      FieldName = 'TIPODOC'
      Visible = False
    end
  end
  object cdsNotasPendentes: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'NUMERONF'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'STATUS'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'TIPODOC'
        DataType = ftInteger
      end
      item
        Name = 'SERIE'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'DATA'
        DataType = ftDate
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 72
    Top = 208
    object cdsNotasPendentesNUMERONF: TStringField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERONF'
      Size = 12
    end
    object cdsNotasPendentesSERIE: TStringField
      DisplayLabel = 'S'#233'rie'
      FieldName = 'SERIE'
      Size = 3
    end
    object cdsNotasPendentesDATA: TDateField
      DisplayLabel = 'Emiss'#227'o'
      FieldName = 'DATA'
    end
    object cdsNotasPendentesSTATUS: TStringField
      DisplayLabel = 'Status'
      DisplayWidth = 200
      FieldName = 'STATUS'
      Size = 250
    end
    object cdsNotasPendentesTIPODOC: TIntegerField
      FieldName = 'TIPODOC'
      Visible = False
    end
  end
end
