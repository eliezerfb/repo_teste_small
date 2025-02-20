unit uIEstruturaTipoRelatorioPadrao;

interface

uses
  uSmallEnumerados, uIEstruturaRelatorioPadrao, uIFiltrosRodapeRelatorio, IBDatabase,
  Data.DB;

type
  IEstruturaTipoRelatorioPadrao = interface
  ['{F3E5B816-C4C8-417E-988E-56B42670A5F5}']
  function setUsuario(AcUsuario: String): IEstruturaTipoRelatorioPadrao;
  function setDataBase(AoDataBase: TIBDatabase): IEstruturaTipoRelatorioPadrao;
  function GerarImpressao(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
  function GerarImpressaoAgrupado(AoEstruturaRel: IEstruturaRelatorioPadrao; AcTitulo: String): IEstruturaTipoRelatorioPadrao;
  function GerarImpressaoCabecalho(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
  function GerarImpressaoTitCabecalho(sTitulo : string) : IEstruturaTipoRelatorioPadrao;
  function AdicionarTitulo(AcTitulo: String; AbQuebraLinhaIni: Boolean = True; AbQuebraLinhaFim: Boolean = True): IEstruturaTipoRelatorioPadrao;
  function ImprimeQuery(sConsulta, sTitulo: string): IEstruturaTipoRelatorioPadrao;
  function AdicionarRodape(AoFiltros: IFiltrosRodapeRelatorio): IEstruturaTipoRelatorioPadrao;
  function Imprimir: IEstruturaTipoRelatorioPadrao;
  function Salvar: IEstruturaTipoRelatorioPadrao; overload;
  function Salvar(AenTipoRel: tTipoRelatorio): IEstruturaTipoRelatorioPadrao; overload;
  end;

implementation

end.
