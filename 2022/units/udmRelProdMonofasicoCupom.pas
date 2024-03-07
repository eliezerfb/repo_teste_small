unit udmRelProdMonofasicoCupom;

interface

uses
  System.SysUtils, System.Classes, IBX.IBCustomDataSet, IBX.IBQuery, Data.DB,
  Datasnap.DBClient, IBX.IBDatabase;

type
  TdmRelProdMonofasicoCupom = class(TDataModule)
    cdsDados: TClientDataSet;
    qryDados: TIBQuery;
    cdsCFOP: TClientDataSet;
    cdsCSTICMSCSOSN: TClientDataSet;
    cdsCFOPCFOP: TWideStringField;
    cdsCSTICMSCSOSNCSTICMS: TWideStringField;
    cdsCSTICMSCSOSNCSOSN: TWideStringField;
    cdsDadosDATA: TDateTimeField;
    cdsDadosCAIXA: TWideStringField;
    cdsDadosCUPOM: TWideStringField;
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
    cdsCFOPTOTAL: TFMTBCDField;
    cdsCSTICMSCSOSNTOTAL: TFMTBCDField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FoTransaction: TIBTransaction;
    procedure setTransaction(const Value: TIBTransaction);
  public
    property Transaction: TIBTransaction read FoTransaction write setTransaction;

    procedure CarregaDados(AbDataIni, AbDataFim: TDate);
  end;

var
  dmRelProdMonofasicoCupom: TdmRelProdMonofasicoCupom;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  smallfunc_xe, uRateioVendasBalcao, uSmallEnumerados, uDadosEmitente;

{ TdmRelProdMonofasicoCupom }

procedure TdmRelProdMonofasicoCupom.CarregaDados(AbDataIni, AbDataFim: TDate);
var
  qryEmitente: TIBQuery;
  oRateio: TRateioBalcao;
  cCFOPAtual: String;
  cCSTCSOSN: String;
  nTotalItem: Double;
begin
  qryDados.Close;
  qryDados.SQL.Clear;
  qryDados.SQL.Add('SELECT');
  qryDados.SQL.Add('    ALTERACA.CAIXA');
  qryDados.SQL.Add('    , ALTERACA.DATA');
  qryDados.SQL.Add('    , ALTERACA.PEDIDO');
  qryDados.SQL.Add('    , ALTERACA.ITEM');
  qryDados.SQL.Add('    , ALTERACA.CFOP');
  qryDados.SQL.Add('    , ALTERACA.TOTAL');
  qryDados.SQL.Add('    , ALTERACA.CODIGO');
  qryDados.SQL.Add('    , ALTERACA.DESCRICAO');
  qryDados.SQL.Add('    , ALTERACA.CST_PIS_COFINS');
  qryDados.SQL.Add('    , ALTERACA.ALIQ_PIS');
  qryDados.SQL.Add('    , ALTERACA.ALIQ_COFINS');
  qryDados.SQL.Add('    , ESTOQUE.CF');
  qryDados.SQL.Add('    , ALTERACA.CST_ICMS');
  qryDados.SQL.Add('    , ALTERACA.CSOSN');
  qryDados.SQL.Add('FROM ALTERACA');
  qryDados.SQL.Add('INNER JOIN ESTOQUE ON (ESTOQUE.CODIGO=ALTERACA.CODIGO)');
  qryDados.SQL.Add('WHERE');
  qryDados.SQL.Add('(ALTERACA.DATA<='+QuotedStr(DateToStrInvertida(AbDataFim))+') AND (ALTERACA.DATA>='+QuotedStr(DateToStrInvertida(AbDataIni))+')');
  qryDados.SQL.Add('AND ((ALTERACA.TIPO='+QuotedStr('BALCAO')+') OR (ALTERACA.TIPO='+QuotedStr('VENDA')+'))');
  qryDados.SQL.Add('AND (ALTERACA.CST_PIS_COFINS=''04'')');
  qryDados.SQL.Add('AND ((SELECT COALESCE(NFCE.MODELO,'''') FROM NFCE WHERE (NFCE.CAIXA=ALTERACA.CAIXA) AND (NFCE.NUMERONF=ALTERACA.PEDIDO)) <> ''99'')');
  qryDados.SQL.Add('ORDER BY ALTERACA.DATA, ALTERACA.PEDIDO');
  qryDados.Open;
  qryDados.First;

  oRateio := TRateioBalcao.Create;

  try
    qryEmitente := TDadosEmitente.New
                                 .setDataBase(FoTransaction.DefaultDatabase)
                                 .getQuery;

    oRateio.IBTransaction := FoTransaction;

    while not qryDados.Eof do
    begin
      nTotalItem := 0;

      oRateio.CalcularRateio(qryDados.FieldByName('CAIXA').AsString, qryDados.FieldByName('PEDIDO').AsString, qryDados.FieldByName('ITEM').AsString);


      nTotalItem := qryDados.FieldByName('TOTAL').AsFloat + oRateio.DescontoItem + oRateio.RateioDescontoItem + oRateio.RateioAcrescimoItem;

      cdsDados.Append;
      cdsDadosDATA.Value         := qryDados.FieldByName('DATA').Value;
      cdsDadosCAIXA.Value        := qryDados.FieldByName('CAIXA').Value;
      cdsDadosCUPOM.Value        := qryDados.FieldByName('PEDIDO').Value;
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
      // CSTICMS/CSOSN FIM
      qryDados.Next;
    end;
  finally
    cdsDados.First;
    cdsCFOP.First;
    cdsCSTICMSCSOSN.First;

    FreeAndNil(oRateio);
  end;
end;

procedure TdmRelProdMonofasicoCupom.DataModuleCreate(Sender: TObject);
begin
  cdsDados.CreateDataSet;
  cdsCFOP.CreateDataSet;
  cdsCSTICMSCSOSN.CreateDataSet;
end;

procedure TdmRelProdMonofasicoCupom.DataModuleDestroy(Sender: TObject);
begin
  cdsDados.Close;
  cdsCFOP.Close;
  cdsCSTICMSCSOSN.Close;
end;

procedure TdmRelProdMonofasicoCupom.setTransaction(const Value: TIBTransaction);
begin
  FoTransaction := Value;

  qryDados.Transaction := FoTransaction;
end;

end.
