unit uIFiltrosRodapeRelatorio;

interface

uses
  Classes;

type
  IFiltrosRodapeRelatorio = interface
  ['{C9E4EC49-89A3-4182-8C68-7B9CAD3C6E1C}']
  function AddItem(AcDescricao: String): IFiltrosRodapeRelatorio;
  function setFiltroData(AcFiltro: String): IFiltrosRodapeRelatorio;
  function getFiltroData: String;
  function getTitulo: String;
  function getItens: TStrings;
  end;

implementation

end.
