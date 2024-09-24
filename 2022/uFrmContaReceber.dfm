inherited FrmContaReceber: TFrmContaReceber
  ClientWidth = 929
  Constraints.MaxWidth = 945
  Constraints.MinWidth = 945
  OnActivate = FormActivate
  OnClose = FormClose
  ExplicitWidth = 945
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel_branco: TPanel
    Width = 929
    ExplicitWidth = 929
    inherited pnlBotoesSuperior: TPanel
      Width = 929
      ExplicitWidth = 929
    end
    inherited pnlBotoesPosterior: TPanel
      Width = 929
      ExplicitWidth = 929
      inherited btnOK: TBitBtn
        Left = 810
        ExplicitLeft = 810
      end
      object btnRecibo: TBitBtn
        Left = 19
        Top = 16
        Width = 100
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Recibo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnReciboClick
      end
      object btnReplicar: TBitBtn
        Left = 123
        Top = 16
        Width = 100
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Replicar'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnReplicarClick
      end
    end
    inherited Panel1: TPanel
      ExplicitHeight = 453
    end
    inherited Panel8: TPanel
      Left = 909
      ExplicitLeft = 909
      ExplicitHeight = 453
    end
    inherited pgcFicha: TPageControl
      Width = 889
      ActivePage = tbsCadastro
      ExplicitWidth = 889
      ExplicitHeight = 453
      object tbsCadastro: TTabSheet
        Caption = 'Cadastro'
        object Label1: TLabel
          Left = 10
          Top = 46
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
        object Label129: TLabel
          Left = 10
          Top = 20
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
        object Label2: TLabel
          Left = 10
          Top = 72
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
          Top = 98
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cliente:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 10
          Top = 124
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
          Top = 150
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
          Top = 176
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Movimento:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 10
          Top = 202
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Data da quita'#231#227'o:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 10
          Top = 228
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
        object Label9: TLabel
          Left = 10
          Top = 306
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
          Top = 384
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
        object Label11: TLabel
          Left = 10
          Top = 254
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valor quitado:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label12: TLabel
          Left = 10
          Top = 280
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valor atual:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label13: TLabel
          Left = 10
          Top = 332
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo de barras:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 10
          Top = 358
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nosso n'#250'mero:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label15: TLabel
          Left = 464
          Top = 20
          Width = 104
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Institui'#231#227'o financeira:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 464
          Top = 46
          Width = 104
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Forma de pagamento:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label17: TLabel
          Left = 473
          Top = 72
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Autoriza'#231#227'o:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 473
          Top = 98
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bandeira:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 473
          Top = 124
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contato:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 473
          Top = 150
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telefone:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label21: TLabel
          Left = 473
          Top = 176
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Celular:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label22: TLabel
          Left = 473
          Top = 202
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Email:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 473
          Top = 228
          Width = 95
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contatos:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        inline fraPlanoContas: TfFrameCampo
          Left = 110
          Top = 45
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 1
          ExplicitLeft = 110
          ExplicitTop = 45
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
        object edtDocumento: TSMALL_DBEdit
          Left = 110
          Top = 19
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
          Top = 71
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
          Top = 123
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
          Top = 149
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
        object edtMovimento: TSMALL_DBEdit
          Left = 110
          Top = 175
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'MOVIMENTO'
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
        object edtDtQuitacao: TSMALL_DBEdit
          Left = 110
          Top = 201
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'RECEBIMENT'
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
        object edtValor: TSMALL_DBEdit
          Left = 110
          Top = 227
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
          TabOrder = 8
          OnKeyDown = PadraoKeyDown
        end
        object edtPortador: TSMALL_DBEdit
          Left = 110
          Top = 305
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
          TabOrder = 11
          OnKeyDown = PadraoKeyDown
        end
        object edtNotaFiscal: TSMALL_DBEdit
          Left = 110
          Top = 383
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
          TabOrder = 14
          OnKeyDown = PadraoKeyDown
        end
        inline fraCliente: TfFrameCampo
          Left = 110
          Top = 97
          Width = 313
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 3
          OnExit = fraClienteExit
          ExplicitLeft = 110
          ExplicitTop = 97
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
        object edtValorQuitado: TSMALL_DBEdit
          Left = 110
          Top = 253
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'VALOR_RECE'
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
        object edtValorAtual: TSMALL_DBEdit
          Left = 110
          Top = 279
          Width = 94
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'VALOR_JURO'
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
        object edtCodBarra: TSMALL_DBEdit
          Left = 110
          Top = 331
          Width = 313
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CODEBAR'
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
        object edtNossoNum: TSMALL_DBEdit
          Left = 110
          Top = 357
          Width = 313
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'NOSSONUM'
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
        inline fraInstituicao: TfFrameCampo
          Left = 574
          Top = 19
          Width = 288
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 15
          ExplicitLeft = 574
          ExplicitTop = 19
          ExplicitWidth = 288
          inherited txtCampo: TEdit
            Width = 288
            ExplicitWidth = 288
          end
          inherited gdRegistros: TDBGrid
            Width = 288
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 290
                Visible = True
              end>
          end
        end
        inline fraFormaPag: TfFrameCampo
          Left = 574
          Top = 45
          Width = 288
          Height = 20
          Color = clWhite
          Ctl3D = False
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 16
          ExplicitLeft = 574
          ExplicitTop = 45
          ExplicitWidth = 288
          inherited txtCampo: TEdit
            Width = 288
            ExplicitWidth = 288
          end
          inherited gdRegistros: TDBGrid
            Width = 288
            Columns = <
              item
                Expanded = False
                FieldName = 'NOME'
                Width = 290
                Visible = True
              end>
          end
        end
        object edtAutorizacao: TSMALL_DBEdit
          Left = 574
          Top = 71
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'AUTORIZACAOTRANSACAO'
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
        object edtBandeira: TSMALL_DBEdit
          Left = 574
          Top = 97
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'BANDEIRA'
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
        object edtContato: TSMALL_DBEdit
          Left = 574
          Top = 123
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CONTATO'
          DataSource = DSCliente
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
        object edtTelefone: TSMALL_DBEdit
          Left = 574
          Top = 149
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'FONE'
          DataSource = DSCliente
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
        object edtCelular: TSMALL_DBEdit
          Left = 574
          Top = 175
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'CELULAR'
          DataSource = DSCliente
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
        object edtEmail: TSMALL_DBEdit
          Left = 574
          Top = 201
          Width = 288
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          DataField = 'EMAIL'
          DataSource = DSCliente
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
        object memContatos: TDBMemo
          Left = 574
          Top = 227
          Width = 288
          Height = 176
          DataField = 'CONTATOS'
          DataSource = DSCliente
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          MaxLength = 32768
          ParentFont = False
          TabOrder = 23
          OnEnter = memContatosEnter
          OnExit = memContatosExit
          OnKeyDown = memContatosKeyDown
        end
      end
    end
  end
  inherited DSCadastro: TDataSource
    DataSet = Form7.ibDataSet7
    OnDataChange = DSCadastroDataChange
  end
  object DSCliente: TDataSource
    DataSet = Form7.IBDataSet2
    Left = 673
    Top = 65
  end
end
