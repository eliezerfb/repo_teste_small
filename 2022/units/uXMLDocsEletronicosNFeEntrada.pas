unit uXMLDocsEletronicosNFeEntrada;

interface

uses
  uIXMLDocsEletronicos, IBDataBase, IBQuery, SmallFunc, ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes;

type
  TXMLDocsEletronicosNFeEntrada = class(TInterfacedObject, IXMLDocsEletronicos)
  private
    FcCNPJ: String;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FQryNFe: TIBQuery;
    FbGerouZIP: Boolean;
    constructor Create;
    function RetornarCaminho: String;
    function RetornarNomeZip: String;
    procedure ApagarArquivosXML;
    procedure CarregarDados;
  public
    destructor Destroy; override;
    class function New: IXMLDocsEletronicos;
    function setTransaction(AoTransaction: TIBTransaction): IXMLDocsEletronicos;
    function setDatas(AdDataIni, AdDataFim: TDateTime): IXMLDocsEletronicos;
    function setCNPJ(AcCNPJ: String): IXMLDocsEletronicos;
    function Salvar: IXMLDocsEletronicos;
    function Compactar: IXMLDocsEletronicos;
    function getCaminhoArquivos: String;
  end;

implementation

uses SysUtils;

{ TXMLDocsEletronicosNFeEntrada }

function TXMLDocsEletronicosNFeEntrada.Compactar: IXMLDocsEletronicos;
begin
  Result := Self;
end;

constructor TXMLDocsEletronicosNFeEntrada.Create;
begin
  FbGerouZIP := False;
end;

destructor TXMLDocsEletronicosNFeEntrada.Destroy;
begin
  FreeAndNil(FQryNFe);
  inherited;
end;

function TXMLDocsEletronicosNFeEntrada.getCaminhoArquivos: String;
begin
  Result := EmptyStr;

  if FbGerouZIP then
    Result := RetornarCaminho + RetornarNomeZip;
end;

class function TXMLDocsEletronicosNFeEntrada.New: IXMLDocsEletronicos;
begin
  Result := Self.Create;
end;

function TXMLDocsEletronicosNFeEntrada.RetornarCaminho: String;
begin
  Result := ExtractFileDir(GetCurrentDir)+'\CONTABIL\';
end;

function TXMLDocsEletronicosNFeEntrada.RetornarNomeZip: String;
begin
  Result := FcCNPJ + LimpaNumero(FcCNPJ) + '_' + StrTRan(DateToStr(date),'/','_')+'_NFeEntrada.zip';
end;

function TXMLDocsEletronicosNFeEntrada.Salvar: IXMLDocsEletronicos;
begin
  Result := Self;

  CarregarDados;  
end;

function TXMLDocsEletronicosNFeEntrada.setCNPJ(
  AcCNPJ: String): IXMLDocsEletronicos;
begin
  Result := Self;

  FcCNPJ := AcCNPJ;
end;

function TXMLDocsEletronicosNFeEntrada.setDatas(AdDataIni,
  AdDataFim: TDateTime): IXMLDocsEletronicos;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TXMLDocsEletronicosNFeEntrada.setTransaction(
  AoTransaction: TIBTransaction): IXMLDocsEletronicos;
begin
  Result := Self;

  FQryNFe := CriaIBQuery(AoTransaction);
end;

procedure TXMLDocsEletronicosNFeEntrada.ApagarArquivosXML;
var
  AnEncontrou: Integer;
  oSearchRec : tSearchREC;
begin
  FindFirst(RetornarCaminho + '*.xml', faAnyFile, oSearchRec);
  AnEncontrou := 0;
  while AnEncontrou = 0 do
  begin
    DeleteFile(pChar(RetornarCaminho+oSearchRec.Name));
    AnEncontrou := FindNext(oSearchRec);
  end;
end;

procedure TXMLDocsEletronicosNFeEntrada.CarregarDados;
begin
  FQryNFe.Close;
  FQryNFe.SQL.Clear;
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   COMPRAS.NFEXML AS XML');
  FQryNFe.SQL.Add('   , COMPRAS.NFEID');
  FQryNFe.SQL.Add('FROM COMPRAS');
  FQryNFe.SQL.Add('WHERE (COMPRAS.EMISSAO >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND (COMPRAS.EMISSAO <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
  FQryNFe.SQL.Add('order by COMPRAS.EMISSAO, COMPRAS.NUMERONF');
  FQryNFe.Open;
end;

end.
