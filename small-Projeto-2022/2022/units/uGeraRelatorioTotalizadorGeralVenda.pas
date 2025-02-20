unit uGeraRelatorioTotalizadorGeralVenda;

interface

uses
  uIGeraRelatorioTotalizadorGeralVenda, uSmallEnumerados, IBDataBase,
  IBQuery, SysUtils, uConectaBancoSmall, uIEstruturaTipoRelatorioPadrao,
  DB, DBClient, udmRelTotalizadorVendasGeral, Variants, uNotaFiscalEletronica,
  smallfunc, Windows;

type
  TGeraRelatorioTotalizadorGeralVenda = class(TInterfacedObject, IGeraRelatorioTotalizadorGeralVenda)
  private
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    FoTransaction: TIBTransaction;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FdmRelatorio: TdmRelTotalizadorVendasGeral;
    FenImprimirFiltroData: tDocsImprimirTotGeralVenda;
    procedure CarregarDados;
    procedure CarregaPorCFOPCSTCSOSN(AenDoc: TDocsImprimirTotGeralVenda);
    procedure CarregaPorFormaPagamento(AenDoc: TDocsImprimirTotGeralVenda);
    procedure GeraEstruturaFormaPgto(AenDoc: TDocsImprimirTotGeralVenda);
    function RetornarDescricaoDocumento(AenDoc: TDocsImprimirTotGeralVenda): String;
    function TipoDocStrToEnum(AcDoc: String): TDocsImprimirTotGeralVenda;
    constructor Create;
    procedure GeraEstruturaCFOPCSTCSOSN(AenDoc: TDocsImprimirTotGeralVenda);
    procedure MapearPorFormaPagamento;
    procedure MapearClientOficial;
    procedure AjustaCentavo(AenDoc: TDocsImprimirTotGeralVenda);
    function SomaClient(AcdsClient: TClientDataSet;
      AcCampo: String): Currency;
    procedure GeraEstruturaRelatorio;
    function TestaTemRegistroDoc(
      AenDoc: TDocsImprimirTotGeralVenda): Boolean;
    function RetornaDocImprimeFiltroData: TDocsImprimirTotGeralVenda;
    function TestarGeraCST: Boolean;
    function TestarGeraCSOSN: Boolean;
  public
    destructor Destroy; override;
    class function New: IGeraRelatorioTotalizadorGeralVenda;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioTotalizadorGeralVenda;
    function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioTotalizadorGeralVenda;
    function setUsuario(AcUsuario: String): IGeraRelatorioTotalizadorGeralVenda;
    function Salvar(AcCaminho: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioTotalizadorGeralVenda;
    function GeraRelatorio: IGeraRelatorioTotalizadorGeralVenda;
    function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
    function Imprimir: IGeraRelatorioTotalizadorGeralVenda;
  end;

implementation

uses
  uEstruturaRelTotalizadorGeralVenda, uIEstruturaRelatorioPadrao,
  uEstruturaTipoRelatorioPadrao, uDadosRelatorioPadraoDAO, Math,
  uNotaFiscalEletronicaCalc;
  
{ TGeraRelatorioTotalizadorGeralVenda }

function TGeraRelatorioTotalizadorGeralVenda.TipoDocStrToEnum(AcDoc: String) : TDocsImprimirTotGeralVenda;
begin
  AcDoc := Trim(AcDoc);
  if AcDoc = 'NFC-e' then
    Result := tditgvNFCe;
  if AcDoc = 'SAT' then
    Result := tditgvSAT;
  if AcDoc = 'NF-e' then
    Result := tditgvNFe;
  if AcDoc = 'Cupom' then
    Result := tditgvCupom;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregaPorFormaPagamento(AenDoc: TDocsImprimirTotGeralVenda);
begin
  FdmRelatorio.CarregaDadosFormaPgto(AenDoc);
  MapearPorFormaPagamento;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.MapearPorFormaPagamento;
var
  cTipo: String;
begin
  try
    while not FdmRelatorio.qryFormaPgto.Eof do
    begin

      if FdmRelatorio.qryFormaPgto.FieldByName('TOTAL').AsCurrency <> 0 then
      begin
        cTipo := Trim(FdmRelatorio.qryFormaPgto.FieldByName('TIPO').AsString);
        if not FdmRelatorio.cdsTotalPorFormaPgto.Locate('TIPO;FORMA', VarArrayOf([cTipo, FdmRelatorio.qryFormaPgto.FieldByName('FORMA').AsString]), []) then
        begin
          FdmRelatorio.cdsTotalPorFormaPgto.Append;
          FdmRelatorio.cdsTotalPorFormaPgtoTIPO.AsString  := cTipo;
          FdmRelatorio.cdsTotalPorFormaPgtoFORMA.AsString := FdmRelatorio.qryFormaPgto.FieldByName('FORMA').AsString;
        end
        else
          FdmRelatorio.cdsTotalPorFormaPgto.Edit;

        FdmRelatorio.cdsTotalPorFormaPgtoVALOR.AsCurrency := FdmRelatorio.cdsTotalPorFormaPgtoVALOR.AsCurrency + FdmRelatorio.qryFormaPgto.FieldByName('TOTAL').AsCurrency;

        FdmRelatorio.cdsTotalPorFormaPgto.Post;
      end;
      
      FdmRelatorio.qryFormaPgto.Next;
    end;
  finally
    FdmRelatorio.cdsTotalPorFormaPgto.IndexFieldNames := 'FORMA';
    FdmRelatorio.cdsTotalPorFormaPgto.First;
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.TestarGeraCST: Boolean;
begin
  Result := (FdmRelatorio.qryEmitente.FieldByName('CRT').AsInteger in [2,3]);
end;

function TGeraRelatorioTotalizadorGeralVenda.TestarGeraCSOSN: Boolean;
begin
  Result := (FdmRelatorio.qryEmitente.FieldByName('CRT').AsInteger in [1]);
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregaPorCFOPCSTCSOSN(AenDoc: TDocsImprimirTotGeralVenda);
var
  nDescontoItem, nDescontoRateioDoc, nAcrescimoRateioDoc: Currency;
  cTipo: String;
  cCSOSN: String;
  cCFOP: String;
  enTipoDoc: tDocsImprimirTotGeralVenda;
  oNotaFiscalCalc: TNotaFiscalEletronicaCalc;
  oObjetoNF: TVENDAS;
  oObjetoNFItem: TITENS001;
  i: Integer;
begin
  try
    if AenDoc = tditgvNFe then
    begin
      FdmRelatorio.CarregaNFs;

      while not FdmRelatorio.qryNFs.Eof do
      begin
        FdmRelatorio.CarregaDadosNFParaObj(FdmRelatorio.qryNFs.FieldByName('PEDIDO').AsString);

        oNotaFiscalCalc := TNotaFiscalEletronicaCalc.Create;
        try
          oObjetoNF := oNotaFiscalCalc.RetornaObjetoNota(FdmRelatorio.DataSetNF, FdmRelatorio.DataSetItensNF, False);

          for i := 0 to Pred(oObjetoNF.Itens.Count) do
          begin
            oObjetoNFItem := oObjetoNF.Itens.Items[i];

            cCFOP := Trim(oObjetoNFItem.Cfop);
            if not FdmRelatorio.cdsTotalCFOPTemp.Locate('TIPO;CFOP', VarArrayOf([RetornarDescricaoDocumento(AenDoc), cCFOP]), []) then
            begin
              FdmRelatorio.cdsTotalCFOPTemp.Append;
              FdmRelatorio.cdsTotalCFOPTempTIPO.AsString := RetornarDescricaoDocumento(AenDoc);
              FdmRelatorio.cdsTotalCFOPTempCFOP.AsString := cCFOP;
              FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency := 0;
            end
            else
              FdmRelatorio.cdsTotalCFOPTemp.Edit;

            FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency + oObjetoNFItem.Total
                                                                                                           + oObjetoNFItem.FreteRateado
                                                                                                           + oObjetoNFItem.SeguroRateado
                                                                                                           + oObjetoNFItem.VIpi
                                                                                                           + oObjetoNFItem.Vicmsst
                                                                                                           + oObjetoNFItem.VFCPST
                                                                                                           + oObjetoNFItem.DespesaRateado
                                                                                                           - oObjetoNFItem.DescontoRateado
                                                                                                           ;

            FdmRelatorio.cdsTotalCFOPTemp.Post;

            if TestarGeraCSOSN then
              cCSOSN := Trim(oObjetoNFItem.Csosn)
            else
              cCSOSN := Trim(oObjetoNFItem.Cst_icms);

            if not FdmRelatorio.cdsTotalCSOSNTemp.Locate('TIPO;CSOSN', VarArrayOf([RetornarDescricaoDocumento(AenDoc), cCSOSN]), []) then
            begin
              FdmRelatorio.cdsTotalCSOSNTemp.Append;
              FdmRelatorio.cdsTotalCSOSNTempTIPO.AsString  := RetornarDescricaoDocumento(AenDoc);
              FdmRelatorio.cdsTotalCSOSNTempCSOSN.AsString := cCSOSN;
            end
            else
              FdmRelatorio.cdsTotalCSOSNTemp.Edit;

            FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency + oObjetoNFItem.Total
                                                                                                             + oObjetoNFItem.FreteRateado
                                                                                                             + oObjetoNFItem.SeguroRateado
                                                                                                             + oObjetoNFItem.VIpi
                                                                                                             + oObjetoNFItem.Vicmsst
                                                                                                             + oObjetoNFItem.VFCPST
                                                                                                             + oObjetoNFItem.DespesaRateado
                                                                                                             - oObjetoNFItem.DescontoRateado
                                                                                                             ;
            FdmRelatorio.cdsTotalCSOSNTemp.Post;
          end;
        finally
          FreeAndNil(oNotaFiscalCalc);
        end;

        FdmRelatorio.qryNFs.Next;
      end;
    end
    else
    begin
      try
        // SETA O VALOR PRODUTO DOS ITENS PARA SEUS RESPECTIVOS CFOPs e CSOSNs
        FdmRelatorio.CarregaPorCFOPCSTCSOSN(AenDoc);

        while not FdmRelatorio.qryDadosCST.Eof do
        begin

          if FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency <> 0 then
          begin
            // CFOP
            if not FdmRelatorio.qryDadosCST.IsEmpty then
            begin
              if not FdmRelatorio.cdsTotalCFOPTemp.Locate('TIPO;CFOP'
                                                          , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryDadosCST.FieldByName('CFOP').AsString])
                                                          , []) then
              begin
                FdmRelatorio.cdsTotalCFOPTemp.Append;
                FdmRelatorio.cdsTotalCFOPTempTIPO.AsString := RetornarDescricaoDocumento(AenDoc);
                FdmRelatorio.cdsTotalCFOPTempCFOP.AsString := FdmRelatorio.qryDadosCST.FieldByName('CFOP').AsString;
              end
              else
                FdmRelatorio.cdsTotalCFOPTemp.Edit;

              FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency + FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency;

              FdmRelatorio.cdsTotalCFOPTemp.Post;

              if not FdmRelatorio.cdsTotalCSOSNTemp.Locate('TIPO;CSOSN'
                                                           , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryDadosCST.FieldByName('CSTCSOSN').AsString])
                                                           , []) then
              begin
                FdmRelatorio.cdsTotalCSOSNTemp.Append;
                FdmRelatorio.cdsTotalCSOSNTempTIPO.AsString  := RetornarDescricaoDocumento(AenDoc);
                FdmRelatorio.cdsTotalCSOSNTempCSOSN.AsString := FdmRelatorio.qryDadosCST.FieldByName('CSTCSOSN').AsString;
              end
              else
                FdmRelatorio.cdsTotalCSOSNTemp.Edit;

              FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency + FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency;

              FdmRelatorio.cdsTotalCSOSNTemp.Post;
            end;
          end;
          FdmRelatorio.qryDadosCST.Next;
        end;
      finally
        FdmRelatorio.cdsTotalCFOPTemp.First;
        FdmRelatorio.cdsTotalCSOSNTemp.First;
      end;

      // SETA OS DESCONTOS DOS ITENS PARA SEUS RESPECTIVOS CFOPs e CSOSNs
      FdmRelatorio.CarregaDescontosItem(AenDoc);
      try
        while not FdmRelatorio.qryDescontoItemCFOP.Eof do
        begin
          if FdmRelatorio.cdsTotalCFOPTemp.Locate('TIPO;CFOP'
                                                  , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryDescontoItemCFOP.FieldByName('CFOP').AsString])
                                                  , []) then
            FdmRelatorio.cdsTotalCFOPTemp.Edit;

          FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency + FdmRelatorio.qryDescontoItemCFOP.FieldByName('DESCONTO').AsCurrency;

          FdmRelatorio.cdsTotalCFOPTemp.Post;

          FdmRelatorio.qryDescontoItemCFOP.Next;
        end;

        while not FdmRelatorio.qryDescontoItemCSOSN.Eof do
        begin
          if FdmRelatorio.cdsTotalCSOSNTemp.Locate('TIPO;CSOSN'
                                                   , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryDescontoItemCSOSN.FieldByName('CSTCSOSN').AsString])
                                                   , []) then
            FdmRelatorio.cdsTotalCSOSNTemp.Edit;

          FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency + FdmRelatorio.qryDescontoItemCSOSN.FieldByName('DESCONTO').AsCurrency;

          FdmRelatorio.cdsTotalCSOSNTemp.Post;

          FdmRelatorio.qryDescontoItemCSOSN.Next;
        end;
      finally
        FdmRelatorio.cdsTotalCFOPTemp.First;
        FdmRelatorio.cdsTotalCSOSNTemp.First;
      end;

      FdmRelatorio.CarregaDadosDescAcrescDocumentos(AenDoc);

      //Rateio do desconto/acrescimo do documento
      while not FdmRelatorio.qryDocumentosDescAcresc.Eof do
      begin
        FdmRelatorio.CarregaItensDocumento(FdmRelatorio.qryDocumentosDescAcresc.FieldByName('PEDIDO').AsString, FdmRelatorio.qryDocumentosDescAcresc.FieldByName('CAIXA').AsString);

        while not FdmRelatorio.qryItensDocumento.Eof do
        begin
          nDescontoRateioDoc  := 0;
          nAcrescimoRateioDoc := 0;

          FdmRelatorio.CarregarDescontoDoc(FdmRelatorio.qryItensDocumento.FieldByName('PEDIDO').AsString, FdmRelatorio.qryItensDocumento.FieldByName('CAIXA').AsString);
          FdmRelatorio.CarregarAcrescimoDoc(FdmRelatorio.qryItensDocumento.FieldByName('PEDIDO').AsString, FdmRelatorio.qryItensDocumento.FieldByName('CAIXA').AsString);
          FdmRelatorio.CarregarTotalItens(FdmRelatorio.qryItensDocumento.FieldByName('PEDIDO').AsString, FdmRelatorio.qryItensDocumento.FieldByName('CAIXA').AsString);
          FdmRelatorio.CarregaDescontoItem(FdmRelatorio.qryItensDocumento.FieldByName('PEDIDO').AsString,
                                           FdmRelatorio.qryItensDocumento.FieldByName('CAIXA').AsString,
                                           FdmRelatorio.qryItensDocumento.FieldByName('ITEM').AsString);

          nDescontoRateioDoc := (FdmRelatorio.qryDescontoDoc.FieldByName('DESCONTOCUPOM').AsFloat / FdmRelatorio.qryTotalItens.FieldByName('TOTAL').AsFloat) * (FdmRelatorio.qryItensDocumento.FieldByName('VALOR').AsFloat + FdmRelatorio.qryDescontoItem.FieldByName('DESCONTO').AsFloat);

          nAcrescimoRateioDoc := (FdmRelatorio.qryAcrescimoDoc.FieldByName('ACRESCIMOCUPOM').AsFloat / FdmRelatorio.qryTotalItens.FieldByName('TOTAL').AsFloat) * (FdmRelatorio.qryItensDocumento.FieldByName('VALOR').AsFloat + FdmRelatorio.qryDescontoItem.FieldByName('DESCONTO').AsFloat);


          if (nDescontoRateioDoc <> 0) or (nAcrescimoRateioDoc <> 0) then
          begin
            if FdmRelatorio.cdsTotalCFOPTemp.Locate('TIPO;CFOP'
                                                    , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryItensDocumento.FieldByName('CFOP').AsString])
                                                    , []) then
              FdmRelatorio.cdsTotalCFOPTemp.Edit;
            FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency + nDescontoRateioDoc + nAcrescimoRateioDoc;
            FdmRelatorio.cdsTotalCFOPTemp.Post;


            if FdmRelatorio.cdsTotalCSOSNTemp.Locate('TIPO;CSOSN'
                                                     , VarArrayOf([RetornarDescricaoDocumento(AenDoc), FdmRelatorio.qryItensDocumento.FieldByName('CSTCSOSN').AsString])
                                                     , []) then
              FdmRelatorio.cdsTotalCSOSNTemp.Edit;
            FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency + nDescontoRateioDoc + nAcrescimoRateioDoc;
            FdmRelatorio.cdsTotalCSOSNTemp.Post;
          end;

          FdmRelatorio.qryItensDocumento.Next;
        end;

        FdmRelatorio.qryDocumentosDescAcresc.Next;
      end;    
    end;
  finally
    FdmRelatorio.cdsTotalCFOPTemp.IndexFieldNames := 'CFOP';
    FdmRelatorio.cdsTotalCFOPTemp.First;
    FdmRelatorio.cdsTotalCSOSNTemp.IndexFieldNames := 'CSOSN';
    FdmRelatorio.cdsTotalCSOSNTemp.First;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.AjustaCentavo(AenDoc: TDocsImprimirTotGeralVenda);
var
  nTotalFormaPgto: Currency;
  nTotalCFOP, nTotalCSOSN: Currency;
begin
  FdmRelatorio.cdsTotalPorFormaPgto.Filtered := False;
  FdmRelatorio.cdsTotalPorFormaPgto.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalPorFormaPgto.Filtered := True;

  FdmRelatorio.cdsTotalCFOP.Filtered := False;
  FdmRelatorio.cdsTotalCFOP.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalCFOP.Filtered := True;

  FdmRelatorio.cdsTotalCSOSN.Filtered := False;
  FdmRelatorio.cdsTotalCSOSN.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalCSOSN.Filtered := True;
  try
    nTotalFormaPgto := SomaClient(FdmRelatorio.cdsTotalPorFormaPgto, 'VALOR');
    nTotalCFOP := SomaClient(FdmRelatorio.cdsTotalCFOP, 'VALOR');
    nTotalCSOSN := SomaClient(FdmRelatorio.cdsTotalCSOSN, 'VALOR');

    if (nTotalFormaPgto <> nTotalCFOP) and (((nTotalFormaPgto - nTotalCFOP) <= 0.02) and ((nTotalFormaPgto - nTotalCFOP) >= -0.02)) then
    begin
      FdmRelatorio.cdsTotalCFOP.Last;

      FdmRelatorio.cdsTotalCFOP.Edit;
      FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency + (nTotalFormaPgto - nTotalCFOP);
      FdmRelatorio.cdsTotalCFOP.Post;

    end;
    if (nTotalFormaPgto <> nTotalCSOSN) and (((nTotalFormaPgto - nTotalCSOSN) <= 0.02) and ((nTotalFormaPgto - nTotalCSOSN) >= -0.02)) then
    begin
      FdmRelatorio.cdsTotalCSOSN.Last;

      FdmRelatorio.cdsTotalCSOSN.Edit;
      FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency + (nTotalFormaPgto - nTotalCSOSN);
      FdmRelatorio.cdsTotalCSOSN.Post;
    end;
  finally
    FdmRelatorio.cdsTotalPorFormaPgto.Filtered := False;
    FdmRelatorio.cdsTotalCFOP.Filtered := False;
    FdmRelatorio.cdsTotalCSOSN.Filtered := False;
    FdmRelatorio.cdsTotalPorFormaPgto.First;
    FdmRelatorio.cdsTotalCFOP.First;
    FdmRelatorio.cdsTotalCSOSN.First;
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.SomaClient(AcdsClient: TClientDataSet; AcCampo: String): Currency;
begin
  Result := 0;

  AcdsClient.First;
  while not AcdsClient.Eof do
  begin
    Result := Result + AcdsClient.FieldByName(AcCampo).AsCurrency;

    AcdsClient.Next;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.MapearClientOficial;
begin
  FdmRelatorio.cdsTotalPorFormaPgto.First;
  FdmRelatorio.cdsTotalCFOPTemp.First;
  FdmRelatorio.cdsTotalCSOSNTemp.First;
  try
    while not FdmRelatorio.cdsTotalPorFormaPgto.Eof do
    begin
      FdmRelatorio.cdsTotalPorFormaPgto.Edit;
      FdmRelatorio.cdsTotalPorFormaPgtoVALOR.AsCurrency := Arredonda(FdmRelatorio.cdsTotalPorFormaPgtoVALOR.AsCurrency, 2);
      FdmRelatorio.cdsTotalPorFormaPgto.Post;

      FdmRelatorio.cdsTotalPorFormaPgto.Next;
    end;
    while not FdmRelatorio.cdsTotalCFOPTemp.Eof do
    begin
      FdmRelatorio.cdsTotalCFOP.Append;
      FdmRelatorio.cdsTotalCFOPTIPO.AsString    := FdmRelatorio.cdsTotalCFOPTempTIPO.AsString;
      FdmRelatorio.cdsTotalCFOPCFOP.AsString    := FdmRelatorio.cdsTotalCFOPTempCFOP.AsString;
      FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency := Arredonda(FdmRelatorio.cdsTotalCFOPTempVALOR.AsCurrency, 2);
      FdmRelatorio.cdsTotalCFOP.Post;

      FdmRelatorio.cdsTotalCFOPTemp.Next;
    end;
    while not FdmRelatorio.cdsTotalCSOSNTemp.Eof do
    begin
      FdmRelatorio.cdsTotalCSOSN.Append;
      FdmRelatorio.cdsTotalCSOSNTIPO.AsString    := FdmRelatorio.cdsTotalCSOSNTempTIPO.AsString;
      FdmRelatorio.cdsTotalCSOSNCSOSN.AsString   := FdmRelatorio.cdsTotalCSOSNTempCSOSN.AsString;
      FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency := Arredonda(FdmRelatorio.cdsTotalCSOSNTempVALOR.AsCurrency, 2);
      FdmRelatorio.cdsTotalCSOSN.Post;

      FdmRelatorio.cdsTotalCSOSNTemp.Next;
    end;
  finally
    FdmRelatorio.cdsTotalPorFormaPgto.First;
    FdmRelatorio.cdsTotalCFOP.First;
    FdmRelatorio.cdsTotalCSOSN.First;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregarDados;
var
  i: Integer;
  enTipoDoc: tDocsImprimirTotGeralVenda;
begin
  FdmRelatorio.setDataBase(FoTransaction.DefaultDatabase);
  FdmRelatorio.CarregaDadosEmitente;

  for i := 0 to Pred(Ord(High(tDocsImprimirTotGeralVenda))) do
  begin
    enTipoDoc := tDocsImprimirTotGeralVenda(i);

    CarregaPorFormaPagamento(enTipoDoc);
    CarregaPorCFOPCSTCSOSN(enTipoDoc);
  end;
  MapearClientOficial;
  for i := 0 to Pred(Ord(High(tDocsImprimirTotGeralVenda))) do
  begin
    enTipoDoc := tDocsImprimirTotGeralVenda(i);

    AjustaCentavo(enTipoDoc);
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.Imprimir: IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;

  Salvar(EmptyStr, ttiHTML);
end;

class function TGeraRelatorioTotalizadorGeralVenda.New: IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self.Create;
end;

function TGeraRelatorioTotalizadorGeralVenda.Salvar(AcCaminho: String; AenTipoRelatorio: tTipoRelatorio): IGeraRelatorioTotalizadorGeralVenda;
var
  cArquivoAtual : String;
begin
  Result := Self;

  FoEstrutura.Salvar(AenTipoRelatorio);
  Sleep(200);

  cArquivoAtual := FcUsuario + ExtractFileExt(AcCaminho);

  if FileExists(cArquivoAtual) then
  begin
    if FileExists(ExtractFileName(AcCaminho)) then
    begin
      //DeleteFile(PAnsiChar(ExtractFileName(AcCaminho))); Mauricio Parizotto 2023-12-29
      DeleteFile(PChar(ExtractFileName(AcCaminho)));
      Sleep(150);
    end;

    RenameFile(cArquivoAtual, ExtractFileName(AcCaminho));
    Sleep(100);

    if FileExists(AcCaminho) then
    begin
      //DeleteFile(PAnsiChar(AcCaminho)); Mauricio Parizotto 2023-12-29
      DeleteFile(PChar(AcCaminho));
      Sleep(150);
    end;

    //MoveFile(PAnsiChar(ExtractFileName(AcCaminho)), PAnsiChar(AcCaminho)); Mauricio Parizotto 2023-12-29
    MoveFile(PChar(ExtractFileName(AcCaminho)), PChar(AcCaminho));
    Sleep(150);
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;

  FdmRelatorio.setPeriodo(FdDataIni, FdDataFim);
end;

function TGeraRelatorioTotalizadorGeralVenda.setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

function TGeraRelatorioTotalizadorGeralVenda.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

function TGeraRelatorioTotalizadorGeralVenda.GeraRelatorio: IGeraRelatorioTotalizadorGeralVenda;
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
begin
  Result := Self;

  oEstruturaRel := TEstruturaRelTotalizadorGeralVenda.New
                                                     .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                     .setDataBase(FoTransaction.DefaultDatabase)
                                                            );

  FoEstrutura := TEstruturaTipoRelatorioPadrao.New
                                              .setUsuario(FcUsuario)
                                              .GerarImpressaoCabecalho(oEstruturaRel);

  CarregarDados;

  GeraEstruturaRelatorio;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.GeraEstruturaRelatorio;
var
  i: Integer;
  enTipoDoc: tDocsImprimirTotGeralVenda;
begin
  FenImprimirFiltroData := RetornaDocImprimeFiltroData;

  for i := 0 to Pred(Ord(High(tDocsImprimirTotGeralVenda))) do
  begin
    enTipoDoc := tDocsImprimirTotGeralVenda(i);

    GeraEstruturaFormaPgto(enTipoDoc);
    GeraEstruturaCFOPCSTCSOSN(enTipoDoc);
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.GeraEstruturaFormaPgto(AenDoc: TDocsImprimirTotGeralVenda);
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  FdmRelatorio.cdsTotalPorFormaPgto.Filtered := False;
  FdmRelatorio.cdsTotalPorFormaPgto.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalPorFormaPgto.Filtered := True;

  if FdmRelatorio.cdsTotalPorFormaPgto.IsEmpty then
    Exit;

  oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                     .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                     .setDataBase(FoTransaction.DefaultDatabase)
                                                                                     .CarregarDados(FdmRelatorio.cdsTotalPorFormaPgto)
                                                            );

  FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por forma de pagamento - ' + RetornarDescricaoDocumento(AenDoc));
end;

procedure TGeraRelatorioTotalizadorGeralVenda.GeraEstruturaCFOPCSTCSOSN(AenDoc: TDocsImprimirTotGeralVenda);
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  FdmRelatorio.cdsTotalCFOP.Filtered := False;
  FdmRelatorio.cdsTotalCFOP.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalCFOP.Filtered := True;

  if not FdmRelatorio.cdsTotalCFOP.IsEmpty then
  begin
    oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                       .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                       .setDataBase(FoTransaction.DefaultDatabase)
                                                                                       .CarregarDados(FdmRelatorio.cdsTotalCFOP)
                                                              );

    FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por CFOP - ' + RetornarDescricaoDocumento(AenDoc));
  end;

  FdmRelatorio.cdsTotalCSOSN.Filtered := False;
  FdmRelatorio.cdsTotalCSOSN.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(AenDoc)) + ')';
  FdmRelatorio.cdsTotalCSOSN.Filtered := True;

  if not FdmRelatorio.cdsTotalCSOSN.IsEmpty then
  begin

    if TestarGeraCST then
      FdmRelatorio.cdsTotalCSOSNCSOSN.DisplayLabel := 'CST'
    else
      FdmRelatorio.cdsTotalCSOSNCSOSN.DisplayLabel := 'CSOSN';

    oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                       .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                       .setDataBase(FoTransaction.DefaultDatabase)
                                                                                       .CarregarDados(FdmRelatorio.cdsTotalCSOSN)
                                                              );

    if (AenDoc = FenImprimirFiltroData) then
      oEstruturaCat.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

    if TestarGeraCSOSN then
      FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por CSOSN - ' + RetornarDescricaoDocumento(AenDoc))
    else
      FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por CST - ' + RetornarDescricaoDocumento(AenDoc))
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.RetornaDocImprimeFiltroData: TDocsImprimirTotGeralVenda;
var
  nQtde: Integer;
begin
  Result := High(tDocsImprimirTotGeralVenda);
  
  nQtde := Ord(High(tDocsImprimirTotGeralVenda));

  while nQtde >= 0 do
  begin
    if TestaTemRegistroDoc(TDocsImprimirTotGeralVenda(nQtde)) then
    begin
      Result := TDocsImprimirTotGeralVenda(nQtde);
      Break;
    end;

    nQtde := Pred(nQtde);
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.TestaTemRegistroDoc(AenDoc: TDocsImprimirTotGeralVenda): Boolean;
var
  nRecNo: Integer;
  cdsTestar: TClientDataSet;
begin
  if FdmRelatorio.cdsTotalCSOSN.IsEmpty then
    cdsTestar := FdmRelatorio.cdsTotalCFOP
  else
    cdsTestar := FdmRelatorio.cdsTotalCSOSN;

  nRecNo := cdsTestar.RecNo;
  try
    Result := cdsTestar.Locate('TIPO', RetornarDescricaoDocumento(AenDoc), []);
  finally
    cdsTestar.RecNo := nRecNo;
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.RetornarDescricaoDocumento(AenDoc: TDocsImprimirTotGeralVenda): String;
begin
  case AenDoc of
    tditgvNFCe: Result := 'NFC-e';
    tditgvSAT: Result := 'SAT';
    tditgvNFe: Result := 'NF-e';
    tditgvCupom: Result := 'Cupom';
  end;
end;

function TGeraRelatorioTotalizadorGeralVenda.setUsuario(AcUsuario: String): IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;
  
  FcUsuario := AcUsuario;
end;

constructor TGeraRelatorioTotalizadorGeralVenda.Create;
begin
  FdmRelatorio := TdmRelTotalizadorVendasGeral.Create(nil);
end;

destructor TGeraRelatorioTotalizadorGeralVenda.Destroy;
begin
  FreeAndNil(FdmRelatorio);
  inherited;
end;

end.
