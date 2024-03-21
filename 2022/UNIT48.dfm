object Form48: TForm48
  Left = 287
  Top = 103
  HorzScrollBar.Color = clRed
  HorzScrollBar.Margin = 10
  HorzScrollBar.ParentColor = False
  VertScrollBar.Color = clRed
  VertScrollBar.Increment = 20
  VertScrollBar.Margin = 10
  VertScrollBar.ParentColor = False
  VertScrollBar.Tracking = True
  AlphaBlendValue = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Recibo Provis'#243'rio de Servi'#231'os - RPS'
  ClientHeight = 615
  ClientWidth = 1008
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label44: TLabel
    Left = 0
    Top = 768
    Width = 4
    Height = 16
    Caption = ' '
  end
  object Label55: TLabel
    Left = 16
    Top = 662
    Width = 4
    Height = 16
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1008
    Height = 615
    Align = alClient
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 15122040
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 7
      Top = 6
      Width = 662
      Height = 499
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Label65: TLabel
        Left = 146
        Top = 24
        Width = 397
        Height = 24
        Caption = 'RECIBO PROVIS'#211'RIO DE SERVI'#199'O - RPS'
        Color = clSilver
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -19
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
      end
      object Label8: TLabel
        Left = 10
        Top = 154
        Width = 163
        Height = 13
        Caption = 'Raz'#227'o social do cliente / ou CNPJ'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label11: TLabel
        Left = 480
        Top = 154
        Width = 76
        Height = 13
        Caption = 'CNPJ do cliente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label30: TLabel
        Left = 276
        Top = 339
        Width = 86
        Height = 13
        Caption = 'Total dos servi'#231'os'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label1: TLabel
        Left = 145
        Top = 339
        Width = 59
        Height = 13
        Caption = 'Valor do ISS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label38: TLabel
        Left = 526
        Top = 339
        Width = 63
        Height = 13
        Caption = 'Total da nota'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label5: TLabel
        Left = 10
        Top = 386
        Width = 138
        Height = 13
        Caption = 'Informa'#231#245'es complementares'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label9: TLabel
        Left = 305
        Top = 109
        Width = 106
        Height = 13
        Caption = 'Vendedor                    '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = False
      end
      object Label71: TLabel
        Left = 278
        Top = 69
        Width = 132
        Height = 24
        Caption = '000000000/RPS'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 10
        Top = 198
        Width = 110
        Height = 13
        Caption = 'Descri'#231#227'o dos servi'#231'os'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label57: TLabel
        Left = 419
        Top = 198
        Width = 20
        Height = 13
        Caption = 'Qtd.'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label59: TLabel
        Left = 546
        Top = 198
        Width = 24
        Height = 13
        Caption = 'Total'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label69: TLabel
        Left = 405
        Top = 339
        Width = 46
        Height = 13
        Caption = 'Desconto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label62: TLabel
        Left = 470
        Top = 198
        Width = 36
        Height = 13
        Caption = 'Unit'#225'rio'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label2: TLabel
        Left = 10
        Top = 338
        Width = 73
        Height = 13
        Caption = 'Aliquota de ISS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 10
        Top = 109
        Width = 106
        Height = 13
        Caption = 'Natureza da opera'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Imagefixa: TImage
        Left = 31
        Top = 8
        Width = 100
        Height = 90
        Center = True
        Picture.Data = {
          0A544A504547496D616765CA180000FFD8FFE000104A46494600010101006000
          600000FFE1002245786966000049492A00080000000100005104000100000000
          00000000000000FFDB004300080606070605080707070909080A0C140D0C0B0B
          0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434
          341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C2132
          3232323232323232323232323232323232323232323232323232323232323232
          3232323232323232323232323232323232FFC000110800880096030122000211
          01031101FFC4001F000001050101010101010000000000000000010203040506
          0708090A0BFFC400B5100002010303020403050504040000017D010203000411
          05122131410613516107227114328191A1082342B1C11552D1F0243362728209
          0A161718191A25262728292A3435363738393A434445464748494A5354555657
          58595A636465666768696A737475767778797A838485868788898A9293949596
          9798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2
          D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F
          0100030101010101010101010000000000000102030405060708090A0BFFC400
          B511000201020404030407050404000102770001020311040521310612415107
          61711322328108144291A1B1C109233352F0156272D10A162434E125F1171819
          1A262728292A35363738393A434445464748494A535455565758595A63646566
          6768696A737475767778797A82838485868788898A92939495969798999AA2A3
          A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8
          D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C0301000211031100
          3F00F7FA28A2800A28A2800AAF797D69A7C425BBB88E08C9DA1A46C026AC5798
          5FFDAED6F26B6B6963967851DD255792ECCAFF00320CA0202BEDEB927AE07B70
          E618C784A5ED396FFA76BF97A265423CCEC77B65AE5ADFDE35BC2B2630E52520
          6C902B6D6DA41CF04F7033DB3585AC6B97F61ACCD1C575921B6C366D113E62F9
          40EE0550B1C3B73DB02B3340B99F44985EEA36378DE72ADBCD339590EEDF8464
          5CEE0ADBB2571C71C7150EAFE28B7D537CBF6D8AD12249A028B0BCD22AB100B3
          6DFB87E40715E4D5CDD54C17B584ED3BECB5EBB3DF4B75EBE468A9DA56B685AB
          3F12EA17B25A4363A9FDB03C87CB952D7FE3E46E1904EC080280C09539E9DFAE
          DF89752BFD32E2D6586568ED8950710F98247DC3E438058646402075AF3482E1
          9F51422E440F712FDA112DE5681233808DCEE1D4007B7DE38ABB7735F69BA9E9
          827BBBAC89D0B477178651F70E4B2EF3D5BA1FFF005571D3CDA51A12A73949D4
          6AE9E9D3E5E5AE8EFA94E9EB75B1BFFF00095DE490C8ABAB28CCA41996DC8314
          801FDC0063C139DBF7BE6EBC735DACB7E2CF494BBB95766D8995503733B60000
          1C0C9240AF2CD1F5082D2DBC87D4A085A296391D5ACE40998DC3293267037632
          4FB9AEBAEFC46BE20D13EC96BA7CB2BDD5BAB4A0EDDB18638CA96C07E8C411DC
          0CE2BAB2ECCED4EA4B135755B5FF003D95EEDF4EC899C3556474165AF69D7CF1
          C51DCA25C3965FB3BB01202A4820807AF07EB8C8AD2AF2579355B46BA92749E3
          82170F6B14FBCCA782B8FB429C024163FC4006E4F5AF43F0E5B35BE9793246EB
          2C85D16298CA88BC00AAC7B719F4C935DF966672C6DD385ADBB4F4E9FF0007CB
          CD9338729AF451457AE66145145001451450014514500145159DA8EAB1583287
          2C30DCE0673F29200FA9007D48A52928ABB7A0136A764351D2AEEC8B14F3E268
          F70ED918CD794EB7A5EBDA35A59C5697371612BB6D13CECAD0C7819215118963
          8C8504018DD9CF6F48B0D54DD810AB013890894E0B2AFCCC36AFAFDD3F4C7356
          359B0B5D52CBECB733984EE12472295DE8C3A11B811EA3A77AF3B1784A58EA6A
          71776969DBE65C64E2EC7865B787A1559751BC7BDD52EE1B8064BBBB90ED2B90
          7804E00C1CF51D2BA18ADA37B9BB484C0D1C90A8430219413860402AAD838DBC
          07AEC13C2F15AC9E747369F7D2F52F799F3188E87792DCFE1573CDBD8CED7B38
          DCFAC1748CBFF8F153FA57C9E33039927FC3725E4D796CBFE02378CA1DCE3ADE
          C2EA692D1E5B4BA765B7292ABC0E70C76F19691411C1A8E0D02EAD34FB48869E
          C0C73879024381DF9E25E7B76AED0DE4A0E0E9F75D71C6C6FE4C68FB64B92058
          5D1FC107F36AF31D0CCD68A84ADE8FCFFCCBBC3B9C25F5A4A6DF53924B2B8064
          188B74527F740E32AFDFFF00D7599AAF87F4AD62FE281A3DE563762627C3A905
          4024A92C3F15535E9FE7DDB1C2D8329EC65B8880FC70C4FE94C9B4C9F50016EC
          E908A0E46E26E3F11909835DD85C1668E49C6938F9DD2E96EA4CA50EE7967872
          2D79350D3B4E3ABDF6A305CC47647E6059E0C2EEE4960ACBDF920820751C1F5E
          F09E892E8D6571F686633CF3173BC82C140C0C91C13D493EFEC2A0D1FC35A5E9
          1A82DF2DEB4B324461891A402285491908BFC39C0EE6BA199CFD9DA489D46064
          36370FD2BEBB0197AA0FDB545EFBDEDB7FC3FF005E673CA77D16C4B4560CDAFC
          51DC1F9F62AC644D9E7CB6CE14818F9813DC75E2B5ACEE96F2DD654040214F3E
          EA1BFAD7A30AB09B718BBB5A326CD1628A28AD04145145001451450015C5EB6E
          D737D2125A488EC0635381B73B837B1CA806BB3624292064FA5707AA4B0FDBA6
          E1E238DF1C9807398F257F0CAF1ED5E27104DC7032B756BFAFEBD4D292F78D1F
          0CC6CA59BF7BF34830BB0290B807F05E724F5278F5AF2AF8ED6D1DDF8F345866
          04A1B07240247F19F4AF5DF0E7CB24CB1C4D18F398B83203C91DCF393EDEBB8F
          A57947C6C1FF00170746FF00B073FF00E866BA70AF972F838FF2AFC8EDCB69C6
          A63E9C26AE9C97E679AFF60E9FFF003C5BFEFE37F8D1FD83A7FF00CF16FF00BF
          8DFE35A24E0F255570492C7005304F1B6006C647058103A66B83DB55FE67F79F
          A3D5A195527253A714E2AEFDD5B7969AFCAE51FEC1D3FF00E78B7FDFC6FF001A
          9F4BF0F697731DC196066293141FBD6181807D7DCD5BA9B4370B0DFB310156E5
          8927B0DAB533AF5791B527F79F31C6B85A186C0C25420A2DC96A925D1F61BFF0
          8A68FF00F3EAFF00F7F9FF00C69BFF0008C689FF003C0FFDFF006FF1AEEB4BF0
          46ABA9C765773B0B7B49E41BA12BFBCF2B19DC4E78CFF77AFAFA0DFD734FD557
          4CBA167A7456FA7C16FB23814AAB320032490720E01C01D7BD7933CDDC66A11A
          977D7DEDBFE0FF00573E0E960ABCA3CD39B5F89E35AA787B498747BBB9B68887
          8E32CAC2666008FC6BE8CF86F93F0AF41C0727EC4BF70E1BF0F7AF09D5D77787
          EF8F98D216809DEC724F1C57BCFC32CFFC2AFF000FE319FB12F538F5AFA6CB2A
          4A709733BEBD4584939296B7D7A99DA9C7B35396428F2AE16440A985DC3E6E0E
          78E631907A738E95D07869A48A196DE598C8430C679E4280471D8118AC5D48A9
          D45CB878DC8449250C09F6C8F7E99F6CF7AD2F0B48A43948994310133DC6C196
          FC4A8E4FA8AF2F05371CE6B416CD7E3A7FC13D297F0D1D3D14515F4E62145145
          0014514500457240B67DD2988118DE3F87DEB8ABF9E596EAEBC968594165922C
          E0C6C2339E9EFB876FBA2BB4BB4325A48A1D5091D5BA7E3ED5C2DF379D717195
          8E531B38F964C327C87E57E79E9CFF00B41BD6BE7F891FFB17CD7EBFD74FD1EB
          47E236FC3663F36E02980ED9C8F93A2FCA3E51EA78393EDEF5E55F1AFF00E4A0
          68FF00F60D7FFD186BD67C3A51A4B87DEB262528AC06D0B855F9547D3F400F7A
          F26F8D9FF250347FFB073FFE8C35D985BFF66C2FFCABF23D0CA7FE4654BFC48E
          5B4EB0BFD6E21A569FA48BB944E26F363886E55231867C70B924F27F0E2B7BC4
          7E069FC3DE12BBB8BD4135E8961432A16F2E04646C8CF42C182827A60AE3AF1C
          B58DDDE69AD70D65793DB1B8C798607319603A64AE0D4975A8EA17B6C6DAEF51
          BEB8818E4C735CBBA9FC09AE6A73A34E3B3B9F678CCA71D5AA374651846EDF56
          DDEDBBB792D169A2DCA8B9C0E318183CE79A934362B1DF38D9B92F372EF50CBB
          86DC643718CE3AF14DE94DF0CCBB9EF949FBF2F9CBF4248FE9584A0E54A724B4
          56FCCF278D20B0F9751A49DDA95F77D3D6EFAE9D8F49D5FC4DAF586A11C116A6
          AD11B68A40CB0C655F72F241C74C838A6E8FE24D7350D72DEDE7D459A170E5D0
          2228C2A31CE71C0C81F9D6245A8446D21B3BFB4F3E18232B6EF07EEE44627272
          C720A9249391C1C6314B2DFDBC76B3DAE9D66624B884473CD72C5E53CE70A460
          05E0718E7BD783F55872727B357DAF65F7F7FF0083F79F05F596EA7B4F69EEF6
          D7EE3135867934AD4A4902891D242CAA00553DC0038C71DBEB5EEBF0C881F0BF
          C3E49000B25E4FE35E15ABE068B7BD8792DFCABDDBE18103E1878789E82CD6BE
          AF28F825EA4E0A5CDCD2EECA97A7FE26CEB0FD9CC8863F972414C8EC7BA918E3
          B6455EF0F4B990A3CC9E60285C27F002A005F7E76FA743E954B520BFDA724785
          61B919621C6323AA37E1F91038C558F0F65EE444AD0A84119D8A72C9804FCDEE
          73FF008F1EB8E3C8C25D67953E7F92FEBF5EFEA4BF848EBE8A28AFAE300A28A2
          800A28A2801B2279913271F30C72322B85D42376B978DE18498F772ED9604C64
          9E31D09FD413DF8EF2B94F14E8F6F733A5C5CC2AD0B364C9D0C726C65049F70C
          00F7FAD78B9FD175304DA57B6A6949DA459F0F34935DDCB19A399236C1645C05
          73D40E7D028CFB7B9AF24F8DEDB7E21E863FBDA7B8FF00C7DBFC2BD6EDAFF4DF
          0E6910CD7F711DAA5C05F2E3C16214280000064E0753EF5E5BF1E6047BBF09EB
          90307819A480C8BC82182B2F3F4DD5D184A6E3818D297C4A3B7CBC8EAC05650C
          7539DF692FCCE028A2A29EE23B74DD23633C00392C7D00EF5E628B93B2DCFD82
          738D38B9CDD92EA32F6630DB109FEB1FE441EE7FCE7F0A8EC645D3EF6DDF2044
          57C873E80FDD3F9FF3A8544934BF68986D6C611339D83FC4D5DB98ED6E5E186C
          A19D8BC6A92249862F21E0EDC7627A0AFB1C0E50A3839D2ADBCFF0EDFE67E51C
          4999C732C45A1F04745E7DD9D15158B65A8BD939B1D4B746636D8B2C8318238D
          AF9E8C3A64F5FAD6D57C3E2B09570B51D3AAACFF003F43E26A53941D999DAFB6
          DD02FCFF00D3123F3AF7AF861FF24C7C3DFF005E6B5F3DF8B2610F87A61DDD95
          07E79FE95F43787EE2CBC21E02D06DF54B816E52D228C86049DFB412303278E6
          BD7CA928D1727DFF00C8F4703A536DF729DE895AFE7B691E0628CA3C871D17A8
          23DB9239ED8ABDE1A4791D3F771A2C48B908DB947CBC0E839F989FC4FA545E20
          B3D3F50582EA5F2EE2CAE9F72B29CE4F9646063921801C0EE3E95B5A069FFD9F
          A6223462391C0664EEB850A013EB8033EF9AF3B07869FF006BD5A928E9BDFA6B
          B59FA5FA69DFBFA9292F66923528A28AFA6310A28A2800A28A2800A82F2DD6EE
          CE6B76C624423919C1EC7F3A9EA0BCBDB6D3ED5EEAEE648604FBCEC7814A4934
          D4B60BDB53CF744B18BC4FE20D4BFB550341A7C0B67144FF00C04E549FF78107
          F13EC2B3BC4BE1DBAD7BE19EA9E1A914B6AFA2389ED78E6555C942BF55DCA3DE
          A8DE4B0EAFE2D9F4DD33518DAC757B98E5320E082371C60E0F049FAF15E81E16
          BF174DF62D51026BDA7A1865DC7E6923CF0C0FF129C0FC79EE2B870CE37B7557
          57EFFD2B1CF4A49CAEBBBFEBF23E6082F6EAF2D9248FCB8958727EFB67E9C01F
          AD5BB0B6B0F36692FA6B80FE4B79722A07667FE1539230BEB8AEE7E27FC3BBAF
          0E6A173E21D12D5A7D1EE18CB756D10CB5AB9EACA3FB87BFA7D2B3344F06D9EA
          5676F797DE29B0812E103C76DA7C6D797047A155FBA7F03822BE8309F52C3D35
          28AB4BEF67A58CCC7198CD2BCDB5DBA7DC8E5E3D8645F30B04C8DC5464E3BE2A
          6892122E1FED26168C6E854A92643BBA647438E73ED5D8EA5F0F2286DDA5B0BC
          D650AF7D4B4A758C8F52D18DC83DCA915CEFFC2357FBB6FDAF47C7F7C6A51B03
          F451973F4DB9AEF8E3E8496F638395990DF393BBE6DDD73CE696DE5B9B2E2D67
          2A9FF3CA41B93F01D47E06BBDD3FC03A708D46A6FE219EE08CECB3B58E007FDD
          594F98DF5C0CFA561DC78523D6B5E8F49F045E5EEA0FC8BC7BEB5F296C0FFB6F
          8193D7E5C1E9D4D7357C4E0F10B92AC6EBCD7F4C52A7CCACC6784B49B9F1EF8C
          B4FD366B645B2D3E41757CE8C59481F75391D58F18FAFA57B8DCD9C5E26F1866
          E235934AD250C6C1C65259DB195F7DA31F8D5DF05F83AC3C15A12E9F664CB2B9
          F32E6E5C7CD349DC9F6F41DAB99F1291AE417761A3B88749D2629279E54FB92C
          C324203DCE7249F53F4AF02A429528F2D38E97D109C234E1CA97C893C2D0CB1E
          BF77E1F277DA69B76D3C7BB92A0FDDFF003FED357A2D7987813C43A72DFDFDF6
          A9A9411DF6A322809CE3033C938C0E4E393DABD3EA708A3C8DA7BBFC3A7E05D1
          9270560A28A2BA8D028A28A0028A28A002B99F125B0D435FF0F584C03DAB4D2C
          F221E43144CA83EA326BA6AA773622E350B2BBDD86B62FC63EF065C11F9E0FE1
          5328F32B09ABAB1C4F897C3915D6BB7D7F7BA8A69A218A23A7DC3158E30DC960
          C7A920A83D7233F856469DE28B9D43588A6D66282E52193CB49AD50ACB1103EF
          A38FBCA79C8CF39E9DABD3355D26CB5AB17B3BE856589B9191CA376607B115E2
          9AF6A16BA26B379A45B9F364B6608B2CA005CE01E9DC8CE0F4E45795984AB61E
          D528C6F7DF5FCD0E18752BCD5F4D5DB5D3CCEBF46F89C117ECFAF5B481F71FDF
          469D89E8CBEDED9FA563EB165F0F27D4A7B8D1BC4575E1DD4AE54A4B3E986489
          1F3CFCE31B7DF8C7D6B8B171A86A52C76C567B9773B42420B64F7C281EDD7DAA
          8EB5A45FE9D751FF006845247E62EE8D65508DB73DD7AE3D09F7F435961F1D88
          E5F7D5FCCE8C928431F8C587937669EBB3BAF934FF000F53D062F857E20D2D0A
          5B49E1BD5803912EA16B2A4C4FA9747CE7F1AA707863C517DAD5C584777A2DB5
          D42A1A448F52BE70A0FB6F1F4233DC574977E3E9ACFC1FA4E6D1CDD5FD93A994
          BED31B0F903F439C9E6B8B835B82C62B4B9B66996FA0995CB608DF8EB93DC11C
          1FA9AEAC4E631A338C52BDF7F24735494694E54E6F589BF3FC2BD1B4FB31A878
          C35685AD612A4C56768B6E9BB3C02E0191BFEFAAE9F4DF19781B44D1FC8D1A48
          A2B687A5BDB5BB29FAF207E64D719E3BF16CFE20F066981ED4422E2E1DA5D872
          A0A636AE7D7E607F0AE474ED17543A49BE4B3BA9AD392A628F78E3A9240EBEC6
          9D7C64D7F095F4F3EA7A15B08A9E571C72D5CA565E9E96DF7EA8F4C3E3E6D635
          09A17B19D74BFB3B030C6489247E08CB0FBA0F4EBD09E4D65DB6A977AC13A0DE
          5FE9DA569476C8C113CA017AF96A5B1939EB9EE3A9E878DB7D66EE165F324568
          072C931CE573D891C5771E06B2D27C633DC3DD46CCB66CA4DB4832B2673C9CF5
          5C83C7D2BCDA389C5D6AAA9C9269F9DB4FEBA1E6D1A6ABD37357696FA77EF6FF
          0033A5D27C2D1AF86758D32451259BCB27D89A4552C176F0F9039F9B907DBDEB
          A1F0CCF25CF85F4B9A524C8F6B19627A93B45693463C931A6106DDAB81C0E2A1
          D3ACC69FA65AD9A9DC208963CE319C0C66BDF8C145E83514B62CD14515A14145
          14500145145001451450015E4FA941A2685F17A4BBD6BE5B7B8856E20665CA2C
          A7E5CB7E2A4E7D4FB57AC5791FC67D364F3B4DD515498F6B5BB9C7DD39DCBF9E
          5BF2AE7C4BB43992BDB53D7C912A98AF612938AA89C5B5F7FE68EAE1D0BC9F19
          41E21D1DA0B8B1BA5293AC6E3E4C8FBEA7A119009FC7D6AE3F81F49BBD7A7D67
          5257BFB99181449FFD5C6A3A00BDF1EF9AF9AAC75DD4B4E5FB65ADE496E8493B
          219191F8E0743C9CE3F3ADE8BE2978AF4D2566D527046DE1B6CC304F5CB2F6C7
          35CF0AF4F671EB7F99DFFD81570FCD2A15924FBDD68F5E97B5FD4F69F1B7862D
          EFB4AD475260D25CC56CA205FE18550EE3B40EE79E7F0AF1311EE8D540C93F28
          5F7EFF00CBF5AD23F17BC4FF003C66F3CF237065FB2C6781D4F4E95CC41AF4D6
          BA9C573112C229436E68C1457E080463E95C98B8C6B4D4A1A773CCC4F0AE2A72
          4E338F9EAFFCBEFEC7D19A3782F4FB0D36E2CA74FB459DD0476B59D432C6E170
          483D7FC3152E95E1987C2B0EA2DA3199E39D77C7672382AB20071B58F233C039
          27A57873FC64F14B46596F88F94B2E208B9C1C7A1C7E354AE3E21F89EEA5F26E
          B55BB42C70E125DA3041208DA07A115DDEDE9C5691DBD0EFA39162793D92AB15
          176D3DEB7974B7FC0F23D934BD2746F07787AE4F892E2D0CD763F7C8DF36571F
          714753D4F41DFDAAAFC25D36DA2B2D5B52B6DFE4CF7462803FDE11A7233EFF00
          37E95E1369A9CBA8967BA766B823796624EE07BE4F27D0D7D2DF0F74D934BF04
          E9F0CC9B25915A6652391B89233EF822A70EF9AA72A8D945158BC053CBB2D4A9
          D4E6F68D69B2B2BBDBBDEDA9D3D14515DE7CD851451400514514005145140051
          451400556BFB0B4D4ECA4B3BD8127B7906191C707FC0FBD145034DA7747986AD
          F03B4D9E4965D2EF7C8F3060C73C7BFF00F1E183FA1AC06F819ACABEE5BFB090
          839DD24B264800800FC878E4D145612C3537D0F5696778CA765CC9DBBA4FF1B5
          C823F815E21815441A9E9C8C03296323B1209CFF0073B539BE06F88B7328D4B4
          DF29983B2195FE6231DFCBEF819A28A5F55A7B96B3DC525CAAD6F4FF0083F7F7
          EA20F813AD85DBF6BD3172ACAC5657CB03D8FEEEAD5B7C0CD5327ED3A8D91248
          25F73B9E38FEE8F53F9D1451F55A7D6FF787F6EE2D7C365FF6EAFD4ED3C3FF00
          09B44D1E78AE2EDDB509A2C6C122058D7FE03CE7F124577F4515AC21182B4558
          F3B118AAD89973D6936C28A28AB39C28A28A0028A28A00FFD9}
        Stretch = True
      end
      object Label4: TLabel
        Left = 480
        Top = 109
        Width = 81
        Height = 13
        Caption = 'Emiss'#227'o              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = False
      end
      object lblHomologacao: TLabel
        Left = 219
        Top = 49
        Width = 249
        Height = 20
        Caption = 'Homologa'#231#227'o - sem valor fiscal'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object SMALL_DBEdit43: TSMALL_DBEdit
        Left = 305
        Top = 124
        Width = 170
        Height = 22
        Color = clWhite
        DataField = 'VENDEDOR'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = SMALL_DBEdit43Change
        OnEnter = SMALL_DBEdit43Enter
        OnExit = SMALL_DBEdit43Exit
        OnKeyDown = SMALL_DBEdit40KeyDown
        OnKeyUp = SMALL_DBEdit43KeyUp
      end
      object SMALL_DBEdit39: TSMALL_DBEdit
        Left = 10
        Top = 169
        Width = 465
        Height = 22
        Color = clWhite
        DataField = 'CLIENTE'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnChange = SMALL_DBEdit39Change
        OnEnter = SMALL_DBEdit39Enter
        OnExit = SMALL_DBEdit39Exit
        OnKeyDown = SMALL_DBEdit39KeyDown
        OnKeyUp = SMALL_DBEdit39KeyUp
      end
      object SMALL_DBEdit4: TSMALL_DBEdit
        Left = 480
        Top = 169
        Width = 170
        Height = 22
        Color = clWhite
        DataField = 'CGC'
        DataSource = Form7.DataSource2
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        OnExit = SMALL_DBEdit4Exit
      end
      object SMALL_DBEdit18: TSMALL_DBEdit
        Left = 276
        Top = 354
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'SERVICOS'
        DataSource = Form7.DataSource15
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object SMALL_DBEdit19: TSMALL_DBEdit
        Left = 145
        Top = 354
        Width = 123
        Height = 22
        Color = clWhite
        DataField = 'ISS'
        DataSource = Form7.DataSource15
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
      end
      object SMALL_DBEdit16: TSMALL_DBEdit
        Left = 526
        Top = 354
        Width = 122
        Height = 22
        Color = clWhite
        DataField = 'TOTAL'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 11
        OnKeyDown = SMALL_DBEdit40KeyDown
      end
      object DBGrid4: TDBGrid
        Left = 10
        Top = 215
        Width = 639
        Height = 112
        Color = clWhite
        Ctl3D = False
        DataSource = Form7.DataSource35
        DrawingStyle = gdsClassic
        FixedColor = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgEditing, dgColumnResize, dgColLines, dgTabs, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 4
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'Microsoft Sans Serif'
        TitleFont.Style = []
        OnColEnter = DBGrid4ColEnter
        OnEnter = DBGrid4Enter
        OnKeyDown = DBGrid4KeyDown
        OnKeyPress = DBGrid4KeyPress
      end
      object DBMemo1: TDBMemo
        Left = 10
        Top = 406
        Width = 640
        Height = 75
        DataField = 'COMPLEMENTO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        MaxLength = 32768
        ParentFont = False
        TabOrder = 6
        OnKeyDown = DBMemo1KeyDown
      end
      object SMALL_DBEdit2: TSMALL_DBEdit
        Left = 405
        Top = 354
        Width = 114
        Height = 22
        Color = clWhite
        DataField = 'DESCONTO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnEnter = SMALL_DBEdit2Enter
        OnExit = SMALL_DBEdit2Exit
        OnKeyDown = SMALL_DBEdit40KeyDown
      end
      object SMALL_DBEdit1: TSMALL_DBEdit
        Left = 10
        Top = 353
        Width = 123
        Height = 22
        Color = clWhite
        DataField = 'ISS'
        DataSource = Form7.DataSource14
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
      end
      object SMALL_DBEdit40: TSMALL_DBEdit
        Left = 10
        Top = 124
        Width = 289
        Height = 22
        Color = clWhite
        DataField = 'OPERACAO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = SMALL_DBEdit40Change
        OnEnter = SMALL_DBEdit40Enter
        OnExit = SMALL_DBEdit40Exit
        OnKeyDown = SMALL_DBEdit40KeyDown
        OnKeyUp = SMALL_DBEdit40KeyUp
      end
      object DBGrid1: TDBGrid
        Left = 10
        Top = 144
        Width = 289
        Height = 5
        Color = 15790320
        DataSource = Form7.DataSource14
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 13
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnCellClick = DBGrid2CellClick
        OnDblClick = DBGrid2DblClick
        OnExit = DBGrid2Exit
        OnKeyDown = DBGrid2KeyDown
        OnKeyPress = DBGrid2KeyPress
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CFOP'
            Visible = True
          end>
      end
      object DBGrid2: TDBGrid
        Left = 10
        Top = 190
        Width = 465
        Height = 5
        Color = 15790320
        DataSource = Form7.DataSource14
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 9
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnCellClick = DBGrid2CellClick
        OnDblClick = DBGrid2DblClick
        OnExit = DBGrid2Exit
        OnKeyDown = DBGrid2KeyDown
        OnKeyPress = DBGrid2KeyPress
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CFOP'
            Visible = True
          end>
      end
      object DBGrid3: TDBGrid
        Left = 10
        Top = 326
        Width = 639
        Height = 5
        Color = 15790320
        DataSource = Form7.DataSource4
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Options = [dgColLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 14
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        Visible = False
        OnDblClick = DBGrid3DblClick
        OnKeyPress = DBGrid3KeyPress
        Columns = <
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            Width = 548
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECO'
            Width = 70
            Visible = True
          end>
      end
      object SMALL_DBEdit3: TSMALL_DBEdit
        Left = 480
        Top = 124
        Width = 170
        Height = 22
        Color = clWhite
        DataField = 'EMISSAO'
        DataSource = Form7.DataSource15
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnEnter = SMALL_DBEdit3Enter
        OnKeyDown = SMALL_DBEdit40KeyDown
        OnKeyUp = SMALL_DBEdit43KeyUp
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 540
      Width = 675
      Height = 40
      BevelOuter = bvNone
      Color = clWhite
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object Button1: TBitBtn
        Left = 570
        Top = 4
        Width = 100
        Height = 30
        Caption = 'OK'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button1Click
        OnEnter = Button1Enter
      end
      object Button3: TBitBtn
        Left = 460
        Top = 4
        Width = 100
        Height = 30
        Caption = 'Pr'#243'xima >'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button3Click
        OnEnter = Button1Enter
      end
    end
    object CheckBox1: TCheckBox
      Left = 17
      Top = 520
      Width = 217
      Height = 17
      Caption = 'Reten'#231#227'o do ISS'
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 17
      Top = 544
      Width = 217
      Height = 17
      Caption = 'Reten'#231#227'o dos impostos federais'
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      OnClick = CheckBox2Click
    end
  end
  object PopupMenu3: TPopupMenu
    AutoHotkeys = maManual
    Left = 680
    Top = 6
    object ImportarOS2: TMenuItem
      Caption = 'Importar Ordem de Servi'#231'o...'
      OnClick = ImportarOS2Click
    end
    object Importaroramentos1: TMenuItem
      Caption = 'Importar Or'#231'amento...'
      OnClick = Importaroramentos1Click
    end
  end
end
