inherited FrmConvenio: TFrmConvenio
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      ExplicitLeft = 10
      ExplicitTop = 105
      object tbsCadastro: TTabSheet
        Caption = 'tbsCadastro'
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet29
  end
end
