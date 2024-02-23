unit uIGeraRelatorioProdMonofasicoCupomNota;

interface

uses
  uSmallEnumerados, IBDataBase, uIEstruturaTipoRelatorioPadrao;

type
  IGeraRelatorioProdMonofasicoCupomNota = interface
  ['{832D2D93-5540-423B-98E2-4EC1B890C6C9}']
  function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupomNota;
  function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupomNota;
  function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupomNota;
  function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
  function Salvar(AcCaminho: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioProdMonofasicoCupomNota;
  function GeraRelatorio: IGeraRelatorioProdMonofasicoCupomNota;
  end;

implementation

end.
