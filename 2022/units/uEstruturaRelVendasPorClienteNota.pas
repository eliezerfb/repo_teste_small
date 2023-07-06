unit uEstruturaRelVendasPorClienteNota;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO, IBQuery,
  uIFiltrosRodapeRelatorio;

type
  TEstruturaRelVendasPorClienteNota = class(TInterfacedObject, IEstruturaRelatorioPadrao)
  private
    FoDados: IDadosImpressaoDAO;
    FoFiltrosRodape: IFiltrosRodapeRelatorio;
    constructor Create;
  public
    class function New: IEstruturaRelatorioPadrao;
    function getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
    function setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
    function getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
    function FiltrosRodape: IFiltrosRodapeRelatorio;
    function getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
  end;

implementation

uses SysUtils, uFiltrosRodapeRelatorioVendasClienteNota;

{ TEstruturaRelVendasPorClienteNota }

constructor TEstruturaRelVendasPorClienteNota.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelVendasClienteNota.New;
end;

function TEstruturaRelVendasPorClienteNota.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := EmptyStr;
end;

function TEstruturaRelVendasPorClienteNota.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelVendasPorClienteNota.getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AQry := FoDados.getDados;
end;

function TEstruturaRelVendasPorClienteNota.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'Vendas por cliente (Nota)';
end;

class function TEstruturaRelVendasPorClienteNota.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelVendasPorClienteNota.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

end.
