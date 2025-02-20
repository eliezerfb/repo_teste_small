unit uISalvaXMLContabilFactory;

interface

uses
  uISalvaXMLDocsEletronicosContabil;

type
  ISalvaXMLContabilFactory = interface
  ['{22FEFA32-A1D5-49D0-8EB5-AD1761120A07}']
  function NFeSaida: ISalvaXMLDocsEletronicosContabil;
  function NFeEntrada: ISalvaXMLDocsEletronicosContabil;
  function NFCeSAT: ISalvaXMLDocsEletronicosContabil;
  end;

implementation

end.
