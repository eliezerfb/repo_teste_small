object framePesquisaPadrao: TframePesquisaPadrao
  Left = 0
  Top = 0
  Width = 820
  Height = 146
  TabOrder = 0
  PixelsPerInch = 96
  object pnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 146
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgItensPesq: TDBGrid
      Left = 0
      Top = 0
      Width = 820
      Height = 146
      TabStop = False
      Align = alClient
      Color = 15790320
      DrawingStyle = gdsClassic
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Options = [dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -12
      TitleFont.Name = 'Fixedsys'
      TitleFont.Style = []
      OnKeyDown = dbgItensPesqKeyDown
    end
  end
end
