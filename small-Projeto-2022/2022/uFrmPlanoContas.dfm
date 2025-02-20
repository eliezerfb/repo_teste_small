inherited FrmPlanoContas: TFrmPlanoContas
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
    end
    inherited Panel1: TPanel
      ExplicitHeight = 453
    end
    inherited Panel8: TPanel
      ExplicitLeft = 822
      ExplicitHeight = 453
    end
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      ExplicitWidth = 802
      ExplicitHeight = 453
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object LabelNroConta: TLabel
          Left = 11
          Top = 41
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'N'#250'mero da conta:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 11
          Top = 67
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nome da Conta:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 11
          Top = 93
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Dia:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 11
          Top = 119
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'M'#234's:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 11
          Top = 146
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ano:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 11
          Top = 172
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Saldo:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 11
          Top = 198
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Descri'#231#227'o Cont'#225'bil:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 11
          Top = 224
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo Cont'#225'bil:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 11
          Top = 251
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Identificador:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelTipoConta: TLabel
          Left = 11
          Top = 16
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Tipo da conta:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtNroConta: TSMALL_DBEdit
          Left = 112
          Top = 37
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CONTA'
          DataSource = DSCadastro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          OnEnter = edtNroContaEnter
          OnKeyDown = PadraoKeyDown
          OnKeyPress = edtNroContaKeyPress
          OnKeyUp = edtNroContaKeyUp
        end
        object edtNomeConta: TSMALL_DBEdit
          Left = 112
          Top = 63
          Width = 350
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
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
          TabOrder = 2
          OnKeyDown = PadraoKeyDown
        end
        object edtDia: TSMALL_DBEdit
          Left = 112
          Top = 89
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'DIA'
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
        object edtMes: TSMALL_DBEdit
          Left = 112
          Top = 115
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'MES'
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
        object edtAno: TSMALL_DBEdit
          Left = 112
          Top = 142
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'ANO'
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
        object edtSaldo: TSMALL_DBEdit
          Left = 112
          Top = 168
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'SALDO'
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
        object edtDescContabil: TSMALL_DBEdit
          Left = 112
          Top = 194
          Width = 350
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'DESCRICAOCONTABIL'
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
        object edtCodContabil: TSMALL_DBEdit
          Left = 112
          Top = 220
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CONTACONTABILIDADE'
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
        object edtIdentificador: TSMALL_DBEdit
          Left = 112
          Top = 247
          Width = 150
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'IDENTIFICADOR'
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
        object cbxTipoConta: TComboBox
          Left = 112
          Top = 11
          Width = 150
          Height = 22
          Style = csOwnerDrawFixed
          TabOrder = 0
          OnClick = cbxTipoContaClick
          OnKeyDown = cbxTipoContaKeyDown
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet12
    OnDataChange = DSCadastroDataChange
  end
end
