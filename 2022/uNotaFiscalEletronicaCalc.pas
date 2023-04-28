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
    IBQIcm, IBQIcmItem : TIBQuery;
    procedure CalculaCstPisCofins(DataSetNF, DataSetItens : TibDataSet);
    procedure CalculaFCP(NotaFiscal: TVENDAS; oItem : TITENS001);
    procedure CalculaImpostos;
    function AliqICMdoCliente(oItem : TITENS001): double;
  public
    Calculando : Boolean;
    procedure CalculaValores(DataSetNF, DataSetItens : TibDataSet);
    constructor Create; Override;
    destructor Destroy; Override;
  end;

implementation

uses Unit7, Mais, uFuncoesFiscais;


procedure TNotaFiscalEletronicaCalc.CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
var
  IBQProduto: TIBQuery;

  sCST_PIS_COFINS: String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;

  //CIT campo ST
  sCST_PIS_COFINS_ITEM: String;
  rpPIS_ITEM, rpCOFINS_ITEM, bcPISCOFINS_op_ITEM : Real;

  vBC_PISCOFINS, vRaterioDesconto : Real;

  oItem : TITENS001;
  i : integer;
begin
  IBQProduto := Form7.CriaIBQuery(DataSetNF.Transaction);

  IBQIcm.Locate('NOME',NotaFiscal.Operacao,[]);

  sCST_PIS_COFINS := IBQIcm.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := IBQIcm.FieldByname('PPIS').AsFloat;
  rpCOFINS        := IBQIcm.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := IBQIcm.FieldByname('BCPISCOFINS').AsFloat;

  //Atualiza Item por Item
  for i := 0 to NotaFiscal.Itens.Count -1 do
  begin
    oItem := NotaFiscal.Itens.GetItem(i);
    //Começa usando configurações da nota
    sCST_PIS_COFINS_ITEM := sCST_PIS_COFINS;
    rpPIS_ITEM           := rpPIS;
    rpCOFINS_ITEM        := rpCOFINS;
    bcPISCOFINS_op_ITEM  := bcPISCOFINS_op;

    //Pega Info do Produto
    IBQProduto.Close;
    IBQProduto.SQL.Text := ' Select '+
                           '   ST, '+
                           '   CST_PIS_COFINS_SAIDA,'+
                           '   ALIQ_PIS_SAIDA,'+
                           '   ALIQ_COFINS_SAIDA,'+
                           '   TAGS_'+
                           ' From ESTOQUE'+
                           ' Where DESCRICAO = '+QuotedStr(oItem.DESCRICAO);
    IBQProduto.Open;

    //Raterio Desconto
    if NotaFiscal.Desconto <> 0 then
      vRaterioDesconto := Arredonda((NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL),2)
    else
      vRaterioDesconto := 0;

    //Verifica se tem CIT e CST_PIS_COFINS da operação principal não estiver preenchido
    if (IBQProduto.FieldByName('ST').AsString <> '')
      and (sCST_PIS_COFINS = '') then
    begin
      IBQIcm.Locate('ST',IBQProduto.FieldByName('ST').AsString,[]);

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
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then  // A tag BCPISCOFINS está preenchida
          begin
            oItem.VBC_PIS_COFINS := StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',IBQProduto.FieldByname('TAGS_').AsString)));
          end else
          begin
            oItem.VBC_PIS_COFINS := oItem.TOTAL - vRaterioDesconto - oItem.VICMS;
          end;
        end;
      end else
      begin
        if Trim(IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString) = '' then
          oItem.CST_PIS_COFINS  := '08'// Codigo de Situacao Tributária - ver opções no Manual
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
      oItem.VBC_PIS_COFINS  := oItem.Quantidade; // Valor da Base de Cálculo
    end;
  end;

  FreeAndNil(IBQProduto);
end;


procedure TNotaFiscalEletronicaCalc.CalculaImpostos;
var
  fFCP, fPercentualFCP, fPercentualFCPST, fTotalMercadoria, fRateioDoDesconto, fIPIPorUnidade, fSomaNaBase, TotalBASE, TotalICMS : Real;
  sreg, sEstado : String;
  tInicio : tTime;
  Hora, Min, Seg, cent: Word;

  vlBalseIPI, vlFreteRateadoItem : Double;
  vlBalseICMSItem, vlICMSItem : Double;
  vFreteSobreIPI, vIPISobreICMS : Boolean;
  vSobreOutras : Boolean;

  fFCPRetido : Real;

  IBQProduto: TIBQuery;

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

  fFCPRetido            := 0;

  IBQProduto := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);

  if NotaFiscal.Finnfe = '4' then // Devolucao Devolução
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

    //Mauricio Parizotto 2023-03-28
    //Não usa CIT
    IBQIcm.Locate('NOME',NotaFiscal.Operacao,[]);

    vFreteSobreIPI := IBQIcm.FieldByName('FRETESOBREIPI').AsString = 'S';
    vIPISobreICMS  := IBQIcm.FieldByName('SOBREIPI').AsString = 'S';
    vSobreOutras   := IBQIcm.FieldByName('SOBREOUTRAS').AsString = 'S';

    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);

      //Zera Valores Itens
      oItem.Vbc     := 0;
      oItem.Vicms   := 0;
      oItem.Vbcst   := 0;
      oItem.Vicmsst := 0;
      
      IBQProduto.Close;
      IBQProduto.SQL.Text := ' Select * From ESTOQUE'+
                             ' Where CODIGO='+QuotedStr(oItem.Codigo);
      IBQProduto.Open;

      try
        if NotaFiscal.Desconto <> 0 then
          fRateioDoDesconto  := Arredonda((NotaFiscal.Desconto / fTotalMErcadoria * oItem.Total),2)
        else
          fRateioDoDesconto := 0;
      except
        fRateioDoDesconto := 0;
      end;

      //CIT
      if AllTrim(IBQProduto.FieldByName('ST').AsString) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
      begin
        // Nova rotina para posicionar na tabéla de CFOP
        IBQIcmItem.Locate('ST',IBQProduto.FieldByName('ST').AsString,[]);

        if IBQIcmItem.FieldByName('ST').AsString <> IBQProduto.FieldByName('ST').AsString then
        begin
          IBQIcmItem.Locate('NOME',NotaFiscal.Operacao,[]);
        end;
      end else
      begin
        IBQIcmItem.Locate('NOME',NotaFiscal.Operacao,[]);
      end;

      if oItem.Quantidade <> 0 then
      begin
        NotaFiscal.Pesoliqui := NotaFiscal.Pesoliqui + oItem.Peso * oItem.Quantidade;

        if (Pos(Alltrim(oItem.Cfop),Form1.CFOP5124) = 0) then// 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          NotaFiscal.Baseiss := NotaFiscal.Baseiss + (oItem.TOTAL * oItem.BASEISS / 100 );
          if oItem.BASE > 0 then
          begin
            // NOTA DEVOLUCAO D E V
            if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (IBQProduto.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByname('CSOSN').AsString = '900') ))
            or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                       (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '90')))
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

        // Soma o CFOP 5124 ou 6124 no TOTAL da nota mas não soma na MERCADORIA
        // 5124 Industrialização efetuada para outra empresa
        if (oItem.BASEISS <> 100) and (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then // 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          NotaFiscal.Mercadoria := NotaFiscal.Mercadoria + Arredonda(oItem.TOTAL,2);
        end;

        if (Copy(IBQIcmItem.FieldByname('CFOP').AsString,1,4) = '5101')
          or (Copy(IBQIcmItem.FieldByname('CFOP').AsString,1,4) = '6101')
          or (Pos('IPI',IBQIcmItem.FieldByname('OBS').AsString) <> 0) then
        begin
          // IPI
          {Mauricio Parizotto 2023-03-30 Inicio}
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then
          begin
            NotaFiscal.Ipi := NotaFiscal.Ipi + Arredonda2((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2);

            //if ((IBQIcmItem.FieldByname('SOBREIPI').AsString = 'S')) then
            if vIPISobreICMS then
            begin
              NotaFiscal.Baseicm   := NotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2); //
              NotaFiscal.ICMS      := NotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post

              oItem.Vbc             := oItem.Vbc + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2); //
              oItem.Vicms           := oItem.Vicms + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);
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
              if IBQProduto.FieldByName('PIVA').AsFloat > 0 then
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (IBQProduto.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByname('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '90')))
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
                if AliqICMdoCliente(oItem) <= IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  //
                  if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2); // Rateio desconto
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.FieldByname('PIVA').AsFloat),2); // Acumula

                      oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2); // Rateio desconto
                      oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
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
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                      oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); 
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst            := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst          := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); 
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
                  oItem.Vicmsst          := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); 
                end;
              end else
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (IBQProduto.FieldByname('CSOSN').AsString = '900') or (IBQIcm.FieldByName('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '90')))
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
             (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '10') or
             (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '30') or
             (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '70') or
             (Copy(LimpaNumero(IBQProduto.FieldByname('CST').AsString)+'000',2,2) = '90')
            )
           ) or
           (
            (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) = '1') and
            (
             (IBQProduto.FieldByname('CSOSN').AsString = '900')                           or
             (IBQProduto.FieldByname('CSOSN').AsString = '201')                           or
             (IBQProduto.FieldByname('CSOSN').AsString = '202')                           or
             (IBQProduto.FieldByname('CSOSN').AsString = '203')
            )
           ) then
        begin
          // 1 - Simples nacional
          // 2 - Simples nacional - Excesso de Sublimite de Receita Bruta
          // 3 - Regime normal
          //
          // Fundo de combate a pobresa Retido deve somar no total da nota

          if (oItem.PFCPUFDEST <> 0) or (oItem.PICMSUFDEST <> 0) then
          begin
            // Quando preenche na nota não vai nada nessas tags
            fPercentualFCP := 0;
            fPercentualFCPST := 0;
          end else
          begin
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',IBQProduto.FieldByname('TAGS_').AsString))); // tributos da NF-e
            end else
            begin
              fPercentualFCP := 0;
            end;

            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',IBQProduto.FieldByname('TAGS_').AsString))); // tributos da NF-e 16 AfterPost
            end else
            begin
              fPercentualFCPST := 0;
            end;
          end;

          if fPercentualFCP <> 0 then
          begin
            fFCP       := Arredonda((oItem.TOTAL*fPercentualFCP/100),2); // Valor do Fundo de Combate à Pobreza (FCP)
          end else
          begin
            fFCP       := 0;
          end;

          oItem.PFCP   := fPercentualFCP;
          oItem.PFCPST := fPercentualFCPST;
          oItem.VFCP   := fFCP;

          if fPercentualFCPST <> 0 then
          begin
            if (UpperCase(Form7.ibDataSet2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              //fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * IBQProduto.FieldByname('PIVA').AsFloat * fPercentualFCPST / 100),2))-fFCP); // Valor do Fundo de Combate à Pobreza (FCP)
              oItem.VFCPST := Arredonda((oItem.TOTAL * IBQProduto.FieldByname('PIVA').AsFloat * fPercentualFCPST / 100), 2) - fFCP;
            end else
            begin
              //fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * IBQProduto.FieldByname('PIVA').AsFloat * fPercentualFCPST / 100),2))); // Valor do Fundo de Combate à Pobreza (FCP)
              oItem.VFCPST := Arredonda( (oItem.TOTAL * IBQProduto.FieldByname('PIVA').AsFloat * fPercentualFCPST / 100), 2);
            end;
            fFCPRetido := (fFCPRetido + oItem.VFCPST); // Valor do Fundo de Combate à Pobreza (FCP)
          end;

          // FCP - Fundo de Combate a Pobresa
        end;

        // SUBSTITUIÇÃO TRIBUTÁRIA
        try
          if IBQProduto.FieldByname('PIVA').AsFloat > 0 then
          begin
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))));
            end;

            // CALCULO DO IVA
            if AliqICMdoCliente(oItem) <= IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
              begin
                // VINICULAS
                try
                  NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                        (((
                        (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                  oItem.Vbcst := oItem.Vbcst + Arredonda((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  oItem.Vicmsst := oItem.Vicmsst + Arredonda(
                        (((
                        (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);
                except
                  on E: Exception do
                  begin
                    Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'no calculo do ICMS substituição. Verifique o valor da tag <BCST> Erro: 16687'
                    ),'Atenção',mb_Ok + MB_ICONWARNING);
                  end;
                end;
              end else
              begin
                NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti +
                    ((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                     * oItem.BASE / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    ((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2); // Não pode arredondar aqui

                oItem.Vbcst := Arredonda(oItem.Vbcst+
                ((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                 * oItem.BASE / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    ((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2); // Não pode arredondar aqui
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
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                      (((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                  oItem.Vbcst := Arredonda((oItem.Vbcst+
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                      (((
                      (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                except
                end;
              end else
              begin
                NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                    oItem.BASE / 100 * IBQProduto.fieldByName('PIVA').AsFloat),2);

                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* IBQProduto.fieldByName('PIVA').AsFloat ),2);

                oItem.Vbcst := Arredonda((oItem.Vbcst+
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                    oItem.BASE / 100 * IBQProduto.fieldByName('PIVA').AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* IBQProduto.fieldByName('PIVA').AsFloat ),2);
              end;

              // Desconta do ICMS substituido o ICMS normal
              NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((
                  ((oItem.TOTAL-fRateioDoDesconto)
                  )) * oItem.BASE / 100 *   IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula

              oItem.Vicmsst := Arredonda(oItem.Vicmsst - ((
                  ((oItem.TOTAL-fRateioDoDesconto)
                  )) * oItem.BASE / 100 *   IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
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
        if (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then// 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          if oItem.BASE > 0 then
          begin
            if not ( IBQProduto.FieldByName('PIVA').AsFloat > 0 ) or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='70') or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='10') or (IBQProduto.FieldByname('CSOSN').AsString = '900') then
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
                    fSomaNaBase  := fSomanaBase + (NotaFiscal.Frete / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor Total do Frete

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
                    fSomaNaBase  := fSomanaBase + (NotaFiscal.Seguro / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando valor do Seguro

                // Soma na base de calculo
                if vSobreOutras then
                begin
                  if NotaFiscal.Despesas <> 0 then
                    if (NotaFiscal.Despesas / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                      fSomaNaBase  := fSomanaBase + (NotaFiscal.Despesas / NotaFiscal.MERCADORIA * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor de outras
                end;

                if NotaFiscal.Desconto <> 0 then
                  if (NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase - (NotaFiscal.Desconto / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor do frete descontando

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

  FreeAndNil(IBQProduto);

  // Particularidades do calculo do total do ICMS
  {Sem uso aparente
  Mauricio Parizotto 2023-04-19
  Eliminar no futuro

  try
    // Verifica se pode usar tributação interestadual
    if UpperCase(Copy(Form7.ibDataSet2IE.AsString,1,2)) = 'PR' then // Quando é produtor rural não precisa ter CGC
    begin
      sEstado := Form7.ibDataSet2ESTADO.AsString;
      if AllTrim(Form7.ibDataSet2CGC.AsString) = '' then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString); // Quando é produtor rural tem que ter CPF
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
var
  sReg16 : string;
begin
  if not Calculando then
  begin
    try
      Calculando := True;
      sReg16 := DataSetItens.fieldByName('REGISTRO').AsString;

      AtualizaValoresNota(DataSetNF, DataSetItens);

      //Calcula Impostos
      CalculaImpostos;

      //Calcula CST PIS COFINS
      CalculaCstPisCofins(DataSetNF, DataSetItens);

      AtualizaDataSetNota(DataSetNF,DataSetItens);

      if Trim(sReg16) <> '' then
        DataSetItens.Locate('REGISTRO', sReg16, []);
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

constructor TNotaFiscalEletronicaCalc.Create;
begin
  inherited;
  IBQIcmItem := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);
  IBQIcm     := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);

  IBQIcmItem.Close;
  IBQIcmItem.SQL.Text := 'Select * From ICM';
  IBQIcmItem.Open;

  IBQIcm.Close;
  IBQIcm.SQL.Text := 'Select * From ICM';
  IBQIcm.Open;
end;

destructor TNotaFiscalEletronicaCalc.Destroy;
begin
  FreeAndNil(IBQIcmItem);
  FreeAndNil(IBQIcm);
  inherited;
end;

procedure TNotaFiscalEletronicaCalc.CalculaFCP(NotaFiscal: TVENDAS;
  oItem : TITENS001);
var
  fPercentualFCPST, fPercentualFCP: Real;
begin
  // fPercentualFCP
  {
  if (DataSetNF.FieldByName('PFCPUFDEST').AsFloat <> 0) or (DataSetNF.FieldByName('PICMSUFDEST').AsFloat <> 0) then
  begin
    // Quando preenche na nota não vai nada nessas tags
    fPercentualFCP := 0; // DataSetNF.FieldByName('PFCPUFDEST').AsFloat;
    fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e
  end else
  begin
    // Quando nao esta preenchido da nota pega valores nas tags
    if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
    begin
      fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
    end else
    begin
      fPercentualFCP := 0;
    end;

    // fPercentualFCPST
    if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
    begin
      fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
    end else
    begin
      fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e
    end;
  end;
  }

  fPercentualFCP   := oItem.PFCP; // DataSetNF.FieldByName('PFCPUFDEST').AsFloat;
  fPercentualFCPST := oItem.PFCPST; // fPercentualFCP; // tributos da NF-e

  if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
  begin

    // Saída empresa no Regime normal por CST
    if Form1.sVersaoLayout = '4.00' then
    begin

      if oItem.Cst_icms = '00' then
      begin
        if fPercentualFCP <> 0 then
        begin
          //Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          //Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
          oItem.VFCP := FormatFloatXML(oItem.Vbc * fPercentualFCP / 100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;

      if oItem.Cst_icms = '10' then
      begin
        if fPercentualFCP <> 0 then
        begin
          {
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',',')));// Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
          }
          oItem.VBCFCP := FormatFloatXML(oItem.Vbc);// Valor da Base de Cálculo do FCP
          oItem.vFCP   := FormatFloatXML(oItem.Vbc * fPercentualFCP / 100); // Valor do Fundo de Combate à Pobreza (FCP)

        end;

        if fPercentualFCPST <> 0 then
        begin
          {
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100) -(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',','))) ); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100) ); // Valor do FCP retido por Substituição Tributária
          end;
          }
          oItem.VBCFCPST  := FormatFloatXML(oItem.Vbcst); // Valor da Base de Cálculo do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            oItem.VBCFCPST  := FormatFloatXML((oItem.Vbcst * fPercentualFCPST / 100) - oItem.VFCP); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            oItem.VBCFCPST  := FormatFloatXML((oItem.Vbcst * fPercentualFCPST / 100)); // Valor do FCP retido por Substituição Tributária
          end;

        end;
      end;

      if oItem.Cst_icms = '20' then
      begin
        if fPercentualFCP <> 0 then
        begin
          {
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value   := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
          }
          oItem.VBCFCP := FormatFloatXML(oItem.Vbcst); // Valor da Base de Cálculo do FCP
          oItem.PFCP   := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          oItem.VFCP   := FormatFloatXML(oItem.Vbcst * fPercentualFCP / 100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;
aqui
      if oItem.Cst_icms = '30' then
      begin
        if fPercentualFCP <> 0 then
        begin
          fCalculo := (DataSetNF.FieldByName('BASE').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase )/100)*fPercentualFCP/100;
        end;

        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value   := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(fCalculo)); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
          end;
        end;
      end;

      if oItem.Cst_icms = '51' then
      begin
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;

      if oItem.Cst_icms = '60' then
      begin
        //
//                          Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
//                          Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
//                          Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;

      if (oItem.Cst_icms = '70') or (oItem.Cst_icms = '90') then
      begin
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',',')))); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
          end;
        end;
      end;
    end;
    // final TAGS saaída por CST - CRT 2 ou 3 - Regime normal
  end;


  if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1') then
  begin
    ///////////////////////////////
    //
    // Início TAGS saída por CSOSN - CRT = 1 imples Nacional
    //
    ///////////////////////////////

    //
    // TAGS - Simples NAcional - CSOSN
    //
    // N12a Tem em todas - e eé referencia para classificar as tags
    //
    {Sandro Silva 2022-11-11 inicio
    // Posiciona na tabéla de CFOP
    //
    if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
    begin
      //
      sReg := Form7.ibDataSet14REGISTRO.AsString;
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      Form7.ibDataSet14.Open;
      if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
        Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
      Form7.ibDataSet14.EnableControls;
      //
      if not (AllTrim(Form7.ibDataSet14.FieldByName('CSOSN').AsString) <> '') then
      begin
        //
        Form7.ibDataSet14.DisableControls;
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Clear;
        Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
        Form7.ibDataSet14.Open;
        Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
        Form7.ibDataSet14.EnableControls;
        //
      end;
      //
    end else
    begin
      //
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      Form7.ibDataSet14.Open;
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
      Form7.ibDataSet14.EnableControls;
      //
    end;
    //
    if AllTrim(Form7.ibDataSet14.FieldByName('CSOSN').AsString) <> '' then
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value  := Form7.ibDataSet14.FieldByname('CSOSN').AsString;
    end else
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value  := Form7.ibDataSet4.FieldByname('CSOSN').AsString;
    end;
    //
    // N11 - Tem em todas
    //
    try
      if AllTrim(Form7.ibDataSet14.FieldByName('CST').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      end else
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      end;
    except
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := '0';
    end;
    }
    ItemNFe := TItemNFe.Create;
    CsosnComOrigemdoProdutoNaOperacao(Form7.ibDataSet4.FieldByName('CODIGO').AsString, Form7.ibDataSet15OPERACAO.AsString, ItemNFe);
    Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value := ItemNFe.CSOSN;

    // N11 - Tem em todas
    Form7.spdNFeDataSets.Campo('orig_N11').Value   := ItemNFe.Origem;
    FreeAndNil(ItemNFe);
    {Sandro Silva 2022-11-11 fim}

    {Sandro Silva 2022-10-04 inicio}
    // Sandro Silva 2022-11-11 AtualizaItens001CSOSN(Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value);
    {Sandro Silva 2022-10-04 fim}
    //
    if  (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '101') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '102') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '103') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '201') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '202') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '203') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '300') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '400') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '500') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '900') then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: Informe o CSOSN do produto '+ConverteAcentos2(Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);
      Abort;
    end;
            
    // CSOSN 101
    if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '101' then
    begin
      // 101 Tributada pelo simples nacional com permissão de credito
      if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
      begin
        // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
        try
          fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
        except
          fAliquota := 2.82;
        end;
      end else
      begin
        // fAliquota := 2.82;
        fAliquota := 0;
      end;

      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue      := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue  := FormatFloatXML(((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
    end;
    // CSOSN 102, 103, 300, 400
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '102')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '103')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '300')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '400') then
    begin
      // N11 - Já esta preenchido acima todos tem
    end;

    // CSOSN 201 - Tributado pelo Simples Nacional Com permissão de Crédito e com cobrança do ICMS por substituição Tributária
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201') then
    begin
      //
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if DataSetNF.FieldByName('BASE').AsFloat > 0 then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;

      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if DataSetNF.FieldByName('BASE').AsFloat > 0 then
      begin
        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          try
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (DataSetNF.FieldByName('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;
                      
              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                  Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end;
          except
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o IVA do produto código: '+Form7.ibDataSet4CODIGO.AsString;
            Abort;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(DataSetNF.FieldByName('TOTAL').AsFloat); // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Arredonda((Form7.AliqICMdoCliente16()*DataSetNF.FieldByName('TOTAL').AsFloat/100),2) ); // Valor do ICMS ST em Reais
        end;
      end;

      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue     := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue := FormatFloatXML(((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
    end;

    // CSOSN 202, 203 -
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
    begin
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if DataSetNF.FieldByName('BASE').AsFloat > 0 then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if DataSetNF.FieldByName('BASE').AsFloat > 0 then
      begin
        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          try
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (DataSetNF.FieldByName('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            // Valor da Base de Calculo de ISMS St do item
            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(((
                (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(((
                (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;
              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                  Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end;
          except
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o IVA do produto código: '+Form7.ibDataSet4CODIGO.AsString;
            Abort;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(DataSetNF.FieldByName('TOTAL').AsFloat); // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Arredonda((Form7.AliqICMdoCliente16()*DataSetNF.FieldByName('TOTAL').AsFloat/100),2) ); // Valor do ICMS ST em Reais
        end;
      end;

      if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
      begin
        // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
        try
          fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
        except
          fAliquota := 2.82;
        end;
      end else
      begin
        // fAliquota := 2.82;
        fAliquota := 0;
      end;

      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
    end;

    // CSOSN 500
    if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') then
    begin
      if Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1' then
      begin
        Form7.spdNFeDataSets.campo('pRedBCEfet_N34').Value      := FormatFloatXML(100-Form7.ibDataSet14BASE.AsFloat);                                                                                              // Percentual de redução da base de cálculo efetiva
        Form7.spdNFeDataSets.campo('vBCEfet_N35').Value         := FormatFloatXML(((DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100));                              // Valor da base de cálculo efetiva
        Form7.spdNFeDataSets.campo('pICMSEfet_N36').Value       := FormatFloatXML(Form7.AliqICMdoCliente16());                                                                                                         // Alíquota do ICMS efetiva
        Form7.spdNFeDataSets.campo('vICMSEfet_N37').Value       := FormatFloatXML(Form7.AliqICMdoCliente16()*(((DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100))/100); // Valor do ICMS efetivo
      end else
      begin
        // Procura pela última compra deste item
        Form7.ibQuery1.Close;
        Form7.ibQuery1.Sql.Clear;
        Form7.ibQuery1.Sql.Add('select first 1 ITENS002.CODIGO, ITENS002.QUANTIDADE, ITENS002.VBCST, ITENS002.VICMSST from ITENS002, COMPRAS where ITENS002.NUMERONF = COMPRAS.NUMERONF and Coalesce(ITENS002.VICMSST,0)<>0 and ITENS002.CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by COMPRAS.EMISSAO desc');
        Form7.ibQuery1.Open;

        if Form7.ibQuery1.FieldByname('VICMSST').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('pST_N26a').Value              := FormatFloatXML((Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('VBCST').AsFloat)*100);  // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := FormatFloatXML(Form7.ibQuery1.FieldByname('VBCST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * DataSetNF.FieldByName('QUANTIDADE.AsFloat);  // Valor do BC do ICMS ST retido na UF Emitente ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := FormatFloatXML(Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * DataSetNF.FieldByName('QUANTIDADE.AsFloat);  //  Valor do ICMS ST retido na UF Emitente
        end else
        begin
          Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST Ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
        end;
      end;
    end;

    // CSOSN 900
    // NOTA DEVOLUCAO D E V
    if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') then
    begin
      // 900 – Outros – Classificam-se neste código as demais operações que não se enquadrem nos códigos 101, 102, 103, 201, 202, 203, 300, 400 e 500.
      //
      // N11 - Já está preenchido acima - todos tem
      // N12a - Já está preenchido acima - todos tem
      try
        Form7.spdNFeDataSets.Campo('modBC_N13').Value  := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

        if (DataSetNF.FieldByName('BASE').AsFloat = 0) then
        begin
          Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
        end else
        begin
          if (DataSetNF.FieldByName('BASE').AsFloat = 0) then
          begin
            Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
            Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
          end else
          begin
            Form7.spdNFeDataSets.Campo('vBC_N15').Value     := FormatFloatXML(DataSetNF.FieldByName('BASE').AsFloat*(DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase )/100);  // BC
            Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := FormatFloatXML(DataSetNF.FieldByName('ICM').AsFloat*(DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase )/100*DataSetNF.FieldByName('BASE').AsFloat/100);     // Valor do ICMS em Reais
          end;
        end;

        if (100-DataSetNF.FieldByName('BASE').AsFloat) <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-DataSetNF.FieldByName('BASE').AsFloat); // Percentual da redução de BC
        end;

        Form7.spdNFeDataSets.Campo('pICMS_N16').Value   := FormatFloatXML(DataSetNF.FieldByName('ICM').AsFloat); // Alíquota do ICMS em Percentual

        Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          if DataSetNF.FieldByName('BASE').AsFloat > 0 then
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
          end else
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
        Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          if DataSetNF.FieldByName('BASE').AsFloat > 0 then
          begin
            // Posiciona na tabéla de CFOP
            if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
            begin
              sReg := Form7.ibDataSet14REGISTRO.AsString;
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
              Form7.ibDataSet14.Open;
              if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
              Form7.ibDataSet14.EnableControls;
            end else
            begin
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
              Form7.ibDataSet14.Open;
              Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
              Form7.ibDataSet14.EnableControls;
            end;

            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (DataSetNF.FieldByName('IPI').AsFloat>0) then
            begin
              // IPI Por Unidade
              fIPIPorUnidade := 0;
              if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                fIPIPorUnidade := (DataSetNF.FieldByName('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
              end;

              // Valor da Base de Calculo de ISMS St do item
              Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', ((
              (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) +  fIPIPorUnidade)
              +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
              )
               * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat) )),',','.'); // Valor da B ST

              // Desconta o ICM sobre IPI normal do ST   CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((
                (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) +(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100))
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat),2)
                 -((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))+(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100)) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100) // Desconta o ICMS Normal
                 ),2))),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((
                (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))+(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100))
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat),2)
                 -((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))+(DataSetNF.FieldByName('IPI').AsFloat * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100)
                 ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) // Desconta o ICMS Normal
                ),2))),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              // IPI Por Unidade
              fIPIPorUnidade := 0;
              if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                fIPIPorUnidade := (DataSetNF.FieldByName('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
              end;
              // Valor da Base de Calculo de ISMS St do item
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * DataSetNF.FieldByName('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Desconta o ICM sobre IPI normal do ST    CALCULO DO IVA
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((
                  (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (DataSetNF.FieldByName('IPI').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )
                  ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((
                  ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (DataSetNF.FieldByName('IPI').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                  ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2))),',','.'); // Valor do ICMS ST em Reais
                end else
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',
                  Arredonda(
                  ((
                  (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (DataSetNF.FieldByName('IPI').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *
                  Form7.AliqICMdoCliente16()
                   / 100 ) * Form7.ibDataSet4PIVA.AsFloat,2)
                  -
                  Arredonda(
                  ((
                  (((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (DataSetNF.FieldByName('IPI').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )) * DataSetNF.FieldByName('BASE').AsFloat / 100 *
                  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat
                   / 100 ),2)
                  )),',','.'); // Valor do ICMS ST em Reais
                end;
              end else
              begin
                if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
                end else
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * DataSetNF.FieldByName('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
                end;
              end;
            end;
          end else
          begin
            Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := '0'; // Valor da B ST
            Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := '0';
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := '0'; // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := '0';  // Valor do ICMS ST em Reais
        end;

        if Form7.spdNFeDataSets.Campo('vICMSST_N23').Value <> '0' then // Mudei 11/05/2022
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
        end else
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := '0';       // Alíquota do ICMS em Percentual
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0.00';   // Percentual de margem de valor adicionado do ICMS ST
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '0.00';  // Percentual de redução de BC do ICMS ST
        end;

        if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
        begin
          // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
          try
            fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
          except
            fAliquota := 2.82;
          end;
        end else
        begin
          fAliquota := 0;
        end;

        try
          Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue       := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
          Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue   := FormatFloatXML(((DataSetNF.FieldByName('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
        except
        end;
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao calcular FCP.'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
        end;
      end;
    end;

    if Form1.sVersaoLayout = '4.00' then
    begin
      try
        fCalculo := (DataSetNF.FieldByName('BASE').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase )/100)*fPercentualFCP/100;

        if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201' then
        begin
          // fPercentualFCPST
          if fPercentualFCPST <> 0 then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(fCalculo)); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
            end;
          end;
        end;

        if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
        begin
          // fPercentualFCPST
          if fPercentualFCPST <> 0 then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(fCalculo)); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
            end;
          end;
        end;

        if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') then
        begin
//                            Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
//                            Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
//                            Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
        end;

        // NOTA DEVOLUCAO D E V
        if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') then
        begin
          try
            // fPercentualFCPST
            if fPercentualFCPST <> 0 then
            begin
              Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(fCalculo)); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
              end;
            end;
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900'),'Atenção',mb_Ok + MB_ICONWARNING);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao calcular FCP 2.'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
        end;
      end;
    end;

    // Final TAGS saída por CSOSN - CRT = 1 imples Nacional
  end;

end;

end.
