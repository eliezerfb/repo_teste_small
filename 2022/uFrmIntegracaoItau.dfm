inherited FrmIntegracaoItau: TFrmIntegracaoItau
  Left = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Integra'#231#227'o Ita'#250
  ClientHeight = 402
  ClientWidth = 518
  Constraints.MaxHeight = 441
  Constraints.MaxWidth = 534
  Constraints.MinHeight = 441
  Constraints.MinWidth = 534
  Font.Name = 'Microsoft Sans Serif'
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  ExplicitWidth = 534
  ExplicitHeight = 441
  PixelsPerInch = 96
  TextHeight = 16
  object imgLogo: TImage
    Left = 233
    Top = 10
    Width = 52
    Height = 31
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000320000
      00180806000000B808AEE1000000097048597300000B1300000B1301009A9C18
      000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000002
      DB4944415478DAD5573D4C144114FEAE944403416D0C7A569A58080995164022
      AD5068A2D18403DA2368832547E959602276721C85898926DE596A7198088D89
      62E10FD5A1441B301A0BDB71BE7BAC3B3B3B7BB7875C6EFD92CBDEEEBC9979DF
      9BEFBD9949A9EDAA4221036CBC040EA7817363C0480E89C7EF9F4047E7DFD794
      7A30A6B0B61C34CA3E05FA46DBEDAAEFF0CE26F0651DD8D2BFEF9B12747E5F54
      069109A850E7F319606229F88D837D5AF107CB965A4F223F284E47214024DBA9
      6AEC4C5C9806AEDEAD3FE0A242CB3193D641FB1C93C8F379854737FD46E6C94C
      05E84EFF674434B0B122B261F250564612B595481310228DB057225EA232A70E
      EC06E7786F3850FB42A434ABB05A0C7E9D2A89B472BDF2EE5ADEEE13FEFF8E2E
      6DFB56FE7365D78AF28C92458F1E77785A56DF04FB14AC6FDC0A6CBB8551A962
      C6FCEEF2EBE5C8AD93F143E2AD50A34A6362F80670653E48E4CE50D0E6E26C78
      5F73CCD15E22048990504B89E47707A5C66D9855AD3678353809F380126215A4
      0CB7DE891CECB16877BB2ACF96103935E8BFE7FA642374AD808DD5A2386FF60F
      F4CB2072BE9613D9CFF2CB2A664BD693572289B0F4D2B1F59238CF9F07BB9A79
      CE268EC80B7DBC793687D0D1270A892452CE0989669038222EFDB31A51FF3D67
      65577FA3A5669EED12498492B29D6459B64BF564EADF8838AAE8DE89DCFB113E
      33B94AAB4DB89EB3AE36FA417F3CB8563D36119783BC41F2DEC23D83494DD9B8
      EC268B727D2668C768DA9BA24784ED535D21276BED9C8FED8571E7061D8F884B
      32AEA8BDD24E2F8D3BDA07E4C9DDDD55C94CF9F034C16B45938847242A923691
      467651308990447EA8BE3D256D05241E1182DAE4042E274D1DD7B32328354A30
      8A08C1F25DCEB9FBF348CF2B94E5734A7DAC544289DC7F093876C63D50E53EF0
      FA8924E6A123C0C1A3626F5796F29CD8FEDA96F7D39AECB50519B7F67DC708C4
      80B49BF8FA1E7898957908CE755DF7EBBFACE77F0C7CFBE0DBEAB63F40E8F76A
      2ED649C70000000049454E44AE426082}
  end
  object lblHomolog: TLabel
    Left = 4
    Top = 2
    Width = 73
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Homologa'#231#227'o'
    Color = clWhite
    Constraints.MaxHeight = 423
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object pnlCadastro: TPanel
    Left = 0
    Top = 42
    Width = 518
    Height = 360
    Align = alCustom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    DesignSize = (
      518
      360)
    object lblCNPJ: TLabel
      Left = 52
      Top = 11
      Width = 45
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'CNPJ'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblRazaoSocial: TLabel
      Left = 20
      Top = 36
      Width = 77
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Raz'#227'o Social'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblEndereco: TLabel
      Left = 21
      Top = 62
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Endere'#231'o'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblBairro: TLabel
      Left = 21
      Top = 87
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Bairro'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblCEP: TLabel
      Left = 21
      Top = 113
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'CEP'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblMunicipio: TLabel
      Left = 21
      Top = 139
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Munic'#237'pio'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblEstado: TLabel
      Left = 20
      Top = 164
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Estado'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblTelefone: TLabel
      Left = 21
      Top = 190
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Telefone'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblEmail: TLabel
      Left = 20
      Top = 216
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Respons'#225'vel'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object imgInfo: TImage
      Left = 477
      Top = 275
      Width = 21
      Height = 21
      Hint = 'Informe um e-mail para acesso ao portal Ita'#250
      ParentShowHint = False
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000150000
        00150806000000A917A596000000097048597300000B1300000B1301009A9C18
        000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000001
        D14944415478DAAD95DD4D02411485CF45138D4FD8015420540054A056802426
        A03E0015B054202F66C117B002A002E940AC00A800DE3446B99ED91FF99B0512
        9C64676767E67E3373E6DEBB82A8D2D6383E7185182EA088B32701C11073BCB3
        3DC09D8CA34CC50AFB4299C69500D2E77BC69131E129B6CD93F1C08ABA0DBE0A
        7DD2148ED065AB8F133828C82CF224AEDED0BAC6A783A2D4EDD010E8AFDEC13E
        C55523C9EB3A58D606AB1CEC45026C3A86B68A02C7070B6853DBEC9CB0D3B102
        9F798A6F64712F8D8805B324B52959DA48264B2BE5B6DDE8CED25473D23E4FDA
        9040F00C4A52D8AA5D8CEE558CD8E962B7357272829676F183171EADB7C560F7
        C28F74C5338CB8F0B981BE51AF021E647810D49760846364256CE05626FF0735
        3B9DD39502773808EAEA14A7489A9D366830DE7109FB5DA6F1A2922465F9D60E
        84FECD09236ACAFA3A52827DA046CF20AA7C684B2BACF394206D3530EE72CAF4
        17151C2DAD119808175D2414573BFCD29D97B109CCD3CA598EC805D4775E13AE
        266F56F70AD9A6965957D6437C3349BBEAB037EFA5405B863749FC837E1D43D9
        FBF6755C99B309F5C109D60E9F4B1A9B9DCF82D971FAB4FF5BF1F3AEF562EDD0
        E5629277CCFB4781C019251A6FFD23B0FC025AE6D93874963B68000000004945
        4E44AE426082}
      ShowHint = True
    end
    object lblEmailPortal: TLabel
      Left = 57
      Top = 279
      Width = 76
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'E-mail'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblAcessoPortal: TLabel
      Left = 105
      Top = 244
      Width = 192
      Height = 13
      AutoSize = False
      Caption = 'Acesso ao Portal Integra'#231#227'o Ita'#250
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object dbeCnpj: TDBText
      Left = 105
      Top = 10
      Width = 297
      Height = 16
      DataField = 'CGC'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeRazaoSocial: TDBText
      Left = 105
      Top = 35
      Width = 373
      Height = 16
      DataField = 'NOME'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeEndereco: TDBText
      Left = 105
      Top = 61
      Width = 373
      Height = 16
      DataField = 'ENDERECO'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeBairro: TDBText
      Left = 105
      Top = 86
      Width = 297
      Height = 16
      DataField = 'COMPLE'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeCEP: TDBText
      Left = 105
      Top = 112
      Width = 297
      Height = 16
      DataField = 'CEP'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeMunicipio: TDBText
      Left = 105
      Top = 138
      Width = 297
      Height = 16
      DataField = 'MUNICIPIO'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeEstado: TDBText
      Left = 105
      Top = 163
      Width = 297
      Height = 16
      DataField = 'ESTADO'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeTelefone: TDBText
      Left = 105
      Top = 189
      Width = 297
      Height = 16
      DataField = 'TELEFO'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbeResponsavel: TDBText
      Left = 105
      Top = 215
      Width = 361
      Height = 16
      DataField = 'CONTATO'
      DataSource = DSEmitente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 9803160
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btnVoltar: TBitBtn
      Left = 191
      Top = 316
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '< Voltar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnVoltarClick
    end
    object btnEnviar: TBitBtn
      Left = 399
      Top = 316
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Enviar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnEnviarClick
    end
    object edtEmail: TEdit
      Left = 139
      Top = 275
      Width = 333
      Height = 22
      TabOrder = 0
      OnKeyDown = edtEmailKeyDown
    end
    object pnlSeparador: TPanel
      Left = 105
      Top = 261
      Width = 393
      Height = 1
      BevelOuter = bvNone
      Color = 9803160
      ParentBackground = False
      TabOrder = 4
    end
    object btnEmitente: TBitBtn
      Left = 295
      Top = 316
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Emitente'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnEmitenteClick
    end
  end
  object pnlInicial: TPanel
    Left = 0
    Top = 42
    Width = 518
    Height = 360
    Align = alCustom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      518
      360)
    object lblContaBancaria: TLabel
      Left = 20
      Top = 12
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'Conta Banc'#225'ria'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblUsuario: TLabel
      Left = 20
      Top = 53
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'Usu'#225'rio (Acces_key)'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblSenha: TLabel
      Left = 20
      Top = 95
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'Senha (Secret_key)'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblClientID: TLabel
      Left = 20
      Top = 137
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'Client ID Token'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblCadastro: TLabel
      Left = 20
      Top = 265
      Width = 105
      Height = 16
      AutoSize = False
      Caption = 'N'#227'o possui cadastro?'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblQueroCadastrar: TLabel
      Left = 130
      Top = 265
      Width = 105
      Height = 16
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'Quero me cadastrar!'
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = 16750592
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      OnClick = lblQueroCadastrarClick
    end
    object lblAcessarPortal: TLabel
      Left = 20
      Top = 291
      Width = 173
      Height = 16
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'Acessar Portal - Integra'#231#227'o Ita'#250
      Color = clWhite
      Constraints.MaxHeight = 423
      Font.Charset = ANSI_CHARSET
      Font.Color = 25343
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      OnClick = lblAcessarPortalClick
    end
    object btnOK: TBitBtn
      Left = 295
      Top = 316
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnOKClick
    end
    object btnCancelar: TBitBtn
      Left = 399
      Top = 316
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnCancelarClick
    end
    inline fraContaBancaria: TfFrameCampo
      Left = 20
      Top = 28
      Width = 211
      Height = 20
      Color = clWhite
      Ctl3D = False
      ParentBackground = False
      ParentColor = False
      ParentCtl3D = False
      TabOrder = 0
      ExplicitLeft = 20
      ExplicitTop = 28
      ExplicitWidth = 211
      inherited txtCampo: TEdit
        Width = 211
        OnKeyDown = fraContaBancariatxtCampoKeyDown
        ExplicitWidth = 211
      end
      inherited gdRegistros: TDBGrid
        Width = 211
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 190
            Visible = True
          end>
      end
    end
    object chkAtivo: TDBCheckBox
      Left = 459
      Top = 264
      Width = 40
      Height = 17
      Caption = 'Ativo'
      DataField = 'HABILITADO'
      DataSource = DSCadastro
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      ValueChecked = 'S'
      ValueUnchecked = 'N'
      OnKeyDown = edtUsuarioKeyDown
    end
    object edtUsuario: TDBEdit
      Left = 20
      Top = 68
      Width = 478
      Height = 22
      DataField = 'USUARIO'
      DataSource = DSCadastro
      TabOrder = 1
      OnKeyDown = edtUsuarioKeyDown
    end
    object edtSenha: TDBEdit
      Left = 20
      Top = 110
      Width = 478
      Height = 22
      DataField = 'SENHA'
      DataSource = DSCadastro
      TabOrder = 2
      OnKeyDown = edtUsuarioKeyDown
    end
    object memClientID: TDBMemo
      Left = 20
      Top = 152
      Width = 478
      Height = 104
      DataField = 'CLIENTID'
      DataSource = DSCadastro
      TabOrder = 3
    end
  end
  object DSCadastro: TDataSource
    DataSet = ibdIntegracaoItau
    Left = 448
    Top = 24
  end
  object ibdIntegracaoItau: TIBDataSet
    Database = Form7.IBDatabase1
    Transaction = Form7.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    DeleteSQL.Strings = (
      'delete from CONFIGURACAOITAU'
      'where'
      '  IDCONFIGURACAOITAU = :OLD_IDCONFIGURACAOITAU')
    InsertSQL.Strings = (
      'insert into CONFIGURACAOITAU'
      '  (IDCONFIGURACAOITAU,IDBANCO,HABILITADO,USUARIO,SENHA,CLIENTID)'
      'values'
      
        '  (:IDCONFIGURACAOITAU,:IDBANCO,:HABILITADO,:USUARIO,:SENHA,:CLI' +
        'ENTID)')
    RefreshSQL.Strings = (
      'Select '
      #9'I.IDCONFIGURACAOITAU,'
      #9'I.IDBANCO,'
      #9'I.HABILITADO,'
      #9'I.USUARIO,'
      #9'I.SENHA,'
      #9'I.CLIENTID,'
      #9'B.NOME'
      'From CONFIGURACAOITAU I'
      #9'Left Join BANCOS B on B.IDBANCO = I.IDBANCO'
      'where'
      '  IDCONFIGURACAOITAU = :IDCONFIGURACAOITAU')
    SelectSQL.Strings = (
      'Select '
      #9'I.*,'
      #9'B.NOME'
      'From CONFIGURACAOITAU I'
      #9'Left Join BANCOS B on B.IDBANCO = I.IDBANCO')
    ModifySQL.Strings = (
      'update CONFIGURACAOITAU'
      'set'
      'IDBANCO = :IDBANCO,'
      'HABILITADO = :HABILITADO,'
      'USUARIO = :USUARIO,'
      'SENHA = :SENHA,'
      'CLIENTID = :CLIENTID '
      'where'
      ' IDCONFIGURACAOITAU = :OLD_IDCONFIGURACAOITAU')
    ParamCheck = True
    UniDirectional = False
    Filtered = True
    Left = 368
    Top = 24
    object ibdIntegracaoItauIDCONFIGURACAOITAU: TIntegerField
      FieldName = 'IDCONFIGURACAOITAU'
      Origin = 'CONFIGURACAOITAU.IDCONFIGURACAOITAU'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibdIntegracaoItauIDBANCO: TIntegerField
      FieldName = 'IDBANCO'
      Origin = 'CONFIGURACAOITAU.IDBANCO'
    end
    object ibdIntegracaoItauHABILITADO: TIBStringField
      FieldName = 'HABILITADO'
      Origin = 'CONFIGURACAOITAU.HABILITADO'
      Size = 1
    end
    object ibdIntegracaoItauUSUARIO: TIBStringField
      FieldName = 'USUARIO'
      Origin = 'CONFIGURACAOITAU.USUARIO'
      Size = 100
    end
    object ibdIntegracaoItauSENHA: TIBStringField
      FieldName = 'SENHA'
      Origin = 'CONFIGURACAOITAU.SENHA'
      Size = 100
    end
    object ibdIntegracaoItauCLIENTID: TIBStringField
      FieldName = 'CLIENTID'
      Origin = 'CONFIGURACAOITAU.CLIENTID'
      Size = 300
    end
    object ibdIntegracaoItauNOME: TIBStringField
      FieldName = 'NOME'
      Origin = 'BANCOS.NOME'
      ProviderFlags = [pfInWhere]
      Size = 30
    end
  end
  object ibqEmitente: TIBQuery
    Database = Form7.IBDatabase1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'Select *'
      'From EMITENTE')
    PrecommittedReads = False
    Left = 368
    Top = 82
    object ibqEmitenteNOME: TIBStringField
      FieldName = 'NOME'
      Origin = 'EMITENTE.NOME'
      Size = 60
    end
    object ibqEmitenteENDERECO: TIBStringField
      FieldName = 'ENDERECO'
      Origin = 'EMITENTE.ENDERECO'
      Size = 35
    end
    object ibqEmitenteCOMPLE: TIBStringField
      FieldName = 'COMPLE'
      Origin = 'EMITENTE.COMPLE'
    end
    object ibqEmitenteMUNICIPIO: TIBStringField
      FieldName = 'MUNICIPIO'
      Origin = 'EMITENTE.MUNICIPIO'
      Size = 40
    end
    object ibqEmitenteCEP: TIBStringField
      FieldName = 'CEP'
      Origin = 'EMITENTE.CEP'
      Size = 9
    end
    object ibqEmitenteESTADO: TIBStringField
      FieldName = 'ESTADO'
      Origin = 'EMITENTE.ESTADO'
      Size = 2
    end
    object ibqEmitenteCGC: TIBStringField
      FieldName = 'CGC'
      Origin = 'EMITENTE.CGC'
      Size = 18
    end
    object ibqEmitenteIE: TIBStringField
      FieldName = 'IE'
      Origin = 'EMITENTE.IE'
      Size = 16
    end
    object ibqEmitenteTELEFO: TIBStringField
      FieldName = 'TELEFO'
      Origin = 'EMITENTE.TELEFO'
      Size = 16
    end
    object ibqEmitenteEMAIL: TIBStringField
      FieldName = 'EMAIL'
      Origin = 'EMITENTE.EMAIL'
      Size = 132
    end
    object ibqEmitenteCONTATO: TIBStringField
      FieldName = 'CONTATO'
      Origin = 'EMITENTE.CONTATO'
      Size = 35
    end
  end
  object DSEmitente: TDataSource
    DataSet = ibqEmitente
    Left = 448
    Top = 82
  end
end
