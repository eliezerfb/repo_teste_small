object FrmSelecionarPIX: TFrmSelecionarPIX
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Selecione a chave PIX'
  ClientHeight = 260
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 659
    Height = 219
    Align = alClient
    DataSource = DSBancosPIX
    Options = [dgTitles, dgColumnResize, dgTabs, dgRowSelect, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Caption = 'Banco'
        Width = 133
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PIXTITULAR'
        Title.Caption = 'Titular'
        Width = 185
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PIXCHAVE'
        Title.Caption = 'Chave'
        Width = 315
        Visible = True
      end>
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 219
    Width = 659
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -257
    ExplicitTop = 318
    ExplicitWidth = 784
    DesignSize = (
      659
      41)
    object btnSelect: TBitBtn
      Left = 500
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Selecionar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnSelectClick
      ExplicitLeft = 625
    end
    object btnCancel: TBitBtn
      Left = 580
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 705
    end
  end
  object DSBancosPIX: TDataSource
    Left = 392
    Top = 88
  end
end
