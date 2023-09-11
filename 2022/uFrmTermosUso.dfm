object FrmTermosUso: TFrmTermosUso
  Left = 511
  Top = 195
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Termos de uso do sistema'
  ClientHeight = 476
  ClientWidth = 640
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 16
    Width = 112
    Height = 13
    Caption = 'Contrato de licen'#231'a'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 31
    Top = 411
    Width = 473
    Height = 13
    Caption = 
      'Voc'#234' aceita todos os termos de uso do sistema? Para usar o Small' +
      ', voc'#234' deve aceitar este contrato.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 31
    Top = 40
    Width = 319
    Height = 13
    Caption = 
      'Os termos de uso do sistema foram atualizados, leia-o com aten'#231#227 +
      'o:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object rcTermo: TRichEdit
    Left = 31
    Top = 64
    Width = 578
    Height = 335
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnAceita: TButton
    Left = 445
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Sim'
    TabOrder = 1
    OnClick = btnAceitaClick
  end
  object btnNaoAceita: TButton
    Left = 534
    Top = 440
    Width = 75
    Height = 25
    Caption = 'N'#227'o'
    TabOrder = 2
    OnClick = btnNaoAceitaClick
  end
end
