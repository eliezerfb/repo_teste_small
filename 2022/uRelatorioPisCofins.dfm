inherited frmRelatorioPisCofins: TfrmRelatorioPisCofins
  PixelsPerInch = 96
  TextHeight = 15
  inherited PanelBotton: TPanel
    ExplicitTop = 436
    ExplicitWidth = 796
    inherited btnCancelar: TBitBtn
      ExplicitLeft = 685
      ExplicitTop = 2
      ExplicitHeight = 24
    end
    inherited BitBtnNext: TBitBtn
      ExplicitLeft = 580
      ExplicitTop = 2
    end
    inherited BitBtnPrior: TBitBtn
      ExplicitLeft = 475
      ExplicitTop = 2
    end
  end
  inherited PanelMain: TPanel
    ExplicitWidth = 796
    ExplicitHeight = 436
    inherited PanelParams: TPanel
      ExplicitLeft = 161
      ExplicitWidth = 634
      ExplicitHeight = 434
    end
    inherited PanelImg: TPanel
      ExplicitHeight = 434
    end
    inherited PageControlParams: TPageControl
      Left = 312
      Top = 88
      ActivePage = tbsFilter
      ExplicitLeft = 312
      ExplicitTop = 88
      inherited tbsPeriod: TTabSheet
        inherited PanelPeriod: TPanel
          ExplicitTop = 0
          ExplicitWidth = 394
        end
      end
      object tbsFilter: TTabSheet
        Caption = 'tbsFilter'
        ImageIndex = 1
        object PanelFilter: TPanel
          Left = 0
          Top = 0
          Width = 394
          Height = 259
          Align = alClient
          TabOrder = 0
          object SpeedButtonCheckAll: TSpeedButton
            Left = 16
            Top = 199
            Width = 105
            Height = 22
            Caption = 'Marcar todas'
            OnClick = SpeedButtonCheckAllClick
          end
          object SpeedButtonUncheckAll: TSpeedButton
            Left = 208
            Top = 199
            Width = 105
            Height = 22
            Caption = 'Desmarcar todas'
            OnClick = SpeedButtonUncheckAllClick
          end
          object CheckListBoxCST: TCheckListBox
            Left = 16
            Top = 16
            Width = 297
            Height = 177
            ItemHeight = 15
            Items.Strings = (
              '01-Opera'#231#227'o Tribut'#225'vel com Al'#237'quota B'#225'sica'
              '02-Opera'#231#227'o Tribut'#225'vel com Al'#237'quota Diferenciada'
              
                '03-Opera'#231#227'o Tribut'#225'vel com Al'#237'quota por Unidade de Medida de Pro' +
                'duto'
              '04-Opera'#231#227'o Tribut'#225'vel Monof'#225'sica - Revenda a Al'#237'quota Zero'
              '05-Opera'#231#227'o Tribut'#225'vel por Substitui'#231#227'o Tribut'#225'ria'
              '06-Opera'#231#227'o Tribut'#225'vel a Al'#237'quota Zero'
              '07-Opera'#231#227'o Isenta da Contribui'#231#227'o'
              '08-Opera'#231#227'o sem Incid'#234'ncia da Contribui'#231#227'o'
              '09-Opera'#231#227'o com Suspens'#227'o da Contribui'#231#227'o'
              '49-Outras Opera'#231#245'es de Sa'#237'da'
              '99-Outras Opera'#231#245'es')
            TabOrder = 0
          end
        end
      end
    end
  end
end
