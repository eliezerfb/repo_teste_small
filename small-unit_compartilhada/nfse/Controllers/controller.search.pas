unit controller.search;

interface

uses
  Horse,
  ACBrNFSeX,
  System.SysUtils,
  nfse.classe.search,
  nfse.classe.configura_componente,
  nfse.classe.retorno,
  nfse.configura_componente,
  nfse.checa_resposta,
  ACBrNFSeXConversao,
  nfse.checaservico,
  nfse.retorna_filaws,
  nfse.constants,
  nfse.envia_xml,
  System.Classes,
  nfse.funcoes;

Type
  TcontrollerSearch = class

    private

      class procedure searchsituation(AcbrNFSe :TACBrNFSeX;
                                      ClasseSearch : TClasseSearch;
                                      classRetorno : TNFSeRetorno);

      class procedure searchlot(AcbrNFSe :TACBrNFSeX;
                                ClasseSearch : TClasseSearch;
                                classRetorno : TNFSeRetorno);

      class procedure searchnfserps(AcbrNFSe :TACBrNFSeX;
                                    ClasseSearch : TClasseSearch;
                                    classRetorno : TNFSeRetorno);

    public


      class procedure situation(Req: THorseRequest;
                                Res: THorseResponse; Next: TProc);

      class procedure batch(Req: THorseRequest;
                          Res: THorseResponse; Next: TProc);

      class procedure nfserps(Req: THorseRequest; Res: THorseResponse;
                              Next: TProc);

      class procedure Registry;

  end;


implementation


{ TcontrollerSearch }


class procedure TcontrollerSearch.searchlot(AcbrNFSe :TACBrNFSeX;
                                            ClasseSearch : TClasseSearch;
                                            classRetorno : TNFSeRetorno);
var
  xmlenviohttp :  TNfseHTTP;
  XMLFiles: TStringList;
begin
  sleep(10000);

  if AcbrNFSe.Configuracoes.Geral.Provedor in [proInfisc] then
  begin
    AcbrNFSe.ConsultarLoteRps(ClasseSearch.Protocolo, ClasseSearch.Protocolo);

    TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno,tmConsultarLote);

    if (classRetorno.Situacao = 4) and (classRetorno.Numero  = '') then
      classRetorno.Numero  := ClasseSearch.NumeroRps;
  end
  else
  begin
    AcbrNFSe.ConsultarLoteRps(ClasseSearch.Protocolo, ClasseSearch.NumeroLote);
     TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno, tmConsultarLote);
  end;


  if not (ClasseSearch.IndependentNfse) then
  begin
    xmlenviohttp := TNfseHTTP.Create(True,
      ClasseSearch.tokenid,
      ClasseSearch.socketId);
    try
      XMLFiles := TStringList.Create;
      Try
        try
          XMLFiles := InsereXMLConsulta(ClasseSearch);
          if XMLFiles.Count > 0 then
            xmlenviohttp.POST('',
                              cons_searchbatch,
                              classRetorno.nfseId,
                              XMLFiles);
          DeleteXML(ClasseSearch.Provedor.EmitenteCnpj);
        Except
        end;
      Finally
        FreeAndNil(XMLFiles);
      End;
    Except
    end;
  end;
end;

class procedure TcontrollerSearch.situation(Req: THorseRequest;
                                           Res: THorseResponse; Next: TProc);
var
  numlote : string;
  classeConfiguraComponente : TConfiguracaoProvedor;
  ClasseSearch : TClasseSearch;
  ClassRetorno : TNFSeRetorno;
  AcbrNfse     : TACBrNFSeX;
  retornoFila : TRetornoFila;
  TokenId,
  vartemp   : string;

begin
  ClasseSearch := TClasseSearch.Create;

  classRetorno := TNFSeRetorno.create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  classeConfiguraComponente := TConfiguracaoProvedor.Create;

  Try
    Try
      ClasseSearch.AsJson := Req.Body;
      ClasseSearch.TokenId := Req.Headers['Authorization-Compufacil'];
      ClasseSearch.socketId := Req.Headers['Socket-Id'];
      ClassRetorno.nfseId := ClasseSearch.nfseId;
      ClassRetorno.consultType := cons_searchsituation;
      ClassRetorno.attempNumber := ClasseSearch.attempNumber;
    Except
      on e : exception do begin
        classRetorno.MensagemCompleta := e.Message;
        exit;
      end;
    End;

    classeConfiguraComponente.CodigoMunicipio := ClasseSearch.Provedor.CodigoMunicipio;
    classeConfiguraComponente.EmitenteCnpj    := ClasseSearch.Provedor.EmitenteCnpj;
    classeConfiguraComponente.EmitenteIE      := ClasseSearch.Provedor.EmitenteIE;
    classeConfiguraComponente.EmitenteInscricaoMunicipal  := ClasseSearch.Provedor.InscricaoMunicipal;
    classeConfiguraComponente.EmitenteRazaoSocial         := ClasseSearch.Provedor.EmitenteRazaoSocial;
    classeConfiguraComponente.EmitenteSenha               := ClasseSearch.Provedor.EmitenteSenha;
    classeConfiguraComponente.EmitenteUsuario             := ClasseSearch.Provedor.EmitenteUsuario;
    classeConfiguraComponente.Producao                    := ClasseSearch.Provedor.Producao;
    classeConfiguraComponente.SenhaCertificado            := ClasseSearch.Provedor.SenhaCertificado;
    classeConfiguraComponente.UF := ClasseSearch.Provedor.UF;
    classeConfiguraComponente.UrlCertificado    := ClasseSearch.Provedor.UrlCertificado;
    classeConfiguraComponente.FraseSecreta      := ClasseSearch.Provedor.FraseSecreta;
    classeConfiguraComponente.ChaveAcesso       := ClasseSearch.Provedor.ChaveAcesso;
    classeConfiguraComponente.ChaveAutorizacao  := ClasseSearch.Provedor.ChaveAutorizacao;
    classeConfiguraComponente.SalvarArquivoSoap := ClasseSearch.Provedor.SalvarArquivoSoap;
    classeConfiguraComponente.PathLocal := ClasseSearch.Provedor.PathLocal;
    classeConfiguraComponente.Layout := ClasseSearch.Provedor.Layout;

    try
      nfse.configura_componente.configuraComponente(classeConfiguraComponente, AcbrNFSe);
    Except
      on e: Exception do
      begin
        classRetorno.Correcao := 'Verifique os parâmetros de envio.';
        classRetorno.Situacao := 0;
        classRetorno.MensagemCompleta :=
          'Exceção ao configurar componente : '+e.Message;
        exit
      end;
    end;

    try
      searchsituation(AcbrNfse, ClasseSearch, ClassRetorno);
    Except
      on e: Exception do
      begin
        classRetorno.Situacao := TClassCheckService.CheckService(e.Message);
        classRetorno.Exception := e.Message;
      end;
    end;
  Finally
    if not (ClasseSearch.IndependentNfse) then
    begin
      try
        retornoFila := TRetornoFila.Create;
        try
          retornoFila.tokenid   := ClasseSearch.TokenId;
          retornoFila.socketId  := ClasseSearch.socketId;
          retornoFila.endpoint  := getEndPointSearch;
          retornoFila.Enviaretorno(classRetorno);
        finally
          FreeAndNil(retornoFila);
        end;
      Except
      end;
    end;

    Res.Send(classRetorno.AsJson);

    FreeAndNil(ClasseSearch);
    FreeAndNil(classeConfiguraComponente);
    FreeAndNil(classRetorno);
    FreeAndNil(AcbrNFSe);
  End;
end;

class procedure TcontrollerSearch.searchsituation(AcbrNFSe :TACBrNFSeX;
                                                  ClasseSearch : TClasseSearch;
                                                  classRetorno : TNFSeRetorno);
var
  varambiente : string;
  xmlenviohttp :  TNfseHTTP;
  XMLFiles: TStringList;
begin
  sleep(10000);
  AcbrNFSe.ConsultarSituacao(ClasseSearch.Protocolo, ClasseSearch.NumeroLote);

  TCheckAnswer.ChecarResposta(AcbrNFSe, ClassRetorno, tmConsultarSituacao);

  if not (ClasseSearch.IndependentNfse) then
  begin
    xmlenviohttp := TNfseHTTP.Create(True,
      ClasseSearch.tokenid,
      ClasseSearch.socketId);
    try
      XMLFiles := TStringList.Create;
      Try
        try
          XMLFiles := InsereXMLConsulta(ClasseSearch);
          if XMLFiles.Count > 0 then
            xmlenviohttp.POST('',
                              cons_searchsituation,
                              classRetorno.nfseId,
                              XMLFiles);
          DeleteXML(ClasseSearch.Provedor.EmitenteCnpj);
        Except
        end;
      Finally
        FreeAndNil(XMLFiles);
      End;
    Except
    end;
  end;

end;


class procedure TcontrollerSearch.searchnfserps(AcbrNFSe :TACBrNFSeX;
                                                ClasseSearch : TClasseSearch;
                                                classRetorno : TNFSeRetorno);
var
  iTipoRps : integer;
  xmlenviohttp :  TNfseHTTP;
  XMLFiles : TStringList;
begin
  if AcbrNfse.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    ClasseSearch.SerieRps := '99';
  end;
  if AcbrNfse.Configuracoes.Geral.Provedor = proSigep then
  begin
    iTipoRps := StrToIntDef(ClasseSearch.TipoRps, 1);

    case iTipoRps of
      1: ClasseSearch.TipoRps := 'R1';
      2: ClasseSearch.TipoRps := 'R2';
      3: ClasseSearch.TipoRps := 'R3';
    end;
  end;
  if AcbrNfse.Configuracoes.Geral.Provedor = proAgili then
  begin
    iTipoRps := StrToIntDef(ClasseSearch.TipoRps, 1);
    case iTipoRps of
      1: ClasseSearch.TipoRps := '-2';
      2: ClasseSearch.TipoRps := '-4';
      3: ClasseSearch.TipoRps := '-5';
    end;
  end;

  if AcbrNfse.Configuracoes.Geral.Provedor in [proGiap, proGoverna] then
  begin
    if ClasseSearch.CodigoVerificacao = '' then
      ClassRetorno.Mensagem := 'Para realizar esta consulta é necessário o código de verificação.';
    Exit;
  end;
  sleep(10000);

  if AcbrNfse.Configuracoes.Geral.Provedor in [proPadraoNacional] then
  begin
    AcbrNfse.ConsultarNFSePorChave(ClasseSearch.CodigoVerificacao);
    TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno, tmConsultarNFSe);
  end
  else
  begin
    AcbrNfse.ConsultarNFSeporRps(ClasseSearch.NumeroRps, ClasseSearch.SerieRps, ClasseSearch.TipoRps, ClasseSearch.CodigoVerificacao);
    TCheckAnswer.ChecarResposta(AcbrNFSe, classRetorno, tmConsultarNFSePorRps);
  end;

  if not (ClasseSearch.IndependentNfse) then
  begin
    xmlenviohttp := TNfseHTTP.Create(True,ClasseSearch.tokenid, ClasseSearch.socketId);
    try
      XMLFiles := TStringList.Create;
      Try
        try
          XMLFiles := InsereXMLConsulta(ClasseSearch);
          if XMLFiles.Count > 0 then
            xmlenviohttp.POST('',
                              cons_searchnfserps,
                              classRetorno.nfseId,
                              XMLFiles);
          DeleteXML(ClasseSearch.Provedor.EmitenteCnpj);
        Except
        end;
      Finally
        FreeAndNil(XMLFiles);
      End;
    Except
    end;
  end;
end;

class procedure TcontrollerSearch.batch(Req: THorseRequest;
                                     Res: THorseResponse;Next: TProc);
var
  numlote : string;
  classeConfiguraComponente : TConfiguracaoProvedor;
  AcbrNFSe :TACBrNFSeX;
  ClasseSearch : TClasseSearch;
  classRetorno : TNFSeRetorno;
  retornoFila : TRetornoFila;
begin
  ClasseSearch := TClasseSearch.Create;

  classRetorno := TNFSeRetorno.create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  classeConfiguraComponente := TConfiguracaoProvedor.Create;

  Try
    try
      ClasseSearch.AsJson := Req.Body;
      ClassRetorno.nfseId := ClasseSearch.nfseId;
      ClassRetorno.consultType := cons_searchbatch;
      ClassRetorno.attempNumber := ClasseSearch.attempNumber;
      ClasseSearch.tokenid := Req.Headers['Authorization-Compufacil'];
      ClasseSearch.socketId := Req.Headers['Socket-Id'];
    Except
      on e : exception do begin
        classRetorno.MensagemCompleta := e.Message;
        exit;
      end;
    end;
    classeConfiguraComponente.CodigoMunicipio := ClasseSearch.Provedor.CodigoMunicipio;
    classeConfiguraComponente.EmitenteCnpj    := ClasseSearch.Provedor.EmitenteCnpj;
    classeConfiguraComponente.EmitenteIE      := ClasseSearch.Provedor.EmitenteIE;
    classeConfiguraComponente.EmitenteInscricaoMunicipal  := ClasseSearch.Provedor.InscricaoMunicipal;
    classeConfiguraComponente.EmitenteRazaoSocial         := ClasseSearch.Provedor.EmitenteRazaoSocial;
    classeConfiguraComponente.EmitenteSenha               := ClasseSearch.Provedor.EmitenteSenha;
    classeConfiguraComponente.EmitenteUsuario             := ClasseSearch.Provedor.EmitenteUsuario;
    classeConfiguraComponente.Producao                    := ClasseSearch.Provedor.Producao;
    classeConfiguraComponente.SenhaCertificado            := ClasseSearch.Provedor.SenhaCertificado;
    classeConfiguraComponente.UF := ClasseSearch.Provedor.UF;
    classeConfiguraComponente.UrlCertificado    := ClasseSearch.Provedor.UrlCertificado;
    classeConfiguraComponente.FraseSecreta      := ClasseSearch.Provedor.FraseSecreta;
    classeConfiguraComponente.ChaveAcesso       := ClasseSearch.Provedor.ChaveAcesso;
    classeConfiguraComponente.ChaveAutorizacao  := ClasseSearch.Provedor.ChaveAutorizacao;
    classeConfiguraComponente.SalvarArquivoSoap := ClasseSearch.Provedor.SalvarArquivoSoap;
    classeConfiguraComponente.PathLocal := ClasseSearch.Provedor.PathLocal;
    classeConfiguraComponente.Layout    := ClasseSearch.Provedor.Layout;

    Try
      nfse.configura_componente.configuraComponente(classeConfiguraComponente, AcbrNFSe);
    Except
      on e: Exception do
      begin
        classRetorno.Correcao := 'Verifique os parâmetros de envio.';
        classRetorno.Situacao := 0;
        classRetorno.MensagemCompleta :=
          'Exceção ao configurar componente : '+e.Message;
      end;
    End;

    try
      searchlot(AcbrNFSe,
                ClasseSearch,
                classRetorno);
    Except
      on e: Exception do
      begin
        classRetorno.Situacao := TClassCheckService.CheckService(e.Message);
        classRetorno.MensagemCompleta := e.Message;
      end;
    end;
  Finally
    if not (ClasseSearch.IndependentNfse) then
    begin
      try
        retornoFila := TRetornoFila.Create;
        try
          retornoFila.tokenid   := ClasseSearch.tokenid;
          retornoFila.socketId  := ClasseSearch.socketId;
          retornoFila.endpoint  := getEndPointSearch;
          retornoFila.Enviaretorno(classRetorno);
        finally
          FreeAndNil(retornoFila);
        end;
      Except
      end;
    end;

    Res.Send(classRetorno.AsJson);

    FreeAndNil(ClasseSearch);
    FreeAndNil(classeConfiguraComponente);
    FreeAndNil(classRetorno);
    FreeAndNil(AcbrNFSe);
  End;
end;

class procedure TcontrollerSearch.nfserps(Req: THorseRequest;
                                          Res: THorseResponse; Next: TProc);
var
  numlote,
  tokenid,
  socketId : string;

  classeConfiguraComponente : TConfiguracaoProvedor;
  AcbrNFSe :TACBrNFSeX;
  ClasseSearch : TClasseSearch;
  classRetorno : TNFSeRetorno;
  retornoFila : TRetornoFila;
begin
  ClasseSearch := TClasseSearch.Create;

  classRetorno := TNFSeRetorno.create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  classeConfiguraComponente := TConfiguracaoProvedor.Create;
  Try
    Try
      ClasseSearch.AsJson := Req.Body;
      ClassRetorno.nfseId := ClasseSearch.nfseId;
      ClassRetorno.consultType := cons_searchnfserps;
      ClassRetorno.attempNumber := ClasseSearch.attempNumber;
      tokenid := Req.Headers['Authorization-Compufacil'];
      socketId := Req.Headers['Socket-Id'];
    Except
      on e : exception do begin
        classRetorno.MensagemCompleta := e.Message;
        exit;
      end;
    End;


    classeConfiguraComponente.CodigoMunicipio := ClasseSearch.Provedor.CodigoMunicipio;
    classeConfiguraComponente.EmitenteCnpj    := ClasseSearch.Provedor.EmitenteCnpj;
    classeConfiguraComponente.EmitenteIE      := ClasseSearch.Provedor.EmitenteIE;
    classeConfiguraComponente.EmitenteInscricaoMunicipal  := ClasseSearch.Provedor.InscricaoMunicipal;
    classeConfiguraComponente.EmitenteRazaoSocial         := ClasseSearch.Provedor.EmitenteRazaoSocial;
    classeConfiguraComponente.EmitenteSenha               := ClasseSearch.Provedor.EmitenteSenha;
    classeConfiguraComponente.EmitenteUsuario             := ClasseSearch.Provedor.EmitenteUsuario;
    classeConfiguraComponente.Producao                    := ClasseSearch.Provedor.Producao;
    classeConfiguraComponente.SenhaCertificado            := ClasseSearch.Provedor.SenhaCertificado;
    classeConfiguraComponente.UF := ClasseSearch.Provedor.UF;
    classeConfiguraComponente.UrlCertificado    := ClasseSearch.Provedor.UrlCertificado;
    classeConfiguraComponente.FraseSecreta      := ClasseSearch.Provedor.FraseSecreta;
    classeConfiguraComponente.ChaveAcesso       := ClasseSearch.Provedor.ChaveAcesso;
    classeConfiguraComponente.ChaveAutorizacao  := ClasseSearch.Provedor.ChaveAutorizacao;
    classeConfiguraComponente.SalvarArquivoSoap := ClasseSearch.Provedor.SalvarArquivoSoap;
    classeConfiguraComponente.PathLocal := ClasseSearch.Provedor.PathLocal;
    classeConfiguraComponente.Layout    := ClasseSearch.Provedor.Layout;

    Try
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
    End;

    try
      searchnfserps(AcbrNFSe,
                    ClasseSearch,
                    classRetorno);
    Except
      on e: Exception do
      begin
        classRetorno.Situacao := TClassCheckService.CheckService(e.Message);
        classRetorno.MensagemCompleta := e.Message;
      end;
    end;

  Finally
    if not (ClasseSearch.IndependentNfse) then
    begin
      try
        retornoFila := TRetornoFila.Create;
        try
          retornoFila.tokenid   := tokenid;
          retornoFila.endpoint  := getEndPointSearch;
          retornoFila.socketId  := socketId;
          retornoFila.Enviaretorno(classRetorno);
        finally
          FreeAndNil(retornoFila);
        end;
      Except
      end;
    end;

    Res.Send(classRetorno.AsJson);

    FreeAndNil(ClasseSearch);
    FreeAndNil(classeConfiguraComponente);
    FreeAndNil(classRetorno);
    FreeAndNil(AcbrNFSe);
  End;
end;

class procedure TcontrollerSearch.Registry;
begin
  THorse.Post('/'+cons_searchsituation,TcontrollerSearch.situation);

  THorse.Post('/'+cons_searchbatch,TcontrollerSearch.batch);

  THorse.Post('/'+cons_searchnfserps,TcontrollerSearch.nfserps);
end;

end.
