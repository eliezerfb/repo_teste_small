inherited FrmIntegracaoIMendes: TFrmIntegracaoIMendes
  BorderIcons = [biSystemMenu]
  Caption = 'Tributa'#231#227'o Inteligente'
  ClientHeight = 384
  ClientWidth = 604
  Font.Name = 'Microsoft Sans Serif'
  ShowHint = True
  OnCreate = FormCreate
  ExplicitWidth = 620
  ExplicitHeight = 423
  PixelsPerInch = 96
  TextHeight = 16
  object pgcImendes: TPageControl
    Left = 20
    Top = 15
    Width = 564
    Height = 349
    ActivePage = tbsSaneamento
    TabOrder = 0
    object tbsSaneamento: TTabSheet
      Caption = 'Saneamento'
      DesignSize = (
        556
        318)
      object Label1: TLabel
        Left = 17
        Top = 20
        Width = 493
        Height = 13
        Caption = 
          'Baseado no c'#243'digo de barras ou na descri'#231#227'o do produto, esse ass' +
          'istente retornar'#225' automaticamente as'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 17
        Top = 38
        Width = 523
        Height = 13
        Caption = 
          'principais informa'#231#245'es referente '#224' tributa'#231#227'o dos produtos (NCM,' +
          ' CEST, CST PIS/COFINS, % PIS, % COFINS, '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 17
        Top = 57
        Width = 251
        Height = 13
        Caption = 'CST IPI, % IPI, % ICMS, CST/CSOSN, % IVA e FCP).'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 17
        Top = 90
        Width = 470
        Height = 13
        Caption = 
          'Os dados retornados s'#227'o de inteira responsabilidade do Grupo IMe' +
          'ndes, empresa especializada em '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 17
        Top = 107
        Width = 81
        Height = 13
        Caption = 'consultoria fiscal.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 40
        Top = 148
        Width = 63
        Height = 13
        Caption = 'Configura'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Image1: TImage
        Left = 17
        Top = 146
        Width = 17
        Height = 17
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000110000
          001108060000003B6D47FA000000097048597300000B1300000B1301009A9C18
          000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
          BF4944415478DA8D54DB51C240143D1795D7171D081588153054A054A0CC3803
          E80F560054A0FE08FA03560054805600560074805FA233B29E9B4D4282897A67
          086473F7E43CEE2288ABBEC9E11DE710E460B0420603546515D52A919BB5B967
          6E7977488057761DF1F7127569A26BF268C8221A44377F62820DF24840018AF8
          C2132E65C48DCAE8849F199F37F97C8124CA1EB32DC88399B2618C3501B20453
          090655E7AD377C410643A72F850A7B9ADC5922B3F21644292630257A214E77A8
          B45F3027888499744D3B88FE6B79AC1BD2B620D68B16A9E7799FF341B6EBA7BC
          7BA68C6B9F65CF4C785D71B77AD311DC1B35AAC4E631D218051AFBBCBED1DC01
          F618B596A6E3C931343E813302BD882343CBA5E657CFCC0950C195CCF0688AA4
          3F244861C71B578EC74418E786117A3360E7C43831EFF38DC6915AF5A5AE29D3
          C64E2636BEB63358414F743DCDB8D56C506A8A3DBB9EE800723D3827D6C4BA1C
          FF998E8208CDAE49271C71CF18821476473AB22CCB390E68EE852CE5077A1277
          F8084CA74AB0C3D5770EE3866B9A0AC8BA66594B083DEB9E1D1028C14367076A
          40F3D5448D79C6EF963B37959F672738D22A29EE14479420AE9459EA7FFF27DF
          A35EC694E598B9A20000000049454E44AE426082}
      end
      object Image2: TImage
        Left = 100
        Top = 171
        Width = 16
        Height = 18
        Hint = 
          'Marque essa op'#231#227'o para que o sistema preencha os campos CST IPI ' +
          'e % IPI.'
        ParentShowHint = False
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
          0010080600000026944E3A000000097048597300000B1300000B1301009A9C18
          000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
          1B4944415478DAAD52C16D0231109CE503FC52021D001584549012C2BD489407
          D701A68290477481CF410774001D4007B912784781CDD8E780C122422496D6D2
          AE6776D7BB23B8F2C8FF1073BDC127FA5074E9353C624DDFDA104F52C4C4B13E
          F0D1D066F496042D5DFC4D5BA820A5DDD31BA227A303F15DFBBC5392EEC2AC47
          27D306D10B9A2179262E00AC68EDB3A45372156D61B5DC051F253902952D6EA2
          64999AB2D5B1AEF08504CFB28EB2D7484C647312EF9095DB8ACA6AF15A32B593
          2DF6430A0F397F227E709A490438479CF0EF3BDBAAFF2C01E622A21FA6E0856A
          A9731DBFED301C985F9DECB30B06170AE0D5AA27945CCADE077C9863CBC79FF5
          D8F15770EBF45BEA755AB61AB762086C12D4F2D1C2E9B78651B8D36F725F87C9
          573754E00000000049454E44AE426082}
        ShowHint = True
      end
      object lblFaixaFat: TLabel
        Left = 17
        Top = 200
        Width = 119
        Height = 13
        Caption = 'Faixa de faturamento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl2FaixaFat: TLabel
        Left = 17
        Top = 220
        Width = 517
        Height = 13
        Caption = 
          'C'#243'digo da faixa - Receita bruta em 12 meses (R$) | Al'#237'quota | IR' +
          'PJ | CSLL | COFINS | PIS/Pasep | CPP | ICMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Panel1: TPanel
        Left = 17
        Top = 133
        Width = 520
        Height = 1
        BevelOuter = bvNone
        Color = 14277081
        ParentBackground = False
        TabOrder = 0
      end
      object chkConsultaIPI: TCheckBox
        Left = 17
        Top = 171
        Width = 77
        Height = 17
        Caption = 'Consular IPI'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object cboFaixaFat: TComboBox
        Left = 17
        Top = 239
        Width = 520
        Height = 22
        Style = csOwnerDrawFixed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          
            '98 - Lucro Presumido | 3,65% | 0,00% | 0,00% | 3,00% | 0,65% | 0' +
            ',00% | 0,00% |'
          
            '99 - Lucro Real | 9,25% | 0,00% | 0,00% | 7,60% | 1,65% | 0,00% ' +
            '| 0,00% |')
      end
      object btnSanear: TBitBtn
        Left = 180
        Top = 277
        Width = 100
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'Saneamento'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnSanearClick
      end
      object btnSincronizar: TBitBtn
        Left = 284
        Top = 277
        Width = 150
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'Sincronizar pendentes'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnSincronizarClick
      end
      object btnOK: TBitBtn
        Left = 438
        Top = 277
        Width = 100
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnOKClick
      end
    end
    object tbsSimulacao: TTabSheet
      Caption = 'Simula'#231#227'o'
      ImageIndex = 1
      DesignSize = (
        556
        318)
      object Label9: TLabel
        Left = 17
        Top = 20
        Width = 486
        Height = 13
        Caption = 
          'Esse recurso permite que voc'#234' gere de forma gratuita um arquivo ' +
          'de simula'#231#227'o, que ser'#225' processado e'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 17
        Top = 38
        Width = 479
        Height = 13
        Caption = 
          'gerado um laudo dos itens cadastrados no estoque com tributa'#231#227'o ' +
          'incorreta. Dessa forma voc'#234' saber'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 17
        Top = 57
        Width = 384
        Height = 13
        Caption = 
          'se h'#225' produtos em seu estoque que voc'#234' est'#225' pagando mais ou meno' +
          's impostos.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 17
        Top = 90
        Width = 470
        Height = 13
        Caption = 
          'Os dados retornados s'#227'o de inteira responsabilidade do Grupo IMe' +
          'ndes, empresa especializada em '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 17
        Top = 107
        Width = 81
        Height = 13
        Caption = 'consultoria fiscal.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 17
        Top = 146
        Width = 321
        Height = 13
        Caption = 'Efetue o download do simulador IMendes clicando no bot'#227'o ao lado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 17
        Top = 163
        Width = 228
        Height = 13
        Caption = 'Ap'#243's baixar fa'#231'a a instala'#231#227'o dele normalmente.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 17
        Top = 194
        Width = 221
        Height = 13
        Caption = 'Agora, clique no bot'#227'o abaixo "Gerar arquivo".'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 17
        Top = 213
        Width = 438
        Height = 13
        Caption = 
          'Ser'#225' exibida a tela para salv'#225'-lo, escolha um local apropriado e' +
          ' em seguida clique em Salvar.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 17
        Top = 246
        Width = 374
        Height = 13
        Caption = 
          'O arquivo ser'#225' processado e o laudo ser'#225' aberto automaticamente ' +
          'em sua tela.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Panel2: TPanel
        Left = 17
        Top = 133
        Width = 520
        Height = 1
        BevelOuter = bvNone
        Color = 14277081
        ParentBackground = False
        TabOrder = 0
      end
      object btnSimulador: TBitBtn
        Left = 346
        Top = 142
        Width = 100
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'Simulador'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnSimuladorClick
      end
      object btnsOK: TBitBtn
        Left = 438
        Top = 277
        Width = 100
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnOKClick
      end
      object btnGeraSimulacao: TBitBtn
        Left = 324
        Top = 277
        Width = 110
        Height = 24
        Anchors = [akRight, akBottom]
        Caption = 'Gerar arquivo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnGeraSimulacaoClick
      end
    end
  end
  object SaveDialog: TSaveDialog
    FileName = 'simulacao.json'
    Filter = 'Arquivo JSON|*.json'
    Left = 528
    Top = 194
  end
end
