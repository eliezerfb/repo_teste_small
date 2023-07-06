unit uIEstruturaRelatorioPadrao;

interface

uses
  uIDadosImpressaoDAO, IBQuery, uIFiltrosRodapeRelatorio;

type
  IEstruturaRelatorioPadrao = interface
  ['{6BD8F4D6-C0C5-413B-8BFD-22DCA48BC3D0}']
  function getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
  function setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
  // Separar os campos por ponto e virgula (;) e colocar no inicio e final.
  // Exmeplo ;Vlr unit.;Qtde;
  // CAMPOS QUE N�O S�O VALOR N�O PRECISA ESPECIFICAR NO M�TODO.
  function getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
  function FiltrosRodape: IFiltrosRodapeRelatorio;
  function getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
  end;

implementation

end.
