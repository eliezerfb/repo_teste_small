inherited frmConfiguracaoTEFCommerce: TfrmConfiguracaoTEFCommerce
  BorderIcons = []
  Caption = 'Configura'#231#227'o TEF'
  ClientHeight = 411
  ClientWidth = 998
  Font.Charset = ANSI_CHARSET
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1014
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inline frameConfiguracao: TframeConfiguraTEF
    Left = 0
    Top = 0
    Width = 998
    Height = 411
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 411
    inherited Label5: TLabel
      Width = 97
      Height = 13
      ExplicitWidth = 97
      ExplicitHeight = 13
    end
    inherited Label4: TLabel
      Width = 105
      Height = 13
      ExplicitWidth = 105
      ExplicitHeight = 13
    end
    inherited Label3: TLabel
      Width = 27
      Height = 13
      ExplicitWidth = 27
      ExplicitHeight = 13
    end
    inherited Label2: TLabel
      Width = 28
      Height = 13
      ExplicitWidth = 28
      ExplicitHeight = 13
    end
    inherited Label6: TLabel
      Width = 24
      Height = 13
      ExplicitWidth = 24
      ExplicitHeight = 13
    end
    inherited Label8: TLabel
      Width = 111
      Height = 13
      ExplicitWidth = 111
      ExplicitHeight = 13
    end
    inherited btnOK: TBitBtn
      Left = 392
      Top = 363
      Font.Style = []
      OnClick = frameConfiguracaobtnOKClick
      ExplicitLeft = 392
      ExplicitTop = 363
    end
    inherited dbgTEFs: TDBGrid
      Left = 13
      Top = 21
      Height = 334
      Font.Charset = ANSI_CHARSET
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      ParentFont = False
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Height = -11
      TitleFont.Name = 'Microsoft Sans Serif'
      Columns = <
        item
          Expanded = False
          FieldName = 'ATIVO'
          Title.Caption = 'Ativo'
          Width = 30
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Adquirente'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PASTA'
          Title.Caption = 'Chave de Requisi'#231#227'o'
          Width = 180
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIRETORIOREQ'
          Title.Caption = 'ID do Estabelecimento'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIRETORIORESP'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CAMINHOEXE'
          Title.Caption = 'Gerenciador TEF'
          Width = 301
          Visible = True
        end>
    end
    inherited btnCancelar: TBitBtn
      Left = 499
      Top = 363
      Font.Style = []
      OnClick = frameConfiguraTEF1btnCancelarClick
      ExplicitLeft = 499
      ExplicitTop = 363
    end
    inherited cdsTEFs: TClientDataSet
      inherited cdsTEFsNOME: TStringField
        OnChange = nil
        OnSetText = nil
      end
      inherited cdsTEFsPASTA: TStringField
        OnSetText = nil
      end
      inherited cdsTEFsDIRETORIOREQ: TStringField
        OnSetText = nil
      end
      inherited cdsTEFsDIRETORIORESP: TStringField
        OnSetText = nil
      end
      inherited cdsTEFsCAMINHOEXE: TStringField
        OnSetText = nil
      end
      inherited cdsTEFsATIVO: TStringField
        OnSetText = nil
      end
      inherited cdsTEFsIDNOME: TStringField
        OnSetText = nil
      end
    end
  end
end
