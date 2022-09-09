object Form1: TForm1
  Left = 310
  Top = 299
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Discador'
  ClientHeight = 228
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Discar: TPageControl
    Left = 10
    Top = 10
    Width = 300
    Height = 210
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Discar'
      object Label5: TLabel
        Left = 10
        Top = 135
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = 'N'#250'mero'
      end
      object Label4: TLabel
        Left = 10
        Top = 2
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object Edit1: TEdit
        Left = 10
        Top = 150
        Width = 170
        Height = 21
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        Text = '(0xx49)88160670'
      end
      object Button1: TButton
        Left = 190
        Top = 150
        Width = 85
        Height = 20
        Caption = 'Discar >>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button1Click
      end
      object Memo1: TMemo
        Left = 10
        Top = 16
        Width = 270
        Height = 110
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Discagem tipo'
      ImageIndex = 1
      object Label1: TLabel
        Left = 10
        Top = 130
        Width = 115
        Height = 13
        Caption = 'Comando para o modem'
      end
      object RadioButton2: TRadioButton
        Left = 30
        Top = 47
        Width = 100
        Height = 17
        Caption = 'Pulso'
        TabOrder = 0
      end
      object RadioButton1: TRadioButton
        Left = 30
        Top = 26
        Width = 100
        Height = 17
        Caption = 'Tom'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object Edit2: TEdit
        Left = 10
        Top = 150
        Width = 170
        Height = 21
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        Text = 'ATDT1170,'
      end
      object Button2: TButton
        Left = 190
        Top = 150
        Width = 85
        Height = 20
        Caption = 'Enviar >>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Porta'
      ImageIndex = 2
      object ComboBox1: TComboBox
        Left = 20
        Top = 32
        Width = 73
        Height = 21
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        Text = 'COM3'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4')
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Obter linha'
      ImageIndex = 3
      object Label2: TLabel
        Left = 20
        Top = 16
        Width = 58
        Height = 13
        Alignment = taRightJustify
        Caption = 'Linha Local:'
      end
      object Edit3: TEdit
        Left = 88
        Top = 16
        Width = 121
        Height = 21
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Operadora'
      ImageIndex = 4
      object Label6: TLabel
        Left = 19
        Top = 20
        Width = 99
        Height = 13
        Alignment = taRightJustify
        Caption = 'C'#243'digo da operadora'
      end
      object Label7: TLabel
        Left = 46
        Top = 44
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = 'C'#243'digo de area'
      end
      object Edit6: TEdit
        Left = 128
        Top = 20
        Width = 121
        Height = 21
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        Text = '21'
      end
      object Edit5: TEdit
        Left = 128
        Top = 44
        Width = 121
        Height = 21
        Color = clBlack
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        Text = '049'
      end
    end
  end
end
