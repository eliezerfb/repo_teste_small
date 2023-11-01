unit uIRetornaSQLGerencialInventario;

interface

type
  IRetornaSQLGerencialInventario = interface
  ['{96E6E00B-74D3-4876-8091-955448B12216}']
  function setData(AdData: TDateTime): IRetornaSQLGerencialInventario;
  function getSQL: String;
  end;

implementation

end.
