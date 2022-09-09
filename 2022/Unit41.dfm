object Form41: TForm41
  Left = 428
  Top = 335
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Importar '
  ClientHeight = 222
  ClientWidth = 452
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 452
    Height = 222
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Image1: TImage
      Left = 15
      Top = 15
      Width = 118
      Height = 148
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Panel3: TPanel
      Left = 200
      Top = 16
      Width = 249
      Height = 145
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object Label5: TLabel
        Left = 10
        Top = 4
        Width = 169
        Height = 13
        Caption = 'Digite o n'#250'mero e clique <Avan'#231'ar>'
      end
      object Label6: TLabel
        Left = 10
        Top = 20
        Width = 64
        Height = 13
        Caption = 'para importar.'
      end
      object Label7: TLabel
        Left = 25
        Top = 55
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'N'#250'mero:'
      end
      object Label8: TLabel
        Left = 36
        Top = 90
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Caixa:'
      end
      object MaskEdit1: TMaskEdit
        Left = 72
        Top = 55
        Width = 120
        Height = 22
        AutoSize = False
        EditMask = '9999999999;1; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 10
        ParentFont = False
        TabOrder = 0
        Text = '          '
        OnExit = MaskEdit1Exit
        OnKeyDown = MaskEdit1KeyDown
      end
      object MaskEdit2: TMaskEdit
        Left = 72
        Top = 90
        Width = 64
        Height = 22
        EditMask = '999;1; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 3
        ParentFont = False
        TabOrder = 1
        Text = '001'
        OnExit = MaskEdit2Exit
        OnKeyDown = MaskEdit1KeyDown
      end
    end
    object Button3: TButton
      Left = 100
      Top = 180
      Width = 100
      Height = 25
      Caption = '< Voltar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button1: TButton
      Left = 215
      Top = 180
      Width = 100
      Height = 25
      Caption = 'Avan'#231'ar >'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 330
      Top = 180
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button2Click
    end
  end
end
