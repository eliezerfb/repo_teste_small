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
    function ResumoDeVendas: IChamaRelatorioPadrao;
  end;

implementation

uses
  uChamaRelVendasCliente, uChamaRelResumoVendas;

{ TChamaRelatorioFactory }

class function TChamaRelatorioFactory.New: IChamaRelatorioFactory;
begin
  Result := Self.Create;
end;

function TChamaRelatorioFactory.ResumoDeVendas: IChamaRelatorioPadrao;
begin
  Result := TChamaRelResumoVendas.New;
end;

function TChamaRelatorioFactory.VendasPorCliente: IChamaRelatorioPadrao;
begin
  Result := TChamaRelVendasCliente.New;
end;

end.
