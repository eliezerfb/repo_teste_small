unit uSalvaXMLContabilFactory;

interface

uses
  uISalvaXMLContabilFactory, uISalvaXMLDocsEletronicosContabil;

type
  TSalvaXMLContabilFactory = class(TInterfacedObject, ISalvaXMLContabilFactory)
  private
  public
    class function New: ISalvaXMLContabilFactory;
    function NFeSaida: ISalvaXMLDocsEletronicosContabil;
    function NFeEntrada: ISalvaXMLDocsEletronicosContabil;
    function NFCeSAT: ISalvaXMLDocsEletronicosContabil;
  end;

implementation

uses
  uSalvaXMLContabilNFeSaida, uSalvaXMLContabilNFeEntrada,
  uSalvaXMLContabilNFCeSAT;

{ TSalvaXMLContabilFactory }

class function TSalvaXMLContabilFactory.New: ISalvaXMLContabilFactory;
begin
  Result := Self.Create;
end;

function TSalvaXMLContabilFactory.NFCeSAT: ISalvaXMLDocsEletronicosContabil;
begin
  Result := TSalvaXMLContabilNFCeSAT.New;
end;

function TSalvaXMLContabilFactory.NFeEntrada: ISalvaXMLDocsEletronicosContabil;
begin
  Result := TSalvaXMLContabilNFeEntrada.New;
end;

function TSalvaXMLContabilFactory.NFeSaida: ISalvaXMLDocsEletronicosContabil;
begin
  Result := TSalvaXMLContabilNFeSaida.New;
end;

end.
