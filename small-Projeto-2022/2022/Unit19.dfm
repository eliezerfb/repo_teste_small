object Form19: TForm19
  Left = 590
  Top = 201
  AlphaBlendValue = 200
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es e ajustes do sistema'
  ClientHeight = 441
  ClientWidth = 624
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Orelhas: TPageControl
    Left = 20
    Top = 20
    Width = 584
    Height = 358
    ActivePage = Orelha_permitir
    Align = alClient
    TabOrder = 0
    object Orelha_relatorios: TTabSheet
      Caption = 'Relat'#243'rios'
      object GroupBox3: TGroupBox
        Left = 15
        Top = 15
        Width = 213
        Height = 100
        Caption = 'Relat'#243'rios'
        TabOrder = 0
        object RadioButton3: TRadioButton
          Left = 8
          Top = 25
          Width = 113
          Height = 17
          Hint = 'HTM - Este formato apresenta uma boa apresenta'#231#227'o visual.'
          Caption = 'HTML'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = FormKeyDown
        end
        object RadioButton4: TRadioButton
          Left = 8
          Top = 50
          Width = 113
          Height = 17
          Hint = 
            'TXT - Este formato apresenta um melhor desempenho, mas sem uma b' +
            'oa apresenta'#231#227'o visual.'
          Caption = 'TXT'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnKeyDown = FormKeyDown
        end
        object RadioButton5: TRadioButton
          Left = 8
          Top = 75
          Width = 113
          Height = 17
          Hint = 
            'PDF - Este formato apresenta uma '#243'tima apresenta'#231#227'o visual e pod' +
            'e ser distribu'#237'do facilmente.'
          Caption = 'PDF'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnKeyDown = FormKeyDown
        end
      end
      object GroupBox5: TGroupBox
        Left = 240
        Top = 15
        Width = 230
        Height = 225
        Caption = 'Clique no logotipo ou na cor do cabe'#231'alho'
        TabOrder = 1
        object Panel1: TPanel
          Left = 15
          Top = 24
          Width = 185
          Height = 185
          BevelOuter = bvNone
          Color = clWhite
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          object Image1: TImage
            Left = 56
            Top = 16
            Width = 180
            Height = 45
            Stretch = True
            OnClick = Image1Click
          end
          object Edit7: TEdit
            Left = 7
            Top = 79
            Width = 43
            Height = 20
            Cursor = crHandPoint
            AutoSize = False
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Text = 'C'#243'digo'
            OnClick = Edit7Click
            OnEnter = Edit8Enter
          end
          object Edit8: TEdit
            Left = 49
            Top = 79
            Width = 150
            Height = 20
            Cursor = crHandPoint
            AutoSize = False
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = 'Descri'#231#227'o'
            OnClick = Edit7Click
            OnEnter = Edit8Enter
          end
          object Edit9: TEdit
            Left = 7
            Top = 98
            Width = 43
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            Text = '00001'
            OnEnter = Edit8Enter
          end
          object Edit10: TEdit
            Left = 49
            Top = 98
            Width = 150
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            Text = 'Xxxxxx x xxxxxxxxxxxxxxxxx'
            OnEnter = Edit8Enter
          end
          object Edit11: TEdit
            Left = 7
            Top = 117
            Width = 43
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 4
            Text = '00002'
            OnEnter = Edit8Enter
          end
          object Edit12: TEdit
            Left = 49
            Top = 117
            Width = 150
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 5
            Text = 'Xxxxxxxxx xxxxxxxxx xxx'
            OnEnter = Edit8Enter
          end
          object Edit13: TEdit
            Left = 49
            Top = 136
            Width = 150
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 6
            Text = 'Xxxxxx xxxxx'
            OnEnter = Edit8Enter
          end
          object Edit14: TEdit
            Left = 49
            Top = 155
            Width = 150
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 7
            Text = 'Xxxxxx xxxxxxxxxxx'
            OnEnter = Edit8Enter
          end
          object Edit15: TEdit
            Left = 7
            Top = 136
            Width = 43
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 8
            Text = '00003'
            OnEnter = Edit8Enter
          end
          object Edit16: TEdit
            Left = 7
            Top = 155
            Width = 43
            Height = 20
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 9
            Text = '00004'
            OnEnter = Edit8Enter
          end
        end
      end
    end
    object tbsTema: TTabSheet
      Caption = 'Tema'
      ImageIndex = 10
      object gbTema: TGroupBox
        Left = 15
        Top = 15
        Width = 213
        Height = 68
        TabOrder = 0
        object rbClassico: TRadioButton
          Left = 8
          Top = 13
          Width = 113
          Height = 17
          Caption = 'Cl'#225'ssico'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = rbClassicoClick
          OnKeyDown = FormKeyDown
        end
        object rbModerno: TRadioButton
          Left = 8
          Top = 36
          Width = 113
          Height = 21
          Caption = 'Moderno'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnKeyDown = FormKeyDown
        end
      end
    end
    object Orelha_permitir: TTabSheet
      Caption = 'Permitir'
      ImageIndex = 1
      object Label35: TLabel
        Left = 92
        Top = 276
        Width = 213
        Height = 13
        Caption = '% m'#225'ximo de desconto no item do or'#231'amento'
      end
      object Label36: TLabel
        Left = 92
        Top = 304
        Width = 214
        Height = 13
        Caption = '% m'#225'ximo de desconto no total do or'#231'amento'
      end
      object chkItensDuplicadosNF: TCheckBox
        Left = 15
        Top = 101
        Width = 194
        Height = 17
        Caption = 'Itens duplos na Nota Fiscal'
        TabOrder = 3
      end
      object chkEstoqueNegativoNF: TCheckBox
        Left = 15
        Top = 43
        Width = 306
        Height = 17
        Caption = 'Vendas com estoque negativo ou zerado'
        TabOrder = 1
      end
      object chkVendasAbaixoCusto: TCheckBox
        Left = 15
        Top = 15
        Width = 137
        Height = 17
        Caption = 'Vendas abaixo do custo'
        TabOrder = 0
      end
      object SMALL_DBEdit4: TSMALL_DBEdit
        Left = 15
        Top = 273
        Width = 66
        Height = 19
        DataField = 'DIFERENCA_'
        DataSource = Form7.DataSource25
        TabOrder = 7
        OnKeyDown = SMALL_DBEdit1KeyDown
      end
      object SMALL_DBEdit5: TSMALL_DBEdit
        Left = 15
        Top = 301
        Width = 66
        Height = 19
        DataField = 'PAGAR'
        DataSource = Form7.DataSource25
        TabOrder = 8
        OnKeyDown = SMALL_DBEdit1KeyDown
      end
      object chkFabricaProdSemQtd: TCheckBox
        Left = 15
        Top = 72
        Width = 421
        Height = 17
        Caption = 
          'Fabrica'#231#227'o de produtos com quantidade insuficiente na Nota Fisca' +
          'l'
        TabOrder = 2
      end
      object chkCalcLucroEstoque: TCheckBox
        Left = 15
        Top = 130
        Width = 290
        Height = 17
        Caption = 'C'#225'lculo do Lucro ao alterar Pre'#231'o de venda no estoque'
        TabOrder = 4
      end
      object chkImportaMesmoOrc: TCheckBox
        Left = 15
        Top = 158
        Width = 290
        Height = 17
        Caption = 'Importar mesmo or'#231'amento m'#250'ltiplas vezes no cupom'
        TabOrder = 5
      end
      object chkRecalculaCustoMedioRetroativo: TCheckBox
        Left = 15
        Top = 187
        Width = 194
        Height = 17
        Hint = 
          'Recalcular custo m'#233'dio retroativo do item baseado em todas as no' +
          'tas de entrada'
        Caption = 'Recalcular custo m'#233'dio retroativo'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object chkOcultaUsoConsumoVenda: TCheckBox
        Left = 15
        Top = 216
        Width = 346
        Height = 17
        Caption = 'Ocultar produtos de uso e consumo nas vendas'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object chkPermiteDuplicarCNPJ: TCheckBox
        Left = 15
        Top = 245
        Width = 346
        Height = 17
        Caption = 'Duplicar CPF/CNPJ no cadastro de clientes'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
    end
    object Orelha_juros: TTabSheet
      Caption = 'Juros e Multa'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 15
        Top = 135
        Width = 300
        Height = 71
        Caption = 'Calcular juros'
        TabOrder = 1
        object rbJurosSimples: TRadioButton
          Left = 40
          Top = 19
          Width = 113
          Height = 17
          Caption = 'Juros simples'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbJurosSimplesClick
          OnKeyDown = rbJurosSimplesKeyDown
        end
        object rbJurosComposto: TRadioButton
          Left = 40
          Top = 44
          Width = 113
          Height = 17
          Caption = 'Juros compostos'
          TabOrder = 1
          OnClick = rbJurosCompostoClick
          OnKeyDown = rbJurosSimplesKeyDown
        end
      end
      object GroupBox2: TGroupBox
        Left = 15
        Top = 15
        Width = 300
        Height = 112
        Caption = 'Taxa de juros para duplicatas em atraso'
        TabOrder = 0
        object Label18: TLabel
          Left = 52
          Top = 25
          Width = 30
          Height = 13
          Caption = 'Di'#225'ria:'
        end
        object Label17: TLabel
          Left = 44
          Top = 51
          Width = 37
          Height = 13
          Caption = 'Mensal:'
        end
        object Label19: TLabel
          Left = 51
          Top = 77
          Width = 30
          Height = 13
          Caption = 'Anual:'
        end
        object edtJurosDia: TEdit
          Left = 87
          Top = 25
          Width = 70
          Height = 19
          TabOrder = 0
          Text = '0,00'
          OnExit = edtJurosDiaExit
          OnKeyDown = SMALL_DBEdit1KeyDown
          OnKeyPress = edtJurosDiaKeyPress
        end
        object edtJurosMes: TEdit
          Left = 87
          Top = 51
          Width = 70
          Height = 19
          TabOrder = 1
          Text = '0,00'
          OnExit = edtJurosMesExit
          OnKeyDown = SMALL_DBEdit1KeyDown
          OnKeyPress = edtJurosDiaKeyPress
        end
        object edtJurosAno: TEdit
          Left = 87
          Top = 77
          Width = 70
          Height = 19
          TabOrder = 2
          Text = '0,00'
          OnExit = edtJurosAnoExit
          OnKeyDown = SMALL_DBEdit1KeyDown
          OnKeyPress = edtJurosDiaKeyPress
        end
      end
      object GroupBox4: TGroupBox
        Left = 15
        Top = 216
        Width = 300
        Height = 105
        Caption = 'Calcular multa'
        TabOrder = 2
        object lblMulta: TLabel
          Left = 28
          Top = 73
          Width = 8
          Height = 13
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = '%'
          ParentBiDiMode = False
        end
        object rbMultaPercentual: TRadioButton
          Left = 40
          Top = 19
          Width = 113
          Height = 17
          Caption = 'Percentual'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbMultaPercentualClick
          OnKeyDown = rbJurosSimplesKeyDown
        end
        object rbMultaValor: TRadioButton
          Left = 40
          Top = 44
          Width = 113
          Height = 17
          Caption = 'Valor fixo'
          TabOrder = 1
          OnClick = rbMultaPercentualClick
          OnKeyDown = rbJurosSimplesKeyDown
        end
        object edtVlMulta: TEdit
          Left = 40
          Top = 70
          Width = 70
          Height = 19
          TabOrder = 2
          Text = '0,00'
          OnExit = edtVlMultaExit
          OnKeyDown = SMALL_DBEdit1KeyDown
          OnKeyPress = edtJurosDiaKeyPress
        end
      end
    end
    object Orelha_prazo: TTabSheet
      Caption = 'Prazo'
      ImageIndex = 3
      object Label4: TLabel
        Left = 43
        Top = 57
        Width = 58
        Height = 13
        Caption = 'Duplicata A:'
      end
      object Label7: TLabel
        Left = 139
        Top = 57
        Width = 19
        Height = 13
        Caption = 'dias'
      end
      object Label20: TLabel
        Left = 219
        Top = 57
        Width = 124
        Height = 13
        Caption = '% sobre o pre'#231'o de venda'
      end
      object Label5: TLabel
        Left = 43
        Top = 89
        Width = 58
        Height = 13
        Caption = 'Duplicata B:'
      end
      object Label8: TLabel
        Left = 139
        Top = 89
        Width = 19
        Height = 13
        Caption = 'dias'
      end
      object Label21: TLabel
        Left = 219
        Top = 89
        Width = 124
        Height = 13
        Caption = '% sobre o pre'#231'o de venda'
      end
      object Label6: TLabel
        Left = 43
        Top = 121
        Width = 58
        Height = 13
        Caption = 'Duplicata C:'
      end
      object Label9: TLabel
        Left = 139
        Top = 121
        Width = 19
        Height = 13
        Caption = 'dias'
      end
      object Label22: TLabel
        Left = 219
        Top = 121
        Width = 124
        Height = 13
        Caption = '% sobre o pre'#231'o de venda'
      end
      object Label38: TLabel
        Left = 43
        Top = 192
        Width = 193
        Height = 13
        Caption = 'Fixar vencimento das parcelas para o dia'
      end
      object edtDiasPrazoA: TMaskEdit
        Left = 109
        Top = 57
        Width = 24
        Height = 19
        EditMask = '!999;1; '
        MaxLength = 3
        TabOrder = 1
        Text = '   '
        OnExit = edtDiasPrazoAExit
        OnKeyDown = edtPercListaAKeyDown
      end
      object edtPercListaA: TMaskEdit
        Left = 164
        Top = 57
        Width = 46
        Height = 19
        EditMask = '!###,##;1; '
        MaxLength = 6
        TabOrder = 2
        Text = '   ,  '
        OnExit = edtPercListaAExit
        OnKeyDown = edtPercListaAKeyDown
        OnKeyPress = edtPercListaAKeyPress
      end
      object edtDiasPrazoB: TMaskEdit
        Left = 109
        Top = 89
        Width = 24
        Height = 19
        EditMask = '!999;1; '
        MaxLength = 3
        TabOrder = 3
        Text = '   '
        OnExit = edtDiasPrazoBExit
        OnKeyDown = edtPercListaAKeyDown
      end
      object edtPercListaB: TMaskEdit
        Left = 164
        Top = 89
        Width = 46
        Height = 19
        EditMask = '!###,##;1; '
        MaxLength = 6
        TabOrder = 4
        Text = '   ,  '
        OnExit = edtPercListaBExit
        OnKeyDown = edtPercListaAKeyDown
        OnKeyPress = edtPercListaAKeyPress
      end
      object edtDiasPrazoC: TMaskEdit
        Left = 109
        Top = 121
        Width = 24
        Height = 19
        EditMask = '!999;1; '
        MaxLength = 3
        TabOrder = 5
        Text = '   '
        OnExit = edtDiasPrazoCExit
        OnKeyDown = edtPercListaAKeyDown
      end
      object edtPercListaC: TMaskEdit
        Left = 164
        Top = 121
        Width = 46
        Height = 19
        EditMask = '!###,##;1; '
        MaxLength = 6
        TabOrder = 6
        Text = '   ,  '
        OnExit = edtPercListaCExit
        OnKeyDown = edtPercListaAKeyDown
        OnKeyPress = edtPercListaAKeyPress
      end
      object rbPrazoDias: TRadioButton
        Left = 15
        Top = 24
        Width = 185
        Height = 17
        Caption = 'Prazo por quantidade de dias'
        TabOrder = 0
      end
      object rbPrazoFixo: TRadioButton
        Left = 15
        Top = 160
        Width = 113
        Height = 17
        Caption = 'Prazo com dia fixo'
        TabOrder = 7
      end
      object cboDiaVencimento: TComboBox
        Left = 242
        Top = 189
        Width = 58
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 8
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31')
      end
    end
    object Orelha_ajustes: TTabSheet
      Caption = 'Ajustes'
      ImageIndex = 4
      object Label23: TLabel
        Left = 80
        Top = 18
        Width = 118
        Height = 13
        Alignment = taRightJustify
        Caption = 'Casas decimais no pre'#231'o'
      end
      object Label2: TLabel
        Left = 80
        Top = 45
        Width = 144
        Height = 13
        Alignment = taRightJustify
        Caption = 'Casas decimais na quantidade'
      end
      object Label30: TLabel
        Left = 80
        Top = 75
        Width = 201
        Height = 13
        Alignment = taRightJustify
        Caption = 'Casas decimais na quantidade de servi'#231'os'
      end
      object Label13: TLabel
        Left = 60
        Top = 190
        Width = 89
        Height = 13
        Alignment = taRightJustify
        Caption = 'Itens na nota fiscal'
        Visible = False
      end
      object Label31: TLabel
        Left = 60
        Top = 220
        Width = 110
        Height = 13
        Alignment = taRightJustify
        Caption = 'Servi'#231'os na  nota fiscal'
        Visible = False
      end
      object Label33: TLabel
        Left = 60
        Top = 250
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Itens na OS'
        Visible = False
      end
      object Label32: TLabel
        Left = 60
        Top = 280
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Servi'#231'os na  OS'
        Visible = False
      end
      object Label28: TLabel
        Left = 60
        Top = 310
        Width = 132
        Height = 13
        Alignment = taRightJustify
        Caption = 'Vias na impress'#227'o do recibo'
        Visible = False
      end
      object Label34: TLabel
        Left = 80
        Top = 105
        Width = 171
        Height = 13
        Caption = 'N'#250'mero de Serie especial para NF-e'
      end
      object ComboBox4: TComboBox
        Left = 15
        Top = 18
        Width = 60
        Height = 21
        TabOrder = 0
        Text = '2'
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9')
      end
      object ComboBox1: TComboBox
        Left = 15
        Top = 45
        Width = 60
        Height = 21
        TabOrder = 1
        Text = '2'
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object ComboBox7: TComboBox
        Left = 15
        Top = 75
        Width = 60
        Height = 21
        TabOrder = 2
        Text = '2'
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object ComboBox5: TComboBox
        Left = 15
        Top = 190
        Width = 40
        Height = 21
        TabOrder = 3
        Text = '20'
        Visible = False
        OnExit = ComboBox5Exit
        Items.Strings = (
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50')
      end
      object ComboBox8: TComboBox
        Left = 15
        Top = 220
        Width = 40
        Height = 21
        TabOrder = 4
        Text = '5'
        Visible = False
        OnExit = ComboBox8Exit
        Items.Strings = (
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50')
      end
      object ComboBox10: TComboBox
        Left = 15
        Top = 250
        Width = 40
        Height = 21
        TabOrder = 5
        Text = '20'
        Visible = False
        OnExit = ComboBox10Exit
        Items.Strings = (
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50')
      end
      object ComboBox9: TComboBox
        Left = 15
        Top = 280
        Width = 40
        Height = 21
        TabOrder = 6
        Text = '5'
        Visible = False
        OnExit = ComboBox9Exit
        Items.Strings = (
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50')
      end
      object ComboBox6: TComboBox
        Left = 15
        Top = 310
        Width = 40
        Height = 21
        TabOrder = 7
        Text = '1'
        Visible = False
        Items.Strings = (
          '1'
          '2'
          '3'
          '4')
      end
      object ComboBox11: TComboBox
        Left = 15
        Top = 105
        Width = 60
        Height = 21
        TabOrder = 8
        Text = ' '
        OnExit = ComboBox11Exit
        Items.Strings = (
          ''
          '803')
      end
    end
    object Orelha_IR: TTabSheet
      Caption = 'IR'
      ImageIndex = 6
      object Label12: TLabel
        Left = 15
        Top = 15
        Width = 225
        Height = 13
        Alignment = taRightJustify
        Caption = 'Teto limite para tributa'#231#227'o de IR sobre servi'#231'os:'
      end
      object Label14: TLabel
        Left = 15
        Top = 65
        Width = 254
        Height = 13
        Alignment = taRightJustify
        Caption = 'Al'#237'quota de IR sobre notas de servi'#231'os acima do teto:'
      end
      object ComboBox2: TComboBox
        Left = 15
        Top = 30
        Width = 260
        Height = 21
        TabOrder = 0
        Text = 'R$ 10.000,00'
        Items.Strings = (
          'R$    500,00'
          'R$ 1.000,00'
          'R$ 1.500,00'
          'R$ 2.000,00'
          'R$ 2.500,00'
          'R$ 3.000,00'
          'R$ 3.500,00'
          'R$ 4.000,00'
          'R$ 4.500,00'
          'R$ 5.000,00'
          'R$ 5.500,00'
          'R$ 6.000,00'
          'R$ 6.500,00'
          'R$ 7.000,00'
          'R$ 7.500,00'
          'R$ 8.000,00'
          'R$ 8.500,00'
          'R$ 9.000,00'
          'R$ 9.500,00'
          'R$ 10.000,00'
          'R$ 11.000,00'
          'R$ 12.000,00'
          'R$ 13.000,00'
          'R$ 14.000,00'
          'R$ 15.000,00'
          'R$ 20.000,00'
          'R$ 25.000,00'
          'R$ 30.000,00'
          'R$ 35.000,00'
          'R$ 40.000,00'
          'R$ 45.000,00'
          'R$ 50.000,00'
          'R$ 100.000,00')
      end
      object ComboBox3: TComboBox
        Left = 15
        Top = 80
        Width = 260
        Height = 21
        TabOrder = 1
        Text = '1,50 %'
        Items.Strings = (
          '1,00 %'
          '1,50 %'
          '2,00 %'
          '2,50 %'
          '3,00 %'
          '3,50 %'
          '4,00 %'
          '4,50 %'
          '5,00 %'
          '5,50 %'
          '6,00 %'
          '6,50 %'
          '7,00 %'
          '7,50 %'
          '8,00 %'
          '9,00 %'
          '10,00 %'
          '11,00 %'
          '12,00 %'
          '13,00 %'
          '14,00 %'
          '15,00 %')
      end
    end
    object Orelha_matricial: TTabSheet
      Caption = 'Impress'#227'o'
      ImageIndex = 5
      object Label26: TLabel
        Left = 33
        Top = 88
        Width = 89
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nota fiscal Serie 1:'
      end
      object Label29: TLabel
        Left = 33
        Top = 115
        Width = 89
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nota fiscal Serie 2:'
      end
      object Label37: TLabel
        Left = 65
        Top = 32
        Width = 55
        Height = 13
        Alignment = taRightJustify
        Caption = 'Or'#231'amento:'
      end
      object Label39: TLabel
        Left = 34
        Top = 60
        Width = 86
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ordem de servi'#231'o:'
      end
      object lblFormatoOrc: TLabel
        Left = 343
        Top = 32
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Formato'
      end
      object ComboBoxNF: TComboBox
        Left = 125
        Top = 86
        Width = 200
        Height = 21
        TabOrder = 3
      end
      object ComboBoxNF2: TComboBox
        Left = 125
        Top = 113
        Width = 200
        Height = 21
        TabOrder = 4
      end
      object ComboBoxImpressora: TComboBox
        Left = 15
        Top = 280
        Width = 300
        Height = 21
        TabOrder = 5
        Text = 'ComboBoxImpressora'
        Visible = False
      end
      object ComboBoxORCA: TComboBox
        Left = 125
        Top = 30
        Width = 200
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 0
        OnChange = ComboBoxORCAChange
      end
      object ComboBoxOS: TComboBox
        Left = 125
        Top = 58
        Width = 200
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 2
      end
      object cboFormatoOrc: TComboBox
        Left = 387
        Top = 30
        Width = 87
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 1
        Items.Strings = (
          '80mm'
          'A5'
          'A5 Matricial')
      end
    end
    object Orelha_atendimento: TTabSheet
      Caption = 'Atendimento'
      ImageIndex = 7
      object Label11: TLabel
        Left = 15
        Top = 25
        Width = 142
        Height = 13
        Caption = 'Hor'#225'rio inicial de atendimento:'
      end
      object Label16: TLabel
        Left = 15
        Top = 60
        Width = 135
        Height = 13
        Caption = 'Hor'#225'rio final de atendimento:'
      end
      object MaskEdit1: TMaskEdit
        Left = 165
        Top = 25
        Width = 48
        Height = 19
        EditMask = '!90:00:00>;1; '
        MaxLength = 8
        TabOrder = 0
        Text = '08:00:00'
        OnExit = edtDiasPrazoAExit
        OnKeyDown = edtPercListaAKeyDown
      end
      object MaskEdit8: TMaskEdit
        Left = 165
        Top = 60
        Width = 49
        Height = 19
        EditMask = '!90:00:00>;1; '
        MaxLength = 8
        TabOrder = 1
        Text = '18:00:00'
        OnExit = edtDiasPrazoAExit
        OnKeyDown = edtPercListaAKeyDown
      end
    end
    object Orelha_perfil: TTabSheet
      Caption = 'Perfil de cores'
      Enabled = False
      ImageIndex = 8
      object Image7: TImage
        Left = 10
        Top = 10
        Width = 200
        Height = 150
        Stretch = True
        OnClick = Image7Click
      end
      object Image9: TImage
        Left = 230
        Top = 12
        Width = 100
        Height = 75
        Visible = False
      end
    end
    object Orelha_email: TTabSheet
      Caption = 'e-mail'
      ImageIndex = 9
      object Label1: TLabel
        Left = 15
        Top = 30
        Width = 259
        Height = 13
        Alignment = taRightJustify
        Caption = 'Servidor de sa'#237'da de e-mails  (smtp.seudominio.com.br)'
      end
      object Label3: TLabel
        Left = 44
        Top = 60
        Width = 230
        Height = 13
        Alignment = taRightJustify
        Caption = 'Login do usu'#225'rio: (seuemail@seudominio.com.br)'
      end
      object Label10: TLabel
        Left = 225
        Top = 90
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Porta: (25)'
      end
      object Label24: TLabel
        Left = 95
        Top = 122
        Width = 179
        Height = 13
        Alignment = taRightJustify
        Caption = 'e-mail: (seuemail@seudominio.com.br)'
      end
      object Label25: TLabel
        Left = 208
        Top = 154
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nome: (nome)'
      end
      object Label15: TLabel
        Left = 240
        Top = 186
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Senha:'
      end
      object Edit1: TEdit
        Left = 280
        Top = 30
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnKeyDown = Edit1KeyDown
      end
      object Edit2: TEdit
        Left = 280
        Top = 60
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        OnKeyDown = Edit1KeyDown
      end
      object Edit3: TEdit
        Left = 280
        Top = 90
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        OnKeyDown = Edit1KeyDown
      end
      object Edit4: TEdit
        Left = 280
        Top = 122
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        OnKeyDown = Edit1KeyDown
      end
      object Edit5: TEdit
        Left = 280
        Top = 154
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        OnKeyDown = Edit1KeyDown
      end
      object Edit6: TEdit
        Left = 280
        Top = 186
        Width = 185
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        PasswordChar = '*'
        TabOrder = 5
        OnKeyDown = Edit1KeyDown
      end
      object CheckBox3: TCheckBox
        Left = 15
        Top = 224
        Width = 278
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Este servidor requer uma conex'#227'o criptografada (SSL):'
        TabOrder = 6
      end
    end
    object tbsDashboard: TTabSheet
      Caption = 'Dashboard'
      ImageIndex = 11
      DesignSize = (
        576
        330)
      object imgCheck: TImage
        Left = 446
        Top = 3
        Width = 20
        Height = 18
        AutoSize = True
        Picture.Data = {
          07544269746D61706E040000424D6E0400000000000036000000280000001400
          0000120000000100180000000000380400000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D81521D81
          521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFFFFFFFFFF
          81521DEFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFD
          FDFEFEFEFFFFFFFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DED
          F0F0EFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD
          FEFEFEFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DEBEEEEEDF0
          F0EFF2F2F1F3F3F3F5F522A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFDFE
          FEFEFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE8ECECEBEEEEEDF0F0
          EFF2F222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFDFEFE
          FE81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE6EAEAE8ECECEBEEEE22A12222
          A12222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD81521D
          FFFFFFFFFFFFFFFFFFFFFFFF81521DE4E8E8E6EAEA22A12222A12222A12222A1
          2222A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFBFCFDFD81521DFFFFFFFF
          FFFFFFFFFFFFFFFF81521DE2E6E6E4E8E822A12222A12222A122EDF0F022A122
          22A12222A12222A122F6F8F8F8F9F9F9FAFAFBFBFB81521DFFFFFFFFFFFFFFFF
          FFFFFFFF81521DE0E4E4E2E6E622A12222A122E8ECECEBEEEEEDF0F022A12222
          A12222A12222A122F6F8F8F8F9F9F9FAFA81521DFFFFFFFFFFFFFFFFFFFFFFFF
          81521DDEE3E3E0E4E422A122E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A1
          2222A12222A122F6F8F8F8F9F981521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDD
          E2E2DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A122
          22A122F5F6F6F6F8F881521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2
          E2DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A12222A122F3
          F5F5F5F6F681521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2
          DEE3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F022A122F1F3F3F3F5
          F581521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DE
          E3E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F2F1F3F381521D
          FFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DDE2E2DEE3
          E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F281521DFFFFFFFF
          FFFFFFFFFFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D
          81521D81521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Visible = False
      end
      object imgUnCheck: TImage
        Left = 482
        Top = 3
        Width = 20
        Height = 18
        AutoSize = True
        Picture.Data = {
          07544269746D61706E040000424D6E0400000000000036000000280000001400
          0000120000000100180000000000380400000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D81521D81
          521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFFFFFFFFFF
          81521DEFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFD
          FDFEFEFEFFFFFFFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DED
          F0F0EFF2F2F1F3F3F3F5F5F5F6F6F6F8F8F8F9F9F9FAFAFBFBFBFCFDFDFDFDFD
          FEFEFEFFFFFFFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DEBEEEEEFF1
          F1F1F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFFFFFFFFFFFFFE
          FEFEFFFFFF81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE8ECECECEFEFEFF1F1
          F1F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFFFFFFFDFDFDFEFE
          FE81521DFFFFFFFFFFFFFFFFFFFFFFFF81521DE6EAEAE9ECECECEFEFEFF1F1F1
          F3F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFFFFFFFCFDFDFDFDFD81521D
          FFFFFFFFFFFFFFFFFFFFFFFF81521DE4E8E8E5E8E8E9ECECECEFEFEFF1F1F1F3
          F3F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDFEFEFEFBFBFBFCFDFD81521DFFFFFFFF
          FFFFFFFFFFFFFFFF81521DE2E6E6E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3
          F4F5F5F6F7F7F8F9F9FAFBFBFCFDFDF9FAFAFBFBFB81521DFFFFFFFFFFFFFFFF
          FFFFFFFF81521DE0E4E4DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4
          F5F5F6F7F7F8F9F9FAFBFBF8F9F9F9FAFA81521DFFFFFFFFFFFFFFFFFFFFFFFF
          81521DDEE3E3DBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5
          F5F6F7F7F8F9F9F6F8F8F8F9F981521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDD
          E2E2D9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5F5
          F6F7F7F5F6F6F6F8F881521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DC
          DCD9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F4F5F5F3
          F5F5F5F6F681521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DCDCD7DCDC
          D9DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1F1F3F3F1F3F3F3F5
          F581521DFFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2D7DCDCD7DCDCD7DCDCD9
          DEDEDBE0E0DEE2E2E2E5E5E5E8E8E9ECECECEFEFEFF1F1EFF2F2F1F3F381521D
          FFFFFFFFFFFFFFFFFFFFFFFF81521DDDE2E2DDE2E2DDE2E2DDE2E2DDE2E2DEE3
          E3E0E4E4E2E6E6E4E8E8E6EAEAE8ECECEBEEEEEDF0F0EFF2F281521DFFFFFFFF
          FFFFFFFFFFFFFFFF81521D81521D81521D81521D81521D81521D81521D81521D
          81521D81521D81521D81521D81521D81521D81521D81521DFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Visible = False
      end
      object Label27: TLabel
        Left = 18
        Top = 42
        Width = 180
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opera'#231#245'es consideradas como venda'
      end
      object chkDashboardAbertura: TCheckBox
        Left = 17
        Top = 15
        Width = 218
        Height = 17
        Caption = 'Exibir dashboard na abertura do sistema'
        TabOrder = 0
      end
      object dbgPrincipal: TDBGrid
        Left = 18
        Top = 61
        Width = 540
        Height = 215
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Ctl3D = False
        DataSource = DSNaturezaDash
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgTabs]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Pitch = fpFixed
        TitleFont.Style = []
        OnCellClick = dbgPrincipalCellClick
        OnDrawColumnCell = dbgPrincipalDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'MARCADO'
            ReadOnly = True
            Width = 21
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            ReadOnly = True
            Width = 431
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CFOP'
            ReadOnly = True
            Width = 67
            Visible = True
          end>
      end
      object btnMarcarTodosOper: TBitBtn
        Left = 16
        Top = 291
        Width = 100
        Height = 25
        Caption = 'Marcar todas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnMarcarTodosOperClick
      end
      object btnDesmarcarTodosOper: TBitBtn
        Left = 120
        Top = 291
        Width = 100
        Height = 25
        Caption = 'Desmarcar todas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnDesmarcarTodosOperClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 20
    Width = 20
    Height = 358
    Align = alLeft
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Button2: TButton
      Left = 350
      Top = 5
      Width = 100
      Height = 25
      Caption = '&Ok'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel4: TPanel
    Left = 604
    Top = 20
    Width = 20
    Height = 358
    Align = alRight
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Button6: TButton
      Left = 350
      Top = 5
      Width = 100
      Height = 25
      Caption = '&Ok'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 378
    Width = 624
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    object btnCancelar: TButton
      Left = 400
      Top = 19
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelarClick
      OnKeyDown = btnOKKeyDown
    end
    object btnOK: TButton
      Left = 506
      Top = 19
      Width = 100
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnOKClick
      OnKeyDown = btnOKKeyDown
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
  end
  object ColorDialog1: TColorDialog
    Color = clGreen
    CustomColors.Strings = (
      'c0c0c0c0')
    Options = [cdFullOpen, cdPreventFullOpen, cdSolidColor]
    Left = 368
    Top = 160
  end
  object OpenDialog4: TOpenDialog
    InitialDir = 'c:\'
    Left = 440
    Top = 160
  end
  object OpenDialog3: TOpenDialog
    InitialDir = 'c:\'
    Left = 512
    Top = 160
  end
  object DSNaturezaDash: TDataSource
    DataSet = cdsNaturezaDash
    Left = 120
    Top = 152
  end
  object cdsNaturezaDash: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspProdutosNota'
    Left = 208
    Top = 152
    object cdsNaturezaDashMARCADO: TWideStringField
      DisplayLabel = ' '
      FieldName = 'MARCADO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object cdsNaturezaDashDESCRICAO: TWideStringField
      DisplayLabel = 'Natureza da opera'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 45
    end
    object cdsNaturezaDashCFOP: TStringField
      FieldName = 'CFOP'
      Size = 5
    end
    object cdsNaturezaDashINTEGRACAO: TStringField
      FieldName = 'INTEGRACAO'
      Size = 8
    end
  end
end
