inherited FrmPerfilTributacao: TFrmPerfilTributacao
  Left = 548
  Top = 187
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsPerfilTributacao
      object tbsPerfilTributacao: TTabSheet
        Caption = 'Perfil Tributa'#231#227'o'
        OnEnter = tbsIPIEnter
        OnShow = tbsIPIShow
        object Label113: TLabel
          Left = 10
          Top = 75
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
        object Label114: TLabel
          Left = 10
          Top = 101
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
        object Label115: TLabel
          Left = 10
          Top = 127
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
        object Label116: TLabel
          Left = 10
          Top = 204
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
        object lblCSOSNPerfilTrib: TLabel
          Left = 10
          Top = 180
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
        object lblCSTPerfilTrib: TLabel
          Left = 10
          Top = 180
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
        object Label119: TLabel
          Left = 10
          Top = 50
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
        object Label120: TLabel
          Left = 10
          Top = 153
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
        object lblCitPerfilTrib: TLabel
          Left = 165
          Top = 206
          Width = 98
          Height = 13
          Caption = '5102 - Venda a vista'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCFOPNfce: TLabel
          Left = 10
          Top = 229
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
        object lblCSOSN_NFCePerfilTrib: TLabel
          Left = 10
          Top = 255
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
        object lblCST_NFCePerfilTrib: TLabel
          Left = 10
          Top = 255
          Width = 95
          Height = 18
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
        object lblAliqNFCEPerfilTrib: TLabel
          Left = 10
          Top = 282
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
        object Label128: TLabel
          Left = 163
          Top = 282
          Width = 8
          Height = 13
          Alignment = taCenter
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
        object Label129: TLabel
          Left = 10
          Top = 26
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nome do Perfil'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblAtencaoPerfilTrib: TLabel
          Left = 18
          Top = 417
          Width = 703
          Height = 13
          AutoSize = False
          Caption = 
            'Aten'#231#227'o: As informa'#231#245'es alteradas aqui ser'#227'o aplicadas em todos ' +
            'os produtos que estiverem com este perfil configurado.'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object edtIVAPerfilTrb: TSMALL_DBEdit
          Left = 110
          Top = 127
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
          TabOrder = 4
          OnKeyDown = PadraoKeyDown
        end
        object edtCITPerfilTrib: TSMALL_DBEdit
          Left = 110
          Top = 204
          Width = 50
          Height = 20
          AutoSize = False
          BevelInner = bvLowered
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ST'
          DataSource = Form7.DSPerfilTributa
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 8
          OnExit = edtCITPerfilTribExit
          OnKeyDown = PadraoKeyDown
        end
        object cboCSTPerfilTrib: TComboBox
          Left = 111
          Top = 178
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnChange = cboCSTPerfilTribChange
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
        object cboTipoItemPerfTrib: TComboBox
          Left = 110
          Top = 49
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnChange = cboTipoItemPerfTribChange
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
        object cboIPPTPerfTrib: TComboBox
          Left = 110
          Top = 75
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnChange = cboIPPTPerfTribChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            'P - Produ'#231#227'o pr'#243'pria'
            'T - Produ'#231#227'o por terceiros')
        end
        object cboIATPerfTrib: TComboBox
          Left = 110
          Top = 101
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnChange = cboIATPerfTribChange
          OnKeyDown = PadraoKeyDown
          Items.Strings = (
            'A - Arredondamento'
            'T - Truncamento')
        end
        object cboOrigemPerfTrib: TComboBox
          Left = 110
          Top = 152
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnChange = cboOrigemPerfTribChange
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
        object cboCSOSNPerfilTrib: TComboBox
          Left = 110
          Top = 178
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnChange = cboCSOSNPerfilTribChange
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
        object cboCFOP_NFCePerfTrib: TComboBox
          Left = 110
          Top = 229
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnChange = cboCFOP_NFCePerfTribChange
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
        object cboCST_NFCePerfilTrib: TComboBox
          Left = 110
          Top = 255
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnChange = cboCST_NFCePerfilTribChange
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
        object cboCSOSN_NFCePerfilTrib: TComboBox
          Left = 110
          Top = 255
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnChange = cboCSOSN_NFCePerfilTribChange
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
        object edtAliqNFCEPerfilTrib: TSMALL_DBEdit
          Left = 110
          Top = 281
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
          TabOrder = 12
          OnKeyDown = PadraoKeyDown
        end
        object edtDescricaoPerfilTrib: TSMALL_DBEdit
          Left = 110
          Top = 25
          Width = 390
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
          TabOrder = 0
          OnKeyDown = PadraoKeyDown
          OnMouseMove = edtDescricaoPerfilTribMouseMove
        end
      end
      object tbsIPI: TTabSheet
        Caption = 'IPI'
        ImageIndex = 1
        OnEnter = tbsIPIEnter
        OnShow = tbsIPIShow
        object Label134: TLabel
          Left = 0
          Top = 25
          Width = 165
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
        object Label135: TLabel
          Left = 0
          Top = 50
          Width = 165
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
        object Label136: TLabel
          Left = 0
          Top = 75
          Width = 165
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo Enquad. Legal do IPI'
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
        object lbAtencaoIPI: TLabel
          Left = 18
          Top = 417
          Width = 703
          Height = 13
          AutoSize = False
          Caption = 
            'Aten'#231#227'o: As informa'#231#245'es alteradas aqui ser'#227'o aplicadas em todos ' +
            'os produtos que estiverem com este perfil configurado.'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object cboCST_IPI_PerTrib: TComboBox
          Left = 170
          Top = 25
          Width = 420
          Height = 22
          Style = csOwnerDrawVariable
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = cboCST_IPI_PerTribChange
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
        object edtPercIPIPerfilTrib: TSMALL_DBEdit
          Left = 170
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
        object edtCodEnquadPerfilTrib: TSMALL_DBEdit
          Left = 170
          Top = 75
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
      object tbsPisCofins: TTabSheet
        Caption = 'PIS/COFINS'
        ImageIndex = 2
        OnEnter = tbsIPIEnter
        OnShow = tbsIPIShow
        object lbAtencaoPisCofins: TLabel
          Left = 18
          Top = 417
          Width = 703
          Height = 13
          AutoSize = False
          Caption = 
            'Aten'#231#227'o: As informa'#231#245'es alteradas aqui ser'#227'o aplicadas em todos ' +
            'os produtos que estiverem com este perfil configurado.'
          Color = clBtnHighlight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object GroupBox1: TGroupBox
          Left = 10
          Top = 10
          Width = 790
          Height = 126
          Caption = 'Sa'#237'da'
          TabOrder = 0
          object Label112: TLabel
            Left = 0
            Top = 25
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
          object lblCST_PIS_S_PerTrib: TLabel
            Left = 0
            Top = 50
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
          object lblCST_COFINS_S_PerTrib: TLabel
            Left = 0
            Top = 75
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
          object cboCST_PISCOFINS_S_PerTrib: TComboBox
            Left = 100
            Top = 25
            Width = 670
            Height = 22
            Style = csOwnerDrawVariable
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cboCST_PISCOFINS_S_PerTribChange
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
          object edtPercPISPerfiLTrib: TSMALL_DBEdit
            Left = 100
            Top = 50
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
          object edtPercCofinsPefilTrib: TSMALL_DBEdit
            Left = 100
            Top = 75
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
        end
        object GroupBox2: TGroupBox
          Left = 10
          Top = 160
          Width = 790
          Height = 126
          Caption = 'Entrada'
          TabOrder = 1
          object Label131: TLabel
            Left = 0
            Top = 25
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
          object lblCST_PIS_E_PerTrib: TLabel
            Left = 0
            Top = 50
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
          object lblCST_COFINS_E_PerTrib: TLabel
            Left = 0
            Top = 75
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
          object cboCST_PISCOFINS_E_PerTrib: TComboBox
            Left = 100
            Top = 25
            Width = 670
            Height = 22
            Style = csOwnerDrawVariable
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cboCST_PISCOFINS_E_PerTribChange
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
          object edtPecPISEntPerfilTrib: TSMALL_DBEdit
            Left = 100
            Top = 50
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
            TabOrder = 1
            OnKeyDown = PadraoKeyDown
          end
          object edtPercCofnsEntPerfilTrib: TSMALL_DBEdit
            Left = 100
            Top = 75
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
            TabOrder = 2
            OnKeyDown = PadraoKeyDown
          end
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibdPerfilTributa
    OnStateChange = DSCadastroStateChange
    OnDataChange = DSCadastroDataChange
  end
end
