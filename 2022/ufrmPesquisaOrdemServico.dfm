inherited FrmPesquisaOrdemServico: TFrmPesquisaOrdemServico
  Left = 557
  Top = 358
  Caption = 'Ordem Servi'#231'o'
  PixelsPerInch = 96
  TextHeight = 16
  inherited dbGridPrincipal: TDBGrid
    OnDrawColumnCell = dbGridPrincipalDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'NUMERO'
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CLIENTE'
        Width = 363
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TECNICO'
        Width = 197
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL_OS'
        Width = 69
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NF'
        Width = 103
        Visible = True
      end>
  end
  inherited IBQPESQUISA: TIBQuery
    SQL.Strings = (
      'Select '
      #9'NUMERO,'
      #9'DATA,'
      #9'CLIENTE,'#9#9
      #9'TECNICO,'
      #9'TOTAL_OS,'
      #9'NF'
      'From OS'
      'Order By DATA desc, NUMERO desc')
    object IBQPESQUISANUMERO: TIBStringField
      DisplayLabel = 'N'#250'mero OS'
      FieldName = 'NUMERO'
      Origin = 'OS.NUMERO'
      Size = 10
    end
    object IBQPESQUISADATA: TDateField
      DisplayLabel = 'Data'
      FieldName = 'DATA'
      Origin = 'OS.DATA'
    end
    object IBQPESQUISACLIENTE: TIBStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE'
      Origin = 'OS.CLIENTE'
      Size = 60
    end
    object IBQPESQUISATECNICO: TIBStringField
      DisplayLabel = 'T'#233'cnico'
      FieldName = 'TECNICO'
      Origin = 'OS.TECNICO'
      Size = 60
    end
    object IBQPESQUISATOTAL_OS: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL_OS'
      Origin = 'OS.TOTAL_OS'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object IBQPESQUISANF: TIBStringField
      DisplayLabel = 'Doc. Fiscal'
      FieldName = 'NF'
      Origin = 'OS.NF'
      Size = 12
    end
  end
end
