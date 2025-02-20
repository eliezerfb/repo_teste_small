object FrmQRCodePixDin: TFrmQRCodePixDin
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'QR Code para PIX'
  ClientHeight = 390
  ClientWidth = 394
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    394
    390)
  TextHeight = 15
  object lblValor: TLabel
    Left = 0
    Top = 35
    Width = 393
    Height = 33
    Align = alCustom
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 0
    Top = 69
    Width = 393
    Height = 18
    Align = alCustom
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Fa'#231'a a leitura do QR Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object imgQrCode: TImage
    Left = 77
    Top = 95
    Width = 241
    Height = 224
    Stretch = True
  end
  object imgLogo: TImage
    Left = 170
    Top = 0
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
  object btnCancel: TBitBtn
    Left = 275
    Top = 346
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnImprimir: TBitBtn
    Left = 170
    Top = 346
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Imprimir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnImprimirClick
  end
  object tmrConsultaPgto: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrConsultaPgtoTimer
    Left = 164
    Top = 112
  end
end
