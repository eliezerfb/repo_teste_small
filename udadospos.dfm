object FDadosPOS: TFDadosPOS
  Left = 179
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FDadosPOS'
  ClientHeight = 741
  ClientWidth = 1008
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 20
    Top = 36
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'C'#243'digo da Autoriza'#231#227'o'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 20
    Top = 5
    Width = 1024
    Height = 19
    AutoSize = False
    Caption = 'Informe os dados da transa'#231#227'o com o POS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 20
    Top = 107
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'C'#243'digo do Pagamento'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 20
    Top = 178
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'N'#250'mero de Aprova'#231#227'o'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 20
    Top = 249
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'Bandeira'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 20
    Top = 321
    Width = 1024
    Height = 14
    AutoSize = False
    Caption = 'Adquirente'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 20
    Top = 56
    Width = 981
    Height = 39
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Button1: TBitBtn
    Left = 342
    Top = 386
    Width = 100
    Height = 40
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 2
    Top = 431
    Width = 1008
    Height = 312
    BevelOuter = bvNone
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 7
    inline Frame_teclado1: TFrame_teclado
      Left = -5
      Top = 0
      Width = 1018
      Height = 301
      TabOrder = 0
      inherited PAnel1: TPanel
        inherited Image4: TImage
          Picture.Data = {00}
        end
      end
    end
  end
  object Edit2: TEdit
    Left = 20
    Top = 127
    Width = 981
    Height = 39
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnKeyDown = Edit1KeyDown
  end
  object Edit3: TEdit
    Left = 20
    Top = 198
    Width = 981
    Height = 39
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    OnKeyDown = Edit1KeyDown
  end
  object Edit4: TEdit
    Left = 20
    Top = 269
    Width = 981
    Height = 39
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    OnKeyDown = Edit1KeyDown
  end
  object Edit5: TEdit
    Left = 20
    Top = 341
    Width = 981
    Height = 39
    Color = clWhite
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    OnKeyDown = Edit1KeyDown
  end
  object BitBtn1: TBitBtn
    Left = 534
    Top = 386
    Width = 100
    Height = 40
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BitBtn1Click
  end
end
