inherited FrmContaBancaria: TFrmContaBancaria
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pgcFicha: TPageControl
      ActivePage = tbsCadastro
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object Label129: TLabel
          Left = 10
          Top = 26
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nome:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 10
          Top = 52
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ag'#234'ncia:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 10
          Top = 78
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Conta Corrente:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 10
          Top = 104
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Plano de Contas:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 10
          Top = 130
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Saldo do Banco:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 10
          Top = 156
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Institui'#231#227'o Fina.:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtNome: TSMALL_DBEdit
          Left = 110
          Top = 25
          Width = 313
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
          TabOrder = 0
          OnKeyDown = PadraoKeyDown
        end
        object edtAgencia: TSMALL_DBEdit
          Left = 110
          Top = 51
          Width = 130
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'AGENCIA'
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
        object edtContaCorrente: TSMALL_DBEdit
          Left = 111
          Top = 77
          Width = 130
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
          TabOrder = 2
          OnKeyDown = PadraoKeyDown
        end
        object edtSaldo: TSMALL_DBEdit
          Left = 110
          Top = 129
          Width = 130
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'SALDO1'
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
        inline fraPlanoContas: TfFrameCampo
          Left = 110
          Top = 103
          Width = 313
          Height = 22
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 3
          ExplicitLeft = 110
          ExplicitTop = 103
          ExplicitWidth = 313
          ExplicitHeight = 22
          inherited txtCampo: TEdit
            Width = 313
            ExplicitWidth = 313
          end
          inherited gdRegistros: TDBGrid
            Width = 313
            Columns = <
              item
                Expanded = False
                FieldName = 'CONTA'
                Width = 45
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 240
                Visible = True
              end>
          end
        end
        inline fraInstituicao: TfFrameCampo
          Left = 110
          Top = 155
          Width = 313
          Height = 22
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 5
          ExplicitLeft = 110
          ExplicitTop = 155
          ExplicitWidth = 313
          ExplicitHeight = 22
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
                Width = 240
                Visible = True
              end>
          end
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet11
    OnDataChange = DSCadastroDataChange
  end
end
