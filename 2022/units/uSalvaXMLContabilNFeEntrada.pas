unit uSalvaXMLContabilNFeEntrada;

interface

uses
  uISalvaXMLDocsEletronicosContabil, IBDataBase, IBQuery, smallfunc_xe, ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes, DB;

type
  TSalvaXMLContabilNFeEntrada = class(TInterfacedObject, ISalvaXMLDocsEletronicosContabil)
  private
    FcCNPJ: String;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FQryNFe: TIBQuery;
    FoDataSet: TDataSet;
    FbGerouZIP: Boolean;
    constructor Create;
    function RetornarCaminho: String;
    function RetornarNomeZip: String;
    procedure ApagarArquivosXML;
    procedure CarregarDados;
    procedure GerarXMLs;
    function LoadXmlDestinatarioEntrada(AcChaveNFe: String): WideString;
    function TestarTemArquivosXML: Boolean;
  public
    destructor Destroy; override;
    class function New: ISalvaXMLDocsEletronicosContabil;
    function setTransaction(AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
    function setDatas(AdDataIni, AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
    function setCNPJ(AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
    function setDataSet(AoDataSet: TDataSet): ISalvaXMLDocsEletronicosContabil;    
    function Salvar: ISalvaXMLDocsEletronicosContabil;
    function Compactar: ISalvaXMLDocsEletronicosContabil;
    function getCaminhoArquivos: String;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSalvaXMLContabilNFeEntrada }

function TSalvaXMLContabilNFeEntrada.TestarTemArquivosXML: Boolean;
var
  oSearchRec : tSearchREC;
begin
  FindFirst(RetornarCaminho + '*.xml', faAnyFile, oSearchRec);

  Result := oSearchRec.Name <> EmptyStr;
end;

function TSalvaXMLContabilNFeEntrada.Compactar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  Sleep(100);

  if not TestarTemArquivosXML then
    Exit;

  if FileExists(RetornarCaminho + RetornarNomeZip) then
  begin
    DeleteFile(RetornarCaminho + RetornarNomeZip);
    Sleep(200);
  end;    
    
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

constructor TSalvaXMLContabilNFeEntrada.Create;
begin
  FbGerouZIP := False;

  if not DirectoryExists(RetornarCaminho) then
    ForceDirectories(RetornarCaminho);  
end;

destructor TSalvaXMLContabilNFeEntrada.Destroy;
begin
  FreeAndNil(FQryNFe);
  inherited;
end;

function TSalvaXMLContabilNFeEntrada.getCaminhoArquivos: String;
begin
  Result := EmptyStr;

  if FbGerouZIP then
    Result := RetornarCaminho + RetornarNomeZip;
end;

class function TSalvaXMLContabilNFeEntrada.New: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self.Create;
end;

function TSalvaXMLContabilNFeEntrada.RetornarCaminho: String;
begin
  Result := ExtractFilePath(Application.ExeName) + 'CONTABIL\';
end;

function TSalvaXMLContabilNFeEntrada.RetornarNomeZip: String;
begin
  Result := LimpaNumero(FcCNPJ) + '_XMLNFe_Entrada_' + StrTRan(DateToStr(date),'/','_')+'.zip';
end;

function TSalvaXMLContabilNFeEntrada.Salvar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  CarregarDados;
  ApagarArquivosXML;
  GerarXMLs;
end;

procedure TSalvaXMLContabilNFeEntrada.GerarXMLs;
var
  slArq: TStringList;
  cArquivo: String;
  cXML: String;
begin
  FQryNFe.First;

  while not FQryNFe.Eof do
  begin
    slArq := TStringList.Create;
    try
      cXML := FQryNFe.FieldByName('NFEXML').AsString;

      if (Pos('<nfeProc', cXML) = 0) and (Pos('<procEventoNFe', cXML) = 0) then
      begin
        cXML := LoadXmlDestinatarioEntrada(FQryNFe.FieldByName('NFEID').AsString);

        if FoDataSet.Locate('REGISTRO', FQryNFe.FieldByName('REGISTRO').AsString, []) then
        begin
          FoDataSet.Edit;
          FoDataSet.FieldByName('NFEXML').AsString := cXML;
          FoDataSet.Post;
        end;
      end;

      if (Pos('<nfeProc', cXML) <> 0) or (Pos('<procEventoNFe', cXML) <> 0) then
      begin
        slArq.Text := cXML;

        cArquivo := RetornarCaminho + FQryNFe.FieldByName('NFEID').AsString;
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

    FQryNFe.Next;    
  end;
end;

function TSalvaXMLContabilNFeEntrada.LoadXmlDestinatarioEntrada(AcChaveNFe: String): WideString;
Var
 slArq : TStringList;
begin
  slArq := TStringList.Create;
  try
    try
      if FileExists(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-caneve.xml')) then
      begin
        slArq.LoadFromFile(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-caneve.xml'));
        Result := slArq.Text;
      end else
      begin
        if FileExists(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-den.xml')) then
        begin
          slArq.LoadFromFile(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-den.xml'));
          Result := slArq.Text;
        end else
        begin
          if FileExists(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-nfe.xml')) then
          begin
            slArq.LoadFromFile(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '-nfe.xml'));
            Result := slArq.Text;
          end else
          begin
            if FileExists(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '.xml')) then
            begin
              slArq.LoadFromFile(pChar(ExtractFilePath(Application.ExeName) + 'XmlDestinatario\' + AcChaveNFe + '.xml'));
              Result := slArq.Text;
            end else
            begin
              Result := FQryNFe.FieldByName('NFEXML').AsString;
            end;
          end;
        end;
        //
      end;
    except
      Result := FQryNFe.FieldByName('NFEXML').AsString;
    end;
  finally
    FreeAndNil(slArq);
  end;
end;

function TSalvaXMLContabilNFeEntrada.setCNPJ(
  AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FcCNPJ := AcCNPJ;
end;

function TSalvaXMLContabilNFeEntrada.setDatas(AdDataIni,
  AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TSalvaXMLContabilNFeEntrada.setTransaction(
  AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FQryNFe := CriaIBQuery(AoTransaction);
end;

procedure TSalvaXMLContabilNFeEntrada.ApagarArquivosXML;
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

procedure TSalvaXMLContabilNFeEntrada.CarregarDados;
begin
  FQryNFe.Close;
  FQryNFe.SQL.Clear;
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('   COMPRAS.NFEXML');
  FQryNFe.SQL.Add('   , COMPRAS.NFEID');
  FQryNFe.SQL.Add('   , COMPRAS.REGISTRO');
  FQryNFe.SQL.Add('FROM COMPRAS');
  FQryNFe.SQL.Add('WHERE ((COMPRAS.EMISSAO >= ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ') AND (COMPRAS.EMISSAO <= ' + QuotedStr(DateToStrInvertida(FdDataFim)) + '))');
  FQryNFe.SQL.Add('AND (COALESCE(COMPRAS.NFEID,'''') <> '''')');
  FQryNFe.SQL.Add('AND (COALESCE(COMPRAS.NFEID,' + QuotedStr(_cZerosNFeID) + ') <> ' + QuotedStr(_cZerosNFeID) + ')');  
  FQryNFe.SQL.Add('ORDER BY COMPRAS.EMISSAO, COMPRAS.NUMERONF');
  FQryNFe.Open;
end;

function TSalvaXMLContabilNFeEntrada.setDataSet(
  AoDataSet: TDataSet): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FoDataSet := AoDataSet;
end;

end.
