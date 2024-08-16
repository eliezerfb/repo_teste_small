inherited FrmCadastro: TFrmCadastro
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pnlBotoesPosterior: TPanel
      object btnRenogiarDivida: TBitBtn
        Left = 579
        Top = 16
        Width = 140
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Renegociar d'#237'vida'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = btnRenogiarDividaClick
      end
    end
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      object tbsCadastro: TTabSheet
        Caption = 'Ficha'
        object Label2: TLabel
          Left = 0
          Top = 12
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CPF/CNPJ:'
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
          Top = 35
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Raz'#227'o Social:'
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
        object Label4: TLabel
          Left = 0
          Top = 59
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contato:'
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
          Top = 83
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
          Top = 106
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
          Top = 69
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
          OnClick = imgEnderecoClick
        end
        object Label7: TLabel
          Left = 0
          Top = 130
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
          Top = 153
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
          Top = 177
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
          Top = 201
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'RG/IE:'
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
          Top = 225
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
          Top = 251
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
          Top = 273
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
          Top = 297
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
        object Label15: TLabel
          Left = 0
          Top = 321
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Limite de Cr'#233'dito:'
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
        object lblLimiteCredDisponivel: TLabel
          Left = 234
          Top = 321
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Limite dispon'#237'vel:'
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
          Top = 347
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
        object Label17: TLabel
          Left = 0
          Top = 373
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #218'ltima Venda:'
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
          Top = 397
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
        object lblConvenio: TLabel
          Left = 430
          Top = 12
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Conv'#234'nio:'
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
        object Label19: TLabel
          Left = 432
          Top = 35
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador1:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label19Click
          OnMouseMove = Label19MouseMove
          OnMouseLeave = Label19MouseLeave
        end
        object Label20: TLabel
          Left = 430
          Top = 59
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador2:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label19Click
          OnMouseMove = Label19MouseMove
          OnMouseLeave = Label19MouseLeave
        end
        object Label21: TLabel
          Left = 430
          Top = 83
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador3:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label19Click
          OnMouseMove = Label19MouseMove
          OnMouseLeave = Label19MouseLeave
        end
        object Label22: TLabel
          Left = 430
          Top = 106
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador4:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label19Click
          OnMouseMove = Label19MouseMove
          OnMouseLeave = Label19MouseLeave
        end
        object Label23: TLabel
          Left = 430
          Top = 130
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador5:'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label19Click
          OnMouseMove = Label19MouseMove
          OnMouseLeave = Label19MouseLeave
        end
        object Label25: TLabel
          Left = 430
          Top = 153
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Observa'#231#227'o:'
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
        object Label26: TLabel
          Left = 430
          Top = 263
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pr'#243'ximo contato:'
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
        object Label27: TLabel
          Left = 430
          Top = 287
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contatos:'
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
        object Label56: TLabel
          Left = 434
          Top = 400
          Width = 91
          Height = 13
          Alignment = taRightJustify
          Caption = 'Rela'#231#227'o comercial:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtCPFCNPJ: TSMALL_DBEdit
          Left = 100
          Top = 12
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
          OnChange = edtCPFCNPJChange
          OnExit = edtCPFCNPJExit
          OnKeyDown = PadraoKeyDown
        end
        object edtRazaoSocial: TSMALL_DBEdit
          Left = 100
          Top = 35
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
        object edtContato: TSMALL_DBEdit
          Left = 100
          Top = 59
          Width = 199
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CONTATO'
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
        object edtCEP: TSMALL_DBEdit
          Left = 100
          Top = 83
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
          TabOrder = 3
          OnEnter = edtCEPEnter
          OnExit = edtCEPExit
          OnKeyDown = PadraoKeyDown
        end
        object edtEndereco: TSMALL_DBEdit
          Left = 100
          Top = 106
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
          TabOrder = 4
          OnExit = edtEnderecoExit
          OnKeyDown = PadraoKeyDown
          OnKeyUp = edtEnderecoKeyUp
        end
        object edtBairro: TSMALL_DBEdit
          Left = 100
          Top = 130
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
          TabOrder = 5
          OnExit = edtBairroExit
          OnKeyDown = PadraoKeyDown
          OnKeyUp = edtBairroKeyUp
        end
        object edtEstado: TSMALL_DBEdit
          Left = 100
          Top = 177
          Width = 30
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
          TabOrder = 7
          OnExit = edtEstadoExit
          OnKeyDown = PadraoKeyDown
        end
        object edtRG_IE: TSMALL_DBEdit
          Left = 100
          Top = 201
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
          TabOrder = 8
          OnKeyDown = PadraoKeyDown
        end
        object edtTelefone: TSMALL_DBEdit
          Left = 100
          Top = 225
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
          TabOrder = 10
          OnKeyDown = PadraoKeyDown
        end
        object edtCelular: TSMALL_DBEdit
          Left = 100
          Top = 249
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
          TabOrder = 11
          OnKeyDown = PadraoKeyDown
        end
        object edtWhatsApp: TSMALL_DBEdit
          Left = 100
          Top = 273
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
          TabOrder = 12
          OnKeyDown = PadraoKeyDown
        end
        object edtEmail: TSMALL_DBEdit
          Left = 100
          Top = 297
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
          TabOrder = 13
          OnExit = edtEmailExit
          OnKeyDown = PadraoKeyDown
          OnKeyUp = edtEmailKeyUp
        end
        object edtLimiteCredito: TSMALL_DBEdit
          Left = 100
          Top = 322
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CREDITO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 14
          OnExit = edtLimiteCreditoExit
          OnKeyDown = PadraoKeyDown
        end
        object eLimiteCredDisponivel: TEdit
          Left = 334
          Top = 322
          Width = 91
          Height = 20
          TabStop = False
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 15
          OnKeyDown = PadraoKeyDown
        end
        object edtCadastro: TSMALL_DBEdit
          Left = 100
          Top = 347
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
          TabOrder = 16
          OnKeyDown = PadraoKeyDown
        end
        object edtUltVenda: TSMALL_DBEdit
          Left = 100
          Top = 373
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ULTIMACO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 17
          OnKeyDown = PadraoKeyDown
        end
        object edtNascido: TSMALL_DBEdit
          Left = 100
          Top = 397
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
          TabOrder = 18
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador1: TSMALL_DBEdit
          Left = 530
          Top = 35
          Width = 245
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR1'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 20
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador2: TSMALL_DBEdit
          Left = 530
          Top = 59
          Width = 245
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR2'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 21
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador3: TSMALL_DBEdit
          Left = 530
          Top = 83
          Width = 245
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR3'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 22
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador4: TSMALL_DBEdit
          Left = 530
          Top = 106
          Width = 245
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR4'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 23
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador5: TSMALL_DBEdit
          Left = 530
          Top = 130
          Width = 245
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR5'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 24
          OnKeyDown = PadraoKeyDown
        end
        object memObs: TDBMemo
          Left = 530
          Top = 153
          Width = 245
          Height = 105
          DataField = 'OBS'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          MaxLength = 254
          ParentFont = False
          TabOrder = 25
          OnEnter = memObsEnter
          OnKeyDown = memContatoKeyDown
        end
        object edtProxContato: TSMALL_DBEdit
          Left = 530
          Top = 263
          Width = 91
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PROXDATA'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 26
          OnKeyDown = PadraoKeyDown
        end
        object memContato: TDBMemo
          Left = 530
          Top = 287
          Width = 245
          Height = 105
          DataField = 'CONTATOS'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          MaxLength = 32768
          ParentFont = False
          TabOrder = 27
          OnEnter = memContatoEnter
          OnExit = memContatoExit
          OnKeyDown = memContatoKeyDown
        end
        inline fraConvenio: TfFrameCampo
          Left = 530
          Top = 12
          Width = 245
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 19
          ExplicitLeft = 530
          ExplicitTop = 12
          ExplicitWidth = 245
          inherited txtCampo: TEdit
            Width = 245
            ExplicitWidth = 245
          end
          inherited gdRegistros: TDBGrid
            Width = 245
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 240
                Visible = True
              end>
          end
        end
        inline fraMunicipio: TfFrameCampo
          Left = 100
          Top = 153
          Width = 325
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 6
          ExplicitLeft = 100
          ExplicitTop = 153
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
        object cboRelacaoCom: TComboBox
          Left = 530
          Top = 397
          Width = 245
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 28
          OnChange = cboRelacaoComChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            'Cliente'
            'Fornecedor'
            'Cliente/Fornecedor'
            'Funcion'#225'rio'
            'Revenda'
            'Representante'
            'Distribuidor'
            'Vendedor'
            'Credenciadora de cart'#227'o'
            'Institui'#231#227'o financeira'
            'Marketplace')
        end
        object pnl_IE: TPanel
          Left = 230
          Top = 202
          Width = 256
          Height = 23
          BevelOuter = bvNone
          TabOrder = 9
          object rgIEContribuinte: TRadioButton
            Left = 6
            Top = 0
            Width = 78
            Height = 17
            Caption = 'Contribuinte'
            TabOrder = 0
            OnClick = rgIEContribuinteClick
            OnKeyDown = PadraoKeyDown
          end
          object rgIENaoContribuinte: TRadioButton
            Left = 87
            Top = 0
            Width = 100
            Height = 17
            Caption = 'N'#227'o Contribuinte'
            TabOrder = 1
            OnClick = rgIENaoContribuinteClick
            OnKeyDown = PadraoKeyDown
          end
          object rgIEIsento: TRadioButton
            Left = 189
            Top = 0
            Width = 113
            Height = 17
            Caption = 'Isento'
            TabOrder = 2
            OnClick = rgIEIsentoClick
            OnKeyDown = PadraoKeyDown
          end
        end
        object pnl_IE_PR: TPanel
          Left = 332
          Top = 224
          Width = 125
          Height = 23
          BevelOuter = bvNone
          TabOrder = 29
          object chkProdRural: TDBCheckBox
            Left = 6
            Top = 0
            Width = 97
            Height = 17
            Caption = 'Produtor Rural'
            DataField = 'PRODUTORRURAL'
            DataSource = DSCadastro
            TabOrder = 0
            ValueChecked = 'S'
            ValueUnchecked = 'N'
            OnClick = chkProdRuralClick
          end
        end
      end
      object tbsFoto: TTabSheet
        Caption = 'Foto'
        ImageIndex = 1
        OnShow = tbsFotoShow
        object Image3: TImage
          Left = 280
          Top = 25
          Width = 249
          Height = 179
          Hint = 'Avan'#231'ar'
          ParentShowHint = False
          Picture.Data = {
            0A544A504547496D616765B8250000FFD8FFE000104A46494600010101004800
            480000FFE20C584943435F50524F46494C4500010100000C484C696E6F021000
            006D6E74725247422058595A2007CE00020009000600310000616373704D5346
            540000000049454320735247420000000000000000000000000000F6D6000100
            000000D32D485020200000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000001163707274000001
            500000003364657363000001840000006C77747074000001F000000014626B70
            7400000204000000147258595A00000218000000146758595A0000022C000000
            146258595A0000024000000014646D6E640000025400000070646D6464000002
            C400000088767565640000034C0000008676696577000003D4000000246C756D
            69000003F8000000146D6561730000040C000000247465636800000430000000
            0C725452430000043C0000080C675452430000043C0000080C62545243000004
            3C0000080C7465787400000000436F7079726967687420286329203139393820
            4865776C6574742D5061636B61726420436F6D70616E79000064657363000000
            0000000012735247422049454336313936362D322E3100000000000000000000
            0012735247422049454336313936362D322E3100000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000058595A20000000000000F35100010000000116CC58595A20000000
            0000000000000000000000000058595A200000000000006FA2000038F5000003
            9058595A2000000000000062990000B785000018DA58595A2000000000000024
            A000000F840000B6CF64657363000000000000001649454320687474703A2F2F
            7777772E6965632E636800000000000000000000001649454320687474703A2F
            2F7777772E6965632E6368000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000064657363000000
            000000002E4945432036313936362D322E312044656661756C74205247422063
            6F6C6F7572207370616365202D207352474200000000000000000000002E4945
            432036313936362D322E312044656661756C742052474220636F6C6F75722073
            70616365202D2073524742000000000000000000000000000000000000000000
            0064657363000000000000002C5265666572656E63652056696577696E672043
            6F6E646974696F6E20696E2049454336313936362D322E310000000000000000
            0000002C5265666572656E63652056696577696E6720436F6E646974696F6E20
            696E2049454336313936362D322E310000000000000000000000000000000000
            00000000000000000076696577000000000013A4FE00145F2E0010CF140003ED
            CC0004130B00035C9E0000000158595A2000000000004C09560050000000571F
            E76D656173000000000000000100000000000000000000000000000000000002
            8F00000002736967200000000043525420637572760000000000000400000000
            05000A000F00140019001E00230028002D00320037003B00400045004A004F00
            540059005E00630068006D00720077007C00810086008B00900095009A009F00
            A400A900AE00B200B700BC00C100C600CB00D000D500DB00E000E500EB00F000
            F600FB01010107010D01130119011F0125012B01320138013E0145014C015201
            5901600167016E0175017C0183018B0192019A01A101A901B101B901C101C901
            D101D901E101E901F201FA0203020C0214021D0226022F02380241024B025402
            5D02670271027A0284028E029802A202AC02B602C102CB02D502E002EB02F503
            00030B03160321032D03380343034F035A03660372037E038A039603A203AE03
            BA03C703D303E003EC03F9040604130420042D043B0448045504630471047E04
            8C049A04A804B604C404D304E104F004FE050D051C052B053A05490558056705
            770586059605A605B505C505D505E505F6060606160627063706480659066A06
            7B068C069D06AF06C006D106E306F507070719072B073D074F07610774078607
            9907AC07BF07D207E507F8080B081F08320846085A086E0882089608AA08BE08
            D208E708FB09100925093A094F09640979098F09A409BA09CF09E509FB0A110A
            270A3D0A540A6A0A810A980AAE0AC50ADC0AF30B0B0B220B390B510B690B800B
            980BB00BC80BE10BF90C120C2A0C430C5C0C750C8E0CA70CC00CD90CF30D0D0D
            260D400D5A0D740D8E0DA90DC30DDE0DF80E130E2E0E490E640E7F0E9B0EB60E
            D20EEE0F090F250F410F5E0F7A0F960FB30FCF0FEC1009102610431061107E10
            9B10B910D710F511131131114F116D118C11AA11C911E8120712261245126412
            8412A312C312E31303132313431363138313A413C513E5140614271449146A14
            8B14AD14CE14F01512153415561578159B15BD15E0160316261649166C168F16
            B216D616FA171D17411765178917AE17D217F7181B18401865188A18AF18D518
            FA19201945196B199119B719DD1A041A2A1A511A771A9E1AC51AEC1B141B3B1B
            631B8A1BB21BDA1C021C2A1C521C7B1CA31CCC1CF51D1E1D471D701D991DC31D
            EC1E161E401E6A1E941EBE1EE91F131F3E1F691F941FBF1FEA20152041206C20
            9820C420F0211C2148217521A121CE21FB22272255228222AF22DD230A233823
            66239423C223F0241F244D247C24AB24DA250925382568259725C725F7262726
            57268726B726E827182749277A27AB27DC280D283F287128A228D42906293829
            6B299D29D02A022A352A682A9B2ACF2B022B362B692B9D2BD12C052C392C6E2C
            A22CD72D0C2D412D762DAB2DE12E162E4C2E822EB72EEE2F242F5A2F912FC72F
            FE3035306C30A430DB3112314A318231BA31F2322A3263329B32D4330D334633
            7F33B833F1342B3465349E34D83513354D358735C235FD3637367236AE36E937
            243760379C37D738143850388C38C839053942397F39BC39F93A363A743AB23A
            EF3B2D3B6B3BAA3BE83C273C653CA43CE33D223D613DA13DE03E203E603EA03E
            E03F213F613FA23FE24023406440A640E74129416A41AC41EE4230427242B542
            F7433A437D43C044034447448A44CE45124555459A45DE4622466746AB46F047
            35477B47C04805484B489148D7491D496349A949F04A374A7D4AC44B0C4B534B
            9A4BE24C2A4C724CBA4D024D4A4D934DDC4E254E6E4EB74F004F494F934FDD50
            27507150BB51065150519B51E65231527C52C75313535F53AA53F65442548F54
            DB5528557555C2560F565C56A956F75744579257E0582F587D58CB591A596959
            B85A075A565AA65AF55B455B955BE55C355C865CD65D275D785DC95E1A5E6C5E
            BD5F0F5F615FB36005605760AA60FC614F61A261F56249629C62F06343639763
            EB6440649464E9653D659265E7663D669266E8673D679367E9683F689668EC69
            43699A69F16A486A9F6AF76B4F6BA76BFF6C576CAF6D086D606DB96E126E6B6E
            C46F1E6F786FD1702B708670E0713A719571F0724B72A67301735D73B8741474
            7074CC7528758575E1763E769B76F8775677B37811786E78CC792A798979E77A
            467AA57B047B637BC27C217C817CE17D417DA17E017E627EC27F237F847FE580
            4780A8810A816B81CD8230829282F4835783BA841D848084E3854785AB860E86
            7286D7873B879F8804886988CE8933899989FE8A648ACA8B308B968BFC8C638C
            CA8D318D988DFF8E668ECE8F368F9E9006906E90D6913F91A89211927A92E393
            4D93B69420948A94F4955F95C99634969F970A977597E0984C98B89924999099
            FC9A689AD59B429BAF9C1C9C899CF79D649DD29E409EAE9F1D9F8B9FFAA069A0
            D8A147A1B6A226A296A306A376A3E6A456A4C7A538A5A9A61AA68BA6FDA76EA7
            E0A852A8C4A937A9A9AA1CAA8FAB02AB75ABE9AC5CACD0AD44ADB8AE2DAEA1AF
            16AF8BB000B075B0EAB160B1D6B24BB2C2B338B3AEB425B49CB513B58AB601B6
            79B6F0B768B7E0B859B8D1B94AB9C2BA3BBAB5BB2EBBA7BC21BC9BBD15BD8FBE
            0ABE84BEFFBF7ABFF5C070C0ECC167C1E3C25FC2DBC358C3D4C451C4CEC54BC5
            C8C646C6C3C741C7BFC83DC8BCC93AC9B9CA38CAB7CB36CBB6CC35CCB5CD35CD
            B5CE36CEB6CF37CFB8D039D0BAD13CD1BED23FD2C1D344D3C6D449D4CBD54ED5
            D1D655D6D8D75CD7E0D864D8E8D96CD9F1DA76DAFBDB80DC05DC8ADD10DD96DE
            1CDEA2DF29DFAFE036E0BDE144E1CCE253E2DBE363E3EBE473E4FCE584E60DE6
            96E71FE7A9E832E8BCE946E9D0EA5BEAE5EB70EBFBEC86ED11ED9CEE28EEB4EF
            40EFCCF058F0E5F172F1FFF28CF319F3A7F434F4C2F550F5DEF66DF6FBF78AF8
            19F8A8F938F9C7FA57FAE7FB77FC07FC98FD29FDBAFE4BFEDCFF6DFFFFFFDB00
            4300010101010101010101010101010101010101010101010101010101010101
            0101010101010101010101010101010101010101010101010101010101010101
            0101FFDB00430101010101010101010101010101010101010101010101010101
            0101010101010101010101010101010101010101010101010101010101010101
            01010101010101FFC0001108009600C803012200021101031101FFC4001F0000
            010501010101010100000000000000000102030405060708090A0BFFC400B510
            0002010303020403050504040000017D01020300041105122131410613516107
            227114328191A1082342B1C11552D1F02433627282090A161718191A25262728
            292A3435363738393A434445464748494A535455565758595A63646566676869
            6A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7
            A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2
            E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301010101010101
            01010000000000000102030405060708090A0BFFC400B5110002010204040304
            0705040400010277000102031104052131061241510761711322328108144291
            A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738
            393A434445464748494A535455565758595A636465666768696A737475767778
            797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4
            B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9
            EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00FEFE28A28A0028A2
            8A0028A28A0028A28A0028A28A0028A2AB49796911C4B756D11F4927890FE4CC
            0D0059A2A18AE6DE6FF53710CBFF005CA58E4FFD058D4D400514514005145140
            0514514005145140051451400514514005145140051451400514514005145731
            E2AF14E9FE15D38DE5D9F36E242D1D959230135DCE06768C83E5C480869A6236
            C6B8FBCEC88C01AFA9EABA7E8F6925EEA7770D9DB47D6499B1B9BB246832F2C8
            DFC31C6ACEDD94D787EBFF0018E776783C396490C792A350D45774AC07F1C366
            AC150770677909CFCD0AF207966B5AEEB5E2CD4967BC796EA7964115958DB077
            860F31B0905A5BAEE3B9870EE434B2B619DCF1B7D47C31F08659D22BCF13CCF6
            EAC03AE9768EBE760F38BBBA1B963C8FBD14019D4120CE8D90003CB6FF00C4FE
            22D5DCFDBB59D42E77923C859DE187927E54B6B731C5D70388C93EA78AAD1683
            AD5D00F168DAACE0F21D74EBC901CF390DE49041C6739C11F5E7EC3D2FC3BA1E
            8C8A9A66976769B401E6242AD3B631CBDC49BE773C0E5E4635B5401F104BA46A
            F63FBC9B4CD52CC2F3E63D95E5B85F43BCC6817D7391CE083EBA9A5F8D3C51A4
            38FB16B776D1A1E6DEEE537D6F81D418EEBCCD83A0223643D70C315F65F5EB5C
            CEB1E0EF0DEBAAC350D2AD9A5607175020B6BB527F885C41B1D88F490BA9EEA4
            50079BF873E30DADC3476DE24B4162E485FED0B3124969CF469EDCEF9E0079CB
            C6D3A83F7820E9ED16F736F77045736B345716F32078A685D648A443D191D095
            61F43C1C83C8AF9B3C57F0AF52D1D25BED15E4D5AC132F25B945FED1B78C1CB1
            D88025E22AF568952603930B005872DE12F1A6A7E14B91E4B35CE9B2BE6EF4D7
            7211BB3CB6E483F67B9001DAE8A124236CCADC32807D854565E8DAC586BBA7C1
            A969D309ADA75C8ED244E3878664EB1CD1B7CB221E87904A9563A94005145140
            051451400514514005145140051451400514514005145140152FEFADB4CB2BAD
            42F24115AD9C324F3487B246A49007F1331C2A28E59CAA8C922BE39F11EBD7FE
            2BD69EFA6491DA675B7D3AC50990C1017DB6F6D120FBD2B96CCCC0132CEE48E3
            685F5FF8C9AF3450587876072A6EBFE2617DB4E098227296B13107A493ABCA54
            8E4C119E873587F08BC36B7D7F3F886EE357B7D318416018655EFDD034930CE4
            1FB2C4C021EA2598303BA3A00F3FBFD2FC43E0AD52CA6B857B0BE8D63BBB2B98
            9849136557CC457FF57218CBB43771312002CAC1A27566FA4FC11E37B3F1659E
            C9365B6B16C8BF6CB307871C0FB55AEEF99EDDC91B9797818EC93828EFA9E2BD
            3BC3FAB69AD61AFDCD9DA452966B5B8B8B8B7B696DEE00F967B692765FDE267E
            75194910949159588AF96B50D3F56F06EAF6F716F740B2B1B9D2758B37125A5F
            C00ED1243221689D587EEEEADD99C29251F7A323B007D9945799F87FE24596AD
            A15E5F4B6D33EADA55B19EFB4AB2512CF3A2601BAB246705ED8E77CB925ED46E
            1206011A4A3A3F897C73E2EB79B51D06D3C3DA6E9F1DCBDBC635392F6E6E2574
            5567CB5BAAAE103A64F95182490BBC0DC403D6A8AF209FE21EADE19D59348F18
            69F64C1E18A65D434492664F2652EA256B5B93BDC2BC6EAEAAD1C802E523932A
            0FA147E27F0E4B124D1EBDA46C911644DDA85AA36D650CBBA37956446C1E51D5
            5D4E5594302280376BC3FE257C3F8E78AE3C47A24012E22569754B185405B988
            7CD2DE411A8C2DCC6017B845189D03480099499377C37F142C35BD56F6C6F208
            349B6892496CAF6E6FA258E648A558FCB98CA228E39A45712A2C6F20DA1D72DB
            439F4BB7BAB5BD884D69716F770312A25B79A39E2623AAEF8D99091D08CFB114
            01F28FC3FF001749E19D55239E42747BF748AFE3E4A40E4EC8AFD4024068B204
            DB47EF2DF7839291E3EB504300CA432B005581041046410470411C823822BE4A
            F88DE1A5F0EF8824FB3C7B34DD4C1BEB2503E4899A4DB756CBD808656DC8BCED
            865894636D7B67C2DD79B58F0D25ACEE5EEF4690584858E5DEDC287B391B9278
            873013DDA0639C93401E95451450014514500145145001451450014514500145
            14500145145007C7DF107503A8F8BF5B98B068EDAE3EC11618E163B28D61603B
            0066595CF3D589AFA57C0DA5AE91E15D1AD428591ED12EEE08182D3DEFFA4C85
            BD4AF9A23F65451DABE4AD518CFAB6A6EFC99B54BE2C7FEBA5E4A0FE1CFA0FA7
            7AFB720411C30C6BC08E28D07D15028FD05007C7DE37BEBAD43C53AD3DDCAD2F
            D9EFEE6CEDD493B21B6B595A18A38D492106137B6D037C8CEED966269344D6AD
            A3B69342D76392E740B9937A98C06BAD1EEDB206A3A7139218139B9B61F25CC7
            B86D2E487ABE2AFF00919BC41FF619D4BFF4AE5AC0A00E86F6CB55F086AB6B77
            67760838BBD1F58B439B6D42D98FCB246DF32B02A445756B21250968A4050AB3
            7636B2EA5AEC135FF822EEE74AD5A475935EF0D585E1B38E5998843AB6968D2C
            71B5BCADFF001F36E4AC96CE46374656AEFC39D0DFC53A5EB7A4EA726FD0E0F2
            8DA295DD7165AB4DB9FED56129FF0053B6253F698B0D15C79A81D7972DC46AFA
            46BBE03D762FDEBC1716EE67D3B52814886EA15E0B2EEDC0E5408EE6D9F76DDC
            51C323ABB0054D7ACBC456D7666F11C1A92DDCC00171A879921984630163B862
            F1C8A8380B1C8428E800358381E83F215F53F86FC49A37C43D1E7D3354B783ED
            CB0EDD434F7E8D8F956FAC4B7CE1379CABA9135ACB8562414793E74F11E8D278
            7F5AD4348918C82D26C432B000CB6F22ACB6F2301C6E685D37E3812070381401
            89807A8CD7A8FC24BFBAB7F142D8472B0B4BFB4BA371064F96CF6F1F9B0CA133
            B44A84320703251D9492318F2EAF45F855FF00239D8FFD7A6A3FFA4CD401EAFF
            0017B4B5BCF0C2DF85066D26F21983E32C2DEE985ACEA0F5C1692173DB3183DA
            BCEBE0F5FB5B7892EAC09FDDEA5A74A76E78F3ECE45963206393E4BDC67BF53D
            ABDB7C751ACBE0FF001123741A64F20F66880950FE0C80FE15F397C3890C7E35
            D0C8FE392EE23EEAF61740E7F2FCE803EB9A28A2800A28A2800A28A2800A28A2
            800A28A2800A28A2800A28A2803E25F10DBBD9EBDAE5BE36B41ABEA000E9C7DA
            6474F4E0A952339E08F6AFB374DB95BCD3AC2ED0E52EACEDAE148EE2685241FF
            00A173EF5F31FC57D28E9FE2B9AE82E20D5EDA2BD43FC2668D05B5CAF18F9818
            92460327F7C0FA57AFFC2BD69754F0BC366CF9BAD1A46B19549CB792732DA3F3
            CED30B79433FC5030EA2803E78F157FC8CDE20FF00B0CEA5FF00A572D605747E
            2F8A587C53E204951A37FED7BE936B0C131CD3BCD138F55922911D48E0AB022B
            9CA00FA0FE0BDF42D63ACE9A5945C47770DE85CFCCF04D0A40580EEB1C9000DF
            DD32AFF7857A8F883C3FA778974E974ED4A2DC8D978274C09ED6700849E0720E
            D75CE194E52442524565622BE40D1B59BFD07518353D3A5F2AE202410C0B4534
            4D8F3209D011BE29000186430215D195D5587BE69BF18F429A05FED4B3BFB1BA
            0A3CC58235BBB766C7262903A48149C90B2440A8E0B375201E2DAB691AE780F5
            D8B32BC17104866D3B52854886EA11F2EF5CE5482A7CBBAB59376376C93746C8
            EDB9AD9FF84E2093C496031AD59DAC29AF68CA32E61B7411AEA9A68FBF3DAEDC
            0BA87E696D880C4B27CC7ADF137C44F0B789122D22EB4ABD974C924CCBA9C9E5
            C57960FB5963BBB1B7532B48D1390D2A48E9E6C3BE3F2DCB007CC2F6CB54F086
            AB69776B77C1FF004CD2357B36CDADFDAB70248CF2A4306F2EEED25C94DCF1C8
            0A32330073BD7A57A2FC2AFF0091CEC7FEBD351FFD266AA37B6367E26B49F5CD
            0E04B6D4EDD4CDAF68108C05E7F79AB6931FDE7B3763BAE6D5417B4762C07964
            5697C278A493C636D22233241637F24AC06563478844ACC7A00D2488A3D49E3A
            1A00F72F8897296BE0DD75988066B64B44048CB3DDCF1401467BED763F404D78
            1FC31B7371E34D2C804ADB457D72FEC12D258949F6F32645FAB0AEFF00E33EB2
            AB6DA6681138F32694EA57601FBB0C21A1B646C74F365791C67A79008ED9A3F0
            5F4A66B8D635B910848E38F4DB763D0BC8CB7172548E32A896CA7D3711EB401F
            4051451400514514005145140051451400514514005145140051451401E73F13
            3C36FAF680D3DAC664D434867BCB6551979A1DB8BBB650064B49101246A39696
            145032D5E09E07F141F0B6B715DC858E9F76AB6DA946BC9F219B725CAA8FBD25
            ABFEF30012D199631CB823EC1AF99BE25F819F46BA975DD3212DA45DC85EEE18
            D7234EB991B2C481F76D2773BA37FBB04ACD11C23C42803DBF55F0AF863C53E4
            5FDF594378EF0C6D0DEDBCD2C2F2DBB2EE8F335B491F9D19560C9BCBED07E520
            64563FFC2ADF05FF00D0326FFC185FFF00F2457907807E224BE1C2BA4EAC64B8
            D159FF00752A82F3E9ACE7E668D39696D0B65A48572D112CF0820B46DF4C59DE
            5AEA16F15DD95C43756D32878A781D648DD4FA3292320F0CA70CA41560082280
            386FF855BE0BFF00A064DFF830BFFF00E48A3FE156F82FFE81937FE0C2FF00FF
            00922BD0A8A00F3DFF00855BE0BFFA064DFF00830BFF00FE48ABB37803C39268
            B71A125BCF1D9CB21B880B5D4F71258DD152BF69B36B8925F218E732A2623986
            44AADB9B3DAD1401F1BEAFA46BBE03D763C4AF05CC2E66D3B52841115DC2AD8D
            CB9C8C32911DD5B49B82E4A3EF8DD1DBDA3C1DE30F08C7A36ABAA0B4B2D13528
            54DDEB36D02856BC909C249621999A486E253B22B68CEDB69A4285406123F5FE
            3887C373685709E269A3B7B500B5B4E306F22BA0A7CB6B0400C925C64E3CA456
            59109594794588F8FDC46ACE518BC619BCB66508C63C9D8CC8ACE11D860B2876
            0A4901C819201B3AC6A77FE29D72E2F9E3796EF52B98E3B6B643BCA2B910D9D9
            C6076442885B8DCFBA4382E4D7D6BE13D0A3F0E68361A5AE1A58A3F36EE41FF2
            D6F273E65C3E7BA873B133D23441DABCC7E17781E4B6F2BC4DAC4252E1E32749
            B49548786371837D2A11F24B2A1DB6E8794899A42033AECF71A0028A28A0028A
            28A0028A28A0028A28A0028A28A0028A28A0028A28A002A39628A78A48678D26
            865468E58A450F1C91B82AC8E8C0AB2B0241520820E0D4945007CEDE33F85573
            68F2EA3E188DAEAD0E64974ACEEBAB6E72DF6366E6E611CED809F3E31F2A79C3
            017CD346F116BBE19B973A6DDCF66CAE44F652AEEB77707056E2D262007E704E
            D8E65E0075EFF6A5735AE7843C3DE2205B53D3E27B8C6D5BC849B7BC51DBFD22
            22AEE076497CC8FF00D8A00F2ED2BE344655535AD1E4571C35C69B22BA363033
            F65B8646539EA16E2403B74C575D0FC57F06CAA19AF2F20246764DA75D161EC4
            C31CA99FA311E84D71FA8FC1552CCFA46B6CAB92560D46DC49807B7DA2D8A1FF
            00817D989F5CE6B9A97E1078AD0911CBA44E39C32DDCF1E7D3892D011401EA37
            1F16BC1F0A9314F7F74C070B0584C849F4DD73F674FC775711AC7C67BB955A2D
            0F4A4B4CE40BBD45C4F22FA325B42444ADCF1E64F2AE7AAB74AC883E0F78A253
            89AE748B607AB1B9B8988FA2C76A0123FDE1F5F4EB34BF82F61132C9AC6AD717
            641C982CA25B48CFFB26691A794A9CE0EC11363A303D003C4EE6EF5CF146A286
            792F757D4666DB0C4A1E691431FB90411AF970463A9088910032ED824D7B7F82
            BE162D8BC3AAF894453DDA1592DB4B1B65B7B670772C976C329713A900AC484D
            BC6C031695B1B3D4B47F0F68DA04260D274FB7B3561892445DD3CDEF35C485A6
            97A7477207602B66800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2
            800AE66CFC69E11D43579B40B1F12E8977AD5B9944DA65BEA56935EA35BFFC7C
            27909297692DF9F3E340CF060F9AA9838D7D56DEE6EB4BD4AD6CA6FB3DE5CD85
            E5BDA5C648F22E66B7923826C8C91E54ACAF90091B78E6BC2BC0573059E95F0F
            7C1B73F0E7566F1078753C8D5EFAFB436B5D3BC33796DA7DC437BE21B5D76E6D
            9AC75297579D9BECE749BC9AEEF12F5E595919191803DA74DF12681AC496F169
            5ABD8DFC97560FAA5B2DADC24C67D392EDEC1EF23DA4EEB75BC47B6320E04CA5
            3A8ADBAF8DB46B4F889A77856DECF43B5F1358DCC1F092E4456D05B5E5BBC3A9
            B7C4399EF859413A2409E233E1F6B87B052A2F4A185A11B590D588F52D696E7C
            683C3575F112EB48D0358F845A9C165AAC9E22B8F10C5A09BFBDB8F119B7D3EF
            CFF6DCD6B73124AD736D2C4D35DC313A88E4B48EDD4007D83457C93AB5FF008E
            B518B55BD857C6765E19BBF89FA9CB7AB258F8B2DF5483C36DE17D38E8860B1D
            21ADFC4B6DA24BAB8964963D28C463B878C5E46A9F6A8ABBAF115DF8974BF803
            A9DE5E6AFAC3788ADBC3C645D5A7B7B8D175D52DA827D91AE2192792E6DB508E
            D1E18277966F3A6915A59B0F2BA800F7CA2BE509AEFC476D67E2C1A55AFC4DBD
            F0A5CDCF832D565D5AE3C4F0EBBA7EAD35C5D9F155F5AB450CDE27B9D0EDE14B
            05D4EDB45091DC5C4D347A4DCDBDB992653C2FA778CF5BB8F01E91ADDF78F6CF
            4EB6F127C494D4A713F88348BA9749B06D36F7C2D6FAA5D5CCB2DF0B398612CF
            EDF7B35D4B12CD666EE47FB42D007D5F457CC3E03BEF175C7C4AB2BABAB4F1A6
            9DA56A56FE308B5BD375C3E25BCD3ECF50B6BEB79B478DEF75358B44F37EC825
            7B13E1EB2B4B18AD244B57BABDB82CC0F1CDF78B8FC46824D2AD3C6B651697E2
            4F054625B56F12DE687A9787EEAE2D935CBA4B7B258BC336B6282E25B5D41350
            5D4F5596684CF12D95BA348801F43D9EBFA26A0D12596AD6172F3DDEA1610A45
            75134935E692EF1EA76D1461B7C92E9F22325E2A2B1B76189769233AF5F1E5AF
            8735BB4D6BC2DAB47A5F88E1BEB7F14FC6A834F92183594B3B7D5351D61AEBC2
            B36A30DB28861D2B53B8DC67BCBC44D36F6D238D6F6692D63880AD629F119FC1
            BE2B78F54F1D0D51F41F0DC77D653E99E2C8AFEDBC52FE23B01A95E693A8EAB3
            CD9B88ECBED91DFD9F87605D08D9FD9E7882C6244201F66515F27F8EE1F14E8B
            AEDBE99E1C1F115FFE11C1E137D3B5337FE2CD76DF5AB3B8D644DE209E66B4D9
            A306B6B69A5B5D4CEBADA95DDC44208B4EB2B582212D7AC7C38D2F541AAF8EF5
            BD66F7C4924F378CFC4BA669563AADEDF9D2ADF4082FE39EC26D2B4EB922058A
            62F2186F62570F062082410204A00F58AA50EA561717B7BA6C17704B7FA6A5AB
            DFDA23869ED12F51E4B469D07282E12391A227EF04623A57CDBE0ABEF17DC7C4
            EB0BAB8B5F1AE9DA56A0FE35B6D774ED68F892F34DB5B8B69D26D0D5EF35158F
            4005EDE3925D3FFE11EB2B7B486D658ED66BEBDB8739BFE3087C5F75E30F10DA
            D94DE2BB6D2AE7C5DF08ADE19F4A9754B78A2D2A78F568FC48F63716E3CA82DC
            2B43FDAB3424470BF9325CB2BAC64007D21457CB1A059F8D347D6343BC5B8F1E
            6A3141E37F88DA0CB61A85FEAD756B378534ED3B549FC3892ADFEFB626E2F60B
            51A7EBB7BBE79E692341772C3E5C2BCAD86A1F1161D3FC5F71A7B78E2C12F7C0
            D637AB16B0FE237B9B1D753C496D06B96DA6EA3E2811C736BF0E8D733C10BE93
            6DA6E9F7774223A5DA48F0892803ED1A2BE399751F125C378EACFC1F7FE3B9F4
            3B1D43E1A09A1D5E4F12DC7886C7C357706AF2EBB2595BC922789E38E799607B
            A36C62D6A4B1595AD1BC85B761B10699E33D4A1F08D8DCEB1E3A934B96C7E26D
            C1B8B74F13F87AFD6DA1834F93C3163A9CD7372FAC4BE5DC2CCDA45C6A9345A8
            DF5B048E456CDC472007D5D457CFDF0B61F165B6BDA33EB577E2BBB835BF857A
            2EB3AE1D7E6D427B687C5DFDA620B88A28EED16DF4BBC4B26D9369D6CB6EC634
            59A781A50D337D03400514514005145140051451400550834BD3ADB50BED56DE
            CEDE1D47538ED22D42F5230B71791D82CA96693C839916D926956107EE09180E
            B57E8A002A8EA7A669FACD8DCE99AADA417FA7DE47E55D59DCA09209E3DCAFB2
            543C32EE556C1EE055EA280100000006000001E8070052D14500145145001451
            450014514500145145001552FEC2CB54B3B9D3F52B4B6BFB0BC89A0BAB3BB863
            B8B6B885FEF473432AB47221E0E194F20118201AB7450061E83E19F0FF00862D
            E6B5F0F68FA7E8F6F712F9F711D85B47079F30508249D946F99D500443233144
            01570BC56E514500145145001451450014514500145145001451450014514500
            1451450014514500145145001451450014514500145145001451450014514500
            145145007FFFD9}
          ShowHint = True
          Transparent = True
          Visible = False
        end
        object Image5: TImage
          Left = 20
          Top = 25
          Width = 238
          Height = 168
          Center = True
          Stretch = True
        end
        object VideoCap1: TVideoCap
          Left = 28
          Top = 33
          Width = 137
          Height = 129
          color = clBlue
          visible = False
          DriverOpen = False
          DriverIndex = -1
          VideoOverlay = False
          VideoPreview = False
          PreviewScaleToWindow = False
          PreviewScaleProportional = True
          PreviewRate = 30
          MicroSecPerFrame = 66667
          FrameRate = 15
          CapAudio = False
          VideoFileName = 'Video.avi'
          SingleImageFile = 'Capture.bmp'
          CapTimeLimit = 0
          CapIndexSize = 0
          CapToFile = True
          BufferFileSize = 0
        end
        object btnWebCam: TBitBtn
          Left = 20
          Top = 380
          Width = 130
          Height = 25
          Caption = '&Webcam'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnWebCamClick
        end
        object btnSelecionarArquivo: TBitBtn
          Left = 304
          Top = 380
          Width = 130
          Height = 25
          Caption = '&Selecionar arquivo'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnSelecionarArquivoClick
        end
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
  inherited DSCadastro: TDataSource
    DataSet = Form7.IBDataSet2
    OnDataChange = DSCadastroDataChange
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'JPEG Image File (*.jpg)|*.jpg|| | | | | | | | | '
    Left = 502
    Top = 465
  end
end
