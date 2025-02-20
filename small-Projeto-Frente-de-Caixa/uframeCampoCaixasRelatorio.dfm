object frameCampoCaixasRel: TframeCampoCaixasRel
  Left = 0
  Top = 0
  Width = 301
  Height = 100
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Color = clWhite
  ParentColor = False
  TabOrder = 0
  PixelsPerInch = 96
  object chklbCaixas: TCheckListBox
    Left = 11
    Top = 24
    Width = 78
    Height = 59
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    Items.Strings = (
      '001'
      '002'
      '003'
      '004'
      '005')
    ParentFont = False
    TabOrder = 1
    OnClickCheck = chklbCaixasClickCheck
    OnKeyPress = chklbCaixasKeyPress
  end
  object chkCaixaFechamentoDeCaixa: TCheckBox
    Left = 11
    Top = 7
    Width = 278
    Height = 13
    Caption = 'Caixas:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = chkCaixaFechamentoDeCaixaClick
  end
end
