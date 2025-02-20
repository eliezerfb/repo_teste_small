unit uIChamaRelatorioCommerceFactory;

interface

uses
  uIChamaRelatorioPadrao;

type
  IChamaRelatorioFactory = interface
  ['{97ADBA58-B6DC-4052-B5CE-4DF7930129E6}']
  function VendasPorCliente: IChamaRelatorioPadrao;
  function ResumoDeVendas: IChamaRelatorioPadrao;
  function TotalizadorGeralVenda: IChamaRelatorioPadrao;    
  end;

implementation

end.
