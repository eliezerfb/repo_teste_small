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
    ExplicitWidth = 1008
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
  object ComboBox5: TComboBox
    Left = 483
    Top = 131
    Width = 202
    Height = 21
    TabOrder = 19
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
  object ComboBox6: TComboBox
    Left = 483
    Top = 156
    Width = 202
    Height = 21
    TabOrder = 20
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
  object ComboBox7: TComboBox
    Left = 483
    Top = 181
    Width = 202
    Height = 21
    TabOrder = 21
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
  object ComboBox8: TComboBox
    Left = 483
    Top = 206
    Width = 202
    Height = 21
    TabOrder = 22
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
  object ComboBox9: TComboBox
    Left = 483
    Top = 230
    Width = 202
    Height = 21
    TabOrder = 23
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
  object ComboBox10: TComboBox
    Left = 483
    Top = 255
    Width = 202
    Height = 21
    TabOrder = 24
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
  object ComboBox11: TComboBox
    Left = 483
    Top = 280
    Width = 202
    Height = 21
    TabOrder = 25
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
  object ComboBox12: TComboBox
    Left = 483
    Top = 305
    Width = 202
    Height = 21
    TabOrder = 26
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
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 28
    Visible = False
  end
  object chkReceberExtra2: TCheckBox
    Left = 691
    Top = 157
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 29
    Visible = False
  end
  object chkReceberExtra3: TCheckBox
    Left = 691
    Top = 182
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 30
    Visible = False
  end
  object chkReceberExtra4: TCheckBox
    Left = 691
    Top = 207
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 31
    Visible = False
  end
  object chkReceberExtra5: TCheckBox
    Left = 691
    Top = 229
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 32
    Visible = False
  end
  object chkReceberExtra6: TCheckBox
    Left = 691
    Top = 256
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 33
    Visible = False
  end
  object chkReceberExtra7: TCheckBox
    Left = 691
    Top = 282
    Width = 137
    Height = 17
    Caption = 'Lan'#231'a Contas Receber'
    TabOrder = 34
    Visible = False
  end
  object chkReceberExtra8: TCheckBox
    Left = 691
    Top = 306
    Width = 137
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
end
