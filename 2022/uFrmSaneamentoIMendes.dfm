inherited FrmSaneamentoIMendes: TFrmSaneamentoIMendes
  BorderIcons = [biSystemMenu]
  Caption = 'Saneamento'
  ClientHeight = 199
  ClientWidth = 270
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  OnCreate = FormCreate
  ExplicitWidth = 286
  ExplicitHeight = 238
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 12
    Width = 175
    Height = 13
    Caption = 'Selecione o que deseja sanear'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnOK: TBitBtn
    Left = 151
    Top = 156
    Width = 100
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnOKClick
  end
  object chkTodos: TCheckBox
    Left = 20
    Top = 38
    Width = 222
    Height = 17
    Caption = 'Todos os produtos da base de dados'
    TabOrder = 1
    OnClick = chkTodosClick
  end
  object chkPendentes: TCheckBox
    Left = 28
    Top = 59
    Width = 225
    Height = 17
    Caption = 'Produtos com status Pendente'
    TabOrder = 2
    OnClick = chkPendentesClick
  end
  object chkAlterados: TCheckBox
    Left = 28
    Top = 80
    Width = 225
    Height = 17
    Caption = 'Produtos com status Alterado pelo usu'#225'rio'
    TabOrder = 3
    OnClick = chkPendentesClick
  end
  object chkNaoConsultados: TCheckBox
    Left = 28
    Top = 101
    Width = 225
    Height = 17
    Caption = 'Produtos com status N'#227'o consultado'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = chkPendentesClick
  end
  object chkConsultados: TCheckBox
    Left = 28
    Top = 122
    Width = 225
    Height = 17
    Caption = 'Produtos com status Consultado'
    TabOrder = 5
    OnClick = chkPendentesClick
  end
end
