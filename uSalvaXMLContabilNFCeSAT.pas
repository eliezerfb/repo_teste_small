unit uSalvaXMLContabilNFCeSAT;

interface

uses
  uISalvaXMLDocsEletronicosContabil, IBDataBase, IBQuery

  {Sandro Silva 2024-01-03 inicio
  , SmallFunc, smallfunc_xe
  }
  {$IFDEF VER150}
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  {Sandro Silva 2024-01-03 fim}
  , ShellAPI, Windows,
  Forms, uConectaBancoSmall, Classes, DB;

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
    function setDataSet(AoDataSet: TDataSet): ISalvaXMLDocsEletronicosContabil;
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
  Result := ExtractFilePath(Application.ExeName) + 'CONTABIL\';
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
          {Sandro Silva 2024-01-03 inicio
          or ((smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//infCFe/@Id') <> '')  //CF-e-SAT de venda com ID
              and (smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//Signature/SignatureValue') <> '')  //CF-e-SAT assinado
             )
          }
          or ((xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//infCFe/@Id') <> '')  //CF-e-SAT de venda com ID
              and (xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//Signature/SignatureValue') <> '')  //CF-e-SAT assinado
             )
          {Sandro Silva 2024-01-03 fim}

          then
        begin
          slArq.Text := StringReplace(FQryNFe.FieldByName('XML').AsString, '﻿','', [rfReplaceAll]);

          cArquivo := RetornarCaminho + FQryNFe.FieldByName('ID').AsString;

          // Sandro Silva 2024-01-03 if (Copy(smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//chNFe'), 21, 2) = '65') then  // Assim para identificar xml de cancelamento de NFC-e
          if (Copy(xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//chNFe'), 21, 2) = '65') then  // Assim para identificar xml de cancelamento de NFC-e
          begin

            if (Pos('CANCEL', AnsiUpperCase(FQryNFe.FieldByName('STATUS').AsString)) <> 0) then
              cArquivo := cArquivo + '-caneve.xml'
            else
              cArquivo := cArquivo + '-nfce.xml';
          end;
          if (xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//ide/mod') = '59') then // Sandro Silva 2024-01-03 if (smallfunc_xe.xmlNodeValue(FQryNFe.FieldByName('XML').AsString, '//ide/mod') = '59') then
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

          {Sandro Silva 2024-01-03 inicio
          cArquivo := RetornarCaminho +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//cUF') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//ano') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//CNPJ') +
                      smallfunc_xe.xmlNodeValue(slArq.Text, '//mod') +
                      RightStr('000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//serie'), 3) +
                      RightStr('000000000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//nNFIni'), 9) +
                      RightStr('000000000' + smallfunc_xe.xmlNodeValue(slArq.Text, '//nNFFin'), 9) +
                      '-inut.xml';
          }
          cArquivo := RetornarCaminho +
                      xmlNodeValue(slArq.Text, '//cUF') +
                      xmlNodeValue(slArq.Text, '//ano') +
                      xmlNodeValue(slArq.Text, '//CNPJ') +
                      xmlNodeValue(slArq.Text, '//mod') +
                      RightStr('000' + xmlNodeValue(slArq.Text, '//serie'), 3) +
                      RightStr('000000000' + xmlNodeValue(slArq.Text, '//nNFIni'), 9) +
                      RightStr('000000000' + xmlNodeValue(slArq.Text, '//nNFFin'), 9) +
                      '-inut.xml';
          {Sandro Silva 2024-01-03 fim}
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
  Sleep(100);   
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

function TSalvaXMLContabilNFCeSAT.setDataSet(
  AoDataSet: TDataSet): ISalvaXMLDocsEletronicosContabil;
begin
  Result := Self;
end;

end.
