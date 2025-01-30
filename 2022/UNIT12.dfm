object Form12: TForm12
  Left = 387
  Top = 84
  HorzScrollBar.Color = clRed
  HorzScrollBar.Margin = 10
  HorzScrollBar.ParentColor = False
  VertScrollBar.Color = clRed
  VertScrollBar.Increment = 20
  VertScrollBar.Margin = 10
  VertScrollBar.ParentColor = False
  VertScrollBar.Tracking = True
  AlphaBlendValue = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'NOTA FISCAL VENDA (SA'#205'DA)'
  ClientHeight = 914
  ClientWidth = 1024
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label44: TLabel
    Left = 0
    Top = 768
    Width = 4
    Height = 16
    Caption = ' '
  end
  object Label55: TLabel
    Left = 16
    Top = 662
    Width = 4
    Height = 16
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1024
    Height = 914
    Align = alClient
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 15122040
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 7
      Width = 662
      Height = 825
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Label64: TLabel
        Left = 394
        Top = 18
        Width = 39
        Height = 13
        Caption = 'Mod: 55'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = Label64Click
      end
      object Label4: TLabel
        Left = 356
        Top = 87
        Width = 28
        Height = 13
        Caption = 'CFOP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label8: TLabel
        Left = 7
        Top = 128
        Width = 163
        Height = 13
        Caption = 'Raz'#227'o social do cliente / ou CNPJ'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label11: TLabel
        Left = 407
        Top = 128
        Width = 76
        Height = 13
        Caption = 'CNPJ do cliente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label12: TLabel
        Left = 561
        Top = 44
        Width = 39
        Height = 13
        Caption = 'Emiss'#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label13: TLabel
        Left = 561
        Top = 87
        Width = 68
        Height = 13
        Caption = 'Data da sa'#237'da'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label14: TLabel
        Left = 561
        Top = 128
        Width = 68
        Height = 13
        Caption = 'Hora da sa'#237'da'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label29: TLabel
        Left = 528
        Top = 435
        Width = 88
        Height = 13
        Caption = 'Total dos produtos'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label30: TLabel
        Left = 528
        Top = 475
        Width = 86
        Height = 13
        Caption = 'Total dos servi'#231'os'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label23: TLabel
        Left = 10
        Top = 435
        Width = 53
        Height = 13
        Caption = 'Base ICMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label31: TLabel
        Left = 120
        Top = 435
        Width = 68
        Height = 13
        Caption = 'Valor do ICMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label32: TLabel
        Left = 220
        Top = 435
        Width = 83
        Height = 13
        Caption = 'Base substitui'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label33: TLabel
        Left = 320
        Top = 435
        Width = 87
        Height = 13
        Caption = 'ICMS Substitui'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label1: TLabel
        Left = 528
        Top = 515
        Width = 59
        Height = 13
        Caption = 'Valor do ISS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label34: TLabel
        Left = 128
        Top = 555
        Width = 24
        Height = 13
        Caption = 'Frete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label35: TLabel
        Left = 228
        Top = 555
        Width = 34
        Height = 13
        Caption = 'Seguro'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label36: TLabel
        Left = 328
        Top = 555
        Width = 81
        Height = 13
        Caption = 'Outras Despesas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label37: TLabel
        Left = 428
        Top = 555
        Width = 78
        Height = 13
        Caption = 'Valor total do IPI'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label38: TLabel
        Left = 528
        Top = 555
        Width = 63
        Height = 13
        Caption = 'Total da nota'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label39: TLabel
        Left = 10
        Top = 595
        Width = 72
        Height = 13
        Caption = 'Transportadora'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label40: TLabel
        Left = 315
        Top = 595
        Width = 72
        Height = 13
        Caption = 'Frete por conta'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label41: TLabel
        Left = 414
        Top = 595
        Width = 27
        Height = 13
        Caption = 'Placa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label42: TLabel
        Left = 494
        Top = 595
        Width = 14
        Height = 13
        Caption = 'UF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label43: TLabel
        Left = 522
        Top = 595
        Width = 58
        Height = 13
        Caption = 'CNPJ / CPF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label45: TLabel
        Left = 10
        Top = 635
        Width = 46
        Height = 13
        Caption = 'Endere'#231'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label46: TLabel
        Left = 315
        Top = 635
        Width = 47
        Height = 13
        Caption = 'Munic'#237'pio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label47: TLabel
        Left = 494
        Top = 635
        Width = 14
        Height = 13
        Caption = 'UF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label48: TLabel
        Left = 522
        Top = 635
        Width = 10
        Height = 13
        Caption = 'IE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label49: TLabel
        Left = 10
        Top = 675
        Width = 63
        Height = 13
        Caption = 'Qtd. Volumes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label50: TLabel
        Left = 95
        Top = 675
        Width = 38
        Height = 13
        Caption = 'Esp'#233'cie'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label51: TLabel
        Left = 200
        Top = 675
        Width = 30
        Height = 13
        Caption = 'Marca'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label52: TLabel
        Left = 340
        Top = 675
        Width = 87
        Height = 13
        Caption = 'N'#250'm. dos volumes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label53: TLabel
        Left = 445
        Top = 675
        Width = 54
        Height = 13
        Caption = 'Peso bruto '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label54: TLabel
        Left = 550
        Top = 675
        Width = 59
        Height = 13
        Caption = 'Peso l'#237'quido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label5: TLabel
        Left = 10
        Top = 715
        Width = 138
        Height = 13
        Caption = 'Informa'#231#245'es complementares'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label9: TLabel
        Left = 407
        Top = 87
        Width = 106
        Height = 13
        Caption = 'Vendedor                    '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = False
      end
      object Label71: TLabel
        Left = 525
        Top = 12
        Width = 60
        Height = 24
        Caption = '000000'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object imgLogoNFe: TImage
        Left = 10
        Top = 5
        Width = 104
        Height = 76
        Center = True
        Proportional = True
        OnClick = imgLogoNFeClick
      end
      object Label6: TLabel
        Left = 10
        Top = 475
        Width = 110
        Height = 13
        Caption = 'Descri'#231#227'o dos servi'#231'os'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label57: TLabel
        Left = 278
        Top = 475
        Width = 20
        Height = 13
        Caption = 'Qtd.'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label59: TLabel
        Left = 409
        Top = 475
        Width = 24
        Height = 13
        Caption = 'Total'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label69: TLabel
        Left = 420
        Top = 435
        Width = 46
        Height = 13
        Caption = 'Desconto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label28: TLabel
        Left = 10
        Top = 555
        Width = 67
        Height = 13
        Caption = 'Identificador 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = Label28Click
        OnMouseMove = Label28MouseMove
        OnMouseLeave = Label28MouseLeave
      end
      object Label62: TLabel
        Left = 332
        Top = 475
        Width = 36
        Height = 13
        Caption = 'Unit'#225'rio'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label10: TLabel
        Left = 450
        Top = 18
        Width = 69
        Height = 13
        Caption = 'N'#250'mero/S'#233'rie:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = Label64Click
      end
      object Label25: TLabel
        Left = 122
        Top = 44
        Width = 86
        Height = 13
        Caption = 'Finalidade da Nf-e'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label24: TLabel
        Left = 308
        Top = 44
        Width = 55
        Height = 13
        Caption = 'Consumidor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label56: TLabel
        Left = 426
        Top = 44
        Width = 106
        Height = 13
        Caption = 'Indicador de presen'#231'a'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 7
        Top = 87
        Width = 106
        Height = 13
        Caption = 'Natureza da opera'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblHomologacao: TLabel
        Left = 122
        Top = 21
        Width = 202
        Height = 15
        Caption = 'Homologa'#231#227'o - sem valor fiscal'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object LabelNFVendaTitulo: TLabel
        Left = 120
        Top = -1
        Width = 139
        Height = 24
        Caption = 'NF DE VENDA'
        Color = clSilver
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -19
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
      end
      object PageControlAddressMktp: TPageControl
        Left = 7
        Top = 170
        Width = 640
        Height = 118
        ActivePage = tbsLocalEntrega
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Roboto'
        Font.Style = []
        ParentFont = False
        TabOrder = 47
        OnDrawTab = PageControlAddressMktpDrawTab
        object TabSheetEnderecoCliente: TTabSheet
          Caption = '  Endere'#231'o do cliente'
          object PanelEnderecoCliente: TPanel
            Left = 0
            Top = 0
            Width = 632
            Height = 89
            Align = alClient
            Color = clMoneyGreen
            ParentBackground = False
            TabOrder = 0
            object LabelEnderecoCliente: TLabel
              Left = 5
              Top = 0
              Width = 95
              Height = 13
              Caption = 'Endere'#231'o do cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label16: TLabel
              Left = 422
              Top = 0
              Width = 76
              Height = 13
              Caption = 'Bairro do cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label17: TLabel
              Left = 555
              Top = 0
              Width = 21
              Height = 13
              Caption = 'CEP'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label18: TLabel
              Left = 5
              Top = 40
              Width = 96
              Height = 13
              Caption = 'Munic'#237'pio do cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label20: TLabel
              Left = 344
              Top = 40
              Width = 14
              Height = 13
              Caption = 'UF'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label19: TLabel
              Left = 377
              Top = 40
              Width = 91
              Height = 13
              Caption = 'Telefone do cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label21: TLabel
              Left = 498
              Top = 40
              Width = 59
              Height = 13
              Caption = 'IE do cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object SMALL_DBEditRua: TSMALL_DBEdit
              Left = 5
              Top = 15
              Width = 412
              Height = 22
              Color = clWhite
              DataField = 'ENDERE'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object SMALL_DBEditBairro: TSMALL_DBEdit
              Left = 422
              Top = 15
              Width = 130
              Height = 22
              Color = clWhite
              DataField = 'COMPLE'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object SMALL_DBEditCEP: TSMALL_DBEdit
              Left = 555
              Top = 15
              Width = 75
              Height = 22
              Color = clWhite
              DataField = 'CEP'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object SMALL_DBEditMunicipio: TSMALL_DBEdit
              Left = 5
              Top = 55
              Width = 333
              Height = 22
              Color = clWhite
              DataField = 'CIDADE'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
            end
            object SMALL_DBEditUF: TSMALL_DBEdit
              Left = 344
              Top = 55
              Width = 27
              Height = 22
              Color = clWhite
              DataField = 'ESTADO'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
            end
            object SMALL_DBEditTelefone: TSMALL_DBEdit
              Left = 377
              Top = 55
              Width = 115
              Height = 22
              Color = clWhite
              DataField = 'FONE'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
            end
            object SMALL_DBEditIE: TSMALL_DBEdit
              Left = 498
              Top = 55
              Width = 135
              Height = 22
              Color = clWhite
              DataField = 'IE'
              DataSource = Form7.DataSource2
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
            end
          end
        end
        object tbsLocalEntrega: TTabSheet
          Caption = '  Local de entrega'
          ImageIndex = 1
          OnShow = tbsLocalEntregaShow
          object PanelRecebedor: TPanel
            Left = 0
            Top = 0
            Width = 632
            Height = 89
            Align = alClient
            Color = clMoneyGreen
            ParentBackground = False
            TabOrder = 0
            ExplicitWidth = 635
            object LabelRecebedor: TLabel
              Left = 5
              Top = 0
              Width = 53
              Height = 13
              Caption = 'Recebedor'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object LabelEnderecoRecebedor: TLabel
              Left = 5
              Top = 40
              Width = 97
              Height = 13
              Caption = 'Endere'#231'o recebedor'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object DBLookupComboBoxEnderReceb: TDBLookupComboBox
              Left = 5
              Top = 55
              Width = 620
              Height = 22
              DataField = 'IDLOCALENTREGA'
              DataSource = Form7.DataSource15
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              KeyField = 'IDENDERECO'
              ListField = 'FULL_ADDRESS'
              ListSource = dsAddress
              ParentFont = False
              TabOrder = 1
              OnKeyDown = DBLookupComboBoxEnderRecebKeyDown
            end
            object EditRecebedorNome: TEdit
              Left = 5
              Top = 15
              Width = 620
              Height = 20
              TabOrder = 0
              Text = 'EditRecebedorNome'
              OnEnter = EditRecebedorNomeEnter
              OnKeyDown = EditRecebedorNomeKeyDown
              OnKeyUp = EditRecebedorNomeKeyUp
            end
          end
        end
        object TabSheetMktplace: TTabSheet
          Caption = '  Marktplace'
          ImageIndex = 2
          object PanelMtplace: TPanel
            Left = 0
            Top = 0
            Width = 632
            Height = 89
            Align = alClient
            Color = clMoneyGreen
            ParentBackground = False
            TabOrder = 0
            object LabelMktplace: TLabel
              Left = 5
              Top = 0
              Width = 59
              Height = 13
              Caption = 'Marketplace'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -11
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object ComboBoxMarktplace: TComboBox
              Left = 5
              Top = 15
              Width = 620
              Height = 24
              AutoDropDown = True
              BevelInner = bvNone
              BevelOuter = bvNone
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Microsoft Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnExit = ComboBoxMarktplaceExit
              OnKeyDown = FormKeyUp
            end
          end
        end
      end
      object SMALL_DBEdit43: TSMALL_DBEdit
        Left = 407
        Top = 102
        Width = 149
        Height = 22
        Color = clWhite
        DataField = 'VENDEDOR'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = SMALL_DBEdit43Change
        OnClick = SMALL_DBEdit43Click
        OnEnter = SMALL_DBEdit43Enter
        OnExit = SMALL_DBEdit43Exit
        OnKeyDown = FormKeyUp
        OnKeyUp = SMALL_DBEdit43KeyUp
      end
      object SMALL_DBEdit3: TSMALL_DBEdit
        Left = 356
        Top = 102
        Width = 47
        Height = 22
        Color = clWhite
        DataField = 'CFOP'
        DataSource = Form7.DataSource14
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        OnEnter = SMALL_DBEditBairroEnter
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit39: TSMALL_DBEdit
        Left = 7
        Top = 142
        Width = 395
        Height = 22
        Color = clWhite
        DataField = 'CLIENTE'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = SMALL_DBEdit39Change
        OnClick = SMALL_DBEdit39Click
        OnEnter = SMALL_DBEdit39Enter
        OnExit = SMALL_DBEdit39Exit
        OnKeyDown = SMALL_DBEdit39KeyDown
        OnKeyUp = SMALL_DBEdit39KeyUp
      end
      object SMALL_DBEdit4: TSMALL_DBEdit
        Left = 407
        Top = 142
        Width = 149
        Height = 22
        Color = clWhite
        DataField = 'CGC'
        DataSource = Form7.DataSource2
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        OnEnter = SMALL_DBEditBairroEnter
        OnExit = SMALL_DBEdit4Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit5: TSMALL_DBEdit
        Left = 561
        Top = 60
        Width = 86
        Height = 22
        Color = clWhite
        DataField = 'EMISSAO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnEnter = SMALL_DBEditBairroEnter
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit9: TSMALL_DBEdit
        Left = 561
        Top = 102
        Width = 86
        Height = 22
        Color = clWhite
        DataField = 'SAIDAD'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        OnEnter = SMALL_DBEditBairroEnter
        OnExit = SMALL_DBEdit9Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit14: TSMALL_DBEdit
        Left = 561
        Top = 142
        Width = 86
        Height = 22
        Color = clWhite
        DataField = 'SAIDAH'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
        OnEnter = SMALL_DBEditBairroEnter
        OnExit = SMALL_DBEdit9Exit
        OnKeyUp = FormKeyUp
      end
      object DBGrid1: TDBGrid
        Left = 7
        Top = 294
        Width = 640
        Height = 132
        Color = clWhite
        Ctl3D = False
        DataSource = Form7.DataSource16
        DrawingStyle = gdsClassic
        FixedColor = 15790320
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgEditing, dgTitles, dgColLines, dgTabs, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        OnColEnter = DBGrid1ColEnter
        OnColExit = DBGrid1ColExit
        OnDrawDataCell = DBGrid1DrawDataCell
        OnEnter = DBGrid1Enter
        OnKeyDown = DBGrid1KeyDown
        OnKeyPress = DBGrid1KeyPress
        OnKeyUp = DBGrid1KeyUp
      end
      object SMALL_DBEdit17: TSMALL_DBEdit
        Left = 528
        Top = 450
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'MERCADORIA'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnEnter = SMALL_DBEdit17Enter
        OnExit = SMALL_DBEdit17Exit
        OnKeyUp = SMALL_DBEdit17KeyUp
      end
      object SMALL_DBEdit18: TSMALL_DBEdit
        Left = 528
        Top = 490
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'SERVICOS'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnKeyUp = SMALL_DBEdit17KeyUp
      end
      object SMALL_DBEdit19: TSMALL_DBEdit
        Left = 528
        Top = 530
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'ISS'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit45: TSMALL_DBEdit
        Left = 320
        Top = 450
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'ICMSSUBSTI'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 17
        OnExit = SMALL_DBEdit45Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit44: TSMALL_DBEdit
        Left = 220
        Top = 450
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'BASESUBSTI'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 18
        OnExit = SMALL_DBEdit44Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit21: TSMALL_DBEdit
        Left = 120
        Top = 450
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'ICMS'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 19
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit20: TSMALL_DBEdit
        Left = 10
        Top = 450
        Width = 105
        Height = 22
        Color = clWhite
        DataField = 'BASEICM'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 20
        OnKeyUp = FormKeyUp
      end
      object edtTotalNota: TSMALL_DBEdit
        Left = 528
        Top = 570
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'TOTAL'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 21
        OnChange = edtTotalNotaChange
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit25: TSMALL_DBEdit
        Left = 428
        Top = 570
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'IPI'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 22
        OnEnter = SMALL_DBEdit22Enter
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit24: TSMALL_DBEdit
        Left = 328
        Top = 570
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'DESPESAS'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit22Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit23: TSMALL_DBEdit
        Left = 228
        Top = 570
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'SEGURO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit22Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit22: TSMALL_DBEdit
        Left = 128
        Top = 570
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'FRETE'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit22Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit30: TSMALL_DBEdit
        Left = 522
        Top = 610
        Width = 128
        Height = 22
        Color = clWhite
        DataField = 'CGC'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 25
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit29: TSMALL_DBEdit
        Left = 494
        Top = 610
        Width = 23
        Height = 22
        Color = clWhite
        DataField = 'ESTADO'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 24
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit28: TSMALL_DBEdit
        Left = 414
        Top = 610
        Width = 75
        Height = 22
        Color = clWhite
        DataField = 'PLACA'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit27: TSMALL_DBEdit
        Left = 315
        Top = 610
        Width = 95
        Height = 22
        Color = clWhite
        DataField = 'FRETE12'
        DataSource = Form7.DataSource15
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 23
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit41: TSMALL_DBEdit
        Left = 10
        Top = 610
        Width = 300
        Height = 22
        Color = clWhite
        DataField = 'TRANSPORTA'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnChange = SMALL_DBEdit41Change
        OnClick = SMALL_DBEdit41Click
        OnEnter = SMALL_DBEdit41Enter
        OnExit = SMALL_DBEdit41Exit
        OnKeyDown = SMALL_DBEdit41KeyDown
        OnKeyUp = SMALL_DBEdit41KeyUp
      end
      object SMALL_DBEdit31: TSMALL_DBEdit
        Left = 522
        Top = 650
        Width = 128
        Height = 22
        Color = clWhite
        DataField = 'IE'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 29
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit32: TSMALL_DBEdit
        Left = 494
        Top = 650
        Width = 23
        Height = 22
        Color = clWhite
        DataField = 'UF'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 28
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit33: TSMALL_DBEdit
        Left = 315
        Top = 650
        Width = 174
        Height = 22
        Color = clWhite
        DataField = 'MUNICIPIO'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 27
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit26: TSMALL_DBEdit
        Left = 10
        Top = 650
        Width = 300
        Height = 22
        Color = clWhite
        DataField = 'ENDERECO'
        DataSource = Form7.DataSource18
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 26
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit38: TSMALL_DBEdit
        Left = 550
        Top = 690
        Width = 100
        Height = 22
        Color = clWhite
        DataField = 'PESOLIQUI'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 35
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit37: TSMALL_DBEdit
        Left = 445
        Top = 690
        Width = 100
        Height = 22
        Color = clWhite
        DataField = 'PESOBRUTO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 34
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit36: TSMALL_DBEdit
        Left = 340
        Top = 690
        Width = 100
        Height = 22
        Color = clWhite
        DataField = 'NVOL'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 33
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit35: TSMALL_DBEdit
        Left = 200
        Top = 690
        Width = 134
        Height = 22
        Color = clWhite
        DataField = 'MARCA'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 32
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit34: TSMALL_DBEdit
        Left = 95
        Top = 690
        Width = 100
        Height = 22
        Color = clWhite
        DataField = 'ESPECIE'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 31
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object SMALL_DBEdit15: TSMALL_DBEdit
        Left = 10
        Top = 690
        Width = 80
        Height = 22
        Color = clWhite
        DataField = 'VOLUMES'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 30
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit38Exit
        OnKeyUp = FormKeyUp
      end
      object DBGrid4: TDBGrid
        Left = 10
        Top = 490
        Width = 513
        Height = 62
        Color = clWhite
        Ctl3D = False
        DataSource = Form7.DataSource35
        DrawingStyle = gdsClassic
        FixedColor = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgEditing, dgColumnResize, dgColLines, dgTabs, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 36
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        OnColEnter = DBGrid4ColEnter
        OnEnter = DBGrid4Enter
        OnKeyDown = DBGrid4KeyDown
        OnKeyPress = DBGrid4KeyPress
        OnKeyUp = DBGrid4KeyUp
      end
      object SMALL_DBEdit2: TSMALL_DBEdit
        Left = 420
        Top = 450
        Width = 103
        Height = 22
        Color = clWhite
        DataField = 'DESCONTO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 37
        OnEnter = SMALL_DBEdit17Enter
        OnExit = SMALL_DBEdit17Exit
        OnKeyUp = SMALL_DBEdit17KeyUp
      end
      object SMALL_DBEdit42: TSMALL_DBEdit
        Left = 10
        Top = 570
        Width = 113
        Height = 22
        Color = clWhite
        DataField = 'IDENTIFICADOR1'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 38
        OnEnter = SMALL_DBEdit22Enter
        OnExit = SMALL_DBEdit22Exit
        OnKeyUp = FormKeyUp
      end
      object DBMemo1: TDBMemo
        Left = 10
        Top = 735
        Width = 640
        Height = 75
        DataField = 'COMPLEMENTO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        MaxLength = 32768
        ParentFont = False
        TabOrder = 40
        OnEnter = DBMemo1Enter
        OnKeyDown = DBMemo1KeyDown
      end
      object Edit1: TEdit
        Left = 315
        Top = 610
        Width = 95
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 41
        OnEnter = Edit1Enter
      end
      object ListBox2: TListBox
        Left = 10
        Top = 551
        Width = 513
        Height = 5
        BevelInner = bvNone
        Color = 15790320
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 39
        Visible = False
        OnClick = ListBox2Click
        OnKeyDown = ListBox2KeyDown
      end
      object Edit2: TEdit
        Left = 122
        Top = 60
        Width = 180
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 42
        Text = '1-Normal'
        OnClick = Edit2Click
        OnEnter = Edit2Click
      end
      object Edit3: TEdit
        Left = 308
        Top = 60
        Width = 114
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 43
        Text = '1-Consumidor final'
        OnClick = Edit3Click
        OnEnter = Edit3Click
      end
      object Edit6: TEdit
        Left = 426
        Top = 60
        Width = 133
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 44
        Text = '3-Opera'#231#227'o n'#227'o presencial, Teleatendimento'
        OnClick = Edit6Click
      end
      object DBGrid3: TDBGrid
        Left = 10
        Top = 425
        Width = 640
        Height = 5
        Color = 15790320
        DataSource = Form7.DataSource4
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgColLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 15
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnCellClick = DBGrid3CellClick
        OnKeyDown = DBGrid3KeyDown
        OnKeyPress = DBGrid3KeyPress
        OnKeyUp = DBGrid3KeyUp
        Columns = <
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            Width = 450
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_ATUAL'
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECO'
            Width = 75
            Visible = True
          end>
      end
      object SMALL_DBEdit40: TSMALL_DBEdit
        Left = 7
        Top = 102
        Width = 344
        Height = 22
        Color = clWhite
        DataField = 'OPERACAO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 45
        OnChange = SMALL_DBEdit40Change
        OnClick = SMALL_DBEdit40Click
        OnEnter = SMALL_DBEdit40Enter
        OnExit = SMALL_DBEdit40Exit
        OnKeyDown = SMALL_DBEdit40KeyDown
        OnKeyUp = SMALL_DBEdit40KeyUp
      end
      object DBGrid2: TDBGrid
        Left = 7
        Top = 122
        Width = 344
        Height = 5
        Color = 15790320
        DataSource = Form7.DataSource14
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 46
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnCellClick = DBGrid2CellClick
        OnDblClick = DBGrid2DblClick
        OnExit = DBGrid2Exit
        OnKeyDown = DBGrid2KeyDown
        OnKeyPress = DBGrid2KeyPress
        OnKeyUp = DBGrid2KeyUp
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CFOP'
            Visible = True
          end>
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 838
      Width = 675
      Height = 40
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object Button1: TBitBtn
        Left = 568
        Top = 5
        Width = 100
        Height = 30
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button1Click
        OnEnter = Button1Enter
      end
      object Button2: TBitBtn
        Left = 462
        Top = 5
        Width = 100
        Height = 30
        Caption = 'Pr'#243'xima >'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button2Click
        OnEnter = Button2Enter
      end
      object BitBtnAtorInteressado: TBitBtn
        Left = 336
        Top = 5
        Width = 120
        Height = 30
        Caption = 'Ator interessado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BitBtnAtorInteressadoClick
        OnEnter = Button2Enter
      end
    end
    object Panel9: TPanel
      Left = 800
      Top = 90
      Width = 200
      Height = 200
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      object Image5: TImage
        Left = 0
        Top = 0
        Width = 198
        Height = 198
        Center = True
        Stretch = True
      end
    end
    object Button3: TBitBtn
      Left = 768
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Button3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnClick = Button3Click
    end
    object Panel2: TPanel
      Left = 688
      Top = 315
      Width = 433
      Height = 209
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
      Visible = False
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 37
        Height = 36
        AutoSize = True
        Picture.Data = {
          07544269746D6170F60F0000424DF60F00000000000036000000280000002500
          0000240000000100180000000000C00F00000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF20C1FF00B9FF00B9FF00B9
          FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00
          B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF
          00B9FF00B9FF00B9FF00B9FF00B9FF00B9FF20C1FFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFF9FE4FF00B9FF00D5FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD
          00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7
          FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D7FD00D5FD00
          B9FF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF20C1FF00CDFE00E1
          FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC
          00E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC00E1FC00E1FC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00DFFC00BCFF9F
          E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF20C1FF00CD
          FE00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC
          00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC00E1FC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00DFFC00BCFF9FE4FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF20C1
          FF00CDFE00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC
          00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF20C1FF00CDFE00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC
          00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00E1FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF20C1FF00CDFE00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC
          00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF20C1FF00CDFE00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00CDFE
          20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC
          00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00E1FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00E1FC00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00CDFE20C1FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF
          00DFFC00E1FC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00E1FC00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF
          00BCFF00DFFC00E1FC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00E1FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00E1FC00E1FC00E1FC00
          E1FC00000000000000E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC00000000000000E1FC00E1FC00E1
          FC00DFFC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00E1FC00E1FC00
          E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC00E1FC00E1FC00E1FC00DF
          FC00BCFF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00E1FC00
          E1FC00E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00E1FC00E1FC00DFFC00BC
          FF9FE4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00CDFE00
          E1FC00E1FC00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00E1FC00E1FC00DFFC00BCFF9FE4
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20C1FF00
          CDFE00E1FC00E1FC00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00DFFC00DFFC00BCFF9FE4FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF20
          C1FF00CDFE00CDFE20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF00BCFF00BCFF9FE4FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF20C1FF20C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FE4FF9FE4FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF00}
      end
      object Label2: TLabel
        Left = 48
        Top = 8
        Width = 43
        Height = 13
        Caption = 'Aten'#231#227'o!'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object DBGridRecebedor: TDBGrid
      Left = 720
      Top = 517
      Width = 161
      Height = 59
      DataSource = dsRecebedor
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Roboto'
      Font.Style = []
      Options = [dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = 15122040
      TitleFont.Height = -13
      TitleFont.Name = 'System'
      TitleFont.Style = [fsBold]
      OnCellClick = DBGridRecebedorCellClick
      OnKeyDown = DBGridRecebedorKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'NOME'
          Visible = True
        end>
    end
  end
  object PopupMenu3: TPopupMenu
    AutoHotkeys = maManual
    OnChange = PopupMenu3Change
    Left = 680
    Top = 6
    object ImportarOS2: TMenuItem
      Caption = 'Importar Ordem de Servi'#231'o'
      OnClick = ImportarOS2Click
    end
    object Emitirnotafiscaldevendasnobalco1: TMenuItem
      Caption = 'Importar Cupom'
      OnClick = Emitirnotafiscaldevendasnobalco1Click
    end
    object Importaroramentos1: TMenuItem
      Caption = 'Importar Or'#231'amento'
      OnClick = Importaroramentos1Click
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Incluirnovoitemnoestoque1: TMenuItem
      Caption = 'Incluir novo item no estoque'
      Visible = False
      OnClick = Incluirnovoitemnoestoque1Click
    end
    object Incluirnovocliente1: TMenuItem
      Caption = 'Incluir novo cliente'
      Visible = False
      OnClick = Incluirnovocliente1Click
    end
  end
  object IBQuery1: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 688
    Top = 120
  end
  object DataSource1: TDataSource
    DataSet = IBQuery1
    Left = 688
    Top = 176
  end
  object IBQueryRecebedor: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 792
    Top = 384
  end
  object dsRecebedor: TDataSource
    DataSet = IBQueryRecebedor
    Left = 792
    Top = 440
  end
  object IBQueryAddress: TIBQuery
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 912
    Top = 384
  end
  object dsAddress: TDataSource
    DataSet = IBQueryAddress
    Left = 912
    Top = 440
  end
end
