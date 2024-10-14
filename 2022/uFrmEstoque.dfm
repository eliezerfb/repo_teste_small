inherited FrmEstoque: TFrmEstoque
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pnlBotoesSuperior: TPanel
      ExplicitWidth = 842
    end
    inherited pnlBotoesPosterior: TPanel
      inherited btnOK: TBitBtn
        ExplicitLeft = 723
      end
      object pnlImendes: TPanel
        Left = 166
        Top = 6
        Width = 555
        Height = 51
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object lblStatusImendes: TLabel
          Left = 241
          Top = 17
          Width = 236
          Height = 13
          AutoSize = False
          Caption = 'Consultado'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = 16605442
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object DBCheckSobreIPI: TDBCheckBox
          Left = 40
          Top = 15
          Width = 182
          Height = 17
          Alignment = taLeftJustify
          BiDiMode = bdRightToLeft
          Caption = 'Consulta autom'#225'tica da tributa'#231#227'o'
          DataField = 'CONSULTA_TRIBUTACAO'
          DataSource = DSCadastro
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 0
          ValueChecked = 'S'
          ValueUnchecked = 'N'
          OnKeyDown = PadraoKeyDown
        end
      end
      object btnConsultarTrib: TBitBtn
        Left = 19
        Top = 16
        Width = 140
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Consultar tributa'#231#227'o'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnConsultarTribClick
      end
    end
    inherited Panel1: TPanel
      ExplicitHeight = 453
    end
    inherited Panel8: TPanel
      ExplicitLeft = 822
      ExplicitHeight = 453
    end
    inherited pgcFicha: TPageControl
      ActivePage = tbsICMS
      ExplicitWidth = 802
      ExplicitHeight = 453
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        OnShow = tbsCadastroShow
        object lblCodigo: TLabel
          Left = 0
          Top = 13
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo'
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
        object lblCodBarras: TLabel
          Left = 0
          Top = 38
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo Barras' 
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
        object lblDescricao: TLabel
          Left = 0
          Top = 63
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Descri'#231#227'o'
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
        object lblGrupo: TLabel
          Left = 0
          Top = 88
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Grupo'
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
        object lblUndMed: TLabel
          Left = 0
          Top = 113
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Medida'
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
        object lblPreco: TLabel
          Left = 0
          Top = 138
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pre'#231'o'
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
        object lblPrecoUS: TLabel
          Left = 0
          Top = 163
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pre'#231'o em US$'
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
        object lblCustoCompra: TLabel
          Left = 0
          Top = 188
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Custo de Compra'
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
        object lblUltCompra: TLabel
          Left = 0
          Top = 213
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #218'lt. Compra'
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
        object lblCustoMedio: TLabel
          Left = 0
          Top = 238
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Custo M'#233'dio'
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
        object lblQuantidade: TLabel
          Left = 0
          Top = 263
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Quantidade'
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
        object lblQtdMinima: TLabel
          Left = 0
          Top = 288
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Qtd. M'#237'nima'
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
        object lblUltVenda: TLabel
          Left = 0
          Top = 313
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #218'lt. Venda'
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
        object lblLocalizacao: TLabel
          Left = 0
          Top = 338
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Localiza'#231#227'o'
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
        object lblPeso: TLabel
          Left = 0
          Top = 363
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Peso'
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
          Left = 410
          Top = 163
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador1'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label18Click
          OnMouseMove = Label18MouseMove
          OnMouseLeave = Label18MouseLeave
        end
        object Label19: TLabel
          Left = 408
          Top = 188
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador2'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label18Click
          OnMouseMove = Label18MouseMove
          OnMouseLeave = Label18MouseLeave
        end
        object Label20: TLabel
          Left = 408
          Top = 213
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador3'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label18Click
          OnMouseMove = Label18MouseMove
          OnMouseLeave = Label18MouseLeave
        end
        object Label21: TLabel
          Left = 408
          Top = 238
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador4'
          Color = clBtnHighlight
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = Label18Click
          OnMouseMove = Label18MouseMove
          OnMouseLeave = Label18MouseLeave
        end
        object lblAplicacao: TLabel
          Left = 408
          Top = 263
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Observa'#231#227'o'
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
        object lblComissao: TLabel
          Left = 408
          Top = 113
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Comiss'#227'o'
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
        object lblLucroBruto: TLabel
          Left = 408
          Top = 138
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '% Lucro Bruto'
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
        object edtCodigo: TSMALL_DBEdit
          Left = 100
          Top = 13
          Width = 141
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CODIGO'
          DataSource = DSCadastro
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnChange = edtCodigoChange
          OnKeyDown = PadraoKeyDown
        end
        object edtCodBarras: TSMALL_DBEdit
          Left = 100
          Top = 38
          Width = 141
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Color = clWhite
          Ctl3D = True
          DataField = 'REFERENCIA'
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
          OnKeyUp = edtCodBarrasKeyUp
        end
        object edtDescricao: TSMALL_DBEdit
          Left = 100
          Top = 63
          Width = 674
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'DESCRICAO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnExit = edtDescricaoExit
          OnKeyDown = PadraoKeyDown
          OnKeyUp = edtDescricaoKeyUp
        end
        object edtPreco: TSMALL_DBEdit
          Left = 100
          Top = 138
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PRECO'
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
        object edtPrecoUS: TSMALL_DBEdit
          Left = 100
          Top = 163
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'INDEXADOR'
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
        object edtCustoCompra: TSMALL_DBEdit
          Left = 100
          Top = 188
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CUSTOCOMPR'
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
        object edtUltCompra: TSMALL_DBEdit
          Left = 100
          Top = 213
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ULT_COMPRA'
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
        object edtCustoMedio: TSMALL_DBEdit
          Left = 100
          Top = 238
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CUSTOMEDIO'
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
        object edtQuantidade: TSMALL_DBEdit
          Left = 100
          Top = 263
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'QTD_ATUAL'
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
        object edtQtdMinima: TSMALL_DBEdit
          Left = 100
          Top = 288
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'QTD_MINIM'
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
        object edtUltVenda: TSMALL_DBEdit
          Left = 100
          Top = 313
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ULT_VENDA'
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
        object edtLocalizacao: TSMALL_DBEdit
          Left = 100
          Top = 338
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'LOCAL'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 13
          OnKeyDown = PadraoKeyDown
        end
        object edtPeso: TSMALL_DBEdit
          Left = 100
          Top = 363
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PESO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 14
          OnKeyDown = PadraoKeyDown
        end
        inline fraGrupo: TfFrameCampo
          Left = 100
          Top = 88
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 3
          ExplicitLeft = 100
          ExplicitTop = 88
          ExplicitWidth = 313
          inherited txtCampo: TEdit
            Width = 313
            ExplicitWidth = 313
          end
          inherited gdRegistros: TDBGrid
            Width = 313
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 290
                Visible = True
              end>
          end
        end
        inline fraUndMed: TfFrameCampo
          Left = 100
          Top = 113
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 4
          ExplicitLeft = 100
          ExplicitTop = 113
          ExplicitWidth = 313
          inherited txtCampo: TEdit
            Width = 85
            ExplicitWidth = 85
          end
          inherited gdRegistros: TDBGrid
            Width = 313
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 60
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DESCRICAO'
                Width = 200
                Visible = True
              end>
          end
        end
        object edtIdentificador1: TSMALL_DBEdit
          Left = 508
          Top = 163
          Width = 266
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'LIVRE1'
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
        object edtIdentificador2: TSMALL_DBEdit
          Left = 508
          Top = 188
          Width = 266
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'LIVRE2'
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
        object edtIdentificador3: TSMALL_DBEdit
          Left = 508
          Top = 213
          Width = 266
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'LIVRE3'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 19
          OnKeyDown = PadraoKeyDown
        end
        object edtIdentificador4: TSMALL_DBEdit
          Left = 508
          Top = 238
          Width = 266
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'LIVRE4'
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
        object memAtivacao: TDBMemo
          Left = 508
          Top = 263
          Width = 266
          Height = 120
          DataField = 'OBS'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          MaxLength = 254
          ParentFont = False
          TabOrder = 21
          OnEnter = memAtivacaoEnter
          OnKeyDown = memAtivacaoKeyDown
        end
        object edtComissao: TSMALL_DBEdit
          Left = 508
          Top = 113
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'COMISSAO'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 15
          OnKeyDown = PadraoKeyDown
        end
        object edtLucroBruto: TSMALL_DBEdit
          Left = 508
          Top = 138
          Width = 85
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'MARGEMLB'
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
        object chkMarketplace: TCheckBox
          Left = 508
          Top = 388
          Width = 97
          Height = 17
          Caption = 'Marketplace'
          TabOrder = 22
          Visible = False
          OnClick = chkMarketplaceClick
          OnKeyDown = PadraoKeyDown
        end
        object pnlEscondeWin11: TPanel
          Left = 185
          Top = 112
          Width = 230
          Height = 26
          BevelOuter = bvNone
          TabOrder = 23
        end
      end
      object tbsICMS: TTabSheet
        Caption = 'ICMS'
        ImageIndex = 1
        OnShow = tbsICMSShow
        object Label31: TLabel
          Left = 10
          Top = 69
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'NCM'
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
        object Label32: TLabel
          Left = 10
          Top = 138
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'IPPT'
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
        object Label33: TLabel
          Left = 10
          Top = 165
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'IAT'
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
        object Label34: TLabel
          Left = 10
          Top = 192
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'IVA'
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
        object Label35: TLabel
          Left = 10
          Top = 271
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CIT'
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
        object Label36: TLabel
          Left = 10
          Top = 245
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CSOSN'
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
        object Label37: TLabel
          Left = 10
          Top = 244
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CST'
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
        object Label53: TLabel
          Left = 10
          Top = 42
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Tipo Item'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label51: TLabel
          Left = 10
          Top = 217
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Origem'
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
        object lblCIT: TLabel
          Left = 193
          Top = 273
          Width = 302
          Height = 13
          AutoSize = False
          Caption = '5102 - Venda a vista'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelDescricaoNCM: TLabel
          Left = 215
          Top = 71
          Width = 48
          Height = 13
          Caption = 'Descri'#231#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label83: TLabel
          Left = 10
          Top = 295
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CFOP NFC-e'
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
        object Label72: TLabel
          Left = 10
          Top = 323
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CSOSN NFC-e'
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
        object Label84: TLabel
          Left = 10
          Top = 323
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CST NFC-e'
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
        object Label92: TLabel
          Left = 10
          Top = 350
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Al'#237'quota NFC-e'
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
        object lblImpostoAprox: TLabel
          Left = 110
          Top = 92
          Width = 385
          Height = 13
          AutoSize = False
          Caption = 'Imposto aproximado (Fonte: IBPT)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label95: TLabel
          Left = 10
          Top = 113
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CEST'
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
        object Label118: TLabel
          Left = 9
          Top = 17
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Perfil de Tributa'#231#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Image3: TImage
          Left = 164
          Top = 193
          Width = 17
          Height = 17
          Hint = 'Exemplo: Para 55,77% de IVA, preencher: 1,5577'
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000110000
            001108060000003B6D47FA000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
            6E4944415478DA9D54CB510241107D0D559647429008C408840C3402E1E4EF20
            46B04B04E041714FAB1168060B11B8194006EED952DBD7BBACEC1791AE1AA619
            BA5FBFE9E987A068BEB6F0811B28BA5C1D085ADC23EE21F76746CC7029CB6C8A
            E4001ED5925D9E46718232D1FCC4BAF4CF624F3122D05319C45307DF18A2C180
            7399A0CE3C1D1264CC4C9771A335C854FBF47C7CE108D712E22FBBD70E8B0569
            4121C0010102AEBB4A069E9E906144FAB31223C0C11EDAB262E1E042DA9555A7
            EAF27399ED41A6870BEB9DD009E8CC19E4FE1BC47E131C1B93777E3D2DD1DD06
            E481576DC237264A26BD9D40A66ACF1E244C14035CC9EB4E200DBC6CD7131BBA
            AA22999EB8F124D6BDCE264B5E672418532BFB58D44E6A322761512FB144009B
            DE9EAC0293C1F964838B136B82341B48F47B6613DBC45BDC4BF66AAD9DE45A0E
            D7ED46EDA42205277CD5C7BC8AD3E9354B656FD680B139E4599FAB55BCBA942A
            999652D997FF4FE6ECDF247735DA0F2478B7D2783B7D950000000049454E44AE
            426082}
        end
        object Image8: TImage
          Left = 164
          Top = 272
          Width = 17
          Height = 17
          Hint = 
            'Vincula o produto '#224' um CFOP e permite preencher o % ICMS diretam' +
            'ente no mapa ao lado'
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000110000
            001108060000003B6D47FA000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
            6E4944415478DA9D54CB510241107D0D559647429008C408840C3402E1E4EF20
            46B04B04E041714FAB1168060B11B8194006EED952DBD7BBACEC1791AE1AA619
            BA5FBFE9E987A068BEB6F0811B28BA5C1D085ADC23EE21F76746CC7029CB6C8A
            E4001ED5925D9E46718232D1FCC4BAF4CF624F3122D05319C45307DF18A2C180
            7399A0CE3C1D1264CC4C9771A335C854FBF47C7CE108D712E22FBBD70E8B0569
            4121C0010102AEBB4A069E9E906144FAB31223C0C11EDAB262E1E042DA9555A7
            EAF27399ED41A6870BEB9DD009E8CC19E4FE1BC47E131C1B93777E3D2DD1DD06
            E481576DC237264A26BD9D40A66ACF1E244C14035CC9EB4E200DBC6CD7131BBA
            AA22999EB8F124D6BDCE264B5E672418532BFB58D44E6A322761512FB144009B
            DE9EAC0293C1F964838B136B82341B48F47B6613DBC45BDC4BF66AAD9DE45A0E
            D7ED46EDA42205277CD5C7BC8AD3E9354B656FD680B139E4599FAB55BCBA942A
            999652D997FF4FE6ECDF247735DA0F2478B7D2783B7D950000000049454E44AE
            426082}
        end
        object lblIVAPorEstado: TLabel
          Left = 193
          Top = 194
          Width = 70
          Height = 13
          Cursor = crHandPoint
          Caption = 'IVA por estado'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16752400
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = lblIVAPorEstadoClick
          OnMouseMove = lblIVAPorEstadoMouseMove
          OnMouseLeave = lblIVAPorEstadoMouseLeave
        end
        object edtNCM: TSMALL_DBEdit
          Left = 110
          Top = 69
          Width = 100
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CF'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnChange = edtNCMChange
          OnExit = edtNCMChange
          OnKeyDown = PadraoKeyDown
        end
        object edtIVA: TSMALL_DBEdit
          Left = 110
          Top = 192
          Width = 50
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PIVA'
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
        object edtCIT: TSMALL_DBEdit
          Left = 110
          Top = 271
          Width = 50
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ST'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 10
          OnExit = edtCITExit
          OnKeyDown = PadraoKeyDown
        end
        object pnlMapaICMS: TPanel
          Left = 489
          Top = 74
          Width = 303
          Height = 272
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 15
          object Image4: TImage
            Left = 17
            Top = 15
            Width = 245
            Height = 243
            Align = alCustom
            AutoSize = True
            Picture.Data = {
              0954506E67496D61676589504E470D0A1A0A0000000D49484452000000F50000
              00F308060000005EE85078000000097048597300000B1300000B1301009A9C18
              000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000030
              8B4944415478DAED7D5D76DB46B6F50148A5EF5B98114479BDABDD5246206504
              9247206904921E6F9C5CC9AB93F4F7266B0496466079049647602ACE7D363D82
              661E3B2281EFEC621D1A86411200513F206AAF9558A4281200B1ABCEEF3E1105
              348AFFF73E3D9D4674A61F8E93849EFFFC8FE8CEF57105740791EB03D8145CBE
              4B075B5B7495A4F4E774429797DF47E37FBD4BB7933EBD7A9CD00F78ECFA1803
              BA8140EA86F0DBFBF4D534A1879F77A2CBECF3BF3CA4376942373F7F1FDDBB3E
              C6806E20907A4DCC77E8297DCC131AF8F57DFA8E77EAA7BC538F5C1F6B403710
              48BD069479BD45AF98D0AF8B08AD08DFA70FCF9E44DFB83ED680EEA033A406C1
              9AF26BF15E7FEBD36912D121FBD0E73F3F596C5AFFFA7BFAE1D93FA2EF5C9F7F
              4077D00952EB80D5073EDB213F1CA6537A603F7738E59FAB10FD9FEFD3FD28A2
              03BE6820F3ED74422F56FD3DFFCD651CD15134A5EB1F77A217AEAF45C0E6A313
              A406B0633E4EE9875E9FB629A1FD38A69D94689B494A514A63DE7541F63FA709
              DDC0FFFDF5FFD20B9AF26B819876F9FF8334A511FFEDEBC9EC35A517036586F7
              E85DDB776C2C6A3DA20BFCFCD7844E429CC04F7486D4D83199905418CC7A97EE
              F24E3EE84574C1A4BE465E19CFA55BF492897CCE3BF268DD1BB8ED6638AE07F5
              E8152F704F79F1DB8F7A74F4ECEFD1F7AE8F2BE04B7486D4B25BF2AEBCD00C66
              E21D47BC83FFF8F7E85C1791ECF28D7BB2EE6763878B533A63521FBABE0E7500
              F725EDD3CBECEEFCDBFBF40D2F76CF43AACE3F7486D4006ECE698F2EF9A45326
              582159C50786A93D69C8C4FCF58FF443F248276D25008E9FAD9CE77CCD6EE6CF
              F102C82ECBEECF4FA2B335DE3AC0003A456A40E795DFF10E6CC514C6CDCF26EB
              5E133BBE0BFCEBFFD28B4942DFE4C92BD572CF9E0413DC37748ED400769EC747
              FADE46E9A6FEAC1FDA1854923C3C1F7F61F1CCAFEFD37F871CBC7FE824A96D95
              6EB67D97E605E9259BDD6FB366F767BF7F9FBE4B7B74F8D37F471F5D1F6BC027
              7495D4CA94FCC970DEB8CDC124B54BF7E8CDB288FD3F1FD2176944C3FF5D40FA
              0037E824A97534FA6851B0AC2980D44C8CE336EE642A6098D2E8D912C24ADEFA
              C727D10FAE8F37E0133A496A496F3D4ECDFAD56DEED02A1B0BD0453D56E21301
              E5E03DA99BACD9CE022678CCFE6E9AD2EB28A223548A355DC6697A27D3053247
              285B95E72254BD118DD1068AB2D8E994EEAB5E3FF5BE7DBAFAA9C4712F2BEA09
              70036F492D050F7CBF0C62BE494D9425FEF3F7F49052DA8D232642445714A932
              D0EB670DFA8892F7E6F7BDE77379DD940A0A16BB7E8F5EF07B7FFBD7ACB573AC
              9FDF46296C94D06E14D3059FDF9817AD112F5EB78F33828FE4EF7B3DDAE76B3B
              48A634CA5A1355620E3A42FEC6568A306035BC24B5480225099D8304A62BB224
              4A1D3FD273EC507C5186FFF3247ADED4FBCB8D6F22B5C5D7E6052F18E3A29D52
              0275D4573BF8319FD71E9FE73D9A5198CC574CF86112D19FFCFC0E137F9B5F33
              64F28FF935FB558EF597DFD31BFE7E86A161C50F7845EA4CC380ECCC73B3D154
              ED744672689E8BC5672D2B27AD03F8A8EBEE666A1726DA8E7BB346132627FE1D
              F0E383A2F7568B215B2052A3AD630958182F98BCD7D99D58EDDC7DDA65A20FAA
              9AEC12290FBEB51FB0466A55A2B945A76C163EE4CD40DC68F06BD93CE57B8A9E
              17F5279BC889AA260536F189179067DF47C3CF8E15E5A431ED2C2ABCA8FC5915
              0A5E846030A195DF1FA92E31C22E1AE9DD15BB337F7930ADD5FB2D7219B093F7
              224A51CF9E7D7FF56F83049418C58F4FA2A74DBD67403D5821B5EC86BCB33C87
              0FC737E9297FF036FF6AC4240691DFF23F77CBC4069013E5A3BD6FCA2755263E
              9BF468C75C445ADCA87C6C83268240AB024A4264DE894F1589610A27F4368D69
              C82674A5BEEFFCFB6EF5E90D5FF7BB265D8A22C0DCE7EFF5DEF4E7042C871552
              375159D554C18898F853A20751FD5CF6994D917A5197584645E59817BDD7B462
              71ABFDD916882DE708BF1D9568BC868D833CB27D5821B522474CDBEB74F42853
              798B5EE1E77416D11D54A9DF16322F33F1BFF8CC86EBB625620DB31EC20CBC23
              0FF8E61F30A14BA9A8AC0B658A13ED981638900E2E3EC7019FEB9EAD3AFB8019
              AC903A53EC519B20DA3C3D939B1FE62CFB9CE3FCCE8D0524FBDC3C925E711734
              5DB78D6608BEFA3FF0FB0FD77FB70A9F3B3BAFD3A653774BCE136ED76DD8B1ED
              C15AA02CA39C719F24F4BA4E514416AA0493DF274B6015ED257AC35BF149CCEF
              8F3C771933BBF078DFA7EFF201B4A6E0BA6D51A2D5BC8BDE6503682680EB984C
              E8BC8D55756D85F59496DA29223A40D1C73A292AD97120CF8B28B0AE0E4394F8
              B9DA89D8C66653FBBCAE7F6AB23D13452F7CBC07AEBBB77461CC8176311A3B4F
              8913F057B03F65DF3A549BD9857552CF03434487EBEE54D871263DE5BB6D234A
              2C04E6DD21E55DF6FB75765944DBF9E28C4C7472E1BD994C431BE6EFCA635952
              BC52071977C74A9C20E04B18273588477D3AC2AA9D464CBE84FEE47FEF4C7EE1
              BFFCC17EF5DFD723A3C9F247B80E299BA4264CFBAA6852E9142A29EC567D3799
              D2D916945AFBAA9068902D630D300FA3A4D611EB97E9946E27092150326ED397
              DB543FB4D45923121CC3AAE005CE27C59026AADD9468239BF2283EC16ECD96D8
              3EA2ECBD98CE7A90634EE9B50F9649176094D43EED4875A052334CC2AAA6A954
              C9A5485DF1CDCD4F217575CF37F6032AC0D852392AD30165ED3C9B20B54EFFF1
              E2B5CB77D5BEA42F958BD4578546877CFE4150C1028C925A950EF6E85BD31156
              93C75FB5F8440702D12C01CBE46DB62416F0512E78DD12DC6CFA0FD33FF3A5A2
              58E4BEEAB3C516D173DB29BC2EC2B84FDD66491F95639DD07595635F25F1634B
              75A50A1005EF45F4759DC55707C68EA5461E1D5BEC66A4D1ACD904854223140A
              C1FCE605EE2EEF7EA149A58DA28C3EC34AA04C2B52B66EF0BA1E435BE9B85795
              B34A9FB84F12407A277DC58BD188BFA7E76548F65951CF84EEB0F0E973BBE2F7
              19CBFBE8DA81AB54FF1D089E6DF114D287691FCDC14A4AABADEA18CB72D5929A
              9BE2264DE84182406576625F2580246F9D246C592DA800930500453DF1846E22
              26317E46F929FED52F1BAB810844772AA6F0F8A98867DEE2C9C03823BE8647BC
              301CB77924916FB05D26EADD8DBC0C8B6202F3AE33A2D710E7E3AB788A0E3410
              A1CCB08075CC5DD3906AB3645A3C5144B95309BD4565206AE9A58E5CE9B1C534
              96364FFD3EFB4526F7FC73B6F873423EBB71582B3E3159CC61124511FCBC1E76
              5E8BAC4C34597C4FFEF1DAB7E0D1226D3599D6D16712C2CC06A1F1BC6E1905C1
              9F6EA13F7DD6FFFD74D979F1FD80F147AA765F35BA6CD1052F90BB70019247BA
              6D630CC617D823754BE5648B027D45932960526322249BE247BC630DCA948022
              6A8CF416A484F0986FEA1B5F7A91713ED9DD3AAB03AE15558E507BCF3BF3A9AE
              AF7F91518E59990A543B7BC4BE38268CFE91BE43B92FC6082325C6D7E394FD70
              6A6B80D535AC9689820C8F13FAAE4DA61622E0698FCE24DDA354517837CAE799
              458113820F75CC49093235AD8F5617F3A68F9968E10841ADEC903C25DA1811C8
              7D93DD9135E15FD28A9D5A320BFDAF686F32A128BF00E07DF85A5C7CA69DC680
              899F57CF09F81C5649DD461DECBCFFBB88D44DC137F510452E8816B2AB00EB23
              2BEA00751634E688F083EA9CA3D5FDEAA23AC3EF71C2D6C9CB6541B26C604D21
              A5411CF3E239EBA927A9560C04FF04DBA46E4C49C416443544DA07AB6862AFF3
              7936E487CA202BCCF8377E9C0F6E659452BF5F1520D441C42B8827A43395D397
              59C1C7B290C927BDFF5084601C41FC62DADE51C14DC32AA955CB21D1814F8517
              652037365B19B73200C0741DB3E885BB9E6B9D954FD611FF2FDA59D5FCED84CE
              E15F2378D68F49B596A6B35801C41247BC2B8F90DE82EF8C455D05207971A873
              1DF3318D302BFB735825B569D3D5F4B14FFA74C6FE9CB508BE5C2FF8956C665E
              473DBAB71D298775C59FBB4320A4D661CFBF46FC63746521A29DCCF2D5F7427E
              98F0CA6C9ED20859844533AFCB402C996CDBAE14F4E0674844B135783F79A4EB
              AE9AE456496D7BE0FBA640919B773FDE310FF80BDB559344888665ABBFD68134
              A760A75DE4274BDCE12F2612A683F489AD19DD6AAB5EC084C631C3FFE545F11E
              0A38758B4D16D5CEAB9D9FAF0D2F2E4FB52EFA0582783EB830B6615FF9A4818E
              A0AE430A3BA0F0D2942EF9BA80D8022680A01601D2C6F9E095CA22F0F3514C47
              75FCE8F9E764F2DBF96B92B502A589C4976C824D04F3BBC56842A5D516E00783
              60BCE3BF5E47C042D7E3172E0AF9618AF920A7EB6B600B76F3D486153ABB061F
              DB381701A446EBE53A84AE23D898CDB8A8CAB5988E55106FE6C68CE11A60B1C9
              0F106C33AC8EDDC9CFAC0AA807B939D735656D1FF3BA4547F9F2DC527FA377F6
              2D0855CCA6A8422AFA3E1B1F409A92EFCD63F6C1F77C7167D6813D5223E25950
              3914501EF3796444876879CC96666E3AB265AA65FF466A0A7A133A41747C950A
              4F5B4B99F3B0D6A58576BDB65F2C97C8768675ADAB49B226C4BB6815692CE96D
              5729B9923B3C027E683FE51F953E3D9BEAE8311F2DBADEA8BD80F65C3A552381
              C76942C329D59F7DD6045A334BABEBA8637A6E0234A1DF48D14A95BF95E92010
              69A8B2C38BF4346ADBD5EC6ED265AA28A04969344DE8414D1CEDD1293FABE686
              E1D768628921B20825558C54C2C2E0A0E3CC0EA96BC802057C429332BE6D8374
              70D571DB90BBE63B7C884059DD0D45864F3C7B123DCD2AC4F0317D444FF9A2DC
              BDA41DE75D78996618D3B043EA909B5E0B6D8A72378975E330AA1A0E03FAD897
              AE137B1089EB6CF0AC8E426E66DE79CAEF756EDA340FA46E01A4CDB10DF9E826
              B12C276D1A7941C5F931AD318E49EAF94D4F01B5223C180A4ED6431BBBDB9A80
              ABCDE0B7DFD32B34884C0A268BAC2BA7AC4A6A89F64C068DEDA8893A9CF0B809
              8014147F53F75D1B07EB82D4A2C1B668016D4296CBB46CB6715287268EF5D166
              EDF4BA70111C2CE3C367FBC7EB9AD0A6F3E18D915A931751BEB94A4532A5D194
              57B5AD352F429751A7E86213B04E7B665D20D25E467F5CFBC6DFAE93A235B950
              AF45EACF6A696761FBFB24A58F2A098FB2BC58D5D5A273671B2D715DDA699A02
              F2D3489F74C99F16B923DB92D255CCFD7589AD23EB32E462D4E479D4227556A7
              0AC97DA2C5F93A4086A4D51D00DF55746D979676C98437848983F1B75050AD72
              AD517DD64B68F4634DFF5A17655D344DEC4AA4CE90F9500BBEDD0493DA1C944C
              504A275D580C658C0F5B78D7EBCE16AF8BAA91ED26323B48574206AAAEB45311
              4A935A662275B1F6D80590566113F4CF4D37BB458A486B875FBABCAF50F948EC
              E7962D2C69CAEFD71922C843D35F350B65B228456A1CFC34A1FD891EB1D2D035
              0C58005D9A78BAE96940E557F6E90DA574EE434D7B958188E21A35E9F72B3F1D
              324C6C14AFA3D6B292D42A50831DA363D54CAE203BD75F1BBE804AFD02FF3882
              7638EAA86D68AE2D3B9E2AA674D30AA67A817BC9D7E29ADF771B052A75851B96
              92BA2B26A04FE84A37962AE2E8D148FC6799B8E96AE4B14A3131A1CA16F868A9
              A40FF9F14B55318F53A5744CD34FADA5731DBAD99412482C0FF9F71FF9E7B14E
              152F6CEF5C486AAC44FC06073F3E899EDABEC05D45B623C8F5B1984651634413
              F9DF3AA8DB1A8C2187714AC375A3DFAB267F4A2B6894D2762655BCA3DA3B13BA
              CE6F008B493D2B5C6F3C8716B0185DBAE68B72C22A4DC4372CE677D91AFA50F7
              BAD7AD7ACBB670AEE3722C9ABF5648EA206A601F5DBBE6459343053264CF4669
              F1BAD7BD8E5640D3054579D7A198D4F8D03023D82ABAB44B174DD9C8C266679F
              6A9649E8AEEEBD0E1D72ECB8FF5B32066262169BA8C3483CA290D460FE5F0E2A
              7ABA8ACEEDD22BCED7A62844764E769DBFAFDA4167AA8D16F18828990D395848
              EAAAEA0E01F5D1A52EAC4C97D342AB4404036DCC2C5BB763AA2A57AAEEEC6521
              A9509C4721A9D574CA98AEBA620EBA4497EABBB3B9D865293BDB9A768862F722
              FA50A7E003052B558A844C915A8E05C5330BA3DF196287964983E8CA1856BD43
              BF2A23965FB5B1A209D41DADBB2CE0B7E0F5AF12AD460A333C46047CAAE68EAD
              CD31710596169F64ED746357B3E35834F06DD350D6C57025B2A867A71F57FDDC
              2A0B900886205DC7847E408E1BD341A39876CAF471ABCF83B5D3A35335DE3857
              71265A7651EE43519EB62D8F7B7DD53D627CC07A97B129532156A1EC8E66A2A2
              2E3BD9048FA1DD8D0A2D4CE1D462FDE3AFA0E19DD2C7AA8524657D6AB1548AE4
              8E8B163C7051FD9BB16AE6A5B5B35252689063F4D29EC80F4B56614E6A69DAC0
              09CB73FC871FD92CBCA400A358C7A76B0BCA08109890301299DF24A573268E2A
              AD54B3B330C3FA9358FF38E19DB3CEBD5E269A2DC1C1456DA5D9F798BF362598
              E3484FEDA2B8043FF37F83BC7E9A101DE7808521D6DD5E92EC3FEA4A4AC54748
              25D5A63672943153F50DFA0E5D5B78DCC4144AD3F9FF32C29AABFC7559CCF8C7
              E7E8CEE305E6BC60801F267ED0A2DE7AC466D4E000D2E6B7163DFFFA71A2544C
              C62130E606EA7BE8D111FF78C20BEC46A513CBEA652BBF309DE9DCC53DB5D1D4
              DEB54D147A147D0622FACB485DC6F5D03EFD014DE9BA6E2AF933F35BF931A43A
              4266D0337B31206C92A8C8DCC8D44509F81CEABB48E99017D8EF37E9BA83D469
              4CFB55F4B22B07A17A339F195D4CF04F7F6597129D4D266342BF4158016631FB
              B9D39965F1D9A225E6B48D925758DC11BABA164E22C02AC75F4214A948DB701A
              66611907E21A6942BB53F6BDE29477294B0D0D3650354D55A5CA4EA49030DE97
              12F6432335A0EE8017C7319BF0E64C6FC4A1A6F41D7FCE90CD66F8BE7B457DE1
              65E209CA449F0DD5AB6DA5896F1EB16990F2AEF0CD32B3686EAFEB415F457935
              1539EFD12E9B100359294D5C4893C06A4FA42EAC751724A3A4015371BC495AE9
              75CA60B30528B8B7161133A3CA63B5AC7951504F9D2BD44B22BA91C0A7B81EF8
              19D604FBCCE36C59A95E9476635E0CD65153419E9A793A8C548026A2F4C7BF47
              E72B2F3476EF1E9DE915691CF14AA8579701A275FC7898446A4E2F7A3DB79347
              3AF19DDCCA64E1555DD21DE92CFA3FE0E788DD8FE7B6A662E453399B327F4C02
              49556762E9F80246C592BAB7F83ECB07BC5C56E309A98B0828AAA8D21289FA72
              3E17DE44691FD64404F776362CEFF9575BB4C7D6D9A5581442CC6CC5994871F3
              35503DD44867211DC756C2307B3DA48E5DA2DFA23A51FAC2E3837A7D3615276A
              20F7177F23173CBB62F904A9954DF060163BF84C19558E9F2FFE252F78B7A68F
              271B4CD994F963D23DC477F36D1D85506D3921573B56A665AC64A6E79577AE47
              24AF6AE6980FB06712F3EBEEB266B92AEC8264D14C70F145E6F9CFEA1632AEC5
              6D3CA13B15059FBDDFA7D9D911CDEEDB54F9F6E7F33CB5AC8C4D86FF65956693
              FCCE37629791DFB5B513E4D3229B32AA689DD9D279481048163AD733BBCB6AC9
              6517A60AE78AC5608FE0CAA64ABD77A9CA2A3E43E5DF51729CD2F667156545F3
              78D7859822BC9A8CCA98F8365025D591AFF6910BD8E4F1149546AE3332D50734
              AD6F97F7CB5DD65648449B1E3F698A358D5A8B814E8B7D51FB6D82D8EA033FCD
              E675DEF955A5894254385069A7460BCD800B3D8F5232017793C759714091209C
              B82ADA77DF27F8EC78BF59EDEE1D16BD7C392E2CA7B847DFFAB21056014C4676
              6BF69BD4B7CB2FAEAE6AE6E784D6A599363F7B15745DF86571EBA5A17AE47971
              45B2BCF5CE2484A45516977C545CCC9C5E8F3EB04F7489E09A2AAF8D68C08F61
              FEE0BFA10ABAC5AA9062A0D21E4C5CA9929AE714D927E2C5E27991CF891B19FE
              7E5D613B17C8A87034B629141578A8A050423736FCE98CA618BE47CA577CF902
              6DF11DAD121E6CDCFC133FD5B6CEB32C54088CAD3B9400BB04EFA20880D0A2A8
              AE94F62D0A2456B956BE061B0BAFCDAC65F7A049B3B86857B629E481CC04025A
              BD47BA2B9372420A8EFDFD7DEDDF2243342A2A4C691A6AD38C68BC90D488EC31
              096A0FFF5A0531C74D9B315932F317F3BC891556911AAE84C1C206814A67F4E8
              85A4405CBB2EABA0F4EDD8BA68321558242C50659AC63AC82A8AA863E1FB165B
              7551AC40E662E97B4DB5562A62478ADC7BFC1DDEFD35FB0E8D1CB3D4B92F24F5
              B23C5C93176C0A1F205691BE7B881D2E1329AF748233DDF2A326C92C284AAF98
              46B6A8E13F13BAF591DC65A48AEAA0C81D3499C797422AE86C2323C48BD4B92C
              5245C7320F06D3F25958EBC695C40D2CB40C3381C4A52209B6F280F36904C8E9
              91FA57B59DD1CC8F5580CFBAAAC97E3EED80E80C7941E4F64CF83EAE7AA0F548
              E0633592654DCDE8EC35631F785B027DF1168DEB96299A9CA59D0F94559D5029
              D0262A74C51FF27D0DFF7A9F5E603CB3145215BD468E05D71F16499FDF4BFD4D
              C9699DD949242828A11E7D9B4EE94FCC762FBAB7451481EFE7C3793E1A4855EB
              288E6BC6939406D22FB090D4BA73EBC8C590B64C608AB2497936675E66FD4B79
              1DDF9403FEDD819E97FD3A9BCC3705972927695ED0A5BB08CEDDA78F7CDE25AC
              1CF1F7D8D2D8912A3ADC50F2FB74662ACE7B7855F5126E3A527AD2A8ECFAE2FD
              5116DCDBE29B33A14B5379E3BC095E5479B50AB29B818C28DEC03D83D80E2AF9
              60D55599BCA92DA73D4DFC4A239DD104C2C7BEAB0A4A66599081B256F9DACA42
              FDD9381E2A2ECD96EF93DD3315AC95C574B94FDDA3144DD9AA9E3B57AFEA0299
              8670C8C1A81D5DADAAFC38F9549933468A096A162689BDCCB7B27E4DB495938D
              BCE377BAE49594F44DA69C975FF79657F6FB65C11B49C3610788F5020BFFB0E8
              B51895839D84ADBAA7A6ACBABC946F268B517A61551560B88FF57796995705F7
              CFDAFCB245969EECE2BAFC7A7BD5389ECC397C5620B5D4A7EEC56CC6626E4FA2
              D235BBFC815FEB0A9AC20FD1818223B5BAF3CE61E20B9693506985DC22235FB4
              4A319132478C05529A1A9066E8D8B6B7B010EBC67A44E0D5F38616B9323DC56B
              7F46812B58D547CD36CDB88E49A02C98EFCFEF8A6A1AF8BBDB7E2495355979EF
              160930941E3A9FB9888535E2AA46950803DE4ED8BCC16E81D4C6BF4D144F683F
              E315888D68A314856841371514B3110FE8925EF732D898D4A98A71603ACFFC48
              9A3CD235EE41B917CA12D5174DB83AFDE579A0430DD6533E7D5889D4C0BC7B26
              938AD23BE4D5173DD986D20E6286A73399D5C2C8B68D944757E47D575E87D9B5
              6EB402B108BA0C72A07CD0599FC2F7D2EC81DF97A92E2B233F64E99A5592165E
              702DAE8AB25395492D1726938A523B645141870962498472557EBBAAC87ADDEB
              E0C30DE212ABE66299828CBD455C43F9F3095B654BE21B12206477F2B4A92693
              358E7D9F09F94A47AF8748E5AA5FF468A0A2E9FCE3B325C546BFFD911EF16676
              B6A86AAF16A9CBA0E92F5BFCE532C103A98135AD1D6D53AAC657E4BBA76C40F2
              C2C96CD7BE5671145EE48B766A695D14AD6D7EEACE7589A72894F413BA91409D
              CA3ACC22E10FA8C85BE4D6A151865FBBBFCC323246EAA67A82B37DCF65CB3BA5
              B2C7F4903F1BC276BE43EA8D6D4A2F2125344DE84176DBA2B6619D7FBF62B247
              93299DF9D4ED86483E5B9BF78BD27145D754785026ED668CD40074A9D6A95BD6
              A6F6615505125C14D2395893FE6EDEA796BC390622C43D354141459F3759BC51
              F2B5D606C42F9046D2925BD0D3130CCA1684D8C62AADF07C35A798DBD02E2F63
              651825753EED23D54BEC07ED22EF9D97631154599516C1B47A884EE3BCC9AA4E
              E8BCF9484F80409590FA1DD22EFCDC759BBAADCA427A78AD917A858EF7B2524A
              5F90D5F95E141792B9D9FDAF54B1CC619540A4515203AA7D9054A5D2AC4A2C55
              D2C30FC87FF3CD7094CFD589EAC7BA8D1EA66732FDF35D7AC8A41EEB1CF052A1
              42DBBB994DD88A5F00AEE66C357E1E3A72CD0BFF894C0D293C57528556F7CB6A
              438A609CD440D15C205150CC9B51797FA92EA4E7D975C597169D78E583388409
              D8945EF2E53B5DFB3C4A4C0DA99A7FCFC20AA90B0F3A97DB9C9BDCB95941B5DF
              9F2F4AD4A72B97450655C6B7B619759B2B2A7FCE06D40594710BA542AF6EEEDF
              19A9A5D30505246C5241FD63D0B424AFEB8A2FDBFEA62BE4EBB24D6113CCEF65
              B50D9F35714CEBEB9F3923352015427C0243130A16AE545604367AD27D40958A
              AE75E073BD7D15A8CD26A5EBEC222832504CE8B77583C302A7A4B6059D06913C
              A65572F9D2CD6512367DDD266AA65D23B7D99CEBCEC2C67AD13B416AC0953AA7
              CDE8B02B9499D1DC14B0CB31218EDB4C6A01167C085E44133A69525FBE33A406
              704398AE32CB635127CD2621AB4B6642173DF759ADD643CF43C796B69BD4EAEB
              14A9956E594C3BF9DD5AEB991DA433E589F3A66E1845E859E18075B3DF269449
              3CA56B3DFB0A7248469A3B36B18146C59522356BEC9BA6EE914E911AC86A694B
              CB2891527DBC8D12DA45317D136930110ADCF42099DC947C23DD41744F49EB4C
              CDE871DB34F36DC18425D739528BE42E454AA30B3248D7D97A5AF17392D9D0BC
              5A35DB65E72C6D02F21241264508CA146DB409A6EE93CE91BA0C543B61A2C6E4
              9CD6D9696D2881F882A24919D9FA8079938B96DC857A265FDB81D24DD3638796
              E9A491AEE3DE44D31BD59349446F9B6E3A09A45E823A91569733935DA0685286
              AE9A7AA5C7AC8EE6B3CB53FA1847AAD965A45FBA2F72B95962CB6E9F995D366B
              9849D542B91159049301D440EA25C8EA62C5A952E4C45CACA5852C5DDAA58175
              534CE2EEC004E587E3AF7A8ACCFBF979559B549D673A801A48BD02BA34715B06
              DBA900D8AC6FF7457E187DD77669A089BCB19226221539271DE3B8CCBFA6CDD5
              64DAF2C0A48FB708C46AC10F63A9D540EA1AC80EAEC3081C7E6ACC3EE33ED456
              D003DEE68683AA3039FE260F0C63E76B9CB669BCAF485EB1A97D82384D1AD3D0
              B49C5220F51AC00E1361C8377AC513BA87BE54DDE05A1B21B5ED362D93755538
              6D6391528B490452370C9B73935DC3C50DDB3652DB1CB92B08A46E189BD0F35B
              06228E60336FDC46A147178B502075C3687340A70A9A52A8A90244C031D8AE2D
              0BA6AB452890DA005C985CB6A035B75F35A5505305AB5A3C55B5604CA8E3DF41
              4E7C3A9B46397275AD5C68A20381D406A00268098D4D8B06D886C8ECA411DDBA
              90DEC5385B8CD32DBAAE1265E61FD5685A359A27A253570219EA7803A937079B
              20BB9387128AE4735A4766A72EE6A5A6BC0B6767540BA484345FB002C864CC26
              5B1BCB2298DF1B02DDB574517483B5152E5B48F567A33B6BC837EB3E8A7EFED2
              132FF17B2DA57B45133A59B4D868D25F45B3313DB7C99446985B855A74747D61
              F7373170C1D558A640EA860113B16837692B6444B12B424FA7F49D8CCD990F66
              D41D763423E97659EB4126B7B015F5351ECF6BD1533551E5A069D5579BF2C959
              0452370C5FE61F3701972DA4DA85795954D802B2F4FAB41B4F68DC942BA07AB5
              63DA6E32B21ECCEF0D820BD9241350FE684AA3A67DD15FFE48AF54830CBAB766
              935B300EF9B57C8EF8C836665E0B32CAAF8DE5DD5D35F704521BC0AFE8939DD0
              75DBABCA4C8912FCC28B5E76F70289277D3A6353788F4930A498F6D98F3E37AD
              23FEC5F9CE2AE42E1054E37F876C36AF6505A0F0243F56CA0602A90D6013C4F1
              4CA563C4A4CFBB2722911BB16F3B7120E59C3D3E2C3011543E89B623485D4534
              4C1FE9759545DA953F0D0452370CAD7B76D476F55053A6E322E17F65DD105DFB
              960AD412CF98207314F3E32A6E154639BB68EE09A46E1879B9DC1ED1EE9468D4
              365D2D53D606527E3DE48D49FBD24463492BE166CCFAD6BE41041DCA06415D8D
              7D0AA46E18181617F36A8EA827DFACFB7CD7DE4131252635F676AEDBB5D523EC
              467BF01F21D513B11FE7CBFC6A17DD57EA73FF48DFB998A25205A2463B65DF9F
              17EBE1B263D556DB4BDBAE582075839099C26A107DAE82497C54ADDB354E7847
              E2A7EF309FF8BFFA745434D6D7055CA5B1DA528597F1B977885429EA605930D1
              85B0432075C3D0258D5476651615952653297521B5DDBCE0343A7DB4EC67477D
              95DF7FEAF21A54C5AAC5C845C02C90DA31963529D8C46F7FA4476942972E6ABB
              01C9138B4494EB05AE2C561598A88A3CCB565820B563E8E8EAAB28A63B57DA5B
              BA46F955D36592758E439581229D14D1B00DBBF6B22C812C94B6ADB0406A4F80
              005BDAA3C355AA9C12644B63DA81283EEA97A18FB64E84D5E628DA52C7D31299
              65D4A63369778B161F2D697CE5C2AD0AA4F60465AAD0B4297786201BFB71CA44
              567DC331EDD14C93FC699D2A285F2AE09400434F75B87DF3D33FA26397C7B20A
              AAD924A1FD4552BF2E470405527B023D79F368510E34D3FE5868224BC04DB57C
              560C72C14AF06132A7E87FF3B17CEFB34F2DDAEF8B460049C0D1D588A0406A8F
              906FE897995E981292126DAF225E51245D0A60E22D356276B8E86F7C194020D7
              C0E741787A115C187FD0A6F7B1ABF45C20B567C8F40C1F401800850E5504E0E7
              4D096C8AF752DA83B9AE34C923DA8EF470F3EC503A58006C4246BEF8D3BC086D
              6FF5E915A574EDAB4F8DF2CF658BA0EB184520B5A7408D74D4A39D3AA910DC54
              A8558E521A3181E7FA5CB9E8B27A8E178E5D179D445F1CF32C4F7D8591347C57
              BE76A1815616AAA024A1D1A20A40D769CA406A8F61B221003B62AFCFBB774AC7
              08B4B9EE2A5375D2BC3BDB2E7AA983550525AE038F81D41E0337074DD8BF365C
              0C6252FD343B9616960334C20A73BA2D92555E5670E2438C2290DA63D8525091
              A98C4D177BCC23F2119D2026A0027FDA32C8D6C667944E9C47E097416A0410EF
              C004CBFC2228453C7C6E4EE30181D49E426E745B6911B55342842FA1D7714CA3
              75553FE43D8B5A0FB3C14034B7A0FD327A5CAC06EA03B2350278CC8BE00E5FAF
              735C274DE60BC427D81271AE221B48ED295C142FC8581BE94042BBE822737915
              745E7DF7D98ADD1FBB9FCFBBB39C8B2E3439C9061DC50A5112C51E45EB03A93D
              84DAC9FAF4D2F52038D95179E7FEF7B2BA745D387300BF99682E24389A385021
              6DFC1A6899E2A20A375D64F286097DEE0BA181406A0FE10BA9055AF163A7C8E7
              469D36FBC98329D1359BDA233CD77622CFCF4D2F56CB620DB68299551048ED21
              7C1CD95AD4ECAF0A5712FAA62D5328AB6255E598BA2EA81E8BE9C227C596406A
              0F015DEC28A1079F4C3A201BF892E9972E84FE6DA1EC6C692C7894D0D897AABC
              406ACFE04B6FF38A63FBA1FF15EDC5091D6B527BB1431938D75273B07C739702
              A93D83EFBDC4BA93EA42D5A51381CC4AA7CBC5544993A84254DFF4D502A93D82
              0FD54865909F3C31CF3BCFCA4D4BA7E134198E94A2EA0CCE6649E75185D4BE2D
              C481D41E410D69E39DCF17DF6CC971DEA409DDE48B4A5487181453231AA5D8BD
              3191128D23990A2BF8E2FD988EE3980ED0BCC1E7FB1C8AAA58207487D9A90F41
              A7B2BBEF32F5135708A4F6086D1983BBAA3006CD22EA5FFEBDCC86D6CA2CCA5C
              1779E4A2CA2B9375E815CF71E5EE9BD120F36AC45220B547507DB87CF3FB9A22
              D2DD49574CCA3FAB1EA3964E1EAC32AD7DF04F85AC4B7BA6B560A40FD2CE7904
              527B84CC3855AF567E40A64D609735B9E8B81C2C07A8F2D6291DAF22AB4B0DB2
              5508A4F60C303FD9EC239FFC6AB9D16D6982BB9A1A0A939B77E86832A5B312E3
              74BC1D821848ED19D44ED5A70F658A1E6C4044F66CB645AA405CC43EB745C184
              2AB24ED92188B68EAF0A02A93D84AB69898B8EC5B678C1A271B726B14A774CB0
              68BEB64F08A4F610AE35AEB2285B2AD9E8F93B089695918ED2FEFE1BD72208AB
              1048ED2198D42FF89BB9776DDE6957E08D6DFD6A172EC8A2DCBB40CA469329DD
              FA14EF284220B587F025B2EA32BD2473A06DCDEC5E964E9C4F0325F7AA266510
              48ED21406A57299DDC71382B7FAC5B7A5A17AA338E17B028A21729D1ADC83965
              F4D3BC6BB05984406A0F813E5ED7F2384A936BB64B3B5D5CF4B48B033E0E63E9
              233957A4ECA847BB4A337DA6E2720F018834A5D73EFBD07904527B08DBBB9420
              5F97ED5A8EC874604A2AE498B4DBF97315E55066C8950FC30EAA2090DA63285F
              6E8B5EE61B1C70C3FDAD4FA74ABD32A2F1BA9D4DF27EEC531E2FABCBB67EFE7F
              A4EF9229BD36119892F1447C0DAF974D03F1C515AA82406ACFA1C7EF60601CBA
              80C619F2DD4E2774C3BBC9FE3A9D4DE233F2CEFC9ADFEF852F3B9296093AA85B
              B585201FBB3083ACDC711D4B040B0BFFBD93E995751148DD02E8D958A7F8392D
              20DF3AA5A5D889F02FFB8E439F7CC765693D35C9B34FBB98088A56D5385233C3
              EE41D0AC49AD268244FC3AD21D626CD554B544C24E1DE0045A5CE145D5D49336
              41E1B79F2B927C9AABE53C9D86BC315B24F7D9365435E123A203BE690FD524CF
              941EA2D93000D4627F8BD24DB66A4E5799D465E143C7581D04526F00EA763615
              95A3EA68F31593FD3E79A45BCCB5E67F07718FB6319E15E4C1EBF8E78FD3846E
              4C915F0946C4B48DBCB1CCE382C9CC0BCF6D7614AF40BB11EF92093D5DB7BC16
              FDE06CA61FF20277D4A6549620907A4350C74C5C56EFAC554CF664B01DEF9A7F
              F2AE354CF4085C98BEBC4B9E32C96FFEE749F4BCE9F3913654BE4307D0438342
              CA2A9379DD3AF57FBD4F2F10AFC02002FEBCB78859B48DD04020F586A02AA99B
              322D4124BE89EEFF33A15B3CE61D757B4A3379A275CF09BBEF7FD8172EF35E62
              61D4CDAB8B863913F9D29760615D04526F08CA7619CD5FDF50B598E4D4F94EFA
              369AC915219AB76B6A075F723E6B95D66271F2B9F3AA0A02A9370455DA3565E0
              9B299D6A690461FFF6DC56FB68DD28B51A4AD0A38B29249A3C6FD4288B40EA0D
              41D9BCEE6FBFA757EC27EF9B163DB02D24A0527309DD6BB9619CD770D1E7CFAB
              C588F6F07AE4FCD95FBFB4719C361048BD4140CD7876775429A044E568294D68
              D8EBF38E44F460DA6F14FD725B5A6B7A6CEEA17451A93C764F8DE445047B0F81
              3E792D027F69AAD2606FC993CAB9A61148BD4190B2D2744AB7523585F645FCC3
              37376EFC6BD326A6A4D7E8D19A9ED9CB55EAA62259AC7E6E6134BB2A02A9370C
              D8252731A1A8E43EBB0B61E46ADAA3B39FFE3BFA68F2F3E106F4223A323D634B
              E67A99AA0D6F3302A93B8255CA1E4D4199FC44172433B68035E76C65775AE06F
              7D3A423E79D3E677358540EA8E00B5D4EC4F0E6D4FFFA82BA2A852655B740ABF
              38CDF8C4489B25B3B88037CD27BE2190BA2300B95CCC92AE23F7AB440B663BF1
              75514968C07204527700D25E695B4010A8D24229F2BB3622F49B8C40EA8EA06A
              C559D39F9D4CE9649909AEE657119D25693BC4FD7C46207547602BFA5D0499C3
              B568948EE499DBD811E52302A93B0214A6B8240D5A296186E7EBAB657ED54FFF
              888E5D5FA34D41207507201D48AE47E442A1A547B4F3D784CEB1B8A8C291297D
              0C79E6661148BDE1B05DB2B90ABA4FFB82621A87C2113308A4DE7048E928D243
              78CC441AB91EBCA7BAC4A6F45D30B9CD2090BA0350236552254E4FF06BA3846E
              6D8DB3C943E5A0898E5DA4D7BA8240EA8E416482EAA6B732E27FFB781CA5349E
              26F436AF5796AD08D3AF53BF4B231A40EE3844B9CD2190BA8350A59B440F6C92
              8F517689B6CC55124452189211FFBBC7F35B44033DAAE634E6F792AA35F4376B
              6D7255CE89FAEDAD3EBDA309FD6073D675171148DD41A00E3CEED1D790334A53
              1AA0E7181244BC038F202C2024C76B9574B0ECCC2BC6DF68DDB397781F7EDF3F
              B3FA67EB8AF3079447207507213E763EF28CA05A1AD33E489E126DAB2E2B88FC
              33F92733F3BA54F45C4D15E19D3B1B715F362A36A059045277108B48DD2474BF
              F3203BF206BEBC2FA9B54D46207507E16AEEB41AA593D09DEB94DAA62390BA63
              9080978B36CC6082DB41207587A073C497EC279FBB500CD181B4239303E40302
              A93B01E99242D00B8FD399D4D0F6A249975A3EA8D4648CCAC711486D1C81D41B
              0C11AA87C91B15CC985285247AD2253FBC4773458F7F4E407A7E2226BA6B72CA
              869A194D7418CC6FB308A4DE50E8E8F39B32635DE73AD9296DA7310D215220E3
              7498F03B4D558021D5857F7F7254A2DA1504526F20B4B97D458F74B26EF5969E
              617DDA04B155ABE523DD86E8B75904526F18942C5042978FD3E606C74BA7D7BA
              C4D643EC429EDA3002A937088AD0299D999893A5AAC47AB453B7CC5399F37D7A
              696A285FC02704526F08A4A5D1D4E03BA908639FFB8EA6F4318A68FE19657AB4
              833F6D0F81D41B00933B74166AA44F8F76D1FC917D5E0DA18B687BD97C68D71A
              695D422075CB91F1A19DFAAADA3C3F2D9A111D4C6FBB08A46E319A0A6035763C
              BC1BD3E4CB88BBAB5AF3AE2290BAA590A98FBE105A46D8E6A3DB227CE86A9040
              171148DD52E8F4506369AB75F1DBEFE9D51473A233ED9C5A18E1CAA7E3EC0202
              A95B081BFDD05590DF8DB3D2471307DD605D4720750BE15B24198B0C248F7E7C
              123D95617C4CE83013CB1102A95B061F23C9CA9FEED31B26F63D3AC04250CC2D
              02A95B0469D260D3FBC4C75D10637562A28B674FA2705F3944B8F82D001A347A
              4C9694FDE824F293D080DEB13FB06BF05DA8EF7687406A8F910D38B159FBDC57
              320392330FF3B1DC2390DA53B429E0A4EACE533AF3D98AE81202A93D455EFC1E
              12436C826FAF9AA4611B9981F146EBCE03CA2390DA53881FCDBBDF10F3A8D89F
              0661C65027C1040C176AA045C788891CAEEBCE033E4720B5C750BB35D1804973
              97258D522389E894FF3B11B17CDB10F7C0A77C79C00C81D42D45A6F6DB89D98B
              217B6C45BC5EA57F16601F81D42D869A7811D1FDCFFF88EE904EEAC7744C3DFA
              76F248D726774FF8D19384BE09AAA07E2290BAC5982B864EE91ABDCC494AAF29
              A57B36D9AF4CF9B9C18FF61F81D42D872A1B8DE950A47DF19CA99955C18F6E07
              02A937105A22F8A8E959D0C18F6E0702A937142060AA87C84FA774BFAEA9ACF2
              D1296D87A1F1FE23907A8381941872DCFC2DEFB09F3DAE9BDB0E7E74BB1048DD
              1180E0BD884EAB125B827141BDA43D08A4EE10324285A573DB6CC6BF623FFA6D
              F0A3DB8340EA8E013DCF941095E9A40A7E743B1148DD31884AC9AAB494DAD57B
              F42AF8D1ED43207507A1840B23DA5D541116FCE8762390BAA360627F58B40B07
              3FBADD08A4EE287E79486FA2845EE4A769043FBAFD08A4EE2840EA34A19B6C29
              A9E8773739DB3AC03E02A93B0A549CE573D661E6D5662090BA839059D3D9F956
              61E6D5E62090BA83D0659F674CE0433CD6C3EDDEF02E7D1D76E9F62390BA83D0
              FA675000BDED47B49344749C125D8768F7662090BA83C0CEDCEBD325EFD65FA7
              293D4C12BA0905269B83FF0FD58BECB6B8A17CAE0000000049454E44AE426082}
          end
          object Label52: TLabel
            Left = 201
            Top = 14
            Width = 61
            Height = 13
            Caption = 'ICMS por UF'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object _AP: TLabel
            Left = 150
            Top = 29
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'AP'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _RR: TLabel
            Left = 89
            Top = 24
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'RR'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _AM: TLabel
            Left = 65
            Top = 68
            Width = 16
            Height = 14
            Cursor = crIBeam
            Caption = 'AM'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _AC: TLabel
            Left = 22
            Top = 99
            Width = 15
            Height = 14
            Cursor = crIBeam
            Caption = 'AC'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _RO: TLabel
            Left = 73
            Top = 106
            Width = 15
            Height = 14
            Cursor = crIBeam
            Caption = 'RO'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _PA: TLabel
            Left = 134
            Top = 68
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'PA'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _MA: TLabel
            Left = 184
            Top = 72
            Width = 16
            Height = 14
            Cursor = crIBeam
            Caption = 'MA'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _CE: TLabel
            Left = 226
            Top = 61
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'CE'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _RN: TLabel
            Left = 259
            Top = 71
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'RN'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _PB: TLabel
            Left = 262
            Top = 83
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'PB'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _PE: TLabel
            Left = 261
            Top = 94
            Width = 12
            Height = 14
            Cursor = crIBeam
            Caption = 'PE'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _AL: TLabel
            Left = 255
            Top = 104
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'AL'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _SE: TLabel
            Left = 247
            Top = 115
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'SE'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _PI: TLabel
            Left = 203
            Top = 91
            Width = 8
            Height = 14
            Cursor = crIBeam
            Caption = 'PI'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _TO: TLabel
            Left = 166
            Top = 106
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'TO'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _MT: TLabel
            Left = 118
            Top = 122
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'MT'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _DF: TLabel
            Left = 161
            Top = 133
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'DF'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _BA: TLabel
            Left = 205
            Top = 121
            Width = 15
            Height = 14
            Cursor = crIBeam
            Caption = 'BA'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _GO: TLabel
            Left = 153
            Top = 144
            Width = 16
            Height = 14
            Cursor = crIBeam
            Caption = 'GO'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _MG: TLabel
            Left = 186
            Top = 156
            Width = 16
            Height = 14
            Cursor = crIBeam
            Caption = 'MG'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _ES: TLabel
            Left = 225
            Top = 169
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'ES'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _RJ: TLabel
            Left = 212
            Top = 188
            Width = 12
            Height = 14
            Cursor = crIBeam
            Caption = 'RJ'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _SP: TLabel
            Left = 158
            Top = 177
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'SP'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _MS: TLabel
            Left = 122
            Top = 166
            Width = 15
            Height = 14
            Cursor = crIBeam
            Caption = 'MS'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _PR: TLabel
            Left = 142
            Top = 195
            Width = 13
            Height = 14
            Cursor = crIBeam
            Caption = 'PR'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _SC: TLabel
            Left = 153
            Top = 210
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'SC'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object _RS: TLabel
            Left = 139
            Top = 227
            Width = 14
            Height = 14
            Cursor = crIBeam
            Caption = 'RS'
            Font.Charset = ANSI_CHARSET
            Font.Color = 3355443
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif Narrow'
            Font.Style = []
            ParentFont = False
            Transparent = True
            OnClick = _RRClick
          end
          object SMALL_DBEditY: TSMALL_DBEdit
            Left = 32
            Top = 136
            Width = 50
            Height = 19
            BorderStyle = bsNone
            Ctl3D = True
            DataField = 'RR_'
            DataSource = Form7.DataSource14
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = [fsBold]
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            Visible = False
            OnExit = SMALL_DBEditYExit
            OnKeyDown = PadraoKeyDown
          end
        end
        object cboTipoItem: TComboBox
          Left = 110
          Top = 42
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnChange = cboTipoItemChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '00 - Mercadoria para Revenda'
            '01 - Mat'#233'ria-Prima'
            '02 - Embalagem'
            '03 - Produto em Processo'
            '04 - Produto Acabado'
            '05 - Subproduto'
            '06 - Produto Intermedi'#225'rio'
            '07 - Material de Uso e Consumo'
            '08 - Ativo Imobilizado'
            '09 - Servi'#231'os'
            '10 - Outros insumos'
            '99 - Outras')
        end
        object cboIAT: TComboBox
          Left = 110
          Top = 165
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnChange = cboIATChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            'A - Arredondamento'
            'T - Truncamento')
        end
        object cboOrigemProd: TComboBox
          Left = 110
          Top = 217
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnChange = cboOrigemProdChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '0 - Nacional, exceto as indicadas nos c'#243'digos 3 a 5'
            
              '1 - Estrangeira - Importa'#231#227'o direta, exceto a indicada no c'#243'digo' +
              ' 6'
            
              '2 - Estrangeira - Adquirida no mercado interno, exceto a indicad' +
              'a no c'#243'digo 7'
            
              '3 - Nacional, mercadoria ou bem com Conte'#250'do de Importa'#231#227'o super' +
              'ior a 40% (quarenta por cento)'
            
              '4 - Nacional, cuja produ'#231#227'o tenha sido feita em conformidade com' +
              ' os processos produtivos b'#225'sicos de que tratam o Decreto-Lei n'#186' ' +
              '288/1967, e as Leis n'#186's 8.248/1991, 8.387/1991, 10.176/2001 e 11' +
              '.484/2007;'
            
              '5 - Nacional, mercadoria ou bem com Conte'#250'do de Importa'#231#227'o infer' +
              'ior ou igual a 40% (quarenta por cento)'
            
              '6 - Estrangeira - Importa'#231#227'o direta, sem similar nacional, const' +
              'ante em lista de Resolu'#231#227'o CAMEX;'
            
              '7 - Estrangeira - Adquirida no mercado interno, sem similar naci' +
              'onal, constante em lista de Resolu'#231#227'o CAMEX.'
            
              '8 - Nacional, mercadoria ou bem com Conte'#250'do de Importa'#231#227'o sup. ' +
              'a 70%')
        end
        object cboCSOSN_Prod: TComboBox
          Left = 110
          Top = 244
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnChange = cboCSOSN_ProdChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '101 - Tributada pelo Simples Nacional com permiss'#227'o de cr'#233'dito'
            '102 - Tributada pelo Simples Nacional sem permiss'#227'o de cr'#233'dito'
            
              '103 - Isen'#231#227'o do ICMS no Simples Nacional para faixa de receita ' +
              'bruta'
            
              '201 - Trib. pelo Simples Nacional com permiss'#227'o de cr'#233'dito e com' +
              ' cobr. do ICMS por ST'
            
              '202 - Trib. pelo Simples Nacional sem permiss'#227'o de cr'#233'dito e com' +
              ' cobr. do ICMS por ST '
            
              '203 - Isen'#231#227'o do ICMS no Simples Nacional para faixa de receita ' +
              'bruta e com cobran'#231'a do ICMS por ST'
            '300 - Imune '
            '400 - N'#227'o tributada pelo Simples Nacional'
            
              '500 - ICMS cobrado anteriormente por ST (substitu'#237'do) ou por ant' +
              'ecipa'#231#227'o'
            '900 - Outros'
            
              '61 - Tributa'#231#227'o monof'#225'sica sobre combust'#237'veis cobrado anteriorme' +
              'nte')
        end
        object cboCFOP_NFCe: TComboBox
          Left = 110
          Top = 296
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnChange = cboCFOP_NFCeChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '5101 - Venda de produ'#231#227'o do estabelecimento;'
            '5102 - Venda de mercadoria de terceiros;'
            
              '5103 - Venda de produ'#231#227'o do estabelecimento efetuada fora do est' +
              'abelecimento;'
            
              '5104 - Venda de mercadoria adquirida ou recebida de terceiros, e' +
              'fetuada fora do estabelecimento;'
            
              '5115 - Venda de mercadoria de terceiros, recebida anteriormente ' +
              'em consigna'#231#227'o mercantil;'
            
              '5405 - Venda de mercadoria de terceiros, sujeita a ST, como cont' +
              'ribuinte substitu'#237'do;'
            
              '5656 - Venda de combust'#237'vel ou lubrificante de terceiros, destin' +
              'ados a consumidor final;'
            
              '5667 - Venda de combust'#237'vel ou lubrificante a consumidor ou usu'#225 +
              'rio final estabelecido em outra Unidade da Federa'#231#227'o;'
            
              '5933 - Presta'#231#227'o de servi'#231'o tributado pelo ISSQN (Nota Fiscal co' +
              'njugada);'
            
              '5949 - Outra sa'#237'da de mercadoria ou presta'#231#227'o de servi'#231'o n'#227'o esp' +
              'ecificado;')
        end
        object cboCST_NFCE: TComboBox
          Left = 110
          Top = 323
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnChange = cboCST_NFCEChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '00 - Tributada integralmente'
            '20 - Com redu'#231#227'o de base de c'#225'lculo'
            '40 - Isenta'
            '41 - N'#227'o tributada'
            '60 - ICMS Cobrado anteriormente por ST'
            
              '61 - Tributa'#231#227'o monof'#225'sica sobre combust'#237'veis cobrado anteriorme' +
              'nte'
            '90 - Outras')
        end
        object cboCSOSN_NFCE: TComboBox
          Left = 110
          Top = 323
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          OnChange = cboCSOSN_NFCEChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '102 - Tributada pelo Simples Nacional sem permiss'#227'o de cr'#233'dito'
            
              '103 - Isen'#231#227'o do ICMS no Simples Nacional para faixa de receita ' +
              'bruta'
            '300 - Imune '
            '400 - N'#227'o tributada pelo Simples Nacional'
            
              '500 - ICMS cobrado anteriormente por ST (substitu'#237'do) ou por ant' +
              'ecipa'#231#227'o'
            '900 - Outros'
            
              '61 - Tributa'#231#227'o monof'#225'sica sobre combust'#237'veis cobrado anteriorme' +
              'nte')
        end
        object edtAliquota: TSMALL_DBEdit
          Left = 110
          Top = 350
          Width = 50
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ALIQUOTA_NFCE'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 14
          OnKeyDown = PadraoKeyDown
        end
        object edtCEST: TSMALL_DBEdit
          Left = 110
          Top = 113
          Width = 100
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CEST'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          OnChange = edtNCMChange
          OnExit = edtNCMChange
          OnKeyDown = PadraoKeyDown
        end
        inline fraPerfilTrib: TfFrameCampo
          Left = 110
          Top = 17
          Width = 385
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 0
          OnExit = fraPerfilTribExit
          ExplicitLeft = 110
          ExplicitTop = 17
          ExplicitWidth = 385
          DesignSize = (
            385
            20)
          inherited txtCampo: TEdit
            Width = 385
            OnKeyDown = fraPerfilTribtxtCampoKeyDown
            ExplicitWidth = 385
          end
          inherited gdRegistros: TDBGrid
            Width = 385
            Font.Charset = ANSI_CHARSET
            Font.Name = 'System'
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Name = 'Microsoft Sans Serif'
          end
        end
        object cboIPPT: TComboBox
          Left = 110
          Top = 138
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnChange = cboIPPTChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            'P - Produ'#231#227'o pr'#243'pria'
            'T - Produ'#231#227'o por terceiros')
        end
        object cboCST_Prod: TComboBox
          Left = 110
          Top = 244
          Width = 385
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnChange = cboCST_ProdChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            ''
            '00 - Tributada integralmente'
            '10 - Tributada e com cobran'#231'a de ICMS por ST'
            '20 - Com redu'#231#227'o de base de c'#225'lculo'
            '30 - Isenta ou n'#227'o tributada e com cobran'#231'a do ICMS por ST'
            '40 - Isenta'
            '41 - N'#227'o tributada'
            '50 - Suspens'#227'o'
            '51 - Diferimento'
            '60 - ICMS Cobrado anteriormente por ST'
            
              '61 - Tributa'#231#227'o monof'#225'sica sobre combust'#237'veis cobrado anteriorme' +
              'nte'
            '70 - Com red. de base de c'#225'lculo e cob. do ICMS por ST'
            '90 - Outras')
        end
      end
      object tbsIPI: TTabSheet
        Caption = 'IPI/PIS/COFINS'
        ImageIndex = 2
        OnEnter = tbsIPIEnter
        OnShow = tbsIPIShow
        object GroupBox1: TGroupBox
          Left = 17
          Top = 13
          Width = 758
          Height = 113
          Caption = ' IPI '
          TabOrder = 0
          object Label41: TLabel
            Left = 60
            Top = 27
            Width = 75
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'CST IPI'
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
          object Label40: TLabel
            Left = 52
            Top = 55
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% IPI'
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
          object Label98: TLabel
            Left = 29
            Top = 81
            Width = 106
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'C'#243'd. Enquadramento'
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
          object cboCST_IPI: TComboBox
            Left = 142
            Top = 22
            Width = 595
            Height = 22
            Style = csOwnerDrawVariable
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cboCST_IPIChange
            OnKeyDown = PadraoKeyDown
            Items.Strings = (
              ''
              '50 - Sa'#237'da Tributada'
              '51 - Sa'#237'da Tribut'#225'vel com Al'#237'quota Zero'
              '52 - Sa'#237'da Isenta'
              '53 - Sa'#237'da N'#227'o-Tributada'
              '54 - Sa'#237'da Imune'
              '55 - Sa'#237'da com Suspens'#227'o'
              '99 - Outras Sa'#237'das')
          end
          object edtIPI: TSMALL_DBEdit
            Left = 142
            Top = 50
            Width = 50
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'IPI'
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
          object edtEnqIPI: TSMALL_DBEdit
            Left = 142
            Top = 76
            Width = 50
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ENQ_IPI'
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
        end
        object GroupBox2: TGroupBox
          Left = 17
          Top = 135
          Width = 758
          Height = 273
          Caption = 'PIS/COFINS'
          TabOrder = 1
          object Label6: TLabel
            Left = 24
            Top = 20
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Sa'#237'da'
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
          object Label7: TLabel
            Left = 24
            Top = 121
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Entrada'
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
          object Label42: TLabel
            Left = 40
            Top = 39
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'CST PIS/COFINS'
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
          object Label43: TLabel
            Left = 40
            Top = 67
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% PIS'
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
          object Label49: TLabel
            Left = 40
            Top = 93
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% COFINS'
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
          object Label38: TLabel
            Left = 40
            Top = 141
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'CST PIS/COFINS'
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
          object Label50: TLabel
            Left = 40
            Top = 169
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% PIS'
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
          object Label54: TLabel
            Left = 40
            Top = 195
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% COFINS'
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
          object lblNatReceita: TLabel
            Left = 37
            Top = 241
            Width = 98
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Natureza da Receita'
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
          object lblGeral: TLabel
            Left = 24
            Top = 222
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Geral'
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
          object cboCST_PIS_COFINS: TComboBox
            Left = 142
            Top = 34
            Width = 595
            Height = 22
            Style = csOwnerDrawVariable
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cboCST_PIS_COFINSChange
            OnKeyDown = PadraoKeyDown
            Items.Strings = (
              ''
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
          end
          object dbepPisSaida: TSMALL_DBEdit
            Left = 142
            Top = 62
            Width = 60
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ALIQ_PIS_SAIDA'
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
          object dbepCofinsSaida: TSMALL_DBEdit
            Left = 142
            Top = 88
            Width = 60
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ALIQ_COFINS_SAIDA'
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
          object cboCST_PIS_COFINS_E: TComboBox
            Left = 142
            Top = 136
            Width = 595
            Height = 22
            Style = csOwnerDrawVariable
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnChange = cboCST_PIS_COFINS_EChange
            OnEnter = cboCST_PIS_COFINS_EEnter
            OnKeyDown = PadraoKeyDown
            Items.Strings = (
              ''
              
                '50-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada Exclusivamente a R' +
                'eceita Tributada no Mercado Interno'
              
                '51-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada Exclusivamente a R' +
                'eceita N'#227'o-Tributada no Mercado Interno'
              
                '52-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada Exclusivamente a R' +
                'eceita de Exporta'#231#227'o'
              
                '53-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada a Receitas Tributa' +
                'das e N'#227'o-Tributadas no Mercado Interno'
              
                '54-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada a Receitas Tributa' +
                'das no Mercado Interno e de Exporta'#231#227'o'
              
                '55-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada a Receitas N'#227'o Tri' +
                'butadas no Mercado Interno e de Exporta'#231#227'o'
              
                '56-Opera'#231#227'o com Direito a Cr'#233'dito - Vinculada a Receitas Tributa' +
                'das e N'#227'o-Tributadas no Mercado Interno e de Exporta'#231#227'o'
              
                '60-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusiva' +
                'mente a Receita Tributada no Mercado Interno'
              
                '61-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusiva' +
                'mente a Receita N'#227'o-Tributada no Mercado Interno'
              
                '62-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusiva' +
                'mente a Receita de Exporta'#231#227'o'
              
                '63-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receita' +
                's Tributadas e N'#227'o-Tributadas no Mercado Interno'
              
                '64-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receita' +
                's Tributadas no Mercado Interno e de Exporta'#231#227'o'
              
                '65-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receita' +
                's N'#227'o-Tributadas no Mercado Interno e de Exporta'#231#227'o'
              
                '66-Cr'#233'dito Presumido - Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receita' +
                's Tributadas e N'#227'o-Tributadas no Mercado Interno e de Exporta'#231#227'o'
              '67-Cr'#233'dito Presumido - Outras Opera'#231#245'es'
              '70-Opera'#231#227'o de Aquisi'#231#227'o sem Direito a Cr'#233'dito'
              '71-Opera'#231#227'o de Aquisi'#231#227'o com Isen'#231#227'o'
              '72-Opera'#231#227'o de Aquisi'#231#227'o com Suspens'#227'o'
              '73-Opera'#231#227'o de Aquisi'#231#227'o a Al'#237'quota Zero'
              '74-Opera'#231#227'o de Aquisi'#231#227'o sem Incid'#234'ncia da Contribui'#231#227'o'
              '75-Opera'#231#227'o de Aquisi'#231#227'o por Substitui'#231#227'o Tribut'#225'ria'
              '98-Outras Opera'#231#245'es de Entrada'
              '99-Outras Opera'#231#245'es')
          end
          object dbepPisEntrada: TSMALL_DBEdit
            Left = 142
            Top = 164
            Width = 60
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ALIQ_PIS_ENTRADA'
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
          object dbepCofinsEntrada: TSMALL_DBEdit
            Left = 142
            Top = 190
            Width = 60
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ALIQ_COFINS_ENTRADA'
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
          object edtNaturezaReceita: TSMALL_DBEdit
            Left = 142
            Top = 236
            Width = 60
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'NATUREZA_RECEITA'
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
            OnKeyPress = edtNaturezaReceitaKeyPress
          end
        end
      end
      object tbsGrade: TTabSheet
        Caption = 'Grade'
        ImageIndex = 4
        OnShow = tbsGradeShow
        object Label39: TLabel
          Left = 19
          Top = 360
          Width = 282
          Height = 13
          Caption = '12345678901234567890123456789012345678901234567'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object sgrdGrade: TStringGrid
          Left = 21
          Top = 25
          Width = 752
          Height = 324
          BorderStyle = bsNone
          Color = clWhite
          ColCount = 20
          Ctl3D = False
          DefaultColWidth = 92
          DefaultRowHeight = 25
          DrawingStyle = gdsClassic
          FixedColor = clWhite
          FixedCols = 0
          RowCount = 30
          FixedRows = 0
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          GridLineWidth = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSizing, goEditing]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 0
          OnClick = sgrdGradeClick
          OnDrawCell = sgrdGradeDrawCell
          OnKeyPress = sgrdGradeKeyPress
          OnKeyUp = sgrdGradeKeyUp
        end
        object btnExcluirGrade: TBitBtn
          Left = 16
          Top = 383
          Width = 100
          Height = 25
          Caption = 'Excluir Grade'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnExcluirGradeClick
        end
        object btnCancelarGrade: TBitBtn
          Left = 120
          Top = 383
          Width = 100
          Height = 25
          Caption = 'Cancelar'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnCancelarGradeClick
        end
        object btnSalvarGrade: TBitBtn
          Left = 224
          Top = 383
          Width = 100
          Height = 25
          Caption = 'Salvar Grade'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnSalvarGradeClick
        end
        object TPanel
          Left = 20
          Top = 25
          Width = 2
          Height = 324
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 4
        end
        object TPanel
          Left = 20
          Top = 23
          Width = 753
          Height = 2
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 5
        end
      end
      object tbsSerial: TTabSheet
        Caption = 'Serial'
        ImageIndex = 5
        OnShow = tbsSerialShow
        object edtTitulo1: TEdit
          Left = 17
          Top = 45
          Width = 213
          Height = 19
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = '  N'#250'mero de s'#233'rie'
        end
        object edtTitulo2: TEdit
          Left = 229
          Top = 45
          Width = 89
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = 'NF Compra'
        end
        object edtTitulo4: TEdit
          Left = 405
          Top = 45
          Width = 89
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          Text = 'Compra'
        end
        object edtTitulo3: TEdit
          Left = 317
          Top = 45
          Width = 89
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          Text = 'Pago'
        end
        object edtTitulo5: TEdit
          Left = 493
          Top = 45
          Width = 89
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          Text = 'NF Venda'
        end
        object edtTitulo6: TEdit
          Left = 581
          Top = 45
          Width = 89
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
          Text = 'Recebido'
        end
        object edtTitulo7: TEdit
          Left = 669
          Top = 45
          Width = 106
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
          Text = 'Venda'
        end
        object chkControlaSerial: TCheckBox
          Left = 20
          Top = 16
          Width = 300
          Height = 17
          Caption = 'Controlar este produto por n'#250'mero de s'#233'rie'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = chkControlaSerialClick
          OnExit = chkControlaSerialExit
        end
        object btnProcurarSer: TBitBtn
          Left = 16
          Top = 383
          Width = 100
          Height = 25
          Caption = 'Procurar'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = btnProcurarSerClick
        end
        object btnHistoricoItemSer: TBitBtn
          Left = 120
          Top = 383
          Width = 120
          Height = 25
          Caption = 'Hist'#243'rico do item'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnClick = btnHistoricoItemSerClick
        end
        object btnHistoricoSer: TBitBtn
          Left = 244
          Top = 383
          Width = 120
          Height = 25
          Caption = 'Hist'#243'rico do serial'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnClick = btnHistoricoSerClick
        end
        object dbgSerial: TDBGrid
          Left = 17
          Top = 66
          Width = 758
          Height = 298
          BiDiMode = bdLeftToRight
          Ctl3D = False
          DataSource = Form7.DataSource30
          DrawingStyle = gdsClassic
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          Options = [dgEditing, dgColLines, dgRowLines]
          ParentBiDiMode = False
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 11
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = 'Microsoft Sans Serif'
          TitleFont.Style = []
          OnKeyDown = dbgSerialKeyDown
          OnKeyPress = dbgSerialKeyPress
          Columns = <
            item
              Expanded = False
              FieldName = 'SERIAL'
              Width = 211
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NFCOMPRA'
              Width = 87
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALCOMPRA'
              Width = 87
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATCOMPRA'
              Width = 87
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NFVENDA'
              Width = 87
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALVENDA'
              Width = 87
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATVENDA'
              Width = 87
              Visible = True
            end>
        end
      end
      object tbsComposicao: TTabSheet
        Caption = 'Composi'#231#227'o'
        ImageIndex = 6
        OnShow = tbsComposicaoShow
        object edtAcum3: TSMALL_DBEdit
          Left = 570
          Top = 384
          Width = 100
          Height = 23
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'CUSTOCOMPR'
          DataSource = Form7.DataSource4
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 9
        end
        object Edit5: TEdit
          Left = 17
          Top = 23
          Width = 634
          Height = 19
          BevelInner = bvNone
          Color = clWhite
          Ctl3D = False
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = '  C'#243'digo/ C'#243'digo de barras/ Descri'#231#227'o'
        end
        object Edit6: TEdit
          Left = 650
          Top = 23
          Width = 125
          Height = 19
          Alignment = taCenter
          Color = clWhite
          Ctl3D = False
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = 'Quantidade'
          OnEnter = Edit6Enter
        end
        object dbgComposicao: TDBGrid
          Left = 17
          Top = 44
          Width = 758
          Height = 250
          Ctl3D = False
          DataSource = Form7.DataSource28
          DrawingStyle = gdsClassic
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          Options = [dgEditing, dgColLines, dgRowLines]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Microsoft Sans Serif'
          TitleFont.Style = []
          OnColEnter = dbgComposicaoColEnter
          OnColExit = dbgComposicaoColExit
          OnKeyDown = dbgComposicaoKeyDown
          OnKeyPress = dbgComposicaoKeyPress
          OnKeyUp = dbgComposicaoKeyUp
          Columns = <
            item
              Expanded = False
              FieldName = 'DESCRICAO'
              Width = 632
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'QUANTIDADE'
              Width = 103
              Visible = True
            end>
        end
        object edtAcum1: TSMALL_DBEdit
          Left = 570
          Top = 315
          Width = 100
          Height = 23
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'ACUMULADO1'
          DataSource = Form7.DataSource25
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
        end
        object edtAcum2: TSMALL_DBEdit
          Left = 570
          Top = 350
          Width = 100
          Height = 23
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'ACUMULADO2'
          DataSource = Form7.DataSource25
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
        end
        object Button8: TBitBtn
          Left = 676
          Top = 314
          Width = 100
          Height = 25
          Caption = '&Fabricar'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = Button8Click
        end
        object Button10: TBitBtn
          Left = 676
          Top = 349
          Width = 100
          Height = 25
          Caption = '&Desmontar'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = Button10Click
        end
        object Button11: TBitBtn
          Left = 676
          Top = 383
          Width = 100
          Height = 25
          Caption = 'C&usto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = Button11Click
        end
        inline framePesquisaProdComposicao: TframePesquisaProduto
          Left = 17
          Top = 293
          Width = 758
          Height = 114
          TabOrder = 8
          Visible = False
          ExplicitLeft = 17
          ExplicitTop = 293
          ExplicitWidth = 758
          ExplicitHeight = 114
          inherited pnlPrincipal: TPanel
            Width = 758
            Height = 114
            ExplicitWidth = 758
            ExplicitHeight = 114
            inherited dbgItensPesq: TDBGrid
              Width = 758
              Height = 114
              OnCellClick = framePesquisaProdComposicaodbgItensPesqCellClick
              OnKeyDown = framePesquisaProdComposicaodbgItensPesqKeyDown
              OnKeyPress = framePesquisaProdComposicaodbgItensPesqKeyPress
            end
          end
        end
      end
      object tbsFoto: TTabSheet
        Caption = 'Foto'
        ImageIndex = 7
        OnShow = tbsFotoShow
        object imgFotoProd: TImage
          Left = 130
          Top = 105
          Width = 533
          Height = 300
          Center = True
          Proportional = True
          OnClick = imgFotoProdClick
        end
        object Image1: TImage
          Left = 257
          Top = 25
          Width = 30
          Height = 31
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D494844520000001E0000
            001F0806000000F06C7D07000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000003
            D34944415478DAC5577F4EE240149E690DEE9FEC09164FB07002E104E20984C4
            AC604B94130027A80A85D535A99E003D81EC09C013C89E403726B2946566BF69
            3BB52DE59721D9499AB67466BEF7DEF7CD7B0F4AFED3A0AB4EEC349B594555F7
            08E75946480A0B93DEA7217E1B124AEFB8A2DC97CBE5E14680052055941A1EB3
            00E8E17940181B2884BC88EF53CE534451D2CE771884EB06063496193017D8B2
            ACE4F8EDAD8EC713B19942E9CDB7E3E39F0B8DBCB8285055AD71448373DE38D6
            F5B3B58005A83D1A3D60711280856580D171D9E9D43863755C8D72A5525F19F8
            B2DDEE0B506EDBB972B5EA87AC639A052C388047699F634A05C73D80DC02A417
            996B31CEAB719ECF0063411D1B9D90C92423414DD34CAB9476B179924244D4E5
            DAF9C6A6D33438CE7B1C87F8BD6CB54E39A506D6E58246CD00773A9D1465EC09
            1B178E74FDD6F33E0FAB2D4CEC6DDB76B158ADBEC445E9AADDDEC5BC1B448000
            2C27C1BF9BE6031C21255DCFCD05C6244B585ED2B41D690814DC8782CF8E34AD
            B18CDB8E61A4682221808612C8FBED29EAB50F6C1946729C483C07BD85215DDC
            D2D2905586002289443FA8EA38AF7DE0CB66330F7EBA08E767114E1976A83AFB
            115533C6F2654DCB38C6E0981155353ED9F68EA4EA1DD8346BE0285FD6F58C7C
            877A0BEB78EB7BED269D87ADEDEDD4E1E1E12FE9C494908CA6698310B0C76F12
            40FB9EA8BA5C84C77B5F1BDC349F15CE4F03B4F1208D51600154F479411E96EF
            EB0EAC17A7A32E81A2862C020EBD7FC463E12104752F3D86C0F2F2FD9DE376DB
            8020B23EC76EDAFB10C7574838A8607DC9699C5043AA668A6249E54981C4659D
            15C21CCA07F2C4E0DDC70B9DE33F38E81141C4669D8521964927BC8F857D52B1
            E7D80BB7938F83594724036C743EAFCA0487534A47A33E714F839FFDA2697806
            D82906E00613F78F2A953B4F244E95214B0ABC438DAA0ACF48B0AA45C31E0BEC
            796D20911450713212C433A82B0A80D3853076CFBC0E043AF88A9B5B9D44799C
            4C8A12B48DEA04411971D96F0658706D23D1A3C2248355C6F1CAED300E885B02
            9D8124F38252D9C3E667C1CD65A470D5E30A4C6C23E0571978889E6A5FA6B9E0
            B8BEBEFEA2BEBEFE8E2B93D2D379A07381A5E7A856061E0BCBF80DF18CC61051
            48230A75F07A3E6FEEF22ED36BE088E82005BF082B54FE283916C744D9DAFA0A
            B0BC9C13E479256021ACC478DC880B9FD76108DED2A2E70A714CC84018C455F5
            AE542A3D46D70A71E2386583BD970F2CC4805BA8666E6AC82C286B7D08385A8F
            370ABC2857FF68B5F6FEA2690F9EDF4D0DA9F2588FC5707233A54220E2F86C2A
            DC295CD9E8D19AEDAB5D15EF6ED2E3B8BF3FFF004D30B53E86498C3B00000000
            49454E44AE426082}
        end
        object Image2: TImage
          Left = 381
          Top = 25
          Width = 30
          Height = 31
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D494844520000001E0000
            001E08060000003B30AEA2000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000002
            574944415478DAED964D6EDA4014C767C692E9220BF706E4067082C20DE8096A
            6F0AC68E884F8073022741B6936C484E403841E809A027C037A8579620C2D3FF
            20BB5280DA039474D13EC99AD1C0CCEFBD795F43C95F12FA1FBC29C3E1505B24
            C9174C5B9C901A3668D9C619175F9A3E991717933F0A0E7DDFC5D013B01C8431
            12BF092538E70D4AA950E49933E698A6191D05CEAC1C61DA10871245713B9DCE
            F79DCADDDEEA5451FA50444B09695A96353B187CE7FB2F19F4B2635937658784
            9E5765AA3A02B82A0BDF028BEBC5625F16FAEB963C4F5BA8EA94504A2A8B45DD
            709C581A1C866195A4E9148BCF801AB2D05C7CDFAF298488FD6EDBB2AEE4C1BE
            AF6361C897CB73D371A27DC142EE83609422E84CCBFA280D16BE45A46AA66DD7
            0F81AEC183410B113E5A11522FF2F5A6C53F18A58FED6ED739142CDC45D3744E
            39D7DBB6FD246B3197F14F99C89CB30DA6F4FA188BF3734849566C82E71866D8
            F0F950E803221BB93C259CB73AB63D960223223D44A4FE01515D968705D6F630
            5C9765C6DBE01A0C1A94B19763FC7C170473D48208D6368BFEB755B9D6298506
            4018ABEF53F4D78A67550F99D1F8DAED7EDB0B2CEA2E41E963E842EA72D994BD
            F2BCF8C806272D3A0475374298378B2CCF3A998BA9F02D417FBE427F760F020B
            C9EAAE688D557C8F280A63F5EC6C6218462C60499254712B2D92F76B580A4563
            805D1978F14340B4BB4AA58732DACA14D816CE278C3137F7E97D18F665E0D26F
            AE8720F894AE563544BD8643635818ABAFAFE35D3120033FD963AF0C7ED25766
            11FCE4CFDBDFC1DFE55D9DC175F480F37705EF927F0FFC1399EA582EFCC11CC2
            0000000049454E44AE426082}
        end
        object Image7: TImage
          Left = 505
          Top = 25
          Width = 30
          Height = 31
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D494844520000001E0000
            001E08060000003B30AEA2000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000002
            E44944415478DAC5965F56DA4014C6EF1D20FAD62C21DD01ACA0B282DA97D664
            E291AC405D81B002740551C81F4F5FD0156057005D81B803FA0651677A6F2416
            5B887820F6BE64C209F39B99FBDDEF0EC27F0ACC06BEEF9B8661584A09B328D8
            FEBE7DF3021C04D111209ED0B030680A43182188A6E37CBBC0308C1B9A360C5A
            9F02A853D775EF8A80FA7E6C19061C10ABA915D431082F07007AE84ADB2B72B7
            590461ECD3395B048E3502EE4AB977FD1EE06E37DA4581BD142C50EF388EF363
            FE8330FC5E057838A1A3B168614321A065DBF6687D70BC8302FA0BC1711C5B8F
            0A06A0614882B851000D41324CA6939AE779E3C2C024385F83AEBAD2A9F1BBEF
            F7CC8A31B925011EB9AE735120F8B247E0F1BCE06831B7F43897D26E15093ED4
            A09A258135CEEBACCEDBF7097CF4BCF5F29C0BE608A2CB361F6DF64E296E2EDB
            2DBB5EB9BC5D2D9761F49A005F05734451F4891ED6743ABD5E262A16A2D2D0D7
            9AD44FCE4422ACE7C15702AF1241180D34A0F9904C6A95ADED1E9D92799F4CEB
            CB16BA1170378C9B948243CA7D8D73CFB65831602010CF1D67EFB810F0ACD66F
            C95C8EC8F5CEFE4CFCE44CECC7F3DD6823E0B4856E6D0F28AF378B3CFE4998AA
            9155C5C6C0DD30A24E869F1F12A82F2A2F369CB23119B0D85CC7AEBF09CCBBE2
            E7DF22996BA38D3C1763AFD7F0D8A7EF5AF4DDE94AE00E4D2E00DA343409D2DA
            977633CB6B5A3A4A5FD164C7F04A74C87848686D045593520E73C1994BF1C540
            29FD5394449BE0670C670FA786B1C3A5B36AB308A2B84FCAB7B206B3103C2B8F
            937997CA8E1611AFB4D6BB6FB5CD2CDF25FA3F97D83F6005E8511B3C5894BBCC
            3EF36C33578C3318A5E80B8972FC0C66F551699808A5BA945F878B565DA94C7A
            AEFB52A16F89ACC4A8EE8FD31364300D46CB4A6393F1946F1C73CA307DD13092
            EF74D94B2F19DC509ECF9FCA4680BA4A12B1D6D5262FCA06EB040F39D7E985BE
            D3091B5812AC66ABE00D8FB3EB13CEFF1A866195CAE6431144CAEBAFCC443870
            9DC9D689DF424122B03DB577A10000000049454E44AE426082}
        end
        object pbWebCam: TPaintBox
          Left = 130
          Top = 105
          Width = 533
          Height = 300
          Visible = False
        end
        object btnWebcam: TBitBtn
          Left = 212
          Top = 60
          Width = 120
          Height = 25
          Caption = '&Webcam'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnWebcamClick
        end
        object btnProcurarWeb: TBitBtn
          Left = 336
          Top = 60
          Width = 120
          Height = 25
          Caption = '&Procurar na web'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnProcurarWebClick
        end
        object btnSelecionarArquivo: TBitBtn
          Left = 460
          Top = 60
          Width = 120
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
        object WebBrowser1: TWebBrowser
          Left = -2000
          Top = -1
          Width = 639
          Height = 446
          TabOrder = 3
          OnNavigateComplete2 = WebBrowser1NavigateComplete2
          OnDocumentComplete = WebBrowser1DocumentComplete
          ControlData = {
            4C0000000B420000182E00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E12620A000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object cboDrivers: TComboBox
          Left = 3
          Top = 16
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 4
          Visible = False
        end
      end
      object tbsPreco: TTabSheet
        Caption = 'Pre'#231'o'
        ImageIndex = 8
        OnShow = tbsPrecoShow
        object Label57: TLabel
          Left = 210
          Top = 21
          Width = 203
          Height = 13
          Alignment = taRightJustify
          Caption = '                       Valor pago na '#250'ltima compra'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPrcVlPg: TLabel
          Left = 488
          Top = 22
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = ' 0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label59: TLabel
          Left = 275
          Top = 41
          Width = 138
          Height = 13
          Alignment = taRightJustify
          Caption = 'Frete + IPI + outras despesas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPrcFreteIPIOut: TLabel
          Left = 491
          Top = 41
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label61: TLabel
          Left = 318
          Top = 68
          Width = 95
          Height = 13
          Alignment = taRightJustify
          Caption = 'Custo de compra'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label62: TLabel
          Left = 267
          Top = 101
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = '% ICM de entrada'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label63: TLabel
          Left = 276
          Top = 126
          Width = 75
          Height = 13
          Alignment = taRightJustify
          Caption = '% ICM de sa'#237'da'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label64: TLabel
          Left = 255
          Top = 151
          Width = 96
          Height = 13
          Alignment = taRightJustify
          Caption = '% Custo operacional'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label65: TLabel
          Left = 266
          Top = 176
          Width = 86
          Height = 13
          Alignment = taRightJustify
          Caption = '% Outros impostos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label66: TLabel
          Left = 295
          Top = 201
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = '% Comiss'#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label67: TLabel
          Left = 245
          Top = 226
          Width = 106
          Height = 13
          Alignment = taRightJustify
          Caption = '% Lucro sobre o pre'#231'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 323
          Top = 256
          Width = 90
          Height = 13
          Alignment = taRightJustify
          Caption = 'Pre'#231'o de venda'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 426
          Top = 68
          Width = 23
          Height = 13
          Caption = '=R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 426
          Top = 102
          Width = 20
          Height = 13
          Caption = '- R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 426
          Top = 126
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 426
          Top = 151
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 426
          Top = 177
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 426
          Top = 201
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 426
          Top = 226
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 426
          Top = 256
          Width = 23
          Height = 13
          Caption = '=R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblCusto1: TLabel
          Left = 491
          Top = 102
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCusto2: TLabel
          Left = 491
          Top = 126
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCusto3: TLabel
          Left = 491
          Top = 151
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCusto4: TLabel
          Left = 491
          Top = 176
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCusto5: TLabel
          Left = 491
          Top = 201
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCusto6: TLabel
          Left = 491
          Top = 226
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPrecoCustoCompra: TLabel
          Left = 487
          Top = 68
          Width = 25
          Height = 13
          Hint = 'Valor pago + frete + IPI + outras despesas.'
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblPrecoTotVenda: TLabel
          Left = 487
          Top = 256
          Width = 25
          Height = 13
          Hint = 'Pre'#231'o de venda do produto'
          Alignment = taRightJustify
          Caption = '0,00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label24: TLabel
          Left = 426
          Top = 21
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label25: TLabel
          Left = 426
          Top = 41
          Width = 20
          Height = 13
          Caption = '+R$'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtPrecoICM_Entrada: TSMALL_DBEdit
          Left = 358
          Top = 101
          Width = 55
          Height = 20
          Hint = 'Percentual de ICM destacado na nota de compra.'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'ICME'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object edtPrecoICM_Saida: TSMALL_DBEdit
          Left = 358
          Top = 126
          Width = 55
          Height = 20
          Hint = 
            'Percentual de ICM na nota de venda (Pode variar para vendas fora' +
            ' do estado)'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'ICMS'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object edtPrecoCustoOP: TSMALL_DBEdit
          Left = 358
          Top = 151
          Width = 55
          Height = 20
          Hint = 'Custo Operacional = Despesas Operacionais * 100 / Receitas'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'COPE'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object btnPrecoIgual: TBitBtn
          Left = 413
          Top = 151
          Width = 10
          Height = 20
          Caption = ':'
          TabOrder = 3
          OnClick = btnPrecoIgualClick
        end
        object edtPrecoOutrosImp: TSMALL_DBEdit
          Left = 358
          Top = 176
          Width = 55
          Height = 20
          Hint = 
            'Percentual de outros impostos incidentes (PIS, FINSOCIAL, COFINS' +
            ', IR)'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'IMPO'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object edtPrecoComissao: TSMALL_DBEdit
          Left = 358
          Top = 201
          Width = 55
          Height = 20
          Hint = 'Percentual de comiss'#227'o de vendedores (M'#233'dia)'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'CVEN'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object edtPrecoLucro: TSMALL_DBEdit
          Left = 358
          Top = 226
          Width = 55
          Height = 20
          Hint = '% de lucro desejado sobre a venda'
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = False
          DataField = 'LUCR'
          DataSource = Form7.DataSource13
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnExit = edtPrecoICM_EntradaExit
          OnKeyDown = edtPrecoICM_EntradaKeyDown
        end
        object btnPreco: TBitBtn
          Left = 399
          Top = 296
          Width = 120
          Height = 25
          Caption = 'Aplicar Neste'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = btnPrecoClick
        end
        object btnPrecoTodos: TBitBtn
          Left = 275
          Top = 296
          Width = 120
          Height = 25
          Caption = 'Aplicar Todos'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = btnPrecoTodosClick
        end
        object Panel2: TPanel
          Left = 426
          Top = 61
          Width = 90
          Height = 1
          BevelOuter = bvNone
          Color = clBlack
          ParentBackground = False
          TabOrder = 9
        end
        object Panel3: TPanel
          Left = 426
          Top = 249
          Width = 90
          Height = 1
          BevelOuter = bvNone
          Color = clBlack
          ParentBackground = False
          TabOrder = 10
        end
      end
      object tbsPromocao: TTabSheet
        Caption = 'Promo'#231#227'o'
        ImageIndex = 9
        object GroupBox3: TGroupBox
          Left = 17
          Top = 16
          Width = 450
          Height = 180
          Caption = ' Promo'#231#227'o por per'#237'odo '
          TabOrder = 0
          object Label44: TLabel
            Left = 45
            Top = 45
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Data inicial'
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
          object Label46: TLabel
            Left = 45
            Top = 70
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Data final'
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
          object Label47: TLabel
            Left = 45
            Top = 95
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Pre'#231'o promocional'
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
          object Label48: TLabel
            Left = 45
            Top = 120
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Pre'#231'o normal'
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
          object edtPromoIni: TSMALL_DBEdit
            Left = 145
            Top = 45
            Width = 100
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'PROMOINI'
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
          object edtPromoFim: TSMALL_DBEdit
            Left = 145
            Top = 70
            Width = 100
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'PROMOFIM'
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
          object edtPrecoPromo: TSMALL_DBEdit
            Left = 145
            Top = 95
            Width = 100
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ONPROMO'
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
          object edtPrecoNormal: TSMALL_DBEdit
            Left = 146
            Top = 121
            Width = 100
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'OFFPROMO'
            DataSource = DSCadastro
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            OnKeyDown = PadraoKeyDown
          end
        end
        object GroupBox4: TGroupBox
          Left = 17
          Top = 208
          Width = 450
          Height = 180
          Caption = '  Promo'#231#227'o por quantidade '
          TabOrder = 1
          object Label99: TLabel
            Left = 36
            Top = 45
            Width = 105
            Height = 13
            AutoSize = False
            Caption = 'Comprando a partir de'
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
          object Label102: TLabel
            Left = 201
            Top = 45
            Width = 67
            Height = 13
            AutoSize = False
            Caption = 'desconto de '
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
          object Label101: TLabel
            Left = 313
            Top = 45
            Width = 19
            Height = 13
            AutoSize = False
            Caption = '%'
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
          object Label103: TLabel
            Left = 36
            Top = 75
            Width = 105
            Height = 13
            AutoSize = False
            Caption = 'Comprando a partir de'
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
          object Label104: TLabel
            Left = 201
            Top = 75
            Width = 67
            Height = 13
            AutoSize = False
            Caption = 'desconto de '
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
          object Label105: TLabel
            Left = 313
            Top = 75
            Width = 19
            Height = 13
            AutoSize = False
            Caption = '%'
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
          object edtCompraA: TSMALL_DBEdit
            Left = 145
            Top = 45
            Width = 49
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'QTD_PRO1'
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
          object edtDescontoDe: TSMALL_DBEdit
            Left = 265
            Top = 45
            Width = 41
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'DESCONT1'
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
          object edtCompraA2: TSMALL_DBEdit
            Left = 145
            Top = 75
            Width = 49
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'QTD_PRO2'
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
          object edtDescontoDe2: TSMALL_DBEdit
            Left = 265
            Top = 75
            Width = 41
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'DESCONT2'
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
        end
      end
      object tbsConversao: TTabSheet
        Caption = 'Convers'#227'o'
        ImageIndex = 10
        OnEnter = tbsConversaoEnter
        object Label85: TLabel
          Left = 5
          Top = 30
          Width = 105
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unidade de entrada'
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
        object Label86: TLabel
          Left = 5
          Top = 60
          Width = 105
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Fator de convers'#227'o'
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
        object Label87: TLabel
          Left = 5
          Top = 90
          Width = 105
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unidade  de sa'#237'da'
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
        object Label88: TLabel
          Left = 17
          Top = 123
          Width = 61
          Height = 13
          Caption = 'Resultado:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblExemploConversao: TLabel
          Left = 17
          Top = 138
          Width = 99
          Height = 13
          Caption = 'Compra... e vende ...'
        end
        object edtFatorCon: TSMALL_DBEdit
          Left = 115
          Top = 60
          Width = 70
          Height = 22
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'FATORC'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          OnChange = edtFatorConChange
          OnExit = edtFatorConExit
          OnKeyDown = PadraoKeyDown
        end
        object cboConvEntrada: TComboBox
          Left = 115
          Top = 30
          Width = 70
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = cboConvEntradaChange
          OnKeyDown = PadraoKeyDown
        end
        object cboConvSaida: TComboBox
          Left = 115
          Top = 90
          Width = 70
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnChange = cboConvSaidaChange
          OnKeyDown = PadraoKeyDown
        end
      end
      object tbsCodBarras: TTabSheet
        Caption = 'V'#237'nculo entrada'
        ImageIndex = 11
        OnEnter = tbsCodBarrasEnter
        object Label15: TLabel
          Left = 594
          Top = 72
          Width = 163
          Height = 65
          Caption = 
            'Ao fazer a importa'#231#227'o do XML de compra, essa tabela '#233' alimentada' +
            ' automaticamente com o c'#243'digo de barras do seu fornecedor, crian' +
            'do o v'#237'nculo com este produto.'
          WordWrap = True
        end
        object Image6: TImage
          Left = 594
          Top = 42
          Width = 158
          Height = 24
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000150000
            00150806000000A917A596000000097048597300000B1300000B1301009A9C18
            000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
            D14944415478DAAD95DD4D02411485CF45138D4FD8015420540054A056802426
            A03E0015B054202F66C117B002A002E940AC00A800DE3446B99ED91FF99B0512
            9C64676767E67E3373E6DEBB82A8D2D6383E7185182EA088B32701C11073BCB3
            3DC09D8CA34CC50AFB4299C69500D2E77BC69131E129B6CD93F1C08ABA0DBE0A
            7DD2148ED065AB8F133828C82CF224AEDED0BAC6A783A2D4EDD010E8AFDEC13E
            C55523C9EB3A58D606AB1CEC45026C3A86B68A02C7070B6853DBEC9CB0D3B102
            9F798A6F64712F8D8805B324B52959DA48264B2BE5B6DDE8CED25473D23E4FDA
            9040F00C4A52D8AA5D8CEE558CD8E962B7357272829676F183171EADB7C560F7
            C28F74C5338CB8F0B981BE51AF021E647810D49760846364256CE05626FF0735
            3B9DD39502773808EAEA14A7489A9D366830DE7109FB5DA6F1A2922465F9D60E
            84FECD09236ACAFA3A52827DA046CF20AA7C684B2BACF394206D3530EE72CAF4
            17151C2DAD119808175D2414573BFCD29D97B109CCD3CA598EC805D4775E13AE
            266F56F70AD9A6965957D6437C3349BBEAB037EFA5405B863749FC837E1D43D9
            FBF6755C99B309F5C109D60E9F4B1A9B9DCF82D971FAB4FF5BF1F3AEF562EDD0
            E5629277CCFB4781C019251A6FFD23B0FC025AE6D93874963B68000000004945
            4E44AE426082}
        end
        object Label27: TLabel
          Left = 594
          Top = 143
          Width = 139
          Height = 26
          Caption = 'Para apagar um c'#243'digo tecle <DELETE>'
          WordWrap = True
        end
        object dbgCodBar: TDBGrid
          Left = 17
          Top = 23
          Width = 536
          Height = 384
          Ctl3D = False
          DataSource = Form7.DataSource6
          DrawingStyle = gdsGradient
          GradientEndColor = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          Options = [dgEditing, dgTitles, dgColLines, dgRowLines]
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Microsoft Sans Serif'
          TitleFont.Style = []
          OnKeyDown = dbgCodBarKeyDown
          Columns = <
            item
              Expanded = False
              FieldName = 'EAN'
              Title.Caption = 'C'#243'digo de barras'
              Width = 133
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FORNECEDOR'
              Width = 381
              Visible = True
            end>
        end
      end
      object tbsTags: TTabSheet
        Caption = 'Tag'#180's'
        ImageIndex = 12
        OnExit = tbsTagsExit
        OnShow = tbsTagsShow
        object Label106: TLabel
          Left = 17
          Top = 16
          Width = 177
          Height = 13
          Caption = 'Tag'#180's do item (altere somente o valor)'
        end
        object sgridTags: TStringGrid
          Left = 17
          Top = 47
          Width = 758
          Height = 362
          ColCount = 4
          Ctl3D = False
          DefaultColWidth = 158
          DrawingStyle = gdsClassic
          RowCount = 10
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ParentCtl3D = False
          TabOrder = 0
          OnDrawCell = sgridTagsDrawCell
          OnSelectCell = sgridTagsSelectCell
          RowHeights = (
            24
            24
            24
            24
            24
            24
            24
            24
            24
            24)
        end
        object Memo1: TMemo
          Left = 536
          Top = 8
          Width = 41
          Height = 33
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Visible = False
        end
        object memTags: TDBMemo
          Left = 584
          Top = 8
          Width = 33
          Height = 33
          Color = clWhite
          DataField = 'TAGS_'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          MaxLength = 5000
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          Visible = False
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet4
    OnDataChange = DSCadastroDataChange
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'JPEG Image File (*.jpg)|*.jpg|| | | | | | | | | '
    Left = 765
    Top = 7
  end
  object ppmTributacao: TPopupMenu
    Left = 47
    Top = 510
    object PorEAN1: TMenuItem
      Caption = 'Por EAN'
      OnClick = PorEAN1Click
    end
    object PorDescrio1: TMenuItem
      Caption = 'Por Descri'#231#227'o'
      OnClick = PorDescrio1Click
    end
  end
end
