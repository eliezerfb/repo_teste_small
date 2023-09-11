unit uSmallResourceString;

interface

uses
  SysUtils;

resourcestring
  _cTituloMsg = 'Atenção';

  _cMsgTextoEmailDoc = 'Você está recebendo neste e-mail o <DESCREXTANEXO> da <DESCRDOC> <NUMERODOC>, emitida em <DATAEMISSAO>.' + SLineBreak +
                    'Este documento está sendo enviado à você via e-mail para que seja guardada uma cópia eletronicamente para sua segurança.' + SLineBreak +
                    'A chave da sua NFe é <CHAVEACESSO> e você pode consultar a autenticidade deste documento juntamente no site www.nfe.fazenda.gov.br' + SLineBreak +
                    SLineBreak +
                    'Este e-mail foi enviado pelo sistema Small' + SLineBreak +
                    SLineBreak +
                    'www.smallsoft.com.br';

  _cMsgTextoEmailOrcamento = 'Você está recebendo neste e-mail o Orçamento <NUMERODOC>, emitido em <DATAEMISSAO>.' + SLineBreak +
                             SLineBreak +
                             'Este e-mail foi enviado pelo sistema Small' + SLineBreak +
                             SLineBreak +
                             'www.smallsoft.com.br';

  _cOrcamentoNaoEncontrado = 'Orçamento %s não encontrado.' + SLineBreak + SLineBreak +
                             'O número do orçamento será restaurado para a sequência automática do sistema.';
  _cPeriodoDataInvalida = 'As datas informadas não são válidas.';
  _cSemDocumentoMarcadoImpressao = 'Selecione ao menos um documento para impressão.';
  _cSemDadosParaImprimir = 'Nenhum dado encontrado para a impressão, verifique os filtros informados.';

  _cOrcamentoComDocFiscal = 'Este orçamento já foi importado para um documento fiscal e não poderá ser excluído.';

  _cMensagemExcluir = 'Excluir este registro?';

implementation

end.
