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
  vCST_CSOSN, cCST_CSOSN : string;
begin
  try
    //Identifca se vai usar campo CST ou CSOSN
    if CST <> '' then
    begin
      vCST_CSOSN := CST;
      cCST_CSOSN := 'CST_ENTRADA';
    end else
    begin
      vCST_CSOSN := CSOSN;
      cCST_CSOSN := 'CSOSN_ENTRADA';
    end;

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
                        ' 	and COALESCE('+cCST_CSOSN+','+QuotedStr(vCST_CSOSN)+') = '+QuotedStr(vCST_CSOSN)+
                        ' 	and COALESCE(ALIQ_ENTRADA,'+ALIQ_E+') = '+ ALIQ_E +
                        ' 	and COALESCE(NCM_ENTRADA,'+QuotedStr(NCM)+') = '+QuotedStr(NCM)+
                        ' Order By '+
                        '   PR.NCM_ENTRADA desc, '+
                        '   (iif(PR.CFOP_ENTRADA is null,0,1) + '+
                        '     iif(PR.ORIGEM_ENTRADA is null,0,1) + '+
                        '     iif(PR.'+cCST_CSOSN+' is null,0,1) + '+
                        '     iif(PR.ALIQ_ENTRADA is null,0,1) + '+
                        '     iif(PR.NCM_ENTRADA is null,0,1) '+
                        '   ) Desc, '+
                        '   PR.ALIQ_ENTRADA desc,'+
                        '   PR.'+cCST_CSOSN+' desc,'+
                        '   PR.CFOP_ENTRADA desc,'+
                        '   PR.ORIGEM_ENTRADA desc'
                        ;
      Query.Open;

      if not Query.IsEmpty then
      begin
        vDataSet.FieldByName('IDPERFILTRIBUTACAO').AsString      := Query.FieldByName('IDPERFILTRIBUTACAO').AsString;
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
