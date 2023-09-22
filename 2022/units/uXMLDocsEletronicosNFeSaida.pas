unit uXMLDocsEletronicosNFeSaida;

interface

uses
  uIXMLDocsEletronicos, IBDataBase, IBQuery, SmallFunc, ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes;

type
  TXMLDocsEletronicosNFeSaida = class(TInterfacedObject, IXMLDocsEletronicos)
  private
    FcCNPJ: String;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FQryNFe: TIBQuery;
    FbGerouZIP: Boolean;
    procedure ApagarArquivosXML;
    procedure GerarXMLs;
    function RetornarCaminho: String;
    function RetornarNomeZip: String;
    procedure GeraXMLFaturadoCancelado;
    procedure GeraXMLInutilizado;
    procedure CarregarDados;
    function LoadXmlDestinatarioSaida(AcChaveNFe: String): WideString;
    constructor Create;
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

const
  _cInutilizacao = 'INUTILIZACAO';

{ TXMLDocsEletronicosNFeSaida }

constructor TXMLDocsEletronicosNFeSaida.Create;
begin
  FbGerouZIP := False
end;

class function TXMLDocsEletronicosNFeSaida.New: IXMLDocsEletronicos;
begin
  Result := Self.Create;
end;

function TXMLDocsEletronicosNFeSaida.Compactar: IXMLDocsEletronicos;
begin
  Result := Self;
  
  try
    ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(RetornarCaminho + '*.xml')+'" "'+Alltrim(RetornarCaminho + RetornarNomeZip)+'"'), '', SW_SHOWMAXIMIZED);

    while ConsultaProcesso('szip.exe') do
    begin
      Application.ProcessMessages;
      sleep(100);
    end;

    while not FileExists(pChar(RetornarCaminho + RetornarNomeZip)) do
    begin
      sleep(100);
    end;

    FbGerouZIP := FileExists(pChar(RetornarCaminho + RetornarNomeZip));
  finally
    ApagarArquivosXML;
  end;
end;

function TXMLDocsEletronicosNFeSaida.getCaminhoArquivos: String;
begin
  Result := EmptyStr;

  if FbGerouZIP then
    Result := RetornarCaminho + RetornarNomeZip;
end;

function TXMLDocsEletronicosNFeSaida.Salvar: IXMLDocsEletronicos;
begin
  Result := Self;

  CarregarDados;
  ApagarArquivosXML;
  GerarXMLs;
end;

procedure TXMLDocsEletronicosNFeSaida.CarregarDados;
begin
  FQryNFe.Close;
  FQryNFe.SQL.Clear;
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   0 AS ORD');
  FQryNFe.SQL.Add('   , VENDAS.NFEXML AS XML');
  FQryNFe.SQL.Add('   , VENDAS.NFEID');
  FQryNFe.SQL.Add('   , VENDAS.REGISTRO');
  FQryNFe.SQL.Add('FROM VENDAS');
  FQryNFe.SQL.Add('WHERE (VENDAS.EMISSAO >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND (VENDAS.EMISSAO <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
  FQryNFe.SQL.Add('UNION ALL');
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   1 AS ORD');
  FQryNFe.SQL.Add('   INUTILIZACAO.XML AS XML');
  FQryNFe.SQL.Add('   , ' + QuotedStr(_cInutilizacao) + ' AS NFEID');
  FQryNFe.SQL.Add('   , INUTILIZACAO.REGISTRO');
  FQryNFe.SQL.Add('FROM INUTILIZACAO');
  FQryNFe.SQL.Add('WHERE (INUTILIZACAO.DATA >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND (INUTILIZACAO.DATA <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
  FQryNFe.SQL.Add('ORDER BY ORD, REGISTRO');
  FQryNFe.Open;
end;

procedure TXMLDocsEletronicosNFeSaida.GerarXMLs;
begin
  FQryNFe.First;

  while not FQryNFe.Eof do
  begin
    if FQryNFe.FieldByName('ORD').AsInteger = 0 then
      GeraXMLFaturadoCancelado
    else
      GeraXMLInutilizado;

    FQryNFe.Next;
  end;
end;

procedure TXMLDocsEletronicosNFeSaida.GeraXMLFaturadoCancelado;
var
  slArq: TStringList;
  cArquivo: String;
begin
  slArq := TStringList.Create;
  try
    if (Pos('<nfeProc',FQryNFe.FieldByName('XML').AsString) = 0) and (Pos('<procEventoNFe',FQryNFe.FieldByName('XML').AsString) = 0) then
      slArq.Text := LoadXmlDestinatarioSaida(FQryNFe.FieldByName('NFEID').AsString)
    else
    begin
      if (Pos('<nfeProc',FQryNFe.FieldByName('XML').AsString) <> 0) or (Pos('<procEventoNFe',FQryNFe.FieldByName('XML').AsString) <> 0) then
        slArq.Text := FQryNFe.FieldByName('XML').AsString;
    end;

    cArquivo := RetornarCaminho+FQryNFe.FieldByName('NFEID').AsString;
    if (Pos('>Cancelamento</descEvento>', slArq.Text) <> 0) then
      cArquivo := cArquivo + '-caneve.xml'
    else
      cArquivo := cArquivo + '-nfe.xml';

    slArq.SaveToFile(cArquivo);
  finally
    FreeAndNil(slArq);
  end;
end;

function TXMLDocsEletronicosNFeSaida.LoadXmlDestinatarioSaida(AcChaveNFe: String): WideString;
var
  lsfile : TStringList;
begin
  lsfile := TStringList.Create;
  try
    try
      if FileExists(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-caneve.xml')) then
      begin
        lsfile.LoadFromFile(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-caneve.xml'));
        Result := lsfile.Text;
      end else
      begin
        if FileExists(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-den.xml')) then
        begin
          lsfile.LoadFromFile(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-den.xml'));
          Result := lsfile.Text;
        end else
        begin
          if FileExists(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-nfe.xml')) then
          begin
            lsfile.LoadFromFile(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '-nfe.xml'));
            Result := lsfile.Text;
          end else
          begin
            if FileExists(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '.xml')) then
            begin
              lsfile.LoadFromFile(pChar(ExtractFileDir(GetCurrentDir) + '\XmlDestinatario\' + AcChaveNFe + '.xml'));
              Result := lsfile.Text;
            end else
            begin
              Result := FQryNFe.FieldByName('XML').AsString;
            end;
          end;
        end;
      end;
    except
      Result := FQryNFe.FieldByName('XML').AsString;
    end;
  finally
    lsfile.Free;
  end;
end;

procedure TXMLDocsEletronicosNFeSaida.GeraXMLInutilizado;
var
  slArq: TStringList;
begin
  slArq := TStringList.Create;
  try
    slArq.Text := FQryNFe.FieldByname('XML').AsString;

    slArq.SaveToFile(RetornarCaminho + FQryNFe.FieldByname('REGISTRO').AsString + '-inutilizada.xml');
  finally
    FreeAndNil(slArq);
  end;
end;

procedure TXMLDocsEletronicosNFeSaida.ApagarArquivosXML;
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

function TXMLDocsEletronicosNFeSaida.RetornarCaminho: String;
begin
  Result := ExtractFileDir(GetCurrentDir)+'\CONTABIL\';
end;

function TXMLDocsEletronicosNFeSaida.setCNPJ(
  AcCNPJ: String): IXMLDocsEletronicos;
begin
  Result := Self;

  FcCNPJ := AcCNPJ;
end;

function TXMLDocsEletronicosNFeSaida.RetornarNomeZip: String;
begin
  Result := FcCNPJ + LimpaNumero(FcCNPJ) + '_' + StrTRan(DateToStr(date),'/','_')+'_NFeSaida.zip';
end;

function TXMLDocsEletronicosNFeSaida.setDatas(AdDataIni,
  AdDataFim: TDateTime): IXMLDocsEletronicos;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TXMLDocsEletronicosNFeSaida.setTransaction(
  AoTransaction: TIBTransaction): IXMLDocsEletronicos;
begin
  Result := Self;

  FQryNFe := CriaIBQuery(AoTransaction);
end;

destructor TXMLDocsEletronicosNFeSaida.Destroy;
begin
  FreeAndNil(FQryNFe);
  inherited;
end;

end.
