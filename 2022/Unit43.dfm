object Form43: TForm43
  Left = 290
  Top = 133
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Plano de contas'
  ClientHeight = 282
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000033333333000000000000000000000033333303333300000000
    00000000000337777803333333000000000000000003FFF80000033333300000
    00000000003FFFF00F0F00733330000000000000003FFFFFFF0F007773330000
    00000000003FFFF7000008777733000000000000003FFFF000007F7777330000
    00000000003FFFF00F0FFFF777330FFFFFFFFFFFFFF3FFF00F0F00FF77300FFF
    FFFFFFFFFFF3FFF7000088FFFF300FFFFFFFFFFF33FF3FFFFF0FFFFFF3300FFF
    FFF0FFFF333FF3FFFFFFFFFF33000FFFFFF708FFF333F077FFFFFF3300000FFF
    FFFF8788FF33300F3F3F370000000FFFFFFF78B30FF33000F3F3F00000000FFF
    FFFFF3BB30FF30003F3F330000000FFFFFFFFF3BB30FF003F3F3F30000000FFF
    FFFFFFF3BB30F0883FFF3F0000000FFFFFFFFFFF3BB300F883FFFFF000000FFF
    FFFFFFFFF3BB30FF883303FF00000FFFFFFFFFFFFF3BB300F880033330000FFF
    FFFFFFFFFFF3BB300000000300000FFFFFFFFFFFFFFF3BB30000000000000FFF
    FFFFFFFFFFFFF3BB3000000000000FFFFFFFFFFFFFFFF03BB800000000000FFF
    FFFFFFFFFFFFF003BB80000000000FFFFFFFFFFFFFFFF0003BB8000000000FFF
    FFFFFFFFFFFFF00003B9100000000FFFFFFFFFFFFFFFF0000019910000000FFF
    FFFFFFFFFFFFF00000019910000000000000000000000000000019000000FFFF
    C03FFFFF000FFFFE0003FFFE0001FFFC0001FFFC0000FFFC0000FFFC00000000
    0000000000010000000100000001000000030000000F0000203F0000307F0000
    303F0000203F0000003F0000001F0000008F0000118700000FEF000007FF0000
    03FF000001FF000020FF0000307F0000383F00003C1F00003E1F00003F3F}
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 263
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      263
      282)
    object Label2: TLabel
      Left = 10
      Top = 13
      Width = 209
      Height = 13
      Caption = 'Selecione a conta a que este valor deve ser'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 10
      Top = 28
      Width = 139
      Height = 13
      Caption = 'atribu'#237'do no plano de contas.'
    end
    object DBGrid1: TDBGrid
      Left = 10
      Top = 71
      Width = 240
      Height = 130
      Anchors = [akLeft, akTop, akRight]
      DataSource = Form7.DataSource12
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Options = [dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -12
      TitleFont.Name = 'Fixedsys'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      OnDblClick = DBGrid1DblClick
      OnKeyUp = DBGrid1KeyUp
      Columns = <
        item
          Expanded = False
          FieldName = 'NOME'
          Visible = True
        end>
    end
    object Button4: TBitBtn
      Left = 150
      Top = 240
      Width = 100
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button4Click
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 208
      Width = 240
      Height = 17
      Caption = 'Usar sempre esta conta para venda a vista '
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 10
      Top = 50
      Width = 240
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = Edit1Change
      OnKeyUp = Edit1KeyUp
    end
  end
end
