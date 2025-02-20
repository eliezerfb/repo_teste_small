unit uEstruturaRelVendasPorClienteCupom;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO, DB,
  uIFiltrosRodapeRelatorio;

type
  TEstruturaRelVendasPorClienteCupom = class(TInterfacedObject, IEstruturaRelatorioPadrao)
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

uses SysUtils, uFiltrosRodapeRelatorioVendasClienteCupom;

{ TEstruturaRelVendasPorClienteCupom }

function TEstruturaRelVendasPorClienteCupom.getColunasNaoTotalizar(out AcColunas: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcColunas := EmptyStr;
end;

function TEstruturaRelVendasPorClienteCupom.FiltrosRodape: IFiltrosRodapeRelatorio;
begin
  Result := FoFiltrosRodape;
end;

function TEstruturaRelVendasPorClienteCupom.getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AcTitulo := 'Vendas por cliente (Cupom)';
end;

class function TEstruturaRelVendasPorClienteCupom.New: IEstruturaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TEstruturaRelVendasPorClienteCupom.setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
begin
  Result := Self;
  
  FoDados := AoDao;
end;

constructor TEstruturaRelVendasPorClienteCupom.Create;
begin
  FoFiltrosRodape := TFiltroRodapeRelVendasClienteCupom.New;
end;

function TEstruturaRelVendasPorClienteCupom.getDAO: IDadosImpressaoDAO;
begin
  Result := FoDados;
end;

end.
