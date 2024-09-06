unit uFrmIntegracaoSicoob;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons, Shellapi,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, uframeCampo, Vcl.DBCtrls, Data.DB, System.Threading,
  Vcl.Mask, IBX.IBCustomDataSet, IBX.IBQuery, Vcl.ComCtrls;

type
  TFrmIntegracaoSicoob = class(TFrmPadrao)
    imgLogo: TImage;
    DSCadastro: TDataSource;
    ibdIntegracaoSicoob: TIBDataSet;
    pnlInicial: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    lblContaBancaria: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    fraContaBancaria: TfFrameCampo;
    pgcSicoob: TPageControl;
    tbsPix: TTabSheet;
    chkAtivo: TDBCheckBox;
    edtCertificado: TEdit;
    Label1: TLabel;
    edtClientID_Pix: TDBEdit;
    ibdIntegracaoSicoobIDCONFIGURACAOSICOOB: TIntegerField;
    ibdIntegracaoSicoobIDBANCO: TIntegerField;
    ibdIntegracaoSicoobHABILITADO: TIBStringField;
    ibdIntegracaoSicoobIDAPIPIX: TIntegerField;
    ibdIntegracaoSicoobCLIENTIDPIX: TIBStringField;
    ibdIntegracaoSicoobCLIENTIDBOLETO: TIBStringField;
    ibdIntegracaoSicoobCERTIFICADO: TWideMemoField;
    ibdIntegracaoSicoobCERTIFICADOSENHA: TIBStringField;
    ibdIntegracaoSicoobNOME: TIBStringField;
    edtSenhaCertificado: TDBEdit;
    btnCadastro: TBitBtn;
    imgProcurar: TImage;
    imgExcluirCad: TImage;
    lblExcluirCad: TLabel;
    OpenDlgCertificado: TOpenDialog;
    ibdIntegracaoSicoobCERTIFICADONOME: TIBStringField;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtUsuarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure fraContaBancariatxtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgProcurarClick(Sender: TObject);
    procedure lblExcluirCadClick(Sender: TObject);
    procedure btnCadastroClick(Sender: TObject);
  private
    procedure AtualizaObjComValorDoBanco;
    procedure GetPaginaAjuda;
    procedure SalvaArquivoBD(dirAnexo: string);
    procedure CarregaValorObjeto;
    procedure ValidaDados;
    procedure ExtraiCertificado;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIntegracaoSicoob: TFrmIntegracaoSicoob;

implementation

{$R *.dfm}

uses
  unit7
  , uFuncoesBancoDados
  , uDialogs
  , smallfunc_xe
  , uFrmTelaProcessamento
  , uChaveCertificado
  , uIntegracaoSicoob
  , uSistema;

procedure TFrmIntegracaoSicoob.btnCadastroClick(Sender: TObject);
var
  id_api_pix : integer;
  Mensagem : string;
  name, identifier, token, pixMerchantName, pixMerchantCity, apiPixCertificate : string;
  qryAux: TIBQuery;
begin
  ValidaDados;
  ExtraiCertificado;

  ibdIntegracaoSicoob.Post;
  ibdIntegracaoSicoob.Edit;

  //Dados Emitente
  try
    qryAux := CriaIBQuery(Form7.IBTransaction1);
    qryAux.SQL.Text := ' Select'+
                       '   NOME,'+
                       '   CGC,'+
                       '   MUNICIPIO'+
                       ' From EMITENTE';
    qryAux.Open;

    name            := qryAux.FieldByName('NOME').AsString;
    identifier      := LimpaNumero(qryAux.FieldByName('CGC').AsString);
    pixMerchantName := qryAux.FieldByName('NOME').AsString;
    pixMerchantCity := qryAux.FieldByName('MUNICIPIO').AsString;
  finally
    FreeAndNil(qryAux);
  end;

  token := TSistema.GetInstance.Serial;
  apiPixCertificate := GetCertificateSicoobPem(Form7.IBTransaction1);

  if RegistraContaSicoob(name,
                         identifier,
                         token,
                         '2',
                         'Pix Sicoob',
                         pixMerchantName,
                         pixMerchantCity,
                         ibdIntegracaoSicoobCLIENTIDPIX.AsString,
                         apiPixCertificate,
                         ibdIntegracaoSicoobCERTIFICADOSENHA.AsString,
                         id_api_pix,
                         Mensagem) then
  begin
    ibdIntegracaoSicoobIDAPIPIX.AsInteger := id_api_pix;

    MensagemSistema('Cadastro realizado com sucesso!');

    CarregaValorObjeto;
  end else
  begin
    MensagemSistema(Mensagem,msgErro);
  end;
end;

procedure TFrmIntegracaoSicoob.btnCancelarClick(Sender: TObject);
begin
  ibdIntegracaoSicoob.Cancel;
  Close;
end;

procedure TFrmIntegracaoSicoob.btnOKClick(Sender: TObject);

begin
  ValidaDados;

  ExtraiCertificado;

  if chkAtivo.Checked then
  begin
    if VarIsNull(ibdIntegracaoSicoobIDAPIPIX.AsVariant) then
    begin
      MensagemSistema('Realize o cadastro da conta antes de continuar!',msgAtencao);
      btnCadastro.SetFocus;
      Exit;
    end;
  end;

  ibdIntegracaoSicoob.Post;
  AgendaCommit(True);
  Close;
end;

procedure TFrmIntegracaoSicoob.edtUsuarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);

  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoSicoob.FormCreate(Sender: TObject);
begin
  ibdIntegracaoSicoob.open;

  if ibdIntegracaoSicoob.isEmpty then
  begin
    ibdIntegracaoSicoob.Insert;
    ibdIntegracaoSicoobIDCONFIGURACAOSICOOB.AsInteger := 1;
    ibdIntegracaoSicoobHABILITADO.AsString := 'S';
    chkAtivo.Visible := False;
  end else
  begin
    ibdIntegracaoSicoob.Edit;
    chkAtivo.Visible := True;
  end;

  edtCertificado.Text := ibdIntegracaoSicoobCERTIFICADONOME.AsString;

  CarregaValorObjeto;
end;

procedure TFrmIntegracaoSicoob.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoSicoob.FormShow(Sender: TObject);
begin
  AtualizaObjComValorDoBanco;

  if fraContaBancaria.txtCampo.CanFocus then
    fraContaBancaria.txtCampo.SetFocus;
end;

procedure TFrmIntegracaoSicoob.fraContaBancariatxtCampoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  fraContaBancaria.txtCampoKeyDown(Sender, Key, Shift);

  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoSicoob.AtualizaObjComValorDoBanco;
begin
  try
    fraContaBancaria.TipoDePesquisa               := tpLocate;
    fraContaBancaria.GravarSomenteTextoEncontrato := True;
    fraContaBancaria.CampoVazioAbrirGridPesquisa  := True;
    fraContaBancaria.CampoCodigo                  := ibdIntegracaoSicoobIDBANCO;
    fraContaBancaria.CampoCodigoPesquisa          := 'IDBANCO';
    fraContaBancaria.sCampoDescricao              := 'NOME';
    fraContaBancaria.sTabela                      := 'BANCOS';
    fraContaBancaria.CarregaDescricaoCodigo;
  except
  end;
end;

procedure TFrmIntegracaoSicoob.GetPaginaAjuda;
begin
  HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('integracao_sicoob.htm')));
end;

procedure TFrmIntegracaoSicoob.imgProcurarClick(Sender: TObject);
begin
  if OpenDlgCertificado.Execute then
  begin
    edtCertificado.Text := OpenDlgCertificado.FileName;
  end;
end;


procedure TFrmIntegracaoSicoob.lblExcluirCadClick(Sender: TObject);
begin
  ibdIntegracaoSicoobIDAPIPIX.Clear;
  ibdIntegracaoSicoobCLIENTIDPIX.Clear;
  ibdIntegracaoSicoobCERTIFICADO.Clear;
  ibdIntegracaoSicoobCERTIFICADOSENHA.Clear;

  CarregaValorObjeto
end;

procedure TFrmIntegracaoSicoob.SalvaArquivoBD(dirAnexo:string);
begin
  try
    TBlobField(ibdIntegracaoSicoobCERTIFICADO).LoadFromFile(dirAnexo);

    ibdIntegracaoSicoobCERTIFICADONOME.AsString := ExtractFileName(dirAnexo);
  except
    MensagemSistema('Erro ao gravar certificado!',msgErro);
  end;
end;

procedure TFrmIntegracaoSicoob.CarregaValorObjeto;
begin
  imgExcluirCad.Visible   := not VarIsNull(ibdIntegracaoSicoobIDAPIPIX.AsVariant);
  lblExcluirCad.Visible   := not VarIsNull(ibdIntegracaoSicoobIDAPIPIX.AsVariant);
  btnCadastro.Enabled     := VarIsNull(ibdIntegracaoSicoobIDAPIPIX.AsVariant);
  edtClientID_Pix.Enabled := VarIsNull(ibdIntegracaoSicoobIDAPIPIX.AsVariant);
end;

procedure TFrmIntegracaoSicoob.ValidaDados;
begin
  if ibdIntegracaoSicoobIDBANCO.AsInteger = 0 then
  begin
    MensagemSistema('O campo Conta Bancária deve ser preenchido!',msgAtencao);
    fraContaBancaria.txtCampo.SetFocus;
    Abort;
  end;

  if (Trim(edtCertificado.Text) = '') and (VarIsNull(ibdIntegracaoSicoobCERTIFICADO.AsVariant)) then
  begin
    MensagemSistema('O campo Certificado Digital deve ser preenchido!',msgAtencao);
    edtCertificado.SetFocus;
    Abort;
  end;

  if Trim(edtSenhaCertificado.Text) = '' then
  begin
    MensagemSistema('O campo Senha do certificado digital deve ser preenchido!',msgAtencao);
    edtSenhaCertificado.SetFocus;
    Abort;
  end;

  if chkAtivo.Checked then
  begin
    if Trim(edtClientID_Pix.Text) = '' then
    begin
      MensagemSistema('O campo Usuário (Client ID) deve ser preenchido!',msgAtencao);
      edtClientID_Pix.SetFocus;
      Abort;
    end;
  end;
end;

procedure TFrmIntegracaoSicoob.ExtraiCertificado;
var
  sDirArquivo : string;
begin
  if Trim(edtCertificado.Text) <> '' then
  begin
    if FileExists(edtCertificado.Text) then
    begin
      SalvaArquivoBD(edtCertificado.Text);

      //Extrai arquivos
      sDirArquivo := ExtractFilePath(Application.ExeName)+'Certificado\';
      if not DirectoryExists(sDirArquivo) then
        CreateDir(sDirArquivo);

      if not ExtraiChavesCertificado(edtCertificado.Text,
                                    edtSenhaCertificado.Text,
                                    sDirArquivo+'SicoobChavePrivada.key',
                                    sDirArquivo+'SicoobCertificado.pem') then
      begin
        MensagemSistema('Ocorreu uma falha ao extrair as chaves pública/privada!',msgAtencao);
        Abort;
      end;
    end;
  end;
end;

end.
