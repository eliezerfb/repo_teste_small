unit uFrmCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls, uObjetoConsultaCEP, uConsultaCEP,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo, Winapi.ShellAPI, System.IniFiles, System.StrUtils, Videocap,
  Vcl.Imaging.jpeg, Vcl.ExtDlgs, Vcl.Clipbrd;

type
  TFrmCadastro = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    tbsFoto: TTabSheet;
    Label2: TLabel;
    edtCPFCNPJ: TSMALL_DBEdit;
    Label3: TLabel;
    edtRazaoSocial: TSMALL_DBEdit;
    Label4: TLabel;
    edtContato: TSMALL_DBEdit;
    Label5: TLabel;
    edtCEP: TSMALL_DBEdit;
    Label6: TLabel;
    edtEndereco: TSMALL_DBEdit;
    imgEndereco: TImage;
    Label7: TLabel;
    edtBairro: TSMALL_DBEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtEstado: TSMALL_DBEdit;
    Label10: TLabel;
    edtRG_IE: TSMALL_DBEdit;
    Label11: TLabel;
    edtTelefone: TSMALL_DBEdit;
    Label12: TLabel;
    edtCelular: TSMALL_DBEdit;
    Label13: TLabel;
    edtWhatsApp: TSMALL_DBEdit;
    Label14: TLabel;
    edtEmail: TSMALL_DBEdit;
    Label15: TLabel;
    edtLimiteCredito: TSMALL_DBEdit;
    lblLimiteCredDisponivel: TLabel;
    eLimiteCredDisponivel: TEdit;
    Label16: TLabel;
    edtCadastro: TSMALL_DBEdit;
    Label17: TLabel;
    edtUltVenda: TSMALL_DBEdit;
    Label18: TLabel;
    edtNascido: TSMALL_DBEdit;
    lblConvenio: TLabel;
    Label19: TLabel;
    edtIdentificador1: TSMALL_DBEdit;
    Label20: TLabel;
    edtIdentificador2: TSMALL_DBEdit;
    Label21: TLabel;
    edtIdentificador3: TSMALL_DBEdit;
    Label22: TLabel;
    edtIdentificador4: TSMALL_DBEdit;
    Label23: TLabel;
    edtIdentificador5: TSMALL_DBEdit;
    Label25: TLabel;
    memObs: TDBMemo;
    Label26: TLabel;
    edtProxContato: TSMALL_DBEdit;
    Label27: TLabel;
    memContato: TDBMemo;
    fraConvenio: TfFrameCampo;
    fraMunicipio: TfFrameCampo;
    cboRelacaoCom: TComboBox;
    Label56: TLabel;
    pnl_IE: TPanel;
    rgIEContribuinte: TRadioButton;
    rgIENaoContribuinte: TRadioButton;
    rgIEIsento: TRadioButton;
    btnRenogiarDivida: TBitBtn;
    Image3: TImage;
    Image5: TImage;
    VideoCap1: TVideoCap;
    btnWebCam: TBitBtn;
    btnSelecionarArquivo: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormShow(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure edtCEPEnter(Sender: TObject);
    procedure edtEnderecoExit(Sender: TObject);
    procedure edtBairroExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboRelacaoComChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgIEContribuinteClick(Sender: TObject);
    procedure rgIENaoContribuinteClick(Sender: TObject);
    procedure rgIEIsentoClick(Sender: TObject);
    procedure edtCPFCNPJChange(Sender: TObject);
    procedure edtLimiteCreditoExit(Sender: TObject);
    procedure imgEnderecoClick(Sender: TObject);
    procedure btnRenogiarDividaClick(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure Label19MouseLeave(Sender: TObject);
    procedure Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure memContatoEnter(Sender: TObject);
    procedure memContatoExit(Sender: TObject);
    procedure memContatoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtEstadoExit(Sender: TObject);
    procedure tbsFotoShow(Sender: TObject);
    procedure btnSelecionarArquivoClick(Sender: TObject);
    procedure btnWebCamClick(Sender: TObject);
    procedure edtEnderecoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtEmailKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtBairroKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FcCEPAnterior: String;
    sContatos : String;
    sNomeDoJPG : string;
    bProximo  : boolean;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure DefineCamposCEP(AoObjeto: TObjetoConsultaCEP);
    procedure LimpaEspaco(Campo : TSMALL_DBEdit);
    procedure AtualizaObjComValorDoBanco;
    procedure CarregaTipoContibuinte;
    procedure SetTipoContribuinte(iTipo: integer);
    procedure DefinirLimiteDisponivel;
    procedure AtualizaTela;
  public
    { Public declarations }
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.dfm}

uses unit7
  , uDialogs
  , uRetornaLimiteDisponivel
  , smallfunc_xe
  , uFuncoesBancoDados
  , MAIS
  , uFrmParcelas
  , MAIS3, uPermissaoUsuario;

{ TFrmCadastro }

procedure TFrmCadastro.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmCadastro.FormCreate(Sender: TObject);
begin
  cboRelacaoCom.Clear;
  cboRelacaoCom.Items.Add('');
  cboRelacaoCom.Items.Add('Cliente');
  cboRelacaoCom.Items.Add('Fornecedor');
  cboRelacaoCom.Items.Add('Cliente/Fornecedor');
  cboRelacaoCom.Items.Add('Funcionário');
  cboRelacaoCom.Items.Add('Revenda');
  cboRelacaoCom.Items.Add('Representante');
  cboRelacaoCom.Items.Add('Distribuidor');
  cboRelacaoCom.Items.Add('Vendedor');
  cboRelacaoCom.Items.Add('Credenciadora de cartão');
  cboRelacaoCom.Items.Add('Instituição financeira');
  cboRelacaoCom.Items.Add('Marketplace');
  cboRelacaoCom.Items.Add('Revenda Inativa'); // adicionadas para uso na Smallsoft
  cboRelacaoCom.Items.Add('Cliente Inativo'); // adicionadas para uso na Smallsoft
  cboRelacaoCom.Sorted := True;

  inherited;
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
begin
  inherited;

  try
    Label19.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR1').DisplayLabel + ':';
    Label20.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR2').DisplayLabel + ':';
    Label21.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR3').DisplayLabel + ':';
    Label22.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR4').DisplayLabel + ':';
    Label23.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR5').DisplayLabel + ':';
  except
  end;

  pgcFicha.ActivePage := tbsCadastro;

  if edtCPFCNPJ.Canfocus then
    edtCPFCNPJ.SetFocus;
end;

function TFrmCadastro.GetPaginaAjuda: string;
begin
  Result := 'clifor.htm';
end;

procedure TFrmCadastro.imgEnderecoClick(Sender: TObject);
begin
    ShellExecute( 0, 'Open',pChar('https://www.google.com.br/maps/dir//'+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2COMPLE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2CEP.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2ESTADO.AsString))+' '
                ),'', '', SW_SHOWMAXIMIZED);
end;

procedure TFrmCadastro.Label19Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  with Sender as TLabel do
  begin
    sNome   := StrTran(Trim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
    Caption := sNome+':';
    Repaint;

    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString(Form7.sModulo,NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TFrmCadastro.Label19MouseLeave(Sender: TObject);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmCadastro.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  try
    if edtCPFCNPJ.CanFocus then
      edtCPFCNPJ.SetFocus;
  except
  end;
end;

procedure TFrmCadastro.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtCPFCNPJ.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtRazaoSocial.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtContato.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCEP.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEndereco.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtBairro.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraMunicipio.Enabled          := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEstado.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtRG_IE.Enabled              := not(bEstaSendoUsado) and not (bSomenteLeitura);
  pnl_IE.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtTelefone.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCelular.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtWhatsApp.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEmail.Enabled              := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtLimiteCredito.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  eLimiteCredDisponivel.Enabled := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCadastro.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtUltVenda.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNascido.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraConvenio.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador1.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador2.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador3.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador4.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador5.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memObs.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtProxContato.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memContato.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  cboRelacaoCom.Enabled         := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnWebCam.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnSelecionarArquivo.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);

end;

procedure TFrmCadastro.edtEmailExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEmailKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtLimiteCreditoExit(Sender: TObject);
begin
  DefinirLimiteDisponivel;
end;

procedure TFrmCadastro.edtCEPEnter(Sender: TObject);
begin
  FcCEPAnterior := TSMALL_DBEdit(Sender).Text;
end;

procedure TFrmCadastro.edtCEPExit(Sender: TObject);
begin
  {Dailon (f-7224) 2024-04-01 inicio}
  if (FcCEPAnterior <> TSMALL_DBEdit(Sender).Text) then
  begin
    try
      DefineCamposCEP(TConsultaCEP.New
                                  .setCEP(TSMALL_DBEdit(Sender).Text)
                                  .SolicitarDados
                                  .getObjeto
                     );
    except
      on e:exception do
        MensagemSistema(e.Message, msgAtencao);
    end;
  end;
  {Dailon (f-7224) 2024-04-01 Fim}
end;

procedure TFrmCadastro.edtEnderecoExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEnderecoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtBairroExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtBairroKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEstadoExit(Sender: TObject);
begin
  if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
  begin
    fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
  end else
  begin
    fraMunicipio.sFiltro := ' ';
  end;
end;

procedure TFrmCadastro.tbsFotoShow(Sender: TObject);
begin
  sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet2REGISTRO.AsString+'.jpg';

  btnWebCam.Caption      := '&Webcam';
  VideoCap1.visible      := False;
  Image5.Visible         := True;
  AtualizaTela;
end;

procedure TFrmCadastro.cboRelacaoComChange(Sender: TObject);
begin
  DSCadastro.DataSet.Edit;
  DSCadastro.DataSet.FieldByName('CLIFOR').AsString := cboRelacaoCom.Text;

  if Form7.ibDataSet9NOME.AsString =  Form7.ibDataSet2NOME.AsString then
  begin
    if Form7.ibDataSet2CLIFOR.AsString <> 'Vendedor' then
    begin
      Form7.ibDataSet9.Delete;
    end else
    begin
      Form7.ibDataSet9.Append;
      Form7.IBDataSet9NOME.AsString := Form7.IBDataSet2NOME.AsString;
      Form7.ibDataSet9.Post;
    end;
  end;

  if Form7.ibDataSet2CLIFOR.AsString = 'Marketplace' then
  begin
    if Trim(RetornaValorDaTagNoCampo('idCadIntTran',Form7.ibDataSet2OBS.AsString)) = '' then
    begin
      Form7.ibDataSet2OBS.AsString := Trim(Form7.ibDataSet2OBS.AsString) + '<idCadIntTran>0000</idCadIntTran>'
    end;
  end else
  begin
    Form7.ibDataSet2OBS.AsString := StringReplace(Form7.ibDataSet2OBS.AsString,'<idCadIntTran>0000</idCadIntTran>','',[rfReplaceAll]);
  end;

end;

procedure TFrmCadastro.memContatoEnter(Sender: TObject);
begin
  sContatos := Form7.IBDataSet2CONTATOS.AsString;

  if Form7.ArquivoAberto.Modified then
    Form7.ArquivoAberto.Post;

  Form7.ArquivoAberto.Edit;

  SendMessage(memContato.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(memContato.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  memContato.SelStart := Length(memContato.Text); //move o cursor pra o final da ultima linha
  memContato.SetFocus;
end;

procedure TFrmCadastro.memContatoExit(Sender: TObject);
begin
  if StrTran(StrTran(StrTran(Form7.IBDataSet2CONTATOS.AsString,chr(10),''),chr(13),''),' ','') <> StrTran(StrTran(StrTran(sContatos,chr(10),''),chr(13),''),' ','') then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2CONTATOS.AsString := Form7.IBDataSet2CONTATOS.AsString +chr(10) +'('+Senhas.UsuarioPub+') '+StrZero(Year(Date),4,0)+'-'+StrZero(Month(Date),2,0)+'-'+StrZero(day(Date),2,0)+' '+TimeToStr(Time);

    // Comercial da Small está perdendo dados de contatos
    if Form7.ibDataSet13CGC.AsString = CNPJ_SMALLSOFT then
      Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy(Form7.IBDataSet2NOME.AsString, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
  end;

  begin
    try
      if Form7.ArquivoAberto.Modified then Form7.ArquivoAberto.Post;
    except
      on E: Exception do
      begin
        // Comercial da Small está perdendo dados de contatos
        if AnsiContainsText(E.Message, 'deadlock') then
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, 'Conflito L3729 ' + RightStr(E.Message, 50),0,0) // Ato, Modulo, Usuário, Histórico, Valor
        else
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy('Salvar contatos L3731 ' + E.Message, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor

        MensagemSistema('Não foi possível gravar o assunto do contato - Este registro está sendo usado por outro usuário.',msgAtencao);
        Form7.ArquivoAberto.Cancel;
      end;
    end;

    Form7.ArquivoAberto.Edit;
  end;
end;

procedure TFrmCadastro.memContatoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end
    else
      bProximo := True;
  end
  else
  	bProximo := False;
end;

procedure TFrmCadastro.DefineCamposCEP(AoObjeto: TObjetoConsultaCEP);
begin
  if not Assigned(AoObjeto) then
    Exit;

  // Endereço
  DSCadastro.DataSet.FieldByName('ENDERE').AsString := Copy(AoObjeto.logradouro,1, DSCadastro.DataSet.FieldByName('ENDERE').Size);

  // Bairro
  DSCadastro.DataSet.FieldByName('COMPLE').AsString := Copy(AoObjeto.bairro,1, DSCadastro.DataSet.FieldByName('COMPLE').Size);

  // Municipio
  if DSCadastro.DataSet.FieldByName('CIDADE').Asstring <> AoObjeto.localidade then
    DSCadastro.DataSet.FieldByName('CIDADE').AsString := Copy(AoObjeto.localidade,1, DSCadastro.DataSet.FieldByName('CIDADE').Size);

  try
    fraMunicipio.CarregaDescricao;
  except
  end;

  // Estado
  if DSCadastro.DataSet.FieldByName('ESTADO').AsString <> AoObjeto.uf then
    DSCadastro.DataSet.FieldByName('ESTADO').AsString := Copy(AoObjeto.uf,1, DSCadastro.DataSet.FieldByName('ESTADO').Size);
end;

procedure TFrmCadastro.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmCadastro.edtCPFCNPJChange(Sender: TObject);
begin
  pnl_IE.Visible    := (Length(Trim(form7.ibDAtaset2CGC.AsString)) = 18); //Mauricio Parizotto 2024-04-15
end;

procedure TFrmCadastro.LimpaEspaco(Campo : TSMALL_DBEdit);
begin
  if (Copy(Campo.Text,1,1) = ' ') then
  begin
    if not (Campo.Field.DataSet.State in [dsEdit, dsInsert]) then
    begin
      Campo.Field.DataSet.Edit;
      Campo.Text := Trim(Campo.Text);
      Campo.Field.DataSet.Post;
    end else
      Campo.Text := Trim(Campo.Text);
  end;
end;

procedure TFrmCadastro.rgIEContribuinteClick(Sender: TObject);
begin
  SetTipoContribuinte(1);
end;

procedure TFrmCadastro.rgIEIsentoClick(Sender: TObject);
begin
  SetTipoContribuinte(2);
end;

procedure TFrmCadastro.rgIENaoContribuinteClick(Sender: TObject);
begin
  SetTipoContribuinte(9);
end;

procedure TFrmCadastro.AtualizaObjComValorDoBanco;
begin
  if not self.Visible then
    Exit;

  cboRelacaoCom.ItemIndex := cboRelacaoCom.Items.IndexOf(Form7.ibDataSet2CLIFOR.AsString);

  pnl_IE.Visible                  := (Length(trim(Form7.ibDAtaset2CGC.AsString)) = 18);

  Self.Caption := form7.ibDataSet2NOME.AsString;

  DefinirLimiteDisponivel;

  CarregaTipoContibuinte;

  //Convenio
  try
    fraConvenio.TipoDePesquisa               := tpLocate;
    fraConvenio.GravarSomenteTextoEncontrato := True;
    fraConvenio.CampoVazioAbrirGridPesquisa  := True;
    fraConvenio.CampoCodigo                  := Form7.ibDataSet2CONVENIO;
    fraConvenio.CampoCodigoPesquisa          := 'NOME';
    fraConvenio.sCampoDescricao              := 'NOME';
    fraConvenio.sTabela                      := 'CONVENIO';
    fraConvenio.CarregaDescricao;
  except
  end;

  //Município
  try
    fraMunicipio.TipoDePesquisa               := tpSelect;
    fraMunicipio.GravarSomenteTextoEncontrato := True;
    fraMunicipio.CampoVazioAbrirGridPesquisa  := True;
    fraMunicipio.CampoCodigo                  := Form7.ibDataSet2CIDADE;
    fraMunicipio.CampoCodigoPesquisa          := 'NOME';
    fraMunicipio.sCampoDescricao              := 'NOME';
    fraMunicipio.sTabela                      := 'MUNICIPIOS';

    if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
    begin
      fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
    end else
    begin
      fraMunicipio.sFiltro := ' ';
    end;

    fraMunicipio.CarregaDescricao;

  except
  end;

  //Botão renegociar divida
  Form7.ibQuery1.Close;
  Form7.IBQuery1.SQL.Text := ' Select sum(VALOR_DUPL) as TOTAL '+
                             ' From RECEBER '+
                             ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                             '   and coalesce(ATIVO,9)<>1 '+
                             '   and Coalesce(VALOR_RECE,999999999)=0';
  Form7.IBQuery1.Open;

  if Form7.IBQuery1.FieldByname('TOTAL').AsFloat <> 0 then
  begin
    if Form1.imgVendas.Visible then
    begin
      btnRenogiarDivida.Visible := True;
    end;
  end;

  AtualizaTela;
end;


procedure TFrmCadastro.SetTipoContribuinte(iTipo : integer);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;

    Form7.IBDataSet2CONTRIBUINTE.AsInteger := iTipo;

    CarregaTipoContibuinte;
  except
  end;
end;

procedure TFrmCadastro.btnRenogiarDividaClick(Sender: TObject);
var
  ftotal1, fTotal2 : Real;
  bButton : Integer;
  sNumeroNF : String;
begin
  try
    ExecutaComando('create generator G_RENEGOCIACAO');
  except
  end;

  Form7.sTextoDoAcordo := '';

  Form7.ibDataSet7.Close;
  Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                     ' Where SubString(DOCUMENTO from 1 for 2)=''RE'' '+
                                     '   and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                     '   and coalesce(ATIVO,9)<>1 '+
                                     '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                     ' Order by VENCIMENTO';
  Form7.ibDataSet7.Open;
  Form7.ibDataSet7.Last;

  if Copy(Form7.ibDataSet7DOCUMENTO.AsString,1,2) = 'RE' then
  begin
    // Abre uma negociação já existente
    sNumeroNF := LimpaNumero(Form7.ibDataSet7HISTORICO.AsString);

    Form7.ibQuery1.Close;
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add(' Update RECEBER set PORTADOR='''', ATIVO=0 '+
                           ' Where PORTADOR=' + QuotedStr('ACORDO '+sNumeroNF) +
                           '   and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
    Form7.IBQuery1.ExecSQL;

    Form7.IBDataSet2.Edit;
    Form7.IBDataSet2MOSTRAR.AsFloat := 1;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 and SubString(DOCUMENTO from 1 for 2)<>''RE''  '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                       ' Order by VENCIMENTO';
    Form7.ibDataSet7.Open;
  end else
  begin
    // Nova negociação
    try
      Form7.ibQuery2.Close;
      Form7.ibQuery2.SQL.Text := ' Select gen_id(G_RENEGOCIACAO,1) from rdb$database';
      Form7.ibQuery2.Open;

      sNumeroNF := strZero(StrToInt(Form7.ibQuery2.FieldByname('GEN_ID').AsString),12,0);
    except
    end;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                       ' Order by VENCIMENTO';
    Form7.ibDataSet7.Open;
  end;

  Form7.sTextoDoAcordo := 'Parcela    Vencimento   Valor R$      Atualizado R$ '+chr(13)+chr(10)+
                          '---------- ------------ ------------- --------------'+chr(13)+chr(10);
  fTotal1 := 0;
  fTotal2 := 0;

  while not Form7.ibDataSet7.Eof do
  begin
    Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat])+chr(13)+chr(10);
    fTotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
    fTotal2 := fTotal2 + Form7.ibDataSet7VALOR_JURO.AsFloat;
    Form7.ibDataSet7.Next;
  end;

  Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                          '                        ------------- ---------------'+chr(13)+chr(10)+
                          '                       '+Format('%15.2n',[fTotal1])+Format('%15.2n',[ftotal2])+chr(13)+chr(10);
  if fTotal1 <> 0 then
  begin
    bButton := Application.MessageBox(Pchar('Considerar o valor atualizado com juros?'),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);

    if bButton = IDYES then
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia.'+chr(13)+chr(10);
      fTotal1 := fTotal2;
    end else
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia foi desconsiderado.'+chr(13)+chr(10);
    end;

    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NUMERONF='+QuotedStr(sNumeroNF)+
                                       '   and  NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       ' Order by REGISTRO';
    Form7.ibDataSet7.Open;

    //Mauricio Parizotto 2024-01-24
    try
      FrmParcelas := TFrmParcelas.Create(Self);
      FrmParcelas.Caption := 'Renegociação de dívida';
      FrmParcelas.vlrRenegociacao := fTotal1;
      FrmParcelas.nrRenegociacao := sNumeroNF;
      FrmParcelas.ShowModal;
    finally
      FreeAndNil(FrmParcelas);
    end;
  end;
end;

procedure TFrmCadastro.btnWebCamClick(Sender: TObject);
var
  jp : TJPEGImage;
begin
  if btnWebCam.Caption <> '&Captura' then
  begin
    try
      VideoCap1.visible    := True;
      Image5.Visible       := False;
      VideoCAp1.Left       := 5;
      VideoCAp1.Top        := 5;

      VideoCAp1.Width      := 640;
      VideoCAp1.Height     := 480;

      VideoCap1.visible    := True;

      try
        Videocap1.DriverIndex := 0;
      except
      end;

      try
        VideoCap1.VideoPreview := True;
        VideoCap1.CapAudio     := False;
      except end;

      btnWebCam.Caption := '&Captura';
    except
    end;
  end else
  begin
    try
      VideoCap1.SaveToClipboard;
      Image5.Picture.Bitmap.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
      VideoCap1.VideoPreview := False;
      VideoCap1.visible      := False;

      jp := TJPEGImage.Create;
      jp.Assign(Image5.Picture.Bitmap);
      jp.CompressionQuality := 100;

      jp.SaveToFile(sNomeDoJPG);

      btnWebCam.Caption    := '&Webcam';
      Image5.Visible       := True;

      while not FileExists(pChar(sNomeDoJPG)) do
      begin
        Sleep(100);
      end;

      Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
      Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

      AtualizaTela;
    except
    end;
  end;

end;

procedure TFrmCadastro.btnSelecionarArquivoClick(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  CHDir(Form1.sAtual);

  if FileExists(OpenPictureDialog1.FileName) then
  begin
    Screen.Cursor             := crHourGlass;              // Cursor de Aguardo

    while FileExists(pChar(sNomeDoJPG)) do
    begin
      DeleteFile(pChar(sNomeDoJPG));
    end;

    CopyFile(pChar(OpenPictureDialog1.FileName),pChar(sNomeDoJPG),True);

    while not FileExists(pChar(sNomeDoJPG)) do
    begin
      Sleep(100);
    end;

    Screen.Cursor             := crDefault;              // Cursor de Aguardo

    Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
    Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

    AtualizaTela;
  end;
end;

procedure TFrmCadastro.CarregaTipoContibuinte;
begin
  try
    edtRG_IE.Enabled       := True;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 0 then
    begin
      rgIEContribuinte.Checked    := False;
      rgIEIsento.Checked          := False;
      rgIENaoContribuinte.Checked := False;
    end;

    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 1 then
    begin
      rgIEContribuinte.Checked := True;

      if Form7.IBDataSet2IE.AsString = 'ISENTO' then
        Form7.IBDataSet2IE.AsString := '';
    end;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 2 then
    begin
      rgIEIsento.Checked          := True;

      Form7.IBDataSet2IE.AsString := 'ISENTO';
      edtRG_IE.Enabled            := False;
    end;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 9 then
    begin
      rgIENaoContribuinte.Checked := True;

      if Form7.IBDataSet2IE.AsString = 'ISENTO' then
        Form7.IBDataSet2IE.AsString := '';
    end;
  except
  end;
end;


procedure TFrmCadastro.DefinirLimiteDisponivel;
var
  nValor: Currency;
begin
  eLimiteCredDisponivel.Text := EmptyStr;
  if not Self.Showing then
    Exit;

  if (Form7.sModulo = 'CLIENTES') and (Form7.IBDataSet2CREDITO.AsCurrency > 0) then
  begin
    nValor := TRetornaLimiteDisponivel.New
                                      .SetDatabase(Form7.IBDatabase1)
                                      .SetCliente(Form7.IBDataSet2NOME.AsString)
                                      .setLimiteCredito(Form7.IBDataSet2CREDITO.AsCurrency)
                                      .CarregarDados
                                      .RetornarValor;



    eLimiteCredDisponivel.Text := FormatFloat(',0.00', nValor);
  end;
end;


procedure TFrmCadastro.Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmCadastro.AtualizaTela;
var
  BlobStream: TStream;
  FileStream : TFileStream;
  JP2         : TJPEGImage;
begin
  Image5.Picture := nil;
  Image3.Picture := nil;

  if FileExists(sNomeDoJPG) then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;
    FileStream := TFileStream.Create(sNomeDoJPG,fmOpenRead or fmShareDenyWrite);
    BlobStream := Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmWrite);
    try
      BlobStream.CopyFrom(FileStream,FileStream.Size);
    finally
      FileStream.Free;
      BlobStream.Free;
    end;

    Deletefile(pChar(sNomeDoJPG));
  end;

  if Form7.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
  end
  else
    Image5.Picture := Image3.Picture;
end;

end.




