unit uGeraRelatorioTotalizadorGeralVenda;

interface

uses
  uIGeraRelatorioTotalizadorGeralVenda, uSmallEnumerados, IBDataBase,
  IBQuery, SysUtils, uConectaBancoSmall, uIEstruturaTipoRelatorioPadrao,
  DB, DBClient, udmRelTotalizadorVendasGeral, Variants, uNotaFiscalEletronica;

type
  TGeraRelatorioTotalizadorGeralVenda = class(TInterfacedObject, IGeraRelatorioTotalizadorGeralVenda)
  private
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    FoTransaction: TIBTransaction;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FdmRelatorio: TdmRelTotalizadorVendasGeral;
    procedure CarregarDados;
    procedure CarregaPorCFOPCSTCSOSN;
    procedure CarregaPorFormaPagamento;
    procedure CarregaPorCSOSN;
    procedure GeraEstruturaFormaPgto;
    function RetornarDescricaoDocumento(AenDoc: TDocsImprimirTotGeralVenda): String;
    function TipoDocStrToEnum(AcDoc: String): TDocsImprimirTotGeralVenda;
    constructor Create;
    procedure GeraEstruturaCFOPCSTCSOSN;
  public
    destructor Destroy; override;
    class function New: IGeraRelatorioTotalizadorGeralVenda;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioTotalizadorGeralVenda;
    function setPerido(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioTotalizadorGeralVenda;
    function setUsuario(AcUsuario: String): IGeraRelatorioTotalizadorGeralVenda;
    function Salvar(AcCaminhoSemExtensao: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioTotalizadorGeralVenda;
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

procedure TGeraRelatorioTotalizadorGeralVenda.CarregaPorFormaPagamento;
var
  cTipo: String;
begin
  FdmRelatorio.qryDocumentos.First;
  try
    while not FdmRelatorio.qryDocumentos.Eof do
    begin
      cTipo := Trim(FdmRelatorio.qryDocumentos.FieldByName('TIPO').AsString);
      FdmRelatorio.CarregaDadosFormaPgto(TipoDocStrToEnum(cTipo));

      while not FdmRelatorio.qryFormaPgto.Eof do
      begin
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

        FdmRelatorio.qryFormaPgto.Next;
      end;

      FdmRelatorio.qryDocumentos.Next;
    end;
  finally
    FdmRelatorio.cdsTotalPorFormaPgto.IndexFieldNames := 'FORMA';
    FdmRelatorio.cdsTotalPorFormaPgto.First;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregaPorCFOPCSTCSOSN;
var
  nDescontoItem, nDescontoRateioDoc, nAcrescimoRateioDoc: Currency;
  cTipo: String;
  cCSOSN: String;
  enTipoDoc: tDocsImprimirTotGeralVenda;
  oNotaFiscalCalc: TNotaFiscalEletronicaCalc;
  oObjetoNF: TVENDAS;
  oObjetoNFItem: TITENS001;
  i: Integer;
begin
  FdmRelatorio.qryDocumentos.First;
  try
    while not FdmRelatorio.qryDocumentos.Eof do
    begin
      cTipo := Trim(FdmRelatorio.qryDocumentos.FieldByName('TIPO').AsString);

      enTipoDoc := TipoDocStrToEnum(cTipo);
      if enTipoDoc = tditgvNFe then
      begin
        FdmRelatorio.CarregaDadosNF(FdmRelatorio.qryDocumentos.FieldByName('PEDIDO').AsString);

        oNotaFiscalCalc := TNotaFiscalEletronicaCalc.Create;
        try
          oObjetoNF := oNotaFiscalCalc.RetornaObjetoNota(FdmRelatorio.DataSetNF, FdmRelatorio.DataSetItensNF, False);

          for i := 0 to Pred(oObjetoNF.Itens.Count) do
          begin
            oObjetoNFItem := oObjetoNF.Itens.Items[i];

            if not FdmRelatorio.cdsTotalCFOP.Locate('CFOP', oObjetoNFItem.Cfop, []) then
            begin
              FdmRelatorio.cdsTotalCFOP.Append;
              FdmRelatorio.cdsTotalCFOPCFOP.AsString := oObjetoNFItem.Cfop;
              FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency := 0;              
            end
            else
              FdmRelatorio.cdsTotalCFOP.Edit;

            FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency + oObjetoNFItem.Total +
                                                                                                     oObjetoNFItem.FreteRateado +
                                                                                                     oObjetoNFItem.SeguroRateado +
                                                                                                     oObjetoNFItem.VIpi +
                                                                                                     oObjetoNFItem.Vicmsst +
                                                                                                     oObjetoNFItem.VFCPST +
                                                                                                     oObjetoNFItem.DespesaRateado +
                                                                                                     oObjetoNFItem.DescontoRateado
                                                                                                     ;

            FdmRelatorio.cdsTotalCFOP.Post;


            cCSOSN := Trim(oObjetoNFItem.Csosn); // CSOSN de ALTERACA

            if not FdmRelatorio.cdsTotalCSOSN.Locate('CSOSN', cCSOSN, []) then
            begin
              FdmRelatorio.cdsTotalCSOSN.Append;
              FdmRelatorio.cdsTotalCSOSNCSOSN.AsString := cCSOSN;
            end
            else
              FdmRelatorio.cdsTotalCSOSN.Edit;

            FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency + oObjetoNFItem.Total +
                                                                                                       oObjetoNFItem.FreteRateado +
                                                                                                       oObjetoNFItem.SeguroRateado +
                                                                                                       oObjetoNFItem.VIpi +
                                                                                                       oObjetoNFItem.Vicmsst +
                                                                                                       oObjetoNFItem.VFCPST +
                                                                                                       oObjetoNFItem.DespesaRateado +
                                                                                                       oObjetoNFItem.DescontoRateado
                                                                                                       ;
            FdmRelatorio.cdsTotalCSOSN.Post;
          end;
        finally
          FreeAndNil(oNotaFiscalCalc);
        end;
      end
      else
      begin
        FdmRelatorio.CarregaPorCFOPCSTCSOSN(enTipoDoc);

        while not FdmRelatorio.qryDadosCST.Eof do
        begin
          if FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency <> 0 then
          begin
            nDescontoItem := 0;
            nAcrescimoRateioDoc := 0;
            nDescontoRateioDoc := 0;

            FdmRelatorio.CarregaDescontos(enTipoDoc);
            if enTipoDoc in [tditgvNFCe, tditgvSAT, tditgvCupom] then
            begin
              if FdmRelatorio.qryDescontoItem.Locate('PEDIDO;ITEM', VarArrayOf([FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, FdmRelatorio.qryDadosCST.FieldByName('ITEM').AsString]), []) then
                nDescontoItem := FdmRelatorio.qryDescontoItem.FieldByName('DESCONTO').AsFloat;

              //Rateio do desconto do documento
              if FdmRelatorio.qryTotalDoc.Locate('PEDIDO', FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, []) then
              begin
                // Não arredondar os valores individuais, somente no momento de imprimir o total do array
                if FdmRelatorio.qryDescontoDoc.Locate('PEDIDO', FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, []) then
                  nDescontoRateioDoc := (FdmRelatorio.qryDescontoDoc.FieldByName('DESCONTOCUPOM').AsFloat / FdmRelatorio.qryTotalItens.FieldByName('TOTAL').AsFloat) * (FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsFloat + nDescontoItem);

                if FdmRelatorio.qryAcrescimoDoc.Locate('PEDIDO', FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, []) then
                  nAcrescimoRateioDoc := (FdmRelatorio.qryAcrescimoDoc.FieldByName('ACRESCIMOCUPOM').AsFloat / FdmRelatorio.qryTotalItens.FieldByName('TOTAL').AsFloat) * (FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsFloat + nDescontoItem);
              end;
            end
            else
            begin
              if FdmRelatorio.qryTotalDoc.Locate('PEDIDO', FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, []) then
              begin
                // Não arredondar os valores individuais, somente no momento de imprimir o total do array
                if FdmRelatorio.qryDescontoDoc.Locate('PEDIDO', FdmRelatorio.qryDadosCST.FieldByName('PEDIDO').AsString, []) then
                  nDescontoRateioDoc := (FdmRelatorio.qryDescontoDoc.FieldByName('DESCONTOCUPOM').AsFloat / FdmRelatorio.qryTotalItens.FieldByName('TOTAL').AsFloat) * (FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsFloat + nDescontoItem);
              end;
            end;

            // CFOP
            if not FdmRelatorio.qryDadosCST.IsEmpty then
            begin
              if not FdmRelatorio.cdsTotalCFOP.Locate('CFOP', FdmRelatorio.qryDadosCST.FieldByName('CFOP').AsString, []) then
              begin
                FdmRelatorio.cdsTotalCFOP.Append;
                FdmRelatorio.cdsTotalCFOPCFOP.AsString := FdmRelatorio.qryDadosCST.FieldByName('CFOP').AsString;
              end
              else
                FdmRelatorio.cdsTotalCFOP.Edit;

              FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency := FdmRelatorio.cdsTotalCFOPVALOR.AsCurrency + FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency +
                                                                                                       nDescontoItem + nDescontoRateioDoc + nAcrescimoRateioDoc;

              FdmRelatorio.cdsTotalCFOP.Post;

              // CSOSN
              cCSOSN := Trim(FdmRelatorio.qryDadosCST.FieldByName('CSOSN').AsString); // CSOSN de ALTERACA
              if (cCSOSN = EmptyStr) and (Trim(FdmRelatorio.qryDadosCST.FieldByName('CSOSN_NFCE').AsString) <> EmptyStr) then
                cCSOSN := Trim(FdmRelatorio.qryDadosCST.FieldByName('CSOSN_NFCE').AsString); // CSOSN de ESTOQUE para NFCE
              if cCSOSN = EmptyStr then
                cCSOSN := Trim(FdmRelatorio.qryDadosCST.FieldByName('ESTOQUE_CSOSN').AsString); // CSOSN de ESTOQUE geral
              if AnsiUpperCase(FdmRelatorio.qryDadosCST.FieldByName('ALIQUICM').AsString) = 'ISS' then
                cCSOSN := 'ISS';

              if not FdmRelatorio.cdsTotalCSOSN.Locate('CSOSN', cCSOSN, []) then
              begin
                FdmRelatorio.cdsTotalCSOSN.Append;
                FdmRelatorio.cdsTotalCSOSNCSOSN.AsString := cCSOSN;
              end
              else
                FdmRelatorio.cdsTotalCSOSN.Edit;

              FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency := FdmRelatorio.cdsTotalCSOSNVALOR.AsCurrency + FdmRelatorio.qryDadosCST.FieldByName('VALOR').AsCurrency +
                                                                                                         nDescontoItem + nDescontoRateioDoc + nAcrescimoRateioDoc;
              FdmRelatorio.cdsTotalCSOSN.Post;
            end;
          end;
          FdmRelatorio.qryDadosCST.Next;
        end;
      end;
      FdmRelatorio.qryDocumentos.Next;
    end;
  finally
    FdmRelatorio.cdsTotalCFOP.IndexFieldNames := 'CFOP';
    FdmRelatorio.cdsTotalCFOP.First;
    FdmRelatorio.cdsTotalCSOSN.IndexFieldNames := 'CSOSN';
    FdmRelatorio.cdsTotalCSOSN.First;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregaPorCSOSN;
begin
  try

  finally
    FdmRelatorio.cdsTotalCSOSN.IndexFieldNames := 'CSOSN';
    FdmRelatorio.cdsTotalCSOSN.First;
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.CarregarDados;
begin
  FdmRelatorio.setDataBase(FoTransaction.DefaultDatabase);
  // Carrega todos os documentos no periodo
  FdmRelatorio.CarregaDadosDocumentos(FdDataIni, FdDataFim);

  CarregaPorFormaPagamento;
  CarregaPorCFOPCSTCSOSN;
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

function TGeraRelatorioTotalizadorGeralVenda.Salvar(AcCaminhoSemExtensao: String; AenTipoRelatorio: tTipoRelatorio): IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;
end;

function TGeraRelatorioTotalizadorGeralVenda.setPerido(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioTotalizadorGeralVenda;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
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

  // Se não tem Dados de
  if FdmRelatorio.qryDocumentos.IsEmpty then
    Exit;

  GeraEstruturaFormaPgto;
  GeraEstruturaCFOPCSTCSOSN;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.GeraEstruturaFormaPgto;
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
  i: Integer;
begin
  // LOOP entre todos os tipos de documentos, o que tiver dados vai imprimir agrupado
  for i := 0 to Pred(Ord(High(tDocsImprimirTotGeralVenda))) do
  begin
    FdmRelatorio.cdsTotalPorFormaPgto.Filtered := False;
    FdmRelatorio.cdsTotalPorFormaPgto.Filter   := '(TIPO=' + QuotedStr(RetornarDescricaoDocumento(tDocsImprimirTotGeralVenda(i))) + ')';
    FdmRelatorio.cdsTotalPorFormaPgto.Filtered := True;

    if FdmRelatorio.cdsTotalPorFormaPgto.IsEmpty then
      Continue;

    oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                       .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                       .setDataBase(FoTransaction.DefaultDatabase)
                                                                                       .CarregarDados(FdmRelatorio.cdsTotalPorFormaPgto)
                                                              );

    FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por forma de pagamento - ' + RetornarDescricaoDocumento(tDocsImprimirTotGeralVenda(i)));
  end;
end;

procedure TGeraRelatorioTotalizadorGeralVenda.GeraEstruturaCFOPCSTCSOSN;
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
  cFiltroData: String;
begin
  oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                     .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                     .setDataBase(FoTransaction.DefaultDatabase)
                                                                                     .CarregarDados(FdmRelatorio.cdsTotalCFOP)
                                                            );

  FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por CFOP');

  oEstruturaCat := TEstruturaRelTotalizadorGeralVenda.New
                                                     .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                     .setDataBase(FoTransaction.DefaultDatabase)
                                                                                     .CarregarDados(FdmRelatorio.cdsTotalCSOSN)
                                                            );

  oEstruturaCat.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

  FoEstrutura.GerarImpressaoAgrupado(oEstruturaCat, 'Total por CSOSN');
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
