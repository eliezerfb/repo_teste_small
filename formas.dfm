object FormasP: TFormasP
  Left = 235
  Top = 34
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Formas de pagamento'
  ClientHeight = 729
  ClientWidth = 1062
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 12
    Top = 372
    Width = 100
    Height = 100
    AutoSize = True
    Center = True
    Visible = False
  end
  object Label1: TLabel
    Left = 332
    Top = 15
    Width = 100
    Height = 13
    Caption = 'Forma de pagamento'
  end
  object Label2: TLabel
    Left = 483
    Top = 15
    Width = 67
    Height = 13
    Caption = #205'ndice na ECF'
  end
  object Edit1: TEdit
    Left = 332
    Top = 33
    Width = 140
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 9
    Text = 'Cartao'
  end
  object Edit2: TEdit
    Left = 332
    Top = 57
    Width = 140
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 10
    Text = 'A prazo'
  end
  object Edit3: TEdit
    Left = 332
    Top = 82
    Width = 140
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 11
    Text = 'Cheque'
  end
  object Edit4: TEdit
    Left = 332
    Top = 107
    Width = 140
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 12
    Text = 'Dinheiro'
  end
  object Edit5: TEdit
    Left = 332
    Top = 131
    Width = 140
    Height = 21
    TabOrder = 0
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit6: TEdit
    Left = 332
    Top = 156
    Width = 140
    Height = 21
    TabOrder = 1
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit7: TEdit
    Left = 332
    Top = 181
    Width = 140
    Height = 21
    TabOrder = 2
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit8: TEdit
    Left = 332
    Top = 206
    Width = 140
    Height = 21
    TabOrder = 3
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit9: TEdit
    Left = 332
    Top = 230
    Width = 140
    Height = 21
    TabOrder = 4
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit10: TEdit
    Left = 332
    Top = 255
    Width = 140
    Height = 21
    TabOrder = 5
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit11: TEdit
    Left = 332
    Top = 280
    Width = 140
    Height = 21
    TabOrder = 6
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object Edit12: TEdit
    Left = 332
    Top = 305
    Width = 140
    Height = 21
    TabOrder = 7
    OnExit = Edit5Exit
    OnKeyDown = Edit5KeyDown
  end
  object chkAplicarForma: TCheckBox
    Left = 333
    Top = 333
    Width = 137
    Height = 17
    Caption = 'Aplicar no xml'
    TabOrder = 13
    Visible = False
  end
  object Ok: TBitBtn
    Left = 399
    Top = 367
    Width = 100
    Height = 40
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = OkClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 417
    Width = 1062
    Height = 312
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 14
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      ExplicitLeft = -5
      ExplicitHeight = 301
      inherited PAnel1: TPanel
        Top = 5
        ExplicitTop = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object ComboBox1: TComboBox
    Left = 483
    Top = 33
    Width = 202
    Height = 21
    ItemIndex = 0
    TabOrder = 15
    Text = '1'
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '')
  end
  object ComboBox2: TComboBox
    Left = 483
    Top = 57
    Width = 202
    Height = 21
    ItemIndex = 1
    TabOrder = 16
    Text = '2'
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '')
  end
  object ComboBox3: TComboBox
    Left = 483
    Top = 82
    Width = 202
    Height = 21
    ItemIndex = 2
    TabOrder = 17
    Text = '3'
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object ComboBox4: TComboBox
    Left = 483
    Top = 107
    Width = 202
    Height = 21
    ItemIndex = 3
    TabOrder = 18
    Text = '4'
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma01: TComboBox
    Left = 483
    Top = 131
    Width = 202
    Height = 21
    TabOrder = 19
    OnChange = cboForma01Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma02: TComboBox
    Left = 483
    Top = 156
    Width = 202
    Height = 21
    TabOrder = 20
    OnChange = cboForma02Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma03: TComboBox
    Left = 483
    Top = 181
    Width = 202
    Height = 21
    TabOrder = 21
    OnChange = cboForma03Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma04: TComboBox
    Left = 483
    Top = 206
    Width = 202
    Height = 21
    TabOrder = 22
    OnChange = cboForma04Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma05: TComboBox
    Left = 483
    Top = 230
    Width = 202
    Height = 21
    TabOrder = 23
    OnChange = cboForma05Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma06: TComboBox
    Left = 483
    Top = 255
    Width = 202
    Height = 21
    TabOrder = 24
    OnChange = cboForma06Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma07: TComboBox
    Left = 483
    Top = 280
    Width = 202
    Height = 21
    TabOrder = 25
    OnChange = cboForma07Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cboForma08: TComboBox
    Left = 483
    Top = 305
    Width = 202
    Height = 21
    TabOrder = 26
    OnChange = cboForma08Change
    OnKeyDown = Edit5KeyDown
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object Button1: TBitBtn
    Left = 510
    Top = 367
    Width = 100
    Height = 40
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 27
    OnClick = Button1Click
  end
  object chkReceberExtra1: TCheckBox
    Left = 691
    Top = 133
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 28
    Visible = False
  end
  object chkReceberExtra2: TCheckBox
    Left = 691
    Top = 158
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 29
    Visible = False
  end
  object chkReceberExtra3: TCheckBox
    Left = 691
    Top = 183
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 30
    Visible = False
  end
  object chkReceberExtra4: TCheckBox
    Left = 691
    Top = 208
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 31
    Visible = False
  end
  object chkReceberExtra5: TCheckBox
    Left = 691
    Top = 232
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 32
    Visible = False
  end
  object chkReceberExtra6: TCheckBox
    Left = 691
    Top = 257
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 33
    Visible = False
  end
  object chkReceberExtra7: TCheckBox
    Left = 691
    Top = 282
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 34
    Visible = False
  end
  object chkReceberExtra8: TCheckBox
    Left = 691
    Top = 307
    Width = 127
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 35
    Visible = False
  end
  object chkUsandoTefCarteirasDigitais: TCheckBox
    Left = 483
    Top = 333
    Width = 342
    Height = 17
    Caption = 'Usando TEF para carteiras digitais (TEF  SITEF e PAY&&GO)'
    TabOrder = 36
    Visible = False
  end
  object cboPixExtra1: TComboBox
    Left = 821
    Top = 131
    Width = 79
    Height = 21
    TabOrder = 37
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra2: TComboBox
    Left = 821
    Top = 156
    Width = 79
    Height = 21
    TabOrder = 38
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra3: TComboBox
    Left = 821
    Top = 181
    Width = 79
    Height = 21
    TabOrder = 39
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra4: TComboBox
    Left = 821
    Top = 206
    Width = 79
    Height = 21
    TabOrder = 40
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra5: TComboBox
    Left = 821
    Top = 230
    Width = 79
    Height = 21
    TabOrder = 41
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra6: TComboBox
    Left = 821
    Top = 255
    Width = 79
    Height = 21
    ItemIndex = 2
    TabOrder = 42
    Text = 'PIX Din'#226'mico'
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra7: TComboBox
    Left = 821
    Top = 280
    Width = 79
    Height = 21
    TabOrder = 43
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object cboPixExtra8: TComboBox
    Left = 821
    Top = 305
    Width = 79
    Height = 21
    TabOrder = 44
    Visible = False
    Items.Strings = (
      'PIX Manual'
      'PIX Est'#225'tico'
      'PIX Din'#226'mico')
  end
  object chkAtalhoF6_1: TCheckBox
    Left = 920
    Top = 133
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 45
    Visible = False
    OnClick = chkAtalhoF6_1Click
  end
  object chkAtalhoF6_2: TCheckBox
    Left = 920
    Top = 158
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 46
    Visible = False
    OnClick = chkAtalhoF6_2Click
  end
  object chkAtalhoF6_3: TCheckBox
    Left = 920
    Top = 183
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 47
    Visible = False
    OnClick = chkAtalhoF6_3Click
  end
  object chkAtalhoF6_4: TCheckBox
    Left = 920
    Top = 208
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 48
    Visible = False
    OnClick = chkAtalhoF6_4Click
  end
  object chkAtalhoF6_5: TCheckBox
    Left = 920
    Top = 232
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 49
    Visible = False
    OnClick = chkAtalhoF6_5Click
  end
  object chkAtalhoF6_6: TCheckBox
    Left = 920
    Top = 257
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 50
    Visible = False
    OnClick = chkAtalhoF6_6Click
  end
  object chkAtalhoF6_7: TCheckBox
    Left = 920
    Top = 282
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 51
    Visible = False
    OnClick = chkAtalhoF6_7Click
  end
  object chkAtalhoF6_8: TCheckBox
    Left = 920
    Top = 307
    Width = 142
    Height = 17
    Caption = 'Finaliza'#231#227'o r'#225'pida com F6'
    TabOrder = 52
    Visible = False
    OnClick = chkAtalhoF6_8Click
  end
end
