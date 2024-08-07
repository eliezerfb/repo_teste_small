inherited FrmParametroTributacao: TFrmParametroTributacao
  Left = 467
  Top = 213
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object Label1: TLabel
          Left = 10
          Top = 5
          Width = 467
          Height = 13
          Caption = 
            'Parametriza'#231#227'o para produtos novos cadastrados na importa'#231#227'o do ' +
            'XML da nota fiscal de entrada.'
        end
        object gbPisCofinsEntrada: TGroupBox
          Left = 10
          Top = 22
          Width = 795
          Height = 177
          Caption = 'XML de entrada'
          TabOrder = 0
          object Label34: TLabel
            Left = 4
            Top = 19
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'CFOP'
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
          object Label51: TLabel
            Left = 4
            Top = 43
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
          object Label36: TLabel
            Left = 4
            Top = 95
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
            Left = 4
            Top = 69
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
          object Label31: TLabel
            Left = 4
            Top = 121
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = '% ICMS'
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
          object Label2: TLabel
            Left = 3
            Top = 145
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
          object edtCFOP: TSMALL_DBEdit
            Left = 104
            Top = 19
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'CFOP_ENTRADA'
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
          object cboOrigem: TComboBox
            Left = 104
            Top = 43
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
            OnChange = cboOrigemChange
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
          object cboCST: TComboBox
            Left = 104
            Top = 69
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
            OnChange = cboCSTChange
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
          object cboCSOSN: TComboBox
            Left = 104
            Top = 95
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
            OnChange = cboCSOSNChange
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
          object edtICMS: TSMALL_DBEdit
            Left = 104
            Top = 121
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'ALIQ_ENTRADA'
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
          object edtNCM: TSMALL_DBEdit
            Left = 103
            Top = 145
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataField = 'NCM_ENTRADA'
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
        end
        object GroupBox1: TGroupBox
          Left = 10
          Top = 204
          Width = 795
          Height = 231
          Caption = 'Cadastro no estoque'
          TabOrder = 1
          object Label3: TLabel
            Left = 4
            Top = 19
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Perfil de tributa'#231#227'o'
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
            Top = 49
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
          object Label113: TLabel
            Left = 10
            Top = 65
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
            Top = 81
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
            Top = 97
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
          object Label120: TLabel
            Left = 10
            Top = 113
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
          object Label116: TLabel
            Left = 10
            Top = 147
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
            Top = 130
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
            Top = 130
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
          object lblCFOPNfce: TLabel
            Left = 10
            Top = 164
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
            Top = 181
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
            Top = 181
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
            Top = 198
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
          object DBText1: TDBText
            Left = 113
            Top = 49
            Width = 273
            Height = 17
            DataField = 'TIPO_ITEM'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText2: TDBText
            Left = 113
            Top = 65
            Width = 273
            Height = 17
            DataField = 'IPPT'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText3: TDBText
            Left = 113
            Top = 81
            Width = 225
            Height = 17
            DataField = 'IAT'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText4: TDBText
            Left = 113
            Top = 97
            Width = 225
            Height = 17
            DataField = 'PIVA'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText5: TDBText
            Left = 113
            Top = 113
            Width = 273
            Height = 17
            DataField = 'ORIGEM'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object descCSTPerfilTrib: TDBText
            Left = 113
            Top = 130
            Width = 225
            Height = 17
            DataField = 'CST'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object descCSOSNPerfilTrib: TDBText
            Left = 112
            Top = 130
            Width = 225
            Height = 17
            DataField = 'CSOSN'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText8: TDBText
            Left = 113
            Top = 147
            Width = 225
            Height = 17
            DataField = 'ST'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText9: TDBText
            Left = 113
            Top = 164
            Width = 273
            Height = 17
            DataField = 'CFOP'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object descCST_NFCePerfilTrib: TDBText
            Left = 113
            Top = 181
            Width = 273
            Height = 17
            DataField = 'CST_NFCE'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText11: TDBText
            Left = 113
            Top = 198
            Width = 273
            Height = 17
            DataField = 'ALIQUOTA_NFCE'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object descCSOSN_NFCePerfilTrib: TDBText
            Left = 113
            Top = 181
            Width = 225
            Height = 17
            DataField = 'CSOSN_NFCE'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label10: TLabel
            Left = 412
            Top = 51
            Width = 95
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'CST IPI'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 412
            Top = 67
            Width = 95
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
          object Label12: TLabel
            Left = 400
            Top = 83
            Width = 107
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'C'#243'd. Enq. Legal do IPI'
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
          object DBText13: TDBText
            Left = 516
            Top = 51
            Width = 257
            Height = 17
            DataField = 'CST_IPI'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText14: TDBText
            Left = 516
            Top = 67
            Width = 257
            Height = 17
            DataField = 'IPI'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DBText15: TDBText
            Left = 516
            Top = 83
            Width = 257
            Height = 17
            DataField = 'ENQ_IPI'
            DataSource = DSPerfilTrib
            Font.Charset = ANSI_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          inline fraPerfilTrib: TfFrameCampo
            Left = 104
            Top = 19
            Width = 390
            Height = 22
            Color = clWhite
            Ctl3D = False
            ParentBackground = False
            ParentColor = False
            ParentCtl3D = False
            TabOrder = 0
            OnExit = fraPerfilTribExit
            ExplicitLeft = 104
            ExplicitTop = 19
            ExplicitWidth = 390
            ExplicitHeight = 22
            inherited txtCampo: TEdit
              Width = 390
              ExplicitWidth = 390
            end
            inherited gdRegistros: TDBGrid
              Width = 390
              OnDblClick = fraPerfilTribgdRegistrosDblClick
              OnKeyDown = fraPerfilTribgdRegistrosKeyDown
            end
          end
          object GroupBox2: TGroupBox
            Left = 394
            Top = 98
            Width = 388
            Height = 59
            Caption = 'Sa'#237'da'
            TabOrder = 1
            object Label4: TLabel
              Left = 19
              Top = 13
              Width = 95
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'CST PIS/COFINS'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 19
              Top = 27
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
            object Label6: TLabel
              Left = 19
              Top = 41
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
            object DBText16: TDBText
              Left = 122
              Top = 41
              Width = 257
              Height = 16
              DataField = 'ALIQ_COFINS_SAIDA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object DBText17: TDBText
              Left = 122
              Top = 13
              Width = 257
              Height = 16
              DataField = 'CST_PIS_COFINS_SAIDA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object DBText18: TDBText
              Left = 122
              Top = 27
              Width = 257
              Height = 16
              DataField = 'ALIQ_PIS_SAIDA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
          end
          object GroupBox3: TGroupBox
            Left = 395
            Top = 159
            Width = 387
            Height = 59
            Caption = 'Entrada'
            TabOrder = 2
            object Label7: TLabel
              Left = 19
              Top = 13
              Width = 95
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'CST PIS/COFINS'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 19
              Top = 27
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
            object Label9: TLabel
              Left = 19
              Top = 41
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
            object DBText19: TDBText
              Left = 122
              Top = 13
              Width = 257
              Height = 16
              DataField = 'CST_PIS_COFINS_ENTRADA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object DBText20: TDBText
              Left = 122
              Top = 27
              Width = 257
              Height = 16
              DataField = 'ALIQ_PIS_ENTRADA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object DBText21: TDBText
              Left = 122
              Top = 41
              Width = 257
              Height = 16
              DataField = 'ALIQ_COFINS_ENTRADA'
              DataSource = DSPerfilTrib
              Font.Charset = ANSI_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
            end
          end
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibdParametroTributa
    OnDataChange = DSCadastroDataChange
  end
  object DSPerfilTrib: TDataSource
    DataSet = ibdPerfilTrib
    Left = 672
    Top = 52
  end
  object ibdPerfilTrib: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    SelectSQL.Strings = (
      'Select'
      #9'Case'
      #9#9'When TIPO_ITEM = '#39'00'#39' then '#39'00 - Mercadoria para Revenda'#39
      #9#9'When TIPO_ITEM = '#39'01'#39' then '#39'01 - Mat'#233'ria-Prima'#39
      #9#9'When TIPO_ITEM = '#39'02'#39' then '#39'02 - Embalagem'#39
      #9#9'When TIPO_ITEM = '#39'03'#39' then '#39'03 - Produto em Processo'#39
      #9#9'When TIPO_ITEM = '#39'04'#39' then '#39'04 - Produto Acabado'#39
      #9#9'When TIPO_ITEM = '#39'05'#39' then '#39'05 - Subproduto'#39
      #9#9'When TIPO_ITEM = '#39'06'#39' then '#39'06 - Produto Intermedi'#225'rio'#39
      #9#9'When TIPO_ITEM = '#39'07'#39' then '#39'07 - Material de Uso e Consumo'#39
      #9#9'When TIPO_ITEM = '#39'08'#39' then '#39'08 - Ativo Imobilizado'#39
      #9#9'When TIPO_ITEM = '#39'09'#39' then '#39'09 - Servi'#231'os'#39
      #9#9'When TIPO_ITEM = '#39'10'#39' then '#39'10 - Outros insumos'#39
      #9#9'When TIPO_ITEM = '#39'99'#39' then '#39'99 - Outras'#39
      #9'End TIPO_ITEM,'
      #9'Case'
      #9#9'When IPPT = '#39'P'#39' then '#39'P - Produ'#231#227'o pr'#243'pria'#39' '#9
      #9#9'When IPPT = '#39'T'#39' then '#39'T - Produ'#231#227'o por terceiros'#39
      #9'End IPPT,'
      #9'Case'
      #9#9'When IAT = '#39'A'#39' then '#39'A - Arredondamento'#39' '#9
      #9#9'When IAT = '#39'T'#39' then '#39'T - Truncamento'#39
      #9'End IAT,'
      #9'Case'
      
        #9#9'When Substring(CST from 1  for 1) = '#39'0'#39' then '#39'0 - Nacional, ex' +
        'ceto as indicadas nos c'#243'digos 3 a 5'#39' '#9
      
        #9#9'When Substring(CST from 1  for 1) = '#39'1'#39' then '#39'1 - Estrangeira ' +
        '- Importa'#231#227'o direta, exceto a indicada no c'#243'digo 6'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'2'#39' then '#39'2 - Estrangeira ' +
        '- Adquirida no mercado interno, exceto a indicada no c'#243'digo 7'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'3'#39' then '#39'3 - Nacional, me' +
        'rcadoria ou bem com Conte'#250'do de Importa'#231#227'o superior a 40% (quare' +
        'nta por cento)'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'4'#39' then '#39'4 - Nacional, cu' +
        'ja produ'#231#227'o tenha sido feita em conformidade com os processos pr' +
        'odutivos b'#225'sicos de que tratam o Decreto-Lei n'#186' 288/1967, e as L' +
        'eis n'#186's 8.248/1991, 8.387/1991, 10.176/2001 e 11.484/2007;'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'5'#39' then '#39'5 - Nacional, me' +
        'rcadoria ou bem com Conte'#250'do de Importa'#231#227'o inferior ou igual a 4' +
        '0% (quarenta por cento)'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'6'#39' then '#39'6 - Estrangeira ' +
        '- Importa'#231#227'o direta, sem similar nacional, constante em lista de' +
        ' Resolu'#231#227'o CAMEX'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'7'#39' then '#39'7 - Estrangeira ' +
        '- Adquirida no mercado interno, sem similar nacional, constante ' +
        'em lista de Resolu'#231#227'o CAMEX.'#39
      
        #9#9'When Substring(CST from 1  for 1) = '#39'8'#39' then '#39'8 - Nacional, me' +
        'rcadoria ou bem com Conte'#250'do de Importa'#231#227'o sup. a 70%'#39
      #9'End ORIGEM,'
      #9'PIVA,'
      #9'Case'
      
        #9#9'When Substring(CST from 2  for 2) = '#39'00'#39' then '#39'00 - Tributada ' +
        'integralmente'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'10'#39' then '#39'10 - Tributada ' +
        'e com cobran'#231'a de ICMS por ST'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'20'#39' then '#39'20 - Com redu'#231#227 +
        'o de base de c'#225'lculo'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'30'#39' then '#39'30 - Isenta ou ' +
        'n'#227'o tributada e com cobran'#231'a do ICMS por ST'#39
      #9#9'When Substring(CST from 2  for 2) = '#39'40'#39' then '#39'40 - Isenta'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'41'#39' then '#39'41 - N'#227'o tribut' +
        'ada'#39
      #9#9'When Substring(CST from 2  for 2) = '#39'50'#39' then '#39'50 - Suspens'#227'o'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'51'#39' then '#39'51 - Diferiment' +
        'o'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'60'#39' then '#39'60 - ICMS Cobra' +
        'do anteriormente por ST'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'61'#39' then '#39'61 - Tributa'#231#227'o' +
        ' monof'#225'sica sobre combust'#237'veis cobrado anteriormente'#39
      
        #9#9'When Substring(CST from 2  for 2) = '#39'70'#39' then '#39'70 - Com red. d' +
        'e base de c'#225'lculo e cob. do ICMS por ST'#39
      #9#9'When Substring(CST from 2  for 2) = '#39'90'#39' then '#39'90 - Outras'#39#9#9
      #9'End CST,'
      #9'Case'
      
        #9#9'When CSOSN = '#39'101'#39' then '#39'101 - Tributada pelo Simples Nacional' +
        ' com permiss'#227'o de cr'#233'dito'#39
      
        #9#9'When CSOSN = '#39'102'#39' then '#39'102 - Tributada pelo Simples Nacional' +
        ' sem permiss'#227'o de cr'#233'dito'#39
      
        #9#9'When CSOSN = '#39'103'#39' then '#39'103 - Isen'#231#227'o do ICMS no Simples Naci' +
        'onal para faixa de receita bruta'#39
      
        #9#9'When CSOSN = '#39'201'#39' then '#39'201 - Trib. pelo Simples Nacional com' +
        ' permiss'#227'o de cr'#233'dito e com cobr. do ICMS por ST'#39
      
        #9#9'When CSOSN = '#39'203'#39' then '#39'203 - Isen'#231#227'o do ICMS no Simples Naci' +
        'onal para faixa de receita bruta e com cobran'#231'a do ICMS por ST'#39
      #9#9'When CSOSN = '#39'300'#39' then '#39'300 - Imune'#39
      
        #9#9'When CSOSN = '#39'400'#39' then '#39'400 - N'#227'o tributada pelo Simples Naci' +
        'onal'#39
      
        #9#9'When CSOSN = '#39'500'#39' then '#39'500 - ICMS cobrado anteriormente por ' +
        'ST (substitu'#237'do) ou por antecipa'#231#227'o'#39
      #9#9'When CSOSN = '#39'900'#39' then '#39'900 - Outros'#39
      
        #9#9'When CSOSN = '#39'61'#39' then '#39'61 - Tributa'#231#227'o monof'#225'sica sobre combu' +
        'st'#237'veis cobrado anteriormente'#39#9
      #9'End CSOSN,'
      #9'ST,'
      #9'Case'
      
        #9#9'When CFOP = '#39'5101'#39' then '#39'5101 - Venda de produ'#231#227'o do estabelec' +
        'imento'#39
      
        #9#9'When CFOP = '#39'5102'#39' then '#39'5102 - Venda de mercadoria de terceir' +
        'os'#39
      
        #9#9'When CFOP = '#39'5103'#39' then '#39'5103 - Venda de produ'#231#227'o do estabelec' +
        'imento efetuada fora do estabelecimento'#39
      
        #9#9'When CFOP = '#39'5104'#39' then '#39'5104 - Venda de mercadoria adquirida ' +
        'ou recebida de terceiros, efetuada fora do estabelecimento'#39
      
        #9#9'When CFOP = '#39'5115'#39' then '#39'5115 - Venda de mercadoria de terceir' +
        'os, recebida anteriormente em consigna'#231#227'o mercantil'#39
      
        #9#9'When CFOP = '#39'5405'#39' then '#39'5405 - Venda de mercadoria de terceir' +
        'os, sujeita a ST, como contribuinte substitu'#237'do'#39
      
        #9#9'When CFOP = '#39'5656'#39' then '#39'5656 - Venda de combust'#237'vel ou lubrif' +
        'icante de terceiros, destinados a consumidor final'#39
      
        #9#9'When CFOP = '#39'5667'#39' then '#39'5667 - Venda de combust'#237'vel ou lubrif' +
        'icante a consumidor ou usu'#225'rio final estabelecido em outra Unida' +
        'de da Federa'#231#227'o'#39
      
        #9#9'When CFOP = '#39'5933'#39' then '#39'5933 - Presta'#231#227'o de servi'#231'o tributado' +
        ' pelo ISSQN (Nota Fiscal conjugada)'#39
      
        #9#9'When CFOP = '#39'5949'#39' then '#39'5949 - Outra sa'#237'da de mercadoria ou p' +
        'resta'#231#227'o de servi'#231'o n'#227'o especificado'#39
      #9'End CFOP,'
      #9'Case'
      #9#9'When CST_NFCE = '#39'00'#39' then '#39'00 - Tributada integralmente'#39
      
        #9#9'When CST_NFCE = '#39'20'#39' then '#39'20 - Com redu'#231#227'o de base de c'#225'lculo' +
        #39
      #9#9'When CST_NFCE = '#39'40'#39' then '#39'40 - Isenta'#39
      #9#9'When CST_NFCE = '#39'41'#39' then '#39'41 - N'#227'o tributada'#39
      
        #9#9'When CST_NFCE = '#39'60'#39' then '#39'60 - ICMS Cobrado anteriormente por' +
        ' ST'#39
      
        #9#9'When CST_NFCE = '#39'61'#39' then '#39'61 - Tributa'#231#227'o monof'#225'sica sobre co' +
        'mbust'#237'veis cobrado anteriormente'#39
      #9#9'When CST_NFCE = '#39'90'#39' then '#39'90 - Outras'#39
      #9'End CST_NFCE,'
      #9'Case'
      
        #9#9'When CSOSN_NFCE = '#39'102'#39' then '#39'102 - Tributada pelo Simples Nac' +
        'ional sem permiss'#227'o de cr'#233'dito'#39
      
        #9#9'When CSOSN_NFCE = '#39'103'#39' then '#39'103 - Isen'#231#227'o do ICMS no Simples' +
        ' Nacional para faixa de receita bruta'#39
      #9#9'When CSOSN_NFCE = '#39'300'#39' then '#39'300 - Imune'#39
      
        #9#9'When CSOSN_NFCE = '#39'400'#39' then '#39'400 - N'#227'o tributada pelo Simples' +
        ' Nacional'#39
      
        #9#9'When CSOSN_NFCE = '#39'500'#39' then '#39'500 - ICMS cobrado anteriormente' +
        ' por ST (substitu'#237'do) ou por antecipa'#231#227'o'#39
      #9#9'When CSOSN_NFCE = '#39'900'#39' then '#39'900 - Outros'#39
      
        #9#9'When CSOSN_NFCE = '#39'61'#39' then '#39'61 - Tributa'#231#227'o monof'#225'sica sobre ' +
        'combust'#237'veis cobrado anteriormente'#39
      #9'End CSOSN_NFCE,'
      #9'ALIQUOTA_NFCE,'
      #9'Case'
      #9#9'When CST_IPI = '#39'50'#39' then '#39'50 - Sa'#237'da Tributada'#39
      
        #9#9'When CST_IPI = '#39'51'#39' then '#39'51 - Sa'#237'da Tribut'#225'vel com Al'#237'quota Z' +
        'ero'#39
      #9#9'When CST_IPI = '#39'52'#39' then '#39'52 - Sa'#237'da Isenta'#39
      #9#9'When CST_IPI = '#39'53'#39' then '#39'53 - Sa'#237'da N'#227'o-Tributada'#39
      #9#9'When CST_IPI = '#39'54'#39' then '#39'54 - Sa'#237'da Imune'#39
      #9#9'When CST_IPI = '#39'55'#39' then '#39'55 - Sa'#237'da com Suspens'#227'o'#39
      #9#9'When CST_IPI = '#39'99'#39' then '#39'99 - Outras Sa'#237'das'#39
      #9'End CST_IPI,'
      #9'IPI,'
      #9'ENQ_IPI,'
      #9'Case'
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'01'#39' then '#39'01-Opera'#231#227'o Tribut'#225'vel ' +
        'com Al'#237'quota B'#225'sica'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'02'#39' then '#39'02-Opera'#231#227'o Tribut'#225'vel ' +
        'com Al'#237'quota Diferenciada'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'03'#39' then '#39'03-Opera'#231#227'o Tribut'#225'vel ' +
        'com Al'#237'quota por Unidade de Medida de Produto'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'04'#39' then '#39'04-Opera'#231#227'o Tribut'#225'vel ' +
        'Monof'#225'sica - Revenda a Al'#237'quota Zero'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'05'#39' then '#39'05-Opera'#231#227'o Tribut'#225'vel ' +
        'por Substitui'#231#227'o Tribut'#225'ria'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'06'#39' then '#39'06-Opera'#231#227'o Tribut'#225'vel ' +
        'a Al'#237'quota Zero'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'07'#39' then '#39'07-Opera'#231#227'o Isenta da C' +
        'ontribui'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'08'#39' then '#39'08-Opera'#231#227'o sem Incid'#234'n' +
        'cia da Contribui'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'09'#39' then '#39'09-Opera'#231#227'o com Suspens' +
        #227'o da Contribui'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_SAIDA = '#39'49'#39' then '#39'49-Outras Opera'#231#245'es de ' +
        'Sa'#237'da'#39
      #9#9'When CST_PIS_COFINS_SAIDA = '#39'99'#39' then '#39'99-Outras Opera'#231#245'es'#39
      #9'End CST_PIS_COFINS_SAIDA,'
      #9'ALIQ_PIS_SAIDA,'
      #9'ALIQ_COFINS_SAIDA,'
      #9'Case'
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'50'#39' then '#39'50-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada Exclusivamente a Receita Tributada no M' +
        'ercado Interno'#39#9
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'51'#39' then '#39'51-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada Exclusivamente a Receita N'#227'o-Tributada ' +
        'no Mercado Interno'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'52'#39' then '#39'52-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada Exclusivamente a Receita de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'53'#39' then '#39'53-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada a Receitas Tributadas e N'#227'o-Tributadas ' +
        'no Mercado Interno'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'54'#39' then '#39'54-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada a Receitas Tributadas no Mercado Intern' +
        'o e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'55'#39' then '#39'55-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada a Receitas N'#227'o Tributadas no Mercado In' +
        'terno e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'56'#39' then '#39'56-Opera'#231#227'o com Direi' +
        'to a Cr'#233'dito - Vinculada a Receitas Tributadas e N'#227'o-Tributadas ' +
        'no Mercado Interno e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'60'#39' then '#39'60-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusivamente a Receita Tribu' +
        'tada no Mercado Interno'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'61'#39' then '#39'61-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusivamente a Receita N'#227'o-T' +
        'ributada no Mercado Interno'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'62'#39' then '#39'62-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada Exclusivamente a Receita de Ex' +
        'porta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'63'#39' then '#39'63-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receitas Tributadas e N'#227'o-Tr' +
        'ibutadas no Mercado Interno'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'64'#39' then '#39'64-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receitas Tributadas no Merca' +
        'do Interno e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'65'#39' then '#39'65-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receitas N'#227'o-Tributadas no M' +
        'ercado Interno e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'66'#39' then '#39'66-Cr'#233'dito Presumido ' +
        '- Opera'#231#227'o de Aquisi'#231#227'o Vinculada a Receitas Tributadas e N'#227'o-Tr' +
        'ibutadas no Mercado Interno e de Exporta'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'67'#39' then '#39'67-Cr'#233'dito Presumido ' +
        '- Outras Opera'#231#245'es'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'70'#39' then '#39'70-Opera'#231#227'o de Aquisi' +
        #231#227'o sem Direito a Cr'#233'dito'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'71'#39' then '#39'71-Opera'#231#227'o de Aquisi' +
        #231#227'o com Isen'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'72'#39' then '#39'72-Opera'#231#227'o de Aquisi' +
        #231#227'o com Suspens'#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'73'#39' then '#39'73-Opera'#231#227'o de Aquisi' +
        #231#227'o a Al'#237'quota Zero'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'74'#39' then '#39'74-Opera'#231#227'o de Aquisi' +
        #231#227'o sem Incid'#234'ncia da Contribui'#231#227'o'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'75'#39' then '#39'75-Opera'#231#227'o de Aquisi' +
        #231#227'o por Substitui'#231#227'o Tribut'#225'ria'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'98'#39' then '#39'98-Outras Opera'#231#245'es d' +
        'e Entrada'#39
      
        #9#9'When CST_PIS_COFINS_ENTRADA = '#39'99'#39' then '#39'99-Outras Opera'#231#245'es'#39#9 +
        #9
      #9'End CST_PIS_COFINS_ENTRADA,'
      #9'ALIQ_PIS_ENTRADA,'
      #9'ALIQ_COFINS_ENTRADA'
      'From PERFILTRIBUTACAO'
      'Where IDPERFILTRIBUTACAO = :IDPERFILTRIBUTACAO')
    ParamCheck = True
    UniDirectional = False
    DataSource = DSCadastro
    Left = 640
    Top = 52
    object ibdPerfilTribTIPO_ITEM: TIBStringField
      FieldName = 'TIPO_ITEM'
      FixedChar = True
      Size = 30
    end
    object ibdPerfilTribIPPT: TIBStringField
      FieldName = 'IPPT'
      FixedChar = True
      Size = 26
    end
    object ibdPerfilTribIAT: TIBStringField
      FieldName = 'IAT'
      FixedChar = True
      Size = 18
    end
    object ibdPerfilTribORIGEM: TIBStringField
      FieldName = 'ORIGEM'
      FixedChar = True
      Size = 202
    end
    object ibdPerfilTribPIVA: TFloatField
      FieldName = 'PIVA'
      Origin = 'PERFILTRIBUTACAO.PIVA'
      DisplayFormat = '#,##0.00000'
    end
    object ibdPerfilTribCST: TIBStringField
      FieldName = 'CST'
      FixedChar = True
      Size = 67
    end
    object ibdPerfilTribCSOSN: TIBStringField
      FieldName = 'CSOSN'
      FixedChar = True
      Size = 99
    end
    object ibdPerfilTribST: TIBStringField
      FieldName = 'ST'
      Origin = 'PERFILTRIBUTACAO.ST'
      Size = 3
    end
    object ibdPerfilTribCFOP: TIBStringField
      FieldName = 'CFOP'
      FixedChar = True
      Size = 116
    end
    object ibdPerfilTribCST_NFCE: TIBStringField
      FieldName = 'CST_NFCE'
      FixedChar = True
      Size = 67
    end
    object ibdPerfilTribCSOSN_NFCE: TIBStringField
      FieldName = 'CSOSN_NFCE'
      FixedChar = True
      Size = 72
    end
    object ibdPerfilTribALIQUOTA_NFCE: TIBBCDField
      FieldName = 'ALIQUOTA_NFCE'
      Origin = 'PERFILTRIBUTACAO.ALIQUOTA_NFCE'
      DisplayFormat = '##0.00'
      Precision = 18
      Size = 2
    end
    object ibdPerfilTribCST_IPI: TIBStringField
      FieldName = 'CST_IPI'
      FixedChar = True
      Size = 39
    end
    object ibdPerfilTribIPI: TFloatField
      FieldName = 'IPI'
      Origin = 'PERFILTRIBUTACAO.IPI'
      DisplayFormat = '#0.00'
    end
    object ibdPerfilTribENQ_IPI: TIBStringField
      FieldName = 'ENQ_IPI'
      Origin = 'PERFILTRIBUTACAO.ENQ_IPI'
      Size = 3
    end
    object ibdPerfilTribCST_PIS_COFINS_SAIDA: TIBStringField
      FieldName = 'CST_PIS_COFINS_SAIDA'
      FixedChar = True
      Size = 68
    end
    object ibdPerfilTribALIQ_PIS_SAIDA: TIBBCDField
      FieldName = 'ALIQ_PIS_SAIDA'
      Origin = 'PERFILTRIBUTACAO.ALIQ_PIS_SAIDA'
      DisplayFormat = '#0.0000'
      Precision = 18
      Size = 4
    end
    object ibdPerfilTribALIQ_COFINS_SAIDA: TIBBCDField
      FieldName = 'ALIQ_COFINS_SAIDA'
      Origin = 'PERFILTRIBUTACAO.ALIQ_COFINS_SAIDA'
      DisplayFormat = '#0.0000'
      Precision = 18
      Size = 4
    end
    object ibdPerfilTribCST_PIS_COFINS_ENTRADA: TIBStringField
      FieldName = 'CST_PIS_COFINS_ENTRADA'
      FixedChar = True
      Size = 128
    end
    object ibdPerfilTribALIQ_PIS_ENTRADA: TIBBCDField
      FieldName = 'ALIQ_PIS_ENTRADA'
      Origin = 'PERFILTRIBUTACAO.ALIQ_PIS_ENTRADA'
      DisplayFormat = '#0.0000'
      Precision = 18
      Size = 4
    end
    object ibdPerfilTribALIQ_COFINS_ENTRADA: TIBBCDField
      FieldName = 'ALIQ_COFINS_ENTRADA'
      Origin = 'PERFILTRIBUTACAO.ALIQ_COFINS_ENTRADA'
      DisplayFormat = '#0.0000'
      Precision = 18
      Size = 4
    end
  end
end
