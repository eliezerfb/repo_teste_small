unit controller.send;


interface

uses
  Horse,
  System.SysUtils,
  ACBrNFSeX,
  ACBrDFeSSL,
  pcnConversao,
  ACBrNFSeXConversao,
  ACBrNFSeXWebservicesResponse,
  ACBrDFeUtil,
  Pkg.Json.DTO,
  nfse.search.nfserps,
  nfse.classes.helpers,
  nfse.classes.nfse,
  nfse.classe.retorno,
  nfse.classe.configura_componente,
  nfse.configura_componente,
  nfse.checa_resposta,
  nfse.checaservico,
  nfse.retorna_filaws,
  nfse.constants,
  nfse.envia_xml,
  System.Classes,
  nfse.funcoes;


  Type
    TControllerSend = Class
    private
      class function GetCodigoMunicipioServico(AcbrNFse : TACBrNFSeX;
        ClassNFSe : TNFSe): String;
      class function getCidadeGoiania(AcbrNFse : TACBrNFSeX; ClassNFSe: TNFSe;
        issRetido : Boolean = False): string;
      class procedure Send(Req: THorseRequest; Res: THorseResponse;
        Next: TProc);
      class procedure SendNFSe(AcbrNfse: TACBrNFSeX; NFSeDTO: TNFSe;
        NFSeRetorno: TNFSeRetorno; ConfiguracaoProvedor: TConfiguracaoProvedor);
      class procedure AlimentaNota(AcbrNFSe: TACBrNFSeX; ClassNFSe: TNFSe);
      class procedure searchNFSeRPS(NumeroRps: String;
        classeConfiguraComponente: TConfiguracaoProvedor; ClassNFSe: TNFSe;
        ClassNFSeRetorno: TNFSeRetorno; AcbrNfse: TACBrNFSeX;
        consultaAposTransmissao: String = 'N');
    public
      class procedure Registry;
    end;



implementation


class Procedure TControllerSend.AlimentaNota(AcbrNFSe: TACBrNFSeX; ClassNFSe: TNFSe);
function OldRemoverAcentos(const Texto: string): string;
const
  Acentos: array[1..34] of string = (
    'á','à','ã','â','é','è','ê','í','ì','ó','ò','õ','ô','ú','ù','ü','ç',
    'Á','À','Ã','Â','É','È','Ê','Í','Ì','Ó','Ò','Õ','Ô','Ú','Ù','Ü','Ç'
  );
  SemAcentos: array[1..34] of string = (
    'a','a','a','a','e','e','e','i','i','o','o','o','o','u','u','u','c',
    'A','A','A','A','E','E','E','I','I','O','O','O','O','U','U','U','C'
  );
var
  i: Integer;
begin
  Result := Texto;
  for i := Low(Acentos) to High(Acentos) do
    Result := StringReplace(Result, Acentos[i], SemAcentos[i], [rfReplaceAll]);
end;

begin
  AcbrNFSe.NotasFiscais.NumeroLote := ClassNFSe.NumeroLote;
  AcbrNFSe.NotasFiscais.Transacao := True;
  with AcbrNFSe.NotasFiscais.New.NFSe do
  begin
    Producao        := ClassNFSe.Provedor.Producao.getAsAcbrType;
    SituacaoTrib    := tsTributadaNoPrestador;
    Situacao        := 1;
    Numero          := ClassNFSe.Numero;
    cNFSe           := GerarCodigoDFe(StrToIntDef(Numero, 0));
    SeriePrestacao  := ClassNFSe.Serie;
    NumeroLote      := ClassNFSe.NumeroLote;
    if AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc then
      ModeloNFSe := '90';

    IdentificacaoRps.Numero := FormatFloat('#########0', StrToIntDef(Numero,0));
    IdentificacaoRps.Serie  := ClassNFSe.Serie;
    IdentificacaoRps.Tipo   := trRPS;

    DataEmissao             := ClassNFSe.DataEmissao;
    Competencia             := ClassNFSe.DataEmissao;
    DataEmissaoRPS          := ClassNFSe.DataEmissao;
    NaturezaOperacao        := ClassNFSe.NaturezaOperacao.getAsAcbrType;
    RegimeEspecialTributacao  := ClassNFSe.RegimeEspecialTributacao.getAsAcbrType;
    OptanteSimplesNacional    := ClassNFSe.OptanteSimplesNacional.getAsAcbrType;
    if AcbrNFSe.Configuracoes.Geral.Provedor = proPadraoNacional then
    begin
      OptanteMEISimei        := snSim;
      OptanteSN              := osnOptanteMEI;
      RegimeApuracaoSN       := raFederaisMunicipalpeloSN;
      verAplic               := 'Zucchetti - 1.00';
    end
    else
      IncentivadorCultural      := ClassNFSe.IncentivadorCultural.getAsAcbrType;
    StatusRps := srNormal;
    OutrasInformacoes := ''; //todo

    Prestador.IdentificacaoPrestador.CpfCnpj := ClassNFSe.Prestador.CNPJ;
    Prestador.IdentificacaoPrestador.InscricaoMunicipal := ClassNFSe.Prestador.InscricaoMunicipal;
    Prestador.RazaoSocial  := ClassNFSe.Prestador.RazaoSocial;
    Prestador.NomeFantasia := ClassNFSe.Prestador.Fantasia;
    Prestador.cUF := UFtoCUF(ClassNFSe.Prestador.Endereco.UF);
    Prestador.Endereco.Endereco := ClassNFSe.Prestador.Endereco.Logradouro;
    Prestador.Endereco.Numero   := ClassNFSe.Prestador.Endereco.Numero;
    Prestador.Endereco.Bairro   := ClassNFSe.Prestador.Endereco.Bairro;
    Prestador.Endereco.CodigoMunicipio := ClassNFSe.Prestador.Endereco.CodigoCidade;
    Prestador.Endereco.xMunicipio := ClassNFSe.Prestador.Endereco.Cidade;
    Prestador.Endereco.UF := ClassNFSe.Prestador.Endereco.UF;
    Prestador.Endereco.CodigoPais := 1058;
    Prestador.Endereco.xPais := 'BRASIL';
    Prestador.Endereco.CEP := ClassNFSe.Prestador.Endereco.CEP;
    Prestador.Contato.Telefone := ClassNFSe.Prestador.Fone;
    Prestador.Contato.Email := ClassNFSe.Prestador.Email;

    Tomador.IdentificacaoTomador.Tipo := ClassNFSe.Tomador.Tipo.getAsAcbrType;
    Tomador.IdentificacaoTomador.CpfCnpj := ClassNFSe.Tomador.CpfCnpj;
    Tomador.IdentificacaoTomador.InscricaoMunicipal := ClassNFSe.Tomador.InscricaoMunicipal;
    Tomador.RazaoSocial := ClassNFSe.Tomador.RazaoSocial;
    Tomador.Endereco.EnderecoInformado := snoSim;
    Tomador.Endereco.TipoLogradouro := ClassNFSe.Tomador.Endereco.TipoLogradouro;
    if AcbrNFSe.Configuracoes.Geral.Provedor = proISSSaoPaulo then
      Tomador.Endereco.TipoLogradouro := Copy(Tomador.Endereco.TipoLogradouro, 1, 3);

    Tomador.Endereco.Endereco := ClassNFSe.Tomador.Endereco.Logradouro;
    Tomador.Endereco.Numero := ClassNFSe.Tomador.Endereco.Numero;
    Tomador.Endereco.Complemento := ClassNFSe.Tomador.Endereco.Complemento;
    Tomador.Endereco.Bairro := ClassNFSe.Tomador.Endereco.Bairro;
    Tomador.Endereco.CodigoMunicipio := GetCidadeGoiania(AcbrNFSe,ClassNFSe);
    Tomador.Endereco.xMunicipio := ClassNFSe.Tomador.Endereco.Cidade;
    Tomador.Endereco.UF := ClassNFSe.Tomador.Endereco.UF;
    Tomador.Endereco.CodigoPais := 1058; // Brasil
    Tomador.Endereco.CEP := ClassNFSe.Tomador.Endereco.CEP;
    Tomador.Endereco.xPais := 'BRASIL';
    Tomador.IdentificacaoTomador.InscricaoEstadual := ClassNFSe.Tomador.InscricaoEstadual;
    Tomador.Contato.Telefone := ClassNFSe.Tomador.Telefone;
    Tomador.Contato.Email := ClassNFSe.Tomador.Email;
    Tomador.AtualizaTomador := snNao;
    Tomador.TomadorExterior := snNao;

    Servico.Valores.ValorServicos := ClassNFSe.Servicos.ValorServicos;
    Servico.Valores.ValorDeducoes := ClassNFSe.Servicos.ValorDeducoes;
    Servico.Valores.AliquotaPis := ClassNFSe.Servicos.AliquotaPis;
    Servico.Valores.ValorPis := ClassNFSe.Servicos.ValorPis;
    Servico.Valores.AliquotaCofins := ClassNFSe.Servicos.AliquotaCofins;
    Servico.Valores.ValorCofins := ClassNFSe.Servicos.ValorCofins;
    Servico.Valores.ValorInss := ClassNFSe.Servicos.ValorInss;
    Servico.Valores.ValorIr := ClassNFSe.Servicos.ValorIr;
    Servico.Valores.ValorCsll := ClassNFSe.Servicos.ValorCsll;
    Servico.Valores.RetidoPis := snNao;
    Servico.Valores.RetidoCofins := snNao;
    Servico.Valores.AliquotaInss := 0;
    Servico.Valores.RetidoInss := snNao;
    Servico.Valores.AliquotaIr := 0;
    Servico.Valores.RetidoIr := snNao;
    Servico.Valores.AliquotaCsll := 0;
    Servico.Valores.RetidoCsll := snNao;
    Servico.Valores.IssRetido := ClassNFSe.Servicos.IssRetido.getAsAcbrType;
    Servico.Valores.ValorIssRetido := ClassNFSe.Servicos.ValorIssRetido;
    Servico.Valores.OutrasRetencoes := ClassNFSe.Servicos.OutrasRetencoes;
    Servico.Valores.DescontoIncondicionado := ClassNFSe.Servicos.DescontoCondicionado;
    Servico.Valores.DescontoCondicionado := ClassNFSe.Servicos.DescontoIncondicionado;
    Servico.Valores.BaseCalculo := Servico.Valores.ValorServicos - Servico.Valores.ValorDeducoes - Servico.Valores.DescontoIncondicionado;
    Servico.Valores.Aliquota := ClassNFSe.Servicos.Aliquota;
    Servico.Valores.ValorISS := ClassNFSe.Servicos.ValorIss;
    Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
                                        Servico.Valores.ValorPis -
                                        Servico.Valores.ValorCofins -
                                        Servico.Valores.ValorInss -
                                        Servico.Valores.ValorIr -
                                        Servico.Valores.ValorCsll -
                                        Servico.Valores.OutrasRetencoes -
                                        Servico.Valores.ValorIssRetido -
                                        Servico.Valores.DescontoIncondicionado -
                                        Servico.Valores.DescontoCondicionado;

    if AcbrNFSe.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1 then
    begin
      Servico.Valores.tribMun.tribISSQN := tiOperacaoTributavel;
      Servico.Valores.tribMun.cPaisResult := 0;

      Servico.Valores.tribFed.CST := cst01;


      if (Servico.Valores.AliquotaPis > 0) or
        (Servico.Valores.AliquotaCofins > 0) Then
      begin
        Servico.Valores.tribFed.vBCPisCofins := Servico.Valores.ValorLiquidoNfse;

        Servico.Valores.tribFed.pAliqPis := Servico.Valores.AliquotaPis;
        Servico.Valores.tribFed.pAliqCofins := Servico.Valores.AliquotaCofins;

        if (Servico.Valores.tribFed.vBCPisCofins > 0) then
        begin
        if Servico.Valores.tribFed.pAliqPis > 0 then
          Servico.Valores.tribFed.vPis := Servico.Valores.tribFed.vBCPisCofins *
                                         Servico.Valores.tribFed.pAliqPis / 100;

          if Servico.Valores.tribFed.pAliqCofins > 0 then
            Servico.Valores.tribFed.vCofins := Servico.Valores.tribFed.vBCPisCofins *
                                      Servico.Valores.tribFed.pAliqCofins / 100;
        end;
      end;
    end;

    Servico.CodigoCnae := ClassNFSe.Servicos.CNAE;

    var Discriminacao := ClassNFSe.Servicos.Discriminacao;

    if AcbrNFSe.Configuracoes.Geral.Provedor = proPronim then
    begin
      Discriminacao := '';
      for var VarServico in ClassNFSe.Servicos.ItensServico do
      begin
        if not(Discriminacao = '') then
          Discriminacao := Discriminacao + ' | ';
        Discriminacao := Discriminacao + VarServico.Descricao;
      end;
    end;
    Servico.Discriminacao := OldRemoverAcentos(Discriminacao);
    Servico.CodigoMunicipio := GetCodigoMunicipioServico(AcbrNFSe, ClassNFSe);
    Servico.UFPrestacao := ClassNFSe.Servicos.UFPrestacao;
    Servico.CodigoTributacaoMunicipio := ClassNFSe.Servicos.CodigoTributacaoMunicipio;
    if Servico.ResponsavelRetencao = rtTomador then
      Servico.MunicipioIncidencia := StrToIntDef(
        getCidadeGoiania(AcbrNFSe, ClassNFSe, True),
        0
      )
    else
      Servico.MunicipioIncidencia := StrToIntDef(
        getCidadeGoiania(AcbrNFSe, ClassNFSe, True), 0
      );
    Servico.CodigoPais := 1058;
    Servico.ResponsavelRetencao := ClassNFSe.Servicos.ResponsavelRetencao.getAsAcbrType;
    Servico.ItemListaServico := ClassNFSe.Servicos.ItemListaServico;
    Servico.ExigibilidadeISS := ClassNFSe.Servicos.ExigibilidadeISS.getAsAcbrType;
    for var VarServico in ClassNFSe.Servicos.ItensServico do
    begin
      with Servico.ItemServico.New do
      begin
        Descricao := OldRemoverAcentos(VarServico.Descricao);
        ItemListaServico := ClassNFSe.Servicos.ItemListaServico;
        CodServ := ClassNFSe.Servicos.CodigoTributacaoMunicipio;
        if AcbrNFSe.Configuracoes.Geral.Provedor = proAgili then
          CodServ := ClassNFSe.Servicos.ItemListaServico;
        ValorDeducoes := 0;
        AliqReducao := 0;
        ValorReducao := 0;
        DescontoIncondicionado := 0;
        DescontoCondicionado := 0;
        TipoUnidade := VarServico.TipoUnidade.getAsAcbrType;
        Unidade := 'UN';
        if AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc then
          codLCServ := SoNumero(ClassNFSe.Servicos.ItemListaServico);
        Quantidade := VarServico.Quantidade;
        ValorUnitario := VarServico.ValorUnitario;
        ValorTotal := VarServico.Quantidade * VarServico.ValorUnitario;
        if (Servico.ExigibilidadeISS = exiIsencao) then
          BaseCalculo := 0
        else
          BaseCalculo := ValorTotal - ValorDeducoes - DescontoIncondicionado;
        Aliquota := ClassNFSe.Servicos.Aliquota;
        ValorISS := BaseCalculo * Aliquota / 100;
        CodMunPrestacao := GetCodigoMunicipioServico(AcbrNFSe, ClassNFSe);

        if AcbrNFSe.Configuracoes.Geral.Provedor = proIPM then
        begin
          CodCNO := '';
          SituacaoTributaria := ClassNFSe.Servicos.ExigibilidadeISS;
          TipoUnidade := tuHora;
          ValorTributavel := ValorTotal;
        end;
      end;
    end;
    CondicaoPagamento.Condicao := cpNaApresentacao;
  end;
end;

class procedure TControllerSend.searchNFSeRPS(NumeroRps: String;
  classeConfiguraComponente : TConfiguracaoProvedor; ClassNFSe: TNFSe;
  ClassNFSeRetorno : TNFSeRetorno; AcbrNfse: TACBrNFSeX;
  consultaAposTransmissao: String = 'N');
var
  iTipoRps : Integer;
  TipoRps  : string;
begin
  if consultaAposTransmissao = 'N' then
  begin
    classeConfiguraComponente.CodigoMunicipio := ClassNFSe.Provedor.CodigoMunicipio;
    classeConfiguraComponente.EmitenteCnpj    := ClassNFSe.Provedor.EmitenteCnpj;
    classeConfiguraComponente.EmitenteIE      := ClassNFSe.Provedor.EmitenteIE;
    classeConfiguraComponente.EmitenteInscricaoMunicipal  := ClassNFSe.Prestador.InscricaoMunicipal;
    classeConfiguraComponente.EmitenteRazaoSocial         := ClassNFSe.Provedor.EmitenteRazaoSocial;
    classeConfiguraComponente.EmitenteSenha               := ClassNFSe.Provedor.EmitenteSenha;
    classeConfiguraComponente.EmitenteUsuario             := ClassNFSe.Provedor.EmitenteUsuario;
    classeConfiguraComponente.Producao                    := ClassNFSe.Provedor.Producao;
    classeConfiguraComponente.SenhaCertificado            := ClassNFSe.Provedor.SenhaCertificado;
    classeConfiguraComponente.UF := ClassNFSe.Provedor.UF;
    classeConfiguraComponente.UrlCertificado    := ClassNFSe.Provedor.UrlCertificado;
    classeConfiguraComponente.FraseSecreta      := ClassNFSe.Provedor.FraseSecreta;
    classeConfiguraComponente.ChaveAcesso       := ClassNFSe.Provedor.ChaveAcesso;
    classeConfiguraComponente.ChaveAutorizacao  := ClassNFSe.Provedor.ChaveAutorizacao;

    Try
      nfse.configura_componente.configuraComponente(classeConfiguraComponente, AcbrNFSe);
    Except
      on e: Exception do
      begin
        ClassNFSeRetorno.Correcao := 'Verifique os parâmetros de envio.';
        ClassNFSeRetorno.Situacao := 0;
        ClassNFSeRetorno.MensagemCompleta :=
          'Exceção ao configurar componente : '+e.Message;
      end;
    End;
  end;

  TipoRps  := '1';
  if AcbrNFSe.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    // Utilizado como serie da prestação
    ClassNFSe.Serie := '99';
  end;
  if AcbrNFSe.Configuracoes.Geral.Provedor = proSigep then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);
    case iTipoRps of
      1: TipoRps := 'R1';
      2: TipoRps := 'R2';
      3: TipoRps := 'R3';
    end;
  end;

  if AcbrNFSe.Configuracoes.Geral.Provedor = proAgili then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);

    case iTipoRps of
      1: TipoRps := '-2';
      2: TipoRps := '-4';
      3: TipoRps := '-5';
    end;
  end;

  AcbrNFSe.ConsultarNFSeporRps(NumeroRps, ClassNFSe.Serie, TipoRps,ClassNFSeRetorno.CodigoVerificacao);

  TCheckAnswer.ChecarResposta(AcbrNFSe, ClassNFSeRetorno, tmConsultarNFSePorRps);
end;

class procedure TControllerSend.SendNFSe(AcbrNfse : TACBrNFSeX; NFSeDTO: TNFSe;
  NFSeRetorno: TNFSeRetorno; ConfiguracaoProvedor: TConfiguracaoProvedor);
var
  xmlenviohttp :  TNfseHTTP;
  XMLFiles: TStringList;
begin
  if AcbrNFSe.Configuracoes.Geral.Provedor = proSoftPlan then
    AcbrNFSe.GerarToken;

  if AcbrNFSe.Configuracoes.Geral.Provedor = proPadraoNacional then
  begin
    try
      AcbrNFSe.Emitir(AcbrNFSe.NotasFiscais.NumeroLote, meUnitario, false)
    except
      on e: exception do
      begin
        NFSeRetorno.Situacao := TClassCheckService.CheckService(e.Message);
        NFSeRetorno.Exception := 'proPadraoNacional AcbrNFSe.Emitir '+e.Message;
      end;
    end;
    TCheckAnswer.ChecarResposta(AcbrNFSe, NFSeRetorno, tmGerar);

  end
  else
  begin
    try
      AcbrNFSe.Emitir(
        AcbrNFSe.NotasFiscais.NumeroLote,
        GetModoEnvio(ConfiguracaoProvedor.MetodoEnvio),
        False
      );
    except
      on e: exception do
      begin
        NFSeRetorno.Situacao := TClassCheckService.CheckService(e.Message);
        NFSeRetorno.Exception := 'AcbrNFSe.Emitir '+e.Message;
      end;
    end;

    if (AcbrNFSe.Configuracoes.Geral.Provedor in [proInfisc, proSigCorp]) then
    begin
      if AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc then
        AcbrNFSe.ConsultarLoteRps(
          AcbrNFSe.WebService.Emite.NumeroLote, // estava assim, não sei se tá certo, mas mantive
          AcbrNFSe.WebService.Emite.NumeroLote
        )
      else if AcbrNFSe.Configuracoes.Geral.Provedor = proSigCorp then
        AcbrNFSe.ConsultarLoteRps(
          AcbrNFSe.WebService.Emite.Protocolo,
          AcbrNFSe.WebService.Emite.NumeroLote
        );

      TCheckAnswer.ChecarResposta(AcbrNFSe, NFSeRetorno, tmConsultarLote);
    end else
      TCheckAnswer.ChecarResposta(AcbrNFSe, NFSeRetorno, tmRecepcionar);
  end;

  if not (NFSeDTO.IndependentNfse) then
  begin
    xmlenviohttp := TNfseHTTP.Create(True, NFSeDTO.tokenid, NFSeDTO.socketId);
    try
      XMLFiles := TStringList.Create;
      try
        try
          XMLFiles := InsereXML(
            NFSeDTO.Provedor.EmitenteCnpj,
            NFSeDTO.Provedor.SalvarArquivoSoap
          );

          if XMLFiles.Count > 0 then
            xmlenviohttp.POST('', cons_send, NFSeRetorno.nfseId, XMLFiles);
          DeleteXML(NFSeDTO.Provedor.EmitenteCnpj);
        except
        end;
      finally
        FreeAndNil(XMLFiles);
      end;
    except
    end;
  end;

  if (NFSeRetorno.Sucesso) and
    ((AcbrNFSe.Configuracoes.Geral.Provedor = proISSJoinville) or
    (AcbrNFSe.Configuracoes.Geral.Provedor = proABase) or
    (AcbrNFSe.Configuracoes.Geral.Provedor = proSigep)) then
  begin
    sleep(2000);
    searchNFSeRPS(
      AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero,
      ConfiguracaoProvedor,
      NFSeDTO,
      NFSeRetorno,
      AcbrNfse,
      'S'
    );
  end;
end;


{ TControllerSend }

class function TControllerSend.getCidadeGoiania(
  AcbrNFse: TACBrNFSeX;
  ClassNFSe: TNFSe;
  issRetido : Boolean = False): string;
begin
  if issRetido then
  begin
    if ClassNFSe.Servicos.ResponsavelRetencao.getAsAcbrType = rtTomador then
    begin
      if AcbrNFse.Configuracoes.Geral.Provedor = proISSGoiania then
        Exit(ClassNFSe.Tomador.Endereco.CodigoSedetec);

      Exit(ClassNFSe.Tomador.Endereco.CodigoCidade);
    end
    else
    begin
      if AcbrNFse.Configuracoes.Geral.Provedor = proISSGoiania then
        Exit(ClassNFSe.Prestador.Endereco.CodigoSedetec);

      Exit(ClassNFSe.Prestador.Endereco.CodigoCidade);
    end;
  end
  else
  begin
    if AcbrNFse.Configuracoes.Geral.Provedor = proISSGoiania then
      Exit(ClassNFSe.Tomador.Endereco.CodigoSedetec);

    Exit(ClassNFSe.Tomador.Endereco.CodigoCidade);
  end;
end;

class function TControllerSend.GetCodigoMunicipioServico(AcbrNFse : TACBrNFSeX;
  ClassNFSe : TNFSe): String;
begin
//  if (AcbrNFse.Configuracoes.Geral.Provedor = proISSNET) and (ClassNFSe.Provedor.Producao = False) then
//    Exit('999');

  if ClassNFSe.Servicos.CodigoMunicipio > 0 then
  begin
    if (AcbrNFse.Configuracoes.Geral.Provedor = proISSGoiania) then
      Exit(ClassNFSe.Servicos.CodigoSedetec);

    Exit(IntToStr(ClassNFSe.Servicos.CodigoMunicipio));
  end;

  if (AcbrNFse.Configuracoes.Geral.Provedor = proISSGoiania) then
    Exit(ClassNFSe.Servicos.CodigoSedetec);

  Exit(IntToStr(ClassNFSe.Servicos.CodigoMunicipio));
end;

class procedure TControllerSend.Registry;
begin
  THorse.Post('/'+CONS_SEND, Send);
end;

class procedure TControllerSend.Send(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  AcbrNFSe: TACBrNFSeX;
begin
  var NFSeJsonDTO := TNFSe.Create;
  var ResponseDTO := TNFSeRetorno.create;
  var ConfiguracaoProvedor := TConfiguracaoProvedor.Create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  Try
    try
      {$IFDEF LINUX}
      NFSeJsonDTO.AsJson := TEncoding.UTF8.GetString(TEncoding.Default.GetBytes(Req.Body));
      {$ENDIF}

      {$IFDEF MSWINDOWS}
      NFSeJsonDTO.AsJson := Req.Body;
      {$ENDIF}

      ResponseDTO.nfseId := NFSeJsonDTO.nfseId;
      NFSeJsonDTO.tokenid  := Req.Headers['Authorization-Compufacil'];
      NFSeJsonDTO.socketId := Req.Headers['Socket-Id'];
    Except
      on e : exception do begin
        ResponseDTO.Exception := e.Message;
        Exit;
      end;
    end;

    ConfiguracaoProvedor.Layout := NFSeJsonDTO.Provedor.Layout;
    ConfiguracaoProvedor.MetodoEnvio := NFSeJsonDTO.Provedor.MetodoEnvio;
    ConfiguracaoProvedor.CodigoMunicipio := NFSeJsonDTO.Provedor.CodigoMunicipio;
    ConfiguracaoProvedor.EmitenteCnpj := NFSeJsonDTO.Provedor.EmitenteCnpj;
    ConfiguracaoProvedor.EmitenteIE := NFSeJsonDTO.Provedor.EmitenteIE;
    ConfiguracaoProvedor.EmitenteInscricaoMunicipal  := NFSeJsonDTO.Prestador.InscricaoMunicipal;
    ConfiguracaoProvedor.EmitenteRazaoSocial := NFSeJsonDTO.Provedor.EmitenteRazaoSocial;
    ConfiguracaoProvedor.EmitenteSenha := NFSeJsonDTO.Provedor.EmitenteSenha;
    ConfiguracaoProvedor.EmitenteUsuario  := NFSeJsonDTO.Provedor.EmitenteUsuario;
    ConfiguracaoProvedor.Producao := NFSeJsonDTO.Provedor.Producao;
    ConfiguracaoProvedor.SenhaCertificado := NFSeJsonDTO.Provedor.SenhaCertificado;
    ConfiguracaoProvedor.UF := NFSeJsonDTO.Provedor.UF;
    ConfiguracaoProvedor.UrlCertificado := NFSeJsonDTO.Provedor.UrlCertificado;
    ConfiguracaoProvedor.FraseSecreta := NFSeJsonDTO.Provedor.FraseSecreta;
    ConfiguracaoProvedor.ChaveAcesso := NFSeJsonDTO.Provedor.ChaveAcesso;
    ConfiguracaoProvedor.ChaveAutorizacao := NFSeJsonDTO.Provedor.ChaveAutorizacao;
    ConfiguracaoProvedor.SalvarArquivoSoap := NFSeJsonDTO.Provedor.SalvarArquivoSoap;
    ConfiguracaoProvedor.PathLocal := NFSeJsonDTO.Provedor.PathLocal;

    Try
      nfse.configura_componente.configuraComponente(
        ConfiguracaoProvedor,
        AcbrNFSe
      );
    Except
      on e: Exception do
      begin
        ResponseDTO.Correcao := 'Verifique os parâmetros de envio.';
        ResponseDTO.Situacao := 0;
        ResponseDTO.MensagemCompleta :=
          'Exceção ao configurar componente : '+ e.Message;
      end;
    End;

    AlimentaNota(AcbrNFSe, NFSeJsonDTO);

    try
      SendNFSe(AcbrNFSe, NFSeJsonDTO, ResponseDTO, ConfiguracaoProvedor);
    except
      on e : exception do
      begin
        ResponseDTO.Exception := e.Message;
        exit;
      end;
    end;
  finally
    if not (NFSeJsonDTO.IndependentNfse) then
    begin
      try
        var RetornoFila := TRetornoFila.Create;
        try
          RetornoFila.tokenid := NFSeJsonDTO.tokenid;
          RetornoFila.socketId := NFSeJsonDTO.socketId;
          RetornoFila.endpoint := getEndPointSend;
          RetornoFila.Enviaretorno(ResponseDTO);
        finally
          FreeAndNil(retornoFila);
        end;
      except
      end;
    end;
    Res.Send(ResponseDTO.AsJson);
    FreeAndNil(AcbrNFSe);
  end;
end;

end.


