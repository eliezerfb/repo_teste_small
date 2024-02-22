unit uIGeraRelatorioProdMonofasicoCupom;

interface

uses
  uSmallEnumerados, IBDataBase, uIEstruturaTipoRelatorioPadrao;

type
  IGeraRelatorioProdMonofasicoCupom = interface
  ['{F7A0B005-88DB-4858-AB87-526A28F6E433}']
  function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupom;
  function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupom;
  function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupom;
  function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
  function GeraRelatorio: IGeraRelatorioProdMonofasicoCupom;
  function Imprimir: IGeraRelatorioProdMonofasicoCupom;
  end;

implementation

end.
