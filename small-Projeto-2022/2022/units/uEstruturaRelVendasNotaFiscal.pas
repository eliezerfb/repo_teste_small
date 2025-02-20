unit uEstruturaRelVendasNotaFiscal;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO,
  uIFiltrosRodapeRelatorio, DB;

type
  TEstruturaRelVendasNotaFiscal = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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

constructor TEstruturaRelVendasNotaFiscal.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelPadrao.New;
end;

function TEstruturaRelVendasNotaFiscal.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := EmptyStr;
end;

function TEstruturaRelVendasNotaFiscal.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelVendasNotaFiscal.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'RELATÓRIO DE VENDAS';
end;

class function TEstruturaRelVendasNotaFiscal.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelVendasNotaFiscal.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

function TEstruturaRelVendasNotaFiscal.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
