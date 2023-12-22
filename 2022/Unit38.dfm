object Form38: TForm38
  Left = 1052
  Top = 262
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio de vendas'
  ClientHeight = 262
  ClientWidth = 454
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 454
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Image1: TImage
      Left = 20
      Top = 20
      Width = 89
      Height = 89
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label2: TLabel
      Left = 200
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Per'#237'odo de:'
      Visible = False
    end
    object Label3: TLabel
      Left = 200
      Top = 56
      Width = 19
      Height = 13
      Caption = 'At'#233':'
      Visible = False
    end
    object Label17: TLabel
      Left = 200
      Top = 160
      Width = 29
      Height = 13
      Caption = 'Caixa:'
      Visible = False
    end
    object Label21: TLabel
      Left = 24
      Top = 190
      Width = 89
      Height = 13
      Caption = '<Nome do cliente>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label25: TLabel
      Left = 200
      Top = 130
      Width = 39
      Height = 13
      Caption = 'Usu'#225'rio:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object cbListarCodigos: TCheckBox
      Left = 216
      Top = 147
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Listar c'#243'digos'
      Enabled = False
      TabOrder = 10
      Visible = False
    end
    object Edit1: TEdit
      Left = 235
      Top = 160
      Width = 25
      Height = 19
      TabOrder = 11
      Visible = False
      OnChange = Edit1Change
      OnExit = Edit1Exit
    end
    object Button3: TBitBtn
      Left = 100
      Top = 220
      Width = 100
      Height = 23
      Caption = '< Voltar'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button3Click
    end
    object btnAvancar: TBitBtn
      Left = 215
      Top = 220
      Width = 100
      Height = 23
      Caption = 'Avan'#231'ar >'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnAvancarClick
    end
    object Button2: TBitBtn
      Left = 330
      Top = 220
      Width = 100
      Height = 23
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 200
      Top = 32
      Width = 225
      Height = 21
      Date = 35796.376154398100000000
      Time = 35796.376154398100000000
      DateFormat = dfLong
      TabOrder = 6
      Visible = False
    end
    object DateTimePicker2: TDateTimePicker
      Left = 200
      Top = 72
      Width = 225
      Height = 21
      Date = 35796.376154398100000000
      Time = 35796.376154398100000000
      DateFormat = dfLong
      TabOrder = 7
      Visible = False
    end
    object RadioButton1: TRadioButton
      Left = 200
      Top = 110
      Width = 185
      Height = 17
      Caption = 'Relat'#243'rio de ICMS'
      Checked = True
      TabOrder = 8
      TabStop = True
      Visible = False
      OnClick = RadioButton1Click
    end
    object rbItemPorITem: TRadioButton
      Left = 200
      Top = 130
      Width = 185
      Height = 17
      Caption = 'Item por item'
      TabOrder = 9
      Visible = False
      OnClick = rbItemPorITemClick
    end
    object Panel3: TPanel
      Left = 200
      Top = 13
      Width = 350
      Height = 200
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 5
      Visible = False
      object Label1: TLabel
        Left = 8
        Top = 80
        Width = 204
        Height = 13
        Caption = 'Clique em <Avan'#231'ar> para  gerar o relat'#243'rio'
      end
      object Label4: TLabel
        Left = 8
        Top = 96
        Width = 111
        Height = 13
        Caption = 'de previs'#227'o de compra.'
      end
      object Label5: TLabel
        Left = 8
        Top = 8
        Width = 208
        Height = 13
        Caption = 'Este relat'#243'rio fornece uma m'#233'dia mensal de '
      end
      object Label6: TLabel
        Left = 8
        Top = 24
        Width = 201
        Height = 13
        Caption = 'vendas, e uma previs'#227'o do tempo em que '
      end
      object Label7: TLabel
        Left = 8
        Top = 40
        Width = 191
        Height = 13
        Caption = 'a mercadoria vai ser totalmente vendida.'
      end
    end
    object Panel5: TPanel
      Left = 200
      Top = 16
      Width = 241
      Height = 136
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 3
      Visible = False
      object Label10: TLabel
        Left = 15
        Top = 32
        Width = 194
        Height = 13
        Caption = 'Selecione abaixo o m'#234's e ano desejado, '
      end
      object Label11: TLabel
        Left = 15
        Top = 48
        Width = 159
        Height = 13
        Caption = 'para calcular o saldo das contas, '
      end
      object Label12: TLabel
        Left = 15
        Top = 8
        Width = 163
        Height = 13
        Caption = 'C'#225'lculo do Saldo das Contas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 15
        Top = 64
        Width = 119
        Height = 13
        Caption = 'depois clique <avan'#231'ar>.'
      end
      object MonthCalendar1: TMonthCalendar
        Left = 0
        Top = 0
        Width = 241
        Height = 136
        Align = alClient
        CalColors.BackColor = clWhite
        CalColors.TitleBackColor = 14456320
        Date = 37168.572637337970000000
        ShowToday = False
        ShowTodayCircle = False
        TabOrder = 0
      end
    end
    object Panel1: TPanel
      Left = 200
      Top = 15
      Width = 240
      Height = 202
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 12
      Visible = False
      object Label18: TLabel
        Left = 5
        Top = 15
        Width = 210
        Height = 13
        Caption = 'Este assistente vai gerar os arquivos  neces-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 5
        Top = 55
        Width = 206
        Height = 13
        Caption = 'Selecione abaixo o modelo da sua balan'#231'a:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label20: TLabel
        Left = 5
        Top = 30
        Width = 197
        Height = 13
        Caption = 's'#225'rios para integra'#231#227'o com uma  balan'#231'a.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object RadioButton3: TRadioButton
        Left = 24
        Top = 95
        Width = 113
        Height = 17
        Caption = 'Urano'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
      end
      object RadioButton4: TRadioButton
        Left = 24
        Top = 114
        Width = 113
        Height = 17
        Caption = 'Toledo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object RadioButton5: TRadioButton
        Left = 24
        Top = 133
        Width = 113
        Height = 17
        Caption = 'Filizola'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object Panel6: TPanel
      Left = 200
      Top = 15
      Width = 240
      Height = 200
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 13
      Visible = False
      object Label22: TLabel
        Left = 5
        Top = 15
        Width = 172
        Height = 13
        Caption = 'Este assistente vai gerar um relat'#243'rio'
      end
      object Label23: TLabel
        Left = 5
        Top = 55
        Width = 190
        Height = 13
        Caption = 'Clique <Avan'#231'ar> para iniciar o relat'#243'rio.'
      end
      object Label24: TLabel
        Left = 5
        Top = 30
        Width = 138
        Height = 13
        Caption = 'com o ranking de devedores.'
      end
    end
    object ComboBox1: TComboBox
      Left = 200
      Top = 150
      Width = 160
      Height = 21
      ItemHeight = 13
      TabOrder = 14
      Text = 'ComboBox1'
      Visible = False
    end
    object pnlSelOperacoes: TPanel
      Left = 200
      Top = 14
      Width = 241
      Height = 187
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 4
      Visible = False
      object Label8: TLabel
        Left = 8
        Top = 0
        Width = 169
        Height = 13
        Caption = 'Selecione abaixo as opera'#231#245'es que'
      end
      object Label9: TLabel
        Left = 8
        Top = 16
        Width = 90
        Height = 13
        Caption = 'devem ser listadas.'
      end
      object chkOperacoes: TCheckListBox
        Left = 11
        Top = 49
        Width = 230
        Height = 106
        Hint = 'Opera'#231#245'es que devem ser listadas'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        IntegralHeight = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
      end
      object btnMarcarTodos: TBitBtn
        Left = 11
        Top = 158
        Width = 94
        Height = 23
        Caption = 'Marcar todas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnMarcarTodosClick
      end
      object btnDesmarcarTodos: TBitBtn
        Left = 110
        Top = 158
        Width = 94
        Height = 23
        Caption = 'Desmarcar todas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnDesmarcarTodosClick
      end
    end
  end
end
