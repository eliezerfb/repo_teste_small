unit uIGeraRelatorioProdMonofasico;

interface

uses
  uSmallEnumerados, IBDataBase, uIEstruturaTipoRelatorioPadrao;

type
  IGeraRelatorioProdMonofasico = interface
  ['{F7A0B005-88DB-4858-AB87-526A28F6E433}']
  function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasico;
  function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasico;
  function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasico;
  function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
  function GeraRelatorio: IGeraRelatorioProdMonofasico;
  end;

implementation

end.
