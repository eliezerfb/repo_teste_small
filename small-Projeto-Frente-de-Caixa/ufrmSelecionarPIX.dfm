object FrmSelecionarPIX: TFrmSelecionarPIX
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Selecione a chave PIX'
  ClientHeight = 260
  ClientWidth = 598
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  DesignSize = (
    598
    260)
  TextHeight = 15
  object dbgChavesPix: TDBGrid
    Left = 20
    Top = 15
    Width = 558
    Height = 182
    Align = alCustom
    Anchors = [akLeft, akTop, akRight]
    DataSource = DSBancosPIX
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgColumnResize, dgTabs, dgRowSelect, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = dbgChavesPixDblClick
    OnKeyDown = dbgChavesPixKeyDown
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
        Width = 219
        Visible = True
      end>
  end
  object btnSelect: TBitBtn
    Left = 374
    Top = 216
    Width = 100
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
    TabOrder = 1
    OnClick = btnSelectClick
  end
  object btnCancel: TBitBtn
    Left = 479
    Top = 216
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
    ExplicitLeft = 540
  end
  object DSBancosPIX: TDataSource
    Left = 392
    Top = 88
  end
end
