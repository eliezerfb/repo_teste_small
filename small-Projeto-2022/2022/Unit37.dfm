object Form37: TForm37
  Left = 1443
  Top = 397
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Relat'#243'rio de comiss'#245'es'
  ClientHeight = 280
  ClientWidth = 518
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitWidth = 452
    ExplicitHeight = 242
    object Image1: TImage
      Left = 25
      Top = 25
      Width = 140
      Height = 104
      AutoSize = True
      Center = True
      Transparent = True
    end
    object Label1: TLabel
      Left = 180
      Top = 15
      Width = 49
      Height = 13
      Caption = 'Vendedor:'
    end
    object Label2: TLabel
      Left = 180
      Top = 35
      Width = 53
      Height = 13
      Caption = 'Per'#237'odo de'
    end
    object Label3: TLabel
      Left = 180
      Top = 75
      Width = 16
      Height = 13
      Caption = 'At'#233
    end
    object Button1: TButton
      Left = 295
      Top = 237
      Width = 100
      Height = 24
      Caption = 'Gerar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 399
      Top = 237
      Width = 100
      Height = 24
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 180
      Top = 50
      Width = 212
      Height = 20
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 2
    end
    object DateTimePicker2: TDateTimePicker
      Left = 180
      Top = 90
      Width = 212
      Height = 20
      Date = 35796.000000000000000000
      Time = 0.376154398101789400
      DateFormat = dfLong
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 180
      Top = 120
      Width = 177
      Height = 17
      Caption = 'Discriminado item por item'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CheckBox2: TCheckBox
      Left = 180
      Top = 145
      Width = 177
      Height = 17
      Caption = 'Do que foi recebido'
      TabOrder = 5
    end
    object Panel3: TPanel
      Left = 180
      Top = 15
      Width = 241
      Height = 167
      BevelOuter = bvNone
      Caption = ' '
      Color = clWhite
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 6
      Visible = False
      object Edit1: TEdit
        Left = 0
        Top = 3
        Width = 230
        Height = 19
        BevelInner = bvNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = Edit1Change
        OnKeyDown = Edit1KeyDown
      end
      object DBGrid3: TDBGrid
        Left = 0
        Top = 20
        Width = 230
        Height = 133
        Ctl3D = False
        DataSource = Form7.DataSource29
        DrawingStyle = gdsClassic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Fixedsys'
        TitleFont.Style = []
        OnCellClick = DBGrid3CellClick
        OnKeyDown = DBGrid3KeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'NOME'
            Visible = True
          end>
      end
    end
  end
end
