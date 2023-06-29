unit uEstruturaRelVendasPorClienteNota;

interface

uses
  uIEstruturaRelatorioPadrao, uIDadosImpressaoDAO, IBQuery;

type
  TEstruturaRelVendasPorClienteNota = class(TInterfacedObject, IEstruturaRelatorioPadrao)
  private
    FoDados: IDadosImpressaoDAO;
  public
    class function New: IEstruturaRelatorioPadrao;
    function getTitulo(out AcTitulo: String): IEstruturaRelatorioPadrao;
    function setDAO(AoDao: IDadosImpressaoDAO): IEstruturaRelatorioPadrao;
    function getQuery(out AQry: TIBQuery): IEstruturaRelatorioPadrao;
  end;
  
implementation

{ TEstruturaRelVendasPorClienteNota }

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
