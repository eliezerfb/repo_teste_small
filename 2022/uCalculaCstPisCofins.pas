unit uCalculaCstPisCofins;

interface

uses
  SysUtils
  , Classes
  , IniFiles
  , Forms
  , Controls
  , Windows
  , Dialogs
  , Math
  , DB
  , IBQuery
  , ShellApi
  , SpdNFeDataSets
  , spdXMLUtils
  , spdNFeType
  , spdNFe
  , spdType
  , SmallFunc
  , unit7
  , unit11
  , unit29
  , unit12
  , Mais
  ,ugeraxmlnfe,
  ibdatabase
;

  procedure CalculaCstPisCofins(vNatureza : string; Transacao : TIBTransaction);

implementation


procedure CalculaCstPisCofins(vNatureza : string; Transacao : TIBTransaction);//Mauricio Parizotto 2023-04-12
var
  IBQTemp, IBQProduto: TIBQuery;

  sCST_PIS_COFINS: String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;

  //CIT campo ST
  sCST_PIS_COFINS_ITEM: String;
  rpPIS_ITEM, rpCOFINS_ITEM, bcPISCOFINS_op_ITEM : Real;

  vBC_PISCOFINS, vRaterioDesconto : Real;
begin
  IBQTemp := Form7.CriaIBQuery(Transacao);
  IBQProduto := Form7.CriaIBQuery(Transacao);

  IBQTemp.Close;
  IBQTemp.SQL.Text := ' Select *'+
                      ' From ICM '+
                      ' Where NOME = '+QuotedStr(vNatureza);
  IBQTemp.Open;

  sCST_PIS_COFINS := IBQTemp.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := IBQTemp.FieldByname('PPIS').AsFloat;
  rpCOFINS        := IBQTemp.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := IBQTemp.FieldByname('BCPISCOFINS').AsFloat;

  //Atualiza Item por Item
  Form7.ibDataSet16.First;
  while not Form7.ibDataSet16.Eof do
  begin
    //Começa usando configurações da nota
    sCST_PIS_COFINS_ITEM := sCST_PIS_COFINS;
    rpPIS_ITEM           := rpPIS;
    rpCOFINS_ITEM        := rpCOFINS;
    bcPISCOFINS_op_ITEM  := bcPISCOFINS_op;

    //Pega Info do Produto
    IBQProduto.Close;
    IBQProduto.SQL.Text := ' Select * '+
                           ' From ESTOQUE'+
                           ' Where DESCRICAO = '+QuotedStr(Form7.ibDataSet16DESCRICAO.AsString);
    IBQProduto.Open;

    //Raterio Desconto
    if Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat <> 0 then
      vRaterioDesconto := Arredonda((Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2)
    else
      vRaterioDesconto := 0;

    //Verifica se tem CIT  
    if IBQProduto.FieldByName('ST').AsString <> '' then
    begin
      IBQTemp.Close;
      IBQTemp.SQL.Text := ' Select *'+
                          ' From ICM '+
                          ' Where ST = '+QuotedStr(IBQProduto.FieldByName('ST').AsString);
      IBQTemp.Open;
                         
      if not IBQTemp.IsEmpty then
      begin
        sCST_PIS_COFINS_ITEM := IBQTemp.FieldByname('CSTPISCOFINS').AsString;
        rpPIS_ITEM           := IBQTemp.FieldByname('PPIS').AsFloat;
        rpCOFINS_ITEM        := IBQTemp.FieldByname('PCOFINS').AsFloat;
        bcPISCOFINS_op_ITEM  := IBQTemp.FieldByname('BCPISCOFINS').AsFloat;
      end;
    end;

    Form7.ibDataSet16.Edit;

    if Alltrim(sCST_PIS_COFINS_ITEM) <> '' then
    begin
      Form7.ibDataSet16CST_PIS_COFINS.AsString := sCST_PIS_COFINS_ITEM;
      Form7.ibDataSet16ALIQ_PIS.AsFloat        := rpPIS_ITEM;
      Form7.ibDataSet16ALIQ_COFINS.AsFloat     := rpCOFINS_ITEM;

      if (rpPIS_ITEM * bcPISCOFINS_op_ITEM <> 0) then
      begin
        vBC_PISCOFINS := Form7.ibDataSet16TOTAL.AsFloat - vRaterioDesconto - Form7.ibDataSet15.FieldByname('ICMS').AsFloat;

        //Base Reduzida
        vBC_PISCOFINS := vBC_PISCOFINS * (bcPISCOFINS_op_ITEM / 100);
      end else
      begin
        vBC_PISCOFINS := 0;
      end;

      Form7.ibDataSet16VBC_PIS_COFINS.AsFloat  := vBC_PISCOFINS;
    end else
    begin
      if (IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat <> 0) then
      begin
        Form7.ibDataSet16CST_PIS_COFINS.AsString := IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString;

        // Pega o CST PIS COFINS e o PERCENTUAL do iten
        if Copy(IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString,1,2) = '03' then // Pis por unidade
        begin
          Form7.ibDataSet16VBC_PIS_COFINS.AsFloat     := Form7.ibDataSet16.FieldByname('TOTAL').AsFloat; // Valor da Base de Cálculo
          Form7.ibDataSet16ALIQ_PIS.AsFloat           := 0;
          Form7.ibDataSet16ALIQ_COFINS.AsFloat        := 0;
        end else
        begin
          Form7.ibDataSet16ALIQ_PIS.AsFloat        := IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat;
          Form7.ibDataSet16ALIQ_COFINS.AsFloat     := IBQProduto.FieldByname('ALIQ_COFINS_SAIDA').AsFloat;

          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then  // A tag BCPISCOFINS está preenchida
          begin
            Form7.ibDataSet16VBC_PIS_COFINS.AsFloat := StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',Form7.ibDataSet4.FieldByname('TAGS_').AsString)));
          end else
          begin
            Form7.ibDataSet16VBC_PIS_COFINS.AsFloat := Form7.ibDataSet16TOTAL.AsFloat - vRaterioDesconto - Form7.ibDataSet15.FieldByname('ICMS').AsFloat;
          end;
        end;
      end else
      begin
        Form7.ibDataSet16CST_PIS_COFINS.AsString := '08';// Codigo de Situacao Tributária - ver opções no Manual
        Form7.ibDataSet16ALIQ_PIS.AsFloat        := 0;
        Form7.ibDataSet16ALIQ_COFINS.AsFloat     := 0;
        Form7.ibDataSet16VBC_PIS_COFINS.AsFloat  := 0;
      end;
    end;

    Form7.ibDataSet16.Post;
    Form7.ibDataSet16.Next;
  end;

  FreeAndNil(IBQTemp);
  FreeAndNil(IBQProduto);
end;

end.
