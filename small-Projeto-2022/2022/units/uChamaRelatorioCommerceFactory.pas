unit uChamaRelatorioCommerceFactory;

interface

uses
  uIChamaRelatorioPadrao, uIChamaRelatorioCommerceFactory;

type
  TChamaRelatorioFactory = class(TInterfacedObject, IChamaRelatorioFactory)
  private
  public
    class function New: IChamaRelatorioFactory;
    function VendasPorCliente: IChamaRelatorioPadrao;    
  end;

implementation

uses
  uChamaRelVendasCliente;

{ TChamaRelatorioFactory }

class function TChamaRelatorioFactory.New: IChamaRelatorioFactory;
begin
  Result := Self.Create;
end;

function TChamaRelatorioFactory.VendasPorCliente: IChamaRelatorioPadrao;
begin
  Result := TChamaRelVendasCliente.New;
end;

end.
