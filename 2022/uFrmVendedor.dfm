inherited FrmVendedor: TFrmVendedor
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsComissao
      object tbsFicha: TTabSheet
        Caption = 'Ficha'
      end
      object tbsFoto: TTabSheet
        Caption = 'Foto'
        ImageIndex = 1
      end
      object tbsComissao: TTabSheet
        Caption = 'Comiss'#227'o'
        ImageIndex = 2
        OnEnter = tbsComissaoEnter
        object Label81: TLabel
          Left = 16
          Top = 15
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '% '#224' vista'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label82: TLabel
          Left = 16
          Top = 45
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '% a prazo'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object SMALL_DBEdit61: TSMALL_DBEdit
          Left = 116
          Top = 15
          Width = 100
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'COMISSA1'
          DataSource = Form7.DataSource9
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit62: TSMALL_DBEdit
          Left = 116
          Top = 45
          Width = 100
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Color = clWhite
          Ctl3D = True
          DataField = 'COMISSA2'
          DataSource = Form7.DataSource9
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          OnKeyDown = PadraoKeyDown
        end
      end
    end
  end
end
