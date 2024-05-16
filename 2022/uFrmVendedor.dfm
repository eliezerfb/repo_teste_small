inherited FrmVendedor: TFrmVendedor
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      object tbsCadastro: TTabSheet
        Caption = 'Ficha'
        object Label2: TLabel
          Left = 0
          Top = 16
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CPF:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label3: TLabel
          Left = 0
          Top = 39
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Vendedor:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label5: TLabel
          Left = 0
          Top = 87
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CEP:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label6: TLabel
          Left = 0
          Top = 110
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Endere'#231'o:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object imgEndereco: TImage
          Left = 403
          Top = 73
          Width = 22
          Height = 30
          Hint = 'Procurar endere'#231'o no mapa'
          ParentShowHint = False
          Picture.Data = {
            07544269746D61702E080000424D2E0800000000000036000000280000001600
            00001E0000000100180000000000F8070000232E0000232E0000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            F8DE96F9E4AAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFF9E3A5F2C138F2C035FAE6AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFBEFCCF2C034F3C74CF3C74CF2C033FBEEC9FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFEFAF1F2C036F3C74CF4C84DF4C84DF3C74CF2C035FDF9ECFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFF3C546F3C649F4C84DF4C84DF4C84DF4C84DF3C74AF3C442FF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFF5D16AF3C544F4C84DF4C84DF4C84DF4C84DF4C84DF4C84D
            F3C545F5D066FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFF9E3A6F2C23BF4C84DF4C84DF4C84DF4C84DF4C84DF4C8
            4DF4C84DF4C84DF2C23BF9E4A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
            FFFFFFFFFFFFFFFFFFFFFDF8EAF2C034F3C74CF4C84DF4C84DF4C84DF4C84DF4
            C84DF4C84DF4C84DF4C84DF3C74CF2C034FEFAF0FFFFFFFFFFFFFFFFFFFFFFFF
            0000FFFFFFFFFFFFFFFFFFFFFFFFF3C74BF3C649F4C84DF4C84DF4C84DF4C84D
            F4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF3C648F4C952FFFFFFFFFFFFFFFF
            FFFFFFFF0000FFFFFFFFFFFFFFFFFFF8DE96F3C440F4C84DF4C84DF4C84DF4C8
            4DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF3C33EF9E3A7FF
            FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFEFBF4F2C034F3C74CF4C84DF4C84DF4
            C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF3C74C
            F2C137FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFF5D16AF3C646F4C84DF4C84D
            F4C84DF3C74CF3C543F2C23CF2C138F2C138F2C23CF3C544F3C74CF4C84DF4C8
            4DF4C84DF3C544F6D67BFFFFFFFFFFFF0000FFFFFFFDF5E0F2C136F4C84CF4C8
            4DF4C84DF3C649F2C138F8DE96FDF6E4FFFFFFFFFFFFFCF4DCF7DB8BF2C137F3
            C649F4C84DF4C84DF3C74CF2C034FEFAEEFFFFFF0000FFFFFFF6D270F3C646F4
            C84DF4C84DF3C647F3C74CFEFEFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FEFCF5F3C74AF3C647F4C84DF4C84DF3C545F6D67BFFFFFF0000FFFEFEF2C034
            F3C74CF4C84DF3C74BF3C441FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFF3C544F3C74AF4C84DF3C74CF2C035FFFFFF0000FAE8
            B5F3C441F4C84DF4C84DF2C23CFBEEC9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF2D5F2C23AF4C84DF4C84DF3C440FAE9B9
            0000F7D881F3C646F4C84DF3C74AF3C74AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CA54F3C749F4C84DF3C6
            46F7D9840000F5CD5FF3C74AF4C84DF3C544F7DB8AFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8DD93F3C544F4
            C84DF3C74AF5CE610000F3C84EF3C74CF4C84DF3C442F9E3A4FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8E3A7
            F3C442F4C84DF3C74CF4C9500000F4C950F3C74CF4C84DF3C443F8E09DFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFF8DF99F3C543F4C84DF3C74CF4C9510000F5CE63F3C74AF4C84DF3C647F6D3
            71FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFF5CF65F3C648F4C84DF3C74AF5CF640000F7DA89F3C546F4C84DF3
            C74CF2C137FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFEFDF9F2C136F3C74CF4C84DF3C545F7DA8A0000FBECC4F3C33E
            F4C84DF4C84DF3C545F6D578FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFF6D370F3C546F4C84DF4C84DF3C33EFBEDC50000FFFF
            FFF2C23BF3C74BF4C84DF4C84DF2C23BF8E09BFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFF9E19EF2C23CF4C84DF4C84DF3C74BF2C23CFFFFFF
            0000FFFFFFF9E5AAF2C23CF4C84DF4C84DF4C84DF2C23CF5D16DFEFBF2FFFFFF
            FFFFFFFFFFFFFFFFFFFEFEFDF6D577F2C23BF4C84DF4C84DF4C84DF2C23CF9E5
            ACFFFFFF0000FFFFFFFFFFFFF4CC5AF3C545F4C84DF4C84DF4C84DF3C646F2C1
            37F4CB57F7D77FF7D883F5CE60F2C137F3C545F4C84DF4C84DF4C84DF3C545F4
            CC5BFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFF3C647F3C545F4C84DF4C84DF4
            C84DF3C74CF3C649F3C546F3C545F3C648F3C74CF4C84DF4C84DF4C84DF3C545
            F3C648FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFF4CB59F3C33D
            F3C74BF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF4C84DF3C74BF2C2
            3CF4CC5BFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFF9E4A9F2C23BF3C33EF3C546F3C74AF3C74CF3C74CF3C74AF3C546F3C33EF2
            C23BF9E5ABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFBECC2F7DA87F5CE61F4C84FF4C84FF5CE62F7DA88
            FBECC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
          ShowHint = True
          Transparent = True
        end
        object Label7: TLabel
          Left = 0
          Top = 134
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bairro:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label8: TLabel
          Left = 0
          Top = 157
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Munic'#237'pio:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label9: TLabel
          Left = 0
          Top = 180
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Estado:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label10: TLabel
          Left = 0
          Top = 204
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'RG:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label11: TLabel
          Left = 0
          Top = 228
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telefone:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label12: TLabel
          Left = 2
          Top = 254
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Celular:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label13: TLabel
          Left = 0
          Top = 276
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'WhatsApp'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label14: TLabel
          Left = 0
          Top = 300
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'e-mail:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label16: TLabel
          Left = 0
          Top = 350
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cadastro:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object Label18: TLabel
          Left = 0
          Top = 400
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nascido em:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object edtCPFCNPJ: TSMALL_DBEdit
          Left = 100
          Top = 16
          Width = 199
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CGC'
          DataSource = DSCadastro
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
        object edtRazaoSocial: TSMALL_DBEdit
          Left = 101
          Top = 39
          Width = 325
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Color = clWhite
          Ctl3D = True
          DataField = 'NOME'
          DataSource = DSCadastro
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
        object edtCEP: TSMALL_DBEdit
          Left = 100
          Top = 87
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CEP'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnKeyDown = PadraoKeyDown
        end
        object edtEndereco: TSMALL_DBEdit
          Left = 100
          Top = 110
          Width = 325
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ENDERE'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          OnKeyDown = PadraoKeyDown
        end
        object edtBairro: TSMALL_DBEdit
          Left = 100
          Top = 134
          Width = 325
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'COMPLE'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          OnKeyDown = PadraoKeyDown
        end
        object edtEstado: TSMALL_DBEdit
          Left = 101
          Top = 180
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ESTADO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 5
          OnKeyDown = PadraoKeyDown
        end
        object edtRG_IE: TSMALL_DBEdit
          Left = 100
          Top = 204
          Width = 127
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IE'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 6
          OnKeyDown = PadraoKeyDown
        end
        object edtTelefone: TSMALL_DBEdit
          Left = 100
          Top = 228
          Width = 162
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'FONE'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 7
          OnKeyDown = PadraoKeyDown
        end
        object edtCelular: TSMALL_DBEdit
          Left = 100
          Top = 252
          Width = 162
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CELULAR'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 8
          OnKeyDown = PadraoKeyDown
        end
        object edtWhatsApp: TSMALL_DBEdit
          Left = 100
          Top = 276
          Width = 162
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'WHATSAPP'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 9
          OnKeyDown = PadraoKeyDown
        end
        object edtEmail: TSMALL_DBEdit
          Left = 100
          Top = 300
          Width = 325
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'EMAIL'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 10
          OnKeyDown = PadraoKeyDown
        end
        object edtCadastro: TSMALL_DBEdit
          Left = 100
          Top = 350
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CADASTRO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 11
          OnKeyDown = PadraoKeyDown
        end
        object edtNascido: TSMALL_DBEdit
          Left = 100
          Top = 400
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'DATANAS'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 12
          OnKeyDown = PadraoKeyDown
        end
        inline fraMunicipio: TfFrameCampo
          Left = 100
          Top = 157
          Width = 325
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 13
          ExplicitLeft = 100
          ExplicitTop = 157
          ExplicitWidth = 325
          inherited txtCampo: TEdit
            Width = 325
            ExplicitWidth = 325
          end
          inherited gdRegistros: TDBGrid
            Width = 325
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 300
                Visible = True
              end>
          end
        end
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
  object DSCadastroVen: TDataSource
    Left = 596
    Top = 7
  end
end
