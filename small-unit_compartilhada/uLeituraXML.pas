unit uLeituraXML;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, Vcl.Dialogs
  , Windows
  , System.IniFiles
  , Winapi.WinSock
  , Forms
  , MSXML2_TLB
  , IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME
  , Soap.EncdDecd
  , Printers, ExtCtrls //2020-07-20
  , IBX.IBDatabase, IBX.IBQuery // 2020-07-21
  , LbCipher, LbClass // 2020-07-21
  , JPeg, Menus, Controls
  , DateUtils
  , ShellApi
  ,Vcl.DBCtrls
  , Vcl.StdCtrls
  , Vcl.Mask
  ;

  function xmlNodeXml(sXML: String; sNode: String): String;
  function xmlNodeValue(sXML: String; sNode: String): String;
  function ConcatencaNodeNFeComProtNFe(sNFe: String; sprotNFe: String): String;

implementation

function xmlNodeXml(sXML: String; sNode: String): String;
//Sandro Silva 2012-02-08 inicio
// Extrai valor do elemento no xml
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
begin
  // Sandro Silva 2019-07-23  XMLDOM := CoDOMDocument50.Create; // Sandro Silva 2019-04-17 XMLDOM := CoDOMDocument.Create;
  XMLDOM := CoDOMDocument.Create; // Tem que criar como CoDOMDocument, CoDOMDocument50 não funcionou 100%
  XMLDOM.loadXML(sXML);
  Result := '';
  xNodes := XMLDOM.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := xNodes.item[iNode].xml;
  end;
  XMLDOM := nil;
  xNodes := nil; // Sandro Silva 2019-06-19
end;

function xmlNodeValue(sXML: String; sNode: String): String;
//Sandro Silva 2012-02-08 inicio
//Extrai valor do elemento no xml
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
  function utf8Fix(sTexto: String): String;
  const
    acento : array[1..46] of string = ('á', 'à', 'â', 'ã', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï', 'ó', 'ò', 'ô', 'õ', 'ö', 'ú', 'ù', 'û', 'ü', 'ç', 'Á', 'À', 'Â', 'Ã', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï', 'Ó', 'Ò', 'Ô', 'Õ', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç');
    utf8: array[1..46] of string = ('Ã¡','Ã ','Ã¢','Ã£','Ã¤','Ã©','Ã¨','Ãª','Ã«','Ã­','Ã¬','Ã®','Ã¯','Ã³','Ã²','Ã´','Ãµ','Ã¶','Ãº','Ã¹','Ã»','Ã¼','Ã§','Ã','Ã€','Ã‚','Ãƒ','Ã„','Ã‰','Ãˆ','ÃŠ','Ã‹','Ã','ÃŒ','ÃŽ','Ã','Ã“','Ã’','Ã”','Ã•','Ã–','Ãš','Ã™','Ã›','Ãœ','Ã‡');
  var
    iLetra: Integer;
  begin
    Result := sTexto;
    for iLetra := 1 to length(utf8) do
    begin
      if Pos(utf8[iLetra], Result) > 0 then
        Result := StringReplace(Result, utf8[iLetra], acento[iLetra], [rfReplaceAll]);
    end;
  end;
begin
  XMLDOM := CoDOMDocument.Create;
  XMLDOM.loadXML(sXML);

  Result := '';
  try
    xNodes := XMLDOM.selectNodes(sNode);
    for iNode := 0 to xNodes.length -1 do
    begin
      Result := utf8fix(xNodes.item[iNode].text);
    end;
  except
  end;
  XMLDOM := nil;
  xNodes := nil; // Sandro Silva 2019-06-19
end;

function ConcatencaNodeNFeComProtNFe(sNFe: String; sprotNFe: String): String;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
            '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + xmlNodeValue(sNFe, '//infNFe/@versao') + '">' +
              xmlNodeXml(sNFe, '//NFe') +
              xmlNodeXML(sprotNFe, '//protNFe') +
            '</nfeProc>';
end;


end.
