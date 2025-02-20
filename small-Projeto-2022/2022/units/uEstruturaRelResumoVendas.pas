unit uEstruturaRelResumoVendas;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO,
  uIFiltrosRodapeRelatorio, DB;

type
  TEstruturaRelResumoVendas = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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

uses SysUtils, uFiltrosRodapeRelatorioPadrao;

{ TEstruturaRelCatalogoProdutos }

constructor TEstruturaRelResumoVendas.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelPadrao.New;
end;

function TEstruturaRelResumoVendas.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := ';Quantidade;%;';
end;

function TEstruturaRelResumoVendas.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelResumoVendas.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'RESUMO DAS VENDAS';
end;

class function TEstruturaRelResumoVendas.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelResumoVendas.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

function TEstruturaRelResumoVendas.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
