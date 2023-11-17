object Form7: TForm7
  Left = 1142
  Top = 58
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Leitura de mem'#243'ria fiscal'
  ClientHeight = 528
  ClientWidth = 305
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    305
    528)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TBitBtn
    Left = 33
    Top = 240
    Width = 100
    Height = 40
    Caption = '&Avan'#231'ar >'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TBitBtn
    Left = 161
    Top = 240
    Width = 100
    Height = 40
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Panel2: TPanel
    Left = 1
    Top = 282
    Width = 302
    Height = 295
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 2
    inline Frame_teclado1: TFrame_teclado
      Left = 15
      Top = -3
      Width = 1018
      Height = 301
      TabOrder = 0
      inherited PAnel1: TPanel
        Left = -758
        Top = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 1
    Top = -8
    Width = 302
    Height = 253
    ActivePage = TabSheet8
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    Style = tsFlatButtons
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Label1: TLabel
        Left = 11
        Top = 0
        Width = 273
        Height = 38
        AutoSize = False
        Caption = 'Informe as condi'#231#245'es para a leitura da mem'#243'ria'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label2___: TLabel
        Left = 11
        Top = 16
        Width = 238
        Height = 13
        Caption = 'fiscal e clique  <Avan'#231'ar> para continuar.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label3: TLabel
        Left = 11
        Top = 39
        Width = 68
        Height = 13
        Caption = 'Data inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label5: TLabel
        Left = 11
        Top = 80
        Width = 59
        Height = 13
        Caption = 'Data final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label4: TLabel
        Left = 11
        Top = 122
        Width = 27
        Height = 13
        Caption = 'ECF:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
        Visible = False
      end
      object DateTimePicker1: TDateTimePicker
        Left = 11
        Top = 54
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object DateTimePicker2: TDateTimePicker
        Left = 11
        Top = 95
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object MaskEdit1: TMaskEdit
        Left = 11
        Top = 54
        Width = 32
        Height = 19
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        Text = '0001'
        OnKeyDown = MaskEdit1KeyDown
        OnKeyPress = FocusNextControl
      end
      object MaskEdit2: TMaskEdit
        Left = 11
        Top = 95
        Width = 32
        Height = 19
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 3
        Text = '9999'
        OnKeyDown = MaskEdit2KeyDown
        OnKeyPress = FocusNextControl
      end
      object CheckBox1: TCheckBox
        Left = 66
        Top = 121
        Width = 213
        Height = 17
        Caption = 'Gravar em disco'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object ComboBox1: TComboBox
        Left = 11
        Top = 137
        Width = 270
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 5
        Text = 'ComboBox1'
        Visible = False
        OnChange = ComboBox1Change
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object CheckBox2: TCheckBox
        Left = 11
        Top = 165
        Width = 268
        Height = 17
        Caption = 'Ato cotepe 17/04'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        Visible = False
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object checkMeioPagamento: TCheckBox
        Left = 152
        Top = 160
        Width = 97
        Height = 17
        Caption = 'Exportar para PDF'
        TabOrder = 7
        Visible = False
        OnKeyPress = FocusNextControl
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 1
      ParentFont = False
      object Label6: TLabel
        Left = 11
        Top = 11
        Width = 51
        Height = 13
        Caption = 'M'#234's/Ano'
        Layout = tlBottom
      end
      object Label7: TLabel
        Left = 11
        Top = 63
        Width = 60
        Height = 13
        Caption = 'CPF/CNPJ'
        Layout = tlBottom
      end
      object DateTimePicker3: TDateTimePicker
        Left = 11
        Top = 27
        Width = 89
        Height = 22
        Date = 42233.570227627320000000
        Format = 'MM/yyyy'
        Time = 42233.570227627320000000
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object edCPFCNPJ: TEdit
        Left = 11
        Top = 78
        Width = 217
        Height = 21
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      DesignSize = (
        294
        222)
      object Label8: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 37
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Vendas por documento fiscal no per'#237'odo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label9: TLabel
        Left = 11
        Top = 26
        Width = 68
        Height = 13
        Caption = 'Data inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label10: TLabel
        Left = 11
        Top = 71
        Width = 59
        Height = 13
        Caption = 'Data final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label11: TLabel
        Left = 11
        Top = 115
        Width = 122
        Height = 13
        Caption = 'Forma de pagamento:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label12: TLabel
        Left = 11
        Top = 159
        Width = 35
        Height = 13
        Caption = 'Caixa:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label13: TLabel
        Left = 11
        Top = 199
        Width = 43
        Height = 13
        Caption = 'Cliente:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object dtpVendasInicial: TDateTimePicker
        Left = 11
        Top = 39
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object dtpVendasFinal: TDateTimePicker
        Left = 11
        Top = 84
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object cbFormasPagto: TComboBox
        Left = 11
        Top = 129
        Width = 270
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        OnChange = ComboBox1Change
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object edCaixa: TEdit
        Left = 11
        Top = 172
        Width = 40
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 3
        ParentFont = False
        TabOrder = 3
        Text = '   '
        OnExit = edCaixaExit
        OnKeyPress = FocusNextControl
      end
      object edCliente: TEdit
        Left = 11
        Top = 213
        Width = 270
        Height = 21
        TabOrder = 4
        OnKeyPress = FocusNextControl
      end
      object checkVendaPorDocumento: TCheckBox
        Left = 72
        Top = 176
        Width = 201
        Height = 17
        Caption = 'Exportar para PDF'
        TabOrder = 5
        OnKeyPress = FocusNextControl
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      DesignSize = (
        294
        222)
      object Label14: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 37
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Arquivo com Informa'#231#245'es do Estoque Mensal do Estabelecimento'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label15: TLabel
        Left = 11
        Top = 48
        Width = 49
        Height = 13
        Caption = 'Per'#237'odo:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object dtpEstoque: TDateTimePicker
        Left = 11
        Top = 62
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Format = 'MMMM/yyyy'
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 4
      OnShow = TabSheet5Show
      DesignSize = (
        294
        222)
      object Label17: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 37
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Vendas por documento fiscal no per'#237'odo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label16: TLabel
        Left = 11
        Top = 48
        Width = 69
        Height = 13
        Caption = 'Data Inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label18: TLabel
        Left = 11
        Top = 172
        Width = 35
        Height = 13
        Caption = 'Caixa:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label2: TLabel
        Left = 11
        Top = 88
        Width = 62
        Height = 13
        Caption = 'Data Final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object dtpMovimentoDia: TDateTimePicker
        Left = 11
        Top = 61
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object edMovimentoDia: TEdit
        Left = 11
        Top = 184
        Width = 40
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 3
        ParentFont = False
        TabOrder = 2
        Text = '   '
        OnExit = edMovimentoDiaExit
        OnKeyPress = FocusNextControl
      end
      object dtpMovimentoDiaF: TDateTimePicker
        Left = 11
        Top = 101
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object checkMovimendoDiaPDF: TCheckBox
        Left = 16
        Top = 205
        Width = 241
        Height = 17
        Caption = 'Exportar para PDF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnKeyPress = FocusNextControl
      end
      object dtpMovimentoHoraI: TDateTimePicker
        Left = 11
        Top = 144
        Width = 77
        Height = 21
        Date = 43434.486128298610000000
        Format = 'HH:mm'
        Time = 43434.486128298610000000
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Kind = dtkTime
        ParentFont = False
        TabOrder = 4
        OnKeyPress = FocusNextControl
      end
      object dtpMovimentoHoraF: TDateTimePicker
        Left = 179
        Top = 144
        Width = 77
        Height = 21
        Date = 43434.486128298610000000
        Format = 'HH:mm'
        Time = 43434.486128298610000000
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Kind = dtkTime
        ParentFont = False
        TabOrder = 5
        OnKeyPress = FocusNextControl
      end
      object chkMovimentoDiaHoraI: TCheckBox
        Left = 11
        Top = 127
        Width = 97
        Height = 17
        Caption = 'Hora inicial'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = chkMovimentoDiaHoraIClick
        OnKeyPress = FocusNextControl
      end
      object chkMovimentoDiaHoraF: TCheckBox
        Left = 179
        Top = 127
        Width = 97
        Height = 17
        Caption = 'Hora final'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = chkMovimentoDiaHoraFClick
        OnKeyPress = FocusNextControl
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
      DesignSize = (
        294
        222)
      object Label20: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Total di'#225'rio no per'#237'odo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label21: TLabel
        Left = 11
        Top = 116
        Width = 35
        Height = 13
        Caption = 'Caixa:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label22: TLabel
        Left = 11
        Top = 159
        Width = 45
        Height = 13
        Caption = 'Modelo:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label19: TLabel
        Left = 11
        Top = 26
        Width = 68
        Height = 13
        Caption = 'Data inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label23: TLabel
        Left = 11
        Top = 71
        Width = 59
        Height = 13
        Caption = 'Data final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object edCaixaDiario: TEdit
        Left = 11
        Top = 128
        Width = 40
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 3
        ParentFont = False
        TabOrder = 0
        OnEnter = edCaixaDiarioEnter
        OnExit = edMovimentoDiaExit
        OnKeyPress = FocusNextControl
      end
      object dtpInicialDiario: TDateTimePicker
        Left = 11
        Top = 39
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object dtpFinalDiario: TDateTimePicker
        Left = 11
        Top = 84
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object cbModeloDiario: TComboBox
        Left = 11
        Top = 171
        Width = 270
        Height = 21
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        OnKeyPress = FocusNextControl
        Items.Strings = (
          '59 - CF-e-SAT'
          '65 - NFC-e')
      end
      object checkTotalDiario: TCheckBox
        Left = 64
        Top = 128
        Width = 209
        Height = 17
        Caption = 'Exportar para PDF'
        TabOrder = 4
        OnKeyPress = FocusNextControl
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'TabSheet7'
      ImageIndex = 6
      DesignSize = (
        294
        222)
      object Label24: TLabel
        Left = 11
        Top = 26
        Width = 68
        Height = 13
        Caption = 'Data inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label25: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 15
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'NFC-e no per'#237'odo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label26: TLabel
        Left = 11
        Top = 71
        Width = 59
        Height = 13
        Caption = 'Data final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object DateTimePicker4: TDateTimePicker
        Left = 11
        Top = 39
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object DateTimePicker5: TDateTimePicker
        Left = 11
        Top = 84
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object CheckBox3: TCheckBox
        Left = 13
        Top = 128
        Width = 209
        Height = 17
        Caption = 'Exportar para PDF'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 2
        OnClick = CheckBox3Click
        OnKeyPress = FocusNextControl
      end
      object chkNFCe: TCheckBox
        Left = 13
        Top = 152
        Width = 97
        Height = 17
        Caption = 'NFC-e'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 3
        Visible = False
        OnKeyPress = FocusNextControl
      end
      object chkCFe: TCheckBox
        Left = 141
        Top = 152
        Width = 97
        Height = 17
        Caption = 'CF-e'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 4
        Visible = False
        OnKeyPress = FocusNextControl
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'TabSheet8'
      ImageIndex = 7
      OnShow = TabSheet8Show
      DesignSize = (
        294
        222)
      object Label27: TLabel
        Left = 11
        Top = 0
        Width = 278
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Fechamento de Caixa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label28: TLabel
        Left = 11
        Top = 20
        Width = 69
        Height = 13
        Caption = 'Data Inicial:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object Label30: TLabel
        Left = 11
        Top = 60
        Width = 62
        Height = 13
        Caption = 'Data Final:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlBottom
      end
      object chkCaixaFechamentoDeCaixa: TCheckBox
        Left = 11
        Top = 143
        Width = 278
        Height = 13
        Caption = 'Caixas:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        OnClick = chkCaixaFechamentoDeCaixaClick
      end
      object dtpFechamentoDeCaixaIni: TDateTimePicker
        Left = 11
        Top = 33
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object edFechamentoDeCaixa1: TEdit
        Left = 235
        Top = 152
        Width = 40
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 3
        ParentFont = False
        TabOrder = 1
        Text = '   '
        Visible = False
        OnExit = edMovimentoDiaExit
        OnKeyPress = FocusNextControl
      end
      object dtpFechamentoDeCaixaFim: TDateTimePicker
        Left = 11
        Top = 73
        Width = 270
        Height = 21
        Date = 35796.376154398150000000
        Time = 35796.376154398150000000
        DateFormat = dfLong
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnKeyPress = FocusNextControl
        OnKeyUp = DateTimePicker1KeyUp
      end
      object checkFechamentoDeCaixaPDF: TCheckBox
        Left = 97
        Top = 201
        Width = 241
        Height = 17
        Caption = 'Exportar para PDF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnKeyPress = FocusNextControl
      end
      object dtpFechamentoDeCaixaHoraI: TDateTimePicker
        Left = 11
        Top = 116
        Width = 77
        Height = 21
        Date = 43434.486128298610000000
        Format = 'HH:mm'
        Time = 43434.486128298610000000
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Kind = dtkTime
        ParentFont = False
        TabOrder = 4
        OnKeyPress = FocusNextControl
      end
      object dtpFechamentoDeCaixaHoraF: TDateTimePicker
        Left = 179
        Top = 116
        Width = 77
        Height = 21
        Date = 43434.486128298610000000
        Format = 'HH:mm'
        Time = 43434.486128298610000000
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        Kind = dtkTime
        ParentFont = False
        TabOrder = 5
        OnKeyPress = FocusNextControl
      end
      object chkFechamentoDeCaixaHoraI: TCheckBox
        Left = 11
        Top = 99
        Width = 97
        Height = 17
        Caption = 'Hora inicial'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = chkFechamentoDeCaixaHoraIClick
        OnKeyPress = FocusNextControl
      end
      object chkFechamentoDeCaixaHoraF: TCheckBox
        Left = 179
        Top = 99
        Width = 97
        Height = 17
        Caption = 'Hora final'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = chkFechamentoDeCaixaHoraIClick
        OnKeyPress = FocusNextControl
      end
      object chklbCaixas: TCheckListBox
        Left = 11
        Top = 160
        Width = 78
        Height = 59
        OnClickCheck = chklbCaixasClickCheck
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        Items.Strings = (
          '001'
          '002'
          '003'
          '004'
          '005')
        ParentFont = False
        TabOrder = 8
        OnKeyPress = FocusNextControl
      end
    end
  end
  object IBQFORMASPAGAMENTO: TIBQuery
    Database = Form1.IBDatabase1
    Transaction = Form1.IBTransaction2
    BufferChunks = 1000
    CachedUpdates = False
    Left = 93
    Top = 35
  end
end
