inherited FrmConversaoCFOP: TFrmConversaoCFOP
  Caption = 'Convers'#227'o de CFOP'
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      ExplicitLeft = 10
      ExplicitTop = 105
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object Label129: TLabel
          Left = 10
          Top = 26
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CFOP Origem'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 10
          Top = 123
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CFOP Convers'#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCST: TLabel
          Left = 9
          Top = 71
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CST'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCSOSN: TLabel
          Left = 10
          Top = 96
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CSOSN'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtCFOPOrigem: TSMALL_DBEdit
          Left = 110
          Top = 25
          Width = 75
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CFOP_ORIGEM'
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
          OnKeyPress = edtCFOPOrigemKeyPress
        end
        object edtCFOPConversao: TSMALL_DBEdit
          Left = 111
          Top = 123
          Width = 75
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CFOP_CONVERSAO'
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
          OnKeyPress = edtCFOPConversaoKeyPress
        end
        object chkConsiderar: TDBCheckBox
          Left = 110
          Top = 48
          Width = 147
          Height = 17
          Alignment = taLeftJustify
          BiDiMode = bdRightToLeft
          Caption = 'Considerar CST/CSOSN'
          DataField = 'CONSIDERACSTCSOSN'
          DataSource = DSCadastro
          ParentBiDiMode = False
          TabOrder = 1
          ValueChecked = 'S'
          ValueUnchecked = 'N'
          OnClick = chkConsiderarClick
          OnKeyDown = PadraoKeyDown
        end
        object cboCST: TComboBox
          Left = 110
          Top = 68
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Enabled = False
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
            '20 - Com redu'#231#227'o de base de c'#225'lculo'
            '40 - Isenta'
            '41 - N'#227'o tributada'
            '60 - ICMS Cobrado anteriormente por ST'
            
              '61 - Tributa'#231#227'o monof'#225'sica sobre combust'#237'veis cobrado anteriorme' +
              'nte'
            '90 - Outras')
        end
        object cboCSOSN: TComboBox
          Left = 110
          Top = 95
          Width = 390
          Height = 22
          Style = csOwnerDrawVariable
          Enabled = False
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
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibdConversaoCFOP
    OnDataChange = DSCadastroDataChange
  end
end
