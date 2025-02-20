inherited FrmPesquisaOrcamento: TFrmPesquisaOrcamento
  Left = 242
  Top = 133
  Caption = 'Or'#231'amento'
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  inherited lblTitulo2: TLabel
    Caption = 'N'#250'mero do or'#231'amento, nome do cliente ou vendedor:'
  end
  inherited dbGridPrincipal: TDBGrid
    OnDrawColumnCell = dbGridPrincipalDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'PEDIDO'
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
        FieldName = 'CLIFOR'
        Width = 363
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VENDEDOR'
        Width = 190
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Width = 69
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NUMERONF'
        Width = 110
        Visible = True
      end>
  end
  inherited IBQPESQUISA: TIBQuery
    SQL.Strings = (
      'Select'
      #9'PEDIDO, '
      #9'DATA, '
      #9'CLIFOR, '
      #9'VENDEDOR, '
      #9'TOTAL, '
      #9'NUMERONF'
      'From'
      #9'(Select '
      #9#9'PEDIDO, '
      #9#9'DATA, '
      #9#9'CLIFOR, '
      #9#9'VENDEDOR, '
      #9#9'sum(TOTAL) TOTAL, '
      #9#9'NUMERONF'
      #9'From ORCAMENT '
      #9'Group by '
      #9#9'PEDIDO, '
      #9#9'DATA, '
      #9#9'CLIFOR, '
      #9#9'VENDEDOR, '
      #9#9'NUMERONF '
      #9'Order by PEDIDO Desc) O'
      'Where 1=1')
    object IBQPESQUISAPEDIDO: TIBStringField
      DisplayLabel = 'Or'#231'amento'
      FieldName = 'PEDIDO'
      Size = 10
    end
    object IBQPESQUISADATA: TDateField
      DisplayLabel = 'Data'
      FieldName = 'DATA'
    end
    object IBQPESQUISACLIFOR: TIBStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIFOR'
      Size = 60
    end
    object IBQPESQUISAVENDEDOR: TIBStringField
      DisplayLabel = 'Vendedor'
      FieldName = 'VENDEDOR'
      Size = 60
    end
    object IBQPESQUISATOTAL: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      DisplayFormat = '##0.00'
      EditFormat = '##0.00'
    end
    object IBQPESQUISANUMERONF: TIBStringField
      DisplayLabel = 'Doc. Fiscal'
      FieldName = 'NUMERONF'
      Size = 12
    end
  end
end
