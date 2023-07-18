unit uIDadosVendasPorClienteFactory;

interface

uses
  uIDadosImpressaoDAO;

type
  IDadosVendasPorClienteFactory = interface
  ['{5D5BE9E1-DCBD-4B94-97FA-C791CA4033F2}']
  function RetornarDAONota(AbItemAItem: Boolean): IDadosImpressaoDAO;
  function RetornarDAOCupom(AbItemAItem: Boolean): IDadosImpressaoDAO;
  end;

implementation

end.
