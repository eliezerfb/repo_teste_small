inherited FrmEstoque: TFrmEstoque
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = TabSheet1
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet4
  end
end
