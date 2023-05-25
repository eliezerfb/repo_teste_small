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
    IBQIcm, IBQIcmItem: TIBQuery;
    procedure CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
    procedure CalculaFCP(NotaFiscal: TVENDAS; oItem: TITENS001);
    procedure CalculaImpostos;
    function AliqICMdoCliente(oItem: TITENS001): Double;
  public
    Calculando: Boolean;
    procedure CalculaValores(DataSetNF, DataSetItens: TibDataSet);
    constructor Create; Override;
    destructor Destroy; Override;
  end;

implementation

uses Unit7, Mais, uFuncoesFiscais, StrUtils;

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
  if NFeFinalidadeComplemento(NotaFiscal.Finnfe) = False then // Complemento
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
    NotaFiscal.VFCPST     := 0;
  end;

  fFCPRetido            := 0;


  IBQProduto := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);


  if NFeFinalidadeComplemento(NotaFiscal.Finnfe) then // Complemento
  begin

  end
  else
  // Sandro Silva 2023-05-18 if NotaFiscal.Finnfe = '4' then // Devolucao Devolução
  if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) then // Devolucao Devolução
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
        NotaFiscal.VFCPST     := NotaFiscal.VFCPST     + Arredonda(oItem.VFCPST,2);
        {Sandro Silva 2023-05-25 inicio}
        //if oItem.Icm = 0.00 then
        //begin
          if (oItem.Vicms > 0.00) and (oItem.Vbc > 0.00) then
            oItem.Icm := Arredonda((oItem.Vicms / oItem.Vbc) * 100, 2);  // Descobre o percentual de ICMS
        //end;
        {Sandro Silva 2023-05-25 fim}

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
      IBQProduto.DisableControls;
      IBQProduto.UniDirectional := True;
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

              oItem.Vbc             := oItem.Vbc + Arredonda((oItem.TOTAL * oItem.BASE / 100 ),2);
              oItem.Vicms           := oItem.Vicms + Arredonda(( (oItem.TOTAL) * oItem.BASE / 100 *  oItem.ICM / 100 ),2);
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
            // Sandro Silva 2023-05-23 NotaFiscal.Ipi := NotaFiscal.Ipi + Arredonda2((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2);
            oItem.Vipi := Arredonda2((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2);
            NotaFiscal.Ipi := NotaFiscal.Ipi + oItem.Vipi;

            //if ((IBQIcmItem.FieldByname('SOBREIPI').AsString = 'S')) then
            if vIPISobreICMS then
            begin
              {Sandro Silva 2023-05-23 inicio
              NotaFiscal.Baseicm   := NotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2); //
              NotaFiscal.ICMS      := NotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post

              oItem.Vbc            := oItem.Vbc + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))),2); //
              oItem.Vicms          := oItem.Vicms + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);
              }
              NotaFiscal.Baseicm   := NotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))) * oItem.BASE / 100, 2); //
              NotaFiscal.ICMS      := NotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post


              oItem.Vbc            := oItem.Vbc + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))) * oItem.BASE / 100, 2); //
              oItem.Vicms          := oItem.Vicms + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);

              {Sandro Silva 2023-05-23 fim}
            end;
          end else
          begin
            vlFreteRateadoItem := 0;

            if vFreteSobreIPI then
              vlFreteRateadoItem := Arredonda((NotaFiscal.Frete / fTotalMercadoria) * oItem.TOTAL, 2);

            vlBalseIPI := oItem.TOTAL + vlFreteRateadoItem;

            // Sandro Silva 2023-05-23 NotaFiscal.IPI := NotaFiscal.Ipi + Arredonda2((vlBalseIPI * ( oItem.IPI / 100 )), 2);
            oItem.Vipi := Arredonda2((vlBalseIPI * ( oItem.IPI / 100 )), 2);
            NotaFiscal.IPI := NotaFiscal.Ipi + + oItem.Vipi;

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

                  oItem.Vbc           := oItem.Vbc + vlBalseICMSItem;
                  oItem.Vicms         := oItem.Vicms + vlICMSItem;
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

                      oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2); // Rateio desconto
                      oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2); // Acumula
                  oItem.Vicmsst         := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2);
                end else
                begin
                  if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                      oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
                  oItem.Vicmsst         := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2);
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

                  oItem.Vbc           := oItem.Vbc + vlBalseICMSItem;
                  oItem.Vicms         := oItem.Vicms + vlICMSItem;
                end;
              end;
            end;
          end;
        end;
        {Sandro Silva 2023-05-15 inicio}
        if (oItem.PFCPUFDEST <> 0) or (oItem.PICMSUFDEST <> 0) then
        begin
          if NotaFiscal.Finnfe <> '4' then // Não é Devolução
          begin
            oItem.PFCP   := 0.00;
            oItem.PFCPST := 0.00;
            oItem.VFCP   := 0.00;
            oItem.VFCPST := 0.00;
          end;
        end;
        {Sandro Silva 2023-05-15 fim}

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

            {Sandro Silva 2023-05-19 inicio}
            IBQProduto.Close;
            IBQProduto.DisableControls;
            IBQProduto.UniDirectional := True;
            IBQProduto.SQL.Text := ' Select * From ESTOQUE'+
                                   ' Where CODIGO='+QuotedStr(oItem.Codigo);
            IBQProduto.Open;
            {Sandro Silva 2023-05-19 fim}

            // Sandro Silva 2023-05-19 if not ( IBQProduto.FieldByName('PIVA').AsFloat > 0 ) or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='70') or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='10') or (IBQProduto.FieldByname('CSOSN').AsString = '900') then
            if not ( IBQProduto.FieldByName('PIVA').AsFloat > 0 )
                    or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='10')
                    or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='70')
                    or (Copy(IBQProduto.FieldByname('CST').AsString,2,2)='90') // Sandro Silva 2023-05-19
                    or (IBQProduto.FieldByname('CSOSN').AsString = '900')
                    then
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
    end; // for notafiscal.itens

  end;

  // Aqui já deve ter feito o rateio de despesas e acréscimos e aplicado nos itens da nota
  // Passa pelos itens da nota para calcular o FCP de cada um
  NotaFiscal.VFCPST := 0.00;  
  for i := 0 to NotaFiscal.Itens.Count -1 do
  begin
    oItem := NotaFiscal.Itens.GetItem(i);
    if oItem.QUANTIDADE <> 0 then
      CalculaFCP( NotaFiscal, oItem);
    NotaFiscal.VFCPST := NotaFiscal.VFCPST + Arredonda(oItem.VFCPST, 2); // Sandro Silva 2023-05-18      
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

function TNotaFiscalEletronicaCalc.AliqICMdoCliente(oItem : TITENS001): Double;
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
  IBQIcmItem.DisableControls;
  IBQIcmItem.SQL.Text := 'Select * From ICM';
  IBQIcmItem.Open;

  IBQIcm.Close;
  IBQIcm.DisableControls;
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
  fFCPDescontar: Real; // Armazena o valor do FCP para descontar do FCPST. Não usar oItem.FCP para não ser gravado no campo do banco
  fPercentualFCP: Real;
  fPercentualFCPST: Real;
//  fRateioDoDesconto: Real; // Sandro Silva 2023-05-18
  //fIPIPorUnidade: Real; // Sandro Silva 2023-05-18
  IBQProduto: TIBQuery;
  dVBCFCPST: Double; // Sandro Silva 2023-05-18
begin
  // fPercentualFCP
  fPercentualFCP   := oItem.PFCP; // DataSetNF.FieldByName('PFCPUFDEST').AsFloat;
  fPercentualFCPST := oItem.PFCPST; // fPercentualFCP; // tributos da NF-e

  IBQProduto := Form7.CriaIBQuery(IBQIcm.Transaction);

  IBQIcm.Locate('NOME', NotaFiscal.Operacao, []);

  try

    //Pega Info do Produto
    IBQProduto.Close;
    IBQProduto.SQL.Text := ' select '+
                           ' PIVA, '  +
                           '   ST, '+
                           '   CST_PIS_COFINS_SAIDA,'+
                           '   ALIQ_PIS_SAIDA,'+
                           '   ALIQ_COFINS_SAIDA,'+
                           '   TAGS_'+
                           ' from ESTOQUE'+
                           ' where DESCRICAO = '+QuotedStr(oItem.DESCRICAO);
    IBQProduto.Open;



    if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then // Não é Devolução
    begin
      oItem.VBCFCP   := oItem.Total;// Valor da Base de Cálculo do FCP
      oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP ST
      oItem.VFCP     := 0.00;// Valor da Base de Cálculo do FCP
      oItem.VFCPST   := 0.00; // Valor da Base de Cálculo do FCP ST
    end;

    if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
    begin

      dVBCFCPST := oItem.Vbcst;

      // Saída empresa no Regime normal por CST
      if Form1.sVersaoLayout = '4.00' then
      begin

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '00' then
        begin
          if fPercentualFCP <> 0 then
          begin
            //Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(oItem.PFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            //Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*oItem.PFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
            oItem.VBCFCP := oItem.Vbc;// Valor da Base de Cálculo do FCP
            oItem.VFCP   := oItem.Vbc * fPercentualFCP / 100; // Valor do Fundo de Combate à Pobreza (FCP)
          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '10' then
        begin
          if fPercentualFCP <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',',')));// Valor da Base de Cálculo do FCP
            Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(oItem.PFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*oItem.PFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
            }
            oItem.VBCFCP := oItem.Vbc;// Valor da Base de Cálculo do FCP
            oItem.vFCP   := oItem.Vbc * fPercentualFCP / 100; // Valor do Fundo de Combate à Pobreza (FCP)

          end;

          if fPercentualFCPST <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100) -(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',','))) ); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100) ); // Valor do FCP retido por Substituição Tributária
            end;
            }
            oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            {Sandro Silva 2023-05-18 inicio}
            // Calcula VBCFCPST da mesma forma que é calculado VBCST na geração do XML
            {Sandro Silva 2023-05-18 fim}

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              oItem.VFCPST  := (oItem.Vbcst * fPercentualFCPST / 100) - oItem.VFCP; // Valor do FCP retido por Substituição Tributária
            end else
            begin
              oItem.VFCPST  := (oItem.Vbcst * fPercentualFCPST / 100); // Valor do FCP retido por Substituição Tributária
            end;

          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '20' then
        begin
          if fPercentualFCP <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
            Form7.spdNFeDataSets.campo('pFCP_N17b').Value   := FormatFloatXML(oItem.PFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            Form7.spdNFeDataSets.campo('vFCP_N17c').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*oItem.PFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
            }
            oItem.VBCFCP := oItem.Vbc; // Valor da Base de Cálculo do FCP
            oItem.VFCP   := oItem.Vbc * fPercentualFCP / 100; // Valor do Fundo de Combate à Pobreza (FCP)
          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '30' then
        begin
          fFCPDescontar := 0.00;
          if fPercentualFCP <> 0 then
          begin
            fFCPDescontar := (oItem.Vbc * fPercentualFCP / 100);
          end;

          if fPercentualFCPST <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value   := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)-(fFCPDescontar)); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)); // Valor do FCP retido por Substituição Tributária
            end;
            }
            oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - (fFCPDescontar), 2); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
            end;
          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '51' then
        begin
          if fPercentualFCP <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
            Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(oItem.PFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*oItem.PFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
            }
            oItem.VBCFCP   := oItem.Vbc; // Valor da Base de Cálculo do FCP
            oItem.VFCP     := Arredonda(oItem.Vbc * fPercentualFCP / 100, 2); // Valor do Fundo de Combate à Pobreza (FCP)

          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '60' then
        begin
          //
          //                          Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
          //                          Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
          //                          Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
          //
        end;

        if (Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '70') or (Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '90') then
        begin
          if fPercentualFCP <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
            Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(oItem.PFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*oItem.PFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
            }
            oItem.VBCFCP   := oItem.Vbc; // Valor da Base de Cálculo do FCP
            // Sandro Silva 2023-05-11 oItem.PFCP     := oItem.PFCP; // Percentual do Fundo de Combate à Pobreza (FCP)
            oItem.VFCP     := Arredonda(oItem.Vbc * fPercentualFCP / 100, 2); // Valor do Fundo de Combate à Pobreza (FCP)

          end;

          if fPercentualFCPST <> 0 then
          begin
            {
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)-(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',',')))); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)); // Valor do FCP retido por Substituição Tributária
            end;
            }
            oItem.VBCFCPST  := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - oItem.VFCP, 2); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100), 2); // Valor do FCP retido por Substituição Tributária
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

      if Form1.sVersaoLayout = '4.00' then
      begin
        try
          //fFCPDescontar := (DataSetNF.FieldByName('BASE').AsFloat * (DataSetNF.FieldByName('TOTAL').AsFloat + fSomaNaBase )/100)*oItem.PFCP/100;
         fFCPDescontar := (oItem.Vbc * fPercentualFCP / 100);

          if oItem.Csosn = '201' then
          begin
            // oItem.PFCPST
            {
            if oItem.PFCPST <> 0 then
            begin
              Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)-(fFCPDescontar)); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)); // Valor do FCP retido por Substituição Tributária
              end;
            end;
            }
            if fPercentualFCPST <> 0 then
            begin
              oItem.VBCFCPST  := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - fFCPDescontar, 2); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100), 2); // Valor do FCP retido por Substituição Tributária
              end;
            end;
          end;

          if (oItem.Csosn = '202') or (oItem.Csosn = '203') then
          begin
            // oItem.PFCPST
            {
            if oItem.PFCPST <> 0 then
            begin
              Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)-(fFCPDescontar)); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)); // Valor do FCP retido por Substituição Tributária
              end;
            end;
            }
            if fPercentualFCPST <> 0 then
            begin
              oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - (fFCPDescontar), 2); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
              end;
            end;

          end;

          if (oItem.CSOSN = '500') then
          begin
  //                            Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
  //                            Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
  //                            Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
          end;

          // NOTA DEVOLUCAO D E V
          if (oItem.CSOSN = '900') then
          begin
            try
              // oItem.PFCPST
              {
              if oItem.PFCPST <> 0 then
              begin
                Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
                Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(oItem.PFCPST); // Percentual do FCP retido por Substituição Tributária

                if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
                begin
                  Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)-(fFCPDescontar)); // Valor do FCP retido por Substituição Tributária
                end else
                begin
                  Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*oItem.PFCPST/100)); // Valor do FCP retido por Substituição Tributária
                end;
              end;
              }
              if fPercentualFCPST <> 0 then
              begin
                oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

                if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'RJ') then
                begin
                  oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - fFCPDescontar, 2); // Valor do FCP retido por Substituição Tributária
                end else
                begin
                  oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
                end;
              end;
            except
              on E: Exception do
              begin
                Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900' + chr(10) + oItem.Descricao),'Atenção',mb_Ok + MB_ICONWARNING);
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.' + chr(10) + oItem.Descricao),'Atenção',mb_Ok + MB_ICONWARNING);
          end;
        end;
      end;

      // Final TAGS saída por CSOSN - CRT = 1 imples Nacional
    end;

  finally
    FreeAndNil(IBQProduto);
  end;
end;

end.
