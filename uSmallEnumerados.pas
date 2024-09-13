unit uSmallEnumerados;

interface

type
  tTipoRelatorio = (ttiHTML = 1, ttiTXT = 2, ttiPDF = 3);
  tOperacaoDocumento = (todVenda, todCompra);
  tAmbienteNFe = (tanfHomologacao, tanfProducao);
  tAmbienteNFSe = (tanfsProducao = 1, tanfsHomologacao = 2);
  tTipoImpressaoOrcamento = (ttioPDF, ttioHTML, ttioPadraoWindows, ttioTXT);
  tTipoDocFrente = (ttdcMesaContaCliente = 1, ttdcSAT = 59, ttdcNFCe = 65, ttdcGerencial = 99);
  tDocsImprimirTotGeralVenda = (tditgvNFCe, tditgvSAT, tditgvNFe, tditgvCupom);
  tModulosCommerce = (tmcNaoMapeado, tmcVenda, tmcCompra, tmcEstoque, tmcOS,
                      tmcClientes, tmcBancos, tmcPagar, tmcReceber, tmcCaixa,
                      tmcOrcamento, tmcConvenio, tmcContas, tmcTransport,
                      tmcGrupos, tmcParametroTributacao, tmcPerfilTributacao,
                      tmcConversaoCFOP, tmcICM, tmc2Contas);
  //tCRTEmitente = (tcrteSimplesNacional = 1, tcrteSimplesNacionalExcessoSublimite = 2, tcrteRegimeNormal = 3); Mauricio Parizotto 2024-08-07
  tCRTEmitente = (tcrteSimplesNacional = 1, tcrteSimplesNacionalExcessoSublimite = 2, tcrteRegimeNormal = 3, tcrteRegimeSimplesMEI = 4);
  TDocsImprimirNotasFaltantes = (dinfNFe, dinfNFCe);
implementation

end.
