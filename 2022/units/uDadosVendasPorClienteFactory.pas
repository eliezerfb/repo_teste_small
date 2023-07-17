unit uDadosVendasPorClienteFactory;

interface

uses
  uIDadosVendasPorClienteFactory, uIDadosImpressaoDAO;

type
  TDadosVendasPorClienteFactory = class(TInterfacedObject, IDadosVendasPorClienteFactory)
  private
  public
    class function New: IDadosVendasPorClienteFactory;
    function RetornarDAONota(AbItemAItem: Boolean): IDadosImpressaoDAO;
    function RetornarDAOCupom(AbItemAItem: Boolean): IDadosImpressaoDAO;
  end;

implementation

uses
  uDadosVendasPorClienteNotaDAO, uDadosVendasPorClienteNotaItemAItemDAO,
  uDadosVendasPorClienteCupomDAO, uDadosVendasPorClienteCupomItemAItemDAO;

{ TDadosVendasPorClienteFactory }

class function TDadosVendasPorClienteFactory.New: IDadosVendasPorClienteFactory;
begin
  Result := Self.Create;
end;

function TDadosVendasPorClienteFactory.RetornarDAONota(AbItemAItem: Boolean): IDadosImpressaoDAO;
begin
  if AbItemAItem then
    Result := TDadosVendasPorClienteNotaItemAItemDAO.New
  else
    Result := TDadosVendasPorClienteNotaDAO.New;
end;

function TDadosVendasPorClienteFactory.RetornarDAOCupom(AbItemAItem: Boolean): IDadosImpressaoDAO;
begin
  if AbItemAItem then
    Result := TDadosVendasPorClienteCupomItemAItemDAO.New
  else
    Result := TDadosVendasPorClienteCupomDAO.New;
end;

end.
