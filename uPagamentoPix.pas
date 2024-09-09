unit uPagamentoPix;

interface

uses
  IBX.IBCustomDataSet, System.SysUtils, System.IniFiles, IBX.IBQuery,
  IBX.IBDatabase;

  function FormaPagamentoPix(DataSet : TibDataSet; TipoPix:string) : integer;

  //Pix Estático
  function PagamentoPixEstatico(Valor : double; IDTransacao : string; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;

  //Pix Dinamico Itaú
  function PagamentoPixDinamico(Valor : double; IDTransacao, NumeroNF, Caixa : string;
            out InstituicaoFinanceira, CodigoAutorizacao : string; IBTRANSACTION: TIBTransaction):boolean;
  procedure GravaTransacaoItau(NumeroNF, Caixa, OrderID, Status : string; Valor : Double; IBDatabase: TIBDatabase);
  procedure AtualizaStatusTransacaoItau(OrderID, Status : string; IBDatabase: TIBDatabase; CodAutorizacao : string = ''; CNPJINSTITUICAO : string = '');

implementation

{$R-} //Desativa Range check error

uses
  uConectaBancoSmall
  , ufrmSelecionarPIX
  , ufrmQRCodePixEst
  , ufrmQRCodePixDin
  , uDialogs
  , smallfunc_xe
  , uIntegracaoItau
  , uGeraChavePix
  , uTypesRecursos
  , uValidaRecursos
  , _small_65
  , uSmallConsts, uIntegracaoSicoob;


function CRC16CCITT(texto: string): WORD;
const
  polynomial = $1021;
var
  crc: WORD;
  i, j: Integer;
  b: Byte;
  bit, c15: Boolean;
begin
  crc := $FFFF;
  for i := 1 to length(texto) do
  begin
    b := Byte(texto[i]);
    for j := 0 to 7 do
    begin
      bit := (((b shr (7 - j)) and 1) = 1);
      c15 := (((crc shr 15) and 1) = 1);
      crc := crc shl 1;
      if (c15 xor bit) then
        crc := crc xor polynomial;
    end;
  end;
  Result := crc and $FFFF;
end;

function FormaPagamentoPix(DataSet : TibDataSet; TipoPix:string) : integer;
var
  i : integer;
  CampoV : string;
  FrenteIni: TIniFile;
begin
  Result := 0;

  try
    FrenteIni  := TIniFile.Create('FRENTE.INI');

    for I := 1 to 8 do
    begin
      CampoV := 'VALOR0'+IntToStr(i);

      //Verifica se a forma foi usada
      if DataSet.FieldByName(CampoV).AsFloat > 0 then
      begin
        //Verifica se a forma está configurada como PIX
        if (Copy(FrenteIni.ReadString('NFCE', 'Ordem forma extra '+I.ToString, ''), 1, 2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO)
         or (Copy(FrenteIni.ReadString('NFCE', 'Ordem forma extra '+I.ToString, ''), 1, 2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO) then
        begin
          //Verifica o Tipo Mauricio Parizotto 2024-06-14
          if FrenteIni.ReadString('NFCE', 'Tipo Pix '+I.ToString, '') = TipoPix then
            Result := i;
        end;
      end;
    end;
  finally
    FreeAndNil(FrenteIni);
  end;
end;

function PagamentoPixEstatico(Valor : double; IDTransacao : string; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
var
  ibqBancos: TIBQuery;
  ChaveQRCode : string;
begin
  Result := False;

  try
    ibqBancos := CriaIBQuery(IBTRANSACTION);
    ibqBancos.SQL.Text := ' Select '+
                          '   B.REGISTRO,'+
                          ' 	B.NOME,'+
                          ' 	B.INSTITUICAOFINANCEIRA,'+
                          ' 	B.PIXTIPOCHAVE,'+
                          ' 	B.PIXTITULAR,'+
                          ' 	B.PIXCHAVE,'+
                          ' 	E.MUNICIPIO'+
                          ' From BANCOS B'+
                          ' 	Left Join EMITENTE E on 1=1'+
                          ' Where PIXESTATICO = ''S'' ';
    ibqBancos.Open;
    ibqBancos.Last; //Para funcionar RecordCount

    //Nenhum banco configurado com pix estático
    if ibqBancos.IsEmpty then
    begin
      MensagemSistema('Nenhum banco com PIX habilitado!',msgAtencao);
      Exit;
    end;

    //Se tiver mais que um configurado abre tela para selecionar
    if ibqBancos.RecordCount > 1 then
    begin
      ibqBancos.First;

      if not SelecionaChavePIX(ibqBancos) then
        Exit;
    end;

    ChaveQRCode := GeraChavePixEstatica(ibqBancos.FieldByName('PIXTITULAR').AsString,
                                        ibqBancos.FieldByName('MUNICIPIO').AsString,
                                        ibqBancos.FieldByName('PIXCHAVE').AsString,
                                        ibqBancos.FieldByName('PIXTIPOCHAVE').AsString,
                                        IDTransacao,
                                        Valor
                                       );

    if PagamentoQRCodePIX(ChaveQRCode,Valor) then
    begin
      InstituicaoFinanceira := ibqBancos.FieldByName('INSTITUICAOFINANCEIRA').AsString;
      Result := True;
    end;
  finally
    FreeAndNil(ibqBancos);
  end;
end;


function PagamentoPixDinamico(Valor : double; IDTransacao, NumeroNF, Caixa : string;
  out InstituicaoFinanceira, CodigoAutorizacao : string; IBTRANSACTION: TIBTransaction):boolean;
var
  ibqItau, ibqSicoob: TIBQuery;
  ChaveQRCode, order_id, Mensagem : string;

  //bLiberado : Boolean;
  bLibItau, bLibSicoob, bHabItau, bHabSicoob : Boolean;
  dLimiteRecurso : Tdate;
  Integracao : TRecursos;
  ITAU_CLIENTID, ITAU_USUARIO, ITAU_SENHA, ITAU_CGC, ITAU_INSTITUICAOFINANCEIRA : string;
  IDAPIPIX : integer;
  SICOOB_INSTITUICAOFINANCEIRA : string;
begin
  CodigoAutorizacao := '';
  Result            := False;
  bLibItau          := False;
  bLibSicoob        := False;
  bHabItau          := False;
  bHabSicoob        := False;

  {$Region'//// Código Antigo ////'}

  {Mauricio Parizotto 2024-09-06
  bLiberado := (RecursoLiberado(IBTRANSACTION.DefaultDatabase,rcIntegracaoItau,dLimiteRecurso));

  if not bLiberado then
  begin
    MensagemSistema('Integração Itaú não está disponível para esta licença' + Chr(10) + Chr(10) +
                    _RecursoIndisponivel
                    ,msgAtencao);
    Exit;
  end;

  try
    ibqItau := CriaIBQuery(IBTRANSACTION);
    ibqItau.SQL.Text := ' Select '+
                        ' 	I.USUARIO,'+
                        ' 	I.SENHA,'+
                        ' 	I.CLIENTID,'+
                        '   B.NOME,'+
                        ' 	B.INSTITUICAOFINANCEIRA,'+
                        '   C.CGC'+
                        ' From CONFIGURACAOITAU I'+
                        ' 	Left Join BANCOS B on B.IDBANCO = I.IDBANCO'+
                        '   Left Join CLIFOR C on C.NOME = B.INSTITUICAOFINANCEIRA '+
                        ' Where I.HABILITADO = ''S'' ';
    ibqItau.Open;

    //Nenhum banco configurado com pix estático
    if ibqItau.IsEmpty then
    begin
      MensagemSistema('Nenhuma integração habilitada!',msgAtencao);
      Exit;
    end;

    if Trim(ibqItau.FieldByName('INSTITUICAOFINANCEIRA').AsString) = '' then
    begin
      MensagemSistema('A conta bancaria "'+ibqItau.FieldByName('NOME').AsString+'" não possui Instituição Financeira vinculada!',msgAtencao);
      Exit;
    end;

    if GeraChavePixItau(ibqItau.FieldByName('CLIENTID').AsString,
                        ibqItau.FieldByName('USUARIO').AsString,
                        ibqItau.FieldByName('SENHA').AsString,
                        IDTransacao,
                        Valor,
                        ChaveQRCode,
                        order_id,
                        Mensagem) then
    begin
      //Grava
      GravaTransacaoItau(NumeroNF,
                         Caixa,
                         order_id,
                         'Pendente',
                         Valor,
                         IBTRANSACTION.DefaultDatabase);
    end else
    begin
      MensagemSistema(Mensagem,msgAtencao);
      Exit;
    end;

    if PagamentoQRCodePIXDin(ChaveQRCode,
                             order_id,
                             Valor,
                             LimpaNumero(ibqItau.FieldByName('CGC').AsString),
                             CodigoAutorizacao,
                             IBTRANSACTION.DefaultDatabase) then
    begin
      InstituicaoFinanceira := ibqItau.FieldByName('INSTITUICAOFINANCEIRA').AsString;
      Result := True;
    end;
  finally
    FreeAndNil(ibqItau);
  end;

  }
  {$Endregion}

  bLibItau    := (RecursoLiberado(IBTRANSACTION.DefaultDatabase,rcIntegracaoItau,dLimiteRecurso));
  bLibSicoob  := (RecursoLiberado(IBTRANSACTION.DefaultDatabase,rcIntegracaoSicoob,dLimiteRecurso));

  if (not bLibItau) and (not bLibSicoob) then
  begin
    MensagemSistema('Nenhuma integração disponível para esta licença' + Chr(10) + Chr(10) +
                    _RecursoIndisponivel
                    ,msgAtencao);
    Exit;
  end;

  {$Region'//// Consulta Itaú ////'}
  if bLibItau then
  begin
    try
      ibqItau := CriaIBQuery(IBTRANSACTION);
      ibqItau.SQL.Text := ' Select '+
                          ' 	I.USUARIO,'+
                          ' 	I.SENHA,'+
                          ' 	I.CLIENTID,'+
                          '   B.NOME,'+
                          ' 	B.INSTITUICAOFINANCEIRA,'+
                          '   C.CGC'+
                          ' From CONFIGURACAOITAU I'+
                          ' 	Left Join BANCOS B on B.IDBANCO = I.IDBANCO'+
                          '   Left Join CLIFOR C on C.NOME = B.INSTITUICAOFINANCEIRA '+
                          ' Where I.HABILITADO = ''S'' ';
      ibqItau.Open;

      if not(ibqItau.IsEmpty) then
      begin
        if  (Trim(ibqItau.FieldByName('INSTITUICAOFINANCEIRA').AsString) = '') then
        begin
          MensagemSistema('A conta bancaria "'+ibqItau.FieldByName('NOME').AsString+'" não possui Instituição Financeira vinculada!',msgAtencao);
          Exit;
        end else
        begin
          bHabItau := True;
          ITAU_CLIENTID              := ibqItau.FieldByName('CLIENTID').AsString;
          ITAU_USUARIO               := ibqItau.FieldByName('USUARIO').AsString;
          ITAU_SENHA                 := ibqItau.FieldByName('SENHA').AsString;
          ITAU_CGC                   := ibqItau.FieldByName('CGC').AsString;
          ITAU_INSTITUICAOFINANCEIRA := ibqItau.FieldByName('INSTITUICAOFINANCEIRA').AsString;
        end;
      end;
    finally
      FreeAndNil(ibqItau);
    end;
  end;
  {$Endregion}

  {$Region'//// Consulta Sicoob ////'}
  if bLibSicoob then
  begin
    try
      ibqSicoob := CriaIBQuery(IBTRANSACTION);
      ibqSicoob.SQL.Text := ' Select '+
                            ' 	S.IDAPIPIX,'+
                            '   B.NOME,'+
                            ' 	B.INSTITUICAOFINANCEIRA'+
                            ' From CONFIGURACAOSICOOB S'+
                            ' 	Left Join BANCOS B on B.IDBANCO = S.IDBANCO'+
                            ' Where S.HABILITADO = ''S'' ';
      ibqSicoob.Open;

      if not(ibqSicoob.IsEmpty) then
      begin
        if  (Trim(ibqSicoob.FieldByName('INSTITUICAOFINANCEIRA').AsString) = '') then
        begin
          MensagemSistema('A conta bancaria "'+ibqSicoob.FieldByName('NOME').AsString+'" não possui Instituição Financeira vinculada!',msgAtencao);
          Exit;
        end else
        begin
          bHabSicoob := True;
          IDAPIPIX                     := ibqSicoob.FieldByName('IDAPIPIX').AsInteger;
          SICOOB_INSTITUICAOFINANCEIRA := ibqSicoob.FieldByName('INSTITUICAOFINANCEIRA').AsString;
        end;
      end;
    finally
      FreeAndNil(ibqSicoob);
    end;
  end;
  {$Endregion}

  {$Region'//// Seleciona Integração ////'}

  if not(bHabItau) and not(bHabSicoob) then
  begin
    MensagemSistema('Nenhuma integração habilitada!',msgAtencao);
    Exit;
  end;

  if (bHabItau) and (bHabSicoob) then
  begin
    /////////////////////////////////////////////////
  end else
  begin
    if bHabItau then
      Integracao := rcIntegracaoItau;

    if bHabSicoob then
      Integracao := rcIntegracaoSicoob;
  end;
  {$Endregion}

  {$Region'//// Gera PIX Itaú ////'}
  if Integracao = rcIntegracaoItau then
  begin
    if GeraChavePixItau(ITAU_CLIENTID,
                        ITAU_USUARIO,
                        ITAU_SENHA,
                        IDTransacao,
                        Valor,
                        ChaveQRCode,
                        order_id,
                        Mensagem) then
    begin
      //Grava
      GravaTransacaoItau(NumeroNF,
                         Caixa,
                         order_id,
                         'Pendente',
                         Valor,
                         IBTRANSACTION.DefaultDatabase);
    end else
    begin
      MensagemSistema(Mensagem,msgAtencao);
      Exit;
    end;

    if PagamentoQRCodePIXDinItau(ChaveQRCode,
                                 order_id,
                                 Valor,
                                 LimpaNumero(ITAU_CGC),
                                 CodigoAutorizacao,
                                 IBTRANSACTION.DefaultDatabase) then
    begin
      InstituicaoFinanceira := ITAU_INSTITUICAOFINANCEIRA;
      Result := True;
    end;
  end;
  {$Endregion}

  {$Region'//// Gera PIX Sicoob ////'}
  if Integracao = rcIntegracaoSicoob then
  begin
    if GeraChavePixISicoob(IDAPIPIX,
                           IDTransacao,
                           Valor,
                           ChaveQRCode,
                           order_id,
                           Mensagem) then
    begin
    end else
    begin
      MensagemSistema(Mensagem,msgAtencao);
      Exit;
    end;

    if PagamentoQRCodePIXDinSicoob(ChaveQRCode,
                                   order_id,
                                   Valor,
                                   CodigoAutorizacao,
                                   IBTRANSACTION.DefaultDatabase) then
    begin
      InstituicaoFinanceira := SICOOB_INSTITUICAOFINANCEIRA;
      Result := True;
    end;
  end;
  {$Endregion}

end;

procedure GravaTransacaoItau(NumeroNF, Caixa, OrderID, Status : string; Valor : Double; IBDatabase: TIBDatabase);
var
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  sValor : string;
begin
  IBTSALVA    := CriaIBTransaction(IBDatabase);
  IBQSALVA    := CriaIBQuery(IBTSALVA);

  sValor := StringReplace(Valor.ToString,'.','',[rfReplaceAll]);
  sValor := StringReplace(sValor,',','.',[rfReplaceAll]);

  try
    IBQSALVA.SQL.Text := ' Insert into ITAUTRANSACAO(IDTRANSACAO,NUMERONF,CAIXA,ORDERID,DATAHORA,STATUS,VALOR)'+
                         ' Values('+
                         '(Select gen_id(G_ITAUTRANSACAO,1) From rdb$database),'+
                         QuotedStr(NumeroNF)+','+
                         QuotedStr(Caixa)+','+
                         QuotedStr(OrderID)+','+
                         'CURRENT_TIMESTAMP,'+
                         QuotedStr(Status)+','+
                         sValor+
                         ')' ;
    IBQSALVA.ExecSQL;
    IBTSALVA.Commit;
  finally
    FreeAndNil(IBQSALVA);
    FreeAndNil(IBTSALVA);
  end;
end;

procedure AtualizaStatusTransacaoItau(OrderID, Status : string; IBDatabase: TIBDatabase; CodAutorizacao : string = ''; CNPJINSTITUICAO : string = '');
var
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  sAtualizaAutorizacao, sAtualizaCNPJ : string;
begin
  IBTSALVA    := CriaIBTransaction(IBDatabase);
  IBQSALVA    := CriaIBQuery(IBTSALVA);

  if CodAutorizacao <> '' then
    sAtualizaAutorizacao := ' , CODIGOAUTORIZACAO = '+QuotedStr(CodAutorizacao);

  if CNPJINSTITUICAO <> '' then
    sAtualizaCNPJ := ' , CNPJINSTITUICAO = '+QuotedStr(CNPJINSTITUICAO);

  try
    IBQSALVA.SQL.Text := ' Update ITAUTRANSACAO '+
                         '   set STATUS = '+ QuotedStr(Status)+
                         sAtualizaAutorizacao+
                         sAtualizaCNPJ+
                         ' Where ORDERID = '+ QuotedStr(OrderID) ;
    IBQSALVA.ExecSQL;
    IBTSALVA.Commit;
  finally
    FreeAndNil(IBQSALVA);
    FreeAndNil(IBTSALVA);
  end;
end;

end.
