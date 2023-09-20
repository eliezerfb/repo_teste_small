inherited FrmParametroTributacao: TFrmParametroTributacao
  Left = 710
  Top = 206
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object Label1: TLabel
          Left = 10
          Top = 8
          Width = 467
          Height = 13
          Caption = 
            'Parametriza'#231#227'o para produtos novos cadastrados na importa'#231#227'o do ' +
            'XML da nota fiscal de entrada.'
        end
        object gbPisCofinsEntrada: TGroupBox
          Left = 10
          Top = 26
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
          object SMALL_DBEdit37: TSMALL_DBEdit
            Left = 104
            Top = 19
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataSource = DSCadastro
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnKeyDown = SMALL_DBEdit37KeyDown
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
            ItemHeight = 16
            ParentFont = False
            TabOrder = 1
            OnKeyDown = SMALL_DBEdit37KeyDown
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
            ItemHeight = 16
            ParentFont = False
            TabOrder = 2
            OnKeyDown = SMALL_DBEdit37KeyDown
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
            ItemHeight = 16
            ParentFont = False
            TabOrder = 3
            OnKeyDown = SMALL_DBEdit37KeyDown
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
          object SMALL_DBEdit31: TSMALL_DBEdit
            Left = 104
            Top = 121
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataSource = DSCadastro
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnKeyDown = SMALL_DBEdit37KeyDown
          end
          object SMALL_DBEdit1: TSMALL_DBEdit
            Left = 103
            Top = 145
            Width = 70
            Height = 20
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvNone
            Ctl3D = True
            DataSource = DSCadastro
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnKeyDown = SMALL_DBEdit37KeyDown
          end
        end
        object GroupBox1: TGroupBox
          Left = 10
          Top = 210
          Width = 795
          Height = 225
          Caption = 'Campos de sa'#237'da'
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
        end
      end
    end
  end
end
