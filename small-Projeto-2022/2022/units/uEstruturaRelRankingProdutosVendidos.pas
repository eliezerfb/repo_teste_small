unit uEstruturaRelRankingProdutosVendidos;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO,
  uIFiltrosRodapeRelatorio, DB;

type
  TEstruturaRelRankingProdutosVendidos = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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

{ TEstruturaRelRankingProdutosVendidos }

constructor TEstruturaRelRankingProdutosVendidos.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelPadrao.New;
end;

function TEstruturaRelRankingProdutosVendidos.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  //AcColunas := ';Quantidade;%;'; Mauricio Parizotto 2024-05-20  f-18859
  AcColunas := ';%;';
end;

function TEstruturaRelRankingProdutosVendidos.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelRankingProdutosVendidos.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'RANKING DE PRODUTOS VENDIDOS';
end;

class function TEstruturaRelRankingProdutosVendidos.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelRankingProdutosVendidos.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

function TEstruturaRelRankingProdutosVendidos.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
