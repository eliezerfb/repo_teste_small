unit uSelecionaTEF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.IniFiles;

type
  TConfigTEF = class
  private
    FcCaminho: String;
    FcExec: String;
    FcResp: String;
    FcNomeTEF: String;
    FcReq: String;
  public
    constructor Create(AcNomeTEF: String; AoArqIni: TIniFile);
    property Nome: String read FcNomeTEF;
    property Caminho: String read FcCaminho;
    property Req: String read FcReq;
    property Resp: String read FcResp;
    property Exec: String read FcExec;
  end;

  TfrmSelecionaTEF = class(TFrmPadrao)
    lbxTEFs: TListBox;
    pnlRodape: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxTEFsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FoIni: TIniFile;
    FoConfigTEFSelecionado: TConfigTEF;

    procedure CarregaTEFsAtivos;
    procedure DefineValoresTEFSelecionado;
  public
    property ConfigTEFSelecionado: TConfigTEF read FoConfigTEFSelecionado;
    procedure ChamarTela;
  end;

var
  frmSelecionaTEF: TfrmSelecionaTEF;

implementation

{$R *.dfm}

uses
  uSmallConsts, uDialogs;

procedure TfrmSelecionaTEF.FormCreate(Sender: TObject);
begin
  inherited;
  FoIni := TIniFile.Create('FRENTE.INI');

  CarregaTEFsAtivos;
end;

procedure TfrmSelecionaTEF.FormDestroy(Sender: TObject);
begin
  FoIni.Free;
  inherited;
end;

procedure TfrmSelecionaTEF.FormShow(Sender: TObject);
begin
  inherited;
  if lbxTEFs.Items.Count > 1 then
    lbxTEFs.SetFocus;
end;

procedure TfrmSelecionaTEF.lbxTEFsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: btnOKClick(Self);
  end;
end;

procedure TfrmSelecionaTEF.DefineValoresTEFSelecionado;
begin
  if lbxTEFs.ItemIndex < 0 then
    Exit;

  FoConfigTEFSelecionado := TConfigTEF.Create(lbxTEFs.Items[lbxTEFs.ItemIndex], FoIni);
end;

procedure TfrmSelecionaTEF.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSelecionaTEF.btnOKClick(Sender: TObject);
begin
  DefineValoresTEFSelecionado;

  Self.Close;
end;

procedure TfrmSelecionaTEF.CarregaTEFsAtivos;
var
  slSecoes : TStringList;
  i: Integer;
begin
  slSecoes  := TStringList.Create;
  try
    slSecoes.Clear;
    FoIni.ReadSections(slSecoes);

    lbxTEFs.Clear;
    for i := 0 to Pred(slSecoes.Count) do
    begin
      if AnsiUpperCase(FoIni.ReadString(slSecoes[i], 'bAtivo', _cNao)) = AnsiUpperCase(_cSim) then
        lbxTEFs.Items.Add(slSecoes[i]);
    end;
  finally
    FreeAndNil(slSecoes);
  end;
end;

procedure TfrmSelecionaTEF.ChamarTela;
begin
  if lbxTEFs.Count <= 0 then
  begin
    uDialogs.MensagemSistema('Não foi encontrado nenhum TEF ativo configurado.' + sLineBreak +
                            'Verifique a configuração de TEF.', msgInformacao);
    Self.Close;
    Exit;
  end;

  lbxTEFs.ItemIndex := 0;

  // Se possui 1 TEF já seleciona automaticamente
  if lbxTEFs.Count = 1 then
    DefineValoresTEFSelecionado
  else
    Self.ShowModal;
end;

{ TConfigTEF }

constructor TConfigTEF.Create(AcNomeTEF: String; AoArqIni: TIniFile);
begin
  FcNomeTEF := AcNomeTEF;
  FcCaminho := Trim(AoArqIni.ReadString(AcNomeTEF, 'Pasta', EmptyStr));
  FcReq     := Trim(AoArqIni.ReadString(AcNomeTEF,'Req','REQ'));
  FcResp    := Trim(AoArqIni.ReadString(AcNomeTEF,'Resp','RESP'));
  FcExec    := Trim(AoArqIni.ReadString(AcNomeTEF,'Exec','XXX.XXX'));
end;

end.
