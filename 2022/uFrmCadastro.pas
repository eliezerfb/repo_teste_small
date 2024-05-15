unit uFrmCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls, uObjetoConsultaCEP, uConsultaCEP,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo, Winapi.ShellAPI, System.IniFiles, System.StrUtils;

type
  TFrmCadastro = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    tbsFoto: TTabSheet;
    Label2: TLabel;
    edtCPFCNPJ: TSMALL_DBEdit;
    Label3: TLabel;
    SMALL_DBEdit2: TSMALL_DBEdit;
    Label4: TLabel;
    SMALL_DBEdit3: TSMALL_DBEdit;
    Label5: TLabel;
    SMALL_DBEdit4: TSMALL_DBEdit;
    Label6: TLabel;
    SMALL_DBEdit5: TSMALL_DBEdit;
    imgEndereco: TImage;
    Label7: TLabel;
    SMALL_DBEdit6: TSMALL_DBEdit;
    Label8: TLabel;
    Label9: TLabel;
    SMALL_DBEdit8: TSMALL_DBEdit;
    Label10: TLabel;
    edtRG_IE: TSMALL_DBEdit;
    Label11: TLabel;
    SMALL_DBEdit10: TSMALL_DBEdit;
    Label12: TLabel;
    SMALL_DBEdit11: TSMALL_DBEdit;
    Label13: TLabel;
    SMALL_DBEdit12: TSMALL_DBEdit;
    Label14: TLabel;
    SMALL_DBEdit13: TSMALL_DBEdit;
    Label15: TLabel;
    SMALL_DBEdit14: TSMALL_DBEdit;
    lblLimiteCredDisponivel: TLabel;
    eLimiteCredDisponivel: TEdit;
    Label16: TLabel;
    SMALL_DBEdit15: TSMALL_DBEdit;
    Label17: TLabel;
    SMALL_DBEdit16: TSMALL_DBEdit;
    Label18: TLabel;
    SMALL_DBEdit17: TSMALL_DBEdit;
    lblConvenio: TLabel;
    Label19: TLabel;
    SMALL_DBEdit19: TSMALL_DBEdit;
    Label20: TLabel;
    SMALL_DBEdit20: TSMALL_DBEdit;
    Label21: TLabel;
    SMALL_DBEdit21: TSMALL_DBEdit;
    Label22: TLabel;
    SMALL_DBEdit22: TSMALL_DBEdit;
    Label23: TLabel;
    SMALL_DBEdit23: TSMALL_DBEdit;
    Label25: TLabel;
    DBMemo1: TDBMemo;
    Label26: TLabel;
    SMALL_DBEdit24: TSMALL_DBEdit;
    Label27: TLabel;
    DBMemo2: TDBMemo;
    fraConvenio: TfFrameCampo;
    fraMunicipio: TfFrameCampo;
    cboRelacaoCom: TComboBox;
    Label56: TLabel;
    pnl_IE: TPanel;
    rgIEContribuinte: TRadioButton;
    rgIENaoContribuinte: TRadioButton;
    rgIEIsento: TRadioButton;
    btnRenogiarDivida: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure SMALL_DBEdit4Exit(Sender: TObject);
    procedure SMALL_DBEdit4Enter(Sender: TObject);
    procedure SMALL_DBEdit5Exit(Sender: TObject);
    procedure SMALL_DBEdit6Exit(Sender: TObject);
    procedure SMALL_DBEdit13Exit(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboRelacaoComChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgIEContribuinteClick(Sender: TObject);
    procedure rgIENaoContribuinteClick(Sender: TObject);
    procedure rgIEIsentoClick(Sender: TObject);
    procedure edtCPFCNPJChange(Sender: TObject);
    procedure SMALL_DBEdit14Exit(Sender: TObject);
    procedure imgEnderecoClick(Sender: TObject);
    procedure btnRenogiarDividaClick(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure Label19MouseLeave(Sender: TObject);
    procedure Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBMemo2Enter(Sender: TObject);
    procedure DBMemo2Exit(Sender: TObject);
    procedure DBMemo2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit8Exit(Sender: TObject);
  private
    { Private declarations }
    FcCEPAnterior: String;
    sContatos : String;
    bProximo  : boolean;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure DefineCamposCEP(AoObjeto: TObjetoConsultaCEP);
    procedure LimpaEspaco(Campo : TSMALL_DBEdit);
    procedure AtualizaObjComValorDoBanco;
    procedure CarregaTipoContibuinte;
    procedure SetTipoContribuinte(iTipo: integer);
    procedure DefinirLimiteDisponivel;
  public
    { Public declarations }
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.dfm}

uses unit7
  , uDialogs
  , uRetornaLimiteDisponivel, smallfunc_xe, uFuncoesBancoDados, MAIS,
  uFrmParcelas, MAIS3;

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
  Except
  end;

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
  with Sender as TLabel do
  begin
    Font.Style := [];
    Font.Color := clBlack;
    Repaint;
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
  //
end;

procedure TFrmCadastro.SMALL_DBEdit13Exit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.SMALL_DBEdit14Exit(Sender: TObject);
begin
  DefinirLimiteDisponivel;
end;

procedure TFrmCadastro.SMALL_DBEdit4Enter(Sender: TObject);
begin
  FcCEPAnterior := TSMALL_DBEdit(Sender).Text;
end;

procedure TFrmCadastro.SMALL_DBEdit4Exit(Sender: TObject);
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

procedure TFrmCadastro.SMALL_DBEdit5Exit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.SMALL_DBEdit6Exit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.SMALL_DBEdit8Exit(Sender: TObject);
begin
  if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
  begin
    fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
  end else
  begin
    fraMunicipio.sFiltro := ' ';
  end;
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

procedure TFrmCadastro.DBMemo2Enter(Sender: TObject);
begin
  sContatos := Form7.IBDataSet2CONTATOS.AsString;

  if Form7.ArquivoAberto.Modified then
    Form7.ArquivoAberto.Post;

  Form7.ArquivoAberto.Edit;

  SendMessage(dbMemo2.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(dbMemo2.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  dbMemo2.SelStart := Length(dbMemo2.Text); //move o cursor pra o final da ultima linha
  dbMemo2.SetFocus;
end;

procedure TFrmCadastro.DBMemo2Exit(Sender: TObject);
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

procedure TFrmCadastro.DBMemo2KeyDown(Sender: TObject; var Key: Word;
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
  with Sender as TLabel do
  begin
    Font.Style := [fsBold,fsUnderline];
    Font.Color := clBlue;
    Repaint;
  end;
end;

end.
