unit controller.cancel;

interface

uses
  Horse,
  System.SysUtils,
  System.Classes,
  System.JSON,
  ACBrNFSeX,
  ACBrDFeSSL,
  pcnConversao,
  ACBrNFSeXConversao,
  ACBrDFeUtil,
  nfse.search.nfserps,
  nfse.classes.helpers,
  nfse.classe.cancelamento,
  nfse.classe.retorno,
  nfse.configura_componente,
  ACBrNFSeXWebserviceBase,
  nfse.checa_resposta,
  nfse.classe.configura_componente,
  nfse.checaservico,
  nfse.retorna_filaws,
  nfse.constants,
  nfse.envia_xml,
  nfse.funcoes;


  Type TControllerCancel = Class
    Private
      class procedure cancela(AcbrNFSe      : TACBrNFSeX;
                              ClassNFSeCancelamento : TNfseCancelamento;
                              classRetorno  : TNFSeRetorno);
    public
      class procedure Cancel(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure registry;
  End;

implementation


{ TControllerCancel }

class procedure TControllerCancel.Cancel(Req: THorseRequest;
                                         Res: THorseResponse; Next: TProc);
var
  numlote : string;
  classeConfiguraComponente : TConfiguracaoProvedor;
  ClassNFSeCancelamento : TNfseCancelamento;
  classRetorno  : TNFSeRetorno;
  AcbrNFSe      : TACBrNFSeX;
  retornoFila   : TRetornoFila;
  varTemp      : String;
begin

  ClassNFSeCancelamento := TNfseCancelamento.Create;

  classRetorno := TNFSeRetorno.create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  classeConfiguraComponente := TConfiguracaoProvedor.Create;

  Try
    try
      ClassNFSeCancelamento.AsJson    := Req.Body;
      ClassRetorno.nfseId             := ClassNFSeCancelamento.nfseId;
      ClassNFSeCancelamento.tokenid     := Req.Headers['Authorization-Compufacil'];
      ClassNFSeCancelamento.socketId  := Req.Headers['Socket-Id'];
    Except
      on e : exception do begin
        classRetorno.MensagemCompleta := 'Json inválido: '+e.Message;
        exit;
      end;
    end;

    classeConfiguraComponente.CodigoMunicipio := ClassNFSeCancelamento.Provedor.CodigoMunicipio;
    classeConfiguraComponente.EmitenteCnpj    := ClassNFSeCancelamento.Provedor.EmitenteCnpj;
    classeConfiguraComponente.EmitenteIE      := ClassNFSeCancelamento.Provedor.EmitenteIE;
    classeConfiguraComponente.EmitenteInscricaoMunicipal  := ClassNFSeCancelamento.Provedor.InscricaoMunicipal;
    classeConfiguraComponente.EmitenteRazaoSocial         := ClassNFSeCancelamento.Provedor.EmitenteRazaoSocial;
    classeConfiguraComponente.EmitenteSenha               := ClassNFSeCancelamento.Provedor.EmitenteSenha;
    classeConfiguraComponente.EmitenteUsuario             := ClassNFSeCancelamento.Provedor.EmitenteUsuario;
    classeConfiguraComponente.Producao                    := ClassNFSeCancelamento.Provedor.Producao;
    classeConfiguraComponente.SenhaCertificado            := ClassNFSeCancelamento.Provedor.SenhaCertificado;
    classeConfiguraComponente.UF := ClassNFSeCancelamento.Provedor.UF;
    classeConfiguraComponente.UrlCertificado    := ClassNFSeCancelamento.Provedor.UrlCertificado;
    classeConfiguraComponente.FraseSecreta      := ClassNFSeCancelamento.Provedor.FraseSecreta;
    classeConfiguraComponente.ChaveAcesso       := ClassNFSeCancelamento.Provedor.ChaveAcesso;
    classeConfiguraComponente.ChaveAutorizacao  := ClassNFSeCancelamento.Provedor.ChaveAutorizacao;
    classeConfiguraComponente.SalvarArquivoSoap := ClassNFSeCancelamento.Provedor.SalvarArquivoSoap;
    classeConfiguraComponente.PathLocal := ClassNFSeCancelamento.Provedor.PathLocal;
    classeConfiguraComponente.Layout := ClassNFSeCancelamento.Provedor.layout;
    try
      nfse.configura_componente.configuraComponente(classeConfiguraComponente,
                                                    AcbrNFSe);
    Except
      on e: Exception do
      begin
        classRetorno.Correcao := 'Verifique os parâmetros de envio.';
        classRetorno.Situacao := 0;
        classRetorno.MensagemCompleta :=
          'Exceção ao configurar componente : '+e.Message;
      end;
    end;

    try
      cancela(AcbrNFSe, ClassNFSeCancelamento, classRetorno);
    Except
      on e: Exception do
      begin
        classRetorno.MensagemCompleta := classRetorno.MensagemCompleta+
          ' Exceção ao cancelar : '+e.Message;
      end;
    end;
  Finally
    if not (ClassNFSeCancelamento.IndependentNfse) then
    begin
      try
        retornoFila := TRetornoFila.Create;
        try
          retornoFila.tokenid   := ClassNFSeCancelamento.tokenid;
          retornoFila.socketId  := ClassNFSeCancelamento.socketId;
          retornoFila.endpoint  := getEndPointCancel;
          retornoFila.Enviaretorno(classRetorno);
        finally
          FreeAndNil(retornoFila);
        end;
      Except
      end;
    end;
    Res.Send(classRetorno.AsJson);
    FreeAndNil(ClassNFSeCancelamento);
    FreeAndNil(classeConfiguraComponente);
    FreeAndNil(classRetorno);
    FreeAndNil(AcbrNFSe);
  End;
end;

class procedure TControllerCancel.Cancela(AcbrNFSe     : TACBrNFSeX;
                                         ClassNFSeCancelamento : TNfseCancelamento;
                                         classRetorno  : TNFSeRetorno);
var
  varNumNFSe, varCodigo, varMotivo, varNumLote, varCodVerif, varSerNFSe,
  varserRPS, varNumRps, varValNFSe, varChNFSe : string;
  CodCanc : integer;
  InfCancelamento: TInfCancelamento;
  xmlenviohttp :  TNfseHTTP;
  XMLFiles: TStringList;
  InfEvento: TInfEvento;

  varTemp : string;
begin
  // Codigo de Cancelamento
  // 1 - Erro de emissão
  // 2 - Serviço não concluido
  // 3 - RPS Cancelado na Emissão
  varNumNFSe  := '';
  varCodigo   := '';
  varMotivo   := '';
  varNumLote  := '';
  varCodVerif := '';
  varSerNFSe  := '';
  varNumRps   := '';
  varValNFSe  := '';
  varChNFSe   := '';
  varserRPS   := '';

  if AcbrNFSe.Configuracoes.Geral.Provedor = proSoftPlan then
    AcbrNFSe.GerarToken;
  if AcbrNFSe.Configuracoes.Geral.Provedor = proISSJoinville then
  begin
    if (ClassNFSeCancelamento.NumeroNfse = '0') then
    begin
      classRetorno.Mensagem := 'Antes de cancelar a NFSe é necessário efetuar a consulta da mesma.'+#13+
                                'Em seguida efetue o cancelamento.';
      Exit;
    end;
  end;

  if ((AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc) and (AcbrNFSe.Configuracoes.Geral.Versao in [ve100,ve101])) then
  begin
    varChNFSe := ClassNFSeCancelamento.ChaveNfse;
    varCodigo := ClassNFSeCancelamento.Codigo;
  end
  else
  begin
    varCodigo  := ClassNFSeCancelamento.codigo;
    varNumNFSe := ClassNFSeCancelamento.NumeroNfse;
    if AcbrNFSe.Configuracoes.Geral.Provedor in [proWebFisco,
      proSimple, proFGMaiss, proiiBrasil, proIPM] then
    begin
      varSerNFSe := ClassNFSeCancelamento.SerieNfse;
    end;
    if AcbrNFSe.Configuracoes.Geral.Provedor = proConam then
    begin
      varSerNFSe  := ClassNFSeCancelamento.SerieNfse;
      varNumRps   := ClassNFSeCancelamento.NumeroRPS;
      varSerRps   := '1';
      varValNFSe  := ClassNFSeCancelamento.ValorNfse;
    end;
  end;
  if AcbrNFSe.Configuracoes.Geral.Provedor = proSigep then
  begin
    CodCanc := StrToIntDef(ClassNFSeCancelamento.Codigo, 1);

    case CodCanc of
      1: varCodigo := 'EE';
      2: varCodigo := 'ED';
      3: varCodigo := 'OU';
      4: varCodigo := 'SB';
    end;
  end;
  if AcbrNFSe.Configuracoes.Geral.Provedor = proPublica then
  begin
    CodCanc := StrToIntDef(ClassNFSeCancelamento.Codigo, 1);
    case CodCanc of
      1: varCodigo := 'C001';
      2: varCodigo := 'C002';
      3: varCodigo := 'C003';
      4: varCodigo := 'C004';
      5: varCodigo := 'C005';
      6: varCodigo := 'C999';
    end;
  end;
  if AcbrNFSe.Configuracoes.Geral.Provedor in [proAgili, proAssessorPublico,
    proConam, proEquiplano, proGoverna, proIPM, proISSDSF,
    proISSLencois, proModernizacaoPublica, proPublica, proSiat, proSigISS, proSigep,
    proSmarAPD, proWebFisco, proTecnos, proSudoeste, proSimple, proFGMaiss] then
  begin
    varMotivo := ClassNFSeCancelamento.Motivo;
  end;
  if AcbrNFSe.Configuracoes.Geral.Provedor = proAssessorPublico then
  begin
    varNumLote := ClassNFSeCancelamento.NumeroLote;
  end;

  if (AcbrNFSe.Configuracoes.Geral.Provedor in [proISSDSF, proissLencois, proGoverna, proSiat, proSigep, proElotech]) or
    ((AcbrNFSe.Configuracoes.Geral.Provedor in [proInfisc]) and (AcbrNFSe.Configuracoes.Geral.Versao in [ve100,ve101])) then
  begin
    varCodVerif := '12345678';
    varCodVerif := ClassNFSeCancelamento.CodigoVerificacao;
  end;

  if AcbrNFSe.Configuracoes.Geral.Provedor = proPadraoNacional then
  begin
    InfEvento := TInfEvento.Create;
    try
      with InfEvento.pedRegEvento do
      begin
        varTemp  := ClassNFSeCancelamento.ChaveNfse;
        tpAmb := AcbrNFSe.Configuracoes.WebServices.AmbienteCodigo;
        verAplic := 'Zucchetti-1.0';
        dhEvento := date;
        chNFSe := ClassNFSeCancelamento.ChaveNfse;
        nPedRegEvento := 1;
        tpEvento := ACBrNFSeXConversao.teCancelamento;
        cMotivo := StrToIntDef(varCodigo, 1);
        xMotivo := ClassNFSeCancelamento.Motivo;
      end;

      AcbrNFSe.EnviarEvento(InfEvento);
    finally
      InfEvento.Free;
    end;

    TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno, tmEnviarEvento);
  end
  else
  begin
    InfCancelamento := TInfCancelamento.Create;
    try
      with InfCancelamento do
      begin
        NumeroNFSe      := varNumNFSe;
        SerieNFSe       := varSerNFSe;
        ChaveNFSe       := varChNFSe;
        CodCancelamento := varCodigo;
        MotCancelamento := varMotivo;
        NumeroLote      := varNumLote;
        NumeroRps       := StrToIntDef(varNumRps, 0);
        SerieRps        := varSerRps;
        ValorNFSe       := StrToFloatDef(varValNFSe, 0);
        CodVerificacao  := varCodVerif;
      end;
      try
        AcbrNFSe.CancelarNFSe(InfCancelamento);
      Except
        on e : exception do
        begin
          classRetorno.Situacao   := TClassCheckService.CheckService(e.Message);
          classRetorno.Mensagem   := e.Message;
        end;
      end;
    finally
      InfCancelamento.Free;
    end;
    TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno, tmCancelarNFSe);
  end;

  if not (ClassNFSeCancelamento.IndependentNfse) then
  begin
    xmlenviohttp := TNfseHTTP.Create(True,
      ClassNFSeCancelamento.tokenid,
      ClassNFSeCancelamento.socketId);
    try
      XMLFiles := TStringList.Create;
      Try
        try
          XMLFiles := InsereXML(ClassNFSeCancelamento.Provedor.EmitenteCnpj,
                                ClassNFSeCancelamento.Provedor.SalvarArquivoSoap);
          if XMLFiles.Count > 0 then
            xmlenviohttp.POST('',
                              cons_cancel,
                              classRetorno.nfseId,
                              XMLFiles);
          DeleteXML(ClassNFSeCancelamento.Provedor.EmitenteCnpj);
        Except
        end;
      Finally
        FreeAndNil(XMLFiles);
      End;
    Except
    end;
  end;

end;

class procedure TControllerCancel.registry;
begin
   THorse.Post('/'+CONS_CANCEL, cancel);
end;

end.
