object Form1: TForm1
  Left = 225
  Top = 106
  BorderStyle = bsDialog
  Caption = 'C'#243'pia de Seguran'#231'a'
  ClientHeight = 428
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 533
    Height = 404
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'C'#243'pia'
      object Label2: TLabel
        Left = 397
        Top = 72
        Width = 76
        Height = 13
        Caption = 'T'#237'tulo da C'#243'pia:'
      end
      object FileListBox: TListBox
        Left = 0
        Top = 0
        Width = 391
        Height = 376
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
      end
      object Button1: TButton
        Left = 397
        Top = 2
        Width = 124
        Height = 20
        Caption = 'Adiciona Arquivos'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 401
        Top = 323
        Width = 117
        Height = 21
        Caption = 'Cria Arquivo !'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button4: TButton
        Left = 397
        Top = 24
        Width = 124
        Height = 21
        Caption = 'Adiciona c/coringas'
        TabOrder = 3
        OnClick = Button4Click
      end
      object rgBackupMode: TRadioGroup
        Left = 397
        Top = 117
        Width = 124
        Height = 46
        Caption = 'Modo da C'#243'pia'
        ItemIndex = 0
        Items.Strings = (
          'Total'
          'Incremental')
        TabOrder = 4
      end
      object EdBackupTitle: TEdit
        Left = 397
        Top = 88
        Width = 124
        Height = 21
        TabOrder = 5
        Text = 'MinhaCopia'
      end
      object BtnCancel: TButton
        Left = 401
        Top = 349
        Width = 117
        Height = 21
        Caption = 'Cancela'
        TabOrder = 6
        OnClick = BtnCancelClick
      end
      object Button5: TButton
        Left = 396
        Top = 47
        Width = 124
        Height = 20
        Caption = 'Apaga Arquivos'
        TabOrder = 7
        OnClick = Button5Click
      end
      object rgCompressionLevel: TRadioGroup
        Left = 397
        Top = 166
        Width = 124
        Height = 79
        Caption = 'N'#237'vel de Compress'#227'o'
        ItemIndex = 0
        Items.Strings = (
          'R'#225'pido'
          'Sem '
          'Padr'#227'o'
          'M'#225'ximo')
        TabOrder = 8
      end
      object CbSaveFileID: TCheckBox
        Left = 403
        Top = 247
        Width = 118
        Height = 14
        Caption = 'Salvar ID Arquivo'
        TabOrder = 9
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Restaura'
      object Label3: TLabel
        Left = 254
        Top = 10
        Width = 84
        Height = 13
        Caption = 'T'#237'tulo do arquivo:'
      end
      object Label4: TLabel
        Left = 254
        Top = 49
        Width = 49
        Height = 13
        Caption = 'Conte'#250'do:'
      end
      object Button3: TButton
        Left = 254
        Top = 349
        Width = 134
        Height = 21
        Caption = 'Restaura !'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button6: TButton
        Left = 397
        Top = 349
        Width = 124
        Height = 21
        Caption = 'Cancela'
        TabOrder = 1
        OnClick = BtnCancelClick
      end
      object FileListBox1: TFileListBox
        Left = 7
        Top = 247
        Width = 234
        Height = 128
        ItemHeight = 13
        Mask = '*.bck'
        TabOrder = 2
        OnClick = FileListBox1Click
      end
      object DriveComboBox1: TDriveComboBox
        Left = 7
        Top = 10
        Width = 234
        Height = 19
        DirList = DirectoryListBox1
        TabOrder = 3
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 7
        Top = 33
        Width = 234
        Height = 205
        FileList = FileListBox1
        ItemHeight = 16
        TabOrder = 4
      end
      object Edit2: TEdit
        Left = 254
        Top = 26
        Width = 267
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 5
      end
      object rgRestoreMode: TRadioGroup
        Left = 254
        Top = 176
        Width = 267
        Height = 69
        Caption = 'Modo de Restaura'#231#227'o'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Total'
          'N'#227'o Sobrescrever'
          'Novos'
          'Sobrescrever'
          'Recentes')
        TabOrder = 6
      end
      object gbRestorepath: TGroupBox
        Left = 254
        Top = 247
        Width = 267
        Height = 95
        Caption = 'Restore path'
        TabOrder = 7
        object rbOrigpath: TRadioButton
          Left = 7
          Top = 20
          Width = 251
          Height = 13
          Caption = 'Caminho original (sobrep'#245'e arquivos originais)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbOrigpathClick
        end
        object rbOtherPath: TRadioButton
          Left = 7
          Top = 39
          Width = 91
          Height = 14
          Caption = 'Outro caminho:'
          TabOrder = 1
          OnClick = rbOrigpathClick
        end
        object EdPath: TEdit
          Left = 20
          Top = 55
          Width = 238
          Height = 21
          Enabled = False
          TabOrder = 2
        end
        object CbFullPath: TCheckBox
          Left = 20
          Top = 78
          Width = 192
          Height = 14
          Caption = 'Restaura todo o caminho'
          Enabled = False
          TabOrder = 3
        end
      end
      object Edit1: TEdit
        Left = 254
        Top = 65
        Width = 267
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 8
      end
      object MeFiles: TMemo
        Left = 254
        Top = 85
        Width = 267
        Height = 88
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 9
        WantTabs = True
        WordWrap = False
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 404
    Width = 533
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 8
      Width = 246
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      WordWrap = True
    end
    object Image1: TImage
      Left = 512
      Top = 5
      Width = 18
      Height = 18
      Picture.Data = {
        07544269746D6170AA030000424DAA0300000000000036000000280000001100
        000011000000010018000000000074030000CE0E0000D80E0000000000000000
        0000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBF809080305830104810004000104810305830708870BFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBF2F602F00400000500000
        68000068000068000048000040002F582FBFBFBFBFBFBFBFBFBFBFBFBF00BFBF
        BFBFBFBFBFBFBF10601000780000880000880000800000780000700000680000
        6800005000104810BFBFBFBFBFBFBFBFBF00BFBFBFBFBFBF2F782F00900000A0
        000FA00F0FA00F0F980F0090000088000078000070000068000050002F502FBF
        BFBFBFBFBF00BFBFBF80A08000900010B81010B81010B8101FB81F10B01010A8
        100FA00F009000008000007000006800004000809080BFBFBF00BFBFBF309830
        0FC70F10CF1020CF201FD71F20CF2020CF201FC71F1FB81F10A8100F980F0088
        00007000005000305830BFBFBF00BFBFBF1FA81F1FD71F20DF202FE72F30DF30
        30E73030DF302FD72F20CF201FB81F10A8100F980F008000007000104810BFBF
        BF00BFBFBF10CF101FDF1F2FEF2F3FEF3F40EF4040EF4040EF403FE73F30DF30
        2FD72F1FC71F10A8100F980F008000004800BFBFBF00BFBFBF20DF202FF72F40
        EF404FFF4F50FF505FF75F50F7504FEF4F40EF4030DF3020CF201FB81F0FA00F
        008800105010BFBFBF00BFBFBF3FE73F2FFF2F40FF4050FF506FFF6F70FF706F
        FF6F5FF75F4FEF4F3FE73F2FD72F1FC71F10B010007800306830BFBFBF00BFBF
        BF80D7802FFF2F4FFF4F60FF608FFF8FAFFFAF90FF906FFF6F50F75040EF4030
        E73020CF2010B810006800709870BFBFBF00BFBFBFBFBFBF40EF4040FF4060FF
        608FFF8FAFFFAF9FFF9F70FF705FFF5F40F74030E73020DF2010B0102F882FBF
        BFBFBFBFBF00BFBFBFBFBFBFBFBFBF3FF73F50FF506FFF6F70FF7070FF7060FF
        6050FF5040F7402FEF2F1FD71F1F981FBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBF
        BFBFBFBFBFBF4FEF4F40FF405FFF5F5FFF5F50FF5040FF4030FF301FDF1F30B8
        30BFBFBFBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF8FDF8F
        4FEF4F3FF73F30FF3030FF303FE73F80C780BFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00}
    end
    object Image2: TImage
      Left = 512
      Top = 5
      Width = 18
      Height = 18
      Picture.Data = {
        07544269746D6170AA030000424DAA0300000000000036000000280000001100
        000011000000010018000000000074030000CE0E0000D80E0000000000000000
        0000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBF70789030375F0F0F4000074010174F30375F707890BFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBF2F2F5F00004000005000
        006000006000005F0000500000402F2F5FBFBFBFBFBFBFBFBFBFBFBFBF00BFBF
        BFBFBFBFBFBFBF10175F00076F00079000079000079000078000076F00006F00
        006000005F10174FBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBF2F2F7000079F0F0F
        AF0007A00007A00007A000079F00079000078000076F00006F00005F2F2F50BF
        BFBFBFBFBF00BFBFBF70789F0007900F0FBF0F0FBF0F0FBF0F0FBF0F0FBF0F0F
        AF0F0FAF00079F00079000076F00006F000040707890BFBFBF00BFBFBF30379F
        1017BF1017CF1F1FCF1F1FCF1F1FCF1F1FCF1017BF1017BF0F0FB00007A00007
        9000078000005030375FBFBFBF00BFBFBF1F1FAF1017D02027D02027DF3037E0
        3037E02F2FDF2027D01F1FCF1017BF0F0FB00007A000079000076F10174FBFBF
        BF00BFBFBF1017BF1F1FE03037EF3037EF3F40E03F40E03F40E03037E02F2FDF
        2027D01017BF0F0FB000079F00078000074FBFBFBF00BFBFBF2027D02F2FEF3F
        40EF4048F04F50FF5058F04F50F04048EF3F40E02F2FDF1F1FCF1017BF0F0FAF
        000790101750BFBFBF00BFBFBF3F40E02F2FFF4048F05058FF6F70FF6F70FF60
        68FF5058FF4F50F03F40E02F2FDF1F1FCF0F0FB000078030376FBFBFBF00BFBF
        BF7078CF2F2FFF4F50FF6068FF8F88FFAFA8FF8F88FF6068FF5058F04048EF30
        37E01F1FD01017BF00076F70789FBFBFBF00BFBFBFBFBFBF4048F04048F06068
        FF8F88FFAFA8FF9F98FF6F70FF5058FF4048F03037E02027D00F0FB02F2F8FBF
        BFBFBFBFBF00BFBFBFBFBFBFBFBFBF3F40FF5058FF6F70FF8080FF7078FF6068
        FF5058FF4048F03037EF1F1FD01F1FA0BFBFBFBFBFBFBFBFBF00BFBFBFBFBFBF
        BFBFBFBFBFBF4F50F04F50FF5F60FF5F60FF5058FF4F50FF3037F01F1FE03037
        BFBFBFBFBFBFBFBFBFBFBFBFBF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF8080DF
        4F50F04048F03F40FF3037F04048E07078CFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BF00BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00}
    end
    object ProgressBar1: TProgressBar
      Left = 265
      Top = 4
      Width = 240
      Height = 18
      TabOrder = 0
    end
    object StaticText1: TStaticText
      Left = 8
      Top = 4
      Width = 249
      Height = 18
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 1
    end
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect]
    Left = 212
    Top = 36
  end
  object Backupfile1: TBackupFile
    Version = '5.10'
    BackupMode = bmIncremental
    CompressionLevel = clFastest
    RestoreMode = rmAll
    MaxSize = 0
    SetArchiveFlag = True
    OnProgress = Backupfile1Progress
    OnNeedDisk = Backupfile1NeedDisk
    OnError = Backupfile1Error
    RestoreFullPath = False
    SaveFileID = False
    Left = 168
    Top = 36
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'bck'
    Filter = 'Backup archives (*.bck)|*.bck'
    Left = 248
    Top = 35
  end
end
