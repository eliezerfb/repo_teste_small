inherited frmRelatorioPisCofins: TfrmRelatorioPisCofins
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelBotton: TPanel
    ExplicitLeft = 0
    ExplicitTop = 436
  end
  inherited PanelMain: TPanel
    inherited PageControlParams: TPageControl
      Left = 312
      Top = 88
      ActivePage = tbsFilter
      ExplicitLeft = 312
      ExplicitTop = 88
      object tbsFilter: TTabSheet
        Caption = 'tbsFilter'
        ImageIndex = 1
        object PanelFilter: TPanel
          Left = 0
          Top = 0
          Width = 394
          Height = 259
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object SpeedButtonCheckAll: TSpeedButton
            Left = 16
            Top = 199
            Width = 105
            Height = 22
            Caption = 'Marcar todas'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = SpeedButtonCheckAllClick
          end
          object SpeedButtonUncheckAll: TSpeedButton
            Left = 127
            Top = 199
            Width = 105
            Height = 22
            Caption = 'Desmarcar todas'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = SpeedButtonUncheckAllClick
          end
          object CheckListBoxCST: TCheckListBox
            Left = 16
            Top = 16
            Width = 297
            Height = 177
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ItemHeight = 13
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
            ParentFont = False
            TabOrder = 0
          end
        end
      end
    end
  end
end
