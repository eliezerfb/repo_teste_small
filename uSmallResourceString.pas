unit uSmallResourceString;

interface

uses
  SysUtils;

resourcestring
  _cTituloMsg = 'Aten��o';

  _cMsgTextoEmailDoc = 'Voc� est� recebendo neste e-mail o <DESCREXTANEXO> da <DESCRDOC> <NUMERODOC>, emitida em <DATAEMISSAO>.' + SLineBreak +
                    'Este documento est� sendo enviado � voc� via e-mail para que seja guardada uma c�pia eletronicamente para sua seguran�a.' + SLineBreak +
                    'A chave da sua NFe � <CHAVEACESSO> e voc� pode consultar a autenticidade deste documento juntamente no site www.nfe.fazenda.gov.br' + SLineBreak +
                    SLineBreak +
                    'Este e-mail foi enviado pelo sistema Small' + SLineBreak +
                    SLineBreak +
                    'www.smallsoft.com.br';

  _cMsgTextoEmailOrcamento = 'Voc� est� recebendo neste e-mail o Or�amento <NUMERODOC>, emitido em <DATAEMISSAO>.' + SLineBreak +
                             SLineBreak +
                             'Este e-mail foi enviado pelo sistema Small' + SLineBreak +
                             SLineBreak +
                             'www.smallsoft.com.br';

  _cOrcamentoNaoEncontrado = 'Or�amento %s n�o encontrado.' + SLineBreak + SLineBreak +
                             'O n�mero do or�amento ser� restaurado para a sequ�ncia autom�tica do sistema.';
  _cPeriodoDataInvalida = 'As datas informadas n�o s�o v�lidas.';
  _cSemDocumentoMarcadoImpressao = 'Selecione ao menos um documento para impress�o.';
  _cSemDadosParaImprimir = 'Nenhum dado encontrado para a impress�o, verifique os filtros informados.';

  _cOrcamentoComDocFiscal = 'Este or�amento j� foi importado para um documento fiscal e n�o poder� ser exclu�do.';

  _cMensagemExcluir = 'Excluir este registro?';

implementation

end.
