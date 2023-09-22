unit uIGeraXMLDocsEletronicosFactory;

interface

uses
  uIXMLDocsEletronicos;

type
  IGeraXMLDocsEletronicosFactory = interface
  ['{D3594AA8-3A02-4742-A483-E76083464B93}']
  function NFeSaida: IXMLDocsEletronicos;
  function NFeEntrada: IXMLDocsEletronicos;
  function NFCeSAT: IXMLDocsEletronicos;
  end;

implementation

end.
