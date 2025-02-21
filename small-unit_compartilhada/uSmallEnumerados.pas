unit uSmallEnumerados;

interface

type
  tTipoRelatorio = (ttiHTML = 1, ttiTXT = 2, ttiPDF = 3);
  tOperacaoDocumento = (todVenda, todCompra);
  tAmbienteNFe = (tanfHomologacao, tanfProducao);
  tAmbienteNFSe = (tanfsProducao = 1, tanfsHomologacao = 2);
  tTipoImpressaoOrcamento = (ttioPDF, ttioHTML, ttioPadraoWindows, ttioTXT);

implementation

end.
