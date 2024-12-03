unit uSmallConsts;

interface

const
  RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF  = 'ZUCCHETTI SOFTWARE E SISTEMAS LTDA'; // Sandro Silva 2023-01-18 const RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF = 'Smallsoft Tecnologia em Inform�tica EIRELI';
  RAZAO_SOCIAL_SOFTWARE_HOUSE      = 'ZUCCHETTI SOFTWARE E SISTEMAS LTDA'; // Sandro Silva 2022-12-02 Unochapeco 'Smallsoft Tecnologia em Inform�tica EIRELI';

  DIRETORIO_BKP_TEF                = 'c:\TEFBKP';

  _cSenhaSair = '#####';
  _cUsuarioAdmin = 'Administrador';
  _cRecebPagto = 'Caixa';
  _cImpressoraPadrao = 'Impressora padr�o do windows';
  _cNaoSeAplica = 'N�o se aplica';
  _cFormatDate = 'dd/mm/yyyy';
  _cArquivo10MB = 10485760;
  _cFormaPgtoBoleto = 'Boleto Banc�rio';

  _cZerosNFeID = '0000000000000000000000000000000000000000000';  

  _cSim = 'Sim';
  _cNao = 'N�o';
  _cOKUpper  = 'OK';
  _cOkCamel  = 'Ok';
  _cMedidaKU = 'KU';
  _cMedidaKG = 'KG';

  _DirImagemIcones = '\inicial\small_22_.bmp';

  _cAmbienteHomologacao = 'Homologacao';
  _cAmbienteProducao = 'Producao';  

  //Incrementar a cada altera��o do termo
  _cVersaoTermoUso = 2; // Sandro Silva 2023-09-11 _cVersaoTermoUso = 1;

  // SECTION Geral (EST0QUE.DAT)
  _cSectionGeral          = 'Geral';
  _cIdentGeralRede        = 'Rede';
  _cIdentGeralBuild       = 'Build';
  _cIdentGeralBuild2020   = _cIdentGeralBuild + ' 2020';
  _cIdentGeralBuild2023   = _cIdentGeralBuild + ' 2024'; //Sandro Silva 2024-01-12  _cIdentGeralBuild2023   = _cIdentGeralBuild + ' 2023';

  // SECTION USO (smallcom.inf)
  _cSectionUso              = 'Uso';
  _cSectionSmallComOutros   = 'Outros';
  _cIdentUso                = 'Uso';
  _cIdentCasasDecimaisQtde  = 'Casas decimais na quantidade';
  _cIdentCasasDecimaisPreco = 'Casas decimais no pre�o';
  _cIdentObservacao         = 'Observacao';
  _cCaminhoArqBalanca       = 'Caminho Arquivo balan�a';
  _cCaminhoArqBalanca2      = 'Caminho Arquivo balan�a 2';

  // SECTION USUARIO ({USUARIO}.INF)
  _cSectionGeralUsuario           = 'GERAL';
  _cSectionHtml                   = 'Html';  
  _cSectionOutros                 = 'Outros';
  _cIdentGeralUsuMarketPlaceAtivo = 'MARKETPLACE ATIVO';
  _cIdentGeralUsuMobileAtivo      = 'MOBILE ATIVO';
  _cIdentHtmlHtml1        = _cSectionHtml+'1';
  _cIdentHtmlCor          = 'Cor';
  _cIdentPeriodoInicial   = 'Per�odo Inicial';
  _cIdentPeriodoFinal     = 'Per�odo Final';
  
  //SECTION Frente de Caixa (FRENTE.INI)
  _cSectionFrenteCaixa = 'Frente de Caixa';
  _cIdentFrenteCaixaTipoEtiqueta = 'Tipo etiqueta';
  _cSectionOrcamento = 'Or�amento';
  _cSectionOrcamentoSemAcento = 'Orcamento';
  _cIdentPorta = 'Porta';

  //SECTION NFE (NFe.ini)
  _cSectionNFE = 'NFE';
  _cSectionXML = 'XML';
  _cIdentNFEAmbiente = 'Ambiente';
  _cIdentXMLPeriodoInicial = 'Periodo Inicial';
  _cIdentXMLPeriodoFinal = 'Periodo Final';
  _cIdentXMLEmailContabilidade = 'e-mail contabilidade';
  _cIdentEnvioAutomatico = 'Envio automatico';
  _cIdentIncluirRelatorioTotalizador = 'Incluir Relatorio Totalizador';
  _cIdentIncluirRelatorioMonofasicos = 'Incluir Relatorio Produtos monof�sico';
  _cIdentNFeSaida = 'NFE SAIDA';
  _cIdentNFeEntrada = 'NFE ENTRADA';
  _cIdentNFCe = 'NFCE';
  _cIdentDataUltimoEnvio = 'Data ultimo envio';

  //SECTION NFE (NFSe.ini)
  _cSectionNFSE = 'NFSE';
  _cSectionNFSE_InformacoesObtidasPrefeitura = 'Informacoes obtidas na prefeitura'; // Sandro Silva 2023-10-02
  _cIdentiPadraoCidade = 'Padrao'; // Sandro Silva 2023-10-02
  _cIdentNFSEAmbiente = 'Ambiente';
  _cObsNaDescricaoNFSE  = 'Observa��o na descri��o';
  _cCalculoDoDescontoPeloProvedor = 'C�lculo desconto no provedor';
  _cNaoDescontarIssQuandoRetido = 'N�o descontar o ISS retido';

  //OS
  _cSectionOS = 'OS';
  _cOSObservacao  ='Observa��o';
  _cOSObservacaoRecibo = 'Observa��o Recibo';

  //Outras
  _cSectionOutras         = 'Outras';
  _cOutrasLog             = 'Log Sistema';
  _cFabricaProdSemQtd     = 'Fabrica��o Prod Sem Qtd';
  _cTipoPrazo             = 'Tipo do Prazo';
  _cDiaVencimento         = 'Dia Vencimento';
  _cTemaIcones            = 'Tema dos �cones';
  _cCalculaLucroAltVenda  = 'Calcula lucro alt pre�o venda';
  _PermiteImportaMesmoOrc = 'Importar Mesmo Orc Cupom';
  _RecalculaCustoMedioRetroativo = 'Recalc Custo Medio Retroativo';
  _OcultaUsoConsumoVenda = 'Ocultar produtos uso consumo';


  //Impressora
  _cSectionImpressora  = 'Impressora';
  _cIpressoraOS        = 'Impressora OS';
  _cIpressoraOrcamento = 'Impressora Or�amento';
  _cFormatoOrcamento   = 'Formato Or�amento';

  //Carne
  _cSectionCarne  = 'Carne';
  _cCarnePIX      = 'PIX Carn�';
  _cCarneBancoPIX = 'PIX Banco';

  //Dashboard
  _cSectionDashboard = 'Dashboard';
  _DashAbertura   = 'Exibir na abertura';
  _DashNaturezas  = 'Natureza de Venda';

  _cPrivateKeyExponent = '75C2624A448186B59016FE623' +
                         'EF23ED97137C8D5F273C15EE813D2AEFD322C2AFBF868ADBB5096A78CD' +
                         'EA9D678CA9370EE0C79FAD21FEC0ECE440149D09367077B46A33F829B3' +
                         '28CAFF49F0B884AA672F9F65D632F44A492D4E92D9B33526CB8DD84416' +
                         '9240235E8F49F74C8CD1B4626A423009FC777935B091CB751895E5F6A';
  _cPrivateKeyModulus = '656B072B31EF964B1C3D31F8BC' +
                        '9BD945E7A675307DEB790B748B1197B0DFC4E4D1064ECCD625C3248970'+
                        'E4F29FC6D8F0D0385A53A9A3E7DB20C258C982CFC47B798E54EE655D55'+
                        '92269559B8DDB864E57D46ECFBFE594A572C0C9E3DA8DD2BDEBE63BDD2'+
                        '9583C66553B3969F73602CF3CAC29C78A6F3DC491507AD2C4F818077';

  const _COR_AZUL = $00EAB231;

  _RelComInstituicao   = 'Institui��o financeira';
  _RelComCredenciadora = 'Credenciadora de cart�o';

  const FONT_NAME_DEFAULT = 'FontB88'; //2016-01-14 'Calibri';//'Arial Narrow';//'Sans Serif';//'Cambria';//'MS Sans Serif';// 'Calibri'; Mauricio Parizotto 2024-04-05
  const FONT_SIZE_DEFAULT = 7; // 2015-06-29 8;//7;
  const ALTURA_PAGINA_PDF = 2448;// 3508; // Sandro Silva 2017-04-17  2374;

  const _cNFCE_EMITIDA_EM_CONTINGENCIA = 'NFC-e emitida em modo de conting�ncia';
  const _cVENDA_GERENCIAL_FINALIZADA   = 'Finalizada - Aguardando Documento Fiscal';
  const _cVENDA_MEI_ANTIGA_FINALIZADA  = 'Finalizada';


  const _RecursoIndisponivel = 'Para ter acesso � esse recurso, procure seu revendedor ou' + Chr(10) +
                               'entre em contato com a Zucchetti pelo telefone 0800 645 2008';


  const _PixManual   = 'PIX Manual';
  const _PixEstatico = 'PIX Est�tico';
  const _PixDinamico = 'PIX Din�mico';

  const _FormaPixEstatico = 'Pagamento Instant�neo (PIX) Est�tico';
  const _FormaPixDinamico = 'Pagamento Instant�neo (PIX) Din�mico';

  //Mauricio Parizotto 2024-07-15
  //Respons�vel T�cnico infRespTec
  const _RespTecCNPJ    = '03916076000664';
  const _RespTecContato = 'Bernardo Rachadel Junior';
  const _RespTecEmail   = 'bernardo.rachadel@zucchetti.com';
  const _RespTecFone    = '4934255800';

  //Mauricio Parizotto 2024-07-30
  const _TemaClassico = 'Cl�ssico';
  const _TemaModerno  = 'Moderno';

  {Dailon Parisotto (small-653) 2024-08-26 Inicio}
  _cNaturezaSINIEF = 'Anula��o de opera��o - Ajuste SINIEF 13/24';
  _cObsNFeSINIEF  = 'Procedimento autorizado pelo Ajuste SINIEF 13/24';
  {Dailon Parisotto (small-653) 2024-08-26 Fim}

  //Imendes
  _cSectionIMendes   = 'IMendes';
  _cConsultaIPI      = 'Consular IPI';
  _cFaixaFaturameto  = 'Faixa de faturamento';

  _cStatusImendesPendente      = 'Pendente';
  _cStatusImendesAlterado      = 'Alterado pelo usu�rio';
  _cStatusImendesConsultado    = 'Consultado';
  _cStatusImendesNaoConsultado = 'N�o consultado';
  _cStatusImendesRejeitado     = 'Informa��es Insuficientes';

  //Frente Sections BD
  _cSectionFrenteBD = 'Frente';
  _cTransmiteContingenciaAbertura = 'Trans Conting�ncia Abertura';

implementation

end.
