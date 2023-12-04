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
    qryDocumentos: TIBQuery;
    qryFormaPgto: TIBQuery;
    qryDescontoItem: TIBQuery;
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
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure CarregarDescontoDoc;
    procedure CarregarAcrescimoDoc;
    procedure CarregarTotalItens;
    procedure CarregarTotalDoc;
    procedure CarregarDescontoItem;
  public
    procedure setDataBase(AoDataBase: TIBDatabase);
    procedure CarregaDadosDocumentos(AdDataIni, AdDataFim: TDateTime);
    procedure CarregaDadosFormaPgto(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaPorCFOPCSTCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaDescontos(AenDocImp: tDocsImprimirTotGeralVenda);
    procedure CarregaDadosNF(AcNumeroNF: String);
  end;

var
  dmRelTotalizadorVendasGeral: TdmRelTotalizadorVendasGeral;

implementation

{$R *.dfm}

procedure TdmRelTotalizadorVendasGeral.CarregaDadosDocumentos(AdDataIni, AdDataFim: TDateTime);
begin
  // Carrega as NFCe emitidas no periodo
  qryDocumentos.Close;
  qryDocumentos.SQL.Clear;
  qryDocumentos.SQL.Add('SELECT DISTINCT');
  qryDocumentos.SQL.Add('    ''NFC-e'' AS TIPO');
  qryDocumentos.SQL.Add('    , NFCE.DATA');
  qryDocumentos.SQL.Add('    , NFCE.CAIXA');
  qryDocumentos.SQL.Add('    , NFCE.NUMERONF AS PEDIDO');
  qryDocumentos.SQL.Add('    , NFCE.MODELO');
  qryDocumentos.SQL.Add('FROM NFCE');
  qryDocumentos.SQL.Add('JOIN ALTERACA A');
  qryDocumentos.SQL.Add('    ON (A.PEDIDO = NFCE.NUMERONF) AND (A.CAIXA = NFCE.CAIXA)');
  qryDocumentos.SQL.Add('WHERE');
  qryDocumentos.SQL.Add('    ((NFCE.STATUS CONTAINING ''Autorizad'')');
  qryDocumentos.SQL.Add('      OR (NFCE.STATUS CONTAINING ''NFC-e emitida em modo de contingência'')');
  qryDocumentos.SQL.Add('    )');
  qryDocumentos.SQL.Add('    AND (NFCE.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
  qryDocumentos.SQL.Add('    AND (NFCE.MODELO = ''65'')');
  qryDocumentos.SQL.Add('UNION ALL');
  qryDocumentos.SQL.Add('SELECT DISTINCT');
  qryDocumentos.SQL.Add('    ''SAT'' AS TIPO');
  qryDocumentos.SQL.Add('    , NFCE.DATA');
  qryDocumentos.SQL.Add('    , NFCE.CAIXA');
  qryDocumentos.SQL.Add('    , NFCE.NUMERONF AS PEDIDO');
  qryDocumentos.SQL.Add('    , NFCE.MODELO');
  qryDocumentos.SQL.Add('FROM NFCE');
  qryDocumentos.SQL.Add('JOIN ALTERACA A');
  qryDocumentos.SQL.Add('    ON (A.PEDIDO = NFCE.NUMERONF) AND (A.CAIXA = NFCE.CAIXA)');
  qryDocumentos.SQL.Add('WHERE');
  qryDocumentos.SQL.Add('    ((NFCE.STATUS CONTAINING ''Autorizad'')');
  qryDocumentos.SQL.Add('      OR (NFCE.STATUS CONTAINING ''Emitido com sucesso'')');
  qryDocumentos.SQL.Add('    )');
  qryDocumentos.SQL.Add('    AND (NFCE.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
  qryDocumentos.SQL.Add('    AND (NFCE.MODELO = ''59'')');
  qryDocumentos.SQL.Add('UNION ALL');
  qryDocumentos.SQL.Add('SELECT DISTINCT');
  qryDocumentos.SQL.Add('    ''Cupom'' AS TIPO');
  qryDocumentos.SQL.Add('    , A.DATA');
  qryDocumentos.SQL.Add('    , A.CAIXA');
  qryDocumentos.SQL.Add('    , A.PEDIDO AS PEDIDO');
  qryDocumentos.SQL.Add('    , CAST(''2D'' AS VARCHAR(2)) AS MODELO');
  qryDocumentos.SQL.Add('FROM ALTERACA A');
  qryDocumentos.SQL.Add('WHERE ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''VENDA'') OR (A.TIPO = ''LOKED''))');
  qryDocumentos.SQL.Add('    AND (A.DATA BETWEEN :XDATAINI AND :XDATAFIM)');
  qryDocumentos.SQL.Add('    AND ((SELECT COUNT(N.NUMERONF) FROM NFCE N WHERE (N.CAIXA=A.CAIXA) AND (N.NUMERONF=A.PEDIDO)) = 0)'); // Não trazer dados de NFCe
  qryDocumentos.SQL.Add('UNION ALL');
  qryDocumentos.SQL.Add('SELECT DISTINCT');
  qryDocumentos.SQL.Add('    ''NF-e'' AS TIPO');
  qryDocumentos.SQL.Add('    , V.EMISSAO AS DATA');
  qryDocumentos.SQL.Add('    , CAST('''' AS VARCHAR(3)) AS CAIXA');
  qryDocumentos.SQL.Add('    , V.NUMERONF AS PEDIDO');
  qryDocumentos.SQL.Add('    , V.MODELO AS MODELO');
  qryDocumentos.SQL.Add('FROM VENDAS V');
  qryDocumentos.SQL.Add('WHERE');
  qryDocumentos.SQL.Add('    (V.EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
  qryDocumentos.SQL.Add('    AND (V.EMITIDA=''S'')');
  qryDocumentos.SQL.Add('    AND (((V.FINNFE = ''1'') and (V.MODELO = ''55'')) or ((coalesce(V.FINNFE, '''') = '''') and (V.MODELO <> ''55'')))');
  qryDocumentos.SQL.Add('ORDER BY 1,2,4');
  qryDocumentos.ParamByName('XDATAINI').AsDate := AdDataIni;
  qryDocumentos.ParamByName('XDATAFIM').AsDate := AdDataFim;
  qryDocumentos.Open;
  qryDocumentos.First;
end;

procedure TdmRelTotalizadorVendasGeral.DataModuleCreate(Sender: TObject);
begin
  if cdsTotalPorFormaPgto.Active then
    cdsTotalPorFormaPgto.Close;
  cdsTotalPorFormaPgto.CreateDataSet;

  cdsTotalPorFormaPgtoTIPO.Visible := False;

  if cdsTotalCFOP.Active then
    cdsTotalCFOP.Close;
  cdsTotalCFOP.CreateDataSet;

  if cdsTotalCSOSN.Active then
    cdsTotalCSOSN.Close;
  cdsTotalCSOSN.CreateDataSet;
end;

procedure TdmRelTotalizadorVendasGeral.DataModuleDestroy(Sender: TObject);
begin
  cdsTotalPorFormaPgto.Close;
  cdsTotalCFOP.Close;
  cdsTotalCSOSN.Close;
end;

procedure TdmRelTotalizadorVendasGeral.setDataBase(AoDataBase: TIBDatabase);
begin
  qryDocumentos.Database   := AoDataBase;
  qryFormaPgto.Database    := AoDataBase;
  qryDescontoItem.Database := AoDataBase;
  qryDescontoDoc.Database  := AoDataBase;
  qryAcrescimoDoc.Database := AoDataBase;
  qryDadosCST.Database     := AoDataBase;
  qryTotalItens.Database   := AoDataBase;
  qryTotalDoc.Database     := AoDataBase;

  DataSetNF.Database       := AoDataBase;
  DataSetItensNF.Database  := AoDataBase;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosFormaPgto(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryFormaPgto.Close;
  qryFormaPgto.SQL.Clear;
  qryFormaPgto.SQL.Add('SELECT');
  case AenDocImp of
    tditgvNFCe, tditgvSAT, tditgvCupom:
    begin
      qryFormaPgto.SQL.Add('    TRIM(REPLACE(REPLACE(SUBSTRING(P.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', '''')) AS FORMA');
      qryFormaPgto.SQL.Add('    , SUM(COALESCE(CASE WHEN SUBSTRING(P.FORMA FROM 1 FOR 2) = ''13'' THEN (P.VALOR * -1) ELSE P.VALOR END,0)) AS TOTAL');
      qryFormaPgto.SQL.Add('FROM PAGAMENT P');
      qryFormaPgto.SQL.Add('WHERE');
      qryFormaPgto.SQL.Add('    (P.DATA=:XDATA)');
      qryFormaPgto.SQL.Add('    AND (P.CAIXA = ' + QuotedStr(qryDocumentos.FieldByName('CAIXA').AsString) + ')');
      qryFormaPgto.SQL.Add('    AND (P.PEDIDO = ' + QuotedStr(qryDocumentos.FieldByName('PEDIDO').AsString) + ')');
      qryFormaPgto.SQL.Add('    AND (P.FORMA <> ''00 Total'')');
      qryFormaPgto.SQL.Add('    AND (COALESCE(P.CLIFOR, ''X'') <> ''Sangria'')');
      qryFormaPgto.SQL.Add('    AND (COALESCE(P.CLIFOR, ''X'') <> ''Suprimento'')');
      qryFormaPgto.SQL.Add('    AND ((COALESCE(P.CAIXA, '''') = '''')');
      qryFormaPgto.SQL.Add('         OR (P.PEDIDO IN (SELECT A.PEDIDO FROM ALTERACA A WHERE (A.PEDIDO = P.PEDIDO) AND (A.CAIXA = P.CAIXA) AND (A.DATA = P.DATA) AND ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''LOKED'') OR (TIPO = ''VENDA''))))');
      qryFormaPgto.SQL.Add('        )');
      qryFormaPgto.SQL.Add('GROUP BY TRIM(REPLACE(REPLACE(SUBSTRING(P.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', ''''))');
      qryFormaPgto.SQL.Add('ORDER BY SUBSTRING(1 FROM 4 FOR 20)');
    end;
    else
    begin
      qryFormaPgto.SQL.Add('    CASE WHEN COALESCE(RECEBER.FORMADEPAGAMENTO,'''') = '''' THEN ''Não informado'' ELSE RECEBER.FORMADEPAGAMENTO END AS FORMA');
      qryFormaPgto.SQL.Add('    , SUM(CASE WHEN (COALESCE(RECEBER.NUMERONF,'''') <> '''') THEN COALESCE(RECEBER.VALOR_DUPL, 0) ELSE VENDAS.TOTAL END) AS TOTAL');
      qryFormaPgto.SQL.Add('FROM VENDAS');
      qryFormaPgto.SQL.Add('LEFT JOIN RECEBER');
      qryFormaPgto.SQL.Add('    ON (RECEBER.NUMERONF=VENDAS.NUMERONF)');
      qryFormaPgto.SQL.Add('WHERE');
      qryFormaPgto.SQL.Add('(VENDAS.NUMERONF=' + QuotedStr(qryDocumentos.FieldByName('PEDIDO').AsString) + ')');
      qryFormaPgto.SQL.Add('AND (VENDAS.EMISSAO=:XDATA)');
      qryFormaPgto.SQL.Add('GROUP BY VENDAS.NUMERONF, FORMA');
      qryFormaPgto.SQL.Add('ORDER BY FORMA');
    end;
  end;
  qryFormaPgto.ParamByName('XDATA').AsDate := qryDocumentos.FieldByName('DATA').AsDateTime;
  qryFormaPgto.Open;
  qryFormaPgto.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDescontos(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  if AenDocImp in [tditgvNFCe, tditgvSAT, tditgvCupom] then
  begin
    CarregarDescontoItem;
    CarregarAcrescimoDoc;
    CarregarTotalDoc;
    CarregarTotalItens;
    CarregarDescontoDoc;
  end;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaDadosNF(AcNumeroNF: String);
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

procedure TdmRelTotalizadorVendasGeral.CarregarTotalDoc;
begin
  qryTotalDoc.Close;
  qryTotalDoc.SQL.Clear;
  qryTotalDoc.SQL.Add('SELECT');
  qryTotalDoc.SQL.Add('    A.PEDIDO');
  qryTotalDoc.SQL.Add('    , SUM(A.TOTAL) AS TOTALCUPOM');
  qryTotalDoc.SQL.Add('FROM ALTERACA A');
  qryTotalDoc.SQL.Add('WHERE');
  qryTotalDoc.SQL.Add('    (A.DATA=:XDATA)');
  qryTotalDoc.SQL.Add('    AND (A.CAIXA=:XCAIXA)');
  qryTotalDoc.SQL.Add('    AND (A.PEDIDO=:XPEDIDO)');
  qryTotalDoc.SQL.Add('    AND ((A.TIPO=''BALCAO'') OR (A.TIPO = ''LOKED''))');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
  qryTotalDoc.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
  qryTotalDoc.SQL.Add('GROUP BY A.PEDIDO');
  qryTotalDoc.SQL.Add('ORDER BY PEDIDO');
  qryTotalDoc.ParamByName('XDATA').AsDate   := qryDocumentos.FieldByName('DATA').AsDateTime;
  qryTotalDoc.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
  qryTotalDoc.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryTotalDoc.Open;
  qryTotalDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarTotalItens;
begin
  qryTotalItens.Close;
  qryTotalItens.SQL.Clear;
  qryTotalItens.SQL.Add('SELECT');
  qryTotalItens.SQL.Add('    SUM(CAST(TOTAL AS NUMERIC(18,2))) AS TOTAL');
  qryTotalItens.SQL.Add('FROM ALTERACA');
  qryTotalItens.SQL.Add('WHERE (PEDIDO=:XPEDIDO)');
  qryTotalItens.SQL.Add('    AND (CAIXA=:XCAIXA)');
  qryTotalItens.SQL.Add('    AND (DESCRICAO <> ''<CANCELADO>'')');
  qryTotalItens.SQL.Add('    AND (TIPO <> ''KOLNAC'')');
  qryTotalItens.SQL.Add('    AND (COALESCE(ITEM,''XX'') <> ''XX'')');
  qryTotalItens.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
  qryTotalItens.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryTotalItens.Open;
  qryTotalItens.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarDescontoItem;
begin
  qryDescontoItem.Close;
  qryDescontoItem.SQL.Clear;
  qryDescontoItem.SQL.Add('SELECT');
  qryDescontoItem.SQL.Add('    A.PEDIDO');
  qryDescontoItem.SQL.Add('    , A.CODIGO');
  qryDescontoItem.SQL.Add('    , A.ALIQUICM');
  qryDescontoItem.SQL.Add('    , A.ITEM');
  qryDescontoItem.SQL.Add('    , A.TOTAL AS DESCONTO');
  qryDescontoItem.SQL.Add('FROM ALTERACA A');
  qryDescontoItem.SQL.Add('WHERE (A.DATA=:XDATA)');
  qryDescontoItem.SQL.Add('AND (A.CAIXA=:XCAIXA)');
  qryDescontoItem.SQL.Add('AND (A.PEDIDO=:XPEDIDO)');
  qryDescontoItem.SQL.Add('AND ((A.TIPO = ''BALCAO'') or (A.TIPO = ''LOKED''))');
  qryDescontoItem.SQL.Add('AND (A.DESCRICAO = ''Desconto'')');
  qryDescontoItem.SQL.Add('AND (COALESCE(A.ITEM, '''') <> '''')');
  qryDescontoItem.SQL.Add('ORDER BY A.ITEM');
  qryDescontoItem.ParamByName('XDATA').AsDate     := qryDocumentos.FieldByName('DATA').AsDateTime;
  qryDescontoItem.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
  qryDescontoItem.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryDescontoItem.Open;
  qryDescontoItem.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarDescontoDoc;
begin
  qryDescontoDoc.Close;
  qryDescontoDoc.SQL.Clear;
  qryDescontoDoc.SQL.Add('SELECT');
  qryDescontoDoc.SQL.Add('    A.PEDIDO');
  qryDescontoDoc.SQL.Add('    , SUM(A.TOTAL) AS DESCONTOCUPOM');
  qryDescontoDoc.SQL.Add('FROM ALTERACA A');
  qryDescontoDoc.SQL.Add('WHERE (A.DATA=:XDATA)');
  qryDescontoDoc.SQL.Add('AND (A.CAIXA=:XCAIXA)');
  qryDescontoDoc.SQL.Add('AND (A.PEDIDO=:XPEDIDO)');
  qryDescontoDoc.SQL.Add('AND ((A.TIPO = ''BALCAO'') or (A.TIPO = ''LOKED''))');
  qryDescontoDoc.SQL.Add('AND (A.DESCRICAO = ''Desconto'')');
  qryDescontoDoc.SQL.Add('AND (COALESCE(A.ITEM, '''') = '''')');
  qryDescontoDoc.SQL.Add('GROUP BY A.PEDIDO');
  qryDescontoDoc.SQL.Add('ORDER BY PEDIDO');
  qryDescontoDoc.ParamByName('XDATA').AsDate     := qryDocumentos.FieldByName('DATA').AsDateTime;
  qryDescontoDoc.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
  qryDescontoDoc.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryDescontoDoc.Open;
  qryDescontoDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregarAcrescimoDoc;
begin
  qryAcrescimoDoc.Close;
  qryAcrescimoDoc.SQL.Clear;
  qryAcrescimoDoc.SQL.Add('SELECT');
  qryAcrescimoDoc.SQL.Add('    A.PEDIDO');
  qryAcrescimoDoc.SQL.Add('    , SUM(A.TOTAL) AS ACRESCIMOCUPOM');
  qryAcrescimoDoc.SQL.Add('FROM ALTERACA A');
  qryAcrescimoDoc.SQL.Add('WHERE (A.DATA=:XDATA)');
  qryAcrescimoDoc.SQL.Add('AND (A.CAIXA=:XCAIXA)');
  qryAcrescimoDoc.SQL.Add('AND (A.PEDIDO=:XPEDIDO)');
  qryAcrescimoDoc.SQL.Add('AND ((A.TIPO = ''BALCAO'') or (A.TIPO = ''LOKED''))');
  qryAcrescimoDoc.SQL.Add('AND (A.DESCRICAO = ''Acréscimo'')');
  qryAcrescimoDoc.SQL.Add('AND (COALESCE(A.ITEM, '''') = '''')');
  qryAcrescimoDoc.SQL.Add('GROUP BY A.PEDIDO');
  qryAcrescimoDoc.SQL.Add('ORDER BY PEDIDO');
  qryAcrescimoDoc.ParamByName('XDATA').AsDate     := qryDocumentos.FieldByName('DATA').AsDateTime;
  qryAcrescimoDoc.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
  qryAcrescimoDoc.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryAcrescimoDoc.Open;
  qryAcrescimoDoc.First;
end;

procedure TdmRelTotalizadorVendasGeral.CarregaPorCFOPCSTCSOSN(AenDocImp: tDocsImprimirTotGeralVenda);
begin
  qryDadosCST.Close;
  qryDadosCST.SQL.Clear;
  qryDadosCST.SQL.Add('SELECT');
  case AenDocImp of
    tditgvNFCe, tditgvSAT, tditgvCupom:
    begin
      qryDadosCST.SQL.Add('    A.PEDIDO');
      qryDadosCST.SQL.Add('    , A.ITEM');
      qryDadosCST.SQL.Add('    , A.CODIGO');
      qryDadosCST.SQL.Add('    , A.CST_ICMS');
      qryDadosCST.SQL.Add('    , COALESCE(A.ALIQUICM, '''') AS ALIQUICM');
      qryDadosCST.SQL.Add('    , A.CST_PIS_COFINS');
      qryDadosCST.SQL.Add('    , A.ALIQ_PIS');
      qryDadosCST.SQL.Add('    , A.ALIQ_COFINS');
      qryDadosCST.SQL.Add('    , CASE WHEN COALESCE(A.CFOP,'''') = '''' THEN E.CFOP ELSE A.CFOP END AS CFOP');
      qryDadosCST.SQL.Add('    , COALESCE(A.TOTAL, 0) AS VALOR');
      qryDadosCST.SQL.Add('    , A.CSOSN');
      qryDadosCST.SQL.Add('    , E.CSOSN AS ESTOQUE_CSOSN');
      qryDadosCST.SQL.Add('    , E.CFOP AS ESTOQUE_CFOP');
      qryDadosCST.SQL.Add('    , E.ALIQUOTA_NFCE');
      qryDadosCST.SQL.Add('    , E.CSOSN_NFCE');
      qryDadosCST.SQL.Add('    , E.CST_NFCE');
      qryDadosCST.SQL.Add('    , E.CEST');
      qryDadosCST.SQL.Add('FROM ALTERACA A');
      qryDadosCST.SQL.Add('LEFT JOIN ESTOQUE E');
      qryDadosCST.SQL.Add('    ON (E.CODIGO = A.CODIGO)');
      qryDadosCST.SQL.Add('WHERE');
      qryDadosCST.SQL.Add('    (A.DATA = :XDATA)');
      qryDadosCST.SQL.Add('    AND (A.CAIXA = :XCAIXA)');
      qryDadosCST.SQL.Add('    AND (A.PEDIDO = :XPEDIDO)');
      qryDadosCST.SQL.Add('    AND ((A.TIPO = ''BALCAO'') OR (A.TIPO = ''LOKED''))');
      qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''<CANCELADO>'')');
      qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''Desconto'')');
      qryDadosCST.SQL.Add('    AND (A.DESCRICAO <> ''Acréscimo'')');
      qryDadosCST.SQL.Add('    AND (COALESCE(A.ITEM, '''') <> '''')');
      qryDadosCST.SQL.Add('ORDER BY A.REGISTRO');
      qryDadosCST.ParamByName('XDATA').AsDate     := qryDocumentos.FieldByName('DATA').AsDateTime;
      qryDadosCST.ParamByName('XCAIXA').AsString  := qryDocumentos.FieldByName('CAIXA').AsString;
    end;
    tditgvNFe:
    begin
      qryDadosCST.SQL.Add('    ITENS001.NUMERONF AS PEDIDO');
      qryDadosCST.SQL.Add('    , ITENS001.DESCRICAO AS ITEM');
      qryDadosCST.SQL.Add('    , ITENS001.CODIGO');
      qryDadosCST.SQL.Add('    , ITENS001.CST_ICMS');
      qryDadosCST.SQL.Add('    , CASE WHEN (ITENS001.NUMERONF CONTAINING ''RPS'') THEN ''ISS'' ELSE '''' END AS ALIQUICM');
      qryDadosCST.SQL.Add('    , ITENS001.CST_PIS_COFINS');
      qryDadosCST.SQL.Add('    , ITENS001.ALIQ_PIS');
      qryDadosCST.SQL.Add('    , ITENS001.ALIQ_COFINS');
      qryDadosCST.SQL.Add('    , CASE WHEN COALESCE(ITENS001.CFOP,'''') = '''' THEN ESTOQUE.CFOP ELSE ITENS001.CFOP END AS CFOP');
      qryDadosCST.SQL.Add('    , ITENS001.TOTAL AS VALOR');
      qryDadosCST.SQL.Add('    , ITENS001.CSOSN');
      qryDadosCST.SQL.Add('    , ESTOQUE.CSOSN AS CSOSN_NFCE');
      qryDadosCST.SQL.Add('    , ESTOQUE.CSOSN AS ESTOQUE_CSOSN');            
      qryDadosCST.SQL.Add('FROM ITENS001');
      qryDadosCST.SQL.Add('LEFT JOIN ESTOQUE');
      qryDadosCST.SQL.Add('    ON (ESTOQUE.CODIGO = ITENS001.CODIGO)');
      qryDadosCST.SQL.Add('WHERE');
      qryDadosCST.SQL.Add('    (ITENS001.NUMERONF=:XPEDIDO)');
      qryDadosCST.SQL.Add('ORDER BY ITENS001.REGISTRO');
    end;
  end;
  qryDadosCST.ParamByName('XPEDIDO').AsString := qryDocumentos.FieldByName('PEDIDO').AsString;
  qryDadosCST.Open;
  qryDadosCST.First;
end;

end.
