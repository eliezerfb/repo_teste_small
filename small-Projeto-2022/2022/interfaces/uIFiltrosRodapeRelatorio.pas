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
  function setTitulo(AcTitulo: String): IFiltrosRodapeRelatorio;
  function getTitulo: String;
  function getItens: TStringList;
  end;

implementation

end.
