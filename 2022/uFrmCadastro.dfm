inherited FrmCadastro: TFrmCadastro
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pnlBotoesSuperior: TPanel
      OnClick = Label19Click
    end
    inherited pnlBotoesPosterior: TPanel
      object btnRenogiarDivida: TBitBtn
        Left = 556
        Top = 8
        Width = 150
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
          Top = 16
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
          Top = 39
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
          Top = 63
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
          OnClick = imgEnderecoClick
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
        object Label15: TLabel
          Left = 0
          Top = 324
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
          Left = 228
          Top = 324
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
          Top = 351
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
          Top = 377
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
          Top = 401
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
          Top = 16
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
          Top = 39
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
          Top = 63
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
          Top = 87
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
          Top = 110
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
          Top = 134
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
          Top = 157
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
          Top = 267
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
          Top = 289
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
          Left = 431
          Top = 407
          Width = 94
          Height = 13
          Alignment = taRightJustify
          Caption = 'Rela'#231#227'o  comercial:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
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
          OnChange = edtCPFCNPJChange
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit2: TSMALL_DBEdit
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
        object SMALL_DBEdit3: TSMALL_DBEdit
          Left = 100
          Top = 63
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
        object SMALL_DBEdit4: TSMALL_DBEdit
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
          TabOrder = 3
          OnEnter = SMALL_DBEdit4Enter
          OnExit = SMALL_DBEdit4Exit
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit5: TSMALL_DBEdit
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
          TabOrder = 4
          OnExit = SMALL_DBEdit5Exit
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit6: TSMALL_DBEdit
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
          TabOrder = 5
          OnExit = SMALL_DBEdit6Exit
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit8: TSMALL_DBEdit
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
          TabOrder = 7
          OnExit = SMALL_DBEdit8Exit
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
          TabOrder = 8
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit10: TSMALL_DBEdit
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
          TabOrder = 10
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit11: TSMALL_DBEdit
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
          TabOrder = 11
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit12: TSMALL_DBEdit
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
          TabOrder = 12
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit13: TSMALL_DBEdit
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
          TabOrder = 13
          OnExit = SMALL_DBEdit13Exit
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit14: TSMALL_DBEdit
          Left = 100
          Top = 325
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
          OnExit = SMALL_DBEdit14Exit
          OnKeyDown = PadraoKeyDown
        end
        object eLimiteCredDisponivel: TEdit
          Left = 334
          Top = 324
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
        object SMALL_DBEdit15: TSMALL_DBEdit
          Left = 100
          Top = 351
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
        object SMALL_DBEdit16: TSMALL_DBEdit
          Left = 100
          Top = 377
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
        object SMALL_DBEdit17: TSMALL_DBEdit
          Left = 100
          Top = 401
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
        object SMALL_DBEdit19: TSMALL_DBEdit
          Left = 530
          Top = 39
          Width = 266
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
        object SMALL_DBEdit20: TSMALL_DBEdit
          Left = 530
          Top = 63
          Width = 266
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
        object SMALL_DBEdit21: TSMALL_DBEdit
          Left = 530
          Top = 87
          Width = 266
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
        object SMALL_DBEdit22: TSMALL_DBEdit
          Left = 530
          Top = 110
          Width = 266
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
        object SMALL_DBEdit23: TSMALL_DBEdit
          Left = 530
          Top = 134
          Width = 266
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
        object DBMemo1: TDBMemo
          Left = 530
          Top = 157
          Width = 266
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
          OnKeyDown = PadraoKeyDown
        end
        object SMALL_DBEdit24: TSMALL_DBEdit
          Left = 530
          Top = 267
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
        object DBMemo2: TDBMemo
          Left = 530
          Top = 293
          Width = 266
          Height = 105
          DataField = 'CONTATOS'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          MaxLength = 254
          ParentFont = False
          TabOrder = 27
          OnEnter = DBMemo2Enter
          OnExit = DBMemo2Exit
          OnKeyDown = DBMemo2KeyDown
        end
        inline fraConvenio: TfFrameCampo
          Left = 530
          Top = 16
          Width = 266
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 19
          ExplicitLeft = 530
          ExplicitTop = 16
          ExplicitWidth = 266
          inherited txtCampo: TEdit
            Width = 266
            ExplicitWidth = 266
          end
          inherited gdRegistros: TDBGrid
            Width = 266
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
          Top = 157
          Width = 325
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 6
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
        object cboRelacaoCom: TComboBox
          Left = 530
          Top = 407
          Width = 266
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
          Top = 204
          Width = 256
          Height = 23
          BevelOuter = bvNone
          TabOrder = 9
          object rgIEContribuinte: TRadioButton
            Left = 8
            Top = 0
            Width = 78
            Height = 17
            Caption = 'Contribuinte'
            TabOrder = 0
            OnClick = rgIEContribuinteClick
            OnKeyDown = PadraoKeyDown
          end
          object rgIENaoContribuinte: TRadioButton
            Left = 91
            Top = 0
            Width = 100
            Height = 17
            Caption = 'N'#227'o Contribuinte'
            TabOrder = 1
            OnClick = rgIENaoContribuinteClick
            OnKeyDown = PadraoKeyDown
          end
          object rgIEIsento: TRadioButton
            Left = 195
            Top = 0
            Width = 113
            Height = 17
            Caption = 'Isento'
            TabOrder = 2
            OnClick = rgIEIsentoClick
            OnKeyDown = PadraoKeyDown
          end
        end
      end
      object tbsFoto: TTabSheet
        Caption = 'Foto'
        ImageIndex = 1
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.IBDataSet2
    OnDataChange = DSCadastroDataChange
  end
end
