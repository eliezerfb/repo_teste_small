unit uGeraXMLDocsEletronicosFactory;

interface

uses
  uIGeraXMLDocsEletronicosFactory, uIXMLDocsEletronicos;

type
  TGeraXMLDocsEletronicosFactory = class(TInterfacedObject, IGeraXMLDocsEletronicosFactory)
  private
  public
    class function New: IGeraXMLDocsEletronicosFactory;
    function NFeSaida: IXMLDocsEletronicos;
    function NFeEntrada: IXMLDocsEletronicos;
    function NFCeSAT: IXMLDocsEletronicos;
  end;

implementation

uses
  uXMLDocsEletronicosNFeSaida, uXMLDocsEletronicosNFeEntrada;

{ TGeraXMLDocsEletronicosFactory }

class function TGeraXMLDocsEletronicosFactory.New: IGeraXMLDocsEletronicosFactory;
begin
  Result := Self.Create;
end;

function TGeraXMLDocsEletronicosFactory.NFCeSAT: IXMLDocsEletronicos;
begin

end;

function TGeraXMLDocsEletronicosFactory.NFeEntrada: IXMLDocsEletronicos;
begin
  Result := TXMLDocsEletronicosNFeEntrada.New;
end;

function TGeraXMLDocsEletronicosFactory.NFeSaida: IXMLDocsEletronicos;
begin
  Result := TXMLDocsEletronicosNFeSaida.New;
end;

end.
