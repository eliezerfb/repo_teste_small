unit uEstruturaRelResumoVendasNaoList;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO,
  uIFiltrosRodapeRelatorio, DB;

type
  TEstruturaRelResumoVendasNaoList = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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

constructor TEstruturaRelResumoVendasNaoList.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelPadrao.New
                                           .setTitulo('Estes itens não foram relacionados, por um dos seguintes motivos:')
                                           .AddItem('Não faz parte do filtro')
                                           .AddItem('Foi apagado')
                                           .AddItem('Foi renomeado');

end;

function TEstruturaRelResumoVendasNaoList.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := EmptyStr
end;

function TEstruturaRelResumoVendasNaoList.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelResumoVendasNaoList.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'ITENS NÃO RELACIONADOS';
end;

class function TEstruturaRelResumoVendasNaoList.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelResumoVendasNaoList.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  FoDados := AoDao;
end;

function TEstruturaRelResumoVendasNaoList.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
