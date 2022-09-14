object FrmInformacoesRastreamento: TFrmInformacoesRastreamento
  Left = 261
  Top = 125
  ActiveControl = edNumeroLote
  BorderStyle = bsDialog
  Caption = 'Rastreabilidade'
  ClientHeight = 238
  ClientWidth = 741
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    741
    238)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 279
    Top = 40
    Width = 82
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '* N'#250'mero do lote:'
    ParentBiDiMode = False
  end
  object Label2: TLabel
    Left = 260
    Top = 72
    Width = 100
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '* Quantidade no lote:'
    ParentBiDiMode = False
  end
  object Label3: TLabel
    Left = 210
    Top = 104
    Width = 151
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '* Data de fabrica'#231#227'o/produ'#231#227'o:'
    ParentBiDiMode = False
  end
  object Label4: TLabel
    Left = 269
    Top = 138
    Width = 91
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '* Data de validade:'
    ParentBiDiMode = False
  end
  object Label5: TLabel
    Left = 254
    Top = 171
    Width = 106
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = 'C'#243'digo de Agrega'#231#227'o:'
    ParentBiDiMode = False
  end
  object lbLegenda: TLabel
    Left = 248
    Top = 208
    Width = 109
    Height = 13
    Caption = '* Campos obrigat'#243'rios'
  end
  object lbQuantidadeNaNota: TLabel
    Left = 226
    Top = 13
    Width = 134
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = 'Quantidade do item na nota:'
    ParentBiDiMode = False
  end
  object lbAcumulado: TLabel
    Left = 493
    Top = 77
    Width = 53
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = 'Acumulado'
    ParentBiDiMode = False
  end
  object Button1: TBitBtn
    Left = 575
    Top = 203
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 6
    OnClick = Button1Click
  end
  object edNumeroLote: TEdit
    Left = 364
    Top = 41
    Width = 121
    Height = 19
    TabOrder = 1
    OnChange = edNumeroLoteChange
    OnKeyPress = FocusNextControl
  end
  object edQuantidade: TMaskEdit
    Left = 364
    Top = 73
    Width = 120
    Height = 19
    TabOrder = 2
    OnChange = edQuantidadeChange
    OnExit = edQuantidadeExit
    OnKeyPress = edQuantidadeKeyPress
  end
  object edDtFabricacao: TMaskEdit
    Left = 364
    Top = 105
    Width = 120
    Height = 19
    EditMask = '!99/99/9999;1;_'
    MaxLength = 10
    TabOrder = 3
    Text = '  /  /    '
    OnChange = edDtFabricacaoChange
    OnKeyPress = FocusNextControl
  end
  object edDtValidade: TMaskEdit
    Left = 364
    Top = 138
    Width = 120
    Height = 19
    EditMask = '!99/99/9999;1;_'
    MaxLength = 10
    TabOrder = 4
    Text = '  /  /    '
    OnChange = edDtValidadeChange
    OnKeyPress = FocusNextControl
  end
  object edCodigoAgregacao: TEdit
    Left = 364
    Top = 172
    Width = 121
    Height = 19
    TabOrder = 5
    OnKeyPress = FocusNextControl
  end
  object Button2: TBitBtn
    Left = 658
    Top = 203
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 0
    OnClick = Button2Click
  end
end
