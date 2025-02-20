// Unit para manipulação de XML de NF-e
unit uSmallNFeUtils;

interface

uses
  Controls
  , SysUtils
  , msxml
  ;


type
  TSmallNFeUtils = class
  private
    FXml: String;
    FNodeItens: IXMLDOMNodeList;
    FDomXMLNFE: IXMLDOMDocument;
    procedure SetFXml(const Value: String);
  private
  public
    constructor Create;
    destructor Destroy; override;
    property Xml: String read FXml write SetFXml;
    property NodeItens: IXMLDOMNodeList read FNodeItens write FNodeItens;
    property DomXMLNFE: IXMLDOMDocument read FDomXMLNFE write FDomXMLNFE;
    function NodeValue(sNode: String): String;
  end;

implementation

{ TSmallNFeUtils }

constructor TSmallNFeUtils.Create;
begin
  FDomXMLNFE := CoDOMDocument.Create;
end;

destructor TSmallNFeUtils.Destroy;
begin
  FNodeItens := nil;
  FDomXMLNFE     := nil;
  inherited;
end;

function TSmallNFeUtils.NodeValue(sNode: String): String;
var
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
begin
  Result := '';
  xNodes := FDomXMLNFE.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := xNodes.item[iNode].text;
  end;
end;

procedure TSmallNFeUtils.SetFXml(const Value: String);
begin
  FXml := Value;
  FDomXMLNFE.loadXML(FXml);
  FNodeItens := FDomXMLNFE.selectNodes('//det');
end;

end.
