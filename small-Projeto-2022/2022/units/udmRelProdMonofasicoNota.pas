unit udmRelProdMonofasicoNota;

interface

uses
  System.SysUtils, System.Classes, IBX.IBCustomDataSet, IBX.IBQuery, Data.DB,
  Datasnap.DBClient, IBX.IBDataBase;

type
  TdmRelProdMonofasicoNota = class(TDataModule)
    cdsDados: TClientDataSet;
    cdsDadosDATA: TDateTimeField;
    cdsDadosCODIGO: TWideStringField;
    cdsDadosDESCRICAO: TWideStringField;
    cdsDadosTOTAL: TFMTBCDField;
    cdsDadosCST: TWideStringField;
    cdsDadosPISPERC: TFMTBCDField;
    cdsDadosPISVLR: TFMTBCDField;
    cdsDadosCOFINSPERC: TFMTBCDField;
    cdsDadosCOFINSVLR: TFMTBCDField;
    cdsDadosCFOP: TWideStringField;
    cdsDadosNCM: TWideStringField;
    cdsDadosCSTICMS: TWideStringField;
    cdsDadosCSOSN: TWideStringField;
    qryDados: TIBQuery;
    cdsCFOP: TClientDataSet;
    cdsCFOPCFOP: TWideStringField;
    cdsCFOPTOTAL: TFMTBCDField;
    cdsCSTICMSCSOSN: TClientDataSet;
    cdsCSTICMSCSOSNCSTICMS: TWideStringField;
    cdsCSTICMSCSOSNCSOSN: TWideStringField;
    cdsCSTICMSCSOSNTOTAL: TFMTBCDField;
    cdsDadosNF: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure setTransaction(const Value: TIBTransaction);
  private
    FoTransaction: TIBTransaction;
  public
    property Transaction: TIBTransaction read FoTransaction write setTransaction;

    procedure CarregaDados(AbDataIni, AbDataFim: TDate);
  end;

var
  dmRelProdMonofasicoNota: TdmRelProdMonofasicoNota;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  smallfunc_xe, uSmallEnumerados, uDadosEmitente;

{ TdmRelProdMonofasicoNota }

procedure TdmRelProdMonofasicoNota.CarregaDados(AbDataIni, AbDataFim: TDate);
var
  qryEmitente: TIBQuery;
  nDescontoRateado, nTotalItem: Double;
  cCFOPAtual, cCSTCSOSN: String;
begin
  qryDados.Close;
  qryDados.SQL.Clear;
  qryDados.SQL.Add('SELECT');
  qryDados.SQL.Add('    VENDAS.EMISSAO');
  qryDados.SQL.Add('    , VENDAS.NUMERONF');
  qryDados.SQL.Add('    , VENDAS.DESCONTO');
  qryDados.SQL.Add('    , VENDAS.MERCADORIA');
  qryDados.SQL.Add('    , ITENS001.CODIGO');
  qryDados.SQL.Add('    , ITENS001.DESCRICAO');
  qryDados.SQL.Add('    , ITENS001.TOTAL');
  qryDados.SQL.Add('    , ITENS001.CST_PIS_COFINS');
  qryDados.SQL.Add('    , ITENS001.ALIQ_PIS');
  qryDados.SQL.Add('    , ITENS001.ALIQ_COFINS');
  qryDados.SQL.Add('    , ITENS001.CFOP');
  qryDados.SQL.Add('    , ESTOQUE.CF');
  qryDados.SQL.Add('    , ITENS001.CST_ICMS');
  qryDados.SQL.Add('    , ITENS001.CSOSN');
  qryDados.SQL.Add('FROM ITENS001');
  qryDados.SQL.Add('INNER JOIN VENDAS ON (VENDAS.NUMERONF=ITENS001.NUMERONF)');
  qryDados.SQL.Add('INNER JOIN ESTOQUE ON (ITENS001.CODIGO=ESTOQUE.CODIGO)');
  qryDados.SQL.Add('WHERE');
  qryDados.SQL.Add('(VENDAS.EMITIDA=''S'')');
  qryDados.SQL.Add('AND (ITENS001.CST_PIS_COFINS=''04'')');
  qryDados.SQL.Add('AND (VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(AbDataIni))+') AND (VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(AbDataFim))+')');
  qryDados.SQL.Add('AND (COALESCE(ITENS001.CST_PIS_COFINS,''XX'')<>''XX'')');
  qryDados.SQL.Add('ORDER BY VENDAS.EMISSAO, VENDAS.NUMERONF');
  qryDados.Open;
  qryDados.First;

  try
    qryEmitente := TDadosEmitente.New
                                 .setDataBase(FoTransaction.DefaultDatabase)
                                 .getQuery;

    while not qryDados.Eof do
    begin
      try
        nDescontoRateado := 0;
        if qryDados.FieldByname('DESCONTO').AsFloat <> 0 then
          nDescontoRateado  := Arredonda((qryDados.FieldByname('DESCONTO').AsFloat / qryDados.FieldByname('MERCADORIA').AsFloat * qryDados.FieldByname('TOTAL').AsFloat), 2);
      except
        nDescontoRateado := 0;
      end;

      nTotalItem := qryDados.FieldByname('TOTAL').AsFloat - nDescontoRateado;

      cdsDados.Append;
      cdsDadosDATA.Value         := qryDados.FieldByName('EMISSAO').Value;
      cdsDadosNF.Value           := qryDados.FieldByName('NUMERONF').Value;
      cdsDadosCODIGO.Value       := qryDados.FieldByName('CODIGO').Value;
      cdsDadosDESCRICAO.Value    := StrTran(StrTran(qryDados.FieldByName('DESCRICAO').Value,'<',EmptyStr),'>',EmptyStr);
      cdsDadosTOTAL.AsFloat      := Arredonda(nTotalItem, 2);
      cdsDadosCST.Value          := qryDados.FieldByName('CST_PIS_COFINS').Value;
      cdsDadosPISPERC.AsFloat    := Arredonda(qryDados.FieldByName('ALIQ_PIS').AsFloat, 4);
      cdsDadosPISVLR.AsFloat     := Arredonda(qryDados.FieldByName('ALIQ_PIS').AsFloat / 100 * (nTotalItem),2);
      cdsDadosCOFINSPERC.AsFloat := Arredonda(qryDados.FieldByName('ALIQ_COFINS').AsFloat, 4);
      cdsDadosCOFINSVLR.AsFloat  := Arredonda(qryDados.FieldByName('ALIQ_COFINS').AsFloat / 100 * (nTotalItem), 2);
      cdsDadosCFOP.AsString      := qryDados.FieldByName('CFOP').Value;
      cdsDadosNCM.AsString       := qryDados.FieldByName('CF').Value;
      cdsDadosCSTICMS.AsString   := qryDados.FieldByName('CST_ICMS').Value;
      cdsDadosCSOSN.AsString     := qryDados.FieldByName('CSOSN').Value;

      cdsDadosCSTICMS.Visible        := (tCRTEmitente(qryEmitente.FieldByName('CRT').AsInteger) = tcrteRegimeNormal);
      cdsDadosCSOSN.Visible          := (tCRTEmitente(qryEmitente.FieldByName('CRT').AsInteger) <> tcrteRegimeNormal);
      cdsCSTICMSCSOSNCSTICMS.Visible := (tCRTEmitente(qryEmitente.FieldByName('CRT').AsInteger) = tcrteRegimeNormal);
      cdsCSTICMSCSOSNCSOSN.Visible   := (tCRTEmitente(qryEmitente.FieldByName('CRT').AsInteger) <> tcrteRegimeNormal);
      cdsDados.Post;


      cCFOPAtual := Trim(qryDados.FieldByName('CFOP').AsString);
      if cCFOPAtual = '' then
        cCFOPAtual := ' ';

      // CFOP INICIO
      cCFOPAtual := Trim(qryDados.FieldByName('CFOP').AsString);
      if cCFOPAtual = EmptyStr then
        cCFOPAtual := ' ';

      if cdsCFOP.Locate('CFOP', cCFOPAtual, []) then
        cdsCFOP.Edit
      else
      begin
        cdsCFOP.Append;
        cdsCFOPCFOP.AsString := cCFOPAtual;
        cdsCFOPTOTAL.AsFloat := 0;
      end;
      cdsCFOPTOTAL.AsFloat := Arredonda(cdsCFOPTOTAL.AsFloat + nTotalItem, 2);
      cdsCFOP.Post;
      // CFOP INICIO FIM

      // CSTICMS/CSOSN INCIO
      if tCRTEmitente(qryEmitente.FieldByName('CRT').AsInteger) = tcrteRegimeNormal then
        cCSTCSOSN := Trim(qryDados.FieldByName('CST_ICMS').AsString)
      else
        cCSTCSOSN := Trim(qryDados.FieldByName('CSOSN').AsString);

      if cCSTCSOSN = EmptyStr then
        cCSTCSOSN := ' ';

      if cdsCSTICMSCSOSN.Locate('CSTICMS', cCSTCSOSN, []) then
      begin
        cdsCSTICMSCSOSN.Edit;
      end
      else
      begin
        cdsCSTICMSCSOSN.Append;
        cdsCSTICMSCSOSNCSTICMS.AsString := cCSTCSOSN;
        cdsCSTICMSCSOSNCSOSN.AsString   := cCSTCSOSN;
        cdsCSTICMSCSOSNTOTAL.AsFloat    := 0;
      end;
      cdsCSTICMSCSOSNTOTAL.AsFloat := Arredonda(cdsCSTICMSCSOSNTOTAL.AsFloat + nTotalItem, 2);
      cdsCSTICMSCSOSN.Post;

      qryDados.Next;
    end;
  finally
    cdsDados.First;
    cdsCFOP.First;
    cdsCSTICMSCSOSN.First;
  end;
end;

procedure TdmRelProdMonofasicoNota.DataModuleCreate(Sender: TObject);
begin
  cdsDados.CreateDataSet;
  cdsCFOP.CreateDataSet;
  cdsCSTICMSCSOSN.CreateDataSet;
end;

procedure TdmRelProdMonofasicoNota.DataModuleDestroy(Sender: TObject);
begin
  cdsDados.Close;
  cdsCFOP.Close;
  cdsCSTICMSCSOSN.Close;
end;

procedure TdmRelProdMonofasicoNota.setTransaction(const Value: TIBTransaction);
begin
  FoTransaction := Value;

  qryDados.Transaction := FoTransaction;
end;

end.
