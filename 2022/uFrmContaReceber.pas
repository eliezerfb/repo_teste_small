unit uFrmContaReceber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmContaReceber = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    fraPlanoContas: TfFrameCampo;
    Label1: TLabel;
    Label129: TLabel;
    edtDocumento: TSMALL_DBEdit;
    edtHistorico: TSMALL_DBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtEmissao: TSMALL_DBEdit;
    Label5: TLabel;
    edtVencimento: TSMALL_DBEdit;
    Label6: TLabel;
    edtMovimento: TSMALL_DBEdit;
    edtDtQuitacao: TSMALL_DBEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtValor: TSMALL_DBEdit;
    Label9: TLabel;
    edtPortador: TSMALL_DBEdit;
    edtNotaFiscal: TSMALL_DBEdit;
    Label10: TLabel;
    fraCliente: TfFrameCampo;
    Label11: TLabel;
    edtValorQuitado: TSMALL_DBEdit;
    Label12: TLabel;
    edtValorAtual: TSMALL_DBEdit;
    Label13: TLabel;
    edtCodBarra: TSMALL_DBEdit;
    Label14: TLabel;
    edtNossoNum: TSMALL_DBEdit;
    Label15: TLabel;
    btnRecibo: TBitBtn;
    btnReplicar: TBitBtn;
    fraInstituicao: TfFrameCampo;
    fraFormaPag: TfFrameCampo;
    edtAutorizacao: TSMALL_DBEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edtBandeira: TSMALL_DBEdit;
    DSCliente: TDataSource;
    Label19: TLabel;
    edtContato: TSMALL_DBEdit;
    Label20: TLabel;
    edtTelefone: TSMALL_DBEdit;
    Label21: TLabel;
    edtCelular: TSMALL_DBEdit;
    Label22: TLabel;
    edtEmail: TSMALL_DBEdit;
    memContatos: TDBMemo;
    Label23: TLabel;
    procedure lblNovoClick(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure btnReciboClick(Sender: TObject);
    procedure btnReplicarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fraClienteExit(Sender: TObject);
    procedure memContatosExit(Sender: TObject);
    procedure memContatosEnter(Sender: TObject);
    procedure memContatosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure AtualizaObjComValorDoBanco;
    procedure AlteracaoInstituicaoFinanceira;
    procedure CarregaCliente;

    var
    sContatos : String;
    bProximo : Boolean;
  public
    { Public declarations }
  end;

var
  FrmContaReceber: TFrmContaReceber;

implementation

{$R *.dfm}

uses
  unit7
  , smallfunc_xe
  , uSmallConsts
  , uFuncoesBancoDados
  , uDialogs
  , MAIS3
  , uPermissaoUsuario
  , MAIS;

procedure TFrmContaReceber.btnOKClick(Sender: TObject);
begin
  try
    if Form7.ibDataSet2.Modified then
    begin
      Form7.IBDataSet2.Post;
    end;
  except
  end;

  AlteracaoInstituicaoFinanceira;

  inherited;
end;

procedure TFrmContaReceber.btnReciboClick(Sender: TObject);
begin
  if Form7.ibDataSet7.FieldByName('VALOR_RECE').AsFloat <> 0 then
    Form7.fTotalDoRecibo := Form7.ibDataSet7.FieldByName('VALOR_RECE').AsFloat
  else
    Form7.fTotalDoRecibo := Form7.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat;

  Form7.sReciboProvenienteDe := 'Proveniente: dp. ' + Form7.ibDataSet7.FieldByName('DOCUMENTO').AsString + ', Referente ' + AllTrim(Form7.ibDataSet7.FieldByName('HISTORICO').AsString);
  Form7.sReciboRecebemosDe   := Form7.ibDataSet7.FieldByName('NOME').AsString;
  Form7.RECIBOClick(Sender);
end;

procedure TFrmContaReceber.btnReplicarClick(Sender: TObject);
var
  vCampo: array [1..7] of Variant; // Cria uma matriz com 6 elementos
  sDocumentoBaseParaSequencia: String; // Sandro Silva 2023-01-06
  sParcelaReplicada: String; // Sandro Silva 2023-01-06
begin
  if AllTrim(Form7.ibDataSet7DOCUMENTO.AsString) <> '' then
  begin
    sDocumentoBaseParaSequencia := Form7.ibDataSet7DOCUMENTO.AsString; // Sandro Silva 2023-01-06
    sParcelaReplicada := Form7.ibDataSet7DOCUMENTO.AsString; // Sandro Silva 2023-01-09

    if Copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = '9' then
      vCampo[1] := Copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1)+'A'
    else if copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = 'Z' then
      vCampo[1] := Copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1)+'a'
    else if copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = 'z' then
      vCampo[1] := chr(Ord(sDocumentoBaseParaSequencia[1])+1)+copy(sDocumentoBaseParaSequencia,2,Length(Trim(sDocumentoBaseParaSequencia))-2)+'A'
    else
      vCampo[1] := copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1) + chr(Ord(sDocumentoBaseParaSequencia[Length(Trim(sDocumentoBaseParaSequencia))])+1); // documento

  end else
  begin
    vCampo[1] := 'A';
  end;

  vCampo[2] := Form7.ibDataSet7HISTORICO.AsString;                 // Histórico
  vCampo[3] := Form7.ibDataSet7VALOR_DUPL.AsFloat;                 // Valor
  vCampo[4] := Form7.ibDataSet7EMISSAO.AsDateTime;                 // Emissão
  vCampo[5] := SomaDias(Form7.ibDataSet7VENCIMENTO.AsDateTime,30); // Vencimento
  vCampo[6] := Form7.ibDataSet7NOME.AsString;                      // Nome do Cliente
  vCampo[7] := Form7.ibDataSet7CONTA.AsString;                     // Plano de contas
  { Incrementa o mês no historico }
  if Pos('dezembro',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'dezembro'  ,'janeiro') else
    if Pos('DEZEMBRO',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'DEZEMBRO'  ,'JANEIRO') else
      if Pos(' DEZ ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ '  ,' JAN ') else
        if Pos(' DEZ.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ.'  ,' JAN.') else
          if Pos(' dez ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez '  ,' jan ') else
            if Pos(' dez.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez.'  ,' jan.') else
            begin
              vCampo[2] := strtran(vCampo[2],'novembro'  ,'dezembro');
              vCampo[2] := strtran(vCampo[2],'outubro'   ,'novembro');
              vCampo[2] := strtran(vCampo[2],'setembro'  ,'outubro');
              vCampo[2] := strtran(vCampo[2],'agosto'    ,'setembro');
              vCampo[2] := strtran(vCampo[2],'julho'     ,'agosto');
              vCampo[2] := strtran(vCampo[2],'junho'     ,'julho');
              vCampo[2] := strtran(vCampo[2],'maio'      ,'junho');
              vCampo[2] := strtran(vCampo[2],'abril'     ,'maio');
              vCampo[2] := strtran(vCampo[2],'março'     ,'abril');
              vCampo[2] := strtran(vCampo[2],'fevereiro' ,'março');
              vCampo[2] := strtran(vCampo[2],'janeiro'   ,'fevereiro');

              vCampo[2] := strtran(vCampo[2],'NOVEMBRO'  ,'DEZEMBRO');
              vCampo[2] := strtran(vCampo[2],'OUTUBRO'   ,'NOVEMBRO');
              vCampo[2] := strtran(vCampo[2],'SETEMBRO'  ,'OUTUBRO');
              vCampo[2] := strtran(vCampo[2],'AGOSTO'    ,'SETEMBRO');
              vCampo[2] := strtran(vCampo[2],'JULHO'     ,'AGOSTO');
              vCampo[2] := strtran(vCampo[2],'JUNHO'     ,'JULHO');
              vCampo[2] := strtran(vCampo[2],'MAIO'      ,'JUNHO');
              vCampo[2] := strtran(vCampo[2],'ABRIL'     ,'MAIO');
              vCampo[2] := strtran(vCampo[2],'MARÇO'     ,'ABRIL');
              vCampo[2] := strtran(vCampo[2],'FEVEREIRO' ,'MARÇO');
              vCampo[2] := strtran(vCampo[2],'JANEIRO'   ,'FEVEREIRO');

              vCampo[2] := strtran(vCampo[2],' NOV '  ,' DEZ ');
              vCampo[2] := strtran(vCampo[2],' OUT '  ,' NOV ');
              vCampo[2] := strtran(vCampo[2],' SET '  ,' OUT ');
              vCampo[2] := strtran(vCampo[2],' AGO '  ,' SET ');
              vCampo[2] := strtran(vCampo[2],' JUL '  ,' AGO ');
              vCampo[2] := strtran(vCampo[2],' JUN '  ,' JUL ');
              vCampo[2] := strtran(vCampo[2],' MAI '  ,' JUN ');
              vCampo[2] := strtran(vCampo[2],' ABR '  ,' MAI ');
              vCampo[2] := strtran(vCampo[2],' MAR '  ,' ABR ');
              vCampo[2] := strtran(vCampo[2],' FEV '  ,' MAR ');
              vCampo[2] := strtran(vCampo[2],' JAN '  ,' FEV ');

              vCampo[2] := strtran(vCampo[2],' NOV.'  ,' DEZ.');
              vCampo[2] := strtran(vCampo[2],' OUT.'  ,' NOV.');
              vCampo[2] := strtran(vCampo[2],' SET.'  ,' OUT.');
              vCampo[2] := strtran(vCampo[2],' AGO.'  ,' SET.');
              vCampo[2] := strtran(vCampo[2],' JUL.'  ,' AGO.');
              vCampo[2] := strtran(vCampo[2],' JUN.'  ,' JUL.');
              vCampo[2] := strtran(vCampo[2],' MAI.'  ,' JUN.');
              vCampo[2] := strtran(vCampo[2],' ABR.'  ,' MAI.');
              vCampo[2] := strtran(vCampo[2],' MAR.'  ,' ABR.');
              vCampo[2] := strtran(vCampo[2],' FEV.'  ,' MAR.');
              vCampo[2] := strtran(vCampo[2],' JAN.'  ,' FEV.');

              vCampo[2] := strtran(vCampo[2],' nov.'  ,' dez.');
              vCampo[2] := strtran(vCampo[2],' out.'  ,' nov.');
              vCampo[2] := strtran(vCampo[2],' set.'  ,' out.');
              vCampo[2] := strtran(vCampo[2],' ago.'  ,' set.');
              vCampo[2] := strtran(vCampo[2],' jul.'  ,' ago.');
              vCampo[2] := strtran(vCampo[2],' jun.'  ,' jul.');
              vCampo[2] := strtran(vCampo[2],' mai.'  ,' jun.');
              vCampo[2] := strtran(vCampo[2],' abr.'  ,' mai.');
              vCampo[2] := strtran(vCampo[2],' mar.'  ,' abr.');
              vCampo[2] := strtran(vCampo[2],' fev.'  ,' mar.');
              vCampo[2] := strtran(vCampo[2],' jan.'  ,' fev.');
            end;

  Form7.ibDataSet7.Append;                            // Registro Novo
  Form7.ibDataSet7DOCUMENTO.asString    := vCampo[1]; // documento
  Form7.ibDataSet7HISTORICO.AsString    := vCampo[2]; // Histórico
  Form7.ibDataSet7VALOR_DUPL.AsFloat    := vCampo[3]; // Valor
  Form7.ibDataSet7EMISSAO.AsDateTime    := vCampo[4]; // Emissão
  Form7.ibDataSet7VENCIMENTO.AsDAtetime := vCampo[5]; // Vencimento
  Form7.ibDataSet7NOME.AsString         := vCampo[6]; // Nome do Cliente
  Form7.ibDataSet7CONTA.AsString        := vCampo[7]; // Plano de contas

  Form7.ibDataSet7.Post;                              // Grava

  if edtDocumento.CanFocus then
    edtDocumento.SetFocus;
end;

procedure TFrmContaReceber.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmContaReceber.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmContaReceber.FormClose(Sender: TObject; var Action: TCloseAction);
var
  t: TTime;
  iRecno: Integer;
begin
  inherited;

  //Fas refresh do grid e volta para o registro atual
  try
    try
      t := Time;
      iRecno := Form7.ibDataSet7.RecNo;
      Form7.ibDataSet7.DisableControls;
      Form7.ibDataSet7.Close;
      Form7.ibDataSet7.Open;
      Form7.ibDataSet7.RecNo := iRecno;
    except
    end;
  finally
    Form7.ibDataSet7.EnableControls;
  end;
end;

procedure TFrmContaReceber.FormShow(Sender: TObject);
begin
  inherited;

  if edtDocumento.CanFocus then
    edtDocumento.SetFocus;
end;

procedure TFrmContaReceber.fraClienteExit(Sender: TObject);
begin
  inherited;
  fraCliente.FrameExit(Sender);

  CarregaCliente;
end;

function TFrmContaReceber.GetPaginaAjuda: string;
begin
  Result := 'cr.htm';
end;

procedure TFrmContaReceber.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  try
    if edtDocumento.CanFocus then
      edtDocumento.SetFocus;
  except
  end;
end;

procedure TFrmContaReceber.memContatosEnter(Sender: TObject);
begin
  inherited;

  sContatos := Form7.IBDataSet2CONTATOS.AsString;

  try
    if Form7.IBDataSet2.Modified then Form7.IBDataSet2.Post;
    Form7.IBDataSet2.Edit;
  except
    MensagemSistema('Este registro esá sendo usado por outro usuário.',msgAtencao);
    memContatos.Visible := False;
  end;

  SendMessage(memContatos.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(memContatos.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  memContatos.SelStart := Length(memContatos.Text); //move o cursor pra o final da ultima linha
  memContatos.SetFocus;
end;

procedure TFrmContaReceber.memContatosExit(Sender: TObject);
begin
  inherited;

  if StrTran(StrTran(StrTran(Form7.IBDataSet2CONTATOS.AsString,chr(10),''),chr(13),''),' ','') <> StrTran(StrTran(StrTran(sContatos,chr(10),''),chr(13),''),' ','') then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;

    Form7.IBDataSet2CONTATOS.AsString := Form7.IBDataSet2CONTATOS.AsString +chr(10) +'('+Senhas.UsuarioPub+') '+StrZero(Year(Date),4,0)+'-'+StrZero(Month(Date),2,0)+'-'+StrZero(day(Date),2,0)+' '+TimeToStr(Time);
  end;

  try
    if Form7.IBDataSet2.Modified then
      Form7.IBDataSet2.Post;
  except
    MensagemSistema('Não foi possível gravar o assunto do contato - Este registro está sendo usado por outro usuário.',msgAtencao);
    Form7.IBDataSet2.Cancel;
  end;

  Form7.ArquivoAberto.Edit;
end;

procedure TFrmContaReceber.memContatosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

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

procedure TFrmContaReceber.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtDocumento.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraPlanoContas.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtHistorico.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraCliente.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEmissao.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtVencimento.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtMovimento.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtDtQuitacao.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtValor.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtValorQuitado.Enabled := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtValorAtual.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtPortador.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCodBarra.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNossoNum.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNotaFiscal.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraInstituicao.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraFormaPag.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtAutorizacao.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtBandeira.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtContato.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtTelefone.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCelular.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEmail.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memContatos.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnReplicar.Enabled     := not (bSomenteLeitura);
end;



procedure TFrmContaReceber.AtualizaObjComValorDoBanco;
begin
  //Se não estiver ativo não carrega informações
  if not FormularioAtivo(Self) then
    Exit;

  //Plano de Contas
  try
    fraPlanoContas.TipoDePesquisa               := tpLocate;
    fraPlanoContas.GravarSomenteTextoEncontrato := True;
    fraPlanoContas.CampoVazioAbrirGridPesquisa  := True;
    fraPlanoContas.CampoCodigo                  := Form7.ibDataSet7CONTA;
    fraPlanoContas.CampoCodigoPesquisa          := 'NOME';
    fraPlanoContas.sCampoDescricao              := 'NOME';
    fraPlanoContas.sTabela                      := 'CONTAS';
    fraPlanoContas.CampoAuxExiber               := ',CONTA';
    fraPlanoContas.CarregaDescricao;
  except
  end;

  //Cliente
  try
    fraCliente.TipoDePesquisa                := tpSelect;
    fraCliente.GravarSomenteTextoEncontrato  := True;
    fraCliente.CampoVazioAbrirGridPesquisa   := True;
    fraCliente.CampoCodigo                   := Form7.ibDataSet7NOME;
    fraCliente.CampoCodigoPesquisa           := 'NOME';
    fraCliente.sCampoDescricao               := 'NOME';
    fraCliente.sTabela                       := 'CLIFOR';
    fraCliente.sFiltro                       := ' and coalesce(ATIVO,0)=0 ';
    fraCliente.CarregaDescricao;
  except
  end;

  //Instituição Financeira
  try
    fraInstituicao.TipoDePesquisa               := tpLocate;
    fraInstituicao.GravarSomenteTextoEncontrato := True;
    fraInstituicao.CampoVazioAbrirGridPesquisa  := True;
    fraInstituicao.CampoCodigo                  := Form7.ibDataSet7INSTITUICAOFINANCEIRA;
    fraInstituicao.CampoCodigoPesquisa          := 'NOME';
    fraInstituicao.sCampoDescricao              := 'NOME';
    fraInstituicao.sTabela                      := 'CLIFOR';
    fraInstituicao.sFiltro                      := ' and CLIFOR in ('+QuotedStr(_RelComInstituicao)+','+QuotedStr(_RelComCredenciadora)+') ';
    fraInstituicao.CarregaDescricao;
  except
  end;

  //Forma de pagamento
  try
    fraFormaPag.TipoDePesquisa               := tpLocate;
    fraFormaPag.GravarSomenteTextoEncontrato := True;
    fraFormaPag.CampoVazioAbrirGridPesquisa  := True;
    fraFormaPag.CampoCodigo                  := Form7.ibDataSet7FORMADEPAGAMENTO;
    fraFormaPag.CampoCodigoPesquisa          := 'NOME';
    fraFormaPag.sCampoDescricao              := 'NOME';
    fraFormaPag.sTabela                      := SELECT_TABELA_VIRTUAL_FORMAS_DE_PAGAMENTO;
    fraFormaPag.CarregaDescricao;
  except
  end;


  CarregaCliente;
end;

procedure TFrmContaReceber.CarregaCliente;
begin
  try
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Text := ' select * from CLIFOR'+
                                       ' where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString);
    Form7.ibDataSet2.Open;
  except
  end;
end;

procedure TFrmContaReceber.AlteracaoInstituicaoFinanceira;
var
  vDescricaoAntes : string;
  vQtdParcelas : integer;
begin
  //Mauricio Parizotto 2023-05-29
  try
    //Verifica se mudou
    // Sandro Silva 2023-09-12 Necessário converter retorno do tipo Variant para String, estava causando exception quando cadastrava nova conta
    vDescricaoAntes := VarToStr(ExecutaComandoEscalar(Form7.ibDataSet7.Transaction.DefaultDatabase,
                                             ' Select Coalesce(INSTITUICAOFINANCEIRA,'''')  '+
                                             ' From RECEBER'+
                                             ' Where REGISTRO ='+QuotedStr(Form7.ibDataSet7REGISTRO.AsString))
                                             );

    if Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString <> vDescricaoAntes then
    begin
      if Trim(Form7.ibDataSet7NUMERONF.AsString) = '' then
        Exit;

      vQtdParcelas := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction.DefaultDatabase,
                                           ' Select count(*)  '+
                                           ' From RECEBER'+
                                           ' Where NUMERONF ='+QuotedStr(Form7.ibDataSet7NUMERONF.AsString));

      if vQtdParcelas > 1 then
      begin
        if Application.MessageBox(PChar('Deseja atribuir essa mesma Instituição financeira para os demais registros dessa venda?'),
                                  'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = id_Yes then
        begin
          ExecutaComando(' Update RECEBER'+
                         '   set INSTITUICAOFINANCEIRA ='+QuotedStr(Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString)+
                         ' Where NUMERONF ='+QuotedStr(Form7.ibDataSet7NUMERONF.AsString),
                         Form7.ibDataSet7.Transaction );
        end;
      end;
    end;
  except
  end;
end;


end.
