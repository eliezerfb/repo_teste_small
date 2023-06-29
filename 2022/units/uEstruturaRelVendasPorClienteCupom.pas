unit uEstruturaRelVendasPorClienteCupom;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO, IBQuery;

type
  TEstruturaRelVendasPorClienteCupom = class(TInterfacedObject, IEstruturaRelatorioPadrao)
  private
    FoDados: IDadosImpressaoDAO;
  public
    class function New: IEstruturaRelatorioPadrao;
    function getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
    function setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
    function getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
  end;
  
implementation

{ TEstruturaRelVendasPorClienteCupom }

function TEstruturaRelVendasPorClienteCupom.getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
begin
  Result := Self;

  AQry := FoDados.getDados;
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

end.
