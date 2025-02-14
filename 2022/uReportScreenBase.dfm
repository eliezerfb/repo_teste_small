object frmReportScreenBase: TfrmReportScreenBase
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 478
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBotton: TPanel
    Left = 0
    Top = 436
    Width = 796
    Height = 42
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Padding.Top = 1
    Padding.Right = 10
    Padding.Bottom = 15
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = 460
    object BevelPrior: TBevel
      Left = 575
      Top = 2
      Width = 5
      Height = 24
      Align = alRight
      Shape = bsSpacer
      ExplicitLeft = 854
      ExplicitTop = 6
    end
    object BevelPrint: TBevel
      Left = 680
      Top = 2
      Width = 5
      Height = 24
      Align = alRight
      Shape = bsSpacer
      ExplicitLeft = 963
      ExplicitTop = 6
    end
    object btnCancelar: TBitBtn
      Left = 685
      Top = 2
      Width = 100
      Height = 24
      Align = alRight
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCancelarClick
    end
    object BitBtnNext: TBitBtn
      Left = 580
      Top = 2
      Width = 100
      Height = 24
      Align = alRight
      Caption = 'Avan'#231'ar >'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = BitBtnNextClick
    end
    object BitBtnPrior: TBitBtn
      Left = 475
      Top = 2
      Width = 100
      Height = 24
      Align = alRight
      Caption = '< Voltar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BitBtnPriorClick
    end
  end
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 436
    Align = alClient
    TabOrder = 1
    object Bevel4: TBevel
      Left = 136
      Top = 1
      Width = 25
      Height = 434
      Align = alLeft
      Shape = bsSpacer
    end
    object PanelParams: TPanel
      Left = 161
      Top = 1
      Width = 634
      Height = 434
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object PanelWait: TPanel
        Left = 434
        Top = 368
        Width = 185
        Height = 41
        Caption = 'Gerando o relat'#243'rio. Aguarde...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
    end
    object PanelImg: TPanel
      Left = 1
      Top = 1
      Width = 135
      Height = 434
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Padding.Left = 42
      Padding.Top = 20
      Padding.Right = 2
      ParentFont = False
      TabOrder = 0
      object ImgRel: TImage
        Left = 43
        Top = 21
        Width = 89
        Height = 89
        Align = alTop
        AutoSize = True
        Center = True
        Transparent = True
        ExplicitLeft = 46
        ExplicitTop = 0
      end
    end
    object PageControlParams: TPageControl
      Left = 199
      Top = 30
      Width = 402
      Height = 289
      ActivePage = tbsPeriod
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object tbsPeriod: TTabSheet
        Caption = 'tbsPeriod'
        object PanelPeriod: TPanel
          Left = 0
          Top = 0
          Width = 394
          Height = 259
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          object Label1: TLabel
            Left = 12
            Top = 6
            Width = 56
            Height = 13
            Caption = 'Per'#237'odo de:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 12
            Top = 49
            Width = 16
            Height = 13
            Caption = 'At'#233
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object DateTimePickerEnd: TDateTimePicker
            Left = 12
            Top = 66
            Width = 212
            Height = 21
            Date = 35796.000000000000000000
            Time = 0.376154398101789400
            DateFormat = dfLong
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object DateTimePickerStart: TDateTimePicker
            Left = 12
            Top = 23
            Width = 212
            Height = 21
            Date = 35796.000000000000000000
            Time = 0.376154398101789400
            DateFormat = dfLong
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
  end
end
