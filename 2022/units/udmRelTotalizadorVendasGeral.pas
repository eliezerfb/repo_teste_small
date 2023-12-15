unit udmRelTotalizadorVendasGeral;

interface

uses
  SysUtils, Classes, DB, DBClient, IBCustomDataSet, IBQuery, IBDataBase,
  Dialogs, uSmallEnumerados, uConectaBancoSmall;

type
  TdmRelTotalizadorVendasGeral = class(TDataModule)
    cdsTotalPorFormaPgto: TClientDataSet;
    cdsTotalPorFormaPgtoFORMA: TStringField;
    cdsTotalPorFormaPgtoVALOR: TFMTBCDField;
    qryDocumentosDescAcresc: TIBQuery;
    qryFormaPgto: TIBQuery;
    qryDescontoItemCFOP: TIBQuery;
    cdsTotalCFOP: TClientDataSet;
    cdsTotalCFOPCFOP: TStringField;
    cdsTotalCFOPVALOR: TFMTBCDField;
    cdsTotalCSOSN: TClientDataSet;
    cdsTotalCSOSNCSOSN: TStringField;
    cdsTotalCSOSNVALOR: TFMTBCDField;
    qryDadosCST: TIBQuery;
    cdsTotalPorFormaPgtoTIPO: TStringField;
    qryDescontoDoc: TIBQuery;
    qryAcrescimoDoc: TIBQuery;
    qryTotalItens: TIBQuery;
    qryTotalDoc: TIBQuery;
    DataSetNF: TIBDataSet;
    DataSetItensNF: TIBDataSet;
    qryDescontoItemCSOSN: TIBQuery;
    qryItensDocumento: TIBQuery;
    qryDescontoItem: TIBQuery;
    qryNFs: TIBQuery;
    cdsTotalCFOPTemp: TClientDataSet;
    cdsTotalCSOSNTemp: TClientDataSet;
    cdsTotalCFOPTempCFOP: TStringField;
    cdsTotalCFOPTempVALOR: TFMTBCDField;
    cdsTotalCSOSNTempCSOSN: TStringField;
    cdsTotalCSOSNTempVALOR: TFMTBCDField;
    cdsTotalCFOPTIPO: TStringField;
    cdsTotalCSOSNTIPO: TStringField;
    cdsTotalCFOPTempTIPO: TStringField;
    cdsTotalCSOSNTempTIPO: TStringField;
    qryEmitente: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;

    procedure CarregarTotalDoc(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregarDescontoItemPorCFOP(AenDocImp: tDocsImprimirTotGeralVenda);
    function RetornarTabelaTemporariaDocumentos(AenDocImp: tDocsImprimirTotGeralVenda): String;
    procedure CarregarDescontoItemPorCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaDadosDocumentosComDescAcresc(AenDocImp: tDocsImprimirTotGeralVenda);
  public
    procedure setDataBase(AoDataBase: TIBDatabase);
    procedure CarregaDadosFormaPgto(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaPorCFOPCSTCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaNFs;
    procedure CarregaDadosNFParaObj(AcNumeroNF: String);
    procedure setPeriodo(AdDataIni, AdDataFim: TDateTime);
    procedure CarregaDescontosItem(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaDadosDescAcrescDocumentos(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregarDescontoDoc(AcPedido, AcCaixa: String);
    procedure CarregaItensDocumento(AcPedido, AcCaixa: String);
    procedure CarregarTotalItens(AcPedido, AcCaixa: String);
    procedure CarregaDescontoItem(AcPedido, AcCaixa, AcItem: String);
    procedure CarregarAcrescimoDoc(AcPedido, AcCaixa: String);
    procedure CarregaDadosEmitente;     
  end;

var
  dmRelTotalizadorVendasGeral: TdmRelTotalizadorVendasGeral;

implementation

{$R *.dfm}

procedure TdmRelTotalizadorVendasGeral.DataModuleCreate(Sender: TObject);
begin
  if cdsTotalPorFormaPgto.Active then
    cdsTotalPorFormaPgto.Close;
  cdsTotalPorFormaPgto.CreateDataSet;

  cdsTotalPorFormaPgtoTIPO.Visible := False;

  if cdsTotalCFOP.Active then
    cdsTotalCFOP.Close;
  cdsTotalCFOP.CreateDataSet;

  if cdsTotalCFOPTemp.Active then
    cdsTotalCFOPTemp.Close;
  cdsTotalCFOPTemp.CreateDataSet;

  if cdsTotalCSOSN.Active then
    cdsTotalCSOSN.Close;
  cdsTotalCSOSN.CreateDataSet;

  if cdsTotalCSOSNTemp.Active then
    cdsTotalCSOSNTemp.Close;
  cdsTotalCSOSNTemp.CreateDataSet;
end;

procedure TdmRelTotalizadorVendasGeral.DataModuleDestroy(Sender: TObject);
begin
  cdsTotalPorFormaPgto.Close;
  cdsTotalCFOP.Close;
  cdsTotalCSOSN.Close;
  cdsTotalCFOPTemp.Close;
  cdsTotalCSOSNTemp.Close;
end;

function TdmRelTotalizadorVendasGeral.RetornarTabelaTemporariaDocumentos(AenDocImp: tDocsImprimirTotGeralVenda): String;
var
  slSQL: TStringList;
begin
  slSQL := TStringList.Create;
  try
    slSQL.Add('WITH DOCUMENTOS AS (');
    slSQL.Add('SELECT DISTINCT');
    case AenDocImp of
      tditgvNFCe:
      begin
        slSQL.Add('    ''NFC-e'' AS TIPO');
        slSQL.Add('    , NFCE.DATA');
        slSQL.Add('    , NFCE.CAIXA');
        slSQL.Add('    , NFCE.NUMERONF AS PEDIDO');
        slSQL.Add('    , NFCE.MODELO');
        slSQL.Add('FROM NFCE');
        slSQL.Add('JOIN ALTERACA A');
        slSQL.Add('    ON (A.PEDIDO = NFCE.NUMERONF) AND (A.CAIXA = NFCE.CAIXA)');
        slSQL.Add('WHERE');
        slSQL.Add('    ((NFCE.STATUS CONTAINING ''Autorizad'')');
        slSQL.Add('      OR (NFCE.STATUS CONTAINING ''NFC-e emitida em modo de contingência'')');
        slSQL.Add('    )');
        slSQL.Add('    AND (NFCE.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
        slSQL.Add('    AND (NFCE.MODELO = ''65'')');
      end;
      tditgvSAT:
      begin
        slSQL.Add('    ''SAT'' AS TIPO');
        slSQL.Add('    , NFCE.DATA');
        slSQL.Add('    , NFCE.CAIXA');
        slSQL.Add('    , NFCE.NUMERONF AS PEDIDO');
        slSQL.Add('    , NFCE.MODELO');
        slSQL.Add('FROM NFCE');
        slSQL.Add('JOIN ALTERACA A');
        slSQL.Add('    ON (A.PEDIDO = NFCE.NUMERONF) AND (A.CAIXA = NFCE.CAIXA)');
        slSQL.Add('WHERE');
        slSQL.Add('    ((NFCE.STATUS CONTAINING ''Autorizad'')');
        slSQL.Add('      OR (NFCE.STATUS CONTAINING ''Emitido com sucesso'')');
        slSQL.Add('    )');
        slSQL.Add('    AND (NFCE.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
        slSQL.Add('    AND (NFCE.MODELO = ''59'')');
      end;
      tditgvCupom:
      begin
        slSQL.Add('    ''Cupom'' AS TIPO');
        slSQL.Add('    , A.DATA');
        slSQL.Add('    , A.CAIXA');
        slSQL.Add('    , A.PEDIDO AS PEDIDO');
        slSQL.Add('    , CAST(''2D'' AS VARCHAR(2)) AS MODELO');
        slSQL.Add('FROM ALTERACA A');
        slSQL.Add('WHERE ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''VENDA'') OR (A.TIPO = ''LOKED''))');
        slSQL.Add('    AND (A.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
        slSQL.Add('    AND ((SELECT COUNT(N.NUMERONF) FROM NFCE N WHERE (N.CAIXA=A.CAIXA) AND (N.NUMERONF=A.PEDIDO)) = 0)');
      end;
      else
      begin
        slSQL.Add('    ''NF-e'' AS TIPO');
        slSQL.Add('    , V.EMISSAO AS DATA');
        slSQL.Add('    , CAST('''' AS VARCHAR(3)) AS CAIXA');
        slSQL.Add('    , V.NUMERONF AS PEDIDO');
        slSQL.Add('    , V.MODELO AS MODELO');
        slSQL.Add('FROM VENDAS V');
        slSQL.Add('WHERE');
        slSQL.Add('    (V.EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
        slSQL.Add('    AND (V.STATUS CONTAINING ''Autorizado'')');
        slSQL.Add('    AND (((V.FINNFE = ''1'') and (V.MODELO = ''55'')) or ((coalesce(V.FINNFE, '''') = '''') and (V.MODELO <> ''55'')))');
      end;
    end;
    slSQL.Add('ORDER BY 1,2,4)');

    Result := slSQL.Text;
  finally
    FreeAndNil(slSQL);
  end;
end;

procedure TdmRelTotalizadorVendasGeral.setDataBase(AoDataBase: TIBDatabase);
begin
  qryEmitente.Database             := AoDataBase;
  qryDocumentosDescAcresc.Database := AoDataBase;
  qryFormaPgto.Database            := AoDataBase;
  qryDescontoItemCFOP.Database     := AoDataBase;
  qryDescontoItemCSOSN.Database    := AoDataBase;
  qryDescontoDoc.Database    := AoDataBase;
  qryAcrescimoDoc.Database   := AoDataBase;
  qryDadosCST.Database       := AoDataBase;
  qryTotalItens.Database     := AoDataBase;
  qryTotalDoc.Database       := AoDataBase;
  qryItensDocumento.Database := AoDataBase;
  qryDescontoItem.Database   := AoDataBase;
  qryNFs.Database            := AoDataBase;

  DataSetNF.Database       := AoDataBase;
  DataSetItensNF.Database  := AoDataBase;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosFormaPgto(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryFormaPgto.Close;
  qryFormaPgto.SQL.Clear;
  qryFormaPgto.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryFormaPgto.SQL.Add('SELECT');
  qryFormaPgto.SQL.Add('    DOCUMENTOS.TIPO');
  case AenDocImp of
    tditgvNFCe, tditgvSAT, tditgvCupom:
    begin
      qryFormaPgto.SQL.Add('    , TRIM(REPLACE(REPLACE(SUBSTRING(P.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', '''')) AS FORMA');
      qryFormaPgto.SQL.Add('    , SUM(COALESCE(CASE WHEN SUBSTRING(P.FORMA FROM 1 FOR 2) = ''13'' THEN (P.VALOR * -1) ELSE P.VALOR END,0)) AS TOTAL');
      qryFormaPgto.SQL.Add('FROM PAGAMENT P');
      qryFormaPgto.SQL.Add('INNER JOIN DOCUMENTOS');
      qryFormaPgto.SQL.Add('    ON (DOCUMENTOS.PEDIDO=P.PEDIDO)');
      qryFormaPgto.SQL.Add('    AND (DOCUMENTOS.CAIXA=P.CAIXA)');
      qryFormaPgto.SQL.Add('    AND (DOCUMENTOS.DATA=P.DATA)');
      qryFormaPgto.SQL.Add('WHERE');
      qryFormaPgto.SQL.Add('    (P.FORMA <> ''00 Total'')');
      qryFormaPgto.SQL.Add('    AND (COALESCE(P.CLIFOR, ''X'') <> ''Sangria'')');
      qryFormaPgto.SQL.Add('    AND (COALESCE(P.CLIFOR, ''X'') <> ''Suprimento'')');
      qryFormaPgto.SQL.Add('    AND ((COALESCE(P.CAIXA, '''') = '''')');
      qryFormaPgto.SQL.Add('         OR (P.PEDIDO IN (SELECT A.PEDIDO FROM ALTERACA A WHERE (A.PEDIDO = P.PEDIDO) AND (A.CAIXA = P.CAIXA) AND (A.DATA = P.DATA) AND ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''LOKED'') OR (TIPO = ''VENDA''))))');
      qryFormaPgto.SQL.Add('        )');
      qryFormaPgto.SQL.Add('GROUP BY DOCUMENTOS.TIPO, TRIM(REPLACE(REPLACE(SUBSTRING(P.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', ''''))');
      qryFormaPgto.SQL.Add('ORDER BY SUBSTRING(1 FROM 4 FOR 20)');
    end;
    else
    begin
      qryFormaPgto.SQL.Add('    , TRIM(COALESCE(COALESCE(RECEBER.FORMADEPAGAMENTO, TRIM(REPLACE(REPLACE(SUBSTRING(PAGAMENT.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', ''''))), ''Não informado'')) AS FORMA');
      qryFormaPgto.SQL.Add('    , SUM(COALESCE(COALESCE(RECEBER.VALOR_DUPL, PAGAMENT.VALOR), VENDAS.TOTAL)) AS TOTAL');
      qryFormaPgto.SQL.Add('FROM VENDAS');
      qryFormaPgto.SQL.Add('INNER JOIN DOCUMENTOS');
      qryFormaPgto.SQL.Add('    ON (DOCUMENTOS.PEDIDO=VENDAS.NUMERONF)');
      qryFormaPgto.SQL.Add('    AND (DOCUMENTOS.DATA=VENDAS.EMISSAO)');
      qryFormaPgto.SQL.Add('LEFT JOIN RECEBER');
      qryFormaPgto.SQL.Add('    ON (RECEBER.NUMERONF=VENDAS.NUMERONF)');
      // Se for INTEGRACAO = CAIXA Vai gerar registro no PAGAMENT e não no RECEBER
      qryFormaPgto.SQL.Add('LEFT JOIN PAGAMENT');
      qryFormaPgto.SQL.Add('    ON (PAGAMENT.DATA=VENDAS.EMISSAO)');
      qryFormaPgto.SQL.Add('    AND (PAGAMENT.CLIFOR=VENDAS.CLIENTE)');
      qryFormaPgto.SQL.Add('    AND (PAGAMENT.PEDIDO=(SUBSTRING(VENDAS.NUMERONF FROM 4 FOR 6)))');
      qryFormaPgto.SQL.Add('GROUP BY DOCUMENTOS.TIPO, FORMA');
      qryFormaPgto.SQL.Add('ORDER BY FORMA');
    end;
  end;
  qryFormaPgto.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryFormaPgto.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryFormaPgto.Open;
  qryFormaPgto.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosNFParaObj(AcNumeroNF: String);
begin
  DataSetNF.Close;
  DataSetNF.SelectSQL.Clear;
  DataSetNF.SelectSQL.Add('SELECT * FROM VENDAS WHERE (NUMERONF=:XNUMERONF)');
  DataSetNF.ParamByName('XNUMERONF').AsString := AcNumeroNF;
  DataSetNF.Open;

  DataSetItensNF.Close;
  DataSetItensNF.SelectSQL.Clear;
  DataSetItensNF.SelectSQL.Add('SELECT * FROM ITENS001 WHERE (NUMERONF=:XNUMERONF)');
  DataSetItensNF.ParamByName('XNUMERONF').AsString := AcNumeroNF;
  DataSetItensNF.Open;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarTotalDoc(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryTotalDoc.Close;
  qryTotalDoc.SQL.Clear;
  qryTotalDoc.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryTotalDoc.SQL.Add('SELECT');
  qryTotalDoc.SQL.Add('    A.PEDIDO');
  qryTotalDoc.SQL.Add('    , A.CAIXA');
  qryTotalDoc.SQL.Add('    , SUM(A.TOTAL) AS TOTALCUPOM');
  qryTotalDoc.SQL.Add('FROM ALTERACA A');
  qryTotalDoc.SQL.Add('INNER JOIN DOCUMENTOS');
  qryTotalDoc.SQL.Add('    ON (DOCUMENTOS.PEDIDO=A.PEDIDO)');
  qryTotalDoc.SQL.Add('    AND (DOCUMENTOS.CAIXA=A.CAIXA)');
  qryTotalDoc.SQL.Add('    AND (DOCUMENTOS.DATA=A.DATA)');
  qryTotalDoc.SQL.Add('WHERE');
  qryTotalDoc.SQL.Add('    ((A.TIPO=''BALCAO'') OR (A.TIPO = ''LOKED''))');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
  qryTotalDoc.SQL.Add('    AND (COALESCE(A.ITEM,'''') <> '''')');
  qryTotalDoc.SQL.Add('    AND ((SELECT COUNT(DESCACRES.PEDIDO) FROM ALTERACA DESCACRES');
  qryTotalDoc.SQL.Add('          WHERE');
  qryTotalDoc.SQL.Add('          (DESCACRES.PEDIDO=A.PEDIDO)');
  qryTotalDoc.SQL.Add('          AND (DESCACRES.CAIXA=A.CAIXA)');
  qryTotalDoc.SQL.Add('          AND ((DESCACRES.TIPO=''BALCAO'') OR (DESCACRES.TIPO = ''LOKED''))');
  qryTotalDoc.SQL.Add('          AND (DESCACRES.DESCRICAO <> ''<CANCELADO>'')');
  qryTotalDoc.SQL.Add('          AND ((DESCACRES.DESCRICAO = ''Desconto'')');
  qryTotalDoc.SQL.Add('                OR (DESCACRES.DESCRICAO = ''Acréscimo''))');
  qryTotalDoc.SQL.Add('          AND (COALESCE(DESCACRES.ITEM,'''') = '''')');
  qryTotalDoc.SQL.Add('          ) > 0)');
  qryTotalDoc.SQL.Add('GROUP BY 1,2');
  qryTotalDoc.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryTotalDoc.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryTotalDoc.Open;
  qryTotalDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarDescontoItemPorCFOP(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryDescontoItemCFOP.Close;
  qryDescontoItemCFOP.SQL.Clear;
  qryDescontoItemCFOP.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryDescontoItemCFOP.SQL.Add('SELECT');
  qryDescontoItemCFOP.SQL.Add('    CASE WHEN COALESCE(ITEM.CFOP,'''') = '''' THEN E.CFOP ELSE ITEM.CFOP END AS CFOP');
  qryDescontoItemCFOP.SQL.Add('    , SUM(DESCONTO.TOTAL) AS DESCONTO');
  qryDescontoItemCFOP.SQL.Add('FROM ALTERACA DESCONTO');
  qryDescontoItemCFOP.SQL.Add('INNER JOIN DOCUMENTOS');
  qryDescontoItemCFOP.SQL.Add('    ON  (DESCONTO.PEDIDO=DOCUMENTOS.PEDIDO)');
  qryDescontoItemCFOP.SQL.Add('    AND (DESCONTO.CAIXA=DOCUMENTOS.CAIXA)');
  qryDescontoItemCFOP.SQL.Add('    AND (DESCONTO.DATA=DOCUMENTOS.DATA)');
  qryDescontoItemCFOP.SQL.Add('INNER JOIN ALTERACA ITEM');
  qryDescontoItemCFOP.SQL.Add('    ON (ITEM.PEDIDO=DESCONTO.PEDIDO)');
  qryDescontoItemCFOP.SQL.Add('    AND (ITEM.CAIXA=DESCONTO.CAIXA)');
  qryDescontoItemCFOP.SQL.Add('    AND (ITEM.DATA=DESCONTO.DATA)');
  qryDescontoItemCFOP.SQL.Add('    AND (ITEM.ITEM=DESCONTO.ITEM)');
  qryDescontoItemCFOP.SQL.Add('    AND (ITEM.DESCRICAO<>DESCONTO.DESCRICAO)');
  qryDescontoItemCFOP.SQL.Add('LEFT JOIN ESTOQUE E');
  qryDescontoItemCFOP.SQL.Add('    ON (E.CODIGO = ITEM.CODIGO)');
  qryDescontoItemCFOP.SQL.Add('    AND (COALESCE(E.DESCRICAO,'''')<>'''')');
  qryDescontoItemCFOP.SQL.Add('WHERE');
  qryDescontoItemCFOP.SQL.Add(' ((DESCONTO.TIPO = ''BALCAO'') or (DESCONTO.TIPO = ''LOKED''))');
  qryDescontoItemCFOP.SQL.Add(' AND (DESCONTO.DESCRICAO = ''Desconto'')');
  qryDescontoItemCFOP.SQL.Add(' AND (COALESCE(DESCONTO.ITEM, '''') <> '''')');
  qryDescontoItemCFOP.SQL.Add('GROUP BY 1');
  qryDescontoItemCFOP.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryDescontoItemCFOP.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryDescontoItemCFOP.Open;
  qryDescontoItemCFOP.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarDescontoItemPorCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryDescontoItemCSOSN.Close;
  qryDescontoItemCSOSN.SQL.Clear;
  qryDescontoItemCSOSN.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryDescontoItemCSOSN.SQL.Add('SELECT');
  if (qryEmitente.FieldByName('CRT').AsInteger in [2,3]) then
    qryDescontoItemCSOSN.SQL.Add('    COALESCE(COALESCE(DESCONTO.CST_ICMS, E.CST_NFCE), E.CST) AS CSTCSOSN')
  else
    qryDescontoItemCSOSN.SQL.Add('    CASE WHEN COALESCE(ITEM.ALIQUICM, '''') = ''ISS'' THEN ''ISS'' ELSE COALESCE(COALESCE(ITEM.CSOSN, E.CSOSN_NFCE), E.CSOSN) END AS CSTCSOSN');
  qryDescontoItemCSOSN.SQL.Add('    , SUM(DESCONTO.TOTAL) AS DESCONTO');
  qryDescontoItemCSOSN.SQL.Add('FROM ALTERACA DESCONTO');
  qryDescontoItemCSOSN.SQL.Add('INNER JOIN DOCUMENTOS');
  qryDescontoItemCSOSN.SQL.Add('    ON  (DESCONTO.PEDIDO=DOCUMENTOS.PEDIDO)');
  qryDescontoItemCSOSN.SQL.Add(' AND (DESCONTO.CAIXA=DOCUMENTOS.CAIXA)');
  qryDescontoItemCSOSN.SQL.Add(' AND (DESCONTO.DATA=DOCUMENTOS.DATA)');
  qryDescontoItemCSOSN.SQL.Add('INNER JOIN ALTERACA ITEM');
  qryDescontoItemCSOSN.SQL.Add('    ON (ITEM.PEDIDO=DESCONTO.PEDIDO)');
  qryDescontoItemCSOSN.SQL.Add('    AND (ITEM.CAIXA=DESCONTO.CAIXA)');
  qryDescontoItemCSOSN.SQL.Add('    AND (ITEM.DATA=DESCONTO.DATA)');
  qryDescontoItemCSOSN.SQL.Add('    AND (ITEM.ITEM=DESCONTO.ITEM)');
  qryDescontoItemCSOSN.SQL.Add('    AND (ITEM.DESCRICAO<>DESCONTO.DESCRICAO)');
  qryDescontoItemCSOSN.SQL.Add('LEFT JOIN ESTOQUE E');
  qryDescontoItemCSOSN.SQL.Add('    ON (E.CODIGO = ITEM.CODIGO)');
  qryDescontoItemCSOSN.SQL.Add('    AND (COALESCE(E.DESCRICAO,'''')<>'''')');
  qryDescontoItemCSOSN.SQL.Add('WHERE');
  qryDescontoItemCSOSN.SQL.Add(' ((DESCONTO.TIPO = ''BALCAO'') or (DESCONTO.TIPO = ''LOKED''))');
  qryDescontoItemCSOSN.SQL.Add(' AND (DESCONTO.DESCRICAO = ''Desconto'')');
  qryDescontoItemCSOSN.SQL.Add(' AND (COALESCE(DESCONTO.ITEM, '''') <> '''')');
  qryDescontoItemCSOSN.SQL.Add('GROUP BY 1');
  qryDescontoItemCSOSN.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryDescontoItemCSOSN.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryDescontoItemCSOSN.Open;
  qryDescontoItemCSOSN.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarDescontoDoc(AcPedido, AcCaixa: String);
begin
  qryDescontoDoc.Close;
  qryDescontoDoc.SQL.Clear;
  qryDescontoDoc.SQL.Add('SELECT');
  qryDescontoDoc.SQL.Add('    A.PEDIDO');
  qryDescontoDoc.SQL.Add('    , A.CAIXA');
  qryDescontoDoc.SQL.Add('    , SUM(A.TOTAL) AS DESCONTOCUPOM');
  qryDescontoDoc.SQL.Add('FROM ALTERACA A');
  qryDescontoDoc.SQL.Add('WHERE');
  qryDescontoDoc.SQL.Add('    (A.PEDIDO=:XPEDIDO)');
  qryDescontoDoc.SQL.Add('    AND (A.CAIXA=:XCAIXA)');
  qryDescontoDoc.SQL.Add('    AND ((A.TIPO = ''BALCAO'') or (A.TIPO = ''LOKED''))');
  qryDescontoDoc.SQL.Add('    AND (A.DESCRICAO = ''Desconto'')');
  qryDescontoDoc.SQL.Add('    AND (COALESCE(A.ITEM, '''') = '''')');
  qryDescontoDoc.SQL.Add('GROUP BY A.PEDIDO, A.CAIXA');
  qryDescontoDoc.SQL.Add('ORDER BY PEDIDO');
  qryDescontoDoc.ParamByName('XPEDIDO').AsString := AcPedido;
  qryDescontoDoc.ParamByName('XCAIXA').AsString := AcCaixa;
  qryDescontoDoc.Open;
  qryDescontoDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarTotalItens(AcPedido, AcCaixa: String);
begin
  qryTotalItens.Close;
  qryTotalItens.SQL.Clear;
  qryTotalItens.SQL.Add('SELECT');
  qryTotalItens.SQL.Add('    SUM(CAST(ALTERACA.TOTAL AS NUMERIC(18,2))) AS TOTAL');
  qryTotalItens.SQL.Add('FROM ALTERACA');
  qryTotalItens.SQL.Add('WHERE');
  qryTotalItens.SQL.Add('    (ALTERACA.PEDIDO=:XPEDIDO)');
  qryTotalItens.SQL.Add('    AND (ALTERACA.CAIXA=:XCAIXA)');
  qryTotalItens.SQL.Add('    AND (ALTERACA.DESCRICAO <> ''<CANCELADO>'')');
  qryTotalItens.SQL.Add('    AND (ALTERACA.TIPO <> ''KOLNAC'')');
  qryTotalItens.SQL.Add('    AND (COALESCE(ALTERACA.ITEM,''XX'') <> ''XX'')');
  qryTotalItens.ParamByName('XPEDIDO').AsString := AcPedido;
  qryTotalItens.ParamByName('XCAIXA').AsString := AcCaixa;
  qryTotalItens.Open;
  qryTotalItens.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaPorCFOPCSTCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryDadosCST.Close;
  qryDadosCST.SQL.Clear;
  qryDadosCST.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryDadosCST.SQL.Add('SELECT');
  qryDadosCST.SQL.Add('    CASE WHEN COALESCE(A.CFOP,'''') = '''' THEN E.CFOP ELSE A.CFOP END AS CFOP');
  if (qryEmitente.FieldByName('CRT').AsInteger in [2,3]) then
    qryDadosCST.SQL.Add('    , COALESCE(COALESCE(A.CST_ICMS, E.CST_NFCE), E.CST) AS CSTCSOSN')
  else
    qryDadosCST.SQL.Add('    , CASE WHEN COALESCE(A.ALIQUICM, '''') = ''ISS'' THEN ''ISS'' ELSE COALESCE(COALESCE(A.CSOSN, E.CSOSN_NFCE), E.CSOSN) END AS CSTCSOSN');
  qryDadosCST.SQL.Add('    , SUM(COALESCE(A.TOTAL, 0)) AS VALOR');
  qryDadosCST.SQL.Add('FROM ALTERACA A');
  qryDadosCST.SQL.Add('INNER JOIN DOCUMENTOS');
  qryDadosCST.SQL.Add('    ON (DOCUMENTOS.PEDIDO=A.PEDIDO)');
  qryDadosCST.SQL.Add('    AND (DOCUMENTOS.CAIXA=A.CAIXA)');
  qryDadosCST.SQL.Add('    AND (DOCUMENTOS.DATA=A.DATA)');
  qryDadosCST.SQL.Add('LEFT JOIN ESTOQUE E');
  qryDadosCST.SQL.Add('    ON (E.CODIGO = A.CODIGO)');
  qryDadosCST.SQL.Add('    AND (COALESCE(E.DESCRICAO,'''')<>'''')');
  qryDadosCST.SQL.Add('WHERE');
  qryDadosCST.SQL.Add('    ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''LOKED''))');
  qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
  qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
  qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
  qryDadosCST.SQL.Add('    AND (COALESCE(A.ITEM, '''') <> '''')');
  qryDadosCST.SQL.Add('GROUP BY 1,2');
  qryDadosCST.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryDadosCST.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryDadosCST.Open;
  qryDadosCST.First;
end;

procedure TdmRelTotalizadorVendasGeral.setPeriodo(AdDataIni, AdDataFim: TDateTime);
begin
  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDescontosItem(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  CarregarDescontoItemPorCFOP(AenDocImp);
  CarregarDescontoItemPorCSOSN(AenDocImp);
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosDescAcrescDocumentos(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  CarregaDadosDocumentosComDescAcresc(AenDocImp);
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosDocumentosComDescAcresc(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  // RETORNA OS DOCUMENTOS QUE POSSUEM DESCONTO E ACRESCIMO
  qryDocumentosDescAcresc.Close;
  qryDocumentosDescAcresc.SQL.Clear;
  qryDocumentosDescAcresc.SQL.Add(RetornarTabelaTemporariaDocumentos(AenDocImp));
  qryDocumentosDescAcresc.SQL.Add('SELECT');
  qryDocumentosDescAcresc.SQL.Add('    A.PEDIDO');
  qryDocumentosDescAcresc.SQL.Add('    , A.CAIXA');
  qryDocumentosDescAcresc.SQL.Add('    , SUM(A.TOTAL) AS TOTALCUPOM');
  qryDocumentosDescAcresc.SQL.Add('FROM ALTERACA A');
  qryDocumentosDescAcresc.SQL.Add('INNER JOIN DOCUMENTOS');
  qryDocumentosDescAcresc.SQL.Add('    ON (DOCUMENTOS.PEDIDO=A.PEDIDO)');
  qryDocumentosDescAcresc.SQL.Add('    AND (DOCUMENTOS.CAIXA=A.CAIXA)');
  qryDocumentosDescAcresc.SQL.Add('    AND (DOCUMENTOS.DATA=A.DATA)');
  qryDocumentosDescAcresc.SQL.Add('WHERE');
  qryDocumentosDescAcresc.SQL.Add('    ((A.TIPO=''BALCAO'') OR (A.TIPO = ''LOKED''))');
  qryDocumentosDescAcresc.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
  qryDocumentosDescAcresc.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
  qryDocumentosDescAcresc.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
  qryDocumentosDescAcresc.SQL.Add('    AND (COALESCE(A.ITEM,'''') <> '''')');
  qryDocumentosDescAcresc.SQL.Add('    AND ((SELECT COUNT(DESCACRES.PEDIDO) FROM ALTERACA DESCACRES');
  qryDocumentosDescAcresc.SQL.Add('          WHERE');
  qryDocumentosDescAcresc.SQL.Add('          (DESCACRES.PEDIDO=A.PEDIDO)');
  qryDocumentosDescAcresc.SQL.Add('          AND (DESCACRES.CAIXA=A.CAIXA)');
  qryDocumentosDescAcresc.SQL.Add('          AND ((DESCACRES.TIPO=''BALCAO'') OR (DESCACRES.TIPO = ''LOKED''))');
  qryDocumentosDescAcresc.SQL.Add('          AND (DESCACRES.DESCRICAO <> ''<CANCELADO>'')');
  qryDocumentosDescAcresc.SQL.Add('          AND ((DESCACRES.DESCRICAO = ''Desconto'')');
  qryDocumentosDescAcresc.SQL.Add('                OR (DESCACRES.DESCRICAO = ''Acréscimo''))');
  qryDocumentosDescAcresc.SQL.Add('          AND (COALESCE(DESCACRES.item,'''') = '''')');
  qryDocumentosDescAcresc.SQL.Add('          ) > 0)');
  qryDocumentosDescAcresc.SQL.Add('GROUP BY 1,2');
  qryDocumentosDescAcresc.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryDocumentosDescAcresc.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryDocumentosDescAcresc.Open;
  qryDocumentosDescAcresc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaItensDocumento(AcPedido, AcCaixa: String);
begin
  qryItensDocumento.Close;
  qryItensDocumento.SQL.Clear;
  qryItensDocumento.SQL.Add('SELECT');
  qryItensDocumento.SQL.Add('    A.PEDIDO');
  qryItensDocumento.SQL.Add('    , A.CAIXA');
  qryItensDocumento.SQL.Add('    , A.ITEM');
  qryItensDocumento.SQL.Add('    , CASE WHEN COALESCE(A.CFOP,'''') = '''' THEN E.CFOP ELSE A.CFOP END AS CFOP');
  if (qryEmitente.FieldByName('CRT').AsInteger in [2,3]) then
    qryItensDocumento.SQL.Add('    , COALESCE(COALESCE(A.CST_ICMS, E.CST_NFCE), E.CST) AS CSTCSOSN')
  else
    qryItensDocumento.SQL.Add('    , CASE WHEN COALESCE(A.ALIQUICM, '''') = ''ISS'' THEN ''ISS'' ELSE COALESCE(COALESCE(A.CSOSN, E.CSOSN_NFCE), E.CSOSN) END AS CSTCSOSN');

  qryItensDocumento.SQL.Add('    , COALESCE(A.TOTAL,0) AS VALOR');
  qryItensDocumento.SQL.Add('FROM ALTERACA A');
  qryItensDocumento.SQL.Add('LEFT JOIN ESTOQUE E');
  qryItensDocumento.SQL.Add('    ON (E.CODIGO = A.CODIGO)');
  qryItensDocumento.SQL.Add('    AND (COALESCE(E.DESCRICAO,'''')<>'''')');
  qryItensDocumento.SQL.Add('WHERE');
  qryItensDocumento.SQL.Add('    (A.PEDIDO=:XPEDIDO)');
  qryItensDocumento.SQL.Add('    AND (A.CAIXA=:XCAIXA)');
  qryItensDocumento.SQL.Add('    AND ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''LOKED''))');
  qryItensDocumento.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
  qryItensDocumento.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
  qryItensDocumento.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
  qryItensDocumento.SQL.Add('    AND (COALESCE(A.ITEM, '''') <> '''')');
  qryItensDocumento.SQL.Add('ORDER BY A.REGISTRO');
  qryItensDocumento.ParamByName('XPEDIDO').AsString := AcPedido;
  qryItensDocumento.ParamByName('XCAIXA').AsString := AcCaixa;
  qryItensDocumento.Open;
  qryItensDocumento.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDescontoItem(AcPedido, AcCaixa, AcItem: String);
begin
  qryDescontoItem.Close;
  qryDescontoItem.SQL.Clear;
  qryDescontoItem.SQL.Add('SELECT');
  qryDescontoItem.SQL.Add('  A.PEDIDO, A.CODIGO, A.ALIQUICM, A.ITEM, A.TOTAL as DESCONTO');
  qryDescontoItem.SQL.Add('from ALTERACA A');
  qryDescontoItem.SQL.Add('where');
  qryDescontoItem.SQL.Add(' A.CAIXA = :XCAIXA');
  qryDescontoItem.SQL.Add(' and A.PEDIDO = :XPEDIDO');
  qryDescontoItem.SQL.Add(' and A.ITEM = :XITEM');
  qryDescontoItem.SQL.Add(' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'')');
  qryDescontoItem.SQL.Add(' and A.DESCRICAO = ''Desconto''');
  qryDescontoItem.SQL.Add(' and coalesce(A.ITEM, '''') <> ''''');
  qryDescontoItem.SQL.Add('order by A.ITEM');
  qryDescontoItem.ParamByName('XPEDIDO').AsString := AcPedido;
  qryDescontoItem.ParamByName('XCAIXA').AsString := AcCaixa;
  qryDescontoItem.ParamByName('XITEM').AsString := AcItem;
  qryDescontoItem.Open;
  qryDescontoItem.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarAcrescimoDoc(AcPedido, AcCaixa: String);
begin
  qryAcrescimoDoc.Close;
  qryAcrescimoDoc.SQL.Clear;
  qryAcrescimoDoc.SQL.Add('SELECT');
  qryAcrescimoDoc.SQL.Add('    A.PEDIDO');
  qryAcrescimoDoc.SQL.Add('    , A.CAIXA');
  qryAcrescimoDoc.SQL.Add('    , SUM(A.TOTAL) AS ACRESCIMOCUPOM');
  qryAcrescimoDoc.SQL.Add('FROM ALTERACA A');
  qryAcrescimoDoc.SQL.Add('WHERE');
  qryAcrescimoDoc.SQL.Add('    (A.PEDIDO=:XPEDIDO)');
  qryAcrescimoDoc.SQL.Add('    AND (A.CAIXA=:XCAIXA)');
  qryAcrescimoDoc.SQL.Add('    AND ((A.TIPO = ''BALCAO'') or (A.TIPO = ''LOKED''))');
  qryAcrescimoDoc.SQL.Add('    AND (A.DESCRICAO = ''Acréscimo'')');
  qryAcrescimoDoc.SQL.Add('    AND (COALESCE(A.ITEM, '''') = '''')');
  qryAcrescimoDoc.SQL.Add('GROUP BY A.PEDIDO, A.CAIXA');
  qryAcrescimoDoc.SQL.Add('ORDER BY PEDIDO');
  qryAcrescimoDoc.ParamByName('XPEDIDO').AsString := AcPedido;
  qryAcrescimoDoc.ParamByName('XCAIXA').AsString := AcCaixa;
  qryAcrescimoDoc.Open;
  qryAcrescimoDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaNFs;
begin
  qryNFs.Close;
  qryNFs.SQL.Clear;
  qryNFs.SQL.Add(RetornarTabelaTemporariaDocumentos(tditgvNFe));
  qryNFs.SQL.Add('SELECT');
  qryNFs.SQL.Add('    DOCUMENTOS.TIPO');
  qryNFs.SQL.Add('    , DOCUMENTOS.PEDIDO');
  qryNFs.SQL.Add('    , DOCUMENTOS.DATA');
  qryNFs.SQL.Add('FROM DOCUMENTOS');
  qryNFs.ParamByName('XDATAINI').AsDate := FdDataIni;
  qryNFs.ParamByName('XDATAFIM').AsDate := FdDataFim;
  qryNFs.Open;
  qryNFs.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosEmitente;
begin
  qryEmitente.Close;
  qryEmitente.SQL.Clear;
  qryEmitente.SQL.Add('SELECT * FROM EMITENTE');
  qryEmitente.Open;
end;

end.
