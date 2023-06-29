unit uIEstruturaRelatorioPadrao;

interface

uses
  uIDadosImpressaoDAO, IBQuery;

type
  IEstruturaRelatorioPadrao = interface
  ['{6BD8F4D6-C0C5-413B-8BFD-22DCA48BC3D0}']
  function getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
  function setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
  function getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
  end;

implementation

end.
