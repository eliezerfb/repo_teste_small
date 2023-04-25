unit uNotaFiscalEletronicaCalc;

interface

uses
  Dialogs, Classes, SysUtils, SmallFunc,
  IBDatabase, IBCustomDataSet, IBTable, IBQuery, IBDatabaseInfo, IBServices,
  Forms, Windows,DB,
  Controls, Contnrs, uNotaFiscalEletronica;

type
  TNotaFiscalEletronicaCalc = class(TNotaFiscalEletronica)
  private
    procedure CalculaCstPisCofins(DataSetNF, DataSetItens : TibDataSet);
    procedure CalculaImpostos;
    function AliqICMdoCliente(oItem : TITENS001): double;
  public
    Calculando : Boolean;
    procedure CalculaValores(DataSetNF, DataSetItens : TibDataSet);
  end;

implementation

uses Unit7, Mais, uFuncoesFiscais;


procedure TNotaFiscalEletronicaCalc.CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
var
  IBQIcm, IBQProduto: TIBQuery;

  sCST_PIS_COFINS: String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;

  //CIT campo ST
  sCST_PIS_COFINS_ITEM: String;
  rpPIS_ITEM, rpCOFINS_ITEM, bcPISCOFINS_op_ITEM : Real;

  vBC_PISCOFINS, vRaterioDesconto : Real;

  oItem : TITENS001;
  i : integer;
begin
  IBQIcm := Form7.CriaIBQuery(DataSetNF.Transaction);
  IBQProduto := Form7.CriaIBQuery(DataSetNF.Transaction);

  IBQIcm.Close;
  IBQIcm.SQL.Text := ' Select *'+
                      ' From ICM '+
                      ' Where NOME = '+QuotedStr(NotaFiscal.Operacao);
  IBQIcm.Open;

  sCST_PIS_COFINS := IBQIcm.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := IBQIcm.FieldByname('PPIS').AsFloat;
  rpCOFINS        := IBQIcm.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := IBQIcm.FieldByname('BCPISCOFINS').AsFloat;

  //Atualiza Item por Item
  for i := 0 to NotaFiscal.Itens.Count -1 do
  begin
    oItem := NotaFiscal.Itens.GetItem(i);
    //Come�a usando configura��es da nota
    sCST_PIS_COFINS_ITEM := sCST_PIS_COFINS;
    rpPIS_ITEM           := rpPIS;
    rpCOFINS_ITEM        := rpCOFINS;
    bcPISCOFINS_op_ITEM  := bcPISCOFINS_op;

    //Pega Info do Produto
    IBQProduto.Close;
    IBQProduto.SQL.Text := ' Select * '+
                           ' From ESTOQUE'+
                           ' Where DESCRICAO = '+QuotedStr(oItem.DESCRICAO);
    IBQProduto.Open;

    //Raterio Desconto
    if NotaFiscal.Desconto <> 0 then
      vRaterioDesconto := Arredonda((NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL),2)
    else
      vRaterioDesconto := 0;

    //Verifica se tem CIT e CST_PIS_COFINS da opera��o principal n�o estiver preenchido
    if (IBQProduto.FieldByName('ST').AsString <> '')
      and (sCST_PIS_COFINS = '') then
    begin
      IBQIcm.Close;
      IBQIcm.SQL.Text := ' Select *'+
                         ' From ICM '+
                         ' Where ST = '+QuotedStr(IBQProduto.FieldByName('ST').AsString);
      IBQIcm.Open;
                         
      if not IBQIcm.IsEmpty then
      begin
        sCST_PIS_COFINS_ITEM := IBQIcm.FieldByname('CSTPISCOFINS').AsString;
        rpPIS_ITEM           := IBQIcm.FieldByname('PPIS').AsFloat;
        rpCOFINS_ITEM        := IBQIcm.FieldByname('PCOFINS').AsFloat;
        bcPISCOFINS_op_ITEM  := IBQIcm.FieldByname('BCPISCOFINS').AsFloat;
      end;
    end;

    if Alltrim(sCST_PIS_COFINS_ITEM) <> '' then
    begin
      oItem.CST_PIS_COFINS  := sCST_PIS_COFINS_ITEM;
      oItem.ALIQ_PIS        := rpPIS_ITEM;
      oItem.ALIQ_COFINS     := rpCOFINS_ITEM;
      vBC_PISCOFINS         := 0;

      if (rpPIS_ITEM * bcPISCOFINS_op_ITEM <> 0) then
      begin
        vBC_PISCOFINS := oItem.TOTAL - vRaterioDesconto - oItem.VICMS;

        //Base Reduzida
        vBC_PISCOFINS := vBC_PISCOFINS * (bcPISCOFINS_op_ITEM / 100);
      end;

      oItem.VBC_PIS_COFINS := vBC_PISCOFINS;
    end else
    begin
      if (IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat <> 0) then
      begin
        oItem.CST_PIS_COFINS  := IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString;
        oItem.ALIQ_PIS        := IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat;
        oItem.ALIQ_COFINS     := IBQProduto.FieldByname('ALIQ_COFINS_SAIDA').AsFloat;

        // Pega o CST PIS COFINS e o PERCENTUAL do iten
        if Copy(IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString,1,2) <> '03' then
        begin
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then  // A tag BCPISCOFINS est� preenchida
          begin
            oItem.VBC_PIS_COFINS := StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',Form7.ibDataSet4.FieldByname('TAGS_').AsString)));
          end else
          begin
            oItem.VBC_PIS_COFINS := oItem.TOTAL - vRaterioDesconto - oItem.VICMS;
          end;
        end;
      end else
      begin
        if Trim(IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString) = '' then
          oItem.CST_PIS_COFINS  := '08'// Codigo de Situacao Tribut�ria - ver op��es no Manual
        else
          oItem.CST_PIS_COFINS := IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString;


        oItem.ALIQ_PIS        := 0;
        oItem.ALIQ_COFINS     := 0;
        oItem.VBC_PIS_COFINS  := 0;
      end;
    end;

    // Pis/Cofins por unidade
    if oItem.CST_PIS_COFINS = '03' then
    begin
      oItem.VBC_PIS_COFINS  := oItem.Quantidade; // Valor da Base de C�lculo
    end;
  end;

  FreeAndNil(IBQIcm);
  FreeAndNil(IBQProduto);
end;


procedure TNotaFiscalEletronicaCalc.CalculaImpostos;
var
  fFCP, fPercentualFCP, fPercentualFCPST, fTotalMercadoria, fRateioDoDesconto, fIPIPorUnidade, fSomaNaBase, TotalBASE, TotalICMS : Real;
  sreg, sReg4, sEstado : String;
  tInicio : tTime;
  Hora, Min, Seg, cent: Word;

  vlBalseIPI, vlFreteRateadoItem : Double;
  vlBalseICMSItem, vlICMSItem : Double;
  vFreteSobreIPI, vIPISobreICMS : Boolean;
  vSobreOutras : Boolean;

  fFCPRetido : Real;

  IBQIcm : TIBQuery;

  oItem : TITENS001;
  i : integer;
begin
  //Zera Valores Nota
  NotaFiscal.Mercadoria := 0;
  NotaFiscal.Baseicm    := 0;
  NotaFiscal.Baseiss    := 0;
  NotaFiscal.Icms       := 0;
  NotaFiscal.Ipi        := 0;
  NotaFiscal.Iss        := 0;
  NotaFiscal.Pesoliqui  := 0;
  NotaFiscal.Basesubsti := 0;
  NotaFiscal.Icmssubsti := 0;
  fFCPRetido  := 0;

  sReg4  := Form7.ibDataSet4REGISTRO.AsString;
  IBQIcm := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);
  IBQIcm.Close;
  IBQIcm.SQL.Text := ' Select *'+
                     ' From ICM '+
                     ' Where NOME = '+QuotedStr(NotaFiscal.Operacao);
  IBQIcm.Open;


  if NotaFiscal.Finnfe = '4' then // Devolucao Devolu��o
  begin
    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);

      if oItem.Quantidade <> 0 then
      begin
        NotaFiscal.Mercadoria := NotaFiscal.Mercadoria + Arredonda(oItem.Total,2);
        NotaFiscal.Baseicm    := NotaFiscal.Baseicm    + Arredonda(oItem.Vbc,2);
        NotaFiscal.Icms       := NotaFiscal.Icms       + Arredonda(oItem.Vicms,2);
        NotaFiscal.Ipi        := NotaFiscal.Ipi        + Arredonda(oItem.Vipi,2);
        NotaFiscal.Icmssubsti := NotaFiscal.Icmssubsti + Arredonda(oItem.Vicmsst,2);
        NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda(oItem.Vbcst,2);
        NotaFiscal.Pesoliqui  := NotaFiscal.Pesoliqui  + oItem.Peso * oItem.Quantidade;
      end;
    end;
  end else
  begin
    //Mauricio Parizotto 2023-04-03
    fTotalMercadoria := GetTotalMercadoria;

    //Mauricio Parizotto 2023-03-28 - Melhorar depois
    //N�o usa CIT
    vFreteSobreIPI := CampoICMporNatureza('FRETESOBREIPI',NotaFiscal.Operacao ,Form7.ibDataSet15.Transaction) = 'S';
    vIPISobreICMS  := CampoICMporNatureza('SOBREIPI',NotaFiscal.Operacao,Form7.ibDataSet15.Transaction) = 'S';
    vSobreOutras   := CampoICMporNatureza('SOBREOUTRAS',NotaFiscal.Operacao,Form7.ibDataSet15.Transaction) = 'S';

    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);

      //Zera Valores Itens
      oItem.Vbc     := 0;
      oItem.Vicms   := 0;
      oItem.Vbcst   := 0;
      oItem.Vicmsst := 0;
      
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(oItem.Codigo)+' ');  //
      Form7.ibDataSet4.Open;

      try
        if NotaFiscal.Desconto <> 0 then
          fRateioDoDesconto  := Arredonda((NotaFiscal.Desconto / fTotalMErcadoria * oItem.Total),2)
        else
          fRateioDoDesconto := 0;
      except
        fRateioDoDesconto := 0;
      end;

      if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar tamb�m retributa Ok 1/ Abril
      begin
        // Nova rotina para posicionar na tab�la de CFOP
        Form7.IBQuery14.Close;
        Form7.IBQuery14.SQL.Clear;
        Form7.IBQuery14.SQL.Add('select * from ICM where ST='+QuotedStr(Form7.ibDataSet4ST.AsString)+''); // Nova rotina
        Form7.IBQuery14.Open;

        if Form7.IBQuery14.FieldByName('ST').AsString <> Form7.ibDataSet4ST.AsString then
        begin
          Form7.IBQuery14.Close;
          Form7.IBQuery14.SQL.Clear;
          Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(NotaFiscal.Operacao)+' ');
          Form7.IBQuery14.Open;
        end;
      end else
      begin
        Form7.IBQuery14.Close;
        Form7.IBQuery14.SQL.Clear;
        Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(NotaFiscal.Operacao)+' ');
        Form7.IBQuery14.Open;
      end;

      if oItem.Quantidade <> 0 then
      begin
        NotaFiscal.Pesoliqui := NotaFiscal.Pesoliqui + oItem.Peso * oItem.Quantidade;

        if (Pos(Alltrim(oItem.Cfop),Form1.CFOP5124) = 0) then// 5124 Industrializa��o efetuada para outra empresa n�o soma na base
        begin
          NotaFiscal.Baseiss := NotaFiscal.Baseiss + (oItem.TOTAL * oItem.BASEISS / 100 );
          if oItem.BASE > 0 then
          begin
            // NOTA DEVOLUCAO D E V
            if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByname('CSOSN').AsString = '900') ))
            or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
            then
            begin
              NotaFiscal.Baseicm    := NotaFiscal.Baseicm  + Arredonda((oItem.TOTAL * oItem.BASE / 100 ),2);
              NotaFiscal.Icms       := NotaFiscal.Icms     + Arredonda(( (oItem.TOTAL) * oItem.BASE / 100 *  oItem.ICM / 100 ),2); // Acumula em 16 After post

              oItem.Vbc              := oItem.Vbc + Arredonda((oItem.TOTAL * oItem.BASE / 100 ),2);
              oItem.Vicms            := oItem.Vicms + Arredonda(( (oItem.TOTAL) * oItem.BASE / 100 *  oItem.ICM / 100 ),2);
            end;
          end;

          NotaFiscal.Iss := NotaFiscal.Iss  + ( oItem.TOTAL * oItem.ISS / 100 );
        end;

        // Soma o CFOP 5124 ou 6124 no TOTAL da nota mas n�o soma na MERCADORIA
        // 5124 Industrializa��o efetuada para outra empresa
        if (oItem.BASEISS <> 100) and (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then // 5124 Industrializa��o efetuada para outra empresa n�o soma na base
        begin
          NotaFiscal.Mercadoria := NotaFiscal.Mercadoria + Arredonda(oItem.TOTAL,2);
        end;

        if (Copy(Form7.ibQuery14.FieldByname('CFOP').AsString,1,4) = '5101')
          or (Copy(Form7.ibQuery14.FieldByname('CFOP').AsString,1,4) = '6101')
          or (Pos('IPI',Form7.ibQuery14.FieldByname('OBS').AsString) <> 0) then
        begin
          // IPI
          {Mauricio Parizotto 2023-03-30 Inicio}
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
          begin
            NotaFiscal.Ipi := NotaFiscal.Ipi + Arredonda2((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2);

            //if ((Form7.ibQuery14.FieldByname('SOBREIPI').AsString = 'S')) then
            if vIPISobreICMS then
            begin
              NotaFiscal.Baseicm   := NotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2); //
              NotaFiscal.ICMS      := NotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post

              oItem.Vbc             := oItem.Vbc + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2); //
              oItem.Vicms           := oItem.Vicms + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);
            end;
          end else
          begin
            vlFreteRateadoItem := 0;

            if vFreteSobreIPI then
              vlFreteRateadoItem := Arredonda((NotaFiscal.Frete / fTotalMercadoria)
                                               * oItem.TOTAL,2);

            vlBalseIPI := oItem.TOTAL + vlFreteRateadoItem;

            NotaFiscal.IPI := NotaFiscal.Ipi + Arredonda2((vlBalseIPI * ( oItem.IPI / 100 )),2);

            {NotaFiscal.IPI.Value         := NotaFiscal.IPI.Value +
                                 Arredonda2((oItem.QUANTIDADE').Asfloat *
                                 oItem.UNITARIO').AsFloat   *
                                 ( oItem.IPI').Value / 100 )),2); // 450 Valor IPI do item Uso o int para arredondar 2 casas}

            {Mauricio Parizotto 2023-03-30 Fim}
          end;

          // Calcula o ICM
          if (vIPISobreICMS) and (oItem.IPI<>0) then
          begin
            if oItem.BASE > 0 then
            begin
              if Form7.ibDataSet4PIVA.AsFloat > 0 then
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByname('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
                then
                begin
                  vlBalseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  NotaFiscal.Baseicm  := NotaFiscal.Baseicm + vlBalseICMSItem;
                  NotaFiscal.Icms     := NotaFiscal.Icms    + vlICMSItem;

                  oItem.Vbc            := oItem.Vbc + vlBalseICMSItem;
                  oItem.Vicms          := oItem.Vicms + vlICMSItem;
                end;

                // CALCULO DO IVA
                if AliqICMdoCliente(oItem) <= Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  //
                  if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2); // Rateio desconto
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula

                      oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2); // Rateio desconto
                      oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2);
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula

                    oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2);
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2); // Acumula
                  oItem.Vicmsst          := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2);
                end else
                begin
                  if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula

                      oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                      oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * Form7.ibDataset4PIVA.AsFloat),2); 
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula

                    oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * Form7.ibDataset4PIVA.AsFloat),2); 
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
                  oItem.Vicmsst          := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); 
                end;
              end else
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByName('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
                then
                begin
                  vlBalseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  NotaFiscal.Baseicm  := NotaFiscal.Baseicm    + vlBalseICMSItem;
                  NotaFiscal.Icms     := NotaFiscal.Icms       + vlICMSItem;

                  oItem.Vbc            := oItem.Vbc + vlBalseICMSItem;
                  oItem.Vicms          := oItem.Vicms + vlICMSItem;
                end;
              end;
            end;
          end;
        end;

        // Fundo de combate a pobresa
        if (
            (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) <> '0') and
            (
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '30') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')
            )
           ) or
           (
            (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) = '1') and
            (
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '201')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '202')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '203')
            )
           ) then
        begin
          // 1 - Simples nacional
          // 2 - Simples nacional - Excesso de Sublimite de Receita Bruta
          // 3 - Regime normal
          //
          // Fundo de combate a pobresa Retido deve somar no total da nota
          //
          // ShowMessage('CRT: '+LimpaNumero(ibDAtaset13.FieldByname('CRT').AsString)+chr(10)+
          //             'CST: '+LimpaNumero(ibDataSet4.FieldByname('CST').AsString)+Chr(10)+
          //             'CSOSN: '+ibDataSet4.FieldByname('CSOSN').AsString);
          // <FCP>


          if (oItem.PFCPUFDEST <> 0) or (oItem.PICMSUFDEST <> 0) then
          begin
            // Quando preenche na nota n�o vai nada nessas tags
            fPercentualFCP := 0;
            fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
          end else
          begin
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
            end else
            begin
              fPercentualFCP := 0;
            end;

            // fPercentualFCPST 16 AfterPost
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e 16 AfterPost
            end else
            begin
              fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
            end;
          end;

          if fPercentualFCP <> 0 then
          begin
            fFCP       := Arredonda((oItem.TOTAL*fPercentualFCP/100),2); // Valor do Fundo de Combate � Pobreza (FCP)
          end else
          begin
            fFCP       := 0;
          end;

          if fPercentualFCPST <> 0 then
          begin
            if (UpperCase(Form7.ibDataSet2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * Form7.ibDataSet4PIVA.AsFloat * fPercentualFCPST / 100),2))-fFCP); // Valor do Fundo de Combate � Pobreza (FCP)
            end else
            begin
              fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * Form7.ibDataSet4PIVA.AsFloat * fPercentualFCPST / 100),2))); // Valor do Fundo de Combate � Pobreza (FCP)
            end;
          end;

          // FCP - Fundo de Combate a Pobresa
        end;

        // SUBSTITUI��O TRIBUT�RIA
        try
          if Form7.ibDataSet4PIVA.AsFloat > 0 then
          begin
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            // CALCULO DO IVA
            if AliqICMdoCliente(oItem) <= Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
              begin
                // VINICULAS
                try
                  NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                        (((
                        (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);

                  oItem.Vbcst := oItem.Vbcst + Arredonda((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2);

                  oItem.Vicmsst := oItem.Vicmsst + Arredonda(
                        (((
                        (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);
                except
                  on E: Exception do
                  begin
                    Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'no calculo do ICMS substitui��o. Verifique o valor da tag <BCST> Erro: 16687'
                    ),'Aten��o',mb_Ok + MB_ICONWARNING);
                  end;
                end;
              end else
              begin
                NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti +
                    ((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                     * oItem.BASE / 100 * Form7.ibDataSet4PIVA.AsFloat),2);

                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    ((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2); // N�o pode arredondar aqui

                oItem.Vbcst := Arredonda(oItem.Vbcst+
                ((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                 * oItem.BASE / 100 * Form7.ibDataSet4PIVA.AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    ((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2); // N�o pode arredondar aqui
              end;

              // Desconta do ICMS substituido o ICMS normal
              NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - (((oItem.TOTAL-fRateioDoDesconto) ) * oItem.BASE / 100 *  AliqICMdoCliente(oItem) / 100 ),2); // Acumula
              oItem.Vicmsst          := Arredonda(oItem.Vicmsst - (((oItem.TOTAL-fRateioDoDesconto) ) * oItem.BASE / 100 *  AliqICMdoCliente(oItem) / 100 ),2); 
            end else
            begin
              if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
              begin
                // VINICULAS
                try
                  NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibDataset4PIVA.AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                      (((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);

                  oItem.Vbcst := Arredonda((oItem.Vbcst+
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * Form7.ibDataset4PIVA.AsFloat),2);

                  oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                      (((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);

                except
                end;
              end else
              begin
                NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                    oItem.BASE / 100 * Form7.ibDataset4PIVA.AsFloat),2);

                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);

                oItem.Vbcst := Arredonda((oItem.Vbcst+
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                    oItem.BASE / 100 * Form7.ibDataset4PIVA.AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);
              end;

              // Desconta do ICMS substituido o ICMS normal
              NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((
                  ((oItem.TOTAL-fRateioDoDesconto)
                  )) * oItem.BASE / 100 *   Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula

              oItem.Vicmsst := Arredonda(oItem.Vicmsst - ((
                  ((oItem.TOTAL-fRateioDoDesconto)
                  )) * oItem.BASE / 100 *   Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
            end;
          end;
        except
        end;
      end;
    end;

    // Passa novamente para calcular frete desconto outras
    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);
      if oItem.QUANTIDADE <> 0 then
      begin
        if (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then// 5124 Industrializa��o efetuada para outra empresa n�o soma na base
        begin
          if oItem.BASE > 0 then
          begin
            if not ( Form7.ibDataSet4PIVA.AsFloat > 0 ) or (Copy(Form7.ibDataSet4.FieldByname('CST').AsString,2,2)='70') or (Copy(Form7.ibDataSet4.FieldByname('CST').AsString,2,2)='10') or (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') then
            begin
              if (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) <> '1')
              or (Copy(oItem.CFOP,2,3) = '201')
              or (Copy(oItem.CFOP,2,3) = '202')
              or (Copy(oItem.CFOP,2,3) = '411') then
              begin
                fSomaNaBase := 0;

                //Soma o Frete no ICMS
                if NotaFiscal.Frete <> 0 then
                begin
                  if (NotaFiscal.Frete / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase + (NotaFiscal.Frete / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TR�S ratiando o valor Total do Frete

                  //Frete Sobre IPI e IPI sobre ICMS
                  if (vFreteSobreIPI) and (vIPISobreICMS) then
                  begin
                    vlFreteRateadoItem := Arredonda((NotaFiscal.Frete / fTotalMercadoria)
                                                     * oItem.TOTAL,2);

                    fSomaNaBase := fSomaNaBase + Arredonda2((vlFreteRateadoItem * ( oItem.IPI / 100 )),2);
                  end;
                end;

                if NotaFiscal.Seguro   <> 0 then
                  if (NotaFiscal.Seguro / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase + (NotaFiscal.Seguro / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TR�S ratiando valor do Seguro

                // Soma na base de calculo
                if vSobreOutras then
                begin
                  if NotaFiscal.Despesas <> 0 then
                    if (NotaFiscal.Despesas / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                      fSomaNaBase  := fSomanaBase + (NotaFiscal.Despesas / NotaFiscal.MERCADORIA * oItem.TOTAL); // REGRA DE TR�S ratiando o valor de outras
                end;

                if NotaFiscal.Desconto <> 0 then
                  if (NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase - (NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TR�S ratiando o valor do frete descontando

                NotaFiscal.Baseicm := NotaFiscal.Baseicm + Arredonda((oItem.BASE*fSomaNaBase/100),2);
                NotaFiscal.Icms    := NotaFiscal.Icms    + Arredonda(((oItem.BASE*fSomaNaBase/100) * oItem.ICM / 100 ),2); // Acumula

                oItem.Vbc          := oItem.Vbc + Arredonda((oItem.BASE*fSomaNaBase/100),2);
                oItem.Vicms        := oItem.Vicms + Arredonda(((oItem.BASE*fSomaNaBase/100) * oItem.ICM / 100 ),2);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  Form7.ibDataSet4.Locate('REGISTRO',sReg4,[]);

  FreeAndNil(IBQIcm);

  // Particularidades do calculo do total do ICMS
  {Sem uso aparente
  Mauricio Parizotto 2023-04-19
  Eliminar no futuro

  try
    // Verifica se pode usar tributa��o interestadual
    if UpperCase(Copy(Form7.ibDataSet2IE.AsString,1,2)) = 'PR' then // Quando � produtor rural n�o precisa ter CGC
    begin
      sEstado := Form7.ibDataSet2ESTADO.AsString;
      if AllTrim(Form7.ibDataSet2CGC.AsString) = '' then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString); // Quando � produtor rural tem que ter CPF
    end else
    begin
      if AllTrim((Limpanumero(Form7.ibDataSet2IE.AsString))) <> '' then
        sEstado := Form7.ibDataSet2ESTADO.AsString
      else
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);

      if not CpfCgc(LimpaNumero(Form7.ibDataSet2CGC.AsString)) then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);

      if Length(AllTrim(Form7.ibDataSet2CGC.AsString)) < 18 then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
    end;

    sEstado := Form7.ibDataSet2ESTADO.AsString;

    if Pos('1'+sEstado+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX2') = 0 then
      sEstado := 'MG';
  except
  end;
  }
end;


procedure TNotaFiscalEletronicaCalc.CalculaValores(DataSetNF, DataSetItens: TibDataSet);
begin
  if not Calculando then
  begin
    try
      Calculando := True;
      AtualizaValoresNota(DataSetNF, DataSetItens);

      //Calcula Impostos
      CalculaImpostos;

      //Calcula CST PIS COFINS
      CalculaCstPisCofins(DataSetNF, DataSetItens);

      AtualizaDataSetNota(DataSetNF,DataSetItens);
    finally
      Calculando := False;
    end;
  end;
end;


// A PEDIDO DO
// VANDERLEI PERETI
// FONES: 49 35664136 / 91427178
// EMAIL: comercial@vpinformatica.com.br

function TNotaFiscalEletronicaCalc.AliqICMdoCliente(oItem : TITENS001): double;
begin
  if Form1.fAliqICMdoCliente <> 0 then
  begin
    if Form7.ibDataSet13ESTADO.AsString =  Form7.ibDataSet2ESTADO.AsString then
    begin
      Result :=  Form1.fAliqICMdoCliente;
    end else
    begin
      Result := oItem.ICM;
    end;
  end else
  begin
    Result := oItem.ICM;
  end;
end;

end.
