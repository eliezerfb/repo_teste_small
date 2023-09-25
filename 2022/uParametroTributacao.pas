unit uParametroTributacao;

interface

uses
  IBCustomDataSet
  , IBDatabase
  , IBQuery
  ;

  procedure SetValoresParTributacao(CFOP, ORIGEM, CST, CSOSN, NCM : string; ALIQ : Double; vDataSet : TibDataSet);

implementation

uses uFuncoesBancoDados, SysUtils;

procedure SetValoresParTributacao(CFOP, ORIGEM, CST, CSOSN, NCM : string; ALIQ : Double; vDataSet : TibDataSet);
var
  Query: TIBQuery;
  ALIQ_E : string;
begin
  try
    ALIQ_E := StringReplace(FloatToStr(ALIQ),',','.',[rfReplaceAll]);

    Query := CriaIBQuery(vDataSet.Transaction);

    try
      Query.SQL.Text := ' Select first 1 '+
                        ' 	PR.*,'+
                        ' 	PF.*'+
                        ' From PARAMETROTRIBUTACAO PR'+
                        ' 	Left Join PERFILTRIBUTACAO PF on PF.IDPERFILTRIBUTACAO = PR.IDPERFILTRIBUTACAO'+
                        ' Where COALESCE(PR.CFOP_ENTRADA,'+QuotedStr(CFOP)+') = '+QuotedStr(CFOP)+
                        ' 	and COALESCE(PR.ORIGEM_ENTRADA,'+QuotedStr(ORIGEM)+') = '+QuotedStr(ORIGEM)+
                        ' 	and COALESCE(CST_ENTRADA,'+QuotedStr(CST)+') = '+QuotedStr(CST)+
                        '   and COALESCE(CSOSN_ENTRADA,'+QuotedStr(CSOSN)+') = '+QuotedStr(CSOSN)+
                        ' 	and COALESCE(ALIQ_ENTRADA,'+ALIQ_E+') = '+ ALIQ_E + // Não obrigatório
                        ' 	and COALESCE(NCM_ENTRADA,'+QuotedStr(NCM)+') = '+QuotedStr(NCM)+ // Não obrigatório
                        ' Order By '+
                        '   PR.CFOP_ENTRADA desc,'+
                        '   PR.CST_ENTRADA desc,'+
                        '   PR.CSOSN_ENTRADA desc,'+
                        '   PR.ALIQ_ENTRADA desc,'+
                        '   PR.NCM_ENTRADA desc ';
      Query.Open;

      if not Query.IsEmpty then
      begin
        vDataSet.FieldByName('TIPO_ITEM').AsString               := Query.FieldByName('TIPO_ITEM').AsString;
        vDataSet.FieldByName('IPPT').AsString                    := Query.FieldByName('IPPT').AsString;
        vDataSet.FieldByName('IAT').AsString                     := Query.FieldByName('IAT').AsString;
        vDataSet.FieldByName('PIVA').AsString                    := Query.FieldByName('PIVA').AsString;
        vDataSet.FieldByName('CST').AsString                     := Query.FieldByName('CST').AsString;
        vDataSet.FieldByName('CSOSN').AsString                   := Query.FieldByName('CSOSN').AsString;
        vDataSet.FieldByName('ST').AsString                      := Query.FieldByName('ST').AsString;
        vDataSet.FieldByName('CFOP').AsString                    := Query.FieldByName('CFOP').AsString;
        vDataSet.FieldByName('CST_NFCE').AsString                := Query.FieldByName('CST_NFCE').AsString;
        vDataSet.FieldByName('CSOSN_NFCE').AsString              := Query.FieldByName('CSOSN_NFCE').AsString;
        vDataSet.FieldByName('ALIQUOTA_NFCE').AsString           := Query.FieldByName('ALIQUOTA_NFCE').AsString;
        vDataSet.FieldByName('CST_IPI').AsString                 := Query.FieldByName('CST_IPI').AsString;
        vDataSet.FieldByName('IPI').AsString                     := Query.FieldByName('IPI').AsString;
        vDataSet.FieldByName('ENQ_IPI').AsString                 := Query.FieldByName('ENQ_IPI').AsString;
        vDataSet.FieldByName('CST_PIS_COFINS_SAIDA').AsString    := Query.FieldByName('CST_PIS_COFINS_SAIDA').AsString;
        vDataSet.FieldByName('ALIQ_PIS_SAIDA').AsString          := Query.FieldByName('ALIQ_PIS_SAIDA').AsString;
        vDataSet.FieldByName('ALIQ_COFINS_SAIDA').AsString       := Query.FieldByName('ALIQ_COFINS_SAIDA').AsString;
        vDataSet.FieldByName('CST_PIS_COFINS_ENTRADA').AsString  := Query.FieldByName('CST_PIS_COFINS_ENTRADA').AsString;
        vDataSet.FieldByName('ALIQ_COFINS_ENTRADA').AsString     := Query.FieldByName('ALIQ_COFINS_ENTRADA').AsString;
        vDataSet.FieldByName('ALIQ_PIS_ENTRADA').AsString        := Query.FieldByName('ALIQ_PIS_ENTRADA').AsString;
      end;
    finally
      FreeAndNil(Query);
    end;
  except
  end;
end;

end.
