unit uEstruturaRelCatalogoProdutos;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO,
  uIFiltrosRodapeRelatorio, DB;

type
  TEstruturaRelCatalogoProdutos = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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
    function getDAO: IDadosImpressaoDAO;
  end;

implementation

uses SysUtils, uFiltrosRodapeRelatorioCatalogoProdutos;

{ TEstruturaRelCatalogoProdutos }

constructor TEstruturaRelCatalogoProdutos.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelCatalogoProdutos.New;
end;

function TEstruturaRelCatalogoProdutos.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := EmptyStr;
end;

function TEstruturaRelCatalogoProdutos.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelCatalogoProdutos.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'CATÁLOGO DE PRODUTOS';
end;

class function TEstruturaRelCatalogoProdutos.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelCatalogoProdutos.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

function TEstruturaRelCatalogoProdutos.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
