object frmPrincipal: TfrmPrincipal
  Left = 188
  Top = 166
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Filizola - Programa de Leitura de Balanças / Delphi 5'
  ClientHeight = 304
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000040000000000000000000000000000004B4000000000000000000
    000000000004B400000000000000000000000000004BBB400000000000000000
    0000000004BBBBB400000000000000000000000004BBBBB40000000000000000
    000000004BBBBBBB400000000000004444444444444BBB444444444444400004
    9999999994BBBBB49999999994000000499999994BBBBBBB4999999940000000
    499999994BBBBBBB499999994000000004999994BBBBBBBBB499999400000000
    0049994BBBBBBBBBBB49994000000000000494BBBBBBBBBBBBB4940000000000
    000494BBBBBBBBBBBBB4940000000000004B4BBBBBBBBBBBBBBB440000000000
    04BBBBBBBBBBBBBBBBBBBB40000000004BBBBBBBBBBBBBBBBBBBBBB400000004
    BBBBBBBBBBBBBBBBBBBBBBBB4000000444444444444444444444444440000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFE3FFFFFFE
    3FFFFFFC1FFFFFF80FFFFFF80FFFFFF007FFC0000001E0000003F0000007F000
    0007F800000FFC00001FFE00003FFE00003FFC00003FF800001FF000000FE000
    0007E0000007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 72
    Top = 75
    Width = 112
    Height = 13
    AutoSize = False
    Caption = 'lblDataBits'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 411
    Height = 133
    Align = alTop
    Caption = 'Configurações da Balança / Indicador'
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 57
      Width = 38
      Height = 13
      Caption = 'Modelo:'
    end
    object Label2: TLabel
      Left = 9
      Top = 75
      Width = 55
      Height = 13
      Caption = 'Porta serial:'
    end
    object Label3: TLabel
      Left = 9
      Top = 93
      Width = 51
      Height = 13
      Caption = 'BaudRate:'
    end
    object lblModelo: TLabel
      Tag = 1
      Left = 72
      Top = 57
      Width = 33
      Height = 13
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSerial: TLabel
      Tag = 1
      Left = 72
      Top = 76
      Width = 33
      Height = 13
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBaudRate: TLabel
      Tag = 1
      Left = 72
      Top = 94
      Width = 33
      Height = 13
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnPara: TBitBtn
      Left = 147
      Top = 21
      Width = 94
      Height = 25
      Hint = 'Inicia o teste de leitura da balança.'
      Caption = '&Testar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnParaClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00370777033333
        3330337F3F7F33333F3787070003333707303F737773333373F7007703333330
        700077337F3333373777887007333337007733F773F333337733700070333333
        077037773733333F7F37703707333300080737F373333377737F003333333307
        78087733FFF3337FFF7F33300033330008073F3777F33F777F73073070370733
        078073F7F7FF73F37FF7700070007037007837773777F73377FF007777700730
        70007733FFF77F37377707700077033707307F37773F7FFF7337080777070003
        3330737F3F7F777F333778080707770333333F7F737F3F7F3333080787070003
        33337F73FF737773333307800077033333337337773373333333}
      NumGlyphs = 2
    end
    object btnSair: TBitBtn
      Left = 285
      Top = 21
      Width = 94
      Height = 25
      Hint = 'Sai do sistema'
      Caption = 'Sai&r'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnSairClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00370777033333
        3330337F3F7F33333F3787070003333707303F737773333373F7007703333330
        700077337F3333373777887007333337007733F773F333337733700070333333
        077037773733333F7F37703707333300080737F373333377737F003333333307
        78087733FFF3337FFF7F33300033330008073F3777F33F777F73073070370733
        078073F7F7FF73F37FF7700070007037007837773777F73377FF007777700730
        70007733FFF77F37377707700077033707307F37773F7FFF7337080777070003
        3330737F3F7F777F333778080707770333333F7F737F3F7F3333080787070003
        33337F73FF737773333307800077033333337337773373333333}
      NumGlyphs = 2
    end
    object btnConfigura: TBitBtn
      Left = 9
      Top = 21
      Width = 94
      Height = 25
      Hint = 
        'Inicia a tela de parâmetros de comunicação com a balança/indicad' +
        'or.'
      Caption = '&Configurar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnConfiguraClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
        1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
        1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
        193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
        11155557F755F777777555000755033305555577755F75F77F55555555503335
        0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
        05555757F75F75557F5505000333555505557F777FF755557F55000000355557
        07557777777F55557F5555000005555707555577777FF5557F55553000075557
        0755557F7777FFF5755555335000005555555577577777555555}
      NumGlyphs = 2
    end
    object Button1: TButton
      Left = 146
      Top = 90
      Width = 235
      Height = 25
      Caption = 'Envia preço/kg a balança CS'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 133
    Width = 411
    Height = 171
    Align = alTop
    Caption = 'Dados lidos da Balança / Indicador'
    TabOrder = 1
    object Label8: TLabel
      Left = 9
      Top = 18
      Width = 25
      Height = 13
      Caption = 'Bruto'
    end
    object Label9: TLabel
      Left = 138
      Top = 18
      Width = 88
      Height = 13
      Caption = 'Código do Produto'
    end
    object Label10: TLabel
      Left = 267
      Top = 18
      Width = 63
      Height = 13
      Caption = 'Valor Unitário'
    end
    object Label11: TLabel
      Left = 9
      Top = 66
      Width = 22
      Height = 13
      Caption = 'Tara'
    end
    object Label12: TLabel
      Left = 138
      Top = 66
      Width = 48
      Height = 13
      Caption = 'Contagem'
    end
    object Label13: TLabel
      Left = 267
      Top = 66
      Width = 51
      Height = 13
      Caption = 'Valor Total'
    end
    object Label14: TLabel
      Left = 9
      Top = 114
      Width = 36
      Height = 13
      Caption = 'Líquido'
    end
    object Label15: TLabel
      Left = 138
      Top = 114
      Width = 142
      Height = 13
      Caption = 'Status da Balança / Indicador'
    end
    object lblStatus: TLabel
      Left = 138
      Top = 129
      Width = 53
      Height = 13
      Caption = 'Parado...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlBruto: TPanel
      Left = 9
      Top = 33
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object pnlCodigo: TPanel
      Left = 138
      Top = 33
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object pnlValUnit: TPanel
      Left = 267
      Top = 33
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object pnlTara: TPanel
      Left = 9
      Top = 81
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object pnlCont: TPanel
      Left = 138
      Top = 81
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object pnlValTot: TPanel
      Left = 267
      Top = 81
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object pnlLiquido: TPanel
      Left = 9
      Top = 129
      Width = 115
      Height = 28
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 249
    Top = 18
  end
end
