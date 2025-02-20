unit uSalvaXMLContabilNFeSaida;

interface

uses
  uISalvaXMLDocsEletronicosContabil, IBDataBase, IBQuery, SmallFunc, ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes;

type
  TSalvaXMLContabilNFeSaida = class(TInterfacedObject, ISalvaXMLDocsEletronicosContabil)
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
    function TestarTemArquivosXML: Boolean;
  public
    destructor Destroy; override;
    class function New: ISalvaXMLDocsEletronicosContabil;
    function setTransaction(AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
    function setDatas(AdDataIni, AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
    function setCNPJ(AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
    function Salvar: ISalvaXMLDocsEletronicosContabil;
    function Compactar: ISalvaXMLDocsEletronicosContabil;
    function getCaminhoArquivos: String;
  end;

implementation

uses SysUtils, uSmallConsts;

const
  _cInutilizacao = 'INUTILIZACAO';

{ TSalvaXMLContabilNFeSaida }

constructor TSalvaXMLContabilNFeSaida.Create;
begin
  FbGerouZIP := False;

  if not DirectoryExists(RetornarCaminho) then
    ForceDirectories(RetornarCaminho);
end;

class function TSalvaXMLContabilNFeSaida.New: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self.Create;
end;

function TSalvaXMLContabilNFeSaida.Compactar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  Sleep(100);
  
  if not TestarTemArquivosXML then
    Exit;
    
  try
    ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(RetornarCaminho + '*.xml')+'" "'+Alltrim(RetornarCaminho + RetornarNomeZip)+'"'), '', SW_SHOWMAXIMIZED);

    while ConsultaProcesso('szip.exe') do
    begin
      Application.ProcessMessages;
      sleep(100);
    end;

    while not FileExists(pChar(RetornarCaminho + RetornarNomeZip)) do
      sleep(100);

    FbGerouZIP := FileExists(pChar(RetornarCaminho + RetornarNomeZip));
  finally
    ApagarArquivosXML;
  end;
end;

function TSalvaXMLContabilNFeSaida.getCaminhoArquivos: String;
begin
  Result := EmptyStr;

  if FbGerouZIP then
    Result := RetornarCaminho + RetornarNomeZip;
end;

function TSalvaXMLContabilNFeSaida.Salvar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  CarregarDados;
  ApagarArquivosXML;
  GerarXMLs;
end;

procedure TSalvaXMLContabilNFeSaida.CarregarDados;
begin
  FQryNFe.Close;
  FQryNFe.SQL.Clear;
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   0 AS ORD');
  FQryNFe.SQL.Add('   , VENDAS.NFEXML AS XML');
  FQryNFe.SQL.Add('   , VENDAS.NFEID');
  FQryNFe.SQL.Add('   , VENDAS.REGISTRO');
  FQryNFe.SQL.Add('FROM VENDAS');
  FQryNFe.SQL.Add('WHERE');
  FQryNFe.SQL.Add('((VENDAS.EMISSAO >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ') AND (VENDAS.EMISSAO <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + '))');
  FQryNFe.SQL.Add('AND (VENDAS.MODELO = ''55'')');
  FQryNFe.SQL.Add('AND (COALESCE(VENDAS.NFEID,'''') <> '''')');
  FQryNFe.SQL.Add('AND (COALESCE(VENDAS.NFEID,' + QuotedStr(_cZerosNFeID) + ') <> ' + QuotedStr(_cZerosNFeID) + ')');
  FQryNFe.SQL.Add('UNION ALL');
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   1 AS ORD');
  FQryNFe.SQL.Add('   , INUTILIZACAO.XML AS XML');
  FQryNFe.SQL.Add('   , ' + QuotedStr(_cInutilizacao) + ' AS NFEID');
  FQryNFe.SQL.Add('   , INUTILIZACAO.REGISTRO');
  FQryNFe.SQL.Add('FROM INUTILIZACAO');
  FQryNFe.SQL.Add('WHERE ((INUTILIZACAO.DATA >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ') AND (INUTILIZACAO.DATA <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + '))');
  FQryNFe.SQL.Add('AND (INUTILIZACAO.MODELO = ''55'')');
  FQryNFe.SQL.Add('ORDER BY 1, 4');
  FQryNFe.Open;
end;

procedure TSalvaXMLContabilNFeSaida.GerarXMLs;
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

procedure TSalvaXMLContabilNFeSaida.GeraXMLFaturadoCancelado;
var
  slArq: TStringList;
  cArquivo: String;
  cXML: String;
begin
  slArq := TStringList.Create;
  try
    cXML := FQryNFe.FieldByName('XML').AsString;

    if (Pos('<nfeProc',cXML) = 0) and (Pos('<procEventoNFe',cXML) = 0) then
      cXML := LoadXmlDestinatarioSaida(FQryNFe.FieldByName('NFEID').AsString);

    if (Pos('<nfeProc',cXML) <> 0) or (Pos('<procEventoNFe',cXML) <> 0) then
    begin
      slArq.Text := cXML;

      cArquivo := RetornarCaminho+FQryNFe.FieldByName('NFEID').AsString;
      if (Pos('>Cancelamento</descEvento>', slArq.Text) <> 0) then
        cArquivo := cArquivo + '-caneve.xml'
      else
        cArquivo := cArquivo + '-nfe.xml';

      if Pos(_cZerosNFeID, cArquivo) > 0 then
        Exit;

      if Trim(slArq.Text) <> EmptyStr then
        slArq.SaveToFile(cArquivo);
    end;
  finally
    FreeAndNil(slArq);
  end;
end;

function TSalvaXMLContabilNFeSaida.LoadXmlDestinatarioSaida(AcChaveNFe: String): WideString;
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

procedure TSalvaXMLContabilNFeSaida.GeraXMLInutilizado;
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

function TSalvaXMLContabilNFeSaida.TestarTemArquivosXML: Boolean;
var
  oSearchRec : tSearchREC;
begin
  FindFirst(RetornarCaminho + '*.xml', faAnyFile, oSearchRec);

  Result := oSearchRec.Name <> EmptyStr;
end;

procedure TSalvaXMLContabilNFeSaida.ApagarArquivosXML;
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
  Sleep(100);  
end;

function TSalvaXMLContabilNFeSaida.RetornarCaminho: String;
begin
  Result := GetCurrentDir + '\CONTABIL\';
end;

function TSalvaXMLContabilNFeSaida.setCNPJ(
  AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FcCNPJ := AcCNPJ;
end;

function TSalvaXMLContabilNFeSaida.RetornarNomeZip: String;
begin
  Result := LimpaNumero(FcCNPJ) + '_XMLNFe_Saida_' + StrTRan(DateToStr(date),'/','_')+'.zip';
end;

function TSalvaXMLContabilNFeSaida.setDatas(AdDataIni,
  AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TSalvaXMLContabilNFeSaida.setTransaction(
  AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FQryNFe := CriaIBQuery(AoTransaction);
end;

destructor TSalvaXMLContabilNFeSaida.Destroy;
begin
  FreeAndNil(FQryNFe);
  inherited;
end;

end.
