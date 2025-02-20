object Form3: TForm3
  Left = 350
  Top = 69
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Refor'#231'o de caixa'
  ClientHeight = 501
  ClientWidth = 268
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 17
    Top = 65
    Width = 69
    Height = 13
    Caption = 'Valor em R$'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 17
    Top = 45
    Width = 57
    Height = 13
    Caption = 'continuar.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 224
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Label3'
    Visible = False
  end
  object Label2: TLabel
    Left = 17
    Top = 29
    Width = 177
    Height = 13
    Caption = 'caixa e clique  <Avan'#231'ar> para'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 17
    Top = 13
    Width = 165
    Height = 13
    Caption = 'Informe o valor do refor'#231'o de'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 17
    Top = -1
    Width = 233
    Height = 65
    AutoSize = False
    Caption = 
      'Informe o valor do refor'#231'o de caixa e clique  <Avan'#231'ar> para con' +
      'tinuar.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 207
    Width = 514
    Height = 305
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    inline Frame_teclado1: TFrame_teclado
      Left = 0
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      ExplicitHeight = 301
      inherited PAnel1: TPanel
        Left = -758
        Top = 5
        ExplicitLeft = -758
        ExplicitTop = 5
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object SMALL_DBEdit1: TSMALL_DBEdit
    Left = 16
    Top = 88
    Width = 230
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    DataField = 'ACUMULADO1'
    DataSource = Form1.DataSource25
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnKeyPress = SMALL_DBEdit1KeyPress
  end
  object Button1: TBitBtn
    Left = 16
    Top = 147
    Width = 100
    Height = 40
    Caption = '&Avan'#231'ar >'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TBitBtn
    Left = 148
    Top = 147
    Width = 100
    Height = 40
    Caption = '&Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
end
