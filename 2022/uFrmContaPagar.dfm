inherited FrmContaPagar: TFrmContaPagar
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    inherited pnlBotoesPosterior: TPanel
      object btnReplicar: TBitBtn
        Left = 10
        Top = 8
        Width = 120
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Replicar'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnReplicarClick
      end
    end
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
          Caption = 'Documento:'
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
          Caption = 'Plano de Contas:'
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
          Caption = 'Hist'#243'rico:'
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
          Caption = 'Fornecedor:'
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
          Caption = 'Emiss'#227'o:'
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
          Caption = 'Vencimento:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 10
          Top = 182
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valor:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 10
          Top = 208
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pago:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 10
          Top = 234
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valor Pago:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 10
          Top = 260
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Portador:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 10
          Top = 286
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'NF/S'#233'rie:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtDocumento: TSMALL_DBEdit
          Left = 110
          Top = 25
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'DOCUMENTO'
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
        object edtHistorico: TSMALL_DBEdit
          Left = 110
          Top = 77
          Width = 313
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'HISTORICO'
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
        object edtEmissao: TSMALL_DBEdit
          Left = 110
          Top = 129
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'EMISSAO'
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
        object edtVencimento: TSMALL_DBEdit
          Left = 110
          Top = 155
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'VENCIMENTO'
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
        object edtValor: TSMALL_DBEdit
          Left = 110
          Top = 181
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'VALOR_DUPL'
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
        object edtPago: TSMALL_DBEdit
          Left = 110
          Top = 207
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PAGAMENTO'
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
        object edtValorPago: TSMALL_DBEdit
          Left = 110
          Top = 233
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'VALOR_PAGO'
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
        object edtPortador: TSMALL_DBEdit
          Left = 110
          Top = 259
          Width = 313
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'PORTADOR'
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
        object edtNotaFiscal: TSMALL_DBEdit
          Left = 110
          Top = 285
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'NUMERONF'
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
        inline fraPlanoContas: TfFrameCampo
          Left = 110
          Top = 51
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 1
          ExplicitLeft = 110
          ExplicitTop = 51
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
        inline fraFornecedor: TfFrameCampo
          Left = 110
          Top = 103
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 3
          ExplicitLeft = 110
          ExplicitTop = 103
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
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet8
    OnDataChange = DSCadastroDataChange
  end
end
