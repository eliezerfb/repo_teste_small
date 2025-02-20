object Form5: TForm5
  Left = 202
  Top = 104
  Width = 518
  Height = 263
  Caption = 'Backup programado'
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  Position = poScreenCenter
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 104
    Height = 16
    Caption = 'Iniciar a cópia as:'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 184
    Top = 128
    Width = 34
    Height = 16
    Caption = 'horas'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 128
    Width = 57
    Height = 17
    Caption = 'Ativo'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 120
    Top = 128
    Width = 57
    Height = 20
    AutoSize = False
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '22:00:00'
  end
  object Button1: TButton
    Left = 360
    Top = 8
    Width = 137
    Height = 30
    Caption = 'Editor de backup'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object Button2: TButton
    Left = 360
    Top = 48
    Width = 137
    Height = 30
    Caption = 'Copiar agora'
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
end
