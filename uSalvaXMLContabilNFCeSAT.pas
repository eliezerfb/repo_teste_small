unit uSalvaXMLContabilNFCeSAT;

interface

uses
  uISalvaXMLDocsEletronicosContabil, IBDataBase, IBQuery, SmallFunc, smallfunc_xe, ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes;

type
  TSalvaXMLContabilNFCeSAT = class(TInterfacedObject, ISalvaXMLDocsEletronicosContabil)
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
    procedure GerarXMLs;
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

uses SysUtils, StrUtils;

{ TSalvaXMLContabilNFCeSAT }

function TSalvaXMLContabilNFCeSAT.TestarTemArquivosXML: Boolean;
var
  oSearchRec : tSearchREC;
begin
  FindFirst(RetornarCaminho + '*.xml', faAnyFile, oSearchRec);

  Result := oSearchRec.Name <> EmptyStr;
end;

function TSalvaXMLContabilNFCeSAT.Compactar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

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
    begin
      sleep(100);
    end;

    FbGerouZIP := FileExists(pChar(RetornarCaminho + RetornarNomeZip));
  finally
    ApagarArquivosXML;
  end;
end;

constructor TSalvaXMLContabilNFCeSAT.Create;
begin
  FbGerouZIP := False;

  if not DirectoryExists(RetornarCaminho) then
    ForceDirectories(RetornarCaminho);  
end;

destructor TSalvaXMLContabilNFCeSAT.Destroy;
begin
  FreeAndNil(FQryNFe);
  inherited;
end;

function TSalvaXMLContabilNFCeSAT.getCaminhoArquivos: String;
begin
  Result := EmptyStr;

  if FbGerouZIP then
    Result := RetornarCaminho + RetornarNomeZip;
end;

class function TSalvaXMLContabilNFCeSAT.New: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self.Create;
end;

function TSalvaXMLContabilNFCeSAT.RetornarCaminho: String;
begin
  Result := GetCurrentDir + '\CONTABIL\';
end;

function TSalvaXMLContabilNFCeSAT.RetornarNomeZip: String;
begin
  Result := LimpaNumero(FcCNPJ) + '_XMLNFCeSAT_' + StrTRan(DateToStr(date),'/','_')+'.zip';  
end;

function TSalvaXMLContabilNFCeSAT.Salvar: ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  CarregarDados;
  ApagarArquivosXML;
  GerarXMLs;
end;

procedure TSalvaXMLContabilNFCeSAT.GerarXMLs;
var
  slArq: TStringList;
  cArquivo: String;
begin
  FQryNFe.First;

  while not FQryNFe.Eof do
  begin
    slArq := TStringList.Create;
    try
      // FATURADAS
      if FQryNFe.FieldByName('ORD').AsInteger = 0 then
      begin
        if ((Pos('<nfeProc',FQryNFe.FieldByName('XML').AsString) <> 0) // NFC-e emitida
            or ((Pos('CANCEL', AnsiUpperCase(FQryNFe.FieldByName('STATUS').AsString)) <> 0)) // NFC-e cancelada
           )
          or ((smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//infCFe/@Id') <> '')  //CF-e-SAT de venda com ID
              and (smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//Signature/SignatureValue') <> '')  //CF-e-SAT assinado
             )
          then
        begin
          slArq.Text := StringReplace(FQryNFe.FieldByName('XML').AsString, '﻿','', [rfReplaceAll]);

          cArquivo := RetornarCaminho + FQryNFe.FieldByName('ID').AsString;

          if (Copy(smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//chNFe'), 21, 2) = '65') then  // Assim para identificar xml de cancelamento de NFC-e
          begin

            if (Pos('CANCEL', AnsiUpperCase(FQryNFe.FieldByName('STATUS').AsString)) <> 0) then
              cArquivo := cArquivo + '-caneve.xml'
            else
              cArquivo := cArquivo + '-nfce.xml';
          end;
          if (smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//ide/mod') = '59') then
          begin
            cArquivo := RetornarCaminho;
            if (Pos('CANCEL', AnsiUpperCase(FQryNFe.FieldByName('STATUS').AsString)) <> 0) then
              cArquivo := cArquivo + 'ADC'+FQryNFe.FieldByName('ID').AsString+'.xml'
            else
              cArquivo := cArquivo + 'AD'+FQryNFe.FieldByName('ID').AsString+'.xml';
          end;
        end;
      end
      else
      begin
        // INUTILIZADAS
        if (Pos('<nProt>',FQryNFe.FieldByName('XML').AsString) <> 0) then
        begin
          slArq.Text := StringReplace(FQryNFe.FieldByName('XML').AsString, '﻿','', [rfReplaceAll]);

          cArquivo := RetornarCaminho +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//cUF') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//ano') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//CNPJ') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//mod') +
                      RightStr('000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//serie'), 3) +
                      RightStr('000000000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//nNFIni'), 9) +
                      RightStr('000000000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//nNFFin'), 9) +
                      '-inut.xml';
        end;
      end;

      if Trim(slArq.Text) <> EmptyStr then
        slArq.SaveToFile(cArquivo);
    finally
      FreeAndNil(slArq);
    end;

    FQryNFe.Next;    
  end;
end;

function TSalvaXMLContabilNFCeSAT.setCNPJ(
  AcCNPJ: String): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FcCNPJ := AcCNPJ;
end;

function TSalvaXMLContabilNFCeSAT.setDatas(AdDataIni,
  AdDataFim: TDateTime): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TSalvaXMLContabilNFCeSAT.setTransaction(
  AoTransaction: TIBTransaction): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;

  FQryNFe := CriaIBQuery(AoTransaction);
end;

procedure TSalvaXMLContabilNFCeSAT.ApagarArquivosXML;
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

procedure TSalvaXMLContabilNFCeSAT.CarregarDados;
begin
  FQryNFe.Close;
  FQryNFe.SQL.Clear;
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('    0 AS ORD');
  FQryNFe.SQL.Add('    , NFCE.DATA');
  FQryNFe.SQL.Add('    , NFCE.NFEXML AS XML');
  FQryNFe.SQL.Add('    , NFCE.NFEID AS ID');
  FQryNFe.SQL.Add('    , NFCE.STATUS');
  FQryNFe.SQL.Add('FROM NFCE');
  FQryNFe.SQL.Add('WHERE');
  FQryNFe.SQL.Add('    (DATA BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
  FQryNFe.SQL.Add('    AND (COALESCE(NFEXML,'''')<>'''')');
  FQryNFe.SQL.Add('    AND ((STATUS CONTAINING ''Autoriza'')');
  FQryNFe.SQL.Add('    OR (STATUS CONTAINING ''Cancel'')');
  FQryNFe.SQL.Add('    OR (STATUS CONTAINING ''conting'')');
  FQryNFe.SQL.Add('    OR (STATUS CONTAINING ''Sucesso''))');
  FQryNFe.SQL.Add('UNION ALL');
  FQryNFe.SQL.Add('SELECT');
  FQryNFe.SQL.Add('    1 AS ORD');
  FQryNFe.SQL.Add('    , INUTILIZACAO.DATA');
  FQryNFe.SQL.Add('    , INUTILIZACAO.XML');
  FQryNFe.SQL.Add('    , INUTILIZACAO.NPROT AS ID');
  FQryNFe.SQL.Add('    , '''' AS STATUS');
  FQryNFe.SQL.Add('FROM INUTILIZACAO');
  FQryNFe.SQL.Add('WHERE');
  FQryNFe.SQL.Add('    (DATA BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
  FQryNFe.SQL.Add('    AND COALESCE(XML,'''')<>''''');
  FQryNFe.SQL.Add('    AND MODELO = ''65''');
  FQryNFe.SQL.Add('ORDER BY 1,2,3');
  FQryNFe.Open;
end;

end.
