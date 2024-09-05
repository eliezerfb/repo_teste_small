unit nfse.classes.helpers;

interface
uses
  Classes, SysUtils, ACBrNFSeXConversao,
  nfse.classes.tiporps,
  nfse.classes.naturezaoperacao,
  nfse.classes.regimeespecialtributacao,
  nfse.classes.statusrps,
  nfse.classes.situacaotributacao,
  nfse.classes.tomador.tipo,
  nfse.classes.servico.situacaotributaria,
  nfse.classes.servico.responsavelretencao,
  nfse.classes.servico.exigibilidadeiss,
  nfse.classes.servico.tipounidade;
type

  TTipoRpsHelper = record helper for TTipoRps
    function getAsAcbrType: ACBrNFSeXConversao.TTipoRPS;
    procedure setAsAcbrType(param: ACBrNFSeXConversao.TTipoRPS);
  end;
  TNaturezaOperacaoHelper = record helper for TNaturezaOperacao
    function getAsAcbrType: TnfseNaturezaOperacao;
    procedure setAsAcbrType(param: TnfseNaturezaOperacao);
  end;
  TRegimeEspecialTributacaoHelper = record helper for TRegimeEspecialTributacao
    function getAsAcbrType: TnfseRegimeEspecialTributacao;
    procedure setAsAcbrType(param: TnfseRegimeEspecialTributacao);
  end;
  TBooleanHelper = record helper for Boolean
    function getAsAcbrType: TnfseSimNao;
    procedure setAsAcbrType(param: TnfseSimNao);
  end;
  TStatusRpsHelper = record helper for TStatusRps
    function getAsAcbrType: ACBrNFSeXConversao.TStatusRPS;
    procedure setAsAcbrType(param: ACBrNFSeXConversao.TStatusRPS);
  end;
  TSituacaoTributacaoHelper = record helper for TSituacaoTributacao
    function getAsAcbrType: TSituacaoTrib;
    procedure setAsAcbrType(param: TSituacaoTrib);
  end;
  TTipoTomadorHelper = record helper for TTipoTomador
    function getAsAcbrType: TTipoPessoa;
    procedure setAsAcbrType(param: TTipoPessoa);
  end;
  TReponsavelRetencaoHelper = record helper for TResponsavelRetencao
    function getAsAcbrType: TnfseResponsavelRetencao;
    procedure setAsAcbrType(param: TnfseResponsavelRetencao);
  end;
  TExigibilidadeIssHelper = record helper for TExigibilidadeIss
    function getAsAcbrType: TnfseExigibilidadeISS;
  end;
  TTipoUnidadeHelper = record helper for TTipoUnidade
    function getAsAcbrType: TUnidade;
    function GetDescricao: String;
  end;
  TIssRetidoHelper = record helper for TIssRetido
    function getAsAcbrType: TnfseSituacaoTributaria;
    procedure setAsAcbrType(param : TnfseSituacaoTributaria);
  end;
implementation
function TTipoUnidadeHelper.getAsAcbrType: TUnidade;
begin
  if Self = UNIDADE_HORA then Result := tuHora;
  if Self = UNIDADE_QUANTIDADE then Result := tuQtde;
end;
function TTipoUnidadeHelper.GetDescricao: String;
begin
  if Self = UNIDADE_HORA then Result := 'H';
  if Self = UNIDADE_QUANTIDADE then Result := 'UN';
end;
function TExigibilidadeIssHelper.getAsAcbrType: TnfseExigibilidadeISS;
begin
  if Self = EXIGIBILIDADE_ISS_EXIGIVEL then Result := exiExigivel;
  if Self = EXIGIBILIDADE_ISS_NAOINCIDENCIA then Result := exiNaoIncidencia;
  if Self = EXIGIBILIDADE_ISS_ISENCAO then Result := exiIsencao;
  if Self = EXIGIBILIDADE_ISS_EXPORTACAO then Result := exiExportacao;
  if Self = EXIGIBILIDADE_ISS_IMUNIDADE then Result := exiImunidade;
  if Self = EXIGIBILIDADE_ISS_SUSPENSAO_JUDICIAL then Result := exiSuspensaDecisaoJudicial;
  if Self = EXIGIBILIDADE_ISS_SUSPENSA_PROCESSO_ADMINISTRATIVO then Result := exiSuspensaProcessoAdministrativo;
  if Self = EXIGIBILIDADE_ISS_FIXO then Result := exiISSFixo;
end;
function TReponsavelRetencaoHelper.getAsAcbrType: TnfseResponsavelRetencao;
begin
  if Self = RESPONSAVEL_RETENCAO_TOMADOR then Result := rtTomador;
  if Self = RESPONSAVEL_RETENCAO_PRESTADOR then Result := rtPrestador;
  if Self = RESPONSAVEL_RETENCAO_INTERMEDIARIO then Result := rtIntermediario;
  if Self = RESPONSAVEL_RETENCAO_NENHUM then Result := rtNenhum;
end;
procedure TReponsavelRetencaoHelper.setAsAcbrType(
  param: TnfseResponsavelRetencao);
begin
  if param = rtTomador then Self := RESPONSAVEL_RETENCAO_TOMADOR;
  if param = rtPrestador then Self := RESPONSAVEL_RETENCAO_PRESTADOR;
  if param = rtIntermediario then Self := RESPONSAVEL_RETENCAO_INTERMEDIARIO;
  if param = rtNenhum then Self := RESPONSAVEL_RETENCAO_NENHUM;
end;
function TTipoTomadorHelper.getAsAcbrType: TTipoPessoa;
begin
  if Self = TOMADOR_PF_NAOIDENTIFICADO then Result := tpPFNaoIdentificada;
  if Self = TOMADOR_PF then Result := tpPF;
  if Self = TOMADOR_PJ_MUNICIPIO then Result := tpPJdoMunicipio;
  if Self = TOMADOR_PJ_FORA_MUNICIPIO then Result := tpPJforaMunicipio;
  if Self = TOMADOR_PJ_FORA_PAIS then Result := tpPJforaPais;
end;
procedure TTipoTomadorHelper.setAsAcbrType(param: TTipoPessoa);
begin
  if param = tpPFNaoIdentificada then Self := TOMADOR_PF_NAOIDENTIFICADO;
  if param = tpPF then Self := TOMADOR_PF;
  if param = tpPJdoMunicipio then Self := TOMADOR_PJ_MUNICIPIO;
  if param = tpPJforaMunicipio then Self := TOMADOR_PJ_FORA_MUNICIPIO;
  if param = tpPJforaPais then Self := TOMADOR_PJ_FORA_PAIS;
end;
function TSituacaoTributacaoHelper.getAsAcbrType: TSituacaoTrib;
begin
  if Self = TRIBUTADA_PRESTADOR then Result := tsTributadaNoPrestador;
  if Self = TRIBUTADA_TOMADOR then Result := tsTibutadaNoTomador;
  if Self = TRIBUTADA_ISENTA then Result := tsIsenta;
  if Self = TRIBUTADA_IMUNE then Result := tsImune;
  if Self = TRIBUTADA_NAOTRIBUTADA then Result := tsNaoTributada;
end;
procedure TSituacaoTributacaoHelper.setAsAcbrType(param: TSituacaoTrib);
begin
  if param = tsTributadaNoPrestador then Self := TRIBUTADA_PRESTADOR;
  if param = tsTibutadaNoTomador then Self := TRIBUTADA_TOMADOR;
  if param = tsIsenta then Self := TRIBUTADA_ISENTA;
  if param = tsImune then Self := TRIBUTADA_IMUNE;
  if param = tsNaoTributada then Self := TRIBUTADA_NAOTRIBUTADA;
end;
function TStatusRpsHelper.getAsAcbrType: ACBrNFSeXConversao.TStatusRPS;
begin
  if Self = STATUSRPS_NORMAL then Result := srNormal;
  if Self = STATUSRPS_CANCELADO then Result := srCancelado;
end;
procedure TStatusRpsHelper.setAsAcbrType(param: ACBrNFSeXConversao.TStatusRPS);
begin
  if param = srNormal then Self := STATUSRPS_NORMAL;
  if param = srCancelado then Self := STATUSRPS_CANCELADO;
end;
function TBooleanHelper.getAsAcbrType: TnfseSimNao;
begin
  if Self  then
    Exit(snSim);
  Exit(snNao);
end;
procedure TBooleanHelper.setAsAcbrType(param: TnfseSimNao);
begin
  if param = snSim then
  begin
    Self := True;
    Exit;
  end;
  Self := False;
end;
function TRegimeEspecialTributacaoHelper.getAsAcbrType: TnfseRegimeEspecialTributacao;
begin
  if Self = REGIME_NENHUM then Exit(retNenhum);
  if Self = REGIME_MICRO_EMPRESA_MUNICIPAL then Exit(retMicroempresaMunicipal);
  if Self = REGIME_ESTIMATIVA then Exit(retEstimativa);
  if Self = REGIME_SOCIEDADE_PROFISSIONAIS then Exit(retSociedadeProfissionais);
  if Self = REGIME_COOPERATIVA then Exit(retCooperativa);
  if Self = REGIME_MEI then Exit(retMicroempresarioIndividual);
  if Self = REGIME_MICRO_EMPRESARIO_EPP then Exit(retMicroempresarioEmpresaPP);
  if Self = REGIME_LUCRO_REAL then Exit(retLucroReal);
  if Self = REGIME_LUCRO_PRESUMIDO then Exit(retLucroPresumido);
  if Self = REGIME_SIMPLES_NACIONAL then Exit(retSimplesNacional);
  if Self = REGIME_IMUNE then Exit(retImune);
  if Self = REGIME_EIRELI then Exit(retEmpresaIndividualRELI);
  if Self = REGIME_EPP then Exit(retEmpresaPP);
  if Self = REGIME_MICRO_EMPRESARIO then Exit(retMicroEmpresario);
  if Self = REGIME_OUTROS then Exit(retOutros);
end;
procedure TRegimeEspecialTributacaoHelper.setAsAcbrType(
  param: TnfseRegimeEspecialTributacao);
begin
  if param = retNenhum then Self := REGIME_NENHUM;
  if param = retMicroempresaMunicipal then Self := REGIME_MICRO_EMPRESA_MUNICIPAL;
  if param = retEstimativa then Self := REGIME_ESTIMATIVA;
  if param = retSociedadeProfissionais then Self := REGIME_SOCIEDADE_PROFISSIONAIS;
  if param = retCooperativa then Self := REGIME_COOPERATIVA;
  if param = retMicroempresarioIndividual then Self := REGIME_MEI;
  if param = retMicroempresarioEmpresaPP then Self := REGIME_MICRO_EMPRESARIO_EPP;
  if param = retLucroReal then Self := REGIME_LUCRO_REAL;
  if param = retLucroPresumido then Self := REGIME_LUCRO_PRESUMIDO;
  if param = retSimplesNacional then Self := REGIME_SIMPLES_NACIONAL;
  if param = retImune then Self := REGIME_IMUNE;
  if param = retEmpresaIndividualRELI then Self := REGIME_EIRELI;
  if param = retEmpresaPP then Self := REGIME_EPP;
  if param = retMicroEmpresario then Self := REGIME_MICRO_EMPRESARIO;
  if param = retOutros then Self := REGIME_OUTROS;
end;
function TNaturezaOperacaoHelper.getAsAcbrType: TnfseNaturezaOperacao;
begin
  if Self = NATUREZA_OPERACAO_0 then Exit(no0);
  if Self = NATUREZA_OPERACAO_1 then Exit(no1);
  if Self = NATUREZA_OPERACAO_3 then Exit(no3);
  if Self = NATUREZA_OPERACAO_4 then Exit(no4);
  if Self = NATUREZA_OPERACAO_5 then Exit(no5);
  if Self = NATUREZA_OPERACAO_6 then Exit(no6);
  if Self = NATUREZA_OPERACAO_7 then Exit(no7);
  if Self = NATUREZA_OPERACAO_50 then Exit(no50);
  if Self = NATUREZA_OPERACAO_51 then Exit(no51);
  if Self = NATUREZA_OPERACAO_52 then Exit(no52);
  if Self = NATUREZA_OPERACAO_53 then Exit(no53);
  if Self = NATUREZA_OPERACAO_54 then Exit(no54);
  if Self = NATUREZA_OPERACAO_55 then Exit(no55);
  if Self = NATUREZA_OPERACAO_56 then Exit(no56);
  if Self = NATUREZA_OPERACAO_57 then Exit(no57);
  if Self = NATUREZA_OPERACAO_58 then Exit(no58);
  if Self = NATUREZA_OPERACAO_59 then Exit(no59);
  if Self = NATUREZA_OPERACAO_60 then Exit(no60);
  if Self = NATUREZA_OPERACAO_61 then Exit(no61);
  if Self = NATUREZA_OPERACAO_62 then Exit(no62);
  if Self = NATUREZA_OPERACAO_63 then Exit(no63);
  if Self = NATUREZA_OPERACAO_64 then Exit(no64);
  if Self = NATUREZA_OPERACAO_65 then Exit(no65);
  if Self = NATUREZA_OPERACAO_66 then Exit(no66);
  if Self = NATUREZA_OPERACAO_67 then Exit(no67);
  if Self = NATUREZA_OPERACAO_68 then Exit(no68);
  if Self = NATUREZA_OPERACAO_69 then Exit(no69);
  if Self = NATUREZA_OPERACAO_70 then Exit(no70);
  if Self = NATUREZA_OPERACAO_71 then Exit(no71);
  if Self = NATUREZA_OPERACAO_72 then Exit(no72);
  if Self = NATUREZA_OPERACAO_78 then Exit(no78);
  if Self = NATUREZA_OPERACAO_79 then Exit(no79);
  if Self = NATUREZA_OPERACAO_101 then Exit(no101);
  if Self = NATUREZA_OPERACAO_102 then Exit(no102);
  if Self = NATUREZA_OPERACAO_103 then Exit(no103);
  if Self = NATUREZA_OPERACAO_104 then Exit(no104);
  if Self = NATUREZA_OPERACAO_105 then Exit(no105);
  if Self = NATUREZA_OPERACAO_106 then Exit(no106);
  if Self = NATUREZA_OPERACAO_107 then Exit(no107);
  if Self = NATUREZA_OPERACAO_108 then Exit(no108);
  if Self = NATUREZA_OPERACAO_109 then Exit(no109);
  if Self = NATUREZA_OPERACAO_110 then Exit(no110);
  if Self = NATUREZA_OPERACAO_111 then Exit(no111);
  if Self = NATUREZA_OPERACAO_112 then Exit(no112);
  if Self = NATUREZA_OPERACAO_113 then Exit(no113);
  if Self = NATUREZA_OPERACAO_114 then Exit(no114);
  if Self = NATUREZA_OPERACAO_115 then Exit(no115);
  if Self = NATUREZA_OPERACAO_116 then Exit(no116);
  if Self = NATUREZA_OPERACAO_117 then Exit(no117);
  if Self = NATUREZA_OPERACAO_118 then Exit(no118);
  if Self = NATUREZA_OPERACAO_121 then Exit(no121);
  if Self = NATUREZA_OPERACAO_200 then Exit(no200);
  if Self = NATUREZA_OPERACAO_201 then Exit(no201);
  if Self = NATUREZA_OPERACAO_301 then Exit(no301);
  if Self = NATUREZA_OPERACAO_501 then Exit(no501);
  if Self = NATUREZA_OPERACAO_511 then Exit(no511);
  if Self = NATUREZA_OPERACAO_541 then Exit(no541);
  if Self = NATUREZA_OPERACAO_551 then Exit(no551);
  if Self = NATUREZA_OPERACAO_601 then Exit(no601);
  if Self = NATUREZA_OPERACAO_701 then Exit(no701);
end;
procedure TNaturezaOperacaoHelper.setAsAcbrType(param: TnfseNaturezaOperacao);
begin
  if param = no0 then Self := NATUREZA_OPERACAO_0;
  if param = no1 then Self := NATUREZA_OPERACAO_1;
  if param = no3 then Self := NATUREZA_OPERACAO_3;
  if param = no4 then Self := NATUREZA_OPERACAO_4;
  if param = no5 then Self := NATUREZA_OPERACAO_5;
  if param = no6 then Self := NATUREZA_OPERACAO_6;
  if param = no7 then Self := NATUREZA_OPERACAO_7;
  if param = no50 then Self := NATUREZA_OPERACAO_50;
  if param = no51 then Self := NATUREZA_OPERACAO_51;
  if param = no52 then Self := NATUREZA_OPERACAO_52;
  if param = no53 then Self := NATUREZA_OPERACAO_53;
  if param = no54 then Self := NATUREZA_OPERACAO_54;
  if param = no55 then Self := NATUREZA_OPERACAO_55;
  if param = no56 then Self := NATUREZA_OPERACAO_56;
  if param = no57 then Self := NATUREZA_OPERACAO_57;
  if param = no58 then Self := NATUREZA_OPERACAO_58;
  if param = no59 then Self := NATUREZA_OPERACAO_59;
  if param = no60 then Self := NATUREZA_OPERACAO_60;
  if param = no61 then Self := NATUREZA_OPERACAO_61;
  if param = no62 then Self := NATUREZA_OPERACAO_62;
  if param = no63 then Self := NATUREZA_OPERACAO_63;
  if param = no64 then Self := NATUREZA_OPERACAO_64;
  if param = no65 then Self := NATUREZA_OPERACAO_65;
  if param = no66 then Self := NATUREZA_OPERACAO_66;
  if param = no67 then Self := NATUREZA_OPERACAO_67;
  if param = no68 then Self := NATUREZA_OPERACAO_68;
  if param = no69 then Self := NATUREZA_OPERACAO_69;
  if param = no70 then Self := NATUREZA_OPERACAO_70;
  if param = no71 then Self := NATUREZA_OPERACAO_71;
  if param = no72 then Self := NATUREZA_OPERACAO_72;
  if param = no78 then Self := NATUREZA_OPERACAO_78;
  if param = no79 then Self := NATUREZA_OPERACAO_79;
  if param = no101 then Self := NATUREZA_OPERACAO_101;
  if param = no111 then Self := NATUREZA_OPERACAO_111;
  if param = no121 then Self := NATUREZA_OPERACAO_121;
  if param = no201 then Self := NATUREZA_OPERACAO_201;
  if param = no301 then Self := NATUREZA_OPERACAO_301;
  if param = no501 then Self := NATUREZA_OPERACAO_501;
  if param = no511 then Self := NATUREZA_OPERACAO_511;
  if param = no541 then Self := NATUREZA_OPERACAO_541;
  if param = no551 then Self := NATUREZA_OPERACAO_551;
  if param = no601 then Self := NATUREZA_OPERACAO_601;
  if param = no701 then Self := NATUREZA_OPERACAO_701;
end;
function TTipoRpsHelper.getAsAcbrType: ACBrNFSeXConversao.TTipoRPS;
begin
  if Self = TIPO_RPS_RPS then
    Exit(trRPS);
  if Self = TIPO_RPS_CONJUGADA then
    Exit(trNFConjugada);
  if Self = TIPO_RPS_CUPOM then
    Exit(trCupom);
  Exit(trNone);
end;
procedure TTipoRpsHelper.setAsAcbrType(param: ACBrNFSeXConversao.TTipoRPS);
begin
  if param = trRPS then
    Self := TIPO_RPS_RPS;
  if param = trNFConjugada then
    Self := TIPO_RPS_CONJUGADA;
  if param = trCupom then
    Self := TIPO_RPS_CUPOM;
  if param = trNone then
    Self := 0;
end;

{ TIssRetidoHelper }

function TIssRetidoHelper.getAsAcbrType: TnfseSituacaoTributaria;
begin
  if Self = ISS_RETENCAO then
    Exit(stRetencao);
  if Self = ISS_NORMAL then
    Exit(stNormal);
  if Self = ISS_SUBSTITUACAO then
    Exit(stSubstituicao);
  Exit(stNormal);
end;

procedure TIssRetidoHelper.setAsAcbrType(param: TnfseSituacaoTributaria);
begin
  if param = stRetencao then
    Self := ISS_RETENCAO;
  if param = stNormal then
    Self := ISS_NORMAL;
  if param = stSubstituicao then
    Self := ISS_SUBSTITUACAO;
end;

end.
