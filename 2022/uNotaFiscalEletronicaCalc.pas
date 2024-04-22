unit uNotaFiscalEletronicaCalc;

interface

uses
  Dialogs, Classes, SysUtils, smallfunc_xe,
  IBDatabase, IBCustomDataSet, IBTable, IBQuery, IBDatabaseInfo, IBServices,
  Forms, Windows,DB,
  Controls, Contnrs, uNotaFiscalEletronica;

type
  TNotaFiscalEletronicaCalc = class(TNotaFiscalEletronica)
  private
    IBQIcm, IBQIcmItem: TIBQuery;
    procedure CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
    procedure CalculaFCP(NotaFiscal: TVENDAS; oItem: TITENS001);
    procedure CalculaImpostos(AbCalcPesoLiq : Boolean);
    procedure CalculaPesoLiquido;
    function AliqICMdoCliente(oItem: TITENS001): Double;
    procedure SetRateioDescAcre;
  public
    Calculando: Boolean;
    procedure CalculaValores(DataSetNF, DataSetItens: TibDataSet; CalcPesoLiq : Boolean = True);
    function RetornaObjetoNota(DataSetNF, DataSetItens: TibDataSet; CalcPesoLiq : Boolean = True): TVENDAS;
    constructor Create; Override;
    destructor Destroy; Override;
  end;

implementation

uses Unit7, Mais, uFuncoesFiscais, StrUtils, uDialogs;

procedure TNotaFiscalEletronicaCalc.CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
var
  IBQProduto: TIBQuery;

  sCST_PIS_COFINS: String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;

  //CIT campo ST
  sCST_PIS_COFINS_ITEM: String;
  rpPIS_ITEM, rpCOFINS_ITEM, bcPISCOFINS_op_ITEM : Real;

  vBC_PISCOFINS{, vRaterioDesconto} : Real;

  oItem : TITENS001;
  i : integer;

  bSobreLucro : boolean;
begin
  IBQProduto := Form7.CriaIBQuery(DataSetNF.Transaction);

  IBQIcm.Locate('NOME',NotaFiscal.Operacao,[]);

  sCST_PIS_COFINS := IBQIcm.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := IBQIcm.FieldByname('PPIS').AsFloat;
  rpCOFINS        := IBQIcm.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := IBQIcm.FieldByname('BCPISCOFINS').AsFloat;

  bSobreLucro     := IBQIcm.FieldByName('PISCOFINSLUCRO').AsString = 'S'; //Mauricio Parizotto 2024-03-28

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
                           //Mauricio Parizotto 2024-03-28
                           //'   TAGS_'+
                           '   TAGS_,'+
                           '   Coalesce(CUSTOCOMPR,0) CUSTO '+
                           ' From ESTOQUE'+
                           ' Where DESCRICAO = '+QuotedStr(oItem.DESCRICAO);
    IBQProduto.Open;

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
        vBC_PISCOFINS := oItem.TOTAL - oItem.DescontoRateado - oItem.VICMS + oItem.FreteRateado + oItem.DespesaRateado + oItem.SeguroRateado;

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
            oItem. VBC_PIS_COFINS := oItem.TOTAL - oItem.DescontoRateado - oItem.VICMS + oItem.FreteRateado + oItem.DespesaRateado + oItem.SeguroRateado;
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

    //Mauricio Parizotto 2024-03-28
    if bSobreLucro then
    begin
      oItem.VBC_PIS_COFINS  := (oItem.Total - IBQProduto.FieldByName('CUSTO').AsFloat) - oItem.DescontoRateado;
    end;

    // Pis/Cofins por unidade
    if oItem.CST_PIS_COFINS = '03' then
    begin
      oItem.VBC_PIS_COFINS  := oItem.Quantidade; // Valor da Base de Cálculo
    end;
  end;

  FreeAndNil(IBQProduto);
end;

procedure TNotaFiscalEletronicaCalc.CalculaImpostos(AbCalcPesoLiq : Boolean);
var
  fFCP, fPercentualFCP, fPercentualFCPST, fTotalMercadoria, {fRateioDoDesconto, }fIPIPorUnidade, fSomaNaBase, TotalBASE, TotalICMS : Real;
  sreg, sEstado : String;
  tInicio : tTime;
  Hora, Min, Seg, cent: Word;

  vlBaseIPI : Double;
  vlBaseICMSItem, vlICMSItem: Double;
  bIPISobreFrete, bIPISobreICMS: Boolean;
  bIPISobreOutras : Boolean;
  bSobreOutras : Boolean;

  fFCPRetido : Real;

  IBQProduto: TIBQuery;

  oItem : TITENS001;
  i : integer;
begin
  //Se não for complemento zera totais 
  if not NFeFinalidadeComplemento(NotaFiscal.Finnfe) then
  begin
    //Zera Valores Nota
    NotaFiscal.Mercadoria := 0;
    NotaFiscal.Baseicm    := 0;
    NotaFiscal.Baseiss    := 0;
    NotaFiscal.Icms       := 0;
    NotaFiscal.Ipi        := 0;
    NotaFiscal.Iss        := 0;

    { Dailon (f-7194) 2023-08-01 Inicio}
//    if AbCalcPesoLiq then
//      NotaFiscal.Pesoliqui  := 0;
    { Dailon (f-7194) 2023-08-01 Fim}

    NotaFiscal.Basesubsti := 0;
    NotaFiscal.Icmssubsti := 0;
    NotaFiscal.VFCPST     := 0;
  end;

  fFCPRetido            := 0;

  IBQProduto := Form7.CriaIBQuery(Form7.ibDataSet15.Transaction);

  if NFeFinalidadeComplemento(NotaFiscal.Finnfe) then // Complemento
  begin
    //Zera Valores Nota
    NotaFiscal.Mercadoria := 0;

    //Complemento de valor
    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);

      if Arredonda(oItem.Unitario,2) > Arredonda(0.01,2) then // 0.01 é complemento de icms ai não soma
        NotaFiscal.Mercadoria := NotaFiscal.Mercadoria + Arredonda(oItem.Total,2);
    end;
  end;
  {Mauricio Parizotto 2023-06-05 Fim}

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

        { Dailon (f-7194) 2023-08-01 Inicio}
        if AbCalcPesoLiq then
          CalculaPesoLiquido;
//          NotaFiscal.Pesoliqui  := NotaFiscal.Pesoliqui + (oItem.Peso * oItem.Quantidade);
        { Dailon (f-7194) 2023-08-01 Fim}

        NotaFiscal.VFCPST     := NotaFiscal.VFCPST     + Arredonda(oItem.VFCPST,2);
        {Sandro Silva 2023-05-25 inicio}
        //if oItem.Icm = 0.00 then
        //begin
        if (oItem.Vicms > 0.00) and (oItem.Vbc > 0.00) and (oItem.Icm <= 0) then
        begin
          // Descobre o percentual de ICMS
          //oItem.Icm := Arredonda((oItem.Vicms / oItem.Vbc) * 100, 2);
          //oItem.Icm := Arredonda((oItem.Vicms / oItem.Vbc) * 100, 1);  // Mauricio Parizotto 2023-08-14
          //se arredondando para 1 casa, gerar um valor de ,5 aceita esse valor, caso contrário arredonda sem casa decimal
          if AnsiContainsText(  FloatToStr(Arredonda((oItem.Vicms / oItem.Vbc) * 100, 1))  ,',5') then
            oItem.Icm := Arredonda((oItem.Vicms / oItem.Vbc) * 100, 1)
          else
            oItem.Icm := Arredonda((oItem.Vicms / oItem.Vbc) * 100, 0);
        end;
        //end;
        {Sandro Silva 2023-05-25 fim}

      end;
    end;
  end;

  if not(NFeFinalidadeDevolucao(NotaFiscal.Finnfe)) and not((NFeFinalidadeComplemento(NotaFiscal.Finnfe)))  then
  begin
    //Mauricio Parizotto 2023-04-03
    fTotalMercadoria := GetTotalMercadoria;

    //Mauricio Parizotto 2023-03-28
    //Não usa CIT
    IBQIcm.Locate('NOME',NotaFiscal.Operacao,[]);

    bIPISobreFrete  := IBQIcm.FieldByName('FRETESOBREIPI').AsString = 'S';
    bIPISobreICMS   := IBQIcm.FieldByName('SOBREIPI').AsString = 'S';
    bSobreOutras    := IBQIcm.FieldByName('SOBREOUTRAS').AsString = 'S';
    bIPISobreOutras := IBQIcm.FieldByName('IPISOBREOUTRA').AsString = 'S'; //Mauricio Parizotto 2024-04-22

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
        //NotaFiscal.Pesoliqui := NotaFiscal.Pesoliqui + oItem.Peso * oItem.Quantidade; Mauricio Parizotto 2023-06-26

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
            if bIPISobreICMS then
            begin
              NotaFiscal.Baseicm   := NotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))) * oItem.BASE / 100, 2); //
              NotaFiscal.ICMS      := NotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post

              oItem.Vbc            := oItem.Vbc + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString)))) * oItem.BASE / 100, 2); //
              oItem.Vicms          := oItem.Vicms + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',IBQProduto.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);
            end;
          end else
          begin
            vlBaseIPI := oItem.TOTAL;
            if bIPISobreFrete then
              vlBaseIPI := vlBaseIPI + oItem.FreteRateado;

            //Mauricio Parizotto 2024-04-22
            if bIPISobreOutras then
              vlBaseIPI := vlBaseIPI + oItem.DespesaRateado;

            oItem.Vipi := Arredonda2((vlBaseIPI * ( oItem.IPI / 100 )), 2);
            NotaFiscal.IPI := NotaFiscal.Ipi + + oItem.Vipi;
          end;

          // Calcula o ICM
          if (bIPISobreICMS) and (oItem.IPI<>0) then
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
                  vlBaseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  NotaFiscal.Baseicm  := NotaFiscal.Baseicm + vlBaseICMSItem;
                  NotaFiscal.Icms     := NotaFiscal.Icms    + vlICMSItem;

                  oItem.Vbc           := oItem.Vbc + vlBaseICMSItem;
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
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2); // Rateio desconto
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.FieldByname('PIVA').AsFloat),2); // Acumula

                      oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2); // Rateio desconto
                      oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                    except
                    end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2); // Acumula
                  oItem.Vicmsst         := Arredonda(oItem.Vicmsst         - ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100 ),2);
                end else
                begin
                  if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                      oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                      oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                    except end;
                  end else
                  begin
                    NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2); // Acumula

                    oItem.Vbcst           := Arredonda((oItem.Vbcst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100) * IBQProduto.fieldByName('PIVA').AsFloat ),2);
                    oItem.Vicmsst         := Arredonda((oItem.Vicmsst+ ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * AliqICMdoCliente(oItem) / 100) * IBQProduto.fieldByName('PIVA').AsFloat),2);
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula
                  oItem.Vicmsst         := Arredonda(oItem.Vicmsst - ((oItem.IPI * (oItem.TOTAL-oItem.DescontoRateado) / 100) * oItem.BASE / 100 * IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2);
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
                  vlBaseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  NotaFiscal.Baseicm  := NotaFiscal.Baseicm    + vlBaseICMSItem;
                  NotaFiscal.Icms     := NotaFiscal.Icms       + vlICMSItem;

                  oItem.Vbc           := oItem.Vbc + vlBaseICMSItem;
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
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                        (((
                        (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                  oItem.Vbcst := oItem.Vbcst + Arredonda((
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                       * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  oItem.Vicmsst := oItem.Vicmsst + Arredonda(
                        (((
                        (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                        ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                         *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);
                except
                  on E: Exception do
                  begin
                    MensagemSistema(E.Message+chr(10)+chr(10)+'no calculo do ICMS substituição. Verifique o valor da tag <BCST> Erro: 16687',msgErro);
                  end;
                end;
              end else
              begin
                NotaFiscal.Basesubsti := Arredonda(NotaFiscal.Basesubsti +
                    //((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                    ((oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                     * oItem.BASE / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                {Dailon 2023-07-31 inicio
                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    //((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ((oItem.TOTAL-oItem.DescontoRateado) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2); // Não pode arredondar aqui
                {Dailon 2023-07-31 fim}

                oItem.Vbcst := Arredonda(oItem.Vbcst+
                //((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                ((oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                 * oItem.BASE / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    //((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                    ((oItem.TOTAL-oItem.DescontoRateado) + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     *  IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2); // Não pode arredondar aqui
              end;

              // Desconta do ICMS substituido o ICMS normal
              oItem.Vicmsst          := Arredonda(oItem.Vicmsst        - (((oItem.TOTAL-oItem.DescontoRateado) ) * oItem.BASE / 100 *  AliqICMdoCliente(oItem) / 100 ),2);

              NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti + oItem.Vicmsst,2); // Acumula
            end else
            begin
              if pos('<BCST>',IBQIcm.FieldByName('OBS').AsString) <> 0 then
              begin
                // VINICULAS
                try
                  NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade) *
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                      (((
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                  oItem.Vbcst := Arredonda((oItem.Vbcst+
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade) *
                      StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100 * IBQProduto.FieldByname('PIVA').AsFloat),2);

                  oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                      (((
                      (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                      ) * StrToFloat(Copy(IBQIcm.FieldByName('OBS').AsString,pos('<BCST>',IBQIcm.FieldByName('OBS').AsString)+6,5)) / 100
                       * AliqICMdoCliente(oItem) / 100 )* IBQProduto.FieldByname('PIVA').AsFloat ),2);

                except
                end;
              end else
              begin
                NotaFiscal.Basesubsti := NotaFiscal.Basesubsti + Arredonda((
                    (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade) *
                    oItem.BASE / 100 * IBQProduto.fieldByName('PIVA').AsFloat),2);

                NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti +
                    (((
                    (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* IBQProduto.fieldByName('PIVA').AsFloat ),2);

                oItem.Vbcst := Arredonda((oItem.Vbcst+
                    (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade) *
                    oItem.BASE / 100 * IBQProduto.fieldByName('PIVA').AsFloat),2);

                oItem.Vicmsst := Arredonda(oItem.Vicmsst+
                    (((
                    (oItem.TOTAL-oItem.DescontoRateado + fIPIPorUnidade)
                    ) * oItem.BASE / 100
                     * AliqICMdoCliente(oItem) / 100 )* IBQProduto.fieldByName('PIVA').AsFloat ),2);
              end;

              // Desconta do ICMS substituido o ICMS normal
              NotaFiscal.Icmssubsti := Arredonda(NotaFiscal.Icmssubsti - ((
                  ((oItem.TOTAL-oItem.DescontoRateado)
                  )) * oItem.BASE / 100 *   IBQIcmItem.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula

              oItem.Vicmsst := Arredonda(oItem.Vicmsst - ((
                  ((oItem.TOTAL-oItem.DescontoRateado)
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
                  if (bIPISobreFrete) and (bIPISobreICMS) then
                  begin
                    fSomaNaBase := fSomaNaBase + Arredonda2((oItem.FreteRateado * ( oItem.IPI / 100 )),2);
                  end;
                end;

                {Mauricio Parizotto 2024-04-22 Inicio}
                //Soma Outras no ICMS
                if NotaFiscal.Despesas <> 0 then
                begin
                  if (NotaFiscal.Despesas / NotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase + (NotaFiscal.Despesas / NotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor Total do Despesas

                  //Outas Sobre IPI e IPI sobre ICMS
                  if (bIPISobreFrete) and (bIPISobreICMS) then
                  begin
                    fSomaNaBase := fSomaNaBase + Arredonda2((oItem.DespesaRateado * ( oItem.IPI / 100 )),2);
                  end;
                end;
                {Mauricio Parizotto 2024-04-22 Fim}

                fSomaNaBase  := fSomanaBase + oItem.SeguroRateado;

                // Soma na base de calculo
                if bSobreOutras then
                begin
                  fSomaNaBase  := fSomanaBase + oItem.DespesaRateado;
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
end;


procedure TNotaFiscalEletronicaCalc.CalculaValores(DataSetNF, DataSetItens: TibDataSet; CalcPesoLiq : Boolean = True);
var
  sReg16 : string;
begin
  if not Calculando then
  begin
    try
      Calculando := True;
      sReg16 := DataSetItens.fieldByName('REGISTRO').AsString;

      AtualizaValoresNota(DataSetNF, DataSetItens);

      //Faz Rateios dos Desconos e Acrecimos dos itens
      SetRateioDescAcre;

      //Calcula Impostos
      CalculaImpostos(CalcPesoLiq);

      //Calcula CST PIS COFINS
      CalculaCstPisCofins(DataSetNF, DataSetItens);

      //Calcula Peso Líquido
      if CalcPesoLiq then
        CalculaPesoLiquido;

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
            oItem.VBCFCP := oItem.Vbc;// Valor da Base de Cálculo do FCP
            oItem.vFCP   := oItem.Vbc * fPercentualFCP / 100; // Valor do Fundo de Combate à Pobreza (FCP)
          end;

          if fPercentualFCPST <> 0 then
          begin
            oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            {Sandro Silva 2023-05-18 inicio}
            // Calcula VBCFCPST da mesma forma que é calculado VBCST na geração do XML
            {Sandro Silva 2023-05-18 fim}

            if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
            begin
              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                oItem.VFCPST  := (oItem.Vbcst * fPercentualFCPST / 100) - oItem.VFCP; // Valor do FCP retido por Substituição Tributária
              end else
              begin
                oItem.VFCPST  := (oItem.Vbcst * fPercentualFCPST / 100); // Valor do FCP retido por Substituição Tributária
              end;
            end;

          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '20' then
        begin
          if fPercentualFCP <> 0 then
          begin
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
            oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
            begin
              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - (fFCPDescontar), 2); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
              end;
            end;
          end;
        end;

        if Copy(LimpaNumero(oItem.Cst_icms) + '000', 2, 2) = '51' then
        begin
          if fPercentualFCP <> 0 then
          begin
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
            oItem.VBCFCP   := oItem.Vbc; // Valor da Base de Cálculo do FCP
            oItem.VFCP     := Arredonda(oItem.Vbc * fPercentualFCP / 100, 2); // Valor do Fundo de Combate à Pobreza (FCP)
          end;

          if fPercentualFCPST <> 0 then
          begin
            oItem.VBCFCPST  := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

            if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
            begin
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
            if fPercentualFCPST <> 0 then
            begin
              oItem.VBCFCPST  := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

              if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
              begin
                if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
                begin
                  oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - fFCPDescontar, 2); // Valor do FCP retido por Substituição Tributária
                end else
                begin
                  oItem.VFCPST    := Arredonda((oItem.Vbcst * fPercentualFCPST / 100), 2); // Valor do FCP retido por Substituição Tributária
                end;
              end;
            end;
          end;

          if (oItem.Csosn = '202') or (oItem.Csosn = '203') then
          begin
            if fPercentualFCPST <> 0 then
            begin
              oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

              if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
              begin
                if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
                begin
                  oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - (fFCPDescontar), 2); // Valor do FCP retido por Substituição Tributária
                end else
                begin
                  oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
                end;
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
              if fPercentualFCPST <> 0 then
              begin
                oItem.VBCFCPST := oItem.Vbcst; // Valor da Base de Cálculo do FCP retido por Substituição Tributária

                if NFeFinalidadeDevolucao(NotaFiscal.Finnfe) = False then //F-7824 Sandro Silva 2024-01-17
                begin
                  if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'RJ') then
                  begin
                    oItem.VFCPST := Arredonda((oItem.Vbcst * fPercentualFCPST / 100) - fFCPDescontar, 2); // Valor do FCP retido por Substituição Tributária
                  end else
                  begin
                    oItem.VFCPST := Arredonda(oItem.Vbcst * fPercentualFCPST / 100, 2); // Valor do FCP retido por Substituição Tributária
                  end;
                end;
                
              end;
            except
              on E: Exception do
              begin
                //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900' + chr(10) + oItem.Descricao),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
                MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900' + chr(10) + oItem.Descricao,msgErro);
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.' + chr(10) + oItem.Descricao),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
            MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.' + chr(10) + oItem.Descricao,msgErro);
          end;
        end;
      end;

      // Final TAGS saída por CSOSN - CRT = 1 imples Nacional
    end;

  finally
    FreeAndNil(IBQProduto);
  end;
end;

procedure TNotaFiscalEletronicaCalc.CalculaPesoLiquido;
var
  i : integer;
  oItem : TITENS001;
  bTemItemComPeso: Boolean;
begin
  bTemItemComPeso := False;

  if not((NFeFinalidadeComplemento(NotaFiscal.Finnfe))) then
  begin
    for i := 0 to NotaFiscal.Itens.Count -1 do
    begin
      oItem := NotaFiscal.Itens.GetItem(i);

      if not bTemItemComPeso then
      begin
        bTemItemComPeso := (oItem.Peso > 0);
        if bTemItemComPeso then
          NotaFiscal.Pesoliqui := 0;
      end;

      if oItem.Quantidade <> 0 then
      begin
        // Sempre que tiver algum item com peso deve recalcular, caso não tenha não muda
        if bTemItemComPeso then
          NotaFiscal.Pesoliqui := NotaFiscal.Pesoliqui + oItem.Peso * oItem.Quantidade;
      end;
    end;
  end;
end;

procedure TNotaFiscalEletronicaCalc.SetRateioDescAcre;
var
  i : integer;
  oItem : TITENS001;
  fTotalMercadoria : Real;
begin
  fTotalMercadoria := GetTotalMercadoria;

  for i := 0 to NotaFiscal.Itens.Count -1 do
  begin
    oItem := NotaFiscal.Itens.GetItem(i);

    oItem.DescontoRateado := Arredonda((NotaFiscal.Desconto / fTotalMercadoria) * oItem.TOTAL,2);
    oItem.FreteRateado    := Arredonda((NotaFiscal.Frete / fTotalMercadoria) * oItem.TOTAL, 2);
    oItem.SeguroRateado   := Arredonda((NotaFiscal.Seguro / fTotalMercadoria) * oItem.TOTAL,2);
    oItem.DespesaRateado  := Arredonda((NotaFiscal.Despesas / fTotalMercadoria * oItem.TOTAL),2);
  end;
end;

function TNotaFiscalEletronicaCalc.RetornaObjetoNota(DataSetNF, DataSetItens: TibDataSet; CalcPesoLiq: Boolean): TVENDAS;
var
  sReg16 : string;
begin
  Result := nil;
  if not Calculando then
  begin
    try
      Calculando := True;
      sReg16 := DataSetItens.fieldByName('REGISTRO').AsString;

      AtualizaValoresNota(DataSetNF, DataSetItens);

      //Faz Rateios dos Desconos e Acrecimos dos itens
      SetRateioDescAcre;

      //Calcula Peso Líquido
      if CalcPesoLiq then
        CalculaPesoLiquido;

      Result := FNotaFiscal;
    finally
      Calculando := False;
    end;
  end;
end;

end.
