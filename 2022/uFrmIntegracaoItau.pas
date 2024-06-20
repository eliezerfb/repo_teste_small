unit uFrmIntegracaoItau;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons, Shellapi,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, uframeCampo, Vcl.DBCtrls, Data.DB, System.Threading,
  Vcl.Mask, IBX.IBCustomDataSet, IBX.IBQuery;

type
  TFrmIntegracaoItau = class(TFrmPadrao)
    imgLogo: TImage;
    DSCadastro: TDataSource;
    ibdIntegracaoItau: TIBDataSet;
    ibdIntegracaoItauIDCONFIGURACAOITAU: TIntegerField;
    ibdIntegracaoItauIDBANCO: TIntegerField;
    ibdIntegracaoItauHABILITADO: TIBStringField;
    ibdIntegracaoItauUSUARIO: TIBStringField;
    ibdIntegracaoItauSENHA: TIBStringField;
    ibdIntegracaoItauCLIENTID: TIBStringField;
    ibdIntegracaoItauNOME: TIBStringField;
    pnlInicial: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    lblContaBancaria: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    lblClientID: TLabel;
    lblCadastro: TLabel;
    lblQueroCadastrar: TLabel;
    lblAcessarPortal: TLabel;
    fraContaBancaria: TfFrameCampo;
    chkAtivo: TDBCheckBox;
    edtUsuario: TDBEdit;
    edtSenha: TDBEdit;
    memClientID: TDBMemo;
    pnlCadastro: TPanel;
    lblCNPJ: TLabel;
    lblRazaoSocial: TLabel;
    lblEndereco: TLabel;
    btnVoltar: TBitBtn;
    btnEnviar: TBitBtn;
    lblBairro: TLabel;
    lblCEP: TLabel;
    lblMunicipio: TLabel;
    lblEstado: TLabel;
    lblTelefone: TLabel;
    lblEmail: TLabel;
    edtEmail: TEdit;
    imgInfo: TImage;
    pnlSeparador: TPanel;
    lblEmailPortal: TLabel;
    lblAcessoPortal: TLabel;
    dbeCnpj: TDBText;
    dbeRazaoSocial: TDBText;
    dbeEndereco: TDBText;
    dbeBairro: TDBText;
    dbeCEP: TDBText;
    dbeMunicipio: TDBText;
    dbeEstado: TDBText;
    dbeTelefone: TDBText;
    dbeResponsavel: TDBText;
    ibqEmitente: TIBQuery;
    DSEmitente: TDataSource;
    ibqEmitenteNOME: TIBStringField;
    ibqEmitenteENDERECO: TIBStringField;
    ibqEmitenteCOMPLE: TIBStringField;
    ibqEmitenteMUNICIPIO: TIBStringField;
    ibqEmitenteCEP: TIBStringField;
    ibqEmitenteESTADO: TIBStringField;
    ibqEmitenteCGC: TIBStringField;
    ibqEmitenteIE: TIBStringField;
    ibqEmitenteTELEFO: TIBStringField;
    ibqEmitenteEMAIL: TIBStringField;
    ibqEmitenteCONTATO: TIBStringField;
    btnEmitente: TBitBtn;
    lblHomolog: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure lblQueroCadastrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtUsuarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnVoltarClick(Sender: TObject);
    procedure lblAcessarPortalClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure btnEmitenteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtEmailKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fraContaBancariatxtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure AtualizaObjComValorDoBanco;
    procedure GetPaginaAjuda;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIntegracaoItau: TFrmIntegracaoItau;

implementation

{$R *.dfm}

uses
  unit7
  , uFuncoesBancoDados
  , uDialogs
  , uIntegracaoItau
  , smallfunc_xe
  , Unit17, uFrmTelaProcessamento, uEmail;

procedure TFrmIntegracaoItau.btnCancelarClick(Sender: TObject);
begin
  ibdIntegracaoItau.Cancel;
  Close;
end;

procedure TFrmIntegracaoItau.btnEmitenteClick(Sender: TObject);
begin
  try
    Form17 := TForm17.Create(nil);
    Form17.ShowModal;
  finally
    FreeAndNil(Form17);

    ibqEmitente.Close;
    ibqEmitente.Open;
  end;
end;

procedure TFrmIntegracaoItau.btnEnviarClick(Sender: TObject);
var
  client_id,access_key, secret_key, user_role_id, retail_chain_id, msRet : string;
begin

  {$Region'//// Validaçoes Campos ////'}
  if Trim(edtEmail.Text) = '' then
  begin
    MensagemSistema('O campo E-mail deve ser preenchido!',msgAtencao);
    edtEmail.SetFocus;
    Exit;
  end;

  if not ValidaEmail(edtEmail.Text) then
  begin
    MensagemSistema('O E-mail está inválido!',msgAtencao);
    edtEmail.SetFocus;
    Exit;
  end;

  if Trim(ibqEmitenteNOME.AsString) = '' then
  begin
    MensagemSistema('O campo Razão Social deve ser preenchido no cadastro do emitente  ',msgAtencao);
    Exit;
  end;

  if Trim(ibqEmitenteCGC.AsString) = '' then
  begin
    MensagemSistema('O campo CNPJ deve ser preenchido no cadastro do emitente!',msgAtencao);
    Exit;
  end;

  if Trim(ibqEmitenteCONTATO.AsString) = '' then
  begin
    MensagemSistema('O campo Responsável deve ser preenchido no cadastro do emitente!',msgAtencao);
    Exit;
  end;
  {$Endregion}

  // só quando for prod deve ser enviado
  if uIntegracaoItau.AmbienteItauProd then
  begin
    user_role_id     := '9f2b6c07-da54-4eee-a625-8dbde593e4f7';
    retail_chain_id  := '1d57912e-8f09-4bad-94ff-e932037b5289'
  end else
  begin
    retail_chain_id  := '2ef0b250-f103-49c5-941e-feb51bc875eb';
  end;


  MostraTelaProcessamento('Processando informações...');

  try
    //Executa em Thread
    TTask.Run(
    procedure()
    begin
      //Autentica
      if AutenticaoITAU(msRet) then
      begin
        //Envia Cadastro
        if RegistraContaItau(ibqEmitenteCONTATO.AsString,
                            edtEmail.Text,
                            ibqEmitenteNOME.AsString,
                            edtEmail.Text,
                            Copy(ibqEmitenteNOME.AsString,1,49),
                            ibqEmitenteCGC.AsString,
                            ibqEmitenteCEP.AsString,
                            ExtraiEnderecoSemONumero(ibqEmitenteENDERECO.AsString),
                            LimpaNumero(ExtraiNumeroSemOEndereco(ibqEmitenteENDERECO.AsString)),
                            ibqEmitenteMUNICIPIO.AsString,
                            ibqEmitenteESTADO.AsString,
                            ibqEmitenteCOMPLE.AsString,
                            '',
                            'Caixa 1',
                            user_role_id,
                            ibqEmitenteTELEFO.AsString,
                            retail_chain_id,
                            client_id,
                            access_key,
                            secret_key,
                            msRet) then
        begin
           ibdIntegracaoItauCLIENTID.AsString := client_id;
           ibdIntegracaoItauUSUARIO.AsString  := access_key;
           ibdIntegracaoItauSENHA.AsString    := secret_key;

           ibdIntegracaoItau.Post;
           ibdIntegracaoItau.Edit;
        end;
      end;

      TThread.Synchronize(TThread.CurrentThread,
      procedure()
      begin
         FechaTelaProcessamento();

        if msRet <> '' then
        begin
          MensagemSistema(msRet,msgAtencao);
        end else
        begin
          pnlInicial.Visible  := True;
          pnlCadastro.Visible := False;

          if MensagemSistemaPerguntaCustom('Cadastro efetuado com sucesso.'+#13#10+
                                           'Verifique seu e-mail para prosseguir com a ativação da sua conta no portal Itaú.',
                                           mtInformation,[mbOK,mbYes],['OK','Ajuda']) = 1 then
          begin
            GetPaginaAjuda;
          end;
        end;
      end);
    end);
  except
    TThread.Synchronize(TThread.CurrentThread,
    procedure()
    begin
       FechaTelaProcessamento();

       if msRet <> '' then
         MensagemSistema(msRet,msgAtencao);
    end);
  end;
end;

procedure TFrmIntegracaoItau.btnOKClick(Sender: TObject);
begin
  if chkAtivo.Checked then
  begin
    //Valida campos
    if Trim(edtUsuario.Text) = '' then
    begin
      MensagemSistema('O campo Usuáio deve ser preenchido!',msgAtencao);
      edtUsuario.SetFocus;
      Exit;
    end;

    if Trim(edtSenha.Text) = '' then
    begin
      MensagemSistema('O campo Senha deve ser preenchido!',msgAtencao);
      edtSenha.SetFocus;
      Exit;
    end;

    if Trim(memClientID.Text) = '' then
    begin
      MensagemSistema('O campo Client ID Token deve ser preenchido!',msgAtencao);
      memClientID.SetFocus;
      Exit;
    end;
  end;

  ibdIntegracaoItau.Post;
  AgendaCommit(True);
  Close;
end;

procedure TFrmIntegracaoItau.btnVoltarClick(Sender: TObject);
begin
  pnlInicial.Visible  := True;
  pnlCadastro.Visible := False;
end;

procedure TFrmIntegracaoItau.edtEmailKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoItau.edtUsuarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);

  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoItau.FormCreate(Sender: TObject);
begin
  ibdIntegracaoItau.open;

  if ibdIntegracaoItau.isEmpty then
  begin
    ibdIntegracaoItau.Insert;
    ibdIntegracaoItauIDCONFIGURACAOITAU.AsInteger := ExecutaComandoEscalar(Form7.Ibdatabase1,'Select gen_id(G_CONFIGURACAOITAU,1) from rdb$database','0');
    ibdIntegracaoItauHABILITADO.AsString := 'S';
    chkAtivo.Visible := False;
  end else
  begin
    ibdIntegracaoItau.Edit;
    chkAtivo.Visible := True;
  end;

  CarregaTipoAmbiente;

  lblHomolog.Visible := not (AmbienteItauProd);
end;

procedure TFrmIntegracaoItau.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoItau.FormShow(Sender: TObject);
begin
  AtualizaObjComValorDoBanco;

  if fraContaBancaria.txtCampo.CanFocus then
    fraContaBancaria.txtCampo.SetFocus;
end;

procedure TFrmIntegracaoItau.fraContaBancariatxtCampoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  fraContaBancaria.txtCampoKeyDown(Sender, Key, Shift);

  if Key = VK_F1 then
    GetPaginaAjuda;
end;

procedure TFrmIntegracaoItau.lblAcessarPortalClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, PChar('https://painelv2-conexaoitau.shipay.com.br/#/login'), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TFrmIntegracaoItau.lblQueroCadastrarClick(Sender: TObject);
begin
  ibqEmitente.Close;
  ibqEmitente.Open;

  pnlInicial.Visible  := False;
  pnlCadastro.Visible := True;
end;

procedure TFrmIntegracaoItau.AtualizaObjComValorDoBanco;
begin
  try
    fraContaBancaria.TipoDePesquisa               := tpLocate;
    fraContaBancaria.GravarSomenteTextoEncontrato := True;
    fraContaBancaria.CampoVazioAbrirGridPesquisa  := True;
    fraContaBancaria.CampoCodigo                  := ibdIntegracaoItauIDBANCO;
    fraContaBancaria.CampoCodigoPesquisa          := 'IDBANCO';
    fraContaBancaria.sCampoDescricao              := 'NOME';
    fraContaBancaria.sTabela                      := 'BANCOS';
    fraContaBancaria.CarregaDescricaoCodigo;
  except
  end;
end;

procedure TFrmIntegracaoItau.GetPaginaAjuda;
begin
  HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('integracao_itau.htm')));
end;

end.
