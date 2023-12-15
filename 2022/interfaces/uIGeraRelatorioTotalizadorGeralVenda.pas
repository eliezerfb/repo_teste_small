unit uIGeraRelatorioTotalizadorGeralVenda;

interface

uses
  uSmallEnumerados, IBDataBase, uIEstruturaTipoRelatorioPadrao;

type
  IGeraRelatorioTotalizadorGeralVenda = interface
  ['{9A9B71A1-EA08-4491-AED0-171191B012F7}']
  function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioTotalizadorGeralVenda;
  function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioTotalizadorGeralVenda;
  function setUsuario(AcUsuario: String): IGeraRelatorioTotalizadorGeralVenda;
  function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
  function Salvar(AcCaminho: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioTotalizadorGeralVenda;
  function GeraRelatorio: IGeraRelatorioTotalizadorGeralVenda;
  function Imprimir: IGeraRelatorioTotalizadorGeralVenda;
  end;

implementation

end.
